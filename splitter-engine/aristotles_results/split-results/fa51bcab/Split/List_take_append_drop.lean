import Split.congrArg
import Split.Nat_brecOn
import Split.instOfNatNat
import Split.List_cons
import Split.Nat_below
import Split.List_append
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.List_drop
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.List_take
import Split.HAppend_hAppend
import Split.rfl
import Split.List_nil

-- List.take_append_drop from environment
-- theorem List.take_append_drop : forall {α : Type.{u_1}} (i : Nat) (l : List.{u_1} α), Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) (List.take.{u_1} α i l) (List.drop.{u_1} α i l)) l

-- Stub: this file represents the declaration `List.take_append_drop`.
-- In a full split, the body would be extracted from the environment.
