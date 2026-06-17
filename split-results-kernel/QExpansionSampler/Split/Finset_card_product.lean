import Split.HMul_hMul
import Split.SProd_sprod
import Split.Finset
import Split.instMulNat
import Split.Finset_val
import Split.Multiset_card_product
import Split.Finset_instSProd
import Split.Nat
import Split.Finset_card
import Split.Prod
import Split.Eq
import Split.instHMul

-- Finset.card_product from environment
-- theorem Finset.card_product : forall {α : Type.{u_1}} {β : Type.{u_2}} (s : Finset.{u_1} α) (t : Finset.{u_2} β), Eq.{1} Nat (Finset.card.{max u_1 u_2} (Prod.{u_1, u_2} α β) (SProd.sprod.{u_1, u_2, max u_1 u_2} (Finset.{u_1} α) (Finset.{u_2} β) (Finset.{max u_2 u_1} (Prod.{u_1, u_2} α β)) (Finset.instSProd.{u_1, u_2} α β) s t)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Finset.card.{u_1} α s) (Finset.card.{u_2} β t))

-- Stub: this file represents the declaration `Finset.card_product`.
-- In a full split, the body would be extracted from the environment.
