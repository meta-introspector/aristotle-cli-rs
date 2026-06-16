import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.HDiv_hDiv
import Split.instSubNat
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Nat_div_lt_iff_lt_mul
import Split.instHAdd
import Split.Iff
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.propext
import Split.Decidable_byContradiction
import Split.Nat_decLt
import Split.instAddNat
import Split.Nat_le_iff_lt_add_one
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Nat_add_one_mul
import Split.instDecidableIff
import Split.Not
import Split.Nat_decLe
import Split.instHMul

-- Nat.div_le_iff_le_mul from environment
-- theorem Nat.div_le_iff_le_mul : forall {k : Nat} {x : Nat} {y : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) k) -> (Iff (LE.le.{0} Nat instLENat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x k) y) (LE.le.{0} Nat instLENat x (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) y k) k) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `Nat.div_le_iff_le_mul`.
-- In a full split, the body would be extracted from the environment.
