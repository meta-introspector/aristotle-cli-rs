/-
# Section 1: Foundations of Categorical Structure

This file formalizes the core categorical framework using Mathlib's category theory library.
We demonstrate the key concepts: objects, morphisms, composition, identity, and the
fundamental axioms (associativity, unit laws).

We also illustrate the difference between a "graph" (raw quiver) and a "category"
(a quiver equipped with composition and identity satisfying axioms).
-/

import Mathlib

open CategoryTheory

/-! ## 1.1 The Category Class

Mathlib's `CategoryTheory.Category` is a class on a type `C : Type u` providing:
- `Hom : C → C → Type v` (the morphism sets)
- `id : ∀ (X : C), X ⟶ X` (identity morphisms)
- `comp : (X ⟶ Y) → (Y ⟶ Z) → (X ⟶ Z)` (composition)
- Associativity and unit laws as `@[simp]` lemmas.

We demonstrate these axioms explicitly below.
-/

section CategoryAxioms

variable {C : Type*} [Category C]

/-- **Associativity of composition**: `(h ≫ g) ≫ f = h ≫ (g ≫ f)` in diagrammatic order. -/
theorem composition_assoc {A B D E : C} (f : A ⟶ B) (g : B ⟶ D) (h : D ⟶ E) :
    (f ≫ g) ≫ h = f ≫ (g ≫ h) :=
  Category.assoc f g h

/-- **Left unit law**: `𝟙 A ≫ f = f`. -/
theorem left_unit {A B : C} (f : A ⟶ B) : 𝟙 A ≫ f = f :=
  Category.id_comp f

/-- **Right unit law**: `f ≫ 𝟙 B = f`. -/
theorem right_unit {A B : C} (f : A ⟶ B) : f ≫ 𝟙 B = f :=
  Category.comp_id f

end CategoryAxioms

/-! ## 1.2 Isomorphisms

An isomorphism in a category is an arrow `f : A ⟶ B` with a two-sided inverse.
In Lean4/Mathlib, this is `Iso A B`, written `A ≅ B`.
-/

section Isomorphisms

variable {C : Type*} [Category C]

/-- An isomorphism is symmetric: if `A ≅ B` then `B ≅ A`. -/
def iso_symm {A B : C} (i : A ≅ B) : B ≅ A := i.symm

/-- Isomorphisms compose: if `A ≅ B` and `B ≅ C` then `A ≅ C`. -/
def iso_trans {A B D : C} (i : A ≅ B) (j : B ≅ D) : A ≅ D := i.trans j

/-- Every object is isomorphic to itself. -/
def iso_refl (A : C) : A ≅ A := Iso.refl A

end Isomorphisms

/-! ## 1.3 Differentiation: Category vs. Graph (Quiver)

A `Quiver` provides the raw data of objects and arrows (vertices and edges).
A `Category` adds composition, identity, and the axioms.
This mirrors the distinction between a `Structure` (data) and a `TypeClass` (data + laws).
-/

section GraphVsCategory

/-- A simple quiver (directed graph) on three vertices with specified edges. -/
inductive ThreeVertex : Type where
  | A | B | C

instance : Quiver ThreeVertex where
  Hom := fun x y => match x, y with
    | .A, .B => Unit  -- one edge A → B
    | .B, .C => Unit  -- one edge B → C
    | _, _ => Empty    -- no other edges

/-- In a quiver, we can have edges but no composition.
    In a category, the existence of `A → B` and `B → C` implies `A → C`. -/
theorem quiver_has_no_composition :
    ∀ (_ : ThreeVertex.A ⟶ ThreeVertex.B) (_ : ThreeVertex.B ⟶ ThreeVertex.C),
    IsEmpty (ThreeVertex.A ⟶ ThreeVertex.C) := by
  intro _ _
  exact ⟨fun x => x.elim⟩

end GraphVsCategory

/-! ## 1.4 Concrete Category Examples -/

section Examples

/-- `Type` forms a category where morphisms are functions. -/
example : Category (Type) := inferInstance

/-- The category of types has identity morphisms (the identity function). -/
example (A : Type) : A ⟶ A := 𝟙 A

/-- Composition in `Type` is function composition. -/
example (A B C : Type) (f : A ⟶ B) (g : B ⟶ C) : A ⟶ C := f ≫ g

end Examples
