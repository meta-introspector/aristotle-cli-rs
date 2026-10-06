import Mathlib

set_option pp.all true
-- spec: Lean.withRef : forall {m : Type -> Type} [inst._@.Init.Prelude.1752495194._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Init.Prelude.1752495194._hygCtx._hyg.8 : Lean.MonadRef m] {α : Type}, Lean.Syntax -> (m α) -> (m α)
def Lean.withRef : forall {m : Type -> Type} [inst._@.Init.Prelude.1752495194._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Init.Prelude.1752495194._hygCtx._hyg.8 : Lean.MonadRef m] {α : Type}, Lean.Syntax -> (m α) -> (m α) :=
  fun {m : Type -> Type} [inst._@.Init.Prelude.1752495194._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Init.Prelude.1752495194._hygCtx._hyg.8 : Lean.MonadRef m] {α : Type} (ref : Lean.Syntax) (x : m α) => Bind.bind.{0, 0} m (Monad.toBind.{0, 0} m inst._@.Init.Prelude.1752495194._hygCtx._hyg.5) Lean.Syntax α (Lean.MonadRef.getRef m inst._@.Init.Prelude.1752495194._hygCtx._hyg.8) (fun (oldRef : Lean.Syntax) => have ref : Lean.Syntax := Lean.replaceRef ref oldRef; Lean.MonadRef.withRef m inst._@.Init.Prelude.1752495194._hygCtx._hyg.8 α ref x)
