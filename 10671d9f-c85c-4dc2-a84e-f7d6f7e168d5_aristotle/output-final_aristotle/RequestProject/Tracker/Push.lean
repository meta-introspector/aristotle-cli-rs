import RequestProject.Tracker.Emit

/-!
# The push path: trigger → skeleton → hydrated body

`onPushTrigger` in `service.ts` is where the tracker's timing story is decided.
A push notification carries the author, a title, a truncated body and the post
id — enough to render a card immediately — but no publish time.  The service:

1. decodes the publish time from the snowflake id (`snowflakeMs`) and drops a
   backlog replay older than `MAX_TWEET_AGE_MS` *before* the skeleton ships,
   marking it seen so the poller cannot resurrect it;
2. publishes a `partial` skeleton whose `detectMs` is the snowflake-derived
   latency, or `0` when the id carries no time;
3. hydrates the body and republishes it as a `tweet_update` **under the
   wrapper id the skeleton shipped with** — for a repost the syndication
   endpoint answers with the *original* post, a different id with a
   possibly days-old `created_at`, and attributing that to the card (or to the
   latency percentiles) is exactly the bug the code comments describe;
4. records the real latency only when it is within the age cap.

This file models the three steps and proves the timing and identity facts they
depend on.
-/

namespace Tracker

/-- A push notification. `born` is the publish time decoded from the snowflake
id (`snowflakeMs`), absent when the id carries none. -/
structure PushTrigger where
  tweetId : String
  /-- Set when the notification is a repost: the id of the original post. -/
  originalTweetId : Option String := none
  handle : String
  title : String := ""
  body : String := ""
  born : Option Nat := none
  deriving DecidableEq, Repr, Inhabited

/-- The immediately renderable card built from the notification alone. -/
def pushSkeleton (now : Nat) (trig : PushTrigger) (acct : Watched)
    (actorId : Option String) : Tweet where
  id := trig.tweetId
  author := { userId := actorId, handle := trig.handle, name := trig.title, tier := acct.tier }
  body := trig.body
  kind := if trig.originalTweetId.isSome then TweetKind.retweet else TweetKind.tweet
  refId := trig.originalTweetId
  createdAt := trig.born.getD now
  seenAt := now
  detectMs := match trig.born with
    | some b => now - b
    | none => 0
  source := IngestSource.push
  hydrateMs := 0
  isPartial := true

/-- The skeleton's provisional latency is consistent with its own timestamps:
the snowflake time when the id is real, and `0` (`createdAt = now`) when it is
not. -/
theorem pushSkeleton_timedAt (now : Nat) (trig : PushTrigger) (acct : Watched)
    (actorId : Option String) : (pushSkeleton now trig acct actorId).timedAt now := by
  cases hb : trig.born with
  | none => simp [Tweet.timedAt, pushSkeleton, hb]
  | some b => simp [Tweet.timedAt, pushSkeleton, hb]

/-- A skeleton is always a partial body, hence never measurable: a push
notification carries no publish time, so recording its `detectMs` would make
the push source advertise a perfect 0 ms forever. -/
@[simp] theorem pushSkeleton_not_measurable (now : Nat) (trig : PushTrigger) (acct : Watched)
    (actorId : Option String) : measurable (pushSkeleton now trig acct actorId) = false := by
  simp [measurable, pushSkeleton]

/-! ## Hydration -/

/-- The result of shaping a hydrated body onto the skeleton's identity. -/
structure Hydrated where
  body : Tweet
  isRetweet : Bool
  createdAt : Nat
  realDetect : Nat
  deriving Repr

