import Mathlib

set_option pp.all true
-- spec: String.instDecidableEqPos : forall {s._@.Init.Data.String.Defs.1404496646._hygCtx._hyg.194 : String}, DecidableEq.{1} (String.Pos s._@.Init.Data.String.Defs.1404496646._hygCtx._hyg.194)
def String.instDecidableEqPos : forall {s._@.Init.Data.String.Defs.1404496646._hygCtx._hyg.194 : String}, DecidableEq.{1} (String.Pos s._@.Init.Data.String.Defs.1404496646._hygCtx._hyg.194) :=
  fun {s._@.Init.Data.String.Defs.1404496646._hygCtx._hyg.194 : String} => String.instDecidableEqPos.decEq s._@.Init.Data.String.Defs.1404496646._hygCtx._hyg.194
