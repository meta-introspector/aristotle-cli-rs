import Mathlib

/-!
# ZKP Constraint Engine

A Lean formalization of a MiniZinc-like constraint satisfaction engine for
plugin certification. Constraints are arithmetic/boolean conditions over
named integer variables that model plugin compliance bounds.

## Components:
- `VarDecl` : Named integer variable with optional bounds
- `ConstraintOp` : Primitive constraint operations (≤, =, ∧)
- `ConstraintModel` : A collection of variable declarations and constraint ops
- `Assignment` : Variable → value mapping
- `satisfiedBy` : Whether an assignment satisfies a constraint
- `isSatisfiedBy` : Whether an assignment satisfies all constraints in a model

## Key Properties:
- Constraint evaluation is deterministic
- Unsatisfiable models yield no valid assignments
- Adding constraints can only reduce the solution space (monotonicity)
-/

namespace ZKP.Constraint

-- ============================================================================
-- Core Types
-- ============================================================================

/-- A named variable declaration in the constraint system. -/
structure VarDecl where
  name : String
  lowerBound : Option Int := none
  upperBound : Option Int := none
  deriving DecidableEq, Repr

/-- Primitive constraint operations supported by the engine. -/
inductive ConstraintOp where
  /-- Variable ≤ literal bound -/
  | leq (varName : String) (bound : Int)
  /-- Variable = literal value -/
  | eq (varName : String) (value : Int)
  /-- Variable₁ = Variable₂ -/
  | eqVar (var1 var2 : String)
  /-- Variable₁ ∧ Variable₂ → Variable₃ (all interpreted as booleans: nonzero = true) -/
  | andBool (var1 var2 target : String)
  /-- Variable ≥ literal bound -/
  | geq (varName : String) (bound : Int)
  /-- Variable ∈ [lo, hi] -/
  | inRange (varName : String) (lo hi : Int)
  deriving DecidableEq, Repr

/-- An assignment maps variable names to integer values. -/
def Assignment := String → Int

/-- A constraint model is a list of variable declarations and constraint ops. -/
structure ConstraintModel where
  varDecls : List VarDecl
  ops : List ConstraintOp
  deriving Repr

-- ============================================================================
-- Constraint Evaluation
-- ============================================================================

/-- Evaluate whether a single constraint is satisfied under a given assignment. -/
def ConstraintOp.satisfiedBy (c : ConstraintOp) (σ : Assignment) : Bool :=
  match c with
  | .leq v b      => decide (σ v ≤ b)
  | .eq v val     => decide (σ v = val)
  | .eqVar v1 v2  => decide (σ v1 = σ v2)
  | .andBool v1 v2 t =>
      let b1 := σ v1 != 0
      let b2 := σ v2 != 0
      let result := b1 && b2
      let target := σ t != 0
      result == target
  | .geq v b      => decide (σ v ≥ b)
  | .inRange v lo hi => decide (lo ≤ σ v) && decide (σ v ≤ hi)

/-- Check whether an assignment satisfies all constraints in a model. -/
def ConstraintModel.isSatisfiedBy (m : ConstraintModel) (σ : Assignment) : Bool :=
  m.ops.all (·.satisfiedBy σ)

/-- A model is satisfiable if there exists a satisfying assignment. -/
def ConstraintModel.isSatisfiable (m : ConstraintModel) : Prop :=
  ∃ σ : Assignment, m.isSatisfiedBy σ = true

/-- An execution trace records the boolean result of each constraint evaluation. -/
def ConstraintModel.executionTrace (m : ConstraintModel) (σ : Assignment) : List Bool :=
  m.ops.map (·.satisfiedBy σ)

/-- Add a constraint to a model. -/
def ConstraintModel.addConstraint (m : ConstraintModel) (c : ConstraintOp) : ConstraintModel :=
  { m with ops := m.ops ++ [c] }

/-- The empty model (no variables, no constraints). -/
def ConstraintModel.empty : ConstraintModel :=
  { varDecls := [], ops := [] }

-- ============================================================================
-- Compliance Profile
-- ============================================================================

/-- A compliance profile specifies the bounds a plugin must satisfy. -/
structure ComplianceProfile where
  maxBinarySize : Nat        -- Maximum binary size in bytes
  maxMemoryPages : Nat       -- Maximum runtime memory pages
  maxInstructionCycles : Nat -- Maximum worst-case execution cycles
  typeSystem : String        -- Required type system (e.g., "wasm_core_v1")
  deriving DecidableEq, Repr

/-- Convert a compliance profile into a constraint model. -/
def ComplianceProfile.toModel (profile : ComplianceProfile) : ConstraintModel :=
  { varDecls := [
      ⟨"plugin_binary_size", some 0, some ↑profile.maxBinarySize⟩,
      ⟨"worst_case_cycles", some 0, some ↑profile.maxInstructionCycles⟩,
      ⟨"memory_pages", some 0, some ↑profile.maxMemoryPages⟩,
      ⟨"type_violations", some 0, none⟩,
      ⟨"is_type_safe", some 0, some 1⟩,
      ⟨"is_compliant", some 0, some 1⟩
    ],
    ops := [
      .leq "plugin_binary_size" ↑profile.maxBinarySize,
      .leq "worst_case_cycles" ↑profile.maxInstructionCycles,
      .leq "memory_pages" ↑profile.maxMemoryPages,
      .eq "type_violations" 0,
      .eq "is_type_safe" 1,
      .eq "is_compliant" 1
    ]
  }

-- ============================================================================
-- Properties
-- ============================================================================

/-- Evaluation is deterministic: same constraint, same assignment → same result. -/
theorem satisfiedBy_deterministic (c : ConstraintOp) (σ : Assignment) :
    c.satisfiedBy σ = c.satisfiedBy σ := rfl

/-- The empty model is satisfied by any assignment. -/
theorem empty_model_satisfied (σ : Assignment) :
    ConstraintModel.empty.isSatisfiedBy σ = true := by
  simp [ConstraintModel.isSatisfiedBy, ConstraintModel.empty]

/-
Adding a constraint can only make satisfaction harder (monotonicity).
    If the extended model is satisfied, the original model is also satisfied.
-/
theorem addConstraint_monotone (m : ConstraintModel) (c : ConstraintOp) (σ : Assignment)
    (h : (m.addConstraint c).isSatisfiedBy σ = true) :
    m.isSatisfiedBy σ = true := by
  unfold ConstraintModel.isSatisfiedBy at *;
  unfold ConstraintModel.addConstraint at h; aesop;

/-
An unsatisfied constraint means the model is not satisfied.
-/
theorem unsatisfied_constraint_fails (m : ConstraintModel) (σ : Assignment) (c : ConstraintOp)
    (hMem : c ∈ m.ops)
    (hFail : c.satisfiedBy σ = false) :
    m.isSatisfiedBy σ = false := by
  unfold ConstraintModel.isSatisfiedBy; aesop;

/-- The execution trace length equals the number of constraints. -/
theorem trace_length (m : ConstraintModel) (σ : Assignment) :
    (m.executionTrace σ).length = m.ops.length := by
  simp [ConstraintModel.executionTrace]

/-
A model is satisfied iff every element of the execution trace is true.
-/
theorem satisfied_iff_trace_all_true (m : ConstraintModel) (σ : Assignment) :
    m.isSatisfiedBy σ = true ↔ (m.executionTrace σ).all (· == true) = true := by
  simp [ConstraintModel.isSatisfiedBy, ConstraintModel.executionTrace]

end ZKP.Constraint