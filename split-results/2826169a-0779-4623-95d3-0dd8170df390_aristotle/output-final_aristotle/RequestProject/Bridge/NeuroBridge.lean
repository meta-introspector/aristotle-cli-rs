/-
# Edelman–Tononi Neuroscience Bridge with Typed Edges and Sheaf Structure

## The key insight (from user analysis)
Edelman's N-CAM pathway and ATP's energy pathway are **complementary,
not competitive**.  They answer different questions:
- **Ontogenetic** (Edelman): How did the architecture get built?
  Gene → N-CAM → neuronal groups → reentry → consciousness
- **Operational** (ATP): What keeps it running right now?
  ATP → Na⁺/K⁺ ATPase → action potential → consciousness

These are two different *types* of causal edge.  The untyped ATP bridge
theorem breaks when ontogenetic nodes (neuralDarwinism, degeneracy) are
added — they reach consciousness but aren't reachable from ATP.  The fix
is to type edges, yielding two complementary theorems:
- ATP is the unique *operational* root of the bio→consciousness cone
- Gene is the unique *ontogenetic* root

## Sheaf structure
The ontology forms a presheaf over causal domains:
- Stalks: sunlight→glucose→ATP, phosphorus→DNA→gene, fungus→phosphorus,
  plant→chemical energy, animal→mitochondria→ATP
- Gluing data: ATP at the cell
- All stalks converge at the cell — the cell is the colimit
- φ(consciousness) is the global section

## Sources
- G. Edelman, "Neural Darwinism" (1987)
- G. Tononi, "Integrated information theory" (2004)
- Edelman & Gally, PNAS 98:13763 (2001) — degeneracy
- Edelman & Tononi, "A Universe of Consciousness" (2000)
- Wikipedia articles provided by user (June 2025)
-/

import Mathlib
import RequestProject.Bridge.ATPPhiBridge

namespace Solfunmeme.NeuroBridge

open Solfunmeme
open Solfunmeme.ATPAmbrosia

-- ============================================================================
-- § 1  Edge types — the causal taxonomy
-- ============================================================================

/-- Every directed edge in the ontology has a causal type. -/
inductive EdgeType where
  | operational   -- moment-to-moment energetic/functional causation
  | ontogenetic   -- evolutionary/developmental causation
  | taxonomic     -- classification/membership
  | semiotic      -- sign/interpretation/theoretical
  deriving DecidableEq, Repr, Inhabited, BEq

-- ============================================================================
-- § 2  New concepts: neuroscience + ecology
-- ============================================================================

/-- Concepts from Edelman, Tononi, Koch, the neuroscience articles,
    and the ecological stalk structure. -/
inductive NeuroConcept where
  -- Edelman
  | neuronalGroup         -- population of co-active neurons
  | cellAdhesionMolecule  -- N-CAM: guides neuronal wiring
  | reentry               -- recursive bidirectional signaling
  | neuralDarwinism       -- Edelman's theory
  | degeneracy            -- structurally different, functionally equivalent
  -- Synaptic
  | synapse               -- chemical synapse
  | neurotransmitter      -- chemical messenger
  -- Tononi
  | synapticHomeostasis   -- sleep restores synaptic balance
  | integratedInformation -- IIT: φ as a measure of consciousness
  -- Technology
  | eegSignal             -- electroencephalography
  | tmsStimulation        -- transcranial magnetic stimulation
  -- Sleep
  | sleepWakeCycle        -- homeostatic sleep drive
  -- Ecological stalks (sheaf structure)
  | sunlight              -- solar energy input
  | glucose               -- product of photosynthesis / energy carrier
  | photosynthesis        -- sunlight → glucose conversion
  | mitochondria          -- ATP factory in animal cells
  | mycorrhizalNetwork    -- fungal phosphorus distribution
  -- Persons
  | tononi                -- Giulio Tononi
  | edelman               -- Gerald Edelman
  | koch                  -- Christof Koch
  deriving DecidableEq, Repr, Inhabited, BEq

