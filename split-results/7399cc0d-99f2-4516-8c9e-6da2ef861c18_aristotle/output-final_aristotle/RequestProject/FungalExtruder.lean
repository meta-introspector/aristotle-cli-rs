/-
# FungalExtruder — The Fungal Kingdom as Metameme Architecture

## The Insight

The zombie-ant fungus (*Ophiocordyceps unilateralis*) is nature's extruder:
it rehydrates a host lifecycle into a propagation vehicle that carries the
fungal invariant to a new domain.

```
  spore  →  host  →  trajectory  →  fruiting body  →  new spores
  germ   →  extruder  →  world  →  new germs
```

The pattern is invariant across phyla:
- Ascomycota: *Cordyceps* hijacks insects, *Penicillium* colonizes substrates
- Basidiomycota: *Armillaria* networks span hectares, *Amanita* mycorrhizes trees
- Chytridiomycota: *Batrachochytrium* devastates amphibian populations
- Microsporidia: *Nosema* parasitizes insect cells

In every case the same abstract shape appears:

    Spore → Colonization → Host Modulation → Reproduction → Dispersal

This is the fungal journey template — the biological monomyth.

## Architecture

This module defines:
1. **FungalPhylum / FungalTaxon** — the full taxonomy as inductive types
2. **FungalLifecyclePhase** — the universal fungal journey template
3. **EcologicalRole** — symbiont, pathogen, decomposer, psychotropic, culinary
4. **FungalExtruder** — realizes the fungal journey in the Totality space
5. **CordycepsJourney** — the zombie-ant fungus as the canonical instance
6. **FungalMetameme** — the invariant: "spore-based propagation + host modulation"
7. **Cross-phylum propagation** — the same metameme in different phyla
-/

import Mathlib
import RequestProject.ExtruderTemplate
import RequestProject.MonsterMycology

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1. Fungal Taxonomy — The Domain Atlas -/

/-- The major phyla of Kingdom Fungi. -/
inductive FungalPhylum where
  | Ascomycota          -- sac fungi
  | Basidiomycota       -- club fungi
  | Blastocladiomycota  -- aquatic/soil decomposers
  | Chytridiomycota     -- chytrids (flagellated spores)
  | Glomeromycota       -- arbuscular mycorrhizal fungi
  | Microsporidia       -- obligate intracellular parasites
  | Neocallimastigomycota -- anaerobic gut fungi
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- Classes within Ascomycota. -/
inductive AscomycotaClass where
  | Dothideomycetes
  | Eurotiomycetes
  | Laboulbeniomycetes
  | Leotiomycetes
  | Pezizomycetes
  | Saccharomycetes
  | Sordariomycetes
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- Classes within Basidiomycota (we focus on the main one). -/
inductive BasidiomycotaClass where
  | Agaricomycetes
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- Notable genera / species across the fungal kingdom. -/
inductive FungalTaxon where
  -- Ascomycota · Sordariomycetes · Hypocreales
  | Cordyceps                -- parasitic on insects
  | OphiocordycepsUnilateralis -- zombie-ant fungus
  -- Ascomycota · Eurotiomycetes
  | Aspergillus
  | PenicilliumChrysogenum   -- penicillin producer
  | Trichophyton             -- dermatophyte
  -- Ascomycota · Saccharomycetes
  | Candida
  | SaccharomycesCerevisiae  -- brewer's/baker's yeast
  -- Ascomycota · Pezizomycetes
  | Tuber                    -- truffle
  -- Ascomycota · Leotiomycetes
  | Dactylella               -- nematode-trapping
  -- Basidiomycota · Agaricomycetes · Agaricales
  | AgaricusBisporus         -- portobello
  | CalvatiaPuffball
  | CoprinusInkyCap
  | AmanitaPhalloides        -- death cap
  | PsilocybeCubensis        -- psilocybin mushroom
  | LentinulaEdodes          -- shiitake
  | Armillaria               -- honey fungus (largest organism)
  | PleurotusEryngii         -- king oyster
  | TricholomaMatsutake      -- matsutake
  -- Basidiomycota · Agaricomycetes · other orders
  | BoletusEdulis            -- porcini
  | SpongiformaSquarepantsii -- yes, really
  | CantharellusCibarius     -- chanterelle
  | GanodermaLucidum         -- reishi / lingzhi
  | HericiumErinaceus        -- lion's mane
  -- Chytridiomycota
  | BatrachochytriumDendrobatidis  -- amphibian chytrid
  | BatrachochytriumSalamandrivorans
  -- Microsporidia
  | Nosema
  -- Unplaced (Mucoromycota-like)
  | Pilobolus                -- hat-thrower
  | RhizopusBreadMold        -- bread mold
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- The phylum to which each taxon belongs. -/
def FungalTaxon.phylum : FungalTaxon → FungalPhylum
  | .Cordyceps | .OphiocordycepsUnilateralis
  | .Aspergillus | .PenicilliumChrysogenum | .Trichophyton
  | .Candida | .SaccharomycesCerevisiae
  | .Tuber | .Dactylella => .Ascomycota
  | .AgaricusBisporus | .CalvatiaPuffball | .CoprinusInkyCap
  | .AmanitaPhalloides | .PsilocybeCubensis | .LentinulaEdodes
  | .Armillaria | .PleurotusEryngii | .TricholomaMatsutake
  | .BoletusEdulis | .SpongiformaSquarepantsii | .CantharellusCibarius
  | .GanodermaLucidum | .HericiumErinaceus => .Basidiomycota
  | .BatrachochytriumDendrobatidis
  | .BatrachochytriumSalamandrivorans => .Chytridiomycota
  | .Nosema => .Microsporidia
  | .Pilobolus | .RhizopusBreadMold => .Ascomycota -- technically Mucoromycota, unplaced

