import RequestProject.Tracker.Dedupe
import RequestProject.Tracker.Timing

/-!
# The hot path: `emitTweet`

`emitTweet(t, source)` in `service.ts` is the single funnel through which every
detected post reaches the browser.  In order it:

1. drops a post that is already in the dedupe set (another source won the race);
2. claims the id in the dedupe set (`markSeen`) — *before* any later drop, so a
   post the push path deliberately discards cannot be resurrected by the poller;
3. drops a post older than `MAX_TWEET_AGE_MS`, unless it was injected manually,
   counting it in `staleDrops`;
4. drops a post whose author is unwatched or muted, or whose kind the settings
   exclude (`skipRetweets` / `skipReplies`);
5. otherwise publishes the card, counts it, keeps it in `recentTweets`, and —
   only if the body is not a push skeleton and the card is not a profile event —
   records its latency in the rolling window.

This file models that function as a state transition and proves what the rest
of the system relies on: publication is at most once per id, everything
published is fresh, watched and unmuted, and the latency window only ever
contains real, in-cap detections.
-/

namespace Tracker

/-- Runtime settings that influence the hot path. -/
structure Config where
  /-- `SEEN_MAX`. -/
  seenMax : Nat := 4000
  /-- `MAX_TWEET_AGE_MS`. -/
  maxAgeMs : Nat := 300000
  /-- Size of the rolling latency window. -/
  detectWindow : Nat := 50
  /-- Size of the `recentTweets` ring. -/
  recentMax : Nat := 100
  skipRetweets : Bool := false
  skipReplies : Bool := false
  deriving DecidableEq, Repr, Inhabited

/-- A `Config` whose caps are all usable (at least one entry). -/
structure Config.Sane (cfg : Config) : Prop where
  seenMax : 1 ≤ cfg.seenMax
  detectWindow : 1 ≤ cfg.detectWindow
  recentMax : 1 ≤ cfg.recentMax

/-- A watchlist entry. -/
structure Watched where
  handle : String
  userId : Option String := none
  muted : Bool := false
  tier : Option Nat := none
  deriving DecidableEq, Repr, Inhabited

/-- `watchedAuthor`: resolve an author against the watchlist.  A numeric user id
wins when it matches; otherwise the handle is used, but only when it does not
contradict a recorded user id (an id mismatch means a different account has
taken over the handle, and the post is not ours). -/
def watchedAuthor (ws : List Watched) (a : Author) : Option Watched :=
  let byHandle : Option Watched :=
    match ws.find? (fun w => w.handle = a.handle) with
    | none => none
    | some w =>
      match w.userId, a.userId with
      | some wid, some aid => if wid = aid then some w else none
      | _, _ => some w
  match a.userId with
  | none => byHandle
  | some uid =>
    match ws.find? (fun w => w.userId = some uid) with
    | some w => some w
    | none => byHandle

/-- `filtered`: settings- and watchlist-level exclusion. -/
def filtered (cfg : Config) (ws : List Watched) (t : Tweet) : Bool :=
  match watchedAuthor ws t.author with
  | none => true
  | some w =>
    w.muted || (cfg.skipRetweets && t.kind == TweetKind.retweet)
             || (cfg.skipReplies && t.kind == TweetKind.reply)

/-- The observable state of the tracker's hot path. -/
structure State where
  cfg : Config
  watch : List Watched
  seen : SeenStore := SeenStore.empty
  /-- Rolling latency window (`detectMs`). -/
  detect : List Nat := []
  /-- Bounded ring of published cards (`recentTweets`). -/
  recent : List Tweet := []
  tweetCount : Nat := 0
  staleDrops : Nat := 0
  /-- Everything published on the wire, oldest first. -/
  log : List Event := []
  deriving Repr, Inhabited

/-- Does this detection get a latency sample?  A push skeleton has no publish
time yet (`partial`), and a profile event is not a post, so neither may enter
the percentiles. -/
def measurable (t : Tweet) : Bool := !t.isPartial && t.kind != TweetKind.profile