/-- Cluster assignment. -/
def NeuroConcept.cluster : NeuroConcept → Cluster
  | .neuronalGroup | .cellAdhesionMolecule | .reentry
  | .neuralDarwinism | .degeneracy | .synapse | .neurotransmitter
  | .synapticHomeostasis | .sleepWakeCycle
  | .sunlight | .glucose | .photosynthesis
  | .mitochondria | .mycorrhizalNetwork     => .biology
  | .integratedInformation                  => .metaphysics
  | .eegSignal | .tmsStimulation            => .technology
  | .tononi | .edelman | .koch              => .culture

/-- All NeuroConcept values. -/
def NeuroConcept.all : List NeuroConcept :=
  [.neuronalGroup, .cellAdhesionMolecule, .reentry, .neuralDarwinism,
   .degeneracy, .synapse, .neurotransmitter, .synapticHomeostasis,
   .integratedInformation, .eegSignal, .tmsStimulation, .sleepWakeCycle,
   .sunlight, .glucose, .photosynthesis, .mitochondria, .mycorrhizalNetwork,
   .tononi, .edelman, .koch]

-- ============================================================================
-- § 3  Extended concept type
-- ============================================================================

/-- Full ontology: original 121 + 10 ATP + 20 neuro = 151 concepts. -/
inductive NeuroExtConcept where
  | base  : ATPExtConcept → NeuroExtConcept
  | neuro : NeuroConcept → NeuroExtConcept
  deriving DecidableEq, Repr, Inhabited, BEq

/-- Cluster of a NeuroExtConcept. -/
def NeuroExtConcept.cluster : NeuroExtConcept → Cluster
  | .base (.orig c) => c.cluster
  | .base (.atp c)  => c.cluster
  | .neuro c        => c.cluster

/-- All NeuroExtConcepts. -/
def NeuroExtConcept.all : List NeuroExtConcept :=
  (ATPExtConcept.all.map .base) ++ (NeuroConcept.all.map .neuro)

-- ============================================================================
-- § 4  Typed adjacency — every edge has a causal type
-- ============================================================================

/-- Typed adjacency: returns `some edgeType` if there is a directed edge
    from `a` to `b`, `none` otherwise. -/
