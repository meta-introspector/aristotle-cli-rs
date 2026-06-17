import Split.instOfNatNat
import Split.GetElem_getElem
import Split.UInt8_IsUTF8FirstByte
import Split.List
import Split.String_utf8EncodeChar
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Char
import Split.instLTNat
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.Eq_trans

-- UInt8.isUTF8FirstByte_getElem_zero_utf8EncodeChar from environment
-- theorem UInt8.isUTF8FirstByte_getElem_zero_utf8EncodeChar : forall {c : Char}, UInt8.IsUTF8FirstByte (GetElem.getElem.{0, 0, 0} (List.{0} UInt8) Nat UInt8 (fun (as : List.{0} UInt8) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} UInt8 as)) (List.instGetElemNatLtLength.{0} UInt8) (String.utf8EncodeChar c) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (UInt8.isUTF8FirstByte_getElem_zero_utf8EncodeChar._proof_1 c))

-- Stub: this file represents the declaration `UInt8.isUTF8FirstByte_getElem_zero_utf8EncodeChar`.
-- In a full split, the body would be extracted from the environment.
