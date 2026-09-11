import Mathlib
import RequestProject.AZ.TenfoldWay

/-!
# Classifying an item into an Altland–Zirnbauer symmetry class

`RequestProject.AZ.TenfoldWay` builds the ten Altland–Zirnbauer (AZ) classes as an
inductive type `AZ.Class`, each carrying its symmetry data `(T², C², S)`.

This file provides the *operational* side of the model: a set of **predicates and
checks** that take some concrete item — described by its symmetry data — and decide
which (if any) of the ten classes it belongs to.

The data of an item is packaged as `AZ.SymData`:
* `tSq`   — the square of the time–reversal operator `T² ∈ {-1, 0, +1}` (`0` = absent),
* `cSq`   — the square of the particle–hole operator `C² ∈ {-1, 0, +1}` (`0` = absent),
* `chiral`— the chiral / sublattice flag `S ∈ {0, 1}` (`1` = present).

We provide:

* `AZ.SymData.ofClass` — the canonical data attached to each class.
* `AZ.SymData.IsClass c s` — the predicate "item `s` is in class `c`", and its decidability.
* `AZ.SymData.InRange`, `AZ.SymData.Consistent`, `AZ.SymData.Valid` — the *checks* that
  an item's data is a physically admissible AZ pattern.
* `AZ.SymData.classOf` — the classifier: a total function returning `some c` if the item
  belongs to class `c`, and `none` otherwise.
* `AZ.HasSymData` — a typeclass letting *any* type be mapped into the classes via
  `AZ.classOfItem`.

The main correctness results are:

* `classOf_ofClass` — the classifier recovers each class from its own data.
* `classOf_eq_some_iff` — `classOf s = some c ↔ s = ofClass c` (soundness + the
  characterisation of when a class is assigned).
* `isSome_classOf_iff_valid` — the classifier succeeds **exactly** on valid data:
  `(classOf s).isSome ↔ Valid s`.
* `valid_iff_exists_class` — the validity check accepts exactly the data that arise
  from one of the ten classes.
* `IsClass_classOf` and `exists_unique_class_of_valid` — every valid item lies in
  one and only one class.
-/

namespace AZ

open Class

/-- The non-spatial symmetry data of an item:
the square of time-reversal `T² = tSq ∈ {-1,0,1}`, the square of particle-hole
`C² = cSq ∈ {-1,0,1}`, and the chiral flag `S = chiral ∈ {0,1}` (`0` = symmetry
absent in each case). -/
structure SymData where
  /-- `T²`, the square of the (antiunitary) time-reversal operator; `0` means absent. -/
  tSq : ℤ
  /-- `C²`, the square of the (antiunitary) particle-hole operator; `0` means absent. -/
  cSq : ℤ
  /-- `S`, the chiral/sublattice flag; `1` = present, `0` = absent. -/
  chiral : ℕ
deriving DecidableEq, Repr

namespace SymData

/-- The canonical symmetry data attached to an Altland–Zirnbauer class. -/
def ofClass (c : Class) : SymData :=
  { tSq := c.trs, cSq := c.phs, chiral := c.chiral }

@[simp] theorem ofClass_tSq (c : Class) : (ofClass c).tSq = c.trs := rfl
@[simp] theorem ofClass_cSq (c : Class) : (ofClass c).cSq = c.phs := rfl
@[simp] theorem ofClass_chiral (c : Class) : (ofClass c).chiral = c.chiral := rfl

/-! ## The per-class membership predicate -/

/-- `IsClass c s` is the predicate "the item with symmetry data `s` belongs to the
Altland–Zirnbauer class `c`", i.e. its `(T², C², S)` data matches that of `c`. -/
def IsClass (c : Class) (s : SymData) : Prop :=
  s = ofClass c

instance (c : Class) (s : SymData) : Decidable (IsClass c s) := by
  unfold IsClass; infer_instance

theorem IsClass_iff (c : Class) (s : SymData) :
    IsClass c s ↔ s.tSq = c.trs ∧ s.cSq = c.phs ∧ s.chiral = c.chiral := by
  constructor
  · rintro rfl; exact ⟨rfl, rfl, rfl⟩
  · rintro ⟨h1, h2, h3⟩
    cases s; cases h1; cases h2; cases h3; rfl

/-! ## Admissibility checks -/

/-- *Range check.* The three data lie in their physical ranges:
`T², C² ∈ {-1, 0, 1}` and `S ∈ {0, 1}`. -/
def InRange (s : SymData) : Prop :=
  (s.tSq = -1 ∨ s.tSq = 0 ∨ s.tSq = 1) ∧
  (s.cSq = -1 ∨ s.cSq = 0 ∨ s.cSq = 1) ∧
  (s.chiral = 0 ∨ s.chiral = 1)

instance (s : SymData) : Decidable (InRange s) := by unfold InRange; infer_instance

/-- *Consistency check.* The chiral symmetry `S` is forced by the presence/absence
of `T` and `C`: present when both are present, absent when exactly one is present.
(When both `T` and `C` are absent, `S` is free — classes `A` and `AIII`.) -/
def Consistent (s : SymData) : Prop :=
  (s.tSq ≠ 0 → s.cSq ≠ 0 → s.chiral = 1) ∧
  (s.tSq ≠ 0 → s.cSq = 0 → s.chiral = 0) ∧
  (s.tSq = 0 → s.cSq ≠ 0 → s.chiral = 0)

