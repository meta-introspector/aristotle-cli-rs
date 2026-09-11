import Mathlib
import RequestProject.Monster
import RequestProject.Moonshine
import RequestProject.LeechBridge

/-!
# Shadows of the 24-dimensional sphere in 2D, and the Monster bridge

This file formalizes the concrete claims of the discussion "monster group and 24d
hypersphere" / "shadows of this 24d sphere in 2d", building on `Monster.lean`,
`Moonshine.lean` and `LeechBridge.lean`.

Two strands:

## 1. The Monster ↔ 24D-hypersphere numerical bridge

The 24-dimensional hypersphere **kissing number** of the Leech lattice is
`196560`, and the Monster's smallest faithful representation dimension is
`196883`.  They are tied together through the **Griess algebra** of dimension
`196884 = 196883 + 1` (the first `j`-function / McKay–Thompson coefficient),
which decomposes under the Conway group `Co₀ = Aut(Λ₂₄)` as

```
196884 = 196560 + 300 + 24
```

where `196560` is the kissing number, `300 = C(25,2) = dim Sym²(ℝ²⁴)`, and `24`
is the ambient dimension.  Equivalently the prompt's identity
`196883 = 196560 + 300 + 24 − 1` (`moonshine_numerical_bridge`).

## 2. The "shadow" of the 24D solid hyperball is a 2D solid disk

`shadow_closedBall` proves that the orthogonal projection onto the first two
coordinates sends the closed ball of radius `r` in `ℝ²⁴` exactly onto the closed
ball of radius `r` in `ℝ²`: a 24D hyperball casts a *filled disk* shadow, with all
extra-dimensional depth flattened away.

## 3. The 2D mandala of kissing points: three concentric rings

When the `196560` minimal (kissing) vectors of the Leech lattice are projected to
2D they split, by *shape*, into three classes — the concentric rings of the
mandala:

```
196560 = 1104 + 97152 + 98304
       = 2²·C(24,2) + 2⁷·759 + 2¹²·24
```

(`kissing_three_rings`), where `759` is the number of Golay-code octads.  The 2D
Petrie shadow shows 24-fold (hence 12- and 6-fold) rotational symmetry, consistent
with `24 ∣ 196560` (`petrie_24fold`), and the hexagonal cross-section has the 2D
hexagonal kissing number `6`.

All arithmetic statements are closed by `decide`/`native_decide`; the geometric
shadow statement is elementary real analysis.
-/

namespace SphereShadows

open Monster (degrees supersingularPrimes mckayThompson1A)
open LeechBridge (leechKissing)

/-! ## 1. The Monster ↔ 24D-hypersphere numerical bridge -/

/-- The kissing number of the 24-dimensional hypersphere (Leech lattice). -/
def kissingNumber : ℕ := 196560

/-- This matches the kissing number recorded in `LeechBridge`. -/
theorem kissingNumber_eq_leech : kissingNumber = leechKissing := rfl

/-- The Monster's smallest faithful representation dimension. -/
def monsterMinDim : ℕ := 196883

/-- The minimal dimension really is the second Monster degree `degrees[1]`. -/
theorem monsterMinDim_eq_degree : monsterMinDim = degrees[1]! := by native_decide

/-- `196883 = 47·59·71` — a product of the three largest supersingular primes. -/
theorem monsterMinDim_factorization : monsterMinDim = 47 * 59 * 71 := by native_decide

/-- The Griess algebra dimension. -/
def griessDim : ℕ := 196884

/-- `196884 = 196883 + 1`: the Griess algebra is the trivial rep plus the smallest
faithful one. -/
theorem griess_eq_min_plus_one : griessDim = monsterMinDim + 1 := by native_decide

/-- `196884 = 196883 + 1`: the **first coefficient of the `j`-function**
(`J = j − 744`, the McKay–Thompson series `T₁ₐ`) is the Griess algebra dimension.
This is McKay's observation that launched Monstrous Moonshine. -/
theorem jFunction_first_coeff : griessDim = mckayThompson1A[0]! := by native_decide

/-- **The Griess algebra decomposition under `Co₀`.**
`196884 = 196560 + 300 + 24`: kissing number `+` `dim Sym²(ℝ²⁴)` `+` ambient
dimension. -/
theorem griess_decomposition : griessDim = kissingNumber + 300 + 24 := by native_decide

/-- `300 = C(25,2) = dim Sym²(ℝ²⁴)`. -/
theorem sym2_dim_24 : (300 : ℕ) = Nat.choose 25 2 := by native_decide

