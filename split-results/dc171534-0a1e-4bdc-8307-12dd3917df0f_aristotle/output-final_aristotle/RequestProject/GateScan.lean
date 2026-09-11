/-
# GateScan — Scanning All Numbers < 512 for Quasifibration Significance

Why just 263?  Every number n < 512 carries a **gate signature** in the
Monster–CRT system: its primality, coprimality to 196883 = 47 × 59 × 71,
Bott periodicity class (n mod 8), CRT residues (mod 47, mod 59, mod 71),
supersingular status, muse-prime resonance, and Q42 alignment (n ≡ 42 mod 59).

This file systematically scans 1 … 511, extracts every meaningful
subsequence, proves their key properties, and arranges them as an
**OEIS-like catalogue of sequences** derived from the quasifibration system.

## Sequences Extracted

| ID  | Name                      | Length | Description                                              |
|-----|---------------------------|--------|----------------------------------------------------------|
| S₁  | `coprime196883`           | 486    | Numbers 1–511 coprime to 196883                          |
| S₂  | `nonCoprime196883`        | 25     | Numbers 1–511 sharing a factor with 196883               |
| S₃  | `gatePrimes`              | 94     | Primes < 512 coprime to 196883 (gate candidates)         |
| S₄  | `bottClass7Gates`         | 24     | Gate primes ≡ 7 (mod 8) — "departure class" gates        |
| S₅  | `bottClass1Gates`         | 20     | Gate primes ≡ 1 (mod 8) — totally split gates            |
| S₆  | `q42Numbers`              | 8      | Numbers 1–511 with n ≡ 42 (mod 59)                       |
| S₇  | `q42Primes`               | 2      | Primes < 512 with n ≡ 42 (mod 59)                        |
| S₈  | `stealthHoles`            | 7      | Numbers 1–511 with 71 ∣ n                                |
| S₉  | `supersingularBelow512`   | 15     | All 15 supersingular primes (all < 512)                   |
| S₁₀ | `museGatePrimes`          | 8      | The 8 muse primes (all are gate primes)                   |
| S₁₁ | `resonantGates`           | 39     | Gate primes with a muse-prime CRT residue                 |
| S₁₂ | `residueSum42`            | 5      | Numbers 1–511 whose CRT residue sum = 42                  |
| S₁₃ | `ontologyPrimesSeq`       | 3      | {47, 59, 71} — the only primes dividing 196883            |

From: "The Calculus of Myth: Formalizing the Hero's Journey
       through Quasifibration Narrative Vectors"
-/
import RequestProject.OntologyPrimes

set_option maxHeartbeats 800000
set_option maxRecDepth 1000

open OntologyPrimes

namespace GateScan

-- ============================================================
-- §1  Core Classification Functions
-- ============================================================

/-- A number is "coprime to the Monster base" if gcd(n, 196883) = 1.
    Such numbers can extend the CRT torus as clean new charts. -/
def isCoprimeToMonster (n : ℕ) : Bool :=
  Nat.gcd n 196883 == 1

/-- A number is a "gate prime" if it is prime AND coprime to 196883.
    These are candidates for extending the quasifibration system. -/
def isGatePrime (n : ℕ) : Bool :=
  n ≥ 2 && Nat.Prime n && isCoprimeToMonster n

/-- The Bott periodicity class: n mod 8. -/
def bottClassOf (n : ℕ) : Fin 8 := ⟨n % 8, Nat.mod_lt n (by omega)⟩

/-- The CRT residue triple of n in the Monster torus. -/
def crtTriple (n : ℕ) : ℕ × ℕ × ℕ := (n % 71, n % 59, n % 47)

/-- Q42 resonance: n ≡ 42 (mod 59). -/
def isQ42Resonant (n : ℕ) : Bool := n % 59 == 42

/-- Stealth hole: 71 divides n (invisible in the largest chart). -/
def isStealthHole (n : ℕ) : Bool := n % 71 == 0

/-- The 8 muse primes. -/
def musePrimesList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19]

/-- The 15 supersingular primes. -/
def sspList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Is n a supersingular prime? -/
def isSupersingular (n : ℕ) : Bool := sspList.contains n

