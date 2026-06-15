import Split.congrArg
import Split.HSub_hSub
import Split.List_take_append
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.List_append_nil
import Split.instHAppendOfAppend
import Split.List
import Split.instHSub
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.Eq
import Split.List_take
import Split.List_length
import Split.HAppend_hAppend
import Split.Nat_sub_eq_zero_of_le
import Split.Eq_trans
import Split.List_nil

-- List.take_append_of_le_length from environment
-- theorem List.take_append_of_le_length : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {i : Nat}, (LE.le.{0} Nat instLENat i (List.length.{u_1} α l₁)) -> (Eq.{succ u_1} (List.{u_1} α) (List.take.{u_1} α i (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂)) (List.take.{u_1} α i l₁))

-- Stub: this file represents the declaration `List.take_append_of_le_length`.
-- In a full split, the body would be extracted from the environment.
