import Split.HSub_hSub
import Split.instOfNatNat
import Split.Int
import Split.instHAdd
import Split.instHSub
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Int_instSub
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl

-- Int.negSucc_sub_one from environment
-- theorem Int.negSucc_sub_one : forall (n : Nat), Eq.{1} Int (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (Int.negSucc n) (OfNat.ofNat.{0} Int 1 (instOfNat 1))) (Int.negSucc (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Int.negSucc_sub_one`.
-- In a full split, the body would be extracted from the environment.
