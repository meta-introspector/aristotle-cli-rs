import Split.String_instLTRaw
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.Eq_rec
import Split.String_Pos_Raw
import Split.LT_lt
import Split.Eq_ndrec
import Split.Eq_refl
import Split.String_Slice_getUTF8Byte
import Split.UInt8
import Split.Eq

-- String.Slice.getUTF8Byte.congr_simp from environment
-- theorem String.Slice.getUTF8Byte.congr_simp : forall (s : String.Slice) (s_1 : String.Slice) (e_s : Eq.{1} String.Slice s s_1) (p : String.Pos.Raw) (p_1 : String.Pos.Raw) (e_p : Eq.{1} String.Pos.Raw p p_1) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)), Eq.{1} UInt8 (String.Slice.getUTF8Byte s p h) (String.Slice.getUTF8Byte s_1 p_1 (Eq.ndrec.{0, 1} String.Slice s (fun (s : String.Slice) => LT.lt.{0} String.Pos.Raw String.instLTRaw p_1 (String.Slice.rawEndPos s)) (Eq.ndrec.{0, 1} String.Pos.Raw p (fun (p : String.Pos.Raw) => LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) h p_1 e_p) s_1 e_s))

-- Stub: this file represents the declaration `String.Slice.getUTF8Byte.congr_simp`.
-- In a full split, the body would be extracted from the environment.
