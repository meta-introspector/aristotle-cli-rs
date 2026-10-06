import Mathlib

set_option pp.all true
-- spec: Lean.modifyTraces : forall {m : Type -> Type} [inst._@.Lean.Util.Trace.2602629369._hygCtx._hyg.9 : Lean.MonadTrace m], ((Lean.PersistentArray.{0} Lean.TraceElem) -> (Lean.PersistentArray.{0} Lean.TraceElem)) -> (m Unit)
def Lean.modifyTraces : forall {m : Type -> Type} [inst._@.Lean.Util.Trace.2602629369._hygCtx._hyg.9 : Lean.MonadTrace m], ((Lean.PersistentArray.{0} Lean.TraceElem) -> (Lean.PersistentArray.{0} Lean.TraceElem)) -> (m Unit) :=
  fun {m : Type -> Type} [inst._@.Lean.Util.Trace.2602629369._hygCtx._hyg.9 : Lean.MonadTrace m] (f : (Lean.PersistentArray.{0} Lean.TraceElem) -> (Lean.PersistentArray.{0} Lean.TraceElem)) => Lean.MonadTrace.modifyTraceState m inst._@.Lean.Util.Trace.2602629369._hygCtx._hyg.9 (fun (s : Lean.TraceState) => Lean.TraceState.mk (Lean.TraceState.tid s) (f (Lean.TraceState.traces s)))
