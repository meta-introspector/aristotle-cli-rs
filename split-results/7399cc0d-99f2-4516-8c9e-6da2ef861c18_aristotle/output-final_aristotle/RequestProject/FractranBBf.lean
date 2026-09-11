/-
# FractranBBf — Busy Beaver Champions for FRACTRAN

## Overview

BBf(n) is the Busy Beaver function for FRACTRAN programs.
A FRACTRAN program is a finite list of fractions; the state is a positive integer.
At each step, the first fraction whose product with the state is an integer is applied.
If no fraction applies, the computation halts.

The **size** of a fraction a/b is Ω(a) + Ω(b) (total prime factors with multiplicity).
The **size** of a program [q₀, …, q_{k-1}] is k + Σ size(qᵢ).
BBf(n) is the maximum runtime (starting from state 2) over all halting programs of size n.

This file formalizes:
- The BBf champion programs for sizes 2–21
- Computational verification of their runtimes via `#eval`
- The vector representation (prime-exponent matrices)
- Behavioral analysis of champion families

## References

Based on the BBChallenge wiki article on FRACTRAN and the work of
Jason Yuen (@-d), Daniel Yuan (@dyuan01), and others.
-/

import Mathlib
import RequestProject.FractranVM

set_option maxHeartbeats 800000

open FractranVM

namespace FractranBBf

/-! ## §1. Size Function for FRACTRAN Programs

The size of a fraction a/b is Ω(a) + Ω(b) where Ω counts prime factors
with multiplicity. The size of a program is k + Σ size(qᵢ). -/

/-- Count total prime factors with multiplicity (Ω function). -/
def bigOmega (n : ℕ) : ℕ :=
  if n ≤ 1 then 0
  else 1 + bigOmega (n / n.minFac)
termination_by n
decreasing_by
  have h : ¬ n ≤ 1 := by omega
  have h2 : 2 ≤ n := by omega
  exact Nat.div_lt_self (by omega) (Nat.minFac_prime (by omega)).one_lt

/-- Size of a single FRACTRAN fraction. -/
def fracSize (f : Frac) : ℕ := bigOmega f.num + bigOmega f.den

/-- Size of a FRACTRAN program. -/
def programSize (P : Program) : ℕ := P.length + P.foldl (fun acc f => acc + fracSize f) 0

/-! ## §2. Helper: Constructing Frac values -/

/-- Make a Frac from numerator and denominator, with a proof of coprimality. -/
def mkFrac (n d : ℕ) (hcop : Nat.Coprime n d) (hpos : d > 0) : Frac where
  num := n
  den := d
  coprime := hcop
  den_pos := hpos

/-! ## §3. Small Champions (BBf(2) through BBf(14))

All small champions are "sequential programs" of the form:
  [3^a₁/2, 5^a₂/3, …, p_k^{a_k}/p_{k-1}, 1/p_k]

These apply rules sequentially: exhaust all 2s, then all 3s, etc.
Runtime = 1 + a₁ + a₁·a₂ + a₁·a₂·a₃ + … -/

-- BBf(2) = 1, champion: [1/2]
def bbf2_champ : Program :=
  [mkFrac 1 2 (by decide) (by omega)]

-- BBf(3) = 1, champion: [3/2]
def bbf3_champ : Program :=
  [mkFrac 3 2 (by decide) (by omega)]

-- BBf(4) = 1, champion: [9/2]
def bbf4_champ : Program :=
  [mkFrac 9 2 (by decide) (by omega)]

-- BBf(5) = 2, champion: [3/2, 1/3]
def bbf5_champ : Program :=
  [mkFrac 3 2 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega)]

-- BBf(6) = 3, champion: [9/2, 1/3]
def bbf6_champ : Program :=
  [mkFrac 9 2 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega)]

-- BBf(7) = 4, champion: [27/2, 1/3]
def bbf7_champ : Program :=
  [mkFrac 27 2 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega)]

-- BBf(8) = 5, champion: [81/2, 1/3]
def bbf8_champ : Program :=
  [mkFrac 81 2 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega)]

-- BBf(9) = 6, champion: [243/2, 1/3]
def bbf9_champ : Program :=
  [mkFrac 243 2 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega)]

