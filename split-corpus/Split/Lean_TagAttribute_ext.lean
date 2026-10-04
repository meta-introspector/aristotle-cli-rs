import Mathlib

set_option pp.all true
-- spec: Lean.TagAttribute.ext : Lean.TagAttribute -> (Lean.PersistentEnvExtension Lean.Name Lean.Name Lean.NameSet)
def Lean.TagAttribute.ext : Lean.TagAttribute -> (Lean.PersistentEnvExtension Lean.Name Lean.Name Lean.NameSet) :=
  fun (self : Lean.TagAttribute) => self.2
