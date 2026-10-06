import Mathlib

set_option pp.all true
-- spec: Lean.Meta.getMatcherInfoCore? : Lean.Environment -> Lean.Name -> (Option.{0} Lean.Meta.Match.MatcherInfo)
def Lean.Meta.getMatcherInfoCore? : Lean.Environment -> Lean.Name -> (Option.{0} Lean.Meta.Match.MatcherInfo) :=
  fun (env : Lean.Environment) (declName : Lean.Name) => Lean.Meta.Match.Extension.getMatcherInfo? env declName
