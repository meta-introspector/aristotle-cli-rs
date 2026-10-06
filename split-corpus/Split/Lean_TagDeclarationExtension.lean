import Mathlib

set_option pp.all true
-- spec: Lean.TagDeclarationExtension : Type
def Lean.TagDeclarationExtension : Type :=
  Lean.SimplePersistentEnvExtension Lean.Name Lean.NameSet
