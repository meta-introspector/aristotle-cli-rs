import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Match.Extension.instInhabitedState : Inhabited.{1} Lean.Meta.Match.Extension.State
def Lean.Meta.Match.Extension.instInhabitedState : Inhabited.{1} Lean.Meta.Match.Extension.State :=
  Inhabited.mk.{1} Lean.Meta.Match.Extension.State (Lean.Meta.Match.Extension.State.mk (Lean.SMap.mk.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo Lean.Name.instBEq Lean.instHashableName Bool.true (EmptyCollection.emptyCollection.{0} (Std.HashMap.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo Lean.Name.instBEq Lean.instHashableName) (Std.HashMap.instEmptyCollection.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo Lean.Name.instBEq Lean.instHashableName)) (Lean.PersistentHashMap.mk.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo Lean.Name.instBEq Lean.instHashableName (Lean.PersistentHashMap.Node.entries.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo (Lean.PersistentHashMap.mkEmptyEntriesArray.{0, 0} Lean.Name Lean.Meta.Match.MatcherInfo)))))
