/-
# Solfunmeme Reachability Engine

This module turns the solfunmeme ontology from a static catalog into
an executable, queryable semantic graph.

## Structure
1. **Adjacency** — edges from Generalization ∪ Association
2. **Computable reachability** — bounded BFS over the finite concept universe
3. **Reachability theorems** — verified semantic paths
4. **Connectivity analysis** — weakly connected components

## Design
The self-referential relationships (Theory → Theory) live in the ontology
layer. At the schema-generation level the SCC analysis shows 121 singletons
(acyclic), but the *semantic* graph formed by Generalization ∪ Association
edges can have cycles and non-trivial reachability.

The graph is made fully decidable by exploiting the finite 121-concept
universe with bounded BFS.
-/

import Mathlib
import RequestProject.SolfunmemeOntology

namespace Solfunmeme

-- ============================================================================
-- § 1  Adjacency — extracting edges from the ontology
-- ============================================================================

/-- The adjacency function for the concept graph.
    Returns `true` iff there is a direct edge from `a` to `b`,
    coming from either a Generalization or an Association. -/
def adjacent : Concept → Concept → Bool
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
  -- Association edges (source → target)
  | .model, .sequence => true
  | .finiteModel, .sequence => true
  | .compiler, .executable => true
  | .executable, .compiler => true
  | .compiler, .languageConcept => true
  | .programConcept, .languageConcept => true
  | .functionConcept, .setConcept => true
  | .functorConcept, .categoryConcept => true
  | .theoryConcept, .theoryConcept => true  -- self-reference
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
  | _, _ => false

/-- Neighbors of a concept in the directed graph. -/
def neighbors (c : Concept) : List Concept :=
  Concept.all.filter (adjacent c ·)

-- ============================================================================
-- § 2  Computable reachability via bounded BFS
-- ============================================================================

/-- Run BFS for at most `fuel` steps from a starting concept.
    Returns the list of all reachable concepts (including the start). -/
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

/-- Decidable reachability: can we reach `target` from `source`?
    Computed by BFS over the finite 121-concept universe. -/
def reaches (source target : Concept) : Bool :=
  target ∈ bfsReachable source

-- ============================================================================
-- § 3  Graph statistics
-- ============================================================================

/-- Number of directed edges in the concept graph. -/
def edgeCount : Nat :=
  (Concept.all.flatMap (fun a => Concept.all.filter (adjacent a ·))).length

/-- Compute the reachable set size from a given concept. -/
def reachableSetSize (c : Concept) : Nat :=
  (bfsReachable c).length

/-- Concepts with no outgoing edges are sinks. -/
def isSink (c : Concept) : Bool :=
  (neighbors c).isEmpty

/-- Concepts with no incoming edges are sources. -/
def isSource (c : Concept) : Bool :=
  Concept.all.all (fun a => !adjacent a c)

/-- A concept is isolated if it has no edges at all. -/
def isIsolated (c : Concept) : Bool :=
  isSink c && isSource c

/-- Count isolated concepts. -/
def isolatedCount : Nat :=
  (Concept.all.filter isIsolated).length

/-- Can any concept in cluster `c1` reach any concept in cluster `c2`? -/
def clusterReaches (c1 c2 : Cluster) : Bool :=
  (Concept.all.filter (·.cluster == c1)).any fun a =>
    (Concept.all.filter (·.cluster == c2)).any fun b =>
      reaches a b

-- ============================================================================
-- § 4  Verified reachability theorems
-- ============================================================================

-- Each theorem is verified by direct computation (native_decide) on the
-- Bool `reaches` function over the finite 121-concept universe.

/-- Consciousness reaches Mind. -/
theorem consciousness_reaches_mind : reaches .consciousness .mind = true := by
  native_decide

/-- Mind reaches Consciousness. -/
theorem mind_reaches_consciousness : reaches .mind .consciousness = true := by
  native_decide

/-- The compiler-executable cycle is reachable in both directions. -/
theorem compiler_executable_cycle :
    reaches .compiler .executable = true ∧
    reaches .executable .compiler = true := by
  constructor <;> native_decide

/-- Theory reaches itself (self-reference is computable). -/
theorem theory_reaches_self : reaches .theoryConcept .theoryConcept = true := by
  native_decide

/-- HoTT reaches UniMath. -/
theorem hott_reaches_unimath :
    reaches .homotopyTypeTheory .uniMathConcept = true := by
  native_decide

