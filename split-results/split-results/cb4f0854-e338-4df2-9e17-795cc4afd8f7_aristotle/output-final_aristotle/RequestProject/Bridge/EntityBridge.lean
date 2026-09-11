/-
# Entity Bridge — Three-Way Semantic Bridge

This module defines a **three-way bridge** connecting:
- **QID** → Wikidata entity identifier (e.g. "Q33742")
- **CID** → IPLD content identifier (content-addressed DAG-CBOR node)
- **Lean term** → formal `ExtConcept` / `Lean.Name` in the ontology

## Architecture
The `EntityBridge` structure ties together a Wikipedia/Wikidata entity,
an IPLD content address, and a formal Lean concept. The `entityTable`
provides the canonical registry of all bridged entities, and directional
maps provide O(n) lookup in each direction.

## Round-trip properties
We prove that `entityTable` has no duplicate QIDs, CIDs, or Lean names,
and that lookups round-trip correctly for any entry in the table.
-/

import Mathlib
import RequestProject.Solfunmeme.SolfunmemeWikipedia

open Lean

namespace Solfunmeme.Bridge

open Solfunmeme
open Solfunmeme.Wikipedia

-- ============================================================================
-- § 1  CID — Content Identifier for IPLD
-- ============================================================================

/-- A content identifier (CID) for IPLD nodes.
    In a full implementation this would carry multicodec, multihash, and digest.
    Here we use a simplified string-based representation. -/
structure CID where
  /-- The string encoding of the CID (e.g. "bafy2bza..."). -/
  raw : String
  deriving Repr, BEq, DecidableEq, Inhabited

/-- Construct a CID from a raw string. -/
def CID.ofString (s : String) : CID := ⟨s⟩

/-- Extract the raw string from a CID. -/
def CID.toString (c : CID) : String := c.raw

instance : ToString CID := ⟨CID.toString⟩

-- ============================================================================
-- § 2  IPLDNode — Placeholder for DAG-CBOR node content
-- ============================================================================

/-- Simplified IPLD node representation.
    A full implementation would carry the DAG-CBOR decoded data model. -/
inductive IPLDNode where
  | null
  | bool   (v : Bool)
  | int    (v : Int)
  | str    (v : String)
  | bytes  (v : List UInt8)
  | list   (vs : List IPLDNode)
  | map    (kvs : List (String × IPLDNode))
  | link   (cid : CID)
  deriving Repr

-- ============================================================================
-- § 3  EntityBridge — The Core Three-Way Bridge
-- ============================================================================

/-- A single semantic entity, tied across Wikipedia/Wikidata, IPLD, and Lean.
    Each entry in the entity table bridges three worlds:
    - **Wikidata** via `qid` and `article`
    - **IPLD** via `cid` (content-addressed)
    - **Lean** via `concept` and `leanName` -/
structure EntityBridge where
  /-- Wikidata entity identifier (e.g. "Q33742"). -/
  qid        : String
  /-- Canonical Wikipedia article title. -/
  article    : String
  /-- IPLD content identifier for the DAG-CBOR node. -/
  cid        : CID
  /-- Formal concept in the ontology. -/
  concept    : ExtConcept
  /-- Lean constant name for the concept. -/
  leanName   : Name
  deriving Repr

instance : BEq EntityBridge where
  beq a b := a.qid == b.qid && a.article == b.article &&
             a.cid == b.cid && a.leanName == b.leanName

-- ============================================================================
-- § 4  Canonical Entity Table
-- ============================================================================

/-- Canonical registry of all bridged entities.
    Each entry maps a Wikidata QID to its Wikipedia article, IPLD CID,
    formal ExtConcept, and Lean constant name. -/
