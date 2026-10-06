import Mathlib

set_option pp.all true
-- spec: Lean.Meta.mkDiagSummaryForUnfoldedReducible : (Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName) -> (Lean.Meta.MetaM Lean.Meta.DiagSummary)
def Lean.Meta.mkDiagSummaryForUnfoldedReducible : (Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName) -> (Lean.Meta.MetaM Lean.Meta.DiagSummary) :=
  fun (counters : Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName) => Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Environment Lean.Meta.DiagSummary (Lean.MonadEnv.getEnv Lean.Meta.MetaM Lean.Meta.instMonadEnvMetaM) (fun (env : Lean.Environment) => Lean.Meta.mkDiagSummary (Lean.Name.mkStr1 "reduction") counters (fun (declName : Lean.Name) => _private.Lean.Meta.Diagnostics.0.Lean.Meta.mkDiagSummaryForUnfoldedReducible.match_1.{1} (fun (x._@.Lean.Meta.Diagnostics.1872179642._hygCtx._hyg.50 : Lean.ReducibilityStatus) => Bool) (Lean.getReducibilityStatusCore env declName) (fun (_ : Unit) => Bool.true) (fun (x._@.Lean.Meta.Diagnostics.1872179642._hygCtx._hyg.57 : Lean.ReducibilityStatus) => Bool.false)))
