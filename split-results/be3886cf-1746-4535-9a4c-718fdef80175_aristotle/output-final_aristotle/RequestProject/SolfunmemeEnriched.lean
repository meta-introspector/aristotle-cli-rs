/-
# Solfunmeme Enriched Reachability Graph

The original 72-edge graph had 38 isolated concepts and Semiotics was
completely cut off from the rest of the ontology. This module adds
**semantically motivated cross-cluster edges** that capture real
conceptual relationships implicit in the UML model but not explicitly
drawn as associations.

## Design Principles for New Edges
Each new edge has a philosophical/scientific justification:
- **Curry-Howard**: Logic ↔ Type (propositions-as-types)
- **Semiotics bridge**: Signs require consciousness to interpret;
  memes are cultural signs; cultural artifacts are symbols
- **Emergence**: Consciousness emerges from organisms
- **Bioinformatics**: Databases store DNA; algorithms process sequences
- **Topology–Biology**: Protein folding is a topological problem
- **Information theory**: All clusters connect through information flow

## Result
The enriched graph has 124 edges (was 72), only 1 isolated concept (was 38),
and every cluster reaches at least 4 others.
-/

import Mathlib
import RequestProject.SolfunmemeOntology

namespace Solfunmeme.Enriched

open Solfunmeme

/-- All clusters. -/
def Cluster.all : List Cluster :=
  [.mathematics, .computation, .metaphysics, .biology,
   .culture, .technology, .typeTheory, .semiotics]

-- ============================================================================
-- § 1  Enriched adjacency — original 72 edges + new cross-cluster edges
-- ============================================================================

/-- The enriched adjacency function.
    Includes all 72 original edges plus semantically motivated cross-cluster
    connections. Each new edge is annotated with its justification. -/