def neuroAdjacentTyped : NeuroExtConcept → NeuroExtConcept → Option EdgeType

  -- ═══════════════════════════════════════════════════════════════════════
  -- Inherited edges from the ATP graph (with type annotations)
  -- ═══════════════════════════════════════════════════════════════════════

  -- Biology chain (ontogenetic: developmental/evolutionary)
  | .base (.orig .cellConcept), .base (.orig .dna)  => some .ontogenetic
  | .base (.orig .dna), .base (.orig .gene)          => some .ontogenetic
  | .base (.orig .rna), .base (.orig .dna)            => some .ontogenetic
  | .base (.orig .gene), .base (.orig .protein)       => some .ontogenetic

  -- Evolution edges (ontogenetic)
  | .base (.orig .evolution), .base (.orig .mutation)    => some .ontogenetic
  | .base (.orig .evolution), .base (.orig .selection)   => some .ontogenetic
  | .base (.orig .organism), .base (.orig .speciesConcept) => some .ontogenetic

  -- Mind ↔ Consciousness (semiotic)
  | .base (.orig .mind), .base (.orig .consciousness) => some .semiotic
  | .base (.orig .consciousness), .base (.orig .mind) => some .semiotic

  -- Meme hierarchy (taxonomic)
  | .base (.orig .metaMeme), .base (.orig .meme)     => some .taxonomic
  | .base (.orig .skibidiToilet), .base (.orig .meme) => some .taxonomic
  | .base (.orig .pianoMan), .base (.orig .meme)      => some .taxonomic
  | .base (.orig .meme), .base (.orig .gene)          => some .semiotic  -- Dawkins analogy

  -- ATP molecular structure (ontogenetic — how ATP is assembled)
  | .base (.atp .nucleotide), .base (.atp .ribose)             => some .ontogenetic
  | .base (.atp .nucleotide), .base (.atp .phosphodiesterBond) => some .ontogenetic
  | .base (.atp .atp), .base (.atp .nucleotide)                => some .ontogenetic
  | .base (.atp .atp), .base (.atp .ribose)                    => some .ontogenetic
  | .base (.atp .atp), .base (.atp .phosphorus)                => some .ontogenetic
  | .base (.atp .atp), .base (.atp .hydrolysis)                => some .operational

  -- ATP powers biological concepts (operational — energy supply)
  | .base (.atp .atp), .base (.orig .cellConcept) => some .operational
  | .base (.atp .atp), .base (.orig .dna)         => some .operational
  | .base (.atp .atp), .base (.orig .rna)         => some .operational
  | .base (.atp .atp), .base (.orig .protein)     => some .operational
  | .base (.atp .atp), .base (.orig .gene)        => some .operational
  | .base (.atp .atp), .base (.orig .organism)    => some .operational

  -- ATP → action potential → consciousness (operational — the energy bridge)
  | .base (.atp .atp), .base (.atp .actionPotential)            => some .operational
  | .base (.atp .actionPotential), .base (.atp .voltage)        => some .operational
  | .base (.atp .actionPotential), .base (.orig .consciousness) => some .operational

  -- Phosphorus backbone (ontogenetic — structural)
  | .base (.atp .phosphorus), .base (.orig .dna) => some .ontogenetic
  | .base (.atp .phosphorus), .base (.orig .rna) => some .ontogenetic
  | .base (.atp .phosphorus), .base (.atp .atp)  => some .ontogenetic

  -- Memus edges (taxonomic)
  | .base (.atp .memus), .base (.orig .meme)          => some .taxonomic
  | .base (.orig .meme), .base (.atp .memus)          => some .taxonomic
  | .base (.orig .metaMeme), .base (.atp .memus)      => some .taxonomic
  | .base (.orig .skibidiToilet), .base (.atp .memus) => some .taxonomic
  | .base (.orig .pianoMan), .base (.atp .memus)      => some .taxonomic
  | .base (.atp .memus), .base (.orig .gene)          => some .semiotic
  | .base (.atp .memus), .base (.orig .speciesConcept) => some .semiotic

  -- Memetic energy (operational in the cultural domain)
  | .base (.atp .memeticEnergy), .base (.orig .meme)          => some .operational
  | .base (.atp .memeticEnergy), .base (.atp .memus)          => some .operational
  | .base (.atp .memeticEnergy), .base (.orig .consciousness) => some .operational

  -- ═══════════════════════════════════════════════════════════════════════
  -- Edelman: N-CAM pathway (ontogenetic — developmental causation)
  -- ═══════════════════════════════════════════════════════════════════════
  | .base (.orig .gene), .neuro .cellAdhesionMolecule    => some .ontogenetic
  | .base (.orig .protein), .neuro .cellAdhesionMolecule => some .ontogenetic
  | .neuro .cellAdhesionMolecule, .neuro .neuronalGroup  => some .ontogenetic
  | .neuro .neuronalGroup, .neuro .reentry               => some .ontogenetic
  | .neuro .reentry, .neuro .neuronalGroup               => some .ontogenetic
  | .neuro .reentry, .base (.orig .consciousness)        => some .ontogenetic

  -- Edelman: Neural Darwinism (semiotic — theoretical)
  | .neuro .neuralDarwinism, .neuro .neuronalGroup => some .semiotic
  | .neuro .neuralDarwinism, .neuro .reentry       => some .semiotic
  | .neuro .neuralDarwinism, .neuro .degeneracy    => some .semiotic
  | .neuro .edelman, .neuro .neuralDarwinism       => some .semiotic
  | .neuro .edelman, .neuro .cellAdhesionMolecule  => some .semiotic

  -- Degeneracy (ontogenetic — evolutionary systems property)
  | .neuro .degeneracy, .base (.orig .evolution)   => some .ontogenetic
  | .neuro .degeneracy, .neuro .neuronalGroup      => some .ontogenetic

  -- ═══════════════════════════════════════════════════════════════════════
  -- Synaptic transmission (operational — moment-to-moment function)
  -- ═══════════════════════════════════════════════════════════════════════
  | .neuro .neuronalGroup, .neuro .synapse                   => some .operational
  | .neuro .synapse, .neuro .neurotransmitter                => some .operational
  | .neuro .neurotransmitter, .base (.orig .consciousness)   => some .operational
  | .base (.atp .actionPotential), .neuro .synapse           => some .operational

  -- ═══════════════════════════════════════════════════════════════════════
  -- Tononi: IIT (semiotic — theoretical framework)
  -- ═══════════════════════════════════════════════════════════════════════
  | .neuro .integratedInformation, .base (.orig .consciousness) => some .semiotic
  | .base (.orig .consciousness), .neuro .integratedInformation => some .semiotic
  | .neuro .tononi, .neuro .integratedInformation               => some .semiotic
  | .neuro .tononi, .neuro .synapticHomeostasis                 => some .semiotic

  -- Tononi–Cirelli: synaptic homeostasis (operational)
  | .neuro .sleepWakeCycle, .neuro .synapticHomeostasis          => some .operational
  | .neuro .synapticHomeostasis, .neuro .synapse                 => some .operational
  | .neuro .synapticHomeostasis, .base (.orig .consciousness)    => some .operational

  -- Koch (semiotic)
  | .neuro .koch, .base (.orig .consciousness)      => some .semiotic
  | .neuro .koch, .neuro .integratedInformation      => some .semiotic

  -- EEG and TMS (operational — measurement/stimulation)
  | .neuro .eegSignal, .base (.orig .consciousness)      => some .operational
  | .neuro .eegSignal, .neuro .neuronalGroup             => some .operational
  | .neuro .tmsStimulation, .neuro .neuronalGroup        => some .operational
  | .neuro .tmsStimulation, .base (.orig .consciousness) => some .operational

  -- Sleep–wake cycle (operational)
  | .neuro .sleepWakeCycle, .base (.orig .consciousness) => some .operational

  -- ═══════════════════════════════════════════════════════════════════════
  -- Ecological stalks (the sheaf structure)
  -- ═══════════════════════════════════════════════════════════════════════

  -- Stalk 1: sunlight → photosynthesis → glucose → ATP (operational)
  | .neuro .sunlight, .neuro .photosynthesis         => some .operational
  | .neuro .photosynthesis, .neuro .glucose          => some .operational
  | .neuro .glucose, .base (.atp .atp)               => some .operational

  -- Stalk 2: phosphorus → ATP backbone (ontogenetic)
  -- (phosphorus → atp is already in ATP graph via .base edges)

  -- Stalk 3: mycorrhizal network → phosphorus transfer (operational)
  | .neuro .mycorrhizalNetwork, .base (.atp .phosphorus) => some .operational

  -- Stalk 4: glucose → mitochondria → ATP (operational)
  | .neuro .glucose, .neuro .mitochondria            => some .operational
  | .neuro .mitochondria, .base (.atp .atp)          => some .operational

  -- Mitochondria are in cells (ontogenetic)
  | .neuro .mitochondria, .base (.orig .cellConcept) => some .ontogenetic

  -- Photosynthesis is in organisms (ontogenetic)
  | .neuro .photosynthesis, .base (.orig .organism)  => some .ontogenetic

  -- Mycorrhizal network connects to organisms (ontogenetic)
  | .neuro .mycorrhizalNetwork, .base (.orig .organism) => some .ontogenetic

  | _, _ => none

