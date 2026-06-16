import Split.outParam
import Split.Exists
import Split.CanLift
import Split.Eq

-- CanLift.mk from environment
-- constructor CanLift.mk : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {coe : outParam.{imax u_2 u_1} (β -> α)} {cond : outParam.{max 1 u_1} (α -> Prop)}, (forall (x : α), (cond x) -> (Exists.{u_2} β (fun (y : β) => Eq.{u_1} α (coe y) x))) -> (CanLift.{u_1, u_2} α β coe cond)

-- Stub: this file represents the declaration `CanLift.mk`.
-- In a full split, the body would be extracted from the environment.
