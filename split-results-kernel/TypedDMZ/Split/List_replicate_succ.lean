import Split.List_replicate
import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl

-- List.replicate_succ from environment
-- theorem List.replicate_succ : forall {α : Type.{u}} {a : α} {n : Nat}, Eq.{succ u} (List.{u} α) (List.replicate.{u} α (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) a) (List.cons.{u} α a (List.replicate.{u} α n a))

-- Stub: this file represents the declaration `List.replicate_succ`.
-- In a full split, the body would be extracted from the environment.