def adjacent : Concept → Concept → Bool
  -- ═══════════════════════════════════════════════════════════════════════
  -- Original 72 edges (unchanged from SolfunmemeReachability)
  -- ═══════════════════════════════════════════════════════════════════════
  -- Generalization edges (child → parent)
  | .naturalNumber, .number => true
  | .integerNum, .number => true
  | .realNumber, .number => true
  | .complexNumber, .number => true
  | .oeisSequence, .sequence => true
  | .primes, .sequence => true
  | .fibonacci, .oeisSequence => true
  | .finiteModel, .model => true
  | .ring, .group => true
  | .fieldAlgebra, .ring => true
  | .vectorSpace, .group => true
  | .homomorphism, .morphism => true
  | .isomorphism, .homomorphism => true
  | .executable, .programConcept => true
  | .variableConcept, .expression => true
  | .constantConcept, .expression => true
  | .metaMeme, .meme => true
  | .skibidiToilet, .meme => true
  | .pianoMan, .meme => true
  | .gitConcept, .programConcept => true
  | .linuxConcept, .programConcept => true
  | .dockerConcept, .programConcept => true
  | .dependentType, .typeConcept => true
  | .inductiveType, .typeConcept => true
  | .coinductiveType, .typeConcept => true
  | .symbolConcept, .signConcept => true
  | .iconConcept, .signConcept => true
  | .indexConcept, .signConcept => true
  | .homotopyTypeTheory, .theoryConcept => true
  | .categoryTheoryConcept, .theoryConcept => true
  | .lambdaCalculus, .theoryConcept => true
  | .computabilityTheory, .theoryConcept => true
  -- Original association edges
  | .model, .sequence => true
  | .finiteModel, .sequence => true
  | .compiler, .executable => true
  | .executable, .compiler => true
  | .compiler, .languageConcept => true
  | .programConcept, .languageConcept => true
  | .functionConcept, .setConcept => true
  | .functorConcept, .categoryConcept => true
  | .theoryConcept, .theoryConcept => true
  | .theoryConcept, .model => true
  | .homotopyTypeTheory, .uniMathConcept => true
  | .categoryTheoryConcept, .functorConcept => true
  | .mind, .consciousness => true
  | .consciousness, .mind => true
  | .meme, .gene => true
  | .gene, .protein => true
  | .dna, .gene => true
  | .rna, .dna => true
  | .cellConcept, .dna => true
  | .evolution, .mutation => true
  | .evolution, .selection => true
  | .organism, .speciesConcept => true
  | .populationConcept, .speciesConcept => true
  | .gitHubConcept, .gitConcept => true
  | .kubernetesConcept, .dockerConcept => true
  | .apiConcept, .protocolConcept => true
  | .networkConcept, .protocolConcept => true
  | .webServerConcept, .apiConcept => true
  | .signConcept, .signifierConcept => true
  | .signConcept, .signifiedConcept => true
  | .goedelConcept, .logic => true
  | .turingConcept, .computabilityTheory => true
  | .churchConcept, .lambdaCalculus => true
  | .proofConcept, .theoremConcept => true
  | .objectConcept, .classConcept => true
  | .classConcept, .interfaceConcept => true
  | .methodConcept, .typeConcept => true
  | .expression, .typeConcept => true
  | .topology, .setConcept => true
  | .relation, .setConcept => true

  -- ═══════════════════════════════════════════════════════════════════════
  -- NEW CROSS-CLUSTER EDGES — semantically motivated bridges
  -- ═══════════════════════════════════════════════════════════════════════

  -- ── Curry-Howard correspondence (Math ↔ Computation) ──
  -- Propositions are types, proofs are programs
  | .logic, .typeConcept => true            -- logic ↔ types
  | .proofConcept, .programConcept => true  -- proofs are programs
  | .axiom_, .typeConcept => true           -- axioms are type constructors
  | .algorithm, .functionConcept => true    -- algorithms implement functions
  | .dataStructure, .setConcept => true     -- data structures model sets

  -- ── Semiotics → Metaphysics (signs require consciousness) ──
  | .signConcept, .consciousness => true    -- interpretation requires awareness
  | .signifiedConcept, .mind => true        -- meaning lives in the mind

  -- ── Culture → Semiotics (cultural artifacts are signs) ──
  | .skibidiToilet, .symbolConcept => true  -- internet memes are symbols
  | .pianoMan, .symbolConcept => true       -- songs are symbolic expressions
  | .meme, .signConcept => true             -- memes are signs (Dawkins meets Peirce)

  -- ── Biology → Metaphysics (emergence) ──
  | .organism, .consciousness => true       -- consciousness emerges from organisms
  | .evolution, .timeConcept => true        -- evolution requires time
  | .ecosystem, .orderConcept => true       -- ecosystems exhibit emergent order

  -- ── Metaphysics → Biology (philosophy of life) ──
  | .consciousness, .organism => true       -- consciousness embodied in organisms
  | .causality, .evolution => true          -- causality drives evolution

  -- ── Technology → Biology (bioinformatics) ──
  | .databaseConcept, .dna => true          -- databases store genomic data
  | .algorithm, .sequence => true           -- algorithms process sequences

  -- ── Math → Biology (mathematical biology) ──
  | .topology, .protein => true             -- protein folding is topological
  | .sequence, .gene => true                -- genes are sequences
  | .number, .populationConcept => true     -- populations are counted

  -- ── Semiotics → Math (formal semiotics) ──
  | .signConcept, .relation => true         -- sign relations are ternary relations
  | .firstness, .categoryConcept => true    -- Peircean firstness → category theory

  -- ── Metaphysics → Semiotics (meaning and truth) ──
  | .truth, .signifiedConcept => true       -- truth is what signs signify
  | .identityConcept, .signConcept => true  -- identity requires signification

  -- ── Metaphysics → Computation (philosophy of mind/AI) ──
  | .mind, .algorithm => true               -- mind as computation
  | .consciousness, .programConcept => true -- computational theory of consciousness

  -- ── Technology → Math (computational tools) ──
  | .databaseConcept, .relation => true     -- relational databases use relations
  | .networkConcept, .topology => true      -- network topology

  -- ── Computation → Technology (implementation) ──
  | .programConcept, .gitConcept => true    -- programs stored in git
  | .compiler, .linuxConcept => true        -- compilers run on linux

  -- ── Internal edges to reduce isolation ──
  | .chaos, .orderConcept => true           -- chaos and order are dual
  | .good, .evil => true                    -- good and evil are dual
  | .beauty, .truth => true                 -- Keats: beauty is truth
  | .justice, .freedom => true              -- justice enables freedom
  | .matter, .energyConcept => true         -- E = mc²
  | .spaceConcept, .timeConcept => true     -- spacetime
  | .soul, .spirit => true                  -- soul and spirit are linked
  | .unityConcept, .dualityConcept => true  -- unity contains duality
  | .infinityConcept, .number => true       -- infinity extends number
  | .voidConcept, .setConcept => true       -- void is the empty set
  | .manifold, .topology => true            -- manifolds are topological spaces
  | .ellipticCurve, .group => true          -- EC forms a group
  | .statementConcept, .expression => true  -- statements contain expressions
  | .operatorConcept, .functionConcept => true  -- operators are functions
  | .moduleConcept, .classConcept => true   -- modules contain classes
  | .signalConcept, .eventConcept => true   -- signals trigger events
  | .propertyConcept, .typeConcept => true  -- properties have types
  | .fitnessConcept, .selection => true     -- fitness drives selection
  | .cellConcept, .organism => true         -- cells compose organisms
  | .secondness, .relation => true          -- Peircean secondness is dyadic relation
  | .thirdness, .signConcept => true        -- Peircean thirdness is the sign relation
  | .lambdaCalculus, .functionConcept => true  -- λ-calc formalizes functions

  | _, _ => false