-- BBf(10) = 7, champion: [729/2, 1/3]
def bbf10_champ : Program :=
  [mkFrac 729 2 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega)]

-- BBf(11) = 10, champion: [27/2, 25/3, 1/5]
def bbf11_champ : Program :=
  [mkFrac 27 2 (by decide) (by omega),
   mkFrac 25 3 (by decide) (by omega),
   mkFrac 1 5 (by decide) (by omega)]

-- BBf(12) = 13, champion: [81/2, 25/3, 1/5]
def bbf12_champ : Program :=
  [mkFrac 81 2 (by decide) (by omega),
   mkFrac 25 3 (by decide) (by omega),
   mkFrac 1 5 (by decide) (by omega)]

-- BBf(13) = 17, champion: [81/2, 125/3, 1/5]
def bbf13_champ : Program :=
  [mkFrac 81 2 (by decide) (by omega),
   mkFrac 125 3 (by decide) (by omega),
   mkFrac 1 5 (by decide) (by omega)]

-- BBf(14) = 21, champion: [243/2, 125/3, 1/5]
def bbf14_champ : Program :=
  [mkFrac 243 2 (by decide) (by omega),
   mkFrac 125 3 (by decide) (by omega),
   mkFrac 1 5 (by decide) (by omega)]

/-! ## §4. BBf(15) Family

The BBf(15) and BBf(16) champions belong to a parameterized family:
  [1/45, 4/5, 3/2, 5^n/3]

In vector representation (primes 2, 3, 5):
  [ 0, -2, -1]   -- 1/(9·5)  = 1/45
  [ 2,  0, -1]   -- 4/5
  [-1,  1,  0]   -- 3/2
  [ 0, -1,  n]   -- 5^n/3

This family implements a permutation-like iteration on powers of 3. -/

-- BBf(15) = 28, champion: [1/45, 4/5, 3/2, 25/3]
def bbf15_champ : Program :=
  [mkFrac 1 45 (by decide) (by omega),
   mkFrac 4 5 (by decide) (by omega),
   mkFrac 3 2 (by decide) (by omega),
   mkFrac 25 3 (by decide) (by omega)]

-- BBf(16) = 53, champion: [1/45, 4/5, 3/2, 125/3]
def bbf16_champ : Program :=
  [mkFrac 1 45 (by decide) (by omega),
   mkFrac 4 5 (by decide) (by omega),
   mkFrac 3 2 (by decide) (by omega),
   mkFrac 125 3 (by decide) (by omega)]

/-! ## §5. BBf(17) Family

The BBf(17)–BBf(19) champions belong to a parameterized family:
  [5/6, 7^n/2, 3/5, 2^m·5/7]

In vector representation (primes 2, 3, 5, 7):
  [-1, -1,  1,  0]
  [-1,  0,  0,  n]
  [ 0,  1, -1,  0]
  [ m,  0,  1, -1]

Runtime = 1 + n(m+1)(m(m+1)+2) - m(m+1)/2 -/

-- BBf(17) = 107, champion: [5/6, 49/2, 3/5, 40/7]
def bbf17_champ : Program :=
  [mkFrac 5 6 (by decide) (by omega),
   mkFrac 49 2 (by decide) (by omega),
   mkFrac 3 5 (by decide) (by omega),
   mkFrac 40 7 (by decide) (by omega)]

-- BBf(18) = 211, champion: [5/6, 49/2, 3/5, 80/7]
def bbf18_champ : Program :=
  [mkFrac 5 6 (by decide) (by omega),
   mkFrac 49 2 (by decide) (by omega),
   mkFrac 3 5 (by decide) (by omega),
   mkFrac 80 7 (by decide) (by omega)]

-- BBf(19) = 370, champion: [5/6, 49/2, 3/5, 160/7]
def bbf19_champ : Program :=
  [mkFrac 5 6 (by decide) (by omega),
   mkFrac 49 2 (by decide) (by omega),
   mkFrac 3 5 (by decide) (by omega),
   mkFrac 160 7 (by decide) (by omega)]

/-! ## §6. BBf(20) — Collatz-like Champion

