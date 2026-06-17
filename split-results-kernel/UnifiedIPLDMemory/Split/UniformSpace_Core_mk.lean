import Split.SetRel_id
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.SetRel_comp
import Split.Filter_lift'
import Split.Filter_Tendsto
import Split.Filter_principal
import Split.Prod_swap
import Split.Prod
import Split.UniformSpace_Core
import Split.Filter
import Split.Filter_instPartialOrder
import Split.Set

-- UniformSpace.Core.mk from environment
-- constructor UniformSpace.Core.mk : forall {α : Type.{u}} (uniformity : Filter.{u} (Prod.{u, u} α α)), (LE.le.{u} (Filter.{u} (Prod.{u, u} α α)) (Preorder.toLE.{u} (Filter.{u} (Prod.{u, u} α α)) (PartialOrder.toPreorder.{u} (Filter.{u} (Prod.{u, u} α α)) (Filter.instPartialOrder.{u} (Prod.{u, u} α α)))) (Filter.principal.{u} (Prod.{u, u} α α) (SetRel.id.{u} α)) uniformity) -> (Filter.Tendsto.{u, u} (Prod.{u, u} α α) (Prod.{u, u} α α) (Prod.swap.{u, u} α α) uniformity uniformity) -> (LE.le.{u} (Filter.{u} (Prod.{u, u} α α)) (Preorder.toLE.{u} (Filter.{u} (Prod.{u, u} α α)) (PartialOrder.toPreorder.{u} (Filter.{u} (Prod.{u, u} α α)) (Filter.instPartialOrder.{u} (Prod.{u, u} α α)))) (Filter.lift'.{u, u} (Prod.{u, u} α α) (Prod.{u, u} α α) uniformity (fun (s : Set.{u} (Prod.{u, u} α α)) => SetRel.comp.{u, u, u} α α α s s)) uniformity) -> (UniformSpace.Core.{u} α)

-- Stub: this file represents the declaration `UniformSpace.Core.mk`.
-- In a full split, the body would be extracted from the environment.
