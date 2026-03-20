# Today It — Service Overview

## One-line thesis
Today It helps users stop managing their whole life and start acting on the few things that genuinely matter today.

## What problem it solves
Traditional todo apps and schedulers often increase mental overhead by showing too much, storing too much, and making the user continuously manage backlog, dates, and categories.

Today It exists to reduce the cost of answering:
- what should I do now?
- what matters today?
- what should stay out of sight because it is not useful in the present?

## Product philosophy
Today It is not about planning the day.
It is about curating the smallest trustworthy execution surface for right now.

Core stance:
- capture is cheap
- acceptance is intentional
- visibility is earned

Today It is:
- today-first
- action-first
- cognitive-unload-first

Today It is not:
- a generic backlog manager
- a project management suite
- a calendar replacement
- a productivity dashboard for storing everything forever

## Current product hypothesis
If the system separates raw incoming/captured items from consciously accepted-today items, users will feel calmer and act more easily because they no longer need to continuously manage their whole backlog in working memory.

## Structural insight inherited from MissionAmongUs
The strongest reusable pattern is:
- incoming / captured items are separate from accepted-now items
- acceptance is a state change
- not everything visible is active

So Today It should preserve a distinction between:
- capture / inbox
- accepted into today's execution surface

See also: `missionamongus-analysis.md`

## Deferred future direction
Later, Today It may evolve toward a human-AI coordination layer where:
- humans assign tasks to AI
- AI assigns tasks to humans
- observers can follow work
- APIs / MCP can move tasks in and out of the system

This is intentionally deferred and should not justify MVP complexity.
