import Mathlib

set_option pp.all true
-- spec: ByteArray.size : ([mdata borrowed:1 ByteArray]) -> Nat
def ByteArray.size : ([mdata borrowed:1 ByteArray]) -> Nat :=
  fun (x._@.Init.Prelude.1687928793._hygCtx._hyg.8 : ByteArray) => ByteArray.size.match_1.{1} (fun (x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19 : ByteArray) => Nat) x._@.Init.Prelude.1687928793._hygCtx._hyg.8 (fun (bs : Array.{0} UInt8) => Array.size.{0} UInt8 bs)
