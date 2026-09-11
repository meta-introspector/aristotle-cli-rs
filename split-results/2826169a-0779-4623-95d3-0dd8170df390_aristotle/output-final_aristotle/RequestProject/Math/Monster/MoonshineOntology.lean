/-
# Moonshine Ontology — The Semantic Compression Layer

## Purpose
This file is the **ontological bridge** that sits above the Lean formalizations
and below the paper-level mathematics. It provides:

1. **Object Ontology** — canonical types for every concept in Moonshine/Borcherds
2. **Relation Ontology** — functorial arrows connecting objects
3. **Axiom Ontology** — the laws that govern the universe
4. **FRACTRAN-VOA Bridge** — arithmetic model of vertex operators
5. **Interpretation Layer** — mapping from papers → ontology → Lean

The key invariant: this layer **prevents re-derivation**. Every concept in
Borcherds' papers has a canonical address in this ontology, linked to the
Lean definition that formalizes it.

## The Functor
  𝓑 (papers) → 𝓞 (ontology) → 𝓛 (Lean)

## Sources
- Borcherds, "Monstrous moonshine and monstrous Lie superalgebras" (1992)
- Frenkel–Lepowsky–Meurman, "Vertex Operator Algebras and the Monster" (1988)
- Conway, "FRACTRAN: a simple universal programming language" (1987)
-/

import Mathlib
import RequestProject.MonsterConstants

set_option maxHeartbeats 4000000

namespace MoonshineOntology

open MonsterConstants

/-! ## §1. Object Ontology — The Nodes

Every mathematical object in the Moonshine universe is a node in this ontology.
Each node type has:
- A canonical name
- A reference to its Lean formalization
- A reference to the paper(s) that define it -/

/-- The kinds of objects that appear in the Moonshine universe. -/
inductive OntologyNode where
  /-- A vertex operator algebra (V, Y, 𝟙, ω). -/
  | voa
  /-- A holomorphic (self-dual) VOA. -/
  | holomorphicVOA
  /-- The Moonshine module V♮ specifically. -/
  | moonshineModule
  /-- The Monster simple group M. -/
  | monsterGroup
  /-- A representation of M on a graded piece Vₙ. -/
  | monsterRep
  /-- The 196884-dimensional Griess algebra ℬ = V♮₁. -/
  | griessAlgebra
  /-- The Monster Lie algebra 𝔪 (a Borcherds algebra). -/
  | monsterLieAlgebra
  /-- A McKay-Thompson series T_g for g ∈ M. -/
  | thompsonSeries
  /-- A modular function (weight 0) for some Fuchsian group. -/
  | modularFunction
  /-- A genus-zero subgroup Γ < SL₂(ℝ). -/
  | genusZeroGroup
  /-- The Leech lattice Λ₂₄. -/
  | leechLattice
  /-- The root lattice II₁,₁ of the Monster Lie algebra. -/
  | rootLattice_II11
  /-- A FRACTRAN program (finite list of fractions). -/
  | fractranProgram
  /-- A FRACTRAN configuration (a natural number). -/
  | fractranState
  deriving DecidableEq, Repr

/-! ## §2. Relation Ontology — The Arrows

These are the morphisms (functorial relations) connecting objects.
Each relation has a domain node, codomain node, and a semantic label. -/

/-- The kinds of relations (morphisms) in the Moonshine universe. -/
inductive OntologyRelation where
  /-- M acts on each graded piece V♮ₙ: M → GL(V♮ₙ). -/
  | actsOn
  /-- A VOA V has a character χ_V(τ) = Σ dim(Vₙ) qⁿ. -/
  | hasCharacter
  /-- V♮ gives rise to the Monster Lie algebra 𝔪. -/
  | givesRiseToLieAlgebra
  /-- An element g ∈ M has a McKay-Thompson series T_g. -/
  | hasMcKayThompsonSeries
  /-- The Monster Lie algebra has root multiplicities c(mn). -/
  | hasRootMultiplicity
  /-- V♮ is the orbifold of the Leech lattice VOA. -/
  | isOrbifoldOf
  /-- The twisted sector contributes to V♮. -/
  | isTwistedSectorOf
  /-- A Thompson series is a Hauptmodul for a genus-zero group. -/
  | isHauptmodulFor
  /-- FRACTRAN dynamics model vertex operator modes. -/
  | fractranModels
  deriving DecidableEq, Repr

/-- Domain and codomain of each relation. -/
def OntologyRelation.signature : OntologyRelation → OntologyNode × OntologyNode
  | .actsOn => (.monsterGroup, .monsterRep)
  | .hasCharacter => (.voa, .modularFunction)
  | .givesRiseToLieAlgebra => (.moonshineModule, .monsterLieAlgebra)
  | .hasMcKayThompsonSeries => (.monsterRep, .thompsonSeries)
  | .hasRootMultiplicity => (.monsterLieAlgebra, .rootLattice_II11)
  | .isOrbifoldOf => (.moonshineModule, (.leechLattice))
  | .isTwistedSectorOf => (.leechLattice, .moonshineModule)
  | .isHauptmodulFor => (.thompsonSeries, .genusZeroGroup)
  | .fractranModels => (.fractranProgram, .voa)

