import Mathlib

set_option pp.all true
-- spec: Eq.ndrec_symm : forall {α : Sort.{u2}} {a : α} {motive : α -> Sort.{u1}}, (motive a) -> (forall {b : α}, (Eq.{u2} α b a) -> (motive b))
def Eq.ndrec_symm : forall {α : Sort.{u2}} {a : α} {motive : α -> Sort.{u1}}, (motive a) -> (forall {b : α}, (Eq.{u2} α b a) -> (motive b)) :=
  fun {α : Sort.{u2}} {a : α} {motive : α -> Sort.{u1}} (m : motive a) {b : α} (h : Eq.{u2} α b a) => Eq.ndrec.{u1, u2} α a motive m b (Eq.symm.{u2} α b a h)
