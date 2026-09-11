/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The Euler-factor identity over an arbitrary commutative ring, proved directly
from the decomposition.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinDecomposition

/-!
# The Euler-factor identity over an arbitrary commutative ring

`RequestProject/A5ArtinDecomposition.lean` states the Euler-factor identity
`L_R(T) = ∏ L_{Rᵢ}(T)^{mᵢ}` over `ℝ`, and proves it *from* the four classical
identities `permPoly5_eq`, `permPoly6_eq`, `permPoly12_eq`, `regPoly_eq` of
`RequestProject/A5Artin.lean`.

Here the direction is reversed, and the statement generalised.  The two
three-dimensional local factors are the only ones with irrational coefficients,
and all they need is a root `t` of `X² = X + 1` in the coefficient ring: the
two factors are then `E3gen t` and `E3gen (1 - t)`.  Over `ℝ` one takes
`t = φ`, the golden ratio.  So:

* `E3gen`, `E3bgen`, `E1gen`, `IRep.eulerGen` — the local factors over any
  commutative ring `A` with a chosen `t : A`;
* `eulerGen_eq_decompose` — **the Euler-factor identity over `A`**, proved
  directly, class by class, from the decomposition datum `decompose`
  (its only inputs are `t² = t + 1` and the definitions of the local factors);
* `permPoly5_eq_of_eulerGen`, `permPoly6_eq_of_eulerGen`,
  `permPoly12_eq_of_eulerGen`, `regPoly_eq_of_eulerGen` — the four classical
  identities, now corollaries of it, over any commutative ring containing a
  root of `X² = X + 1` (over a ring without such a root the first two are still
  available, hypothesis-free, as `permPoly5_eq` and `permPoly6_eq`);
* `euler_eq_eulerGen`, `euler_eq_decompose_of_gen` — the real-valued
  statements of `RequestProject/A5ArtinDecomposition.lean` recovered by
  specialising `t` to the golden ratio.
-/

namespace A5Artin

open Cls IRep

section Gen

variable {A : Type*} [CommRing A]

/-- The local factor of the trivial representation, over any commutative ring. -/
def E1gen : Cls → A → A := fun _ T => 1 - T

/-- The local factor of the three-dimensional representation `ρ₃` over a
commutative ring `A`, in terms of a chosen root `t` of `X² = X + 1`
(over `ℝ`: the golden ratio, `χ₃(5A) = φ`). -/
def E3gen (t : A) : Cls → A → A
  | c1, T => (1 - T) ^ 3
  | c2, T => (1 - T) * (1 + T) ^ 2
  | c3, T => 1 - T ^ 3
  | c5A, T => 1 - t * T + t * T ^ 2 - T ^ 3
  | c5B, T => 1 - (1 - t) * T + (1 - t) * T ^ 2 - T ^ 3

/-- The local factor of the conjugate representation `ρ₃′`: the same expression
with `t` replaced by the conjugate root `1 - t`. -/
def E3bgen (t : A) : Cls → A → A := E3gen (1 - t)

/-- The two three-dimensional local factors are conjugate, and their product is
the rational polynomial `E3E3b`. -/
theorem E3gen_mul_E3bgen {t : A} (ht : t ^ 2 = t + 1) (c : Cls) (T : A) :
    E3gen t c T * E3bgen t c T = E3E3b c T := by
  have hm : t * (1 - t) = -1 := by linear_combination -ht
  cases c
  · simp only [E3gen, E3bgen, E3E3b]; ring
  · simp only [E3gen, E3bgen, E3E3b]; ring
  · simp only [E3gen, E3bgen, E3E3b]; ring
  · simp only [E3gen, E3bgen, E3E3b]
    linear_combination (T ^ 2 - 2 * T ^ 3 + T ^ 4) * hm
  · simp only [E3gen, E3bgen, E3E3b]
    linear_combination (T ^ 2 - 2 * T ^ 3 + T ^ 4) * hm

/-- The local Euler factor `det(1 − T·ρ(Frob))` of each representation in
`IRep`, over an arbitrary commutative ring. -/
def IRep.eulerGen (t : A) : IRep → Cls → A → A
  | r1 => E1gen | r3 => E3gen t | r3b => E3bgen t | r4 => E4 | r5 => E5
  | perm5 => permPoly5 | perm6 => permPoly6 | perm12 => permPoly12 | reg => regPoly

