import Split.Int_instNegInt
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg
import Split.rfl

-- Int.neg_negSucc from environment
-- theorem Int.neg_negSucc : forall (n : Nat), Eq.{1} Int (Neg.neg.{0} Int Int.instNegInt (Int.negSucc n)) (Nat.cast.{0} Int instNatCastInt (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Int.neg_negSucc`.
-- In a full split, the body would be extracted from the environment.
