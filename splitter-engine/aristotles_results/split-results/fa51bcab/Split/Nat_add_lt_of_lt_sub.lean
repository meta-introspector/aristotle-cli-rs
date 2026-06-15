import Split.congrArg
import Split.HSub_hSub
import Split.Eq_mp
import Split.instSubNat
import Split.Nat_add_le_of_le_sub
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Nat_le_of_lt
import Split.instHAdd
import Split.instHSub
import Split.Nat_ge_of_not_lt
import Split.HAdd_hAdd
import Split.Nat_not_lt_zero
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.congrFun'
import Split.instLTNat
import Split.Nat_succ_add
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Nat_sub_eq_zero_of_le

-- Nat.add_lt_of_lt_sub from environment
-- theorem Nat.add_lt_of_lt_sub : forall {a : Nat} {b : Nat} {c : Nat}, (LT.lt.{0} Nat instLTNat a (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) c b)) -> (LT.lt.{0} Nat instLTNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a b) c)

-- Stub: this file represents the declaration `Nat.add_lt_of_lt_sub`.
-- In a full split, the body would be extracted from the environment.
