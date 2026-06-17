import Mathlib

-- spec: theorem by_contradiction : forall {p : Prop}, ((Not p) -> False) -> p
theorem by_contradiction : forall {p : Prop}, ((Not p) -> False) -> p :=
  fun {p : Prop} => Decidable.byContradiction p (Classical.propDecidable p)
