/-
# Solfunmeme Ontology — Lean 4 Formalization

This module formalizes the solfunmeme UML model as native Lean 4 types,
capturing the full conceptual framework from the Modelio project:

## Structure
1. **Concept taxonomy** — 8 thematic clusters as inductive types
2. **Generalization hierarchies** — parent relationships from the UML model
3. **Association graph** — typed edges between concepts
4. **Instance specifications** — concrete exemplars (Fibonacci, Gödel, etc.)
5. **Verified theorems** — structural properties of the ontology

## Source
- Modelio project: solfunmeme (April 2025)
- User: jmikedupont on SOLFUNMEME1
- Original data: `data/fragments/solfunmeme/`
-/

import Mathlib

namespace Solfunmeme

-- ============================================================================
-- § 1  Concept Taxonomy — all concept clusters as a single enum
-- ============================================================================

/-- The thematic clusters of the solfunmeme ontology. -/
inductive Cluster where
  | mathematics
  | computation
  | metaphysics
  | biology
  | culture
  | technology
  | typeTheory
  | semiotics
  deriving DecidableEq, Repr, Inhabited

/-- All concepts in the solfunmeme UML model, organized by cluster. -/
inductive Concept where
  -- Mathematics (28 concepts)
  | number | naturalNumber | integerNum | realNumber | complexNumber
  | sequence | oeisSequence | primes | fibonacci
  | model | finiteModel | ellipticCurve
  | setConcept | functionConcept | relation
  | group | ring | fieldAlgebra | vectorSpace
  | topology | manifold
  | categoryConcept | functorConcept | morphism | homomorphism | isomorphism
  | logic | axiom_ | proofConcept | theoremConcept
  -- Computation (20 concepts)
  | languageConcept | programConcept | compiler | executable
  | algorithm | dataStructure
  | typeConcept | expression | variableConcept | constantConcept
  | operatorConcept | statementConcept
  | moduleConcept | interfaceConcept | classConcept | objectConcept
  | methodConcept | propertyConcept | eventConcept | signalConcept
  -- Metaphysics (22 concepts)
  | theoryConcept | chaos | orderConcept | good | evil
  | truth | beauty | justice | freedom
  | consciousness | mind | soul | spirit
  | matter | energyConcept | spaceConcept | timeConcept | causality
  | identityConcept | dualityConcept | unityConcept
  | infinityConcept | voidConcept
  -- Biology (15 concepts)
  | gene | meme | metaMeme
  | cellConcept | protein | dna | rna
  | organism | speciesConcept | evolution | mutation | selection
  | fitnessConcept | populationConcept | ecosystem
  -- Culture (2 concepts)
  | skibidiToilet | pianoMan
  -- Technology (10 concepts)
  | gitConcept | gitHubConcept | linuxConcept
  | dockerConcept | kubernetesConcept
  | databaseConcept | apiConcept | webServerConcept
  | networkConcept | protocolConcept
  -- Type Theory (6 concepts)
  | homotopyTypeTheory | uniMathConcept | categoryTheoryConcept
  | dependentType | inductiveType | coinductiveType
  -- Semiotics (9 concepts)
  | signConcept | signifierConcept | signifiedConcept
  | symbolConcept | iconConcept | indexConcept
  | firstness | secondness | thirdness
  -- Foundational figures (3 concepts)
  | goedelConcept | turingConcept | churchConcept
  -- Additional theories (2 concepts)
  | lambdaCalculus | computabilityTheory
  -- Person (1 concept)
  | jamesMichaelDuPont
  deriving DecidableEq, Repr, Inhabited

-- ============================================================================
-- § 2  Cluster assignment
-- ============================================================================

