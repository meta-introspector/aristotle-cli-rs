import Mathlib

/-!
# The Quasi Meta Meme (QMM) Framework in Lean 4

This formalization represents programs as self-operating entities
within a high-dimensional embedding space governed by Lie dynamics.

## Mathematical Setup

We work with a concrete model:
- The **embedding/state space** is `ℝ^d` (i.e., `Fin d → ℝ`).
- The **Lie algebra** is `𝔤𝔩(d, ℝ)`, the space of `d × d` real matrices,
  equipped with the commutator bracket `⁅A, B⁆ = A * B - B * A`.
- The **Lie group** action is via the matrix exponential: `exp(A) · v`.

The central QMM postulate — that computation is a smooth trajectory through
a high-dimensional embedding space governed by Lie group dynamics — is
captured by the transition function `qmm_step`.
-/

open Matrix NormedSpace

/-!
## 1. The Embedding Space and Lie Algebra
-/

/-- The Lie algebra `𝔤𝔩(d, ℝ)`: real `d × d` matrices with the commutator bracket. -/
abbrev 𝔤𝔩 (d : ℕ) := Matrix (Fin d) (Fin d) ℝ

/-- The state space `ℝ^d`. -/
abbrev StateSpace (d : ℕ) := Fin d → ℝ

variable (d : ℕ)

/-!
## 2. Program Embeddings and VM State
-/

/--
**POSTULATE 1: Programs as Embeddings (`v_P`).**

A program embedding combines:
- `vector`: the program's representation in the state space `ℝ^d`, and
- `generator`: a matrix `A(v_P) ∈ 𝔤𝔩(d, ℝ)` encoding the program's
  computational effect as an infinitesimal generator in the Lie algebra.
-/
structure ProgramEmbedding (d : ℕ) where
  /-- The program's representation vector in `ℝ^d`. -/
  vector : StateSpace d
  /-- The infinitesimal generator `A(v_P)` in the Lie algebra `𝔤𝔩(d, ℝ)`. -/
  generator : 𝔤𝔩 d

/--
**POSTULATE 2: VM State as an Embedding (`v_state`).**

The current state of the "Quasi Meta Virtual Machine" is a vector in `ℝ^d`.
-/
def VMState := StateSpace d

/-!
## 3. The QMM Transition Function (Self-Operation)
-/

/--
**THE QMM TRANSITION FUNCTION (Self-Operation).**

Implements the formula `v_next = exp(A(v_P)) · v_state`.

The next state is derived by:
1. Taking the program's Lie algebra element `A(v_P)` (the infinitesimal generator),
2. Exponentiating it via the matrix exponential to get a finite transformation `exp(A(v_P))`,
3. Applying this transformation to the current state via matrix-vector multiplication.
-/
noncomputable def qmm_step (prog : ProgramEmbedding d) (state : StateSpace d) : StateSpace d :=
  (exp prog.generator).mulVec state

/--
**Iterated QMM computation.**

Running `n` steps of QMM with the same program corresponds to `exp(n · A) · v_state`,
modeling a computation trajectory through the state space.
-/
noncomputable def qmm_trajectory (prog : ProgramEmbedding d) (state : StateSpace d) : ℕ → StateSpace d
  | 0 => state
  | n + 1 => qmm_step d prog (qmm_trajectory prog state n)

/-!
## 4. The Lie Bracket as the "Grammar of Microsteps"
-/

/-
**THEOREM (Lie Bracket Grammar — Forward Direction).**

If the Lie bracket `[X, Y] = 0` (i.e., the two generators commute as matrices),
then their exponentials commute: `exp(X) * exp(Y) = exp(Y) * exp(X)`.

This formalizes the QMM claim that the Lie bracket defines the "structure of
possible transformations": when `[X, Y] = 0`, the order of applying the two
programs does not matter, and both compositions yield the same result.

