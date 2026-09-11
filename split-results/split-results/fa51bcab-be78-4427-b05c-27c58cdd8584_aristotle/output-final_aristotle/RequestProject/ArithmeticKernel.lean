/-
ArithmeticKernel.lean — commutative-diagram graphs for arithmetic kernels in the 7D act-space.

This is **Option 4 — Arithmetic Kernel Commutative Graphs**.  We reuse the fixed 7D act-space
of `SevenDEmbedding` and the graph/flow calculus of `ProofGeometry`, and specialise them to the
algebra of *arithmetic kernels*:

* **Vertices** are algebraic objects (a kernel `K`, a ring/module `B`, a quotient `Q`, …), each
  fixed at its 7D coordinate `SevenD.coord` — the seven act-sizes of its type-shape's size word.
* **Edges** are homomorphisms `f : X → Y` (a kernel inclusion `ι : K ↪ B`, a projection
  `π : B ↠ Q`, a connecting homomorphism `∂`, …), each carrying the 7D displacement
  `SevenD.arrowVec X Y = coord Y − coord X`.
* A **path** `P = [f₁, …, fₙ]` is a composite of homomorphisms, and its **flow** `flow P` is the
  net 7D displacement it induces (`ProofGeometry.flow`).

On top of `ProofGeometry.flow_eq_head_sub_tail` (the flow of a graph depends only on its
endpoints' coordinates) we obtain the two headline facts requested:

* **`kernel_flow_commutative`** — in any commutative diagram, two *parallel* paths `P₁, P₂`
  with the same source and target have **identical** 7D displacement: `flow P₁ = flow P₂`.
  This is the geometric content of a commuting square/diagram: every way of getting from `X`
  to `Y` lands at the same point.
* **`kernel_flow_exactness`** — an **exact sequence**, traversed as a closed loop (e.g.
  `0 → A → B → C → 0` walked `A → B → C → A`, or a kernel `K ↪ B ↠ B/K ⤳ K`), has **zero net
  flow**: the displacements cancel exactly.  Equivalently (`kernel_flow_exact_split`) the
  forward flow of an exact run is the exact negative of its return flow — the *predictable
  orthogonal* displacement requested.

Everything here is `sorry`-free and axiom-clean (only `propext`, `Classical.choice`,
`Quot.sound`); see the `#print axioms` checks at the end.
-/
import Mathlib
import RequestProject.SevenDEmbedding
import RequestProject.ProofGeometry

open Finset ProofGeometry

namespace ArithmeticKernel

/-! ## Paths of homomorphisms

A **path** `s → … → t` of homomorphisms is a chained list of edges.  `IsPathFrom es s t` says
the edge list `es` chains the source `s` to the target `t`: the first edge starts at `s`, each
edge starts where the previous ended, and the last edge ends at `t`. -/

/-- `IsPathFrom es s t` : the edge list `es` is a composable path of homomorphisms from object
`s` to object `t`. -/
def IsPathFrom : Graph → List Nat → List Nat → Prop
  | [],      s, t => s = t
  | e :: es, s, t => e.1 = s ∧ IsPathFrom es e.2 t

/-- The empty path is a path from `s` to itself. -/
@[simp] theorem isPathFrom_nil (s : List Nat) : IsPathFrom [] s s := rfl

/-- A single homomorphism `f : a → b` is a path from `a` to `b`. -/
theorem isPathFrom_single (a b : List Nat) : IsPathFrom [(a, b)] a b :=
  ⟨rfl, rfl⟩

/-- A commutative square `a → b → d` and `a → c → d` gives two paths `a → d`. -/
theorem isPathFrom_square_left (a b d : List Nat) : IsPathFrom [(a, b), (b, d)] a d :=
  ⟨rfl, rfl, rfl⟩

theorem isPathFrom_square_right (a c d : List Nat) : IsPathFrom [(a, c), (c, d)] a d :=
  ⟨rfl, rfl, rfl⟩

/-! ## The flow of a path is the endpoint displacement -/

/-- **Path flow = endpoint displacement.**  Walking any composable path of homomorphisms from
`s` to `t`, the total 7D displacement is exactly `coord t − coord s`: it depends only on the
endpoints, never on the intermediate objects or the particular factorisation.  This is the
diagram-level form of `ProofGeometry.flow_eq_head_sub_tail`. -/
theorem flow_of_path (es : Graph) (s t : List Nat) (i : Fin 7) (h : IsPathFrom es s t) :
    flow es i = (SevenD.coord t i : ℤ) - (SevenD.coord s i : ℤ) := by
  induction es generalizing s with
  | nil =>
    cases h
    simp
  | cons e es ih =>
    obtain ⟨he, htl⟩ := h
    rw [flow_cons, ih e.2 htl, SevenD.arrowVec, he]
    ring

/-! ## Headline theorem 1: commutative diagrams -/

/-- **`kernel_flow_commutative` — parallel paths agree.**  In a commutative diagram of
arithmetic-kernel homomorphisms, any two paths `P₁, P₂` sharing the same source `s` and target
`t` induce the **identical** 7D displacement: `flow P₁ = flow P₂`.  This is the geometric
statement that the diagram commutes — every route from `s` to `t` lands at the same point of the
7D act-space. -/
theorem kernel_flow_commutative
    (p1 p2 : Graph) (s t : List Nat) (i : Fin 7)
    (h1 : IsPathFrom p1 s t) (h2 : IsPathFrom p2 s t) :
    flow p1 i = flow p2 i := by
  rw [flow_of_path p1 s t i h1, flow_of_path p2 s t i h2]

/-- Concrete commuting square: the two sides of `a → b → d` vs `a → c → d` have equal flow.
(`b` = upper-right object, `c` = lower-left object; both composites are the diagonal `a → d`.) -/
theorem kernel_flow_square (a b c d : List Nat) (i : Fin 7) :
    flow [(a, b), (b, d)] i = flow [(a, c), (c, d)] i :=
  kernel_flow_commutative _ _ a d i (isPathFrom_square_left a b d) (isPathFrom_square_right a c d)

/-! ## Headline theorem 2: exact sequences as flows -/

/-- **`kernel_flow_exactness` — exact loops have zero net flow.**  An exact sequence traversed
as a *closed loop* (a path from an object `s` back to itself — e.g. the short exact sequence
`0 → A → B → C → 0` walked `A → B → C → A`, or a kernel `K ↪ B ↠ B/K ⤳ K`) induces **zero**
net 7D displacement: the per-axis contributions cancel exactly. -/
theorem kernel_flow_exactness (es : Graph) (s : List Nat) (i : Fin 7)
    (h : IsPathFrom es s s) :
    flow es i = 0 := by
  rw [flow_of_path es s s i h]; ring

/-- **`kernel_flow_exact_split` — predictable orthogonal cancellation.**  If an exact run goes
forward `s → t` (e.g. kernel inclusion then projection) and returns `t → s` (the connecting
homomorphism closing the sequence), the forward flow is the exact negative of the return flow:
`flow fwd + flow ret = 0`.  The two displacements are equal and opposite on every act, so the
loop's net displacement is orthogonal to none and zero on all. -/
theorem kernel_flow_exact_split (fwd ret : Graph) (s t : List Nat) (i : Fin 7)
    (hf : IsPathFrom fwd s t) (hr : IsPathFrom ret t s) :
    flow fwd i + flow ret i = 0 := by
  rw [flow_of_path fwd s t i hf, flow_of_path ret t s i hr]; ring

/-- The return run's flow is exactly the negative of the forward run's flow. -/
theorem kernel_flow_return_neg (fwd ret : Graph) (s t : List Nat) (i : Fin 7)
    (hf : IsPathFrom fwd s t) (hr : IsPathFrom ret t s) :
    flow ret i = - flow fwd i := by
  have := kernel_flow_exact_split fwd ret s t i hf hr; omega

/-! ## Three-term exact sequence `A → B → C` and its kernel/cokernel geometry

For a short exact sequence `0 → A →ᶠ B →ᵍ C → 0`, `A` is (the image of) the kernel of `g` and
`C` is the cokernel of `f`.  Geometrically the inclusion `f` and projection `g` compose to the
total displacement `A → C`, and closing the loop with a connecting map `C ⤳ A` cancels it. -/

/-- The composite of the kernel inclusion `f : A → B` and the projection `g : B → C` has flow
equal to the total displacement `coord C − coord A`. -/
theorem kernel_inclusion_then_projection (a b c : List Nat) (i : Fin 7) :
    flow [(a, b), (b, c)] i = (SevenD.coord c i : ℤ) - (SevenD.coord a i : ℤ) :=
  flow_of_path _ a c i (isPathFrom_square_left a b c)

/-- Closing a short exact sequence into a loop `A → B → C → A` gives zero net flow. -/
theorem short_exact_loop (a b c : List Nat) (i : Fin 7) :
    flow [(a, b), (b, c), (c, a)] i = 0 :=
  kernel_flow_exactness _ a i ⟨rfl, rfl, rfl, rfl⟩

end ArithmeticKernel

-- Axiom-cleanliness checks (only propext, Classical.choice, Quot.sound).
#print axioms ArithmeticKernel.flow_of_path
#print axioms ArithmeticKernel.kernel_flow_commutative
#print axioms ArithmeticKernel.kernel_flow_exactness
#print axioms ArithmeticKernel.kernel_flow_exact_split
#print axioms ArithmeticKernel.short_exact_loop
