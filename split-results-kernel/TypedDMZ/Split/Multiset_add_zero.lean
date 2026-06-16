import Split.Multiset
import Split.List_append_nil
import Split.Quotient_inductionOn
import Split.congr_arg
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Zero_toOfNat0
import Split.List_instAppend
import Split.List_isSetoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Multiset_instAdd
import Split.HAppend_hAppend
import Split.Setoid_r
import Split.Quot_mk
import Split.List_nil
import Split.Multiset_instZero

-- Multiset.add_zero from environment
-- theorem Multiset.add_zero : forall {α : Type.{u_1}} (s : Multiset.{u_1} α), Eq.{succ u_1} (Multiset.{u_1} α) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) s (OfNat.ofNat.{u_1} (Multiset.{u_1} α) 0 (Zero.toOfNat0.{u_1} (Multiset.{u_1} α) (Multiset.instZero.{u_1} α)))) s

-- Stub: this file represents the declaration `Multiset.add_zero`.
-- In a full split, the body would be extracted from the environment.