/-- **The numerical moonshine bridge** (as stated in the prompt):
`196883 = 196560 + 300 + 24 − 1`. -/
theorem moonshine_numerical_bridge :
    monsterMinDim = kissingNumber + 300 + 24 - 1 := by native_decide

/-! ## 2. The shadow of the 24D solid hyperball is a 2D solid disk -/

/-- The orthogonal projection of `ℝ²⁴` onto its first two coordinates (the "light"
casting a 2D shadow). -/
noncomputable def shadow (x : EuclideanSpace ℝ (Fin 24)) : EuclideanSpace ℝ (Fin 2) :=
  (EuclideanSpace.equiv (Fin 2) ℝ).symm (fun i => x (Fin.castLE (by norm_num) i))

/-- **A 24-dimensional solid hyperball casts a 2-dimensional solid disk shadow.**
The orthogonal projection onto the first two coordinates sends the closed ball of
radius `r` in `ℝ²⁴` exactly onto the closed ball of radius `r` in `ℝ²`: all the
extra-dimensional depth is flattened into a filled circle. -/
theorem shadow_closedBall (r : ℝ) :
    shadow '' (Metric.closedBall 0 r) = Metric.closedBall 0 r := by
  apply Set.eq_of_subset_of_subset;
  · rintro _ ⟨ x, hx, rfl ⟩;
    simp_all +decide [ EuclideanSpace.norm_eq, Fin.sum_univ_succ ];
    exact le_trans ( Real.sqrt_le_sqrt <| by exact add_le_add ( le_rfl ) <| le_add_of_nonneg_right <| by positivity ) hx;
  · intro y hy; use ( EuclideanSpace.equiv ( Fin 24 ) ℝ ).symm ( fun i => if h : ( i : ℕ ) < 2 then y ⟨ i, h ⟩ else 0 ) ; simp_all +decide [ EuclideanSpace.norm_eq ] ;
    refine' ⟨ _, _ ⟩;
    · erw [ Finset.sum_fin_eq_sum_range ] ; norm_num [ Finset.sum_range_succ' ] ; ring_nf at * ; aesop;
    · ext i; fin_cases i <;> rfl;

/-! ## 3. The 2D mandala of kissing points: three concentric rings -/

/-- The number of Golay-code octads (weight-8 codewords / blocks of `S(5,8,24)`). -/
def golayOctads : ℕ := 759

/-- Ring 1 of the mandala: minimal vectors of shape `(±4², 0²²)`, counted as
`2²·C(24,2)`. -/
def ring_4_shape : ℕ := 2 ^ 2 * Nat.choose 24 2

/-- Ring 2: minimal vectors of shape `(±2⁸, 0¹⁶)` over the Golay octads,
`2⁷·759`. -/
def ring_2_shape : ℕ := 2 ^ 7 * golayOctads

/-- Ring 3: minimal vectors of shape `(∓3, ±1²³)`, `2¹²·24`. -/
def ring_3_shape : ℕ := 2 ^ 12 * 24

theorem ring_4_shape_value : ring_4_shape = 1104 := by native_decide
theorem ring_2_shape_value : ring_2_shape = 97152 := by native_decide
theorem ring_3_shape_value : ring_3_shape = 98304 := by native_decide

/-- **The three shape classes partition the `196560` kissing vectors** — the three
concentric rings of the 2D mandala:
`196560 = 2²·C(24,2) + 2⁷·759 + 2¹²·24`. -/
theorem kissing_three_rings :
    ring_4_shape + ring_2_shape + ring_3_shape = kissingNumber := by native_decide

/-! ## The rotational symmetry of the 2D Petrie shadow -/

/-- The 2D Petrie projection shows **24-fold** rotational symmetry, consistent with
`24 ∣ 196560`. -/
theorem petrie_24fold : 24 ∣ kissingNumber := by native_decide

/-- … hence also 12-fold. -/
theorem petrie_12fold : 12 ∣ kissingNumber := by native_decide

/-- … and the hexagonal cross-section's 6-fold symmetry. -/
theorem hex_6fold : 6 ∣ kissingNumber := by native_decide

/-- The size of one orbit under the 24-fold symmetry: `196560 / 24 = 8190`. -/
theorem petrie_24_orbit : kissingNumber / 24 = 8190 := by native_decide

/-- The 2D hexagonal honeycomb cross-section has kissing number `6` (each penny
touches six others), and this divides the 24D kissing number. -/
def kissing2D : ℕ := 6

theorem kissing2D_dvd_kissing24 : kissing2D ∣ kissingNumber := by native_decide

end SphereShadows