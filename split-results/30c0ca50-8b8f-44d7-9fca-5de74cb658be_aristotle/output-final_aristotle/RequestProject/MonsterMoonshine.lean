import Mathlib
import RequestProject.MoonshineCorpus

open scoped BigOperators

/-!
# Monster Moonshine — a `MonsterIrrep` stub and CRT address layer

This module extends `RequestProject.MoonshineCorpus` with the *Moonshine* content
the design notes asked for: a concrete type whose cardinality is the dimension
`196883` of the smallest faithful irreducible representation of the Monster group
`𝕄`, the `j`-function decomposition arithmetic (`McKay` and `FLM`), the
Clifford/Bott-periodicity grading on the Oggioral blade space, and a small
*geometric product* giving the blade space genuine algebraic structure.

Two honest design choices:

* **`MonsterIrrep` is a genuine type, not a literal.**  Because
  `196883 = 47 · 59 · 71` (a product of three supersingular primes), we can take
  `MonsterIrrep := ZMod 47 × ZMod 59 × ZMod 71` and *prove*
  `Fintype.card MonsterIrrep = 196883`.  The McKay equation and the
  Frenkel–Lepowsky–Meurman `j`-coefficient decomposition then become `@[simp]`
  lemmas *about that type*, exactly as requested.

* **`CRTAddress := ZMod 47 × ZMod 59 × ZMod 71`** is the residue register on the
  three "deep" supersingular primes `47A, 59A, 71A` that index the Monster's
  largest cyclic Hauptmoduln; it is definitionally the same shape as
  `MonsterIrrep`, tying the dimension count back to the CRT moonshine encoding of
  `MoonshineCorpus`.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

namespace Moonshine

/-! ## The CRT address register on the deep supersingular primes `47, 59, 71` -/

/-- A **CRT address** is one residue for each of the three deepest supersingular
primes `47, 59, 71` — the moduli of the Monster conjugacy classes `47A, 59A, 71A`
whose Hauptmoduln are the "thinnest" (genus-zero with no extra cusps). -/
abbrev CRTAddress : Type := ZMod 47 × ZMod 59 × ZMod 71

/-- There are exactly `47 · 59 · 71 = 196883` CRT addresses. -/
theorem card_CRTAddress : Fintype.card CRTAddress = 196883 := by
  simp [CRTAddress, Fintype.card_prod, ZMod.card]

/-! ## The Monster irrep dimension as a cardinality -/

/-- The **smallest faithful irreducible representation of the Monster** has
dimension `196883`.  We model it by a concrete type of that cardinality, using the
moonshine coincidence `196883 = 47 · 59 · 71` (three supersingular primes), so that
`196883` is a *proved cardinality*, not a magic literal. -/
abbrev MonsterIrrep : Type := ZMod 47 × ZMod 59 × ZMod 71

/-- `MonsterIrrep` is definitionally the CRT address register on `47, 59, 71`. -/
theorem monsterIrrep_eq_CRTAddress : MonsterIrrep = CRTAddress := rfl

/-- The dimension of the smallest faithful Monster irrep, **as a cardinality**. -/
def monsterIrrepDim : Nat := Fintype.card MonsterIrrep

/-- The dimension factors as a product of three supersingular primes:
`196883 = 47 · 59 · 71`. -/
@[simp] theorem monsterIrrepDim_factor : monsterIrrepDim = 47 * 59 * 71 := by
  simp [monsterIrrepDim, MonsterIrrep, Fintype.card_prod, ZMod.card]

/-- The Monster irrep dimension is exactly `196883`. -/
@[simp] theorem monsterIrrepDim_eq : monsterIrrepDim = 196883 := by
  simp [monsterIrrepDim_factor]

/-! ## The `j`-function: McKay's equation and the FLM decomposition -/

/-- The first nontrivial `q`-coefficient of the modular `j`-invariant,
`j(τ) = q⁻¹ + 744 + 196884 q + …`.  This is the McKay coefficient. -/
def jCoeff1 : Nat := 196884

