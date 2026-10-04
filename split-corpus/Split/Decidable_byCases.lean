import Mathlib

set_option pp.all true
-- spec: Decidable.byCases : forall {p : Prop} {q : Sort.{u}} [dec : Decidable p], (p -> q) -> ((Not p) -> q) -> q
def Decidable.byCases : forall {p : Prop} {q : Sort.{u}} [dec : Decidable p], (p -> q) -> ((Not p) -> q) -> q :=
  fun {p : Prop} {q : Sort.{u}} [dec : Decidable p] (h1 : p -> q) (h2 : (Not p) -> q) => Decidable.byCases.match_1.{u} p (fun (dec._@.Init.Core.1874316381._hygCtx._hyg.24 : Decidable p) => q) dec (fun (h : p) => h1 h) (fun (h : Not p) => h2 h)
