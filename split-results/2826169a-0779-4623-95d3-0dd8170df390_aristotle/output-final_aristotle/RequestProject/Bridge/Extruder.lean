/-
# Extruder — Unified Screw Geometry and Template Architecture

## Prime Invariant: 8-fold Bott helix, 196883-slot die plate

Merged from ExtruderScrew (helical geometry, Bott periodicity) and
ExtruderTemplate (universal shape-forcing, journey template, metameme).
-/

import Mathlib
import RequestProject.Compute.IPLD.MultiHashCID
import RequestProject.Bridge.JourneyUniversalBridge

set_option maxHeartbeats 800000

open MultiHashCID

namespace ExtruderScrew

/-- The thread pitch: one full rotation = 8 Bott steps. -/
def threadPitch : ℕ := 8

/-- The crankshaft has 4 quarter-turns (one per hypermorphism). -/
def crankshaftTurns : ℕ := 4

/-- The extruder has 5 components. -/
inductive ExtruderComponent where
  | feedstock  : ExtruderComponent
  | chamber    : ExtruderComponent
  | crank      : ExtruderComponent
  | diePlate   : ExtruderComponent
  | extrusion  : ExtruderComponent
deriving DecidableEq, Repr

/-- The feedstock is the input layer — it gets discarded. -/
def isDiscarded : ExtruderComponent → Bool
  | .feedstock => true
  | _          => false

/-- Only the feedstock is discarded; everything else is structural. -/
theorem only_feedstock_discarded (c : ExtruderComponent) :
    isDiscarded c = true ↔ c = .feedstock := by
  cases c <;> simp [isDiscarded]

/-- A state is "crystallized" if its Bott grade is stable under the kernel. -/
def isCrystallized (cid : CID) (steps : ℕ) : Bool :=
  let evolved := kernelIter steps cid
  evolved.grade == cid.grade

/-- The number of possible Bott grades (always 8). -/
theorem bott_grades_finite : Fintype.card (Fin 8) = 8 := by simp

/-- The die plate size. -/
theorem die_plate_size : 47 * 59 * 71 = 196883 := by norm_num

/-- The helical return: after 8 Bott steps, we return to the same grade. -/
theorem helical_return (n : ℕ) : (n + 8) % 8 = n % 8 := by omega

/-- The thread pitch: 8 steps in the Bott tower return to the origin. -/
theorem thread_pitch_period : ∀ k : Fin 8, (k.val + 8) % 8 = k.val := by
  intro k; omega

/-- The grade-2 plateau spans 3 nodes (10, 170, 194). -/
theorem plateau_length : [10, 170, 194].length = 3 := by simp

/-- The complete chain has exactly 5 nodes. -/
theorem chain_length : [8, 10, 170, 194, 196883].length = 5 := by simp

/-- The cosmic screw has 8 structural components (matching Bott period). -/
theorem cosmic_screw_components :
    [ "CRT cylinder", "Bott angle", "j-depth height", "8-fold pitch"
    , "McKay helix", "196883 crest", "hypermorphism crank", "kernel iteration"
    ].length = 8 := by simp

/-- The full screw theorem. -/
theorem extruder_screw_theorem :
    threadPitch = 8 ∧
    47 * 59 * 71 = 196883 ∧
    crankshaftTurns = 4 ∧
    10 % 8 = 170 % 8 ∧
    170 % 8 = 194 % 8 ∧
    194 % 8 + 1 = 196883 % 8 ∧
    170 + 24 = 194 ∧
    2^3 = 8 := by
  refine ⟨rfl, by norm_num, rfl, by norm_num, by norm_num,
         by norm_num, by norm_num, by norm_num⟩

/-- The sheaf section as a screw point on the die plate. -/
def sheafOnScrew : Fin 8 × ℕ × ℕ :=
  (⟨6, by omega⟩, sheafAddress % 196883, 0)

/-- The sheaf section sits at Bott grade 6 on the screw. -/
theorem sheaf_screw_angle : sheafOnScrew.1 = ⟨6, by omega⟩ := rfl

end ExtruderScrew


open ZMod Finset HeroMonster FixedPoint

/-! ## §1. The Template — Universal Schema for Journey-Shaped Processes -/