*Note:* The converse does not hold in general for matrix Lie groups — there exist
non-commuting matrices whose exponentials commute. The forward direction is the
mathematically rigorous content of the QMM "grammar" postulate.
-/
theorem lie_bracket_grammar (X Y : 𝔤𝔩 d)
    (h : ⁅X, Y⁆ = 0) :
    exp X * exp Y = exp Y * exp X := by
  have h_comm : Commute X Y := commute_iff_lie_eq.mpr h
  have h_exp_comm : exp X * exp Y = exp (X + Y) := by
    rw [ ← Matrix.exp_add_of_commute ] ; aesop;
  have h_exp_comm' : exp Y * exp X = exp (Y + X) :=
    (Matrix.exp_add_of_commute Y X h_comm.symm).symm
  rw [h_exp_comm, h_exp_comm', add_comm]

/-
**COROLLARY: Commuting programs yield order-independent computation.**

If two programs have commuting generators (`[A₁, A₂] = 0`), then applying
them in either order yields the same final state.
-/
theorem qmm_step_comm (p₁ p₂ : ProgramEmbedding d) (state : StateSpace d)
    (h : ⁅p₁.generator, p₂.generator⁆ = 0) :
    qmm_step d p₁ (qmm_step d p₂ state) = qmm_step d p₂ (qmm_step d p₁ state) := by
  -- Apply the lemma that allows us to interchange the order of matrix multiplication.
  have h_comm : (exp p₁.generator) * (exp p₂.generator) = (exp p₂.generator) * (exp p₁.generator) :=
    lie_bracket_grammar d p₁.generator p₂.generator h
  unfold qmm_step; aesop;

/-!
## 5. Compositionality of the Exponential Map
-/

/-
**THEOREM: Composition of commuting programs.**

When two programs commute (`[A₁, A₂] = 0`), composing their effects is the same
as exponentiating the sum: `exp(A₁) · (exp(A₂) · v) = exp(A₁ + A₂) · v`.

This is the algebraic foundation of QMM's claim that "programs compose smoothly".
-/
theorem qmm_composition (p₁ p₂ : ProgramEmbedding d) (state : StateSpace d)
    (h : ⁅p₁.generator, p₂.generator⁆ = 0) :
    qmm_step d p₁ (qmm_step d p₂ state) =
    (exp (p₁.generator + p₂.generator)).mulVec state := by
  have h_comm : p₁.generator * p₂.generator = p₂.generator * p₁.generator := by
    exact eq_of_sub_eq_zero h;
  have h_exp_comm : NormedSpace.exp (p₁.generator + p₂.generator) = NormedSpace.exp p₁.generator * NormedSpace.exp p₂.generator :=
    Matrix.exp_add_of_commute p₁.generator p₂.generator (eq_of_sub_eq_zero h)
  unfold qmm_step; simp +decide [ h_exp_comm, Matrix.mulVec_mulVec ] ;

/-!
## 6. Software Controllability
-/

/--
**DEFINITION: Reachable states.**

The set of states reachable from a given initial state using a collection
of available program embeddings (and their compositions).
-/
noncomputable def reachable_states
    (programs : Set (ProgramEmbedding d))
    (initial : StateSpace d) : Set (StateSpace d) :=
  { s | ∃ (n : ℕ) (seq : Fin n → ProgramEmbedding d),
    (∀ i, seq i ∈ programs) ∧
    s = (List.ofFn (fun i => (seq i).generator)).foldl
      (fun acc A => (exp A).mulVec acc) initial }

/--
**DEFINITION: Software Controllability.**

A system is controllable if every state in `ℝ^d` is reachable from any initial state
using the available programs. Drawing from robotics and control theory, this holds
when the Lie algebra generated by the program generators (via iterated brackets)
spans the full tangent space `𝔤𝔩(d, ℝ)`.
-/
def is_controllable (programs : Set (ProgramEmbedding d)) : Prop :=
  ∀ (initial target : StateSpace d), target ∈ reachable_states d programs initial

/-!
## 7. The Identity Program
-/

/-
**THEOREM: The zero generator is the identity transformation.**

A program with generator `A = 0` acts as the identity: `exp(0) · v = v`.
This is the "no-op" of QMM dynamics.
-/
theorem qmm_identity (state : StateSpace d) :
    (exp (0 : 𝔤𝔩 d)).mulVec state = state := by
  convert Matrix.one_mulVec state;
  convert NormedSpace.exp_zero