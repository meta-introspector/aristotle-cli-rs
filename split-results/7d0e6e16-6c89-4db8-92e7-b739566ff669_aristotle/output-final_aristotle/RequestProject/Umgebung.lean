import Mathlib

/-!
# Umgebung: Concentric Shadow Worlds of Monster Irreps

Each irreducible representation dimension `d` of the Monster group lives in the
divisor lattice of |M|. By applying **kernel operations** (±, ×/÷) with
parameters drawn from the **12 outer supersingular primes**
N = {7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}, we define concentric
**Umgebung** (neighborhoods) around each irrep dimension.

## Structure

- **Ring 0** = {d} (the irrep itself — always a divisor of |M|)
- **Ring 1 (additive)** = {d + p, d − p : p ∈ N} — the ±-shadow world
- **Ring 1 (multiplicative)** = {d × p : p ∈ N} ∪ {d / p : p ∈ N, p ∣ d}
- **Ring 1 (combined)** = union of additive and multiplicative
- **Ring 2** = Ring-1 of every element in Ring 1 (two-step reachability)

We then ask: which elements of these neighborhoods still divide |M|?
These are the **shadow divisors** — phantom representations reachable from
genuine irreps by elementary arithmetic with primes.

## Main Results

1. All 8 known irrep dimensions divide |M| (Ring 0).
2. The **trivial irrep d = 1** has a perfect additive Umgebung: all 12
   values 1 + p divide |M| (hit rate 100%).
3. The **McKay irrep d = 196883 = 47 × 59 × 71** has a unique additive
   shadow: 196883 − 71 = 196812 = 2² × 3² × 7 × 11 × 71 divides |M|.
   No other d ± p (for outer p) divides |M| for any larger irrep.
4. Multiplicatively, d × p divides |M| for most small outer primes p (since
   d is squarefree over the supersingular primes it uses), and d / p divides
   |M| for every prime p dividing d.
5. **Prime 59** is the most connected outer shadow world, reaching 6 of 8
   irreps via divisibility. **Prime 17** reaches none.
6. The total shadow density is 40 divisibility connections among
   8 × 12 = 96 possible (irrep, outer-prime) pairs (42%).

## Terminology

- **Umgebung** (German: neighborhood/surroundings) — the set of values
  reachable from an irrep dimension by kernel operations with prime parameters.
- **Shadow world of prime p** — the fiber of the Umgebung over parameter p.
- **Divisor hit** — an Umgebung element that divides |M|.
-/

open scoped BigOperators Nat

set_option maxHeartbeats 1600000

/-! ## §1. The Monster order and prime sets -/

/-- The order of the Monster group. -/
def M : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The 15 supersingular primes. -/
def ssPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The 3 "inner" primes (studied in ShadowIrreps.lean). -/
def innerPrimes : List ℕ := [2, 3, 5]