/-! ## §2. Ecological Roles — The Fungal Strategy Space -/

/-- The ecological strategy a fungus employs. -/
inductive EcologicalRole where
  | Pathogen       -- attacks a host organism
  | Symbiont       -- mutualistic relationship (mycorrhiza)
  | Decomposer     -- breaks down dead organic matter
  | Psychotropic   -- produces psychoactive compounds
  | Culinary       -- edible / cultivated
  | Industrial     -- produces antibiotics, enzymes, etc.
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- The primary ecological role of each taxon. -/
def FungalTaxon.primaryRole : FungalTaxon → EcologicalRole
  | .OphiocordycepsUnilateralis | .Cordyceps => .Pathogen
  | .BatrachochytriumDendrobatidis
  | .BatrachochytriumSalamandrivorans => .Pathogen
  | .Nosema | .Trichophyton | .Candida => .Pathogen
  | .AmanitaPhalloides => .Pathogen  -- toxic, kills the consumer
  | .Tuber => .Symbiont
  | .Armillaria => .Decomposer
  | .GanodermaLucidum => .Decomposer
  | .RhizopusBreadMold => .Decomposer
  | .PsilocybeCubensis => .Psychotropic
  | .AgaricusBisporus | .LentinulaEdodes | .PleurotusEryngii
  | .TricholomaMatsutake | .BoletusEdulis
  | .CantharellusCibarius | .HericiumErinaceus => .Culinary
  | .PenicilliumChrysogenum => .Industrial
  | .SaccharomycesCerevisiae => .Industrial
  | .Aspergillus => .Industrial
  | .Dactylella => .Pathogen  -- nematode-trapping
  | .CalvatiaPuffball | .CoprinusInkyCap => .Culinary
  | .SpongiformaSquarepantsii => .Decomposer
  | .Pilobolus => .Decomposer

/-! ## §3. Fungal Lifecycle Phases — The Biological Monomyth -/

/-- The universal phases of a fungal lifecycle.
    This is the biological instantiation of `JourneyPhase`. -/