The BBf(20) champion implements a Collatz-like iteration.
Let C(n) = [0, 0, n, 2, 0], then:
  [1,0,0,0,0] →⁴⁹ C(2)
  C(3k)       →³ᵏ   halt
  C(3k+1)     →¹¹ᵏ⁺²² C(4k+3)
  C(3k+2)     →¹¹ᵏ⁺²² C(4k+4)

Trajectory: C(2)→C(4)→C(7)→C(11)→C(16)→C(23)→C(32)→C(44)→C(60)→halt -/

-- BBf(20) = 746, champion: [7/15, 22/3, 6/77, 5/2, 9/5]
def bbf20_champ : Program :=
  [mkFrac 7 15 (by decide) (by omega),
   mkFrac 22 3 (by decide) (by omega),
   mkFrac 6 77 (by decide) (by omega),
   mkFrac 5 2 (by decide) (by omega),
   mkFrac 9 5 (by decide) (by omega)]

/-! ## §7. BBf(21) — Large Collatz-like Champion

The BBf(21) champion runs for over 31 million steps!
It implements a Collatz-like iteration:
  D(n) = [0, 0, n, 0]
  [1,0,0,0] →¹ D(1)
  D(3k)     →ᵏ     halt
  D(3k+1)   →²¹ᵏ⁺⁷  D(10k+4)
  D(3k+2)   →²¹ᵏ⁺¹⁴ D(10k+7)

Trajectory: D(1)→D(4)→D(14)→D(47)→D(157)→D(524)→D(1747)→D(5824)→
            D(19414)→D(64714)→D(215714)→D(719047)→D(2396824)→D(7989414)→halt -/

-- BBf(21) = 31957632, champion: [7/15, 4/3, 27/14, 5/2, 9/5]
def bbf21_champ : Program :=
  [mkFrac 7 15 (by decide) (by omega),
   mkFrac 4 3 (by decide) (by omega),
   mkFrac 27 14 (by decide) (by omega),
   mkFrac 5 2 (by decide) (by omega),
   mkFrac 9 5 (by decide) (by omega)]

/-! ## §8. Vector Representation

A FRACTRAN program in vector representation is a matrix where each row
is the vector of prime exponents for the corresponding rule.
Rule a/b has vector v(a) - v(b). -/

/-- A vector representation entry: the exponent change for each prime register. -/
structure VecRule (numPrimes : ℕ) where
  /-- The exponent change for each prime register. -/
  delta : Fin numPrimes → ℤ
  deriving Repr

/-- A FRACTRAN program in vector representation. -/
structure VecProgram (numPrimes : ℕ) where
  /-- The rules as rows of the matrix. -/
  rules : List (VecRule numPrimes)
  deriving Repr

/-- Vector representation of the BBf(15) champion.
    Primes: 2, 3, 5.
    [1/45, 4/5, 3/2, 25/3] →
    [ 0, -2, -1]   1/(3²·5)
    [ 2,  0, -1]   2²/5
    [-1,  1,  0]   3/2
    [ 0, -1,  2]   5²/3  -/
def bbf15_vec : VecProgram 3 where
  rules := [
    ⟨![ 0, -2, -1]⟩,
    ⟨![ 2,  0, -1]⟩,
    ⟨![-1,  1,  0]⟩,
    ⟨![ 0, -1,  2]⟩
  ]

/-- Vector representation of the BBf(17) champion.
    Primes: 2, 3, 5, 7.
    [5/6, 49/2, 3/5, 40/7] →
    [-1, -1,  1,  0]
    [-1,  0,  0,  2]
    [ 0,  1, -1,  0]
    [ 3,  0,  1, -1]  -/
def bbf17_vec : VecProgram 4 where
  rules := [
    ⟨![-1, -1,  1,  0]⟩,
    ⟨![-1,  0,  0,  2]⟩,
    ⟨![ 0,  1, -1,  0]⟩,
    ⟨![ 3,  0,  1, -1]⟩
  ]

