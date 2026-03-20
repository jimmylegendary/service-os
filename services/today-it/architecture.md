# Today It — Early Architecture Notes

## Canonical product loop

Capture -> Review/Accept -> Today -> Done / Snooze / Waiting -> Resurface

## MVP-visible states
- captured
- accepted_today
- done
- snoozed
- waiting

## Future-compatible states / modes
- incoming
- resurfaced
- delegated
- observing

These should not force MVP over-modeling.

## Core surfaces

### 1. Today
The primary trusted execution surface.
This is the product center.
Only items accepted for present execution belong here.

### 2. Capture / Inbox
Where raw or incoming items land before they become active today work.
This protects Today from backlog contamination.

### 3. Tomorrow / Day-after
Useful as a constrained preview, but should not become a wide future planner.
This is a lightweight preview only, not a planning workspace.

## Important rule
Dates may exist internally, but should not dominate the product experience.
Time metadata is secondary to present relevance.

For MVP, date handling should stay narrow:
- enough to support today / tomorrow / day-after preview
- enough to support snooze/resurface behavior
- not enough to turn the product into a scheduler-first system

## Future-compatible extension points
- assign to another human
- observer model
- MCP/API task ingress/egress
- AI-assisted triage / rewrite / compression
- location/context-aware relevance

## Architectural warning
Do not let data modeling pull the product back into scheduler-first thinking.
The visible product must stay today-first even if storage models include temporal metadata.