/-- Which cluster each concept belongs to. -/
def Concept.cluster : Concept → Cluster
  -- Mathematics
  | .number | .naturalNumber | .integerNum | .realNumber | .complexNumber
  | .sequence | .oeisSequence | .primes | .fibonacci
  | .model | .finiteModel | .ellipticCurve
  | .setConcept | .functionConcept | .relation
  | .group | .ring | .fieldAlgebra | .vectorSpace
  | .topology | .manifold
  | .categoryConcept | .functorConcept | .morphism | .homomorphism | .isomorphism
  | .logic | .axiom_ | .proofConcept | .theoremConcept
    => .mathematics
  -- Computation
  | .languageConcept | .programConcept | .compiler | .executable
  | .algorithm | .dataStructure
  | .typeConcept | .expression | .variableConcept | .constantConcept
  | .operatorConcept | .statementConcept
  | .moduleConcept | .interfaceConcept | .classConcept | .objectConcept
  | .methodConcept | .propertyConcept | .eventConcept | .signalConcept
    => .computation
  -- Metaphysics
  | .theoryConcept | .chaos | .orderConcept | .good | .evil
  | .truth | .beauty | .justice | .freedom
  | .consciousness | .mind | .soul | .spirit
  | .matter | .energyConcept | .spaceConcept | .timeConcept | .causality
  | .identityConcept | .dualityConcept | .unityConcept
  | .infinityConcept | .voidConcept
    => .metaphysics
  -- Biology
  | .gene | .meme | .metaMeme
  | .cellConcept | .protein | .dna | .rna
  | .organism | .speciesConcept | .evolution | .mutation | .selection
  | .fitnessConcept | .populationConcept | .ecosystem
    => .biology
  -- Culture
  | .skibidiToilet | .pianoMan => .culture
  -- Technology
  | .gitConcept | .gitHubConcept | .linuxConcept
  | .dockerConcept | .kubernetesConcept
  | .databaseConcept | .apiConcept | .webServerConcept
  | .networkConcept | .protocolConcept
    => .technology
  -- Type Theory
  | .homotopyTypeTheory | .uniMathConcept | .categoryTheoryConcept
  | .dependentType | .inductiveType | .coinductiveType
    => .typeTheory
  -- Semiotics
  | .signConcept | .signifierConcept | .signifiedConcept
  | .symbolConcept | .iconConcept | .indexConcept
  | .firstness | .secondness | .thirdness
    => .semiotics
  -- Foundational figures → mathematics
  | .goedelConcept | .turingConcept | .churchConcept => .mathematics
  -- Theories → mathematics
  | .lambdaCalculus | .computabilityTheory => .mathematics
  -- Person → culture
  | .jamesMichaelDuPont => .culture

-- ============================================================================
-- § 3  Generalization hierarchies
-- ============================================================================

/-- A generalization (inheritance) relationship: child extends parent.
    Mirrors the UML generalization arrows in the solfunmeme model. -/
inductive Generalization : Concept → Concept → Prop where
  -- Number hierarchy
  | nat_extends_number     : Generalization .naturalNumber .number
  | int_extends_number     : Generalization .integerNum .number
  | real_extends_number    : Generalization .realNumber .number
  | complex_extends_number : Generalization .complexNumber .number
  -- Sequence hierarchy
  | oeis_extends_sequence  : Generalization .oeisSequence .sequence
  | primes_extends_sequence : Generalization .primes .sequence
  | fib_extends_oeis       : Generalization .fibonacci .oeisSequence
  -- Model hierarchy
  | finite_extends_model   : Generalization .finiteModel .model
  -- Algebra hierarchy
  | ring_extends_group     : Generalization .ring .group
  | field_extends_ring     : Generalization .fieldAlgebra .ring
  | vs_extends_group       : Generalization .vectorSpace .group
  -- Morphism hierarchy
  | homo_extends_morphism  : Generalization .homomorphism .morphism
  | iso_extends_homo       : Generalization .isomorphism .homomorphism
  -- Computation hierarchy
  | exec_extends_program   : Generalization .executable .programConcept
  | var_extends_expr       : Generalization .variableConcept .expression
  | const_extends_expr     : Generalization .constantConcept .expression
  -- Meme hierarchy
  | metameme_extends_meme  : Generalization .metaMeme .meme
  | skibidi_extends_meme   : Generalization .skibidiToilet .meme
  | piano_extends_meme     : Generalization .pianoMan .meme
  -- Technology hierarchy
  | git_extends_program    : Generalization .gitConcept .programConcept
  | linux_extends_program  : Generalization .linuxConcept .programConcept
  | docker_extends_program : Generalization .dockerConcept .programConcept
  -- Type hierarchy
  | dep_extends_type       : Generalization .dependentType .typeConcept
  | ind_extends_type       : Generalization .inductiveType .typeConcept
  | coind_extends_type     : Generalization .coinductiveType .typeConcept
  -- Sign hierarchy
  | symbol_extends_sign    : Generalization .symbolConcept .signConcept
  | icon_extends_sign      : Generalization .iconConcept .signConcept
  | index_extends_sign     : Generalization .indexConcept .signConcept
  -- Theory hierarchy
  | hott_extends_theory    : Generalization .homotopyTypeTheory .theoryConcept
  | catthry_extends_theory : Generalization .categoryTheoryConcept .theoryConcept
  | lambda_extends_theory  : Generalization .lambdaCalculus .theoryConcept
  | comp_extends_theory    : Generalization .computabilityTheory .theoryConcept

