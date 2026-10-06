import Mathlib

set_option pp.all true
-- spec: instDecidableEqRaw.match_3 : forall (motive : String.Pos.Raw -> Sort.{u_1}) (x._@.Init.Prelude.2299997360._hygCtx.7.Init.Prelude.2299997360._hygCtx._hyg.24 : String.Pos.Raw), (forall (b : Nat), motive (String.Pos.Raw.mk b)) -> (motive x._@.Init.Prelude.2299997360._hygCtx.7.Init.Prelude.2299997360._hygCtx._hyg.24)
def instDecidableEqRaw.match_3 : forall (motive : String.Pos.Raw -> Sort.{u_1}) (x._@.Init.Prelude.2299997360._hygCtx.7.Init.Prelude.2299997360._hygCtx._hyg.24 : String.Pos.Raw), (forall (b : Nat), motive (String.Pos.Raw.mk b)) -> (motive x._@.Init.Prelude.2299997360._hygCtx.7.Init.Prelude.2299997360._hygCtx._hyg.24) :=
  fun (motive : String.Pos.Raw -> Sort.{u_1}) (x._@.Init.Prelude.2299997360._hygCtx.7.Init.Prelude.2299997360._hygCtx._hyg.24 : String.Pos.Raw) (h_1 : forall (b : Nat), motive (String.Pos.Raw.mk b)) => String.Pos.Raw.casesOn.{u_1} (fun (x : String.Pos.Raw) => motive x) x._@.Init.Prelude.2299997360._hygCtx.7.Init.Prelude.2299997360._hygCtx._hyg.24 (fun (byteIdx._@.Init.Prelude.2299997360._hygCtx._hyg.77 : Nat) => h_1 byteIdx._@.Init.Prelude.2299997360._hygCtx._hyg.77)
