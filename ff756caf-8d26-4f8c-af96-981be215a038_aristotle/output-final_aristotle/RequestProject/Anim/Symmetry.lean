import Mathlib

/-!
# Maximal-symmetry images: the divisor index and symmetry by construction

The semantics of `web/js/symmetry.js`, which is what the `symmetry` statement
of a playbook means: given one integer `N` (or a pair `N × M`), draw a single
image that exhibits every point-symmetry order that number-theoretically fits
inside `N`, together with a *digital index* — the counts that the image must
have — derived from `N` alone.

Two quite different things are proved here.

**The index is a theorem, not a convention.**  Ring count, element count,
palette size and the Mode-C core count are `d(N)`, `σ(N)`, `ω(N) + 1` and
`4·G(N) + d(N)²` where `G(N) = Σ_{a|N} Σ_{b|N} gcd(a,b)`; `modeA_elements`
says the wedges really do sum to `σ(N)`, and `index_60` / `index_12` are the
worked checks, evaluated rather than asserted.

*A correction to the specification as written.*  The specification's worked
check for `N = 12` gives `G(12) = 66`, hence a core count of `300` and a total
of `624`.  That is wrong: the sum of `gcd(a, b)` over all `36` ordered pairs of
divisors of `12` is `90`, so the core count is `4·90 + 36 = 396` and the total
is `720`.  `gcdSum_twelve` and `gcdSum_twelve_ne_spec` record both the correct
value and the fact that it is not the published one; the generator and its
Digital Index use the correct value, so "measured equals target" still holds.

**The symmetry is exact by construction, not by eye.**

* radial (Modes A and C): a ring is the orbit of one seed point under the
  `g`-th roots of unity.  `orbit_rotation_invariant` says that rotating the
  ring by `2π/g` maps it onto itself, `orbit_card` that it has exactly `g`
  points, and `orbit_conj_invariant` that adding the mirrored seed gives a set
  closed under reflection as well — the dihedral group `D_g`, not just `C_g`.
* grid (Mode B): content is drawn on a fundamental domain and copied out by
  the group.  `symmetrize_hflip`, `symmetrize_vflip` and `symmetrize_rot180`
  say the result is invariant under the Klein four-group of any `N × M`
  rectangle, and `symmetrizeSquare_transpose` adds the diagonal reflection —
  the eight elements of `D₄` — exactly when the rectangle is a square.
-/

namespace Hesper.Symmetry

/-! ## The derived index

Everything the specification calls a "derived parameter" is a function of `N`.
-/

/-- `k = d(N)`: how many divisors `N` has, and so how many rings Mode A draws. -/
def divisorCount (n : ℕ) : ℕ := n.divisors.card

/-- `σ(N)`: the sum of the divisors, and so how many wedges Mode A draws in total. -/
def divisorSum (n : ℕ) : ℕ := ∑ d ∈ n.divisors, d

/-- `ω(N)`: how many distinct primes divide `N`. -/
def primeCount (n : ℕ) : ℕ := n.primeFactors.card

/-- `P = ω(N) + 1`: one colour per prime factor, plus the base colour. -/
def paletteSize (n : ℕ) : ℕ := primeCount n + 1

/-- `G(N) = Σ_{a|N} Σ_{b|N} gcd(a, b)`, the quantity Mode C's core count is built from. -/
def gcdSum (n : ℕ) : ℕ := ∑ a ∈ n.divisors, ∑ b ∈ n.divisors, Nat.gcd a b

/-! ### Mode A — radial rings -/

/-- Mode A draws one ring per divisor. -/
def modeARings (n : ℕ) : ℕ := divisorCount n

/-- Ring `d` is `d` copies of one wedge, so the whole image is `σ(N)` wedges. -/
def modeAElements (n : ℕ) : ℕ := divisorSum n

/-- The element count really is the number of wedges drawn: ring `d` contributes `d`. -/
theorem modeA_elements (n : ℕ) :
    ∑ d ∈ n.divisors, d = modeAElements n := rfl

/-- Every ring is a genuine subgroup relationship: `C_d ⊆ C_N` exactly when `d ∣ N`. -/
theorem ring_iff_dvd {n d : ℕ} (hn : n ≠ 0) : d ∈ n.divisors ↔ d ∣ n := by
  simp [Nat.mem_divisors, hn]

theorem modeARings_pos {n : ℕ} (hn : n ≠ 0) : 0 < modeARings n := by
  unfold modeARings divisorCount
  refine Finset.card_pos.2 ⟨1, ?_⟩
  simp [Nat.mem_divisors, hn]

