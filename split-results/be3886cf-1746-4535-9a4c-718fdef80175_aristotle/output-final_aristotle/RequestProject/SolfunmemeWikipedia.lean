/-
# Wikipedia Knowledge Graph Extension

Extends the solfunmeme ontology with concepts extracted from Wikipedia articles on:
- **Skibidi Toilet** — YouTube web series, Generation Alpha culture
- **Internet meme** — viral content, image macros, meme stocks
- **Meme** (Dawkins) — memetics, cultural evolution, replicators
- **Protein** — amino acids, enzymes, protein folding, structures
- **Biosemiotics** — zoosemiotics, phytosemiotics, umwelt
- **Semiotics** — semiosis, codes, tropes, structuralism

## Architecture
Rather than modifying the existing 121-concept `Concept` type (which would break
all downstream modules), we define:
1. `WikiConcept` — 54 new concepts from Wikipedia
2. `ExtConcept` — disjoint union of `Concept` and `WikiConcept`
3. Extended adjacency, reachability, and verified theorems

## Sources
All concepts derived from English Wikipedia articles accessed June 2025.
-/

import Mathlib
import RequestProject.SolfunmemeOntology

namespace Solfunmeme.Wikipedia

open Solfunmeme

-- ============================================================================
-- § 1  New concepts extracted from Wikipedia articles
-- ============================================================================

/-- Extended cluster taxonomy adding two new clusters. -/
inductive ExtCluster where
  | orig : Cluster → ExtCluster       -- original 8 clusters
  | media                              -- media & communication
  | biochemistry                       -- molecular biology detail
  deriving DecidableEq, Repr, Inhabited

/-- New concepts extracted from Wikipedia articles, organized by source. -/
inductive WikiConcept where
  -- ── From "Semiotics" article (19 concepts) ────────────────────────────
  | semiosis              -- the sign process / action of signs
  | semanticsConcept      -- branch: sign–meaning relations
  | syntacticsConcept     -- branch: formal relations between signs
  | pragmaticsConcept     -- branch: sign–user relations
  | codeConcept           -- semiotic code (system for encoding meaning)
  | textConcept           -- composed sign / message
  | paradigmaticRelation  -- substitution axis
  | syntagmaticRelation   -- combination axis
  | trope                 -- figurative shift (metaphor, metonymy, etc.)
  | metaphor              -- analogy-based trope
  | metonymy              -- contiguity-based trope
  | irony                 -- dissimilarity-based trope
  | denotation            -- literal / referential meaning
  | connotation           -- associative / secondary meaning
  | structuralism         -- meaning from structural relations
  | postStructuralism     -- deconstruction, unlimited semiosis
  | narratology           -- study of narrative codes
  | hermeneutics          -- theory of interpretation
  | semioticTriangle      -- Ogden–Richards model: symbol–thought–referent
  -- ── From "Biosemiotics" article (5 concepts) ─────────────────────────
  | biosemiotics          -- sign processes in the living realm
  | zoosemiotics          -- animal semiosis
  | phytosemiotics        -- plant semiosis
  | umwelt                -- species-specific perceptual world (Uexküll)
  | neurosemiotics        -- neural sign interpretation
  -- ── From "Meme" (Dawkins) article (4 concepts) ───────────────────────
  | memetics              -- study of memes and cultural evolution
  | memeplex              -- co-adapted meme complex
  | culturalEvolution     -- evolution of culture analogous to biology
  | replicator            -- self-replicating unit of transmission
  -- ── From "Internet meme" article (8 concepts) ────────────────────────
  | internetMeme          -- meme spread via internet/social media
  | imageMacro            -- image overlaid with text
  | viralContent          -- rapidly spreading digital content
  | memeStock             -- stock driven by social media buzz
  | brainRot              -- low-quality oversaturated content
  | socialMedia           -- platforms for user-generated content
  | dankMeme              -- deliberately odd/zany meme genre
  | fairUseConcept        -- copyright defense for transformative works
  -- ── From "Protein" article (11 concepts) ─────────────────────────────
  | aminoAcid             -- building block of proteins
  | peptideBond           -- covalent bond linking amino acids
  | polypeptide           -- linear chain of amino acid residues
  | enzymeConcept         -- protein catalyst
  | proteinFolding        -- process of assuming 3D structure
  | primaryStructure      -- amino acid sequence
  | secondaryStructure    -- local folding (α-helix, β-sheet)
  | tertiaryStructure     -- overall 3D shape
  | quaternaryStructure   -- multi-subunit assembly
  | proteome              -- complete set of proteins in a cell
  | activeSite            -- enzyme's catalytic region
  -- ── From "Skibidi Toilet" article (7 concepts) ───────────────────────
  | generationAlpha       -- cohort born since early 2010s
  | sourceFilmmaker       -- Valve's animation tool
  | machinima             -- filmmaking using game engines
  | alexeyGerasimov       -- creator of Skibidi Toilet
  | invisibleNarratives   -- licensing/production company
  | webSeries             -- episodic content released online
  | youTubeConcept        -- video-sharing platform
  deriving DecidableEq, Repr, Inhabited