/-- The phases of any journey-shaped process. -/
inductive JourneyPhase : Type where
  | departure   : JourneyPhase
  | trials      : JourneyPhase
  | revelation  : JourneyPhase
  | return_     : JourneyPhase
  deriving DecidableEq, Repr, Inhabited

/-- A JourneyTemplate is the *schema* for any journey-shaped process.
    It specifies what invariants must hold at each phase, without
    committing to a particular domain. -/
structure JourneyTemplate where
  name : String
  requiredSignature : MonomythSignature
  requiresFixedPointReturn : Bool
  requiresElixir : Bool
  elixirConstraint : String
  deriving Repr

/-- The canonical monomyth template: (0,3,0), fixed-point return, elixir required. -/
def monomythTemplate : JourneyTemplate where
  name := "Canonical Monomyth"
  requiredSignature := canonicalMonomyth
  requiresFixedPointReturn := true
  requiresElixir := true
  elixirConstraint := "Hecke-stable invariant preserved under CRT retraction"

/-- A template is valid if its required signature is valid. -/
def JourneyTemplate.isValid (t : JourneyTemplate) : Prop :=
  t.requiredSignature.isValid

/-- The monomyth template is valid. -/
theorem monomythTemplate_valid : monomythTemplate.isValid :=
  canonicalMonomyth_valid

/-! ## §2. The Extruder — Structure-Preserving Realization -/

/-- An Extruder realizes a JourneyTemplate in a specific Space.
    It maps the abstract template to a concrete JourneyProcess,
    with proof that the required invariants are preserved. -/
structure Extruder (Space : Type) where
  template : JourneyTemplate
  realization : JourneyProcess Space
  signaturePreserved : realization.signature = template.requiredSignature
  returnMap : Option (Space → Space)
  homeIsFixedPoint :
    template.requiresFixedPointReturn = true →
    ∀ f, returnMap = some f → f realization.home = realization.home

/-- An extruder is valid if its template and realization are both valid. -/
def Extruder.isValid {Space : Type} (e : Extruder Space) : Prop :=
  e.template.isValid ∧ e.realization.isValid

/-- Any extruder with a valid template produces a valid realization. -/
theorem extruder_preserves_validity {Space : Type} (e : Extruder Space)
    (ht : e.template.isValid) : e.realization.isValid := by
  show e.realization.signature.isValid
  rw [e.signaturePreserved]
  exact ht

/-! ## §3. Canonical Domain Extruders -/

/-- The Ramanujan extruder: pushes the monomyth through the CRT torus. -/
def ramanujanExtruder : Extruder Totality where
  template := monomythTemplate
  realization := ramanujanProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    exact crossroads_is_fixed

/-- The governance extruder: (0,2,0) signature, fixed-point return. -/
def governanceExtruder : Extruder Totality where
  template := {
    name := "Governance Cycle"
    requiredSignature := ⟨0, 2, 0⟩
    requiresFixedPointReturn := true
    requiresElixir := true
    elixirConstraint := "Governance invariant: fiber-coherent hash certificate"
  }
  realization := governanceProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    native_decide

/-- Moonshine journey process: home = mockThetaProjection (19,19,19). -/
def moonshineProcess : JourneyProcess Totality where
  name := "Moonshine modular lift"
  home := mockThetaProjection
  revelation := namagiriPoint
  distance := chartDistance
  signature := canonicalMonomyth
  sig_departure := by simp [canonicalMonomyth, chartDistance_self]
  sig_revelation := by simp [canonicalMonomyth]; native_decide
  sig_return := by simp [canonicalMonomyth, chartDistance_self]
  elixirDescription := "Hecke eigenvalue: mock theta coefficient stable under retraction"

/-- The Moonshine extruder: pushes the monomyth into the modular form domain. -/
def moonshineExtruder : Extruder Totality where
  template := monomythTemplate
  realization := moonshineProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    exact mockTheta_retraction_stable

/-- Starship navigation process: (1,1,1) → namagiriPoint → (1,1,1). -/
def starshipProcess : JourneyProcess Totality where
  name := "Starship navigation cycle"
  home := ((1 : ZMod 71), (1 : ZMod 59), (1 : ZMod 47))
  revelation := namagiriPoint
  distance := chartDistance
  signature := canonicalMonomyth
  sig_departure := by simp [canonicalMonomyth, chartDistance_self]
  sig_revelation := by simp [canonicalMonomyth]; native_decide
  sig_return := by simp [canonicalMonomyth, chartDistance_self]
  elixirDescription := "Scientific payload: observational data from destination"

