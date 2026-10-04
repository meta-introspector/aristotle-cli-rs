import Mathlib

set_option pp.all true
-- spec: Lean.MonadTrace.modifyTraceState : forall {m : Type -> Type} [self : Lean.MonadTrace m], (Lean.TraceState -> Lean.TraceState) -> (m Unit)
def Lean.MonadTrace.modifyTraceState : forall {m : Type -> Type} [self : Lean.MonadTrace m], (Lean.TraceState -> Lean.TraceState) -> (m Unit) :=
  fun (m : Type -> Type) [self : Lean.MonadTrace m] => self.1
