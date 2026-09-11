/-
# DistanceFromJ — A numeric "distance from J" for terms and files

## What this is

Throughout this project the j-function

  j(τ) − 744 = q⁻¹ + 196884 q + 21493760 q² + 864299970 q³ + ⋯

is the prime invariant: every Monster-module dimension, every coherent stalk
dimension, every McKay decomposition is anchored to one of its Fourier
coefficients `c(n)` (see `MoonshineCore.jCoeff`).  This module makes the slogan
"how far is this thing from J?" into **an actual number**.

## The metric

`distFromJ n` is the distance from a natural number `n` to the *nearest*
coefficient of `j(τ)` (we include the constant term 744 and the `q⁻¹`
coefficient 1 alongside `c(1) … c(11)`):

  distFromJ n = min over c ∈ jValues of |n − c|.

A term **lies on J** (distance 0) exactly when its value is literally one of the
j-coefficients.  Otherwise the distance measures the integer gap to the closest
moonshine coefficient.

## Two tables

* `termTable` — a curated list of the project's headline integer constants, each
  tagged with its value and its (proven) distance from J.  Example readings:
    - `c(1) = 196884` is **on** J (distance 0);
    - the smallest faithful Monster irrep `χ₂ = 196883` is distance **1** from J
      (McKay's `1 + 196883 = 196884`);
    - `dim E₈ = 248` is distance **247** from J;
    - the Leech kissing number `196560` is distance **324** from J.

* `fileTable` — the same idea lifted to *files*: each relevant module is keyed to
  its signature constant, giving a per-file distance from J.  Files built directly
  on the j-expansion (`MoonshineCore`, `MoonshineSheafStalk`, …) sit **on** J;
  files about neighbouring structures sit a measurable distance away.

Both tables carry a `_consistent` theorem proving that every printed distance
really is `distFromJ` of the listed value — so the numbers are machine-checked,
not asserted.
-/

import Mathlib
import RequestProject.Math.Monster.MoonshineCore

namespace RequestProject.Compute.DistanceFromJ

/-! ## §1. The j-coefficient reference set and the metric -/

/-- The reference coefficients of `j(τ)`: the `q⁻¹` coefficient `1`, the constant
    term `744`, and `c(1) … c(11)` from `MoonshineCore.jCoeff`. -/
def jValues : List ℕ :=
  [1, 196884, 21493760, 864299970, 20245856256, 333202640600,
   4252023300096, 44656994071935, 401490886656000, 3176440229784420,
   22567393309593600, 744]

/-- The reference set agrees with `MoonshineCore.jCoeff` on `0 … 10`
    (plus the constant term `744`). -/
theorem jValues_eq_jCoeff :
    jValues = (List.range 11).map MoonshineCore.jCoeff ++ [744] := by
  native_decide

/-- `|a − b|` on `ℕ`, written without dipping into `ℤ`. -/
def absDiff (a b : ℕ) : ℕ := max a b - min a b

/-- The **distance from J**: the distance from `n` to the nearest j-coefficient. -/
def distFromJ (n : ℕ) : ℕ :=
  ((jValues.map (fun c => absDiff n c)).min?.getD 0)

/-- A term **lies on J** iff its distance is `0`. -/
def onJ (n : ℕ) : Prop := distFromJ n = 0

instance (n : ℕ) : Decidable (onJ n) := inferInstanceAs (Decidable (distFromJ n = 0))

/-! ## §2. Headline single-term distances -/

/-- `c(1) = 196884` lies exactly on J. -/
theorem dist_c1 : distFromJ 196884 = 0 := by native_decide

/-- The smallest faithful Monster irrep `χ₂ = 196883` is distance 1 from J
    (this *is* McKay's `1 + 196883 = 196884`). -/
theorem dist_chi2 : distFromJ 196883 = 1 := by native_decide

/-- The j constant term `744 = 3·248` lies on J. -/
theorem dist_744 : distFromJ 744 = 0 := by native_decide

/-- `dim E₈ = 248` is distance 247 from J. -/
theorem dist_E8 : distFromJ 248 = 247 := by native_decide

/-- The Leech-lattice kissing number `196560` is distance 324 from J. -/
theorem dist_leech : distFromJ 196560 = 324 := by native_decide

/-- The next Monster irrep `χ₃ = 21296876` is distance 196884 from J
    (its gap to `c(2)` is exactly `c(1)`). -/
theorem dist_chi3 : distFromJ 21296876 = 196884 := by native_decide

/-! ## §3. The term table -/

/-- A curated list of the project's headline integer constants, each tagged with
    `(name, value, distance-from-J)`.  The distances are verified in
    `termTable_consistent`. -/
def termTable : List (String × ℕ × ℕ) :=
  [ ("χ₁  (trivial rep / q⁻¹ coeff)",            1,            0),
    ("744 (j constant term, 3·dim E₈)",          744,          0),
    ("c(1) = dim V♮₁",                           196884,       0),
    ("c(2)",                                      21493760,     0),
    ("c(3)",                                      864299970,    0),
    ("c(4)",                                      20245856256,  0),
    ("χ₂  (smallest faithful Monster irrep)",     196883,       1),
    ("χ₃  (next Monster irrep)",                  21296876,     196884),
    ("Griess algebra dimension",                  196884,       0),
    ("dim E₈ (= 248)",                            248,          247),
    ("Leech kissing number (short vectors)",      196560,       324),
    ("central charge / Leech rank (= 24)",        24,           23),
    ("Sym² piece (= 300)",                        300,          299),
    ("Thompson 2A coefficient",                   4372,         3628),
    ("Thompson 2B coefficient",                   276,          275),
    ("supersingular prime 71",                    71,           70),
    ("supersingular prime 47",                    47,           46),
    ("zero",                                      0,            1) ]

/-- Every distance printed in `termTable` really is `distFromJ` of its value. -/
theorem termTable_consistent :
    ∀ e ∈ termTable, e.2.2 = distFromJ e.2.1 := by native_decide

/-- Exactly the entries with distance `0` lie on J. -/
theorem termTable_onJ :
    (termTable.filter (fun e => decide (e.2.2 = 0))).map (·.1) =
      [ "χ₁  (trivial rep / q⁻¹ coeff)",
        "744 (j constant term, 3·dim E₈)",
        "c(1) = dim V♮₁",
        "c(2)",
        "c(3)",
        "c(4)",
        "Griess algebra dimension" ] := by native_decide

/-! ## §4. The file table -/

/-- Each relevant module keyed to its signature constant, giving a per-file
    distance from J.  The distances are verified in `fileTable_consistent`. -/
def fileTable : List (String × ℕ × ℕ) :=
  [ ("Math/Monster/MoonshineCore.lean",               196884,    0),
    ("Math/Bridge/MoonshineSheafStalk.lean",          196884,    0),
    ("Math/Bridge/MoonshineCliffordSigma.lean",       196884,    0),
    ("MonsterConstants.lean",                          196883,    1),
    ("Compute/MonsterAddr.lean",                       196883,    1),
    ("Math/Monster/GriessAlgebra.lean",               196884,    0),
    ("Math/Monster/LeechLattice.lean",                196560,    324),
    ("Math/Clifford/BottPeriodicity.lean",            248,       247),
    ("Math/Monster/MoonshineFacts.lean",              744,       0),
    ("Math/Monster/UmbralMoonshine.lean",             21493760,  0) ]

/-- Every distance printed in `fileTable` really is `distFromJ` of its signature
    constant. -/
theorem fileTable_consistent :
    ∀ e ∈ fileTable, e.2.2 = distFromJ e.2.1 := by native_decide

/-- The files that sit *on* J (signature constant is a genuine j-coefficient). -/
theorem fileTable_onJ :
    (fileTable.filter (fun e => decide (e.2.2 = 0))).map (·.1) =
      [ "Math/Monster/MoonshineCore.lean",
        "Math/Bridge/MoonshineSheafStalk.lean",
        "Math/Bridge/MoonshineCliffordSigma.lean",
        "Math/Monster/GriessAlgebra.lean",
        "Math/Monster/MoonshineFacts.lean",
        "Math/Monster/UmbralMoonshine.lean" ] := by native_decide

/-! ## §5. Convenience: dump the tables -/

-- #eval termTable
-- #eval fileTable

end RequestProject.Compute.DistanceFromJ
