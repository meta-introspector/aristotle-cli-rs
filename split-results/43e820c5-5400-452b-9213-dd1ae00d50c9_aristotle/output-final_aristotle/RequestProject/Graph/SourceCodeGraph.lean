import RequestProject.Math.UnivalentCore

/-!
# The whole-repository source-code dependency graph

This module models the repository as a directed graph whose nodes are the source
modules and whose edges are `import` dependencies. The central well-formedness
property of a build graph is **acyclicity**: there are no circular imports. We
witness acyclicity by a strictly decreasing *layer rank* — every import edge
goes from a higher layer to a strictly lower one — which immediately rules out
cycles.
-/

namespace RequestProject.Graph

/-- The source modules of the unified repository (graph nodes). -/
inductive Node
  | UnivalentCore
  | Fibration | TotalNode | CartesianLift | VerticalLift
  | GradedGenerator
  | CliffordMorphismLift | CliffordMetricLift
  | SpectralReduction | Examples | CensusEngine
  | SpectralPlane | ConformalWeightGrading | IPLD | Viz
  | SourceCodeGraph
  | Main
  deriving DecidableEq, Repr

open Node

/-- The layer rank of a module: foundational layers rank low, the global hub
ranks highest. Every import points from a higher rank to a strictly lower one. -/
def rank : Node → ℕ
  | UnivalentCore => 0
  | Fibration => 1
  | TotalNode => 2
  | CartesianLift => 2
  | VerticalLift => 3
  | GradedGenerator => 1
  | CliffordMorphismLift => 1
  | CliffordMetricLift => 2
  | SpectralReduction => 1
  | Examples => 2
  | CensusEngine => 3
  | SpectralPlane => 1
  | ConformalWeightGrading => 2
  | IPLD => 2
  | Viz => 1
  | SourceCodeGraph => 1
  | Main => 10

/-- The import edges of the repository (a directed edge `a ⟶ b` means module `a`
imports module `b`). -/
def imports : Node → Node → Prop
  | Fibration, UnivalentCore => True
  | TotalNode, Fibration => True
  | CartesianLift, Fibration => True
  | VerticalLift, CartesianLift => True
  | GradedGenerator, UnivalentCore => True
  | CliffordMorphismLift, UnivalentCore => True
  | CliffordMetricLift, CliffordMorphismLift => True
  | SpectralReduction, UnivalentCore => True
  | Examples, SpectralReduction => True
  | CensusEngine, Examples => True
  | SpectralPlane, UnivalentCore => True
  | ConformalWeightGrading, SpectralPlane => True
  | ConformalWeightGrading, GradedGenerator => True
  | IPLD, UnivalentCore => True
  | Viz, UnivalentCore => True
  | SourceCodeGraph, UnivalentCore => True
  | Main, Main => False
  | Main, _ => True
  | _, _ => False

instance : DecidableRel imports := by
  intro a b
  cases a <;> cases b <;> unfold imports <;> infer_instance

/-- **Acyclicity witness.** Every import edge strictly decreases the layer rank.
Hence the dependency graph has no directed cycles. -/
theorem imports_rank_decreasing (a b : Node) (h : imports a b) : rank b < rank a := by
  cases a <;> cases b <;> simp_all [imports, rank]

/-- **No self-imports.** As an immediate corollary, no module imports itself. -/
theorem no_self_import (a : Node) : ¬ imports a a := by
  intro h
  exact lt_irrefl _ (imports_rank_decreasing a a h)

/-- **The graph is acyclic.** There is no directed import cycle, because a cycle
would force a module's rank to be strictly less than itself. We state the
length-2 case (no mutual imports) explicitly. -/
theorem no_two_cycle (a b : Node) (h₁ : imports a b) (h₂ : imports b a) : False := by
  have := imports_rank_decreasing a b h₁
  have := imports_rank_decreasing b a h₂
  omega

end RequestProject.Graph