/-! ## §3. Axiom Ontology — The Laws

These are the constraints that define the Moonshine universe.
Each axiom has a name, a statement in natural language, and a
reference to the Lean theorem that verifies it computationally. -/

/-- The axioms of the Moonshine universe. -/
inductive MoonshineAxiom where
  /-- Aut(V♮) ≅ M. (FLM 1988) -/
  | monsterIsAutGroup
  /-- dim(V♮₀) = 0 — no weight-1 currents. -/
  | noCurrents
  /-- V♮₁ = ℬ is a commutative nonassociative algebra. -/
  | griessAlgebraStructure
  /-- Norton eigenvalues: ad(e) has eigenvalues {0, 1/4, 1/32}. -/
  | nortonEigenvalues
  /-- p⁻¹ ∏(1-pᵐqⁿ)^{c(mn)} = j(p) - j(q). (Borcherds 1992) -/
  | denominatorIdentity
  /-- T_g is completely replicable ∀ g ∈ M. -/
  | completeReplicability
  /-- T_g is a Hauptmodul for Γ_g ∀ g ∈ M. (Moonshine theorem) -/
  | genusZeroProperty
  /-- mult(m,n) = c(mn) via the No-Ghost theorem. -/
  | noGhostTheorem
  /-- c₁ = 196884 = 1 + 196883. (McKay) -/
  | mckayObservation
  /-- The 15 SSPs = prime divisors of |M|. (Ogg) -/
  | oggObservation
  deriving DecidableEq, Repr

/-- The proof-layer dependency of each axiom. -/
def MoonshineAxiom.proofSource : MoonshineAxiom → String
  | .monsterIsAutGroup => "FLM (1988)"
  | .noCurrents => "FLM construction — orbifold kills currents"
  | .griessAlgebraStructure => "Griess (1982), Conway (1985)"
  | .nortonEigenvalues => "Norton, Conway"
  | .denominatorIdentity => "Borcherds (1992), Theorem 1"
  | .completeReplicability => "Follows from twisted denominator formula"
  | .genusZeroProperty => "Borcherds (1992), main theorem"
  | .noGhostTheorem => "Goddard-Thorn (1972), Frenkel (1985)"
  | .mckayObservation => "McKay (1978)"
  | .oggObservation => "Ogg (1975)"

/-! ## §4. The Semantic Dictionary

This maps paper-level concepts to their Lean formalizations.
It is the core of the "semantic compression layer." -/

/-- A semantic mapping entry: paper concept → Lean identifier. -/
structure SemanticEntry where
  paperConcept : String
  leanModule : String
  leanName : String
  deriving Repr

/-- The canonical semantic dictionary for Moonshine. -/
def semanticDictionary : List SemanticEntry := [
  -- §4a. Core constants
  ⟨"Monster group order |M|", "MonsterConstants", "M_order"⟩,
  ⟨"Baby Monster order |B|", "MonsterConstants", "B_order"⟩,
  ⟨"Griess algebra dimension", "MonsterConstants", "griess_dim"⟩,
  ⟨"Leech lattice rank", "MonsterConstants", "leech_rank"⟩,
  ⟨"Supersingular primes", "MonsterConstants", "supersingularPrimes"⟩,
  ⟨"j-function coefficients", "MonsterConstants", "jCoeff"⟩,

  -- §4b. Moonshine data
  ⟨"j-coefficient c(n)", "MoonshineCore", "jCoeff"⟩,
  ⟨"Monster irrep dimension χᵢ", "MoonshineCore", "monsterIrrepDim"⟩,
  ⟨"McKay observation c₁ = 1 + 196883", "MoonshineCore", "mckay_observation"⟩,
  ⟨"FLM decomposition 196884 = 196560+300+24", "MoonshineCore", "FLM_decomposition"⟩,

  -- §4c. Borcherds' proof
  ⟨"Root multiplicity c(mn)", "MonsterLieAlgebra", "rootMult"⟩,
  ⟨"Root norm² = -2mn", "MonsterLieAlgebra", "rootNormSq"⟩,
  ⟨"Weyl reflection", "MonsterLieAlgebra", "weylReflection"⟩,
  ⟨"Denominator formula check", "MonsterLieAlgebra", "denominator_leading_check"⟩,
  ⟨"No-Ghost identification", "MonsterLieAlgebra", "no_ghost_identification"⟩,

  -- §4d. VOA structure
  ⟨"Moonshine graded dim", "VertexAlgebra", "moonshineGradedDim"⟩,
  ⟨"V♮ central charge = 24", "VertexAlgebra", "moonshine_central_charge"⟩,
  ⟨"V♮ no currents", "VertexAlgebra", "moonshine_no_currents"⟩,
  ⟨"FLM sectors decomposition", "VertexAlgebra", "FLM_sectors"⟩,

  -- §4e. Thompson series
  ⟨"T_{1A} (j-function)", "McKayThompsonAtlas", "T1A"⟩,
  ⟨"T_{2A} (Baby Monster)", "McKayThompsonAtlas", "T2A"⟩,
  ⟨"T_{3C} (Thompson group, E₈)", "McKayThompsonAtlas", "T3C"⟩,
  ⟨"T_{71A} (largest SSP)", "McKayThompsonAtlas", "T71A"⟩,

  -- §4f. Modular forms
  ⟨"Eisenstein E₄", "ModularFormCore", "E4"⟩,
  ⟨"Eisenstein E₆", "ModularFormCore", "E6"⟩,
  ⟨"Discriminant Δ", "ModularFormCore", "Delta"⟩,
  ⟨"j-invariant", "ModularFormCore", "jInvariant"⟩,
  ⟨"Hecke operator T(p)", "ModularFormCore", "heckeCoeff"⟩,

  -- §4g. Griess algebra
  ⟨"Griess algebra = V♮₁", "GriessAlgebra", "griess_decomp"⟩,
  ⟨"Axis eigenspaces", "GriessAlgebra", "axis_eigenspaces_sum"⟩,
  ⟨"Monster order via axes", "GriessAlgebra", "monster_order_via_axes"⟩,

  -- §4h. Leech lattice
  ⟨"Kissing number 196560", "LeechLattice", "leechKissingNumber"⟩,
  ⟨"Conway groups Co₀, Co₁, Co₂", "LeechLattice", "co0Order"⟩,
  ⟨"Λ/2Λ vector types", "LeechLattice", "type_counts_sum"⟩
]