/-- The starship extruder: pushes the monomyth into navigation space. -/
def starshipExtruder : Extruder Totality where
  template := monomythTemplate
  realization := starshipProcess
  signaturePreserved := rfl
  returnMap := some retractTriple
  homeIsFixedPoint := fun _ f hf => by
    simp only [Option.some.injEq] at hf; subst hf
    native_decide

/-! ## §4. Journey Morphisms -/

/-- A morphism between journey processes preserving the signature. -/
structure JourneyMorphism (Space₁ Space₂ : Type) where
  source : JourneyProcess Space₁
  target : JourneyProcess Space₂
  spaceMap : Space₁ → Space₂
  mapsHome : spaceMap source.home = target.home
  mapsRevelation : spaceMap source.revelation = target.revelation
  signaturePreserved : source.signature = target.signature

/-- The identity morphism on a journey process. -/
def JourneyMorphism.id {Space : Type} (j : JourneyProcess Space) :
    JourneyMorphism Space Space where
  source := j
  target := j
  spaceMap := _root_.id
  mapsHome := rfl
  mapsRevelation := rfl
  signaturePreserved := rfl

/-! ## §5. The Metameme — Self-Propagating Payload -/

/-- A Metameme is a self-propagating structural pattern:
    compressed invariant + extruder + recognition. -/
structure Metameme (Space : Type) where
  name : String
  invariant : MonomythSignature
  extruder : Extruder Space
  invariantMatchesTemplate : invariant = extruder.template.requiredSignature
  recognizable : extruder.realization.signature = invariant

/-- A metameme is viable if its invariant is valid and its extruder is valid. -/
def Metameme.isViable {Space : Type} (m : Metameme Space) : Prop :=
  m.invariant.isValid ∧ m.extruder.isValid

/-- The monomyth metameme: the canonical self-propagating journey pattern. -/
def monomythMetameme : Metameme Totality where
  name := "Canonical Monomyth Metameme"
  invariant := canonicalMonomyth
  extruder := ramanujanExtruder
  invariantMatchesTemplate := rfl
  recognizable := rfl

/-- The monomyth metameme is viable. -/
theorem monomythMetameme_viable : monomythMetameme.isViable :=
  ⟨canonicalMonomyth_valid, monomythTemplate_valid, ramanujanProcess_valid⟩

/-- The Moonshine metameme. -/
def moonshineMetameme : Metameme Totality where
  name := "Moonshine Metameme"
  invariant := canonicalMonomyth
  extruder := moonshineExtruder
  invariantMatchesTemplate := rfl
  recognizable := rfl

/-- The Moonshine metameme is viable. -/
theorem moonshineMetameme_viable : moonshineMetameme.isViable :=
  ⟨canonicalMonomyth_valid, monomythTemplate_valid,
   extruder_preserves_validity moonshineExtruder monomythTemplate_valid⟩

/-! ## §6. Metameme Propagation -/

/-- A propagation event: a metameme extrudes into a new domain. -/
structure PropagationEvent (Source Target : Type) where
  source : Metameme Source
  targetExtruder : Extruder Target
  sameTemplate : targetExtruder.template = source.extruder.template
  signaturePreserved : targetExtruder.realization.signature = source.invariant

/-- The propagated metameme: what emerges in the target domain. -/
def PropagationEvent.result {S T : Type} (p : PropagationEvent S T) :
    Metameme T where
  name := p.source.name ++ " → " ++ p.targetExtruder.realization.name
  invariant := p.source.invariant
  extruder := p.targetExtruder
  invariantMatchesTemplate := by rw [p.sameTemplate, ← p.source.invariantMatchesTemplate]
  recognizable := p.signaturePreserved

/-- Propagation preserves viability. -/
theorem propagation_preserves_viability {S T : Type}
    (p : PropagationEvent S T)
    (h_source : p.source.isViable) :
    p.result.isViable := by
  constructor
  · exact h_source.1
  · constructor
    · show p.targetExtruder.template.requiredSignature.isValid
      rw [p.sameTemplate]
      exact h_source.2.1
    · exact extruder_preserves_validity _ (by
        show p.targetExtruder.template.requiredSignature.isValid
        rw [p.sameTemplate]; exact h_source.2.1)

