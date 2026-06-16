import Split.Quot_lift
import Split.Setoid
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.Eq

-- Quotient.lift from environment
-- def Quotient.lift : forall {α : Sort.{u}} {β : Sort.{v}} {s : Setoid.{u} α} (f : α -> β), (forall (a : α) (b : α), (HasEquiv.Equiv.{u, 0} α (instHasEquivOfSetoid.{u} α s) a b) -> (Eq.{v} β (f a) (f b))) -> (Quotient.{u} α s) -> β
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.lift`.
-- In a full split, the body would be extracted from the environment.
