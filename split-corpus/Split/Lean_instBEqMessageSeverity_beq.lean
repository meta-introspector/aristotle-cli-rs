import Mathlib

set_option pp.all true
-- spec: Lean.instBEqMessageSeverity.beq : Lean.MessageSeverity -> Lean.MessageSeverity -> Bool
def Lean.instBEqMessageSeverity.beq : Lean.MessageSeverity -> Lean.MessageSeverity -> Bool :=
  fun (x._@.Lean.Message.3631932226._hygCtx._hyg.1 : Lean.MessageSeverity) (y._@.Lean.Message.3631932226._hygCtx._hyg.1 : Lean.MessageSeverity) => BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (Lean.MessageSeverity.ctorIdx x._@.Lean.Message.3631932226._hygCtx._hyg.1) (Lean.MessageSeverity.ctorIdx y._@.Lean.Message.3631932226._hygCtx._hyg.1)
