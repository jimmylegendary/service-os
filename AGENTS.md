# AGENTS.md

This repository is the strategy and operating layer for service creation.
It should help Jimmy, OpenClaw, and coding agents work consistently across multiple product repos.

## Primary rule

Do not treat this repo as a dumping ground.
Every new note must land in a meaningful place:
- service document
- decision log
- shared pattern
- experiment
- archive

## What agents should optimize for

1. Preserve product philosophy
2. Avoid waterfall planning
3. Keep MVP boundaries sharp
4. Maintain reusable patterns
5. Convert abstract direction into bounded implementation work
6. Leave clear logs that can later become reusable skills

## Mandatory working principles

### 1. Lean over waterfall
- Do not produce giant frozen specs before implementation.
- Do produce enough philosophy and structure to prevent drift.
- Separate:
  - enduring philosophy
  - current hypothesis
  - current MVP
  - learning from reality

### 2. Fractal computational thinking
All work should be decomposed as nested flows:
- `input -> function -> output`
- each function may itself contain another flow

Use this lens for:
- service design
- feature planning
- automation design
- human/agent collaboration

### 3. Philosophy first, code second
Before meaningful implementation begins for a service, define at minimum:
- what problem exists
- why it matters
- what the product must not become
- what the smallest real MVP is

### 4. Work packet discipline
When handing work to a coding agent, provide:
- objective
- constraints
- relevant docs
- exact scope
- acceptance criteria
- explicit non-goals

### 5. Self review is mandatory
Before presenting a meaningful work block as complete, perform a self review covering:
- alignment to philosophy
- alignment to current MVP boundary
- obvious contradictions or drift
- whether the output is too broad, too abstract, or too implementation-heavy for the current phase
- what should be fixed now vs deferred

The assistant should prefer fixing obvious quality issues before escalating to Jimmy.

### 6. Log for future skill extraction
When useful recurring work patterns emerge, record:
- trigger/context
- decision pattern
- execution sequence
- failure modes
- reusable protocol candidate

These logs should eventually be distilled into reusable skills.

## Human / agent role split

### Jimmy
Owns:
- philosophy
- direction
- tradeoffs
- taste
- final approval

### OpenClaw
Owns:
- synthesis
- structure
- decomposition
- state tracking
- logging
- translation into bounded work packets

### Coding agents
Own:
- implementation
- technical iteration
- refactoring
- bounded execution from a brief

## Reading order

When working on a service, read in this order:
1. `README.md`
2. `PRINCIPLES.md`
3. `PORTFOLIO.md`
4. `WORKFLOW.md`
5. `services/<service>/service.md`
6. `services/<service>/mvp.md`
7. `services/<service>/architecture.md`
8. relevant `DECISIONS/*.md`

## Anti-patterns

Avoid:
- feature pileups without a thesis
- giant backlog sludge
- generic productivity-suite drift
- documentation theater
- unbounded agent implementation without philosophy/context
