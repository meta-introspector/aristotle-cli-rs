import Mathlib

-- spec: theorem Classical.byContradiction : forall {p : Prop}, ((Not p) -> False) -> p
theorem Classical.byContradiction : forall {p : Prop}, ((Not p) -> False) -> p :=
  fun {p : Prop} (h : (Not p) -> False) => Decidable.byContradiction p (Classical.propDecidable p) h
