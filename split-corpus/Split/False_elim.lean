import Mathlib

set_option pp.all true
-- spec: False.elim : forall {C : Sort.{u}}, False -> C
def False.elim : forall {C : Sort.{u}}, False -> C :=
  fun {C : Sort.{u}} (h : False) => False.rec.{u} (fun (x._@.Init.Prelude.2135250726._hygCtx._hyg.6 : False) => C) h