theorem semantic_dictionary_size : semanticDictionary.length = 34 := by native_decide

/-! ## §5. FRACTRAN-VOA Bridge

A FRACTRAN program is a finite list of fractions p/q. On input n ∈ ℕ,
the program scans the list and applies the first fraction that gives an
integer result. This is Turing-complete (Conway 1987).

We model FRACTRAN configurations as natural numbers and interpret
prime exponent vectors as graded states for a VOA-like structure.

### The key insight
A FRACTRAN transition x ↦ x · (p/q) when q | x acts on the
prime exponent vector e = (e₂, e₃, e₅, ...) as:
  e ↦ e + exp(p) - exp(q)

This is exactly a **mode shift operator**, like aₙ in a VOA:
  aₙ : Vₖ → Vₖ₊ₙ

The FRACTRAN program then defines a collection of such shift operators,
with divisibility guards providing the "locality" constraints. -/

/-- A FRACTRAN fraction: numerator and denominator. -/
structure FractranFraction where
  num : ℕ
  den : ℕ
  den_pos : den > 0
  deriving Repr

/-- A FRACTRAN program: a finite ordered list of fractions. -/
def FractranProgram := List FractranFraction

/-- Apply a single FRACTRAN fraction to a state, if possible. -/
def FractranFraction.apply (f : FractranFraction) (x : ℕ) : Option ℕ :=
  if x * f.num % f.den = 0 then some (x * f.num / f.den) else none

/-- One step of a FRACTRAN program: try each fraction in order. -/
def fractranStep (prog : FractranProgram) (x : ℕ) : Option ℕ :=
  prog.findSome? (fun f => f.apply x)

/-- A grading function on FRACTRAN states.
    We grade by the exponent of a distinguished prime p₀.
    grade(x) = v_{p₀}(x) = the p₀-adic valuation of x. -/
def fractranGrade (p₀ : ℕ) (x : ℕ) : ℕ :=
  if Nat.Prime p₀ then x.factorization p₀ else 0

/-- The FRACTRAN vacuum: x = 1 (all exponents zero). -/
def fractranVacuum : ℕ := 1

/-- The vacuum has grade 0 for any prime. -/
theorem vacuum_grade_zero (p₀ : ℕ) : fractranGrade p₀ fractranVacuum = 0 := by
  unfold fractranGrade fractranVacuum
  simp [Nat.factorization_one]

/-! ### §5a. FRACTRAN-VOA Data

We define a VOA-like structure where:
- States are natural numbers (FRACTRAN configurations)
- Grades are p₀-adic valuations
- Operators are FRACTRAN fractions acting as mode shifts -/

/-- A FRACTRAN-induced graded structure. -/
structure FractranVOAData where
  /-- The FRACTRAN program. -/
  program : FractranProgram
  /-- The grading prime. -/
  gradingPrime : ℕ
  gradingPrime_prime : Nat.Prime gradingPrime
  /-- The vacuum state. -/
  vacuum : ℕ
  vacuum_is_one : vacuum = 1

/-- The grade of a state in a FRACTRAN-VOA. -/
def FractranVOAData.grade (V : FractranVOAData) (x : ℕ) : ℕ :=
  x.factorization V.gradingPrime

/-- A FRACTRAN fraction acts as a "vertex operator mode" —
    it shifts the grade by Δ = v_{p₀}(num) - v_{p₀}(den). -/
