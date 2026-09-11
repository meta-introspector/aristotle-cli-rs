import Mathlib

/-!
# A Lean model of the Twitter-tracker event and post contract (`types.ts`)

This file mirrors the shared contract used by the TypeScript tracker: the post
record that flows through ingestion, the SSE envelope, and the ingest sources
that race to detect a post.

The model keeps every field that participates in *timing* or in *identity*
(id, author, kind, `createdAt`, `seenAt`, `detectMs`, `hydrateMs`, `partial`)
and abstracts purely presentational payloads (media urls, cards, avatars) away,
since no property proved here depends on them.

All times are milliseconds since the epoch, modelled as `ℕ`.  Natural
subtraction is truncating, which is exactly the `Math.max(0, a - b)` the
TypeScript code performs on every latency computation.
-/

namespace Tracker

/-- Where a post was first *seen*.  Two (or more) sources race; the winner is
recorded.  `feed` is the merged-timeline detector, `poll` the per-account
fallback, `push` the notification socket, `manual` a local injection. -/
inductive IngestSource
  | push | poll | feed | manual
  deriving DecidableEq, Repr, Inhabited

/-- The kinds of card the UI can render. -/
inductive TweetKind
  | tweet | reply | quote | retweet | profile | activity
  deriving DecidableEq, Repr, Inhabited

/-- Which provider path produced a record.  An opaque upstream label, not a
claim of independent providers. -/
inductive ProviderLane
  | fastStream | standardStream | immediateRest | timelineRecovery
  deriving DecidableEq, Repr, Inhabited

/-- Tiers are `1 | 2` upstream; here an out-of-range tier is simply never
produced by the model's constructors. -/
structure Author where
  userId : Option String := none
  handle : String
  name : String := ""
  tier : Option Nat := none
  deriving DecidableEq, Repr, Inhabited

/-- A tracked post.  Presentation-only fields of `TrackedTweet` are omitted;
`body` stands for the visible text so that "the push skeleton's truncated body"
and "the hydrated body" can be distinguished. -/
structure Tweet where
  id : String
  author : Author
  body : String := ""
  kind : TweetKind := TweetKind.tweet
  /-- For a repost: the id of the ORIGINAL post being reposted. -/
  refId : Option String := none
  /-- Author of a repost's original body; `author` stays the reposting actor. -/
  originalAuthor : Option Author := none
  /-- Id of a quoted post, when there is one. -/
  quotedId : Option String := none
  /-- Status id this post replies to, when it is a reply. -/
  replyToId : Option String := none
  /-- ms epoch the post was published (from the post itself). -/
  createdAt : Nat
  /-- ms epoch we first saw it. -/
  seenAt : Nat
  /-- `seenAt - createdAt`: the measured detection latency of this post. -/
  detectMs : Nat
  source : IngestSource
  /-- ms spent hydrating the body after the trigger fired. -/
  hydrateMs : Nat := 0
  /-- `true` while the body is still the push notification's truncated text. -/
  isPartial : Bool := false
  /-- Opaque upstream label, not a claim of independent providers. -/
  provider : Option String := none
  providerLane : Option ProviderLane := none
  deriving DecidableEq, Repr, Inhabited

/-- The measured detection latency of a post: `seenAt - createdAt`, floored at
zero exactly as `Math.max(0, now - createdAt)` does. -/
def Tweet.latency (t : Tweet) : Nat := t.seenAt - t.createdAt

/-- A post record whose reported `detectMs` really is the latency implied by
its own timestamps, and which was seen at time `now`.  Every constructor in the
model (poll, feed, push skeleton, hydrated body, manual injection) produces
records satisfying this predicate. -/
def Tweet.timedAt (now : Nat) (t : Tweet) : Prop :=
  t.seenAt = now ∧ t.detectMs = now - t.createdAt

theorem Tweet.detectMs_eq_latency {now : Nat} {t : Tweet} (h : t.timedAt now) :
    t.detectMs = t.latency := by
  obtain ⟨hs, hd⟩ := h
  simp [Tweet.latency, hs, hd]

/-- Server-sent envelope. -/
inductive Event
  /-- A new card. -/
  | tweet (t : Tweet)
  /-- A body upgrade for a card already on screen. -/
  | tweetUpdate (id : String) (createdAt detectMs hydrateMs : Nat) (isPartial : Bool)
  /-- The periodic status heartbeat. -/
  | status
  /-- Withdrawal of posts that became unavailable. -/
  | remove (ids : List String)
  deriving DecidableEq, Repr, Inhabited

/-- The post id an event addresses, when it addresses exactly one. -/
def Event.postId : Event → Option String
  | .tweet t => some t.id
  | .tweetUpdate id _ _ _ _ => some id
  | .status => none
  | .remove _ => none

/-- Is this event a new card (as opposed to an update/heartbeat/withdrawal)? -/
def Event.isCard : Event → Bool
  | .tweet _ => true
  | _ => false

end Tracker