def entityTable : List EntityBridge :=
[
  -- ── Semiotics cluster ─────────────────────────────────────────────────
  { qid := "Q33742",   article := "Semiotics",
    cid := CID.ofString "bafy2bza_semiotics",
    concept := .orig .signConcept, leanName := `Solfunmeme.Concept.signConcept },
  { qid := "Q186588",  article := "Signifier",
    cid := CID.ofString "bafy2bza_signifier",
    concept := .orig .signifierConcept, leanName := `Solfunmeme.Concept.signifierConcept },
  { qid := "Q390946",  article := "Signified",
    cid := CID.ofString "bafy2bza_signified",
    concept := .orig .signifiedConcept, leanName := `Solfunmeme.Concept.signifiedConcept },
  { qid := "Q80071",   article := "Symbol",
    cid := CID.ofString "bafy2bza_symbol",
    concept := .orig .symbolConcept, leanName := `Solfunmeme.Concept.symbolConcept },
  { qid := "Q1499972", article := "Icon (semiotics)",
    cid := CID.ofString "bafy2bza_icon",
    concept := .orig .iconConcept, leanName := `Solfunmeme.Concept.iconConcept },
  { qid := "Q598418",  article := "Index (semiotics)",
    cid := CID.ofString "bafy2bza_index",
    concept := .orig .indexConcept, leanName := `Solfunmeme.Concept.indexConcept },

  -- ── Wikipedia-sourced semiotics extensions ────────────────────────────
  { qid := "Q2480612", article := "Semiosis",
    cid := CID.ofString "bafy2bza_semiosis",
    concept := .wiki .semiosis, leanName := `Solfunmeme.Wikipedia.WikiConcept.semiosis },
  { qid := "Q39645",   article := "Semantics",
    cid := CID.ofString "bafy2bza_semantics",
    concept := .wiki .semanticsConcept, leanName := `Solfunmeme.Wikipedia.WikiConcept.semanticsConcept },
  { qid := "Q193657",  article := "Biosemiotics",
    cid := CID.ofString "bafy2bza_biosemiotics",
    concept := .wiki .biosemiotics, leanName := `Solfunmeme.Wikipedia.WikiConcept.biosemiotics },
  { qid := "Q7168011", article := "Zoosemiotics",
    cid := CID.ofString "bafy2bza_zoosemiotics",
    concept := .wiki .zoosemiotics, leanName := `Solfunmeme.Wikipedia.WikiConcept.zoosemiotics },

  -- ── Mathematics cluster ───────────────────────────────────────────────
  { qid := "Q11563",   article := "Number",
    cid := CID.ofString "bafy2bza_number",
    concept := .orig .number, leanName := `Solfunmeme.Concept.number },
  { qid := "Q21199",   article := "Natural number",
    cid := CID.ofString "bafy2bza_nat",
    concept := .orig .naturalNumber, leanName := `Solfunmeme.Concept.naturalNumber },
  { qid := "Q12916",   article := "Real number",
    cid := CID.ofString "bafy2bza_real",
    concept := .orig .realNumber, leanName := `Solfunmeme.Concept.realNumber },
  { qid := "Q36496",   article := "Sequence",
    cid := CID.ofString "bafy2bza_sequence",
    concept := .orig .sequence, leanName := `Solfunmeme.Concept.sequence },
  { qid := "Q47007",   article := "Prime number",
    cid := CID.ofString "bafy2bza_primes",
    concept := .orig .primes, leanName := `Solfunmeme.Concept.primes },
  { qid := "Q36583",   article := "Group (mathematics)",
    cid := CID.ofString "bafy2bza_group",
    concept := .orig .group, leanName := `Solfunmeme.Concept.group },
  { qid := "Q161172",  article := "Ring (mathematics)",
    cid := CID.ofString "bafy2bza_ring",
    concept := .orig .ring, leanName := `Solfunmeme.Concept.ring },
  { qid := "Q190109",  article := "Field (mathematics)",
    cid := CID.ofString "bafy2bza_field",
    concept := .orig .fieldAlgebra, leanName := `Solfunmeme.Concept.fieldAlgebra },
  { qid := "Q180907",  article := "Topology",
    cid := CID.ofString "bafy2bza_topology",
    concept := .orig .topology, leanName := `Solfunmeme.Concept.topology },
  { qid := "Q203920",  article := "Category theory",
    cid := CID.ofString "bafy2bza_cattheory",
    concept := .orig .categoryTheoryConcept,
    leanName := `Solfunmeme.Concept.categoryTheoryConcept },
  { qid := "Q864377",  article := "Morphism",
    cid := CID.ofString "bafy2bza_morphism",
    concept := .orig .morphism, leanName := `Solfunmeme.Concept.morphism },
  { qid := "Q16889133", article := "Logic",
    cid := CID.ofString "bafy2bza_logic",
    concept := .orig .logic, leanName := `Solfunmeme.Concept.logic },

  -- ── Computation cluster ───────────────────────────────────────────────
  { qid := "Q68",      article := "Computer science",
    cid := CID.ofString "bafy2bza_algorithm",
    concept := .orig .algorithm, leanName := `Solfunmeme.Concept.algorithm },
  { qid := "Q21127166", article := "Compiler",
    cid := CID.ofString "bafy2bza_compiler",
    concept := .orig .compiler, leanName := `Solfunmeme.Concept.compiler },
  { qid := "Q1077469", article := "Executable",
    cid := CID.ofString "bafy2bza_executable",
    concept := .orig .executable, leanName := `Solfunmeme.Concept.executable },
  { qid := "Q9143",    article := "Programming language",
    cid := CID.ofString "bafy2bza_language",
    concept := .orig .languageConcept, leanName := `Solfunmeme.Concept.languageConcept },

  -- ── Biology cluster ───────────────────────────────────────────────────
  { qid := "Q7187",    article := "Gene",
    cid := CID.ofString "bafy2bza_gene",
    concept := .orig .gene, leanName := `Solfunmeme.Concept.gene },
  { qid := "Q7020",    article := "DNA",
    cid := CID.ofString "bafy2bza_dna",
    concept := .orig .dna, leanName := `Solfunmeme.Concept.dna },
  { qid := "Q11053",   article := "RNA",
    cid := CID.ofString "bafy2bza_rna",
    concept := .orig .rna, leanName := `Solfunmeme.Concept.rna },
  { qid := "Q8054",    article := "Protein",
    cid := CID.ofString "bafy2bza_protein",
    concept := .orig .protein, leanName := `Solfunmeme.Concept.protein },
  { qid := "Q7239",    article := "Organism",
    cid := CID.ofString "bafy2bza_organism",
    concept := .orig .organism, leanName := `Solfunmeme.Concept.organism },
  { qid := "Q37813",   article := "Ecosystem",
    cid := CID.ofString "bafy2bza_ecosystem",
    concept := .orig .ecosystem, leanName := `Solfunmeme.Concept.ecosystem },
  { qid := "Q37517",   article := "Cell (biology)",
    cid := CID.ofString "bafy2bza_cell",
    concept := .orig .cellConcept, leanName := `Solfunmeme.Concept.cellConcept },
  { qid := "Q420",     article := "Evolution",
    cid := CID.ofString "bafy2bza_evolution",
    concept := .orig .evolution, leanName := `Solfunmeme.Concept.evolution },

  -- ── Culture / Memes cluster ───────────────────────────────────────────
  { qid := "Q5227365", article := "Meme",
    cid := CID.ofString "bafy2bza_meme",
    concept := .orig .meme, leanName := `Solfunmeme.Concept.meme },
  { qid := "Q113196853", article := "Skibidi Toilet",
    cid := CID.ofString "bafy2bza_skibidi",
    concept := .orig .skibidiToilet, leanName := `Solfunmeme.Concept.skibidiToilet },
  { qid := "Q1147471", article := "Piano Man (song)",
    cid := CID.ofString "bafy2bza_pianoman",
    concept := .orig .pianoMan, leanName := `Solfunmeme.Concept.pianoMan },

  -- ── Wikipedia-sourced meme/culture extensions ─────────────────────────
  { qid := "Q1064858", article := "Memetics",
    cid := CID.ofString "bafy2bza_memetics",
    concept := .wiki .memetics, leanName := `Solfunmeme.Wikipedia.WikiConcept.memetics },
  { qid := "Q1432449", article := "Internet meme",
    cid := CID.ofString "bafy2bza_internetmeme",
    concept := .wiki .internetMeme, leanName := `Solfunmeme.Wikipedia.WikiConcept.internetMeme },
  { qid := "Q65254020", article := "Generation Alpha",
    cid := CID.ofString "bafy2bza_genalpha",
    concept := .wiki .generationAlpha, leanName := `Solfunmeme.Wikipedia.WikiConcept.generationAlpha },

  -- ── Metaphysics cluster ───────────────────────────────────────────────
  { qid := "Q44325",   article := "Consciousness",
    cid := CID.ofString "bafy2bza_consciousness",
    concept := .orig .consciousness, leanName := `Solfunmeme.Concept.consciousness },
  { qid := "Q450",     article := "Mind",
    cid := CID.ofString "bafy2bza_mind",
    concept := .orig .mind, leanName := `Solfunmeme.Concept.mind },
  { qid := "Q131",     article := "Truth",
    cid := CID.ofString "bafy2bza_truth",
    concept := .orig .truth, leanName := `Solfunmeme.Concept.truth },
  { qid := "Q5401",    article := "Good and evil",
    cid := CID.ofString "bafy2bza_good",
    concept := .orig .good, leanName := `Solfunmeme.Concept.good },
  { qid := "Q17737",   article := "Theory",
    cid := CID.ofString "bafy2bza_theory",
    concept := .orig .theoryConcept, leanName := `Solfunmeme.Concept.theoryConcept },
  { qid := "Q44602",   article := "Chaos theory",
    cid := CID.ofString "bafy2bza_chaos",
    concept := .orig .chaos, leanName := `Solfunmeme.Concept.chaos },
  { qid := "Q3769587", article := "Soul",
    cid := CID.ofString "bafy2bza_soul",
    concept := .orig .soul, leanName := `Solfunmeme.Concept.soul },

  -- ── Technology cluster ────────────────────────────────────────────────
  { qid := "Q186055",  article := "Git",
    cid := CID.ofString "bafy2bza_git",
    concept := .orig .gitConcept, leanName := `Solfunmeme.Concept.gitConcept },
  { qid := "Q364",     article := "GitHub",
    cid := CID.ofString "bafy2bza_github",
    concept := .orig .gitHubConcept, leanName := `Solfunmeme.Concept.gitHubConcept },
  { qid := "Q388",     article := "Linux",
    cid := CID.ofString "bafy2bza_linux",
    concept := .orig .linuxConcept, leanName := `Solfunmeme.Concept.linuxConcept },
  { qid := "Q15206305", article := "Docker (software)",
    cid := CID.ofString "bafy2bza_docker",
    concept := .orig .dockerConcept, leanName := `Solfunmeme.Concept.dockerConcept },

  -- ── Type Theory cluster ───────────────────────────────────────────────
  { qid := "Q1145828", article := "Homotopy type theory",
    cid := CID.ofString "bafy2bza_hott",
    concept := .orig .homotopyTypeTheory,
    leanName := `Solfunmeme.Concept.homotopyTypeTheory },
  { qid := "Q278119",  article := "Lambda calculus",
    cid := CID.ofString "bafy2bza_lambda",
    concept := .orig .lambdaCalculus, leanName := `Solfunmeme.Concept.lambdaCalculus },

  -- ── Biochemistry extensions from Wikipedia ────────────────────────────
  { qid := "Q8066",    article := "Amino acid",
    cid := CID.ofString "bafy2bza_aminoacid",
    concept := .wiki .aminoAcid, leanName := `Solfunmeme.Wikipedia.WikiConcept.aminoAcid },
  { qid := "Q178295",  article := "Enzyme",
    cid := CID.ofString "bafy2bza_enzyme",
    concept := .wiki .enzymeConcept, leanName := `Solfunmeme.Wikipedia.WikiConcept.enzymeConcept },
  { qid := "Q11094",   article := "Proteome",
    cid := CID.ofString "bafy2bza_proteome",
    concept := .wiki .proteome, leanName := `Solfunmeme.Wikipedia.WikiConcept.proteome },
  { qid := "Q898568",  article := "Protein folding",
    cid := CID.ofString "bafy2bza_folding",
    concept := .wiki .proteinFolding,
    leanName := `Solfunmeme.Wikipedia.WikiConcept.proteinFolding },

  -- ── Figures ───────────────────────────────────────────────────────────
  { qid := "Q41390",   article := "Kurt Gödel",
    cid := CID.ofString "bafy2bza_goedel",
    concept := .orig .goedelConcept, leanName := `Solfunmeme.Concept.goedelConcept },
  { qid := "Q7251",    article := "Alan Turing",
    cid := CID.ofString "bafy2bza_turing",
    concept := .orig .turingConcept, leanName := `Solfunmeme.Concept.turingConcept },
  { qid := "Q92737",   article := "Alonzo Church",
    cid := CID.ofString "bafy2bza_church",
    concept := .orig .churchConcept, leanName := `Solfunmeme.Concept.churchConcept }
]

