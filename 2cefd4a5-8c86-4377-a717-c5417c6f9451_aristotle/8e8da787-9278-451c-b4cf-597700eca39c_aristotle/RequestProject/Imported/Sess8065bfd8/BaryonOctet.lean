import Mathlib

/-!
# Baryon Octet

Basic definitions for the baryon octet model: phase labels for the six outer vertices
of the hexagonal weight diagram, a baryon-number assignment, and a net-phase operator.
-/

open Equiv

/-- The six phases corresponding to the outer vertices of the baryon octet. -/
abbrev Phase := Fin 6

/-- Baryon number assignment.  Every outer vertex of the octet carries baryon number 1. -/
def baryonFromPhase (_p : Phase) : ℕ := 1

/-- The net phase.  For every positive natural number the net phase is the
    "center" of the hexagon, i.e. the fixed point (index 5) of the A₅-action
    that permutes indices 0–4. -/
def netPhase (_n : ℕ) : Phase := ⟨5, by omega⟩
