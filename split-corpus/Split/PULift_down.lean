import Mathlib

set_option pp.all true
-- spec: PULift.down : forall {α : Sort.{s}}, (PULift.{r, s} α) -> α
def PULift.down : forall {α : Sort.{s}}, (PULift.{r, s} α) -> α :=
  fun (α : Sort.{s}) (self : PULift.{r, s} α) => self.1