/-- `emitTweet`. -/
def emit (now : Nat) (s : State) (t : Tweet) (src : IngestSource) : State :=
  if s.seen.has t.id then s
  else
    let seen' := s.seen.mark' s.cfg.seenMax t.id src
    if src ≠ IngestSource.manual ∧ isStale s.cfg.maxAgeMs now t then
      { s with seen := seen', staleDrops := s.staleDrops + 1 }
    else if filtered s.cfg s.watch t then
      { s with seen := seen' }
    else
      { s with
        seen := seen'
        log := s.log ++ [Event.tweet t]
        tweetCount := s.tweetCount + 1
        recent := pushBounded s.cfg.recentMax s.recent t
        detect := if measurable t then recordDetect s.cfg.detectWindow s.detect t.detectMs
                  else s.detect }

/-- The conditions under which `emit` puts a card on the wire. -/
def Publishes (now : Nat) (s : State) (t : Tweet) (src : IngestSource) : Prop :=
  ¬ s.seen.has t.id ∧ ¬ (src ≠ IngestSource.manual ∧ isStale s.cfg.maxAgeMs now t) ∧
    filtered s.cfg s.watch t = false

instance (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    Decidable (Publishes now s t src) := by unfold Publishes; infer_instance

/-! ## Publication -/

theorem emit_of_seen {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (h : s.seen.has t.id) : emit now s t src = s := by
  simp [emit, h]

theorem emit_log_of_publishes {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (h : Publishes now s t src) :
    (emit now s t src).log = s.log ++ [Event.tweet t] := by
  obtain ⟨h1, h2, h3⟩ := h
  simp [emit, h1, h2, h3]

theorem emit_log_of_not_publishes {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (h : ¬ Publishes now s t src) : (emit now s t src).log = s.log := by
  unfold Publishes at h
  by_cases h1 : s.seen.has t.id
  · simp [emit, h1]
  · by_cases h2 : src ≠ IngestSource.manual ∧ isStale s.cfg.maxAgeMs now t
    · simp [emit, h1, h2]
    · have h3 : filtered s.cfg s.watch t = true := by
        by_cases hb : filtered s.cfg s.watch t = true
        · exact hb
        · exact absurd ⟨h1, h2, by simpa using hb⟩ h
      simp [emit, h1, h2, h3]

/-- `emit` appends at most one card to the wire, and never rewrites history. -/
theorem emit_log_grows (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    (emit now s t src).log = s.log ∨ (emit now s t src).log = s.log ++ [Event.tweet t] := by
  by_cases h : Publishes now s t src
  · exact Or.inr (emit_log_of_publishes h)
  · exact Or.inl (emit_log_of_not_publishes h)

/-! ## Dedupe: at most one card per post id -/

/-- The id is claimed no matter which branch was taken — including the stale
drop, so a stale push replay cannot be re-detected by the poller. -/
theorem emit_seen_has {now : Nat} {s : State} (hcfg : s.cfg.Sane) (t : Tweet)
    (src : IngestSource) : (emit now s t src).seen.has t.id := by
  by_cases h1 : s.seen.has t.id
  · simpa [emit_of_seen h1] using h1
  · have hmark := SeenStore.has_mark' hcfg.seenMax s.seen t.id src
    unfold emit
    rw [if_neg h1]
    split
    · exact hmark
    · split <;> exact hmark

/-- Re-delivering the very same post is a no-op: the second call publishes
nothing and changes no counter. -/
theorem emit_idem {now : Nat} {s : State} (hcfg : s.cfg.Sane) (t : Tweet)
    (src : IngestSource) :
    emit now (emit now s t src) t src = emit now s t src :=
  emit_of_seen (emit_seen_has hcfg t src)

/-! ## What reaches the wire -/

/-- Passing the staleness gate on a live source means the post is fresh. -/
theorem fresh_of_not_stale {now cap : Nat} {t : Tweet} {src : IngestSource}
    (h : ¬ (src ≠ IngestSource.manual ∧ isStale cap now t)) (hsrc : src ≠ IngestSource.manual) :
    age now t ≤ cap := by
  rw [not_and] at h
  exact (not_stale_iff _ _ _).mp (h hsrc)

/-- Everything published from a live source is fresh: its age at publication is
within `MAX_TWEET_AGE_MS`.  (Manual injection is exempt by design.) -/
theorem publishes_fresh {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (h : Publishes now s t src) (hsrc : src ≠ IngestSource.manual) :
    age now t ≤ s.cfg.maxAgeMs :=
  fresh_of_not_stale h.2.1 hsrc

/-- Everything published belongs to a watched, unmuted account. -/
theorem publishes_watched {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (h : Publishes now s t src) :
    ∃ w, watchedAuthor s.watch t.author = some w ∧ w.muted = false := by
  have h3 := h.2.2
  unfold filtered at h3
  cases hw : watchedAuthor s.watch t.author with
  | none => rw [hw] at h3; simp at h3
  | some w =>
    rw [hw] at h3
    simp only [Bool.or_eq_false_iff] at h3
    exact ⟨w, rfl, h3.1.1⟩

/-- Settings-level exclusions really do exclude. -/
theorem publishes_kind {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (h : Publishes now s t src) :
    ¬ (s.cfg.skipRetweets = true ∧ t.kind = TweetKind.retweet) ∧
    ¬ (s.cfg.skipReplies = true ∧ t.kind = TweetKind.reply) := by
  have h3 := h.2.2
  unfold filtered at h3
  cases hw : watchedAuthor s.watch t.author with
  | none => rw [hw] at h3; simp at h3
  | some w =>
    rw [hw] at h3
    simp only [Bool.or_eq_false_iff, Bool.and_eq_false_iff] at h3
    constructor
    · rintro ⟨hs, hk⟩
      have := h3.1.2
      simp [hs, hk] at this
    · rintro ⟨hs, hk⟩
      have := h3.2
      simp [hs, hk] at this

/-! ## Componentwise behaviour of `emit` -/

@[simp] theorem emit_cfg (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    (emit now s t src).cfg = s.cfg := by
  unfold emit; split_ifs <;> rfl

@[simp] theorem emit_watch (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    (emit now s t src).watch = s.watch := by
  unfold emit; split_ifs <;> rfl

theorem emit_seen_cases (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    (emit now s t src).seen = s.seen ∨
      (emit now s t src).seen = s.seen.mark' s.cfg.seenMax t.id src := by
  unfold emit; split_ifs <;> simp

theorem emit_detect_cases (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    (emit now s t src).detect = s.detect ∨
      (emit now s t src).detect = recordDetect s.cfg.detectWindow s.detect t.detectMs := by
  unfold emit
  split_ifs <;> simp_all

theorem emit_recent_cases (now : Nat) (s : State) (t : Tweet) (src : IngestSource) :
    (emit now s t src).recent = s.recent ∨
      (emit now s t src).recent = pushBounded s.cfg.recentMax s.recent t := by
  unfold emit; split_ifs <;> simp

/-! ## The state invariant -/

/-- What the hot path maintains: every bounded buffer is within its cap, and
the latency window holds only in-cap detections. -/
structure State.Wf (s : State) : Prop where
  seenBound : s.seen.entries.length ≤ s.cfg.seenMax
  detectBound : s.detect.length ≤ s.cfg.detectWindow
  /-- Nothing older than `MAX_TWEET_AGE_MS` can sit in the percentiles. -/
  detectFresh : ∀ v ∈ s.detect, v ≤ s.cfg.maxAgeMs
  recentBound : s.recent.length ≤ s.cfg.recentMax

/-- `emit` preserves the invariant for every live (non-manual) source, as long
as the record's own `detectMs` is the latency its timestamps imply. -/
theorem emit_wf {now : Nat} {s : State} {t : Tweet} {src : IngestSource}
    (hwf : s.Wf) (ht : t.timedAt now) (hsrc : src ≠ IngestSource.manual) :
    (emit now s t src).Wf := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rcases emit_seen_cases now s t src with h | h
    · simpa [h] using hwf.seenBound
    · rw [emit_cfg, h]
      exact SeenStore.length_mark'_le hwf.seenBound _ _
  · rcases emit_detect_cases now s t src with h | h
    · simpa [h] using hwf.detectBound
    · rw [emit_cfg, h]
      exact length_recordDetect_le _ _ _
  · rw [emit_cfg]
    unfold emit
    split_ifs with h1 h2 h3 h4
    · exact hwf.detectFresh
    · exact hwf.detectFresh
    · exact hwf.detectFresh
    · refine recordDetect_forall_le hwf.detectFresh ?_
      rw [detectMs_eq_age ht]
      exact fresh_of_not_stale h2 hsrc
    · exact hwf.detectFresh
  · rcases emit_recent_cases now s t src with h | h
    · simpa [h] using hwf.recentBound
    · rw [emit_cfg, h]
      exact length_pushBounded_le _ _ _

/-! ## No duplicate cards -/

/-- The ids of the cards published so far, oldest first. -/
def cardIds : List Event → List String
  | [] => []
  | Event.tweet t :: rest => t.id :: cardIds rest
  | _ :: rest => cardIds rest

theorem cardIds_append (l : List Event) (e : Event) :
    cardIds (l ++ [e]) = cardIds l ++ cardIds [e] := by
  induction l with
  | nil => cases e <;> simp [cardIds]
  | cons a l ih => cases a <;> simp [cardIds, ih]

/-- Every published card is claimed in the dedupe set, and no post id has been
published twice. -/
structure State.Deduped (s : State) : Prop where
  tracked : ∀ id ∈ cardIds s.log, id ∈ s.seen.ids
  nodup : (cardIds s.log).Nodup

/-- While the dedupe set is below its cap (so nothing is evicted), `emit`
never publishes the same post id twice. -/
theorem emit_deduped {now : Nat} {s : State} (hd : s.Deduped)
    (hroom : s.seen.entries.length + 1 ≤ s.cfg.seenMax) (t : Tweet) (src : IngestSource) :
    (emit now s t src).Deduped := by
  by_cases hp : Publishes now s t src
  · have hlog := emit_log_of_publishes hp
    have hseen : (emit now s t src).seen = s.seen.mark' s.cfg.seenMax t.id src := by
      obtain ⟨h1, h2, h3⟩ := hp
      simp [emit, h1, h2, h3]
    have hids : (emit now s t src).seen.ids = s.seen.ids ++ [t.id] := by
      rw [hseen]
      exact SeenStore.ids_mark'_eq_append hp.1 hroom src
    have hnot : t.id ∉ cardIds s.log := fun h => hp.1 (hd.tracked _ h)
    constructor
    · intro id hid
      rw [hlog, cardIds_append] at hid
      rcases List.mem_append.mp hid with h | h
      · exact hids ▸ List.mem_append_left _ (hd.tracked _ h)
      · have : id = t.id := by simpa [cardIds] using h
        simp [hids, this]
    · rw [hlog, cardIds_append]
      have hone : cardIds [Event.tweet t] = [t.id] := rfl
      rw [hone]
      simp only [List.nodup_append, List.nodup_cons, List.not_mem_nil, List.nodup_nil,
        not_false_eq_true, and_true, true_and, List.mem_singleton]
      refine ⟨hd.nodup, ?_⟩
      rintro a ha b hb rfl
      exact hnot (by simpa [List.mem_singleton] using hb ▸ ha)
  · have hlog := emit_log_of_not_publishes hp
    refine ⟨?_, by rw [hlog]; exact hd.nodup⟩
    intro id hid
    rw [hlog] at hid
    rcases emit_seen_cases now s t src with h | h
    · rw [h]; exact hd.tracked _ hid
    · rw [h]
      exact SeenStore.ids_subset_mark' src hroom (hd.tracked _ hid)

/-! ## Traces -/

/-- Replaying a whole sequence of detections, each with its own wall clock. -/
def run (s : State) : List (Nat × Tweet × IngestSource) → State
  | [] => s
  | (now, t, src) :: rest => run (emit now s t src) rest

@[simp] theorem run_nil (s : State) : run s [] = s := rfl

@[simp] theorem run_cons (s : State) (now : Nat) (t : Tweet) (src : IngestSource)
    (rest : List (Nat × Tweet × IngestSource)) :
    run s ((now, t, src) :: rest) = run (emit now s t src) rest := rfl

/-- A trace of live detections, each timed consistently with its own clock. -/
def LiveTrace (trace : List (Nat × Tweet × IngestSource)) : Prop :=
  ∀ e ∈ trace, e.2.2 ≠ IngestSource.manual ∧ e.2.1.timedAt e.1

/-- The invariant survives an arbitrary run of live detections. -/
theorem run_wf {s : State} (hwf : s.Wf) {trace : List (Nat × Tweet × IngestSource)}
    (h : LiveTrace trace) : (run s trace).Wf := by
  induction trace generalizing s with
  | nil => simpa using hwf
  | cons e rest ih =>
    obtain ⟨now, t, src⟩ := e
    have he := h (now, t, src) (by simp)
    exact ih (emit_wf hwf he.2 he.1) (fun x hx => h x (by simp [hx]))

/-- After any run of live detections, every latency percentile the dashboard
reports is a real observed detection, is within `MAX_TWEET_AGE_MS`, and the
reported percentiles are ordered `p50 ≤ p90 ≤ p99`. -/
theorem run_percentiles {s : State} (hwf : s.Wf) {trace : List (Nat × Tweet × IngestSource)}
    (h : LiveTrace trace) (p : Nat) :
    ((run s trace).detect ≠ [] → pct (run s trace).detect p ∈ (run s trace).detect) ∧
      pct (run s trace).detect p ≤ (run s trace).cfg.maxAgeMs ∧
      pct (run s trace).detect 50 ≤ pct (run s trace).detect 90 ∧
      pct (run s trace).detect 90 ≤ pct (run s trace).detect 99 := by
  have hw := run_wf hwf h
  exact ⟨fun hne => pct_mem hne p, pct_le hw.detectFresh p,
    (p50_le_p90_le_p99 _).1, (p50_le_p90_le_p99 _).2⟩

end Tracker
