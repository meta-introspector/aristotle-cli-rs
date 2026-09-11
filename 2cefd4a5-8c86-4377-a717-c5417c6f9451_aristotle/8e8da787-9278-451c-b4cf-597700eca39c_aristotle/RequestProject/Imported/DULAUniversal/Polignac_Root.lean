import Mathlib
import RequestProject.Imported.DULAUniversal.CharTwistedEta_Root
import RequestProject.Imported.DULAUniversal.DULAGradedMonoid_Root

/-!
# Polignac-Family Lane Theorems

This file extends `twin_prime_lane_crossing` from `DULAGradedMonoid.lean`
to the rest of the small Polignac family:

  - **Cousin primes** `(p, p+4)`: lane-crossing, opposite direction from twins
  - **Sexy primes** `(p, p+6)`: same-lane (the "same-lane" Polignac case)

Together with twin primes (gap 2), these are the three smallest Polignac
prime-constellation cases and exhaust the gap-mod-6 ∈ {2, 4} non-trivial
crossings plus the gap-mod-6 = 0 same-lane case.

## Lane table for prime gaps `g` mod 6, primes `p, p+g > 3`:

  | g mod 6 | lane(p) | lane(p+g) | chi(p)·chi(p+g) | name        |
  |---------|---------|-----------|-----------------|-------------|
  | 0       | same    | same      | +1              | sexy (g=6)  |
  | 2       | -1      | +1        | -1              | twin (g=2)  |
  | 4       | +1      | -1        | -1              | cousin (g=4)|

Other gaps mod 6 (1, 3, 5) are forbidden: they force one of `p` or `p+g`
to be divisible by 2 or 3, hence not prime when `p > 3`.

## Status

All theorems proved by the same residue-arithmetic + `omega` pattern that
worked for twin primes. No `sorry`. Numerical sanity checks live in
`sanity_check_polignac.py`.
-/

noncomputable section

open Nat

namespace DULAGradedMonoid

/-! ### Cousin primes (gap 4) -/

/-- **Cousin prime lane-crossing theorem.**
    For any cousin prime pair `(p, p+4)` with `p > 3`,
    `p ∈ lanePlus` and `p + 4 ∈ laneMinus`. -/
