import Mathlib
import RequestProject.Monster

/-!
# The Monster Hypercube Atlas

Each of the 194 irreducible representations of the Monster is read as a vertex of the
15-dimensional Boolean hypercube `{0,1}¹⁵` via its supersingular-prime *divisibility
vector*
`bᵢⱼ = [pⱼ ∣ dᵢ]`   (`pⱼ` the `j`-th supersingular prime, `dᵢ = Monster.degrees[i]`),
the same "ink" studied in `RequestProject/Shadows.lean`.  The realized vertex set is

`V = { maskOf i : i < 194 } ⊆ {0,1}¹⁵`.

This file stratifies the 194 irreps by their **local hypercube geometry**, assembling a
Lean-certified `HypercubeAtlas`.  For each irrep `i` we certify:

* **cube-rank** `cubeRank i` — the dimension of the *largest axis-aligned face of the
  cube `{0,1}¹⁵` that is entirely contained in `V` and passes through `bᵢ`*; i.e. the
  largest `k` for which there are `k` coordinate axes such that flipping `bᵢ` in every
  possible way along those axes (keeping the other 11 coordinates frozen) always lands
  on another realized irrep.  This is the genuine *embedded* `k`-cube through `i`
  (not merely a projection/shadow).

* **cube-class** `cubeClass i` — the set of irreps reachable from `bᵢ` by flipping only
  the *free axes* (the axes participating in some maximal embedded cube through `i`);
  equivalently the irreps whose divisibility vector agrees with `bᵢ` outside the free
  axes.

* **stabilizer mask** `stabilizerMask i` — the set of supersingular *primes* on which
  **all** members of the cube-class agree (the frozen coordinates of the stratum).

The main results:

* `cubeRank_le_two` / `cubeRank_two_exists` — the largest embedded cube through any
  single vertex has dimension exactly **2** (the strata have local dimensions `0,1,2`).
* `cubeRank_distribution` — there are `113` rank-0, `46` rank-1 and `35` rank-2 irreps.
* `cubeRank_is_max` — `cubeRank i` is genuinely the maximal embedded-cube dimension
  through `i` (a cube of that dimension exists, none of one higher does).
* `stabilizerMask_eq_complement` — the stabilizer mask is exactly the complement of the
  free axes: every prime is *either* a free (varying) axis of the maximal cube *or* a
  frozen coordinate shared by the whole cube-class.
* `monsterAtlas` / `monsterAtlas_certified` — the assembled `HypercubeAtlas` together
  with a proof that all four fields satisfy the cube axioms.

Everything is closed by `native_decide` (only standard axioms `propext` /
`Lean.ofReduceBool` / `Lean.trustCompiler`): the geometry is *decided by the kernel*,
not asserted from outside.
-/

namespace MonsterAtlas

open Monster (degrees)

/-! ## The realized vertex set `V ⊆ {0,1}¹⁵` -/

/-- The 15 supersingular primes (hypercube axes / matrix columns). -/
def primesList : List Nat := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The 15-bit divisibility vector of irrep `i`, packed as a `Nat`:
bit `j` is set iff the `j`-th supersingular prime divides `degrees[i]`. -/
def maskOf (i : Nat) : Nat :=
  (List.range 15).foldl
    (fun acc j => acc ||| (if primesList[j]! ∣ degrees[i]! then 1 <<< j else 0)) 0

/-- The divisibility vectors of all 194 irreps, as an array of 15-bit codes. -/
def maskArr : Array Nat := Id.run do
  let mut a : Array Nat := Array.replicate 194 0
  for i in [0:194] do
    a := a.set! i (maskOf i)
  return a

/-- Membership table of the realized vertex set `V`: `present[m]` is `true` iff some
irrep has divisibility vector `m`. -/
def present : Array Bool := Id.run do
  let mut a : Array Bool := Array.replicate 32768 false
  for i in [0:194] do
    a := a.set! (maskArr[i]!) true
  return a

/-! ## Embedded cubes through a vertex -/

