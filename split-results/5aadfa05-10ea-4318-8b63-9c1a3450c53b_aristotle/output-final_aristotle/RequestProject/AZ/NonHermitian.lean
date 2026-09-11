import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification

/-!
# The non-Hermitian "38-fold way"

`RequestProject.AZ.TenfoldWay` builds the ten Hermitian Altland–Zirnbauer (AZ)
classes.  For **non-Hermitian** Hamiltonians the symmetry classification is richer:
because a non-Hermitian matrix `H` is not equal to `H†`, complex conjugation `*`,
transposition `ᵀ` and Hermitian conjugation `†` become *independent* operations.
As a consequence the antiunitary symmetries ramify, and one obtains the celebrated
**38-fold classification** of non-Hermitian systems
(Bernard–LeClair; Kawabata–Shiozaki–Ueda–Sato; Gong et al.).

This file is a self-contained, machine-checked combinatorial model of that 38-fold
way, built on the same footing as the Hermitian tenfold-way model.

## The ingredients of the 38

The non-Hermitian internal-symmetry classes are assembled from three structural
ingredients, all already visible in the Hermitian theory:

1. **Two AZ families.**  The antiunitary symmetries split into
   * the **AZ family** — time reversal `T` and particle–hole `C` defined through
     complex conjugation `H*` (the familiar Hermitian symmetries), and
   * the **AZ† family** — the "dagger" symmetries `T†`, `C†` defined through the
     transpose `Hᵀ`, which are genuinely new in the non-Hermitian setting.
   Each family carries the ten Cartan labels, and the two families share *only* the
   symmetry-free class `A` (no antiunitary symmetry at all).  Hence there are
   `10 + 10 - 1 = 19` distinct families-of-symmetry patterns.

2. **Pseudo-Hermiticity.**  A non-Hermitian Hamiltonian may in addition possess
   *pseudo-Hermiticity* `η H† η⁻¹ = H`, a `ℤ₂` flag refining each of the `19`
   patterns.  This doubles the count to `2 · 19 = 38`.

We encode a class as `NHClass = (family, Cartan label, pseudo-Hermiticity flag)`
with the single identification that the symmetry-free class `A` is shared between
the two families (canonicalised to the `az` family).  The headline theorem
`card_classes : classes.card = 38` proves the 38-fold count, and we record the full
structural breakdown.

## Reduction to the Hermitian theory

A line-gapped non-Hermitian Hamiltonian can be *Hermitianized* and its topology read
off from a Hermitian AZ class.  We expose the underlying Hermitian AZ class
(`NHClass.underlying`) and inherit the periodic table and Bott periodicity from
`RequestProject.AZ.TenfoldWay`, including the per-dimension count of non-trivial
non-Hermitian classes.
-/

namespace AZ
namespace NonHermitian

open Class

/-! ## The two AZ families -/

/-- The two Altland–Zirnbauer families of non-Hermitian antiunitary symmetries:
the ordinary **AZ family** (`az`, symmetries defined through complex conjugation `H*`)
and the **AZ† family** (`azdag`, symmetries defined through the transpose `Hᵀ`). -/
inductive Family
  | az
  | azdag
deriving DecidableEq, Fintype, Repr

/-- There are exactly two AZ families. -/
theorem card_family : Fintype.card Family = 2 := by decide

/-! ## The non-Hermitian symmetry classes -/

/-- A non-Hermitian internal-symmetry class: a choice of AZ `family`, an underlying
Cartan label `cls`, and a pseudo-Hermiticity flag `pH`.  The symmetry-free class `A`
is shared between the two families and is canonicalised to the `az` family
(see `Canonical`). -/
structure NHClass where
  /-- Which AZ family (ordinary `az` or dagger `azdag`) the class belongs to. -/
  family : Family
  /-- The underlying Cartan label of the AZ (or AZ†) class. -/
  cls : Class
  /-- The pseudo-Hermiticity flag: `true` if `η H† η⁻¹ = H` is imposed. -/
  pH : Bool
deriving DecidableEq, Fintype, Repr

namespace NHClass

/-- A representative is **canonical** unless it is the symmetry-free class `A` in the
`azdag` family: that case is identified with the same class in the `az` family, since
`A` (no antiunitary symmetry at all) does not distinguish the two families. -/
def Canonical (x : NHClass) : Prop :=
  ¬ (x.family = Family.azdag ∧ x.cls = Class.A)

instance (x : NHClass) : Decidable (Canonical x) := by
  unfold Canonical; infer_instance

end NHClass

/-- The set of the genuine non-Hermitian symmetry classes: all representatives that
are canonical. -/
def classes : Finset NHClass :=
  Finset.univ.filter (fun x => x.Canonical)