-- ============================================================================
-- § 2  Extended concept type (disjoint union)
-- ============================================================================

/-- Extended concept: either an original solfunmeme concept or a new Wikipedia concept. -/
inductive ExtConcept where
  | orig : Concept → ExtConcept
  | wiki : WikiConcept → ExtConcept
  deriving DecidableEq, Repr, Inhabited

-- ============================================================================
-- § 3  Cluster assignment for new concepts
-- ============================================================================

/-- Cluster assignment for WikiConcepts. -/
def WikiConcept.cluster : WikiConcept → ExtCluster
  -- Semiotics article → semiotics cluster
  | .semiosis | .semanticsConcept | .syntacticsConcept | .pragmaticsConcept
  | .codeConcept | .textConcept
  | .paradigmaticRelation | .syntagmaticRelation
  | .trope | .metaphor | .metonymy | .irony
  | .denotation | .connotation
  | .structuralism | .postStructuralism
  | .narratology | .hermeneutics
  | .semioticTriangle
    => .orig .semiotics
  -- Biosemiotics → biology cluster
  | .biosemiotics | .zoosemiotics | .phytosemiotics
  | .umwelt | .neurosemiotics
    => .orig .biology
  -- Memetics → biology (cultural evolution)
  | .memetics | .memeplex | .culturalEvolution | .replicator
    => .orig .biology
  -- Internet memes → media cluster
  | .internetMeme | .imageMacro | .viralContent
  | .memeStock | .brainRot | .socialMedia | .dankMeme | .fairUseConcept
    => .media
  -- Protein detail → biochemistry cluster
  | .aminoAcid | .peptideBond | .polypeptide
  | .enzymeConcept | .proteinFolding
  | .primaryStructure | .secondaryStructure
  | .tertiaryStructure | .quaternaryStructure
  | .proteome | .activeSite
    => .biochemistry
  -- Skibidi Toilet article
  | .generationAlpha | .webSeries | .youTubeConcept => .media
  | .sourceFilmmaker | .machinima => .orig .technology
  | .alexeyGerasimov => .orig .culture
  | .invisibleNarratives => .orig .culture

/-- Cluster assignment for extended concepts. -/
def ExtConcept.cluster : ExtConcept → ExtCluster
  | .orig c => .orig c.cluster
  | .wiki w => w.cluster

-- ============================================================================
-- § 4  Adjacency — edges between and within old and new concepts
-- ============================================================================

/-- Directed adjacency for the extended graph.
    Includes edges among WikiConcepts, and cross-edges to original Concepts. -/
