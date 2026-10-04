import Mathlib

set_option pp.all true
-- spec: DecidableLE : forall (α : Type.{u}) [inst._@.Init.Prelude.217401435._hygCtx._hyg.3 : LE.{u} α], Sort.{max 1 (succ u)}
def DecidableLE : forall (α : Type.{u}) [inst._@.Init.Prelude.217401435._hygCtx._hyg.3 : LE.{u} α], Sort.{max 1 (succ u)} :=
  fun (α : Type.{u}) [inst._@.Init.Prelude.217401435._hygCtx._hyg.3 : LE.{u} α] => DecidableRel.{succ u, succ u} α α (LE.le.{u} α inst._@.Init.Prelude.217401435._hygCtx._hyg.3)
