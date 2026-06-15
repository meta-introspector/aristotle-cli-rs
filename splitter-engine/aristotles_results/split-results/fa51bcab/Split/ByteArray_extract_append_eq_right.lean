import Split.Array_instAppend
import Split.congrArg
import Split.ByteArray_extract
import Split.HSub_hSub
import Split.Nat_add_sub_cancel_left
import Split.instSubNat
import Split.instOfNatNat
import Split.Array_extract
import Split.List_toArray
import Split.Array
import Split.Nat_sub_self
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.ByteArray_data_append
import Split.Nat
import Split.ByteArray_data
import Split.congr
import Split.True
import Split.eq_self
import Split.ByteArray_data_extract
import Split.Array_extract_size
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Array_extract_size_left
import Split.Eq_refl
import Split.Array_extract_congr
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.UInt8
import Split.Array_extract_append
import Split.Eq
import Split.Array_size
import Split.HAppend_hAppend
import Split.Array_empty_append
import Split.ByteArray_ext
import Split.ByteArray_size
import Split.Eq_trans
import Split.List_nil

-- ByteArray.extract_append_eq_right from environment
-- theorem ByteArray.extract_append_eq_right : forall {a : ByteArray} {b : ByteArray} {i : Nat} {j : Nat}, (Eq.{1} Nat i (ByteArray.size a)) -> (Eq.{1} Nat j (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (ByteArray.size a) (ByteArray.size b))) -> (Eq.{1} ByteArray (ByteArray.extract (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b) i j) b)

-- Stub: this file represents the declaration `ByteArray.extract_append_eq_right`.
-- In a full split, the body would be extracted from the environment.
