import Mathlib

/-!
# Interleaving of QR codeword blocks

The formal counterpart of `addEccAndInterleave` in `web/js/qr.js` — the
encoder behind the share dialog's QR code — and of the reader in
`tests/node/check_qr.py`.

A QR symbol splits its codewords into `blocks` Reed-Solomon blocks.  The first
`short` of them hold one data codeword less than the others, so the standard
lays the final message out as if every block had `shortLen + 1` slots, the short
blocks carrying one unused *pad slot* at index `shortLen - ecc` — exactly
between their data and their error-correction codewords — and then reads the
slots one index at a time across all blocks, skipping those pad slots.

Getting that skip wrong silently drops a codeword.  This file rules that out:
`slots` lists every real slot exactly once (`mem_slots`, `slots_nodup`), the
message has the length the symbol reserves (`length_slots_add_short`,
`length_slots`), and reading the interleaved stream back recovers every block's
codewords (`deinterleave_interleave`).
-/

namespace Hesper.QR

/-- The block geometry of a QR symbol at a given version and error level. -/
structure Layout where
  /-- Number of Reed-Solomon blocks. -/
  blocks : ℕ
  /-- Total codewords in a *short* block (data + error correction). -/
  shortLen : ℕ
  /-- Error-correction codewords per block. -/
  ecc : ℕ
  /-- How many of the blocks are short; the remaining ones hold one more. -/
  short : ℕ
  /-- There is at least one block. -/
  blocks_pos : 0 < blocks
  /-- The short blocks are among the blocks. -/
  short_le : short ≤ blocks
  /-- A block is at least as long as its error-correction part. -/
  ecc_le : ecc ≤ shortLen

namespace Layout

variable (L : Layout)

/-- Index of the slot the short blocks leave unused. -/
def padIndex : ℕ := L.shortLen - L.ecc

/-- Slot `i` of block `j` is a pad slot: it exists only in the long blocks. -/
def IsPad (j i : ℕ) : Prop := i = L.padIndex ∧ j < L.short

instance (j i : ℕ) : Decidable (L.IsPad j i) := by unfold IsPad; infer_instance

/--
The order in which the final message visits the slots: for each slot index
`i ≤ shortLen`, every block `j` in turn, skipping the pad slots.
-/
def slots : List (ℕ × ℕ) :=
  (List.range (L.shortLen + 1)).flatMap fun i =>
    ((List.range L.blocks).filter fun j => !decide (L.IsPad j i)).map fun j => (j, i)

/-- Interleave the blocks — block `j`'s slot `i` holding `B j i` — into the
final message. -/
def interleave {α : Type*} (B : ℕ → ℕ → α) : List α :=
  (L.slots).map fun p => B p.1 p.2

/-- Read one slot back out of an interleaved stream, as a decoder does. -/
def deinterleave {α : Type*} (stream : List α) (j i : ℕ) : Option α :=
  if (j, i) ∈ L.slots then stream[List.idxOf (j, i) L.slots]? else none

end Layout

variable {L : Layout}

/-- Of the first `n` blocks, all but the `s` short ones survive the filter. -/
private theorem length_filter_not_lt (n s : ℕ) :
    ((List.range n).filter fun j => !decide (j < s)).length = n - s := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [List.range_succ, List.filter_append, List.length_append, ih]
    by_cases h : m < s <;> simp [h] <;> omega

/-- The message visits exactly the slots that exist: every block, every index
up to `shortLen`, minus the short blocks' pad slot. -/
@[simp] theorem mem_slots {j i : ℕ} :
    (j, i) ∈ L.slots ↔ j < L.blocks ∧ i ≤ L.shortLen ∧ ¬ L.IsPad j i := by
  classical
  simp only [Layout.slots, List.mem_flatMap, List.mem_map, List.mem_filter, List.mem_range,
    Prod.mk.injEq]
  constructor
  · rintro ⟨i', hi', j', ⟨hj, hpad⟩, rfl, rfl⟩
    exact ⟨hj, by omega, by simpa using hpad⟩
  · rintro ⟨hj, hi, hpad⟩
    exact ⟨i, by omega, j, ⟨hj, by simpa using hpad⟩, rfl, rfl⟩

