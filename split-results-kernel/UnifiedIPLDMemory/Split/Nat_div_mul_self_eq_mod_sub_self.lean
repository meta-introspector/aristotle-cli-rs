import Split.Nat_mod_eq_sub_div_mul
import Split.instHDiv
import Split.HMul_hMul
import Split.Nat_div_mul_le_self
import Split.HSub_hSub
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instSubNat
import Split.instMulNat
import Split.LE_le
import Split.instLENat
import Split.HMod_hMod
import Split.instHSub
import Split.Nat
import Split.Nat_instDiv
import Split.Decidable_byContradiction
import Split.instDecidableEqNat
import Split.Eq
import Split.Not
import Split.instHMul

-- Nat.div_mul_self_eq_mod_sub_self from environment
-- theorem Nat.div_mul_self_eq_mod_sub_self : forall {x : Nat} {k : Nat}, Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x k) k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) x k))

-- Stub: this file represents the declaration `Nat.div_mul_self_eq_mod_sub_self`.
-- In a full split, the body would be extracted from the environment.
