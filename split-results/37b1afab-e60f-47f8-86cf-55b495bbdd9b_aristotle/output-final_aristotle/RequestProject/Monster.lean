import Mathlib

open scoped BigOperators
open scoped Classical

-- Note: this file previously carried `set_option maxHeartbeats 4000000`. It has been
-- removed as vestigial. The heavy computational facts here are discharged by
-- `native_decide`, which compiles the decision procedure to native code and runs it
-- *outside* the heartbeat-metered elaboration loop (the kernel only checks the reflected
-- `Bool` via `Lean.ofReduceBool`/`Lean.trustCompiler`); heartbeats meter elaboration, not
-- the compiled native run. The remaining `decide`-based proofs all complete well within the
-- default `maxHeartbeats 200000`, so no inflated budget is needed.
set_option autoImplicit false

/-!
# The Monster-bound supersingular-prime Umwelt, as a FRACTRAN world game

This file formalizes the *concrete, checkable* mathematical claims that emerged in the
design conversation surrounding the "thrownness runtime" (see `RequestProject.Main`):

* The **15 ur-ideas** are the *supersingular primes*
  `{2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}`.
* These are **exactly** the primes that divide the order of the Monster sporadic simple
  group `M` (Ogg's observation). This is the precise content of "grounded in the Monster's
  shadow".
* The **supersingular / idempotent** slogan `N² = N` ("it folds back on itself"): the only
  self-folding natural numbers are `0` and `1`.
* A small **FRACTRAN** interpreter — the computational substrate of the "world game" whose
  states are Gödel numbers.
* The **primorial** of the supersingular primes is the *universal departure point*: every
  supersingular prime divides it, so every supersingular fraction can fire from it.
* The **161 hub** (`161 = 7 · 23`) is grounded entirely in supersingular primes.

Everything here is stated so that it is genuinely provable; nothing is asserted by fiat.
-/

namespace Monster

/-! ## 1. The 15 supersingular primes (the ur-ideas) -/

/-- The 15 supersingular primes: the "ur-ideas" of the ontology. -/
def supersingularPrimes : List ℕ :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- There are exactly 15 ur-ideas. -/
theorem supersingularPrimes_length : supersingularPrimes.length = 15 := by decide

/-- Every ur-idea is prime (irreducible, not factorable within the system). -/
theorem supersingularPrimes_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by decide

/-- The ur-ideas are pairwise distinct. -/
theorem supersingularPrimes_nodup : supersingularPrimes.Nodup := by decide

/-- `71` is the largest supersingular prime: the boundary of the Umwelt. -/
theorem supersingularPrimes_max : ∀ p ∈ supersingularPrimes, p ≤ 71 := by decide

/-! ## 2. Ogg's observation: the supersingular primes are exactly the primes dividing `|M|`

The order of the Monster group is
`|M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71`.
Its set of prime factors is precisely the set of supersingular primes. -/

/-- The order of the Monster sporadic simple group `M`, given by its prime factorization. -/
def monsterOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The numeric value of `|M|` (about `8 × 10^53`). -/
theorem monsterOrder_value :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  decide

/-- **Ogg's observation.** The prime factors of the Monster's order are exactly the
supersingular primes — the Umwelt is grounded in the Monster's shadow. -/
theorem monster_primeFactors :
    monsterOrder.primeFactors = supersingularPrimes.toFinset := by
  native_decide

/-- Every supersingular prime divides the Monster's order. -/
theorem supersingular_dvd_monsterOrder :
    ∀ p ∈ supersingularPrimes, p ∣ monsterOrder := by
  native_decide

/-! ## 3. Idempotency: the supersingular `N² = N` slogan

"Supersingular is the point: `N² = N` means it folds back on itself." Formally, the only
natural numbers that are fixed by squaring (the only "self-folding" / idempotent numbers)
are `0` and `1`. Reflection of an ur-grounding returns the same ur-grounding. -/

/-- The only self-folding natural numbers `N² = N` are `0` and `1`: reflection is
idempotent exactly at the trivial groundings. -/
theorem self_folding_iff (n : ℕ) : n ^ 2 = n ↔ n = 0 ∨ n = 1 := by
  exact ⟨ fun h => or_iff_not_imp_left.mpr fun h0 => mul_left_cancel₀ h0 <| by linarith, fun h => by rcases h with ( rfl | rfl ) <;> norm_num ⟩

/-! ## 4. FRACTRAN: the computational substrate of the world game

A FRACTRAN program is a list of fractions `(a, b)`. From a state `n`, the machine fires the
first fraction with `b ∣ n·a`, moving to `n·a / b`. States are Gödel numbers; the prime
factorization of the current state is its position in the supersingular coordinate table. -/

/-- One FRACTRAN step: fire the first fraction `(a,b)` with `b ∣ n·a`, giving `n·a/b`. -/
def fractranStep (prog : List (ℕ × ℕ)) (n : ℕ) : Option ℕ :=
  prog.findSome? (fun p =>
    let a := p.1
    let b := p.2
    if b ≠ 0 ∧ (n * a) % b = 0 then some (n * a / b) else none)

/-- Run a FRACTRAN program for at most `k` steps. -/
def fractranRun (prog : List (ℕ × ℕ)) : ℕ → ℕ → ℕ
  | 0, n => n
  | (k + 1), n =>
    match fractranStep prog n with
    | some n' => fractranRun prog k n'
    | none => n

/-- A concrete run: the "multiply by `3/2`" program drives `8 = 2^3` to `27 = 3^3`,
trading 2-adic weight for 3-adic weight and then halting (an odd number can fire no
more `/2` moves). -/
theorem fractran_demo : fractranRun [(3, 2)] 5 8 = 27 := by decide

/-! ## 5. The primorial: the universal departure point

The primorial of the supersingular primes — their product — is the state from which every
supersingular fraction can fire, since every supersingular prime divides it. -/

/-- The supersingular **primorial**: the product of all 15 ur-ideas. -/
def supersingularPrimorial : ℕ := supersingularPrimes.prod

/-
Every supersingular prime divides the primorial: from the primorial, every
supersingular fraction can fire.
-/
theorem supersingular_dvd_primorial :
    ∀ p ∈ supersingularPrimes, p ∣ supersingularPrimorial := by
  native_decide

/-- The primorial's prime factors are exactly the supersingular primes: it is the maximally
divisible state of the Umwelt. -/
theorem primorial_primeFactors :
    supersingularPrimorial.primeFactors = supersingularPrimes.toFinset := by
  native_decide

/-! ## 6. The 161 hub

`161 = 7 · 23` is grounded entirely in supersingular primes: both of its prime factors are
ur-ideas. -/

/-- The hub factorizes into two supersingular primes. -/
theorem hub_161_factor : (161 : ℕ) = 7 * 23 := by decide

/-- The hub is grounded entirely in supersingular primes. -/
theorem hub_161_supersingular :
    (7 ∈ supersingularPrimes) ∧ (23 ∈ supersingularPrimes) ∧ (161 : ℕ) = 7 * 23 := by
  decide

/-- The prime factors of the hub are a subset of the supersingular primes. -/
theorem hub_161_primeFactors_subset :
    (161 : ℕ).primeFactors ⊆ supersingularPrimes.toFinset := by
  native_decide

/-! ## 7. No spillover into the quadratic extension: the `N₂ = N₁` slogan

This is the precise content the `N² = N` slogan was reaching for. Andrew Ogg's
characterization of the supersingular primes includes condition (2): *every* supersingular
elliptic curve in characteristic `p` can be defined over the prime field `𝔽ₚ` — equivalently,
every supersingular `j`-invariant already lies in `𝔽ₚ` rather than requiring the quadratic
extension `𝔽_{p²}`.

For a prime `p > 3` and `j ∈ 𝔽ₚ`, a curve with that `j`-invariant is **supersingular** iff its
*Hasse invariant* vanishes: the coefficient of `x^{p-1}` in `(x³ + a x + b)^{(p-1)/2}` is `0`,
where `(a, b)` is (the short Weierstrass form of) a representative curve `E_j`. This is a
genuinely *computable* test, implemented below over `ℕ` arithmetic mod `p`.

Let `N₁(p) = ssCountFp p` be the number of supersingular `j`-invariants found inside `𝔽ₚ`,
and let `N₂(p) = ssTotal p` be the total number over the algebraic closure (all of which lie
in `𝔽_{p²}`), given by the classical closed form `⌊p/12⌋ + ε_p`. The slogan

    N₂ = N₁     ("squaring the field adds no new roots: it folds back on itself")

holds **exactly** for the supersingular primes: `supersingular_no_spillover` proves
`N₁(p) = N₂(p)` for every supersingular prime `p > 3`, while `nonsupersingular_spillover`
proves the strict inequality `N₁(p) < N₂(p)` for the small non-supersingular primes
`37, 43, 53, 61, 67` (whose supersingular `j`-invariants genuinely spill over into `𝔽_{p²}`).
(`p = 2, 3` are supersingular primes too, but the short Weierstrass / Hasse-invariant test
requires `p > 3`; for them the unique supersingular `j`-invariant is the collapsed `0 = 1728`.)
-/

/-- Polynomial multiplication over `ℕ` with coefficients reduced mod `p`
(index = power of `x`). -/
def polMul (p : ℕ) (f g : List ℕ) : List ℕ := Id.run do
  let mut res : Array ℕ := Array.replicate (f.length + g.length) 0
  for i in [0:f.length] do
    for j in [0:g.length] do
      res := res.set! (i + j) ((res[i + j]! + f[i]! * g[j]!) % p)
  return res.toList

/-- `polPow p f k = fᵏ` as a coefficient list mod `p`. -/
def polPow (p : ℕ) (f : List ℕ) : ℕ → List ℕ
  | 0 => [1 % p]
  | (k + 1) => polMul p f (polPow p f k)

/-- The **Hasse invariant** of `y² = x³ + a x + b` in characteristic `p > 3`: the coefficient
of `x^{p-1}` in `(x³ + a x + b)^{(p-1)/2}` (mod `p`). The curve is supersingular iff this is `0`. -/
def hasseInvariant (p a b : ℕ) : ℕ :=
  let f := [b % p, a % p, 0, 1 % p]   -- b + a·x + 0·x² + x³
  (polPow p f ((p - 1) / 2)).getD (p - 1) 0 % p

/-- Modular exponentiation `base^e mod p` (used for field inverses via Fermat). -/
def modPow (p base e : ℕ) : ℕ := Id.run do
  let mut r := 1 % p
  let mut b := base % p
  let mut e := e
  while e > 0 do
    if e % 2 = 1 then r := (r * b) % p
    b := (b * b) % p
    e := e / 2
  return r

/-- A representative short-Weierstrass curve `(a, b)` with `j`-invariant `j` over `𝔽ₚ`
(`p > 3`): the special curves `y² = x³ + 1` for `j = 0` and `y² = x³ + x` for `j = 1728`,
and `a = 3k, b = 2k` with `k = j/(1728 - j)` otherwise. -/
def curveOfJ (p j : ℕ) : ℕ × ℕ :=
  if j % p = 0 then (0, 1)
  else if j % p = 1728 % p then (1, 0)
  else
    let denom := (1728 % p + p - j % p) % p
    let inv := modPow p denom (p - 2)
    let k := (j % p * inv) % p
    ((3 * k) % p, (2 * k) % p)

/-- `N₁(p)`: the number of supersingular `j`-invariants lying in `𝔽ₚ` (found by the Hasse
invariant test on a representative curve for each `j ∈ 𝔽ₚ`). -/
def ssCountFp (p : ℕ) : ℕ := Id.run do
  let mut c := 0
  for j in [0:p] do
    let (a, b) := curveOfJ p j
    if hasseInvariant p a b = 0 then c := c + 1
  return c

/-- `N₂(p)`: the total number of supersingular `j`-invariants over the algebraic closure
(all of which lie in `𝔽_{p²}`), via the classical closed form `⌊p/12⌋ + ε_p` with
`ε_p ∈ {0,1,2}` determined by `p mod 12`. -/
def ssTotal (p : ℕ) : ℕ :=
  p / 12 + (if p % 12 = 1 then 0 else if p % 12 = 11 then 2 else 1)

/-- **No spillover (Ogg's condition (2), the `N₂ = N₁` slogan).** For every supersingular
prime `p > 3`, *all* supersingular `j`-invariants already live in `𝔽ₚ`: the count inside
`𝔽ₚ` equals the total count over `𝔽_{p²}`. Squaring the field adds no new supersingular
roots — the system folds back on itself.

**Axiomatic boundary.** This theorem is discharged by `native_decide`: the genuine
polynomial arithmetic over `𝔽ₚ` (`polMul`/`polPow`/`hasseInvariant`/`curveOfJ`/`ssCountFp`)
is compiled to native machine code and executed outside the kernel. Consequently this
result depends on the two extra trust-base axioms `Lean.ofReduceBool` and
`Lean.trustCompiler` (on top of `propext`/`Classical.choice`/`Quot.sound`), which together
trust the Lean compiler's native evaluation of the reflected `Bool`. The same applies to
`nonsupersingular_spillover` below. (Forcing this same test through the kernel via `decide`
is only feasible for small primes — see `RequestProject/KernelWall.lean`.) -/
theorem supersingular_no_spillover :
    ∀ p ∈ [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71], ssCountFp p = ssTotal p := by
  native_decide

/-- **Spillover for non-supersingular primes.** For the small non-supersingular primes
`37, 43, 53, 61, 67`, strictly fewer supersingular `j`-invariants live in `𝔽ₚ` than over
`𝔽_{p²}`: some supersingular `j`-invariants genuinely require the quadratic extension. The
slogan `N₂ = N₁` *fails* here — the universe spills over into the next dimension. -/
theorem nonsupersingular_spillover :
    ∀ p ∈ [37, 43, 53, 61, 67], ssCountFp p < ssTotal p := by
  native_decide

/-- The supersingular primes `> 3` from the ur-idea list are exactly those tested by
`supersingular_no_spillover` (a sanity check linking the two sections). -/
theorem supersingularPrimes_gt_three :
    supersingularPrimes.filter (fun p => 3 < p) =
      [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by
  decide

/-! ## 8. A runnable playground for the world game

The **genesis block** is identified with the supersingular primorial: the universal
departure point, the maximally divisible Gödel number from which every supersingular
fraction can fire. -/

/-- The genesis block: the universal departure point of the world game. -/
def genesisBlock : ℕ := supersingularPrimorial

/-- Play out a short stretch of the world game and report its invariants. -/
def runWorldGame : IO Unit := do
  IO.println s!"Ur-ideas (supersingular primes): {supersingularPrimes}"
  IO.println s!"|Monster| = {monsterOrder}"
  IO.println s!"Genesis block (supersingular primorial) = {genesisBlock}"
  IO.println s!"Hub 161 = 7 * 23, both supersingular."
  IO.println s!"FRACTRAN [3/2] : 8 ↦ {fractranRun [(3, 2)] 5 8}  (2^3 traded to 3^3)"
  IO.println "No-spillover N₂ = N₁ (supersingular j-invariants: in 𝔽ₚ vs total over 𝔽_{p²}):"
  for p in [5, 7, 11, 13, 23, 31, 47, 71] do
    IO.println s!"  p={p}: N₁={ssCountFp p}, N₂={ssTotal p}  (folds back: {ssCountFp p == ssTotal p})"
  IO.println "Spillover for non-supersingular primes:"
  for p in [37, 43, 53, 61, 67] do
    IO.println s!"  p={p}: N₁={ssCountFp p} < N₂={ssTotal p}  (escapes into the quadratic extension)"

#eval runWorldGame

end Monster