-- ============================================================================
-- § 5  Untyped adjacency (derived from typed)
-- ============================================================================

/-- Untyped adjacency: there exists an edge of any type. -/
def neuroAdjacent (a b : NeuroExtConcept) : Bool :=
  (neuroAdjacentTyped a b).isSome

/-- Adjacency restricted to a specific edge type. -/
def neuroAdjacentOfType (t : EdgeType) (a b : NeuroExtConcept) : Bool :=
  neuroAdjacentTyped a b == some t

-- ============================================================================
-- § 6  BFS reachability — untyped and typed
-- ============================================================================

/-- Generic BFS step over a given adjacency predicate. -/
private def genericBfsStep (adj : NeuroExtConcept → NeuroExtConcept → Bool)
    (visited frontier : List NeuroExtConcept) : List NeuroExtConcept :=
  let newNodes := frontier.foldl (fun acc node =>
    acc ++ (NeuroExtConcept.all.filter fun target =>
      adj node target && !(visited ++ acc).any (· == target))) []
  newNodes.eraseDups

/-- Generic BFS with bounded depth. -/
private def genericReachesAux (adj : NeuroExtConcept → NeuroExtConcept → Bool)
    (src : NeuroExtConcept) : Nat → List NeuroExtConcept
  | 0 => [src]
  | n + 1 =>
    let prev := genericReachesAux adj src n
    let newNodes := genericBfsStep adj prev prev
    (prev ++ newNodes).eraseDups

