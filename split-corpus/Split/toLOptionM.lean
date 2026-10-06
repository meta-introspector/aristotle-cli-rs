import Mathlib

set_option pp.all true
-- spec: toLOptionM : forall {α : Type} {m : Type -> Type} [inst._@.Lean.Data.LOption.871359945._hygCtx._hyg.6 : Monad.{0, 0} m], (m (Option.{0} α)) -> (m (Lean.LOption.{0} α))
def toLOptionM : forall {α : Type} {m : Type -> Type} [inst._@.Lean.Data.LOption.871359945._hygCtx._hyg.6 : Monad.{0, 0} m], (m (Option.{0} α)) -> (m (Lean.LOption.{0} α)) :=
  fun {α : Type} {m : Type -> Type} [inst._@.Lean.Data.LOption.871359945._hygCtx._hyg.6 : Monad.{0, 0} m] (x : m (Option.{0} α)) => Bind.bind.{0, 0} m (Monad.toBind.{0, 0} m inst._@.Lean.Data.LOption.871359945._hygCtx._hyg.6) (Option.{0} α) (Lean.LOption.{0} α) x (fun (b : Option.{0} α) => Pure.pure.{0, 0} m (Applicative.toPure.{0, 0} m (Monad.toApplicative.{0, 0} m inst._@.Lean.Data.LOption.871359945._hygCtx._hyg.6)) (Lean.LOption.{0} α) (Option.toLOption.{0} α b))
