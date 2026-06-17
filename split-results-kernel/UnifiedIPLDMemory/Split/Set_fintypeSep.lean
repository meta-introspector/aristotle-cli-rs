import Split.setOf
import Split.Membership_mem
import Split.Set_Elem
import Split.Fintype_ofFinset
import Split.Set_toFinset
import Split.And
import Split.Fintype
import Split.DecidablePred
import Split.Finset_filter
import Split.Set_instMembership
import Split.Set

-- Set.fintypeSep from environment
-- def Set.fintypeSep : forall {α : Type.{u}} (s : Set.{u} α) (p : α -> Prop) [inst._@.Mathlib.Data.Set.Finite.Basic.463295175._hygCtx._hyg.11 : Fintype.{u} (Set.Elem.{u} α s)] [inst._@.Mathlib.Data.Set.Finite.Basic.463295175._hygCtx._hyg.14 : DecidablePred.{succ u} α p], Fintype.{u} (Set.Elem.{u} α (setOf.{u} α (fun (a : α) => And (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s a) (p a))))
-- (definition body omitted)

-- Stub: this file represents the declaration `Set.fintypeSep`.
-- In a full split, the body would be extracted from the environment.
