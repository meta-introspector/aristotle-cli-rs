import Split.Eq_mpr
import Split.List_take_nil
import Split.congrArg
import Split.HSub_hSub
import Split.Eq_rec
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.List_rec
import Split.LE_le
import Split.instLENat
import Split.List_append_nil
import Split.List_cons
import Split.Nat_casesAuxOn
import Split.List_cons_injEq
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.And
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.Decidable_byContradiction
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instDecidableEqNat
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.List_take
import Split.List_length
import Split.List_append_cancel_left_eq
import Split.Not
import Split.HAppend_hAppend
import Split.Nat_sub_eq_zero_of_le
import Split.true_and
import Split.Eq_trans
import Split.List_nil

-- List.take_append from environment
-- theorem List.take_append : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {i : Nat}, Eq.{succ u_1} (List.{u_1} α) (List.take.{u_1} α i (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂)) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) (List.take.{u_1} α i l₁) (List.take.{u_1} α (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (List.length.{u_1} α l₁)) l₂))

-- Stub: this file represents the declaration `List.take_append`.
-- In a full split, the body would be extracted from the environment.
