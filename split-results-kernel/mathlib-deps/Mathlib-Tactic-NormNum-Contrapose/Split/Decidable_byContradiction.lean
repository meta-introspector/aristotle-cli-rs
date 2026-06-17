import Mathlib

-- spec: theorem Decidable.byContradiction : forall {p : Prop} [dec : Decidable p], ((Not p) -> False) -> p
theorem Decidable.byContradiction : forall {p : Prop} [dec : Decidable p], ((Not p) -> False) -> p :=
  fun {p : Prop} [dec : Decidable p] (h : (Not p) -> False) => Decidable.byCases.{0} p p dec (id.{0} p) (fun (np : Not p) => False.elim.{0} p (h np))
