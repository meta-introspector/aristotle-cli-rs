import Split.Function_LeftInverse
import Split.Membership_mem
import Split.Equiv_mk
import Split.Set_Elem
import Split.Equiv
import Split.Subtype_mk
import Split.Nonempty
import Split.Set_range
import Split.Subtype_val
import Split.Set_instMembership
import Split.Set

-- Equiv.ofLeftInverse from environment
-- def Equiv.ofLeftInverse : forall {α : Sort.{u_3}} {β : Type.{u_4}} (f : α -> β) (f_inv : (Nonempty.{u_3} α) -> β -> α), (forall (h : Nonempty.{u_3} α), Function.LeftInverse.{u_3, succ u_4} α β (f_inv h) f) -> (Equiv.{u_3, succ u_4} α (Set.Elem.{u_4} β (Set.range.{u_4, u_3} β α f)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Equiv.ofLeftInverse`.
-- In a full split, the body would be extracted from the environment.