/-- Does n have at least one muse-prime among its CRT residues? -/
def hasMuseResidue (n : ℕ) : Bool :=
  let (r71, r59, r47) := crtTriple n
  musePrimesList.any (fun m => r71 == m || r59 == m || r47 == m)

/-- How many of n's three CRT residues are muse primes? (0, 1, 2, or 3) -/
def museResonanceCount (n : ℕ) : ℕ :=
  let (r71, r59, r47) := crtTriple n
  let count := fun r => if musePrimesList.any (fun m => r == m) then 1 else 0
  count r71 + count r59 + count r47

-- ============================================================
-- §2  The Gate Signature: Complete Classification of n < 512
-- ============================================================

/-- The full "gate signature" of a natural number in the quasifibration system. -/
structure GateSignature where
  value         : ℕ
  isPrime       : Bool
  coprimeMonster : Bool
  bottClass     : Fin 8
  crt           : ℕ × ℕ × ℕ    -- (mod 71, mod 59, mod 47)
  q42Resonant   : Bool
  stealthHole   : Bool
  supersingular : Bool
  museCount     : ℕ              -- how many CRT residues are muse primes
  deriving Repr

/-- Compute the gate signature of any natural number. -/
def gateSignature (n : ℕ) : GateSignature where
  value         := n
  isPrime       := n ≥ 2 && Nat.Prime n
  coprimeMonster := isCoprimeToMonster n
  bottClass     := bottClassOf n
  crt           := crtTriple n
  q42Resonant   := isQ42Resonant n
  stealthHole   := isStealthHole n
  supersingular := isSupersingular n
  museCount     := museResonanceCount n

-- ============================================================
-- §3  S₁: Numbers 1–511 Coprime to 196883 (486 elements)
-- ============================================================

/-- All numbers 1–511 coprime to 196883.
    These can be added as clean CRT charts. -/
def coprime196883 : List ℕ :=
  (List.range 512).filter (fun n => n > 0 && isCoprimeToMonster n)

theorem coprime196883_length : coprime196883.length = 486 := by native_decide

-- ============================================================
-- §4  S₂: Numbers 1–511 NOT Coprime to 196883 (25 elements)
-- ============================================================

/-- Multiples of 47, 59, or 71 below 512 — these CANNOT extend the CRT torus. -/
def nonCoprime196883 : List ℕ :=
  (List.range 512).filter (fun n => n > 0 && !isCoprimeToMonster n)

theorem nonCoprime196883_length : nonCoprime196883.length = 25 := by native_decide

/-- The non-coprime numbers are exactly the multiples of 47, 59, or 71 below 512. -/
theorem nonCoprime196883_values : nonCoprime196883 =
    [47, 59, 71, 94, 118, 141, 142, 177, 188, 213, 235, 236, 282, 284,
     295, 329, 354, 355, 376, 413, 423, 426, 470, 472, 497] := by native_decide

/-- Partition: every number 1–511 is either coprime or not. -/
theorem partition_511 : coprime196883.length + nonCoprime196883.length = 511 := by
  native_decide

-- ============================================================
-- §5  S₃: Gate Primes < 512 (94 primes)
-- ============================================================

/-- All primes < 512 coprime to 196883: these are the gate candidates.
    263 is just ONE of these 94 primes — any of them can serve as a gate. -/
def gatePrimes : List ℕ :=
  (List.range 512).filter (fun n => isGatePrime n)

theorem gatePrimes_length : gatePrimes.length = 94 := by native_decide

/-- 263 is the 53rd gate prime (1-indexed), at position 52 (0-indexed). -/
theorem gate263_position : gatePrimes.getD 52 0 = 263 := by native_decide

-- ============================================================
-- §6  S₄: Bott Class 7 Gate Primes — "Departure Gates" (24 primes)
-- ============================================================

/-- Gate primes ≡ 7 (mod 8): in Bott periodicity, π₇(O) ≅ ℤ.
    This is the "departure class" — the deepest real K-theory class. -/
def bottClass7Gates : List ℕ :=
  gatePrimes.filter (fun p => p % 8 == 7)

