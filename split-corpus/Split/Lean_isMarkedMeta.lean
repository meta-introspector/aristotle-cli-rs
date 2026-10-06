import Mathlib

set_option pp.all true
-- spec: Lean.isMarkedMeta : Lean.Environment -> Lean.Name -> Bool
def Lean.isMarkedMeta : Lean.Environment -> Lean.Name -> Bool :=
  fun (env : Lean.Environment) (declName : Lean.Name) => Lean.TagDeclarationExtension.isTagged _private.Lean.Compiler.MetaAttr.0.Lean.metaExt env declName (Lean.EnvExtension.asyncMode (Lean.PersistentEnvExtensionState Lean.Name (Prod.{0, 0} (List.{0} Lean.Name) Lean.NameSet)) (Lean.PersistentEnvExtension.toEnvExtension Lean.Name Lean.Name (Prod.{0, 0} (List.{0} Lean.Name) Lean.NameSet) _private.Lean.Compiler.MetaAttr.0.Lean.metaExt))
