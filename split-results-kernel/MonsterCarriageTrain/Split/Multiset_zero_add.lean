import Split.Multiset
import Split.Quotient_inductionOn
import Split.Quotient_mk
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Zero_toOfNat0
import Split.List_isSetoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Multiset_instAdd
import Split.rfl
import Split.Multiset_instZero

-- Multiset.zero_add from environment
-- theorem Multiset.zero_add : forall {α : Type.{u_1}} (s : Multiset.{u_1} α), Eq.{succ u_1} (Multiset.{u_1} α) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) (OfNat.ofNat.{u_1} (Multiset.{u_1} α) 0 (Zero.toOfNat0.{u_1} (Multiset.{u_1} α) (Multiset.instZero.{u_1} α))) s) s

-- Stub: this file represents the declaration `Multiset.zero_add`.
-- In a full split, the body would be extracted from the environment.
