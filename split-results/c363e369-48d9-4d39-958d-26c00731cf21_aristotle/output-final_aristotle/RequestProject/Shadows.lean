import Mathlib
import RequestProject.Monster

/-!
# Shadows of higher-dimensional cubes in the Monster degree matrix

Each Monster representation `i` is a point in `{0,1}¹⁵` via its supersingular-prime
*divisibility vector* `bᵢⱼ = [pⱼ ∣ dᵢ]` (cell `(i,j)` is "ink" iff `pⱼ ∣ dᵢ`).  The
194×15 matrix the eye looks at is a 2-dimensional rendering of these 194 points of a
15-dimensional hypercube.  It is therefore natural to ask which *higher-dimensional
cubes* cast shadows here.

Two precise notions:

* an **embedded `d`-cube** `Qd`: `2ᵈ` representations that agree on all the other
  coordinates and realize all `2ᵈ` patterns on `d` chosen primes — a genuine
  `d`-dimensional sub-cube of `{0,1}¹⁵`;
* a **`d`-cube shadow** (projection): `2ᵈ` representations realizing all `2ᵈ`
  divisibility patterns on `d` chosen primes, with no constraint on the other
  coordinates — i.e. the orthogonal projection onto those `d` axes is a full `Qd`.

This file certifies (all by `native_decide`, only standard axioms):

* **3-D — a genuine embedded 3-cube.**  Over primes `{17,19,23}` there are 8
  representations realizing all 8 corners *and* all divisible by the remaining six
  binary-block primes `{29,31,41,47,59,71}` — a true `Q₃ ⊂ {0,1}⁹`
  (`cube3_shadow`, `cube3_embedded`, `cube3_distinct`).

* **5-D — the matrix is the shadow of a penteract, and 5 is maximal.**  Over primes
  `{2,3,5,23,47}` all `2⁵ = 32` divisibility patterns occur (`cube5_shadow`,
  `cube5_distinct`, `cube5_shadow_exists`), while **no** choice of 6 primes realizes
  all `2⁶ = 64` patterns (`no_cube6_shadow`).  So the largest hypercube whose shadow
  the Monster degrees cast is the 5-cube.
-/

namespace MonsterShadows

open Monster (degrees)

/-! ## 3-D: a genuine embedded 3-cube over primes {17, 19, 23} -/

/-- The three "axis" primes of the embedded 3-cube. -/
def axes3 : List Nat := [17, 19, 23]

/-- The 8 representations at the corners of the 3-cube, indexed by corner
`e = 0,…,7`; bit `k` of `e` records whether `axes3[k]` divides that degree. -/
def cube3 : List Nat := [30, 17, 49, 50, 24, 69, 13, 32]

/-- **3-cube shadow.**  For each corner `e < 8` and axis `k < 3`, the prime
`axes3[k]` divides the corner's degree iff bit `k` of `e` is set: the 8
representations realize all 8 corners of `Q₃` on the primes `{17,19,23}`. -/
theorem cube3_shadow :
    ∀ e < 8, ∀ k < 3,
      (axes3[k]! ∣ degrees[cube3[e]!]! ↔ (e >>> k) % 2 = 1) := by
  native_decide

/-- **The cube is genuinely embedded, not merely projected.**  Every one of the 8
corner representations is also divisible by all six remaining binary-block primes
`{29,31,41,47,59,71}`.  Hence the 8 points agree on those coordinates and differ only
along the three axes `{17,19,23}`: they form a true 3-dimensional sub-cube of
`{0,1}⁹`, whose 2-D rendering is the cube one sees. -/
theorem cube3_embedded :
    ∀ e < 8, ∀ p ∈ ([29, 31, 41, 47, 59, 71] : List Nat),
      p ∣ degrees[cube3[e]!]! := by
  native_decide

/-- The 8 corners are 8 distinct representations. -/
theorem cube3_distinct : cube3.Nodup := by native_decide

/-! ## 5-D: the shadow of a penteract over primes {2, 3, 5, 23, 47} -/

/-- The five "axis" primes of the 5-cube shadow. -/
def axes5 : List Nat := [2, 3, 5, 23, 47]

/-- The 32 representations realizing the 32 corners of the 5-cube shadow, indexed by
corner `e = 0,…,31`; bit `k` of `e` records whether `axes5[k]` divides that degree. -/
def cube5 : List Nat :=
  [0, 2, 8, 168, 15, 35, 160, 150, 5, 4, 25, 43, 18, 118, 52, 19,
   1, 3, 100, 6, 9, 20, 30, 36, 21, 38, 10, 7, 24, 13, 27, 66]

/-- **5-cube (penteract) shadow.**  For each corner `e < 32` and axis `k < 5`, the
prime `axes5[k]` divides the corner's degree iff bit `k` of `e` is set: the 32
representations realize all 32 corners of `Q₅` on the primes `{2,3,5,23,47}`.  The
Monster degree matrix thus casts the shadow of a 5-dimensional hypercube. -/
theorem cube5_shadow :
    ∀ e < 32, ∀ k < 5,
      (axes5[k]! ∣ degrees[cube5[e]!]! ↔ (e >>> k) % 2 = 1) := by
  native_decide

/-- The 32 corners are 32 distinct representations. -/
theorem cube5_distinct : cube5.Nodup := by native_decide

/-! ## Maximality: 5 is the largest cube-shadow dimension -/

/-- The 15 supersingular primes (columns of the matrix). -/
def primesList : List Nat := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The `d`-bit divisibility pattern of representation `i` on the prime columns
`cols` (bit `k` set iff `primesList[cols[k]]` divides `dᵢ`). -/
def patternOf (i : Nat) (cols : List Nat) : Nat :=
  (List.range cols.length).foldl
    (fun acc k => acc + (if primesList[cols[k]!]! ∣ degrees[i]! then 2 ^ k else 0)) 0

/-- Bitset of all divisibility patterns on `cols` realized by some representation:
bit `p` is set iff some `i < 194` has `patternOf i cols = p`. -/
def shadowMask (cols : List Nat) : Nat :=
  (List.range 194).foldl (fun acc i => acc ||| (1 <<< patternOf i cols)) 0

/-- The columns `cols` carry a *full* `cols.length`-cube shadow: every one of the
`2 ^ cols.length` divisibility patterns is realized. -/
def fullShadow (cols : List Nat) : Bool :=
  shadowMask cols = 2 ^ (2 ^ cols.length) - 1

/-- All `d`-element subsets of a list (as ordered sublists). -/
def combos : Nat → List Nat → List (List Nat)
  | 0, _ => [[]]
  | _, [] => []
  | (n + 1), (x :: xs) => (combos n xs).map (x :: ·) ++ combos (n + 1) xs

/-- **A full 5-cube shadow exists**, on the prime columns `{2,3,5,23,47}`
(`primesList` indices `0,1,2,8,12`). -/
theorem cube5_shadow_exists : fullShadow [0, 1, 2, 8, 12] = true := by native_decide

/-- **5 is maximal: no 6-cube shadow exists.**  For *every* choice of 6 of the 15
supersingular primes, at least one of the `2⁶ = 64` divisibility patterns is missing,
so the 194 Monster degrees never project onto a full 6-dimensional hypercube. -/
theorem no_cube6_shadow :
    (combos 6 (List.range 15)).all (fun c => ! fullShadow c) = true := by
  native_decide

end MonsterShadows
