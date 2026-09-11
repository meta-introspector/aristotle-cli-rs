import RequestProject.Tracker

/-!
# Worked examples

Small executable checks that exercise the model the way the TypeScript service
is exercised by hand: a fresh detection, a duplicate from a second source, a
stale replay, a push skeleton upgraded by hydration, and a non-local request.

These are `#eval`s, not proofs — the proofs live in the other modules — but
they make the model's behaviour easy to inspect.
-/

namespace Tracker.Examples

open Tracker

/-- A minimal configuration: caps small enough to watch eviction happen. -/
def cfg : Config :=
  { seenMax := 4, maxAgeMs := 300000, detectWindow := 3, recentMax := 3 }

def watch : List Watched := [{ handle := "alice", userId := some "1" }]

def s0 : State := { cfg := cfg, watch := watch }

/-- A fresh post from the merged-timeline detector, seen 900 ms after it was
published. -/
def fresh (id : String) (createdAt now : Nat) : Tweet where
  id := id
  author := { userId := some "1", handle := "alice", name := "Alice" }
  createdAt := createdAt
  seenAt := now
  detectMs := now - createdAt
  source := IngestSource.feed

-- One detection: one card on the wire, one latency sample.
#eval (emit 1_000_900 s0 (fresh "100" 1_000_000 1_000_900) IngestSource.feed).log.length -- 1
#eval (emit 1_000_900 s0 (fresh "100" 1_000_000 1_000_900) IngestSource.feed).detect      -- [900]

-- The same post from a second source publishes nothing more.
#eval
  (emit 1_001_100
      (emit 1_000_900 s0 (fresh "100" 1_000_000 1_000_900) IngestSource.feed)
      (fresh "100" 1_000_000 1_001_100) IngestSource.poll).log.length -- 1

-- A backlog replay six minutes old is dropped and counted, not published.
#eval (emit 1_360_000 s0 (fresh "101" 1_000_000 1_360_000) IngestSource.poll).log.length   -- 0
#eval (emit 1_360_000 s0 (fresh "101" 1_000_000 1_360_000) IngestSource.poll).staleDrops   -- 1
-- … and it is still marked seen, so the poller cannot pick it up again.
#eval (emit 1_360_000 s0 (fresh "101" 1_000_000 1_360_000) IngestSource.poll).seen.ids     -- ["101"]

/-- A push notification whose snowflake says the post is 120 ms old. -/
def trig : PushTrigger :=
  { tweetId := "200", handle := "alice", title := "Alice", body := "…", born := some 2_000_000 }

def acct : Watched := { handle := "alice", userId := some "1" }

-- The skeleton ships immediately with the snowflake latency, but as a partial
-- body it contributes no sample to the percentiles.
#eval (pushSkeleton 2_000_120 trig acct (some "1")).detectMs        -- 120
#eval measurable (pushSkeleton 2_000_120 trig acct (some "1"))      -- false

/-- What syndication returns for a repost: the ORIGINAL post, under a different
id and with a two-day-old publish time. -/
def original : Tweet where
  id := "199"
  author := { userId := some "9", handle := "bob", name := "Bob" }
  createdAt := 1_827_200_000 % 2_000_000  -- an old timestamp
  seenAt := 2_000_120
  detectMs := 0
  source := IngestSource.push

-- The hydrated frame keeps the wrapper id and the wrapper's publish time,
-- so the days-old original cannot enter the latency figures.
#eval (hydratedBody "200" (pushSkeleton 2_000_120 trig acct (some "1")) original
        trig.born 2_000_120 acct.tier).body.id          -- "200"
#eval (hydratedBody "200" (pushSkeleton 2_000_120 trig acct (some "1")) original
        trig.born 2_000_120 acct.tier).realDetect        -- 120

-- Percentiles of a window are observed samples, ordered in `p`.
#eval (pct [120, 900, 30, 4000] 50, pct [120, 900, 30, 4000] 90, pct [120, 900, 30, 4000] 99)

/-- A request that arrives with a non-loopback `Host`. -/
def remoteRequest : Request :=
  { method := Method.post, path := "/api/tracker/run", host := "tracker.example.com"
    contentType := some "application/json", body := Body.run true }

#eval (handle 0 { tracker := s0, bus := { bootId := "boot" } } remoteRequest "id").2 -- 403

/-! ## The polling plan

The spacing each published quota implies, and the plan the tracker runs with
20% headroom (`planPeriod`), including per-account refresh under round robin
(`planRefresh`). -/

open Tracker.Endpoint

-- `⌈window / quota⌉` for recent search (app), a user timeline (user token) and
-- the home timeline (user token), in milliseconds.
#eval (searchRecentApp.minPeriod, userTweetsUser.minPeriod, homeTimelineUser.minPeriod)
-- (2000, 1000, 5000)

-- The same three with 20% headroom reserved.
#eval (planPeriod searchRecentApp 80, planPeriod userTweetsUser 80, planPeriod homeTimelineUser 80)
-- (2500, 1250, 6250)

-- Watching 1, 5, 10 and 25 accounts round-robin on their user timelines: the
-- refresh period each account gets.
#eval (planRefresh userTweetsUser 80 1, planRefresh userTweetsUser 80 5,
  planRefresh userTweetsUser 80 10, planRefresh userTweetsUser 80 25)
-- (1250, 6250, 12500, 31250)

-- A governor that has spent its budget holds the next request until the reset …
#eval (Governor.step { limit := 450, windowMs := 900000, used := 450, resetAt := 900000 } 500000).2
-- false
-- … and issues it once the window has rolled over.
#eval (Governor.step { limit := 450, windowMs := 900000, used := 450, resetAt := 900000 } 900000).2
-- true

-- A 429 seen at t = 500 000 with `x-rate-limit-reset` at 900 000: wait 400 s.
#eval backoffWaitMs 500000 900000 -- 400000
-- A 429 whose reset is already imminent still waits the 60 s floor.
#eval backoffWaitMs 890000 900000 -- 60000

end Tracker.Examples