/-- No codeword is emitted twice. -/
theorem slots_nodup : (L.slots).Nodup := by
  classical
  rw [Layout.slots, List.nodup_flatMap]
  refine ⟨fun i _ => ((List.nodup_range).filter _).map (fun a b hab => by simpa using hab), ?_⟩
  refine List.nodup_range.imp (fun {i i'} hne => ?_)
  simp only [Function.onFun, List.disjoint_left, List.mem_map, List.mem_filter]
  rintro p ⟨j, -, rfl⟩ ⟨j', -, hj'⟩
  simp at hj'
  exact hne hj'.2.symm

/-- The message is one codeword short of `blocks * (shortLen + 1)` for each
short block — stated without truncated subtraction. -/
theorem length_slots_add_short :
    (L.slots).length + L.short = L.blocks * (L.shortLen + 1) := by
  classical
  have hcount : ∀ i ∈ List.range (L.shortLen + 1),
      (((List.range L.blocks).filter fun j => !decide (L.IsPad j i)).map fun j => (j, i)).length
        = if i = L.padIndex then L.blocks - L.short else L.blocks := by
    intro i _
    rw [List.length_map]
    by_cases hi : i = L.padIndex
    · have hfilter : ((List.range L.blocks).filter fun j => !decide (L.IsPad j i))
          = (List.range L.blocks).filter fun j => !decide (j < L.short) :=
        List.filter_congr fun j _ => by simp [Layout.IsPad, hi]
      rw [hfilter, if_pos hi, length_filter_not_lt]
    · have hfilter : ((List.range L.blocks).filter fun j => !decide (L.IsPad j i))
          = List.range L.blocks :=
        List.filter_eq_self.mpr fun j _ => by simp [Layout.IsPad, hi]
      rw [hfilter, if_neg hi, List.length_range]
  have hsum : ∀ n : ℕ,
      ((List.range (n + 1)).map fun i => if i = L.padIndex then L.blocks - L.short else L.blocks).sum
        + (if L.padIndex ≤ n then L.short else 0) = (n + 1) * L.blocks := by
    have hs : L.short ≤ L.blocks := L.short_le
    intro n
    induction n with
    | zero => by_cases h : L.padIndex = 0 <;> simp [h] <;> omega
    | succ m ih =>
      have hmul : (m + 1 + 1) * L.blocks = (m + 1) * L.blocks + L.blocks := by ring
      rw [List.range_succ, List.map_append, List.sum_append, hmul]
      by_cases h : m + 1 = L.padIndex
      · have h1 : ¬ L.padIndex ≤ m := by omega
        simp only [h1, if_pos h, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
          add_zero] at ih ⊢
        simp [h, le_refl] at ih ⊢
        omega
      · by_cases h2 : L.padIndex ≤ m
        · have h3 : L.padIndex ≤ m + 1 := by omega
          simp only [h2, h3, if_pos, if_neg h, List.map_cons, List.map_nil, List.sum_cons,
            List.sum_nil, add_zero] at ih ⊢
          omega
        · have h3 : ¬ L.padIndex ≤ m + 1 := by omega
          simp only [h2, h3, if_neg h, List.map_cons, List.map_nil, List.sum_cons,
            List.sum_nil, add_zero, if_false] at ih ⊢
          omega
  have hpad : L.padIndex ≤ L.shortLen := by simp [Layout.padIndex]
  have := hsum L.shortLen
  rw [if_pos hpad] at this
  rw [Layout.slots, List.length_flatMap, List.map_congr_left hcount, this]
  ring

/-- The interleaved message has exactly the number of codewords the symbol
reserves for data and error correction. -/
theorem length_slots :
    (L.slots).length = L.blocks * (L.shortLen + 1) - L.short := by
  have := length_slots_add_short (L := L)
  omega

@[simp] theorem length_interleave {α : Type*} (B : ℕ → ℕ → α) :
    (L.interleave B).length = (L.slots).length := by
  simp [Layout.interleave]

/-- **Reading the message back recovers the blocks.**  Every slot that exists is
found again holding its own codeword, and the pad slots hold nothing. -/
theorem deinterleave_interleave {α : Type*} (B : ℕ → ℕ → α) (j i : ℕ) :
    L.deinterleave (L.interleave B) j i =
      if (j, i) ∈ L.slots then some (B j i) else none := by
  classical
  unfold Layout.deinterleave Layout.interleave
  by_cases h : (j, i) ∈ L.slots
  · simp only [h, if_pos, List.getElem?_map, List.getElem?_idxOf h]
    rfl
  · simp [h]

/-- The same statement in the shape the decoder uses: a real slot of a real
block comes back unchanged. -/
theorem deinterleave_interleave_of_valid {α : Type*} (B : ℕ → ℕ → α) {j i : ℕ}
    (hj : j < L.blocks) (hi : i ≤ L.shortLen) (hpad : ¬ L.IsPad j i) :
    L.deinterleave (L.interleave B) j i = some (B j i) := by
  rw [deinterleave_interleave, if_pos (mem_slots.mpr ⟨hj, hi, hpad⟩)]

/-- Nothing is read out of a pad slot. -/
theorem deinterleave_interleave_pad {α : Type*} (B : ℕ → ℕ → α) {j i : ℕ}
    (hpad : L.IsPad j i) :
    L.deinterleave (L.interleave B) j i = none := by
  rw [deinterleave_interleave, if_neg]
  simpa using fun _ _ => hpad

end Hesper.QR
