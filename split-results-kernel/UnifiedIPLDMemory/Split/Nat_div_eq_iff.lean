import Split.Nat_eq_iff_le_and_ge
import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Iff_rfl
import Split.HSub_hSub
import Split.id
import Split.HDiv_hDiv
import Split.instSubNat
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.and_comm
import Split.instLENat
import Split.instHAdd
import Split.And
import Split.Iff
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.propext
import Split.Nat_le_div_iff_mul_le
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Nat_div_le_iff_le_mul
import Split.instHMul

-- Nat.div_eq_iff from environment
-- theorem Nat.div_eq_iff : forall {k : Nat} {x : Nat} {y : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) k) -> (Iff (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x k) y) (And (LE.le.{0} Nat instLENat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) y k) x) (LE.le.{0} Nat instLENat x (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) y k) k) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))))

-- Stub: this file represents the declaration `Nat.div_eq_iff`.
-- In a full split, the body would be extracted from the environment.
