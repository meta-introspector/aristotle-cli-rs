import Split.Quot_inductionOn
import Split.Multiset
import Split.Multiset_cons
import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Multiset_card
import Split.List_isSetoid
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.card_cons from environment
-- theorem Multiset.card_cons : forall {α : Type.{u_1}} (a : α) (s : Multiset.{u_1} α), Eq.{1} Nat (Multiset.card.{u_1} α (Multiset.cons.{u_1} α a s)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Multiset.card.{u_1} α s) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

-- Stub: this file represents the declaration `Multiset.card_cons`.
-- In a full split, the body would be extracted from the environment.