def extAdjacent : ExtConcept → ExtConcept → Bool
  -- ══════════════════════════════════════════════════════════════════════
  -- Cross-edges: WikiConcept → original Concept (bridges)
  -- ══════════════════════════════════════════════════════════════════════
  -- Semiotics bridges
  | .wiki .semiosis, .orig .signConcept => true         -- semiosis is the action of signs
  | .wiki .semiosis, .orig .consciousness => true       -- semiosis requires interpretation
  | .wiki .semanticsConcept, .orig .signConcept => true -- semantics studies sign meaning
  | .wiki .syntacticsConcept, .orig .signConcept => true
  | .wiki .pragmaticsConcept, .orig .signConcept => true
  | .wiki .codeConcept, .orig .signConcept => true      -- codes are sign systems
  | .wiki .semioticTriangle, .orig .signConcept => true
  | .wiki .semioticTriangle, .orig .signifierConcept => true
  | .wiki .semioticTriangle, .orig .signifiedConcept => true
  | .wiki .structuralism, .orig .signConcept => true
  | .wiki .postStructuralism, .wiki .structuralism => true  -- builds on structuralism
  | .wiki .narratology, .wiki .textConcept => true
  | .wiki .hermeneutics, .wiki .textConcept => true
  -- Biosemiotics bridges
  | .wiki .biosemiotics, .orig .signConcept => true     -- biosemiotics = biology + semiotics
  | .wiki .biosemiotics, .orig .organism => true
  | .wiki .biosemiotics, .orig .gene => true            -- genetic code as sign system
  | .wiki .zoosemiotics, .wiki .biosemiotics => true
  | .wiki .phytosemiotics, .wiki .biosemiotics => true
  | .wiki .neurosemiotics, .wiki .biosemiotics => true
  | .wiki .neurosemiotics, .orig .mind => true          -- neural sign interpretation
  | .wiki .umwelt, .orig .organism => true              -- species-specific world
  | .wiki .umwelt, .orig .signConcept => true
  -- Memetics bridges
  | .wiki .memetics, .orig .meme => true                -- study of memes
  | .wiki .memetics, .orig .evolution => true           -- cultural evolution
  | .wiki .memeplex, .orig .meme => true                -- complex of co-adapted memes
  | .wiki .culturalEvolution, .orig .evolution => true
  | .wiki .culturalEvolution, .orig .meme => true
  | .wiki .replicator, .orig .gene => true              -- gene as biological replicator
  | .wiki .replicator, .orig .meme => true              -- meme as cultural replicator
  -- Internet meme bridges
  | .wiki .internetMeme, .orig .meme => true            -- internet meme extends meme
  | .wiki .internetMeme, .wiki .socialMedia => true     -- spread via social media
  | .wiki .internetMeme, .wiki .viralContent => true
  | .wiki .imageMacro, .wiki .internetMeme => true      -- type of internet meme
  | .wiki .dankMeme, .wiki .internetMeme => true        -- genre of internet meme
  | .wiki .brainRot, .wiki .internetMeme => true        -- low-quality meme content
  | .wiki .internetMeme, .wiki .brainRot => true         -- internet memes can be brain rot
  | .wiki .memeStock, .wiki .internetMeme => true       -- meme-driven stocks
  | .wiki .fairUseConcept, .wiki .internetMeme => true  -- copyright issue for memes
  | .wiki .viralContent, .wiki .socialMedia => true
  | .wiki .socialMedia, .orig .networkConcept => true   -- social media is networked
  -- Protein bridges
  | .wiki .aminoAcid, .orig .protein => true            -- proteins are chains of amino acids
  | .wiki .peptideBond, .wiki .aminoAcid => true        -- bonds link amino acids
  | .wiki .polypeptide, .wiki .aminoAcid => true        -- polypeptide = chain of amino acids
  | .wiki .polypeptide, .orig .protein => true           -- proteins contain polypeptides
  | .wiki .enzymeConcept, .orig .protein => true         -- enzymes are proteins
  | .wiki .proteinFolding, .orig .protein => true
  | .wiki .proteinFolding, .wiki .tertiaryStructure => true
  | .wiki .primaryStructure, .orig .protein => true
  | .wiki .secondaryStructure, .orig .protein => true
  | .wiki .tertiaryStructure, .orig .protein => true
  | .wiki .quaternaryStructure, .orig .protein => true
  | .wiki .proteome, .orig .cellConcept => true         -- proteome of a cell
  | .wiki .proteome, .orig .protein => true
  | .wiki .activeSite, .wiki .enzymeConcept => true
  | .wiki .enzymeConcept, .wiki .activeSite => true      -- enzymes have active sites
  | .orig .protein, .wiki .enzymeConcept => true          -- some proteins are enzymes
  | .wiki .primaryStructure, .wiki .secondaryStructure => true
  | .wiki .secondaryStructure, .wiki .tertiaryStructure => true
  | .wiki .tertiaryStructure, .wiki .quaternaryStructure => true
  -- Skibidi Toilet bridges
  | .wiki .alexeyGerasimov, .orig .skibidiToilet => true  -- creator
  | .wiki .sourceFilmmaker, .orig .skibidiToilet => true  -- production tool
  | .wiki .machinima, .wiki .sourceFilmmaker => true
  | .wiki .webSeries, .orig .skibidiToilet => true
  | .wiki .youTubeConcept, .wiki .webSeries => true
  | .wiki .youTubeConcept, .wiki .socialMedia => true
  | .wiki .generationAlpha, .orig .skibidiToilet => true  -- primary audience
  | .wiki .generationAlpha, .wiki .brainRot => true       -- associated with brainrot
  | .wiki .invisibleNarratives, .orig .skibidiToilet => true -- licensing company
  | .orig .skibidiToilet, .wiki .internetMeme => true     -- skibidi is an internet meme
  | .orig .skibidiToilet, .wiki .machinima => true        -- skibidi is machinima
  -- Semiosis internal edges
  | .wiki .trope, .wiki .metaphor => true
  | .wiki .trope, .wiki .metonymy => true
  | .wiki .trope, .wiki .irony => true
  | .wiki .denotation, .orig .signConcept => true
  | .wiki .connotation, .orig .signConcept => true
  | .wiki .textConcept, .wiki .codeConcept => true       -- texts use codes
  | .wiki .paradigmaticRelation, .wiki .codeConcept => true
  | .wiki .syntagmaticRelation, .wiki .codeConcept => true
  -- ══════════════════════════════════════════════════════════════════════
  -- Original edges (key paths from solfunmeme graph)
  -- ══════════════════════════════════════════════════════════════════════
  | .orig .skibidiToilet, .orig .meme => true
  | .orig .meme, .orig .gene => true                    -- from enriched: culture→biology
  | .orig .gene, .orig .protein => true
  | .orig .gene, .orig .dna => true
  | .orig .dna, .orig .rna => true
  | .orig .signConcept, .orig .signifierConcept => true
  | .orig .signConcept, .orig .signifiedConcept => true
  | .orig .symbolConcept, .orig .signConcept => true
  | .orig .iconConcept, .orig .signConcept => true
  | .orig .indexConcept, .orig .signConcept => true
  | .orig .signConcept, .orig .consciousness => true    -- from enriched
  | .orig .consciousness, .orig .mind => true
  | .orig .mind, .orig .consciousness => true
  | .orig .organism, .orig .cellConcept => true
  | .orig .cellConcept, .orig .dna => true
  | .orig .compiler, .orig .executable => true
  | .orig .executable, .orig .compiler => true
  | .orig .theoryConcept, .orig .theoryConcept => true
  | .orig .homotopyTypeTheory, .orig .theoryConcept => true
  | .orig .evolution, .orig .mutation => true
  | .orig .evolution, .orig .selection => true
  | .orig .meme, .orig .evolution => true               -- memes evolve
  | _, _ => false

