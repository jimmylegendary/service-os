# Today It — Early Architecture Notes

## Core state model

Potential high-level task states:
- captured
- incoming
- accepted_today
- done
- deferred
- resurfaced
- delegated
- observing
- waiting

Not all of these need to appear in the first UI, but the system should be designed so they can exist.

## Core surfaces

### 1. Today
The primary execution surface.
This is the product center.

### 2. Capture / Inbox
Where raw or incoming items land before they become active today work.

### 3. Tomorrow / Day-after
Useful as a constrained preview, but should not become a wide future planner.

## Important rule
Dates may exist internally, but should not dominate the product experience.
Time metadata is secondary to present relevance.

## Future-compatible extension points
- assign to another human
- observer model
- MCP/API task ingress/egress
- AI-assisted triage / rewrite / compression
- location/context-aware relevance

## Architectural warning
Do not let data modeling pull the product back into scheduler-first thinking.
The visible product must stay today-first even if storage models include temporal metadata.