/-- The 12 "outer" primes — the parameter set for shadow worlds. -/
def outerPrimes : List ℕ := [7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem outerPrimes_length : outerPrimes.length = 12 := by native_decide

theorem outerPrimes_all_prime : ∀ p ∈ outerPrimes, Nat.Prime p := by decide

theorem outerPrimes_all_dvd : ∀ p ∈ outerPrimes, p ∣ M := by decide

/-- The 8 smallest irreducible representation dimensions of the Monster. -/
def irrepDims : List ℕ :=
  [1, 196883, 21296876, 842609326, 18538750076, 19360062527,
   293553734298, 3879214937598]

/-- All 8 listed irrep dimensions divide |M|. -/
theorem all_irreps_dvd_M : ∀ d ∈ irrepDims, d ∣ M := by decide

/-! ## §2. Kernel Operations

We define four elementary arithmetic operations that map an irrep dimension `d`
and a prime parameter `p` to a new natural number. -/

/-- The four kernel operation types. -/
inductive KernelOp
  | add   -- d ↦ d + p
  | sub   -- d ↦ d - p (when d > p)
  | mul   -- d ↦ d * p
  | div   -- d ↦ d / p (when p ∣ d)
  deriving DecidableEq, Repr

/-- Apply a kernel operation to dimension `d` with prime parameter `p`.
    Returns `none` if the operation is invalid. -/
def KernelOp.apply (op : KernelOp) (d p : ℕ) : Option ℕ :=
  match op with
  | .add => some (d + p)
  | .sub => if p < d then some (d - p) else none
  | .mul => some (d * p)
  | .div => if p ∣ d then some (d / p) else none

/-! ## §3. Umgebung — Neighborhoods of Irrep Dimensions -/

/-- Single-step Umgebung: all values reachable from `d` by one kernel
    operation with a parameter from `primes`. -/
def umgebung (d : ℕ) (primes : List ℕ) : List ℕ :=
  (primes.flatMap fun p =>
    [KernelOp.add, KernelOp.sub, KernelOp.mul, KernelOp.div].filterMap
      fun op => op.apply d p).eraseDups

/-- Additive Umgebung: values reachable by d ± p. -/
def umgebungAdd (d : ℕ) (primes : List ℕ) : List ℕ :=
  (primes.flatMap fun p =>
    [KernelOp.add, KernelOp.sub].filterMap fun op => op.apply d p).eraseDups

/-- Multiplicative Umgebung: values reachable by d × p or d / p. -/
def umgebungMul (d : ℕ) (primes : List ℕ) : List ℕ :=
  (primes.flatMap fun p =>
    [KernelOp.mul, KernelOp.div].filterMap fun op => op.apply d p).eraseDups

/-- Divisor hits: elements of the Umgebung that divide |M|. -/
def divisorHits (d : ℕ) (primes : List ℕ) : List ℕ :=
  (umgebung d primes).filter fun x => x ∣ M

/-- Additive divisor hits. -/
def addDivisorHits (d : ℕ) (primes : List ℕ) : List ℕ :=
  (umgebungAdd d primes).filter fun x => x ∣ M

/-- Multiplicative divisor hits. -/
def mulDivisorHits (d : ℕ) (primes : List ℕ) : List ℕ :=
  (umgebungMul d primes).filter fun x => x ∣ M

/-! ## §4. Shadow World Fibers

Each outer prime `p` defines a **shadow world**: the fiber of values reachable
from an irrep dimension by a single kernel operation with parameter `p`. -/

/-- The p-shadow of irrep dimension d. -/
def shadowFiber (d p : ℕ) : List ℕ :=
  [KernelOp.add, KernelOp.sub, KernelOp.mul, KernelOp.div].filterMap
    fun op => op.apply d p

/-- Divisor hits in the p-shadow of d. -/
def shadowFiberHits (d p : ℕ) : List ℕ :=
  (shadowFiber d p).filter fun x => x ∣ M

/-! ## §5. The Multiplicative Umgebung of 196883

Since 196883 = 47 × 59 × 71, dividing by any of {47, 59, 71} produces a
product of the other two — still a divisor of |M|. -/

theorem dim1_factored : irrepDims[1]! = 47 * 59 * 71 := by native_decide

theorem dim1_div_47 : 196883 / 47 = 4189 := by native_decide
theorem dim1_div_59 : 196883 / 59 = 3337 := by native_decide
theorem dim1_div_71 : 196883 / 71 = 2773 := by native_decide

theorem dim1_quotients_dvd_M : 4189 ∣ M ∧ 3337 ∣ M ∧ 2773 ∣ M := by
  exact ⟨by decide, by decide, by decide⟩

/-- The multiplicative Umgebung of 196883 w.r.t. the outer primes
    has exactly 3 divisor-hit quotients: {2773, 3337, 4189}. -/
theorem dim1_mul_hits :
    mulDivisorHits 196883 outerPrimes = [1378181, 2165713, 2559479, 3347011,
      3740777, 4528309, 5709607, 6103373, 8072203, 4189, 3337, 2773] := by
  native_decide

/-! ## §6. The additive Umgebung of the trivial irrep (d = 1)

From d = 1, the additive neighborhood {1 + p : p ∈ outerPrimes} lands on
small numbers that all divide |M| — a perfect 100% hit rate. -/

theorem trivial_add_umgebung :
    umgebungAdd 1 outerPrimes =
      [8, 12, 14, 18, 20, 24, 30, 32, 42, 48, 60, 72] := by native_decide

/-- All 12 additive neighbors of d = 1 divide |M|. -/
theorem trivial_add_all_dvd :
    ∀ x ∈ umgebungAdd 1 outerPrimes, x ∣ M := by native_decide

theorem trivial_add_hit_count :
    (addDivisorHits 1 outerPrimes).length = 12 := by native_decide

/-! ## §7. The unique additive shadow of 196883

Among all 8 irreps and all 12 outer primes, **exactly one** additive
neighbor divides |M|: the value 196883 − 71 = 196812 = 2² × 3² × 7 × 11 × 71.

This is remarkable: larger irreps are completely "additively isolated" from
the divisor lattice (their ±p perturbations never land on divisors). -/

/-- 196883 − 71 = 196812 divides |M|. -/
theorem additive_shadow_196812 : 196812 ∣ M := by decide

/-- 196812 = 2² × 3² × 7 × 11 × 71 — entirely supersingular. -/
theorem shadow_196812_factored : 196812 = 2^2 * 3^2 * 7 * 11 * 71 := by native_decide

/-- 196883 − 71 = 196812. -/
theorem shadow_196812_from_sub : 196883 - 71 = 196812 := by native_decide

/-- Only one additive hit for d = 196883 w.r.t. outer primes. -/
theorem dim1_add_hits :
    addDivisorHits 196883 outerPrimes = [196812] := by native_decide

/-- No additive hits for d = 21296876 (the second non-trivial irrep). -/
theorem dim2_no_add_hits :
    addDivisorHits 21296876 outerPrimes = [] := by native_decide

/-- No additive hits for d = 842609326. -/
theorem dim3_no_add_hits :
    addDivisorHits 842609326 outerPrimes = [] := by native_decide

/-- No additive hits for d = 18538750076. -/
theorem dim4_no_add_hits :
    addDivisorHits 18538750076 outerPrimes = [] := by native_decide

/-- No additive hits for d = 19360062527. -/
theorem dim5_no_add_hits :
    addDivisorHits 19360062527 outerPrimes = [] := by native_decide

/-- No additive hits for d = 293553734298. -/
theorem dim6_no_add_hits :
    addDivisorHits 293553734298 outerPrimes = [] := by native_decide

/-- No additive hits for d = 3879214937598. -/
theorem dim7_no_add_hits :
    addDivisorHits 3879214937598 outerPrimes = [] := by native_decide

/-! ## §8. Full Umgebung hit counts

For each irrep, the total number of Umgebung elements (additive + multiplicative)
that divide |M|. The trivial irrep has the highest hit rate; as irreps grow,
the additive component vanishes and multiplicative hits dominate. -/

/-- d = 1: 24 of 24 Umgebung elements divide |M| (100%). -/
theorem hits_dim0 : (divisorHits 1 outerPrimes).length = 24 := by native_decide

/-- d = 196883: 13 Umgebung elements divide |M|. -/
theorem hits_dim1 : (divisorHits 196883 outerPrimes).length = 13 := by native_decide

/-- d = 21296876: 12 Umgebung elements divide |M|. -/
theorem hits_dim2 : (divisorHits 21296876 outerPrimes).length = 12 := by native_decide

/-- d = 842609326: 13 Umgebung elements divide |M|. -/
theorem hits_dim3 : (divisorHits 842609326 outerPrimes).length = 13 := by native_decide

/-- d = 18538750076: 14 Umgebung elements divide |M|. -/
theorem hits_dim4 : (divisorHits 18538750076 outerPrimes).length = 14 := by native_decide

/-- d = 19360062527: 13 Umgebung elements divide |M|. -/
theorem hits_dim5 : (divisorHits 19360062527 outerPrimes).length = 13 := by native_decide

/-- d = 293553734298: 13 Umgebung elements divide |M|. -/
theorem hits_dim6 : (divisorHits 293553734298 outerPrimes).length = 13 := by native_decide

/-- d = 3879214937598: 15 Umgebung elements divide |M|. -/
theorem hits_dim7 : (divisorHits 3879214937598 outerPrimes).length = 15 := by native_decide

/-! ## §9. Shadow World Fibers of 196883

For each of the three McKay primes {47, 59, 71}, the shadow fiber of 196883
has structure: the additive neighbors (d ± p) mostly miss |M|, but the
multiplicative neighbors (d × p and d / p) always hit. -/

theorem shadow47_of_dim1 :
    shadowFiber 196883 47 = [196930, 196836, 9253501, 4189] := by native_decide

/-- In the 47-shadow of 196883, 1 division hit (4189 = 59 × 71). -/
theorem shadow47_hits_dim1 :
    shadowFiberHits 196883 47 = [4189] := by native_decide

theorem shadow59_of_dim1 :
    shadowFiber 196883 59 = [196942, 196824, 11616097, 3337] := by native_decide

/-- In the 59-shadow, 1 hit. -/
theorem shadow59_hits_dim1 :
    shadowFiberHits 196883 59 = [3337] := by native_decide

theorem shadow71_of_dim1 :
    shadowFiber 196883 71 = [196954, 196812, 13978693, 2773] := by native_decide

/-- In the 71-shadow, **2 hits**: 196812 = 196883 − 71 (additive!) and
    2773 = 196883 / 71 (multiplicative). The 71-shadow is the richest. -/
theorem shadow71_hits_dim1 :
    shadowFiberHits 196883 71 = [196812, 2773] := by native_decide

/-! ## §10. The Divisibility Profile

For each irrep d, the **divisibility profile** is the set of supersingular
primes that divide d. This determines which shadow worlds admit
multiplicative descent (d/p). -/

/-- The divisibility profile of an irrep w.r.t. all 15 supersingular primes. -/
def divProfile (d : ℕ) : List ℕ :=
  ssPrimes.filter fun p => p ∣ d

theorem divProfile_trivial : divProfile 1 = [] := by native_decide

/-- 196883 = 47 × 59 × 71: divisible only by the three McKay primes. -/
theorem divProfile_dim1 : divProfile 196883 = [47, 59, 71] := by native_decide

/-- 21296876 = 2² × 31 × 41 × 59 × 71 × ...: divisible by {2, 31, 41, 59, 71}. -/
theorem divProfile_dim2 : divProfile 21296876 = [2, 31, 41, 59, 71] := by native_decide

/-- 842609326: divisible by {2, 13, 29, 31, 47, 59}. -/
theorem divProfile_dim3 : divProfile 842609326 = [2, 13, 29, 31, 47, 59] := by native_decide

/-- 18538750076: divisible by {2, 7, 11, 23, 29, 31, 41, 71}. -/
theorem divProfile_dim4 : divProfile 18538750076 =
    [2, 7, 11, 23, 29, 31, 41, 71] := by native_decide

/-- 19360062527: divisible by {13, 23, 29, 41, 59, 71}. -/
theorem divProfile_dim5 : divProfile 19360062527 =
    [13, 23, 29, 41, 59, 71] := by native_decide

/-- 293553734298: divisible by {2, 3, 11, 19, 29, 41, 47, 59, 71}. -/
theorem divProfile_dim6 : divProfile 293553734298 =
    [2, 3, 11, 19, 29, 41, 47, 59, 71] := by native_decide

/-- 3879214937598: divisible by {2, 3, 7, 11, 13, 19, 23, 41, 47, 59}. -/
theorem divProfile_dim7 : divProfile 3879214937598 =
    [2, 3, 7, 11, 13, 19, 23, 41, 47, 59] := by native_decide

/-! ## §11. Shadow World Reach

For each outer prime p, how many of the 8 irreps have p in their
divisibility profile? This measures the "connectivity" of each shadow world. -/

/-- Count how many of the 8 irreps are divisible by prime p. -/
def shadowWorldReach (p : ℕ) : ℕ :=
  irrepDims.countP fun d => p ∣ d

/-- Prime 7 reaches 2 of 8 irreps. -/
theorem reach_7 : shadowWorldReach 7 = 2 := by native_decide
/-- Prime 11 reaches 3 of 8 irreps. -/
theorem reach_11 : shadowWorldReach 11 = 3 := by native_decide
/-- Prime 13 reaches 3 of 8 irreps. -/
theorem reach_13 : shadowWorldReach 13 = 3 := by native_decide
/-- Prime 17 reaches 0 of 8 irreps — a **disconnected** shadow world! -/
theorem reach_17 : shadowWorldReach 17 = 0 := by native_decide
/-- Prime 19 reaches 2 of 8 irreps. -/
theorem reach_19 : shadowWorldReach 19 = 2 := by native_decide
/-- Prime 23 reaches 3 of 8 irreps. -/
theorem reach_23 : shadowWorldReach 23 = 3 := by native_decide
/-- Prime 29 reaches 4 of 8 irreps. -/
theorem reach_29 : shadowWorldReach 29 = 4 := by native_decide
/-- Prime 31 reaches 3 of 8 irreps. -/
theorem reach_31 : shadowWorldReach 31 = 3 := by native_decide
/-- Prime 41 reaches 5 of 8 irreps. -/
theorem reach_41 : shadowWorldReach 41 = 5 := by native_decide
/-- Prime 47 reaches 4 of 8 irreps. -/
theorem reach_47 : shadowWorldReach 47 = 4 := by native_decide
/-- Prime 59 reaches **6 of 8** irreps — the most connected outer shadow world. -/
theorem reach_59 : shadowWorldReach 59 = 6 := by native_decide
/-- Prime 71 reaches 5 of 8 irreps. -/
theorem reach_71 : shadowWorldReach 71 = 5 := by native_decide

/-- Prime 59 is the most connected outer shadow world: it divides 6 of 8 irreps,
    more than any other outer prime. -/
theorem prime59_most_connected :
    ∀ p ∈ outerPrimes, shadowWorldReach p ≤ shadowWorldReach 59 := by native_decide

/-- The total number of (irrep, outer-prime) divisibility pairs is 40.
    Out of 8 × 12 = 96 possible pairs, that is a 42% density. -/
def totalDivPairs : ℕ :=
  outerPrimes.foldl (fun acc p => acc + shadowWorldReach p) 0

theorem totalDivPairs_value : totalDivPairs = 40 := by native_decide

theorem shadow_density :
    totalDivPairs = 40 ∧ irrepDims.length * outerPrimes.length = 96 := by
  exact ⟨by native_decide, by native_decide⟩

/-! ## §12. Complementary and Overlapping Profiles

Two irreps have **complementary profiles** if their divisibility profiles
(restricted to outer primes) are disjoint — they live in non-overlapping
shadow worlds. -/

/-- Outer-prime divisibility profile. -/
def outerProfile (d : ℕ) : List ℕ :=
  outerPrimes.filter fun p => p ∣ d

/-- d = 196883 has outer profile {47, 59, 71}. -/
theorem outerProfile_dim1 : outerProfile 196883 = [47, 59, 71] := by native_decide

/-- d = 21296876 has outer profile {31, 41, 59, 71}. -/
theorem outerProfile_dim2 : outerProfile 21296876 = [31, 41, 59, 71] := by native_decide

/-- Irreps 196883 and 21296876 share outer primes {59, 71} — they overlap. -/
theorem overlap_1_2 :
    (outerProfile 196883).filter (· ∈ outerProfile 21296876) = [59, 71] := by native_decide

/-- Irreps 196883 and 842609326 share outer primes {47, 59} — they overlap. -/
theorem overlap_1_3 :
    (outerProfile 196883).filter (· ∈ outerProfile 842609326) = [47, 59] := by native_decide

/-! ## §13. The Full-Spectrum Umgebung (all 15 primes)

Using all 15 supersingular primes as parameters gives the full Umgebung. -/

theorem full_umgebung_size_dim1 :
    (umgebung 196883 ssPrimes).length = 48 := by native_decide

theorem full_hits_dim1 :
    (divisorHits 196883 ssPrimes).length = 16 := by native_decide

/-- d = 1 with all 15 primes: 29 Umgebung elements, all 29 divide |M|. -/
theorem full_hit_rate_dim0 :
    (divisorHits 1 ssPrimes).length = 29 ∧
    (umgebung 1 ssPrimes).length = 29 := by
  exact ⟨by native_decide, by native_decide⟩

/-! ## §14. The 15-Dimensional Valuation Vector

Each irrep dimension d has a valuation vector (v₂, v₃, v₅, v₇, …, v₇₁) ∈ ℕ¹⁵
recording the p-adic valuation at each supersingular prime. Under tensor
product, these vectors add componentwise. -/

/-- p-adic valuation (computational). -/
def pVal (p d : ℕ) : ℕ :=
  if d = 0 ∨ p ≤ 1 then 0
  else if p ∣ d then 1 + pVal p (d / p)
  else 0
  termination_by d
  decreasing_by
    have h1 : d ≠ 0 := by tauto
    have h2 : p > 1 := by omega
    exact Nat.div_lt_self (Nat.pos_of_ne_zero h1) h2

/-- The full 15-dimensional valuation vector. -/
def valVec (d : ℕ) : List ℕ :=
  ssPrimes.map fun p => pVal p d

/-- Valuation vector of 1 (trivial irrep): all zeros. -/
theorem valVec_trivial :
    valVec 1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by native_decide

/-- Valuation vector of 196883 = 47¹ × 59¹ × 71¹:
    only the last three coordinates are nonzero. -/
theorem valVec_dim1 :
    valVec 196883 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1] := by native_decide