-- ============================================================================
-- § 2  BFS reachability on the enriched graph
-- ============================================================================

/-- Neighbors of a concept in the enriched directed graph. -/
def neighbors (c : Concept) : List Concept :=
  Concept.all.filter (adjacent c ·)

/-- BFS reachability on the enriched graph. -/
def bfsReachable (start : Concept) (fuel : Nat := 121) : List Concept :=
  go [start] [start] fuel
where
  go (visited frontier : List Concept) : Nat → List Concept
    | 0 => visited
    | n + 1 =>
      let newFrontier :=
        (frontier.flatMap neighbors).filter (· ∉ visited) |>.eraseDups
      if newFrontier.isEmpty then visited
      else go (visited ++ newFrontier) newFrontier n

/-- Enriched reachability predicate. -/
def reaches (source target : Concept) : Bool :=
  target ∈ bfsReachable source

-- ============================================================================
-- § 3  Statistics
-- ============================================================================

/-- Edge count in the enriched graph. -/
def edgeCount : Nat :=
  (Concept.all.flatMap (fun a => Concept.all.filter (adjacent a ·))).length

def reachableSetSize (c : Concept) : Nat :=
  (bfsReachable c).length

def isSink (c : Concept) : Bool := (neighbors c).isEmpty
def isSource (c : Concept) : Bool := Concept.all.all (fun a => !adjacent a c)
def isIsolated (c : Concept) : Bool := isSink c && isSource c
def isolatedCount : Nat := (Concept.all.filter isIsolated).length

def clusterReaches (c1 c2 : Cluster) : Bool :=
  (Concept.all.filter (·.cluster == c1)).any fun a =>
    (Concept.all.filter (·.cluster == c2)).any fun b =>
      reaches a b

-- ============================================================================
-- § 4  Edge count and isolation reduction (verified)
-- ============================================================================

/-- The enriched graph has 124 directed edges (was 72 — a 72% increase). -/
theorem enriched_edge_count : edgeCount = 124 := by native_decide

/-- The enriched graph has only 1 isolated concept (was 38). -/
theorem enriched_isolated_count : isolatedCount = 1 := by native_decide

-- ============================================================================
-- § 5  Cross-cluster reachability — previously impossible connections
-- ============================================================================

-- ── Semiotics is no longer isolated! ──

/-- Semiotics now reaches Metaphysics (sign → consciousness). -/
theorem semiotics_reaches_metaphysics :
    clusterReaches .semiotics .metaphysics = true := by native_decide

/-- Semiotics now reaches Mathematics (sign → relation → set). -/
theorem semiotics_reaches_math :
    clusterReaches .semiotics .mathematics = true := by native_decide

/-- Semiotics reaches Biology (sign → consciousness → organism). -/
theorem semiotics_reaches_biology :
    clusterReaches .semiotics .biology = true := by native_decide

/-- Semiotics reaches Computation (sign → consciousness → program). -/
theorem semiotics_reaches_computation :
    clusterReaches .semiotics .computation = true := by native_decide

/-- Semiotics reaches Technology (sign → consciousness → program → git). -/
theorem semiotics_reaches_technology :
    clusterReaches .semiotics .technology = true := by native_decide

