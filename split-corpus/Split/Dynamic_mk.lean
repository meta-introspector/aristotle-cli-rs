import Mathlib

-- spec: opaque Dynamic.mk : forall {α : Type.{u_1}} [inst._@.Init.Dynamic.1434432365._hygCtx._hyg.5 : TypeName.{u_1} α], α -> Dynamic
opaque Dynamic.mk : forall {α : Type.{u_1}} [inst._@.Init.Dynamic.1434432365._hygCtx._hyg.5 : TypeName.{u_1} α], α -> Dynamic :=
  fun {α : Type.{u_1}} [inst._@.Init.Dynamic.1434432365._hygCtx._hyg.5 : TypeName.{u_1} α] (obj : α) => Classical.ofNonempty.{1} Dynamic instNonemptyDynamic
