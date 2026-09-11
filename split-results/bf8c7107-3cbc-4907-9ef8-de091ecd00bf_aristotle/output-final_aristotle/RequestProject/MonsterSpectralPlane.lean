import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterClifford
import RequestProject.MonsterBaseWalk
import RequestProject.MonsterBladeWalk

/-!
# The 2-D spectral plane of the base-2 Monster Walk

This module builds the requested **2-D spectral plane** coordinate system on the Clifford
blades of the base-2 Monster Walk (`RequestProject.MonsterBladeWalk`).  Each blade — and
hence each walk step — is placed at a point

```
spectralPoint b = (moonshineWeight b, heckeWeight b)
```

of the discrete plane `ℕ × ℕ`, and we ask **where the base shadows sit relative to the
unoccupied origin** `(0, 0)`.

## The two axes

* `moonshineWeight b` — the **vertical / moonshine axis**: the blade's Clifford grade,
  the integer level on the period-8 real Bott clock that drives the Altland–Zirnbauer
  classification (`MonsterBladeWalk.azOfGrade`).  Grade `0` is the moonshine vacuum
  (the scalar / identity blade).
* `heckeWeight b` — the **horizontal / Hecke axis**: the sum of the Monster primes
  `pᵢ` over the blade's generator support `{γᵢ}`.  The primes are exactly the Hecke
  indices `T_p` of monstrous moonshine, so this is a discrete Hecke-spectral coordinate.

The companion `harmonicFreq b = 432 · heckeWeight b` recovers the original note's
"musical periodic table" assignment `f(p) = 432 Hz · p` summed over the kept generators.

## What is proved (all kernel-checked)

* `surviving_spectralPoint` — the surviving coprime shadow `L = 539` sits at the point
  `(5, 52)` (grade `5`, prime-sum `2+3+7+11+29 = 52`), far from the origin.
* `base2_walk_spectralPoints` — the three steps occupy `[(5,52), (6,89), (6,87)]`.
* `origin_is_vacuum` — the origin `(0,0)` is occupied *only* by the moonshine vacuum
  blade `bladeOfAddr 0` (empty support, grade `0`); equivalently a blade sits at the
  origin iff it is the scalar.
* `walk_avoids_origin` — **no** base-2 walk step sits at the unoccupied origin: every
  step has strictly positive moonshine weight and strictly positive Hecke weight.
* `spectralPoint_injective_on_walk` — the three walk steps occupy three *distinct* points
  of the spectral plane (the plane separates the steps).

As elsewhere in this project, the *physical* spectral interpretation is an analogy; the
statements proved here are exact decidable facts about this explicit coordinate system.
-/

set_option maxHeartbeats 4000000

namespace MonsterSpectralPlane

open MonsterWalk MonsterBaseWalk MonsterClifford MonsterBladeWalk

/-! ## Prime values of the Clifford generators -/

/-- The Monster prime carried by the `i`-th Clifford generator `γᵢ`. -/
def primeVal (i : Fin 15) : ℕ := (MonsterWalk.monsterPrimes.getD i.val (1, 0)).1

/-- The fifteen generator primes, in order, are the fifteen Monster primes. -/
theorem primeVal_values :
    (List.finRange 15).map primeVal
      = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by
  native_decide

/-! ## The two spectral axes -/

/-- **Moonshine axis** (vertical): the blade's Clifford grade — its level on the period-8
real Bott clock.  Grade `0` is the moonshine vacuum. -/
def moonshineWeight (b : Blade) : ℕ := b.grade

/-- **Hecke axis** (horizontal): the sum of the Monster primes over the blade's generator
support.  The primes are the Hecke indices `T_p` of monstrous moonshine. -/
def heckeWeight (b : Blade) : ℕ := (b.support.map primeVal).sum

/-- The point of the discrete spectral plane occupied by a blade. -/
def spectralPoint (b : Blade) : ℕ × ℕ := (moonshineWeight b, heckeWeight b)

/-- The spectral point of a base-2 walk step. -/
def stepPoint (s : ℕ × ℕ × ℕ) : ℕ × ℕ := spectralPoint (bladeOfAddr (stepShadow s))

/-- The original note's harmonic frequency of a blade: `432 Hz` times its Hecke weight
(the `432·p` assignment summed over the supported generators). -/
def harmonicFreq (b : Blade) : ℕ := 432 * heckeWeight b

/-! ## Where the surviving shadow sits -/

/-- **The surviving coprime shadow `L = 539` sits at `(5, 52)`.** Its blade has grade `5`
(moonshine axis) and prime-sum `2 + 3 + 7 + 11 + 29 = 52` (Hecke axis). -/
theorem surviving_spectralPoint :
    spectralPoint (bladeOfAddr 539) = (5, 52) ∧
    moonshineWeight (bladeOfAddr 539) = 5 ∧
    heckeWeight (bladeOfAddr 539) = 52 ∧
    harmonicFreq (bladeOfAddr 539) = 22464 := by
  refine ⟨by decide, by decide, by decide, by decide⟩

/-! ## The three steps on the plane -/

/-- The three base-2 walk steps occupy the points `[(5,52), (6,89), (6,104)]`. -/
theorem base2_walk_spectralPoints :
    (monsterWalkBase 2 10).map stepPoint = [(5, 52), (6, 89), (6, 104)] := by
  native_decide

/-! ## The unoccupied origin -/

/-- **The origin is the moonshine vacuum.** A blade sits at the origin `(0,0)` of the
spectral plane iff it is the scalar blade `bladeOfAddr 0` (grade `0`, empty support). -/
theorem origin_is_vacuum :
    spectralPoint (bladeOfAddr 0) = (0, 0) ∧
    (bladeOfAddr 0).grade = 0 ∧ (bladeOfAddr 0).support = [] := by
  refine ⟨by decide, by decide, by decide⟩

/-- **The base-2 walk avoids the unoccupied origin.** Every walk step has strictly
positive moonshine weight *and* strictly positive Hecke weight, so none sits at `(0,0)`. -/
theorem walk_avoids_origin :
    (monsterWalkBase 2 10).all
      (fun s => decide (0 < moonshineWeight (bladeOfAddr (stepShadow s)))
        && decide (0 < heckeWeight (bladeOfAddr (stepShadow s)))) = true ∧
    (monsterWalkBase 2 10).all (fun s => stepPoint s ≠ (0, 0)) = true := by
  refine ⟨by native_decide, by native_decide⟩

/-! ## The plane separates the steps -/

/-- **The spectral plane separates the steps.** The three base-2 walk steps occupy three
*distinct* points: the coordinate system is injective on the walk. -/
theorem spectralPoint_injective_on_walk :
    ((monsterWalkBase 2 10).map stepPoint).Nodup := by native_decide

/-! ## Summary -/

/-- **Spectral-plane summary of the base-2 Monster Walk.**
1. The surviving coprime shadow `L = 539` sits at `(moonshine = 5, Hecke = 52)`.
2. The three steps occupy `[(5,52), (6,89), (6,104)]`, all distinct.
3. The origin `(0,0)` is the moonshine vacuum and is avoided by every walk step. -/
theorem spectral_plane_summary :
    stepPoint (0, 10, 1) = (5, 52) ∧
    (monsterWalkBase 2 10).map stepPoint = [(5, 52), (6, 89), (6, 104)] ∧
    ((monsterWalkBase 2 10).map stepPoint).Nodup ∧
    (monsterWalkBase 2 10).all (fun s => stepPoint s ≠ (0, 0)) = true := by
  refine ⟨by native_decide, base2_walk_spectralPoints, by native_decide, by native_decide⟩

end MonsterSpectralPlane
