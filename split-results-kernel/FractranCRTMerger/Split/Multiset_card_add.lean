import Split.Multiset
import Split.List_length_append
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Quotient_inductionOn₂
import Split.Nat
import Split.instAddNat
import Split.Multiset_card
import Split.List_isSetoid
import Split.Eq
import Split.Multiset_instAdd

-- Multiset.card_add from environment
-- theorem Multiset.card_add : forall {α : Type.{u_1}} (s : Multiset.{u_1} α) (t : Multiset.{u_1} α), Eq.{1} Nat (Multiset.card.{u_1} α (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) s t)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Multiset.card.{u_1} α s) (Multiset.card.{u_1} α t))

-- Stub: this file represents the declaration `Multiset.card_add`.
-- In a full split, the body would be extracted from the environment.
