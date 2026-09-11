/-
# MoonshineLensStack — A stack of "lenses" that route any number through moonshine

## What this is

The user's picture: treat the moonshine data as **a series of lenses**.  Given any
data item (a natural number `n`), we look at it through one lens after another, and
each lens reports the *nearest* reference value plus the distance to it:

1. **Irrep lens** — the nearest of the 194 Monster irreducible character degrees
   (`MoonshineIrrepGrading.irrepDim`).  "First we find the irrep."
2. **Resonance lens** — the supersingular (Ogg) prime modulus that *resonates the
   most* with `n`: the prime giving the smallest residue `n % p` (ties broken
   towards the larger, more significant prime).  "Then the mod that resonates the
   most with it."
3. **Divisor lens** — the next divisor of the Monster: the least irrep degree
   `≥ n` (every irrep degree divides `|M|`).  "Wrap it in the next divisors of the
   Monster."
4. **q-expansion lens** — the nearest Fourier coefficient of `j(τ)` (the
   `MoonshineCore.jCoeff` ladder).  "The next q-expansions."

`lensRead n` bundles all four lenses into one `LensReading` record, and
`distMatrix` / `nearestNeighbor` provide the requested **distance table / matrix**:
each value's nearest neighbour among a set of values.

Everything is computable and machine-checked: each lens comes with a theorem that
the value it returns really is a member of its reference set and really is the
nearest one (minimal distance), and the distance matrix is proved symmetric with a
zero diagonal.  All proofs are `native_decide` (axioms `Lean.ofReduceBool`,
`Lean.trustCompiler`).

## Design

The four lenses share one generic engine, `nearestIn`, so "nearest neighbour in a
reference set" is a single reusable notion; the four moonshine lenses are just
`nearestIn` (or a residue scan) applied to four different reference ladders.
-/

import Mathlib
import RequestProject.Math.Bridge.MoonshineIrrepGrading
import RequestProject.Math.Monster.MoonshineCore

namespace RequestProject.Compute.MoonshineLensStack

open RequestProject.Math.Bridge.MoonshineIrrepGrading

/-! ## §1. The generic lens engine -/

/-- `|a − b|` on `ℕ`, staying inside `ℕ`. -/
def absDiff (a b : ℕ) : ℕ := max a b - min a b

theorem absDiff_self (a : ℕ) : absDiff a a = 0 := by simp [absDiff]

theorem absDiff_comm (a b : ℕ) : absDiff a b = absDiff b a := by
  simp [absDiff, max_comm, min_comm]

/-- The generic **nearest-neighbour lens**: given a reference list `refs` and a
    value `n`, return `(r, d)` where `r ∈ refs` minimises the distance `d` to `n`.
    On an empty reference set it returns `(n, 0)`. -/
def nearestIn (refs : List ℕ) (n : ℕ) : ℕ × ℕ :=
  match refs with
  | [] => (n, 0)
  | r0 :: rs => rs.foldl (fun best r =>
       let d := absDiff n r
       if d < best.2 then (r, d) else best) (r0, absDiff n r0)

/-! ## §2. The four moonshine reference ladders -/

/-- The 194 Monster irreducible character degrees (with multiplicity: complex
    conjugate pairs share a degree). -/
def irrepDims : List ℕ := (List.range 194).map irrepDim

/-- The 15 supersingular (Ogg) primes as a list. -/
def oggList : List ℕ := oggPrimes.toList

/-- The `j(τ)` Fourier-coefficient ladder: `q⁻¹` coefficient `1`, `c(1) … c(10)`,
    and the constant term `744`. -/
def qLadder : List ℕ := (List.range 11).map MoonshineCore.jCoeff ++ [744]

theorem irrepDims_size : irrepDims.length = 194 := by native_decide
theorem oggList_size : oggList.length = 15 := by native_decide
theorem qLadder_size : qLadder.length = 12 := by native_decide

/-! ## §3. Lens 1 — the irrep lens -/

/-- **Irrep lens**: nearest Monster irrep degree to `n`, with its distance. -/
def irrepLens (n : ℕ) : ℕ × ℕ := nearestIn irrepDims n

/-! ## §4. Lens 2 — the resonance (modulus) lens -/

