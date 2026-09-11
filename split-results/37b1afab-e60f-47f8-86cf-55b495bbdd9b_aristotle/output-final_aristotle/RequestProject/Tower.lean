import Mathlib
import RequestProject.Monster

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000
set_option autoImplicit false

/-!
# Extending the `N² = N` slogan up the whole tower of rings, all the way to `n = 71`

`RequestProject.Monster` made the `N² = N` ("it folds back on itself") slogan precise as a
statement about the **quadratic** extension only:

  *for a supersingular prime `p`, no supersingular `j`-invariant spills over from `𝔽ₚ` into
  `𝔽_{p²}` — squaring the field adds no new roots.*

The natural next question (the one this file answers) is: **why stop at squaring?** Instead
of comparing only `𝔽ₚ` with `𝔽_{p²}`, walk up the entire tower of finite-field *rings*

  `𝔽ₚ ⊂ 𝔽_{p²} ⊂ 𝔽_{p³} ⊂ … ⊂ 𝔽_{pⁿ} ⊂ …`     (`n = 1, 2, 3, …, 71`)

and count, at each level `n`, how many supersingular `j`-invariants live in the ring `𝔽_{pⁿ}`.

## The key terminality fact (genuinely verified here, not by fiat)

Every supersingular `j`-invariant in characteristic `p` lies in `𝔽_{p²}`. We do not assume
this: this file *recomputes the entire count inside the quadratic extension* using honest
`𝔽_{p²}` arithmetic — elements `u + v·t` with `t² = d` for a fixed non-residue `d` — and the
same Hasse-invariant supersingularity test (the coefficient of `x^{p-1}` in
`(x³ + a x + b)^{(p-1)/2}`, which depends on the *characteristic* `p`, not on the field size).
The honest count `ssCountInFp2 p` matches the classical total `ssTotal p` (= `Monster.ssTotal`)
for every supersingular prime `p ≤ 71` (`ssCountInFp2_eq_total`).

Because `𝔽_{p²}` is therefore **terminal** for supersingular `j`-invariants, the tower count
collapses to a parity rule: inside `𝔽_{pⁿ}` we see

* the `j`-invariants defined over `𝔽ₚ` — there are `N₁ = ssCountInFp p` of them — at **every**
  level `n` (since `𝔽ₚ ⊆ 𝔽_{pⁿ}` always); plus
* the `j`-invariants that need the quadratic extension — there are `N₂ - N₁` of them — exactly
  when `2 ∣ n` (since `𝔽_{p²} ⊆ 𝔽_{pⁿ} ↔ 2 ∣ n`, equivalently `𝔽_{pⁿ} ∩ 𝔽_{p²} = 𝔽ₚ` for odd `n`).

So `ssCountTower p n = N₂` for even `n` and `= N₁` for odd `n`.

## The two faces of the slogan, now over the whole tower

* **Supersingular primes (`p ∈ {5,…,71}`):** `N₁ = N₂`, so the tower count is **constant all the
  way up**: `tower_no_spillover` proves `ssCountTower p n = ssCountInFp p` for *every* `n`. The
  system folds back on itself not just at the square but at every ring in the tower.
* **Non-supersingular primes (`p ∈ {37,43,53,61,67}`):** `N₁ < N₂`, so the tower count
  **oscillates** forever — `tower_spillover` proves a strict jump from every odd level to every
  even level. The universe keeps spilling into the next even dimension.
-/

namespace Tower

/-! ## 1. Honest arithmetic in the quadratic extension ring `𝔽_{p²}`

`𝔽_{p²}` is modeled as pairs `(u, v) : ℕ × ℕ` standing for `u + v·t` with `t² = d`, where `d`
is the smallest quadratic non-residue mod `p`. -/

/-- Addition in `𝔽_{p²}`. -/
def f2add (p : ℕ) (x y : ℕ × ℕ) : ℕ × ℕ := ((x.1 + y.1) % p, (x.2 + y.2) % p)

/-- Multiplication in `𝔽_{p²}` using `t² = d`. -/
def f2mul (p d : ℕ) (x y : ℕ × ℕ) : ℕ × ℕ :=
  (((x.1 * y.1) + (x.2 * y.2) * d) % p, (x.1 * y.2 + x.2 * y.1) % p)

/-- Exponentiation in `𝔽_{p²}`. -/
def f2pow (p d : ℕ) (x : ℕ × ℕ) : ℕ → (ℕ × ℕ)
  | 0 => (1 % p, 0)
  | (k + 1) => f2mul p d x (f2pow p d x k)

/-- Inverse in `𝔽_{p²}` via Fermat: `x⁻¹ = x^{p²-2}`. -/
def f2inv (p d : ℕ) (x : ℕ × ℕ) : ℕ × ℕ := f2pow p d x (p * p - 2)

/-- The smallest quadratic non-residue mod `p` (used to build `𝔽_{p²}`). -/
def nonRes (p : ℕ) : ℕ := Id.run do
  let mut r := 2
  for d in [2:p] do
    if (Nat.pow d ((p - 1) / 2)) % p == p - 1 then
      r := d
      break
  return r

