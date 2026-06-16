import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Iff
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.propext
import Split.Nat_le_div_iff_mul_le
import Split.instLTNat
import Split.Nat_not_le
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Not
import Split.not_congr
import Split.instHMul

-- Nat.div_lt_iff_lt_mul from environment
-- theorem Nat.div_lt_iff_lt_mul : forall {k : Nat} {x : Nat} {y : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) k) -> (Iff (LT.lt.{0} Nat instLTNat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x k) y) (LT.lt.{0} Nat instLTNat x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) y k)))

-- Stub: this file represents the declaration `Nat.div_lt_iff_lt_mul`.
-- In a full split, the body would be extracted from the environment.
