import Mathlib

set_option pp.all true
-- spec: instMonadControlReaderT : forall {m : Type.{u_1} -> Type.{u_2}} {ρ : Type.{u_1}}, MonadControl.{u_1, u_2, max u_2 u_1} m (ReaderT.{u_1, u_2} ρ m)
def instMonadControlReaderT : forall {m : Type.{u_1} -> Type.{u_2}} {ρ : Type.{u_1}}, MonadControl.{u_1, u_2, max u_2 u_1} m (ReaderT.{u_1, u_2} ρ m) :=
  fun {m : Type.{u_1} -> Type.{u_2}} {ρ : Type.{u_1}} => MonadControl.mk.{u_1, u_2, max u_2 u_1} m (ReaderT.{u_1, u_2} ρ m) (id.{succ (succ u_1)} Type.{u_1}) (fun {α._@.Init.Control.Reader.376596232._hygCtx._hyg.25 : Type.{u_1}} (f : (forall {β : Type.{u_1}}, (ReaderT.{u_1, u_2} ρ m β) -> (m (id.{succ (succ u_1)} Type.{u_1} β))) -> (m α._@.Init.Control.Reader.376596232._hygCtx._hyg.25)) (ctx : ρ) => f (fun {β._@.Init.Control.Reader.376596232._hygCtx._hyg.31 : Type.{u_1}} (x : ReaderT.{u_1, u_2} ρ m β._@.Init.Control.Reader.376596232._hygCtx._hyg.31) => x ctx)) (fun {α._@.Init.Control.Reader.376596232._hygCtx._hyg.37 : Type.{u_1}} (x : m (id.{succ (succ u_1)} Type.{u_1} α._@.Init.Control.Reader.376596232._hygCtx._hyg.37)) (x._@.Init.Control.Reader.376596232._hygCtx._hyg.39 : ρ) => x)
