import Split.instHDiv
import Split.HDiv_hDiv
import Split.instOfNatNat
import Split.instHShiftRightOfShiftRight
import Split.instHAdd
import Split.Nat_instShiftRight
import Split.HAdd_hAdd
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.Nat_instDiv
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl

-- Nat.shiftRight_succ from environment
-- theorem Nat.shiftRight_succ : forall (m : Nat) (n : Nat), Eq.{1} Nat (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m n) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)))

-- Stub: this file represents the declaration `Nat.shiftRight_succ`.
-- In a full split, the body would be extracted from the environment.
