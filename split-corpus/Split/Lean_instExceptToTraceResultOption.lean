import Mathlib

set_option pp.all true
-- spec: Lean.instExceptToTraceResultOption : forall {α : Type} {ε : Type}, Lean.ExceptToTraceResult ε (Option.{0} α)
def Lean.instExceptToTraceResultOption : forall {α : Type} {ε : Type}, Lean.ExceptToTraceResult ε (Option.{0} α) :=
  fun {α : Type} {ε : Type} => Lean.ExceptToTraceResult.mk ε (Option.{0} α) (fun (x._@.Lean.Util.Trace.2932495608._hygCtx._hyg.38 : Except.{0, 0} ε (Option.{0} α)) => Lean.instExceptToTraceResultOption.match_1.{1} α ε (fun (x._@.Lean.Util.Trace.2932495608._hygCtx.38.Lean.Util.Trace.2932495608._hygCtx._hyg.50 : Except.{0, 0} ε (Option.{0} α)) => Lean.TraceResult) x._@.Lean.Util.Trace.2932495608._hygCtx._hyg.38 (fun (a._@._internal.0.Lean.Util.Trace.2932495608._hygCtx._hyg.57 : ε) => Lean.TraceResult.error) (fun (val._@.Lean.Util.Trace.2932495608._hygCtx._hyg.68 : α) => Lean.TraceResult.success) (fun (_ : Unit) => Lean.TraceResult.failure))
