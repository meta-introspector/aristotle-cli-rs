import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instBEqTransparencyMode.beq : Lean.Meta.TransparencyMode -> Lean.Meta.TransparencyMode -> Bool
def Lean.Meta.instBEqTransparencyMode.beq : Lean.Meta.TransparencyMode -> Lean.Meta.TransparencyMode -> Bool :=
  fun (x._@.Init.MetaTypes.2581322616._hygCtx._hyg.1 : Lean.Meta.TransparencyMode) (y._@.Init.MetaTypes.2581322616._hygCtx._hyg.1 : Lean.Meta.TransparencyMode) => BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (Lean.Meta.TransparencyMode.ctorIdx x._@.Init.MetaTypes.2581322616._hygCtx._hyg.1) (Lean.Meta.TransparencyMode.ctorIdx y._@.Init.MetaTypes.2581322616._hygCtx._hyg.1)
