import Mathlib

-- spec: theorem Nat.not_lt_of_ge : forall {a : Nat} {b : Nat}, (GE.ge.{0} Nat instLENat b a) -> (Not (LT.lt.{0} Nat instLTNat b a))
theorem Nat.not_lt_of_ge : forall {a : Nat} {b : Nat}, (GE.ge.{0} Nat instLENat b a) -> (Not (LT.lt.{0} Nat instLTNat b a)) :=
  fun {a._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.23 : Nat} {b._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.24 : Nat} => flip.{0, 0, 0} (LT.lt.{0} Nat instLTNat b._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.24 a._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.23) (GE.ge.{0} Nat instLENat b._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.24 a._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.23) False (Nat.not_le_of_gt a._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.23 b._@.Init.Data.Nat.Basic.3845588696._hygCtx._hyg.24)
