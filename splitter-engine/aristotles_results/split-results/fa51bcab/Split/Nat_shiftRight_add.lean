import Split.instHDiv
import Split.congrArg
import Split.Nat_brecOn
import Split.HDiv_hDiv
import Split.instOfNatNat
import Split.instHShiftRightOfShiftRight
import Split.Nat_below
import Split.instHAdd
import Split.Unit
import Split.Nat_instShiftRight
import Split.HAdd_hAdd
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.True
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.rfl
import Split.Eq_trans

-- Nat.shiftRight_add from environment
-- theorem Nat.shiftRight_add : forall (m : Nat) (n : Nat) (k : Nat), Eq.{1} Nat (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k)) (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m n) k)

-- Stub: this file represents the declaration `Nat.shiftRight_add`.
-- In a full split, the body would be extracted from the environment.
