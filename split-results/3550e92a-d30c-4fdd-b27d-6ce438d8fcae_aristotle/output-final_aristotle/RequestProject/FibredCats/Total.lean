/-
Copyright (c) 2024 Sina Hazratpour. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sina Hazratpour
-/
import Mathlib
import RequestProject.FibredCats.CartesianLift

/-!
# The total category of a functor

For a functor `P : E ⥤ C`, this file assembles the fibers `P ⁻¹ c` into a single
*total category* `∫ P` (the Grothendieck-style total space of `P`).

## Main definitions

* `TotalCat P` (notation `∫ P`) : the total space `Fiber.Total P.obj` of the functor `P`,
  whose objects are pairs of a base object `c : C` and an object in the fiber `P ⁻¹ c`.
* `TotalCatHom X Y` : a morphism in `∫ P`, consisting of a base morphism together with a
  fiber morphism lying over it (the compatibility being recorded by the `eq` field).
* `TotalCat.BasedLiftOf` : the based-lift underlying a morphism of `∫ P`.
* `TotalCat.instCatOfTotal` : the category structure on `∫ P`.
-/

namespace CategoryTheory
open Category Opposite Functor Limits Cones

variable {C E : Type*} [Category C] [Category E]

/-- The total category `∫ P` of a functor `P : E ⥤ C`: its objects are pairs of a base object
`c : C` together with an object of the fiber `P ⁻¹ c`. -/
abbrev TotalCat {C E : Type*} [Category C] [Category E] (P : E ⥤ C) := Fiber.Total P.obj

prefix:75 " ∫ "  => TotalCat

/-- A morphism in the total category `∫ P`: a morphism `base` in the base together with a
morphism `fiber` in `E` lying over it, compatibly with the witnesses that the endpoints lie in
their respective fibers. -/
@[ext]
structure TotalCatHom {P : E ⥤ C} (X Y : ∫ P) where
base : X.base ⟶ Y.base
fiber : X.fiber.1 ⟶ Y.fiber.1
eq : (P.map fiber) ≫ eqToHom (Y.fiber.over') = eqToHom (X.fiber.over') ≫ base

namespace TotalCat

/-- The based-lift underlying a morphism of the total category `∫ P`. -/
def BasedLiftOf {P : E ⥤ C} {X Y : ∫ P} (g : TotalCatHom X Y) : X.fiber ⟶[g.base] Y.fiber where
  hom := g.fiber
  over' := g.eq

@[simp]
lemma over_base {P : E ⥤ C} {X Y : ∫ P} (g : TotalCatHom X Y) : P.map g.fiber = eqToHom (X.fiber.over') ≫ g.base ≫ (eqToHom (Y.fiber.over').symm)  := by simp [← Category.assoc _ _ _, ← g.eq]


/-- The category structure on the total category `∫ P` of a functor `P`. -/
instance instCatOfTotal (P : E ⥤ C) : Category (∫ P) where
  Hom X Y := TotalCatHom X Y
  id X := ⟨𝟙 X.base, 𝟙 X.fiber.1, by simp⟩
  comp := @fun X Y Z f g => ⟨f.1 ≫ g.1, f.2  ≫ g.2, by
    rw [map_comp, assoc, over_base g, over_base f]
    slice_lhs 3 4 =>
      rw [eqToHom_trans, eqToHom_refl]
    simp
   ⟩
  id_comp := by intro X Y f; dsimp; congr 1 <;> simp
  comp_id := by intro X Y f; dsimp; congr 1 <;> simp
  assoc := by intro X Y Z W f g h; dsimp; congr 1 <;> simp

end TotalCat

end CategoryTheory



