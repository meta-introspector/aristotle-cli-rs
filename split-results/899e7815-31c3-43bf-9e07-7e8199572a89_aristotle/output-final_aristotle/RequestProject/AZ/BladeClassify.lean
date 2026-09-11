import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification
import RequestProject.AZ.CliffordK

/-!
# Classifying Clifford blades, and the self-reflection of this implementation

This file adds two capabilities on top of the Altland–Zirnbauer (AZ) tenfold-way
model and its Clifford / K-theory front-end (`RequestProject.AZ.CliffordK`).

## 1. Feeding in vectors of different sizes ("blades")

A `Blade` is a finite vector of integer coefficients **of arbitrary length** together
with a flag recording whether it lives over the complex or the real ground field.
Geometrically a blade of a Clifford algebra `Cl_{p,q}` is built from generators
squaring to `+1` (recorded as a positive coefficient) or `-1` (a negative coefficient);
zero coefficients are degenerate directions and are ignored.  The relevant homotopy
invariant is the **Clifford degree** `q - p`.

* `Blade` — an arbitrary-length integer vector + a complex/real flag.
* `Blade.signature`, `Blade.degree` — the Clifford signature `Cl_{p,q}` and degree.
* `Blade.nearestClass` — **classify a blade as the closest element of the model**:
  the AZ class whose Bott-clock position matches the blade's degree
  (mod 8 for real blades, mod 2 for complex blades).
* `cdist8` / `cdist2` — circular (Bott-clock) distances, with the theorems
  `nearestClass_dist_zero` (the nearest class has distance `0`) and
  `nearestClass_le` (it minimises the distance over the whole model).

## 2. Classifying the implementation's own self-reflection

The implementation can describe *itself* as data: each AZ class is reflected into the
blade `selfBlade c` carrying its own Clifford signature.  Re-classifying that blade
recovers the class (`nearestClass_selfBlade`), so the model classifies its own
self-description faithfully.

We then define when two periodic-table "models" are **weakly equivalent**
(`WeakEquiv`: they have the same non-triviality pattern in every dimension), show it
is an equivalence relation, and prove the **self-reflection theorem**
`implModel_weakEquiv_classify`: the impl model obtained by classifying every class's
own self-blade and reading off the table is weakly equivalent to — in fact equal to —
the original periodic table.  The bridge to the Clifford front-end
(`implModel_eq_classifyViaClifford`) closes the loop.
-/

namespace AZ

open Class

/-! ## 1. Blades: arbitrary-length vectors over a Clifford algebra -/

/-- A **blade**: a finite vector of integer coefficients of *arbitrary length*,
together with a flag saying whether it lives over the complex (`true`) or real
(`false`) ground field.  A positive coefficient marks a generator squaring to `+1`,
a negative one a generator squaring to `-1`, and `0` a degenerate direction. -/
structure Blade where
  /-- The coefficient vector; its length may be anything. -/
  coeffs : List ℤ
  /-- Whether the blade lives over the complex ground field. -/
  complex : Bool := false
deriving DecidableEq, Repr

namespace Blade

/-- The number of generators squaring to `+1` (the `p` of `Cl_{p,q}`). -/
def pCount (b : Blade) : ℕ := (b.coeffs.filter (fun x => 0 < x)).length

/-- The number of generators squaring to `-1` (the `q` of `Cl_{p,q}`). -/
def qCount (b : Blade) : ℕ := (b.coeffs.filter (fun x => x < 0)).length

/-- The Clifford signature `Cl_{p,q}` extracted from a blade. -/
def signature (b : Blade) : ClIndex := ⟨(b.pCount : ℤ), (b.qCount : ℤ)⟩

/-- The Clifford degree `q - p` of a blade — the invariant driving Bott periodicity. -/
def degree (b : Blade) : ℤ := b.signature.degree

@[simp] theorem degree_eq (b : Blade) : b.degree = (b.qCount : ℤ) - (b.pCount : ℤ) := rfl

end Blade

/-! ## Reading an AZ class off a Bott-clock position -/

/-- The real class sitting at position `n` on the `ℤ₈` Bott clock (inverse of
`Class.realIndex` on the eight real classes). -/
def fromIndex8 (n : ZMod 8) : Class :=
  if n = 0 then AI else if n = 1 then BDI else if n = 2 then D
  else if n = 3 then DIII else if n = 4 then AII else if n = 5 then CII
  else if n = 6 then C else CI