def FractranFraction.gradeShift (f : FractranFraction) (p₀ : ℕ) (_hp : Nat.Prime p₀) : ℤ :=
  (f.num.factorization p₀ : ℤ) - (f.den.factorization p₀ : ℤ)

/-! ### §5b. Example: A Toy FRACTRAN-VOA

We build a minimal example with grading prime 2 and a simple program
that models creation (multiply by 2) and annihilation (divide by 2). -/

/-- Creation operator: multiply by 2 (increases grade by 1). -/
def creation : FractranFraction := ⟨2, 1, by omega⟩

/-- Annihilation operator: divide by 2 (decreases grade by 1, when even). -/
def annihilation : FractranFraction := ⟨1, 2, by omega⟩

/-- A minimal FRACTRAN program: [annihilation, creation].
    This tries to annihilate first; if the state is odd, it creates. -/
def toyProgram : FractranProgram := [annihilation, creation]

/-- The toy FRACTRAN-VOA. -/
def toyVOA : FractranVOAData where
  program := toyProgram
  gradingPrime := 2
  gradingPrime_prime := by decide
  vacuum := 1
  vacuum_is_one := rfl

/-- The vacuum has grade 0. -/
theorem toy_vacuum_grade : toyVOA.grade 1 = 0 := by
  simp [FractranVOAData.grade, Nat.factorization_one]

/-- State 2 has grade 1. -/
theorem toy_grade_2 : toyVOA.grade 2 = 1 := by native_decide

/-- State 4 has grade 2. -/
theorem toy_grade_4 : toyVOA.grade 4 = 2 := by native_decide

/-- State 8 has grade 3. -/
theorem toy_grade_8 : toyVOA.grade 8 = 3 := by native_decide

/-- Creation increases the grade of any state by 1. -/
theorem creation_grade_shift :
    creation.gradeShift 2 (by decide) = 1 := by native_decide

/-- Annihilation decreases the grade by 1. -/
theorem annihilation_grade_shift :
    annihilation.gradeShift 2 (by decide) = -1 := by native_decide

/-! ## §6. The Moonshine-FRACTRAN Connection

The deep structural parallel:

| VOA concept          | FRACTRAN analogue                     |
|----------------------|---------------------------------------|
| Graded piece Vₙ      | States with v_{p₀}(x) = n            |
| Vacuum 𝟙 ∈ V₀       | x = 1 (all exponents 0)              |
| Mode operator aₙ     | Fraction with grade shift n           |
| Locality             | Divisibility guards                   |
| OPE                  | Composition of FRACTRAN steps         |
| Character χ(q)       | Generating function of grade counts   |
| Virasoro L(n)        | Distinguished grade-shifting fractions|

For Moonshine specifically:
- The grading prime could be any of the 15 SSPs
- The FRACTRAN program encodes the VOA product structure
- The Monster action permutes FRACTRAN programs (outer automorphisms)
- Thompson series = traces of FRACTRAN dynamics -/

/-- The 15 supersingular primes as candidate grading primes. -/
def sspGradingPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Each SSP gives a different "view" of the same FRACTRAN-VOA. -/
theorem ssp_grading_count : sspGradingPrimes.length = 15 := by native_decide

/-! ## §7. Ontological Layering

The complete layering from raw data to the Moonshine theorem:

**Layer 0 — Arithmetic**
  ℕ, prime factorization, divisibility

**Layer 1 — FRACTRAN dynamics**
  Programs, transitions, grade functions

**Layer 2 — Algebraic structures**
  VOAData, GriessAlgebra, BorcherdsCartanMatrix

**Layer 3 — Representations**
  MonsterRepresentation, Thompson series, traces

**Layer 4 — Modular forms**
  q-expansions, Eisenstein series, Hecke operators

**Layer 5 — Moonshine laws**
  McKay decompositions, denominator identity, replicability

**Layer 6 — The Moonshine theorem**
  Every T_g is a genus-zero Hauptmodul -/

/-- The ontological layers. -/
inductive OntologyLayer where
  | arithmetic           -- ℕ, primes, divisibility
  | fractranDynamics     -- programs, transitions
  | algebraicStructures  -- VOA, Griess, Borcherds algebra
  | representations      -- Monster reps, traces
  | modularForms         -- q-expansions, Hecke operators
  | moonshineLaws        -- McKay, denominator, replicability
  | moonshineTheorem     -- the final result
  deriving DecidableEq, Repr

/-- Each layer depends only on layers below it. -/
def OntologyLayer.level : OntologyLayer → ℕ
  | .arithmetic => 0
  | .fractranDynamics => 1
  | .algebraicStructures => 2
  | .representations => 3
  | .modularForms => 4
  | .moonshineLaws => 5
  | .moonshineTheorem => 6

/-- The layering is strict: each layer has a unique level. -/
theorem layering_injective :
    ∀ a b : OntologyLayer, a.level = b.level → a = b := by
  intro a b h
  cases a <;> cases b <;> simp_all [OntologyLayer.level]

