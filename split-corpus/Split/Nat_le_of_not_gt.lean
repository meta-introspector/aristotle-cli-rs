import Mathlib

-- spec: theorem Nat.le_of_not_gt : forall {a : Nat} {b : Nat}, (Not (GT.gt.{0} Nat instLTNat b a)) -> (LE.le.{0} Nat instLENat b a)
theorem Nat.le_of_not_gt : forall {a : Nat} {b : Nat}, (Not (GT.gt.{0} Nat instLTNat b a)) -> (LE.le.{0} Nat instLENat b a) :=
  fun {a._@.Init.Data.Nat.Basic.2977137._hygCtx._hyg.23 : Nat} {b._@.Init.Data.Nat.Basic.2977137._hygCtx._hyg.24 : Nat} => Nat.ge_of_not_lt a._@.Init.Data.Nat.Basic.2977137._hygCtx._hyg.23 b._@.Init.Data.Nat.Basic.2977137._hygCtx._hyg.24
