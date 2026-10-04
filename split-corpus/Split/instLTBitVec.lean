import Mathlib

set_option pp.all true
-- spec: instLTBitVec : forall {w : Nat}, LT.{0} (BitVec w)
def instLTBitVec : forall {w : Nat}, LT.{0} (BitVec w) :=
  fun {w : Nat} => LT.mk.{0} (BitVec w) (fun (x1._@.Init.Prelude.4066320391._hygCtx._hyg.17 : BitVec w) (x2._@.Init.Prelude.4066320391._hygCtx._hyg.17 : BitVec w) => LT.lt.{0} Nat instLTNat (BitVec.toNat w x1._@.Init.Prelude.4066320391._hygCtx._hyg.17) (BitVec.toNat w x2._@.Init.Prelude.4066320391._hygCtx._hyg.17))
