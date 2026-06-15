import Split.Eq_mpr
import Split.String_Pos_Raw_isValid_append
import Split.congrArg
import Split.true_or
import Split.String
import Split.Classical_byContradiction
import Split.HSub_hSub
import Split.String_utf8ByteSize
import Split.String_push
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.String_Pos_Raw
import Split.Or_casesOn
import Split.String_Pos_Raw_isValid_singleton
import Split.And_casesOn
import Split.String_rawEndPos
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.And
import Split.Iff
import Split.instHSub
import Split.String_instHSubRaw
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.String_instLERaw
import Split.Iff_intro
import Split.propext
import Split.Decidable_byContradiction
import Split.of_eq_true
import Split.String_append_singleton
import Split.instAddNat
import Split.congrFun'
import Split.instDecidableEqNat
import Split.Or_inl
import Split.Char
import Split.Or
import Split.String_instOfNatRaw
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.String_singleton
import Split.Eq
import Split.Not
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.Eq_trans
import Split.String_instHAddRawChar

-- String.Pos.Raw.isValid_push from environment
-- theorem String.Pos.Raw.isValid_push : forall {s : String} {c : Char} {p : String.Pos.Raw}, Iff (String.Pos.Raw.IsValid (String.push s c) p) (Or (String.Pos.Raw.IsValid s p) (Eq.{1} String.Pos.Raw p (HAdd.hAdd.{0, 0, 0} String.Pos.Raw Char String.Pos.Raw String.instHAddRawChar (String.rawEndPos s) c)))

-- Stub: this file represents the declaration `String.Pos.Raw.isValid_push`.
-- In a full split, the body would be extracted from the environment.
