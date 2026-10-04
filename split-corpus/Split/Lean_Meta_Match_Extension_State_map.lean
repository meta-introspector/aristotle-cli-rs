import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Match.Extension.State.map : Lean.Meta.Match.Extension.State -> (Lean.SMap.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo Lean.Name.instBEq Lean.instHashableName)
def Lean.Meta.Match.Extension.State.map : Lean.Meta.Match.Extension.State -> (Lean.SMap.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Meta.Match.Extension.State) => self.1
