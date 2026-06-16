import Split.One
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.NatCast
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.autoParam
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.AddMonoid
import Split.One_toOfNat1
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.AddMonoidWithOne

-- AddMonoidWithOne.mk from environment
-- constructor AddMonoidWithOne.mk : forall {R : Type.{u_2}} [toNatCast : NatCast.{u_2} R] [toAddMonoid : AddMonoid.{u_2} R] [toOne : One.{u_2} R], (autoParam.{0} (Eq.{succ u_2} R (NatCast.natCast.{u_2} R toNatCast (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u_2} R 0 (Zero.toOfNat0.{u_2} R (AddMonoid.toZero.{u_2} R toAddMonoid)))) AddMonoidWithOne.natCast_zero._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u_2} R (NatCast.natCast.{u_2} R toNatCast (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HAdd.hAdd.{u_2, u_2, u_2} R R R (instHAdd.{u_2} R (AddSemigroup.toAdd.{u_2} R (AddMonoid.toAddSemigroup.{u_2} R toAddMonoid))) (NatCast.natCast.{u_2} R toNatCast n) (OfNat.ofNat.{u_2} R 1 (One.toOfNat1.{u_2} R toOne)))) AddMonoidWithOne.natCast_succ._autoParam) -> (AddMonoidWithOne.{u_2} R)

-- Stub: this file represents the declaration `AddMonoidWithOne.mk`.
-- In a full split, the body would be extracted from the environment.