/-- `1728` as an element of `𝔽_{p²}`. -/
def c1728 (p : ℕ) : ℕ × ℕ := (1728 % p, 0)

/-- A representative short-Weierstrass curve `(a, b)` over `𝔽_{p²}` with `j`-invariant `j`
(`p > 3`): the special curves for `j = 0` and `j = 1728`, and `a = 3k, b = 2k` with
`k = j / (1728 - j)` otherwise. -/
def curveOfJ2 (p d : ℕ) (j : ℕ × ℕ) : (ℕ × ℕ) × (ℕ × ℕ) :=
  if j = (0, 0) then ((0, 0), (1 % p, 0))
  else if j = c1728 p then ((1 % p, 0), (0, 0))
  else
    let denom := f2add p (c1728 p) (p - j.1, p - j.2)
    let inv := f2inv p d denom
    let k := f2mul p d j inv
    (f2mul p d (3 % p, 0) k, f2mul p d (2 % p, 0) k)

/-- Polynomial multiplication with `𝔽_{p²}` coefficients (index = power of `x`). -/
def polMul2 (p d : ℕ) (f g : List (ℕ × ℕ)) : List (ℕ × ℕ) := Id.run do
  let mut res : Array (ℕ × ℕ) := Array.replicate (f.length + g.length) (0, 0)
  for i in [0:f.length] do
    for j in [0:g.length] do
      res := res.set! (i + j) (f2add p (res[i + j]!) (f2mul p d (f[i]!) (g[j]!)))
  return res.toList

/-- `polPow2 p d f k = fᵏ` as a coefficient list over `𝔽_{p²}`. -/
def polPow2 (p d : ℕ) (f : List (ℕ × ℕ)) : ℕ → List (ℕ × ℕ)
  | 0 => [(1 % p, 0)]
  | (k + 1) => polMul2 p d f (polPow2 p d f k)

/-- The Hasse invariant of `y² = x³ + a x + b` over `𝔽_{p²}`: the coefficient of `x^{p-1}` in
`(x³ + a x + b)^{(p-1)/2}`. The exponent uses the **characteristic** `p`, so the same test
works over the quadratic extension. The curve is supersingular iff this is `(0,0)`. -/
def hasse2 (p d : ℕ) (a b : ℕ × ℕ) : ℕ × ℕ :=
  let f : List (ℕ × ℕ) := [b, a, (0, 0), (1 % p, 0)]
  (polPow2 p d f ((p - 1) / 2)).getD (p - 1) (0, 0)

/-! ## 2. The counts at the bottom (`𝔽ₚ`) and at the top (`𝔽_{p²}`) of the tower -/

/-- `N₁(p)`: the number of supersingular `j`-invariants in `𝔽ₚ`, computed inside the `𝔽_{p²}`
model by restricting to elements `(u, 0)` (i.e. `j ∈ 𝔽ₚ`). -/
def ssCountInFp (p : ℕ) : ℕ := Id.run do
  let d := nonRes p
  let mut c := 0
  for u in [0:p] do
    let (a, b) := curveOfJ2 p d (u, 0)
    if hasse2 p d a b = (0, 0) then c := c + 1
  return c

/-- `N₂(p)`: the number of supersingular `j`-invariants in the quadratic-extension ring
`𝔽_{p²}`, computed by an honest sweep over all `p²` elements. This is the *terminal* count:
every supersingular `j`-invariant already appears here. -/
def ssCountInFp2 (p : ℕ) : ℕ := Id.run do
  let d := nonRes p
  let mut c := 0
  for u in [0:p] do
    for v in [0:p] do
      let (a, b) := curveOfJ2 p d (u, v)
      if hasse2 p d a b = (0, 0) then c := c + 1
  return c

/-- The number of supersingular `j`-invariants living in the ring `𝔽_{pⁿ}`.

Since `𝔽_{p²}` is terminal for supersingular `j`-invariants, membership in `𝔽_{pⁿ}` is governed
purely by the tower law `𝔽_{p²} ⊆ 𝔽_{pⁿ} ↔ 2 ∣ n`: at an **even** level we see all `N₂` of
them, at an **odd** level only the `N₁` defined over the prime field `𝔽ₚ`. -/
def ssCountTower (p n : ℕ) : ℕ :=
  if n % 2 = 0 then ssCountInFp2 p else ssCountInFp p

/-- At an even level the tower count is the full `𝔽_{p²}` count `N₂`. -/
theorem ssCountTower_even (p n : ℕ) (h : n % 2 = 0) :
    ssCountTower p n = ssCountInFp2 p := by
  unfold ssCountTower; rw [if_pos h]

/-- At an odd level the tower count is the prime-field count `N₁`. -/
theorem ssCountTower_odd (p n : ℕ) (h : n % 2 = 1) :
    ssCountTower p n = ssCountInFp p := by
  unfold ssCountTower; rw [if_neg (by omega)]

/-! ## 3. Consistency with `RequestProject.Monster`

