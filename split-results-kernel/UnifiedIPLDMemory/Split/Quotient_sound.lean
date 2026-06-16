import Split.Quot_sound
import Split.Setoid
import Split.Quotient_mk
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.Eq

-- Quotient.sound from environment
-- theorem Quotient.sound : forall {α : Sort.{u}} {s : Setoid.{u} α} {a : α} {b : α}, (HasEquiv.Equiv.{u, 0} α (instHasEquivOfSetoid.{u} α s) a b) -> (Eq.{u} (Quotient.{u} α s) (Quotient.mk.{u} α s a) (Quotient.mk.{u} α s b))

-- Stub: this file represents the declaration `Quotient.sound`.
-- In a full split, the body would be extracted from the environment.
