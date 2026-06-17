import Split.Quot_liftOn
import Split.Setoid
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.Eq
import Split.Setoid_r

-- Quotient.liftOn from environment
-- def Quotient.liftOn : forall {α : Sort.{u}} {β : Sort.{v}} {s : Setoid.{u} α}, (Quotient.{u} α s) -> (forall (f : α -> β), (forall (a : α) (b : α), (HasEquiv.Equiv.{u, 0} α (instHasEquivOfSetoid.{u} α s) a b) -> (Eq.{v} β (f a) (f b))) -> β)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.liftOn`.
-- In a full split, the body would be extracted from the environment.
