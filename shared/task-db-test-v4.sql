truncate table public.task_events, public.task_artifacts, public.task_dependencies, public.task_queue, public.tasks restart identity cascade;

insert into public.tasks (slug, title, description, task_type, priority, status, owner_type, owner_id, mvp_phase, goal, current_brief)
values
('a-ready-task', 'A ready task', 'Should enter queue immediately', 'design', 'high', 'ready', 'openclaw', 'main', 'foundation', 'Test queue admission', 'Do ready task'),
('b-blocker-task', 'B blocker task', 'Blocks child', 'design', 'critical', 'ready', 'openclaw', 'main', 'foundation', 'Blocker task', 'Finish blocker first'),
('c-child-task', 'C child task', 'Should not be queueable yet', 'implementation', 'normal', 'ready', 'coding_agent', 'claude', 'mvp', 'Child task', 'Wait for blocker');

insert into public.task_dependencies (task_id, depends_on_task_id, dependency_type)
select child.id, parent.id, 'blocks'
from public.tasks child
join public.tasks parent on parent.slug = 'b-blocker-task'
where child.slug = 'c-child-task';

select public.sync_task_queue((select id from public.tasks where slug = 'c-child-task'));

-- ASSERT 1: initial queue row count = 2
select count(*) as queue_rows_initial from public.task_queue;

-- lease blocker
select * from public.lease_next_task('openclaw-main', 30);

-- ASSERT 2: queue row count still 2 (1 leased + 1 queued)
select count(*) as queue_rows_after_lease1 from public.task_queue;

-- complete blocker; child should join queue, blocker should disappear from queue
select public.complete_task((select id from public.tasks where slug = 'b-blocker-task'), 'openclaw-main', 'Completed blocker');

-- ASSERT 3: queue row count still 2 (a-ready-task + c-child-task)
select count(*) as queue_rows_after_complete1 from public.task_queue;

-- complete ready task directly from queueable state
select public.complete_task((select id from public.tasks where slug = 'a-ready-task'), 'openclaw-main', 'Completed ready task');

-- ASSERT 4: queue row count now 1 (only child left)
select count(*) as queue_rows_after_complete2 from public.task_queue;

-- lease child and complete it
select * from public.lease_next_task('openclaw-main', 30);
select public.complete_task((select id from public.tasks where slug = 'c-child-task'), 'openclaw-main', 'Completed child task');

-- ASSERT 5: queue empty = executor stop condition
select count(*) as queue_rows_final from public.task_queue;

select slug, status from public.tasks order by slug;
select event_type, actor_id, summary from public.task_events order by created_at;