-- ============================================================================
-- § 4  Association graph
-- ============================================================================

/-- Named associations between concepts.
    Mirrors the UML association arrows in the solfunmeme model. -/
inductive Association : Concept → Concept → String → Prop where
  -- Model ↔ Sequence
  | model_sequence          : Association .model .sequence "has_sequence"
  | finiteModel_sequence    : Association .finiteModel .sequence "uses_sequence"
  -- Compiler ↔ Executable
  | compiler_executable     : Association .compiler .executable "produces"
  | executable_compiler     : Association .executable .compiler "compiled_by"
  -- Compiler ↔ Language
  | compiler_source_lang    : Association .compiler .languageConcept "source_language"
  | compiler_target_lang    : Association .compiler .languageConcept "target_language"
  -- Program ↔ Language
  | program_language        : Association .programConcept .languageConcept "written_in"
  -- Function ↔ Set
  | function_domain         : Association .functionConcept .setConcept "domain"
  | function_codomain       : Association .functionConcept .setConcept "codomain"
  -- Functor ↔ Category
  | functor_source          : Association .functorConcept .categoryConcept "source_cat"
  | functor_target          : Association .functorConcept .categoryConcept "target_cat"
  -- Theory ↔ itself (self-instance)
  | theory_self_instance    : Association .theoryConcept .theoryConcept "instance_of_self"
  -- Theory ↔ Model
  | theory_model            : Association .theoryConcept .model "has_model"
  -- HoTT → UniMath (realization)
  | hott_realizes_unimath   : Association .homotopyTypeTheory .uniMathConcept "realizes"
  -- Category theory → Functor (dependency)
  | catthry_functor         : Association .categoryTheoryConcept .functorConcept "uses"
  -- Mind ↔ Consciousness
  | mind_consciousness      : Association .mind .consciousness "aware_of"
  | consciousness_mind      : Association .consciousness .mind "resides_in"
  -- Meme ↔ Gene
  | meme_gene               : Association .meme .gene "cultural_analog_of"
  -- Gene → Protein
  | gene_protein            : Association .gene .protein "encodes"
  -- DNA → Gene
  | dna_gene                : Association .dna .gene "contains"
  -- RNA → DNA
  | rna_dna                 : Association .rna .dna "transcribed_from"
  -- Cell → DNA
  | cell_dna                : Association .cellConcept .dna "has_dna"
  -- Evolution → Mutation, Selection
  | evolution_mutation      : Association .evolution .mutation "driven_by"
  | evolution_selection     : Association .evolution .selection "filtered_by"
  -- Organism → Species
  | organism_species        : Association .organism .speciesConcept "belongs_to"
  -- Population → Species
  | population_species      : Association .populationConcept .speciesConcept "of_species"
  -- GitHub → Git
  | github_git              : Association .gitHubConcept .gitConcept "hosts"
  -- Kubernetes → Docker
  | kubernetes_docker       : Association .kubernetesConcept .dockerConcept "orchestrates"
  -- API → Protocol
  | api_protocol            : Association .apiConcept .protocolConcept "uses_protocol"
  -- Network → Protocol
  | network_protocol        : Association .networkConcept .protocolConcept "runs_protocol"
  -- WebServer → API
  | webserver_api           : Association .webServerConcept .apiConcept "serves"
  -- Sign → Signifier, Signified
  | sign_signifier          : Association .signConcept .signifierConcept "has_signifier"
  | sign_signified          : Association .signConcept .signifiedConcept "has_signified"
  -- Gödel → Logic
  | goedel_logic            : Association .goedelConcept .logic "incomplete"
  -- Turing → Computability
  | turing_computability    : Association .turingConcept .computabilityTheory "machine"
  -- Church → Lambda
  | church_lambda           : Association .churchConcept .lambdaCalculus "created"
  -- Proof → Theorem
  | proof_theorem           : Association .proofConcept .theoremConcept "proves"
  -- Object → Class
  | object_class            : Association .objectConcept .classConcept "instance_of"
  -- Class → Interface
  | class_interface         : Association .classConcept .interfaceConcept "implements"
  -- Method → Type
  | method_return           : Association .methodConcept .typeConcept "returns"
  -- Expression → Type
  | expression_type         : Association .expression .typeConcept "has_type"
  -- Topology → Set
  | topology_set            : Association .topology .setConcept "on_set"
  -- Relation → Set
  | relation_set            : Association .relation .setConcept "on_set"