-- ── Mathematics now reaches Computation (Curry-Howard) ──

/-- Math reaches Computation via Curry-Howard (logic → type). -/
theorem math_reaches_computation :
    clusterReaches .mathematics .computation = true := by native_decide

/-- Computation reaches Math (algorithm → function → set). -/
theorem computation_reaches_math :
    clusterReaches .computation .mathematics = true := by native_decide

-- ── Biology connects to Metaphysics ──

/-- Biology reaches Metaphysics (organism → consciousness). -/
theorem biology_reaches_metaphysics :
    clusterReaches .biology .metaphysics = true := by native_decide

/-- Metaphysics reaches Biology (causality → evolution). -/
theorem metaphysics_reaches_biology :
    clusterReaches .metaphysics .biology = true := by native_decide

-- ── Technology bridges to Biology and Math ──

/-- Technology reaches Biology (database → dna → gene → protein). -/
theorem technology_reaches_biology :
    clusterReaches .technology .biology = true := by native_decide

/-- Technology reaches Math (network → topology → set). -/
theorem technology_reaches_math :
    clusterReaches .technology .mathematics = true := by native_decide

-- ── Culture reaches Semiotics and beyond ──

/-- Culture reaches Semiotics (skibidi → symbol → sign). -/
theorem culture_reaches_semiotics :
    clusterReaches .culture .semiotics = true := by native_decide

-- ── Metaphysics is richly connected ──

/-- Metaphysics reaches Computation (mind → algorithm). -/
theorem metaphysics_reaches_computation :
    clusterReaches .metaphysics .computation = true := by native_decide

/-- Metaphysics reaches Semiotics (identity → sign). -/
theorem metaphysics_reaches_semiotics :
    clusterReaches .metaphysics .semiotics = true := by native_decide

-- ============================================================================
-- § 6  Grand multi-hop paths across the entire ontology
-- ============================================================================

/-- Skibidi Toilet reaches Algorithm!
    Path: skibidi → meme → sign → consciousness → mind → algorithm.
    Internet memes influence computational thinking. -/
theorem skibidi_reaches_algorithm :
    reaches .skibidiToilet .algorithm = true := by native_decide

/-- Gödel reaches Type (Gödel → logic → type).
    Incompleteness meets type theory (Curry-Howard). -/
theorem goedel_reaches_type :
    reaches .goedelConcept .typeConcept = true := by native_decide

/-- Infinity reaches Species (infinity → number → population → species). -/
theorem infinity_reaches_species :
    reaches .infinityConcept .speciesConcept = true := by native_decide

/-- Church reaches DNA via λ-calculus.
    church → lambdaCalc → theory → model → sequence → gene → dna? or
    church → lambdaCalc → function → set ← ... The computational theory of life. -/
theorem church_reaches_gene :
    reaches .churchConcept .gene = true := by native_decide

/-- The void reaches the empty set (void → set).
    Philosophically: nothingness is the empty collection. -/
theorem void_reaches_set :
    reaches .voidConcept .setConcept = true := by native_decide

/-- Beauty reaches Protein.
    beauty → truth → signified → mind → consciousness → organism →
    ... → cell → dna → gene → protein. Keats meets biology. -/
theorem beauty_reaches_protein :
    reaches .beauty .protein = true := by native_decide

/-- Chaos reaches Order (chaos → order). Dialectical duality. -/
theorem chaos_reaches_order :
    reaches .chaos .orderConcept = true := by native_decide

/-- Spacetime: space reaches time. -/
theorem space_reaches_time :
    reaches .spaceConcept .timeConcept = true := by native_decide

/-- Matter reaches Energy (E = mc²). -/
theorem matter_reaches_energy :
    reaches .matter .energyConcept = true := by native_decide

/-- Peircean Thirdness reaches Consciousness.
    thirdness → sign → consciousness. The sign relation is triadic awareness. -/
theorem thirdness_reaches_consciousness :
    reaches .thirdness .consciousness = true := by native_decide

/-- Elliptic curve reaches Group (elliptic curves form groups). -/
theorem elliptic_curve_reaches_group :
    reaches .ellipticCurve .group = true := by native_decide

/-- Skibidi reaches Protein AND Algorithm AND Consciousness — a concept that
    spans Culture, Biology, Computation, and Metaphysics! -/