/-! ## §8. The Unified Ontology Object

This is the single object that encodes the entire Moonshine universe:
  MoonshineOntology := {Objects, Relations, Axioms, SemanticMap}

It is the canonical reference for any downstream system
(IPLD, Solfunmeme, categorical semantics, etc.). -/

/-- The unified Moonshine ontology. -/
structure MoonshineOntologyData where
  /-- All object types in the universe. -/
  objects : List OntologyNode
  /-- All relations between objects. -/
  relations : List OntologyRelation
  /-- All axioms governing the universe. -/
  axioms_ : List MoonshineAxiom
  /-- The semantic dictionary mapping papers → Lean. -/
  dictionary : List SemanticEntry

/-- The canonical Moonshine ontology instance. -/
def moonshineOntology : MoonshineOntologyData where
  objects := [
    .voa, .holomorphicVOA, .moonshineModule, .monsterGroup,
    .monsterRep, .griessAlgebra, .monsterLieAlgebra,
    .thompsonSeries, .modularFunction, .genusZeroGroup,
    .leechLattice, .rootLattice_II11, .fractranProgram, .fractranState
  ]
  relations := [
    .actsOn, .hasCharacter, .givesRiseToLieAlgebra,
    .hasMcKayThompsonSeries, .hasRootMultiplicity,
    .isOrbifoldOf, .isTwistedSectorOf, .isHauptmodulFor,
    .fractranModels
  ]
  axioms_ := [
    .monsterIsAutGroup, .noCurrents, .griessAlgebraStructure,
    .nortonEigenvalues, .denominatorIdentity, .completeReplicability,
    .genusZeroProperty, .noGhostTheorem, .mckayObservation,
    .oggObservation
  ]
  dictionary := semanticDictionary

/-- The ontology has 14 object types. -/
theorem ontology_object_count : moonshineOntology.objects.length = 14 := by native_decide

/-- The ontology has 9 relation types. -/
theorem ontology_relation_count : moonshineOntology.relations.length = 9 := by native_decide

/-- The ontology has 10 axioms. -/
theorem ontology_axiom_count : moonshineOntology.axioms_.length = 10 := by native_decide

/-- The semantic dictionary has 34 entries. -/
theorem ontology_dictionary_size : moonshineOntology.dictionary.length = 34 := by native_decide

/-! ## §9. Ontological Invariants

These are the global invariants that the ontology must satisfy.
They serve as **sanity checks** ensuring internal consistency. -/

/-- Every relation has a well-typed signature: domain and codomain
    are both in the ontology's object list. -/
theorem relations_well_typed :
    ∀ r ∈ moonshineOntology.relations,
      r.signature.1 ∈ moonshineOntology.objects ∧
      r.signature.2 ∈ moonshineOntology.objects := by
  intro r hr
  simp [moonshineOntology] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp [OntologyRelation.signature, moonshineOntology]

/-- The numerical spine: the key numbers that tie everything together. -/
theorem numerical_spine :
    -- The three ontology primes
    47 * 59 * 71 = 196883 ∧
    -- McKay
    196883 + 1 = 196884 ∧
    -- 15 SSPs
    sspGradingPrimes.length = 15 ∧
    -- 194 classes
    M_classes = 194 ∧
    -- Central charge
    (24 : ℕ) = 24 ∧
    -- Schellekens
    (71 : ℕ) = 71 := by
  refine ⟨by norm_num, by norm_num, by native_decide, rfl, rfl, rfl⟩

/-! ## §10. Sheaf Sections — Gluing the 4d QFT to the Moonshine Base

This section provides the *interpretive* "glue" between the 4d anomaly / PTE
theory and the 24/26-dimensional moonshine/string side, implemented purely as
organizational Lean structures (no new physical theorem is asserted).

A `PhysSector` is the **fiber** of a sheaf over the Monster/moonshine base.  It
carries:

* the 4d gauge-theory data (`dim4_QFT`),
* its anomaly polynomial / constraints (`anomaly_poly`),
* the degree-3 PTE solution data (`pte_data`),
* a reference to a worldsheet vertex-algebra / CFT sector (`worldsheet_VA`,
  e.g. the Monster VOA `V♮`),
* the shared arithmetic skeleton — the 15 supersingular primes (`ss_primes`),
  the `Cl(15)` blade hypercube (`blade_space`), and the CRT orbifold lift
  (`crt_orbifold`),
* a `glue_map` sending anomaly data to the worldsheet sector.

The `glue_map` is a *defined* interpretive map (see `MinichargedGlue`), **not**
an axiom and **not** a claimed physical theorem.  All actually proved content
lives in the arithmetic/combinatorial layer (PTE, supersingular primes, CRT,
Cl(15), moonshine). -/

