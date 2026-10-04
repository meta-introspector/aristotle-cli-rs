import Mathlib

set_option pp.all true
-- spec: Lean.BinderInfo.casesOn : forall {motive : Lean.BinderInfo -> Sort.{u}} (t : Lean.BinderInfo), (motive Lean.BinderInfo.default) -> (motive Lean.BinderInfo.implicit) -> (motive Lean.BinderInfo.strictImplicit) -> (motive Lean.BinderInfo.instImplicit) -> (motive t)
def Lean.BinderInfo.casesOn : forall {motive : Lean.BinderInfo -> Sort.{u}} (t : Lean.BinderInfo), (motive Lean.BinderInfo.default) -> (motive Lean.BinderInfo.implicit) -> (motive Lean.BinderInfo.strictImplicit) -> (motive Lean.BinderInfo.instImplicit) -> (motive t) :=
  fun {motive : Lean.BinderInfo -> Sort.{u}} (t : Lean.BinderInfo) (default : motive Lean.BinderInfo.default) (implicit : motive Lean.BinderInfo.implicit) (strictImplicit : motive Lean.BinderInfo.strictImplicit) (instImplicit : motive Lean.BinderInfo.instImplicit) => Lean.BinderInfo.rec.{u} motive default implicit strictImplicit instImplicit t