theorem bottClass7Gates_length : bottClass7Gates.length = 24 := by native_decide

theorem bottClass7Gates_values : bottClass7Gates =
    [7, 23, 31, 79, 103, 127, 151, 167, 191, 199, 223, 239,
     263, 271, 311, 359, 367, 383, 431, 439, 463, 479, 487, 503] := by native_decide

/-- 263 is the 13th departure-class gate (1-indexed). -/
theorem gate263_departure_position : bottClass7Gates.getD 12 0 = 263 := by native_decide

-- ============================================================
-- §7  S₅: Bott Class 1 Gate Primes — "Split Gates" (20 primes)
-- ============================================================

/-- Gate primes ≡ 1 (mod 8): these split completely in Q(√-1, √2).
    They represent maximum algebraic splitting. -/
def bottClass1Gates : List ℕ :=
  gatePrimes.filter (fun p => p % 8 == 1)

theorem bottClass1Gates_length : bottClass1Gates.length = 20 := by native_decide

theorem bottClass1Gates_values : bottClass1Gates =
    [17, 41, 73, 89, 97, 113, 137, 193, 233, 241,
     257, 281, 313, 337, 353, 401, 409, 433, 449, 457] := by native_decide

-- ============================================================
-- §8  S₆: Q42 Resonant Numbers (n ≡ 42 mod 59, 8 elements)
-- ============================================================

/-- Numbers 1–511 whose 59-chart residue is 42 = Douglas Adams' Answer. -/
def q42Numbers : List ℕ :=
  (List.range 512).filter (fun n => n > 0 && isQ42Resonant n)

theorem q42Numbers_length : q42Numbers.length = 8 := by native_decide

theorem q42Numbers_values : q42Numbers =
    [42, 101, 160, 219, 278, 337, 396, 455] := by native_decide

/-- These are exactly the numbers 42 + 59k for k = 0, …, 7. -/
theorem q42Numbers_arithmetic_progression :
    q42Numbers = (List.range 8).map (fun k => 42 + 59 * k) := by native_decide

-- ============================================================
-- §9  S₇: Q42 Gate Primes (prime AND ≡ 42 mod 59, 2 elements)
-- ============================================================

/-- Primes < 512 with Q42 resonance: only 101 and 337. -/
def q42Primes : List ℕ :=
  gatePrimes.filter (fun p => isQ42Resonant p)

theorem q42Primes_length : q42Primes.length = 2 := by native_decide
theorem q42Primes_values : q42Primes = [101, 337] := by native_decide

/-- 101 is Bott class 5, 337 is Bott class 1. -/
theorem q42Prime_bott_classes :
    (101 % 8, 337 % 8) = (5, 1) := by native_decide

-- ============================================================
-- §10  S₈: Stealth Holes (71 ∣ n, 7 elements)
-- ============================================================

/-- Numbers 1–511 divisible by 71: invisible in the largest CRT chart.
    These are "holes" in the 71-sheet of the quasifibration. -/
def stealthHoles : List ℕ :=
  (List.range 512).filter (fun n => n > 0 && isStealthHole n)

theorem stealthHoles_length : stealthHoles.length = 7 := by native_decide

theorem stealthHoles_values : stealthHoles =
    [71, 142, 213, 284, 355, 426, 497] := by native_decide

/-- No stealth hole has Q42 resonance (71 and 59 are coprime,
    so 71 | n and n ≡ 42 (mod 59) has no solution below 512). -/
theorem no_stealth_q42 :
    (stealthHoles.filter isQ42Resonant).length = 0 := by native_decide

-- ============================================================
-- §11  S₉: Supersingular Primes (all 15 are below 512)
-- ============================================================

/-- The 15 supersingular primes — primes dividing |M|, the Monster group order.
    ALL of them are below 512 (the largest is 71). -/
def supersingularBelow512 : List ℕ :=
  (List.range 512).filter (fun n => isSupersingular n)

theorem supersingularBelow512_length : supersingularBelow512.length = 15 := by native_decide

theorem supersingularBelow512_values : supersingularBelow512 =
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by native_decide

/-- All supersingular primes are indeed prime. -/
theorem ssp_all_prime : sspList.Forall Nat.Prime := by native_decide

