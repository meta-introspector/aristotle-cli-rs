import Mathlib

/-!
# Market quotes and the board a mesh node keeps

The mesh game collects market data.  The atom it collects is a **quote**: one
venue's reading of one token's price at one slot, together with the size behind
it.  Everything downstream — the chart, the report, the meme, the signed post —
is a function of a list of quotes, so this file fixes what a quote is and how
two nodes' collections are combined.

The combination is deliberately the simplest thing that can survive an
unreliable mesh: **set union**.  A node never deletes and never overwrites, so
merging is idempotent, commutative and associative (`merge_toFinset` plus the
three corollaries), which is exactly the condition under which peers that have
seen the same readings in different orders end up in the same state.  That is
the convergence used in `Mesh.Net`.

Because union keeps conflicting readings rather than resolving them, reading a
single number off a board is a separate, explicit step:

* `latest` — the highest-slot quote for a token, ties broken by a fixed total
  order on the remaining fields, so two nodes with the same board always print
  the same number;
* `vwap` — the size-weighted average price, which `vwap_mem_range` proves lies
  between the lowest and the highest price actually quoted, so a summary can
  never be outside the data it summarises.
-/

namespace Mesh

/-- One reading: venue `venue` saw `size` base units of token `token` trade at
`price` micro-units at slot `slot`.  All fields are naturals — no floating
point anywhere in this game, so every node computes the same numbers. -/
structure Quote where
  /-- Which token, as an index into the mesh's symbol table. -/
  token : Nat
  /-- Which venue reported it. -/
  venue : Nat
  /-- The chain slot (or unix millisecond) of the reading. -/
  slot : Nat
  /-- Price in micro-units of quote currency per whole token. -/
  price : Nat
  /-- Size behind the reading, in base units. -/
  size : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A node's collection of readings. -/
abbrev Board := List Quote

/-! ## Merging boards -/

/-- Merge two boards: keep everything, add nothing twice. -/
def merge (a b : Board) : Board := a ++ b.filter (fun q => !a.contains q)

@[simp] theorem mem_merge {a b : Board} {q : Quote} : q ∈ merge a b ↔ q ∈ a ∨ q ∈ b := by
  simp only [merge, List.mem_append, List.mem_filter, Bool.not_eq_true', List.contains_eq_mem,
    decide_eq_false_iff_not]
  by_cases h : q ∈ a <;> simp [h]

theorem merge_nodup {a b : Board} (ha : a.Nodup) (hb : b.Nodup) : (merge a b).Nodup := by
  refine List.Nodup.append ha (hb.filter _) ?_
  intro x hx hy
  simp only [List.mem_filter, Bool.not_eq_true', List.contains_eq_mem,
    decide_eq_false_iff_not] at hy
  exact hy.2 hx

/-- **A merge is a union.**  This is the equation every convergence statement
in the mesh is derived from. -/
@[simp] theorem merge_toFinset (a b : Board) :
    (merge a b).toFinset = a.toFinset ∪ b.toFinset := by
  ext q; simp

theorem merge_comm_toFinset (a b : Board) : (merge a b).toFinset = (merge b a).toFinset := by
  simp [Finset.union_comm]

theorem merge_assoc_toFinset (a b c : Board) :
    (merge (merge a b) c).toFinset = (merge a (merge b c)).toFinset := by
  simp [Finset.union_assoc]

theorem merge_idem_toFinset (a : Board) : (merge a a).toFinset = a.toFinset := by simp

theorem subset_merge_left (a b : Board) : a.toFinset ⊆ (merge a b).toFinset := by
  simp [Finset.subset_union_left]

theorem subset_merge_right (a b : Board) : b.toFinset ⊆ (merge a b).toFinset := by
  simp [Finset.subset_union_right]

