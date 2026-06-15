import Split.Eq_mpr
import Split.congrArg
import Split.Nat_min_le_right
import Split.Nat_add_sub_assoc
import Split.HSub_hSub
import Split.GE_ge
import Split.id
import Split.Nat_add_lt_of_lt_sub'
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.Array
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Array_extract_loop
import Split.instAddNat
import Split.Array_size_extract_loop
import Split.instLTNat
import Split.Eq
import Split.Nat_lt_of_lt_of_le
import Split.Array_size
import Split.Nat_add_le_add_left
import Split.Min_min
import Split.instMinNat
import Split.Nat_sub_lt_left_of_lt_add

-- Array.getElem_extract_loop_ge_aux from environment
-- theorem Array.getElem_extract_loop_ge_aux : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {size : Nat} {start : Nat}, (GE.ge.{0} Nat instLENat i (Array.size.{u_1} α ys)) -> (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (Array.extract.loop.{u_1} α xs size start ys))) -> (LT.lt.{0} Nat instLTNat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start i) (Array.size.{u_1} α ys)) (Array.size.{u_1} α xs))

-- Stub: this file represents the declaration `Array.getElem_extract_loop_ge_aux`.
-- In a full split, the body would be extracted from the environment.
