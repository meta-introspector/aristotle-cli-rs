/-
# ConformalSectionFunctor — sections of the scale tower as a functor with a limit

The module `RequestProject.Compute.CFTArrow` introduced `ConformalSection`: the
"multi-level presence of one object", a representative `rep s` at every scale `s`
whose conformal weight is the same at all scales.  This file completes the
roadmap item of **packaging that data categorically**: the scale tower is a
connected category (`RequestProject.Compute.ScaleCategory`), and the *global
sections* of the constant address presheaf over it are exactly the constant
conformal sections.

## What is built here

1. `confSectionFunctor : Scale ⥤ Type` — the constant address presheaf: every
   rung sees the address line `ℕ`, with identity restriction maps.

2. `Scale` **is connected** (`instConnectedScale`): any two rungs are joined by a
   conformal embedding, so the tower is a single connected diagram.

3. **The global-sections / limit statement.**  `globalSectionsIsLimit` shows the
   apex `ℕ` of the constant cone is a *limit* of `confSectionFunctor`: the global
   sections of the tower form a single copy of the address line.  Equivalently
   `globalSections ≃ ℕ`.

4. **Realization as conformal sections.**  `ConformalSection.IsConstant` singles
   out the sections coming from one global value, and
   `constSection_equivGlobalSections : {x : ConformalSection // x.IsConstant} ≃ ℕ`
   identifies them with the limit, so `constSection` is the comparison map turning
   a global section into a genuine multi-level presence.
-/

import Mathlib
import RequestProject.Compute.CFTArrow
import RequestProject.Compute.ScaleCategory

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ
open CategoryTheory CategoryTheory.Limits

/-! ## §1. The scale tower is connected -/

instance : Nonempty Scale := ⟨Scale.bit⟩

/-- Any two scales are joined by a (weight-preserving, identity-map) conformal
    embedding, so the tower is a connected category. -/
instance instConnectedScale : IsConnected Scale := by
  apply zigzag_isConnected
  intro a b
  exact Relation.ReflTransGen.single (Or.inl ⟨⟨_root_.id, fun _ => rfl⟩⟩)

/-! ## §2. The constant address presheaf and its limit -/

/-- The **constant address presheaf** on the scale tower: every rung sees the
    address line `ℕ`, with identity restriction maps. -/
def confSectionFunctor : Scale ⥤ Type := (Functor.const Scale).obj ℕ

/-- The global sections (= limit apex) of the scale tower form a single copy of
    the address line: the constant cone with apex `ℕ` is a limit. -/
noncomputable def globalSectionsIsLimit : IsLimit (Limits.constCone Scale ℕ) :=
  isLimitConstCone Scale ℕ

/-- `confSectionFunctor` has a limit, and that limit is the address line `ℕ`. -/
noncomputable def globalSectionsIso :
    limit confSectionFunctor ≅ ℕ :=
  haveI : HasLimit confSectionFunctor := ⟨⟨⟨_, globalSectionsIsLimit⟩⟩⟩
  IsLimit.conePointUniqueUpToIso (limit.isLimit confSectionFunctor) globalSectionsIsLimit

/-! ## §3. Realization as constant conformal sections -/

/-- A conformal section is **constant** (a genuine global section) when its
    representative is the same at every scale. -/
def ConformalSection.IsConstant (x : ConformalSection) : Prop :=
  ∀ s t, x.rep s = x.rep t

/-- Every `constSection n` is constant. -/
theorem constSection_isConstant (n : ℕ) : (constSection n).IsConstant :=
  fun _ _ => rfl

/-- The constant conformal sections are exactly the global sections: they biject
    with the limit apex `ℕ`.  The forward map reads off the (scale-independent)
    representative; the inverse is `constSection`. -/
def constSection_equivGlobalSections :
    {x : ConformalSection // x.IsConstant} ≃ ℕ where
  toFun x := x.1.rep Scale.bit
  invFun n := ⟨constSection n, constSection_isConstant n⟩
  left_inv := by
    rintro ⟨x, hx⟩
    apply Subtype.ext
    have : ∀ s, x.rep s = x.rep Scale.bit := fun s => hx s Scale.bit
    cases x with
    | mk rep conf =>
      simp only [constSection]
      congr 1
      funext s
      exact (this s).symm
  right_inv := by intro n; rfl

/-- Each global section `n` realizes a multi-level presence whose weight is
    `distFromJ n` at every scale — `constSection` is the comparison map from the
    limit to the conformal sections. -/
theorem globalSection_weight (n : ℕ) (s : Scale) :
    distFromJ ((constSection n).rep s) = distFromJ n := rfl

end RequestProject.Compute.CFT
