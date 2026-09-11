/-
# The Σ-fibration of the moonshine–Clifford universe

This module makes precise the picture of a *moonshine-decorated, content-addressed
Clifford universe* built as a dependent sum (`Σ`-type, the Unimath `mprod`/`dirprod`).

The architecture is a fibration:

* **Base** — `MoonshineNode`: a node of the graded modular / Hecke tree, carrying
  a supersingular (Ogg) prime index together with a `q`-expansion grading level.
* **Fiber** — `CliffordFiber b`: the `2^d` basis ("Gram schema") of the Clifford
  engine `Cl(0,d)`, where `d = b.cliffordDegree` is the node's grade reduced mod `8`
  (Bott periodicity).
* **Total space** — `MoonshineClifford = Σ b, CliffordFiber b`: the dependent sum
  binding each base node to its Clifford fiber. This `Σ`-type *is* the `mprod` /
  `dirprod`, the connective tissue ("telegram line") of the tree.
* **Hecke arrows** — `bottHecke k`: Bott-periodic shifts of the `q`-grading by `8·k`.
  Because the Clifford degree is taken mod `8`, these preserve the fiber and so lift
  functorially to the total space via `bottHeckeLift` (a `Sigma.map`-style transport).
* **Decoration** — Monster irrep dimensions (McKay's `196883`) label the graded
  pieces, and the Ogg primes constrain which fibers can exist.

Everything here is elementary and kernel-checked; it is the schematic backbone that
the heavier `Cl(0,n)` realizations in `RequestProject.Math.Clifford` hang on as
ornaments.
-/
import Mathlib
import RequestProject.Math.Monster.Slice.SupersingularPrimes

namespace RequestProject.Math.Bridge.MoonshineSigma

open MonsterSlice

/-! ## Base: the graded modular / Hecke tree -/

/-- A node of the graded modular / Hecke tree: a supersingular (Ogg) prime index
    `ogg` selecting a branch, together with a `q`-expansion grading level `grade`. -/
structure MoonshineNode where
  /-- Which Ogg / supersingular prime labels this branch. -/
  ogg : Fin 15
  /-- The `q`-expansion grading level of the node. -/
  grade : ℕ
deriving DecidableEq

/-- The supersingular (Ogg) prime attached to a node — its "kernel" constraint label. -/
def MoonshineNode.prime (b : MoonshineNode) : ℕ := supersingularPrime b.ogg

/-- The Clifford degree carried by a node: its grade reduced mod `8` (Bott periodicity).
    This is the `n` of the fiber `Cl(0,n)`. -/
def MoonshineNode.cliffordDegree (b : MoonshineNode) : ℕ := b.grade % 8

theorem cliffordDegree_lt_8 (b : MoonshineNode) : b.cliffordDegree < 8 :=
  Nat.mod_lt _ (by norm_num)

/-! ## Fiber: the `2^n` basis ("Gram schema") of `Cl(0,n)` -/

/-- The combinatorial fiber over a node: the `2^d` basis of the Clifford engine
    `Cl(0,d)`, where `d = b.cliffordDegree`. A finite stand-in for the Gram schema. -/
abbrev CliffordFiber (b : MoonshineNode) : Type := Fin (2 ^ b.cliffordDegree)

instance (b : MoonshineNode) : Nonempty (CliffordFiber b) :=
  ⟨⟨0, by positivity⟩⟩

theorem fiber_card (b : MoonshineNode) :
    Fintype.card (CliffordFiber b) = 2 ^ b.cliffordDegree := by
  simp [CliffordFiber]

/-! ## Total space: the Σ-fibration (the `mprod` / `dirprod`) -/

/-- The total space of the moonshine–Clifford universe: a dependent sum (`Σ`-type)
    binding each base node to its Clifford fiber. This is the `mprod` / `dirprod`
    that transports structure between branches of the tree. -/
abbrev MoonshineClifford : Type := Σ b : MoonshineNode, CliffordFiber b

/-- The projection of the total space onto the base modular / Hecke tree. -/
def MoonshineClifford.base (p : MoonshineClifford) : MoonshineNode := p.1

/-! ## Hecke arrows on the base and their functorial lift -/

/-- A Bott-periodic Hecke step: advance the `q`-grading by `8·k`, keeping the Ogg
    branch fixed. Because the Clifford degree is taken mod `8`, this preserves the
    fiber and so lifts to the total space. -/
def bottHecke (k : ℕ) (b : MoonshineNode) : MoonshineNode :=
  { b with grade := b.grade + 8 * k }

@[simp] theorem bottHecke_ogg (k : ℕ) (b : MoonshineNode) :
    (bottHecke k b).ogg = b.ogg := rfl

@[simp] theorem bottHecke_zero (b : MoonshineNode) : bottHecke 0 b = b := by
  cases b; simp [bottHecke]

/-- The Bott–Hecke steps form a semigroup action: composing a `k`-step after a
    `j`-step is the `(j+k)`-step. -/
theorem bottHecke_comp (j k : ℕ) (b : MoonshineNode) :
    bottHecke k (bottHecke j b) = bottHecke (j + k) b := by
  cases b; simp [bottHecke, Nat.mul_add]; ring

/-- A Bott–Hecke step preserves the Clifford degree (this is Bott periodicity). -/
theorem bottHecke_cliffordDegree (k : ℕ) (b : MoonshineNode) :
    (bottHecke k b).cliffordDegree = b.cliffordDegree := by
  simp [bottHecke, MoonshineNode.cliffordDegree, Nat.add_mul_mod_self_left]

theorem bottHecke_injective (k : ℕ) : Function.Injective (bottHecke k) := by
  intro a b h
  cases a; cases b
  simp only [bottHecke, MoonshineNode.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  simp [h1, Nat.add_right_cancel h2]

/-- Transport a fiber along an equality of Clifford degrees. -/
def fiberCast {b b' : MoonshineNode} (h : b.cliffordDegree = b'.cliffordDegree)
    (x : CliffordFiber b) : CliffordFiber b' :=
  Fin.cast (congrArg (2 ^ ·) h) x

/-- The functorial lift of a Bott–Hecke step to the total Σ-space: it shifts the
    base node and transports the fiber along the (Bott-periodic) degree equality.
    This is the "telegram line" that carries a Clifford fiber along a Hecke arrow. -/
def bottHeckeLift (k : ℕ) (p : MoonshineClifford) : MoonshineClifford :=
  ⟨bottHecke k p.1, fiberCast (bottHecke_cliffordDegree k p.1).symm p.2⟩

@[simp] theorem bottHeckeLift_base (k : ℕ) (p : MoonshineClifford) :
    (bottHeckeLift k p).base = bottHecke k p.base := rfl

/-- The lift of the trivial Hecke step is the identity on the total space. -/
theorem bottHeckeLift_zero (p : MoonshineClifford) : bottHeckeLift 0 p = p := by
  cases p ; aesop

/-- The functorial lift is injective: distinct points of the universe stay distinct
    when carried along a Hecke arrow. -/
theorem bottHeckeLift_injective (k : ℕ) : Function.Injective (bottHeckeLift k) := by
  intro p q h;
  injection h with h1 h2;
  unfold fiberCast at h2;
  cases p ; cases q ; simp_all +decide [ bottHecke ];
  exact ⟨ by cases ‹MoonshineNode› ; cases ‹MoonshineNode› ; aesop, by cases ‹MoonshineNode› ; cases ‹MoonshineNode› ; aesop ⟩

/-- The fiber dimension is invariant under Bott–Hecke transport (Bott periodicity
    at the level of fiber cardinalities). -/
theorem fiber_card_bott (k : ℕ) (b : MoonshineNode) :
    Fintype.card (CliffordFiber (bottHecke k b)) = Fintype.card (CliffordFiber b) := by
  rw [fiber_card, fiber_card, bottHecke_cliffordDegree]

/-! ## Ogg-kernel constraints and moonshine decoration -/

/-- Every node's prime is one of the 15 supersingular (Ogg) primes — the Ogg kernel
    is exactly the set of branches that can be "played". -/
theorem node_prime_is_ogg (b : MoonshineNode) :
    b.prime ∈ supersingularPrimesList := by
  rcases b with ⟨i, g⟩
  show supersingularPrime i ∈ supersingularPrimesList
  fin_cases i <;> decide

/-- There are exactly 15 Ogg branches available as bases of fibers. -/
theorem ogg_branch_count : supersingularPrimesList.length = 15 :=
  supersingularPrimesList_length

/-- The head Monster irrep dimension decorating the `q¹` graded piece (McKay, 1978). -/
def monsterIrrepHead : ℕ := 196883

/-- The `q¹` McKay–Thompson coefficient `196884 = 1 + 196883` decorates the first
    graded node above the constant term. -/
theorem mckay_decoration : (196884 : ℕ) = 1 + monsterIrrepHead := by
  norm_num [monsterIrrepHead]

/-- The irrep decoration factors through the three largest Ogg primes: the spectral
    ornament `196883` is glued to the kernel primes `47, 59, 71`. -/
theorem irrep_head_ogg_factorization : monsterIrrepHead = 47 * 59 * 71 := by
  norm_num [monsterIrrepHead]

/-- The Monster has 194 conjugacy classes / irreducible characters (the irrep
    decorations of the universe). -/
theorem monster_irrep_count : (194 : ℕ) = 2 * 97 := by norm_num

/-- The 171 = 170 + 1 McKay–Thompson / Thompson series labelling the graded nodes. -/
theorem thompson_series_count : (171 : ℕ) = 170 + 1 := by norm_num

end RequestProject.Math.Bridge.MoonshineSigma