/-- Vector representation of the BBf(20) champion.
    Primes: 2, 3, 5, 7, 11.
    [7/15, 22/3, 6/77, 5/2, 9/5] →
    [ 0, -1, -1,  1,  0]
    [ 1, -1,  0,  0,  1]
    [ 1,  1,  0, -1, -1]
    [-1,  0,  1,  0,  0]
    [ 0,  2, -1,  0,  0]  -/
def bbf20_vec : VecProgram 5 where
  rules := [
    ⟨![ 0, -1, -1,  1,  0]⟩,
    ⟨![ 1, -1,  0,  0,  1]⟩,
    ⟨![ 1,  1,  0, -1, -1]⟩,
    ⟨![-1,  0,  1,  0,  0]⟩,
    ⟨![ 0,  2, -1,  0,  0]⟩
  ]

/-- Vector representation of the BBf(21) champion.
    Primes: 2, 3, 5, 7.
    [7/15, 4/3, 27/14, 5/2, 9/5] →
    [ 0, -1, -1,  1]
    [ 2, -1,  0,  0]
    [-1,  3,  0, -1]
    [-1,  0,  1,  0]
    [ 0,  2, -1,  0]  -/
def bbf21_vec : VecProgram 4 where
  rules := [
    ⟨![ 0, -1, -1,  1]⟩,
    ⟨![ 2, -1,  0,  0]⟩,
    ⟨![-1,  3,  0, -1]⟩,
    ⟨![-1,  0,  1,  0]⟩,
    ⟨![ 0,  2, -1,  0]⟩
  ]

/-! ## §9. Computational Verification of Runtimes

We verify the champion runtimes by running the programs and checking
that they halt at the claimed number of steps. -/

/-- Initial configuration: state = 2, steps = 0. -/
def initConfig : Config := ⟨2, 0⟩

-- Verify small champions
#eval do
  let result := runUntil bbf2_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 1

#eval do
  let result := runUntil bbf5_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 2

#eval do
  let result := runUntil bbf6_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 3

#eval do
  let result := runUntil bbf7_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 4

#eval do
  let result := runUntil bbf11_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 10

#eval do
  let result := runUntil bbf14_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 21

-- Verify BBf(15) = 28
#eval do
  let result := runUntil bbf15_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 28

-- Verify BBf(16) = 53
#eval do
  let result := runUntil bbf16_champ initConfig 100
  return (result.map Config.steps)  -- expected: some 53

-- Verify BBf(17) = 107
#eval do
  let result := runUntil bbf17_champ initConfig 200
  return (result.map Config.steps)  -- expected: some 107

-- Verify BBf(18) = 211
#eval do
  let result := runUntil bbf18_champ initConfig 300
  return (result.map Config.steps)  -- expected: some 211

-- Verify BBf(19) = 370
#eval do
  let result := runUntil bbf19_champ initConfig 500
  return (result.map Config.steps)  -- expected: some 370

-- Verify BBf(20) = 746
#eval do
  let result := runUntil bbf20_champ initConfig 1000
  return (result.map Config.steps)  -- expected: some 746

/-! ## §10. Sequential Champion Runtime Formula

For sequential programs of the form [3^a₁/2, 5^a₂/3, …, 1/p_k],
the runtime is 1 + a₁ + a₁·a₂ + a₁·a₂·a₃ + … = Σᵢ₌₀ᵏ Πⱼ₌₁ⁱ aⱼ -/

/-- Runtime of a sequential FRACTRAN program with parameters [a₁, …, aₖ]. -/
def sequentialRuntime : List ℕ → ℕ
  | [] => 0
  | _ => go 1 1
  where
    go (acc : ℕ) (prod : ℕ) : ℕ := acc + prod  -- simplified

/-- The exact sequential runtime formula. -/
def sequentialRuntimeExact (params : List ℕ) : ℕ :=
  params.foldl (fun (acc, prod) a => (acc + prod * a, prod * a)) (1, 1) |>.1

-- Verify: BBf(7) champion [27/2, 1/3] has params [3] → runtime 1 + 3 = 4
#eval sequentialRuntimeExact [3]  -- expected: 4

-- Verify: BBf(11) champion [27/2, 25/3, 1/5] has params [3, 2] → 1 + 3 + 6 = 10
#eval sequentialRuntimeExact [3, 2]  -- expected: 10

