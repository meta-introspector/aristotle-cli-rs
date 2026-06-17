import Split.AddGroup_toSubtractionMonoid
import Split.Int_cast
import Split.NegZeroClass_toNeg
import Split.AddGroupWithOne_toAddGroup
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.AddMonoidWithOne_toNatCast
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.instOfNatNat
import Split.AddGroupWithOne_toIntCast
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddGroupWithOne_intCast_negSucc
import Split.Nat_cast
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.AddGroupWithOne
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- Int.cast_negSucc from environment
-- theorem Int.cast_negSucc : forall {R : Type.{u}} [inst._@.Mathlib.Data.Int.Cast.Basic.519550533._hygCtx._hyg.3 : AddGroupWithOne.{u} R] (n : Nat), Eq.{succ u} R (Int.cast.{u} R (AddGroupWithOne.toIntCast.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.519550533._hygCtx._hyg.3) (Int.negSucc n)) (Neg.neg.{u} R (NegZeroClass.toNeg.{u} R (SubNegZeroMonoid.toNegZeroClass.{u} R (SubtractionMonoid.toSubNegZeroMonoid.{u} R (AddGroup.toSubtractionMonoid.{u} R (AddGroupWithOne.toAddGroup.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.519550533._hygCtx._hyg.3))))) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.519550533._hygCtx._hyg.3)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `Int.cast_negSucc`.
-- In a full split, the body would be extracted from the environment.
