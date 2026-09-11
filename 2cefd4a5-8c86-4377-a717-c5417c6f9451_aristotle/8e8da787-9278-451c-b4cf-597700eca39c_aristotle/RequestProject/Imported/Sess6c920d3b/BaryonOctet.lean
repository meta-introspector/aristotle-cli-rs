import Mathlib

/-!
# Baryon Octet – Basic Definitions

This file provides the foundational types and functions for the baryon-octet model:
six phases (Fin 6) encoding the hexagonal geometry, a baryon-number assignment,
and a drop-trigger predicate capturing the central-core invariance condition.
-/

/-- A phase in the hexagonal baryon-octet geometry.
    There are six phases indexed 0–5, with phase 5 being the invariant core. -/
abbrev Phase := Fin 6

/-- Baryon number assigned to a phase.
    In this simplified model every phase carries the same baryon number (1),
    reflecting that all members of the octet are baryons. -/
def baryonFromPhase (_p : Phase) : ℤ := 1

/-- The drop-trigger predicate.
    Returns `true` when the index corresponds to the central core (phase 5),
    formalizing the condition that the center (I₃ = 0, Y = 0) drops out. -/
def dropTrigger (n : Nat) : Bool := n == 5
