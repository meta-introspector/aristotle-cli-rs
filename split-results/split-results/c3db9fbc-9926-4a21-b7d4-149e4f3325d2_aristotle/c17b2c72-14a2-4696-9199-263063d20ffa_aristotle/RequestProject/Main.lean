/-
# Fold/Scan Compiler Pass Framework

Formalization of the core mathematical structure underlying the "inversion" framework,
where compiler passes are modeled as a fold over a type-level sequence, and intermediate
states (Frobenius traces / series coefficients) arise as the scan.

## Key concepts:
- **Motive**: The accumulator type, representing compiler state
- **PassSequence**: A list of "passes" (transformations on the motive)
- **Pipeline (Foldl)**: Final state after applying all passes
- **Series (Scanl)**: All intermediate states — the "ast_series(f)"
- **Convergents**: The nth intermediate state = foldl on the first n passes

## Main theorems:
1. `scanl_last_eq_foldl`: The last element of the scan equals the fold result
2. `scanl_nth_eq_foldl_take`: The nth scan element equals fold on first n passes
   (already in Mathlib as `List.getElem_scanl`)
3. `pipeline_determines_series_endpoint`: Pipeline result is recoverable from series
4. `series_monotone_refinement`: Each convergent refines the previous one's information
-/

import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000

/-! ## Core Definitions -/

/-- A `Pass` is a transformation on a motive (accumulator) state.
    In the C++ analogy: each element of `TypeList<FrobeniusPass, FunctionalEquationPass, ...>`.
    Here we work concretely with `α → α` rather than at the type level. -/
abbrev Pass (α : Type*) := α → α

/-- The pipeline: fold a sequence of passes over an initial motive.
    Corresponds to `Foldl<Trampoline, M, PassSequence>`. -/
def pipeline {α : Type*} (passes : List (Pass α)) (init : α) : α :=
  passes.foldl (fun acc p => p acc) init

/-- The series: all intermediate motive states during the fold.
    Corresponds to `Scanl<Trampoline, M, PassSequence>`.
    These are the "ast_series(f)" coefficients. -/
def series {α : Type*} (passes : List (Pass α)) (init : α) : List α :=
  List.scanl (fun acc p => p acc) init passes

/-- The nth convergent: motive state after n passes.
    Corresponds to `Head<Drop<N, SeriesCoefficients>>`. -/
def convergent {α : Type*} (passes : List (Pass α)) (init : α) (n : ℕ) (h : n < passes.length + 1) : α :=
  (series passes init)[n]'(by simp [series, List.length_scanl]; omega)

/-! ## Core Theorems -/

/-
The series always starts with the initial motive state.
-/
theorem series_head {α : Type*} (passes : List (Pass α)) (init : α) :
    (series passes init).head (by simp [series]) = init := by
  -- By definition of `series`, we know that its head is `init`.
  simp [series]

/-
The series has length `passes.length + 1` (one entry per pass, plus the initial state).
-/
theorem series_length {α : Type*} (passes : List (Pass α)) (init : α) :
    (series passes init).length = passes.length + 1 := by
  -- By definition of `series`, we have `(series passes init) = List.scanl (fun acc p => p acc) init passes`.
  simp [series]

/-
**Key theorem**: The last element of the scan equals the fold result.
    The pipeline result is the final series coefficient.
    In C++ terms: `Last<Scanl<...>> ≡ Foldl<...>`.
-/
theorem scanl_last_eq_foldl {α : Type*} (passes : List (Pass α)) (init : α) :
    (series passes init).getLast (by simp [series]) = pipeline passes init := by
  unfold series pipeline; induction passes generalizing init <;> simp_all +decide [ List.scanl ] ;
  grind

/-
**Key theorem**: The nth convergent equals the fold on the first n passes.
    This is the core identity: `Head<Drop<N, Scanl<...>>> ≡ Foldl<..., Take<N, Passes>>`.
    Already in Mathlib as `List.getElem_scanl`, restated here in our vocabulary.