/-! ## The 38-fold count -/

/-- The raw representative space has `2 · 10 · 2 = 40` elements. -/
theorem card_raw : Fintype.card NHClass = 40 := by decide

/-- **The 38-fold way.**  There are exactly thirty-eight non-Hermitian
internal-symmetry classes. -/
theorem card_classes : classes.card = 38 := by decide

/-- Breakdown: the ordinary **AZ family** contributes its full ten Cartan labels,
each doubled by pseudo-Hermiticity — twenty classes. -/
theorem card_az :
    (classes.filter (fun x => x.family = Family.az)).card = 20 := by decide

/-- Breakdown: the **AZ† family** contributes its ten Cartan labels doubled by
pseudo-Hermiticity, *minus* the shared symmetry-free class `A` (in both
pseudo-Hermiticity sectors) — eighteen classes. -/
theorem card_azdag :
    (classes.filter (fun x => x.family = Family.azdag)).card = 18 := by decide

/-- Breakdown by pseudo-Hermiticity: there are nineteen classes **without**
pseudo-Hermiticity (the `10 + 10 - 1 = 19` family patterns). -/
theorem card_no_pH :
    (classes.filter (fun x => x.pH = false)).card = 19 := by decide

/-- Breakdown by pseudo-Hermiticity: there are nineteen classes **with**
pseudo-Hermiticity, doubling the previous count to `38`. -/
theorem card_with_pH :
    (classes.filter (fun x => x.pH = true)).card = 19 := by decide

/-- Every canonical class lies in `classes`, and vice versa. -/
theorem mem_classes_iff (x : NHClass) : x ∈ classes ↔ x.Canonical := by
  simp [classes]

/-! ## Symmetry signature and injectivity

Each non-Hermitian class is faithfully recorded by its `(family, Cartan T², C², S,
pseudo-Hermiticity)` signature, on the canonical representatives. -/

/-- The full non-Hermitian symmetry signature of a class: its family, the underlying
Cartan symmetry data `(T², C², S)`, and the pseudo-Hermiticity flag. -/
def signature (x : NHClass) : Family × ℤ × ℤ × ℕ × Bool :=
  (x.family, x.cls.trs, x.cls.phs, x.cls.chiral, x.pH)

/-- On canonical representatives, the symmetry signature determines the class:
distinct canonical classes (those in `classes`) have distinct signatures. -/
theorem signature_injOn :
    ∀ x ∈ classes, ∀ y ∈ classes, signature x = signature y → x = y := by
  decide

/-! ## Reduction to the Hermitian Altland–Zirnbauer theory

A line-gapped non-Hermitian Hamiltonian is *Hermitianized* to a Hermitian operator
whose topology is governed by an ordinary AZ class.  We expose this underlying
Hermitian class and inherit the periodic table and Bott periodicity. -/

/-- The underlying Hermitian Altland–Zirnbauer class obtained by Hermitianizing a
line-gapped non-Hermitian Hamiltonian in the given class. -/
def NHClass.underlying (x : NHClass) : Class := x.cls

/-- The classifying group of a non-Hermitian class in spatial dimension `d`, read off
from the underlying Hermitian AZ class via Hermitianization. -/
def nhClassify (x : NHClass) (d : ℕ) : KGroup := classify x.underlying d

/-- **Bott periodicity** of the non-Hermitian classification, inherited from the
Hermitian theory (period `8`). -/
theorem nhClassify_periodic8 (x : NHClass) (d : ℕ) :
    nhClassify x (d + 8) = nhClassify x d :=
  classify_periodic8 x.underlying d

/-- The non-Hermitian classifying group depends on the dimension only through
`d % 8`. -/
theorem nhClassify_mod8 (x : NHClass) (d : ℕ) :
    nhClassify x d = nhClassify x (d % 8) :=
  classify_mod8 x.underlying d

/-- A non-Hermitian class is **non-trivial** in dimension `d` when its underlying
classifying group is non-zero. -/
def NHClass.isNontrivial (x : NHClass) (d : ℕ) : Prop := nhClassify x d ≠ KGroup.null

instance (x : NHClass) (d : ℕ) : Decidable (x.isNontrivial d) := by
  unfold NHClass.isNontrivial; infer_instance

/-- The count of non-trivial non-Hermitian classes in a fixed dimension depends only
on `d % 8`. -/
theorem card_nontrivial_mod8 (d : ℕ) :
    (classes.filter (fun x => x.isNontrivial d)).card
      = (classes.filter (fun x => x.isNontrivial (d % 8))).card := by
  apply congrArg
  apply Finset.filter_congr
  intro x _
  simp only [NHClass.isNontrivial, nhClassify_mod8 x d]

end NonHermitian
end AZ
