/-
Copyright (c) 2024 Sina Hazratpour. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sina Hazratpour
-/
import Mathlib
import RequestProject.Fiber
import RequestProject.FibredCats.CartesianLift

set_option maxHeartbeats 1000000

/-!
# Vertical Lifts

We call a lift `v : x ⟶[𝟙 c] y` of the identity morphism a *vertical* lift/morphism. This file
relates such vertical lifts to the morphisms of the fiber categories and shows that vertical
cartesian morphisms are isomorphisms.

## Main definitions

* `Vert P` : the total category of vertical objects `⟨c, x⟩` of `P`, with vertical morphisms.
* `vertHomOfBasedLift`, `basedLiftOfVertHom` : the passage between vertical morphisms of `Vert P`
  and based-lifts of the identity.
* `equivFiberHomBasedLift`, `equivVertHomBasedLift` : the bijections between fiber/vertical homs
  and based-lifts of the identity.
* `isoVertBasedLiftEquiv` : the bijection between isomorphisms in a fiber and iso-based-lifts of
  the identity.
* `vertCartIso` : a vertical cartesian morphism is an isomorphism.

Question: Can we use extension types to define `VertHom` so that the proofs of
`vertHomOfBasedLift` and `basedLiftOfVertHom` are more concise/automated?

-/


namespace CategoryTheory

open Category Functor Fiber BasedLift

variable {C E : Type*} [Category C] [Category E]

/-- The total category of vertical objects of `P`: pairs `⟨c, x⟩` of a base object `c` and an
object `x` in the fiber `P⁻¹ c`. Morphisms are the morphisms of the disjoint union of the
fiber categories (i.e. the vertical morphisms). -/
abbrev Vert (P : E ⥤ C) := Σ c, P⁻¹ c

-- inductive VertHom {P : E ⥤ C} : (Vert P) → (Vert P) → Type max v u
--   | mk : ∀ {c : C} {X Y : P⁻¹ c}, (X ⟶ Y) → VertHom (⟨c, X⟩ : Vert P) (⟨c, Y⟩ : Vert P)

-- def VertHom {P : E ⥤ C} (x y : Vert P) := Σ (h : x.1 = y.1), x.2 ⟶[𝟙 x.1] (y.2.cast h.symm)

variable {P : E ⥤ C}

/-- The category structure on `Vert P`, inherited as the (sigma) coproduct of the fiber
categories. -/
instance instCategoryVert : Category (Vert P) := inferInstance

/-- A based-lift of the identity generates a morphism in `Vert P`. -/
def vertHomOfBasedLift {X Y : Vert P} (h : X.1 = Y.1)
(f : X.2 ⟶[𝟙 X.1] Y.2.cast h.symm) : (X ⟶ Y) := by
  obtain ⟨c, x⟩ := X
  obtain ⟨c', y⟩ := Y
  have H : c = c' := h
  subst H
  simp at f
  exact ⟨f.1, by aesop⟩

/-
NtS: shorter proof of above for mathlib
def vertHomOfBasedLift' {X Y : Vert P} {h : X.1 = Y.1}
(f : X.2 ⟶[𝟙 X.1] Y.2.cast h.symm) : (X ⟶ Y) := by
cases X; cases Y; simp at h; subst h; exact ⟨f.1, by aesop⟩
-/
/-- A vertical morphism keeps the base object fixed: its source and target lie over the same
base point. -/
@[simp]
lemma base_eq_of_vert_hom {X Y : Vert P} (f : X ⟶ Y) : X.1 = Y.1 := by
  rcases f with ⟨g⟩;
  rfl

/-- The underlying domain morphism of a vertical morphism `f : X ⟶ Y` in `Vert P`. -/
@[simp]
def basedLiftOfVertHomAux {X Y : Vert P} (f : X ⟶ Y) : X.2.1 ⟶ Y.2.1 := by
  rcases f with ⟨g⟩
  exact g.1

