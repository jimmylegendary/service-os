# WORKFLOW.md

## Collaboration model

The default build loop is:

Jimmy direction
-> OpenClaw synthesis and decomposition
-> bounded work packet
-> coding-agent implementation
-> OpenClaw self review and integration
-> Jimmy judgment and correction
-> recorded learning

## Roles

### Jimmy
Provides:
- philosophy
- direction
- product judgment
- engineering judgment when needed
- final approval

### OpenClaw
Provides:
- synthesis
- planning
- decomposition
- memory/logging
- work packet generation
- alignment protection

### coding-agent
Provides:
- implementation labor
- code iteration
- refactoring
- tests / technical proposals in bounded scopes

## Standard work packet

Every bounded implementation task should include:
- objective
- why this matters
- relevant documents
- exact scope
- acceptance criteria
- explicit exclusions
- expected outputs/artifacts

## Execution cadence

### Strategy layer
- identify philosophy
- identify core problem
- identify MVP
- identify roadmap axes

### Implementation layer
- define one bounded build step
- assign to coding agent
- perform self review
- decide keep / revise / discard

### Learning layer
- capture hypothesis tested
- capture what worked
- capture what drifted
- capture what pattern is reusable
- promote reusable work patterns toward future skills

## Self review format

Use `templates/self-review.md`.
Minimum review questions:
- What was the objective?
- What changed?
- What philosophy risk exists?
- What MVP boundary risk exists?
- What feels overbuilt?
- What is unresolved but intentionally deferred?

## Escalation rules

Ask Jimmy when:
- philosophy is ambiguous
- two options have different long-term product implications
- cost / account / payment / deployment access is required
- legal / platform policy risk is material

Do not ask Jimmy when:
- a bounded technical detail can be tested directly
- a draft can be created and then reviewed later
- multiple options can be narrowed first by concrete comparison
