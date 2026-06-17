import Split.Eq_mpr
import Split.List_take_nil
import Split.congrArg
import Split.HEq_refl
import Split.true_or
import Split.String
import Split.String_utf8ByteSize
import Split.Exists
import Split.String_singleton_eq_ofList
import Split.List_take_of_length_le
import Split.Eq_casesOn
import Split.String_utf8ByteSize_singleton
import Split.id
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.String_Pos_Raw
import Split.String_Pos_Raw_isValid_ofList
import Split.Or_casesOn
import Split.List_cons
import Split.List
import Split.Iff
import Split.Exists_casesOn
import Split.Nat
import Split.congr
import Split.True
import Split.Iff_intro
import Split.eq_self
import Split.propext
import Split.Exists_intro
import Split.Decidable_byContradiction
import Split.of_eq_true
import Split.Eq_ndrec
import Split.String_utf8ByteSize_empty
import Split.Eq_refl
import Split.HEq
import Split.congrFun'
import Split.instDecidableEqNat
import Split.Char
import Split.Or
import Split.String_instOfNatRaw
import Split.Nat_zero_add
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.String_singleton
import Split.or_true
import Split.Eq
import Split.List_take
import Split.List_length
import Split.instDecidableOr
import Split.Not
import Split.Nat_decLe
import Split.String_ofList
import Split.Char_utf8Size
import Split.Eq_trans
import Split.List_nil

-- String.Pos.Raw.isValid_singleton from environment
-- theorem String.Pos.Raw.isValid_singleton : forall {c : Char} {p : String.Pos.Raw}, Iff (String.Pos.Raw.IsValid (String.singleton c) p) (Or (Eq.{1} String.Pos.Raw p (OfNat.ofNat.{0} String.Pos.Raw 0 String.instOfNatRaw)) (Eq.{1} Nat (String.Pos.Raw.byteIdx p) (Char.utf8Size c)))

-- Stub: this file represents the declaration `String.Pos.Raw.isValid_singleton`.
-- In a full split, the body would be extracted from the environment.