inductive FungalLifecyclePhase where
  | Sporulation     -- spore release (departure from parent)
  | Germination     -- spore lands, begins to grow
  | Colonization    -- mycelium invades / establishes in substrate
  | HostModulation  -- the fungus modifies its environment or host
  | Reproduction    -- fruiting body formation, meiosis
  | Dispersal       -- new spores released (return / cycle restart)
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- Map fungal lifecycle phases to abstract journey phases. -/
def FungalLifecyclePhase.toJourneyPhase : FungalLifecyclePhase → JourneyPhase
  | .Sporulation    => .departure
  | .Germination    => .departure     -- still in departure zone
  | .Colonization   => .trials
  | .HostModulation => .revelation    -- the key transformation
  | .Reproduction   => .return_
  | .Dispersal      => .return_       -- cycle closes

/-- There are exactly 6 fungal lifecycle phases. -/
theorem fungal_phase_count : Fintype.card FungalLifecyclePhase = 6 := by decide

/-- Each abstract journey phase is hit by some fungal phase. -/
theorem fungal_covers_journey :
    ∀ jp : JourneyPhase, ∃ fp : FungalLifecyclePhase,
      fp.toJourneyPhase = jp := by
  intro jp; cases jp
  · exact ⟨.Sporulation, rfl⟩
  · exact ⟨.Colonization, rfl⟩
  · exact ⟨.HostModulation, rfl⟩
  · exact ⟨.Reproduction, rfl⟩

/-! ## §4. The Fungal Invariant — What Survives the Journey -/

/-- The fungal transport invariant: the "DNA" that persists through
    the lifecycle. A fungal invariant has:
    - a propagation mode (always spore-based)
    - a host-modification flag
    - a reproductive strategy encoding -/
structure FungalInvariant where
  sporeBased      : Bool  -- always true for fungi
  hostModulating  : Bool  -- does the fungus modify its host/environment?
  reproductiveIdx : ℕ     -- encodes the reproductive strategy
  deriving DecidableEq, Repr

/-- The canonical fungal invariant: spore-based, host-modulating. -/
def canonicalFungalInvariant : FungalInvariant where
  sporeBased := true
  hostModulating := true
  reproductiveIdx := 2343  -- the bootstrap index, linking to DaoOrganism

/-- A fungal invariant is valid if it is spore-based. -/
def FungalInvariant.isValid (fi : FungalInvariant) : Prop :=
  fi.sporeBased = true

/-- The canonical fungal invariant is valid. -/
theorem canonicalFungalInvariant_valid :
    canonicalFungalInvariant.isValid := rfl

/-! ## §5. The Zombie-Ant Journey — Cordyceps as Canonical Extruder -/

