/-
# ATP is Ambrosia for the Meme — A Formal Theory

## Core thesis
Adenosine triphosphate (ATP) is the universal energy currency of biological
cells.  Every process that sustains a gene — transcription, translation,
replication — is powered by ATP hydrolysis.  Genes encode proteins; proteins
fold and catalyse; the whole cathedral of molecular biology runs on ATP.

Dawkins' meme is the cultural analogue of the gene.  If the gene→protein
pipeline is powered by ATP, then by functorial analogy the meme→culture
pipeline must have its own "ambrosia" — an energy substrate that drives
memetic replication, variation and selection.

## The taxonomic lift: Gene : Meme :: Genus : Memus
A gene is an *individual replicator* in biology.  A genus is a *taxonomic
class* grouping related species.  Extending the Dawkins analogy one
categorical level:

  Gene   ↦  Meme     (atomic replicator)
  Genus  ↦  Memus    (taxonomic class of replicators)

**Memus** is the genus-level taxon of memes — a higher-order classifier
that groups related meme-types, just as a biological genus groups related
species.  A meme is therefore not merely an individual; it belongs to a
**memus**, its memetic genus.

## Formal content
1. Taxonomic rank hierarchy (biological and memetic, in parallel)
2. ATP as the energy substrate powering both domains
3. The "ambrosia" functor: Biology → Culture
4. Memus as a first-class concept in the ontology
5. Verified structural theorems

## Sources
- R. Dawkins, *The Selfish Gene* (1976) — meme concept
- C. S. Peirce, *Collected Papers* — sign/semiosis
- Wikipedia articles: "Adenosine triphosphate", "Phosphorus", "DNA", "RNA",
  "Action potential", "Voltage" (provided by user, June 2025)
-/

import Mathlib
import RequestProject.SolfunmemeOntology

namespace Solfunmeme.ATPAmbrosia

open Solfunmeme

-- ============================================================================
-- § 1  Taxonomic ranks — the parallel hierarchies
-- ============================================================================

/-- Linnaean taxonomic ranks in biology. -/
inductive BioRank where
  | domain
  | kingdom
  | phylum
  | classis    -- "class" is a Lean keyword
  | ordo       -- "order" is common, use Latin
  | familia
  | genus
  | species
  deriving DecidableEq, Repr, Inhabited, BEq

/-- Memetic taxonomic ranks — the cultural parallel.
    Just as biology classifies replicators (genes/organisms) into a
    hierarchy of ranks, memetics classifies cultural replicators (memes)
    into an analogous hierarchy. -/
inductive MemRank where
  | memosphere    -- analogue of domain: all memes
  | tradition     -- analogue of kingdom: broad cultural tradition
  | paradigm      -- analogue of phylum: conceptual framework
  | genre         -- analogue of class: recognisable category
  | school        -- analogue of order: specific movement
  | memeplex      -- analogue of family: co-adapted meme complex
  | memus         -- analogue of genus: taxonomic class of related memes
  | meme          -- analogue of species: atomic replicator
  deriving DecidableEq, Repr, Inhabited, BEq

/-- The rank-level correspondence: each biological rank maps to its
    memetic analogue.  This is the "taxonomic functor". -/
def rankAnalogy : BioRank → MemRank
  | .domain   => .memosphere
  | .kingdom  => .tradition
  | .phylum   => .paradigm
  | .classis  => .genre
  | .ordo     => .school
  | .familia  => .memeplex
  | .genus    => .memus
  | .species  => .meme

-- ============================================================================
-- § 2  The core analogy: Gene : Meme :: Genus : Memus
-- ============================================================================

/-- A formal analogy is a 4-tuple (a, b, c, d) where a:b :: c:d.
    We encode this as a structure so we can state and prove properties. -/
structure Analogy (α β : Type*) where
  source₁ : α
  target₁ : β
  source₂ : α
  target₂ : β
  deriving Repr

