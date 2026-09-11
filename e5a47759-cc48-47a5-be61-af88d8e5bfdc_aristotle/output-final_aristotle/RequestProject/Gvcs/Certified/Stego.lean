import RequestProject.Gvcs.Certified.Crypto

/-!
# Certified mode, layer 3: carrying the moves inside a useful public feed

The transport for certified play is a **public data feed** that is worth
reading in its own right — a market feed of prices for the materials the game
(and the real workshop) buys: steel, fuel, bearings.  A player publishes his
feed update; the hidden strategy rides in the low-order noise digits of the
quantities he publishes.

The model here is deliberately blunt and completely explicit:

* a `Tick` is one published quantity, an integer in the smallest unit the feed
  quotes (say millionths of a currency unit);
* `coarse` is the part of that quantity readers actually consume — the value
  truncated to a multiple of 256 units, i.e. everything above the noise floor;
* `embedTick` overwrites the low-order byte with a payload digit.

What is proved:

* `extractTick_embedTick`, `extractFeed_embedFeed` — the payload comes back out
  exactly: the feed really is a channel.
* `coarse_embedTick`, `coarseFeed_embedFeed` — the *useful* content of the feed
  is bit-for-bit unchanged by carrying a payload.  The publisher is not
  degrading the public good he is contributing to.
* `embedTick_le`, `le_embedTick` — the distortion of any quantity is under one
  noise unit (255 out of 256 parts), and `embedTick_idem` — re-embedding does
  not accumulate error, so a feed can carry a payload every round for ever
  without drifting.
* `embedFeed_length`, `capacity` — one byte of strategy per published quantity:
  the channel's capacity is exactly the width of the feed.

The secrecy of what is carried comes from `RequestProject/Certified/Crypto.lean`
and is combined with this file in `RequestProject/Certified/Protocol.lean`.
-/

namespace LifeTrac
namespace Certified

/-- One published quantity of a public feed, in the smallest unit quoted. -/
structure Tick where
  /-- The quantity, as an integer number of the smallest published unit. -/
  value : ℕ
deriving DecidableEq, Repr, Inhabited

/-- A public feed update: a list of quantities. -/
abbrev Feed := List Tick

/-- The part of a quantity that readers of the feed consume: everything above
the noise floor of one byte. -/
def coarse (t : Tick) : ℕ := t.value / 256

/-- Write a payload digit into the noise floor of a quantity. -/
def embedTick (t : Tick) (d : Digit) : Tick := ⟨256 * (t.value / 256) + d.val⟩

/-- Read the noise floor of a quantity back as a payload digit. -/
def extractTick (t : Tick) : Digit := (t.value : Digit)

/-- **The channel works.** -/
@[simp] theorem extractTick_embedTick (t : Tick) (d : Digit) :
    extractTick (embedTick t d) = d := by
  have h256 : (256 : ZMod 256) = 0 := by decide
  simp [extractTick, embedTick, h256, ZMod.natCast_val, ZMod.cast_id]

/-- **The public content is untouched.**  Whatever is carried, the feed reports
exactly the same value above the noise floor. -/
@[simp] theorem coarse_embedTick (t : Tick) (d : Digit) : coarse (embedTick t d) = coarse t := by
  have hd : d.val < 256 := ZMod.val_lt d
  simp [coarse, embedTick, Nat.mul_add_div, Nat.div_eq_of_lt hd]

/-- The quantity published is never more than 255 units above the true one. -/
theorem embedTick_le (t : Tick) (d : Digit) : (embedTick t d).value ≤ t.value + 255 := by
  have hd : d.val < 256 := ZMod.val_lt d
  simp only [embedTick]
  omega

/-- …nor more than 255 units below it. -/
theorem le_embedTick (t : Tick) (d : Digit) : t.value ≤ (embedTick t d).value + 255 := by
  simp only [embedTick]
  omega

/-- **Error does not accumulate.**  Publishing over a quantity that already
carried a payload gives the same result as publishing over the true quantity:
a channel that runs for ever does not drift. -/
@[simp] theorem embedTick_idem (t : Tick) (d e : Digit) :
    embedTick (embedTick t d) e = embedTick t e := by
  have hd : d.val < 256 := ZMod.val_lt d
  simp [embedTick, Nat.mul_add_div, Nat.div_eq_of_lt hd]

