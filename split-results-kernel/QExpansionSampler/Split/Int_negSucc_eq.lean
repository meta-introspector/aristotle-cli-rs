import Split.Int_instNegInt
import Split.Int
import Split.Nat_cast
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.Int_instAdd
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg
import Split.rfl

-- Int.negSucc_eq from environment
-- theorem Int.negSucc_eq : forall (n : Nat), Eq.{1} Int (Int.negSucc n) (Neg.neg.{0} Int Int.instNegInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Nat.cast.{0} Int instNatCastInt n) (OfNat.ofNat.{0} Int 1 (instOfNat 1))))

-- Stub: this file represents the declaration `Int.negSucc_eq`.
-- In a full split, the body would be extracted from the environment.
