import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# A verified model of ComputerCraft-style inventory item transfer

This file formalises the core operation performed by item-moving programs for
Minecraft mod platforms (a "hopper"): moving items from a slot of a source
inventory into a slot of a destination inventory, respecting the per-item
stack limit of the destination slot and the amount actually present in the
source slot.

The main results are:

* `Hopper.transfer_conserves` — item transfer conserves, for *every* item type,
  the combined number of items held by the source and the destination.
* `Hopper.transfer_valid` — transfer preserves the invariant that no slot holds
  more items than the stack limit allows.
* `Hopper.transfer_maximal` — the transfer is greedy: afterwards either the
  request has been fully served, or the source slot has been drained, or the
  destination slot is full.
-/

namespace Hopper

/-- Item identifiers (e.g. `"minecraft:cobblestone"`). -/
abbrev Item := String

/-- A stack of items: an item identifier together with a count. -/
structure Stack where
  item : Item
  count : ℕ
deriving DecidableEq, Repr

/-- A slot is either empty or holds a stack. -/
abbrev Slot := Option Stack

/-- An inventory is a finite list of slots. -/
abbrev Inventory := List Slot

/-- The number of items of type `it` held in a single slot. -/
def slotCountOf (it : Item) (s : Slot) : ℕ :=
  match s with
  | none => 0
  | some st => if st.item = it then st.count else 0

/-- The total number of items held in a slot, whatever their type. -/
def slotSize (s : Slot) : ℕ :=
  match s with
  | none => 0
  | some st => st.count

/-- The number of items of type `it` held in an inventory. -/
def countOf (inv : Inventory) (it : Item) : ℕ :=
  (inv.map (slotCountOf it)).sum

/-- How many more items of type `it` the slot `s` can accept, given the stack
limit function `limit`. -/
def freeSpace (limit : Item → ℕ) (it : Item) (s : Slot) : ℕ :=
  match s with
  | none => limit it
  | some st => if st.item = it then limit it - st.count else 0

/-- Insert `k` items of type `it` into a slot. -/
def pushSlot (it : Item) (k : ℕ) (s : Slot) : Slot :=
  if k = 0 then s else
    match s with
    | none => some ⟨it, k⟩
    | some st => if st.item = it then some ⟨it, st.count + k⟩ else some st

/-- Remove `k` items from a slot; the slot becomes empty if it is drained. -/
def popSlot (k : ℕ) (s : Slot) : Slot :=
  match s with
  | none => none
  | some st => if st.count ≤ k then none else some ⟨st.item, st.count - k⟩

/-- The number of items actually moved by a transfer request of `req` items
from slot `i` of `src` to slot `j` of `dst`: the minimum of what is present,
what is requested, and what fits. -/
def amountMoved (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) : ℕ :=
  match src.getD i none with
  | none => 0
  | some st => min (min st.count req) (freeSpace limit st.item (dst.getD j none))

/-- One transfer step: move up to `req` items from slot `i` of `src` into slot
`j` of `dst`, returning the updated pair of inventories. -/
def transfer (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) : Inventory × Inventory :=
  match src.getD i none with
  | none => (src, dst)
  | some st =>
      let k := amountMoved limit src i dst j req
      (src.set i (popSlot k (src.getD i none)),
       dst.set j (pushSlot st.item k (dst.getD j none)))

/-- A slot is valid when it does not exceed the stack limit of its item. -/
def ValidSlot (limit : Item → ℕ) (s : Slot) : Prop :=
  ∀ st : Stack, s = some st → st.count ≤ limit st.item

/-- An inventory is valid when all of its slots are. -/
def Valid (limit : Item → ℕ) (inv : Inventory) : Prop :=
  ∀ s ∈ inv, ValidSlot limit s

/-! ### Bookkeeping lemmas about lists of slots -/

theorem getD_set_self (l : Inventory) (i : ℕ) (hi : i < l.length) (s : Slot) :
    (l.set i s).getD i none = s := by
  rw [List.getD_eq_getElem _ _ (by simpa using hi), List.getElem_set_self]

theorem mem_of_getD_eq_some {l : Inventory} {i : ℕ} {st : Stack}
    (h : l.getD i none = some st) : (some st) ∈ l := by
  by_cases hi : i < l.length
  · rw [List.getD_eq_getElem l none hi] at h
    exact h ▸ List.getElem_mem hi
  · rw [List.getD_eq_default l none (by omega)] at h
    exact absurd h (by simp)

