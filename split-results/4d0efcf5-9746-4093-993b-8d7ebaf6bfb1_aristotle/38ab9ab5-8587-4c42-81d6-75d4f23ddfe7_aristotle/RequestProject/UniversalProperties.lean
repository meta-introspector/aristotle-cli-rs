/-
# Section 2: Universal Properties — Limits and Colimits

This file formalizes initial/terminal objects, products, coproducts, pullbacks,
and equalisers as universal constructions in category theory.
-/

import Mathlib

open CategoryTheory Limits

/-! ## 2.1 Initial and Terminal Objects

- An **initial object** `0` has a unique morphism `0 ⟶ A` for every `A`.
- A **terminal object** `1` has a unique morphism `A ⟶ 1` for every `A`.
-/

section InitialTerminal

variable {C : Type*} [Category C]

/-- The unique morphism from an initial object is unique. -/
theorem initial_morphism_unique [HasInitial C] (A : C) (f g : ⊥_ C ⟶ A) : f = g :=
  Limits.IsInitial.hom_ext initialIsInitial f g

/-- The unique morphism to a terminal object is unique. -/
theorem terminal_morphism_unique [HasTerminal C] (A : C) (f g : A ⟶ ⊤_ C) : f = g :=
  Limits.IsTerminal.hom_ext terminalIsTerminal f g

/-- In `Type`, the initial object is `Empty` (up to isomorphism). -/
noncomputable example : IsInitial (⊥_ (Type)) := initialIsInitial

/-- In `Type`, the terminal object is `PUnit` (up to isomorphism). -/
noncomputable example : IsTerminal (⊤_ (Type)) := terminalIsTerminal

end InitialTerminal

/-! ## 2.2 Products and Coproducts

Products are defined by projections and a universal pairing morphism.
Coproducts are defined by injections and a universal copairing morphism.
-/

section ProductsCoproducts

variable {C : Type*} [Category C]

/-- **Product commutativity (first projection)**:
    `π₁ ∘ ⟨f, g⟩ = f` -/
theorem prod_fst_comp_lift [HasBinaryProducts C] {X A B : C}
    (f : X ⟶ A) (g : X ⟶ B) :
    prod.lift f g ≫ prod.fst = f :=
  prod.lift_fst f g

/-- **Product commutativity (second projection)**:
    `π₂ ∘ ⟨f, g⟩ = g` -/
theorem prod_snd_comp_lift [HasBinaryProducts C] {X A B : C}
    (f : X ⟶ A) (g : X ⟶ B) :
    prod.lift f g ≫ prod.snd = g :=
  prod.lift_snd f g

/-- **Product uniqueness**: Any morphism agreeing with both projections equals the lift. -/
theorem prod_lift_unique [HasBinaryProducts C] {X A B : C}
    (f : X ⟶ A) (g : X ⟶ B) (h : X ⟶ A ⨯ B)
    (hf : h ≫ prod.fst = f) (hg : h ≫ prod.snd = g) :
    h = prod.lift f g :=
  prod.hom_ext (by rw [hf, prod.lift_fst]) (by rw [hg, prod.lift_snd])

/-- **Coproduct commutativity (left injection)**:
    `[f, g] ∘ ι₁ = f` -/
theorem coprod_inl_comp_desc [HasBinaryCoproducts C] {A B X : C}
    (f : A ⟶ X) (g : B ⟶ X) :
    coprod.inl ≫ coprod.desc f g = f :=
  coprod.inl_desc f g

/-- **Coproduct commutativity (right injection)**:
    `[f, g] ∘ ι₂ = g` -/
theorem coprod_inr_comp_desc [HasBinaryCoproducts C] {A B X : C}
    (f : A ⟶ X) (g : B ⟶ X) :
    coprod.inr ≫ coprod.desc f g = g :=
  coprod.inr_desc f g

/-- **Coproduct uniqueness**: Any morphism agreeing with both injections equals the desc. -/
theorem coprod_desc_unique [HasBinaryCoproducts C] {A B X : C}
    (f : A ⟶ X) (g : B ⟶ X) (h : A ⨿ B ⟶ X)
    (hf : coprod.inl ≫ h = f) (hg : coprod.inr ≫ h = g) :
    h = coprod.desc f g :=
  coprod.hom_ext (by rw [hf, coprod.inl_desc]) (by rw [hg, coprod.inr_desc])

end ProductsCoproducts

/-! ## 2.3 Pullbacks

A pullback of `f : A ⟶ C` and `g : B ⟶ C` is a limit of the cospan diagram,
providing `p : P ⟶ A` and `q : P ⟶ B` with `f ∘ p = g ∘ q`.
-/

section Pullbacks

variable {C : Type*} [Category C]

/-- The pullback condition: the two compositions into the target agree. -/
theorem pullback_condition [HasPullbacks C] {A B D : C} (f : A ⟶ D) (g : B ⟶ D) :
    pullback.fst f g ≫ f = pullback.snd f g ≫ g :=
  pullback.condition

end Pullbacks

/-! ## 2.4 Equalisers

An equaliser of `f, g : A ⟶ B` is an arrow `e : E ⟶ A` such that `f ∘ e = g ∘ e`,
universal among all such arrows.
-/

section Equalisers

variable {C : Type*} [Category C]

/-- The equaliser condition: `f ∘ ι = g ∘ ι`. -/
theorem equalizer_condition [HasEqualizers C] {A B : C} (f g : A ⟶ B) :
    equalizer.ι f g ≫ f = equalizer.ι f g ≫ g :=
  equalizer.condition f g

end Equalisers
