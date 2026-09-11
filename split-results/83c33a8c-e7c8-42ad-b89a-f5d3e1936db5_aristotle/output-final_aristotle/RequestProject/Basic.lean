/-
# Atlas of Finite Simple Groups — Lean 4 Formalization

This project is part of a consensus-driven effort to formalize the
Atlas of Finite Simple Groups (R. A. Wilson, et al.) in Lean 4,
combining human mathematical expertise with machine-verified proofs.

## Scope

The Atlas catalogs the finite simple groups and records:
- Group orders
- Maximal subgroups
- Character tables
- Outer automorphism groups
- Schur multipliers

This formalization aims to state and prove key facts from the Atlas
in a machine-checkable format using Lean 4 and Mathlib.
-/

import Mathlib

/-! ## Basic definitions and utilities for the Atlas formalization -/

/-- A predicate asserting that a finite group has a specific order. -/
def HasGroupOrder (G : Type*) [Group G] [Fintype G] (n : ℕ) : Prop :=
  Fintype.card G = n

/-- A predicate asserting that the outer automorphism group of G has a given order. -/
noncomputable def outOrder (G : Type*) [Group G] :=
  MulAut G ⧸ MulAut.conj.range