/-- **The Euler-factor identity**, over an arbitrary commutative ring:
`L_R(T) = ∏ L_{Rᵢ}(T)^{mᵢ}`, proved directly from the decomposition datum. -/
theorem eulerGen_eq_decompose {t : A} (ht : t ^ 2 = t + 1) (R : IRep) (c : Cls) (T : A) :
    R.eulerGen t c T = ((decompose R).map fun q => (q.2.eulerGen t c T) ^ q.1).prod := by
  have h3 := E3gen_mul_E3bgen ht
  cases R
  case perm5 =>
    simp only [decompose, IRep.eulerGen, E1gen, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    cases c <;> simp only [permPoly5, E4] <;> ring
  case perm6 =>
    simp only [decompose, IRep.eulerGen, E1gen, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    cases c <;> simp only [permPoly6, E5] <;> ring
  case perm12 =>
    simp only [decompose, IRep.eulerGen, E1gen, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    rw [show (1 - T) * (E3gen t c T * (E3bgen t c T * E5 c T))
        = (1 - T) * (E3gen t c T * E3bgen t c T) * E5 c T from by ring, h3 c T]
    cases c <;> simp only [permPoly12, E3E3b, E5] <;> ring
  case reg =>
    simp only [decompose, IRep.eulerGen, E1gen, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    rw [show (1 - T) * (E3gen t c T ^ 3 * (E3bgen t c T ^ 3 * (E4 c T ^ 4 * E5 c T ^ 5)))
        = (1 - T) * (E3gen t c T * E3bgen t c T) ^ 3 * E4 c T ^ 4 * E5 c T ^ 5 from by ring,
      h3 c T]
    cases c <;> simp only [regPoly, E3E3b, E4, E5] <;> ring
  all_goals
    simp only [decompose, IRep.eulerGen, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]

/-! ### The four classical identities, now corollaries -/

theorem permPoly5_eq_of_eulerGen {t : A} (ht : t ^ 2 = t + 1) (c : Cls) (T : A) :
    permPoly5 c T = (1 - T) * E4 c T := by
  simpa [decompose, IRep.eulerGen, E1gen] using eulerGen_eq_decompose ht perm5 c T

theorem permPoly6_eq_of_eulerGen {t : A} (ht : t ^ 2 = t + 1) (c : Cls) (T : A) :
    permPoly6 c T = (1 - T) * E5 c T := by
  simpa [decompose, IRep.eulerGen, E1gen] using eulerGen_eq_decompose ht perm6 c T

theorem permPoly12_eq_of_eulerGen {t : A} (ht : t ^ 2 = t + 1) (c : Cls) (T : A) :
    permPoly12 c T = (1 - T) * (E3gen t c T * E3bgen t c T) * E5 c T := by
  have h := eulerGen_eq_decompose ht perm12 c T
  simp only [decompose, IRep.eulerGen, E1gen, List.map_cons, List.map_nil, List.prod_cons,
    List.prod_nil, pow_one, mul_one] at h
  rw [h]; ring

theorem regPoly_eq_of_eulerGen {t : A} (ht : t ^ 2 = t + 1) (c : Cls) (T : A) :
    regPoly c T = (1 - T) * (E3gen t c T) ^ 3 * (E3bgen t c T) ^ 3 * (E4 c T) ^ 4 *
      (E5 c T) ^ 5 := by
  have h := eulerGen_eq_decompose ht reg c T
  simp only [decompose, IRep.eulerGen, E1gen, List.map_cons, List.map_nil, List.prod_cons,
    List.prod_nil, pow_one, mul_one] at h
  rw [h]; ring

end Gen

/-! ## Specialisation to `ℝ` and the golden ratio -/

theorem goldenRatio_sq' : phi ^ 2 = phi + 1 := Real.goldenRatio_sq

theorem E3_eq_E3gen (c : Cls) (T : ℝ) : E3 c T = E3gen phi c T := by
  have h : phi' = 1 - phi := by have := phi_add; linarith
  cases c <;> simp only [E3, E3gen, h]

theorem E3b_eq_E3bgen (c : Cls) (T : ℝ) : E3b c T = E3bgen phi c T := by
  have h : phi' = 1 - phi := by have := phi_add; linarith
  cases c
  · simp only [E3b, E3bgen, E3gen]
  · simp only [E3b, E3bgen, E3gen]
  · simp only [E3b, E3bgen, E3gen]
  · simp only [E3b, E3bgen, E3gen, h]
  · simp only [E3b, E3bgen, E3gen]; ring

/-- The real-valued Euler factors are the general ones at `t = φ`. -/
theorem euler_eq_eulerGen (R : IRep) (c : Cls) (T : ℝ) :
    R.euler c T = R.eulerGen phi c T := by
  cases R
  · rfl
  · exact E3_eq_E3gen c T
  · exact E3b_eq_E3bgen c T
  all_goals rfl

/-- The real-valued Euler-factor identity, recovered from the general one. -/
theorem euler_eq_decompose_of_gen (R : IRep) (c : Cls) (T : ℝ) :
    R.euler c T = ((decompose R).map fun q => (q.2.euler c T) ^ q.1).prod := by
  have h := eulerGen_eq_decompose goldenRatio_sq' R c T
  rw [euler_eq_eulerGen]
  rw [h]
  congr 1
  refine List.map_congr_left ?_
  intro q _
  rw [euler_eq_eulerGen]

end A5Artin
