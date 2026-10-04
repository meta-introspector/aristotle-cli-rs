import Mathlib

set_option pp.all true
-- spec: Lean.instExceptToTraceResultBool : forall {ε : Type}, Lean.ExceptToTraceResult ε Bool
def Lean.instExceptToTraceResultBool : forall {ε : Type}, Lean.ExceptToTraceResult ε Bool :=
  fun {ε : Type} => Lean.ExceptToTraceResult.mk ε Bool (fun (x._@.Lean.Util.Trace.2167253133._hygCtx._hyg.35 : Except.{0, 0} ε Bool) => Lean.instExceptToTraceResultBool.match_1.{1} ε (fun (x._@.Lean.Util.Trace.2167253133._hygCtx.35.Lean.Util.Trace.2167253133._hygCtx._hyg.47 : Except.{0, 0} ε Bool) => Lean.TraceResult) x._@.Lean.Util.Trace.2167253133._hygCtx._hyg.35 (fun (a._@._internal.0.Lean.Util.Trace.2167253133._hygCtx._hyg.53 : ε) => Lean.TraceResult.error) (fun (_ : Unit) => Lean.TraceResult.success) (fun (_ : Unit) => Lean.TraceResult.failure))
