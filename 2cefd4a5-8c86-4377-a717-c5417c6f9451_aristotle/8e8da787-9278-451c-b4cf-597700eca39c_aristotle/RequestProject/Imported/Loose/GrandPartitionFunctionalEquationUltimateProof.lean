import Mathlib

set_option linter.mathlibStandardSet false

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 0
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

noncomputable section

open Complex
open scoped BigOperators

variable (M : Type) [Group M] [Fintype M]
variable [MulAction M M]

noncomputable def class_weight (g : M) [Fintype ↑(MulAction.orbit M g)] : ℝ :=
  (Fintype.card ↑(MulAction.orbit M g) : ℝ) / (Fintype.card M : ℝ)

variable (graded_trace : M → ℂ → ℂ)
variable (DULA_Operator : M → ℂ)
variable (Fricke_Involution : ℂ → ℂ)
variable (epsilon_g : M → ℝ)

variable (VOA_Global_Commutativity : ∀ (g : M) (tau : ℂ),
  graded_trace g (Fricke_Involution tau) * DULA_Operator g = 
  epsilon_g g * (graded_trace g tau * DULA_Operator g))

variable (Lambda_DULA : M → ℂ → ℂ)
variable (Individual_Functional_Equation : ∀ (g : M) (s : ℂ),
  Lambda_DULA g s = epsilon_g g * Lambda_DULA g (1 - s))

variable (ConjugacyClasses : Finset M)

noncomputable def Grand_Z_DULA (s : ℂ) : ℂ :=
  ∑ g ∈ ConjugacyClasses, (class_weight M g) * (Lambda_DULA g s)

theorem Grand_Partition_Functional_Equation_Ultimate
  (M : Type) [Group M] [Fintype M] [MulAction M M]
  (epsilon_g : M → ℝ)
  (Lambda_DULA : M → ℂ → ℂ)
  (ConjugacyClasses : Finset M)
  (Individual_Functional_Equation : ∀ (g : M) (s : ℂ), Lambda_DULA g s = epsilon_g g * Lambda_DULA g (1 - s))
  (s : ℂ) :
  Grand_Z_DULA M Lambda_DULA ConjugacyClasses s = 
  ∑ g ∈ ConjugacyClasses, (class_weight M g) * (epsilon_g g) * Lambda_DULA g (1 - s) := by
  unfold Grand_Z_DULA
  apply Finset.sum_congr rfl
  intro g _
  rw [Individual_Functional_Equation g s]
  push_cast
  ring