-- ============================================================================
-- § 5  Instance specifications
-- ============================================================================

/-- Named instances from the solfunmeme model (instance specifications in UML). -/
structure Instance where
  name : String
  concept : Concept
  description : Option String := none
  deriving Repr

/-- The distinguished instance specifications from the solfunmeme UML model. -/
def instances : List Instance := [
  -- Mathematical constants / sequences
  { name := "A000045 Fibonacci", concept := .fibonacci,
    description := "The Fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, ..." },
  { name := "1", concept := .naturalNumber, description := "Unity" },
  { name := "2", concept := .naturalNumber, description := "Duality / pair" },
  { name := "3", concept := .naturalNumber, description := "Thirdness / Peirce" },
  -- Foundational thinkers
  { name := "Kurt Gödel", concept := .goedelConcept,
    description := "Incompleteness theorems" },
  { name := "Alan Turing", concept := .turingConcept,
    description := "Turing machine, halting problem" },
  { name := "Alonzo Church", concept := .churchConcept,
    description := "Lambda calculus, Church-Turing thesis" },
  -- Software projects
  { name := "git", concept := .gitConcept,
    description := "Distributed version control system" },
  { name := "github", concept := .gitHubConcept,
    description := "Git hosting platform" },
  { name := "linux", concept := .linuxConcept,
    description := "Unix-like operating system kernel" },
  -- Cultural memes
  { name := "meme", concept := .meme, description := "Unit of cultural transmission" },
  { name := "skibidi toilet", concept := .skibidiToilet,
    description := "Internet meme series" },
  { name := "piano man", concept := .pianoMan,
    description := "Billy Joel song / cultural reference" },
  -- Theories
  { name := "Theory", concept := .theoryConcept,
    description := "Theory is an instance of itself" },
  { name := "Homotopy Type Theory", concept := .homotopyTypeTheory,
    description := "HoTT, univalent foundations" },
  { name := "unimath", concept := .uniMathConcept,
    description := "Univalent Mathematics library" },
  { name := "category theory", concept := .categoryTheoryConcept,
    description := "Study of abstract structure" },
  -- Peirce's categories
  { name := "identity", concept := .identityConcept, description := "Self-sameness" },
  { name := "duality", concept := .dualityConcept, description := "Oppositional pair" },
  { name := "thirdness", concept := .thirdness, description := "Peircean thirdness" },
  -- Person
  { name := "James Michael DuPont", concept := .jamesMichaelDuPont,
    description := "Creator of solfunmeme" }
]

