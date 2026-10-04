import Mathlib

set_option pp.all true
-- spec: Eq.ndrec : forall {α : Sort.{u2}} {a : α} {motive : α -> Sort.{u1}}, (motive a) -> (forall {b : α}, (Eq.{u2} α a b) -> (motive b))
def Eq.ndrec : forall {α : Sort.{u2}} {a : α} {motive : α -> Sort.{u1}}, (motive a) -> (forall {b : α}, (Eq.{u2} α a b) -> (motive b)) :=
  fun {α : Sort.{u2}} {a : α} {motive : α -> Sort.{u1}} (m : motive a) {b : α} (h : Eq.{u2} α a b) => Eq.rec.{u1, u2} α a (fun (x._@.Init.Prelude.2055208596._hygCtx._hyg.17 : α) (x._@.Init.Prelude.2055208596._hygCtx._hyg.16 : Eq.{u2} α a x._@.Init.Prelude.2055208596._hygCtx._hyg.17) => motive x._@.Init.Prelude.2055208596._hygCtx._hyg.17) m b h