/-- `hydratedBody`.  `full` is what the syndication endpoint returned for the
notification's id: the post itself, or — for a repost — the ORIGINAL post under
a different id.  Either way the result keeps the wrapper id and the snowflake
publish time, and a repost takes the shape the GraphQL path gives it. -/
def hydratedBody (wrapperId : String) (skeleton full : Tweet) (born : Option Nat) (now : Nat)
    (tier : Option Nat) : Hydrated :=
  let createdAt := born.getD full.createdAt
  let realDetect := now - createdAt
  let body : Tweet :=
    if full.id ≠ wrapperId then
      { full with
        id := wrapperId
        author := { skeleton.author with tier := tier }
        kind := TweetKind.retweet
        refId := some full.id
        originalAuthor := some full.author
        quotedId := full.quotedId
        replyToId := none
        createdAt := createdAt
        seenAt := now
        detectMs := realDetect }
    else
      { full with
        author := { full.author with tier := tier }
        createdAt := createdAt
        seenAt := now
        detectMs := realDetect }
  { body := body
    isRetweet := full.id ≠ wrapperId || full.kind == TweetKind.retweet
    createdAt := createdAt
    realDetect := realDetect }

/-- **Every frame stays under the wrapper id the skeleton shipped with.** -/
@[simp] theorem hydratedBody_id (wrapperId : String) (skeleton full : Tweet) (born : Option Nat)
    (now : Nat) (tier : Option Nat) :
    (hydratedBody wrapperId skeleton full born now tier).body.id = wrapperId := by
  unfold hydratedBody
  by_cases h : full.id ≠ wrapperId
  · simp [h]
  · simp [not_not.mp h]

/-- A repost takes the GraphQL path's shape: the watched actor stays the
author, the retweeted post becomes `refId`/`originalAuthor`. -/
theorem hydratedBody_retweet {wrapperId : String} {skeleton full : Tweet} {born : Option Nat}
    {now : Nat} {tier : Option Nat} (h : full.id ≠ wrapperId) :
    let r := (hydratedBody wrapperId skeleton full born now tier).body
    r.kind = TweetKind.retweet ∧ r.refId = some full.id ∧
      r.originalAuthor = some full.author ∧ r.author.handle = skeleton.author.handle := by
  simp [hydratedBody, h]

/-- The publish time is the snowflake of the wrapper whenever the id is real —
never the original post's `created_at`, which can be days old. -/
@[simp] theorem hydratedBody_createdAt (wrapperId : String) (skeleton full : Tweet) (b now : Nat)
    (tier : Option Nat) :
    (hydratedBody wrapperId skeleton full (some b) now tier).createdAt = b := rfl

/-- The measured latency is the age of the post at hydration time. -/
@[simp] theorem hydratedBody_realDetect (wrapperId : String) (skeleton full : Tweet)
    (born : Option Nat) (now : Nat) (tier : Option Nat) :
    (hydratedBody wrapperId skeleton full born now tier).realDetect =
      now - (hydratedBody wrapperId skeleton full born now tier).createdAt := rfl

/-- The hydrated body reports its own latency consistently. -/
theorem hydratedBody_timedAt (wrapperId : String) (skeleton full : Tweet) (born : Option Nat)
    (now : Nat) (tier : Option Nat) :
    (hydratedBody wrapperId skeleton full born now tier).body.timedAt now := by
  unfold hydratedBody Tweet.timedAt
  by_cases h : full.id ≠ wrapperId <;> simp [h]

/-- **The skeleton does not lie about latency.**  When the id carries a
snowflake, the provisional figure shown immediately is exactly the figure the
hydrate confirms; hydration upgrades the body, not the clock. -/
theorem pushSkeleton_detect_eq_hydrated {now b : Nat} {trig : PushTrigger} {acct : Watched}
    {actorId : Option String} {full : Tweet} {tier : Option Nat} (hb : trig.born = some b) :
    (pushSkeleton now trig acct actorId).detectMs =
      (hydratedBody trig.tweetId (pushSkeleton now trig acct actorId) full trig.born now
        tier).realDetect := by
  simp [pushSkeleton, hydratedBody, hb]

/-! ## The push pipeline as a state transition -/

/-- The backlog-replay guard applied to the notification itself. -/
def pushStale (cap now : Nat) (trig : PushTrigger) : Prop :=
  ∃ b, trig.born = some b ∧ cap < now - b

instance (cap now : Nat) (trig : PushTrigger) : Decidable (pushStale cap now trig) := by
  unfold pushStale
  cases hb : trig.born with
  | none => exact isFalse (by simp)
  | some b =>
    by_cases h : cap < now - b
    · exact isTrue ⟨b, rfl, h⟩
    · refine isFalse ?_
      rintro ⟨b', hb', hlt⟩
      cases hb'
      exact h hlt