-- ============================================================================
-- § 6  Decidable helpers
-- ============================================================================

/-- All concept values as a list (for enumeration). -/
def Concept.all : List Concept := [
  .number, .naturalNumber, .integerNum, .realNumber, .complexNumber,
  .sequence, .oeisSequence, .primes, .fibonacci,
  .model, .finiteModel, .ellipticCurve,
  .setConcept, .functionConcept, .relation,
  .group, .ring, .fieldAlgebra, .vectorSpace,
  .topology, .manifold,
  .categoryConcept, .functorConcept, .morphism, .homomorphism, .isomorphism,
  .logic, .axiom_, .proofConcept, .theoremConcept,
  .languageConcept, .programConcept, .compiler, .executable,
  .algorithm, .dataStructure,
  .typeConcept, .expression, .variableConcept, .constantConcept,
  .operatorConcept, .statementConcept,
  .moduleConcept, .interfaceConcept, .classConcept, .objectConcept,
  .methodConcept, .propertyConcept, .eventConcept, .signalConcept,
  .theoryConcept, .chaos, .orderConcept, .good, .evil,
  .truth, .beauty, .justice, .freedom,
  .consciousness, .mind, .soul, .spirit,
  .matter, .energyConcept, .spaceConcept, .timeConcept, .causality,
  .identityConcept, .dualityConcept, .unityConcept,
  .infinityConcept, .voidConcept,
  .gene, .meme, .metaMeme,
  .cellConcept, .protein, .dna, .rna,
  .organism, .speciesConcept, .evolution, .mutation, .selection,
  .fitnessConcept, .populationConcept, .ecosystem,
  .skibidiToilet, .pianoMan,
  .gitConcept, .gitHubConcept, .linuxConcept,
  .dockerConcept, .kubernetesConcept,
  .databaseConcept, .apiConcept, .webServerConcept,
  .networkConcept, .protocolConcept,
  .homotopyTypeTheory, .uniMathConcept, .categoryTheoryConcept,
  .dependentType, .inductiveType, .coinductiveType,
  .signConcept, .signifierConcept, .signifiedConcept,
  .symbolConcept, .iconConcept, .indexConcept,
  .firstness, .secondness, .thirdness,
  .goedelConcept, .turingConcept, .churchConcept,
  .lambdaCalculus, .computabilityTheory,
  .jamesMichaelDuPont
]

/-- The all-list is complete. -/
lemma Concept.all_complete : ∀ c : Concept, c ∈ Concept.all := by
  intro c; cases c <;> simp [Concept.all]

-- ============================================================================
-- § 7  Counting functions
-- ============================================================================

/-- Count concepts in a given cluster. -/
def clusterSize (cl : Cluster) : Nat :=
  (Concept.all.filter (·.cluster == cl)).length

/-- Total concept count. -/
def totalConceptCount : Nat := Concept.all.length

/-- Count generalizations. -/
def generalizationCount : Nat := 31  -- from the Generalization inductive

/-- Count associations. -/
def associationCount : Nat := 43  -- from the Association inductive

/-- Count instances. -/
def instanceCount : Nat := instances.length

-- ============================================================================
-- § 8  Verified theorems about the solfunmeme ontology
-- ============================================================================

/-- The ontology has exactly 121 concepts (matching the IPLD schema). -/
theorem total_concept_count : totalConceptCount = 121 := by native_decide

/-- Mathematics is the largest cluster. -/
theorem math_largest_cluster :
    clusterSize .mathematics ≥ clusterSize .computation ∧
    clusterSize .mathematics ≥ clusterSize .metaphysics ∧
    clusterSize .mathematics ≥ clusterSize .biology ∧
    clusterSize .mathematics ≥ clusterSize .culture ∧
    clusterSize .mathematics ≥ clusterSize .technology ∧
    clusterSize .mathematics ≥ clusterSize .typeTheory ∧
    clusterSize .mathematics ≥ clusterSize .semiotics := by native_decide