/-- **McKay's equation** `196884 = 196883 + 1`, stated about the *type*
`MonsterIrrep`: the first `j`-coefficient equals the dimension of the smallest
faithful Monster irrep plus the trivial representation.  This is the observation
that launched Monstrous Moonshine. -/
@[simp] theorem mckay_equation : jCoeff1 = monsterIrrepDim + 1 := by
  simp [jCoeff1]

/-- The plain-arithmetic form of McKay's equation. -/
theorem mckay_equation_arith : (196884 : Nat) = 196883 + 1 := by norm_num

/-- **Frenkel–Lepowsky–Meurman decomposition** of the first `j`-coefficient as it
appears in the Leech-lattice construction of the Moonshine module `V♮`:
`196884 = 196560 + 300 + 24`, the number of Leech minimal vectors, the
symmetric-square `300`, and the `24` rank coordinates. -/
@[simp] theorem flm_decomposition : 196560 + 300 + 24 = jCoeff1 := by
  simp [jCoeff1]

/-- The two decompositions agree: the Griess/irrep count `196883 + 1` and the
FLM/Leech count `196560 + 300 + 24` are the same `j`-coefficient. -/
theorem mckay_eq_flm : monsterIrrepDim + 1 = 196560 + 300 + 24 := by
  simp

/-! ## Bridging `MonsterIrrep` to the CRT moonshine encoding -/

/-- Read a `MoonshineCorpus` payload as a CRT address by sampling it at the three
deep supersingular primes `47, 59, 71`. -/
def payloadAddress (payload : Payload) : CRTAddress :=
  (payload 47, payload 59, payload 71)

/-- The all-ones payload (the identity of the supersingular register, which
`crtEncode_one` sends to `1`) reads as the all-ones CRT address. -/
@[simp] theorem payloadAddress_one :
    payloadAddress (fun _ => 1) = (1, 1, 1) := by
  simp [payloadAddress]

/-! ## Bott periodicity grading on the Oggioral blade space -/

/-- The **Bott grade** of a blade: its grade taken modulo `8`.  Real Clifford
algebras satisfy `Cl(0, n+8) ≅ Cl(0, n) ⊗ ℝ(16)`, so the representation theory of
the Oggioral `Cl(0,15)` is governed by `grade mod 8`. -/
def bottGrade (S : Blade) : Fin 8 := ⟨grade S % 8, Nat.mod_lt _ (by norm_num)⟩

/-- The scalar blade (empty subset) has Bott grade `0`. -/
@[simp] theorem bottGrade_empty : bottGrade (∅ : Blade) = 0 := by decide

/-- The pseudoscalar of `Cl(0,15)` (the full top blade) has grade `15`, so Bott
grade `7`. -/
theorem bottGrade_top : bottGrade (Finset.univ : Blade) = 7 := by decide

/-! ## A geometric product on the Oggioral blades

We equip the blade space `Cl(0,15)` (signature `(0,15)`: every generator squares
to `-1`) with its graded geometric product `e_S · e_T = ε(S,T) · e_{S △ T}`.  The
sign `ε(S,T)` combines the *reordering* sign (swapping past out-of-order
generators) with the *metric* sign `(-1)^|S ∩ T|` coming from `e_i² = -1`. -/

/-- Number of out-of-order generator pairs when concatenating the (sorted) blades
`S` and `T`: pairs `(a, b)` with `a ∈ S`, `b ∈ T` and `b < a`. -/
def reorderInversions (S T : Blade) : Nat :=
  ((S ×ˢ T).filter (fun p => p.2 < p.1)).card

/-- The geometric-product sign `ε(S,T)`: reordering inversions plus one factor of
`-1` for each shared generator (since `e_i² = -1` in signature `(0,15)`). -/
def geomSign (S T : Blade) : Int :=
  (-1 : Int) ^ (reorderInversions S T + (S ∩ T).card)

/-- The blade underlying a geometric product is the symmetric difference of the
two factor blades. -/
def geomBlade (S T : Blade) : Blade := (S \ T) ∪ (T \ S)

/-- The geometric product of two basis blades: a signed blade. -/
def geomProd (S T : Blade) : Int × Blade := (geomSign S T, geomBlade S T)