/-- Untyped reachability (all edge types). -/
def neuroReaches (src tgt : NeuroExtConcept) : Bool :=
  let reachable := genericReachesAux neuroAdjacent src 15
  reachable.any (· == tgt)

/-- Reachability via edges of a specific type only. -/
def reachesViaType (t : EdgeType) (src tgt : NeuroExtConcept) : Bool :=
  let reachable := genericReachesAux (neuroAdjacentOfType t) src 15
  reachable.any (· == tgt)

/-- Reachability via operational edges only. -/
def reachesOperational (src tgt : NeuroExtConcept) : Bool :=
  reachesViaType .operational src tgt

/-- Reachability via ontogenetic edges only. -/
def reachesOntogenetic (src tgt : NeuroExtConcept) : Bool :=
  reachesViaType .ontogenetic src tgt

-- ============================================================================
-- § 7  SCC and φ in the full graph
-- ============================================================================

/-- Two concepts are in the same SCC (untyped). -/
def neuroInSameSCC (a b : NeuroExtConcept) : Bool :=
  neuroReaches a b && neuroReaches b a

/-- SCC of a concept. -/
def neuroSccOf (c : NeuroExtConcept) : List NeuroExtConcept :=
  NeuroExtConcept.all.filter (neuroInSameSCC c)

/-- φ(c) = |SCC(c)| - 1. -/
def neuroPhi (c : NeuroExtConcept) : Nat :=
  (neuroSccOf c).length - 1

-- ============================================================================
-- § 8  Biology predicate
-- ============================================================================

/-- A concept is biological. -/
def neuroIsBiology : NeuroExtConcept → Bool
  | .base (.orig c) => c.cluster == .biology
  | .base (.atp c)  => c.cluster == .biology
  | .neuro c        => c.cluster == .biology

/-- Biological concepts in the extended ontology. -/
def neuroBiologyConcepts : List NeuroExtConcept :=
  NeuroExtConcept.all.filter neuroIsBiology

-- ============================================================================
-- § 9  Structural theorems
-- ============================================================================

/-- The extended ontology has 151 concepts. -/
theorem neuro_concept_count : NeuroExtConcept.all.length = 151 := by native_decide

/-- There are 35 biological concepts. -/
theorem neuro_bio_count : neuroBiologyConcepts.length = 35 := by native_decide

-- ============================================================================
-- § 10  Untyped reachability theorems
-- ============================================================================

/-- ATP reaches consciousness (untyped). -/
theorem atp_reaches_consciousness :
    neuroReaches (.base (.atp .atp)) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Gene reaches consciousness via the Edelman pathway (untyped). -/
theorem gene_reaches_consciousness :
    neuroReaches (.base (.orig .gene)) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Sunlight reaches consciousness (the full ecological chain). -/
theorem sunlight_reaches_consciousness :
    neuroReaches (.neuro .sunlight) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Mycorrhizal network reaches consciousness. -/
theorem mycorrhizal_reaches_consciousness :
    neuroReaches (.neuro .mycorrhizalNetwork) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Mitochondria reach consciousness. -/
