import Mathlib

/-!
# From Lattice Theory to the Soft Knaster–Tarski Theorem

This file formalizes the mathematical backbone of the accompanying note:

1. Foundational facts about complete lattices (the universal bounds `⊥` and `⊤`
   as the infimum and supremum of the whole universe).
2. Tarski's lattice-theoretical fixed point theorem: the explicit construction of
   the greatest fixed point of an isotone map `f` as `⨆ {x | x ≤ f x}`, together
   with the fact that the set of fixed points forms a complete lattice.
3. The "soft set" framework, modelled as the product order on `A × Set U` where
   `A` is the (complete) lattice of parameters and `Set U` is the power-set lattice
   of the universe `U`.  We prove the soft order is the product order, that soft
   intervals are complete lattices (Lemma 2.1), and the soft Knaster–Tarski
   theorem (Theorem 2.2).
4. The generalization to commuting families of order-preserving maps: the common
   fixed point set is non-empty (Tarski's second theorem / Leyewa–Abbas 2.5).

Throughout, `α`, `A` are complete lattices and maps are bundled as `OrderHom`
(written `α →o α`), i.e. monotone / isotone functions.
-/

namespace SoftTarski

/-! ## Section 1: Foundational algebraic structures

In a complete lattice the universal bounds are the infimum and the supremum of
the entire universe, exactly as in Tarski's presentation. -/

section Foundations

variable {α : Type*} [CompleteLattice α]

/-- `0 = ⋂ A`: the bottom element is the infimum of the whole universe. -/
theorem bot_eq_sInf_univ : (⊥ : α) = sInf Set.univ := by
  aesop

/-- `1 = ⋃ A`: the top element is the supremum of the whole universe. -/
theorem top_eq_sSup_univ : (⊤ : α) = sSup Set.univ := by
  simp

end Foundations

/-! ## Section 2: Tarski's lattice-theoretical fixed point theorem

We follow the step-by-step construction of the note.  Let
`u = ⨆ {x | x ≤ f x}`.  Then `u` is the greatest fixed point of `f`. -/

section Tarski

variable {α : Type*} [CompleteLattice α] (f : α →o α)

/-- The join of the "increasing" elements `{x | f x ≥ x}`. -/
noncomputable def tarskiSup : α := sSup {x | x ≤ f x}

/-- Step (2): `f (tarskiSup f)` is an upper bound of `{x | x ≤ f x}`, hence
`u ≤ f u`. -/
theorem le_map_tarskiSup : tarskiSup f ≤ f (tarskiSup f) :=
  sSup_le fun _ hx => le_trans hx (f.mono (le_sSup hx))

/-- Step (3): applying `f` to `u ≤ f u` shows `f u` is itself increasing, so it
lies below the supremum: `f u ≤ u`. -/
theorem map_tarskiSup_le : f (tarskiSup f) ≤ tarskiSup f :=
  le_sSup (f.mono (le_map_tarskiSup f))

/-- By antisymmetry, `u` is a fixed point of `f`. -/
theorem map_tarskiSup : f (tarskiSup f) = tarskiSup f :=
  le_antisymm (map_tarskiSup_le f) (le_map_tarskiSup f)

/-- `u` is the greatest fixed point: every fixed point lies below it. -/
theorem tarskiSup_isGreatest (a : α) (ha : f a = a) : a ≤ tarskiSup f :=
  le_sSup ha.ge

/-- The set of fixed points of an isotone map on a complete lattice is non-empty. -/
theorem fixedPoints_nonempty : (Function.fixedPoints (f : α → α)).Nonempty :=
  ⟨tarskiSup f, map_tarskiSup f⟩

/-- **Tarski's Theorem 1.** The set of fixed points of `f` is a complete lattice
under the induced order. -/
noncomputable def fixedPoints_completeLattice :
    CompleteLattice (Function.fixedPoints (f : α → α)) :=
  fixedPoints.completeLattice f

end Tarski

/-! ## Sections 3–4: Soft sets and the soft Knaster–Tarski theorem

A *soft ingredient* over a parameter lattice `A` and a universe `U` is a pair
`(x, S)` with `x : A` and `S : Set U`.  The *soft relation* `≤ₛ` is the product
order: `(x, S) ≤ₛ (y, T)` iff `x ≤ y` and `S ⊆ T`.  This is exactly the order
Lean puts on `A × Set U`. -/

section Soft

variable {A : Type*} [CompleteLattice A] {U : Type*}

/-- The soft relation is the product order on the parameter lattice and the
power-set lattice. -/
theorem soft_le_iff (p q : A × Set U) : p ≤ q ↔ p.1 ≤ q.1 ∧ p.2 ⊆ q.2 :=
  Iff.rfl

/-- The collection of soft ingredients is a (soft) complete lattice. -/
noncomputable example : CompleteLattice (A × Set U) := inferInstance

/-- **Lemma 2.1 (Soft intervals).** For `a ≤ₛ b` the soft interval `[a, b]` is
itself a soft complete lattice. -/
noncomputable def softInterval_completeLattice (a b : A × Set U) (h : a ≤ b) :
    CompleteLattice (Set.Icc a b) :=
  haveI : Fact (a ≤ b) := ⟨h⟩
  inferInstance

variable (f : (A × Set U) →o (A × Set U))

/-- **Theorem 2.2 (Soft Knaster–Tarski).** A soft isotone map on a soft complete
lattice has a soft fixed point. -/
theorem soft_knaster_tarski : ∃ p : A × Set U, f p = p :=
  ⟨tarskiSup f, map_tarskiSup f⟩

/-- The soft fixed point set forms a soft complete lattice. -/
noncomputable def soft_fixedPoints_completeLattice :
    CompleteLattice (Function.fixedPoints (f : A × Set U → A × Set U)) :=
  fixedPoints.completeLattice f

end Soft

/-! ## Section 5: Commuting families of mappings

If `f` and `g` are commuting isotone maps then `g` maps the fixed points of `f`
to fixed points of `f`, and the lattice structure is preserved.  We prove the
existence of a common fixed point, first for a pair and then for an arbitrary
commuting family. -/

section Commuting

variable {α : Type*} [CompleteLattice α]

/-- **Common fixed point of two commuting isotone maps.**
Take `m = ⨆ {x | x ≤ f x ∧ x ≤ g x}`.  Then `m` is a common fixed point. -/
theorem commuting_common_fixedPoint (f g : α →o α)
    (hcomm : (f : α → α) ∘ g = g ∘ f) :
    ∃ x : α, f x = x ∧ g x = x := by
  -- Define `m = ⨆ {x | x ≤ f x ∧ x ≤ g x}`.
  set m : α := sSup {x | x ≤ f x ∧ x ≤ g x} with hm_def
  -- Both `m ≤ f m` and `m ≤ g m`, since `f m` (resp. `g m`) is an upper bound.
  have hm_le_fm_gm : m ≤ f m ∧ m ≤ g m := by
    refine ⟨sSup_le fun x hx => ?_, sSup_le fun x hx => ?_⟩
    · exact le_trans hx.1 (f.monotone (le_sSup hx))
    · exact le_trans hx.2 (g.monotone (le_sSup hx))
  -- `f m` is increasing and `≤ g (f m)`, so it belongs to the set.
  have hfm_in_S : f m ∈ {x | x ≤ f x ∧ x ≤ g x} := by
    refine ⟨f.monotone hm_le_fm_gm.1, ?_⟩
    have : f (g m) = g (f m) := congrFun hcomm m
    exact this ▸ f.monotone hm_le_fm_gm.2
  -- `g m` is increasing and `≤ f (g m)`, so it belongs to the set.
  have hgm_in_S : g m ∈ {x | x ≤ f x ∧ x ≤ g x} := by
    refine ⟨?_, g.monotone hm_le_fm_gm.2⟩
    have : g (f m) = f (g m) := (congrFun hcomm m).symm
    exact this ▸ g.monotone hm_le_fm_gm.1
  exact ⟨m, le_antisymm (le_sSup hfm_in_S) hm_le_fm_gm.1,
    le_antisymm (le_sSup hgm_in_S) hm_le_fm_gm.2⟩

/-- **Theorem 2.5 (commuting family).** For a commuting family `𝓕` of isotone
maps on a complete lattice, the set of common fixed points is non-empty.
Take `m = ⨆ {x | ∀ f ∈ 𝓕, x ≤ f x}`. -/
theorem commuting_family_common_fixedPoint (𝓕 : Set (α →o α))
    (hcomm : ∀ f ∈ 𝓕, ∀ g ∈ 𝓕, (f : α → α) ∘ g = g ∘ f) :
    ∃ x : α, ∀ f ∈ 𝓕, f x = x := by
  -- Let `S = {x | ∀ f ∈ 𝓕, x ≤ f x}` and `m = sSup S`.
  set S := {x : α | ∀ f ∈ 𝓕, x ≤ f x} with hS_def
  set m := sSup S with hm_def
  -- For every `f ∈ 𝓕`, `f m` is an upper bound of `S`, so `m ≤ f m`.
  have hm : ∀ f ∈ 𝓕, m ≤ f m :=
    fun f hf => sSup_le fun x hx => le_trans (hx f hf) (f.monotone (le_sSup hx))
  -- For every `f ∈ 𝓕`, `f m ∈ S`: for each `g ∈ 𝓕`, `f m ≤ f (g m) = g (f m)`.
  have hf_m_in_S : ∀ f ∈ 𝓕, f m ∈ S := by
    intro f hf g hg
    have : f (g m) = g (f m) := congrFun (hcomm f hf g hg) m
    exact this ▸ f.monotone (hm g hg)
  -- Hence `f m ≤ m` and, with `m ≤ f m`, equality.
  exact ⟨m, fun f hf => le_antisymm (le_sSup (hf_m_in_S f hf)) (hm f hf)⟩

end Commuting

end SoftTarski