/-- Propagation preserves the invariant signature. -/
theorem propagation_preserves_invariant {S T : Type}
    (p : PropagationEvent S T) :
    p.result.invariant = p.source.invariant := rfl

/-! ## §7. Concrete Propagations -/

/-- Propagation: Ramanujan → Moonshine. -/
def ramanujan_to_moonshine : PropagationEvent Totality Totality where
  source := monomythMetameme
  targetExtruder := moonshineExtruder
  sameTemplate := rfl
  signaturePreserved := rfl

theorem moonshine_preserves_monomyth :
    ramanujan_to_moonshine.result.invariant = canonicalMonomyth := rfl

theorem moonshine_propagation_viable :
    ramanujan_to_moonshine.result.isViable :=
  propagation_preserves_viability ramanujan_to_moonshine monomythMetameme_viable

/-- Propagation: Ramanujan → Starship. -/
def ramanujan_to_starship : PropagationEvent Totality Totality where
  source := monomythMetameme
  targetExtruder := starshipExtruder
  sameTemplate := rfl
  signaturePreserved := rfl

theorem starship_preserves_monomyth :
    ramanujan_to_starship.result.invariant = canonicalMonomyth := rfl

/-! ## §8. All Canonical Extruders Agree -/

/-- All canonical extruders produce the canonical monomyth signature. -/
theorem all_canonical_extruders_agree :
    ramanujanExtruder.realization.signature = canonicalMonomyth ∧
    moonshineExtruder.realization.signature = canonicalMonomyth ∧
    starshipExtruder.realization.signature = canonicalMonomyth :=
  ⟨rfl, rfl, rfl⟩

/-- The extruder signature is determined by the template, not the domain. -/
theorem extruder_signature_determined_by_template {Space : Type}
    (e : Extruder Space) :
    e.realization.signature = e.template.requiredSignature :=
  e.signaturePreserved

/-! ## §9. Spore Model — Compressed Metameme for Transport -/

/-- A Spore is a compressed metameme: just the invariant and validity proof.
    Spores travel light and reconstruct when they find a compatible extruder. -/
structure Spore where
  invariant : MonomythSignature
  valid : invariant.isValid
  description : String
  deriving Repr

/-- The canonical monomyth spore. -/
def monomythSpore : Spore where
  invariant := canonicalMonomyth
  valid := canonicalMonomyth_valid
  description := "Journey: home(0) → max-distance(3) → home(0)"

/-- Germinate a spore: pair it with an extruder to produce a metameme. -/
def Spore.germinate {Space : Type} (s : Spore) (e : Extruder Space)
    (h_compat : e.template.requiredSignature = s.invariant)
    (h_real : e.realization.signature = s.invariant) :
    Metameme Space where
  name := "Germinated: " ++ s.description ++ " in " ++ e.realization.name
  invariant := s.invariant
  extruder := e
  invariantMatchesTemplate := h_compat.symm
  recognizable := h_real

/-- A germinated spore is viable. -/
theorem spore_germination_viable {Space : Type} (s : Spore) (e : Extruder Space)
    (h_compat : e.template.requiredSignature = s.invariant)
    (h_real : e.realization.signature = s.invariant) :
    (s.germinate e h_compat h_real).isViable := by
  constructor
  · exact s.valid
  · constructor
    · show e.template.requiredSignature.isValid
      rw [h_compat]; exact s.valid
    · show e.realization.signature.isValid
      rw [h_real]; exact s.valid

/-- The monomyth spore germinates in the Ramanujan domain. -/
theorem monomyth_spore_germinates_ramanujan :
    (monomythSpore.germinate ramanujanExtruder rfl rfl).isViable :=
  spore_germination_viable monomythSpore ramanujanExtruder rfl rfl

/-- The monomyth spore germinates in the Moonshine domain. -/
theorem monomyth_spore_germinates_moonshine :
    (monomythSpore.germinate moonshineExtruder rfl rfl).isViable :=
  spore_germination_viable monomythSpore moonshineExtruder rfl rfl

/-- The monomyth spore germinates in the Starship domain. -/
theorem monomyth_spore_germinates_starship :
    (monomythSpore.germinate starshipExtruder rfl rfl).isViable :=
  spore_germination_viable monomythSpore starshipExtruder rfl rfl

