import Mathlib

set_option pp.all true
-- spec: Lean.MonadTrace.getInheritedTraceOptions : forall {m : Type -> Type} [self : Lean.MonadTrace m], m (Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName)
def Lean.MonadTrace.getInheritedTraceOptions : forall {m : Type -> Type} [self : Lean.MonadTrace m], m (Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) :=
  fun (m : Type -> Type) [self : Lean.MonadTrace m] => self.3
