import Split.Quotient_inductionOn₃
import Split.List_append_assoc
import Split.Multiset
import Split.congr_arg
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.List_instAppend
import Split.List_isSetoid
import Split.Eq
import Split.Multiset_instAdd
import Split.HAppend_hAppend
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.add_assoc from environment
-- theorem Multiset.add_assoc : forall {α : Type.{u_1}} (s : Multiset.{u_1} α) (t : Multiset.{u_1} α) (u : Multiset.{u_1} α), Eq.{succ u_1} (Multiset.{u_1} α) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) s t) u) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) s (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) t u))

-- Stub: this file represents the declaration `Multiset.add_assoc`.
-- In a full split, the body would be extracted from the environment.