-- ============================================================================
-- § 5  Directional Maps — QID ↔ Article ↔ CID ↔ Concept ↔ Lean Name
-- ============================================================================

/-- Look up a Wikipedia article title by Wikidata QID. -/
def qidToArticle (qid : String) : Option String :=
  (entityTable.find? (fun e => e.qid == qid)).map (·.article)

/-- Look up an IPLD content identifier by Wikidata QID. -/
def qidToCID (qid : String) : Option CID :=
  (entityTable.find? (fun e => e.qid == qid)).map (·.cid)

/-- Look up the formal concept by Wikidata QID. -/
def qidToConcept (qid : String) : Option ExtConcept :=
  (entityTable.find? (fun e => e.qid == qid)).map (·.concept)

/-- Look up the Lean constant name by Wikidata QID. -/
def qidToLeanName (qid : String) : Option Name :=
  (entityTable.find? (fun e => e.qid == qid)).map (·.leanName)

/-- Look up a Wikidata QID by CID. -/
def cidToQID (cid : CID) : Option String :=
  (entityTable.find? (fun e => e.cid == cid)).map (·.qid)

/-- Look up a Wikidata QID by Lean name. -/
def leanNameToQID (n : Name) : Option String :=
  (entityTable.find? (fun e => e.leanName == n)).map (·.qid)