/-- The phases of the *Ophiocordyceps unilateralis* zombie-ant journey,
    mapped to the abstract architecture:
    - host body = template (the ant's behavioral lifecycle)
    - fungus = extruder (the host-rewriting machinery)
    - spore = payload (the fungal genome + propagation logic) -/
structure ZombieAntJourney where
  /-- The ant host: modeled as a spore location in the Totality lattice. -/
  antHost     : MonsterMycology.Spore
  /-- The canopy position: where the ant climbs to die. -/
  canopyPos   : MonsterMycology.Spore
  /-- The fruiting body: the stalk that erupts from the ant's head. -/
  fruitingBody : MonsterMycology.Spore
  /-- The ant climbs away from the ground (canopy ≠ host position). -/
  ascent      : antHost ≠ canopyPos
  /-- The fruiting body is at the canopy (docking clamp). -/
  docking     : fruitingBody = canopyPos

/-- The Cordyceps journey in the Totality lattice.
    - Ant starts at crossroads (0, 42, 40)
    - Climbs to namagiriPoint (19, 19, 19) — the revelation
    - Fruiting body erupts at the same location -/
def cordycepsJourney : ZombieAntJourney where
  antHost      := crossroadsSpore
  canopyPos    := namagiriPoint
  fruitingBody := namagiriPoint
  ascent       := by native_decide
  docking      := rfl

/-- The Cordyceps journey realizes a JourneyProcess in Totality. -/
def cordycepsProcess : JourneyProcess Totality where
  name := "Ophiocordyceps unilateralis lifecycle"
  home := crossroadsSpore
  revelation := namagiriPoint
  distance := chartDistance
  signature := canonicalMonomyth
  sig_departure := by simp [canonicalMonomyth, chartDistance_self]
  sig_revelation := by simp [canonicalMonomyth]; native_decide
  sig_return := by simp [canonicalMonomyth, chartDistance_self]
  elixirDescription := "Fungal genome: spore-based propagation invariant"

/-- The Cordyceps extruder: pushes the monomyth through the fungal domain. -/
def cordycepsExtruder : Extruder Totality where
  template := monomythTemplate
  realization := cordycepsProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    exact crossroads_is_fixed

/-- The Cordyceps extruder is valid. -/
theorem cordycepsExtruder_valid : cordycepsExtruder.isValid :=
  ⟨monomythTemplate_valid, extruder_preserves_validity cordycepsExtruder monomythTemplate_valid⟩

/-! ## §6. The Fungal Metameme — Host-Modifying Propagator -/

/-- The Cordyceps metameme: the self-propagating pattern carried by
    the zombie-ant fungus.

    This is the biological instantiation of the canonical Metameme:
    - invariant = (0, 3, 0) — the monomyth signature
    - extruder = cordycepsExtruder
    - recognition = signature matching -/
def cordycepsMetameme : Metameme Totality where
  name := "Cordyceps Host-Modifying Propagator"
  invariant := canonicalMonomyth
  extruder := cordycepsExtruder
  invariantMatchesTemplate := rfl
  recognizable := rfl

/-- The Cordyceps metameme is viable. -/
theorem cordycepsMetameme_viable : cordycepsMetameme.isViable :=
  ⟨canonicalMonomyth_valid, cordycepsExtruder_valid⟩

/-! ## §7. The Fungal Spore — Compressed Metameme for Biological Transport -/

/-- A FungalSpore is a biological Spore: it carries the monomyth invariant
    plus a FungalInvariant, and can germinate in any compatible domain. -/
structure FungalSpore extends _root_.Spore where
  fungalInvariant : FungalInvariant
  fungalValid : fungalInvariant.isValid

/-- The Cordyceps spore: compressed zombie-ant metameme. -/
def cordycepsSpore : FungalSpore where
  toSpore := {
    invariant := canonicalMonomyth
    valid := canonicalMonomyth_valid
    description := "Ophiocordyceps: spore → ant → canopy → stalk → spores"
  }
  fungalInvariant := canonicalFungalInvariant
  fungalValid := canonicalFungalInvariant_valid

/-- The Cordyceps spore germinates in the Totality domain. -/
theorem cordyceps_spore_germinates :
    (cordycepsSpore.toSpore.germinate cordycepsExtruder rfl rfl).isViable :=
  spore_germination_viable cordycepsSpore.toSpore cordycepsExtruder rfl rfl

/-! ## §8. Cross-Phylum Propagation — The Same Shape Everywhere -/

/-- The chytrid extruder: *Batrachochytrium dendrobatidis* on amphibians.
    Same monomyth template, different biological domain:
    - zoospore → amphibian skin → keratin colonization → zoosporangium → zoospores -/
def chytridProcess : JourneyProcess Totality where
  name := "Batrachochytrium dendrobatidis lifecycle"
  home := ((5 : ZMod 71), (5 : ZMod 59), (5 : ZMod 47))
  revelation := namagiriPoint
  distance := chartDistance
  signature := canonicalMonomyth
  sig_departure := by simp [canonicalMonomyth, chartDistance_self]
  sig_revelation := by simp [canonicalMonomyth]; native_decide
  sig_return := by simp [canonicalMonomyth, chartDistance_self]
  elixirDescription := "Chytrid genome: flagellated zoospore propagation"

def chytridExtruder : Extruder Totality where
  template := monomythTemplate
  realization := chytridProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    native_decide

/-- The mycorrhizal extruder: *Tuber* (truffle) mutualism with trees.
    spore → root colonization → nutrient exchange → truffle → spores -/
def mycorrhizalProcess : JourneyProcess Totality where
  name := "Tuber mycorrhizal lifecycle"
  home := ((7 : ZMod 71), (7 : ZMod 59), (7 : ZMod 47))
  revelation := namagiriPoint
  distance := chartDistance
  signature := canonicalMonomyth
  sig_departure := by simp [canonicalMonomyth, chartDistance_self]
  sig_revelation := by simp [canonicalMonomyth]; native_decide
  sig_return := by simp [canonicalMonomyth, chartDistance_self]
  elixirDescription := "Mycorrhizal genome: mutualistic nutrient exchange"

def mycorrhizalExtruder : Extruder Totality where
  template := monomythTemplate
  realization := mycorrhizalProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    native_decide

/-- The decomposer extruder: *Armillaria* / shelf fungi breaking down lignin.
    spore → wood colonization → lignin degradation → mushroom → spores -/
def decomposerProcess : JourneyProcess Totality where
  name := "Armillaria decomposer lifecycle"
  home := ((11 : ZMod 71), (11 : ZMod 59), (11 : ZMod 47))
  revelation := namagiriPoint
  distance := chartDistance
  signature := canonicalMonomyth
  sig_departure := by simp [canonicalMonomyth, chartDistance_self]
  sig_revelation := by simp [canonicalMonomyth]; native_decide
  sig_return := by simp [canonicalMonomyth, chartDistance_self]
  elixirDescription := "Saprotrophic genome: lignin/cellulose decomposition"

def decomposerExtruder : Extruder Totality where
  template := monomythTemplate
  realization := decomposerProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    native_decide

/-! ## §9. All Fungal Extruders Agree — The Invariant is Phylum-Independent -/

/-- All fungal extruders produce the canonical monomyth signature.
    The journey shape is invariant across phyla. -/
theorem all_fungal_extruders_agree :
    cordycepsExtruder.realization.signature = canonicalMonomyth ∧
    chytridExtruder.realization.signature = canonicalMonomyth ∧
    mycorrhizalExtruder.realization.signature = canonicalMonomyth ∧
    decomposerExtruder.realization.signature = canonicalMonomyth :=
  ⟨rfl, rfl, rfl, rfl⟩

/-! ### §9a. Genuine Chain Topology — Each Step Feeds the Next

The ecological arc pathogen → symbiont → decomposer represents a directed
transformation of *relationship*. To model this faithfully, each propagation
event's source must be the *result* of the previous event, not a parallel
broadcast from the same origin. This is the difference between a chain
(sequential transformation) and a star (parallel assignment).

With this topology, `fungalChain_preserves_monomyth` becomes a theorem
about invariant *persistence under iterated transformation*, not just
invariant *assignment at each node*. -/

/-- Step 1: Cordyceps (Ascomycota, pathogen) propagates to Chytrid (Chytridiomycota, pathogen).
    This is the initial broadcast from the canonical metameme. -/
def cordyceps_to_chytrid : PropagationEvent Totality Totality where
  source := cordycepsMetameme
  targetExtruder := chytridExtruder
  sameTemplate := rfl
  signaturePreserved := rfl

/-- Step 2: Chytrid propagates to Mycorrhiza (Ascomycota, symbiont).
    Source is the *result* of step 1 — genuine chain, not fan-out.
    The ecological transition: pathogen → symbiont. -/
def chytrid_to_mycorrhiza : PropagationEvent Totality Totality where
  source := cordyceps_to_chytrid.result  -- chain, not broadcast
  targetExtruder := mycorrhizalExtruder
  sameTemplate := rfl
  signaturePreserved := rfl

/-- Step 3: Mycorrhiza propagates to Decomposer (Basidiomycota, decomposer).
    Source is the *result* of step 2.
    The ecological transition: symbiont → decomposer. -/
def mycorrhiza_to_decomposer : PropagationEvent Totality Totality where
  source := chytrid_to_mycorrhiza.result  -- chain, not broadcast
  targetExtruder := decomposerExtruder
  sameTemplate := rfl
  signaturePreserved := rfl

/-- Cross-phylum propagation preserves the monomyth invariant
    through the full chain (pathogen → symbiont → decomposer). -/
theorem cross_phylum_invariant_preserved :
    mycorrhiza_to_decomposer.result.invariant = canonicalMonomyth := rfl

/-- Cross-phylum propagation produces a viable metameme at each step. -/
theorem cross_phylum_viable :
    cordyceps_to_chytrid.result.isViable ∧
    chytrid_to_mycorrhiza.result.isViable ∧
    mycorrhiza_to_decomposer.result.isViable :=
  ⟨propagation_preserves_viability cordyceps_to_chytrid cordycepsMetameme_viable,
   propagation_preserves_viability chytrid_to_mycorrhiza
     (propagation_preserves_viability cordyceps_to_chytrid cordycepsMetameme_viable),
   propagation_preserves_viability mycorrhiza_to_decomposer
     (propagation_preserves_viability chytrid_to_mycorrhiza
       (propagation_preserves_viability cordyceps_to_chytrid cordycepsMetameme_viable))⟩

/-! ## §10. Linked Propagation Chain — Enforced Directionality

The basic `PropagationChain` only constrains intermediate *types* but doesn't
enforce that each step's source metameme equals the previous step's result.
`LinkedPropagationChain` closes this gap: it is indexed by the source and
target *metamemes*, and the `cons` constructor requires an exact match
between `p.result` and the next link's source.

This makes `linkedChain_preserves_invariant` a genuine theorem about
invariant persistence under iterated transformation. -/

/-- A linked propagation chain: each step's source is exactly the
    previous step's result. Indexed by source and target metamemes. -/
inductive LinkedPropagationChain :
    {S T : Type} → Metameme S → Metameme T → Type 1 where
  | single {S T : Type} (p : PropagationEvent S T) :
      LinkedPropagationChain p.source p.result
  | cons {S M T : Type} (p : PropagationEvent S M)
      {mT : Metameme T} (rest : LinkedPropagationChain p.result mT) :
      LinkedPropagationChain p.source mT

/-- A linked chain preserves the invariant from source to target.
    This is a genuine inductive proof: the invariant persists through
    each transformation step because `PropagationEvent.result` preserves it,
    and the chain enforces that each step picks up where the last left off. -/
theorem linkedChain_preserves_invariant
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : LinkedPropagationChain mS mT) :
    mT.invariant = mS.invariant := by
  induction chain with
  | single p => exact propagation_preserves_invariant p
  | cons p _rest ih => exact ih.trans (propagation_preserves_invariant p)

