create extension if not exists pgcrypto;

create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  slug text unique,
  title text not null,
  description text,
  task_type text not null check (task_type in ('research','decision','design','implementation','review','setup','deploy','meta')),
  priority text not null default 'normal' check (priority in ('low','normal','high','critical')),
  status text not null default 'queued' check (status in ('queued','ready','in_progress','self_review','blocked','needs_human_input','waiting_external','done','cancelled','archived')),
  owner_type text not null check (owner_type in ('openclaw','coding_agent','human','automation')),
  owner_id text,
  parent_task_id uuid references public.tasks(id) on delete set null,
  mvp_phase text check (mvp_phase in ('foundation','mvp','post_mvp','future')),
  review_needed boolean not null default true,
  goal text,
  acceptance_criteria jsonb not null default '[]'::jsonb,
  non_goals jsonb not null default '[]'::jsonb,
  current_brief text,
  self_review_summary text,
  blocker_summary text,
  started_at timestamptz,
  completed_at timestamptz,
  due_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.task_events (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  event_type text not null check (event_type in ('created','status_changed','brief_updated','agent_started','agent_finished','self_review_passed','self_review_failed','human_feedback_requested','human_feedback_received','blocked','unblocked','artifact_added','queued','leased','dequeued','note')),
  actor_type text not null check (actor_type in ('openclaw','coding_agent','human','system','automation')),
  actor_id text,
  old_status text,
  new_status text,
  summary text,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table public.task_artifacts (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  artifact_type text not null check (artifact_type in ('file','repo_commit','github_pr','github_issue','url','screenshot','note')),
  label text not null,
  location text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table public.task_dependencies (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  depends_on_task_id uuid not null references public.tasks(id) on delete cascade,
  dependency_type text not null default 'blocks' check (dependency_type in ('blocks','relates_to','spawned_from')),
  created_at timestamptz not null default now(),
  unique(task_id, depends_on_task_id, dependency_type)
);

create table public.task_queue (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  status text not null default 'queued' check (status in ('queued','leased')),
  priority_score numeric not null default 0,
  leased_by text,
  leased_at timestamptz,
  lease_expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(task_id)
);

create index idx_tasks_status_priority_created_at on public.tasks(status, priority, created_at);
create index idx_tasks_owner_type_status on public.tasks(owner_type, status);
create index idx_tasks_parent_task_id on public.tasks(parent_task_id);
create index idx_task_events_task_id_created_at on public.task_events(task_id, created_at desc);
create index idx_task_artifacts_task_id on public.task_artifacts(task_id);
create index idx_task_dependencies_task_id on public.task_dependencies(task_id);
create index idx_task_dependencies_depends_on_task_id on public.task_dependencies(depends_on_task_id);
create index idx_task_queue_status_priority_created_at on public.task_queue(status, priority_score desc, created_at);

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_tasks_updated_at before update on public.tasks for each row execute function public.set_updated_at();
create trigger trg_task_queue_updated_at before update on public.task_queue for each row execute function public.set_updated_at();

create or replace function public.task_priority_score(p_priority text)
returns numeric language sql immutable as $$
  select case p_priority when 'critical' then 400 when 'high' then 300 when 'normal' then 200 else 100 end;
$$;

create or replace function public.task_is_queueable(p_task_id uuid)
returns boolean as $$
declare
  t public.tasks;
  dep_count int;
begin
  select * into t from public.tasks where id = p_task_id;
  if not found then return false; end if;
  if t.status not in ('queued','ready') then return false; end if;
  if t.owner_type not in ('openclaw','coding_agent','automation') then return false; end if;
  if t.due_at is not null and t.due_at > now() then return false; end if;

  select count(*) into dep_count
  from public.task_dependencies d
  join public.tasks t2 on t2.id = d.depends_on_task_id
  where d.task_id = p_task_id
    and d.dependency_type = 'blocks'
    and t2.status <> 'done';

  return dep_count = 0;
end;
$$ language plpgsql;

create or replace function public.sync_task_queue(p_task_id uuid)
returns void as $$
declare
  t public.tasks;
  v_queueable boolean;
  v_has_queue boolean;
  v_queue_status text;
begin
  select * into t from public.tasks where id = p_task_id;
  if not found then return; end if;

  v_queueable := public.task_is_queueable(p_task_id);
  select exists(select 1 from public.task_queue where task_id = p_task_id) into v_has_queue;
  select status into v_queue_status from public.task_queue where task_id = p_task_id;

  if not v_has_queue and v_queueable then
    insert into public.task_queue (task_id, status, priority_score)
    values (p_task_id, 'queued', public.task_priority_score(t.priority));
    insert into public.task_events (task_id, event_type, actor_type, actor_id, summary)
    values (p_task_id, 'queued', 'system', 'queue', 'Task entered execution queue');
    return;
  end if;

  if v_has_queue and v_queue_status = 'leased' then
    return;
  end if;

  if v_has_queue and not v_queueable then
    delete from public.task_queue where task_id = p_task_id and status = 'queued';
    insert into public.task_events (task_id, event_type, actor_type, actor_id, summary)
    values (p_task_id, 'dequeued', 'system', 'queue', 'Task removed from execution queue');
    return;
  end if;

  if v_has_queue and v_queueable and v_queue_status = 'queued' then
    update public.task_queue
    set priority_score = public.task_priority_score(t.priority), updated_at = now()
    where task_id = p_task_id;
    return;
  end if;
end;
$$ language plpgsql;

create or replace function public.lease_next_task(p_claimer text, p_lease_minutes int default 30)
returns table(queue_id uuid, task_id uuid, slug text, title text, priority text, task_status text, owner_type text, current_brief text) as $$
declare
  v_queue_id uuid;
  v_task_id uuid;
begin
  select q.id, q.task_id into v_queue_id, v_task_id
  from public.task_queue q
  join public.tasks t on t.id = q.task_id
  where q.status = 'queued'
  order by q.priority_score desc, q.created_at asc
  limit 1
  for update skip locked;

  if v_queue_id is null then return; end if;

  update public.task_queue
  set status = 'leased', leased_by = p_claimer, leased_at = now(), lease_expires_at = now() + make_interval(mins => p_lease_minutes), updated_at = now()
  where id = v_queue_id;

  update public.tasks
  set status = 'in_progress', started_at = coalesce(started_at, now()), updated_at = now()
  where id = v_task_id;

  insert into public.task_events (task_id, event_type, actor_type, actor_id, old_status, new_status, summary)
  values (v_task_id, 'leased', 'system', p_claimer, 'queued', 'in_progress', 'Task leased');

  return query
  select q.id, t.id, t.slug, t.title, t.priority, t.status, t.owner_type, t.current_brief
  from public.task_queue q join public.tasks t on t.id = q.task_id
  where q.id = v_queue_id;
end;
$$ language plpgsql;

create or replace function public.complete_task(p_task_id uuid, p_actor text, p_summary text default null)
returns void as $$
begin
  delete from public.task_queue where task_id = p_task_id;

  update public.tasks
  set status = 'done', completed_at = now(), updated_at = now()
  where id = p_task_id;

  insert into public.task_events (task_id, event_type, actor_type, actor_id, old_status, new_status, summary)
  values (p_task_id, 'dequeued', 'system', p_actor, 'leased', 'done', 'Task removed from queue on completion');

  insert into public.task_events (task_id, event_type, actor_type, actor_id, old_status, new_status, summary)
  values (p_task_id, 'agent_finished', 'system', p_actor, 'in_progress', 'done', coalesce(p_summary, 'Task completed'));

  perform public.sync_task_queue(d.task_id)
  from public.task_dependencies d
  where d.depends_on_task_id = p_task_id and d.dependency_type = 'blocks';
end;
$$ language plpgsql;

create or replace function public.on_tasks_sync_queue_trigger()
returns trigger as $$
begin
  perform public.sync_task_queue(new.id);
  return new;
end;
$$ language plpgsql;

create trigger trg_tasks_sync_queue
after insert or update of status, owner_type, due_at, priority on public.tasks
for each row execute function public.on_tasks_sync_queue_trigger();
