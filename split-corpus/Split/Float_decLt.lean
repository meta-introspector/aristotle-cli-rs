import Mathlib

-- spec: opaque Float.decLt : forall (a : Float) (b : Float), Decidable (LT.lt.{0} Float instLTFloat a b)
opaque Float.decLt : forall (a : Float) (b : Float), Decidable (LT.lt.{0} Float instLTFloat a b) :=
  fun (a : Float) (b : Float) => _private.Init.Data.Float.0.Float.lt.match_1.{1} (fun (a._@.Init.Data.Float.2496129708._hygCtx._hyg.16 : Float) (b._@.Init.Data.Float.2496129708._hygCtx._hyg.18 : Float) => Decidable (LT.lt.{0} Float instLTFloat a._@.Init.Data.Float.2496129708._hygCtx._hyg.16 b._@.Init.Data.Float.2496129708._hygCtx._hyg.18)) a b (fun (a : FloatSpec.float floatSpec) (b : FloatSpec.float floatSpec) => FloatSpec.decLt floatSpec a b)
