import Mathlib

set_option pp.all true
-- spec: String.Slice.instDecidableEqPos : forall {s._@.Init.Data.String.Defs.1404496647._hygCtx._hyg.194 : String.Slice}, DecidableEq.{1} (String.Slice.Pos s._@.Init.Data.String.Defs.1404496647._hygCtx._hyg.194)
def String.Slice.instDecidableEqPos : forall {s._@.Init.Data.String.Defs.1404496647._hygCtx._hyg.194 : String.Slice}, DecidableEq.{1} (String.Slice.Pos s._@.Init.Data.String.Defs.1404496647._hygCtx._hyg.194) :=
  fun {s._@.Init.Data.String.Defs.1404496647._hygCtx._hyg.194 : String.Slice} => String.Slice.instDecidableEqPos.decEq s._@.Init.Data.String.Defs.1404496647._hygCtx._hyg.194
