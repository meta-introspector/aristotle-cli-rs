import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.MonadTraverser.goDown : forall {m : Type -> Type} [t : Lean.Syntax.MonadTraverser m], Nat -> (m Unit)
def Lean.Syntax.MonadTraverser.goDown : forall {m : Type -> Type} [t : Lean.Syntax.MonadTraverser m], Nat -> (m Unit) :=
  fun {m : Type -> Type} [t : Lean.Syntax.MonadTraverser m] (idx : Nat) => modify.{0, 0} Lean.Syntax.Traverser m (Lean.Syntax.MonadTraverser.st m t) (fun (t : Lean.Syntax.Traverser) => Lean.Syntax.Traverser.down t idx)