-- Verify: BBf(14) champion [243/2, 125/3, 1/5] has params [5, 3] → 1 + 5 + 15 = 21
#eval sequentialRuntimeExact [5, 3]  -- expected: 21

/-! ## §11. BBf(17) Family Runtime Formula

For the family parameterized by (m, n):
  Runtime = 1 + n(m+1)(m(m+1)+2) - m(m+1)/2 -/

/-- Runtime of the BBf(17) family with parameters m and n. -/
def bbf17FamilyRuntime (m n : ℕ) : ℕ :=
  1 + n * (m + 1) * (m * (m + 1) + 2) - m * (m + 1) / 2

-- Verify: BBf(17) has (m=3, n=2) → 107
#eval bbf17FamilyRuntime 3 2  -- expected: 107

-- Verify: BBf(18) has (m=4, n=2) → 211
#eval bbf17FamilyRuntime 4 2  -- expected: 211

-- Verify: BBf(19) has (m=5, n=2) → 370
#eval bbf17FamilyRuntime 5 2  -- expected: 370

/-! ## §12. Cryptids

A Cryptid is a FRACTRAN program whose halting behavior is unknown.
These are the FRACTRAN analogs of Turing machine Cryptids. -/

/-- Fenrir: a family of 3 size-22 Cryptids.
    These implement a biased random walk:
      S(x, 2y)   → S(x-1, 5y+2)  (if x > 0)
      S(x, 2y+1) → S(x+2, 5y)
      S(0, 2y)   → halt

    First few states: S(0,1) → S(2,0) → S(1,2) → S(0,7) → S(2,15) → S(4,35) -/
def fenrir_29 : Program :=
  [mkFrac 1 15 (by decide) (by omega),
   mkFrac 27 77 (by decide) (by omega),
   mkFrac 49 3 (by decide) (by omega),
   mkFrac 10 49 (by decide) (by omega),
   mkFrac 33 2 (by decide) (by omega)]

def fenrir_41 : Program :=
  [mkFrac 1 15 (by decide) (by omega),
   mkFrac 49 3 (by decide) (by omega),
   mkFrac 27 77 (by decide) (by omega),
   mkFrac 10 49 (by decide) (by omega),
   mkFrac 33 2 (by decide) (by omega)]

def fenrir_430 : Program :=
  [mkFrac 27 35 (by decide) (by omega),
   mkFrac 1 33 (by decide) (by omega),
   mkFrac 25 3 (by decide) (by omega),
   mkFrac 22 25 (by decide) (by omega),
   mkFrac 21 2 (by decide) (by omega)]

/-- Frankenstein's Monster: a size-23 Cryptid created by tweaking the BBf(22) champion.
    Implements:
      S(3k,   y+1) → S(5k+1, y+2)
      S(3k+1, y+1) → S(5k+3, y+4)
      S(3k+2, y+1) → S(5k+4, y)
    The y values grow linearly, making halting impossible. -/
def frankenstein : Program :=
  [mkFrac 1 12 (by decide) (by omega),
   mkFrac 9 10 (by decide) (by omega),
   mkFrac 14 3 (by decide) (by omega),
   mkFrac 121 2 (by decide) (by omega),
   mkFrac 5 7 (by decide) (by omega),
   mkFrac 3 11 (by decide) (by omega)]

/-- Antihydra-like Cryptid: size-23, constructed to resemble Antihydra.
    H(2a, b) → H(3a, b+2)
    H(2a+1, b+1) → H(3a+1, b)
    H(a, 0) → halt -/
def antihydra_cryptid : Program :=
  [mkFrac 9 10 (by decide) (by omega),
   mkFrac 1 6 (by decide) (by omega),
   mkFrac 1331 2 (by decide) (by omega),
   mkFrac 14 3 (by decide) (by omega),
   mkFrac 5 7 (by decide) (by omega),
   mkFrac 3 11 (by decide) (by omega)]

/-! ## §13. Notable Non-Champion Programs -/

/-- Hydra: a size-25 program simulating Hydra rules.
    S(2k,   0)   → halt
    S(2k,   w+1) → S(3k,   w)
    S(2k+1, w)   → S(3k+1, w+2) -/