-- ============================================================================
-- § 5  Enumeration and counting
-- ============================================================================

/-- All WikiConcepts as a list. -/
def WikiConcept.all : List WikiConcept :=
  [-- Semiotics (19)
   .semiosis, .semanticsConcept, .syntacticsConcept, .pragmaticsConcept,
   .codeConcept, .textConcept, .paradigmaticRelation, .syntagmaticRelation,
   .trope, .metaphor, .metonymy, .irony,
   .denotation, .connotation,
   .structuralism, .postStructuralism,
   .narratology, .hermeneutics, .semioticTriangle,
   -- Biosemiotics (5)
   .biosemiotics, .zoosemiotics, .phytosemiotics, .umwelt, .neurosemiotics,
   -- Memetics (4)
   .memetics, .memeplex, .culturalEvolution, .replicator,
   -- Internet meme (8)
   .internetMeme, .imageMacro, .viralContent, .memeStock,
   .brainRot, .socialMedia, .dankMeme, .fairUseConcept,
   -- Protein (11)
   .aminoAcid, .peptideBond, .polypeptide,
   .enzymeConcept, .proteinFolding,
   .primaryStructure, .secondaryStructure, .tertiaryStructure, .quaternaryStructure,
   .proteome, .activeSite,
   -- Skibidi Toilet (7)
   .generationAlpha, .sourceFilmmaker, .machinima,
   .alexeyGerasimov, .invisibleNarratives, .webSeries, .youTubeConcept]