/-- Updating one entry of a list changes the sum of a `ℕ`-valued function over it
exactly by the difference at that entry. -/
theorem sum_map_set {α : Type} (f : α → ℕ) (l : List α) (i : ℕ) (hi : i < l.length)
    (d x : α) : ((l.set i x).map f).sum + f (l.getD i d) = (l.map f).sum + f x := by
  induction l generalizing i with
  | nil => simp at hi
  | cons a t ih =>
    cases i with
    | zero => simp [List.getD]; ring
    | succ n =>
      have hn : n < t.length := by simpa using hi
      have h2 := ih n hn
      have hg : (a :: t).getD (n + 1) d = t.getD n d := by
        simp [List.getD, List.getElem?_cons_succ]
      simp only [List.set_cons_succ, List.map_cons, List.sum_cons, hg]
      omega

theorem getD_set_ne {α : Type} (l : List α) {a b : ℕ} (h : a ≠ b) (x d : α) :
    (l.set a x).getD b d = l.getD b d := by
  simp [List.getD, List.getElem?_set_ne h]

theorem countOf_set (l : Inventory) (i : ℕ) (hi : i < l.length) (s : Slot) (it : Item) :
    countOf (l.set i s) it + slotCountOf it (l.getD i none)
      = countOf l it + slotCountOf it s :=
  sum_map_set (slotCountOf it) l i hi none s

/-! ### Behaviour of the slot operations -/

theorem slotCountOf_popSlot_of_le (it : Item) (st : Stack) (k : ℕ)
    (hk : k ≤ st.count) (h : st.item = it) :
    slotCountOf it (popSlot k (some st)) + k = slotCountOf it (some st) := by
  subst h
  simp only [popSlot, slotCountOf]
  by_cases hc : st.count ≤ k <;> simp [hc] <;> omega

theorem slotCountOf_popSlot_other (it : Item) (st : Stack) (k : ℕ)
    (h : st.item ≠ it) :
    slotCountOf it (popSlot k (some st)) = slotCountOf it (some st) := by
  simp only [popSlot, slotCountOf]
  by_cases hc : st.count ≤ k <;> simp [hc, h]

theorem slotCountOf_pushSlot_self (limit : Item → ℕ) (it : Item) (k : ℕ) (s : Slot)
    (hk : k ≤ freeSpace limit it s) :
    slotCountOf it (pushSlot it k s) = slotCountOf it s + k := by
  cases s with
  | none => by_cases hk0 : k = 0 <;> simp [pushSlot, slotCountOf, hk0]
  | some st =>
    by_cases hk0 : k = 0
    · simp [pushSlot, hk0]
    · by_cases hs : st.item = it
      · simp [pushSlot, slotCountOf, hk0, hs]
      · simp only [freeSpace, if_neg hs] at hk
        omega

theorem freeSpace_pushSlot_self (limit : Item → ℕ) (it : Item) (k : ℕ) (s : Slot)
    (hk : k ≤ freeSpace limit it s) :
    freeSpace limit it (pushSlot it k s) + k = freeSpace limit it s := by
  cases s with
  | none =>
    by_cases hk0 : k = 0
    · simp [pushSlot, hk0]
    · simp only [freeSpace] at hk
      simp [pushSlot, hk0, freeSpace]
      omega
  | some st =>
    by_cases hk0 : k = 0
    · simp [pushSlot, hk0]
    · by_cases hs : st.item = it
      · simp only [freeSpace, if_pos hs] at hk
        simp [pushSlot, hk0, hs, freeSpace]
        omega
      · simp only [freeSpace, if_neg hs] at hk
        omega