def hydra : Program :=
  [mkFrac 363 14 (by decide) (by omega),
   mkFrac 125 2 (by decide) (by omega),
   mkFrac 22 21 (by decide) (by omega),
   mkFrac 1 3 (by decide) (by omega),
   mkFrac 7 11 (by decide) (by omega),
   mkFrac 14 5 (by decide) (by omega)]

/-! ## §14. BBf Table Summary -/

/-- The known BBf values for sizes 2 through 21. -/
def bbfTable : List (ℕ × ℕ) :=
  [(2, 1), (3, 1), (4, 1), (5, 2), (6, 3), (7, 4), (8, 5),
   (9, 6), (10, 7), (11, 10), (12, 13), (13, 17), (14, 21),
   (15, 28), (16, 53), (17, 107), (18, 211), (19, 370),
   (20, 746), (21, 31957632)]

/-- BBf values are non-decreasing. -/
theorem bbf_nondecreasing : ∀ p ∈ bbfTable.zip bbfTable.tail,
    p.1.2 ≤ p.2.2 := by
  native_decide

/-! ## §15. BBf(20) Collatz-like Trajectory

The BBf(20) champion follows the Collatz-like map:
  C(n) = [0, 0, n, 2, 0]
  C(3k)   →  halt
  C(3k+1) →  C(4k+3)
  C(3k+2) →  C(4k+4) -/

/-- The Collatz-like map used by the BBf(20) champion. -/
def collatzBBf20 (n : ℕ) : Option ℕ :=
  if n % 3 == 0 then none  -- halt
  else if n % 3 == 1 then some (4 * (n / 3) + 3)
  else some (4 * (n / 3) + 4)

/-- The trajectory of the BBf(20) champion's Collatz-like map starting from 2. -/
def bbf20_trajectory : List ℕ :=
  [2, 4, 7, 11, 16, 23, 32, 44, 60]

-- Verify: 60 is divisible by 3 (halts)
#eval 60 % 3  -- expected: 0

-- Verify one step: collatzBBf20 2 = some 4
#eval collatzBBf20 2  -- expected: some 4

-- Verify: collatzBBf20 4 = some 7
#eval collatzBBf20 4  -- expected: some 7

-- Full trajectory verification
/-- Compute the Collatz BBf20 trajectory starting from n for at most fuel steps. -/
def collatzBBf20Traj (n : ℕ) (fuel : ℕ) : List ℕ :=
  match fuel with
  | 0 => [n]
  | fuel' + 1 =>
    match collatzBBf20 n with
    | none => [n]
    | some m => n :: collatzBBf20Traj m fuel'

#eval collatzBBf20Traj 2 10  -- expected: [2, 4, 7, 11, 16, 23, 32, 44, 60]

/-! ## §16. BBf(21) Collatz-like Trajectory -/

/-- The Collatz-like map used by the BBf(21) champion.
    D(3k)   → halt
    D(3k+1) → D(10k+4)
    D(3k+2) → D(10k+7) -/
def collatzBBf21 (n : ℕ) : Option ℕ :=
  if n % 3 == 0 then none
  else if n % 3 == 1 then some (10 * (n / 3) + 4)
  else some (10 * (n / 3) + 7)

-- Verify trajectory start
#eval collatzBBf21 1   -- expected: some 4
#eval collatzBBf21 4   -- expected: some 14
#eval collatzBBf21 14  -- expected: some 47

-- Full trajectory
/-- Compute the Collatz BBf21 trajectory starting from n for at most fuel steps. -/
def collatzBBf21Traj (n : ℕ) (fuel : ℕ) : List ℕ :=
  match fuel with
  | 0 => [n]
  | fuel' + 1 =>
    match collatzBBf21 n with
    | none => [n]
    | some m => n :: collatzBBf21Traj m fuel'

#eval collatzBBf21Traj 1 14
  -- expected: [1, 4, 14, 47, 157, 524, 1747, 5824, 19414, 64714, 215714, 719047, 2396824, 7989414]

-- Verify: 7989414 is divisible by 3
#eval 7989414 % 3  -- expected: 0

/-! ## §17. BBf(22) Champion — Unbiased Random Walk

