import Split.Multiset_sum
import Split.instHSMul
import Split.HMul_hMul
import Split.Multiset_map
import Split.Multiset_instSProd
import Split.SProd_sprod
import Split.congrArg
import Split.AddMonoid_toNSMul
import Split.Function_comp
import Split.Membership_mem
import Split.Multiset
import Split.Prod_mk
import Split.instMulNat
import Split.Multiset_instMembership
import Split.Multiset_sum_replicate
import Split.Nat
import Split.True
import Split.eq_self
import Split.Multiset_map_congr
import Split.of_eq_true
import Split.Nat_instAddCommMonoid
import Split.Multiset_card
import Split.Eq_refl
import Split.HSMul_hSMul
import Split.congrFun'
import Split.AddCommMonoid_toAddMonoid
import Split.Multiset_replicate
import Split.Prod
import Split.Eq
import Split.Multiset_bind
import Split.Multiset_map_const'
import Split.Multiset_card_bind
import Split.Eq_trans
import Split.Multiset_card_map
import Split.instHMul

-- Multiset.card_product from environment
-- theorem Multiset.card_product : forall {α : Type.{u_1}} {β : Type.{v}} (s : Multiset.{u_1} α) (t : Multiset.{v} β), Eq.{1} Nat (Multiset.card.{max u_1 v} (Prod.{u_1, v} α β) (SProd.sprod.{u_1, v, max u_1 v} (Multiset.{u_1} α) (Multiset.{v} β) (Multiset.{max v u_1} (Prod.{u_1, v} α β)) (Multiset.instSProd.{v, u_1} α β) s t)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Multiset.card.{u_1} α s) (Multiset.card.{v} β t))

-- Stub: this file represents the declaration `Multiset.card_product`.
-- In a full split, the body would be extracted from the environment.
