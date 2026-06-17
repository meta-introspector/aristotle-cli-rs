import Split.Eq_mpr
import Split.congrArg
import Split.String_Slice_toByteArray_copy
import Split.ByteArray_extract
import Split.String_toByteArray
import Split.HSub_hSub
import Split.String_utf8ByteSize
import Split.String_Slice
import Split.String_Pos_Raw_IsValid_le_rawEndPos
import Split.Eq_mp
import Split.id
import Split.instSubNat
import Split.LE_le
import Split.String_Slice_startInclusive
import Split.instLENat
import Split.String_Pos_Raw
import Split.String_Slice_str
import Split.String_rawEndPos
import Split.String_Slice_copy
import Split.ByteArray_size_extract
import Split.instHSub
import Split.String_Pos_isValid
import Split.Nat
import Split.Nat_min_eq_left
import Split.String_instLERaw
import Split.String_Slice_endExclusive
import Split.Eq_refl
import Split.congrFun'
import Split.ByteArray
import Split.String_Pos_Raw_byteIdx
import Split.Eq
import Split.String_Pos_offset
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_size
import Split.Eq_trans

-- String.Slice.utf8ByteSize_copy_eq_sub from environment
-- theorem String.Slice.utf8ByteSize_copy_eq_sub : forall {s : String.Slice}, Eq.{1} Nat (String.utf8ByteSize (String.Slice.copy s)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))))

-- Stub: this file represents the declaration `String.Slice.utf8ByteSize_copy_eq_sub`.
-- In a full split, the body would be extracted from the environment.
