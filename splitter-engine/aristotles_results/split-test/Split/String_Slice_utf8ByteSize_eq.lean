import Split.HSub_hSub
import Split.String_Slice
import Split.instSubNat
import Split.String_Slice_utf8ByteSize
import Split.String_Slice_startInclusive
import Split.String_Slice_str
import Split.instHSub
import Split.Nat
import Split.String_Slice_endExclusive
import Split.String_Pos_Raw_byteIdx
import Split.Eq
import Split.String_Pos_offset
import Split.rfl

-- String.Slice.utf8ByteSize_eq from environment
-- theorem String.Slice.utf8ByteSize_eq : forall {s : String.Slice}, Eq.{1} Nat (String.Slice.utf8ByteSize s) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))))

-- Stub: this file represents the declaration `String.Slice.utf8ByteSize_eq`.
-- In a full split, the body would be extracted from the environment.
