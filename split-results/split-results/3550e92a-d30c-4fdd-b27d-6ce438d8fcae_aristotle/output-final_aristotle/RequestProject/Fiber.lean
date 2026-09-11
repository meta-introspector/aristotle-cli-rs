/-
Copyright (c) 2023 Sina Hazratpour. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sina Hazratpour
-/
import Mathlib

/-!
# Fiber

This file defines the type `Fiber` of the fiber of a map `P : E → C` at a given point `c : C`,
together with its basic API, and -- when `P` is a functor -- the induced category structure on
each fiber.

This is a unification of two previously separate developments of the notion of "fiber":

* a `Fib`/`FibCat` development carrying the category-theoretic layer
  (the category structure on the fibers of a functor, the forgetful functor, the comparison
  with the comma category, and the description of the fibers of an opposite functor), and
* a `Fiber` development carrying a cleaner basic API
  (`cast`, `coe_cast`, `equivCompSigma`, …).

Both used the *same* underlying definition `{d : E // P d = c}`, so here they are merged into a
single `Fiber` type with a single, deduplicated API.

(Note: the witness lemma is named `over'` rather than `over`, since `over` is now a reserved
token in Lean/Mathlib.)

## Main definitions

* `Fiber P c` : the fiber `{d : E // P d = c}` of a map `P : E → C` at `c : C`.
* `Fiber.tauto e` : the tautological element of `Fiber P (P e)`.
* `Fiber.cast e h` : transport an element of `Fiber P c` to `Fiber P d` along `h : c = d`.
* `Fiber.equivCompSigma` : the fiber of a composite as a sigma type of fibers.
* `Fiber.Total P` : the total space of `P`.
* `FiberCat P c` (notation `P ⁻¹ c`) : the fiber of a functor `P`, as a category.
* `FiberCat.forget` : the forgetful functor from a fiber to the total category.
* `FiberCat.eqToHomFunctor` : the comparison functor to the comma category `Comma P (𝟭 C)`.
* `FiberCat.Op.equiv`, `FiberCat.Op.Iso` : comparison between the fibers of `P.op` and (the
  opposite of) the fibers of `P`.
-/

universe u

namespace CategoryTheory

open Category Opposite

