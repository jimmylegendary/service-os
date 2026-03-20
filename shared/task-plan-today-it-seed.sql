-- Today It operational task graph seed

insert into public.tasks (
  slug, title, description, task_type, priority, status, owner_type, owner_id,
  mvp_phase, goal, acceptance_criteria, non_goals, current_brief
) values
(
  'review-current-flutter-slice',
  'Review current Flutter slice',
  'Review the existing Today It Flutter slice for product alignment, drift, and implementation quality.',
  'review',
  'critical',
  'ready',
  'openclaw',
  'main',
  'foundation',
  'Establish the real current state before planning the next slice.',
  '["current slice reviewed", "issues listed", "next-step decision possible"]'::jsonb,
  '["no new implementation", "no broad redesign"]'::jsonb,
  'Inspect current Flutter code, compare against philosophy and MVP, record findings.'
),
(
  'debug-android-build-path',
  'Debug Android build path',
  'Ensure the Android build/run path is stable enough for continued mobile-first development.',
  'debugging',
  'high',
  'ready',
  'openclaw',
  'main',
  'foundation',
  'Remove Android environment/build blockers from the immediate workflow.',
  '["build path reviewed", "blockers identified or fixed", "next Android step clear"]'::jsonb,
  '["no feature expansion", "no product redesign"]'::jsonb,
  'Check build pipeline, confirm environment, identify remaining blockers.'
),
(
  'review-doc-implementation-alignment',
  'Review doc/implementation alignment',
  'Compare service-os / today-it docs against the current Flutter implementation direction.',
  'review',
  'high',
  'ready',
  'openclaw',
  'main',
  'foundation',
  'Prevent drift between philosophy docs and implementation repo.',
  '["alignment reviewed", "mismatches listed", "follow-up tasks obvious"]'::jsonb,
  '["no feature coding", "no stack changes"]'::jsonb,
  'Review docs vs repo state and note mismatches.'
),
(
  'refine-screen-model-v1',
  'Refine screen model v1',
  'Tighten the mobile screen model for Today / Capture / Ahead based on current review.',
  'design',
  'high',
  'queued',
  'openclaw',
  'main',
  'foundation',
  'Make the mobile screen structure concrete enough for the next implementation brief.',
  '["screen model updated", "mobile-first preserved", "MVP scope respected"]'::jsonb,
  '["no backend work", "no new collaboration layer"]'::jsonb,
  'Use review findings to sharpen the mobile screen model.'
),
(
  'refine-object-model-v1',
  'Refine object model v1',
  'Tighten the minimal item/state model for the next Flutter slice.',
  'design',
  'high',
  'queued',
  'openclaw',
  'main',
  'foundation',
  'Clarify the minimal task/item semantics without over-modeling.',
  '["object model updated", "state semantics clarified", "MVP preserved"]'::jsonb,
  '["no recurrence engine", "no team schema"]'::jsonb,
  'Use review findings to refine object and state definitions.'
),
(
  'write-implementation-brief-002',
  'Write implementation brief 002',
  'Prepare the next bounded coding-agent brief after review and model refinement.',
  'implementation',
  'normal',
  'queued',
  'openclaw',
  'main',
  'mvp',
  'Enable a controlled next implementation slice.',
  '["brief written", "scope bounded", "acceptance clear", "non-goals explicit"]'::jsonb,
  '["no implementation yet", "no broad roadmap rewrite"]'::jsonb,
  'Write the next coding-agent brief after review and model updates.'
),
(
  'execute-flutter-slice-002',
  'Execute Flutter slice 002',
  'Implement the next bounded Flutter slice using the approved brief.',
  'implementation',
  'normal',
  'queued',
  'coding_agent',
  'claude',
  'mvp',
  'Advance the product by one tightly scoped mobile slice.',
  '["brief implemented", "verification run", "changes summarized"]'::jsonb,
  '["no unbounded feature growth", "no architecture rewrite"]'::jsonb,
  'Run coding agent on the approved Flutter brief.'
),
(
  'review-flutter-slice-002',
  'Review Flutter slice 002',
  'Review the coding-agent output for product alignment and technical quality.',
  'review',
  'high',
  'queued',
  'openclaw',
  'main',
  'mvp',
  'Decide whether slice 002 passes or needs follow-up bugfix tasks.',
  '["review completed", "pass/fail decided", "issues captured if any"]'::jsonb,
  '["no new implementation during review"]'::jsonb,
  'Inspect Flutter slice 002 results and decide next branch.'
)
on conflict (slug) do nothing;

insert into public.task_dependencies (task_id, depends_on_task_id, dependency_type)
select child.id, parent.id, 'blocks'
from public.tasks child
join public.tasks parent on parent.slug = 'review-current-flutter-slice'
where child.slug in ('refine-screen-model-v1','refine-object-model-v1')
on conflict do nothing;

insert into public.task_dependencies (task_id, depends_on_task_id, dependency_type)
select child.id, parent.id, 'blocks'
from public.tasks child
join public.tasks parent on parent.slug in ('refine-screen-model-v1','refine-object-model-v1')
where child.slug = 'write-implementation-brief-002'
on conflict do nothing;

insert into public.task_dependencies (task_id, depends_on_task_id, dependency_type)
select child.id, parent.id, 'blocks'
from public.tasks child
join public.tasks parent on parent.slug = 'write-implementation-brief-002'
where child.slug = 'execute-flutter-slice-002'
on conflict do nothing;

insert into public.task_dependencies (task_id, depends_on_task_id, dependency_type)
select child.id, parent.id, 'blocks'
from public.tasks child
join public.tasks parent on parent.slug = 'execute-flutter-slice-002'
where child.slug = 'review-flutter-slice-002'
on conflict do nothing;

insert into public.task_events (task_id, event_type, actor_type, actor_id, summary)
select id, 'created', 'system', 'seed', 'Seeded Today It operational task.'
from public.tasks
where not exists (
  select 1 from public.task_events e where e.task_id = tasks.id and e.event_type = 'created'
);

-- force queue synchronization for all seeded tasks
select public.sync_task_queue(id) from public.tasks;
