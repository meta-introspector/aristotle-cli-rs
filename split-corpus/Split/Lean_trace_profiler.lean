import Mathlib

-- spec: opaque Lean.trace.profiler : Lean.Option Bool
opaque Lean.trace.profiler : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