/-- The fiber of a map `P : E → C` at a given point `c : C`. -/
@[simp]
def Fiber {C E : Type*} (P : E → C) (c : C) := {d : E // P d = c}

namespace Fiber

variable {C E : Type*} {P : E → C} {c d : C}

/-- Coercion from the fiber to the domain. -/
instance {c : C} : CoeOut (Fiber P c) E where
  coe := fun x => x.1

/-- The underlying domain element of `⟨e, h⟩ : Fiber P c` is `e` itself. -/
@[simp]
lemma coe_mk (e : E) (h : P e = c) : ((⟨e, h⟩ : Fiber P c) : E) = e := rfl

/-- Repackaging a fiber element from its components recovers the original element. -/
@[simp]
lemma mk_coe (x : Fiber P c) : ⟨x.1, x.2⟩ = x := rfl

/-- Two elements of the same fiber are equal iff their underlying domain elements are equal. -/
lemma coe_inj (x y : Fiber P c) : (x : E) = y ↔ x = y := Subtype.coe_inj

/-- The defining property of an element of the fiber: it lies over `c`. -/
@[simp]
lemma over' (x : Fiber P c) : P x = c := x.2

/-- Any two elements of the same fiber lie over the same base point. -/
@[simp]
lemma over_eq (x y : Fiber P c) : P x = P y := by simp [Fiber.over']

/-- A tautological construction of an element in the fiber of the image of a domain element. -/
@[simps]
def tauto (e : E) : Fiber P (P e) := ⟨e, rfl⟩

/-- Regarding an element of the domain as an element in the fibre of its image. -/
instance instTautoFib (e : E) : CoeDep (E) (e) (Fiber P (P e)) where
  coe := tauto e

/-- The underlying domain element of `tauto e` is `e` itself. -/
@[simp]
lemma tauto_over (e : E) : (tauto e : Fiber P (P e)).1 = e := rfl

/-- Cast an element of a fiber along an equality of the base objects. -/
@[simp]
def cast (e : Fiber P c) (h : c = d) : Fiber P d := ⟨e.1, by simp_all only [over']⟩

/-- Casting a fiber element along an equality of base points leaves its underlying
domain element unchanged. -/
theorem coe_cast (e : Fiber P c) (h : c = d) : (cast e h : E) = e.1 := rfl

/-- Casting the tautological element of the underlying domain element of `e` back along the
defining equality recovers `e`. -/
@[simp]
lemma cast_coe_tauto (e : Fiber P c) : cast (tauto e.1) (by simp [over']) = e := by
  cases e; simp

/-- The symmetric form of `cast_coe_tauto`: the tautological element of `e.1` equals `e`
cast along the defining equality. -/
@[simp]
lemma cast_coe_tauto' (e : Fiber P c) : (tauto e.1) = cast e (by simp [over']) := by
  cases e; rfl

/-- The fiber of a composite map `P ∘ Q` as a sigma type of fibers. -/
@[simps!]
def equivCompSigma {C E F : Type*} (P : E → C) (Q : F → E) (c : C) :
    (Fiber (P ∘ Q) c) ≃ (t : Fiber P c) × Fiber Q (t.1) where
  toFun := fun x => ⟨⟨Q x.1, x.2⟩, x.1⟩
  invFun := fun x => ⟨x.2, by dsimp; rw [x.2.over', x.1.over']⟩
  left_inv := by
    intro x
    simp_all only [Fiber, Function.comp_apply, tauto, Subtype.coe_eta]
  right_inv := by intro x; ext; simp [over']; rfl

/-- The total space of a map. -/
@[ext]
structure Total {C E : Type*} (P : E → C) where
  /-- The base object in `C` -/
  base : C
  /-- The object in the fiber of the base object. -/
  fiber : Fiber P base

end Fiber

/-- The fiber of a functor `P : E ⥤ C` at `c : C`, as a category. -/
abbrev FiberCat {C E : Type*} [Category C] [Category E] (P : E ⥤ C) (c : C) := Fiber P.obj c

notation:75 P " ⁻¹ " c => FiberCat P c

namespace FiberCat

variable {C E : Type*} [Category C] [Category E] {P : E ⥤ C}

/-- The category structure on the fiber of a functor. -/
@[simps]
instance instCategoryFiber {c : C} : Category (P ⁻¹ c) where
  Hom x y := { g : (x : E) ⟶ (y : E) // P.map g = eqToHom (Fiber.over_eq x y) }
  id x := ⟨𝟙 (x : E), by simp only [Functor.map_id, eqToHom_refl]⟩
  comp g h := ⟨g.1 ≫ h.1, by simp only [Functor.map_comp, Fiber.over', eqToHom_trans]⟩

/-- The underlying morphism of a fiber morphism maps, under `P`, to the canonical
`eqToHom` between the (equal) images of its endpoints. -/
@[simp, aesop forward safe]
lemma fiber_hom_over {c : C} (x y : P ⁻¹ c) (g : x ⟶ y) :
    P.map g.1 = eqToHom (Fiber.over_eq x y) := g.2

/-- The forgetful functor from a fiber to the total category. -/
@[simps]
def forget {c : C} : (P ⁻¹ c) ⥤ E where
  obj := fun x => x
  map := @fun x y f => f.1

/-- The underlying morphism of a composite in a fiber is the composite of the underlying
morphisms. -/
@[simp]
lemma fiber_comp_obj {c : C} (x y z : P ⁻¹ c) (f : x ⟶ y) (g : y ⟶ z) :
    (f ≫ g).1 = f.1 ≫ g.1 := rfl

/-- A composite of fiber morphisms equals a given morphism iff this holds for the underlying
morphisms. -/
@[simp]
lemma fiber_comp_obj_eq {c : C} {x y z : P ⁻¹ c} {f : x ⟶ y} {g : y ⟶ z} {h : x ⟶ z} :
    (f ≫ g = h) ↔ f.1 ≫ g.1 = h.1 := Subtype.ext_iff

/-- The underlying morphism of the identity in a fiber is the identity of the underlying
object. -/
@[simp]
lemma fiber_id_obj {c : C} (x : P ⁻¹ c) : (𝟙 x : x ⟶ x).val = 𝟙 (x : E) := rfl

/-- A morphism in a fiber is an isomorphism iff its underlying morphism in `E` is. -/
lemma is_iso {c : C} {x y : P ⁻¹ c} (f : x ⟶ y) : IsIso f ↔ IsIso f.1 := by
  constructor <;> intro hf;
  · obtain ⟨ g, hg ⟩ := hf;
    refine' ⟨ ⟨ g.val, _, _ ⟩ ⟩;
    · convert congr_arg Subtype.val hg.1 using 1;
    · exact congr_arg Subtype.val hg.2;
  · refine' ⟨ ⟨ ⟨ CategoryTheory.inv f.val, _ ⟩, _, _ ⟩ ⟩;
    all_goals simp_all +decide;
    · exact Subtype.ext ( IsIso.hom_inv_id _ );
    · exact Subtype.ext ( IsIso.inv_hom_id _ )

/-- The comparison functor from the total category of fibers to the comma category `Comma P (𝟭 C)`.
This is a unit of a KZ-monad whose algebras are cocartesian fibrations. -/
def eqToHomFunctor : (Σ c, P ⁻¹ c) ⥤ Comma P (𝟭 C) where
  obj := fun ⟨c, x⟩ => ⟨x, c, eqToHom (x.over')⟩
  map := @fun ⟨_, x⟩ ⟨_, y⟩ ⟨f⟩ => {
    left := f.1
    right := 𝟙 _
    w := by simp only [Functor.id_obj, fiber_hom_over, eqToHom_trans, Functor.id_map, comp_id]
  }
  map_id := by intro X; rfl
  map_comp := by aesop

/-- Two morphisms in a fiber `P ⁻¹ c` are equal if their underlying morphisms in `E` are equal. -/
lemma hom_ext {c : C} {x y : P ⁻¹ c} {f g : x ⟶ y} (h : f.1 = g.1) : f = g := Subtype.ext h

namespace Op

/-- An element of the fiber of `P.op` over `op c` lies, after `unop`, over `c`. -/
@[simp]
lemma obj_over (x : P.op ⁻¹ (op c)) : P.obj (unop (x.1)) = c := by
  cases' x with e h
  simpa [Functor.op] using h

/-- The fibres of the opposite functor `P.op` are isomorphic to the fibres of `P`. -/
@[simps]
def equiv (c : C) : (P.op ⁻¹ (op c)) ≅ (P ⁻¹ c) where
  hom := fun x => (⟨unop x.1, by rw [obj_over]⟩)
  inv := fun x => ⟨op x.1, by simp only [Functor.op_obj, Fiber.over']⟩

/-- Unapplying `P.op` to the underlying morphism of a fiber morphism of `P.op` recovers the
action of `P` on the unopped morphism. -/
@[simp]
lemma unop_op_map {c : C} {x y : (P.op) ⁻¹ (op c)} (f : x ⟶ y) :
    unop (P.op.map f.1) = P.map f.1.unop := by rfl

/-- The action of `P.op` on the opped underlying morphism of an opposite fiber morphism is the
op of the action of `P`. -/
@[simp]
lemma op_map_unop {c : C} {x y : (P ⁻¹ c)ᵒᵖ} (f : x ⟶ y) :
    P.op.map (f.unop.1.op) = (P.map (f.unop.1)).op := rfl

/-- The fiber category of the opposite functor `P.op` is isomorphic to the opposite of the fiber
category of `P`. -/
def Iso (P : E ⥤ C) (c : C) : Cat.of (P.op ⁻¹ (op c)) ≅ Cat.of ((P ⁻¹ c)ᵒᵖ) where
  hom := { toFunctor := {
    obj := fun x => op (⟨unop x.1, by rw [obj_over]⟩)
    map := @fun x y f => ⟨f.1.unop, by dsimp; rw [← (unop_op_map f), f.2]; apply eqToHom_unop⟩ } }
  inv := { toFunctor := {
    obj := fun x => ⟨op x.unop.1, by simp only [Functor.op_obj, Fiber.over']⟩
    map := @fun x y f => ⟨(f.unop.1).op, by dsimp; simp⟩ } }
  hom_inv_id := by apply Cat.Hom.ext; rfl
  inv_hom_id := by apply Cat.Hom.ext; rfl

end Op

end FiberCat

end CategoryTheory