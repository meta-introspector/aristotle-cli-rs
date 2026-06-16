import Split.Equiv_instEquivLike
import Split.Equiv
import Split.Function_Injective
import Split.EquivLike_injective
import Split.DFunLike_coe
import Split.EquivLike_toFunLike

-- Equiv.injective from environment
-- theorem Equiv.injective : forall {α : Sort.{u}} {β : Sort.{v}} (e : Equiv.{u, v} α β), Function.Injective.{u, v} α β (DFunLike.coe.{max (max 1 u) v, u, v} (Equiv.{u, v} α β) α (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : α) => β) (EquivLike.toFunLike.{max (max 1 u) v, u, v} (Equiv.{u, v} α β) α β (Equiv.instEquivLike.{u, v} α β)) e)

-- Stub: this file represents the declaration `Equiv.injective`.
-- In a full split, the body would be extracted from the environment.
