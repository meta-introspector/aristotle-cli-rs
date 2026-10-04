import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.MonadTraverser.goUp : forall {m : Type -> Type} [t : Lean.Syntax.MonadTraverser m], m Unit
def Lean.Syntax.MonadTraverser.goUp : forall {m : Type -> Type} [t : Lean.Syntax.MonadTraverser m], m Unit :=
  fun {m : Type -> Type} [t : Lean.Syntax.MonadTraverser m] => modify.{0, 0} Lean.Syntax.Traverser m (Lean.Syntax.MonadTraverser.st m t) (fun (t : Lean.Syntax.Traverser) => Lean.Syntax.Traverser.up t)
