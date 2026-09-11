import RequestProject.Tracker.Types
import RequestProject.Tracker.Dedupe
import RequestProject.Tracker.Timing
import RequestProject.Tracker.Emit
import RequestProject.Tracker.Push
import RequestProject.Tracker.Provider
import RequestProject.Tracker.Bus
import RequestProject.Tracker.Server
import RequestProject.Tracker.RateLimit

/-!
# A Lean 4 model of the Twitter tracker

This module gathers the whole model:

* `RequestProject.Tracker.Types`    — the shared post/event contract (`types.ts`)
* `RequestProject.Tracker.Dedupe`   — the bounded FIFO dedupe set (`service.ts`)
* `RequestProject.Tracker.Timing`   — latency, staleness, rolling window, percentiles
* `RequestProject.Tracker.Emit`     — `emitTweet`, the hot path, and its invariants
* `RequestProject.Tracker.Push`     — trigger → skeleton → hydrated body
* `RequestProject.Tracker.Provider` — provider product updates, age allowances, recent ring
* `RequestProject.Tracker.Bus`      — the event bus and its resumable replay ring
* `RequestProject.Tracker.Server`   — the local HTTP surface and its safety envelope
* `RequestProject.Tracker.RateLimit` — the X API v2 quotas, the optimal polling
  plan, the `x-rate-limit-*` governor and 429 backoff

`docs/MODEL.md` maps each TypeScript function to its Lean counterpart and lists
the properties proved about it; `docs/POLLING_PLAN.md` states the polling plan
and points at the theorem justifying each line of it.
-/