/-- 12 of the 15 SSPs are gate primes (all except 47, 59, 71). -/
theorem ssp_gate_count :
    (sspList.filter isGatePrime).length = 12 := by native_decide

-- ============================================================
-- §12  S₁₀: Muse Gate Primes (8 elements)
-- ============================================================

/-- The 8 muse primes are all gate primes (all coprime to 196883). -/
def museGatePrimes : List ℕ :=
  musePrimesList.filter isGatePrime

theorem museGatePrimes_length : museGatePrimes.length = 8 := by native_decide

theorem museGatePrimes_eq_musePrimes : museGatePrimes = musePrimesList := by native_decide

/-- All 8 muse primes are also supersingular. -/
theorem muse_primes_supersingular :
    musePrimesList.Forall (fun p => isSupersingular p) := by native_decide

-- ============================================================
-- §13  S₁₁: Resonant Gate Primes (39 primes)
-- ============================================================

/-- Gate primes that have at least one muse-prime among their CRT residues.
    These "resonate" with the muse eigenspace through their torus coordinates. -/
def resonantGates : List ℕ :=
  gatePrimes.filter hasMuseResidue

theorem resonantGates_length : resonantGates.length = 39 := by native_decide

/-- 263 is NOT a resonant gate (its CRT residues are (50, 27, 28)). -/
theorem gate263_not_resonant : hasMuseResidue 263 = false := by native_decide

/-- 263's CRT triple. -/
theorem gate263_crt : crtTriple 263 = (50, 27, 28) := by native_decide

-- ============================================================
-- §14  S₁₂: Residue Sum 42 (5 elements)
-- ============================================================

/-- Numbers 1–511 whose CRT residue sum (mod 47 + mod 59 + mod 71) equals 42. -/
def residueSum42 : List ℕ :=
  (List.range 512).filter (fun n =>
    n > 0 && (n % 47 + n % 59 + n % 71) == 42)

theorem residueSum42_length : residueSum42.length = 5 := by native_decide
theorem residueSum42_values : residueSum42 = [14, 73, 242, 301, 360] := by native_decide

-- ============================================================
-- §15  S₁₃: The Ontology Primes (3 elements)
-- ============================================================

/-- The three primes dividing 196883 — the only primes below 512
    that CANNOT extend the CRT torus. -/
def ontologyPrimesSeq : List ℕ :=
  (List.range 512).filter (fun n => Nat.Prime n && !isCoprimeToMonster n)

theorem ontologyPrimesSeq_length : ontologyPrimesSeq.length = 3 := by native_decide
theorem ontologyPrimesSeq_values : ontologyPrimesSeq = [47, 59, 71] := by native_decide

-- ============================================================
-- §16  Cross-Sequence Analysis
-- ============================================================

/-- Gate primes by Bott class: the distribution across the 8 periodicity classes. -/
def gateByBott (c : Fin 8) : List ℕ :=
  gatePrimes.filter (fun p => p % 8 == c.val)

/-- Bott class distribution of gate primes: (class, count).
    Classes 0, 2, 4, 6 have 0 or 1 elements (only p=2 for class 2);
    classes 1, 3, 5, 7 carry the bulk. -/
theorem gate_bott_0 : (gateByBott 0).length = 0  := by native_decide
theorem gate_bott_1 : (gateByBott 1).length = 20 := by native_decide
theorem gate_bott_2 : (gateByBott 2).length = 1  := by native_decide
theorem gate_bott_3 : (gateByBott 3).length = 24 := by native_decide
theorem gate_bott_4 : (gateByBott 4).length = 0  := by native_decide
theorem gate_bott_5 : (gateByBott 5).length = 25 := by native_decide
theorem gate_bott_6 : (gateByBott 6).length = 0  := by native_decide
theorem gate_bott_7 : (gateByBott 7).length = 24 := by native_decide

/-- Odd primes avoid even Bott classes (except 2 in class 2).
    This is because odd primes p satisfy p mod 2 = 1,
    so p mod 8 ∈ {1, 3, 5, 7}. -/
