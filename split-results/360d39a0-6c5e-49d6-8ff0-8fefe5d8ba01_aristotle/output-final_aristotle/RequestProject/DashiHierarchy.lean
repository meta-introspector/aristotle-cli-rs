/-
  DashiHierarchy.lean — Formalization of the dashiCORE Hierarchy specification.

  Formalizes M-level hierarchy from MATH.md §7:
    • M-levels as representation indices (M3, M6, M9, ...)
    • Explicit Lift and Project operations
    • Roundtrip constraint: Project(Lift(s)) = s
    • No implicit cross-level operations
    • Defect composition across levels

  Key results:
    • Lift/Project roundtrip is identity (no spurious defect)
    • Hierarchy composition laws
    • Ternary multiplication (for tensor product lift)
    • Backend equivalence as an equivalence relation
-/
import Mathlib
import RequestProject.DashiCarrier

namespace DashiCORE

/-! ## §1. M-Level Indices -/

/-- An M-level is a natural number index representing the hierarchy depth. -/
abbrev MLevel := ℕ

/-- Standard M-level names. -/
def M3 : MLevel := 0
def M6 : MLevel := 1
def M9 : MLevel := 2

/-! ## §2. Lift and Project Operations -/

/-- A Lift-Project pair between two M-levels.
    Lift raises the representation level, Project lowers it. -/
structure LiftProject (Ω_low Ω_high : Type*) where
  /-- Lift maps a carrier from the lower level to the higher level. -/
  lift : CarrierField Ω_low → CarrierField Ω_high
  /-- Project maps a carrier from the higher level to the lower level. -/
  project : CarrierField Ω_high → CarrierField Ω_low
  /-- Roundtrip: projecting a lifted state recovers the original. -/
  roundtrip : ∀ s, project (lift s) = s

/-- The roundtrip property: no spurious defect is created. -/
theorem LiftProject.no_spurious_defect {Ω_low Ω_high : Type*}
    (lp : LiftProject Ω_low Ω_high) (s : CarrierField Ω_low) :
    lp.project (lp.lift s) = s :=
  lp.roundtrip s

/-! ## §3. Identity and Composition -/

/-- The identity lift-project pair (same level). -/
def identityLiftProject (Ω : Type*) : LiftProject Ω Ω where
  lift := id
  project := id
  roundtrip := fun _ => rfl

/-- Compose two lift-project pairs. -/
def LiftProject.comp {Ω₁ Ω₂ Ω₃ : Type*}
    (lp₂₃ : LiftProject Ω₂ Ω₃) (lp₁₂ : LiftProject Ω₁ Ω₂) :
    LiftProject Ω₁ Ω₃ where
  lift := lp₂₃.lift ∘ lp₁₂.lift
  project := lp₁₂.project ∘ lp₂₃.project
  roundtrip := fun s => by
    simp [Function.comp]
    rw [lp₂₃.roundtrip, lp₁₂.roundtrip]

/-- Composing with identity on the left is identity. -/
theorem LiftProject.comp_id_left {Ω₁ Ω₂ : Type*}
    (lp : LiftProject Ω₁ Ω₂) (s : CarrierField Ω₁) :
    (LiftProject.comp (identityLiftProject Ω₂) lp).lift s = lp.lift s := rfl

/-- Composing with identity on the right is identity. -/
theorem LiftProject.comp_id_right {Ω₁ Ω₂ : Type*}
    (lp : LiftProject Ω₁ Ω₂) (s : CarrierField Ω₁) :
    (LiftProject.comp lp (identityLiftProject Ω₁)).lift s = lp.lift s := rfl

/-! ## §4. Tensor Product Lift (M3 → M6) -/

/-- Simple tensor product on ternary values. -/
def ternaryMul : Ternary → Ternary → Ternary
  | .zero, _     => .zero
  | _,     .zero => .zero
  | .pos,  .pos  => .pos
  | .neg,  .neg  => .pos
  | .pos,  .neg  => .neg
  | .neg,  .pos  => .neg

/-- Ternary multiplication is commutative. -/
theorem ternaryMul_comm (a b : Ternary) : ternaryMul a b = ternaryMul b a := by
  cases a <;> cases b <;> rfl

/-- Zero is absorbing. -/
theorem ternaryMul_zero_left (b : Ternary) : ternaryMul .zero b = .zero := rfl
theorem ternaryMul_zero_right (a : Ternary) : ternaryMul a .zero = .zero := by cases a <;> rfl

/-- Pos is the identity. -/
theorem ternaryMul_pos_left (b : Ternary) : ternaryMul .pos b = b := by cases b <;> rfl
theorem ternaryMul_pos_right (a : Ternary) : ternaryMul a .pos = a := by cases a <;> rfl

/-- Ternary multiplication is associative. -/
theorem ternaryMul_assoc (a b c : Ternary) :
    ternaryMul (ternaryMul a b) c = ternaryMul a (ternaryMul b c) := by
  cases a <;> cases b <;> cases c <;> rfl

/-- Tensor lift: Ω → Ω × Ω. -/
def tensorLift {Ω : Type*} (s : CarrierField Ω) : CarrierField (Ω × Ω) :=
  fun ⟨i, j⟩ => ternaryMul (s i) (s j)

/-- Tensor project: Ω × Ω → Ω via diagonal. -/
def tensorProject {Ω : Type*} (s : CarrierField (Ω × Ω)) : CarrierField Ω :=
  fun i => s (i, i)

/-
Tensor lift preserves support structure:
    support at (i,j) requires support at both i and j.
-/
theorem tensorLift_support {Ω : Type*} (s : CarrierField Ω) (i j : Ω)
    (h : (tensorLift s (i, j)).support = true) :
    (s i).support = true ∧ (s j).support = true := by
      cases hi : s i <;> cases hj : s j <;> simp_all +decide [ tensorLift ]

/-! ## §5. Backend Invariance -/

/-- Two backend executions are equivalent iff they produce identical
    carrier fields on all inputs. This is the parity requirement. -/
def backendEquivalent {Ω : Type*}
    (f g : CarrierField Ω → CarrierField Ω) : Prop :=
  ∀ s, f s = g s

/-- Backend equivalence is reflexive. -/
theorem backendEquivalent_refl {Ω : Type*}
    (f : CarrierField Ω → CarrierField Ω) :
    backendEquivalent f f := fun _ => rfl

/-- Backend equivalence is symmetric. -/
theorem backendEquivalent_symm {Ω : Type*}
    {f g : CarrierField Ω → CarrierField Ω}
    (h : backendEquivalent f g) :
    backendEquivalent g f := fun s => (h s).symm

/-- Backend equivalence is transitive. -/
theorem backendEquivalent_trans {Ω : Type*}
    {f g h : CarrierField Ω → CarrierField Ω}
    (hfg : backendEquivalent f g) (hgh : backendEquivalent g h) :
    backendEquivalent f h := fun s => (hfg s).trans (hgh s)

end DashiCORE