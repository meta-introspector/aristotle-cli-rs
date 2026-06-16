import Split.Setoid
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.Quot_map
import Split.Setoid_r

-- Quotient.map from environment
-- def Quotient.map : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {sa : Setoid.{u_1} α} {sb : Setoid.{u_2} β} (f : α -> β), (forall {{a : α}} {{b : α}}, (HasEquiv.Equiv.{u_1, 0} α (instHasEquivOfSetoid.{u_1} α sa) a b) -> (HasEquiv.Equiv.{u_2, 0} β (instHasEquivOfSetoid.{u_2} β sb) (f a) (f b))) -> (Quotient.{u_1} α sa) -> (Quotient.{u_2} β sb)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.map`.
-- In a full split, the body would be extracted from the environment.