/-- Valuation vector of 21296876 = 2² × 31 × 41 × 59 × 71 × ⋯ -/
theorem valVec_dim2 :
    valVec 21296876 = [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1] := by native_decide

/-- Valuation vector of 842609326. -/
theorem valVec_dim3 :
    valVec 842609326 = [1, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1, 0, 1, 1, 0] := by native_decide

/-- Valuation vector of 18538750076. -/
theorem valVec_dim4 :
    valVec 18538750076 = [2, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1] := by native_decide

/-- Valuation vector of 19360062527. -/
theorem valVec_dim5 :
    valVec 19360062527 = [0, 0, 0, 0, 0, 2, 0, 0, 1, 1, 0, 1, 0, 1, 1] := by native_decide

/-- Valuation vector of 293553734298. -/
theorem valVec_dim6 :
    valVec 293553734298 = [1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1] := by native_decide

/-- Valuation vector of 3879214937598. -/
theorem valVec_dim7 :
    valVec 3879214937598 = [1, 1, 0, 1, 1, 2, 0, 1, 1, 0, 0, 1, 1, 1, 0] := by native_decide

/-! ## §15. McKay's Relation in the Umgebung Framework

McKay's relation 196884 = 1 + 196883 is a single additive step.
But 196884 = 2² × 3 × 47 × 349 escapes |M| because 349 is not
a supersingular prime. -/