/-- Total number of new concepts. -/
def wikiConceptCount : Nat := WikiConcept.all.length

/-- All original concepts enumerated. -/
private def origAll : List Concept :=
  [.number, .naturalNumber, .integerNum, .realNumber, .complexNumber,
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
   .jamesMichaelDuPont]

/-- All extended concepts. -/
def ExtConcept.all : List ExtConcept :=
  (origAll.map .orig) ++ (WikiConcept.all.map .wiki)

/-- Total extended concept count. -/
def extConceptCount : Nat := ExtConcept.all.length

-- ============================================================================
-- § 6  BFS Reachability on the extended graph
-- ============================================================================

/-- BFS reachability using a simple list-based visited set.
    Returns true if `dst` is reachable from `src` via `extAdjacent`. -/
def extReaches (src dst : ExtConcept) : Bool :=
  go [src] [] 300
where
  go (queue : List ExtConcept) (visited : List ExtConcept) (fuel : Nat) : Bool :=
    match fuel, queue with
    | 0, _ => false
    | _, [] => false
    | fuel + 1, x :: rest =>
      if x == dst then true
      else if visited.contains x then go rest visited fuel
      else
        let neighbors := ExtConcept.all.filter (extAdjacent x ·)
        let newQueue := rest ++ neighbors.filter (fun n => !visited.contains n)
        go newQueue (x :: visited) fuel

-- ============================================================================
-- § 7  Canonical names and descriptions
-- ============================================================================

/-- Canonical name for each WikiConcept (matching Wikipedia article terminology). -/
def WikiConcept.canonicalName : WikiConcept → String
  | .semiosis => "Semiosis"
  | .semanticsConcept => "Semantics"
  | .syntacticsConcept => "Syntactics"
  | .pragmaticsConcept => "Pragmatics"
  | .codeConcept => "Code (semiotics)"
  | .textConcept => "Text (semiotics)"
  | .paradigmaticRelation => "Paradigmatic relation"
  | .syntagmaticRelation => "Syntagmatic relation"
  | .trope => "Trope"
  | .metaphor => "Metaphor"
  | .metonymy => "Metonymy"
  | .irony => "Irony"
  | .denotation => "Denotation"
  | .connotation => "Connotation"
  | .structuralism => "Structuralism"
  | .postStructuralism => "Post-structuralism"
  | .narratology => "Narratology"
  | .hermeneutics => "Hermeneutics"
  | .semioticTriangle => "Semiotic triangle"
  | .biosemiotics => "Biosemiotics"
  | .zoosemiotics => "Zoosemiotics"
  | .phytosemiotics => "Phytosemiotics"
  | .umwelt => "Umwelt"
  | .neurosemiotics => "Neurosemiotics"
  | .memetics => "Memetics"
  | .memeplex => "Memeplex"
  | .culturalEvolution => "Cultural evolution"
  | .replicator => "Replicator"
  | .internetMeme => "Internet meme"
  | .imageMacro => "Image macro"
  | .viralContent => "Viral content"
  | .memeStock => "Meme stock"
  | .brainRot => "Brain rot"
  | .socialMedia => "Social media"
  | .dankMeme => "Dank meme"
  | .fairUseConcept => "Fair use"
  | .aminoAcid => "Amino acid"
  | .peptideBond => "Peptide bond"
  | .polypeptide => "Polypeptide"
  | .enzymeConcept => "Enzyme"
  | .proteinFolding => "Protein folding"
  | .primaryStructure => "Primary structure"
  | .secondaryStructure => "Secondary structure"
  | .tertiaryStructure => "Tertiary structure"
  | .quaternaryStructure => "Quaternary structure"
  | .proteome => "Proteome"
  | .activeSite => "Active site"
  | .generationAlpha => "Generation Alpha"
  | .sourceFilmmaker => "Source Filmmaker"
  | .machinima => "Machinima"
  | .alexeyGerasimov => "Alexey Gerasimov"
  | .invisibleNarratives => "Invisible Narratives"
  | .webSeries => "Web series"
  | .youTubeConcept => "YouTube"

