/-
# ConformalSectionColimit — the colimit (inductive system) of the scale tower

`RequestProject.Compute.ConformalSectionFunctor` exhibits the *global sections*
of the constant address presheaf `confSectionFunctor` as the **limit** of the
scale tower, with apex the address line `ℕ`.  This file records the dual
construction asked for by the roadmap: the **colimit** (direct limit) of the same
tower.

Because the scale tower `Scale` is a *connected* category
(`instConnectedScale`), the constant presheaf has the address line `ℕ` as **both**
its limit and its colimit.  The colimit is the "inductive system resembling a CFT
state space": every rung injects its local states, and the colimit glues them
into one global state space, which here is again `ℕ`.

## What is built here

* `globalStatesIsColimit` — the constant cocone with apex `ℕ` is a colimit of
  `confSectionFunctor`.
* `globalStatesIso : colimit confSectionFunctor ≅ ℕ` — the colimit is the address
  line.
* `scaleTower_limit_iso_colimit : limit confSectionFunctor ≅ colimit
  confSectionFunctor` — for the connected scale tower the limit and colimit
  coincide (both are `ℕ`).
-/

import Mathlib
import RequestProject.Compute.CFTArrow
import RequestProject.Compute.ScaleCategory
import RequestProject.Compute.ConformalSectionFunctor

namespace RequestProject.Compute.CFT

open CategoryTheory CategoryTheory.Limits

/-- The **colimit** (inductive system) of the scale tower: the constant cocone
    with apex the address line `ℕ` is a colimit of `confSectionFunctor`.  This is
    the direct limit gluing every rung's local states into one global state
    space. -/
noncomputable def globalStatesIsColimit : IsColimit (Limits.constCocone Scale ℕ) :=
  isColimitConstCocone Scale ℕ

/-- `confSectionFunctor` has a colimit, and that colimit is the address line `ℕ`. -/
noncomputable def globalStatesIso :
    colimit confSectionFunctor ≅ ℕ :=
  haveI : HasColimit confSectionFunctor := ⟨⟨⟨_, globalStatesIsColimit⟩⟩⟩
  IsColimit.coconePointUniqueUpToIso (colimit.isColimit confSectionFunctor)
    globalStatesIsColimit

/-- For the connected scale tower the limit and the colimit of the constant
    address presheaf coincide: both are the address line `ℕ`. -/
noncomputable def scaleTower_limit_iso_colimit :
    limit confSectionFunctor ≅ colimit confSectionFunctor :=
  globalSectionsIso.trans globalStatesIso.symm

end RequestProject.Compute.CFT
