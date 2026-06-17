import Split.ByteArray_utf8DecodeChar?_parseFirstByte
import Split.Eq_rec
import Split.ByteArray_utf8DecodeChar?_assemble₁
import Split.Eq_ndrec
import Split.Eq_refl
import Split.ByteArray_utf8DecodeChar?_FirstByte_done
import Split.ByteArray_utf8DecodeChar?_FirstByte
import Split.Char
import Split.UInt8
import Split.Eq
import Split.Option

-- ByteArray.utf8DecodeChar?.assemble₁.congr_simp from environment
-- theorem ByteArray.utf8DecodeChar?.assemble₁.congr_simp : forall (w : UInt8) (w_1 : UInt8) (e_w : Eq.{1} UInt8 w w_1) (h : Eq.{1} ByteArray.utf8DecodeChar?.FirstByte (ByteArray.utf8DecodeChar?.parseFirstByte w) ByteArray.utf8DecodeChar?.FirstByte.done), Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar?.assemble₁ w h) (ByteArray.utf8DecodeChar?.assemble₁ w_1 (Eq.ndrec.{0, 1} UInt8 w (fun (w : UInt8) => Eq.{1} ByteArray.utf8DecodeChar?.FirstByte (ByteArray.utf8DecodeChar?.parseFirstByte w) ByteArray.utf8DecodeChar?.FirstByte.done) h w_1 e_w))

-- Stub: this file represents the declaration `ByteArray.utf8DecodeChar?.assemble₁.congr_simp`.
-- In a full split, the body would be extracted from the environment.
