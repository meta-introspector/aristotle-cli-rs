import Split.Eq_mpr
import Split.instHDiv
import Split.congrArg
import Split.Nat_brecOn
import Split.id
import Split.HDiv_hDiv
import Split.Nat_shiftRight_succ
import Split.instOfNatNat
import Split.instHShiftRightOfShiftRight
import Split.Nat_below
import Split.instHAdd
import Split.Nat_instShiftRight
import Split.HAdd_hAdd
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.Nat_instDiv
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.rfl

-- Nat.shiftRight_succ_inside from environment
-- theorem Nat.shiftRight_succ_inside : forall (m : Nat) (n : Nat), Eq.{1} Nat (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) m (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) n)

-- Stub: this file represents the declaration `Nat.shiftRight_succ_inside`.
-- In a full split, the body would be extracted from the environment.
