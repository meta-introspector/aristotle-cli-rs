import Split.Iff_mpr
import Split.False
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.HDiv_hDiv
import Split.Or_resolve_left
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Nat_div_lt_iff_lt_mul
import Split.GT_gt
import Split.instHAdd
import Split.absurd
import Split.HAdd_hAdd
import Split.Nat_le_of_lt_succ
import Split.Nat
import Split.LT_lt
import Split.Nat_mul_zero
import Split.Nat_not_le_of_gt
import Split.Nat_instDiv
import Split.Nat_le_div_iff_mul_le
import Split.instAddNat
import Split.Nat_le_antisymm
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_eq_zero_or_pos
import Split.instHMul

-- Nat.div_eq_of_lt_le from environment
-- theorem Nat.div_eq_of_lt_le : forall {k : Nat} {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k n) m) -> (LT.lt.{0} Nat instLTNat m (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) n)) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) m n) k)

-- Stub: this file represents the declaration `Nat.div_eq_of_lt_le`.
-- In a full split, the body would be extracted from the environment.