/-- The Dawkins analogy at the replicator level. -/
def dawkinsAnalogy : Analogy BioRank MemRank where
  source₁ := .species   -- gene lives at species-level
  target₁ := .meme      -- meme is the atomic replicator
  source₂ := .genus     -- genus classifies species
  target₂ := .memus     -- memus classifies memes

/-- An analogy is *rank-preserving* if the mapping from source to target
    is consistent with `rankAnalogy`. -/
def Analogy.isRankPreserving (a : Analogy BioRank MemRank) : Prop :=
  rankAnalogy a.source₁ = a.target₁ ∧ rankAnalogy a.source₂ = a.target₂

/-- The Dawkins analogy is rank-preserving: the taxonomic functor sends
    species ↦ meme  and  genus ↦ memus. -/
theorem dawkins_analogy_preserves_rank : dawkinsAnalogy.isRankPreserving := by
  constructor <;> rfl

-- ============================================================================
-- § 3  The rank functor is injective (no two bio-ranks collapse)
-- ============================================================================

theorem rankAnalogy_injective : Function.Injective rankAnalogy := by
  intro a b h
  cases a <;> cases b <;> simp_all [rankAnalogy]

/-- The rank analogy is surjective (every memetic rank has a bio source). -/
theorem rankAnalogy_surjective : Function.Surjective rankAnalogy := by
  intro b
  cases b
  · exact ⟨.domain, rfl⟩
  · exact ⟨.kingdom, rfl⟩
  · exact ⟨.phylum, rfl⟩
  · exact ⟨.classis, rfl⟩
  · exact ⟨.ordo, rfl⟩
  · exact ⟨.familia, rfl⟩
  · exact ⟨.genus, rfl⟩
  · exact ⟨.species, rfl⟩

/-- The rank analogy is a bijection. -/
theorem rankAnalogy_bijective : Function.Bijective rankAnalogy :=
  ⟨rankAnalogy_injective, rankAnalogy_surjective⟩

-- ============================================================================
-- § 4  ATP — the energy substrate
-- ============================================================================

/-- The domains where ATP operates. -/
inductive EnergyDomain where
  | cellularMetabolism     -- glycolysis, citric acid cycle, ox-phos
  | dnaReplication         -- helicase, polymerase powered by ATP
  | rnaTranscription       -- RNA polymerase uses ATP (among NTPs)
  | proteinSynthesis       -- aminoacyl-tRNA synthetase, ribosome
  | muscleContraction      -- myosin ATPase
  | nerveImpulse           -- Na⁺/K⁺ ATPase, action potentials
  | activeTransport        -- ABC transporters
  | signalTransduction     -- kinases phosphorylate using ATP
  deriving DecidableEq, Repr, Inhabited, BEq

/-- Every energy domain maps to a solfunmeme ontology concept
    that it powers or enables. -/
def energyDomainConcept : EnergyDomain → Concept
  | .cellularMetabolism => .cellConcept
  | .dnaReplication     => .dna
  | .rnaTranscription   => .rna
  | .proteinSynthesis   => .protein
  | .muscleContraction  => .organism
  | .nerveImpulse       => .consciousness   -- action potentials underlie awareness
  | .activeTransport    => .cellConcept
  | .signalTransduction => .gene            -- kinase cascades regulate gene expression

-- ============================================================================
-- § 5  Ambrosia — the energy-sustenance relation
-- ============================================================================

/-- A `Sustainer` is an energy source that powers a replicator system.
    ATP sustains genes; "memetic ATP" (attention, affect, transmission
    energy) sustains memes. -/
structure Sustainer where
  name : String
  domain : String            -- "biology" or "culture"
  powersReplicator : Bool    -- does it power the atomic replicator?
  powersClassifier : Bool    -- does it power the genus-level classifier?
  deriving Repr, DecidableEq, BEq

/-- ATP: the biological sustainer.  Powers both gene-level processes
    (replication, transcription) and genus-level processes (speciation,
    phylogenesis — all ATP-dependent). -/
def atp : Sustainer where
  name := "Adenosine triphosphate"
  domain := "biology"
  powersReplicator := true
  powersClassifier := true