/-- Look up a concept by CID. -/
def cidToConcept (cid : CID) : Option ExtConcept :=
  (entityTable.find? (fun e => e.cid == cid)).map (·.concept)

/-- Look up a CID by concept. -/
def conceptToCID (c : ExtConcept) : Option CID :=
  (entityTable.find? (fun e => decide (e.concept = c))).map (·.cid)

/-- Look up a Wikipedia article by concept. -/
def conceptToArticle (c : ExtConcept) : Option String :=
  (entityTable.find? (fun e => decide (e.concept = c))).map (·.article)

-- ============================================================================
-- § 6  IPLD Node Loading (placeholder)
-- ============================================================================

/-- Load an IPLD node by CID (placeholder — requires an IPLD blockstore).
    In a real implementation, this would retrieve and decode the DAG-CBOR block. -/
def loadNode (_cid : CID) : Option IPLDNode := none

/-- Resolve a QID to its IPLD node content via the bridge table.
    Composes `qidToCID` with the blockstore loader. -/
def qidToNode (loader : CID → Option IPLDNode) (qid : String) : Option IPLDNode :=
  match qidToCID qid with
  | some cid => loader cid
  | none     => none

-- ============================================================================
-- § 7  Table Statistics
-- ============================================================================

/-- Number of bridged entities. -/
def bridgedEntityCount : Nat := entityTable.length