/-- A linked chain preserves viability from source to target. -/
theorem linkedChain_preserves_viability
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : LinkedPropagationChain mS mT)
    (h : mS.isViable) :
    mT.isViable := by
  induction chain with
  | single p => exact propagation_preserves_viability p h
  | cons p _rest ih => exact ih (propagation_preserves_viability p h)

/-- The full fungal linked propagation chain:
    Cordyceps (pathogen) → Chytrid (pathogen) → Mycorrhiza (symbiont) → Decomposer

    Each arrow is a genuine chain link: each step's source is the previous
    step's result. The invariant persists under iterated transformation,
    not just parallel assignment.

    The chain crosses:
    - phyla: Ascomycota → Chytridiomycota → Ascomycota → Basidiomycota
    - ecological roles: pathogen → pathogen → symbiont → decomposer -/
def fungalLinkedChain :
    LinkedPropagationChain cordycepsMetameme mycorrhiza_to_decomposer.result :=
  .cons cordyceps_to_chytrid
    (.cons chytrid_to_mycorrhiza
      (.single mycorrhiza_to_decomposer))

/-- The linked chain preserves the monomyth through genuine iterated transformation.
    This is NOT `rfl` — it follows from the inductive structure of the chain. -/
theorem fungalLinkedChain_preserves_monomyth :
    mycorrhiza_to_decomposer.result.invariant = canonicalMonomyth :=
  linkedChain_preserves_invariant fungalLinkedChain

