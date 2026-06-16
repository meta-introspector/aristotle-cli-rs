import Split.Quot_sound
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Eq_rec
import Split.Multiset
import Split.List_Perm
import Split.LE_le
import Split.Quotient_mk
import Split.List
import Split.Multiset_ofList
import Split.Quotient
import Split.Quotient_inductionOn₂
import Split.List_Sublist
import Split.List_isSetoid
import Split.Eq
import Split.Setoid_r
import Split.Multiset_instPartialOrder

-- Multiset.leInductionOn from environment
-- theorem Multiset.leInductionOn : forall {α : Type.{u_1}} {C : (Multiset.{u_1} α) -> (Multiset.{u_1} α) -> Prop} {s : Multiset.{u_1} α} {t : Multiset.{u_1} α}, (LE.le.{u_1} (Multiset.{u_1} α) (Preorder.toLE.{u_1} (Multiset.{u_1} α) (PartialOrder.toPreorder.{u_1} (Multiset.{u_1} α) (Multiset.instPartialOrder.{u_1} α))) s t) -> (forall {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, (List.Sublist.{u_1} α l₁ l₂) -> (C (Multiset.ofList.{u_1} α l₁) (Multiset.ofList.{u_1} α l₂))) -> (C s t)

-- Stub: this file represents the declaration `Multiset.leInductionOn`.
-- In a full split, the body would be extracted from the environment.
