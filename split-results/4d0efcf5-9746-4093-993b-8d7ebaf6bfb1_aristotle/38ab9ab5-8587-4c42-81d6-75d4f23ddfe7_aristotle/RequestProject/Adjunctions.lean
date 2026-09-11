/-
# Section 4: Adjunctions and Cartesian Closed Categories

This file formalizes adjunctions — the most powerful formulation of universality —
and Cartesian Closed Categories (CCCs), which provide the categorical foundation
for functional programming and the lambda calculus.
-/

import Mathlib

open CategoryTheory

/-! ## 4.1 Adjunctions

An adjunction `F ⊣ G` between functors `F : C ⥤ D` and `G : D ⥤ C` is a
natural bijection: `Hom_D(F(A), B) ≅ Hom_C(A, G(B))`.
-/

section Adjunctions

variable {C : Type*} [Category C] {D : Type*} [Category D]

/-- The hom-set bijection of an adjunction. -/
noncomputable def adjunction_hom_equiv (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G)
    (A : C) (B : D) :
    (F.obj A ⟶ B) ≃ (A ⟶ G.obj B) :=
  adj.homEquiv A B

/-- The unit of an adjunction: `η : Id_C ⟶ G ∘ F`. -/
def adjunction_unit (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G) :
    𝟭 C ⟶ F ⋙ G :=
  adj.unit

/-- The counit of an adjunction: `ε : F ∘ G ⟶ Id_D`. -/
def adjunction_counit (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G) :
    G ⋙ F ⟶ 𝟭 D :=
  adj.counit

/-- The triangle identity: `ε_{FA} ∘ F(η_A) = id_{FA}`. -/
theorem adjunction_left_triangle (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G)
    (A : C) :
    F.map (adj.unit.app A) ≫ adj.counit.app (F.obj A) = 𝟙 (F.obj A) :=
  adj.left_triangle_components A

end Adjunctions

/-! ## 4.2 Cartesian Closed Categories

A CCC has:
1. A terminal object (unit type)
2. Binary products (tuple types)
3. Exponential objects (function types `B^A` or `A ⟹ B`)

The exponential is right adjoint to the product: `(− × A) ⊣ (−)^A`.

We demonstrate the CCC structure on `Type` directly.
-/

section CCC

/-- In `Type`, the exponential object `A ⟹ B` is the function type `A → B`. -/
example (A B : Type) : (A → B) = (A → B) := rfl

/-- **Evaluation (Modus Ponens)**: `ev : (A ⟹ B) × A → B`.
    In `Type`, this is just function application. -/
def evaluation (A B : Type) : (A → B) × A → B :=
  fun ⟨f, a⟩ => f a

/-- **Currying (λ-abstraction)**: For `g : C × A → B`, we get `Λ(g) : C → (A → B)`.
    This is the categorical version of currying. -/
def currying (A B C : Type) (g : C × A → B) : C → (A → B) :=
  fun c a => g (c, a)

/-- **Uncurrying**: The inverse of currying. -/
def uncurrying (A B C : Type) (f : C → (A → B)) : C × A → B :=
  fun ⟨c, a⟩ => f c a

/-- Currying and uncurrying are inverses (one direction). -/
theorem curry_uncurry (A B C : Type) (g : C × A → B) :
    uncurrying A B C (currying A B C g) = g := by
  ext ⟨c, a⟩
  rfl

/-- Currying and uncurrying are inverses (other direction). -/
theorem uncurry_curry (A B C : Type) (f : C → (A → B)) :
    currying A B C (uncurrying A B C f) = f := by
  rfl

/-- The curry-uncurry bijection. -/
def curry_equiv (A B C : Type) : (C × A → B) ≃ (C → A → B) where
  toFun := currying A B C
  invFun := uncurrying A B C
  left_inv := fun g => by ext ⟨c, a⟩; rfl
  right_inv := fun f => rfl

end CCC