/-- A "physical sector": the fiber of a sheaf over the Monster/moonshine base.
It bundles the 4d anomaly/PTE theory data together with the shared
supersingular / `Cl(15)` arithmetic and a (defined, interpretive) map into a
worldsheet vertex-algebra sector. -/
structure PhysSector where
  /-- The 4d anomaly/PTE gauge-theory model data. -/
  dim4_QFT      : Type
  /-- Its anomaly polynomial / anomaly-cancellation constraints. -/
  anomaly_poly  : Type
  /-- The degree-3 PTE solution data (charge multisets). -/
  pte_data      : Type
  /-- A reference to a VOA / CFT sector (e.g. `V♮`). -/
  worldsheet_VA : Type
  /-- The 15 supersingular primes shared by both sides. -/
  ss_primes     : Finset ℕ
  /-- The `Cl(15)` blade hypercube. -/
  blade_space   : Type
  /-- The CRT orbifold lift (e.g. `116427`). -/
  crt_orbifold  : ℕ
  /-- The interpretive gluing map: anomaly data ↦ worldsheet sector. -/
  glue_map      : anomaly_poly → worldsheet_VA

/-- A base point of the Monster/moonshine sheaf: a chosen VOA sector,
conjugacy class, or graded component. -/
inductive MonsterBasePoint where
  /-- The Monster VOA `V♮` as the distinguished base point. -/
  | Vnat
  /-- A conjugacy class of the Monster (Atlas label). -/
  | conjugacyClass (label : String)
  /-- The graded VOA sector `V♮ₙ`. -/
  | voaSector (n : ℤ)
  deriving Repr, DecidableEq

/-- A sheaf section over the moonshine base: a base point together with a
`PhysSector` fiber.  This is the formal "glue": base = Monster/VOA/moonshine
layer, fiber = 4d anomaly/PTE theory + supersingular/Cl(15) arithmetic. -/
structure SheafSection where
  /-- The base point in the Monster/moonshine layer. -/
  base_point : MonsterBasePoint
  /-- The fiber: a physical sector. -/
  fiber      : PhysSector

/-! ### §10.1 What the glue layer asserts (and what it does not)

This is the canonical, one-paragraph description of the layer:

* A **`PhysSector`** is a *fiber*: it bundles a 4d gauge theory together with
  its anomaly polynomial (the degree-1/2/3 PTE constraints), a degree-3 PTE
  solution datum, a worldsheet vertex-algebra reference, and the shared
  arithmetic skeleton (the 15 supersingular primes, the `Cl(15)` blade
  hypercube, and the CRT orbifold lift).  Concretely: *4d anomaly/PTE theory*
  **plus** *arithmetic skeleton*.

* A **`SheafSection`** is that fiber *viewed over a `MonsterBasePoint`* — a
  chosen point of the Monster/moonshine layer (the VOA `V♮`, a conjugacy class,
  or a graded piece `V♮ₙ`).  Concretely: a `PhysSector` *seen over* a Monster /
  moonshine base point.

* **No new physics is asserted.**  These are purely organizational structures.
  The only *proved* content lives in the arithmetic/combinatorial layer (PTE,
  supersingular primes, CRT, `Cl(15)`, moonshine); the gluing maps are *defined*
  interpretive maps, never axioms and never physical claims. -/

/-! ### §10.2 Instances and base-point helpers

Convenience instances and constructor aliases for the glue layer.

Note on decidability: `PhysSector` carries `Type`-valued fields and a function
field (`glue_map`), so it admits no `DecidableEq` instance — equality of
physical sectors is genuinely undecidable in general.  The *base points*,
however, are fully concrete and do carry `DecidableEq` (derived on
`MonsterBasePoint`), which is what is actually used for comparison. -/

/-- A default (empty) physical sector, used as the `Inhabited` witness. -/
instance : Inhabited PhysSector where
  default :=
    { dim4_QFT      := PUnit
      anomaly_poly  := PUnit
      pte_data      := PUnit
      worldsheet_VA := PUnit
      ss_primes     := ∅
      blade_space   := PUnit
      crt_orbifold  := 0
      glue_map      := fun _ => PUnit.unit }

/-- The Monster VOA `V♮` is the default base point. -/
instance : Inhabited MonsterBasePoint := ⟨MonsterBasePoint.Vnat⟩

/-- The default section is the empty fiber over `V♮`. -/
instance : Inhabited SheafSection := ⟨{ base_point := default, fiber := default }⟩

/-- Constructor alias: the base point indexed by a Monster conjugacy class `g`
(an Atlas label such as `"2A"`, `"71A"`).  This makes sections indexable by
actual McKay–Thompson data. -/
abbrev MonsterBasePoint.ConjClass (g : String) : MonsterBasePoint :=
  MonsterBasePoint.conjugacyClass g

/-- Constructor alias: the base point indexed by the graded VOA piece `V♮ₙ`. -/
abbrev MonsterBasePoint.VOAGrade (n : ℤ) : MonsterBasePoint :=
  MonsterBasePoint.voaSector n

/-! ### §10.3 Query API for sectors

Total, computable functions that expose the arithmetic skeleton of a glued
section, so it can be inspected and compared. -/

