import Mathlib

set_option pp.all true
-- spec: Lean.Meta.State.postponed : Lean.Meta.State -> (Lean.PersistentArray.{0} Lean.Meta.PostponedEntry)
def Lean.Meta.State.postponed : Lean.Meta.State -> (Lean.PersistentArray.{0} Lean.Meta.PostponedEntry) :=
  fun (self : Lean.Meta.State) => self.4
