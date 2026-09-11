import RequestProject.Tracker.Emit

/-!
# The provider path: product updates, age allowances and the recent ring

This file models the timing-critical parts of the TwitterAPI.io primary path:

* `ProviderStreamDelivery.emit` — every version of a post (fast-stream preview,
  standard-stream body, REST completion, recovery body) is stamped with the
  **first receipt** of that post: `seenAt = firstAt`, `detectMs = firstAt -
  createdAt`, `hydrateMs = now - firstAt`.  Later versions therefore cannot
  make the latency look better or worse than the moment the event arrived.
* `providerProductUpdate` (`provider-primary.ts`) — an in-place card update
  keeps the previous receipt time, recomputes the latency against it, never
  lets `hydrateMs` go backwards and never downgrades a complete body to a
  partial one.
* `providerPostAgeLimit` — deferred timeline-recovery records get an age
  allowance wide enough that they are not discarded as stale by the very delay
  that made them recovery records.
* `retainProviderRecent` — the bounded reload cache, where late recovery
  records are ordered by publication time so that they evict the oldest entry
  rather than a newer live card.
-/

namespace Tracker

/-- The upstream label the primary path stamps on its records. -/
def providerStreamLabel : String := "twitterapi_io_stream"

/-- Is this a deferred timeline-recovery record? -/
def isRecoveryLane (t : Tweet) : Bool :=
  t.provider == some providerStreamLabel && t.providerLane == some ProviderLane.timelineRecovery

/-! ## Stream delivery stamps every version with the first receipt -/

/-- `ProviderStreamDelivery.emit`: shape an outgoing version of a post that was
first received at `firstAt` and finished being assembled at `now`. -/
def deliveryOutgoing (firstAt now : Nat) (post : Tweet) : Tweet :=
  { post with
    provider := some providerStreamLabel
    seenAt := firstAt
    detectMs := firstAt - post.createdAt
    hydrateMs := now - firstAt }

/-- Latency is measured from the first receipt of the event, whatever version
is being published. -/
@[simp] theorem deliveryOutgoing_seenAt (firstAt now : Nat) (post : Tweet) :
    (deliveryOutgoing firstAt now post).seenAt = firstAt := rfl

theorem deliveryOutgoing_timedAt (firstAt now : Nat) (post : Tweet) :
    (deliveryOutgoing firstAt now post).timedAt firstAt := ⟨rfl, rfl⟩

/-- Two versions of the same event report the same detection latency: the
preview and the completed body cannot disagree about when it arrived. -/
theorem deliveryOutgoing_detect_stable {firstAt now₁ now₂ : Nat} {preview complete : Tweet}
    (h : preview.createdAt = complete.createdAt) :
    (deliveryOutgoing firstAt now₁ preview).detectMs =
      (deliveryOutgoing firstAt now₂ complete).detectMs := by
  simp [deliveryOutgoing, h]

/-! ## `providerProductUpdate` -/

/-- An in-place update of a card already on screen.  `none` means the incoming
record is rejected. -/
def providerProductUpdate (previous incoming : Tweet) : Option Tweet :=
  if previous.id ≠ incoming.id then none
  else if incoming.provider ≠ some providerStreamLabel then none
  else if previous.author.userId ≠ none ∧ incoming.author.userId ≠ none ∧
      previous.author.userId ≠ incoming.author.userId then none
  else if previous.isPartial = false ∧ incoming.isPartial = true then none
  else some
    { incoming with
      seenAt := previous.seenAt
      detectMs := previous.seenAt - incoming.createdAt
      hydrateMs := max previous.hydrateMs incoming.hydrateMs }

theorem providerProductUpdate_eq {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) :
    next = { incoming with
             seenAt := previous.seenAt
             detectMs := previous.seenAt - incoming.createdAt
             hydrateMs := max previous.hydrateMs incoming.hydrateMs } := by
  unfold providerProductUpdate at h
  split_ifs at h
  simp_all

/-- An accepted update addresses exactly the same card. -/
theorem providerProductUpdate_id {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) : next.id = previous.id := by
  have hid : ¬ previous.id ≠ incoming.id := by
    unfold providerProductUpdate at h
    split_ifs at h with h1
    simp_all
  rw [providerProductUpdate_eq h]
  simpa using (not_not.mp hid).symm

/-- **The receipt clock never moves.**  An update keeps the original `seenAt`,
so a slow body cannot rewrite when the event was detected. -/
@[simp] theorem providerProductUpdate_seenAt {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) : next.seenAt = previous.seenAt := by
  rw [providerProductUpdate_eq h]

/-- The refreshed latency is measured against that same original receipt. -/
theorem providerProductUpdate_detect {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) :
    next.detectMs = previous.seenAt - incoming.createdAt := by
  rw [providerProductUpdate_eq h]

theorem providerProductUpdate_createdAt {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) :
    next.createdAt = incoming.createdAt := by
  rw [providerProductUpdate_eq h]

/-- Consequently the updated card is still self-consistent about its timing. -/
theorem providerProductUpdate_timedAt {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) : next.timedAt previous.seenAt := by
  refine ⟨providerProductUpdate_seenAt h, ?_⟩
  rw [providerProductUpdate_detect h, providerProductUpdate_createdAt h]

/-- Hydration time never goes backwards. -/
theorem providerProductUpdate_hydrate_mono {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) :
    previous.hydrateMs ≤ next.hydrateMs ∧ incoming.hydrateMs ≤ next.hydrateMs := by
  rw [providerProductUpdate_eq h]
  exact ⟨le_max_left _ _, le_max_right _ _⟩

