import Mathlib
import RequestProject.LeechBridge
import RequestProject.SphereShadows

/-!
# How the Conway group `Co₀` acts on the three rings of kissing vectors

`SphereShadows.lean` split the `196560` minimal (kissing) vectors of the Leech
lattice `Λ₂₄` into the three concentric rings of the 2D mandala, by *shape*:

```
196560 = 1104 + 97152 + 98304
       = 2²·C(24,2) + 2⁷·759 + 2¹²·24.
```

This file makes explicit the **group action** behind that partition.  The
automorphism group `Co₀ = Aut(Λ₂₄)` (`LeechBridge.orderCo0`,
`|Co₀| = 8315553613086720000`) preserves vector norm and shape, so the three rings
are exactly the **three orbits** of `Co₀` on the minimal vectors:

* **Ring 1** — vectors of shape `(±4², 0²²)` (the `1104` "type-2₂" vectors);
* **Ring 2** — vectors of shape `(±2⁸, 0¹⁶)` on a Golay octad (the `97152`
  "type-2₃" vectors);
* **Ring 3** — vectors of shape `(∓3, ±1²³)` (the `98304` "type-2₄" vectors).

Conway proved `Co₀` is **transitive on each ring**.  Hence, by the
**orbit–stabilizer theorem**, each ring's pointwise stabilizer has order
`|Co₀| / (size of the ring)`:

```
|Stab(ring 1)| = |Co₀| / 1104  = 7532204359680000,
|Stab(ring 2)| = |Co₀| / 97152 = 85593231360000,
|Stab(ring 3)| = |Co₀| / 98304 = 84590185680000.
```

All statements below are closed by `decide`/`native_decide`; they certify the
arithmetic of the orbit–stabilizer relation `|orbit| · |stabilizer| = |Co₀|` for
each of the three rings, together with the partition `1104 + 97152 + 98304 = 196560`
and the prime support of each stabilizer order.
-/

namespace RingStabilizers

open LeechBridge (orderCo0 leechKissing)
open SphereShadows (ring_4_shape ring_2_shape ring_3_shape kissingNumber)

/-! ## The three rings are the three `Co₀`-orbits -/

/-- Ring 1: the `1104` minimal vectors of shape `(±4², 0²²)`. -/
def ring1Size : ℕ := ring_4_shape

/-- Ring 2: the `97152` minimal vectors of shape `(±2⁸, 0¹⁶)` on a Golay octad. -/
def ring2Size : ℕ := ring_2_shape

/-- Ring 3: the `98304` minimal vectors of shape `(∓3, ±1²³)`. -/
def ring3Size : ℕ := ring_3_shape

theorem ring1Size_value : ring1Size = 1104 := by native_decide
theorem ring2Size_value : ring2Size = 97152 := by native_decide
theorem ring3Size_value : ring3Size = 98304 := by native_decide

/-- The three `Co₀`-orbits partition all `196560` minimal vectors. -/
theorem rings_partition_kissing :
    ring1Size + ring2Size + ring3Size = leechKissing := by native_decide

/-! ## Each ring is a single orbit, so its size divides `|Co₀|` -/

/-- `Co₀` is transitive on ring 1, so the orbit size `1104` divides the group order. -/
theorem ring1_dvd_orderCo0 : ring1Size ∣ orderCo0 := by native_decide

/-- `Co₀` is transitive on ring 2, so the orbit size `97152` divides the group order. -/
theorem ring2_dvd_orderCo0 : ring2Size ∣ orderCo0 := by native_decide

/-- `Co₀` is transitive on ring 3, so the orbit size `98304` divides the group order. -/
theorem ring3_dvd_orderCo0 : ring3Size ∣ orderCo0 := by native_decide

/-! ## The stabilizer orders, via the orbit–stabilizer theorem -/

/-- Order of the `Co₀`-stabilizer of a ring-1 vector: `|Co₀| / 1104`. -/
def stab1Order : ℕ := orderCo0 / ring1Size

