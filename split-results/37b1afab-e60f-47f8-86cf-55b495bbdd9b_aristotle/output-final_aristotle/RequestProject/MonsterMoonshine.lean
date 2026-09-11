import Mathlib

set_option autoImplicit false

/-!
# Monstrous Moonshine: the head of the moonshine module, fully checked

"If you want the monster, just ask — I have more."  The companion file
`RequestProject/Monster.lean` grounds the project's Umwelt in **Ogg's observation**: the
primes dividing the order of the Monster sporadic simple group `M` are exactly the 15
supersingular primes.  This file formalizes the *other* half of the Monster's shadow — the
phenomenon that started it all, **Monstrous Moonshine**.

In 1978 John McKay noticed that the first nontrivial Fourier coefficient of the modular
`j`-invariant,

    j(τ) = q⁻¹ + 744 + 196884 q + 21493760 q² + 864299970 q³ + ⋯   (q = e^{2πiτ}),

satisfies `196884 = 196883 + 1`, where `196883` is the dimension of the smallest faithful
irreducible representation of `M` and `1` is the trivial representation.  Thompson extended
this: *every* coefficient of `J := j − 744` is a small non-negative integer combination of
the dimensions of the irreducible representations of the Monster.  Conway and Norton turned
this into the Monstrous Moonshine conjectures, proved by Borcherds (1992, Fields Medal).

Everything below is the *concrete, kernel-checkable* arithmetic core of that story: the
graded pieces `V_n` of the (head of the) moonshine module `V♮` decompose into Monster
irreducibles with the multiplicities tabulated in `moonshineMult`, and the resulting
dimensions are *exactly* the coefficients of `J`.  All proofs are by `decide`, so the file
adds no trust-base axioms beyond Lean's standard `propext`/`Classical.choice`/`Quot.sound`.
-/

namespace MonsterMoonshine

/-! ## 1. The smallest irreducible representations of the Monster -/

/-- Dimensions of the seven smallest irreducible representations of the Monster group `M`,
in increasing order: the trivial representation `1`, then
`196883, 21296876, 842609326, 18538750076, 19360062527, 293553734298`. -/
def irrepDims : List ℕ :=
  [1, 196883, 21296876, 842609326, 18538750076, 19360062527, 293553734298]

/-- We track the seven smallest irreducibles. -/
theorem irrepDims_length : irrepDims.length = 7 := by decide

/-- The dimensions are strictly increasing (in particular pairwise distinct). -/
theorem irrepDims_pairwise_lt : irrepDims.Pairwise (· < ·) := by decide

/-- In particular the dimensions are pairwise distinct. -/
theorem irrepDims_nodup : irrepDims.Nodup := by decide

/-- The trivial representation has dimension `1`. -/
theorem irrepDims_trivial : irrepDims.head? = some 1 := by decide

/-- McKay's representation: `196883` is the dimension of the smallest *faithful*
(equivalently here, smallest nontrivial) irreducible representation of the Monster. -/
theorem smallest_faithful_dim : irrepDims[1]! = 196883 := by decide

/-! ## 2. The Fourier coefficients of `J = j − 744` -/

/-- The first five Fourier coefficients `c(1),…,c(5)` of the normalized modular invariant
`J(τ) = j(τ) − 744 = q⁻¹ + ∑_{n≥1} c(n) qⁿ`:
`196884, 21493760, 864299970, 20245856256, 333202640600`. -/
def jCoeff : List ℕ :=
  [196884, 21493760, 864299970, 20245856256, 333202640600]

/-- McKay's original observation (1978): the first coefficient of `J` is the smallest
faithful Monster dimension plus the trivial dimension, `196884 = 196883 + 1`. -/
theorem mckay_observation : jCoeff.head? = some (196883 + 1) := by decide

/-! ## 3. The head of the moonshine module `V♮`

`mult` is the list of multiplicities `(a₁,…,a₇)` of the seven irreducibles, so the graded
piece it describes has dimension `headChar mult = ∑ᵢ aᵢ · dᵢ`. -/

/-- The dimension of a graded piece given its multiplicity vector against `irrepDims`. -/
def headChar (mult : List ℕ) : ℕ := (List.zipWith (· * ·) mult irrepDims).sum

/-- The Monster-module decomposition multiplicities for the graded pieces `V₁,…,V₅` of the
moonshine module `V♮` (one row per power of `q`, each row giving the multiplicities of the
seven irreducibles of `irrepDims`).  These are the classical McKay–Thompson head
characters. -/
def moonshineMult : List (List ℕ) :=
  [[1, 1, 0, 0, 0, 0, 0],
   [1, 1, 1, 0, 0, 0, 0],
   [2, 2, 1, 1, 0, 0, 0],
   [3, 3, 1, 2, 1, 0, 0],
   [4, 5, 3, 2, 1, 1, 1]]

/-- **Monstrous Moonshine (the head, fully checked).**  Decomposing each graded piece
`Vₙ` of the moonshine module into Monster irreducibles with the multiplicities of
`moonshineMult` yields *exactly* the Fourier coefficients of `J = j − 744`.  This is the
arithmetic heart of McKay's `196884 = 196883 + 1` and Thompson's extension to all
coefficients. -/
theorem moonshine_relation : moonshineMult.map headChar = jCoeff := by decide

/-- Coefficient-by-coefficient form: the `n`-th coefficient of `J` equals the dimension of
the corresponding graded piece of `V♮`. -/
theorem moonshine_relation_pointwise :
    ∀ n : ℕ, jCoeff[n]? = (moonshineMult.map headChar)[n]? := by rw [moonshine_relation]; intro n; rfl

/-- Each moonshine multiplicity row records all seven irreducibles. -/
theorem moonshineMult_widths : ∀ row ∈ moonshineMult, row.length = irrepDims.length := by
  decide

/-- The number of tabulated graded pieces matches the number of tabulated coefficients. -/
theorem moonshine_count : moonshineMult.length = jCoeff.length := by decide

/-! ## 4. The first three relations, spelled out

These are the historically decisive identities (McKay, then Thompson), each here as an
honest natural-number equation. -/

/-- `c(1) = 196884 = 196883 + 1`. -/
theorem coeff1 : (196884 : ℕ) = 196883 + 1 := by decide

/-- `c(2) = 21493760 = 21296876 + 196883 + 1`. -/
theorem coeff2 : (21493760 : ℕ) = 21296876 + 196883 + 1 := by decide

/-- `c(3) = 864299970 = 842609326 + 21296876 + 2·196883 + 2·1`. -/
theorem coeff3 :
    (864299970 : ℕ) = 842609326 + 21296876 + 2 * 196883 + 2 * 1 := by decide

/-! ## 5. A runnable summary -/

/-- Print the moonshine head: irreducible dimensions, `J`-coefficients, and the verified
McKay–Thompson decompositions. -/
def runMoonshine : IO Unit := do
  IO.println s!"Monster irreducible dimensions (smallest 7): {irrepDims}"
  IO.println s!"J = j - 744 coefficients c(1..5): {jCoeff}"
  IO.println s!"McKay: 196884 = 196883 + 1"
  IO.println "Thompson head characters (multiplicities ⋅ dimensions = coefficient):"
  for (mult, c) in moonshineMult.zip jCoeff do
    IO.println s!"  {mult}  ↦  {headChar mult}   (= c = {c}: {headChar mult == c})"

#eval runMoonshine

end MonsterMoonshine
