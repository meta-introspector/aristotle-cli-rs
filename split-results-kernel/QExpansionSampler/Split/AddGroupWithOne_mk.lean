import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.HSub_hSub
import Split.IntCast_intCast
import Split.IntCast
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.autoParam
import Split.instHAdd
import Split.Neg
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.AddGroupWithOne
import Split.instNatCastInt
import Split.AddMonoidWithOne_toAddMonoid
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Neg_neg
import Split.AddMonoidWithOne
import Split.Sub

-- AddGroupWithOne.mk from environment
-- constructor AddGroupWithOne.mk : forall {R : Type.{u}} [toIntCast : IntCast.{u} R] [toAddMonoidWithOne : AddMonoidWithOne.{u} R] [toNeg : Neg.{u} R] [toSub : Sub.{u} R], (autoParam.{0} (forall (a : R) (b : R), Eq.{succ u} R (HSub.hSub.{u, u, u} R R R (instHSub.{u} R toSub) a b) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddMonoidWithOne.toAddMonoid.{u} R toAddMonoidWithOne)))) a (Neg.neg.{u} R toNeg b))) SubNegMonoid.sub_eq_add_neg._autoParam) -> (forall (zsmul : Int -> R -> R), (autoParam.{0} (forall (a : R), Eq.{succ u} R (zsmul (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddMonoidWithOne.toAddMonoid.{u} R toAddMonoidWithOne))))) SubNegMonoid.zsmul_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : R), Eq.{succ u} R (zsmul (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddMonoidWithOne.toAddMonoid.{u} R toAddMonoidWithOne)))) (zsmul (Nat.cast.{0} Int instNatCastInt n) a) a)) SubNegMonoid.zsmul_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : R), Eq.{succ u} R (zsmul (Int.negSucc n) a) (Neg.neg.{u} R toNeg (zsmul (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) SubNegMonoid.zsmul_neg'._autoParam) -> (forall (a : R), Eq.{succ u} R (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddMonoidWithOne.toAddMonoid.{u} R toAddMonoidWithOne)))) (Neg.neg.{u} R toNeg a) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddMonoidWithOne.toAddMonoid.{u} R toAddMonoidWithOne))))) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R toIntCast (Nat.cast.{0} Int instNatCastInt n)) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R toAddMonoidWithOne) n)) AddGroupWithOne.intCast_ofNat._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R toIntCast (Int.negSucc n)) (Neg.neg.{u} R toNeg (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R toAddMonoidWithOne) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))) AddGroupWithOne.intCast_negSucc._autoParam) -> (AddGroupWithOne.{u} R))

-- Stub: this file represents the declaration `AddGroupWithOne.mk`.
-- In a full split, the body would be extracted from the environment.
