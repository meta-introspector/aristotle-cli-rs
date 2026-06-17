import Split.AddZeroClass_toAddZero
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- AddZeroClass.add_zero from environment
-- theorem AddZeroClass.add_zero : forall {M : Type.{u}} [self : AddZeroClass.{u} M] (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddZero.toAdd.{u} M (AddZeroClass.toAddZero.{u} M self))) a (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M (AddZero.toZero.{u} M (AddZeroClass.toAddZero.{u} M self))))) a

-- Stub: this file represents the declaration `AddZeroClass.add_zero`.
-- In a full split, the body would be extracted from the environment.
