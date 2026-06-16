import Split.Multiset
import Split.Multiset_cons
import Split.Zero_toOfNat0
import Split.Multiset_induction
import Split.OfNat_ofNat
import Split.Multiset_instZero

-- Multiset.induction_on from environment
-- theorem Multiset.induction_on : forall {α : Type.{u_1}} {p : (Multiset.{u_1} α) -> Prop} (s : Multiset.{u_1} α), (p (OfNat.ofNat.{u_1} (Multiset.{u_1} α) 0 (Zero.toOfNat0.{u_1} (Multiset.{u_1} α) (Multiset.instZero.{u_1} α)))) -> (forall (a : α) (s : Multiset.{u_1} α), (p s) -> (p (Multiset.cons.{u_1} α a s))) -> (p s)

-- Stub: this file represents the declaration `Multiset.induction_on`.
-- In a full split, the body would be extracted from the environment.