theorem cousin_prime_lane_crossing
    {p : ℕ} (hp : p.Prime) (hp' : (p + 4).Prime) (h3 : 3 < p) :
    p ∈ lanePlus ∧ (p + 4) ∈ laneMinus := by
  -- p prime and p > 3 ⇒ p%6 ∈ {1, 5}.
  rcases prime_mod_six_of_three_lt hp h3 with h1 | h5
  · -- Case p%6 = 1: then (p+4)%6 = 5, both prime, both in expected lanes. ✓
    refine ⟨?_, ?_⟩
    · exact (mem_lanePlus_iff p).mpr ⟨by omega, h1⟩
    · exact (mem_laneMinus_iff (p + 4)).mpr ⟨by omega, by omega⟩
  · -- Case p%6 = 5: then (p+4)%6 = 3, so 3 ∣ p+4. Since p+4 > 7 > 3 and prime,
    -- contradiction.
    exfalso
    have h3_dvd : (3 : ℕ) ∣ (p + 4) := by omega
    have h_eq : 3 = p + 4 := (hp'.eq_one_or_self_of_dvd 3 h3_dvd).resolve_left (by omega)
    omega

/-- **Cousin prime sign-determinacy**: `χ(p) · χ(p+4) = -1` for cousin primes
    with `p > 3`. -/
theorem chi_cousin_prime_sign
    {p : ℕ} (hp : p.Prime) (hp' : (p + 4).Prime) (h3 : 3 < p) :
    chi p * chi (p + 4) = -1 := by
  obtain ⟨hp_plus, hp4_minus⟩ := cousin_prime_lane_crossing hp hp' h3
  obtain ⟨_, hχp⟩ := hp_plus
  obtain ⟨_, hχp4⟩ := hp4_minus
  rw [hχp, hχp4]; ring

/-! ### Sexy primes (gap 6)

Both `p` and `p+6` live in the *same* lane (since adding 6 doesn't change
residue mod 6). So `χ(p)·χ(p+6) = +1` for any sexy prime pair `p > 3`. -/

/-- **Sexy prime same-lane theorem.**
    For any sexy prime pair `(p, p+6)` with `p > 3`, both `p` and `p+6`
    are in the *same* lane (`lanePlus` or `laneMinus`). -/
theorem sexy_prime_same_lane
    {p : ℕ} (hp : p.Prime) (hp' : (p + 6).Prime) (h3 : 3 < p) :
    (p ∈ lanePlus ∧ (p + 6) ∈ lanePlus)
      ∨ (p ∈ laneMinus ∧ (p + 6) ∈ laneMinus) := by
  rcases prime_mod_six_of_three_lt hp h3 with h1 | h5
  · -- p%6 = 1 ⇒ (p+6)%6 = 1, both in lanePlus.
    left
    refine ⟨?_, ?_⟩
    · exact (mem_lanePlus_iff p).mpr ⟨by omega, h1⟩
    · exact (mem_lanePlus_iff (p + 6)).mpr ⟨by omega, by omega⟩
  · -- p%6 = 5 ⇒ (p+6)%6 = 5, both in laneMinus.
    right
    refine ⟨?_, ?_⟩
    · exact (mem_laneMinus_iff p).mpr ⟨by omega, h5⟩
    · exact (mem_laneMinus_iff (p + 6)).mpr ⟨by omega, by omega⟩

/-- **Sexy prime sign-determinacy**: `χ(p) · χ(p+6) = +1` for sexy primes
    with `p > 3`. -/
theorem chi_sexy_prime_sign
    {p : ℕ} (hp : p.Prime) (hp' : (p + 6).Prime) (h3 : 3 < p) :
    chi p * chi (p + 6) = 1 := by
  rcases sexy_prime_same_lane hp hp' h3 with ⟨hp_plus, hp6_plus⟩ | ⟨hp_minus, hp6_minus⟩
  · obtain ⟨_, hχp⟩ := hp_plus
    obtain ⟨_, hχp6⟩ := hp6_plus
    rw [hχp, hχp6]; ring
  · obtain ⟨_, hχp⟩ := hp_minus
    obtain ⟨_, hχp6⟩ := hp6_minus
    rw [hχp, hχp6]; ring

/-! ### Unified Polignac sign-determinacy

The general pattern: for prime pairs `(p, p+2k)` with `p > 3`, the sign
`χ(p)·χ(p+2k)` is determined by `(2k) mod 6`.
This corollary just packages the three cases above. -/

/-- **Unified Polignac sign-determinacy** for gaps `g ∈ {2, 4, 6}`. -/
theorem chi_polignac_sign
    {p g : ℕ} (hp : p.Prime) (hp' : (p + g).Prime) (h3 : 3 < p)
    (hg : g = 2 ∨ g = 4 ∨ g = 6) :
    chi p * chi (p + g) = if g % 6 = 0 then 1 else -1 := by
  rcases hg with h | h | h
  · subst h
    simp only [show (2 : ℕ) % 6 = 2 from rfl, ↓reduceIte]
    -- Need to massage `2 % 6 = 2` (not 0) so `if` branch is `-1`
    exact chi_twin_prime_sign hp hp' h3
  · subst h
    simp only [show (4 : ℕ) % 6 = 4 from rfl, ↓reduceIte]
    exact chi_cousin_prime_sign hp hp' h3
  · subst h
    simp only [show (6 : ℕ) % 6 = 0 from rfl, ↓reduceIte]
    exact chi_sexy_prime_sign hp hp' h3

end DULAGradedMonoid

end