/-- The complex class sitting at position `n` on the `ℤ₂` Bott clock. -/
def fromIndex2 (n : ZMod 2) : Class :=
  if n = 0 then A else AIII

/-- `fromIndex8` is a genuine inverse to `realIndex`: it lands on the class with the
prescribed Bott-clock position. -/
@[simp] theorem realIndex_fromIndex8 (n : ZMod 8) : (fromIndex8 n).realIndex = n := by
  revert n; decide

/-- `fromIndex2` is a genuine inverse to `complexIndex`. -/
@[simp] theorem complexIndex_fromIndex2 (n : ZMod 2) : (fromIndex2 n).complexIndex = n := by
  revert n; decide

/-- `fromIndex8` always produces a real class. -/
@[simp] theorem isComplex_fromIndex8 (n : ZMod 8) : (fromIndex8 n).isComplex = false := by
  revert n; decide

/-- `fromIndex2` always produces a complex class. -/
@[simp] theorem isComplex_fromIndex2 (n : ZMod 2) : (fromIndex2 n).isComplex = true := by
  revert n; decide

/-! ## Classifying a blade as the closest element of the model -/

/-- **Classify a blade as the closest element of the model.**  A real blade is sent to
the real class whose `ℤ₈` Bott position equals its Clifford degree; a complex blade to
the complex class whose `ℤ₂` Bott position equals its degree. -/
def Blade.nearestClass (b : Blade) : Class :=
  if b.complex then fromIndex2 (b.degree : ZMod 2) else fromIndex8 (b.degree : ZMod 8)

/-- Circular ("Bott-clock") distance on `ℤ₈`. -/
def cdist8 (a b : ZMod 8) : ℕ := min (a - b).val (b - a).val

/-- Circular ("Bott-clock") distance on `ℤ₂`. -/
def cdist2 (a b : ZMod 2) : ℕ := min (a - b).val (b - a).val

@[simp] theorem cdist8_self (a : ZMod 8) : cdist8 a a = 0 := by simp [cdist8]

@[simp] theorem cdist2_self (a : ZMod 2) : cdist2 a a = 0 := by simp [cdist2]

/-- The `ℤ₈` circular distance vanishes exactly on equal points. -/
theorem cdist8_eq_zero_iff (a b : ZMod 8) : cdist8 a b = 0 ↔ a = b := by
  revert a b; decide

/-- `fromIndex8` inverts `realIndex` on the real classes. -/
theorem fromIndex8_realIndex (c : Class) (hc : c.isComplex = false) :
    fromIndex8 c.realIndex = c := by
  revert hc; cases c <;> decide

/-- The Bott-clock distance from a real blade to a real class. -/
def Blade.distToReal (b : Blade) (c : Class) : ℕ := cdist8 (b.degree : ZMod 8) c.realIndex

/-- The Bott-clock distance from a complex blade to a complex class. -/
def Blade.distToComplex (b : Blade) (c : Class) : ℕ := cdist2 (b.degree : ZMod 2) c.complexIndex

/-- For a real blade, the chosen nearest class has distance `0`. -/
theorem Blade.nearestClass_dist_zero_real (b : Blade) (hb : b.complex = false) :
    b.distToReal b.nearestClass = 0 := by
  simp [Blade.distToReal, Blade.nearestClass, hb]

/-- For a complex blade, the chosen nearest class has distance `0`. -/
theorem Blade.nearestClass_dist_zero_complex (b : Blade) (hb : b.complex = true) :
    b.distToComplex b.nearestClass = 0 := by
  simp [Blade.distToComplex, Blade.nearestClass, hb]

/-- **Minimality (real case).** No real class is closer to a real blade than the
class chosen by `nearestClass`. -/
theorem Blade.nearestClass_le_real (b : Blade) (hb : b.complex = false) (c : Class) :
    b.distToReal b.nearestClass ≤ b.distToReal c := by
  rw [b.nearestClass_dist_zero_real hb]; exact Nat.zero_le _

/-- **Minimality (complex case).** No complex class is closer to a complex blade than
the class chosen by `nearestClass`. -/
theorem Blade.nearestClass_le_complex (b : Blade) (hb : b.complex = true) (c : Class) :
    b.distToComplex b.nearestClass ≤ b.distToComplex c := by
  rw [b.nearestClass_dist_zero_complex hb]; exact Nat.zero_le _

