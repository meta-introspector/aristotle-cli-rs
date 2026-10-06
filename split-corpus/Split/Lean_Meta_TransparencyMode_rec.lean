import Mathlib

-- spec: recursor Lean.Meta.TransparencyMode.rec : forall {motive : Lean.Meta.TransparencyMode -> Sort.{u}}, (motive Lean.Meta.TransparencyMode.all) -> (motive Lean.Meta.TransparencyMode.default) -> (motive Lean.Meta.TransparencyMode.reducible) -> (motive Lean.Meta.TransparencyMode.instances) -> (motive Lean.Meta.TransparencyMode.none) -> (forall (t : Lean.Meta.TransparencyMode), motive t)
