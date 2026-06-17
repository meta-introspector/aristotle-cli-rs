import Split.AddZero_toZero
import Split.AddZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- AddZeroClass.mk from environment
-- constructor AddZeroClass.mk : forall {M : Type.{u}} [toAddZero : AddZero.{u} M], (forall (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddZero.toAdd.{u} M toAddZero)) (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M (AddZero.toZero.{u} M toAddZero))) a) a) -> (forall (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddZero.toAdd.{u} M toAddZero)) a (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M (AddZero.toZero.{u} M toAddZero)))) a) -> (AddZeroClass.{u} M)

-- Stub: this file represents the declaration `AddZeroClass.mk`.
-- In a full split, the body would be extracted from the environment.
