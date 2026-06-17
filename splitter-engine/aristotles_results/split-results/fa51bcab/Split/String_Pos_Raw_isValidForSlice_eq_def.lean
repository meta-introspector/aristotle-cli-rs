import Split.String_instLTRaw
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.String_Pos_Raw
import Split.dite
import Split.UInt8_IsUTF8FirstByte
import Split.String_Pos_Raw_isValidForSlice
import Split.instDecidableEqRaw
import Split.String_instDecidableLtRaw
import Split.LT_lt
import Split.Bool
import Split.Eq_refl
import Split.UInt8_instDecidableIsUTF8FirstByte
import Split.String_Slice_getUTF8Byte
import Split.Decidable_decide
import Split.Eq
import Split.Not

-- String.Pos.Raw.isValidForSlice.eq_def from environment
-- theorem String.Pos.Raw.isValidForSlice.eq_def : forall (s : String.Slice) (p : String.Pos.Raw), Eq.{1} Bool (String.Pos.Raw.isValidForSlice s p) (dite.{1} Bool (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) (String.instDecidableLtRaw p (String.Slice.rawEndPos s)) (fun (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) => Decidable.decide (UInt8.IsUTF8FirstByte (String.Slice.getUTF8Byte s p h)) (UInt8.instDecidableIsUTF8FirstByte (String.Slice.getUTF8Byte s p h))) (fun (h : Not (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s))) => Decidable.decide (Eq.{1} String.Pos.Raw p (String.Slice.rawEndPos s)) (instDecidableEqRaw p (String.Slice.rawEndPos s))))

-- Stub: this file represents the declaration `String.Pos.Raw.isValidForSlice.eq_def`.
-- In a full split, the body would be extracted from the environment.
