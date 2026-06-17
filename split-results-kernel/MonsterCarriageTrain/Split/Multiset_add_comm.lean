import Split.Quot_sound
import Split.Multiset
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Quotient_inductionOn₂
import Split.List_perm_append_comm
import Split.List_instAppend
import Split.List_isSetoid
import Split.Eq
import Split.Multiset_instAdd
import Split.HAppend_hAppend
import Split.Setoid_r

-- Multiset.add_comm from environment
-- theorem Multiset.add_comm : forall {α : Type.{u_1}} (s : Multiset.{u_1} α) (t : Multiset.{u_1} α), Eq.{succ u_1} (Multiset.{u_1} α) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) s t) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) t s)

-- Stub: this file represents the declaration `Multiset.add_comm`.
-- In a full split, the body would be extracted from the environment.