/-- Fibonacci reaches OEIS Sequence. -/
theorem fibonacci_reaches_oeis :
    reaches .fibonacci .oeisSequence = true := by
  native_decide

/-- Turing reaches computability theory. -/
theorem turing_reaches_computability :
    reaches .turingConcept .computabilityTheory = true := by
  native_decide

/-- Church reaches lambda calculus. -/
theorem church_reaches_lambda :
    reaches .churchConcept .lambdaCalculus = true := by
  native_decide

/-- Gene reaches protein (gene → protein). -/
theorem gene_reaches_protein : reaches .gene .protein = true := by
  native_decide

/-- Cell reaches protein via: cell → dna → gene → protein. -/
theorem cell_reaches_protein : reaches .cellConcept .protein = true := by
  native_decide

/-- RNA reaches protein via: rna → dna → gene → protein. -/
theorem rna_reaches_protein : reaches .rna .protein = true := by
  native_decide

/-- GitHub reaches language via: github → git → program → language. -/
theorem github_reaches_language :
    reaches .gitHubConcept .languageConcept = true := by
  native_decide

/-- WebServer reaches protocol via: webserver → api → protocol. -/
theorem webserver_reaches_protocol :
    reaches .webServerConcept .protocolConcept = true := by
  native_decide

/-- Kubernetes reaches language via: kubernetes → docker → program → language. -/
theorem kubernetes_reaches_language :
    reaches .kubernetesConcept .languageConcept = true := by
  native_decide

/-- Isomorphism reaches morphism via: iso → homo → morphism. -/
theorem isomorphism_reaches_morphism :
    reaches .isomorphism .morphism = true := by
  native_decide

/-- Field reaches group via: field → ring → group. -/
theorem field_reaches_group : reaches .fieldAlgebra .group = true := by
  native_decide

/-- Category theory reaches category via: catTheory → functor → category. -/
theorem cattheory_reaches_category :
    reaches .categoryTheoryConcept .categoryConcept = true := by
  native_decide

/-- Sign reaches both signifier and signified. -/
theorem sign_reaches_both :
    reaches .signConcept .signifierConcept = true ∧
    reaches .signConcept .signifiedConcept = true := by
  constructor <;> native_decide

/-- Gödel reaches logic. -/
theorem goedel_reaches_logic : reaches .goedelConcept .logic = true := by
  native_decide

-- ============================================================================
-- § 5  Negative reachability / sink theorems
-- ============================================================================

/-- The number concept is a sink (nothing further reachable from it). -/
theorem number_is_sink : isSink .number = true := by native_decide

/-- Protein is a sink. -/
theorem protein_is_sink : isSink .protein = true := by native_decide

/-- There are exactly 38 isolated concepts (no edges in or out). -/
theorem isolated_concept_count : isolatedCount = 38 := by native_decide

/-- The graph has exactly 72 directed edges. -/
theorem edge_count_72 : edgeCount = 72 := by native_decide

-- ============================================================================
-- § 6  Cluster reachability (verified from computed matrix)
-- ============================================================================

-- The computed cluster reachability matrix is:
--        Math Comp Meta Bio  Cult Tech TT   Sem
--   Math:  ✓   ·    ✓   ·    ·    ·    ·    ·
--   Comp:  ·   ✓    ·   ·    ·    ·    ·    ·
--   Meta:  ✓   ·    ✓   ·    ·    ·    ·    ·
--   Bio :  ·   ·    ·   ✓    ·    ·    ·    ·
--   Cult:  ·   ·    ·   ✓    ✓    ·    ·    ·
--   Tech:  ·   ✓    ·   ·    ·    ✓    ·    ·
--   TT  :  ✓   ✓    ✓   ·    ·    ·    ✓    ·
--   Sem :  ·   ·    ·   ·    ·    ·    ·    ✓

/-- Mathematics reaches Metaphysics (e.g. theory → theory self-ref, or
    functor → category which are in math, and goedel → logic). -/
theorem math_reaches_metaphysics :
    clusterReaches .mathematics .metaphysics = true := by native_decide

/-- Metaphysics reaches Mathematics (theory → model → sequence). -/
theorem metaphysics_reaches_math :
    clusterReaches .metaphysics .mathematics = true := by native_decide

/-- Culture reaches Biology (meme → gene). -/
theorem culture_reaches_biology :
    clusterReaches .culture .biology = true := by native_decide

