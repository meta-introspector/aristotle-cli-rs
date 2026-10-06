import Mathlib

set_option pp.all true
-- spec: Lean.instExceptToTraceResult : forall {α : Type} {ε : Type}, Lean.ExceptToTraceResult ε α
def Lean.instExceptToTraceResult : forall {α : Type} {ε : Type}, Lean.ExceptToTraceResult ε α :=
  fun {α : Type} {ε : Type} => Lean.ExceptToTraceResult.mk ε α (fun (x._@.Lean.Util.Trace.2904460784._hygCtx._hyg.35 : Except.{0, 0} ε α) => Lean.instExceptToTraceResult.match_1.{1} α ε (fun (x._@.Lean.Util.Trace.2904460784._hygCtx.35.Lean.Util.Trace.2904460784._hygCtx._hyg.47 : Except.{0, 0} ε α) => Lean.TraceResult) x._@.Lean.Util.Trace.2904460784._hygCtx._hyg.35 (fun (a._@._internal.0.Lean.Util.Trace.2904460784._hygCtx._hyg.53 : ε) => Lean.TraceResult.error) (fun (a._@._internal.0.Lean.Util.Trace.2904460784._hygCtx._hyg.61 : α) => Lean.TraceResult.success))