/-- Step 1–2: drop a stale replay (marking it seen), otherwise publish the
skeleton through the ordinary hot path. -/
def handleTrigger (now : Nat) (s : State) (trig : PushTrigger) (acct : Watched)
    (actorId : Option String) : State :=
  if pushStale s.cfg.maxAgeMs now trig then
    { s with seen := s.seen.mark' s.cfg.seenMax trig.tweetId IngestSource.push
             staleDrops := s.staleDrops + 1 }
  else emit now s (pushSkeleton now trig acct actorId) IngestSource.push

@[simp] theorem handleTrigger_cfg (now : Nat) (s : State) (trig : PushTrigger) (acct : Watched)
    (actorId : Option String) : (handleTrigger now s trig acct actorId).cfg = s.cfg := by
  unfold handleTrigger
  split
  · rfl
  · simp

/-- A stale backlog replay publishes nothing … -/
theorem handleTrigger_stale_log {now : Nat} {s : State} {trig : PushTrigger} {acct : Watched}
    {actorId : Option String} (h : pushStale s.cfg.maxAgeMs now trig) :
    (handleTrigger now s trig acct actorId).log = s.log := by
  simp [handleTrigger, h]

/-- … and is marked seen, so the poller cannot resurrect it. -/
theorem handleTrigger_stale_seen {now : Nat} {s : State} (hcfg : s.cfg.Sane) {trig : PushTrigger}
    {acct : Watched} {actorId : Option String} (h : pushStale s.cfg.maxAgeMs now trig) :
    (handleTrigger now s trig acct actorId).seen.has trig.tweetId := by
  simp only [handleTrigger, if_pos h]
  exact SeenStore.has_mark' hcfg.seenMax _ _ _

/-- Either way the id is claimed exactly once. -/
theorem handleTrigger_seen {now : Nat} {s : State} (hcfg : s.cfg.Sane) (trig : PushTrigger)
    (acct : Watched) (actorId : Option String) :
    (handleTrigger now s trig acct actorId).seen.has trig.tweetId := by
  by_cases h : pushStale s.cfg.maxAgeMs now trig
  · exact handleTrigger_stale_seen hcfg h
  · simpa [handleTrigger, h, pushSkeleton] using
      emit_seen_has (now := now) hcfg (pushSkeleton now trig acct actorId) IngestSource.push

/-- Step 3–4: the body upgrade.  The frame is addressed to the wrapper id, and
the real latency enters the percentiles only when it is within the age cap. -/
def applyHydrate (t0 tEnd : Nat) (s : State) (wrapperId : String) (h : Hydrated) : State :=
  { s with
    log := s.log ++ [Event.tweetUpdate wrapperId h.createdAt h.realDetect (tEnd - t0) h.body.isPartial]
    detect := if h.realDetect ≤ s.cfg.maxAgeMs then
                recordDetect s.cfg.detectWindow s.detect h.realDetect
              else s.detect }

@[simp] theorem applyHydrate_cfg (t0 tEnd : Nat) (s : State) (wrapperId : String) (h : Hydrated) :
    (applyHydrate t0 tEnd s wrapperId h).cfg = s.cfg := rfl

/-- The update frame addresses the card the browser already has. -/
theorem applyHydrate_update_id (t0 tEnd : Nat) (s : State) (wrapperId : String) (h : Hydrated) :
    ∃ e, (applyHydrate t0 tEnd s wrapperId h).log = s.log ++ [e] ∧
      e.postId = some wrapperId := by
  exact ⟨_, rfl, rfl⟩

/-- The latency window stays inside the age cap across a hydrate. -/
theorem applyHydrate_wf {t0 tEnd : Nat} {s : State} {wrapperId : String} {h : Hydrated}
    (hwf : s.Wf) : (applyHydrate t0 tEnd s wrapperId h).Wf := by
  refine ⟨hwf.seenBound, ?_, ?_, hwf.recentBound⟩
  · by_cases hr : h.realDetect ≤ s.cfg.maxAgeMs
    · simp [applyHydrate, hr]
    · simpa [applyHydrate, hr] using hwf.detectBound
  · by_cases hr : h.realDetect ≤ s.cfg.maxAgeMs
    · simpa [applyHydrate, hr] using recordDetect_forall_le hwf.detectFresh hr
    · simpa [applyHydrate, hr] using hwf.detectFresh

