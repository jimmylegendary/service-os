-- Seed a minimal task graph for polling executor validation
insert into public.tasks (slug, title, description, task_type, priority, status, owner_type, owner_id, mvp_phase, goal, current_brief)
values
('poll-test-root-review', 'Poll test root review', 'First task to be picked by poller', 'review', 'critical', 'ready', 'openclaw', 'main', 'foundation', 'Validate poller execution', 'Root task for polling test'),
('poll-test-child-design', 'Poll test child design', 'Should be unblocked after root completion', 'design', 'high', 'ready', 'openclaw', 'main', 'foundation', 'Validate dependency unblocking', 'Child task for polling test');

insert into public.task_dependencies (task_id, depends_on_task_id, dependency_type)
select child.id, parent.id, 'blocks'
from public.tasks child
join public.tasks parent on parent.slug = 'poll-test-root-review'
where child.slug = 'poll-test-child-design';

select public.sync_task_queue(id) from public.tasks;