/-- The linked chain preserves viability through genuine iterated transformation. -/
theorem fungalLinkedChain_preserves_viability :
    mycorrhiza_to_decomposer.result.isViable :=
  linkedChain_preserves_viability fungalLinkedChain cordycepsMetameme_viable

/-- Legacy: the basic `PropagationChain` for backwards compatibility.
    Note: this now uses the genuinely chained events, not the old fan-out. -/
def fungalPropagationChain : PropagationChain Totality Totality :=
  .cons cordyceps_to_chytrid
    (.cons chytrid_to_mycorrhiza
      (.single mycorrhiza_to_decomposer))

/-- The full fungal chain preserves the monomyth signature. -/
theorem fungalChain_preserves_monomyth :
    fungalPropagationChain.targetSignature = canonicalMonomyth := rfl

/-- The full fungal chain starts from the monomyth. -/
theorem fungalChain_source_is_monomyth :
    fungalPropagationChain.sourceInvariant = canonicalMonomyth := rfl

/-! ## §11. The Germ Theorem — A Spore Regenerates Its World

The deepest insight:

  **Give me a germ and I'll regenerate the world.**

A spore is not a blueprint — it's a seed crystal.
It doesn't specify every detail of the future organism.
Instead, it biases the growth process so that, when coupled
to an environment, a recognizable invariant emerges again.