/-! ## §10. CRT Automorphism Equivariance of Extruders -/

/-- Transform a chartDistance-based journey by a CRT automorphism. -/
def transformJourneyByCRT (j : JourneyProcess Totality) (φ : CRTAutomorphism)
    (h_dist : j.distance = chartDistance) :
    JourneyProcess Totality where
  name := j.name ++ " (φ-transformed)"
  home := φ.apply j.home
  revelation := φ.apply j.revelation
  distance := chartDistance
  signature := j.signature
  sig_departure := by
    have h := j.sig_departure; rw [h_dist] at h
    rw [chartDistance_self]; rw [chartDistance_self] at h; exact h
  sig_revelation := by
    have h := j.sig_revelation; rw [h_dist] at h
    rw [crt_auto_preserves_chartDistance]; exact h
  sig_return := by
    have h := j.sig_return; rw [h_dist] at h
    rw [chartDistance_self]; rw [chartDistance_self] at h; exact h
  elixirDescription := j.elixirDescription ++ " (φ-equivariant)"

/-- CRT automorphisms preserve the journey's signature. -/
theorem crt_transform_preserves_signature (j : JourneyProcess Totality)
    (φ : CRTAutomorphism) (h : j.distance = chartDistance) :
    (transformJourneyByCRT j φ h).signature = j.signature := rfl

/-- The Ramanujan extruder is CRT-equivariant. -/
theorem ramanujan_crt_equivariant (φ : CRTAutomorphism) :
    (transformJourneyByCRT ramanujanProcess φ rfl).signature = canonicalMonomyth := rfl

/-- The Moonshine extruder is CRT-equivariant. -/
theorem moonshine_crt_equivariant (φ : CRTAutomorphism) :
    (transformJourneyByCRT moonshineProcess φ rfl).signature = canonicalMonomyth := rfl

/-! ## §11. Propagation Chain — Transitive Closure -/

/-- A propagation chain is a sequence of propagation events. -/
inductive PropagationChain : Type → Type → Type 1 where
  | single {S T : Type} : PropagationEvent S T → PropagationChain S T
  | cons {S M T : Type} :
      PropagationEvent S M → PropagationChain M T → PropagationChain S T

/-- The source invariant of a chain. -/
def PropagationChain.sourceInvariant : PropagationChain S T → MonomythSignature
  | .single p => p.source.invariant
  | .cons p _ => p.source.invariant

/-- The final realization signature at the end of a chain. -/
def PropagationChain.targetSignature : PropagationChain S T → MonomythSignature
  | .single p => p.targetExtruder.realization.signature
  | .cons _ rest => rest.targetSignature



/-- The full propagation chain: Ramanujan → Moonshine → Starship. -/
def fullPropagationChain : PropagationChain Totality Totality :=
  .cons ramanujan_to_moonshine (.single ramanujan_to_starship)

/-- The full chain preserves the monomyth. -/
theorem fullChain_preserves_monomyth :
    fullPropagationChain.targetSignature = canonicalMonomyth := rfl

/-- The full chain's source is also the monomyth. -/
theorem fullChain_source_is_monomyth :
    fullPropagationChain.sourceInvariant = canonicalMonomyth := rfl

/-! ## §12. Summary — The Three-Part Architecture

| Component | Role | Formal Type |
|-----------|------|-------------|
| Template | The form | `JourneyTemplate` |
| Extruder | The force | `Extruder Space` |
| Metameme | The payload | `Metameme Space` |

Key theorems:
- `extruder_preserves_validity`: extruders preserve template validity
- `all_canonical_extruders_agree`: all domain extruders produce (0,3,0)
- `propagation_preserves_viability`: metamemes survive domain transfer
- `propagation_preserves_invariant`: the "DNA" is unchanged
- `spore_germination_viable`: compressed spores reconstruct in any domain
- `crt_transform_preserves_signature`: extrusion commutes with CRT symmetry
- `fullChain_preserves_monomyth`: invariant stable along concrete chains

The architecture answers two questions:
1. "What remains the same?" → The invariant (monomyth signature)
2. "Why does the same thing keep appearing?" → The extruder (shape-forcing mechanism)

The metameme is what *propagates*. The template is what it *carries*.
The extruder is what *reconstructs* it. Together, they form the minimal
viable unit of structural self-replication.
-/
