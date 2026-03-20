# service-os

A central strategy and operating repository for Jimmy's services.

This is not a code monorepo.
This repo exists to keep **ideas, philosophy, architecture, MVP boundaries, decisions, and agent collaboration rules** in one place so implementation repos can stay aligned.

## Purpose

Use this repository to:
- preserve product philosophy before code drifts it away
- manage multiple service ideas in one structured place
- define MVP boundaries without falling into waterfall planning
- capture reusable product/architecture patterns across services
- document how Jimmy, OpenClaw, and coding agents collaborate
- log decisions and experiments so the system gets smarter over time

## Current focus

Primary service in focus:
- **Today It**

Other tracked services:
- Study It
- AI workflow as API service
- future services and automation systems

## Working model

This repo should support a repeating loop:

1. clarify product philosophy
2. define the smallest meaningful MVP
3. break the work into fractal flows
4. hand bounded work to coding agents
5. perform self review before asking Jimmy to review
6. review output with Jimmy
7. log what was learned
8. update direction, not just code

## Reading order for agents

1. `README.md`
2. `AGENTS.md`
3. `PRINCIPLES.md`
4. `PORTFOLIO.md`
5. `WORKFLOW.md`
6. relevant files under `services/<service>/`
7. relevant files under `DECISIONS/`

## Document contract

- `PRINCIPLES.md` = enduring truths and product/build philosophy
- `PORTFOLIO.md` = portfolio state, strategic ordering, and why-now logic
- `WORKFLOW.md` = repo operating loop, handoff protocol, and self-review loop
- `operating-system/*.md` = reusable conceptual methods
- `services/<name>/service.md` = service thesis, anti-thesis, and current product hypothesis
- `services/<name>/mvp.md` = current narrow build boundary and validation target
- `services/<name>/architecture.md` = structural model, not a feature wishlist
- `DECISIONS/` = durable decisions with consequences
- `experiments/` = hypothesis tests and learning records
- `templates/` = reusable scaffolds for repeatable execution

## Top-level structure

- `AGENTS.md` — agent operating rules for this repo
- `PRINCIPLES.md` — product and build philosophy
- `PORTFOLIO.md` — all tracked services and their status
- `WORKFLOW.md` — Jimmy/OpenClaw/coding-agent collaboration model
- `DECISIONS/` — architecture and product decisions
- `services/` — per-service strategy packets
- `shared/` — patterns used across services
- `architecture/` — system-level structures and maps
- `experiments/` — test ideas not yet promoted into full services
- `templates/` — reusable scaffolds
- `operating-system/` — how the whole machine works
- `archive/` — retired ideas and superseded docs

## Rule of thumb

Think broadly, build narrowly.
Preserve philosophy, but ship lean.
Every large problem should be decomposed as nested flows.
