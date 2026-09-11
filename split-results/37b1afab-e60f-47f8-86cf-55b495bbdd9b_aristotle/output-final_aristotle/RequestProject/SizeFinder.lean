import Mathlib
import RequestProject.Monster

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000
set_option autoImplicit false

/-!
# `SizeFinder`: mapping "data in the wild" back onto the discrete syntax crystals

The earlier files (`RequestProject.Main`, `RequestProject.Monster`,
`RequestProject.MonsterInvariants`, `RequestProject.Tower`) live entirely in the *discrete*
regime: structural sizes, branch depths, valuation profiles and supersingular counts are all
natural numbers. This file extends the matching layer so that **continuous / signed data "in
the wild"** — noisy dependency paths, runtime profiles, physical-lattice frequencies — can be
mapped back onto those discrete invariants *without fracturing the underlying algebraic
relations*.

The matching layer splits into two regimes (and one rigorous bridge between them):

* **Pure integer matching (`Int`).** Mapping to `ℤ` keeps the discrete structure exact but
  adds **directionality / sign**: a negative signature is an *inverted path* / contrapositive
  step / dual (transpose–dagger) operator. The quadratic "Clifford" form `e_z · e_z = z²` is
  preserved exactly, and matching is exact structural unification.

* **Floating-point matching (`Float`).** Raw measurements like `4.001` or `46.998` cannot be
  compared by exact equality (`Float` rounding makes `decide (x == y)` unstable). Instead the
  structural bijection is replaced by an **ε-neighborhood threshold trap**:
  `matchFloatPattern ε wild pattern` accepts iff `|wild − pattern| < ε`. This is the *executable*
  layer; `Float` is opaque to the kernel, so it carries no proofs beyond concrete
  `native_decide` checks.

* **The rigorous bridge (ordered fields: `ℝ`, `ℚ`).** The real mathematical content of the
  "ε-neighborhood trap" is proved over any linearly ordered field (so it applies to both `ℝ`
  and the *computable* `ℚ` model that mirrors `Float`): under a sufficiently tight filter
  (`ε ≤ 1/2`), a noisy value **precipitates uniquely** into a single discrete integer
  (`snap_unique`). Existence of a capture (`round` lands within `1/2`, `snap_round_dist`)
  completes the picture: the wild datum snaps to exactly one lattice node, treating the
  floating-point noise as a trivial displacement on the lattice.

The geometric-quantization / Clifford-blade / "15-channel p-adic table" framing is kept as
labeled docstring motivation; the statements below are the precise, machine-checked residue.
-/

namespace SizeFinder

open Monster

/-! ## 1. Pure integer matching: exact unification with sign / directionality

Mapping a wild signature to `ℤ` keeps the matching exact (structural unification) while adding
a *sign*. The discrete "size generator" `sizeGen` is the identity embedding, and the Clifford
quadratic form on a generator is its square `e_z · e_z = z²`, which is invariant under the dual
(sign-flip / transpose–dagger) operation `z ↦ -z`. -/

/-- The discrete size generator: the identity embedding of a signed size into `ℤ`. -/
def sizeGen (z : ℤ) : ℤ := z

/-- The Clifford quadratic form on a single generator: `e_z · e_z`. -/
def cliffordSq (z : ℤ) : ℤ := sizeGen z * sizeGen z

/-- The Clifford relation is exact over `ℤ`: `e_z · e_z = z²`. -/
theorem cliffordSq_eq_sq (z : ℤ) : cliffordSq z = z ^ 2 := by
  unfold cliffordSq sizeGen; ring

/-- **Dual / sign symmetry.** The quadratic form is invariant under the dual operator
`z ↦ -z` (transpose–dagger): an inverted path has the same Clifford signature. -/
theorem cliffordSq_neg (z : ℤ) : cliffordSq (-z) = cliffordSq z := by
  unfold cliffordSq sizeGen; ring

/-- Exact integer matching: structural unification of a wild signed signature with a pattern. -/
def matchIntPattern (wild pattern : ℤ) : Bool := wild == pattern

/-- Integer matching is exact: it accepts iff the signatures are literally equal. -/
theorem matchIntPattern_iff (wild pattern : ℤ) :
    matchIntPattern wild pattern = true ↔ wild = pattern := by
  unfold matchIntPattern; simp