theorem skibidi_universal :
    reaches .skibidiToilet .protein = true ∧
    reaches .skibidiToilet .algorithm = true ∧
    reaches .skibidiToilet .consciousness = true ∧
    reaches .skibidiToilet .setConcept = true := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 7  Cluster connectivity summary
-- ============================================================================

/-- Every cluster reaches at least 4 others in the enriched graph
    (minimum connectivity is 4/8). -/
theorem every_cluster_reaches_four :
    (∀ c : Cluster,
      (Cluster.all.filter (clusterReaches c ·)).length ≥ 4) := by
  intro c; cases c <;> native_decide

/-- Type Theory reaches 5 clusters: Math, Comp, Meta, Bio, and itself. -/
theorem typetheory_reach_count :
    (Cluster.all.filter (clusterReaches .typeTheory ·)).length = 5 := by
  native_decide

/-- Culture reaches 7 of 8 clusters — the most connected! -/
theorem culture_reach_count :
    (Cluster.all.filter (clusterReaches .culture ·)).length = 7 := by
  native_decide

/-- Metaphysics reaches 6 clusters. -/
theorem metaphysics_reach_count :
    (Cluster.all.filter (clusterReaches .metaphysics ·)).length = 6 := by
  native_decide

/-- Semiotics reaches 6 clusters (was 1 — the biggest improvement). -/
theorem semiotics_reach_count :
    (Cluster.all.filter (clusterReaches .semiotics ·)).length = 6 := by
  native_decide

-- ============================================================================
-- § 8  Comparison with original graph
-- ============================================================================

/-- The enriched graph has 52 more edges than the original (124 vs 72). -/
theorem edge_increase : edgeCount - 72 = 52 := by native_decide

/-- The enriched graph reduced isolation from 38 to 1 concept — a 97% reduction. -/
theorem isolation_reduction : 38 - isolatedCount = 37 := by native_decide

-- ============================================================================
-- § 9  Summary statistics
-- ============================================================================

#eval IO.println s!"═══ Solfunmeme ENRICHED Reachability Engine ═══"
#eval IO.println s!"  Total edges: {edgeCount} (was 72, +{edgeCount - 72})"
#eval IO.println s!"  Isolated concepts: {isolatedCount} (was 38)"

#eval do
  let interesting : List (String × Concept) := [
    ("Theory", .theoryConcept),
    ("HoTT", .homotopyTypeTheory),
    ("Cell", .cellConcept),
    ("Sign", .signConcept),
    ("Skibidi", .skibidiToilet),
    ("Gödel", .goedelConcept),
    ("Chaos", .chaos),
    ("Infinity", .infinityConcept),
    ("Beauty", .beauty),
    ("Consciousness", .consciousness),
    ("DNA", .dna),
    ("Thirdness", .thirdness)
  ]
  IO.println s!"\nReachable set sizes (enriched):"
  for (name, c) in interesting do
    IO.println s!"  {name}: {reachableSetSize c} concepts"

#eval do
  let clusters : List (String × Cluster) := [
    ("Math", .mathematics), ("Comp", .computation),
    ("Meta", .metaphysics), ("Bio ", .biology),
    ("Cult", .culture), ("Tech", .technology),
    ("TT  ", .typeTheory), ("Sem ", .semiotics)
  ]
  IO.println s!"\nEnriched Cluster Reachability Matrix:"
  IO.print "       "
  for (n, _) in clusters do
    IO.print s!"{n} "
  IO.println ""
  for (n1, c1) in clusters do
    IO.print s!"  {n1}: "
    for (_, c2) in clusters do
      let r := if clusterReaches c1 c2 then " ✓  " else " ·  "
      IO.print r
    IO.println ""

#eval do
  let clusters : List (String × Cluster) := [
    ("Mathematics", .mathematics), ("Computation", .computation),
    ("Metaphysics", .metaphysics), ("Biology", .biology),
    ("Culture", .culture), ("Technology", .technology),
    ("Type Theory", .typeTheory), ("Semiotics", .semiotics)
  ]
  IO.println s!"\nCluster reach counts:"
  for (n, c) in clusters do
    let count := (Cluster.all.filter (clusterReaches c ·)).length
    IO.println s!"  {n}: reaches {count}/8 clusters"

end Solfunmeme.Enriched
