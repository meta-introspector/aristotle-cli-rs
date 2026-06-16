import Split.Semigroup
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Eq
import Split.instHMul

-- Semigroup.mul_assoc from environment
-- theorem Semigroup.mul_assoc : forall {G : Type.{u}} [self : Semigroup.{u} G] (a : G) (b : G) (c : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G self)) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G self)) a b) c) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G self)) a (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G self)) b c))

-- Stub: this file represents the declaration `Semigroup.mul_assoc`.
-- In a full split, the body would be extracted from the environment.
