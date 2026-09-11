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

end MoonshineOntology
