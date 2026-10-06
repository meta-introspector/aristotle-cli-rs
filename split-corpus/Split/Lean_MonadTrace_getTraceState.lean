import Mathlib

set_option pp.all true
-- spec: Lean.MonadTrace.getTraceState : forall {m : Type -> Type} [self : Lean.MonadTrace m], m Lean.TraceState
def Lean.MonadTrace.getTraceState : forall {m : Type -> Type} [self : Lean.MonadTrace m], m Lean.TraceState :=
  fun (m : Type -> Type) [self : Lean.MonadTrace m] => self.2
