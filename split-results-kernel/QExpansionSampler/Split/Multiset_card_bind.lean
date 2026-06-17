import Split.Multiset_sum
import Split.Multiset_map
import Split.congrArg
import Split.Function_comp
import Split.Membership_mem
import Split.Multiset
import Split.Multiset_instMembership
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.Multiset_join
import Split.Multiset_map_congr
import Split.of_eq_true
import Split.Nat_instAddCommMonoid
import Split.Multiset_map_map
import Split.Multiset_card
import Split.Eq_refl
import Split.Multiset_card_join
import Split.Eq
import Split.Multiset_bind
import Split.Eq_trans

-- Multiset.card_bind from environment
-- theorem Multiset.card_bind : forall {α : Type.{u_1}} {β : Type.{v}} (s : Multiset.{u_1} α) (f : α -> (Multiset.{v} β)), Eq.{1} Nat (Multiset.card.{v} β (Multiset.bind.{v, u_1} α β s f)) (Multiset.sum.{0} Nat Nat.instAddCommMonoid (Multiset.map.{0, u_1} α Nat (Function.comp.{succ u_1, succ v, 1} α (Multiset.{v} β) Nat (Multiset.card.{v} β) f) s))

-- Stub: this file represents the declaration `Multiset.card_bind`.
-- In a full split, the body would be extracted from the environment.
