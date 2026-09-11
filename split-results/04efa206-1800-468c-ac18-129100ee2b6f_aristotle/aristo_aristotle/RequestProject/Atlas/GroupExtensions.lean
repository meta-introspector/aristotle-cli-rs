/-
# Group Extensions and the ATLAS Notation
This file formalizes the group extension notation used pervasively
in the ATLAS of Finite Groups.
The ATLAS uses a compact notation for group structures:
- `A × B` : direct product
- `A.B`   : an extension of B by A (A is normal)
- `A:B`   : a split extension (semidirect product) of B by A
- `p^n`   : elementary abelian p-group of order p^n
- `p^{1+2n}` : extraspecial p-group
-/
import Mathlib
set_option maxHeartbeats 800000
open scoped BigOperators Classical
noncomputable section
/-- An abstract description of a group structure, as used in the ATLAS notation. -/
inductive ATLASGroupDesc where
  /-- A cyclic group of given order. -/
  | cyclic (n : ℕ)
  /-- An elementary abelian p-group of rank n (order p^n). -/
  | elemAbelian (p : ℕ) (n : ℕ)
  /-- An alternating group Aₙ. -/
  | alt (n : ℕ)
  /-- A symmetric group Sₙ. -/
  | sym (n : ℕ)
  /-- A group of Lie type. -/
  | lieType (name : String)
  /-- A sporadic group. -/
  | sporadic (name : String)
  /-- Direct product A × B. -/
  | prod (A B : ATLASGroupDesc)
  /-- Extension A.B (A normal in the extension, quotient B). -/
  | ext (A B : ATLASGroupDesc)
  /-- Split extension (semidirect product) A:B. -/
  | splitExt (A B : ATLASGroupDesc)
  /-- Wreath product A ≀ B. -/
  | wreath (A B : ATLASGroupDesc)
  /-- An extraspecial group p^{1+2n}. -/
  | extraspecial (p : ℕ) (n : ℕ) (type : Bool)
/-- The order of a group described in ATLAS notation. -/
def ATLASGroupDesc.order : ATLASGroupDesc → ℕ
  | .cyclic n => n
  | .elemAbelian p n => p ^ n
  | .alt n => Nat.factorial n / 2
  | .sym n => Nat.factorial n
  | .lieType _ => 0
  | .sporadic _ => 0
  | .prod A B => A.order * B.order
  | .ext A B => A.order * B.order
  | .splitExt A B => A.order * B.order
  | .wreath A B => A.order ^ B.order * B.order
  | .extraspecial p n _ => p ^ (1 + 2 * n)
/-- The double cover of A₅, written "2.A₅" in the ATLAS.
    This is isomorphic to SL(2,5) and the binary icosahedral group.
    Order = 2 × 60 = 120. -/
def doubleCoverA5 : ATLASGroupDesc :=
  .ext (.cyclic 2) (.alt 5)
/-- "2⁴:A₈", a maximal subgroup of M₂₄.
    Order = 16 × 20160 = 322560. -/
def two4_A8 : ATLASGroupDesc :=
  .splitExt (.elemAbelian 2 4) (.alt 8)
example : doubleCoverA5.order = 120 := by
  native_decide
example : two4_A8.order = 322560 := by
  simp [two4_A8, ATLASGroupDesc.order]
  native_decide
/-- The order of the Schur multiplier of Aₙ. -/
def schurMultiplierOrderAlt (n : ℕ) : ℕ :=
  if n < 5 then
    if n = 4 then 2
    else if n = 3 then 2
    else 1
  else if n = 6 ∨ n = 7 then 6
  else 2
example : schurMultiplierOrderAlt 5 = 2 := by decide
example : schurMultiplierOrderAlt 6 = 6 := by decide
example : schurMultiplierOrderAlt 7 = 6 := by decide
example : schurMultiplierOrderAlt 8 = 2 := by decide
/-- The order of Out(Aₙ). -/
def outerAutOrderAlt (n : ℕ) : ℕ :=
  if n = 6 then 4
  else if n ≥ 5 then 2
  else if n ≥ 3 then 2
  else 1
example : outerAutOrderAlt 5 = 2 := by decide
example : outerAutOrderAlt 6 = 4 := by decide
example : outerAutOrderAlt 7 = 2 := by decide
end -- noncomputable section
