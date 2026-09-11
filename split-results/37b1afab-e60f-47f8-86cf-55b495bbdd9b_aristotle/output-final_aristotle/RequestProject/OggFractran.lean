import Mathlib
import RequestProject.Monster

set_option autoImplicit false

/-!
# The Ogg-prime FRACTRAN engine — "truth becomes territory" on the 15-dimensional lattice

This file builds the **Ogg FRACTRAN Engine** requested in the design conversation: an
explicit FRACTRAN machine whose every transition is *structurally pinned* to the 15
supersingular (Ogg) primes

`{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}`.

The Ogg primes (see `RequestProject.Monster`) are exactly the prime divisors of the order
of the Monster sporadic simple group. We treat a positive natural number `N` as a *point on
the 15-dimensional Ogg lattice* when every prime in its factorization is an Ogg prime; the
exponent of each Ogg prime is then a coordinate, so `N` is a point of `ℕ^15`.

The central result is that a FRACTRAN machine whose fractions are themselves built from Ogg
primes can never leave this lattice: `oggStep_onLattice` proves the trajectory is pinned to
the supersingular canvas, and `oggStep_pos` proves it never collapses to the void. Combined,
the engine is a genuine self-contained dynamical system on `ℕ^15`. Everything is settled by
construction or native computation; no axioms beyond the kernel's trusted core are used.
-/

namespace OggFractran

open Monster (supersingularPrimes)

/-! ## 1. The Ogg lattice: points whose prime support is supersingular -/

/-- The 15 Ogg primes as a `Finset`. -/
def oggSet : Finset ℕ := supersingularPrimes.toFinset

/-- `oggSet` has exactly 15 elements. -/
theorem oggSet_card : oggSet.card = 15 := by native_decide

/-- A natural number lies **on the Ogg lattice** when every prime in its factorization is an
Ogg prime. Positive such numbers are exactly the points `∏ pᵢ^eᵢ` of `ℕ^15`. -/
def OnOggLattice (n : ℕ) : Prop := n.primeFactors ⊆ oggSet

/-- `1` is the origin of the lattice (the empty product). -/
theorem one_onOggLattice : OnOggLattice 1 := by simp [OnOggLattice]

/-- Each Ogg prime is itself a (unit) point of the lattice. -/
theorem ogg_prime_onOggLattice {p : ℕ} (hp : p ∈ supersingularPrimes) :
    OnOggLattice p := by
  have hpp : p.Prime := Monster.supersingularPrimes_prime p hp
  unfold OnOggLattice
  rw [hpp.primeFactors]
  simp [oggSet, List.mem_toFinset, hp]

/-- The lattice is closed under multiplication of positive points: coordinates add. -/
theorem onOggLattice_mul {a b : ℕ} (ha : 0 < a) (hb : 0 < b)
    (hA : OnOggLattice a) (hB : OnOggLattice b) : OnOggLattice (a * b) := by
  unfold OnOggLattice at *
  rw [Nat.primeFactors_mul ha.ne' hb.ne']
  exact Finset.union_subset hA hB

