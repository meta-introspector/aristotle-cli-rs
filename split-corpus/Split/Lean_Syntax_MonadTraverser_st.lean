import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.MonadTraverser.st : forall {m : Type -> Type} [self : Lean.Syntax.MonadTraverser m], MonadState.{0, 0} Lean.Syntax.Traverser m
def Lean.Syntax.MonadTraverser.st : forall {m : Type -> Type} [self : Lean.Syntax.MonadTraverser m], MonadState.{0, 0} Lean.Syntax.Traverser m :=
  fun (m : Type -> Type) [self : Lean.Syntax.MonadTraverser m] => self.1