/-- Wikipedia source article for each concept. -/
def WikiConcept.sourceArticle : WikiConcept → String
  | .semiosis | .semanticsConcept | .syntacticsConcept | .pragmaticsConcept
  | .codeConcept | .textConcept | .paradigmaticRelation | .syntagmaticRelation
  | .trope | .metaphor | .metonymy | .irony | .denotation | .connotation
  | .structuralism | .postStructuralism | .narratology | .hermeneutics
  | .semioticTriangle => "Semiotics"
  | .biosemiotics | .zoosemiotics | .phytosemiotics | .umwelt
  | .neurosemiotics => "Biosemiotics"
  | .memetics | .memeplex | .culturalEvolution | .replicator => "Meme"
  | .internetMeme | .imageMacro | .viralContent | .memeStock
  | .brainRot | .socialMedia | .dankMeme | .fairUseConcept => "Internet meme"
  | .aminoAcid | .peptideBond | .polypeptide | .enzymeConcept | .proteinFolding
  | .primaryStructure | .secondaryStructure | .tertiaryStructure
  | .quaternaryStructure | .proteome | .activeSite => "Protein"
  | .generationAlpha | .sourceFilmmaker | .machinima | .alexeyGerasimov
  | .invisibleNarratives | .webSeries | .youTubeConcept => "Skibidi Toilet"

-- ============================================================================
-- § 8  Edge counting and statistics
-- ============================================================================

/-- Count directed edges in the extended graph. -/
def extEdgeCount : Nat :=
  ExtConcept.all.foldl (fun acc src =>
    acc + (ExtConcept.all.filter (extAdjacent src ·)).length) 0

-- ============================================================================
-- § 9  Verified theorems
-- ============================================================================

/-- There are exactly 54 new Wikipedia concepts. -/
theorem wiki_concept_count : wikiConceptCount = 54 := by native_decide

/-- The extended ontology has 175 concepts total (121 + 54). -/
theorem ext_concept_count : extConceptCount = 175 := by native_decide

-- ── Cross-domain reachability paths ────────────────────────────────────

/-- Skibidi Toilet reaches the Protein concept through the extended graph.
    Path: skibidiToilet → meme → gene → protein -/
theorem skibidi_reaches_protein_ext :
    extReaches (.orig .skibidiToilet) (.orig .protein) = true := by native_decide

/-- Skibidi Toilet reaches Internet Meme (it IS one). -/
theorem skibidi_is_internet_meme :
    extReaches (.orig .skibidiToilet) (.wiki .internetMeme) = true := by native_decide

/-- Skibidi Toilet reaches Brain Rot. -/
theorem skibidi_reaches_brainrot :
    extReaches (.orig .skibidiToilet) (.wiki .brainRot) = true := by native_decide

/-- Biosemiotics bridges semiotics and biology:
    biosemiotics reaches both signConcept and organism. -/
theorem biosemiotics_bridges :
    extReaches (.wiki .biosemiotics) (.orig .signConcept) = true ∧
    extReaches (.wiki .biosemiotics) (.orig .organism) = true := by
  constructor <;> native_decide

/-- Memetics reaches both evolution and meme. -/
theorem memetics_bridges :
    extReaches (.wiki .memetics) (.orig .evolution) = true ∧
    extReaches (.wiki .memetics) (.orig .meme) = true := by
  constructor <;> native_decide

/-- The semiotic triangle reaches all three vertices:
    sign, signifier, and signified. -/
theorem semiotic_triangle_complete :
    extReaches (.wiki .semioticTriangle) (.orig .signConcept) = true ∧
    extReaches (.wiki .semioticTriangle) (.orig .signifierConcept) = true ∧
    extReaches (.wiki .semioticTriangle) (.orig .signifiedConcept) = true := by
  refine ⟨?_, ?_, ?_⟩ <;> native_decide

/-- Protein folding reaches quaternary structure through the structure hierarchy. -/
theorem folding_reaches_quaternary :
    extReaches (.wiki .proteinFolding) (.wiki .quaternaryStructure) = true := by
  native_decide

/-- Amino acids reach protein (they compose it). -/
theorem amino_acid_reaches_protein :
    extReaches (.wiki .aminoAcid) (.orig .protein) = true := by native_decide