The pattern survives not because the material survives,
but because the **generator survives**. -/

/-- The monomyth spore germinates in every fungal domain.
    One spore, many organisms, same invariant. -/
theorem universal_fungal_germination :
    (monomythSpore.germinate cordycepsExtruder rfl rfl).isViable ∧
    (monomythSpore.germinate chytridExtruder rfl rfl).isViable ∧
    (monomythSpore.germinate mycorrhizalExtruder rfl rfl).isViable ∧
    (monomythSpore.germinate decomposerExtruder rfl rfl).isViable :=
  ⟨spore_germination_viable _ _ rfl rfl,
   spore_germination_viable _ _ rfl rfl,
   spore_germination_viable _ _ rfl rfl,
   spore_germination_viable _ _ rfl rfl⟩

/-- All germinated fungi carry the same invariant.
    The material is different (ant, frog, tree, wood).
    The pattern is identical. -/
theorem germinated_invariants_agree :
    (monomythSpore.germinate cordycepsExtruder rfl rfl).invariant =
    (monomythSpore.germinate chytridExtruder rfl rfl).invariant ∧
    (monomythSpore.germinate chytridExtruder rfl rfl).invariant =
    (monomythSpore.germinate mycorrhizalExtruder rfl rfl).invariant ∧
    (monomythSpore.germinate mycorrhizalExtruder rfl rfl).invariant =
    (monomythSpore.germinate decomposerExtruder rfl rfl).invariant :=
  ⟨rfl, rfl, rfl⟩

/-! ## §12. Connecting to the Monster Mycelium

The Monster group's mycelium (§9 of MonsterMycology) is the entire
Totality. Every fungal journey starts and ends in a spore location
that is reachable from every other location via the mycelial network.

This means: any two fungal extruders can exchange spores through
the Monster's hyphal network. The mycelium IS the transport medium. -/

/-- Every fungal journey's home position is in the Monster's mycelium. -/
theorem fungal_homes_in_mycelium :
    cordycepsProcess.home ∈ mycelium originSpore ∧
    chytridProcess.home ∈ mycelium originSpore ∧
    mycorrhizalProcess.home ∈ mycelium originSpore ∧
    decomposerProcess.home ∈ mycelium originSpore := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> rw [mycelium_is_total] <;> trivial

