import Split.Semigroup
import Split.HMul_hMul
import Split.Mul
import Split.Eq
import Split.instHMul

-- Semigroup.mk from environment
-- constructor Semigroup.mk : forall {G : Type.{u}} [toMul : Mul.{u} G], (forall (a : G) (b : G) (c : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G toMul) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G toMul) a b) c) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G toMul) a (HMul.hMul.{u, u, u} G G G (instHMul.{u} G toMul) b c))) -> (Semigroup.{u} G)

-- Stub: this file represents the declaration `Semigroup.mk`.
-- In a full split, the body would be extracted from the environment.