/-- The proteome reaches DNA (proteome → cell → dna). -/
theorem proteome_reaches_dna :
    extReaches (.wiki .proteome) (.orig .dna) = true := by native_decide

/-- YouTube reaches social media. -/
theorem youtube_is_social_media :
    extReaches (.wiki .youTubeConcept) (.wiki .socialMedia) = true := by native_decide

/-- Alexey Gerasimov reaches Skibidi Toilet (he created it). -/
theorem gerasimov_created_skibidi :
    extReaches (.wiki .alexeyGerasimov) (.orig .skibidiToilet) = true := by native_decide

/-- Machinima reaches Source Filmmaker. -/
theorem machinima_uses_sfm :
    extReaches (.wiki .machinima) (.wiki .sourceFilmmaker) = true := by native_decide

-- ── The grand cross-domain path ────────────────────────────────────────

/-- The "grand path": from Alexey Gerasimov (person) through Skibidi Toilet (culture)
    through meme (biology) through gene through protein (biochemistry)
    all the way to active site (enzyme catalysis).
    This path spans 5 conceptual domains:
    Person → Culture → Biology → Biochemistry → Molecular Biology -/
theorem grand_cross_domain_path :
    extReaches (.wiki .alexeyGerasimov) (.wiki .activeSite) = true := by native_decide

/-- From semiosis (pure semiotics) to consciousness (metaphysics). -/
theorem semiosis_reaches_consciousness :
    extReaches (.wiki .semiosis) (.orig .consciousness) = true := by native_decide

/-- Post-structuralism reaches structuralism (it builds on it). -/
theorem post_reaches_structuralism :
    extReaches (.wiki .postStructuralism) (.wiki .structuralism) = true := by native_decide

-- ── Cluster connectivity ───────────────────────────────────────────────

/-- Internet meme reaches the biology cluster through the meme→gene bridge. -/
theorem internet_meme_reaches_biology :
    extReaches (.wiki .internetMeme) (.orig .gene) = true := by native_decide

/-- Generation Alpha reaches protein (via skibidi → meme → gene → protein). -/
theorem gen_alpha_reaches_protein :
    extReaches (.wiki .generationAlpha) (.orig .protein) = true := by native_decide

/-- Zoosemiotics reaches consciousness (via biosemiotics → sign → consciousness). -/
theorem zoosemiotics_reaches_consciousness :
    extReaches (.wiki .zoosemiotics) (.orig .consciousness) = true := by native_decide

-- ============================================================================
-- § 10  Summary output
-- ============================================================================

#eval IO.println s!"Wikipedia Knowledge Graph Extension:"
#eval IO.println s!"  New concepts: {wikiConceptCount}"
#eval IO.println s!"  Total concepts: {extConceptCount}"
#eval IO.println s!"  Extended edge count: {extEdgeCount}"

#eval do
  let crossDomainPaths := [
    ("Gerasimov → Active site", extReaches (.wiki .alexeyGerasimov) (.wiki .activeSite)),
    ("Skibidi → Protein", extReaches (.orig .skibidiToilet) (.orig .protein)),
    ("Skibidi → Brain rot", extReaches (.orig .skibidiToilet) (.wiki .brainRot)),
    ("Biosemiotics → Sign", extReaches (.wiki .biosemiotics) (.orig .signConcept)),
    ("Biosemiotics → Organism", extReaches (.wiki .biosemiotics) (.orig .organism)),
    ("Semiosis → Consciousness", extReaches (.wiki .semiosis) (.orig .consciousness)),
    ("GenAlpha → Protein", extReaches (.wiki .generationAlpha) (.orig .protein)),
    ("Zoosemiotics → Consciousness", extReaches (.wiki .zoosemiotics) (.orig .consciousness)),
    ("Internet meme → Gene", extReaches (.wiki .internetMeme) (.orig .gene)),
    ("Proteome → DNA", extReaches (.wiki .proteome) (.orig .dna))
  ]
  IO.println s!"\nCross-domain reachability:"
  for (name, result) in crossDomainPaths do
    IO.println s!"  {name}: {if result then "✓" else "·"}"

end Solfunmeme.Wikipedia
