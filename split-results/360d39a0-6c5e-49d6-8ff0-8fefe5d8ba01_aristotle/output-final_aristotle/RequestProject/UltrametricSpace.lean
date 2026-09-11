/-
  UltrametricSpace.lean — Port of Ultrametric.agda, Contraction.agda, FixedPoint.agda.
-/
import Mathlib

/-! ## §1. Discrete ultrametric spaces -/

structure DiscreteUltrametric (S : Type*) where
  d : S → S → ℕ
  id_zero : ∀ x, d x x = 0
  symmetric : ∀ x y, d x y = d y x
  ultratriangle : ∀ x y z, d x z ≤ max (d x y) (d y z)

namespace DiscreteUltrametric

variable {S : Type*} (U : DiscreteUltrametric S)

theorem triangle (x y z : S) : U.d x z ≤ U.d x y + U.d y z :=
  le_trans (U.ultratriangle x y z) (max_le_add_of_nonneg (Nat.zero_le _) (Nat.zero_le _))

end DiscreteUltrametric

/-! ## §2. Contractive maps -/

structure StrictContractive {S : Type*} (U : DiscreteUltrametric S) (K : S → S) where
  contraction : ∀ x y, U.d (K x) (K y) < U.d x y

/-! ## §3. Fixed points -/

def IsFixedPt {S : Type*} (K : S → S) (x : S) : Prop := K x = x

theorem fixed_unique {S : Type*} (U : DiscreteUltrametric S) (K : S → S)
    (C : StrictContractive U K) (x y : S)
    (hx : IsFixedPt K x) (hy : IsFixedPt K y) : U.d x y = 0 := by
  by_contra h
  have hpos : 0 < U.d x y := Nat.pos_of_ne_zero h
  have := C.contraction x y
  rw [hx, hy] at this
  omega

/-! ## §4. Action monotonicity (port of ActionMonotonicity.agda) -/

structure ActionMonotone {X : Type*} (K : X → X) (A : X → ℕ) where
  monotone : ∀ s, A (K s) ≤ A s

/-! ## §5. Counterexample harness -/

structure Counterexample {A : Type*} (P : A → Prop) where
  witness : A
  violates : ¬ P witness
