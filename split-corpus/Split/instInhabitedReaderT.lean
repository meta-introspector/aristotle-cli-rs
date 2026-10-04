import Mathlib

set_option pp.all true
-- spec: instInhabitedReaderT : forall (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) (α : Type.{u}) [inst._@.Init.Prelude.83305912._hygCtx._hyg.7 : Inhabited.{succ v} (m α)], Inhabited.{max (succ v) (succ u)} (ReaderT.{u, v} ρ m α)
def instInhabitedReaderT : forall (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) (α : Type.{u}) [inst._@.Init.Prelude.83305912._hygCtx._hyg.7 : Inhabited.{succ v} (m α)], Inhabited.{max (succ v) (succ u)} (ReaderT.{u, v} ρ m α) :=
  fun (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) (α : Type.{u}) [inst._@.Init.Prelude.83305912._hygCtx._hyg.7 : Inhabited.{succ v} (m α)] => Inhabited.mk.{max (succ u) (succ v)} (ReaderT.{u, v} ρ m α) (fun (x._@.Init.Prelude.83305912._hygCtx._hyg.25 : ρ) => Inhabited.default.{succ v} (m α) inst._@.Init.Prelude.83305912._hygCtx._hyg.7)
