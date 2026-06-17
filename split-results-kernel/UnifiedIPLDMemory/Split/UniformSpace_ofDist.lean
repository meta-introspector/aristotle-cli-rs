import Split.UniformSpace
import Split.Real_partialOrder
import Split.Real_instLE
import Split.Real
import Split.Real_instZero
import Split.UniformSpace_ofDist_aux
import Split.LE_le
import Split.Real_instAdd
import Split.instHAdd
import Split.HAdd_hAdd
import Split.UniformSpace_ofFun
import Split.Real_instAddCommMonoid
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- UniformSpace.ofDist from environment
-- def UniformSpace.ofDist : forall {α : Type.{u}} (dist : α -> α -> Real), (forall (x : α), Eq.{1} Real (dist x x) (OfNat.ofNat.{0} Real 0 (Zero.toOfNat0.{0} Real Real.instZero))) -> (forall (x : α) (y : α), Eq.{1} Real (dist x y) (dist y x)) -> (forall (x : α) (y : α) (z : α), LE.le.{0} Real Real.instLE (dist x z) (HAdd.hAdd.{0, 0, 0} Real Real Real (instHAdd.{0} Real Real.instAdd) (dist x y) (dist y z))) -> (UniformSpace.{u} α)
-- (definition body omitted)

-- Stub: this file represents the declaration `UniformSpace.ofDist`.
-- In a full split, the body would be extracted from the environment.
