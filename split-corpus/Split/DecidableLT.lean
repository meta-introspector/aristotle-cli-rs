import Mathlib

set_option pp.all true
-- spec: DecidableLT : forall (α : Type.{u}) [inst._@.Init.Prelude.1048366004._hygCtx._hyg.3 : LT.{u} α], Sort.{max 1 (succ u)}
def DecidableLT : forall (α : Type.{u}) [inst._@.Init.Prelude.1048366004._hygCtx._hyg.3 : LT.{u} α], Sort.{max 1 (succ u)} :=
  fun (α : Type.{u}) [inst._@.Init.Prelude.1048366004._hygCtx._hyg.3 : LT.{u} α] => DecidableRel.{succ u, succ u} α α (LT.lt.{u} α inst._@.Init.Prelude.1048366004._hygCtx._hyg.3)
