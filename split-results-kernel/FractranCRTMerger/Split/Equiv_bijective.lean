import Split.Equiv_instEquivLike
import Split.Equiv
import Split.EquivLike_bijective
import Split.Function_Bijective
import Split.DFunLike_coe
import Split.EquivLike_toFunLike

-- Equiv.bijective from environment
-- theorem Equiv.bijective : forall {α : Sort.{u}} {β : Sort.{v}} (e : Equiv.{u, v} α β), Function.Bijective.{u, v} α β (DFunLike.coe.{max (max 1 u) v, u, v} (Equiv.{u, v} α β) α (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : α) => β) (EquivLike.toFunLike.{max (max 1 u) v, u, v} (Equiv.{u, v} α β) α β (Equiv.instEquivLike.{u, v} α β)) e)

-- Stub: this file represents the declaration `Equiv.bijective`.
-- In a full split, the body would be extracted from the environment.
