/-
# SharedStructures.lean — Canonical Shared Structures for the Monster Universe

This module provides canonical definitions for structures and inductive types
that appear in multiple files across the project.

## Types provided
- `Eigenspace` — the four eigenspace components (Earth, Spoke, Hub, Clock)
- `BottPhase` — the 8 Bott periodicity phases
- Eigenspace utilities (dimension, classification)
-/
import Mathlib
import RequestProject.MonsterConstants

open MonsterConstants

namespace SharedStructures

/-! ## §1. Eigenspace -/

/-- The four eigenspace components of the Monster Walk.
    - `earth`: eigenvalue −1, primes {2,3,5,7,11,13,47}, dim 7
    - `spoke`: eigenvalue −1, primes {17,29,31,41,59,71}, dim 5
    - `hub`:   eigenvalue +1, direction (e₁₉+e₂₃)/√2, dim 1
    - `clock`: eigenvalue e^{±iπ/3}, 60° rotation plane, dim 2 -/
inductive Eigenspace where
  | earth  -- 7D: low primes, dense arithmetic
  | spoke  -- 5D: mid primes, structural bridges
  | hub    -- 1D: prime 47, the entropy gate
  | clock  -- 2D: primes 59, 71, temporal phase
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- The dimension of each eigenspace component. -/
def Eigenspace.dim : Eigenspace → ℕ
  | .earth => 7
  | .spoke => 5
  | .hub   => 1
  | .clock => 2

/-- Total dimension = 15 (= number of supersingular primes). -/
theorem eigenspace_total_dim :
    Eigenspace.dim .earth + Eigenspace.dim .spoke +
    Eigenspace.dim .hub + Eigenspace.dim .clock = 15 := by decide

/-- There are exactly 4 eigenspace components. -/
theorem eigenspace_card : Fintype.card Eigenspace = 4 := by decide

/-! ## §2. Bott Phase -/

/-- The 8 phases of Bott periodicity (mod 8). -/
inductive BottPhase where
  | phase0 | phase1 | phase2 | phase3
  | phase4 | phase5 | phase6 | phase7
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- Convert a natural number to a Bott phase (mod 8). -/
def BottPhase.ofNat' : ℕ → BottPhase
  | 0 => .phase0 | 1 => .phase1 | 2 => .phase2 | 3 => .phase3
  | 4 => .phase4 | 5 => .phase5 | 6 => .phase6 | 7 => .phase7
  | n + 8 => ofNat' n

/-- There are exactly 8 Bott phases. -/
theorem bottPhase_card : Fintype.card BottPhase = 8 := by decide

/-! ## §3. Eigenspace ↔ SSP Classification -/

/-- Classify a supersingular prime index (Fin 15) to its eigenspace. -/
def eigenspaceOfSSPIndex : Fin 15 → Eigenspace
  | ⟨0, _⟩ | ⟨1, _⟩ | ⟨2, _⟩ | ⟨3, _⟩ | ⟨4, _⟩ | ⟨5, _⟩ | ⟨12, _⟩ => .earth
  | ⟨6, _⟩ | ⟨9, _⟩ | ⟨10, _⟩ | ⟨11, _⟩ | ⟨13, _⟩ | ⟨14, _⟩ => .spoke
  | ⟨7, _⟩ => .hub
  | ⟨8, _⟩ => .clock

end SharedStructures