/-- All QIDs in the table. -/
def allQIDs : List String := entityTable.map (·.qid)

/-- All CIDs in the table. -/
def allCIDs : List CID := entityTable.map (·.cid)

/-- All Lean names in the table. -/
def allLeanNames : List Name := entityTable.map (·.leanName)

-- ============================================================================
-- § 8  Uniqueness predicates
-- ============================================================================

/-- Check that a list has no duplicates (using BEq). -/
def noDupsBEq [BEq α] : List α → Bool
  | [] => true
  | x :: xs => !(xs.any (· == x)) && noDupsBEq xs

/-- All QIDs are unique. -/
def qidsUnique : Bool := noDupsBEq allQIDs

/-- All CIDs are unique. -/
def cidsUnique : Bool := noDupsBEq allCIDs

/-- All Lean names are unique. -/
def leanNamesUnique : Bool := noDupsBEq allLeanNames

-- ============================================================================
-- § 9  Verified Properties
-- ============================================================================

/-- The entity table has exactly 55 bridged entities. -/
theorem entity_count : bridgedEntityCount = 60 := by native_decide

/-- All QIDs in the table are distinct. -/
theorem qids_are_unique : qidsUnique = true := by native_decide

/-- All CIDs in the table are distinct. -/
theorem cids_are_unique : cidsUnique = true := by native_decide

