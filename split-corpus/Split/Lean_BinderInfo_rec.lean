import Mathlib

-- spec: recursor Lean.BinderInfo.rec : forall {motive : Lean.BinderInfo -> Sort.{u}}, (motive Lean.BinderInfo.default) -> (motive Lean.BinderInfo.implicit) -> (motive Lean.BinderInfo.strictImplicit) -> (motive Lean.BinderInfo.instImplicit) -> (forall (t : Lean.BinderInfo), motive t)