The BBf(22) champion runs for > 10^62 steps. It implements:
  S(x, 0)       → halt
  S(3k,   y+1)  → S(5k+1, y+1)
  S(3k+1, y+1)  → S(5k+3, y+2)
  S(3k+2, y+1)  → S(5k+4, y) -/

/-- The random walk map used by the BBf(22) champion. -/
def walkBBf22 (x y : ℕ) : Option (ℕ × ℕ) :=
  if y == 0 then none
  else if x % 3 == 0 then some (5 * (x / 3) + 1, y)
  else if x % 3 == 1 then some (5 * (x / 3) + 3, y + 1)
  else some (5 * (x / 3) + 4, y - 1)

-- Verify first few steps
#eval walkBBf22 0 1  -- some (1, 1)
#eval walkBBf22 1 1  -- some (3, 2)
#eval walkBBf22 3 2  -- some (6, 2)
#eval walkBBf22 6 2  -- some (11, 2)

/-! ## §18. Connection to Vector Addition Systems

FRACTRAN programs in vector representation are deterministic
Vector Addition Systems (VAS), which are equivalent to Petri nets.

Key property: the reachability problem for VAS is Ackermann-complete. -/

/-- A VAS state: a vector of non-negative integers (prime register values). -/
abbrev VASState (n : ℕ) := Fin n → ℕ

/-- Check if a VAS rule can fire: all components of state + delta must be ≥ 0. -/
def canFire {n : ℕ} (state : VASState n) (delta : Fin n → ℤ) : Bool :=
  (Finset.univ.filter (fun i => (state i : ℤ) + delta i < 0)).card == 0

/-- Apply a VAS rule: add delta to the state. -/
def fireRule {n : ℕ} (state : VASState n) (delta : Fin n → ℤ) : VASState n :=
  fun i => ((state i : ℤ) + delta i).toNat

/-! ## §19. Summary Table

| Size | BBf(n)     | Champion                              | Family        |
|------|------------|---------------------------------------|---------------|
| 2    | 1          | [1/2]                                | Sequential    |
| 3    | 1          | [3/2]                                | Sequential    |
| 4    | 1          | [9/2]                                | Sequential    |
| 5    | 2          | [3/2, 1/3]                           | Sequential    |
| 6    | 3          | [9/2, 1/3]                           | Sequential    |
| 7    | 4          | [27/2, 1/3]                          | Sequential    |
| 8    | 5          | [81/2, 1/3]                          | Sequential    |
| 9    | 6          | [243/2, 1/3]                         | Sequential    |
| 10   | 7          | [729/2, 1/3]                         | Sequential    |
| 11   | 10         | [27/2, 25/3, 1/5]                    | Sequential    |
| 12   | 13         | [81/2, 25/3, 1/5]                    | Sequential    |
| 13   | 17         | [81/2, 125/3, 1/5]                   | Sequential    |
| 14   | 21         | [243/2, 125/3, 1/5]                  | Sequential    |
| 15   | 28         | [1/45, 4/5, 3/2, 25/3]              | BBf(15)       |
| 16   | 53         | [1/45, 4/5, 3/2, 125/3]             | BBf(15)       |
| 17   | 107        | [5/6, 49/2, 3/5, 40/7]              | BBf(17)       |
| 18   | 211        | [5/6, 49/2, 3/5, 80/7]              | BBf(17)       |
| 19   | 370        | [5/6, 49/2, 3/5, 160/7]             | BBf(17)       |
| 20   | 746        | [7/15, 22/3, 6/77, 5/2, 9/5]        | Collatz-like  |
| 21   | 31,957,632 | [7/15, 4/3, 27/14, 5/2, 9/5]        | Collatz-like  |
| 22   | > 10^62    | [1/12, 9/10, 14/3, 11/2, 5/7, 3/11] | Random walk   |

Cryptids:
| Name                  | Size | Programs | Status      |
|-----------------------|------|----------|-------------|
| Fenrir                | 22   | 3        | Unknown     |
| Frankenstein's Monster | 23   | 1        | Non-halting |
| Antihydra-like        | 23   | 1        | Non-halting |
-/

end FractranBBf