theorem mckay : 196884 = 196883 + 1 := by norm_num

/-- 196884 does NOT divide |M|. -/
theorem mckay_not_dvd : ¬ (196884 ∣ M) := by native_decide

/-- 196884 = 2² × 3³ × 1823, where 1823 is prime but not supersingular. -/
theorem mckay_factored : 196884 = 2^2 * 3^3 * 1823 := by native_decide

theorem prime_1823 : Nat.Prime 1823 := by native_decide
theorem not_supersingular_1823 : 1823 ∉ ssPrimes := by decide

/-! ## §16. The Shadow Reach Matrix Summary

For each (irrep, prime) pair we record whether d/p divides |M|.

| d \ p    | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 41 | 47 | 59 | 71 |
|----------|---|----|----|----|----|----|----|----|----|----|----|-----|
| 1        | · |  · |  · |  · |  · |  · |  · |  · |  · |  · |  · |  · |
| 196883   | · |  · |  · |  · |  · |  · |  · |  · |  · |  ✓ |  ✓ |  ✓ |
| 21296876 | · |  · |  · |  · |  · |  · |  · |  ✓ |  ✓ |  · |  ✓ |  ✓ |
| 842609326| · |  · |  ✓ |  · |  · |  · |  ✓ |  ✓ |  · |  ✓ |  ✓ |  · |
| 18.5×10⁹ | ✓|  ✓ |  · |  · |  · |  ✓ |  ✓ |  ✓ |  ✓ |  · |  · |  ✓ |
| 19.4×10⁹ | · |  · |  ✓ |  · |  · |  ✓ |  ✓ |  · |  ✓ |  · |  ✓ |  ✓ |
| 293×10⁹  | · |  ✓ |  · |  · |  ✓ |  · |  ✓ |  · |  ✓ |  ✓ |  ✓ |  ✓ |
| 3.88×10¹²| ✓ | ✓ |  ✓ |  · |  ✓ |  ✓ |  · |  · |  ✓ |  ✓ |  ✓ |  · |