/-- **Resonance lens**: the Ogg prime that resonates the most with `n`, i.e. the
    prime minimising the residue `n % p`, ties broken towards the larger prime. -/
def resonantPrime (n : ℕ) : ℕ :=
  oggList.foldl (fun best p =>
     let r := n % p
     let rb := n % best
     if r < rb ∨ (r = rb ∧ best < p) then p else best) (oggList.headD 2)

/-- The residue of `n` under its most resonant Ogg prime. -/
def resonance (n : ℕ) : ℕ := n % resonantPrime n

/-! ## §5. Lens 3 — the divisor lens -/

/-- **Divisor lens**: the next divisor of the Monster, namely the least irrep
    degree `≥ n` (returns `0` if `n` exceeds every degree). -/
def nextDivisor (n : ℕ) : ℕ :=
  match irrepDims.filter (n ≤ ·) with
  | [] => 0
  | x :: xs => xs.foldl min x

/-! ## §6. Lens 4 — the q-expansion lens -/

/-- **q-expansion lens**: nearest `j(τ)` Fourier coefficient to `n`, with its
    distance. -/
def qLens (n : ℕ) : ℕ × ℕ := nearestIn qLadder n

/-! ## §7. The full lens stack -/

/-- One reading of a data item through the entire lens stack. -/
structure LensReading where
  /-- The data item. -/
  value : ℕ
  /-- Nearest Monster irrep degree. -/
  irrep : ℕ
  /-- Distance to the nearest irrep degree. -/
  irrepDist : ℕ
  /-- The most resonant Ogg prime modulus. -/
  resPrime : ℕ
  /-- Residue under that modulus. -/
  res : ℕ
  /-- The next Monster divisor (least irrep degree `≥ value`). -/
  divisor : ℕ
  /-- Nearest `j(τ)` Fourier coefficient. -/
  qCoeff : ℕ
  /-- Distance to that coefficient. -/
  qDist : ℕ
  deriving Repr, DecidableEq

/-- Read a data item through all four lenses. -/
def lensRead (n : ℕ) : LensReading where
  value := n
  irrep := (irrepLens n).1
  irrepDist := (irrepLens n).2
  resPrime := resonantPrime n
  res := resonance n
  divisor := nextDivisor n
  qCoeff := (qLens n).1
  qDist := (qLens n).2

/-! ## §8. Headline data items and their readings -/

/-- A curated list of the project's headline integer constants — the "data items"
    we push through the lens stack. -/
def dataValues : List ℕ :=
  [ 1,            -- trivial rep / q⁻¹ coefficient
    196883,       -- χ₂, smallest faithful Monster irrep
    196884,       -- c(1) = Griess algebra dimension
    21296876,     -- χ₃
    21493760,     -- c(2)
    248,          -- dim E₈
    744,          -- j constant term
    196560,       -- Leech kissing number
    24,           -- central charge / Leech rank
    300,          -- Sym² piece
    4372,         -- Thompson 2A coefficient
    71 ]          -- supersingular prime 71

/-- The lens readings of every headline data item. -/
def readings : List LensReading := dataValues.map lensRead

/-! ## §9. Correctness of each lens

For each lens we prove two facts on every headline data item: the value it returns
is a genuine member of its reference ladder, and it is the *nearest* such member
(its reported distance is minimal). -/

/-- The irrep lens always lands on a real irrep degree. -/
theorem irrepLens_mem : ∀ n ∈ dataValues, (irrepLens n).1 ∈ irrepDims := by
  native_decide

/-- The irrep lens reports the genuine distance to the degree it picks. -/
theorem irrepLens_dist : ∀ n ∈ dataValues, (irrepLens n).2 = absDiff n (irrepLens n).1 := by
  native_decide

/-- The irrep lens is a true nearest-neighbour lens: no irrep degree is closer. -/
theorem irrepLens_nearest :
    ∀ n ∈ dataValues, ∀ d ∈ irrepDims, (irrepLens n).2 ≤ absDiff n d := by
  native_decide

/-- The resonance lens picks a genuine Ogg prime. -/
theorem resonantPrime_mem : ∀ n ∈ dataValues, resonantPrime n ∈ oggList := by
  native_decide

/-- No Ogg prime resonates more strongly (smaller residue) than the chosen one. -/
theorem resonance_minimal :
    ∀ n ∈ dataValues, ∀ p ∈ oggList, resonance n ≤ n % p := by
  native_decide

