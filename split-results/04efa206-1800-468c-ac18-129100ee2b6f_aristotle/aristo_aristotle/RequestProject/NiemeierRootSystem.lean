/-
# Niemeier Root Systems

The 23 non-empty Niemeier root systems, following the classification of
even unimodular lattices in rank 24 (Niemeier, 1973).
Each Niemeier root system X determines an instance of umbral moonshine:
a finite group G^X, a vector-valued mock modular form H^X, and a
conjectured graded module K^X.
-/
import Mathlib

namespace NiemeierRootSystemNS

/-! ## Enumeration of the 23 Niemeier Root Systems -/
/-- The 23 non-empty Niemeier root systems.
The 24 Niemeier lattices are the even unimodular lattices of rank 24.
They are classified by their root systems. Exactly one (the Leech lattice)
has empty root system; the remaining 23 are listed here.
Labeling follows Cheng-Duncan-Harvey's conventions from the original
umbral moonshine conjecture. -/
inductive NiemeierRootSystem : Type where
  | A1_24       -- A₁²⁴, umbral group ≅ M₂₄
  | A2_12       -- A₂¹²
  | A3_8        -- A₃⁸
  | A4_6        -- A₄⁶
  | A5_4_D4     -- A₅⁴D₄
  | A6_4        -- A₆⁴
  | A7_2_D5_2   -- A₇²D₅²
  | A8_3        -- A₈³
  | A9_2_D6     -- A₉²D₆
  | A11_D7_E6   -- A₁₁D₇E₆
  | A12_2       -- A₁₂²
  | A15_D9      -- A₁₅D₉
  | A17_E7      -- A₁₇E₇
  | A24         -- A₂₄
  | D4_6        -- D₄⁶
  | D6_4        -- D₆⁴
  | D8_3        -- D₈³
  | D10_E7_2    -- D₁₀E₇²
  | D12_2       -- D₁₂²
  | D16_E8      -- D₁₆E₈
  | D24         -- D₂₄
  | E6_4        -- E₆⁴
  | E8_3        -- E₈³
  deriving DecidableEq, Fintype
/-- There are exactly 23 non-empty Niemeier root systems. -/
theorem NiemeierRootSystem.card : Fintype.card NiemeierRootSystem = 23 := by
  decide +kernel
/-- The Coxeter number of each Niemeier root system.
This is the Coxeter number of any irreducible component (they all share
the same Coxeter number for Niemeier root systems). The Coxeter number
determines the level of the mock modular forms in umbral moonshine. -/
def NiemeierRootSystem.coxeterNumber : NiemeierRootSystem → ℕ
  | .A1_24     => 2
  | .A2_12     => 3
  | .A3_8      => 4
  | .A4_6      => 5
  | .A5_4_D4   => 6
  | .A6_4      => 7
  | .A7_2_D5_2 => 8
  | .A8_3      => 9
  | .A9_2_D6   => 10
  | .A11_D7_E6 => 12
  | .A12_2     => 13
  | .A15_D9    => 16
  | .A17_E7    => 18
  | .A24       => 25
  | .D4_6      => 6
  | .D6_4      => 10
  | .D8_3      => 14
  | .D10_E7_2  => 18
  | .D12_2     => 22
  | .D16_E8    => 30
  | .D24       => 46
  | .E6_4      => 12
  | .E8_3      => 30
/-- The rank of the root system (always 24 for Niemeier root systems). -/
def NiemeierRootSystem.rank : NiemeierRootSystem → ℕ := fun _ => 24
theorem NiemeierRootSystem.rank_eq (X : NiemeierRootSystem) : X.rank = 24 := rfl
/-- The Coxeter number is always at least 2. -/
theorem NiemeierRootSystem.coxeterNumber_pos (X : NiemeierRootSystem) :
    0 < X.coxeterNumber := by
  cases X <;> simp [coxeterNumber]

end NiemeierRootSystemNS
