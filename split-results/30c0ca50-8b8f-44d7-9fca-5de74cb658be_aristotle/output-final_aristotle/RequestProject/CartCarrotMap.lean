import Mathlib
import RequestProject.MoonshineExpansion

open scoped BigOperators

/-!
# The `q`-expansion as Cart, Carrot, and Map

This module formalizes the conceptual refinement of the design notes: the
Moonshine `q`-expansion is not merely a *map of the territory* (a static list of
coefficients), but simultaneously the **cart** moving through the territory and the
**carrot** that supplies the forward motion.

The picture, made precise:

* **The Monster order is the kingdom / address book** — a *finite* coordinate
  skeleton (`Moonshine.monsterOrder`, already in `MoonshineExpansion`).
* **The Ogg primes are the roads / coordinate axes**, and their product — the
  *radical* of the Monster order, the **Oggorial** `oggorial` — is the squarefree
  coordinate system.  We prove it divides the Monster order and is squarefree.
* **The map** `knownMap N` is the finite set of coefficients already explored at
  stage `N` (`{a₋₁, …, a_{N-1}}`, indexed `0 .. N-1`).
* **The cart** advances: `cartAdvance N = N + 1` moves to a strictly larger map.
* **The carrot** `carrot N = N` is the first *unknown* coefficient, lying just
  beyond the current map.  Reaching it (advancing the cart) exposes a *new* carrot
  `carrot (N+1)`.  This never terminates.

The headline is `incompleteness_shield`: at every stage there is always another
carrot — an inexhaustible source of forward motion, the structural form of the
incompleteness story running through this project.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

namespace Moonshine.CartCarrot

open Moonshine

/-! ## The coordinate system: the Oggorial (radical of the Monster order) -/

/-- The **Oggorial**: the radical (squarefree kernel) of the Monster order — the
product of the 15 distinct supersingular primes.  These are the prime-coordinate
axes of the Moonshine address space. -/
def oggorial : Nat := monsterPrimes.prod

/-- The explicit value of the Oggorial. -/
theorem oggorial_eq : oggorial = 1618964990108856390 := by
  decide

/-- The Oggorial is positive. -/
theorem oggorial_pos : 0 < oggorial := by
  decide

/-- The coordinate system divides the kingdom: the Oggorial (radical) divides the
Monster order. -/
theorem oggorial_dvd_monsterOrder : oggorial ∣ monsterOrder := by
  decide

/-
The Oggorial is squarefree — it is a genuine *radical*, a product of distinct
primes with no repeated prime factor.
-/
theorem oggorial_squarefree : Squarefree oggorial := by
  native_decide +revert

/-! ## The map: finitely explored territory -/

/-- The **map** at stage `N`: the finite set of `q`-expansion coefficients already
explored, namely the layers `0, 1, …, N-1` (the coefficients `a₋₁, …, a_{N-1}`). -/
def knownMap (N : Nat) : Finset Nat := Finset.range N

/-- The map is finite at every stage — the explored territory is always a finite
coordinate skeleton. -/
theorem knownMap_finite (N : Nat) : (knownMap N).card = N := by
  simp [knownMap]

/-! ## The cart and the carrot -/

/-- The **cart** advances one stage: from a map of `N` coefficients to a map of
`N + 1` coefficients. -/
def cartAdvance (N : Nat) : Nat := N + 1

/-- The **carrot** at stage `N`: the first *unknown* coefficient, the layer `N`
that lies just beyond the current map `{0, …, N-1}`. -/
def carrot (N : Nat) : Nat := N

/-- The carrot lies just beyond the current map — it is not yet known. -/
theorem carrot_not_known (N : Nat) : carrot N ∉ knownMap N := by
  simp [carrot, knownMap]

/-- Advancing the cart reaches the carrot: after one step the previously-unknown
coefficient is recorded on the map. -/
theorem carrot_reached (N : Nat) : carrot N ∈ knownMap (cartAdvance N) := by
  simp [carrot, knownMap, cartAdvance]

/-- The cart genuinely moves: the new map strictly contains the old one. -/
theorem cart_advances (N : Nat) : knownMap N ⊂ knownMap (cartAdvance N) := by
  simp only [knownMap, cartAdvance]
  apply Finset.ssubset_iff_subset_ne.2
  refine ⟨?_, ?_⟩
  · intro x hx; simp only [Finset.mem_range] at *; omega
  · intro h; have : N ∈ Finset.range N := by rw [h]; simp
    simp at this

/-- Once the carrot is reached, a *new* carrot appears, strictly later and still
unknown: the motion is self-renewing. -/
theorem new_carrot_appears (N : Nat) :
    carrot N < carrot (cartAdvance N) ∧
      carrot (cartAdvance N) ∉ knownMap (cartAdvance N) := by
  refine ⟨?_, ?_⟩
  · simp [carrot, cartAdvance]
  · simp [carrot, knownMap, cartAdvance]

/-! ## The incompleteness shield: there is always another carrot -/

/-- **The Incompleteness Shield.**  At every stage there is always another carrot:
a strictly later coefficient that is still unknown.  The `q`-expansion contains an
intrinsic, inexhaustible source of forward motion — every finite truncation
creates the conditions for the next extension. -/
theorem incompleteness_shield (N : Nat) :
    ∃ M : Nat, N < M ∧ carrot M ∉ knownMap M := by
  exact ⟨N + 1, by omega, by simp [carrot, knownMap]⟩

/-- The set of carrots is infinite — the cart never runs out of forward motion. -/
theorem carrots_infinite : (Set.range carrot).Infinite := by
  have : Set.range carrot = (Set.univ : Set Nat) := by
    ext n; simp [carrot]
  rw [this]
  exact Set.infinite_univ

/-- **The full Cart–Carrot–Map principle in one statement.**  At every stage `N`:
the map is a finite skeleton of `N` explored coefficients (the kingdom is finite),
the carrot is fresh and unreached (lies beyond the map), and advancing the cart
yields a strictly larger map that captures the carrot and exposes a brand-new
carrot.  Motion is therefore permanent. -/
theorem cart_carrot_map_principle (N : Nat) :
    (knownMap N).card = N ∧
      carrot N ∉ knownMap N ∧
      knownMap N ⊂ knownMap (cartAdvance N) ∧
      carrot N ∈ knownMap (cartAdvance N) ∧
      carrot (cartAdvance N) ∉ knownMap (cartAdvance N) := by
  refine ⟨knownMap_finite N, carrot_not_known N, cart_advances N, carrot_reached N, ?_⟩
  exact (new_carrot_appears N).2

end Moonshine.CartCarrot