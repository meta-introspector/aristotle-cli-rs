import Split.outParam
import Split.Exists
import Split.CanLift
import Split.Eq

-- CanLift.prf from environment
-- theorem CanLift.prf : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {coe : outParam.{imax u_2 u_1} (β -> α)} {cond : outParam.{max 1 u_1} (α -> Prop)} [self : CanLift.{u_1, u_2} α β coe cond] (x : α), (cond x) -> (Exists.{u_2} β (fun (y : β) => Eq.{u_1} α (coe y) x))

-- Stub: this file represents the declaration `CanLift.prf`.
-- In a full split, the body would be extracted from the environment.