/-- Memetic ATP: the cultural sustainer.  Attention, affect, and
    transmission bandwidth are the "energy currency" of meme propagation.
    Powers both individual memes (virality) and memetic genera
    (tradition formation, genre crystallisation). -/
def memeticATP : Sustainer where
  name := "Attention-Affect-Transmission"
  domain := "culture"
  powersReplicator := true
  powersClassifier := true

/-- The ambrosia thesis: a sustainer is "ambrosia" for a replicator
    system if it powers both the atomic replicator and its classifier. -/
def Sustainer.isAmbrosia (s : Sustainer) : Prop :=
  s.powersReplicator = true ∧ s.powersClassifier = true

/-- ATP is ambrosia for the gene (and by extension, for biology). -/
theorem atp_is_ambrosia : atp.isAmbrosia := by
  constructor <;> rfl

/-- Memetic ATP is ambrosia for the meme. -/
theorem memetic_atp_is_ambrosia : memeticATP.isAmbrosia := by
  constructor <;> rfl

-- ============================================================================
-- § 6  The Ambrosia Functor: Biology → Culture
-- ============================================================================

/-- The full ambrosia mapping bundles the rank analogy with the
    sustainer analogy into a single coherent bridge. -/
structure AmbrosiaMapping where
  bioRank    : BioRank
  memRank    : MemRank
  bioEnergy  : Sustainer
  memEnergy  : Sustainer
  rankMatch  : rankAnalogy bioRank = memRank
  energyMatch : bioEnergy.domain = "biology" ∧ memEnergy.domain = "culture"
  bothAmbrosia : bioEnergy.isAmbrosia ∧ memEnergy.isAmbrosia

/-- The concrete mapping at genus/memus level. -/
def genusMemusMapping : AmbrosiaMapping where
  bioRank := .genus
  memRank := .memus
  bioEnergy := atp
  memEnergy := memeticATP
  rankMatch := rfl
  energyMatch := ⟨rfl, rfl⟩
  bothAmbrosia := ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- The concrete mapping at species/meme level. -/
def speciesMemeMapping : AmbrosiaMapping where
  bioRank := .species
  memRank := .meme
  bioEnergy := atp
  memEnergy := memeticATP
  rankMatch := rfl
  energyMatch := ⟨rfl, rfl⟩
  bothAmbrosia := ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

-- ============================================================================
-- § 7  Memus as a concept in the ontology
-- ============================================================================

/-- New concepts introduced by the ATP-Ambrosia theory. -/
inductive ATPConcept where
  | atp                 -- adenosine triphosphate itself
  | phosphorus          -- element P, backbone of ATP and DNA
  | memus               -- the genus-level taxon of memes
  | memeticEnergy       -- the cultural analogue of ATP
  | actionPotential     -- nerve impulse (ATP-powered)
  | voltage             -- electric potential difference
  | nucleotide          -- building block of DNA/RNA (contains phosphate)
  | ribose              -- sugar component of RNA/ATP
  | phosphodiesterBond  -- bond linking nucleotides (ATP-related)
  | hydrolysis          -- ATP → ADP + Pᵢ releases energy
  deriving DecidableEq, Repr, Inhabited, BEq

/-- Extended concept: original ontology + ATP theory concepts. -/
inductive ATPExtConcept where
  | orig : Concept → ATPExtConcept
  | atp  : ATPConcept → ATPExtConcept
  deriving DecidableEq, Repr, Inhabited, BEq

/-- Cluster assignment for ATP concepts. -/
def ATPConcept.cluster : ATPConcept → Cluster
  | .atp | .phosphorus | .nucleotide | .ribose
  | .phosphodiesterBond | .hydrolysis          => .biology
  | .memus | .memeticEnergy                     => .culture
  | .actionPotential | .voltage                 => .metaphysics  -- consciousness/nerve

