import Split.Std_IterStep
import Split.Std_IterStep_skip
import Split.Std_IterStep_rec
import Split.Std_IterStep_yield
import Split.Std_IterStep_done

-- Std.IterStep.casesOn from environment
-- def Std.IterStep.casesOn : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {motive : (Std.IterStep.{u_1, u_2} α β) -> Sort.{u}} (t : Std.IterStep.{u_1, u_2} α β), (forall (it : α) (out : β), motive (Std.IterStep.yield.{u_1, u_2} α β it out)) -> (forall (it : α), motive (Std.IterStep.skip.{u_1, u_2} α β it)) -> (motive (Std.IterStep.done.{u_1, u_2} α β)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterStep.casesOn`.
-- In a full split, the body would be extracted from the environment.
