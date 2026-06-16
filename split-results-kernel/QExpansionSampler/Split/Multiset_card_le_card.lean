import Split.List_Sublist_length_le
import Split.Multiset_leInductionOn
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Multiset
import Split.LE_le
import Split.instLENat
import Split.List
import Split.Nat
import Split.Multiset_card
import Split.Multiset_instPartialOrder

-- Multiset.card_le_card from environment
-- theorem Multiset.card_le_card : forall {α : Type.{u_1}} {s : Multiset.{u_1} α} {t : Multiset.{u_1} α}, (LE.le.{u_1} (Multiset.{u_1} α) (Preorder.toLE.{u_1} (Multiset.{u_1} α) (PartialOrder.toPreorder.{u_1} (Multiset.{u_1} α) (Multiset.instPartialOrder.{u_1} α))) s t) -> (LE.le.{0} Nat instLENat (Multiset.card.{u_1} α s) (Multiset.card.{u_1} α t))

-- Stub: this file represents the declaration `Multiset.card_le_card`.
-- In a full split, the body would be extracted from the environment.
