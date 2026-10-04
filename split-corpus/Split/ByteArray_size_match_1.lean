import Mathlib

set_option pp.all true
-- spec: ByteArray.size.match_1 : forall (motive : ByteArray -> Sort.{u_1}) (x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19 : ByteArray), (forall (bs : Array.{0} UInt8), motive (ByteArray.mk bs)) -> (motive x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19)
def ByteArray.size.match_1 : forall (motive : ByteArray -> Sort.{u_1}) (x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19 : ByteArray), (forall (bs : Array.{0} UInt8), motive (ByteArray.mk bs)) -> (motive x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19) :=
  fun (motive : ByteArray -> Sort.{u_1}) (x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19 : ByteArray) (h_1 : forall (bs : Array.{0} UInt8), motive (ByteArray.mk bs)) => ByteArray.casesOn.{u_1} (fun (x : ByteArray) => motive x) x._@.Init.Prelude.1687928793._hygCtx.8.Init.Prelude.1687928793._hygCtx._hyg.19 (fun (data._@.Init.Prelude.1687928793._hygCtx._hyg.28 : Array.{0} UInt8) => h_1 data._@.Init.Prelude.1687928793._hygCtx._hyg.28)