/-- **Uniqueness of the closest real class.**  A real class is at distance `0` from a
real blade iff it is the class chosen by `nearestClass`. -/
theorem Blade.distToReal_eq_zero_iff (b : Blade) (hb : b.complex = false) (c : Class)
    (hc : c.isComplex = false) :
    b.distToReal c = 0 ↔ c = b.nearestClass := by
  constructor
  · intro h
    have heq : (b.degree : ZMod 8) = c.realIndex := (cdist8_eq_zero_iff _ _).1 h
    rw [Blade.nearestClass, if_neg (by simp [hb]), heq, fromIndex8_realIndex c hc]
  · rintro rfl; exact b.nearestClass_dist_zero_real hb

/-- Read off the classifying group of a blade in spatial dimension `d` by classifying
it and consulting the periodic table. -/
def Blade.kGroup (b : Blade) (d : ℕ) : KGroup := classify b.nearestClass d

/-! ## 2. The implementation's self-reflection -/

/-- The **self-reflection** of an AZ class as a blade: a vector with `q` generators
squaring to `-1` and `p` generators squaring to `+1`, carrying the class's own Clifford
signature and ground field. -/
def selfBlade (c : Class) : Blade where
  coeffs := List.replicate (clIndexOfClass c).q.toNat (-1 : ℤ)
            ++ List.replicate (clIndexOfClass c).p.toNat (1 : ℤ)
  complex := c.isComplex

/-- The self-blade of a class carries exactly that class's Clifford degree. -/
theorem selfBlade_degree (c : Class) : (selfBlade c).degree = (clIndexOfClass c).degree := by
  cases c <;> decide

/-- **The model classifies its own self-description faithfully.**  Re-classifying the
self-blade of a class recovers the class. -/
@[simp] theorem nearestClass_selfBlade (c : Class) : (selfBlade c).nearestClass = c := by
  cases c <;> decide

/-! ## Weak equivalence of periodic-table models -/

/-- A **periodic-table model** is any assignment of a classifying group to each class in
each spatial dimension. -/
abbrev Model := Class → ℕ → KGroup

/-- Two models are **weakly equivalent** if they have the same non-triviality pattern:
in every class and dimension, one is trivial iff the other is.  (Strict equality of the
groups is a stronger condition; weak equivalence keeps only the observable content —
which slots support a non-trivial topological phase.) -/
def WeakEquiv (f g : Model) : Prop :=
  ∀ c d, (f c d ≠ KGroup.null) ↔ (g c d ≠ KGroup.null)

theorem WeakEquiv.refl (f : Model) : WeakEquiv f f := fun _ _ => Iff.rfl

theorem WeakEquiv.symm {f g : Model} (h : WeakEquiv f g) : WeakEquiv g f :=
  fun c d => (h c d).symm

theorem WeakEquiv.trans {f g h : Model} (hfg : WeakEquiv f g) (hgh : WeakEquiv g h) :
    WeakEquiv f h := fun c d => (hfg c d).trans (hgh c d)

/-- Strict equality of models implies weak equivalence. -/
theorem weakEquiv_of_eq {f g : Model} (h : ∀ c d, f c d = g c d) : WeakEquiv f g :=
  fun c d => by rw [h c d]

/-- The **impl model**: the periodic table obtained by replacing every class with the
class one gets from classifying that class's own self-blade, then consulting the table.
This is the implementation re-describing itself through the blade classifier. -/
def implModel : Model := fun c d => classify (selfBlade c).nearestClass d

/-- The impl model is *literally* the original periodic table. -/
@[simp] theorem implModel_eq (c : Class) (d : ℕ) : implModel c d = classify c d := by
  simp [implModel]

/-- **Self-reflection theorem.**  The impl model obtained from the implementation's own
self-description is weakly equivalent to the original periodic table. -/
theorem implModel_weakEquiv_classify : WeakEquiv implModel classify :=
  weakEquiv_of_eq (fun c d => implModel_eq c d)

/-- The self-reflection also matches the Clifford / K-theory front-end: the impl model
equals the model expressed through Clifford degrees. -/
theorem implModel_eq_classifyViaClifford (c : Class) (d : ℕ) :
    implModel c d = classifyViaClifford c d := by
  rw [implModel_eq, classify_eq_classifyViaClifford]

/-- ...and is therefore weakly equivalent to the Clifford front-end as well. -/
theorem implModel_weakEquiv_clifford : WeakEquiv implModel (fun c d => classifyViaClifford c d) :=
  weakEquiv_of_eq implModel_eq_classifyViaClifford

end AZ