theorem slotCountOf_pushSlot_other (it it' : Item) (k : ℕ) (s : Slot)
    (h : it ≠ it') :
    slotCountOf it' (pushSlot it k s) = slotCountOf it' s := by
  cases s with
  | none => by_cases hk0 : k = 0 <;> simp [pushSlot, slotCountOf, hk0, h]
  | some st =>
    by_cases hk0 : k = 0
    · simp [pushSlot, hk0]
    · by_cases hs : st.item = it
      · subst hs; simp [pushSlot, slotCountOf, hk0, h]
      · simp [pushSlot, slotCountOf, hk0, hs]

theorem validSlot_popSlot (limit : Item → ℕ) (k : ℕ) (s : Slot)
    (hs : ValidSlot limit s) : ValidSlot limit (popSlot k s) := by
  cases s with
  | none => intro st h; simp [popSlot] at h
  | some st0 =>
    intro st h
    simp only [popSlot] at h
    by_cases hc : st0.count ≤ k
    · rw [if_pos hc] at h; exact absurd h (by simp)
    · rw [if_neg hc] at h
      have h0 : st0.count ≤ limit st0.item := hs st0 rfl
      cases h
      simpa using by omega

theorem validSlot_pushSlot (limit : Item → ℕ) (it : Item) (k : ℕ) (s : Slot)
    (hk : k ≤ freeSpace limit it s) (hs : ValidSlot limit s) :
    ValidSlot limit (pushSlot it k s) := by
  cases s with
  | none =>
    intro st h
    simp only [pushSlot] at h
    by_cases hk0 : k = 0
    · rw [if_pos hk0] at h; exact absurd h (by simp)
    · rw [if_neg hk0] at h
      simp only [freeSpace] at hk
      cases h
      simpa using hk
  | some st0 =>
    intro st h
    simp only [pushSlot] at h
    by_cases hk0 : k = 0
    · rw [if_pos hk0] at h; exact hs st h
    · rw [if_neg hk0] at h
      by_cases hi : st0.item = it
      · rw [if_pos hi] at h
        simp only [freeSpace, if_pos hi] at hk
        have h0 : st0.count ≤ limit st0.item := hs st0 rfl
        cases h
        simp only []
        rw [hi] at h0
        omega
      · rw [if_neg hi] at h
        exact hs st h

/-! ### Unfolding lemmas for `transfer` -/

theorem transfer_of_none (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (h : src.getD i none = none) :
    transfer limit src i dst j req = (src, dst) := by
  simp only [transfer, h]

theorem transfer_of_some (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (st : Stack) (h : src.getD i none = some st) :
    transfer limit src i dst j req =
      (src.set i (popSlot (amountMoved limit src i dst j req) (some st)),
       dst.set j (pushSlot st.item (amountMoved limit src i dst j req)
          (dst.getD j none))) := by
  simp only [transfer, h]

theorem amountMoved_of_some (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (st : Stack) (h : src.getD i none = some st) :
    amountMoved limit src i dst j req
      = min (min st.count req) (freeSpace limit st.item (dst.getD j none)) := by
  simp only [amountMoved, h]

theorem amountMoved_of_none (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (h : src.getD i none = none) :
    amountMoved limit src i dst j req = 0 := by
  simp only [amountMoved, h]

/-! ### Main results -/

/-- The number of items moved never exceeds the request. -/
theorem amountMoved_le_req (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) :
    amountMoved limit src i dst j req ≤ req := by
  cases h : src.getD i none with
  | none => simp [amountMoved_of_none limit src i dst j req h]
  | some st => rw [amountMoved_of_some limit src i dst j req st h]; omega

/-- The number of items moved never exceeds what is in the source slot. -/
theorem amountMoved_le_available (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) :
    amountMoved limit src i dst j req ≤ slotSize (src.getD i none) := by
  cases h : src.getD i none with
  | none => simp [amountMoved_of_none limit src i dst j req h]
  | some st =>
    rw [amountMoved_of_some limit src i dst j req st h]
    simp only [slotSize]
    omega

/-- The number of items moved never exceeds the free space in the target slot. -/
theorem amountMoved_le_freeSpace (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (st : Stack) (h : src.getD i none = some st) :
    amountMoved limit src i dst j req ≤ freeSpace limit st.item (dst.getD j none) := by
  rw [amountMoved_of_some limit src i dst j req st h]
  omega

/-- **Conservation.** A transfer moves items around but creates and destroys
nothing: for every item type, the total held by source and destination
together is unchanged. -/
theorem transfer_conserves (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (it : Item)
    (hi : i < src.length) (hj : j < dst.length) :
    countOf (transfer limit src i dst j req).1 it
        + countOf (transfer limit src i dst j req).2 it
      = countOf src it + countOf dst it := by
  cases h : src.getD i none with
  | none => rw [transfer_of_none limit src i dst j req h]
  | some st =>
    rw [transfer_of_some limit src i dst j req st h]
    dsimp only
    set k := amountMoved limit src i dst j req with hk
    have hsrcset := countOf_set src i hi (popSlot k (some st)) it
    have hdstset := countOf_set dst j hj (pushSlot st.item k (dst.getD j none)) it
    rw [h] at hsrcset
    have hkc : k ≤ st.count := by
      have := amountMoved_le_available limit src i dst j req
      rw [h] at this
      simpa [slotSize] using this
    have hkf : k ≤ freeSpace limit st.item (dst.getD j none) :=
      amountMoved_le_freeSpace limit src i dst j req st h
    by_cases hit : st.item = it
    · have hpop : slotCountOf it (popSlot k (some st)) + k = slotCountOf it (some st) :=
        slotCountOf_popSlot_of_le it st k hkc hit
      have hpush : slotCountOf it (pushSlot st.item k (dst.getD j none))
          = slotCountOf it (dst.getD j none) + k := by
        subst hit
        exact slotCountOf_pushSlot_self limit st.item k (dst.getD j none) hkf
      omega
    · have hpop : slotCountOf it (popSlot k (some st)) = slotCountOf it (some st) :=
        slotCountOf_popSlot_other it st k hit
      have hpush : slotCountOf it (pushSlot st.item k (dst.getD j none))
          = slotCountOf it (dst.getD j none) :=
        slotCountOf_pushSlot_other st.item it k (dst.getD j none) hit
      omega

/-- **Safety.** A transfer never overfills a slot: validity of both inventories
is preserved. -/
theorem transfer_valid (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ)
    (hsrc : Valid limit src) (hdst : Valid limit dst) :
    Valid limit (transfer limit src i dst j req).1 ∧
      Valid limit (transfer limit src i dst j req).2 := by
  cases h : src.getD i none with
  | none => rw [transfer_of_none limit src i dst j req h]; exact ⟨hsrc, hdst⟩
  | some st =>
    rw [transfer_of_some limit src i dst j req st h]
    set k := amountMoved limit src i dst j req with hk
    have hsrcslot : ValidSlot limit (some st) := hsrc _ (mem_of_getD_eq_some h)
    have hdstslot : ValidSlot limit (dst.getD j none) := by
      cases hd : dst.getD j none with
      | none => intro st' h'; simp at h'
      | some st' => exact hdst _ (mem_of_getD_eq_some hd)
    have hkf : k ≤ freeSpace limit st.item (dst.getD j none) :=
      amountMoved_le_freeSpace limit src i dst j req st h
    constructor
    · intro s hs
      rcases List.mem_or_eq_of_mem_set hs with hs' | hs'
      · exact hsrc s hs'
      · exact hs' ▸ validSlot_popSlot limit k (some st) hsrcslot
    · intro s hs
      rcases List.mem_or_eq_of_mem_set hs with hs' | hs'
      · exact hdst s hs'
      · exact hs' ▸ validSlot_pushSlot limit st.item k (dst.getD j none) hkf hdstslot

/-- **Greediness.** After a transfer, either the whole request has been served,
or the source slot has been drained, or the destination slot is full. -/
theorem transfer_maximal (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) (st : Stack)
    (hst : src.getD i none = some st)
    (hi : i < src.length) (hj : j < dst.length) :
    amountMoved limit src i dst j req = req ∨
      slotSize ((transfer limit src i dst j req).1.getD i none) = 0 ∨
      freeSpace limit st.item ((transfer limit src i dst j req).2.getD j none) = 0 := by
  rw [transfer_of_some limit src i dst j req st hst]
  dsimp only
  set k := amountMoved limit src i dst j req with hk
  have hkeq : k = min (min st.count req) (freeSpace limit st.item (dst.getD j none)) := by
    rw [hk, amountMoved_of_some limit src i dst j req st hst]
  have hcase : k = req ∨ st.count ≤ k ∨ freeSpace limit st.item (dst.getD j none) ≤ k := by
    omega
  rcases hcase with hc | hc | hc
  · exact Or.inl hc
  · refine Or.inr (Or.inl ?_)
    rw [getD_set_self src i hi]
    simp [popSlot, slotSize, hc]
  · refine Or.inr (Or.inr ?_)
    rw [getD_set_self dst j hj]
    have hkf : k ≤ freeSpace limit st.item (dst.getD j none) := by omega
    have hbal := freeSpace_pushSlot_self limit st.item k (dst.getD j none) hkf
    omega

/-! ### Iterated transfer: a whole hopper run

A hopper program does not perform a single move: it runs through a *plan*, a
list of `(source slot, destination slot, requested amount)` triples.  The
results above lift to arbitrary plans. -/

theorem transfer_length_fst (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) :
    (transfer limit src i dst j req).1.length = src.length := by
  cases h : src.getD i none with
  | none => rw [transfer_of_none limit src i dst j req h]
  | some st => rw [transfer_of_some limit src i dst j req st h]; simp

theorem transfer_length_snd (limit : Item → ℕ) (src : Inventory) (i : ℕ)
    (dst : Inventory) (j : ℕ) (req : ℕ) :
    (transfer limit src i dst j req).2.length = dst.length := by
  cases h : src.getD i none with
  | none => rw [transfer_of_none limit src i dst j req h]
  | some st => rw [transfer_of_some limit src i dst j req st h]; simp

/-- Run a whole plan of transfers, each entry being
`(source slot, destination slot, requested amount)`. -/
def transferAll (limit : Item → ℕ) (plan : List (ℕ × ℕ × ℕ))
    (src dst : Inventory) : Inventory × Inventory :=
  match plan with
  | [] => (src, dst)
  | p :: rest =>
      let q := transfer limit src p.1 dst p.2.1 p.2.2
      transferAll limit rest q.1 q.2

theorem transferAll_length (limit : Item → ℕ) (plan : List (ℕ × ℕ × ℕ))
    (src dst : Inventory) :
    (transferAll limit plan src dst).1.length = src.length ∧
      (transferAll limit plan src dst).2.length = dst.length := by
  induction plan generalizing src dst with
  | nil => exact ⟨rfl, rfl⟩
  | cons p rest ih =>
    obtain ⟨h1, h2⟩ := ih (transfer limit src p.1 dst p.2.1 p.2.2).1
      (transfer limit src p.1 dst p.2.1 p.2.2).2
    refine ⟨?_, ?_⟩
    · rw [transferAll]
      rw [h1, transfer_length_fst]
    · rw [transferAll]
      rw [h2, transfer_length_snd]

/-- **Conservation for a whole run.** Running any plan of transfers preserves,
for every item type, the combined contents of source and destination. -/
theorem transferAll_conserves (limit : Item → ℕ) (plan : List (ℕ × ℕ × ℕ))
    (src dst : Inventory) (it : Item)
    (hplan : ∀ p ∈ plan, p.1 < src.length ∧ p.2.1 < dst.length) :
    countOf (transferAll limit plan src dst).1 it
        + countOf (transferAll limit plan src dst).2 it
      = countOf src it + countOf dst it := by
  induction plan generalizing src dst with
  | nil => rfl
  | cons p rest ih =>
    obtain ⟨hp1, hp2⟩ := hplan p (by simp)
    have hstep := transfer_conserves limit src p.1 dst p.2.1 p.2.2 it hp1 hp2
    have hlen1 := transfer_length_fst limit src p.1 dst p.2.1 p.2.2
    have hlen2 := transfer_length_snd limit src p.1 dst p.2.1 p.2.2
    have hrest : ∀ r ∈ rest,
        r.1 < (transfer limit src p.1 dst p.2.1 p.2.2).1.length ∧
          r.2.1 < (transfer limit src p.1 dst p.2.1 p.2.2).2.length := by
      intro r hr
      obtain ⟨h1, h2⟩ := hplan r (by simp [hr])
      exact ⟨by rw [hlen1]; exact h1, by rw [hlen2]; exact h2⟩
    have := ih (transfer limit src p.1 dst p.2.1 p.2.2).1
      (transfer limit src p.1 dst p.2.1 p.2.2).2 hrest
    rw [transferAll]
    omega

/-- **Safety for a whole run.** Running any plan of transfers preserves the
stack-limit invariant. -/
theorem transferAll_valid (limit : Item → ℕ) (plan : List (ℕ × ℕ × ℕ))
    (src dst : Inventory) (hsrc : Valid limit src) (hdst : Valid limit dst) :
    Valid limit (transferAll limit plan src dst).1 ∧
      Valid limit (transferAll limit plan src dst).2 := by
  induction plan generalizing src dst with
  | nil => exact ⟨hsrc, hdst⟩
  | cons p rest ih =>
    obtain ⟨h1, h2⟩ := transfer_valid limit src p.1 dst p.2.1 p.2.2 hsrc hdst
    have := ih (transfer limit src p.1 dst p.2.1 p.2.2).1
      (transfer limit src p.1 dst p.2.1 p.2.2).2 h1 h2
    rw [transferAll]
    exact this

/-! ### Networks of inventories

A network (a set of peripherals wired together) is a list of inventories; a
network step moves items between two *distinct* members of the network. -/

/-- A network is a list of inventories. -/
abbrev Network := List Inventory

/-- The number of items of type `it` held anywhere in the network. -/
def netCount (net : Network) (it : Item) : ℕ :=
  (net.map (fun inv => countOf inv it)).sum

/-- Move up to `req` items from slot `i` of network member `a` to slot `j` of
network member `b`.  Self-transfer is a no-op. -/
def netTransfer (limit : Item → ℕ) (net : Network) (a i b j req : ℕ) : Network :=
  if a = b then net else
    let p := transfer limit (net.getD a []) i (net.getD b []) j req
    (net.set a p.1).set b p.2

/-- A network is valid when each of its inventories is. -/
def NetValid (limit : Item → ℕ) (net : Network) : Prop :=
  ∀ inv ∈ net, Valid limit inv

theorem netCount_set (net : Network) (a : ℕ) (ha : a < net.length) (inv : Inventory)
    (it : Item) :
    netCount (net.set a inv) it + countOf (net.getD a []) it
      = netCount net it + countOf inv it :=
  sum_map_set (fun l => countOf l it) net a ha [] inv

/-- **Network conservation.** Moving items between two distinct members of a
network leaves the total amount of every item in the network unchanged. -/
theorem netTransfer_conserves (limit : Item → ℕ) (net : Network) (a i b j req : ℕ)
    (it : Item) (hab : a ≠ b) (ha : a < net.length) (hb : b < net.length)
    (hi : i < (net.getD a []).length) (hj : j < (net.getD b []).length) :
    netCount (netTransfer limit net a i b j req) it = netCount net it := by
  have hstep := transfer_conserves limit (net.getD a []) i (net.getD b []) j req it hi hj
  set p := transfer limit (net.getD a []) i (net.getD b []) j req with hp
  have h1 := netCount_set net a ha p.1 it
  have hb' : b < (net.set a p.1).length := by simpa using hb
  have h2 := netCount_set (net.set a p.1) b hb' p.2 it
  rw [getD_set_ne net hab p.1 []] at h2
  have hnt : netTransfer limit net a i b j req = (net.set a p.1).set b p.2 := by
    simp only [netTransfer, if_neg hab, hp]
  rw [hnt]
  omega

/-- **Network safety.** A network step preserves the stack-limit invariant. -/
theorem netTransfer_valid (limit : Item → ℕ) (net : Network) (a i b j req : ℕ)
    (hnet : NetValid limit net) :
    NetValid limit (netTransfer limit net a i b j req) := by
  by_cases hab : a = b
  · simpa [netTransfer, hab] using hnet
  · have hva : Valid limit (net.getD a []) := by
      by_cases ha : a < net.length
      · exact hnet _ (by rw [List.getD_eq_getElem net [] ha]; exact List.getElem_mem ha)
      · rw [List.getD_eq_default net [] (by omega)]
        intro s hs; simp at hs
    have hvb : Valid limit (net.getD b []) := by
      by_cases hb : b < net.length
      · exact hnet _ (by rw [List.getD_eq_getElem net [] hb]; exact List.getElem_mem hb)
      · rw [List.getD_eq_default net [] (by omega)]
        intro s hs; simp at hs
    obtain ⟨h1, h2⟩ := transfer_valid limit (net.getD a []) i (net.getD b []) j req hva hvb
    simp only [netTransfer, if_neg hab]
    intro inv hinv
    rcases List.mem_or_eq_of_mem_set hinv with hinv' | hinv'
    · rcases List.mem_or_eq_of_mem_set hinv' with hinv'' | hinv''
      · exact hnet inv hinv''
      · exact hinv'' ▸ h1
    · exact hinv' ▸ h2

end Hopper