instance (s : SymData) : Decidable (Consistent s) := by unfold Consistent; infer_instance

/-- *Validity check.* An item's data is a physically admissible Altland–Zirnbauer
pattern iff it passes both the range and consistency checks. -/
def Valid (s : SymData) : Prop := InRange s ∧ Consistent s

instance (s : SymData) : Decidable (Valid s) := by unfold Valid; infer_instance

/-! ## The classifier -/

/-- The classifier: map an item, described by its symmetry data, to the unique
Altland–Zirnbauer class it belongs to (returning `none` for inadmissible data). -/
def classOf (s : SymData) : Option Class :=
  match s.tSq, s.cSq, s.chiral with
  | 0, 0, 0 => some Class.A
  | 0, 0, 1 => some Class.AIII
  | 1, 0, 0 => some Class.AI
  | 1, 1, 1 => some Class.BDI
  | 0, 1, 0 => some Class.D
  | -1, 1, 1 => some Class.DIII
  | -1, 0, 0 => some Class.AII
  | -1, -1, 1 => some Class.CII
  | 0, -1, 0 => some Class.C
  | 1, -1, 1 => some Class.CI
  | _, _, _ => none

/-! ## Correctness of the classifier -/

/-- The classifier recovers each class from its own canonical data. -/
@[simp] theorem classOf_ofClass (c : Class) : classOf (ofClass c) = some c := by
  cases c <;> rfl

/-- **Soundness and characterisation.** The classifier returns `some c` exactly when
the item's data is the canonical data of class `c`. -/
theorem classOf_eq_some_iff (s : SymData) (c : Class) :
    classOf s = some c ↔ s = ofClass c := by
  constructor
  · cases s
    unfold classOf; aesop
  · aesop

/-- If the classifier returns a class, the item genuinely belongs to it. -/
theorem IsClass_classOf {s : SymData} {c : Class} (h : classOf s = some c) :
    IsClass c s := (classOf_eq_some_iff s c).1 h

/-- The validity check accepts exactly the data realised by one of the ten classes. -/
theorem valid_iff_exists_class (s : SymData) :
    Valid s ↔ ∃ c : Class, ofClass c = s := by
  constructor
  · rintro ⟨⟨ht, hc, hs⟩, h₁, h₂, h₃⟩
    rcases ht with (ht | ht | ht) <;> rcases hc with (hc | hc | hc) <;>
      rcases hs with (hs | hs) <;> simp_all +decide only
    all_goals cases s; simp_all +decide
  · rintro ⟨c, rfl⟩; cases c <;> decide

/-- **The classifier succeeds exactly on valid data.** -/
theorem isSome_classOf_iff_valid (s : SymData) :
    (classOf s).isSome ↔ Valid s := by
  grind +suggestions

/-- Distinct classes never share the same data: the assignment of canonical data is
injective, so the classification is unambiguous. -/
theorem ofClass_injective : Function.Injective ofClass := by
  intro a b h
  have h1 : classOf (ofClass a) = classOf (ofClass b) := by rw [h]
  rw [classOf_ofClass, classOf_ofClass] at h1
  exact Option.some.inj h1

/-- **Every valid item lies in one and only one class.** -/
theorem exists_unique_class_of_valid {s : SymData} (h : Valid s) :
    ∃! c : Class, IsClass c s := by
  obtain ⟨c, hc⟩ : ∃ c : Class, s = ofClass c :=
    ⟨_, Eq.symm (Classical.choose_spec ((valid_iff_exists_class s).1 h))⟩
  refine ⟨c, hc, ?_⟩
  intro y hy
  exact ofClass_injective (hy.symm.trans hc)

end SymData

/-! ## Classifying arbitrary items

Any type `α` equipped with a way to read off its symmetry data can be mapped into
the ten classes. -/

/-- A typeclass packaging "this item type carries Altland–Zirnbauer symmetry data". -/
class HasSymData (α : Type*) where
  /-- The non-spatial symmetry data of the item. -/
  symData : α → SymData

/-- Map an item of any type with symmetry data into its Altland–Zirnbauer class. -/
def classOfItem {α : Type*} [HasSymData α] (a : α) : Option Class :=
  SymData.classOf (HasSymData.symData a)

/-- An item carries valid AZ symmetry data when its underlying data passes the
validity check. -/
def IsValidItem {α : Type*} [HasSymData α] (a : α) : Prop :=
  SymData.Valid (HasSymData.symData a)

/-- For items, the classifier succeeds exactly on the valid ones. -/
theorem isSome_classOfItem_iff_valid {α : Type*} [HasSymData α] (a : α) :
    (classOfItem a).isSome ↔ IsValidItem a :=
  SymData.isSome_classOf_iff_valid _

/-- A `Class` is itself an item, via its canonical symmetry data. -/
instance : HasSymData Class where
  symData := SymData.ofClass

@[simp] theorem classOfItem_class (c : Class) : classOfItem c = some c :=
  SymData.classOf_ofClass c

end AZ