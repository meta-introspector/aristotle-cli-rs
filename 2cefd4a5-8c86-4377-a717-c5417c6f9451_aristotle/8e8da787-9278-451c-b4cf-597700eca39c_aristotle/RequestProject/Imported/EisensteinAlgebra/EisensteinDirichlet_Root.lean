import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplitHard_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinAlgebra_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinIdealCount_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinDivSum_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinExtensions_Root

/-!
# `chi3` as an arithmetic function and Dirichlet character

This file packages two contained extensions of the DULA Eisenstein program:

* **Multiplicativity of `chi3Arith`**: the `ArithmeticFunction ℤ` packaging of
  `chi3` (defined in `EisensteinExtensions`) is a multiplicative function in the
  sense of `ArithmeticFunction.IsMultiplicative` (and in fact completely
  multiplicative).

* **Identification with a Dirichlet character**: `chi3` corresponds to the
  unique nontrivial Dirichlet character modulo 3 with values in `ℤ`. We
  construct `chi3DirichletInt : DirichletCharacter ℤ 3` explicitly via the
  `MulChar` interface and prove agreement with `chi3` on natural-number inputs.

## What's done before this file

Both pieces lean on existing results:

* `EisensteinTheta.chi3_mul (m n : ℕ) : chi3 (m * n) = chi3 m * chi3 n` — full
  multiplicativity of `chi3`, proved by case analysis modulo 3.
* `EisensteinTheta.chi3_one : chi3 1 = 1` and `chi3_zero : chi3 0 = 0` — simp
  lemmas.
* `EisensteinTheta.chi3_mod (n : ℕ) : chi3 n = chi3 (n % 3)` — periodicity.
* `EisensteinExtensions.chi3Arith : ArithmeticFunction ℤ` — the packaging.

## What this file does NOT claim

This file establishes two compatibility theorems between our `chi3` and
Mathlib's standard frameworks. It does NOT:

* Establish analytic properties of the L-function `L(s, χ_{-3})` (continuation,
  functional equation, zeros).
* Connect to any 24-dimensional / Leech-lattice / RH-related claim.

The point of these compatibility results is purely interoperability: future
work that uses Mathlib's `ArithmeticFunction.IsMultiplicative` or
`DirichletCharacter` API can refer to our `chi3` directly.
-/

noncomputable section

open scoped Classical
open ArithmeticFunction

namespace Eisenstein

/-! ## Part 1: `chi3Arith` is multiplicative -/

/-- The arithmetic function `chi3Arith` is multiplicative: `chi3Arith 1 = 1`
and `chi3Arith (m * n) = chi3Arith m * chi3Arith n` for coprime `m, n`.

Follows from the (stronger) complete multiplicativity of `chi3`. -/
theorem chi3Arith_isMultiplicative : chi3Arith.IsMultiplicative := by
  refine ⟨?_, ?_⟩
  · -- chi3Arith 1 = 1
    show EisensteinTheta.chi3 1 = 1
    exact EisensteinTheta.chi3_one
  · -- ∀ m n, Coprime m n → chi3Arith (m * n) = chi3Arith m * chi3Arith n
    intro m n _hcop
    -- This is a consequence of FULL multiplicativity (chi3_mul), not just
    -- the coprime case; we discard the coprime hypothesis.
    show EisensteinTheta.chi3 (m * n) = EisensteinTheta.chi3 m * EisensteinTheta.chi3 n
    exact EisensteinTheta.chi3_mul m n

/-! ## Part 2: `chi3` as a Dirichlet character mod 3 -/

/-- The underlying function `ZMod 3 → ℤ` for our Dirichlet character: send
`x : ZMod 3` to `chi3 (x.val)`, where `x.val : ℕ` is the canonical natural
number representative of `x`. -/
def chi3OnZMod3 : ZMod 3 → ℤ := fun x => EisensteinTheta.chi3 x.val

/-- `chi3OnZMod3` agrees with `chi3` on natural number coercions, since
`((n : ℕ) : ZMod 3).val = n % 3` and `chi3` is periodic mod 3. -/
theorem chi3OnZMod3_natCast (n : ℕ) :
    chi3OnZMod3 (n : ZMod 3) = EisensteinTheta.chi3 n := by
  -- ((n : ℕ) : ZMod 3).val = n % 3 (`ZMod.val_natCast`)
  -- and chi3 (n % 3) = chi3 n (`chi3_mod`, reversed)
  unfold chi3OnZMod3
  rw [ZMod.val_natCast]
  exact (EisensteinTheta.chi3_mod n).symm

/-- The nontrivial Dirichlet character mod 3 with values in `ℤ`. We construct
it directly as a `MulChar (ZMod 3) ℤ` (which is the same type as
`DirichletCharacter ℤ 3`) using `chi3OnZMod3`. -/
def chi3DirichletInt : DirichletCharacter ℤ 3 where
  toFun := chi3OnZMod3
  map_one' := by
    -- chi3OnZMod3 1 = chi3 1 = 1
    show EisensteinTheta.chi3 ((1 : ZMod 3).val) = 1
    -- (1 : ZMod 3).val = 1
    have : (1 : ZMod 3).val = 1 := by decide
    rw [this]
    exact EisensteinTheta.chi3_one
  map_mul' := by
    -- chi3OnZMod3 (a * b) = chi3OnZMod3 a * chi3OnZMod3 b
    intro a b
    show EisensteinTheta.chi3 ((a * b).val) =
         EisensteinTheta.chi3 a.val * EisensteinTheta.chi3 b.val
    -- (a*b).val = (a.val * b.val) % 3, and chi3 is periodic mod 3 + multiplicative
    have h_val : (a * b).val = (a.val * b.val) % 3 := by
      rw [ZMod.val_mul]
    rw [h_val, ← EisensteinTheta.chi3_mod, EisensteinTheta.chi3_mul]
  map_nonunit' := by
    -- For non-units a : ZMod 3, chi3OnZMod3 a = 0.
    -- In ZMod 3, the only non-unit is 0.
    intro a ha
    show EisensteinTheta.chi3 a.val = 0
    -- Since ZMod 3 has 3 elements and 2 of them (1, 2) are units, the only
    -- non-unit is 0. We do a finite case analysis.
    -- (Fallback if `fin_cases a` fails: prove `a.val < 3` and `interval_cases a.val`,
    --  then show `a = ZMod.val_cast_of_lt`-ish or by `Fin.val_injective`.)
    have ha_zero : a = 0 := by
      have h1 : IsUnit (1 : ZMod 3) := isUnit_one
      have h2 : IsUnit (2 : ZMod 3) := by decide
      fin_cases a
      · rfl
      · exact absurd h1 ha
      · exact absurd h2 ha
    rw [ha_zero]
    show EisensteinTheta.chi3 ((0 : ZMod 3).val) = 0
    have : (0 : ZMod 3).val = 0 := by decide
    rw [this]
    exact EisensteinTheta.chi3_zero

/-- The Dirichlet character `chi3DirichletInt` agrees with `chi3` on natural
number inputs: `chi3DirichletInt (n : ZMod 3) = chi3 n` for any `n : ℕ`. -/
theorem chi3DirichletInt_eq_chi3 (n : ℕ) :
    chi3DirichletInt (n : ZMod 3) = EisensteinTheta.chi3 n := by
  show chi3OnZMod3 (n : ZMod 3) = EisensteinTheta.chi3 n
  exact chi3OnZMod3_natCast n

end Eisenstein
