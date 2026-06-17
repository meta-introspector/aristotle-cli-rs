import Split.Eq_mpr
import Split.congrArg
import Split.String
import Split.String_push
import Split.Exists
import Split.String_singleton_eq_ofList
import Split.id
import Split.List_cons
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.List
import Split.Exists_casesOn
import Split.String_exists_eq_ofList
import Split.String_ofList_append
import Split.Eq_ndrec
import Split.String_append_singleton
import Split.Char
import Split.List_instAppend
import Split.Eq_symm
import Split.String_singleton
import Split.Eq
import Split.HAppend_hAppend
import Split.String_ofList
import Split.List_nil

-- String.push_induction from environment
-- theorem String.push_induction : forall (s : String) (motive : String -> Prop), (motive "") -> (forall (b : String) (c : Char), (motive b) -> (motive (String.push b c))) -> (motive s)

-- Stub: this file represents the declaration `String.push_induction`.
-- In a full split, the body would be extracted from the environment.