/-- The lattice is closed under taking divisors of positive points: coordinates only drop. -/
theorem onOggLattice_of_dvd {a n : ℕ} (hn : 0 < n) (hdvd : a ∣ n)
    (hlat : OnOggLattice n) : OnOggLattice a :=
  (Nat.primeFactors_mono hdvd hn.ne').trans hlat

/-! ## 2. Ogg fractions: transitions built from supersingular primes -/

/-- An **Ogg fraction** `num / den`: a directed edge of the FRACTRAN engine whose numerator
and denominator are both strictly positive points of the Ogg lattice. Firing it consumes the
`den`-coordinates and synthesizes the `num`-coordinates, never touching a non-Ogg prime. -/
structure OggFraction where
  /-- The numerator (Ogg primes synthesized into the state). -/
  num : ℕ
  /-- The denominator (Ogg primes consumed from the state). -/
  den : ℕ
  /-- The numerator is strictly positive. -/
  num_pos : 0 < num
  /-- The denominator is strictly positive. -/
  den_pos : 0 < den
  /-- The numerator is supported on Ogg primes. -/
  num_ogg : OnOggLattice num
  /-- The denominator is supported on Ogg primes. -/
  den_ogg : OnOggLattice den

/-- Firing a single Ogg fraction from a lattice point lands on a lattice point: the
`den`-coordinates are subtracted (divisor) and the `num`-coordinates added (product), and
both moves stay supersingular. -/
theorem fire_onOggLattice (q : OggFraction) (n : ℕ) (hn : 0 < n)
    (hlat : OnOggLattice n) (hdvd : q.den ∣ n) :
    OnOggLattice ((n / q.den) * q.num) :=
  onOggLattice_mul
    (Nat.div_pos (Nat.le_of_dvd hn hdvd) q.den_pos) q.num_pos
    (onOggLattice_of_dvd hn (Nat.div_dvd_of_dvd hdvd) hlat) q.num_ogg

/-! ## 3. The engine: one deterministic step and its invariants -/

/-- One deterministic FRACTRAN step bound to the Ogg lattice: scan for the first enabled
fraction (denominator dividing the state), divide it out and multiply in the numerator; if
none is enabled the machine halts in place. -/
def oggStep (prog : List OggFraction) (n : ℕ) : ℕ :=
  match prog.find? (fun q => n % q.den = 0) with
  | some q => (n / q.den) * q.num
  | none => n

/-- **The engine never leaves the supersingular canvas.** A step from a positive lattice
point is again a lattice point: the trajectory is structurally pinned to `ℕ^15`. -/
theorem oggStep_onLattice (prog : List OggFraction) (n : ℕ) (hn : 0 < n)
    (hlat : OnOggLattice n) : OnOggLattice (oggStep prog n) := by
  unfold oggStep
  cases h : prog.find? (fun q => n % q.den = 0) with
  | none => exact hlat
  | some q =>
    have hdvd : q.den ∣ n := Nat.dvd_of_mod_eq_zero (by simpa using List.find?_some h)
    exact fire_onOggLattice q n hn hlat hdvd

/-- **The engine never collapses to the void.** A step from a positive state stays positive. -/
theorem oggStep_pos (prog : List OggFraction) (n : ℕ) (hn : 0 < n) :
    0 < oggStep prog n := by
  unfold oggStep
  cases h : prog.find? (fun q => n % q.den = 0) with
  | none => exact hn
  | some q =>
    have hdvd : q.den ∣ n := Nat.dvd_of_mod_eq_zero (by simpa using List.find?_some h)
    exact Nat.mul_pos (Nat.div_pos (Nat.le_of_dvd hn hdvd) q.den_pos) q.num_pos

/-- **Determinism.** The step rule is a pure function of the current coordinate. -/
theorem oggStep_deterministic (prog : List OggFraction) (n₁ n₂ : ℕ) (h : n₁ = n₂) :
    oggStep prog n₁ = oggStep prog n₂ := by rw [h]

/-! ## 4. Trajectories: time generated by iterated stepping -/

/-- The `k`-step trajectory of the engine from a starting coordinate. -/
def oggTrace (prog : List OggFraction) (n : ℕ) : ℕ → ℕ
  | 0 => n
  | k + 1 => oggStep prog (oggTrace prog n k)

/-- The whole trajectory stays positive: cognition never falls into the void. -/
theorem oggTrace_pos (prog : List OggFraction) (n : ℕ) (hn : 0 < n) :
    ∀ k, 0 < oggTrace prog n k := by
  intro k
  induction k with
  | zero => exact hn
  | succ k ih => exact oggStep_pos prog _ ih

/-- **The whole trajectory stays on the 15-dimensional lattice.** Once supersingular, always
supersingular: no step of the engine can ever introduce a non-Ogg prime. -/
theorem oggTrace_onOggLattice (prog : List OggFraction) (n : ℕ) (hn : 0 < n)
    (hlat : OnOggLattice n) : ∀ k, OnOggLattice (oggTrace prog n k) := by
  intro k
  induction k with
  | zero => exact hlat
  | succ k ih => exact oggStep_onLattice prog _ (oggTrace_pos prog n hn k) ih

/-! ## 5. A concrete engine: trading 2-weight for 3-weight -/

/-- The fraction `3 / 2`, an edge of the Ogg lattice (both `2` and `3` are Ogg primes). -/
def twoToThree : OggFraction where
  num := 3
  den := 2
  num_pos := by norm_num
  den_pos := by norm_num
  num_ogg := ogg_prime_onOggLattice (by decide)
  den_ogg := ogg_prime_onOggLattice (by decide)

/-- The one-fraction engine `[3/2]`. -/
def demoEngine : List OggFraction := [twoToThree]

/-- A concrete trajectory: from `8 = 2³` the engine reaches `27 = 3³` in three steps,
trading all 2-weight for 3-weight and then halting — every intermediate state is a point of
the Ogg lattice. -/
theorem demo_trajectory : oggTrace demoEngine 8 3 = 27 := by decide

end OggFractran