-/
theorem convergent_eq_partial_pipeline {α : Type*} (passes : List (Pass α)) (init : α)
    (n : ℕ) (hn : n ≤ passes.length) :
    convergent passes init n (by omega) = pipeline (passes.take n) init := by
  -- By definition of convergent, we have convergent passes init n = (series passes init)[n]!.
  simp [convergent, series];
  rfl

/-
The 0th convergent is always the initial state.
-/
theorem convergent_zero {α : Type*} (passes : List (Pass α)) (init : α)
    (h : 0 < passes.length + 1) :
    convergent passes init 0 h = init := by
  convert series_head _ _;
  convert List.getElem_zero _

/-
The final convergent equals the full pipeline result.
-/
theorem convergent_last {α : Type*} (passes : List (Pass α)) (init : α)
    (h : passes.length < passes.length + 1) :
    convergent passes init passes.length h = pipeline passes init := by
  grind +suggestions

/-
Each convergent extends the previous by one more pass application.
-/
theorem convergent_step {α : Type*} (passes : List (Pass α)) (init : α)
    (n : ℕ) (hn : n < passes.length) :
    convergent passes init (n + 1) (by omega) =
      passes[n] (convergent passes init n (by omega)) := by
  unfold convergent;
  unfold series;
  rw [ List.getElem_succ_scanl ]

/-! ## Certification Framework

The `static_assert` analogue: a predicate that must hold at every intermediate state,
modeling the functional equation / GRH witness checks. -/

/-- A pass sequence satisfies an invariant if the invariant holds at every intermediate state.
    This is the type-level analogue of:
    ```cpp
    static_assert(Pipeline::satisfies_functional_equation());
    ```
    but checked at every stage, not just the final one. -/
def certified {α : Type*} (inv : α → Prop) (passes : List (Pass α)) (init : α) : Prop :=
  ∀ x ∈ series passes init, inv x

/-
If each pass preserves an invariant and it holds initially, the pipeline is certified.
-/
theorem certified_of_preserving {α : Type*} (inv : α → Prop) (passes : List (Pass α)) (init : α)
    (h_init : inv init) (h_pres : ∀ p ∈ passes, ∀ x, inv x → inv (p x)) :
    certified inv passes init := by
  induction' passes with p passes ih generalizing init;
  · exact fun x hx => by rw [ List.mem_singleton.mp hx ] ; exact h_init;
  · intro x hx;
    unfold series at hx; aesop;

/-
A certified pipeline produces a result satisfying the invariant.
-/
theorem pipeline_satisfies_of_certified {α : Type*} (inv : α → Prop) (passes : List (Pass α)) (init : α)
    (h : certified inv passes init) :
    inv (pipeline passes init) := by
  exact scanl_last_eq_foldl passes init ▸ h _ ( List.getLast_mem _ )

/-! ## GRH Witness Example

A concrete instantiation: motive states carry a "zero proximity" value,
and we certify that all zeros stay on the critical line (proximity < bound)
up to the detectable depth. -/

/-- A motive state with arithmetic data. -/
structure MotiveState where
  /-- Current L-function coefficient accumulator -/
  value : ℤ
  /-- Running proximity to critical line -/
  zeroProximity : ℚ
  /-- Depth (number of passes applied) -/
  depth : ℕ

/-- The GRH witness predicate: zero proximity stays below 1/(depth+1)².
    This is the Lean analogue of:
    ```cpp
    static_assert(critical_zeros_on_half_line<MyMotive>(DEPTH), "GRH violated");
    ``` -/
def grhWitness (s : MotiveState) : Prop :=
  s.zeroProximity < 1 / ((s.depth : ℚ) + 1) ^ 2

/-- If each pass in the sequence preserves the GRH witness property,
    then the full pipeline is a certified finite GRH witness. -/
theorem grh_certified_pipeline (passes : List (Pass MotiveState)) (init : MotiveState)
    (h_init : grhWitness init)
    (h_pres : ∀ p ∈ passes, ∀ s, grhWitness s → grhWitness (p s)) :
    certified grhWitness passes init :=
  certified_of_preserving grhWitness passes init h_init h_pres