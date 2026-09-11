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
# Fibrations, cloven fibrations and split fibrations

Building on the `Cartesian`/`CartLift` API developed in
`RequestProject.FibredCats.CartesianLift`, this file introduces the three
classical "fibredness" properties of a functor `P : E ⥤ C`.

## Main definitions

* `Fibration P` is the `Prop`-valued class asserting that `P` is a *fibration*:
  for every object `y` in the fiber over a base object `d` and every base
  morphism `f : c ⟶ d`, there exists a cartesian lift of `f` with target `y`
  (`HasCartLift f y`).

* `ClovenFibration P` is the data of a *cleavage*: an explicit choice
  `lift f y : CartLift f y` of a cartesian lift for every base morphism `f`
  and every object `y` in the fiber over its codomain.

* `SplitFibration P` is a `ClovenFibration` whose cleavage is *normal* and
  *closed under composition*: the chosen lift of an identity is the identity
  lift (`split_id`), and the chosen lift of a composite is the composite of the
  chosen lifts (`split_comp`).

We record the obvious implications: a cloven fibration is a fibration
(`ClovenFibration.toFibration`), and, using classical choice, every fibration
admits a (noncomputable) cleavage (`Fibration.clovenFibration`).
-/

namespace CategoryTheory

open Category Opposite Functor Limits BasedLift

variable {C E : Type*} [Category C] [Category E]

/-- A functor `P : E ⥤ C` is a *fibration* if every morphism in the base admits a
cartesian lift with any prescribed target in the fiber over its codomain. -/
class Fibration (P : E ⥤ C) : Prop where
  /-- For every base morphism `f : c ⟶ d` and every object `y` in the fiber over
  `d`, there merely exists a cartesian lift of `f` with target `y`. -/
  has_cart_lift : ∀ {c d : C} (f : c ⟶ d) (y : P⁻¹ d), HasCartLift (P := P) f y

/-- A *cloven fibration* is a functor equipped with a choice of cartesian lift
(a *cleavage*) for every base morphism and every target in the fiber over its
codomain. -/
class ClovenFibration (P : E ⥤ C) where
  /-- The cleavage: a chosen cartesian lift of `f` with target `y`. -/
  lift : ∀ {c d : C} (f : c ⟶ d) (y : P⁻¹ d), CartLift (P := P) f y

namespace ClovenFibration

variable {P : E ⥤ C} [ClovenFibration P]

/-- The chosen source of the cleavage lift of `f` with target `y`. -/
def liftSrc {c d : C} (f : c ⟶ d) (y : P⁻¹ d) : P⁻¹ c := (lift f y).src

/-- The chosen cartesian based-lift of `f` with target `y`. -/
def liftHom {c d : C} (f : c ⟶ d) (y : P⁻¹ d) :
    BasedLift P f (liftSrc f y) y := (lift f y).based_lift

/-- The chosen lift is cartesian. -/
instance liftCartesian {c d : C} (f : c ⟶ d) (y : P⁻¹ d) :
    BasedLift.Cartesian (liftHom f y) := (lift f y).is_cart

/-- A cloven fibration is in particular a fibration. -/
instance (priority := 100) toFibration (P : E ⥤ C) [ClovenFibration P] :
    Fibration P where
  has_cart_lift f y := ⟨lift f y⟩

end ClovenFibration

/-- A *split fibration* is a cloven fibration whose cleavage is normal (sends
identities to identity lifts) and closed under composition. -/
class SplitFibration (P : E ⥤ C) extends ClovenFibration P where
  /-- The chosen lift of an identity morphism is the identity lift. -/
  split_id : ∀ {c : C} (x : P⁻¹ c),
    (ClovenFibration.lift (𝟙 c) x).toLift = Lift.id x
  /-- The chosen lift of a composite is the composite of the chosen lifts. -/
  split_comp : ∀ {c d e : C} (f : c ⟶ d) (g : d ⟶ e) (z : P⁻¹ e),
    (ClovenFibration.lift (f ≫ g) z).toLift =
      ⟨(ClovenFibration.lift f (ClovenFibration.lift g z).src).src,
        (ClovenFibration.lift f (ClovenFibration.lift g z).src).based_lift ≫[l]
          (ClovenFibration.lift g z).based_lift⟩

namespace Fibration

open Classical in
/-- Using classical choice, every fibration admits a cleavage, i.e. can be
upgraded to a (noncomputable) cloven fibration. -/
noncomputable def clovenFibration (P : E ⥤ C) [Fibration P] : ClovenFibration P where
  lift f y := Classical.choice (Fibration.has_cart_lift f y)

end Fibration

end CategoryTheory
