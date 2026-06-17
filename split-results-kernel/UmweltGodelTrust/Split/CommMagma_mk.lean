import Split.HMul_hMul
import Split.Mul
import Split.CommMagma
import Split.Eq
import Split.instHMul

-- CommMagma.mk from environment
-- constructor CommMagma.mk : forall {G : Type.{u}} [toMul : Mul.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G toMul) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G toMul) b a)) -> (CommMagma.{u} G)

-- Stub: this file represents the declaration `CommMagma.mk`.
-- In a full split, the body would be extracted from the environment.