/-- Canonical names for ATP concepts. -/
def ATPConcept.canonicalName : ATPConcept → String
  | .atp               => "Adenosine triphosphate"
  | .phosphorus        => "Phosphorus"
  | .memus             => "Memus"
  | .memeticEnergy     => "Memetic energy"
  | .actionPotential   => "Action potential"
  | .voltage           => "Voltage"
  | .nucleotide        => "Nucleotide"
  | .ribose            => "Ribose"
  | .phosphodiesterBond => "Phosphodiester bond"
  | .hydrolysis        => "Hydrolysis"

/-- All ATPConcept values. -/
def ATPConcept.all : List ATPConcept :=
  [.atp, .phosphorus, .memus, .memeticEnergy, .actionPotential,
   .voltage, .nucleotide, .ribose, .phosphodiesterBond, .hydrolysis]

-- ============================================================================
-- § 8  Extended adjacency — ATP theory edges
-- ============================================================================

/-- All original Concepts. -/
private def origConceptList : List Concept := [
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

/-- All ATPExtConcepts. -/
def ATPExtConcept.all : List ATPExtConcept :=
  (origConceptList.map .orig) ++ (ATPConcept.all.map .atp)

/-- Adjacency in the extended graph.
    Includes original ontology edges plus ATP-theory edges. -/
def atpAdjacent : ATPExtConcept → ATPExtConcept → Bool
  -- ── Inherit key original ontology edges ───────────────────────────────
  -- Meme hierarchy
  | .orig .metaMeme, .orig .meme => true
  | .orig .skibidiToilet, .orig .meme => true
  | .orig .pianoMan, .orig .meme => true
  -- Biology chain: cell → dna → gene → protein
  | .orig .cellConcept, .orig .dna => true
  | .orig .dna, .orig .gene => true
  | .orig .rna, .orig .dna => true
  | .orig .gene, .orig .protein => true
  -- Meme → Gene (Dawkins bridge)
  | .orig .meme, .orig .gene => true
  -- Mind ↔ Consciousness
  | .orig .mind, .orig .consciousness => true
  | .orig .consciousness, .orig .mind => true
  -- Evolution edges
  | .orig .evolution, .orig .mutation => true
  | .orig .evolution, .orig .selection => true
  | .orig .organism, .orig .speciesConcept => true

  -- ── ATP theory edges ──────────────────────────────────────────────────
  -- ATP molecular structure
  | .atp .nucleotide, .atp .ribose => true
  | .atp .nucleotide, .atp .phosphodiesterBond => true
  | .atp .atp, .atp .nucleotide => true
  | .atp .atp, .atp .ribose => true
  | .atp .atp, .atp .phosphorus => true
  | .atp .atp, .atp .hydrolysis => true

  -- ATP powers biological concepts
  | .atp .atp, .orig .cellConcept => true
  | .atp .atp, .orig .dna => true
  | .atp .atp, .orig .rna => true
  | .atp .atp, .orig .protein => true
  | .atp .atp, .orig .gene => true
  | .atp .atp, .orig .organism => true

  -- ATP → action potential → consciousness chain
  | .atp .atp, .atp .actionPotential => true
  | .atp .actionPotential, .atp .voltage => true
  | .atp .actionPotential, .orig .consciousness => true

  -- Phosphorus backbone
  | .atp .phosphorus, .orig .dna => true
  | .atp .phosphorus, .orig .rna => true
  | .atp .phosphorus, .atp .atp => true

  -- ── Memus edges ───────────────────────────────────────────────────────
  -- Memus is the genus of memes
  | .atp .memus, .orig .meme => true
  | .orig .meme, .atp .memus => true
  | .orig .metaMeme, .atp .memus => true
  | .orig .skibidiToilet, .atp .memus => true
  | .orig .pianoMan, .atp .memus => true

  -- Memetic energy
  | .atp .memeticEnergy, .orig .meme => true
  | .atp .memeticEnergy, .atp .memus => true
  | .atp .memeticEnergy, .orig .consciousness => true

  -- Memus → biology bridge (the grand analogy)
  | .atp .memus, .orig .gene => true
  | .atp .memus, .orig .speciesConcept => true

  -- ── Everything else ───────────────────────────────────────────────────
  | _, _ => false

-- ============================================================================
-- § 9  BFS reachability over the extended graph
-- ============================================================================

/-- BFS step: expand frontier by one hop. -/
private def atpBfsStep (visited frontier : List ATPExtConcept) : List ATPExtConcept :=
  let newNodes := frontier.foldl (fun acc node =>
    acc ++ (ATPExtConcept.all.filter fun target =>
      atpAdjacent node target && !(visited ++ acc).any (· == target))) []
  newNodes.eraseDups

/-- BFS reachability with bounded depth. -/
private def atpReachesAux (src : ATPExtConcept) : Nat → List ATPExtConcept
  | 0 => [src]
  | n + 1 =>
    let prev := atpReachesAux src n
    let newNodes := atpBfsStep prev prev
    (prev ++ newNodes).eraseDups

/-- Full reachability (depth 15 is more than enough for 131 nodes). -/
def atpReaches (src tgt : ATPExtConcept) : Bool :=
  let reachable := atpReachesAux src 15
  reachable.any (· == tgt)

-- ============================================================================
-- § 10  Verified theorems
-- ============================================================================

-- ── The core analogy theorems ───────────────────────────────────────────

/-- Gene : Meme :: Genus : Memus — the rank analogy is consistent. -/
theorem gene_meme_genus_memus :
    rankAnalogy .species = .meme ∧ rankAnalogy .genus = .memus := by
  constructor <;> rfl

/-- The Dawkins analogy preserves taxonomic rank. -/
theorem dawkins_preserves_rank : dawkinsAnalogy.isRankPreserving :=
  dawkins_analogy_preserves_rank

/-- The rank analogy is a bijection (injective + surjective). -/
theorem rank_analogy_is_bijective :
    Function.Bijective rankAnalogy :=
  rankAnalogy_bijective

-- ── ATP as ambrosia ─────────────────────────────────────────────────────

/-- ATP is ambrosia for biology. -/
theorem atp_ambrosia_bio : atp.isAmbrosia :=
  atp_is_ambrosia

/-- Memetic ATP is ambrosia for culture. -/
theorem memetic_atp_ambrosia_culture : memeticATP.isAmbrosia :=
  memetic_atp_is_ambrosia

/-- Both sustainers are ambrosia — the parallel holds. -/
theorem both_ambrosia : atp.isAmbrosia ∧ memeticATP.isAmbrosia :=
  ⟨atp_is_ambrosia, memetic_atp_is_ambrosia⟩

-- ── Reachability: ATP powers the whole chain ────────────────────────────

/-- ATP reaches protein (ATP powers protein synthesis). -/
theorem atp_reaches_protein :
    atpReaches (.atp .atp) (.orig .protein) = true := by native_decide

/-- ATP reaches gene (ATP powers gene expression). -/
theorem atp_reaches_gene :
    atpReaches (.atp .atp) (.orig .gene) = true := by native_decide

/-- ATP reaches DNA (ATP powers DNA replication). -/
theorem atp_reaches_dna :
    atpReaches (.atp .atp) (.orig .dna) = true := by native_decide

/-- ATP reaches consciousness via action potentials. -/
theorem atp_reaches_consciousness :
    atpReaches (.atp .atp) (.orig .consciousness) = true := by native_decide

/-- ATP reaches organism (organisms run on ATP). -/
theorem atp_reaches_organism :
    atpReaches (.atp .atp) (.orig .organism) = true := by native_decide

-- ── Memus reachability ──────────────────────────────────────────────────

/-- Memus reaches meme (a memus classifies memes). -/
theorem memus_reaches_meme :
    atpReaches (.atp .memus) (.orig .meme) = true := by native_decide

/-- Memus reaches gene (via the grand analogy bridge). -/
theorem memus_reaches_gene :
    atpReaches (.atp .memus) (.orig .gene) = true := by native_decide

/-- Memus reaches protein (memus → meme → gene → protein). -/
theorem memus_reaches_protein :
    atpReaches (.atp .memus) (.orig .protein) = true := by native_decide

/-- Meme reaches memus (memes belong to a memus). -/
theorem meme_reaches_memus :
    atpReaches (.orig .meme) (.atp .memus) = true := by native_decide

/-- Skibidi Toilet reaches memus (it belongs to a memetic genus). -/
theorem skibidi_reaches_memus :
    atpReaches (.orig .skibidiToilet) (.atp .memus) = true := by native_decide

/-- Skibidi Toilet reaches protein via memus
    (skibidi → meme → gene → protein). -/
theorem skibidi_via_memus_reaches_protein :
    atpReaches (.orig .skibidiToilet) (.orig .protein) = true := by native_decide

-- ── The grand ambrosia path ─────────────────────────────────────────────

/-- Phosphorus reaches consciousness:
    phosphorus → ATP → action potential → consciousness.
    The element that forms DNA's backbone also powers the mind. -/
theorem phosphorus_reaches_consciousness :
    atpReaches (.atp .phosphorus) (.orig .consciousness) = true := by native_decide

/-- Phosphorus reaches protein:
    phosphorus → ATP → protein.
    Or: phosphorus → DNA → gene → protein. -/
theorem phosphorus_reaches_protein :
    atpReaches (.atp .phosphorus) (.orig .protein) = true := by native_decide

/-- Memetic energy reaches memus (it powers the memetic genus). -/
theorem memetic_energy_reaches_memus :
    atpReaches (.atp .memeticEnergy) (.atp .memus) = true := by native_decide

/-- Memetic energy reaches consciousness (attention requires awareness). -/
theorem memetic_energy_reaches_consciousness :
    atpReaches (.atp .memeticEnergy) (.orig .consciousness) = true := by native_decide

-- ── Structural theorems ─────────────────────────────────────────────────

/-- There are exactly 10 ATP-theory concepts. -/
theorem atp_concept_count : ATPConcept.all.length = 10 := by native_decide

/-- The extended ontology has 131 concepts (121 original + 10 ATP). -/
theorem ext_concept_count : ATPExtConcept.all.length = 131 := by native_decide

/-- All energy domains map to ontology concepts in the biology or
    metaphysics clusters. -/
theorem energy_domains_are_bio_or_meta :
    ∀ d : EnergyDomain,
      (energyDomainConcept d).cluster = .biology ∨
      (energyDomainConcept d).cluster = .metaphysics := by
  intro d; cases d <;> simp [energyDomainConcept, Concept.cluster]

/-- Memus is in the culture cluster. -/
theorem memus_is_culture : ATPConcept.memus.cluster = .culture := rfl

/-- ATP is in the biology cluster. -/
theorem atp_is_biology : ATPConcept.atp.cluster = .biology := rfl

/-- All ATP concept names are distinct. -/
theorem atp_names_unique :
    (ATPConcept.all.map ATPConcept.canonicalName).Nodup := by native_decide

-- ============================================================================
-- § 11  Summary
-- ============================================================================

#eval IO.println "═══════════════════════════════════════════════════════"
#eval IO.println " ATP is Ambrosia for the Meme"
#eval IO.println "═══════════════════════════════════════════════════════"
#eval IO.println ""
#eval IO.println "Core analogy: Gene : Meme :: Genus : Memus"
#eval IO.println s!"  rankAnalogy .species = {repr (rankAnalogy .species)}"
#eval IO.println s!"  rankAnalogy .genus   = {repr (rankAnalogy .genus)}"
#eval IO.println ""
#eval IO.println s!"ATP concepts: {ATPConcept.all.length}"
#eval IO.println s!"Total concepts: {ATPExtConcept.all.length}"
#eval IO.println ""
#eval IO.println "Ambrosia status:"
#eval IO.println s!"  ATP (biology):  {atp.name} — powers replicator & classifier"
#eval IO.println s!"  AAT (culture):  {memeticATP.name} — powers replicator & classifier"

end Solfunmeme.ATPAmbrosia