/-- The axis-set `cols` (a 15-bit mask of chosen coordinates) carries an **embedded
cube through `i`**: every one of the `2 ^ |cols|` ways of overwriting `bᵢ`'s bits on
`cols` lands on a realized vertex.  Equivalently, the axis-aligned face of `{0,1}¹⁵`
spanned by `cols` and anchored at `bᵢ` lies entirely inside `V`. -/
def cubeOK (i : Nat) (cols : Nat) : Bool := Id.run do
  let m := maskArr[i]!
  let colList := (List.range 15).filter (fun j => (cols >>> j) % 2 = 1)
  let k := colList.length
  for p in [0:(2 ^ k)] do
    let mut mm := m
    for idx in [0:k] do
      let j := colList[idx]!
      if (p >>> idx) % 2 = 1 then mm := mm ||| (1 <<< j)
      else mm := mm &&& (32767 - (1 <<< j))
    if ! present[mm]! then return false
  return true

/-- All `k`-element subsets of a list (as ordered sublists). -/
def combos : Nat → List Nat → List (List Nat)
  | 0, _ => [[]]
  | _, [] => []
  | (n + 1), (x :: xs) => (combos n xs).map (x :: ·) ++ combos (n + 1) xs

/-- The bitmask of a list of axis indices. -/
def axesMask (c : List Nat) : Nat := c.foldl (fun a j => a ||| (1 <<< j)) 0

/-- Is there an embedded `k`-cube through `i` (using some `k` of the 15 axes)? -/
def embCube (i k : Nat) : Bool :=
  (combos k (List.range 15)).any (fun c => cubeOK i (axesMask c))

/-! ## Cube-rank -/

/-- The **cube-rank** of every irrep: `rankArr[i]` is the largest `k ≤ 3` with an
embedded `k`-cube through `i`.  (Scanning to `3` suffices: no vertex lies on a `3`-cube,
so the true maximum, `2`, is always found and the bound is certified by
`cubeRank_is_max`.) -/
def rankArr : Array Nat := Id.run do
  let mut a : Array Nat := Array.replicate 194 0
  for i in [0:194] do
    let mut best := 0
    for k in [1:4] do
      if embCube i k then best := k
    a := a.set! i best
  return a

/-- Cube-rank as a function. -/
def cubeRank (i : Nat) : Nat := rankArr[i]!

/-! ## Free axes, cube-class and stabilizer mask -/

/-- The **free axes** of `i`: the union of the axis-sets of all maximal embedded cubes
through `i`.  These are the coordinates one is allowed to flip while staying inside the
local stratum. -/
def freeAxes (i : Nat) : Nat := Id.run do
  let r := rankArr[i]!
  let mut acc := 0
  for c in (combos r (List.range 15)) do
    let cm := axesMask c
    if cubeOK i cm then acc := acc ||| cm
  return acc

/-- The **cube-class** of `i` as a list of irrep indices: all `j` whose divisibility
vector agrees with `bᵢ` outside the free axes (i.e. `j` is reachable from `i` by
flipping only free axes). -/
def cubeClassList (i : Nat) : List Nat :=
  (List.range 194).filter
    (fun j => ((maskArr[i]! ^^^ maskArr[j]!) &&& (32767 - (freeAxes i &&& 32767))) = 0)

/-- The **stabilizer mask** of `i` as a list of primes: the supersingular primes on
which every member of the cube-class has the same divisibility bit. -/
def stabilizerList (i : Nat) : List Nat := Id.run do
  let cls := cubeClassList i
  let mut acc : List Nat := []
  for c in (List.range 15) do
    if cls.all (fun j => ((maskArr[j]! >>> c) % 2) = ((maskArr[i]! >>> c) % 2)) then
      acc := acc ++ [primesList[c]!]
  return acc

/-- The primes lying on the free (varying) axes of `i` — the complement of the
stabilizer mask. -/
def freePrimesList (i : Nat) : List Nat :=
  (List.range 15).filter (fun c => (freeAxes i >>> c) % 2 = 1) |>.map (fun c => primesList[c]!)

/-! ## Certified structural theorems -/

/-- **Local dimensions are at most 2.**  No single vertex of the realized set lies on an
embedded 3-cube: the largest axis-aligned face of `{0,1}¹⁵` contained in `V` and passing
through any given irrep has dimension `≤ 2`. -/
theorem cubeRank_le_two : ∀ i < 194, cubeRank i ≤ 2 := by native_decide

/-- **Dimension 2 is attained**: there are irreps lying on a genuine embedded 2-cube. -/
theorem cubeRank_two_exists : ∃ i < 194, cubeRank i = 2 := by native_decide

/-- **`cubeRank` is the true maximal embedded-cube dimension through each vertex**: an
embedded cube of dimension `cubeRank i` exists, and none of dimension `cubeRank i + 1`
does. -/
theorem cubeRank_is_max :
    ∀ i < 194, embCube i (cubeRank i) = true ∧ embCube i (cubeRank i + 1) = false := by
  native_decide