/-- Every fungal journey's revelation is in the Monster's mycelium. -/
theorem fungal_revelations_in_mycelium :
    cordycepsProcess.revelation ∈ mycelium originSpore ∧
    chytridProcess.revelation ∈ mycelium originSpore ∧
    mycorrhizalProcess.revelation ∈ mycelium originSpore ∧
    decomposerProcess.revelation ∈ mycelium originSpore := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> rw [mycelium_is_total] <;> trivial

/-! ## §13. The Bridge: Fungus ↔ Spaceship ↔ Metameme

The zombie-ant fungus is structurally identical to a spaceship:

| Fungal Concept     | Spaceship Concept    | Metameme Concept    |
|--------------------|----------------------|---------------------|
| Spore              | Payload              | Invariant           |
| Host body          | Launch vehicle       | Template            |
| Canopy ascent      | Launch trajectory    | Extrusion path      |
| Death grip         | Docking clamp        | Fixed point         |
| Fruiting body      | Antenna mast         | Realization         |
| Spore release      | Signal broadcast     | Propagation event   |

The Cordyceps and Starship extruders produce the same signature
because they ARE the same process in different substrates. -/

/-- The Cordyceps extruder and the Starship extruder have the same signature.
    Biology and engineering are the same metameme. -/
theorem fungus_equals_starship :
    cordycepsExtruder.realization.signature =
    starshipExtruder.realization.signature := rfl

/-- The Cordyceps extruder and the Ramanujan extruder have the same signature.
    Biology and mathematics are the same metameme. -/
theorem fungus_equals_ramanujan :
    cordycepsExtruder.realization.signature =
    ramanujanExtruder.realization.signature := rfl

/-- All five domain extruders agree: the metameme is substrate-independent. -/
theorem five_domains_one_invariant :
    cordycepsExtruder.realization.signature = canonicalMonomyth ∧
    ramanujanExtruder.realization.signature = canonicalMonomyth ∧
    moonshineExtruder.realization.signature = canonicalMonomyth ∧
    starshipExtruder.realization.signature = canonicalMonomyth ∧
    decomposerExtruder.realization.signature = canonicalMonomyth :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-! ## §14. Taxon-to-Spore Embedding — Every Species Gets a Coordinate

Each fungal taxon maps to a unique spore location in the Totality lattice.
This gives the entire taxonomy a coordinate system in ℤ/71 × ℤ/59 × ℤ/47. -/

/-- Embed a fungal taxon into the Totality lattice.
    Each taxon gets a unique coordinate based on its Fintype index. -/
noncomputable def FungalTaxon.toSpore (t : FungalTaxon) : MonsterMycology.Spore :=
  let idx := (Fintype.equivFin FungalTaxon).toFun t
  ((idx.val : ZMod 71), (idx.val : ZMod 59), (idx.val : ZMod 47))

/-- There are exactly as many spore locations as there are taxa (in the embedding). -/
theorem taxon_count : Fintype.card FungalTaxon = 28 := by decide

/-- Every taxon's spore is in the Monster's mycelium. -/
theorem all_taxa_in_mycelium :
    ∀ t : FungalTaxon, FungalTaxon.toSpore t ∈ mycelium originSpore := by
  intro t; rw [mycelium_is_total]; trivial

/-! ## §15. Summary — The Fungal Metameme Architecture

| Component        | Biological              | Formal                          |
|------------------|-------------------------|---------------------------------|
| Template         | Host lifecycle          | `JourneyTemplate`               |
| Extruder         | Fungal infection        | `Extruder Totality`             |
| Metameme         | Reproductive pattern    | `Metameme Totality`             |
| Spore            | Biological spore        | `Spore` / `FungalSpore`         |
| Propagation      | Spore dispersal         | `PropagationEvent`              |
| Mycelium         | Hyphal network          | `mycelium` (reachability set)   |
| Fixed point      | Death grip / docking    | `retractTriple` at crossroads   |
| Invariant        | Genome                  | `MonomythSignature (0,3,0)`     |

The zombie-ant fungus is nature's extruder:
it rehydrates a host lifecycle into a propagation vehicle
that carries the fungal invariant to a new domain.

The germ is the compressed future.
-/