/-- Integer matching is sign-aware: matching is preserved under the dual `z ↦ -z` applied to
both wild datum and pattern (a global inversion of orientation matches the dual pattern). -/
theorem matchIntPattern_dual (wild pattern : ℤ) :
    matchIntPattern (-wild) (-pattern) = matchIntPattern wild pattern := by
  unfold matchIntPattern
  by_cases h : wild = pattern
  · subst h; simp
  · have h2 : -wild ≠ -pattern := by simpa using h
    simp [h, h2]

/-! ## 2. The ε-neighborhood trap, rigorously (ordered fields: `ℝ`, `ℚ`)

This is the mathematical heart: in *any* linearly ordered field — in particular `ℝ` (the ideal
continuum) and `ℚ` (a computable stand-in for `Float`) — a value `x` cannot lie within a
half-unit window of two distinct integers. So under the tight filter `ε ≤ 1/2` the trap is
*injective on accepted patterns*: the wild datum precipitates **uniquely** into a single
discrete integer node. -/

/-- **Uniqueness of snapping (the ε-neighborhood trap).** If a value `x` lies within `ε ≤ 1/2`
of two integers `n` and `m`, then `n = m`: under a sufficiently tight filter the wild datum
precipitates uniquely into a single discrete node, no matter how noisy the input. -/
theorem snap_unique {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]
    {x ε : K} (hε : ε ≤ 1 / 2)
    {n m : ℤ} (hn : |x - (n : K)| < ε) (hm : |x - (m : K)| < ε) : n = m := by
  have hle : |(n : K) - (m : K)| ≤ |x - (n : K)| + |x - (m : K)| := by
    rw [abs_sub_comm x (n : K)]
    calc |(n : K) - m| = |((n : K) - x) + (x - m)| := by ring_nf
      _ ≤ |(n : K) - x| + |x - m| := abs_add_le _ _
  have h : |(n : K) - (m : K)| < 1 := by linarith
  have e1 : |(n : K) - (m : K)| = (|n - m| : ℤ) := by push_cast; ring_nf
  rw [e1] at h
  have h2 : |n - m| < 1 := by exact_mod_cast h
  have h3 := abs_lt.mp h2
  omega

/-- The `ℕ`-pattern corollary: snapping onto natural-number sizes is also unique under `ε ≤ 1/2`. -/
theorem snap_unique_nat {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]
    {x ε : K} (hε : ε ≤ 1 / 2)
    {n m : ℕ} (hn : |x - (n : K)| < ε) (hm : |x - (m : K)| < ε) : n = m := by
  have : (n : ℤ) = (m : ℤ) := by
    apply snap_unique (K := K) hε
    · simpa using hn
    · simpa using hm
  exact_mod_cast this

/-- **Existence of a capture.** Rounding to the nearest integer always lands within `1/2`:
`round x` is a node the trap can snap `x` to. Combined with `snap_unique` (for `ε ≤ 1/2`) this
says the wild datum snaps to *exactly one* lattice node, the floating-point noise being a
trivial displacement. -/
theorem snap_round_dist {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]
    [FloorRing K] (x : K) : |x - (round x : K)| ≤ 1 / 2 :=
  abs_sub_round x

/-! ## 3. The computable rational matcher (a verified mirror of the `Float` matcher)

`ℚ` is both decidable and amenable to proof, so we use it as the computable model of the
continuous matcher: `matchRatPattern` is the exact analogue of `matchFloatPattern` below, but
its acceptance is a genuine, provable proposition. The uniqueness theorem transfers verbatim. -/

/-- The rational ε-neighborhood matcher: accepts iff `|wild − pattern| < ε`. -/
def matchRatPattern (ε wild : ℚ) (pattern : ℤ) : Bool :=
  decide (|wild - (pattern : ℚ)| < ε)

/-- The rational matcher accepts exactly when the datum is within `ε` of the pattern. -/
theorem matchRatPattern_iff (ε wild : ℚ) (pattern : ℤ) :
    matchRatPattern ε wild pattern = true ↔ |wild - (pattern : ℚ)| < ε := by
  unfold matchRatPattern; rw [decide_eq_true_eq]

