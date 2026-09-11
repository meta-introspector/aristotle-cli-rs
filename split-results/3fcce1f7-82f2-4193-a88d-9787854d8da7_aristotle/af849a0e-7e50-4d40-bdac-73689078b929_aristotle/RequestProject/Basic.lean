/-
# Basic Types for Decentralized AI Formalization

Common mathematical types used across the formalization: vectors, tensors,
probability measures, and adjacency relations.
-/
import Mathlib

open scoped BigOperators

/-! ## Vector and Tensor Types -/

/-- A simple real-valued vector of fixed dimension. -/
abbrev Vec (n : ℕ) := Fin n → ℝ

/-- L2 norm squared of a vector. -/
noncomputable def Vec.normSq {n : ℕ} (v : Vec n) : ℝ :=
  ∑ i, v i ^ 2

/-- L2 norm of a vector. -/
noncomputable def Vec.norm {n : ℕ} (v : Vec n) : ℝ :=
  Real.sqrt (Vec.normSq v)

/-- Pointwise addition of vectors. -/
def Vec.add {n : ℕ} (u v : Vec n) : Vec n := fun i => u i + v i

/-- Scalar multiplication of a vector. -/
def Vec.smul {n : ℕ} (c : ℝ) (v : Vec n) : Vec n := fun i => c * v i

/-- Pointwise subtraction of vectors. -/
def Vec.sub {n : ℕ} (u v : Vec n) : Vec n := fun i => u i - v i

/-- Weighted sum of a list of vectors. -/
noncomputable def Vec.weightedSum {n : ℕ} {K : ℕ}
    (weights : Fin K → ℝ) (vecs : Fin K → Vec n) : Vec n :=
  fun i => ∑ k, weights k * vecs k i

/-! ## Probability and Measure Basics -/

/-- A discrete probability mass function over a finite type. -/
structure DiscretePMF (α : Type*) [Fintype α] where
  prob : α → ℝ
  nonneg : ∀ a, 0 ≤ prob a
  sum_one : ∑ a, prob a = 1

/-- Probability of a set under a DiscretePMF. -/
noncomputable def DiscretePMF.probSet {α : Type*} [Fintype α] [DecidableEq α]
    (p : DiscretePMF α) (S : Finset α) : ℝ :=
  ∑ a ∈ S, p.prob a

lemma DiscretePMF.probSet_nonneg {α : Type*} [Fintype α] [DecidableEq α]
    (p : DiscretePMF α) (S : Finset α) : 0 ≤ p.probSet S :=
  Finset.sum_nonneg fun a _ => p.nonneg a

/-! ## Dataset Adjacency -/

/-- Two datasets are adjacent if they differ in exactly one record. -/
structure Adjacent {α : Type*} (S S' : List α) : Prop where
  diff_one : ∃ i x x', S = S'.set i x' ∧ S' = S.set i x ∧ S.length = S'.length
