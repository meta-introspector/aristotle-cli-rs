import Mathlib

/-!
# Baryon Octet — Basic Definitions

Defines the six-phase type and the drop trigger predicate used
by the rest of the project.
-/

/-- The six outer phases of the baryon octet, indexed `0, …, 5`. -/
abbrev Phase : Type := Fin 6

/-- Placeholder drop-trigger predicate (domain-specific).
    Replace with the real criterion when the physics model is finalized. -/
def dropTrigger (n : Nat) : Prop := n % 6 = 0

instance (n : Nat) : Decidable (dropTrigger n) :=
  inferInstanceAs (Decidable (n % 6 = 0))
