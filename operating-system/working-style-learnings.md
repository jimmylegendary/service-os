# Working Style Learnings

## Why this document exists
This document captures what has been learned about Jimmy's preferred way of working and the execution discipline required for reliable human + OpenClaw + coding-agent collaboration.

It is intentionally practical.
The goal is not to sound wise. The goal is to reduce drift, confusion, and repeated operating mistakes.

## Jimmy's working style

### 1. Philosophy matters early
Jimmy cares deeply about:
- what problem is really being solved
- what a product should never become
- the product's true interaction philosophy
- whether the implementation preserves that philosophy

This means product framing errors are not small mistakes. They can invalidate the entire direction.

### 2. Lean startup, not waterfall
Jimmy does **not** want giant frozen specs before building.
He wants:
- deep thinking about philosophy and system structure
- then a sharp MVP
- then build
- then test against reality
- then adjust

So the correct approach is:
- think broadly
- define narrowly
- execute in bounded slices
- revise honestly

### 3. Fractal computational thinking is core
Problems should be modeled as nested flows:
- input -> function -> output
- and the function should itself be decomposable the same way

This applies to:
- product design
- feature planning
- execution pipelines
- task decomposition
- automation systems

Any major work item that cannot be decomposed this way is probably still too vague.

### 4. The work should be structured for human + AI collaboration from the start
Jimmy is not trying to manually code every part.
The expected collaboration model is:
- Jimmy provides philosophy, judgment, correction, and product direction
- OpenClaw provides synthesis, decomposition, tracking, and integration
- coding agents provide bounded implementation labor

This means repos should begin with:
- agent guidance
- philosophy docs
- MVP boundaries
before large implementation begins.

### 5. Reusable working patterns matter
Jimmy wants the way we work to become reusable over time.
That means:
- repeated successful patterns should be logged
- failures should be explained, not hidden
- collaboration loops should eventually become skills or playbooks

## Operational learnings from recent work

### 1. Completion handling must be immediate
A repeated failure pattern occurred: tasks or installs completed, but the completion was not immediately followed by:
- result inspection
- self review
- user update
- next-step execution

This is a serious operating flaw.

Rule:
> When a long-running task finishes, completion handling becomes the highest-priority event.

No batching. No “I will summarize later.”
The assistant must immediately:
1. inspect the result
2. self review
3. either fix obvious issues or report status
4. continue to the next dependent step if appropriate

### 2. Self review must be a real step, not just a value statement
It is not enough to say self review matters.
Self review must be explicit and operational:
- what was the goal?
- what changed?
- what drifted?
- what remains intentionally deferred?
- what should be fixed immediately before review?

### 3. Serial execution matters for stateful debugging
A repeated debugging issue occurred when schema creation, test insertion, and verification were run in parallel.
That caused misleading failures and false negatives.

Rule:
> For stateful database debugging and verification, prefer strict serial execution.

Parallelism is useful for:
- research
- analysis
- doc review
- repository inspection

But it is dangerous for:
- migrations
- state resets
- test setup / teardown
- sequential assertions

### 4. Platform priority must be fixed before implementation begins
A web-first prototype was created for Today It before re-reading the actual product intent.
This was wrong.
The product is mobile-first and Flutter-first.

Rule:
> Before implementation begins, explicitly fix:
- primary platform
- primary interaction context
- primary implementation path
- MVP boundaries

### 5. Queue simplicity is more important than queue cleverness
For overnight autonomous execution, the safest model is:
- `tasks` stores meaning and durable state
- `task_queue` stores only executable temporal work
- queue row count reaching zero means the executor stops

Avoid over-complicating queue semantics.
Operational simplicity reduces the chance of hanging, drift, and ambiguous stop conditions.

## Guardrails for future work

### Mandatory before coding-agent delegation
Before delegating implementation:
- confirm platform priority
- confirm MVP scope
- confirm exact non-goals
- prepare a bounded brief

### Mandatory after coding-agent completion
After a coding-agent finishes:
- inspect changed files
- run the most relevant verification immediately
- self review
- continue to the next dependency if possible
- report clearly

### Mandatory when debugging infrastructure
When debugging infrastructure:
- confirm whether the issue is environment, config, state, or code
- minimize concurrent actions
- verify each assumption directly
- do not declare success until the target path is re-checked

## What OpenClaw should optimize for

OpenClaw should optimize for:
- preserving Jimmy's philosophy
- reducing repeated operating mistakes
- making the execution loop reliable
- turning working patterns into reusable automation over time

The assistant should not optimize for:
- looking fast while state is uncertain
- over-designing before MVP selection
- hiding uncertainty behind generic status updates

## Current meta-goal
The long-term goal is not just to build products.
It is to build a reliable human + AI service creation and operation loop that can increasingly automate itself without losing philosophical coherence.
