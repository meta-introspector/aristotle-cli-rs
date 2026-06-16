import Split.AddGroupWithOne_zsmul
import Split.AddGroupWithOne_toNeg
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.AddGroupWithOne
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.Neg_neg

-- AddGroupWithOne.zsmul_neg' from environment
-- theorem AddGroupWithOne.zsmul_neg' : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (n : Nat) (a : R), Eq.{succ u} R (AddGroupWithOne.zsmul.{u} R self (Int.negSucc n) a) (Neg.neg.{u} R (AddGroupWithOne.toNeg.{u} R self) (AddGroupWithOne.zsmul.{u} R self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `AddGroupWithOne.zsmul_neg'`.
-- In a full split, the body would be extracted from the environment.