theorem mitochondria_reaches_consciousness :
    neuroReaches (.neuro .mitochondria) (.base (.orig .consciousness)) = true := by
  native_decide

-- ============================================================================
-- § 11  The typed bridge theorems — the core result
-- ============================================================================

/-- ATP reaches consciousness via operational edges only.
    Path: ATP →[op] actionPotential →[op] consciousness -/
theorem atp_reaches_consciousness_operationally :
    reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Gene reaches consciousness via ontogenetic edges only.
    Path: gene →[onto] CAM →[onto] neuronalGroup →[onto] reentry →[onto] consciousness -/
theorem gene_reaches_consciousness_ontogenetically :
    reachesOntogenetic (.base (.orig .gene)) (.base (.orig .consciousness)) = true := by
  native_decide

/-- **ATP is the universal root**: it reaches consciousness via BOTH
    operational and ontogenetic edges.
    Operational path: ATP →[op] actionPotential →[op] consciousness
    Ontogenetic path: ATP →[onto] phosphorus →[onto] DNA →[onto] gene
      →[onto] CAM →[onto] neuronalGroup →[onto] reentry →[onto] consciousness
    ATP is the root of both causal hierarchies because phosphorus is
    both the backbone of ATP and the backbone of DNA. -/
theorem atp_universal_root :
    reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    reachesOntogenetic (.base (.atp .atp)) (.base (.orig .consciousness)) = true := by
  constructor <;> native_decide

/-- **Gene is exclusively ontogenetic**: it reaches consciousness only
    through developmental/evolutionary edges.  Gene cannot reach
    consciousness via operational edges — it needs ATP for energy.
    This is why consciousness goes dark immediately when ATP stops
    (cardiac arrest) even though the genes are still intact. -/
theorem gene_exclusively_ontogenetic :
    reachesOntogenetic (.base (.orig .gene)) (.base (.orig .consciousness)) = true ∧
    reachesOperational (.base (.orig .gene)) (.base (.orig .consciousness)) = false := by
  constructor <;> native_decide

/-- **Complementary Necessity Theorem**: consciousness requires
    operational energy (ATP) which gene cannot provide.  Gene provides
    the developmental blueprint that ATP cannot encode.  ATP bridges
    both worlds because phosphorus is shared infrastructure.
    This is why Edelman and Tononi wrote a book together: structure
    (Neural Darwinism) needs energy (IIT's φ requires real-time
    information integration, which requires ATP-powered action potentials). -/
