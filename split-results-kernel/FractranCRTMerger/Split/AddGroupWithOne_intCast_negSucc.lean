import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IntCast_intCast
import Split.AddGroupWithOne_toNeg
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.AddGroupWithOne_toIntCast
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

-- AddGroupWithOne.intCast_negSucc from environment
-- theorem AddGroupWithOne.intCast_negSucc : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R (AddGroupWithOne.toIntCast.{u} R self) (Int.negSucc n)) (Neg.neg.{u} R (AddGroupWithOne.toNeg.{u} R self) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `AddGroupWithOne.intCast_negSucc`.
-- In a full split, the body would be extracted from the environment.
