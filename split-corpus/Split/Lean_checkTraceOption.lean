import Mathlib

set_option pp.all true
-- spec: Lean.checkTraceOption : (Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) -> Lean.Options -> Lean.Name -> Bool
def Lean.checkTraceOption : (Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) -> Lean.Options -> Lean.Name -> Bool :=
  fun (inherited : Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) (opts : Lean.Options) (cls : Lean.Name) => Bool.and (Lean.Options.hasTrace opts) (_private.Lean.Util.Trace.0.Lean.checkTraceOption.go inherited opts (HAppend.hAppend.{0, 0, 0} Lean.Name Lean.Name Lean.Name (instHAppendOfAppend.{0} Lean.Name Lean.instAppendName) (Lean.Name.mkStr1 "trace") cls))
