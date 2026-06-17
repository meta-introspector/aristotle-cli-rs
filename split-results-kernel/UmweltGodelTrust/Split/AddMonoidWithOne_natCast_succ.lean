import Split.AddMonoid_toAddSemigroup
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.AddMonoidWithOne_toOne
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.One_toOfNat1
import Split.instAddNat
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.AddMonoidWithOne

-- AddMonoidWithOne.natCast_succ from environment
-- theorem AddMonoidWithOne.natCast_succ : forall {R : Type.{u_2}} [self : AddMonoidWithOne.{u_2} R] (n : Nat), Eq.{succ u_2} R (NatCast.natCast.{u_2} R (AddMonoidWithOne.toNatCast.{u_2} R self) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HAdd.hAdd.{u_2, u_2, u_2} R R R (instHAdd.{u_2} R (AddSemigroup.toAdd.{u_2} R (AddMonoid.toAddSemigroup.{u_2} R (AddMonoidWithOne.toAddMonoid.{u_2} R self)))) (NatCast.natCast.{u_2} R (AddMonoidWithOne.toNatCast.{u_2} R self) n) (OfNat.ofNat.{u_2} R 1 (One.toOfNat1.{u_2} R (AddMonoidWithOne.toOne.{u_2} R self))))

-- Stub: this file represents the declaration `AddMonoidWithOne.natCast_succ`.
-- In a full split, the body would be extracted from the environment.
