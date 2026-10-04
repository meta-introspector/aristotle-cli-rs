import Mathlib

set_option pp.all true
-- spec: dite : forall {α : Sort.{u}} (c : Prop) [h : Decidable c], (c -> α) -> ((Not c) -> α) -> α
def dite : forall {α : Sort.{u}} (c : Prop) [h : Decidable c], (c -> α) -> ((Not c) -> α) -> α :=
  fun {α : Sort.{u}} (c : Prop) [h : Decidable c] (t : c -> α) (e : (Not c) -> α) => Decidable.casesOn.{u} c (fun (x._@.Init.Prelude.3893281826._hygCtx._hyg.15 : Decidable c) => α) h e t
