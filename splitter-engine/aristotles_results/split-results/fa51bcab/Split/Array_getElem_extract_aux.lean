import Split.congrArg
import Split.Nat_min_le_right
import Split.HSub_hSub
import Split.Eq_mp
import Split.Nat_add_lt_of_lt_sub'
import Split.instSubNat
import Split.Array_extract
import Split.Array
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_le_sub_right
import Split.HAdd_hAdd
import Split.Array_size_extract
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.Nat_lt_of_lt_of_le
import Split.Array_size
import Split.Min_min
import Split.instMinNat

-- Array.getElem_extract_aux from environment
-- theorem Array.getElem_extract_aux : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {start : Nat} {stop : Nat}, (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (Array.extract.{u_1} α xs start stop))) -> (LT.lt.{0} Nat instLTNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start i) (Array.size.{u_1} α xs))

-- Stub: this file represents the declaration `Array.getElem_extract_aux`.
-- In a full split, the body would be extracted from the environment.