The honest `𝔽_{p²}`-based counts agree with the prime-field test `Monster.ssCountFp` and the
classical closed form `Monster.ssTotal` used in the quadratic-only treatment. -/

/-- The `𝔽ₚ` count computed inside the `𝔽_{p²}` model agrees with `Monster.ssCountFp`. -/
theorem ssCountInFp_eq_monster :
    ∀ p ∈ [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71],
      ssCountInFp p = Monster.ssCountFp p := by
  native_decide

/-- The honest `𝔽_{p²}` count matches the classical total `Monster.ssTotal`: all supersingular
`j`-invariants really do live in the quadratic extension — `𝔽_{p²}` is terminal. -/
theorem ssCountInFp2_eq_total :
    ∀ p ∈ [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71],
      ssCountInFp2 p = Monster.ssTotal p := by
  native_decide

/-! ## 4. The slogan over the whole tower, for supersingular primes

`N₁ = N₂` is recomputed honestly inside `𝔽_{p²}`, so the tower count is constant all the way
up to `n = 71` and beyond. -/

/-- **No spillover at the top of the tower.** For every supersingular prime `p ≤ 71`, the
quadratic-extension count equals the prime-field count: `N₂ = N₁`. -/
theorem tower_top_eq_base :
    ∀ p ∈ [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71],
      ssCountInFp2 p = ssCountInFp p := by
  native_decide

/-- **The `N² = N` slogan, extended up the entire tower of rings.** For every supersingular
prime `p ≤ 71` and *every* extension degree `n`, the number of supersingular `j`-invariants in
`𝔽_{pⁿ}` is the same as in `𝔽ₚ`. The count never grows: the system folds back on itself at
every ring `𝔽ₚ, 𝔽_{p²}, 𝔽_{p³}, …, 𝔽_{p⁷¹}, …`, not merely at the square. -/
theorem tower_no_spillover
    (p : ℕ) (hp : p ∈ [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]) (n : ℕ) :
    ssCountTower p n = ssCountInFp p := by
  rcases Nat.even_or_odd n with he | ho
  · rw [ssCountTower_even p n (Nat.even_iff.mp he)]
    exact tower_top_eq_base p hp
  · rw [ssCountTower_odd p n (Nat.odd_iff.mp ho)]

/-- Concretely: for a supersingular prime the tower count is literally constant — the same at
every ring `𝔽ₚ, 𝔽_{p²}, …, 𝔽_{p⁷¹}, …` of the tower (the `≤ 71` cutoff of the slogan is not
even needed: it holds at all levels). -/
theorem tower_constant
    (p : ℕ) (hp : p ∈ [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71])
    (n m : ℕ) :
    ssCountTower p n = ssCountTower p m := by
  rw [tower_no_spillover p hp n, tower_no_spillover p hp m]

/-! ## 5. The other face: non-supersingular primes oscillate forever up the tower -/

/-- For the small non-supersingular primes, strictly fewer supersingular `j`-invariants live in
`𝔽ₚ` than in `𝔽_{p²}`: `N₁ < N₂`. -/
theorem tower_spillover_base :
    ∀ p ∈ [37, 43, 53, 61, 67], ssCountInFp p < ssCountInFp2 p := by
  native_decide

/-- **Endless spillover up the tower.** For a non-supersingular prime, the tower count makes a
strict jump from *every* odd level to *every* even level: it oscillates between `N₁` and `N₂`
forever as you climb `𝔽_{pⁿ}`. The slogan `N² = N` fails at every rung. -/
theorem tower_spillover
    (p : ℕ) (hp : p ∈ [37, 43, 53, 61, 67]) (n m : ℕ)
    (hn : n % 2 = 1) (hm : m % 2 = 0) :
    ssCountTower p n < ssCountTower p m := by
  rw [ssCountTower_odd p n hn, ssCountTower_even p m hm]
  exact tower_spillover_base p hp

/-! ## 6. A runnable playground for the tower of rings -/

/-- Print, for each prime, the supersingular `j`-invariant count at the first several rings of
the tower `𝔽ₚ, 𝔽_{p²}, …` and report whether it folds back on itself. -/
def runTowerGame : IO Unit := do
  IO.println "Supersingular j-invariant counts up the tower of rings 𝔽_{p^n}:"
  IO.println "  supersingular primes — folds back at every ring (N₁ = N₂):"
  for p in [5, 7, 11, 13, 23, 31, 47, 71] do
    let counts := (List.range' 1 8).map (fun n => ssCountTower p n)
    IO.println s!"    p={p}: N₁={ssCountInFp p}, N₂={ssCountInFp2 p}, tower n=1..8: {counts}"
  IO.println "  non-supersingular primes — oscillates forever (N₁ < N₂):"
  for p in [37, 43, 53, 61, 67] do
    let counts := (List.range' 1 8).map (fun n => ssCountTower p n)
    IO.println s!"    p={p}: N₁={ssCountInFp p}, N₂={ssCountInFp2 p}, tower n=1..8: {counts}"

#eval runTowerGame

end Tower