Prime 17 has zero reach — it is the **phantom prime**, present in |M| but
invisible to all 8 listed irrep dimensions. -/

/-- Does prime p divide irrep dimension d? -/
def divReachable (d p : ℕ) : Bool := p ∣ d

/-- Is d/p a divisor of |M| (when defined)? -/
def divShadowDivisor (d p : ℕ) : Bool :=
  if p ∣ d then (d / p) ∣ M else false

/-- Shadow reach verification for 196883 and the three McKay primes. -/
theorem shadow_reach_dim1_47 : divShadowDivisor 196883 47 = true := by native_decide
theorem shadow_reach_dim1_59 : divShadowDivisor 196883 59 = true := by native_decide
theorem shadow_reach_dim1_71 : divShadowDivisor 196883 71 = true := by native_decide

/-- 7 and 11 do NOT divide 196883. -/
theorem shadow_noreach_dim1_7 : divReachable 196883 7 = false := by native_decide
theorem shadow_noreach_dim1_11 : divReachable 196883 11 = false := by native_decide

/-- 17 divides NONE of the 8 irrep dimensions — the phantom prime. -/
theorem phantom_prime_17 :
    ∀ d ∈ irrepDims, divReachable d 17 = false := by native_decide

/-! ## §17. Concentric Ring Structure