/-! ## The pipeline end to end -/

/-- One complete push detection: the notification, then its hydrated body. -/
def pushRound (now t0 tEnd : Nat) (s : State) (trig : PushTrigger) (acct : Watched)
    (actorId : Option String) (full : Tweet) : State :=
  let s1 := handleTrigger now s trig acct actorId
  let skeleton := pushSkeleton now trig acct actorId
  applyHydrate t0 tEnd s1 trig.tweetId
    (hydratedBody trig.tweetId skeleton full trig.born now acct.tier)

/-- A live push round publishes exactly two frames — the immediate card and its
body upgrade — both addressed to the wrapper id, and it leaves the latency
window bounded by the age cap. -/
theorem pushRound_frames {now t0 tEnd : Nat} {s : State} (hwf : s.Wf) {trig : PushTrigger}
    {acct : Watched} {actorId : Option String} {full : Tweet}
    (hfresh : ¬ pushStale s.cfg.maxAgeMs now trig)
    (hpub : Publishes now s (pushSkeleton now trig acct actorId) IngestSource.push) :
    ∃ card update,
      (pushRound now t0 tEnd s trig acct actorId full).log = s.log ++ [card, update] ∧
      card.postId = some trig.tweetId ∧ update.postId = some trig.tweetId ∧
      card.isCard = true ∧ update.isCard = false ∧
      (pushRound now t0 tEnd s trig acct actorId full).Wf := by
  have hlog : (handleTrigger now s trig acct actorId).log =
      s.log ++ [Event.tweet (pushSkeleton now trig acct actorId)] := by
    simpa [handleTrigger, hfresh] using emit_log_of_publishes hpub
  have hwf1 : (handleTrigger now s trig acct actorId).Wf := by
    simpa [handleTrigger, hfresh] using
      emit_wf hwf (pushSkeleton_timedAt now trig acct actorId) (by simp)
  refine ⟨Event.tweet (pushSkeleton now trig acct actorId),
    Event.tweetUpdate trig.tweetId
      (hydratedBody trig.tweetId (pushSkeleton now trig acct actorId) full trig.born now
        acct.tier).createdAt
      (hydratedBody trig.tweetId (pushSkeleton now trig acct actorId) full trig.born now
        acct.tier).realDetect (tEnd - t0)
      (hydratedBody trig.tweetId (pushSkeleton now trig acct actorId) full trig.born now
        acct.tier).body.isPartial,
    ?_, rfl, rfl, rfl, rfl, applyHydrate_wf hwf1⟩
  simp [pushRound, applyHydrate, hlog]

/-- Nothing that reaches the percentiles through the push path is older than
the age cap, and the skeleton itself never contributes a sample. -/
theorem pushRound_detect_bounded {now t0 tEnd : Nat} {s : State} (hwf : s.Wf) {trig : PushTrigger}
    {acct : Watched} {actorId : Option String} {full : Tweet} :
    ∀ v ∈ (pushRound now t0 tEnd s trig acct actorId full).detect, v ≤ s.cfg.maxAgeMs := by
  have hwf1 : (handleTrigger now s trig acct actorId).Wf := by
    unfold handleTrigger
    split
    · exact ⟨SeenStore.length_mark'_le hwf.seenBound _ _, hwf.detectBound, hwf.detectFresh,
        hwf.recentBound⟩
    · exact emit_wf hwf (pushSkeleton_timedAt now trig acct actorId) (by simp)
  have := (applyHydrate_wf (t0 := t0) (tEnd := tEnd)
    (wrapperId := trig.tweetId)
    (h := hydratedBody trig.tweetId (pushSkeleton now trig acct actorId) full trig.born now
      acct.tier) hwf1).detectFresh
  simpa [pushRound, handleTrigger_cfg] using this

end Tracker
