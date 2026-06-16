import Split.Semiring_toNatCast
import Split.Ring_toNeg
import Split.IntCast_intCast
import Split.instOfNatNat
import Split.Nat_cast
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Int_negSucc
import Split.Ring_toIntCast
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.Neg_neg

-- Ring.intCast_negSucc from environment
-- theorem Ring.intCast_negSucc : forall {R : Type.{u}} [self : Ring.{u} R] (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R (Ring.toIntCast.{u} R self) (Int.negSucc n)) (Neg.neg.{u} R (Ring.toNeg.{u} R self) (Nat.cast.{u} R (Semiring.toNatCast.{u} R (Ring.toSemiring.{u} R self)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `Ring.intCast_negSucc`.
-- In a full split, the body would be extracted from the environment.