/-- A prime has exactly the two rings `1` and `p`. -/
theorem modeARings_prime {p : ℕ} (hp : p.Prime) : modeARings p = 2 := by
  rw [modeARings, divisorCount, Nat.Prime.divisors hp]
  exact Finset.card_pair hp.one_lt.ne

/-! ### Mode C — the divisor × divisor atlas -/

/-- The cell `(a, b)` of the core atlas shows the group of order `gcd a b`. -/
def cellOrder (a b : ℕ) : ℕ := Nat.gcd a b

/-- Dots, hollow dots, edges and axes, plus one label per cell. -/
def modeCCore (n : ℕ) : ℕ := 4 * gcdSum n + (divisorCount n) ^ 2

/-- The same with the Cayley-graph edges dropped. -/
def modeCCoreReduced (n : ℕ) : ℕ := 3 * gcdSum n + (divisorCount n) ^ 2

/-- Grid lines, the seven frieze cells, the seventeen wallpaper cells, the legend. -/
def modeCPeripheral (n : ℕ) : ℕ := 2 * (divisorCount n + 1) + 84 + 204 + 22

/-- The explosion guard: above fifty thousand core elements the edges are dropped. -/
def modeCReduced (n : ℕ) : Bool := decide (50000 < modeCCore n)

def modeCTotal (n : ℕ) : ℕ :=
  (if modeCReduced n then modeCCoreReduced n else modeCCore n) + modeCPeripheral n

theorem modeCCoreReduced_le (n : ℕ) : modeCCoreReduced n ≤ modeCCore n := by
  unfold modeCCore modeCCoreReduced
  have : 3 * gcdSum n ≤ 4 * gcdSum n := Nat.mul_le_mul_right _ (by norm_num)
  omega

/-- The guard fires exactly when the specification says it does. -/
theorem modeCReduced_iff (n : ℕ) : modeCReduced n = true ↔ 50000 < modeCCore n := by
  simp [modeCReduced]

/-- The atlas is a lattice picture: the cell of a pair of divisors is itself a divisor. -/
theorem cellOrder_mem_divisors {n a : ℕ} (b : ℕ) (ha : a ∈ n.divisors) :
    cellOrder a b ∈ n.divisors := by
  rw [Nat.mem_divisors] at ha ⊢
  exact ⟨dvd_trans (Nat.gcd_dvd_left a b) ha.1, ha.2⟩

/-- …and it really is the meet of the two: `C_{gcd a b} = C_a ∩ C_b`. -/
theorem cellOrder_dvd_iff (a b d : ℕ) : d ∣ cellOrder a b ↔ d ∣ a ∧ d ∣ b :=
  Nat.dvd_gcd_iff

/-- The core atlas is symmetric about its diagonal. -/
theorem cellOrder_comm (a b : ℕ) : cellOrder a b = cellOrder b a := Nat.gcd_comm a b

/-- The diagonal of the atlas is the divisor list itself. -/
theorem cellOrder_self (a : ℕ) : cellOrder a a = a := Nat.gcd_self a

/-! ### The worked checks

These are evaluated, not asserted: `decide` runs the definitions.
-/

/-- `N = 60 = 2²·3·5`: twelve rings, `σ = 168` wedges, a four-colour palette. -/
theorem primeFactors_60 : Nat.primeFactors 60 = {2, 3, 5} := by decide +kernel

theorem index_60 :
    divisorCount 60 = 12 ∧ divisorSum 60 = 168 ∧ primeCount 60 = 3 ∧ paletteSize 60 = 4 := by
  refine ⟨by decide, by decide, ?_, ?_⟩ <;>
    simp [primeCount, paletteSize, primeFactors_60]

/-- `N = 12`: six rings and `σ = 28`. -/
theorem index_12_rings : divisorCount 12 = 6 ∧ divisorSum 12 = 28 := by
  constructor <;> decide

/-- `G(12) = 90`, the sum of `gcd(a, b)` over all thirty-six ordered pairs of divisors. -/
theorem gcdSum_twelve : gcdSum 12 = 90 := by decide

/-- The specification's published value of `66` for `G(12)` is not that sum. -/
theorem gcdSum_twelve_ne_spec : gcdSum 12 ≠ 66 := by decide

/-- Hence Mode C at `N = 12` draws `396` core and `720` total elements, not `300` and `624`. -/
theorem modeC_12 : modeCCore 12 = 396 ∧ modeCPeripheral 12 = 324 ∧ modeCTotal 12 = 720 := by
  refine ⟨by decide, by decide, by decide⟩

/-! ## Radial symmetry, exact by construction

A ring of order `g` is the orbit of one seed point under the `g`-th roots of
unity.  Nothing is drawn outside the wedge, so the invariance below is a
property of the construction rather than of the artwork.
-/

