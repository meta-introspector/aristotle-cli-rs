import Split.UniformSpace
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.nhds
import Split.Prod_mk
import Split.LE_le
import Split.SetRel_comp
import Split.TopologicalSpace
import Split.Filter_lift'
import Split.Filter_Tendsto
import Split.Prod_swap
import Split.Prod
import Split.Eq
import Split.Filter
import Split.Filter_comap
import Split.Filter_instPartialOrder
import Split.Set

-- UniformSpace.mk from environment
-- constructor UniformSpace.mk : forall {α : Type.{u}} [toTopologicalSpace : TopologicalSpace.{u} α] (uniformity : Filter.{u} (Prod.{u, u} α α)), (Filter.Tendsto.{u, u} (Prod.{u, u} α α) (Prod.{u, u} α α) (Prod.swap.{u, u} α α) uniformity uniformity) -> (LE.le.{u} (Filter.{u} (Prod.{u, u} α α)) (Preorder.toLE.{u} (Filter.{u} (Prod.{u, u} α α)) (PartialOrder.toPreorder.{u} (Filter.{u} (Prod.{u, u} α α)) (Filter.instPartialOrder.{u} (Prod.{u, u} α α)))) (Filter.lift'.{u, u} (Prod.{u, u} α α) (Prod.{u, u} α α) uniformity (fun (s : Set.{u} (Prod.{u, u} α α)) => SetRel.comp.{u, u, u} α α α s s)) uniformity) -> (forall (x : α), Eq.{succ u} (Filter.{u} α) (nhds.{u} α toTopologicalSpace x) (Filter.comap.{u, u} α (Prod.{u, u} α α) (Prod.mk.{u, u} α α x) uniformity)) -> (UniformSpace.{u} α)

-- Stub: this file represents the declaration `UniformSpace.mk`.
-- In a full split, the body would be extracted from the environment.
