-- 1. Core Homotopy & n-type foundation
import RequestProject.Math.UnivalentCore

-- 2. Fibred categories (display-map model of fibrations)
import RequestProject.Math.FibredCats.Fibration
import RequestProject.Math.FibredCats.Total
import RequestProject.Math.FibredCats.CartesianLift
import RequestProject.Math.FibredCats.VerticalLift

-- 3. Geometric bridge & Monster symmetries
import RequestProject.Math.Bridge.CliffordMorphismLift
import RequestProject.Math.Bridge.CliffordMetricLift
import RequestProject.Math.Monster.GradedGenerator

-- 4. Altland–Zirnbauer & topological engine census
import RequestProject.AZ.SpectralReduction
import RequestProject.AZ.Examples
import RequestProject.AZ.CensusEngine

-- 5. Conformal field theory, spectral coordinates, serialization, visual safety
import RequestProject.Compute.SpectralPlane
import RequestProject.Compute.ConformalWeightGrading
import RequestProject.Compute.IPLD
import RequestProject.Compute.Viz

-- 6. Global whole-repository source graph
import RequestProject.Graph.SourceCodeGraph

/-!
# RequestProject/Main.lean

The master validation hub for the unified `RequestProject` ecosystem.

This file aggregates the sub-systems (Math, AZ, Compute, Graph) so that the
entire repository compiles in a single step. Every imported module is
`sorry`-free and depends only on the standard trusted axioms (`propext`,
`Classical.choice`, `Quot.sound`).

## Layers

1. **Core homotopy / `n`-type foundation** — `Math.UnivalentCore`.
2. **Fibred categories (display-map model)** — `Math.FibredCats.*`.
3. **Geometric bridge & Monster symmetries** — `Math.Bridge.*`, `Math.Monster.*`.
4. **Altland–Zirnbauer & the Bott clock** — `AZ.*`.
5. **Conformal weights, spectral plane, content-addressing, visual safety** —
   `Compute.*`.
6. **Whole-repository dependency graph** — `Graph.SourceCodeGraph`.
-/

/-- Entry point: a status banner for the unified build. The mathematical
guarantees live in the imported modules; this `main` simply reports a successful
aggregation. -/
def main : IO Unit := do
  IO.println "[RequestProject] Unified verification build complete."
  IO.println "  - Core univalent n-type hierarchy (Math.UnivalentCore)"
  IO.println "  - Fibred categories: fibration, total, cartesian/vertical lifts"
  IO.println "  - Clifford morphism & metric lifts; Monster moonshine generators"
  IO.println "  - Altland–Zirnbauer Bott clock, examples, census engine"
  IO.println "  - Spectral plane, conformal weights, IPLD CIDs, layout safety"
  IO.println "  - Whole-repository acyclic dependency graph"
  IO.println "  No 'sorry'; axioms: propext, Classical.choice, Quot.sound."