theorem merge_mono {a a' b b' : Board} (ha : a.toFinset ⊆ a'.toFinset)
    (hb : b.toFinset ⊆ b'.toFinset) : (merge a b).toFinset ⊆ (merge a' b').toFinset := by
  simp only [merge_toFinset]
  exact Finset.union_subset_union ha hb

/-! ## Ingesting a live feed -/

/-- Fold a stream of readings — the realtime feed — into a board. -/
def ingest (b : Board) (stream : List Quote) : Board :=
  stream.foldl (fun acc q => merge acc [q]) b

/-- **Replay determinism.**  The board after a feed is the union of what was
there and what arrived, so two nodes that receive the same readings in any
order, with any duplication, hold the same board. -/
theorem ingest_toFinset (b : Board) (s : List Quote) :
    (ingest b s).toFinset = b.toFinset ∪ s.toFinset := by
  induction s generalizing b with
  | nil => simp [ingest]
  | cons q t ih =>
    simp only [ingest, List.foldl_cons] at *
    rw [ih (merge b [q])]
    simp

theorem ingest_nodup {b : Board} (hb : b.Nodup) (s : List Quote) : (ingest b s).Nodup := by
  induction s generalizing b with
  | nil => simpa [ingest] using hb
  | cons q t ih => exact ih (merge_nodup hb (by simp))

/-! ## Reading a number off a board -/

/-- Field bound: every field of a quote must fit in 64 bits for the ranking
below to be injective. -/
def bound : Nat := 18446744073709551616

/-- A quote is *well formed* when its fields fit the wire format. -/
def Quote.wf (q : Quote) : Bool :=
  q.token < bound && q.venue < bound && q.slot < bound && q.price < bound && q.size < bound

/-- The total ranking used to break ties: slot first, then venue, price, size,
and finally the token, so that the ranking is injective on well-formed
quotes. -/
def Quote.score (q : Quote) : Nat :=
  ((((q.slot * bound + q.venue) * bound + q.price) * bound + q.size) * bound) + q.token

/-- Splitting a two-field packing. -/
theorem pack_inj {B x v y w : Nat} (hv : v < B) (hw : w < B) (h : x * B + v = y * B + w) :
    x = y ∧ v = w := by
  constructor
  · have h1 : (x * B + v) / B = x := by
      rw [Nat.mul_comm, Nat.mul_add_div (by omega), Nat.div_eq_of_lt hv]; omega
    have h2 : (y * B + w) / B = y := by
      rw [Nat.mul_comm, Nat.mul_add_div (by omega), Nat.div_eq_of_lt hw]; omega
    rw [← h1, ← h2, h]
  · have h1 : (x * B + v) % B = v := by
      rw [Nat.mul_comm, Nat.mul_add_mod, Nat.mod_eq_of_lt hv]
    have h2 : (y * B + w) % B = w := by
      rw [Nat.mul_comm, Nat.mul_add_mod, Nat.mod_eq_of_lt hw]
    rw [← h1, ← h2, h]

theorem Quote.score_inj {q r : Quote} (hq : q.wf = true) (hr : r.wf = true)
    (h : q.score = r.score) : q = r := by
  simp only [Quote.wf, Bool.and_eq_true, decide_eq_true_eq] at hq hr
  obtain ⟨⟨⟨⟨hqt, hqv⟩, hqs⟩, hqp⟩, hqz⟩ := hq
  obtain ⟨⟨⟨⟨hrt, hrv⟩, hrs⟩, hrp⟩, hrz⟩ := hr
  simp only [Quote.score] at h
  obtain ⟨h0, htoken⟩ := pack_inj hqt hrt h
  obtain ⟨h1, hsize⟩ := pack_inj hqz hrz h0
  obtain ⟨h2, hprice⟩ := pack_inj hqp hrp h1
  obtain ⟨hslot, hvenue⟩ := pack_inj hqv hrv h2
  cases q; cases r
  simp_all

/-- The readings of one token. -/
def forToken (t : Nat) (b : Board) : Board := b.filter (fun q => q.token == t)

theorem mem_forToken {t : Nat} {b : Board} {q : Quote} :
    q ∈ forToken t b ↔ q ∈ b ∧ q.token = t := by
  simp [forToken]

/-- The current quote for a token: highest slot wins, ties broken by
`Quote.score`.  Deterministic, so two nodes holding the same board print the
same price. -/
def latest (t : Nat) (b : Board) : Option Quote := (forToken t b).argmax Quote.score

theorem latest_mem {t : Nat} {b : Board} {q : Quote} (h : latest t b = some q) :
    q ∈ b ∧ q.token = t :=
  mem_forToken.mp (List.argmax_mem h)

/-- **The printed price is the newest one on the board.**  Nothing on the board
outranks what `latest` returns. -/
theorem latest_max {t : Nat} {b : Board} {q r : Quote} (h : latest t b = some q)
    (hr : r ∈ b) (hrt : r.token = t) : r.score ≤ q.score :=
  List.le_of_mem_argmax (mem_forToken.mpr ⟨hr, hrt⟩) h

theorem latest_eq_none_iff {t : Nat} {b : Board} :
    latest t b = none ↔ ∀ q ∈ b, q.token ≠ t := by
  rw [latest, List.argmax_eq_none]
  simp [forToken, List.filter_eq_nil_iff]

/-- Merging can only move the printed price forward in the ranking: a node that
learns more never un-learns the newest quote it had. -/
theorem latest_score_mono {t : Nat} {a b : Board} {qa q : Quote}
    (ha : latest t a = some qa) (h : latest t (merge a b) = some q) : qa.score ≤ q.score :=
  latest_max h (by simp [(latest_mem ha).1]) (latest_mem ha).2

/-! ## Summaries that cannot lie about their data -/

/-- Total size quoted. -/
def totalSize (b : Board) : Nat := (b.map Quote.size).sum

/-- Size-weighted total value quoted, in micro-units. -/
def totalValue (b : Board) : Nat := (b.map (fun q => q.price * q.size)).sum

/-- Volume-weighted average price, floor-rounded to micro-units. -/
def vwap (b : Board) : Nat := totalValue b / totalSize b

theorem totalValue_lower {b : Board} {lo : Nat} (hlo : ∀ q ∈ b, lo ≤ q.price) :
    lo * totalSize b ≤ totalValue b := by
  induction b with
  | nil => simp [totalSize, totalValue]
  | cons q t ih =>
    simp only [totalSize, totalValue, List.map_cons, List.sum_cons, Nat.mul_add] at *
    have h1 : lo * q.size ≤ q.price * q.size := Nat.mul_le_mul_right _ (hlo q (by simp))
    have h2 := ih (fun r hr => hlo r (by simp [hr]))
    omega

theorem totalValue_upper {b : Board} {hi : Nat} (hhi : ∀ q ∈ b, q.price ≤ hi) :
    totalValue b ≤ hi * totalSize b := by
  induction b with
  | nil => simp [totalSize, totalValue]
  | cons q t ih =>
    simp only [totalSize, totalValue, List.map_cons, List.sum_cons, Nat.mul_add] at *
    have h1 : q.price * q.size ≤ hi * q.size := Nat.mul_le_mul_right _ (hhi q (by simp))
    have h2 := ih (fun r hr => hhi r (by simp [hr]))
    omega

/-- **A weighted average lies inside its data.**  If any size is quoted, the
VWAP is between the lowest and the highest price on the board — so a report
cannot quote an average outside the range it was computed from. -/
theorem vwap_mem_range {b : Board} {lo hi : Nat} (hpos : 0 < totalSize b)
    (hlo : ∀ q ∈ b, lo ≤ q.price) (hhi : ∀ q ∈ b, q.price ≤ hi) :
    lo ≤ vwap b ∧ vwap b ≤ hi := by
  have hL : lo * totalSize b ≤ totalValue b := totalValue_lower hlo
  have hH : totalValue b ≤ hi * totalSize b := totalValue_upper hhi
  exact ⟨(Nat.le_div_iff_mul_le hpos).mpr hL, Nat.div_le_of_le_mul (by simpa [Nat.mul_comm] using hH)⟩

end Mesh
