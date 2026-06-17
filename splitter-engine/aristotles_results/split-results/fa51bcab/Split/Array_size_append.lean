import Split.Array_instAppend
import Split.congrArg
import Split.List_length_append
import Split.Array_toList_append
import Split.Array_toList
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.List_instAppend
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.HAppend_hAppend
import Split.Eq_trans

-- Array.size_append from environment
-- theorem Array.size_append : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α}, Eq.{1} Nat (Array.size.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Array.size.{u_1} α xs) (Array.size.{u_1} α ys))

-- Stub: this file represents the declaration `Array.size_append`.
-- In a full split, the body would be extracted from the environment.