theorem gate_even_bott_sparse :
    (gateByBott 0).length + (gateByBott 4).length + (gateByBott 6).length = 0 := by
  native_decide

/-- Muse resonance distribution: how many gate primes have 0, 1, or 3
    muse-prime residues? (No gate prime has exactly 2.) -/
def gatesByResonance (c : Fin 4) : List ℕ :=
  gatePrimes.filter (fun p => museResonanceCount p == c.val)

theorem resonance_distribution :
    ((gatesByResonance 0).length, (gatesByResonance 1).length,
     (gatesByResonance 2).length, (gatesByResonance 3).length) =
    (55, 31, 0, 8) := by native_decide

/-- The 8 primes with maximum resonance (all 3 CRT residues are muse primes)
    are exactly the 8 muse primes: they are small enough that n mod X = n
    for all three ontology primes X ∈ {47, 59, 71}. -/
theorem max_resonance_primes :
    (gatesByResonance 3) = [2, 3, 5, 7, 11, 13, 17, 19] := by native_decide

-- ============================================================
-- §17  The Full Gate Scan: Every Number Gets a Signature
-- ============================================================

/-- Compute gate signatures for all numbers 1–511. -/
def fullScan : List GateSignature :=
  ((List.range 512).filter (· > 0)).map gateSignature

/-- The scan covers exactly 511 numbers. -/
theorem fullScan_length : fullScan.length = 511 := by native_decide

-- ============================================================
-- §18  263 In Context: Why It's Special (But Not Unique)
-- ============================================================

/-- 263 is prime. -/
theorem prime_263 : Nat.Prime 263 := by decide

/-- 263 is coprime to 196883. -/
theorem coprime_263_monster : Nat.gcd 263 196883 = 1 := by decide

/-- 263 is Bott class 7 (departure class). -/
theorem bott_263 : 263 % 8 = 7 := by native_decide

/-- 263 is the 56th prime overall. -/
theorem prime263_is_56th : ((List.range 264).filter Nat.Prime).length = 56 := by native_decide

/-- 263 = p₅₆ and 56 = 8 × 7: the dimension of the muse space (8)
    times the departure Bott class (7). This is its structural significance. -/
theorem gate263_structural : ((List.range 264).filter Nat.Prime).length = 8 * 7 := by
  native_decide

-- ============================================================
-- §19  New Gate Candidates: Other Interesting Primes
-- ============================================================

/-- Gate primes with BOTH Bott class 7 AND one of their CRT residues is
    a supersingular prime (not just a muse prime). -/
def sspResonantDepartureGates : List ℕ :=
  bottClass7Gates.filter (fun p =>
    let (r71, r59, r47) := crtTriple p
    sspList.any (fun s => r71 == s || r59 == s || r47 == s))

theorem sspResonant_departure_length :
    sspResonantDepartureGates.length = 15 := by native_decide

/-- Gate primes that are twin primes (p and p+2 or p-2 both prime). -/
def twinGatePrimes : List ℕ :=
  gatePrimes.filter (fun p => Nat.Prime (p + 2) || (p ≥ 2 && Nat.Prime (p - 2)))

theorem twinGatePrimes_length : twinGatePrimes.length = 45 := by native_decide

-- ============================================================
-- §20  The Coprimality Theorem: Gate Extension is Generic
-- ============================================================

/-- For ANY prime p coprime to 196883, it is coprime to each factor individually.
    This means ANY gate prime can serve as a clean CRT extension, not just 263. -/
theorem any_gate_coprime_factors (p : ℕ)
    (hcop : Nat.Coprime p (47 * 59 * 71)) :
    Nat.Coprime p 47 ∧ Nat.Coprime p 59 ∧ Nat.Coprime p 71 := by
  refine ⟨hcop.coprime_dvd_right ?_, hcop.coprime_dvd_right ?_, hcop.coprime_dvd_right ?_⟩
  all_goals omega

-- ============================================================
-- §21  Arithmetic Progressions in the Sequences
-- ============================================================

/-- The Q42 numbers form an arithmetic progression 42 + 59k. -/
theorem q42_is_AP : ∀ n ∈ q42Numbers, n % 59 = 42 := by native_decide

