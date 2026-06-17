import Split.Eq_mpr
import Split.String_instLTRaw
import Split.String_Pos_Raw_isValidForSlice_eq_def
import Split.congrArg
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.dif_pos
import Split.String_Pos_Raw
import Split.dif_neg
import Split.dite
import Split.UInt8_IsUTF8FirstByte
import Split.String_Pos_Raw_isValidForSlice
import Split.instDecidableEqRaw
import Split.String_instDecidableLtRaw
import Split.LT_lt
import Split.Bool
import Split.UInt8_instDecidableIsUTF8FirstByte
import Split.String_Slice_getUTF8Byte
import Split.Decidable_decide
import Split.Eq
import Split.Not

-- String.Pos.Raw.isValidForSlice.fun_cases_unfolding from environment
-- theorem String.Pos.Raw.isValidForSlice.fun_cases_unfolding : forall (s : String.Slice) (p : String.Pos.Raw) (motive : Bool -> Prop), (forall (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)), motive (Decidable.decide (UInt8.IsUTF8FirstByte (String.Slice.getUTF8Byte s p h)) (UInt8.instDecidableIsUTF8FirstByte (String.Slice.getUTF8Byte s p h)))) -> ((Not (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s))) -> (motive (Decidable.decide (Eq.{1} String.Pos.Raw p (String.Slice.rawEndPos s)) (instDecidableEqRaw p (String.Slice.rawEndPos s))))) -> (motive (String.Pos.Raw.isValidForSlice s p))

-- Stub: this file represents the declaration `String.Pos.Raw.isValidForSlice.fun_cases_unfolding`.
-- In a full split, the body would be extracted from the environment.