/-- A complete body is never replaced by a preview. -/
theorem providerProductUpdate_no_downgrade {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) (hp : next.isPartial = true) :
    previous.isPartial = true := by
  have hin : incoming.isPartial = true := by rw [providerProductUpdate_eq h] at hp; simpa using hp
  by_contra hprev
  have : previous.isPartial = false := by simpa using hprev
  unfold providerProductUpdate at h
  split_ifs at h with h1 h2 h3 h4
  all_goals simp_all

/-- Only records the primary provider produced can update a card. -/
theorem providerProductUpdate_provider {previous incoming next : Tweet}
    (h : providerProductUpdate previous incoming = some next) :
    incoming.provider = some providerStreamLabel := by
  unfold providerProductUpdate at h
  split_ifs at h with h1 h2
  simp_all

/-! ## Age allowance for deferred recovery records -/

/-- `providerPostAgeLimit`: the ordinary cap, widened only for deferred
timeline-recovery records. -/
def providerPostAgeLimit (t : Tweet) (normalMaxMs : Nat) : Nat :=
  if isRecoveryLane t then max (max normalMaxMs 210000) ((t.seenAt - t.createdAt) + 30000)
  else normalMaxMs

/-- The allowance is never narrower than the ordinary cap. -/
theorem le_providerPostAgeLimit (t : Tweet) (normalMaxMs : Nat) :
    normalMaxMs ≤ providerPostAgeLimit t normalMaxMs := by
  unfold providerPostAgeLimit
  split
  · exact le_trans (le_max_left _ _) (le_max_left _ _)
  · exact le_refl _

/-- Ordinary live records get no extra allowance whatsoever. -/
theorem providerPostAgeLimit_of_live {t : Tweet} (h : isRecoveryLane t = false)
    (normalMaxMs : Nat) : providerPostAgeLimit t normalMaxMs = normalMaxMs := by
  simp [providerPostAgeLimit, h]

/-- **A deferred recovery record is never discarded by the delay that made it
one.**  At its own receipt time its age is strictly inside its allowance, with
thirty seconds of headroom to publish. -/
theorem recovery_not_stale {t : Tweet} (h : isRecoveryLane t = true) (normalMaxMs : Nat) :
    ¬ isStale (providerPostAgeLimit t normalMaxMs) t.seenAt t := by
  rw [not_stale_iff]
  simp only [providerPostAgeLimit, age, h, if_true]
  exact le_trans (Nat.le_add_right _ 30000) (le_max_right _ _)

/-! ## The bounded recent ring -/

/-- The ordering key of the reload cache: publication time, falling back to
receipt time when the record carries none. -/
def recentKey (t : Tweet) : Nat := if t.createdAt = 0 then t.seenAt else t.createdAt

/-- `retainProviderRecent`: append, order late recovery records by publication
time, then evict from the front down to `maximum`. -/
def retainRecent (maximum : Nat) (rows : List Tweet) (row : Tweet) : List Tweet :=
  let appended := rows ++ [row]
  let ordered :=
    if isRecoveryLane row then appended.mergeSort (fun a b => decide (recentKey a ≤ recentKey b))
    else appended
  ordered.drop (ordered.length - maximum)

/-- The reload cache is bounded. -/
theorem length_retainRecent_le (maximum : Nat) (rows : List Tweet) (row : Tweet) :
    (retainRecent maximum rows row).length ≤ maximum := by
  unfold retainRecent
  simp only [List.length_drop]
  split <;> omega

/-- For ordinary live records insertion is exactly the bounded ring append. -/
theorem retainRecent_of_live {row : Tweet} (h : isRecoveryLane row = false) (maximum : Nat)
    (rows : List Tweet) : retainRecent maximum rows row = pushBounded maximum rows row := by
  simp [retainRecent, pushBounded, h]

/-- Whatever is evicted is at least as old as everything retained: a late
recovery record is placed by publication time, so it cannot displace a newer
live card — at worst it displaces itself. -/
theorem retainRecent_evicts_oldest {row : Tweet} (h : isRecoveryLane row = true) {maximum : Nat}
    {rows : List Tweet} {x y : Tweet}
    (hx : x ∈ ((rows ++ [row]).mergeSort fun a b => decide (recentKey a ≤ recentKey b)).take
      (rows.length + 1 - maximum))
    (hy : y ∈ retainRecent maximum rows row) : recentKey x ≤ recentKey y := by
  set k := rows.length + 1 - maximum with hk
  set ordered := (rows ++ [row]).mergeSort (fun a b => decide (recentKey a ≤ recentKey b))
    with hord
  have hlen : ordered.length = rows.length + 1 := by simp [hord]
  have hsorted : ordered.Pairwise (fun a b => recentKey a ≤ recentKey b) := by
    have := List.pairwise_mergeSort (le := fun a b => decide (recentKey a ≤ recentKey b))
      (by intro a b c hab hbc; simp_all; omega) (by intro a b; simp; omega) (rows ++ [row])
    simpa [hord] using this
  have hsorted' : (ordered.take k ++ ordered.drop k).Pairwise
      (fun a b => recentKey a ≤ recentKey b) := by
    rw [List.take_append_drop]; exact hsorted
  have hy' : y ∈ ordered.drop k := by
    simpa [retainRecent, h, hord, hlen, hk] using hy
  exact (List.pairwise_append.mp hsorted').2.2 x hx y hy'

end Tracker
