import Mathlib

set_option pp.all true
-- spec: instLEBitVec : forall {w : Nat}, LE.{0} (BitVec w)
def instLEBitVec : forall {w : Nat}, LE.{0} (BitVec w) :=
  fun {w : Nat} => LE.mk.{0} (BitVec w) (fun (x1._@.Init.Prelude.821860767._hygCtx._hyg.17 : BitVec w) (x2._@.Init.Prelude.821860767._hygCtx._hyg.17 : BitVec w) => LE.le.{0} Nat instLENat (BitVec.toNat w x1._@.Init.Prelude.821860767._hygCtx._hyg.17) (BitVec.toNat w x2._@.Init.Prelude.821860767._hygCtx._hyg.17))
