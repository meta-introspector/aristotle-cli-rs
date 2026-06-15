import Split.congrArg
import Split.ByteArray_extract
import Split.HSub_hSub
import Split.instSubNat
import Split.Array_extract
import Split.Array
import Split.instHSub
import Split.Array_size_extract
import Split.Nat
import Split.ByteArray_data
import Split.True
import Split.eq_self
import Split.ByteArray_data_extract
import Split.of_eq_true
import Split.congrFun'
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.Array_size
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_size
import Split.Eq_trans

-- ByteArray.size_extract from environment
-- theorem ByteArray.size_extract : forall {a : ByteArray} {b : Nat} {e : Nat}, Eq.{1} Nat (ByteArray.size (ByteArray.extract a b e)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Min.min.{0} Nat instMinNat e (ByteArray.size a)) b)

-- Stub: this file represents the declaration `ByteArray.size_extract`.
-- In a full split, the body would be extracted from the environment.