/-- **Unique precipitation, computably.** Under a tight filter `ε ≤ 1/2`, the rational matcher
accepts at most one pattern: a noisy `ℚ` datum snaps to a single discrete node. -/
theorem matchRatPattern_unique {ε wild : ℚ} (hε : ε ≤ 1 / 2) {n m : ℤ}
    (hn : matchRatPattern ε wild n = true) (hm : matchRatPattern ε wild m = true) : n = m := by
  rw [matchRatPattern_iff] at hn hm
  exact snap_unique (K := ℚ) hε hn hm

/-- A concrete capture: a noisy measurement `46.998` snaps onto the silver `47`-coin under a
half-unit filter. -/
theorem matchRat_47_capture : matchRatPattern (1 / 2) (46998 / 1000) 47 = true := by
  native_decide

/-- ...and the same noisy measurement is *rejected* by the neighbouring `46` node — there is no
phantom double match. -/
theorem matchRat_47_reject_46 : matchRatPattern (1 / 2) (46998 / 1000) 46 = false := by
  native_decide

/-! ## 4. The floating-point matcher (the executable "data in the wild" layer)

`Float` is opaque to the kernel, so this layer is *executable* (driving `#eval` pipelines and
verified only by concrete `native_decide` checks); its rigorous guarantees are exactly those
proved over `ℝ` / `ℚ` above, of which `Float` is the lossy physical shadow. -/

/-- A continuous shape token found in the wild: a labelled floating-point measurement. -/
structure WildToken where
  id    : String
  value : Float
  deriving Repr

/-- The ε-matching criterion for the syntax crystals: a wild `Float` matches a discrete `Nat`
pattern iff it lies in the open ε-neighborhood of that pattern. -/
def matchFloatPattern (epsilon : Float) (wild : Float) (pattern : Nat) : Bool :=
  let patFloat := pattern.toFloat
  (wild - patFloat).abs < epsilon

/-- Snap a wild token to the first candidate discrete node within the ε-window (the executable
trapping + snapping layers of the pipeline). -/
def snapWild (epsilon : Float) (candidates : List Nat) (w : WildToken) : Option Nat :=
  candidates.find? (fun p => matchFloatPattern epsilon w.value p)

/-- Concrete `Float` captures: `4.001` snaps to `4`, `46.998` snaps to the `47`-coin, and a
value squarely between two nodes is rejected by the tight filter. -/
theorem matchFloat_4_capture : matchFloatPattern 0.5 4.001 4 = true := by native_decide

theorem matchFloat_47_capture : matchFloatPattern 0.5 46.998 47 = true := by native_decide

theorem matchFloat_midpoint_reject : matchFloatPattern 0.4 4.5 4 = false := by native_decide

/-! ## 5. The geometric classifier pipeline

`SizeFinder` runs wild data through three stages — a Float/Int profiler, the ε-neighborhood
trap (snapping to a discrete `sizeWord`), and the algebraic Clifford layer — and looks the
result up in the **15-channel** supersingular table of `RequestProject.Monster`. The headline
property is that, with a half-unit filter, even a noisy stream lands on a *single* supersingular
channel (here the silver `47`-coin), structurally sound and free of phantom anomalies. -/

/-- The 15 discrete channels of the p-adic table: the supersingular primes (as `Nat` patterns)
that wild data is snapped onto. -/
def channels : List Nat := Monster.supersingularPrimes

/-- A noisy stream around the `47`-coin snaps, under a half-unit filter, onto exactly `47`,
which is a genuine supersingular channel. -/
theorem snap_to_47_channel :
    snapWild 0.5 channels ⟨"wild-47", 46.998⟩ = some 47 ∧ (47 ∈ channels) := by
  constructor
  · native_decide
  · decide

/-- Run the continuous-to-discrete classifier on a few wild tokens and report the snapped
channels and their Clifford signatures. -/
def runSizeFinder : IO Unit := do
  let tokens : List WildToken :=
    [⟨"path-2", 2.003⟩, ⟨"path-7", 6.997⟩, ⟨"coin-47", 46.998⟩, ⟨"noise", 4.5⟩]
  IO.println s!"Channels (15 supersingular primes): {channels}"
  for t in tokens do
    match snapWild 0.5 channels t with
    | some p =>
        IO.println s!"  {t.id}: {t.value} ⇝ snapped to channel {p}, Clifford sig e·e = {cliffordSq (Int.ofNat p)}"
    | none =>
        IO.println s!"  {t.id}: {t.value} ⇝ no channel within ε (phantom rejected)"

#eval runSizeFinder

end SizeFinder
