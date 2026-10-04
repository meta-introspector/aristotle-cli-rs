import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.MonadTraverser.getCur : forall {m : Type -> Type} [inst._@.Lean.Syntax.3624857742._hygCtx._hyg.5 : Monad.{0, 0} m] [t : Lean.Syntax.MonadTraverser m], m Lean.Syntax
def Lean.Syntax.MonadTraverser.getCur : forall {m : Type -> Type} [inst._@.Lean.Syntax.3624857742._hygCtx._hyg.5 : Monad.{0, 0} m] [t : Lean.Syntax.MonadTraverser m], m Lean.Syntax :=
  fun {m : Type -> Type} [inst._@.Lean.Syntax.3624857742._hygCtx._hyg.5 : Monad.{0, 0} m] [t : Lean.Syntax.MonadTraverser m] => Functor.map.{0, 0} m (Applicative.toFunctor.{0, 0} m (Monad.toApplicative.{0, 0} m inst._@.Lean.Syntax.3624857742._hygCtx._hyg.5)) Lean.Syntax.Traverser Lean.Syntax Lean.Syntax.Traverser.cur (MonadState.get.{0, 0} Lean.Syntax.Traverser m (Lean.Syntax.MonadTraverser.st m t))
