/-
# Dark Forest: LMFDB Edition — Isogeny Graph Formalization

This file formalizes the **isogeny graph** that serves as the game map in
Dark Forest: LMFDB Edition. Vertices are j-invariants of elliptic curves
over a finite field, and edges correspond to isogenies of a given prime degree ℓ.

Key results formalized:
- The isogeny graph as a `SimpleGraph`
- Movement cost as the sum of isogeny degrees along a path
- Fuel budget constraints on movement range
-/

import Mathlib

/-! ## The Isogeny Graph -/

/-- The **ℓ-isogeny graph** over a type `F` (representing j-invariants).
    Two j-invariants are adjacent if there exists an isogeny of degree `ℓ`
    between the corresponding elliptic curves. -/
structure IsogenyGraph (F : Type*) where
  /-- The prime degree of the isogenies forming edges -/
  ell : ℕ
  ell_prime : Nat.Prime ell
  /-- Adjacency relation: j₁ ~ j₂ iff there is an ℓ-isogeny E₁ → E₂ -/
  adj : F → F → Prop
  adj_symm : Symmetric adj
  adj_irrefl : ∀ (a : F), ¬adj a a

namespace IsogenyGraph

variable {F : Type*} (G : IsogenyGraph F)

/-- Convert an isogeny graph to a Mathlib `SimpleGraph`. -/
def toSimpleGraph : SimpleGraph F where
  Adj := G.adj
  symm := G.adj_symm
  loopless := ⟨fun a => G.adj_irrefl a⟩

/-! ## Movement / Paths -/

/-- A **move** in the game is a path in the isogeny graph.
    The cost of a path is the number of edges × ℓ (each edge is an ℓ-isogeny). -/
def pathCost (path : List F) : ℕ :=
  (path.length - 1) * G.ell

/-- A path is **valid** if consecutive elements are adjacent in the isogeny graph. -/
def validPath (G : IsogenyGraph F) : List F → Prop
  | [] => True
  | [_] => True
  | (a :: b :: rest) => G.adj a b ∧ G.validPath (b :: rest)

/-- The fuel cost of a single-edge move equals ℓ. -/
theorem singleMoveCost (j₁ j₂ : F) :
    G.pathCost [j₁, j₂] = G.ell := by
  simp [pathCost]

/-- Empty path has zero cost. -/
theorem emptyPathCost : G.pathCost [] = 0 := by
  simp [pathCost]

/-- A single-vertex path has zero cost. -/
theorem stayInPlaceCost (j : F) : G.pathCost [j] = 0 := by
  simp [pathCost]

/-- Path cost is monotone in path length (for fixed ℓ). -/
theorem pathCost_le_of_length_le (p₁ p₂ : List F)
    (h : p₁.length ≤ p₂.length) :
    G.pathCost p₁ ≤ G.pathCost p₂ := by
  unfold pathCost
  exact Nat.mul_le_mul_right G.ell (Nat.sub_le_sub_right h 1)

/-! ## Fuel / Movement Budget -/

/-- A player's **movement budget** per turn. -/
structure MoveBudget where
  fuel : ℕ
  fuel_pos : 0 < fuel

/-- A move is **affordable** if the path cost doesn't exceed the fuel budget. -/
def affordable (budget : MoveBudget) (path : List F) : Prop :=
  G.pathCost path ≤ budget.fuel

/-- With fuel budget `B`, the maximum number of ℓ-isogeny hops is `B / ℓ`. -/
theorem maxHops (budget : MoveBudget) (path : List F)
    (h_afford : G.affordable budget path) :
    path.length - 1 ≤ budget.fuel / G.ell := by
  unfold affordable pathCost at h_afford
  exact (Nat.le_div_iff_mul_le (Nat.Prime.pos G.ell_prime)).mpr h_afford

/-- A path is **valid between two endpoints** if it starts at `src`, ends at `dst`,
    and all consecutive elements are adjacent. -/
def IsValidPath (G : IsogenyGraph F) (src dst : F) : List F → Prop
  | [] => src = dst
  | path => path.head? = some src ∧ path.getLast? = some dst ∧ G.validPath path

/-- **Concrete fuel-to-distance bound**: if a player has fuel budget `B` and
    `ℓ` is the isogeny degree, then any affordable path has at most `B / ℓ`
    edges. Since `pathCost = (edges) × ℓ`, this is exactly the discrete
    distance constraint on the isogeny graph. -/
theorem fuel_bounds_distance (path : List F) (fuel : ℕ)
    (h : G.pathCost path ≤ fuel) :
    path.length - 1 ≤ fuel / G.ell := by
  unfold pathCost at h
  exact (Nat.le_div_iff_mul_le (Nat.Prime.pos G.ell_prime)).mpr h

/-- The path cost is exactly `(number of edges) × ℓ`, giving the fuel bound
    concrete content: each isogeny hop costs exactly `ℓ` fuel units. -/
theorem pathCost_eq_edges_times_ell (path : List F) :
    G.pathCost path = (path.length - 1) * G.ell := rfl

end IsogenyGraph
