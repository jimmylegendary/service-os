# Today It — MVP

## MVP goal
Prove that the product can help a user arrive at a calmer, smaller, more actionable “today” than they would create alone.

## MVP scope
This is a single-user-first, mobile-first MVP.
The first implementation target is Flutter.

## Must include

1. **Today surface**
   - a primary view that shows only what is actionable today

2. **Fast capture**
   - quick way to unload thoughts, tasks, commitments, and requests

3. **Today vs not-today separation**
   - the system must protect the Today view from backlog contamination

4. **Acceptance as state change**
   - captured / incoming items are not automatically active
   - users consciously move items into active today execution

5. **Completion / snooze / waiting / re-surface loop**
   - `done` means complete and removed from active surface
   - `snooze` means hidden until the next narrow reappearance moment
   - `waiting` means blocked by someone/something else and not treated as active now-work
   - unfinished work should not silently disappear
   - it should be intentionally re-surfaced later

6. **No broad exchange model in MVP**
   - assign / observer should be treated as future-compatible direction, not a mandatory MVP requirement

## Should exclude from MVP

- project management complexity
- advanced scheduling and calendar behaviors
- social feed mechanics
- heavy permissions / workspace complexity
- rich customization systems
- broad autonomous AI behavior
- overbuilt recurrence and planning tools
- tags as an organization system
- priority matrices
- calendar grid views
- team workspace model

## MVP validation questions

- Does the Today view actually reduce mental clutter?
- Do users feel clearer about what to do now?
- Does the inbox/capture to today transition feel meaningful?
- Do unfinished items feel managed without creating guilt or list anxiety?
- Is the product clearly different from a generic todo app?

## Current hypothesis under test
If users can keep capture/incoming separate from consciously accepted-today work, they will feel less overwhelmed and trust the Today surface more than a conventional backlog-driven todo app.
d and trust the Today surface more than a conventional backlog-driven todo app.
