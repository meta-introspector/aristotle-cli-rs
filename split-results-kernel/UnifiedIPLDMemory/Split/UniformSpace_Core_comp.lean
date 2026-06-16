import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.UniformSpace_Core_uniformity
import Split.SetRel_comp
import Split.Filter_lift'
import Split.Prod
import Split.UniformSpace_Core
import Split.Filter
import Split.Filter_instPartialOrder
import Split.Set

-- UniformSpace.Core.comp from environment
-- theorem UniformSpace.Core.comp : forall {α : Type.{u}} (self : UniformSpace.Core.{u} α), LE.le.{u} (Filter.{u} (Prod.{u, u} α α)) (Preorder.toLE.{u} (Filter.{u} (Prod.{u, u} α α)) (PartialOrder.toPreorder.{u} (Filter.{u} (Prod.{u, u} α α)) (Filter.instPartialOrder.{u} (Prod.{u, u} α α)))) (Filter.lift'.{u, u} (Prod.{u, u} α α) (Prod.{u, u} α α) (UniformSpace.Core.uniformity.{u} α self) (fun (s : Set.{u} (Prod.{u, u} α α)) => SetRel.comp.{u, u, u} α α α s s)) (UniformSpace.Core.uniformity.{u} α self)

-- Stub: this file represents the declaration `UniformSpace.Core.comp`.
-- In a full split, the body would be extracted from the environment.