/-- The stealth holes form an arithmetic progression 71k. -/
theorem stealth_is_AP : ∀ n ∈ stealthHoles, n % 71 = 0 := by native_decide

/-- The non-coprime numbers are a union of three arithmetic progressions. -/
theorem nonCoprime_union :
    ∀ n ∈ nonCoprime196883, 47 ∣ n ∨ 59 ∣ n ∨ 71 ∣ n := by native_decide

-- ============================================================
-- §22  Summary Statistics
-- ============================================================

/-- 94 out of 97 primes < 512 are gate candidates (3 are ontology primes). -/
theorem primes_below_512 :
    ((List.range 512).filter Nat.Prime).length = 97 := by native_decide

theorem gate_fraction : gatePrimes.length + ontologyPrimesSeq.length = 97 := by native_decide

/-- The system distinguishes 486 clean vs 25 blocked extension points. -/
theorem clean_vs_blocked : 486 + 25 = 511 := by norm_num

/-- Every Bott class 7 gate prime is ≡ 7 (mod 8) = ≡ -1 (mod 8).
    Since p ≡ -1 (mod 8), these primes are inert in ℤ[i]. -/
theorem bott7_mod8 : ∀ p ∈ bottClass7Gates, p % 8 = 7 := by native_decide

-- ============================================================
-- §23  OEIS-Style Sequence Index
-- ============================================================

/-- Master index of all extracted sequences with their first 8 terms. -/

-- S₁: coprime196883 starts [1, 2, 3, 4, 5, 6, 7, 8, ...]
theorem S1_head : coprime196883.take 8 = [1, 2, 3, 4, 5, 6, 7, 8] := by native_decide

-- S₂: nonCoprime196883 = [47, 59, 71, 94, 118, 141, 142, 177, ...]
theorem S2_head : nonCoprime196883.take 8 =
    [47, 59, 71, 94, 118, 141, 142, 177] := by native_decide

-- S₃: gatePrimes = [2, 3, 5, 7, 11, 13, 17, 19, ...]
theorem S3_head : gatePrimes.take 8 = [2, 3, 5, 7, 11, 13, 17, 19] := by native_decide

-- S₄: bottClass7Gates = [7, 23, 31, 79, 103, 127, 151, 167, ...]
theorem S4_head : bottClass7Gates.take 8 =
    [7, 23, 31, 79, 103, 127, 151, 167] := by native_decide

-- S₅: bottClass1Gates = [17, 41, 73, 89, 97, 113, 137, 193, ...]
theorem S5_head : bottClass1Gates.take 8 =
    [17, 41, 73, 89, 97, 113, 137, 193] := by native_decide

-- S₆: q42Numbers = [42, 101, 160, 219, 278, 337, 396, 455]
theorem S6_complete : q42Numbers = [42, 101, 160, 219, 278, 337, 396, 455] := by native_decide

-- S₇: q42Primes = [101, 337]
theorem S7_complete : q42Primes = [101, 337] := by native_decide

-- S₈: stealthHoles = [71, 142, 213, 284, 355, 426, 497]
theorem S8_complete : stealthHoles = [71, 142, 213, 284, 355, 426, 497] := by native_decide

-- S₉: supersingularBelow512 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
theorem S9_complete : supersingularBelow512 =
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] := by native_decide

-- S₁₀: museGatePrimes = [2, 3, 5, 7, 11, 13, 17, 19]
theorem S10_complete : museGatePrimes = [2, 3, 5, 7, 11, 13, 17, 19] := by native_decide

-- S₁₁: resonantGates first 8 = [2, 3, 5, 7, 11, 13, 17, 19, ...]
theorem S11_head : resonantGates.take 8 = [2, 3, 5, 7, 11, 13, 17, 19] := by native_decide

-- S₁₂: residueSum42 = [14, 73, 242, 301, 360]
theorem S12_complete : residueSum42 = [14, 73, 242, 301, 360] := by native_decide

-- S₁₃: ontologyPrimesSeq = [47, 59, 71]
theorem S13_complete : ontologyPrimesSeq = [47, 59, 71] := by native_decide

end GateScan