/-- Technology reaches Computation (git/docker → program → language). -/
theorem tech_reaches_computation :
    clusterReaches .technology .computation = true := by native_decide

/-- Type Theory reaches Mathematics (catTheory → functor → category). -/
theorem typetheory_reaches_math :
    clusterReaches .typeTheory .mathematics = true := by native_decide

/-- Type Theory reaches Computation (catTheory → theory → ... or via
    functor/category edges in math that reach other clusters). -/
theorem typetheory_reaches_computation :
    clusterReaches .typeTheory .computation = true := by native_decide

/-- Type Theory reaches Metaphysics (HoTT → theory). -/
theorem typetheory_reaches_metaphysics :
    clusterReaches .typeTheory .metaphysics = true := by native_decide

/-- Semiotics reaches itself (sign → signifier/signified). -/
theorem semiotics_reaches_semiotics :
    clusterReaches .semiotics .semiotics = true := by native_decide

/-- Biology reaches itself (gene → protein, dna → gene, etc.). -/
theorem biology_reaches_biology :
    clusterReaches .biology .biology = true := by native_decide

-- Negative cluster reachability: verified impossibilities

/-- Mathematics cannot reach Computation directly. -/
theorem math_not_reaches_computation :
    clusterReaches .mathematics .computation = false := by native_decide

/-- Computation cannot reach Mathematics directly. -/
theorem computation_not_reaches_math :
    clusterReaches .computation .mathematics = false := by native_decide

/-- Semiotics cannot reach any other cluster. -/
theorem semiotics_isolated_cluster :
    clusterReaches .semiotics .mathematics = false ∧
    clusterReaches .semiotics .computation = false ∧
    clusterReaches .semiotics .metaphysics = false ∧
    clusterReaches .semiotics .biology = false ∧
    clusterReaches .semiotics .culture = false ∧
    clusterReaches .semiotics .technology = false ∧
    clusterReaches .semiotics .typeTheory = false := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 7  Multi-hop path theorems (longer chains)
-- ============================================================================

/-- Theory reaches Sequence via: theory → model → sequence. -/
theorem theory_reaches_sequence :
    reaches .theoryConcept .sequence = true := by native_decide

/-- HoTT reaches Sequence via: HoTT → theory → model → sequence. -/
theorem hott_reaches_sequence :
    reaches .homotopyTypeTheory .sequence = true := by native_decide

/-- Church reaches Theory via: church → lambdaCalc → theory. -/
theorem church_reaches_theory :
    reaches .churchConcept .theoryConcept = true := by native_decide

/-- Turing reaches Theory via: turing → compTheory → theory. -/
theorem turing_reaches_theory :
    reaches .turingConcept .theoryConcept = true := by native_decide

/-- Turing reaches Sequence via: turing → compTheory → theory → model → seq. -/
theorem turing_reaches_sequence :
    reaches .turingConcept .sequence = true := by native_decide

/-- Skibidi Toilet reaches Protein via: skibidi → meme → gene → protein. -/
theorem skibidi_reaches_protein :
    reaches .skibidiToilet .protein = true := by native_decide

-- ============================================================================
-- § 8  Summary statistics (computed at elaboration time)
-- ============================================================================

#eval IO.println s!"Solfunmeme Reachability Engine:"
#eval IO.println s!"  Edge count: {edgeCount}"
#eval IO.println s!"  Isolated concepts: {isolatedCount}"

#eval do
  let interesting : List (String × Concept) := [
    ("Theory", .theoryConcept),
    ("HoTT", .homotopyTypeTheory),
    ("Cell", .cellConcept),
    ("Compiler", .compiler),
    ("GitHub", .gitHubConcept),
    ("Sign", .signConcept),
    ("Church", .churchConcept),
    ("Turing", .turingConcept),
    ("Gödel", .goedelConcept),
    ("Skibidi", .skibidiToilet)
  ]
  IO.println s!"\nReachable set sizes:"
  for (name, c) in interesting do
    IO.println s!"  {name}: {reachableSetSize c} concepts"

-- Cluster reachability matrix
#eval do
  let clusters : List (String × Cluster) := [
    ("Math", .mathematics), ("Comp", .computation),
    ("Meta", .metaphysics), ("Bio ", .biology),
    ("Cult", .culture), ("Tech", .technology),
    ("TT  ", .typeTheory), ("Sem ", .semiotics)
  ]
  IO.println s!"\nCluster Reachability Matrix:"
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

end Solfunmeme
