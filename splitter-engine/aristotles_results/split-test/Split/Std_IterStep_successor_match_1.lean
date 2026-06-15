import Split.Unit_unit
import Split.Std_IterStep
import Split.Std_IterStep_skip
import Split.Unit
import Split.Std_IterStep_yield
import Split.Std_IterStep_done
import Split.Std_IterStep_casesOn

-- Std.IterStep.successor.match_1 from environment
-- def Std.IterStep.successor.match_1 : forall {α : Type.{u_1}} {β : Type.{u_2}} (motive : (Std.IterStep.{succ u_1, succ u_2} α β) -> Sort.{u_3}) (x._@.Init.Data.Iterators.Basic.1473718047._hygCtx.10.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.21 : Std.IterStep.{succ u_1, succ u_2} α β), (forall (it : α) (out._@.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.29 : β), motive (Std.IterStep.yield.{succ u_1, succ u_2} α β it out._@.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.29)) -> (forall (it : α), motive (Std.IterStep.skip.{succ u_1, succ u_2} α β it)) -> (Unit -> (motive (Std.IterStep.done.{succ u_1, succ u_2} α β))) -> (motive x._@.Init.Data.Iterators.Basic.1473718047._hygCtx.10.Init.Data.Iterators.Basic.1473718047._hygCtx._hyg.21)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterStep.successor.match_1`.
-- In a full split, the body would be extracted from the environment.
