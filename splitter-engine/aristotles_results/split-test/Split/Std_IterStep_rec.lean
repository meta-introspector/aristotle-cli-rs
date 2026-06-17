import Split.Std_IterStep
import Split.Std_IterStep_skip
import Split.Std_IterStep_yield
import Split.Std_IterStep_done

-- Std.IterStep.rec from environment
-- recursor Std.IterStep.rec : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {motive : (Std.IterStep.{u_1, u_2} α β) -> Sort.{u}}, (forall (it : α) (out : β), motive (Std.IterStep.yield.{u_1, u_2} α β it out)) -> (forall (it : α), motive (Std.IterStep.skip.{u_1, u_2} α β it)) -> (motive (Std.IterStep.done.{u_1, u_2} α β)) -> (forall (t : Std.IterStep.{u_1, u_2} α β), motive t)

-- Stub: this file represents the declaration `Std.IterStep.rec`.
-- In a full split, the body would be extracted from the environment.
