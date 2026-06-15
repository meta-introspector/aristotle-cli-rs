import Split.congrArg
import Split.ByteArray_extract
import Split.Nat_min_le_right
import Split.HSub_hSub
import Split.Eq_mp
import Split.Nat_add_lt_of_lt_sub'
import Split.instSubNat
import Split.instHAdd
import Split.ByteArray_size_extract
import Split.instHSub
import Split.Nat_sub_le_sub_right
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.ByteArray
import Split.Nat_lt_of_lt_of_le
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_size

-- ByteArray.getElem_extract_aux from environment
-- theorem ByteArray.getElem_extract_aux : forall {i : Nat} {xs : ByteArray} {start : Nat} {stop : Nat}, (LT.lt.{0} Nat instLTNat i (ByteArray.size (ByteArray.extract xs start stop))) -> (LT.lt.{0} Nat instLTNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start i) (ByteArray.size xs))

-- Stub: this file represents the declaration `ByteArray.getElem_extract_aux`.
-- In a full split, the body would be extracted from the environment.
