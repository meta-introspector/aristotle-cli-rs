import Split.Quot_ind
import Split.Multiset
import Split.Multiset_cons
import Split.List_rec
import Split.List
import Split.Zero_toOfNat0
import Split.List_isSetoid
import Split.OfNat_ofNat
import Split.Setoid_r
import Split.Quot_mk
import Split.Multiset_instZero

-- Multiset.induction from environment
-- theorem Multiset.induction : forall {α : Type.{u_1}} {p : (Multiset.{u_1} α) -> Prop}, (p (OfNat.ofNat.{u_1} (Multiset.{u_1} α) 0 (Zero.toOfNat0.{u_1} (Multiset.{u_1} α) (Multiset.instZero.{u_1} α)))) -> (forall (a : α) (s : Multiset.{u_1} α), (p s) -> (p (Multiset.cons.{u_1} α a s))) -> (forall (s : Multiset.{u_1} α), p s)

-- Stub: this file represents the declaration `Multiset.induction`.
-- In a full split, the body would be extracted from the environment.