open Complex in
/-- The primitive `g`-th root of unity the construction rotates by. -/
noncomputable def zeta (g : ℕ) : ℂ := Complex.exp (2 * Real.pi * Complex.I / g)

theorem zeta_pow_self {g : ℕ} (hg : g ≠ 0) : (zeta g) ^ g = 1 :=
  (Complex.isPrimitiveRoot_exp g hg).pow_eq_one

/-- The ring: the `C_g` orbit of the seed point `z`. -/
noncomputable def orbit (g : ℕ) (z : ℂ) : Finset ℂ :=
  (Finset.range g).image (fun i => (zeta g) ^ i * z)

/-- The ring has exactly `g` points — one wedge, replicated `g` times. -/
theorem orbit_card {g : ℕ} (hg : g ≠ 0) {z : ℂ} (hz : z ≠ 0) : (orbit g z).card = g := by
  rw [orbit, Finset.card_image_of_injOn, Finset.card_range]
  intro a ha b hb hab
  simp only [Finset.coe_range, Set.mem_Iio] at ha hb
  exact (Complex.isPrimitiveRoot_exp g hg).pow_inj ha hb (mul_right_cancel₀ hz hab)

/-- Rotating the ring by `2π/g` maps it onto itself: the symmetry is exact. -/
theorem orbit_rotation_invariant {g : ℕ} (hg : g ≠ 0) (z : ℂ) :
    (orbit g z).image (fun w => zeta g * w) = orbit g z := by
  have hz : (zeta g) ^ g = 1 := zeta_pow_self hg
  ext w
  simp only [Finset.mem_image, orbit, Finset.mem_range, exists_exists_and_eq_and]
  constructor
  · rintro ⟨i, hi, rfl⟩
    by_cases hlast : i + 1 = g
    · exact ⟨0, Nat.pos_of_ne_zero hg, by
        rw [← mul_assoc, ← pow_succ']
        simp [hlast, hz]⟩
    · exact ⟨i + 1, by omega, by rw [← mul_assoc, ← pow_succ']⟩
  · rintro ⟨i, hi, rfl⟩
    rcases Nat.eq_zero_or_pos i with rfl | hipos
    · refine ⟨g - 1, by omega, ?_⟩
      rw [← mul_assoc, ← pow_succ']
      have : g - 1 + 1 = g := by omega
      simp [this, hz]
    · exact ⟨i - 1, by omega, by
        rw [← mul_assoc, ← pow_succ']
        congr 2
        omega⟩

/-- The full ring of `D_g`: the seed and its mirror image, each spun round. -/
noncomputable def dihedralOrbit (g : ℕ) (z : ℂ) : Finset ℂ :=
  orbit g z ∪ (orbit g z).image (starRingEnd ℂ)

/-- The dihedral ring is closed under reflection in the real axis. -/
theorem dihedralOrbit_conj_invariant (g : ℕ) (z : ℂ) :
    (dihedralOrbit g z).image (starRingEnd ℂ) = dihedralOrbit g z := by
  unfold dihedralOrbit
  rw [Finset.image_union, Finset.image_image,
    show (starRingEnd ℂ) ∘ (starRingEnd ℂ) = id from by funext w; simp,
    Finset.image_id, Finset.union_comm]

/-! ## Grid symmetry, exact by construction

Mode B draws content only on a fundamental domain and copies it out.  `fold`
is the map onto the domain; `symmetrize` reads the content through it.
-/

/-- The mirror of `x` in a row of `n` cells. -/
def hflip (n x : ℕ) : ℕ := n - 1 - x

/-- The fundamental-domain coordinate of `x`: the smaller of `x` and its mirror. -/
def fold (n x : ℕ) : ℕ := min x (hflip n x)

theorem hflip_hflip {n x : ℕ} (hx : x < n) : hflip n (hflip n x) = x := by
  unfold hflip; omega

theorem fold_hflip {n x : ℕ} (hx : x < n) : fold n (hflip n x) = fold n x := by
  unfold fold
  rw [hflip_hflip hx]
  exact min_comm _ _

theorem fold_le {n x : ℕ} : fold n x ≤ x := min_le_left _ _

/-- Content on the quarter, read out over the whole rectangle. -/
def symmetrize {α : Type*} (N M : ℕ) (f : ℕ → ℕ → α) (x y : ℕ) : α :=
  f (fold N x) (fold M y)

variable {α : Type*}

/-- Invariance under the horizontal flip. -/
theorem symmetrize_hflip (N M : ℕ) (f : ℕ → ℕ → α) {x : ℕ} (hx : x < N) (y : ℕ) :
    symmetrize N M f (hflip N x) y = symmetrize N M f x y := by
  simp [symmetrize, fold_hflip hx]

/-- Invariance under the vertical flip. -/
theorem symmetrize_vflip (N M : ℕ) (f : ℕ → ℕ → α) (x : ℕ) {y : ℕ} (hy : y < M) :
    symmetrize N M f x (hflip M y) = symmetrize N M f x y := by
  simp [symmetrize, fold_hflip hy]

/-- …and hence under their composite, the half-turn: the Klein four-group `D₂`. -/
theorem symmetrize_rot180 (N M : ℕ) (f : ℕ → ℕ → α) {x y : ℕ} (hx : x < N) (hy : y < M) :
    symmetrize N M f (hflip N x) (hflip M y) = symmetrize N M f x y := by
  rw [symmetrize_hflip N M f hx, symmetrize_vflip N M f x hy]

/-- On a square, content is drawn on an eighth: the triangular wedge `x ≤ y`. -/
def symmetrizeSquare {α : Type*} (N : ℕ) (f : ℕ → ℕ → α) (x y : ℕ) : α :=
  f (min (fold N x) (fold N y)) (max (fold N x) (fold N y))

/-- The square construction is invariant under the diagonal reflection … -/
theorem symmetrizeSquare_transpose (N : ℕ) (f : ℕ → ℕ → α) (x y : ℕ) :
    symmetrizeSquare N f y x = symmetrizeSquare N f x y := by
  simp [symmetrizeSquare, min_comm, max_comm]

/-- … and under the horizontal flip, so with the transpose it carries all of `D₄`. -/
theorem symmetrizeSquare_hflip (N : ℕ) (f : ℕ → ℕ → α) {x : ℕ} (hx : x < N) (y : ℕ) :
    symmetrizeSquare N f (hflip N x) y = symmetrizeSquare N f x y := by
  simp [symmetrizeSquare, fold_hflip hx]

theorem symmetrizeSquare_vflip (N : ℕ) (f : ℕ → ℕ → α) (x : ℕ) {y : ℕ} (hy : y < N) :
    symmetrizeSquare N f x (hflip N y) = symmetrizeSquare N f x y := by
  simp [symmetrizeSquare, fold_hflip hy]

/-- A quarter turn of the square is the transpose after a flip, so it is covered too. -/
theorem symmetrizeSquare_rot90 (N : ℕ) (f : ℕ → ℕ → α) {x y : ℕ} (hy : y < N) :
    symmetrizeSquare N f (hflip N y) x = symmetrizeSquare N f x y := by
  rw [symmetrizeSquare_hflip N f hy, symmetrizeSquare_transpose]

/-! ## Mode B's index

The grid mode indexes on `g = gcd(N, M)`: the rectangle splits into
`(N/g) × (M/g)` blocks of `g × g`, and each block carries the Mode-A rings of `g`.
-/

def blockOrder (n m : ℕ) : ℕ := Nat.gcd n m

def modeBBlocks (n m : ℕ) : ℕ := (n / blockOrder n m) * (m / blockOrder n m)

def modeBElements (n m : ℕ) : ℕ := modeBBlocks n m * divisorSum (blockOrder n m)

/-- The blocks tile the rectangle exactly. -/
theorem modeB_blocks_tile {n m : ℕ} (hn : n ≠ 0) :
    modeBBlocks n m * (blockOrder n m * blockOrder n m) = n * m := by
  have hg : blockOrder n m ≠ 0 := Nat.gcd_ne_zero_left hn
  have hdn : blockOrder n m ∣ n := Nat.gcd_dvd_left n m
  have hdm : blockOrder n m ∣ m := Nat.gcd_dvd_right n m
  unfold modeBBlocks
  calc (n / blockOrder n m) * (m / blockOrder n m) * (blockOrder n m * blockOrder n m)
      = ((n / blockOrder n m) * blockOrder n m) * ((m / blockOrder n m) * blockOrder n m) := by
        ring
    _ = n * m := by rw [Nat.div_mul_cancel hdn, Nat.div_mul_cancel hdm]

/-- The point group of a rectangle: order eight for a square, four otherwise. -/
def rectangleGroupOrder (n m : ℕ) : ℕ := if n = m then 8 else 4

theorem rectangleGroupOrder_square (n : ℕ) : rectangleGroupOrder n n = 8 := by
  simp [rectangleGroupOrder]

theorem rectangleGroupOrder_oblong {n m : ℕ} (h : n ≠ m) : rectangleGroupOrder n m = 4 := by
  simp [rectangleGroupOrder, h]

end Hesper.Symmetry