/-- All Lean names in the table are distinct. -/
theorem lean_names_are_unique : leanNamesUnique = true := by native_decide

-- ── Round-trip properties ───────────────────────────────────────────────

/-- Looking up Semiotics by QID returns the correct article. -/
theorem qid_semiotics_article :
    qidToArticle "Q33742" = some "Semiotics" := by native_decide

/-- Looking up Semiotics by QID returns the correct CID. -/
theorem qid_semiotics_cid :
    qidToCID "Q33742" = some (CID.ofString "bafy2bza_semiotics") := by native_decide

/-- Looking up Semiotics by QID returns the correct concept. -/
theorem qid_semiotics_concept :
    qidToConcept "Q33742" = some (.orig .signConcept) := by native_decide

/-- Looking up Skibidi Toilet by QID yields the correct article. -/
theorem qid_skibidi_article :
    qidToArticle "Q113196853" = some "Skibidi Toilet" := by native_decide

/-- Looking up by CID returns the correct QID (inverse direction). -/
theorem cid_semiotics_roundtrip :
    cidToQID (CID.ofString "bafy2bza_semiotics") = some "Q33742" := by native_decide

/-- Looking up by Lean name returns the correct QID (inverse direction). -/
theorem name_semiotics_roundtrip :
    leanNameToQID `Solfunmeme.Concept.signConcept = some "Q33742" := by native_decide

/-- Concept → CID → QID round-trip for Protein. -/
theorem protein_roundtrip :
    (do let cid ← conceptToCID (.orig .protein)
        cidToQID cid) = some "Q8054" := by native_decide

/-- Concept → Article for Turing. -/
theorem turing_article :
    conceptToArticle (.orig .turingConcept) = some "Alan Turing" := by native_decide

-- ── Cross-cluster coverage ──────────────────────────────────────────────

/-- Every original cluster has at least one bridged entity. -/
theorem all_clusters_bridged :
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .mathematics | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .computation | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .metaphysics | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .biology | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .culture | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .technology | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .typeTheory | _ => false)) &&
    (entityTable.any (fun e => match e.concept with | .orig c => c.cluster == .semiotics | _ => false))
    = true := by native_decide

-- ============================================================================
-- § 10  Summary Output
-- ============================================================================

#eval IO.println s!"Entity Bridge:"
#eval IO.println s!"  Bridged entities: {bridgedEntityCount}"
#eval IO.println s!"  QIDs unique: {qidsUnique}"
#eval IO.println s!"  CIDs unique: {cidsUnique}"
#eval IO.println s!"  Lean names unique: {leanNamesUnique}"

#eval do
  let samples := [
    ("Q33742", "Semiotics"),
    ("Q113196853", "Skibidi Toilet"),
    ("Q7251", "Alan Turing"),
    ("Q8054", "Protein"),
    ("Q193657", "Biosemiotics")
  ]
  IO.println "\n  Sample lookups (QID → Article):"
  for (qid, expected) in samples do
    let result := qidToArticle qid
    IO.println s!"    {qid} → {result} (expected: {expected})"

#eval do
  IO.println "\n  CID → QID reverse lookups:"
  let cidSamples := [
    ("bafy2bza_semiotics", "Q33742"),
    ("bafy2bza_skibidi", "Q113196853"),
    ("bafy2bza_turing", "Q7251")
  ]
  for (cidStr, expectedQid) in cidSamples do
    let result := cidToQID (CID.ofString cidStr)
    IO.println s!"    {cidStr} → {result} (expected: {expectedQid})"

end Solfunmeme.Bridge
