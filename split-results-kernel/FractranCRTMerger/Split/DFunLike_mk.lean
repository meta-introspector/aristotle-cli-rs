import Split.outParam
import Split.DFunLike
import Split.Function_Injective

-- DFunLike.mk from environment
-- constructor DFunLike.mk : forall {F : Sort.{u_1}} {α : outParam.{succ u_2} Sort.{u_2}} {β : outParam.{max u_2 (succ u_3)} (α -> Sort.{u_3})} (coe : F -> (forall (a : α), β a)), (Function.Injective.{u_1, imax u_2 u_3} F (forall (a : α), β a) coe) -> (DFunLike.{u_1, u_2, u_3} F α β)

-- Stub: this file represents the declaration `DFunLike.mk`.
-- In a full split, the body would be extracted from the environment.