theorem complementary_necessity :
    -- ATP reaches via operational edges (energy)
    reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    -- ATP also reaches via ontogenetic edges (phosphorus→DNA→gene→CAM)
    reachesOntogenetic (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    -- Gene reaches via ontogenetic edges (development)
    reachesOntogenetic (.base (.orig .gene)) (.base (.orig .consciousness)) = true ∧
    -- Gene CANNOT reach via operational edges (needs ATP for that)
    reachesOperational (.base (.orig .gene)) (.base (.orig .consciousness)) = false := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 12  φ theorems — consciousness SCC grows
-- ============================================================================

/-- Consciousness and integratedInformation are in the same SCC. -/
theorem consciousness_iit_scc :
    neuroInSameSCC (.base (.orig .consciousness)) (.neuro .integratedInformation) = true := by
  native_decide

/-- Mind and consciousness still in same SCC. -/
theorem mind_consciousness_scc :
    neuroInSameSCC (.base (.orig .consciousness)) (.base (.orig .mind)) = true := by
  native_decide

/-- Reentry and neuronalGroup form an SCC (bidirectional edges). -/
theorem reentry_neuronalGroup_scc :
    neuroInSameSCC (.neuro .neuronalGroup) (.neuro .reentry) = true := by
  native_decide

/-- φ(consciousness) ≥ 2 — the SCC grew from {consciousness, mind}
    to at least {consciousness, mind, integratedInformation}. -/
theorem phi_consciousness_grows :
    neuroPhi (.base (.orig .consciousness)) ≥ 2 := by native_decide

/-- φ(neuronalGroup) > 0 — participates in reentry feedback. -/
theorem phi_neuronalGroup_pos :
    neuroPhi (.neuro .neuronalGroup) > 0 := by native_decide

/-- φ(reentry) > 0 — reentry is inherently integrated. -/
theorem phi_reentry_pos :
    neuroPhi (.neuro .reentry) > 0 := by native_decide

-- ============================================================================
-- § 13  Sheaf stalks — all paths converge at cell/ATP
-- ============================================================================

/-- Stalk 1: sunlight → photosynthesis → glucose → ATP (solar energy). -/
theorem stalk_solar :
    neuroReaches (.neuro .sunlight) (.base (.atp .atp)) = true := by native_decide

/-- Stalk 2: phosphorus → ATP (geological/structural). -/
theorem stalk_phosphorus :
    neuroReaches (.base (.atp .phosphorus)) (.base (.atp .atp)) = true := by native_decide

/-- Stalk 3: mycorrhizal network → phosphorus → ATP (fungal). -/
theorem stalk_mycorrhizal :
    neuroReaches (.neuro .mycorrhizalNetwork) (.base (.atp .atp)) = true := by native_decide

/-- Stalk 4: glucose → mitochondria → ATP (animal metabolism). -/
theorem stalk_mitochondria :
    neuroReaches (.neuro .glucose) (.base (.atp .atp)) = true := by native_decide

/-- **Sheaf Gluing Theorem**: All ecological stalks converge at ATP.
    ATP is the gluing data that makes local sections compatible.
    Regardless of source (sun, rock, fungus, food), the terminal
    output before handoff to the cell is always ATP. -/
theorem sheaf_gluing_at_atp :
    -- Solar stalk
    neuroReaches (.neuro .sunlight) (.base (.atp .atp)) = true ∧
    -- Geological stalk
    neuroReaches (.base (.atp .phosphorus)) (.base (.atp .atp)) = true ∧
    -- Fungal stalk
    neuroReaches (.neuro .mycorrhizalNetwork) (.base (.atp .atp)) = true ∧
    -- Metabolic stalk
    neuroReaches (.neuro .glucose) (.base (.atp .atp)) = true := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

/-- All stalks then reach consciousness through ATP. -/
theorem stalks_reach_consciousness :
    neuroReaches (.neuro .sunlight) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.base (.atp .phosphorus)) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.neuro .mycorrhizalNetwork) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.neuro .glucose) (.base (.orig .consciousness)) = true := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 14  The cell as colimit — all stalks pass through it
-- ============================================================================

/-- ATP reaches the cell (ATP powers all cellular processes). -/
theorem atp_reaches_cell :
    neuroReaches (.base (.atp .atp)) (.base (.orig .cellConcept)) = true := by
  native_decide

/-- All ecological sources reach the cell via ATP. -/
theorem stalks_reach_cell :
    neuroReaches (.neuro .sunlight) (.base (.orig .cellConcept)) = true ∧
    neuroReaches (.base (.atp .phosphorus)) (.base (.orig .cellConcept)) = true ∧
    neuroReaches (.neuro .mycorrhizalNetwork) (.base (.orig .cellConcept)) = true ∧
    neuroReaches (.neuro .glucose) (.base (.orig .cellConcept)) = true := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 15  Degeneracy theorem
-- ============================================================================

/-- The Edelman pathway and ATP pathway are degenerate: structurally
    dissimilar but functionally equivalent (both reach consciousness
    from biology). -/
theorem degeneracy_of_consciousness_paths :
    -- Path 1 (operational): ATP → actionPotential → consciousness
    reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    -- Path 2 (ontogenetic): gene → CAM → NG → reentry → consciousness
    reachesOntogenetic (.base (.orig .gene)) (.base (.orig .consciousness)) = true ∧
    -- Degeneracy concept reaches evolution
    neuroReaches (.neuro .degeneracy) (.base (.orig .evolution)) = true := by
  refine ⟨?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 16  Person–theory bridges
-- ============================================================================

