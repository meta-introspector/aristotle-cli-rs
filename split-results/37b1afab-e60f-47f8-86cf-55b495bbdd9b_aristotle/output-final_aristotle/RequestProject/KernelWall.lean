import RequestProject.Monster

/-!
# Mapping the kernel wall: `decide` vs. `native_decide` on the supersingularity test

`RequestProject/Monster.lean` proves `supersingular_no_spillover` (Ogg's condition (2),
the `N₂ = N₁` slogan) with **`native_decide`**: the polynomial arithmetic over `𝔽ₚ` is
compiled to native machine code and executed *outside* the kernel, so the cost is borne by
the compiler and the `Lean.ofReduceBool`/`Lean.trustCompiler` trust boundary, and the
elaborator's `maxHeartbeats` meter is irrelevant. (That is exactly why the inflated
`set_option maxHeartbeats 4000000` was vestigial there and has been removed.)

This file maps the *other* boundary — what happens when the same computation is forced
through **kernel reduction** via `decide`. Two obstructions surface:

1. **The array/`Id.run`/for-loop formulation is not kernel-reducible at all.**  The
   `Monster.ssCountFp` definition uses `Array.set!`, `for` loops and mutable `let mut`,
   which the kernel cannot reduce; `decide` gets stuck on it even for `p = 5`. So we first
   give a faithful, purely *structurally recursive* reimplementation (`ssCountK`) over
   `List ℕ` that the kernel **can** reduce, and prove (by `native_decide`) that it agrees
   with `Monster.ssCountFp` on every supersingular prime `> 3`.

2. **For the kernel-reducible version, a genuine complexity wall appears.**  The naive
   `O(deg²)` polynomial multiplication, raised to the `(p−1)/2` power and summed over the
   `p` candidate `j`-invariants, makes kernel `whnf` cost grow steeply in `p`:

   | prime `p`            | kernel `decide`                                              |
   |----------------------|--------------------------------------------------------------|
   | `5, 7, 11, 13`       | succeeds at the default `maxRecDepth`                          |
   | `17 … 47`            | succeeds, but needs a raised `maxRecDepth`                     |
   | `59`                 | needs a raised `maxHeartbeats` — the budget is **load-bearing**|
   | `71`                 | beyond practical kernel reach (times out even when inflated)   |

   So for kernel reduction `maxHeartbeats` is decisive exactly where it was *irrelevant*
   for `native_decide`. The wall sits between `p = 47` (under the default heartbeat budget)
   and `p = 59` (needs the inflated budget), with `p = 71` past the practical edge.
-/

namespace KernelWall

set_option autoImplicit false

/-! ## 1. A kernel-reducible reimplementation of the supersingularity count

Every definition below is structurally recursive over `List ℕ` or `ℕ` — no `Array`, no
`for`/`while`, no `Id.run` — so the kernel's `whnf` can reduce closed applications. (`ℕ`
arithmetic `+ * / %` is handled by the kernel's built-in GMP support, so it is fast.) -/

/-- Coefficient-wise polynomial addition mod `p`. -/
def polAdd (p : ℕ) : List ℕ → List ℕ → List ℕ
  | [], g => g
  | f, [] => f
  | a :: f, b :: g => ((a + b) % p) :: polAdd p f g

/-- Polynomial multiplication mod `p` (structural recursion on the first factor). -/
def polMulK (p : ℕ) : List ℕ → List ℕ → List ℕ
  | [], _ => []
  | a :: f, g => polAdd p (g.map (fun c => (a * c) % p)) (0 :: polMulK p f g)

/-- `polPowK p f k = fᵏ` mod `p`. -/
def polPowK (p : ℕ) (f : List ℕ) : ℕ → List ℕ
  | 0 => [1 % p]
  | k + 1 => polMulK p f (polPowK p f k)

/-- Hasse invariant of `y² = x³ + a·x + b` for `p > 3`: coefficient of `x^{p-1}` in
`(x³ + a·x + b)^{(p-1)/2}` mod `p`. The curve is supersingular iff this is `0`. -/
def hasseK (p a b : ℕ) : ℕ :=
  let f := [b % p, a % p, 0, 1 % p]
  ((polPowK p f ((p - 1) / 2)).getD (p - 1) 0) % p

/-- Linear modular exponentiation `base^e mod p` (structural recursion on `e`). -/
def modPowK (p base : ℕ) : ℕ → ℕ
  | 0 => 1 % p
  | e + 1 => (base % p * modPowK p base e) % p