/-- **The stratification census**: `113` irreps have cube-rank `0`, `46` have rank `1`,
and `35` have rank `2`. -/
theorem cubeRank_distribution :
    ((List.range 194).countP (fun i => cubeRank i = 0) = 113) ∧
    ((List.range 194).countP (fun i => cubeRank i = 1) = 46) ∧
    ((List.range 194).countP (fun i => cubeRank i = 2) = 35) := by
  native_decide

/-- **Each irrep belongs to its own cube-class** (it is reachable from itself by
flipping no axis). -/
theorem self_mem_cubeClass : ∀ i < 194, i ∈ cubeClassList i := by native_decide

/-- **Cube-class members agree off the free axes.**  Every `j` in the cube-class of `i`
has the same divisibility bit as `i` on every non-free coordinate — the defining
property of the stratum. -/
theorem cubeClass_agrees_offfree :
    ∀ i < 194, ∀ j ∈ cubeClassList i, ∀ c < 15,
      (freeAxes i >>> c) % 2 = 0 → (maskArr[i]! >>> c) % 2 = (maskArr[j]! >>> c) % 2 := by
  native_decide

/-- **The stabilizer mask is exactly the complement of the free axes.**  Every
supersingular prime is *either* a free (varying) axis of the maximal cube through `i`,
*or* a frozen coordinate on which the whole cube-class agrees — never both, never
neither.  So the stabilizer mask records precisely the frozen coordinates of the
stratum. -/
theorem stabilizerMask_eq_complement :
    ∀ i < 194,
      stabilizerList i =
        ((List.range 15).filter (fun c => (freeAxes i >>> c) % 2 = 0)).map
          (fun c => primesList[c]!) := by
  native_decide

/-- The free primes and the stabilizer primes partition the 15 supersingular primes. -/
theorem free_stabilizer_partition :
    ∀ i < 194, (freePrimesList i).length + (stabilizerList i).length = 15 := by
  native_decide

/-! ## Assembling the atlas -/

/-- The **Monster Hypercube Atlas**: a stratification of the 194 irreps by their local
hypercube geometry.  `cubeRank` gives the dimension of the stratum, `cubeClass` its
vertices, `stabilizerMask` its frozen coordinates, and `certified` is the proposition
that these data satisfy the cube axioms. -/
structure HypercubeAtlas where
  cubeRank : Fin 194 → ℕ
  cubeClass : Fin 194 → Finset (Fin 194)
  stabilizerMask : Fin 194 → Finset ℕ
  certified : Prop

/-- The cube axioms the Monster atlas satisfies (the content of its `certified` field):
local dimensions are `≤ 2` and exact, every vertex lies in its own class, classes are
constant off the free axes, and the stabilizer mask is the complement of the free
axes. -/
def AtlasAxioms : Prop :=
  (∀ i < 194, cubeRank i ≤ 2) ∧
  (∀ i < 194, embCube i (cubeRank i) = true ∧ embCube i (cubeRank i + 1) = false) ∧
  (∀ i < 194, i ∈ cubeClassList i) ∧
  (∀ i < 194, ∀ j ∈ cubeClassList i, ∀ c < 15,
      (freeAxes i >>> c) % 2 = 0 → (maskArr[i]! >>> c) % 2 = (maskArr[j]! >>> c) % 2) ∧
  (∀ i < 194,
      stabilizerList i =
        ((List.range 15).filter (fun c => (freeAxes i >>> c) % 2 = 0)).map
          (fun c => primesList[c]!))

/-- The assembled atlas for the Monster's 194 irreps. -/
def monsterAtlas : HypercubeAtlas where
  cubeRank i := rankArr[i.1]!
  cubeClass i := Finset.univ.filter (fun j => j.1 ∈ cubeClassList i.1)
  stabilizerMask i := (stabilizerList i.1).toFinset
  certified := AtlasAxioms

/-- **The Monster Hypercube Atlas is certified**: all four fields satisfy the cube
axioms. -/
theorem monsterAtlas_certified : monsterAtlas.certified := by
  refine ⟨cubeRank_le_two, cubeRank_is_max, self_mem_cubeClass, cubeClass_agrees_offfree,
    stabilizerMask_eq_complement⟩

end MonsterAtlas
