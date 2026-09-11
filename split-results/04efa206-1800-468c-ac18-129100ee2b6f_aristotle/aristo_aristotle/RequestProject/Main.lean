import RequestProject.AVFT
import RequestProject.AVFTExtended
import RequestProject.Atlas.CharacterTable
import RequestProject.Atlas.ClassFunction
import RequestProject.Atlas.Classification
import RequestProject.Atlas.ConstructedGroups
import RequestProject.Atlas.GroupExtensions
import RequestProject.Atlas.GroupOrders
import RequestProject.Atlas.MaximalSubgroups
import RequestProject.Atlas.ProvedFacts
import RequestProject.Basic
import RequestProject.BasicTypes
import RequestProject.Diagonalization
import RequestProject.FuzzWitness
import RequestProject.HerosJourney
import RequestProject.Introspector
import RequestProject.IrrepMask
import RequestProject.KrohnRhodes
import RequestProject.M24Closure
import RequestProject.McKayThompson
import RequestProject.MockThetaFunctions
import RequestProject.Monster
import RequestProject.MonsterArithmetic
import RequestProject.MonsterIrrepFactors
import RequestProject.MonsterIrreps
import RequestProject.MonsterQuasiSymmetry
import RequestProject.MonsterTower
import RequestProject.MonstrousMoonshine
import RequestProject.Mythos
import RequestProject.Network
import RequestProject.NiemeierRootSystem
import RequestProject.Protocols
import RequestProject.QExpansion
import RequestProject.QPochhammer
import RequestProject.SSP
import RequestProject.ShadowDetection
import RequestProject.ShapeBase
import RequestProject.ShapeSheaf
import RequestProject.SieveCore
import RequestProject.SieveQuadrant
import RequestProject.SieveTower
import RequestProject.SubgroupLattice
import RequestProject.SupersingularPrimes
import RequestProject.Symmetry
import RequestProject.UmbralMoonshine

/-!
# Monster Group Architecture — Consolidated Main Module

This module re-exports all components of the Monster group formalization project,
consolidating work from multiple sessions into a single unified project.

## Modules

### Core Monster Group
- `SupersingularPrimes` — the 15 supersingular primes and their properties
- `IrrepMask` — SSP support vectors and Hamming distance
- `Monster` — axiomatic interface for the Monster group via type class
- `ShadowDetection` — CFSG-based shadow detection
- `FuzzWitness` — reproducibility records

### Representation Theory
- `MonsterIrreps` — Monster irreducible representations
- `MonsterIrrepFactors` — factorization of irrep dimensions
- `MonsterArithmetic` — arithmetic properties of Monster invariants
- `MonsterTower` — tower constructions
- `MonsterQuasiSymmetry` — quasi-symmetry properties

### Moonshine
- `MonstrousMoonshine` — monstrous moonshine connections
- `McKayThompson` — McKay-Thompson series
- `UmbralMoonshine` — umbral moonshine
- `NiemeierRootSystem` — Niemeier root systems
- `MockThetaFunctions` — mock theta functions
- `QExpansion` — q-expansions
- `QPochhammer` — q-Pochhammer symbol

### ATLAS
- `Atlas.CharacterTable` — character tables
- `Atlas.ClassFunction` — class functions
- `Atlas.Classification` — classification results
- `Atlas.ConstructedGroups` — constructed groups
- `Atlas.GroupExtensions` — group extensions
- `Atlas.GroupOrders` — group orders
- `Atlas.MaximalSubgroups` — maximal subgroups
- `Atlas.ProvedFacts` — proved facts

### Computational / Sieve
- `SSP` — SSP computations
- `SieveCore` — sieve core
- `SieveQuadrant` — sieve quadrant
- `SieveTower` — sieve tower
- `SubgroupLattice` — subgroup lattice
- `M24Closure` — M24 closure computations

### Infrastructure
- `Basic` — basic definitions
- `BasicTypes` — basic types
- `AVFT` — AVFT constructions
- `AVFTExtended` — extended AVFT
- `Diagonalization` — diagonalization
- `Introspector` — introspection tools
- `KrohnRhodes` — Krohn-Rhodes decomposition
- `ShapeBase` — shape base types
- `ShapeSheaf` — shape sheaf constructions
- `Symmetry` — symmetry utilities
- `Network` — network definitions
- `Protocols` — protocol definitions
- `HerosJourney` — narrative structure
- `Mythos` — mythological framework
-/
