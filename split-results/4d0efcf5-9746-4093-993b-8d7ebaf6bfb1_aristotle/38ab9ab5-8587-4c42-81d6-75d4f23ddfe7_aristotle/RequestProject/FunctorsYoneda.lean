/-
# Section 3: Functoriality and Natural Transformations

This file formalizes functors, natural transformations, and the Yoneda Lemma.
The Yoneda Lemma is the cornerstone result: an object is determined by its
relationships to all other objects.
-/

import Mathlib

open CategoryTheory

/-! ## 3.1 Functors

A functor `F : C ⥤ D` maps objects and morphisms, preserving identity and composition.
-/

section Functors

variable {C : Type*} [Category C] {D : Type*} [Category D]

/-- Functors preserve identity morphisms. -/
theorem functor_map_id (F : C ⥤ D) (A : C) : F.map (𝟙 A) = 𝟙 (F.obj A) :=
  F.map_id A

/-- Functors preserve composition. -/
theorem functor_map_comp (F : C ⥤ D) {A B E : C} (f : A ⟶ B) (g : B ⟶ E) :
    F.map (f ≫ g) = F.map f ≫ F.map g :=
  F.map_comp f g

/-- Functors preserve isomorphisms. -/
theorem functor_preserves_iso (F : C ⥤ D) {A B : C} (i : A ≅ B) :
    IsIso (F.map i.hom) :=
  inferInstance

end Functors

/-! ## 3.2 Natural Transformations

A natural transformation `α : F ⟶ G` between functors `F G : C ⥤ D` is a family
of morphisms `α.app X : F.obj X ⟶ G.obj X` satisfying the naturality square:
`α.app Y ∘ F.map f = G.map f ∘ α.app X` for all `f : X ⟶ Y`.
-/

section NatTrans

variable {C : Type*} [Category C] {D : Type*} [Category D]

/-- The naturality condition for a natural transformation. -/
theorem naturality_condition (F G : C ⥤ D) (α : F ⟶ G) {X Y : C} (f : X ⟶ Y) :
    F.map f ≫ α.app Y = α.app X ≫ G.map f :=
  α.naturality f

/-- Natural isomorphisms are equivalences between functors. -/
noncomputable def nat_iso_symm (F G : C ⥤ D) (α : F ≅ G) : G ≅ F := α.symm

end NatTrans

/-! ## 3.3 The Yoneda Lemma

The Yoneda Lemma establishes a bijection:
  `Nat(Hom(A, −), F) ≅ F(A)`
for any functor `F : C ⥤ Type` and object `A : C`.

This is the deepest result in basic category theory: it says that an object
is completely determined by the morphisms into (or out of) it.
-/

section Yoneda

variable {C : Type*} [Category C]

/-- The Yoneda embedding `C ⥤ (Cᵒᵖ ⥤ Type)` is fully faithful.
    This means the Yoneda functor reflects all categorical structure. -/
noncomputable def yoneda_fully_faithful : (yoneda (C := C)).FullyFaithful :=
  Yoneda.fullyFaithful

/-- The Yoneda lemma: natural transformations from `yoneda.obj A` to `F`
    are in bijection with elements of `F.obj (Opposite.op A)`. -/
noncomputable def yoneda_equiv_apply
    (A : C) (F : Cᵒᵖ ⥤ Type v₁) :
    (yoneda.obj A ⟶ F) ≃ F.obj (Opposite.op A) :=
  yonedaEquiv

/-- The Yoneda embedding is injective on objects up to isomorphism:
    if `Hom(A, −) ≅ Hom(B, −)` then `A ≅ B`. -/
noncomputable def yoneda_obj_iso_iff {A B : C} :
    (yoneda.obj A ≅ yoneda.obj B) → (A ≅ B) := by
  intro h
  exact Yoneda.fullyFaithful.preimageIso h

end Yoneda

/-! ## 3.4 Contravariant Functors

Contravariant functors are modeled as functors from `Cᵒᵖ` to `D`.
The opposite category `Cᵒᵖ` reverses all arrows.
-/

section Contravariant

variable {C : Type*} [Category C] {D : Type*} [Category D]

/-- A contravariant functor is a functor from the opposite category. -/
def ContFunctor := Cᵒᵖ ⥤ D

/-- The opposite category reverses morphisms. -/
example {A B : C} (f : A ⟶ B) : (Opposite.op B ⟶ Opposite.op A) := f.op

end Contravariant
