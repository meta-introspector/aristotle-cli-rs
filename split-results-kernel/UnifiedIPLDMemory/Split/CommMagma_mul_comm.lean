import Split.HMul_hMul
import Split.CommMagma_toMul
import Split.CommMagma
import Split.Eq
import Split.instHMul

-- CommMagma.mul_comm from environment
-- theorem CommMagma.mul_comm : forall {G : Type.{u}} [self : CommMagma.{u} G] (a : G) (b : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (CommMagma.toMul.{u} G self)) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (CommMagma.toMul.{u} G self)) b a)

-- Stub: this file represents the declaration `CommMagma.mul_comm`.
-- In a full split, the body would be extracted from the environment.