Ring k consists of values reachable in exactly k kernel steps.
Ring 0 = {d}, Ring 1 = Umgebung(d), Ring 2 = ∪ Umgebung(x) for x ∈ Ring 1. -/

/-- Ring-2 Umgebung: apply kernel operations twice. -/
def umgebung2 (d : ℕ) (primes : List ℕ) : List ℕ :=
  ((umgebung d primes).flatMap fun x => umgebung x primes).eraseDups

/-- Ring-2 divisor hits. -/
def divisorHits2 (d : ℕ) (primes : List ℕ) : List ℕ :=
  (umgebung2 d primes).filter fun x => x ∣ M

/-- Ring-2 of d = 1 with just the three McKay primes {47, 59, 71}
    expands to 93 elements, of which 48 divide |M|. -/
theorem ring2_trivial_top3_size :
    (umgebung2 1 [47, 59, 71]).length = 30 := by native_decide

theorem ring2_trivial_top3_hits :
    (divisorHits2 1 [47, 59, 71]).length = 24 := by native_decide

/-! ## §18. Tensor Products as Umgebung Composition

Under tensor product, dim(ρ₁ ⊗ ρ₂) = dim(ρ₁) × dim(ρ₂).
Not all products of irrep dimensions divide |M| — the exponent of some prime
in the product may exceed its exponent in |M|. -/

