# MissionAmongUs Analysis for Today It

## Why this document exists
MissionAmongUs is not being treated as a codebase to port.
It is being treated as a prior product experiment whose useful structural ideas should be extracted and reinterpreted for Today It.

## High-level conclusion
The most valuable reusable concept from MissionAmongUs is:

> incoming items and accepted-now items should be separate,
> and acceptance should be an intentional state change.

Everything else is secondary.

## What MissionAmongUs appears to have been
A prototype Flutter app centered around:
- creating a mission
- sending it to someone else
- letting it arrive in an inbox
- letting the receiver accept it into a personal board

This makes it socially flavored and mission-oriented, but the useful kernel is not the social wrapper — it is the **inbox to accepted execution surface transition**.

## Concepts worth inheriting

### 1. Inbox -> Board transition
This maps strongly to Today It:
- capture / inbox / incoming
- consciously accepted into today

Not everything seen should become active.
The user should actively accept what belongs on the trusted execution surface.

### 2. Acceptance as a meaningful act
The product should distinguish:
- seen
- captured
- incoming
- accepted for today

This supports Today It's philosophy that visibility should be earned and present execution should be intentional.

### 3. Tasks can originate from self or others
MissionAmongUs contained a useful `from -> to` model.
This can later evolve into:
- delegation
- requests
- accountability
- observer relationships

This should be treated as a future-compatible axis, not necessarily a broad MVP collaboration system.

### 4. Compact card-based execution surface
The card list metaphor is useful for a today-first action system.
It reinforces action rather than archive management.

## Concepts to discard or heavily de-emphasize

### 1. Mission framing
The word "mission" creates a social/game/challenge tone that is not right for Today It.
Today It should feel clearer, calmer, and more direct.

### 2. Early heavy schedule framing
MissionAmongUs used start/end/repeat ideas too early.
For Today It this would risk dragging the product back into scheduler-first logic.

### 3. Friends / feed / social-first structure
Social graph and feed concepts are not central to Today It MVP.
They are likely distractions at the current stage.

### 4. Over-ceremonial creation flow
A tabbed create flow is too heavy for a product whose purpose is reducing cognitive friction.
Today It should prefer:
- fast capture first
- clarification later

## Translation into Today It

MissionAmongUs structure:
- Inbox
- Mission Board
- Create Mission
- Friends / Social

Today It translation:
- Capture / Inbox
- Today
- Clarify / Commit
- later: Delegated / Shared / Waiting

## Design implication
Today It should not inherit MissionAmongUs implementation patterns.
It should inherit only the strongest structural insight:

> separate incoming work from accepted present work.

That idea is strong enough to become part of Today It's core product loop.