/-- A representative short-Weierstrass curve with `j`-invariant `j` over `𝔽ₚ` (`p > 3`),
matching `Monster.curveOfJ` but using the kernel-reducible `modPowK`. -/
def curveOfJK (p j : ℕ) : ℕ × ℕ :=
  if j % p = 0 then (0, 1)
  else if j % p = 1728 % p then (1, 0)
  else
    let denom := (1728 % p + p - j % p) % p
    let inv := modPowK p denom (p - 2)
    let k := (j % p * inv) % p
    ((3 * k) % p, (2 * k) % p)

/-- Count supersingular `j`-invariants among `j ∈ {0, …, n-1}` (structural on `n`). -/
def ssCountUpTo (p : ℕ) : ℕ → ℕ
  | 0 => 0
  | j + 1 => ssCountUpTo p j + (let (a, b) := curveOfJK p j; if hasseK p a b = 0 then 1 else 0)

/-- `N₁(p)` computed by the kernel-reducible counter. -/
def ssCountK (p : ℕ) : ℕ := ssCountUpTo p p

/-! ## 2. Faithfulness: the kernel-reducible counter agrees with the array version

This cross-check is itself done with `native_decide` (cheap), certifying that `ssCountK`
is a faithful reimplementation of `Monster.ssCountFp` on every supersingular prime `> 3`. -/

/-- `ssCountK` reproduces `Monster.ssCountFp` on all supersingular primes `> 3`. -/
theorem ssCountK_eq_ssCountFp :
    [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71].all
      (fun p => ssCountK p == Monster.ssCountFp p) := by
  native_decide

/-! ## 3. Under the wall: kernel `decide` at the default heartbeat budget

These facts are proved by **kernel reduction** (`decide`), with no `native_decide` and no
inflated `maxHeartbeats`. We raise only `maxRecDepth`, which controls the elaborator's
recursion bookkeeping (not the kernel's time budget), so that the deeper unfoldings for the
larger primes are permitted. Each equation `ssCountK p = N₁(p)` is genuinely reduced by the
kernel. -/

section KernelDecide
set_option maxRecDepth 100000

example : ssCountK 5 = 1 := by decide
example : ssCountK 7 = 1 := by decide
example : ssCountK 11 = 2 := by decide
example : ssCountK 13 = 1 := by decide
example : ssCountK 17 = 2 := by decide
example : ssCountK 19 = 2 := by decide
example : ssCountK 23 = 3 := by decide
example : ssCountK 29 = 3 := by decide
example : ssCountK 31 = 3 := by decide
example : ssCountK 37 = 1 := by decide   -- 37 is *not* supersingular: N₁(37) = 1 < N₂(37) = 3
example : ssCountK 41 = 4 := by decide
example : ssCountK 47 = 5 := by decide

end KernelDecide

/-! ## 4. At the wall: `maxHeartbeats` becomes load-bearing for kernel reduction

For `p = 59` the kernel `whnf` exceeds the *default* `maxHeartbeats 200000` (it times out).
Raising the budget pushes the reduction through — so here, unlike for `native_decide`, the
heartbeat setting is genuinely load-bearing. This is the precise sense in which the choice
of checker, not the heartbeat number per se, governs whether a heavy computation is feasible. -/

section KernelWallEdge
set_option maxRecDepth 1000000
set_option maxHeartbeats 4000000

/-- `p = 59` (supersingular): reachable by kernel `decide` only with an inflated heartbeat
budget — direct evidence that `maxHeartbeats` is load-bearing for *kernel* reduction here. -/
example : ssCountK 59 = 6 := by decide

end KernelWallEdge

/-! ## 5. Past the wall: `p = 71`

For `p = 71` kernel `decide` times out at `whnf` even with a heavily inflated heartbeat
budget — it is past the practical edge of kernel reduction. We therefore certify the value
with `native_decide` (which runs it in well under a second), and leave the kernel attempt
documented but commented out so the file builds in reasonable time:

```
set_option maxRecDepth 1000000 in
set_option maxHeartbeats 40000000 in
example : ssCountK 71 = 7 := by decide   -- times out at `whnf`: past the kernel wall
```
-/

/-- `p = 71` via the compiled checker — cheap where kernel `decide` is infeasible. -/
theorem ssCountK_71 : ssCountK 71 = 7 := by native_decide

/-! ## 6. A runnable survey of the wall -/

/-- Print the kernel-reducible counts alongside `Monster`'s array counts. -/
def runKernelWallSurvey : IO Unit := do
  IO.println "Kernel-reducible supersingularity count vs. Monster's array version:"
  for p in [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] do
    IO.println s!"  p={p}: ssCountK={ssCountK p}, Monster.ssCountFp={Monster.ssCountFp p}"
  IO.println "Kernel `decide` boundary:  p ≤ 47 default heartbeats | p = 59 inflated | p = 71 native only"

#eval runKernelWallSurvey

end KernelWall