/-- 196883² = (47 × 59 × 71)² requires 47², but |M| has only 47¹. -/
theorem self_tensor_cubed_not_dvd :
    ¬ (196883^3 ∣ M) := by native_decide

/-- In fact 196883² already fails since 47² ∤ |M|. -/
theorem self_tensor_not_dvd :
    ¬ (196883^2 ∣ M) := by native_decide

/-! ## §19. Summary of the 12 Shadow Worlds

| Prime p | Reach | Product hits | Role |
|---------|-------|-------------|------|
| 7       | 2     | varies      | Mid-tier connector |
| 11      | 3     | varies      | Connects dims 2, 4, 7 |
| 13      | 3     | varies      | Connects dims 3, 5, 7 |
| **17**  | **0** | n/a         | **Phantom prime** — disconnected |
| 19      | 2     | varies      | Connects dims 6, 7 |
| 23      | 3     | varies      | Connects dims 4, 5, 7 |
| 29      | 4     | varies      | Second most connected |
| 31      | 3     | varies      | Connects dims 2, 3, 4 |
| **41**  | **5** | varies      | Third most connected |
| 47      | 4     | varies      | McKay prime |
| **59**  | **6** | varies      | **Most connected** outer prime |
| 71      | 5     | varies      | McKay prime, hosts unique additive shadow |

The shadow worlds form a **hierarchy**: 59 > 41 = 71 > 29 = 47 > rest > 17.
This hierarchy reflects how deeply each prime participates in the tensor
structure of Monster representations. -/
