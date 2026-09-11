import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root

/-!
# The bridge between integer-pair representations and Eisenstein elements

This file connects two ways of counting:

* **Integer pairs**: `EisensteinTheta.repCount n` counts pairs `(a, b) ∈ ℤ²`
  with `a² + ab + b² = n` (defined in `EisensteinTheta.lean`).

* **Eisenstein elements**: the cardinality of `{z : Eisenstein | norm z = n}`
  using the ring structure from `EisensteinIntegers.lean`.

The two counts are **equal** for every `n`, via the explicit bijection
`(a, b) ↔ ⟨a, -b⟩`.
-/

namespace EisensteinThetaBridge

open Eisenstein EisensteinTheta

/-! ### The bijection maps -/

/-- Forward: an integer pair `(a, b)` becomes the Eisenstein element `⟨a, -b⟩`. -/
def toEis (p : ℤ × ℤ) : Eisenstein := Eisenstein.mk p.1 (-p.2)

/-- Inverse: an Eisenstein element `⟨a, b⟩` becomes the pair `(a, -b)`. -/
def fromEis (z : Eisenstein) : ℤ × ℤ := (z.a, -z.b)

@[simp] theorem toEis_apply (a b : ℤ) : toEis (a, b) = Eisenstein.mk a (-b) := rfl

@[simp] theorem fromEis_apply (z : Eisenstein) : fromEis z = (z.a, -z.b) := rfl

/-- The two maps are mutual inverses. -/
theorem toEis_fromEis (z : Eisenstein) : toEis (fromEis z) = z := by
  cases z; simp [toEis, fromEis]

theorem fromEis_toEis (p : ℤ × ℤ) : fromEis (toEis p) = p := by
  cases p; simp [toEis, fromEis]

/-! ### The norm identity -/

/-- The norm of `toEis (a, b)` equals the quadratic form `a*a + a*b + b*b`. -/
theorem norm_toEis (a b : ℤ) :
    norm (toEis (a, b)) = a * a + a * b + b * b := by
  show a ^ 2 - a * (-b) + (-b) ^ 2 = a * a + a * b + b * b
  ring

/-- **Key identity:** `a² + ab + b² = Eisenstein.norm ⟨a, -b⟩`. -/
theorem Q_plus_eq_norm (a b : ℤ) :
    a ^ 2 + a * b + b ^ 2 = norm (Eisenstein.mk a (-b)) := by
  show a ^ 2 + a * b + b ^ 2 = a ^ 2 - a * (-b) + (-b) ^ 2
  ring

/-! ### The Eisenstein side: finset of norm-`n` elements -/

/-- The set of Eisenstein elements with norm `n`, as a finset. -/
def eisNormSet (n : ℕ) : Finset Eisenstein :=
  ((Finset.Icc (-(n + 1 : ℤ)) (n + 1)).product (Finset.Icc (-(n + 1 : ℤ)) (n + 1))).image
    (fun p => Eisenstein.mk p.1 p.2)
    |>.filter (fun z => norm z = n)

/-- The cardinality of the Eisenstein norm-`n` set. -/
def eisNormCount (n : ℕ) : ℕ := (eisNormSet n).card

/-! ### The bijection as an `Equiv` -/

/-- `toEis` is a bijection from `ℤ × ℤ` to `Eisenstein`. -/
def toEisEquiv : ℤ × ℤ ≃ Eisenstein where
  toFun := toEis
  invFun := fromEis
  left_inv := fromEis_toEis
  right_inv := toEis_fromEis

@[simp] theorem toEisEquiv_apply (p : ℤ × ℤ) :
    toEisEquiv p = toEis p := rfl

@[simp] theorem toEisEquiv_symm_apply (z : Eisenstein) :
    toEisEquiv.symm z = fromEis z := rfl

/-! ### General cardinality equality

The key idea: we construct an explicit bijection between `repSet n` and
`eisNormSet n` using `toEis`/`fromEis`, then use `Finset.card_bij` to
conclude the cardinalities are equal. -/

/-
The image of `repSet n` under `toEis` equals `eisNormSet n`.
-/
theorem image_toEis_repSet (n : ℕ) :
    (repSet n).image toEis = eisNormSet n := by
  ext; simp [toEis, eisNormSet];
  constructor <;> intro h;
  · rcases h with ⟨ a, b, h₁, rfl ⟩ ; simp_all +decide [ repSet ] ; (
    exact ⟨ by linarith, by simpa [ Eisenstein.norm ] using by linarith ⟩);
  · rcases h with ⟨ ⟨ a, b, ⟨ ⟨ ha₁, ha₂ ⟩, ⟨ hb₁, hb₂ ⟩ ⟩, rfl ⟩, hn ⟩ ; use a, -b; simp_all +decide [ repSet ] ;
    exact ⟨ by linarith, by rw [ show ( { a := a, b := b } : Eisenstein ).norm = a ^ 2 - a * b + b ^ 2 by rfl ] at hn; linarith ⟩

/-
**Main bijection theorem:** `repCount n = eisNormCount n` for all `n`.
-/
theorem repCount_eq_eisNormCount (n : ℕ) :
    repCount n = eisNormCount n := by
  convert congr_arg Finset.card ( image_toEis_repSet n |> Eq.symm ) using 1;
  · rw [ ← image_toEis_repSet ];
    rw [ Finset.card_image_of_injective ];
    · rfl;
    · exact Function.LeftInverse.injective fromEis_toEis;
  · convert congr_arg Finset.card ( image_toEis_repSet n |> Eq.symm ) using 1

end EisensteinThetaBridge