/-- The underlying morphism `basedLiftOfVertHomAux f` of a vertical morphism `f` lies over the
identity, expressed as the compatibility square with the relevant `eqToHom`s. -/
@[simp]
lemma basedLiftOfVertHomAux_over {X Y : Vert P} {f : X ⟶ Y} :
have : P.obj Y.2.1 = X.1 := by simp [Fiber.over']; symm; exact base_eq_of_vert_hom f
P.map (basedLiftOfVertHomAux f) ≫ eqToHom (this) = eqToHom (X.2.over') ≫ 𝟙 X.1 := by
  -- Split the vertically fibered hom `f : X ⟶ Y` into its base map and fiber hom using `rcases`.
  -- Unpack the fiber hom and simplify the goal by `simp`/`dsimp` (we won't need the base-isomorphism information).
  rcases f with ⟨g⟩
  dsimp;
  -- By definition of `basedLiftOfVertHomAux`, we have that `P.map (basedLiftOfVertHomAux f) = eqToHom (by rfl)`.
  simp

/-- The based-lift over the identity underlying a vertical morphism `f : X ⟶ Y` of `Vert P`. -/
def basedLiftOfVertHom {X Y : Vert P} (f : X ⟶ Y) :
have : X.1 = Y.1 := base_eq_of_vert_hom f
X.2 ⟶[𝟙 X.1] Y.2.cast this.symm := ⟨basedLiftOfVertHomAux f, by
  -- By definition of `basedLiftOfVertHomAux`, we have that `P.map (basedLiftOfVertHomAux f) = eqToHom (Fiber.over_eq X.2 Y.2)`.
  apply basedLiftOfVertHomAux_over⟩

--@[aesop forward safe]
/-- The based-lift over `𝟙 c` corresponding to a morphism `f : x ⟶ y` in the fiber `P⁻¹ c`. -/
@[simp]
def basedLiftOfFiberHom {c : C} {x y : P⁻¹ c} (f : x ⟶ y) : x ⟶[𝟙 c] y :=
⟨f.1, by simp⟩

/-- Coercing a based-lift `x ⟶[𝟙 c] y` of the identity morphism `𝟙 c`
to a morphism `x ⟶ y` in the fiber `P⁻¹ c`. -/
@[simps]
instance instCoeFiberHom {c : C} {x y : P⁻¹ c} : Coe (x ⟶[𝟙 c] y) (x ⟶ y) where
  coe := fun f ↦ ⟨ f.hom , by simp⟩

/-- The bijection between the hom-type of the fiber P⁻¹ c and the based-lifts of the identity morphism of c. -/
@[simps!]
def equivFiberHomBasedLift {c : C} {x y : P⁻¹ c} : (x ⟶ y) ≃ (x ⟶[𝟙 c] y) where
  toFun := fun g ↦ basedLiftOfFiberHom g
  invFun := fun g ↦ g
  left_inv := by intro g; simp [basedLiftOfFiberHom]
  right_inv := by intro g; rfl

/-- The bijection between vertical morphisms `⟨c, x⟩ ⟶ ⟨c, y⟩` in `Vert P` and based-lifts of the
identity morphism `𝟙 c`. -/
@[simps!]
def equivVertHomBasedLift {c : C} {x y : P⁻¹ c} : ((⟨c, x⟩ : Vert P) ⟶ ⟨c, y⟩) ≃ (x ⟶[𝟙 c] y) where
  toFun := fun g ↦ basedLiftOfVertHom g
  invFun := fun g ↦ vertHomOfBasedLift rfl g
  left_inv := by
    rintro ⟨ g ⟩ ; simp +decide at *
    congr! 1
  right_inv := by
    -- Since the basedLiftOfVertHom is just the hom of the based lift, and the based lift is already a hom, their homs are equal.
    apply Eq.refl

/-- The bijection between the isomorphisms in the fiber `P⁻¹ c` and the iso-based-lifts of the
identity morphism `𝟙 c`. -/
noncomputable
def isoVertBasedLiftEquiv {c : C} {x y : P⁻¹ c} : (x ≅ y) ≃ (x ⟶[≅(𝟙 c)] y) where
  toFun := fun g => ⟨⟨g.hom.1, by simp⟩, by
    obtain ⟨ g₁, g₂ ⟩ := g;
    refine' ⟨ ⟨ g₂.1, _, _ ⟩ ⟩;
    convert congr_arg Subtype.val ‹g₁ ≫ g₂ = 𝟙 x›;
    exact congr_arg Subtype.val ‹g₂ ≫ g₁ = 𝟙 y›⟩
  invFun := fun g => {
    hom := ⟨g.hom , by simp⟩
    inv := ⟨ (asIso g.hom).inv , by simp⟩
    hom_inv_id := by
      erw [ Subtype.ext_iff ];
      convert IsIso.hom_inv_id g.hom
    inv_hom_id := by
      erw [Subtype.ext_iff]
      convert IsIso.inv_hom_id g.hom
  }
  left_inv := by
    intro g; ext; simp +decide
  right_inv := by
    intro g;
    grind

/-- The underlying-morphism cancellation identity for `vertCartIso.hom_inv_id`.
The inverse `inv := gaplift b (𝟙 c) (id e' ≫[l] id e')` of the cartesian based-lift
`b := basedLiftOfFiberHom g` satisfies `g.1 ≫ inv.hom = 𝟙 e.1`. -/
lemma vertCart_hom_inv_hom {P : E ⥤ C} {c : C} {e e' : P⁻¹ c} (g : e ⟶ e')
    [Cartesian (basedLiftOfFiberHom g)] :
    g.1 ≫ (gaplift (basedLiftOfFiberHom g) (𝟙 c) (id e' ≫[l] id e')).hom = 𝟙 (e.1) := by
  have hb : (basedLiftOfFiberHom g).hom = g.1 := rfl
  set inv := gaplift (basedLiftOfFiberHom g) (𝟙 c) (id e' ≫[l] id e') with hinv
  have h1 : inv.hom ≫ g.1 = 𝟙 e'.1 := by
    have h := gaplift_hom_property (basedLiftOfFiberHom g) (𝟙 c) (id e' ≫[l] id e')
    rw [← hinv, hb] at h
    rw [h]
    simp
  let p : e ⟶[𝟙 c] e := (basedLiftOfFiberHom g ≫[l] inv).cast (by simp)
  have hp : p.hom = g.1 ≫ inv.hom := rfl
  have key : p ≫[l] (basedLiftOfFiberHom g) = BasedLift.id e ≫[l] (basedLiftOfFiberHom g) := by
    apply BasedLift.hom_ext
    simp only [BasedLift.comp_hom, hp, BasedLift.id_hom, hb, Category.assoc, h1,
      Category.comp_id, Category.id_comp]
  have huniq := gaplift_uniq' (basedLiftOfFiberHom g) p (BasedLift.id e) key
  have hhom := congrArg BasedLift.hom huniq
  simpa [hp, BasedLift.id_hom] using hhom

/-- Helper for `vertCartIso.hom_inv_id`. -/
lemma vertCartIso_hom_inv_id {P : E ⥤ C} {c : C} {e e' : P⁻¹ c} (g : e ⟶ e')
    [Cartesian (basedLiftOfFiberHom g)] :
    g ≫ (↑(gaplift (basedLiftOfFiberHom g) (𝟙 c) (id e' ≫[l] id e')) : e' ⟶ e) = 𝟙 e := by
  apply FiberCat.hom_ext
  simpa [FiberCat.id_coe] using vertCart_hom_inv_hom g

/-- A vertical cartesian morphism is an isomorphism: if the based-lift over `𝟙 c` induced by a
fiber morphism `g` is cartesian, then `g` is an isomorphism in the fiber. -/
@[simps!]
def vertCartIso {P : E ⥤ C} {c: C} {e e' : P⁻¹ c} (g : e ⟶ e')
[Cartesian (basedLiftOfFiberHom g)] : e ≅ e' where
  hom := g
  inv := gaplift (basedLiftOfFiberHom g) (𝟙 c) (id e' ≫[l] id e')
  inv_hom_id := by
    -- By definition of gaplift, we know that the composition of the gaplift and g is the identity.
    apply FiberCat.hom_ext;
    convert basedLiftOfFiberHom g |>.gaplift_hom_property ( 𝟙 c ) ( BasedLift.id e' ≫[l] BasedLift.id e' ) using 1;
    simp +decide [ BasedLift.comp ];
    rfl
  hom_inv_id := vertCartIso_hom_inv_id g

-- have H' := comp_hom'.mp H
    -- simp only [BasedLift.comp, BasedLift.id, comp_id] at H'
    -- simp only [comp_id, H']
    -- simp_all only [BasedLift.comp, BasedLift.id, comp_id, id_comp, FiberCat.fiber_id_obj]
    -- exact H'

end CategoryTheory