/-- The product of the supersingular primes carried by a section's fiber.
For the full minicharged section this is the "Oggorial". -/
def sectorSupersingularProduct (s : SheafSection) : ℕ :=
  s.fiber.ss_primes.prod id

/-- The number of supersingular primes carried by a section's fiber. -/
def sectorSupersingularCard (s : SheafSection) : ℕ :=
  s.fiber.ss_primes.card

/-- The number of blades in the section's `Cl(k)` hypercube, i.e. `2 ^ k`
where `k = sectorSupersingularCard s` is the number of supersingular primes
carried by the fiber.  (The `Cl(k)` blade space is `Finset (Fin k)`, which has
`2 ^ k` elements; for the full minicharged section, `k = 15` and this is
`2 ^ 15 = 32768`.) -/
def sectorBladeCard (s : SheafSection) : ℕ :=
  2 ^ s.fiber.ss_primes.card

/-! ## §11. Sheaf Navigation, Comparison, Families and Diagrams

This section turns the static sheaf-section layer into a *navigable, queryable,
extensible* object.  As with the rest of the glue layer everything here is
purely organizational/interpretive: no new physical theorem is asserted.  The
navigation operators move between sections, the comparison predicates give a
sheaf-theoretic equivalence relation, families collect sections, and diagrams
record sections together with the morphisms between them. -/

/-! ### §11.1 Section morphisms -/

/-- A morphism between two sheaf sections: a map on the anomaly-polynomial
fibers.  This is the categorical arrow of the sheaf-section layer (it records a
transformation of anomaly data from the source section to the target). -/
structure SectionMorph where
  /-- The source section. -/
  src : SheafSection
  /-- The target section. -/
  dst : SheafSection
  /-- The underlying map on anomaly-polynomial fibers. -/
  map : src.fiber.anomaly_poly → dst.fiber.anomaly_poly

/-- The identity morphism on a section (identity on its anomaly fiber). -/
def SectionMorph.id (s : SheafSection) : SectionMorph where
  src := s
  dst := s
  map := _root_.id

/-! ### §11.2 Navigation operators

These are *interpretive* navigation operators, not physical evolution. -/

/-- A Hecke-indexed navigation operator `T_p`.  It keeps the fiber fixed and
moves the base point: graded VOA sectors are shifted by `p` (`V♮ₙ ↦ V♮₍ₙ₊ₚ₎`),
the distinguished VOA base `V♮` is sent to the graded sector `V♮ₚ`, and a
conjugacy-class base point is relabelled with the Hecke index.  Purely
combinatorial. -/
def heckeStep (p : ℕ) (s : SheafSection) : SheafSection :=
  { s with base_point :=
      match s.base_point with
      | MonsterBasePoint.Vnat => MonsterBasePoint.voaSector (p : ℤ)
      | MonsterBasePoint.voaSector n => MonsterBasePoint.voaSector (n + (p : ℤ))
      | MonsterBasePoint.conjugacyClass g =>
          MonsterBasePoint.conjugacyClass (g ++ "·T" ++ toString p) }

/-- The unique residue in `[0, 196883)` realizing the CRT triple
`(r47 mod 47, r59 mod 59, r71 mod 71)` for the three largest supersingular
primes `47, 59, 71` (whose product is `196883`).

Closed-form Chinese-Remainder reconstruction: the coefficients
`33512 = 59·71·8`, `113458 = 47·71·34`, `49914 = 47·59·18` use the modular
inverses `8 ≡ (59·71)⁻¹ (mod 47)`, `34 ≡ (47·71)⁻¹ (mod 59)`,
`18 ≡ (47·59)⁻¹ (mod 71)`. -/
def crtCombine (r47 r59 r71 : ℕ) : ℕ :=
  (33512 * r47 + 113458 * r59 + 49914 * r71) % 196883

/-- A CRT-indexed navigation operator.  It keeps the base point fixed and moves
the fiber's arithmetic label, replacing its CRT orbifold coordinate by the
residue `crtCombine r47 r59 r71`.  Interpretive only. -/
def crtStep (r47 r59 r71 : ℕ) (s : SheafSection) : SheafSection :=
  { s with fiber := { s.fiber with crt_orbifold := crtCombine r47 r59 r71 } }

/-- `heckeStep` never changes the fiber. -/
theorem heckeStep_fiber (p : ℕ) (s : SheafSection) :
    (heckeStep p s).fiber = s.fiber := rfl

/-- `crtStep` never changes the base point. -/
theorem crtStep_base (r47 r59 r71 : ℕ) (s : SheafSection) :
    (crtStep r47 r59 r71 s).base_point = s.base_point := rfl

/-- `crtStep` sets the fiber's CRT coordinate to `crtCombine r47 r59 r71`. -/
theorem crtStep_crt (r47 r59 r71 : ℕ) (s : SheafSection) :
    (crtStep r47 r59 r71 s).fiber.crt_orbifold = crtCombine r47 r59 r71 := rfl

