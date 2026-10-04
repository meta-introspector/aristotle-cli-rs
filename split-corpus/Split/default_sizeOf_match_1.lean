import Mathlib

set_option pp.all true
-- spec: default.sizeOf.match_1 : forall (α : Sort.{u_2}) (motive : α -> Sort.{u_1}) (x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17 : α), (forall (x._@.Init.SizeOf.3898511741._hygCtx._hyg.21 : α), motive x._@.Init.SizeOf.3898511741._hygCtx._hyg.21) -> (motive x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17)
def default.sizeOf.match_1 : forall (α : Sort.{u_2}) (motive : α -> Sort.{u_1}) (x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17 : α), (forall (x._@.Init.SizeOf.3898511741._hygCtx._hyg.21 : α), motive x._@.Init.SizeOf.3898511741._hygCtx._hyg.21) -> (motive x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17) :=
  fun (α : Sort.{u_2}) (motive : α -> Sort.{u_1}) (x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17 : α) (h_1 : forall (x._@.Init.SizeOf.3898511741._hygCtx._hyg.21 : α), motive x._@.Init.SizeOf.3898511741._hygCtx._hyg.21) => h_1 x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17
