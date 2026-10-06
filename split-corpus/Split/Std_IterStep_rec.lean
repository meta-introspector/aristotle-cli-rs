import Mathlib

-- spec: recursor Std.IterStep.rec : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {motive : (Std.IterStep.{u_1, u_2} α β) -> Sort.{u}}, (forall (it : α) (out : β), motive (Std.IterStep.yield.{u_1, u_2} α β it out)) -> (forall (it : α), motive (Std.IterStep.skip.{u_1, u_2} α β it)) -> (motive (Std.IterStep.done.{u_1, u_2} α β)) -> (forall (t : Std.IterStep.{u_1, u_2} α β), motive t)
