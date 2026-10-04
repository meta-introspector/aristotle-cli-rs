import Mathlib

-- spec: opaque Lean.Meta.Match.Extension.extension : Lean.SimplePersistentEnvExtension Lean.Meta.Match.Extension.Entry Lean.Meta.Match.Extension.State
opaque Lean.Meta.Match.Extension.extension : Lean.SimplePersistentEnvExtension Lean.Meta.Match.Extension.Entry Lean.Meta.Match.Extension.State :=
  Inhabited.default.{1} (Lean.SimplePersistentEnvExtension Lean.Meta.Match.Extension.Entry Lean.Meta.Match.Extension.State) (Lean.SimplePersistentEnvExtension.instInhabited Lean.Meta.Match.Extension.Entry Lean.Meta.Match.Extension.State Lean.Meta.Match.Extension.instInhabitedState)
