import Mathlib

-- spec: opaque Lean.ppExt : Lean.EnvExtension Lean.PPFns
opaque Lean.ppExt : Lean.EnvExtension Lean.PPFns :=
  Inhabited.default.{1} (Lean.EnvExtension Lean.PPFns) (Lean.instInhabitedEnvExtension Lean.PPFns)
