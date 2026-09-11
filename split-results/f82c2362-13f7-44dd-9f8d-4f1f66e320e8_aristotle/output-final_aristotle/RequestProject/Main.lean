/-
# Monstrous Moonshine and Borcherds — Lean 4 Formalization

A formalization of the mathematical structures underlying the
Monstrous Moonshine conjecture and Borcherds' proof (Fields Medal 1998).

## Architecture

### Foundation Layer
- `MonsterConstants` — Canonical numerical constants (group orders, dimensions)
- `SupersingularPrimes` — The 15 supersingular primes and Ogg's observation
- `ModularFormCore` — q-expansions, Eisenstein series, Hecke operators

### Moonshine Data Layer
- `MoonshineCore` — j-coefficients, McKay decompositions, FLM construction
- `McKayThompsonAtlas` — Thompson series data for all key conjugacy classes
- `GriessAlgebra` — The 196884-dim commutative nonassociative algebra
- `LeechLattice` — The 24-dim even unimodular lattice and Conway groups

### Borcherds' Proof Layer
- `VertexAlgebra` — Vertex operator algebra axioms and V♮
- `MonsterLieAlgebra` — Generalized Kac-Moody (Borcherds) algebras
- `BorcherdsProducts` — Denominator formula and product identities
- `MoonshineTheorem` — The Moonshine conjecture and proof structure

## References
- Conway–Norton, "Monstrous Moonshine" (1979)
- Frenkel–Lepowsky–Meurman, "Vertex Operator Algebras and the Monster" (1988)
- Borcherds, "Monstrous moonshine and monstrous Lie superalgebras" (1992)
- Borcherds, "Automorphic forms on O_{s+2,2}(ℝ) and infinite products" (1995)
- Gannon, "Monstrous Moonshine: the first twenty-five years" (2004)
-/

-- Foundation
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.SupersingularPrimes
import RequestProject.Math.Monster.ModularFormCore

-- Data
import RequestProject.Math.Monster.MoonshineCore
import RequestProject.Math.Monster.McKayThompsonAtlas
import RequestProject.Math.Monster.GriessAlgebra
import RequestProject.Math.Monster.LeechLattice
import RequestProject.Math.Monster.BorcherdsProducts

-- Borcherds' Proof
import RequestProject.Math.Monster.VertexAlgebra
import RequestProject.Math.Monster.MonsterLieAlgebra
import RequestProject.Math.Monster.MoonshineTheorem

-- Ontological Layer
import RequestProject.Math.Monster.MoonshineOntology