/-- `crtCombine` realizes the metadata triple `(8 mod 47, 20 mod 59, 58 mod 71)`
as the residue `116427`, matching `Moonshine.orbifold_crt`. -/
theorem crtCombine_orbifold : crtCombine 8 20 58 = 116427 := by decide

/-- `crtCombine` reproduces the requested residues modulo `47, 59, 71`. -/
theorem crtCombine_residues :
    crtCombine 8 20 58 % 47 = 8 ∧
    crtCombine 8 20 58 % 59 = 20 ∧
    crtCombine 8 20 58 % 71 = 58 := by decide

/-! ### §11.3 Comparison API (a sheaf-theoretic equivalence) -/

/-- Arithmetic equivalence of sections: same supersingular primes and the same
blade space.  Captures "same arithmetic skeleton". -/
def arithEq (s₁ s₂ : SheafSection) : Prop :=
  s₁.fiber.ss_primes = s₂.fiber.ss_primes ∧
  s₁.fiber.blade_space = s₂.fiber.blade_space

/-- PTE equivalence of sections: the same PTE-solution data type. -/
def pteEq (s₁ s₂ : SheafSection) : Prop :=
  s₁.fiber.pte_data = s₂.fiber.pte_data

/-- Base-point equivalence of sections: the same `MonsterBasePoint`.  This is
decidable since `MonsterBasePoint` has `DecidableEq`. -/
def baseEq (s₁ s₂ : SheafSection) : Prop :=
  s₁.base_point = s₂.base_point

instance (s₁ s₂ : SheafSection) : Decidable (baseEq s₁ s₂) :=
  inferInstanceAs (Decidable (s₁.base_point = s₂.base_point))

/-- `arithEq` is reflexive. -/
theorem arithEq_refl (s : SheafSection) : arithEq s s := ⟨rfl, rfl⟩

/-- `arithEq` is symmetric. -/
theorem arithEq_symm {s₁ s₂ : SheafSection} (h : arithEq s₁ s₂) : arithEq s₂ s₁ :=
  ⟨h.1.symm, h.2.symm⟩

/-- `arithEq` is transitive. -/
theorem arithEq_trans {s₁ s₂ s₃ : SheafSection}
    (h₁ : arithEq s₁ s₂) (h₂ : arithEq s₂ s₃) : arithEq s₁ s₃ :=
  ⟨h₁.1.trans h₂.1, h₁.2.trans h₂.2⟩

/-- `pteEq` is reflexive. -/
theorem pteEq_refl (s : SheafSection) : pteEq s s := rfl

/-- `pteEq` is symmetric. -/
theorem pteEq_symm {s₁ s₂ : SheafSection} (h : pteEq s₁ s₂) : pteEq s₂ s₁ := h.symm

/-- `pteEq` is transitive. -/
theorem pteEq_trans {s₁ s₂ s₃ : SheafSection}
    (h₁ : pteEq s₁ s₂) (h₂ : pteEq s₂ s₃) : pteEq s₁ s₃ := h₁.trans h₂

/-! ### §11.4 Section families -/

/-- A family of sheaf sections (e.g. the Minicharged + AltMinicharged sectors). -/
abbrev SectionFamily := List SheafSection

/-- The supersingular-prime products of every section in a family. -/
def familySupersingularProduct (F : SectionFamily) : List ℕ :=
  F.map sectorSupersingularProduct

/-- The blade counts of every section in a family. -/
def familyBladeCard (F : SectionFamily) : List ℕ :=
  F.map sectorBladeCard

/-- The base points of every section in a family. -/
def familyBasePoints (F : SectionFamily) : List MonsterBasePoint :=
  F.map (·.base_point)

/-! ### §11.5 Lift to arithmetic -/

/-- The reverse direction of the glue: the CRT orbifold coordinate as a
canonical arithmetic label for a section. -/
def liftToArithmetic (s : SheafSection) : ℕ :=
  s.fiber.crt_orbifold

/-- `liftToArithmetic` reads off the fiber's CRT coordinate. -/
theorem liftToArithmetic_eq (s : SheafSection) :
    liftToArithmetic s = s.fiber.crt_orbifold := rfl

/-! ### §11.6 Sheaf diagrams -/

/-- A sheaf diagram: a list of section nodes together with a list of section
morphisms (edges).  This is the extensible structural object on which Hecke /
CRT navigation edges can later be hung. -/
structure SheafDiagram where
  /-- The section nodes of the diagram. -/
  nodes : List SheafSection
  /-- The morphism edges of the diagram. -/
  edges : List SectionMorph

/-- The empty diagram. -/
def SheafDiagram.empty : SheafDiagram := ⟨[], []⟩

/-- The number of nodes in a diagram. -/
def SheafDiagram.numNodes (D : SheafDiagram) : ℕ := D.nodes.length

/-- The number of edges in a diagram. -/
def SheafDiagram.numEdges (D : SheafDiagram) : ℕ := D.edges.length

end MoonshineOntology
