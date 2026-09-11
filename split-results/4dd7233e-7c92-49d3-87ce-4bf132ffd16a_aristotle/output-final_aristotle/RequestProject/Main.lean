/-
# Number Theory in Quantum Physics + Monstrous Moonshine / Borcherds

This project collects the machine-verified core of two related developments:

1. The Prouhet–Tarry–Escott / minicharged-particle correspondence
   (`RequestProject.PTE`) and the supersingular-prime "Oggorial" /
   Cl(15) blade-hypercube skeleton (`RequestProject.Moonshine`).

2. The Monstrous Moonshine and Borcherds layer (the "Borcherds archive"):
   foundational constants, supersingular primes, modular forms, the
   j-function / McKay–Thompson data, the Griess algebra, the Leech lattice,
   vertex operator algebras, the Monster Lie algebra, Borcherds products
   (the denominator formula data), the Moonshine theorem statement, and an
   ontological/semantic layer.

## References
- Conway–Norton, "Monstrous Moonshine" (1979)
- Frenkel–Lepowsky–Meurman, "Vertex Operator Algebras and the Monster" (1988)
- Borcherds, "Monstrous moonshine and monstrous Lie superalgebras" (1992)
- Borcherds, "Automorphic forms on O_{s+2,2}(ℝ) and infinite products" (1995)
- Gannon, "Monstrous Moonshine: the first twenty-five years" (2004)
- Lee–Takahashi–Tsai, "Number Theory in Quantum Physics: Minicharged
  Particles and the Prouhet–Tarry–Escott Problem"
-/

-- Number-theory / quantum-physics core
import RequestProject.PTE
import RequestProject.Moonshine
import RequestProject.UmbralMoonshine

-- Moonshine / Borcherds foundation
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.SupersingularPrimes
import RequestProject.Math.Monster.ModularFormCore

-- Moonshine data layer
import RequestProject.Math.Monster.MoonshineCore
import RequestProject.Math.Monster.McKayThompsonAtlas
import RequestProject.Math.Monster.GriessAlgebra
import RequestProject.Math.Monster.LeechLattice
import RequestProject.Math.Monster.BorcherdsProducts

-- Borcherds' proof layer
import RequestProject.Math.Monster.VertexAlgebra
import RequestProject.Math.Monster.MonsterLieAlgebra
import RequestProject.Math.Monster.MoonshineTheorem

-- Ontological layer
import RequestProject.Math.Monster.MoonshineOntology

-- Sheaf-section glue: 4d minicharged sector over the moonshine base
import RequestProject.Physics.MinichargedGlue

-- 26d bosonic string and the dimensional descent 26 → 4
import RequestProject.Physics.BosonicStringDescent

-- 10d superstring and the dimensional descent 10 → 4
import RequestProject.Physics.SuperstringDescent

-- Synthesis: cross-module bridges tying every strand together
import RequestProject.Synthesis

-- The moonshine → PTE descent walk and its projections / views
import RequestProject.MoonshineWalk

-- The iongraph hierarchical layout algorithm, lifted into Lean (replaces Graphviz)
import RequestProject.IonGraph

-- The branching descent (confluence diamond) and the animated SVG "movie"
import RequestProject.MoonshineBranch

-- The unified source-code dependency graph (category-theoretic global graph)
import RequestProject.Graph.SourceCodeGraph
