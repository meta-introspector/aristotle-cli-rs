import Mathlib.Tactic
import RequestProject.Tracker.Timing
import RequestProject.Tracker.Server

/-!
# Polling the feed optimally under the X API v2 rate limits

The tracker reads the feed by polling.  Every X API v2 endpoint publishes a
quota of the form "`quota` requests per `windowMs` milliseconds" (the tables in
the rate-limit documentation: 450/15 min for recent search per app, 900/15 min
for a user timeline per user token, and so on), and a request made once the
quota is exhausted is answered with `429` until `x-rate-limit-reset`.

This file models a *polling plan* and proves that the plan below is both legal
and the best legal one:

* `Limit` — a published quota, with `Limit.minPeriod = ⌈windowMs / quota⌉`, the
  spacing the quota implies;
* `Compliant` — a schedule never puts more than `quota` requests into *any*
  window of `windowMs` (this is exactly what the server enforces: the window is
  sliding from the caller's point of view, since the caller cannot see where
  the server's window boundaries fall);
* `uniform start p` — poll every `p` milliseconds.

The results:

* `uniform_compliant` — a uniform schedule of period `p` is compliant as soon
  as `windowMs ≤ p * quota`; in particular `minPeriod_uniform_compliant`, the
  plan "one request every `⌈windowMs / quota⌉` ms", is compliant.
* `uniform_not_compliant` — any faster uniform schedule (`p * quota < windowMs`,
  i.e. `p < minPeriod`) provably breaks the quota, so `minPeriod` is the
  smallest legal uniform period.
* `uniform_covers` — a period-`p` poller detects anything that appears at time
  `t` by `t + p`, so the uniform plan has worst-case detection latency
  `minPeriod`.
* `exists_gap_ge_minPeriod` — *no* compliant schedule at all, uniform or not,
  can do better: every compliant schedule has, among any `quota` consecutive
  polls, a gap of at least `minPeriod`.  Uniform polling at `minPeriod` is
  therefore latency-optimal, and the "spread requests across the window" advice
  is not merely a courtesy — bursting cannot beat it.
* `roundRobin_slice` / `roundRobin_refresh` — how to serve `m` watched accounts
  from one quota: one merged period-`minPeriod` schedule, round-robin, giving
  each account a refresh period of `m * minPeriod`.
* `Governor` — the `x-rate-limit-*` header bookkeeping, proved never to issue
  more than `limit` requests before the reset it was told about, and
  `backoffWaitMs` / `expBackoff` — the `429` recovery, proved never to retry
  before `x-rate-limit-reset`.
* `Endpoint` — the concrete numbers for the endpoints this tracker uses, and
  `plan*` — the resulting plan, including the fact that the tracker's default
  2 s poll interval is legal for recent search while the *minimum* interval the
  settings endpoint accepts (700 ms) is not.

`docs/POLLING_PLAN.md` states the plan in prose and points at the theorem that
justifies each line of it.
-/

namespace Tracker

/-! ## Quotas -/

/-- A published rate limit: `quota` requests per `windowMs` milliseconds. -/
structure Limit where
  quota : Nat
  windowMs : Nat
deriving Repr, DecidableEq

namespace Limit

/-- The spacing a quota implies: `⌈windowMs / quota⌉` milliseconds per request. -/
def minPeriod (L : Limit) : Nat := (L.windowMs + L.quota - 1) / L.quota

/-- A full window's worth of requests at the implied spacing covers the window:
`windowMs ≤ minPeriod * quota`. -/
theorem windowMs_le_minPeriod_mul {L : Limit} (hq : 0 < L.quota) :
    L.windowMs ≤ L.minPeriod * L.quota := by
  simp only [minPeriod]
  have h1 : L.quota * ((L.windowMs + L.quota - 1) / L.quota)
      + (L.windowMs + L.quota - 1) % L.quota = L.windowMs + L.quota - 1 :=
    Nat.div_add_mod _ _
  have h2 : (L.windowMs + L.quota - 1) % L.quota < L.quota := Nat.mod_lt _ hq
  have h3 : ((L.windowMs + L.quota - 1) / L.quota) * L.quota
      = L.quota * ((L.windowMs + L.quota - 1) / L.quota) := Nat.mul_comm _ _
  rw [h3]
  omega

/-- Anything strictly faster than the implied spacing overruns the window:
if `p < minPeriod` then `p * quota < windowMs`. -/
theorem mul_lt_windowMs_of_lt_minPeriod {L : Limit} {p : Nat} (hq : 0 < L.quota)
    (hp : p < L.minPeriod) : p * L.quota < L.windowMs := by
  have hdle : L.minPeriod * L.quota ≤ L.windowMs + L.quota - 1 :=
    Nat.div_mul_le_self _ _
  have hstep : p * L.quota + L.quota ≤ L.minPeriod * L.quota := by
    calc p * L.quota + L.quota = (p + 1) * L.quota := by ring
      _ ≤ L.minPeriod * L.quota := Nat.mul_le_mul_right _ hp
  omega

/-- The implied spacing is at least one millisecond for a nonempty window. -/
theorem minPeriod_pos {L : Limit} (hq : 0 < L.quota) (hw : 0 < L.windowMs) :
    0 < L.minPeriod := by
  by_contra h
  have h0 : L.minPeriod = 0 := by omega
  have := windowMs_le_minPeriod_mul (L := L) hq
  rw [h0] at this
  simp at this
  omega

/-- Reserve headroom: use only `pct`% of the published quota, so that a burst
of retries or a second client on the same token cannot push you over. -/
def withHeadroom (L : Limit) (pct : Nat) : Limit :=
  { quota := L.quota * pct / 100, windowMs := L.windowMs }

@[simp] theorem withHeadroom_windowMs (L : Limit) (pct : Nat) :
    (L.withHeadroom pct).windowMs = L.windowMs := rfl

theorem withHeadroom_quota_le {L : Limit} {pct : Nat} (h : pct ≤ 100) :
    (L.withHeadroom pct).quota ≤ L.quota := by
  have : L.quota * pct ≤ L.quota * 100 := Nat.mul_le_mul_left _ h
  calc L.quota * pct / 100 ≤ L.quota * 100 / 100 := Nat.div_le_div_right this
    _ = L.quota := by omega

end Limit

/-! ## Schedules and compliance

A schedule is the sequence of times at which requests are sent: `σ k` is the
wall-clock time (ms) of the `k`-th request. -/

/-- How many of the first `N` requests of `σ` fall in the window `[s, s + W)`. -/
def windowCount (sigma : Nat → Nat) (s W N : Nat) : Nat :=
  ((Finset.range N).filter (fun k => s ≤ sigma k ∧ sigma k < s + W)).card

/-- A schedule is compliant with a limit when no window of `windowMs`
milliseconds — wherever it starts — contains more than `quota` requests. -/
def Compliant (L : Limit) (sigma : Nat → Nat) : Prop :=
  ∀ s N, windowCount sigma s L.windowMs N ≤ L.quota

/-- Compliance with a tighter quota implies compliance with the published one:
this is what makes `Limit.withHeadroom` safe. -/
theorem Compliant.mono {L L' : Limit} {sigma : Nat → Nat} (hw : L.windowMs = L'.windowMs)
    (hq : L.quota ≤ L'.quota) (h : Compliant L sigma) : Compliant L' sigma := by
  intro s N
  have := h s N
  rw [hw] at this
  omega

/-- Poll every `p` milliseconds, starting at `start`. -/
def uniform (start p : Nat) : Nat → Nat := fun k => start + k * p

@[simp] theorem uniform_apply (start p k : Nat) : uniform start p k = start + k * p := rfl

theorem uniform_mono {start p : Nat} : Monotone (uniform start p) := by
  intro a b hab
  simpa [uniform] using Nat.mul_le_mul_right p hab

/-! ### Uniform polling is legal exactly down to `minPeriod` -/

/-- A finite set of indices whose members are pairwise within `q` of each other
has at most `q` members. -/
theorem card_le_of_pairwise_close {S : Finset Nat} {q : Nat}
    (h : ∀ a ∈ S, ∀ b ∈ S, b < a + q) : S.card ≤ q := by
  rcases Finset.eq_empty_or_nonempty S with hemp | hne
  · simp [hemp]
  · have hk0mem : S.min' hne ∈ S := S.min'_mem hne
    have hsub : S ⊆ Finset.Ico (S.min' hne) (S.min' hne + q) := by
      intro b hb
      exact Finset.mem_Ico.mpr ⟨S.min'_le b hb, h _ hk0mem b hb⟩
    calc S.card ≤ (Finset.Ico (S.min' hne) (S.min' hne + q)).card :=
          Finset.card_le_card hsub
      _ = q := by simp

/-- A uniform schedule of period `p` is compliant as soon as one window's worth
of requests spans the window, i.e. `windowMs ≤ p * quota`. -/
theorem uniform_compliant {L : Limit} {start p : Nat}
    (h : L.windowMs ≤ p * L.quota) : Compliant L (uniform start p) := by
  intro s N
  unfold windowCount
  refine card_le_of_pairwise_close ?_
  intro a ha b hb
  have hap := (Finset.mem_filter.mp ha).2.1
  have hbp := (Finset.mem_filter.mp hb).2.2
  simp only [uniform] at hap hbp
  have hlt : b * p < a * p + L.quota * p := by
    have hcomm : L.quota * p = p * L.quota := by ring
    omega
  have : b * p < (a + L.quota) * p := by
    calc b * p < a * p + L.quota * p := hlt
      _ = (a + L.quota) * p := by ring
  exact lt_of_mul_lt_mul_right this (Nat.zero_le p)

/-- The plan: poll every `⌈windowMs / quota⌉` milliseconds.  It is legal. -/
theorem minPeriod_uniform_compliant {L : Limit} (hq : 0 < L.quota) (start : Nat) :
    Compliant L (uniform start L.minPeriod) :=
  uniform_compliant (by simpa [Nat.mul_comm] using Limit.windowMs_le_minPeriod_mul (L := L) hq)

/-- Any strictly faster uniform schedule breaks the quota: the first
`quota + 1` requests already share one window. -/
theorem uniform_not_compliant {L : Limit} {start p : Nat}
    (h : p * L.quota < L.windowMs) : ¬ Compliant L (uniform start p) := by
  classical
  intro hc
  have hcount := hc start (L.quota + 1)
  have hfilter : (Finset.range (L.quota + 1)).filter
      (fun k => start ≤ uniform start p k ∧ uniform start p k < start + L.windowMs)
      = Finset.range (L.quota + 1) := by
    apply Finset.filter_true_of_mem
    intro k hk
    have hk' : k ≤ L.quota := by simpa [Nat.lt_succ_iff] using Finset.mem_range.mp hk
    refine ⟨by simp [uniform], ?_⟩
    have : k * p ≤ L.quota * p := Nat.mul_le_mul_right p hk'
    have hcomm : L.quota * p = p * L.quota := by ring
    simp only [uniform]
    omega
  rw [windowCount, hfilter] at hcount
  simp at hcount

/-- `minPeriod` is exactly the fastest legal uniform period. -/
theorem uniform_compliant_iff {L : Limit} {start p : Nat} (hq : 0 < L.quota) :
    Compliant L (uniform start p) ↔ L.minPeriod ≤ p := by
  constructor
  · intro hc
    by_contra hcon
    exact uniform_not_compliant
      (Limit.mul_lt_windowMs_of_lt_minPeriod hq (by omega)) hc
  · intro hle
    refine uniform_compliant ?_
    calc L.windowMs ≤ L.minPeriod * L.quota := Limit.windowMs_le_minPeriod_mul hq
      _ ≤ p * L.quota := Nat.mul_le_mul_right _ hle

/-! ### Coverage: what a period-`p` poller guarantees -/

/-- A period-`p` poller looks again within `p` milliseconds of any moment at or
after it started: a post appearing at `t` is picked up by `t + p` at the latest. -/
theorem uniform_covers {start p t : Nat} (hp : 0 < p) (hstart : start ≤ t) :
    ∃ k, t ≤ uniform start p k ∧ uniform start p k ≤ t + p := by
  refine ⟨(t - start) / p + 1, ?_, ?_⟩
  · have h1 : p * ((t - start) / p) + (t - start) % p = t - start := Nat.div_add_mod _ _
    have h2 : (t - start) % p < p := Nat.mod_lt _ hp
    have h3 : ((t - start) / p + 1) * p = p * ((t - start) / p) + p := by ring
    simp only [uniform]
    omega
  · have h : (t - start) / p * p ≤ t - start := Nat.div_mul_le_self _ _
    have h3 : ((t - start) / p + 1) * p = (t - start) / p * p + p := by ring
    simp only [uniform]
    omega

/-! ### Optimality: no compliant schedule polls faster on average

The two lemmas below say that the uniform plan is not just the best *uniform*
plan.  Any compliant schedule at all — bursty, adaptive, whatever — has, among
any `quota` consecutive polls, one gap of at least `minPeriod`.  A post
appearing just after that poll waits at least `minPeriod`, so `minPeriod` is a
lower bound on worst-case detection latency, and the uniform plan attains it. -/

/-- A compliant schedule spans a whole window every `quota` requests. -/
theorem compliant_span {L : Limit} {sigma : Nat → Nat} (hc : Compliant L sigma)
    (hm : Monotone sigma) (k : Nat) :
    sigma k + L.windowMs ≤ sigma (k + L.quota) := by
  classical
  by_contra hcon
  push_neg at hcon
  have hsub : Finset.Icc k (k + L.quota) ⊆
      (Finset.range (k + L.quota + 1)).filter
        (fun j => sigma k ≤ sigma j ∧ sigma j < sigma k + L.windowMs) := by
    intro j hj
    obtain ⟨hj1, hj2⟩ := Finset.mem_Icc.mp hj
    refine Finset.mem_filter.mpr ⟨Finset.mem_range.mpr (by omega), hm hj1, ?_⟩
    exact lt_of_le_of_lt (hm hj2) hcon
  have hcard := Finset.card_le_card hsub
  rw [Nat.card_Icc] at hcard
  have hc' := hc (sigma k) (k + L.quota + 1)
  unfold windowCount at hc'
  omega

/-- If every gap in a stretch of `m` polls is at most `g`, the stretch spans at
most `m * g`. -/
theorem span_le_of_gaps_le {sigma : Nat → Nat} {k g : Nat} :
    ∀ m, (∀ j, k ≤ j → j < k + m → sigma (j + 1) ≤ sigma j + g) →
      sigma (k + m) ≤ sigma k + m * g := by
  intro m
  induction m with
  | zero => intro _; simp
  | succ n ih =>
      intro h
      have hn : sigma (k + n) ≤ sigma k + n * g :=
        ih (fun j hj1 hj2 => h j hj1 (by omega))
      have hlast : sigma (k + n + 1) ≤ sigma (k + n) + g := h (k + n) (by omega) (by omega)
      have : k + (n + 1) = k + n + 1 := by omega
      rw [this]
      calc sigma (k + n + 1) ≤ sigma (k + n) + g := hlast
        _ ≤ sigma k + n * g + g := by omega
        _ = sigma k + (n + 1) * g := by ring

/-- **Optimality of uniform polling.**  Every compliant schedule has, among any
`quota` consecutive polls, a gap of at least `minPeriod`.  So no legal schedule
guarantees a detection latency better than the uniform plan's `minPeriod`. -/
theorem exists_gap_ge_minPeriod {L : Limit} {sigma : Nat → Nat} (hq : 0 < L.quota)
    (hw : 0 < L.windowMs) (hc : Compliant L sigma) (hm : Monotone sigma) (k : Nat) :
    ∃ j, k ≤ j ∧ j < k + L.quota ∧ L.minPeriod ≤ sigma (j + 1) - sigma j := by
  by_contra hcon
  push_neg at hcon
  have hgap : ∀ j, k ≤ j → j < k + L.quota → sigma (j + 1) ≤ sigma j + (L.minPeriod - 1) := by
    intro j h1 h2
    have := hcon j h1 h2
    have hmono : sigma j ≤ sigma (j + 1) := hm (by omega)
    omega
  have hspan := span_le_of_gaps_le (sigma := sigma) (k := k) (g := L.minPeriod - 1) L.quota hgap
  have hlow := compliant_span hc hm k
  have hpos := L.minPeriod_pos hq hw
  have hlt : (L.minPeriod - 1) * L.quota < L.windowMs :=
    Limit.mul_lt_windowMs_of_lt_minPeriod hq (by omega)
  have hcomm : L.quota * (L.minPeriod - 1) = (L.minPeriod - 1) * L.quota := by ring
  omega

/-! ### Sharing one quota between many pollers (round robin)

`m` watched accounts share one endpoint quota by issuing one merged
`minPeriod`-spaced stream of requests and rotating through the accounts.  The
requests belonging to account `i` are themselves a uniform schedule of period
`m * minPeriod`, which is therefore that account's refresh period. -/

/-- The sub-schedule of account `i` in an `m`-way round robin over the merged
uniform schedule is itself uniform, with period `m * p`. -/
theorem roundRobin_slice (start p m i k : Nat) :
    uniform start p (i + k * m) = uniform (start + i * p) (m * p) k := by
  simp only [uniform]
  ring

/-- Consecutive visits to the same account are `m * p` apart. -/
theorem roundRobin_refresh (start p m i k : Nat) :
    uniform start p (i + (k + 1) * m) - uniform start p (i + k * m) = m * p := by
  simp only [uniform]
  have h : start + (i + (k + 1) * m) * p = (start + (i + k * m) * p) + m * p := by ring
  omega

/-- Serving `m` accounts from one quota is legal, and each account is then
refreshed every `m * minPeriod` milliseconds. -/
theorem roundRobin_plan {L : Limit} (hq : 0 < L.quota) (start m i : Nat) :
    Compliant L (uniform start L.minPeriod) ∧
      ∀ k, uniform start L.minPeriod (i + (k + 1) * m)
            - uniform start L.minPeriod (i + k * m) = m * L.minPeriod :=
  ⟨minPeriod_uniform_compliant hq start, fun k => roundRobin_refresh _ _ _ _ k⟩

/-! ## Reading the headers: the governor

`x-rate-limit-limit`, `x-rate-limit-remaining` and `x-rate-limit-reset` let the
client track its own budget.  The governor below refuses to issue a request
once the budget for the current window is spent, and rolls the budget over only
when the advertised reset time has passed. -/

/-- Client-side budget bookkeeping for one endpoint/token pair. -/
structure Governor where
  /-- `x-rate-limit-limit`. -/
  limit : Nat
  /-- Length of the quota window, in milliseconds. -/
  windowMs : Nat
  /-- Requests issued since the current window opened. -/
  used : Nat
  /-- `x-rate-limit-reset`, as a wall-clock time in milliseconds. -/
  resetAt : Nat
deriving Repr, DecidableEq

namespace Governor

/-- What `x-rate-limit-remaining` would say. -/
def remaining (g : Governor) : Nat := g.limit - g.used

/-- The budget is never overspent. -/
def Invariant (g : Governor) : Prop := g.used ≤ g.limit

/-- May a request go out now?  Either the window has rolled over, or budget is
left in the current one. -/
def mayRequest (g : Governor) (now : Nat) : Bool := g.resetAt ≤ now || g.used < g.limit

/-- Charge a request to the budget, rolling the window over first if the
advertised reset time has passed. -/
def issue (g : Governor) (now : Nat) : Governor :=
  if g.resetAt ≤ now then { g with used := 1, resetAt := now + g.windowMs }
  else { g with used := g.used + 1 }

/-- One attempt: issue if allowed, otherwise hold. -/
def step (g : Governor) (now : Nat) : Governor × Bool :=
  if g.mayRequest now then (g.issue now, true) else (g, false)

/-- Adopt the server's own numbers from the response headers. -/
def observe (g : Governor) (hdrLimit hdrRemaining hdrReset : Nat) : Governor :=
  { g with limit := hdrLimit, used := hdrLimit - hdrRemaining, resetAt := hdrReset }

/-- The governor never spends more than the limit in a window. -/
theorem invariant_step {g : Governor} {now : Nat} (h : g.Invariant) (hl : 1 ≤ g.limit) :
    (g.step now).1.Invariant := by
  unfold step
  by_cases hm : g.mayRequest now = true
  · simp only [hm, if_true]
    unfold issue Invariant
    by_cases hr : g.resetAt ≤ now
    · simpa [hr] using hl
    · simp only [hr, if_false]
      unfold mayRequest at hm
      simp only [hr, decide_false, Bool.false_or, decide_eq_true_eq] at hm
      simpa using hm
  · simpa [hm] using h

/-- Trusting the headers keeps the invariant. -/
theorem invariant_observe (g : Governor) (hdrLimit hdrRemaining hdrReset : Nat) :
    (g.observe hdrLimit hdrRemaining hdrReset).Invariant := by
  unfold observe Invariant
  simp

/-- A held request really is held: nothing is sent and the state does not move. -/
theorem step_hold {g : Governor} {now : Nat} (h : g.mayRequest now = false) :
    g.step now = (g, false) := by simp [step, h]

/-- A request is only ever withheld when the budget is spent and the window has
not yet reset — never otherwise. -/
theorem step_issues_iff {g : Governor} {now : Nat} :
    (g.step now).2 = true ↔ (now < g.resetAt → g.used < g.limit) := by
  unfold step mayRequest
  by_cases hr : g.resetAt ≤ now <;> by_cases hu : g.used < g.limit <;>
    simp [hr, hu]

/-- Used budget only ever moves by one request at a time. -/
theorem used_step_le {g : Governor} {now : Nat} :
    (g.step now).1.used ≤ g.used + 1 := by
  unfold step issue
  by_cases hm : g.mayRequest now <;> by_cases hr : g.resetAt ≤ now <;> simp [hm, hr]

end Governor

/-! ## Recovering from a 429 -/

/-- The documented recovery: sleep until `x-rate-limit-reset`, but at least
60 s (`max(reset - now, 60)`, in milliseconds). -/
def backoffWaitMs (now resetAt : Nat) : Nat := max (resetAt - now) 60000

/-- The retry never happens before the advertised reset. -/
theorem retry_after_reset (now resetAt : Nat) : resetAt ≤ now + backoffWaitMs now resetAt := by
  unfold backoffWaitMs
  have : resetAt - now ≤ max (resetAt - now) 60000 := le_max_left _ _
  omega

/-- The retry also always waits the documented floor of 60 s. -/
theorem retry_min_wait (now resetAt : Nat) : 60000 ≤ backoffWaitMs now resetAt :=
  le_max_right _ _

/-- Exponential backoff for repeated failures, capped. -/
def expBackoff (baseMs cap attempt : Nat) : Nat := min cap (baseMs * 2 ^ attempt)

theorem expBackoff_le_cap (baseMs cap attempt : Nat) : expBackoff baseMs cap attempt ≤ cap :=
  min_le_left _ _

theorem expBackoff_mono (baseMs cap : Nat) {a b : Nat} (hab : a ≤ b) :
    expBackoff baseMs cap a ≤ expBackoff baseMs cap b := by
  unfold expBackoff
  exact min_le_min (le_refl _) (Nat.mul_le_mul_left _ (Nat.pow_le_pow_right (by norm_num) hab))

/-! ## The concrete plan

The published numbers for the endpoints a feed tracker can poll.  A 15-minute
window is 900 000 ms; a 24-hour window is 86 400 000 ms. -/

namespace Endpoint

/-- `quota` requests per 15 minutes. -/
def per15 (q : Nat) : Limit := { quota := q, windowMs := 900000 }

/-- `quota` requests per 24 hours. -/
def per24h (q : Nat) : Limit := { quota := q, windowMs := 86400000 }

/-- `GET /2/tweets/search/recent`, per app: 450/15 min. -/
def searchRecentApp : Limit := per15 450
/-- `GET /2/tweets/search/recent`, per user: 300/15 min. -/
def searchRecentUser : Limit := per15 300
/-- `GET /2/users/:id/tweets`, per app: 10 000/15 min. -/
def userTweetsApp : Limit := per15 10000
/-- `GET /2/users/:id/tweets`, per user: 900/15 min. -/
def userTweetsUser : Limit := per15 900
/-- `GET /2/users/:id/mentions`, per user: 300/15 min. -/
def mentionsUser : Limit := per15 300
/-- `GET /2/users/:id/timelines/reverse_chronological`, per user: 180/15 min. -/
def homeTimelineUser : Limit := per15 180
/-- `GET /2/tweets` (id hydration), per app: 3 500/15 min. -/
def tweetsLookupApp : Limit := per15 3500
/-- `GET /2/lists/:id/tweets`: 900/15 min. -/
def listTweets : Limit := per15 900
/-- `GET /2/tweets/search/stream` (connection attempts), per app: 50/15 min. -/
def filteredStreamConnect : Limit := per15 50
/-- `POST /2/tweets/search/stream/rules`, per app: 100/15 min. -/
def streamRulesWrite : Limit := per15 100
/-- `GET /2/usage/tweets`, per app: 50/15 min. -/
def usageApp : Limit := per15 50
/-- `POST /2/tweets`, per app: 10 000/24 h. -/
def createTweetApp : Limit := per24h 10000

/-- The implied spacings, in milliseconds. -/
example : searchRecentApp.minPeriod = 2000 := by decide
example : searchRecentUser.minPeriod = 3000 := by decide
example : userTweetsUser.minPeriod = 1000 := by decide
example : userTweetsApp.minPeriod = 90 := by decide
example : mentionsUser.minPeriod = 3000 := by decide
example : homeTimelineUser.minPeriod = 5000 := by decide
example : tweetsLookupApp.minPeriod = 258 := by decide
example : listTweets.minPeriod = 1000 := by decide
example : filteredStreamConnect.minPeriod = 18000 := by decide
example : usageApp.minPeriod = 18000 := by decide

end Endpoint

/-! ### The plan the tracker should run -/

/-- The merged polling period for a source: `⌈windowMs / quota⌉`, after
reserving headroom. -/
def planPeriod (L : Limit) (headroomPct : Nat) : Nat := (L.withHeadroom headroomPct).minPeriod

/-- The refresh period each of `m` round-robin targets gets. -/
def planRefresh (L : Limit) (headroomPct m : Nat) : Nat := m * planPeriod L headroomPct

/-- A plan run at `planPeriod` is compliant with the published limit, headroom
and all. -/
theorem planPeriod_compliant {L : Limit} {headroomPct : Nat} (h100 : headroomPct ≤ 100)
    (hq : 0 < (L.withHeadroom headroomPct).quota) (start : Nat) :
    Compliant L (uniform start (planPeriod L headroomPct)) := by
  have hbase : Compliant (L.withHeadroom headroomPct)
      (uniform start (planPeriod L headroomPct)) :=
    minPeriod_uniform_compliant hq start
  exact hbase.mono (by simp) (Limit.withHeadroom_quota_le h100)

/-- With 80% headroom the tracker polls recent search every 2.5 s … -/
example : planPeriod Endpoint.searchRecentApp 80 = 2500 := by decide

/-- … and, watching 5 accounts round-robin on their user timelines with the same
headroom, refreshes each of them every 6.25 s. -/
example : planRefresh Endpoint.userTweetsUser 80 5 = 6250 := by decide

/-- The tracker's default poll interval of 2 000 ms is legal for recent search
on an app token. -/
theorem defaultPollMs_compliant (start : Nat) :
    Compliant Endpoint.searchRecentApp (uniform start 2000) :=
  uniform_compliant (by decide)

/-- It is also a value the settings endpoint accepts. -/
theorem defaultPollMs_valid : validPollMs 2000 = true := by decide

/-- But the *fastest* interval the settings endpoint accepts, 700 ms, is not
legal against recent search: the settings validation is a UI guard, not a rate
limit, so the scheduler — not the operator — has to enforce `minPeriod`. -/
theorem minPollMs_accepted_but_not_compliant (start : Nat) :
    validPollMs 700 = true ∧ ¬ Compliant Endpoint.searchRecentApp (uniform start 700) :=
  ⟨by decide, uniform_not_compliant (by decide)⟩

/-- Worst-case detection latency of the recommended recent-search plan: a post
that appears at `t` is seen by `t + 2500` ms. -/
theorem searchPlan_covers {start t : Nat} (h : start ≤ t) :
    ∃ k, t ≤ uniform start (planPeriod Endpoint.searchRecentApp 80) k ∧
      uniform start (planPeriod Endpoint.searchRecentApp 80) k ≤ t + 2500 := by
  have := uniform_covers (start := start) (p := 2500) (t := t) (by norm_num) h
  simpa [planPeriod, Endpoint.searchRecentApp, Endpoint.per15,
    Limit.withHeadroom, Limit.minPeriod] using this

/-- And no legal schedule against the *full* recent-search quota can promise
better than 2 000 ms: any compliant schedule leaves a ≥ 2 s gap somewhere in
every 450 polls. -/
theorem searchPlan_optimal {sigma : Nat → Nat} (hc : Compliant Endpoint.searchRecentApp sigma)
    (hm : Monotone sigma) (k : Nat) :
    ∃ j, k ≤ j ∧ j < k + 450 ∧ 2000 ≤ sigma (j + 1) - sigma j := by
  have := exists_gap_ge_minPeriod (L := Endpoint.searchRecentApp) (sigma := sigma)
    (by decide) (by decide) hc hm k
  simpa [Endpoint.searchRecentApp, Endpoint.per15, Limit.minPeriod] using this

end Tracker