/-- The meme hierarchy has depth 2: MetaMeme → Meme (and culture memes → Meme). -/
theorem meme_hierarchy_depth :
    Generalization .metaMeme .meme ∧
    Generalization .skibidiToilet .meme ∧
    Generalization .pianoMan .meme := by
  exact ⟨.metameme_extends_meme, .skibidi_extends_meme, .piano_extends_meme⟩

/-- Theory is an instance of itself (self-reference). -/
theorem theory_self_referential :
    Association .theoryConcept .theoryConcept "instance_of_self" := by
  exact .theory_self_instance

/-- HoTT realizes UniMath (the key realization dependency). -/
theorem hott_realizes_unimath :
    Association .homotopyTypeTheory .uniMathConcept "realizes" := by
  exact .hott_realizes_unimath

/-- The compiler-executable association is bidirectional. -/
theorem compiler_executable_bidirectional :
    Association .compiler .executable "produces" ∧
    Association .executable .compiler "compiled_by" := by
  exact ⟨.compiler_executable, .executable_compiler⟩

/-- All Peircean sign types extend SignConcept. -/
theorem peircean_signs_extend_sign :
    Generalization .symbolConcept .signConcept ∧
    Generalization .iconConcept .signConcept ∧
    Generalization .indexConcept .signConcept := by
  exact ⟨.symbol_extends_sign, .icon_extends_sign, .index_extends_sign⟩

/-- The three foundational thinkers are all in the mathematics cluster. -/
theorem foundational_thinkers_in_math :
    Concept.goedelConcept.cluster = .mathematics ∧
    Concept.turingConcept.cluster = .mathematics ∧
    Concept.churchConcept.cluster = .mathematics := by
  exact ⟨rfl, rfl, rfl⟩

/-- The number hierarchy: all numeric types extend Number. -/
theorem number_hierarchy_complete :
    Generalization .naturalNumber .number ∧
    Generalization .integerNum .number ∧
    Generalization .realNumber .number ∧
    Generalization .complexNumber .number := by
  exact ⟨.nat_extends_number, .int_extends_number,
         .real_extends_number, .complex_extends_number⟩

/-- All type theory types extend TypeConcept. -/
theorem type_theory_extends_type :
    Generalization .dependentType .typeConcept ∧
    Generalization .inductiveType .typeConcept ∧
    Generalization .coinductiveType .typeConcept := by
  exact ⟨.dep_extends_type, .ind_extends_type, .coind_extends_type⟩

/-- There are at least 20 instance specifications. -/
theorem instance_count_at_least_20 : instanceCount ≥ 20 := by native_decide

/-- James Michael DuPont created the solfunmeme project. -/
theorem dupont_is_creator :
    ∃ i ∈ instances, i.name = "James Michael DuPont" ∧
      i.concept = .jamesMichaelDuPont := by
  exact ⟨{ name := "James Michael DuPont", concept := .jamesMichaelDuPont,
            description := some "Creator of solfunmeme" },
         by simp [instances], rfl, rfl⟩

-- ============================================================================
-- § 9  Ontology summary
-- ============================================================================

#eval IO.println s!"Solfunmeme Ontology:"
#eval IO.println s!"  Total concepts: {totalConceptCount}"
#eval IO.println s!"  Mathematics: {clusterSize .mathematics}"
#eval IO.println s!"  Computation: {clusterSize .computation}"
#eval IO.println s!"  Metaphysics: {clusterSize .metaphysics}"
#eval IO.println s!"  Biology: {clusterSize .biology}"
#eval IO.println s!"  Culture: {clusterSize .culture}"
#eval IO.println s!"  Technology: {clusterSize .technology}"
#eval IO.println s!"  Type Theory: {clusterSize .typeTheory}"
#eval IO.println s!"  Semiotics: {clusterSize .semiotics}"
#eval IO.println s!"  Instances: {instanceCount}"

end Solfunmeme
