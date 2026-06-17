import Split.congrArg
import Split.ByteArray_extract
import Split.Array_extract
import Split.Array
import Split.instHAdd
import Split.Array_extract_extract
import Split.HAdd_hAdd
import Split.Nat
import Split.ByteArray_data
import Split.congr
import Split.True
import Split.eq_self
import Split.ByteArray_data_extract
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.Array_extract_congr
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_ext
import Split.Eq_trans

-- ByteArray.extract_extract from environment
-- theorem ByteArray.extract_extract : forall {a : ByteArray} {i : Nat} {j : Nat} {k : Nat} {l : Nat}, Eq.{1} ByteArray (ByteArray.extract (ByteArray.extract a i j) k l) (ByteArray.extract a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i k) (Min.min.{0} Nat instMinNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i l) j))

-- Stub: this file represents the declaration `ByteArray.extract_extract`.
-- In a full split, the body would be extracted from the environment.