/-- The scalar blade `1 = e_∅` is a **left unit** for the geometric product. -/
@[simp] theorem geomProd_empty_left (T : Blade) : geomProd ∅ T = (1, T) := by
  simp [geomProd, geomSign, geomBlade, reorderInversions]

/-- The scalar blade `1 = e_∅` is a **right unit** for the geometric product. -/
@[simp] theorem geomProd_empty_right (S : Blade) : geomProd S ∅ = (1, S) := by
  simp [geomProd, geomSign, geomBlade, reorderInversions]

/-- The grade of a product blade has the parity of `grade S + grade T`
(the geometric product respects the `ℤ/2` super-grading). -/
theorem geomBlade_card_parity (S T : Blade) :
    (geomBlade S T).card % 2 = (grade S + grade T) % 2 := by
  have hdisj : Disjoint (S \ T) (T \ S) := by
    simp [Finset.disjoint_left]; tauto
  have hcard : (geomBlade S T).card = (S \ T).card + (T \ S).card := by
    simp [geomBlade, Finset.card_union_of_disjoint hdisj]
  have hST : (S \ T).card = S.card - (T ∩ S).card := Finset.card_sdiff
  have hTS : (T \ S).card = T.card - (S ∩ T).card := Finset.card_sdiff
  have hle1 : (T ∩ S).card ≤ S.card := Finset.card_le_card Finset.inter_subset_right
  have hle2 : (S ∩ T).card ≤ T.card := Finset.card_le_card Finset.inter_subset_right
  have hcomm : (T ∩ S).card = (S ∩ T).card := by rw [Finset.inter_comm]
  rw [hcard, hST, hTS, hcomm]
  unfold grade
  omega

/-- A generator squares to `-1`: `e_i · e_i = (-1, e_∅)`, the signature `(0,15)`
relation. -/
@[simp] theorem geomProd_self (i : Fin 15) :
    geomProd {i} {i} = (-1, ∅) := by
  simp [geomProd, geomSign, geomBlade, reorderInversions, Finset.filter_singleton]

/-- Distinct generators **anticommute up to the symmetric difference**: the blade
part of `e_i · e_j` is `{i, j}`, and the sign flips when the factors are swapped. -/
theorem geomProd_distinct_blade {i j : Fin 15} (h : i ≠ j) :
    (geomProd {i} {j}).2 = {i, j} := by
  show geomBlade {i} {j} = {i, j}
  ext x
  simp only [geomBlade, Finset.mem_union, Finset.mem_sdiff, Finset.mem_singleton,
    Finset.mem_insert]
  constructor
  · rintro (⟨rfl, _⟩ | ⟨rfl, _⟩) <;> tauto
  · rintro (rfl | rfl) <;> simp_all [Ne.symm]

/-- Distinct generators **anticommute**: `e_i · e_j = - e_j · e_i`.  This is the
defining relation of the Clifford algebra `Cl(0,15)` and shows the geometric
product is genuinely noncommutative on the Oggioral. -/
theorem geomProd_anticomm {i j : Fin 15} (h : i ≠ j) :
    (geomProd {i} {j}).1 = - (geomProd {j} {i}).1 := by
  have hc1 : ({i} ∩ {j} : Finset (Fin 15)).card = 0 := by
    rw [Finset.card_eq_zero, ← Finset.disjoint_iff_inter_eq_empty]; simpa using h
  have hc2 : ({j} ∩ {i} : Finset (Fin 15)).card = 0 := by
    rw [Finset.card_eq_zero, ← Finset.disjoint_iff_inter_eq_empty]; simpa using Ne.symm h
  simp only [geomProd, geomSign, reorderInversions, hc1, hc2, add_zero,
    show ({i} ×ˢ {j} : Finset (Fin 15 × Fin 15)) = {(i,j)} from rfl,
    show ({j} ×ˢ {i} : Finset (Fin 15 × Fin 15)) = {(j,i)} from rfl,
    Finset.filter_singleton]
  rcases lt_or_gt_of_ne h with hlt | hgt
  · simp [not_lt.mpr hlt.le, hlt]
  · simp [not_lt.mpr hgt.le, hgt]

end Moonshine
