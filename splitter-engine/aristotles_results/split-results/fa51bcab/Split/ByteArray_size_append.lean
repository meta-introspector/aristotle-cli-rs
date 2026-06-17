import Split.Array_instAppend
import Split.Array_size_append
import Split.congrArg
import Split.Array
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.HAdd_hAdd
import Split.ByteArray_data_append
import Split.Nat
import Split.ByteArray_data
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.Array_size
import Split.HAppend_hAppend
import Split.ByteArray_size
import Split.Eq_trans

-- ByteArray.size_append from environment
-- theorem ByteArray.size_append : forall {a : ByteArray} {b : ByteArray}, Eq.{1} Nat (ByteArray.size (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (ByteArray.size a) (ByteArray.size b))

-- Stub: this file represents the declaration `ByteArray.size_append`.
-- In a full split, the body would be extracted from the environment.
