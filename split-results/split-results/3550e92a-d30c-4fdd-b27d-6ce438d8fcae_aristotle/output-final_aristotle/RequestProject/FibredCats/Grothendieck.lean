/-
Copyright (c) 2024 Sina Hazratpour. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sina Hazratpour
-/
import Mathlib

import RequestProject.Fiber
import RequestProject.FibredCats.CartesianLift
import RequestProject.FibredCats.Total

set_option maxHeartbeats 1000000

/-!
# The Grothendieck-style total category recovers its functor

For a functor `P : E ⥤ C`, the total category `∫ P` (defined in
`RequestProject.FibredCats.Total`) assembles the fibers `P ⁻¹ c` into a single
category whose objects are pairs `(c, x)` with `x : P ⁻¹ c`.  This file develops
the basic comparison between `∫ P` and the original data of `P`, the
"Grothendieck" half of the fibration/indexed-category dictionary.

## Main definitions

* `TotalCat.proj P : ∫ P ⥤ C` : the projection of the total category onto the
  base, sending `(c, x)` to `c`.
* `TotalCat.toDom P : ∫ P ⥤ E` : the projection onto the domain, sending `(c, x)`
  to the underlying object `x.1 : E`.
* `TotalCat.ofDom P : E ⥤ ∫ P` : the canonical functor in the other direction,
  sending `e` to `(P.obj e, ⟨e, rfl⟩)`.

## Main results

* `TotalCat.toDom` is full, faithful and essentially surjective, hence an
  equivalence: `TotalCat.equivDom P : ∫ P ≌ E` exhibits the total category of `P`
  as canonically equivalent to the domain `E`.
* `TotalCat.projIso P : toDom P ⋙ P ≅ proj P` : under this identification, the
  base projection of the total category is the functor `P` itself, so `∫ P`
  together with `proj P` recovers `P` up to equivalence.
-/

namespace CategoryTheory

open Category Opposite Functor Limits Fiber

namespace TotalCat

variable {C E : Type*} [Category C] [Category E]

/-- The projection of the total category `∫ P` onto the base category `C`,
sending an object `(c, x)` to `c` and a morphism to its `base` component. -/
def proj (P : E ⥤ C) : (∫ P) ⥤ C where
  obj X := X.base
  map g := g.base
  map_id := by intro X; rfl
  map_comp := by intro X Y Z f g; rfl

@[simp] lemma proj_obj (P : E ⥤ C) (X : ∫ P) : (proj P).obj X = X.base := rfl
@[simp] lemma proj_map (P : E ⥤ C) {X Y : ∫ P} (g : X ⟶ Y) : (proj P).map g = g.base := rfl

/-- The projection of the total category `∫ P` onto the domain category `E`,
sending an object `(c, x)` to the underlying object `x.1 : E` and a morphism to
its `fiber` component. -/
def toDom (P : E ⥤ C) : (∫ P) ⥤ E where
  obj X := X.fiber.1
  map g := g.fiber
  map_id := by intro X; rfl
  map_comp := by intro X Y Z f g; rfl

@[simp] lemma toDom_obj (P : E ⥤ C) (X : ∫ P) : (toDom P).obj X = X.fiber.1 := rfl
@[simp] lemma toDom_map (P : E ⥤ C) {X Y : ∫ P} (g : X ⟶ Y) : (toDom P).map g = g.fiber := rfl

/-- The canonical functor from the domain `E` into the total category `∫ P`,
sending an object `e` to `(P.obj e, ⟨e, rfl⟩)` and a morphism `g` to the total
morphism with base `P.map g` and fiber `g`. -/
def ofDom (P : E ⥤ C) : E ⥤ (∫ P) where
  obj e := ⟨P.obj e, Fiber.tauto e⟩
  map {e e'} g := ⟨P.map g, g, by simp [Fiber.tauto]⟩
  map_id := by intro X; congr 1; exact P.map_id X
  map_comp := by intro X Y Z f g; congr 1; exact P.map_comp f g

@[simp] lemma ofDom_obj (P : E ⥤ C) (e : E) :
    (ofDom P).obj e = ⟨P.obj e, Fiber.tauto e⟩ := rfl

@[simp] lemma ofDom_map_fiber (P : E ⥤ C) {e e' : E} (g : e ⟶ e') :
    ((ofDom P).map g).fiber = g := rfl

@[simp] lemma ofDom_map_base (P : E ⥤ C) {e e' : E} (g : e ⟶ e') :
    ((ofDom P).map g).base = P.map g := rfl

/-- The domain projection `toDom P` is faithful: a morphism of the total category
is determined by its fiber component (the base component being forced by the
compatibility condition). -/
instance faithful_toDom (P : E ⥤ C) : (toDom P).Faithful where
  map_injective := by
    intro X Y f g h
    simp only [toDom_map] at h
    apply TotalCatHom.ext _ h
    have hf := f.eq
    have hg := g.eq
    rw [h] at hf
    have : eqToHom X.fiber.over' ≫ f.base = eqToHom X.fiber.over' ≫ g.base := by
      rw [← hf, ← hg]
    exact (cancel_epi _).mp this

/-- The domain projection `toDom P` is full: every morphism `h : x.1 ⟶ y.1` in `E`
between the underlying objects lifts to a morphism of the total category. -/
instance full_toDom (P : E ⥤ C) : (toDom P).Full where
  map_surjective := by
    intro X Y h
    refine ⟨⟨eqToHom X.fiber.over'.symm ≫ P.map h ≫ eqToHom Y.fiber.over', h, ?_⟩, rfl⟩
    simp

/-- The domain projection `toDom P` is essentially surjective: every object of `E`
arises (on the nose) as the underlying object of `ofDom P` applied to it. -/
instance essSurj_toDom (P : E ⥤ C) : (toDom P).EssSurj where
  mem_essImage e := ⟨(ofDom P).obj e, ⟨Iso.refl _⟩⟩

/-- Being full, faithful and essentially surjective, `toDom P` is an equivalence. -/
instance isEquivalence_toDom (P : E ⥤ C) : (toDom P).IsEquivalence where

/-- The total category `∫ P` of a functor `P : E ⥤ C` is canonically equivalent
to the domain `E`, via the domain projection `toDom P`. -/
noncomputable def equivDom (P : E ⥤ C) : (∫ P) ≌ E := (toDom P).asEquivalence

@[simp] lemma equivDom_functor (P : E ⥤ C) : (equivDom P).functor = toDom P := rfl

/-- Under the equivalence `∫ P ≌ E`, the base projection `proj P` of the total
category is identified with the functor `P`: there is a natural isomorphism
`toDom P ⋙ P ≅ proj P`.  Equivalently, `∫ P` together with `proj P` recovers `P`. -/
def projIso (P : E ⥤ C) : toDom P ⋙ P ≅ proj P :=
  NatIso.ofComponents
    (fun X => eqToIso X.fiber.over')
    (by intro X Y f; exact f.eq)

end TotalCat

end CategoryTheory