/-! ## Whole feeds -/

/-- Carry a payload in a feed update, one digit per quantity.  Quantities
beyond the payload are published untouched; payload beyond the feed is not
carried (see `capacity`). -/
def embedFeed : Feed → List Digit → Feed
  | ts, [] => ts
  | [], _ :: _ => []
  | t :: ts, d :: ds => embedTick t d :: embedFeed ts ds

/-- Read the first `n` payload digits out of a feed update. -/
def extractFeed (f : Feed) (n : ℕ) : List Digit := (f.take n).map extractTick

@[simp] theorem embedFeed_nil_payload (f : Feed) : embedFeed f [] = f := by
  cases f <;> rfl

@[simp] theorem embedFeed_cons (t : Tick) (ts : Feed) (d : Digit) (ds : List Digit) :
    embedFeed (t :: ts) (d :: ds) = embedTick t d :: embedFeed ts ds := rfl

/-- The feed keeps its shape: readers cannot even tell how much is carried. -/
@[simp] theorem embedFeed_length (f : Feed) (c : List Digit) :
    (embedFeed f c).length = f.length := by
  induction f generalizing c with
  | nil => cases c <;> rfl
  | cons t ts ih => cases c with
    | nil => rfl
    | cons d ds => simp [ih]

/-- **The payload comes back.** -/
theorem extractFeed_embedFeed {f : Feed} {c : List Digit} (h : c.length ≤ f.length) :
    extractFeed (embedFeed f c) c.length = c := by
  induction f generalizing c with
  | nil => cases c with
    | nil => rfl
    | cons d ds => simp at h
  | cons t ts ih =>
      cases c with
      | nil => rfl
      | cons d ds =>
          simp only [List.length_cons, Nat.add_le_add_iff_right] at h
          simp only [embedFeed_cons, extractFeed, List.length_cons, List.take_succ_cons,
            List.map_cons, extractTick_embedTick]
          exact congrArg _ (ih h)

/-- **The feed stays as useful as it was.**  Quantity by quantity, everything
above the noise floor is exactly what the publisher measured. -/
theorem coarseFeed_embedFeed (f : Feed) (c : List Digit) :
    (embedFeed f c).map coarse = f.map coarse := by
  induction f generalizing c with
  | nil => cases c <;> rfl
  | cons t ts ih => cases c with
    | nil => rfl
    | cons d ds => simp [ih]

/-- **Capacity.**  A feed update of `n` quantities carries exactly `n` bytes of
strategy: a payload of that size round-trips, and there is no room for more. -/
theorem capacity (f : Feed) (c : List Digit) (h : c.length ≤ f.length) :
    extractFeed (embedFeed f c) c.length = c ∧ (embedFeed f c).length = f.length :=
  ⟨extractFeed_embedFeed h, embedFeed_length f c⟩

/-- **Quote by quote, the distortion is under one noise unit.**  Whatever is
carried, every published quantity is within 255 of the true one. -/
theorem embedFeed_distortion (f : Feed) (c : List Digit) (i : ℕ) (t u : Tick)
    (ht : f[i]? = some t) (hu : (embedFeed f c)[i]? = some u) :
    u.value ≤ t.value + 255 ∧ t.value ≤ u.value + 255 := by
  induction f generalizing c i with
  | nil => simp at ht
  | cons x xs ih =>
      cases c with
      | nil =>
          rw [embedFeed_nil_payload, ht] at hu
          have htu := Option.some.inj hu
          subst htu
          omega
      | cons d ds =>
          cases i with
          | zero =>
              simp only [List.getElem?_cons_zero, Option.some.injEq, embedFeed_cons] at ht hu
              subst ht; subst hu
              exact ⟨embedTick_le x d, le_embedTick x d⟩
          | succ i =>
              simp only [List.getElem?_cons_succ, embedFeed_cons] at ht hu
              exact ih ds i ht hu

/-- Payload beyond the width of the feed is simply not carried. -/
theorem embedFeed_truncates (f : Feed) (c : List Digit) (h : f.length < c.length) :
    (embedFeed f c).length < c.length := by
  rw [embedFeed_length]; exact h

end Certified
end LifeTrac