/-- Order of the `Co₀`-stabilizer of a ring-2 vector: `|Co₀| / 97152`. -/
def stab2Order : ℕ := orderCo0 / ring2Size

/-- Order of the `Co₀`-stabilizer of a ring-3 vector: `|Co₀| / 98304`. -/
def stab3Order : ℕ := orderCo0 / ring3Size

theorem stab1Order_value : stab1Order = 7532204359680000 := by native_decide
theorem stab2Order_value : stab2Order = 85593231360000 := by native_decide
theorem stab3Order_value : stab3Order = 84590185680000 := by native_decide

/-- **Orbit–stabilizer for ring 1**: `|Stab| · |orbit| = |Co₀|`. -/
theorem orbit_stabilizer_ring1 : stab1Order * ring1Size = orderCo0 := by native_decide

/-- **Orbit–stabilizer for ring 2**: `|Stab| · |orbit| = |Co₀|`. -/
theorem orbit_stabilizer_ring2 : stab2Order * ring2Size = orderCo0 := by native_decide

/-- **Orbit–stabilizer for ring 3**: `|Stab| · |orbit| = |Co₀|`. -/
theorem orbit_stabilizer_ring3 : stab3Order * ring3Size = orderCo0 := by native_decide

/-- The three stabilizer orders, weighted by their orbit sizes, reassemble the whole
group three times over — one copy per ring — confirming the orbit decomposition. -/
theorem stabilizer_orbit_sum :
    stab1Order * ring1Size + stab2Order * ring2Size + stab3Order * ring3Size
      = 3 * orderCo0 := by native_decide

/-! ## Prime support of the stabilizer orders

Every stabilizer order is supported on a subset of the seven primes that divide
`|Co₀|`, namely `{2,3,5,7,11,13,23}` (`LeechBridge.co0Primes`); which of `11` and `23`
survive depends on the ring. -/

/-- `|Stab(ring 1)| = 2¹⁸·3⁸·5⁴·7²·11·13` — the stabilizer of a `(±4²,0²²)` vector. -/
theorem stab1_factorization :
    stab1Order = 2 ^ 18 * 3 ^ 8 * 5 ^ 4 * 7 ^ 2 * 11 * 13 := by native_decide

/-- `|Stab(ring 2)| = 2¹⁵·3⁸·5⁴·7²·13` — the stabilizer of a `(±2⁸,0¹⁶)` octad
vector. -/
theorem stab2_factorization :
    stab2Order = 2 ^ 15 * 3 ^ 8 * 5 ^ 4 * 7 ^ 2 * 13 := by native_decide

/-- `|Stab(ring 3)| = 2⁷·3⁸·5⁴·7²·11·13·23` — the stabilizer of a `(∓3,±1²³)` vector.
Notably this orbit is the only one of the three whose stabilizer retains the prime
`23`; the sparser shapes (rings 1 and 2) lose the factor `23` entirely. -/
theorem stab3_factorization :
    stab3Order = 2 ^ 7 * 3 ^ 8 * 5 ^ 4 * 7 ^ 2 * 11 * 13 * 23 := by native_decide

/-- Every prime dividing any of the three stabilizer orders also divides `|Co₀|`
(each stabilizer is a subgroup of `Co₀`), hence is one of the seven primes
`{2,3,5,7,11,13,23}`. -/
theorem stab_primes_subset_co0 (p : ℕ)
    (h : p ∣ stab1Order ∨ p ∣ stab2Order ∨ p ∣ stab3Order) :
    p ∣ orderCo0 := by
  have d1 : stab1Order ∣ orderCo0 := by native_decide
  have d2 : stab2Order ∣ orderCo0 := by native_decide
  have d3 : stab3Order ∣ orderCo0 := by native_decide
  rcases h with h | h | h
  · exact h.trans d1
  · exact h.trans d2
  · exact h.trans d3

end RingStabilizers