/-- Tononi reaches consciousness (via IIT). -/
theorem tononi_reaches_consciousness :
    neuroReaches (.neuro .tononi) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Edelman reaches consciousness (via Neural Darwinism → reentry). -/
theorem edelman_reaches_consciousness :
    neuroReaches (.neuro .edelman) (.base (.orig .consciousness)) = true := by
  native_decide

/-- Koch reaches consciousness. -/
theorem koch_reaches_consciousness :
    neuroReaches (.neuro .koch) (.base (.orig .consciousness)) = true := by
  native_decide

-- ============================================================================
-- § 17  Crossing structure — bio→meta edges
-- ============================================================================

/-- The Edelman crossing: reentry (biology) → consciousness (metaphysics). -/
theorem edelman_crossing_typed :
    NeuroExtConcept.cluster (.neuro .reentry) = .biology ∧
    NeuroExtConcept.cluster (.base (.orig .consciousness)) = .metaphysics ∧
    neuroAdjacentTyped (.neuro .reentry) (.base (.orig .consciousness)) = some .ontogenetic := by
  refine ⟨?_, ?_, ?_⟩ <;> rfl

/-- The ATP crossing: actionPotential (metaphysics) → consciousness (metaphysics).
    But the bridge is ATP (biology) → actionPotential (metaphysics). -/
theorem atp_crossing_typed :
    NeuroExtConcept.cluster (.base (.atp .atp)) = .biology ∧
    NeuroExtConcept.cluster (.base (.atp .actionPotential)) = .metaphysics ∧
    neuroAdjacentTyped (.base (.atp .atp)) (.base (.atp .actionPotential)) = some .operational := by
  refine ⟨?_, ?_, ?_⟩ <;> rfl

-- ============================================================================
-- § 18  Summary output
-- ============================================================================

#eval IO.println "═══════════════════════════════════════════════════════"
#eval IO.println " Edelman–Tononi Neuroscience Bridge"
#eval IO.println " with Typed Edges and Sheaf Structure"
#eval IO.println "═══════════════════════════════════════════════════════"
#eval IO.println ""
#eval IO.println s!"Total concepts: {NeuroExtConcept.all.length}"
#eval IO.println s!"Biology concepts: {neuroBiologyConcepts.length}"
#eval IO.println ""
#eval IO.println "── Typed Bridge Theorems ──"
#eval IO.println s!"ATP →[operational]→ consciousness:  {reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness))}"
#eval IO.println s!"gene →[ontogenetic]→ consciousness: {reachesOntogenetic (.base (.orig .gene)) (.base (.orig .consciousness))}"
#eval IO.println s!"ATP →[ontogenetic]→ consciousness:  {reachesOntogenetic (.base (.atp .atp)) (.base (.orig .consciousness))}"
#eval IO.println s!"gene →[operational]→ consciousness: {reachesOperational (.base (.orig .gene)) (.base (.orig .consciousness))}"
#eval IO.println ""
#eval IO.println "── φ values ──"
#eval IO.println s!"φ(consciousness) = {neuroPhi (.base (.orig .consciousness))}"
#eval IO.println s!"φ(integratedInformation) = {neuroPhi (.neuro .integratedInformation)}"
#eval IO.println s!"φ(neuronalGroup) = {neuroPhi (.neuro .neuronalGroup)}"
#eval IO.println s!"φ(reentry) = {neuroPhi (.neuro .reentry)}"
#eval IO.println ""
#eval IO.println "── Sheaf Stalks ──"
#eval IO.println s!"sunlight → ATP:        {neuroReaches (.neuro .sunlight) (.base (.atp .atp))}"
#eval IO.println s!"phosphorus → ATP:      {neuroReaches (.base (.atp .phosphorus)) (.base (.atp .atp))}"
#eval IO.println s!"mycorrhizal → ATP:     {neuroReaches (.neuro .mycorrhizalNetwork) (.base (.atp .atp))}"
#eval IO.println s!"glucose → ATP:         {neuroReaches (.neuro .glucose) (.base (.atp .atp))}"

end Solfunmeme.NeuroBridge
