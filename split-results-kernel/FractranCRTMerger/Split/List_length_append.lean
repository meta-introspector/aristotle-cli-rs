import Split.congrArg
import Split.instOfNatNat
import Split.List_rec
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.Nat_zero_add
import Split.List_instAppend
import Split.Nat_succ_add
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- List.length_append from environment
-- theorem List.length_append : forall {α : Type.{u}} {as : List.{u} α} {bs : List.{u} α}, Eq.{1} Nat (List.length.{u} α (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) as bs)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (List.length.{u} α as) (List.length.{u} α bs))

-- Stub: this file represents the declaration `List.length_append`.
-- In a full split, the body would be extracted from the environment.