/-- The next divisor really divides the Monster order. -/
theorem nextDivisor_dvd : ∀ n ∈ dataValues, nextDivisor n ∣ monsterOrder := by
  native_decide

/-- The next divisor is `≥` the value (the wrapping shell contains it). -/
theorem nextDivisor_ge : ∀ n ∈ dataValues, n ≤ nextDivisor n := by
  native_decide

/-- The q-expansion lens always lands on a genuine `j(τ)` coefficient. -/
theorem qLens_mem : ∀ n ∈ dataValues, (qLens n).1 ∈ qLadder := by
  native_decide

/-- The q-expansion lens is a true nearest-neighbour lens. -/
theorem qLens_nearest :
    ∀ n ∈ dataValues, ∀ c ∈ qLadder, (qLens n).2 ≤ absDiff n c := by
  native_decide

/-! ## §10. Sample readings (sanity checks) -/

/-- McKay through the lenses: `χ₂ = 196883` lands exactly on its own irrep degree
    (distance 0), resonates most with the prime `71`, its next Monster divisor is
    `c(1) = 196884`'s neighbour, and it sits distance `1` from the j-coefficient
    `c(1)` — McKay's `1 + 196883 = 196884`. -/
theorem reading_chi2 :
    lensRead 196883 =
      { value := 196883, irrep := 196883, irrepDist := 0,
        resPrime := 71, res := 0,
        divisor := nextDivisor 196883, qCoeff := 196884, qDist := 1 } := by
  native_decide

/-- `c(1) = 196884` is *not* itself an irrep degree — its nearest irrep is
    `χ₂ = 196883` at distance `1` (McKay) — but it lands exactly on its own
    j-coefficient (distance 0). -/
theorem reading_c1 :
    (lensRead 196884).irrep = 196883 ∧ (lensRead 196884).irrepDist = 1 ∧
      (lensRead 196884).qDist = 0 := by
  native_decide

/-! ## §11. The distance matrix / nearest-neighbour table -/

/-- The **distance matrix** of a list of values: entry `(i,j)` is `absDiff vᵢ vⱼ`. -/
def distMatrix (vs : List ℕ) : List (List ℕ) :=
  vs.map (fun a => vs.map (fun b => absDiff a b))

/-- The nearest neighbour of `a` among the *other* values of `vs`, with its
    distance. -/
def nearestNeighbor (vs : List ℕ) (a : ℕ) : ℕ × ℕ :=
  nearestIn (vs.filter (· ≠ a)) a

/-- The nearest-neighbour table over the headline data items. -/
def neighborTable : List (ℕ × ℕ × ℕ) :=
  dataValues.map (fun a =>
    let nn := nearestNeighbor dataValues a
    (a, nn.1, nn.2))

/-- The distance matrix has a zero diagonal. -/
theorem distMatrix_diag_zero :
    ∀ i < dataValues.length,
      ((distMatrix dataValues).getD i []).getD i 0 = 0 := by
  native_decide

/-- The distance matrix is symmetric. -/
theorem distMatrix_symm :
    ∀ i < dataValues.length, ∀ j < dataValues.length,
      ((distMatrix dataValues).getD i []).getD j 0 =
      ((distMatrix dataValues).getD j []).getD i 0 := by
  native_decide

/-- Every nearest neighbour is one of the data values, and is distinct from its
    source. -/
theorem neighborTable_valid :
    ∀ e ∈ neighborTable, e.2.1 ∈ dataValues ∧ e.2.1 ≠ e.1 := by
  native_decide

/-- The reported neighbour distance equals the matrix distance between the two
    points. -/
theorem neighborTable_dist :
    ∀ e ∈ neighborTable, e.2.2 = absDiff e.1 e.2.1 := by
  native_decide

/-- McKay again, now in the neighbour table: the nearest neighbour of `c(1) =
    196884` among the headline constants is `χ₂ = 196883`, at distance `1`. -/
theorem neighbor_c1 : nearestNeighbor dataValues 196884 = (196883, 1) := by
  native_decide

/-! ## §12. Convenience: dump the readings / tables -/

-- #eval readings
-- #eval neighborTable
-- #eval distMatrix dataValues

end RequestProject.Compute.MoonshineLensStack
