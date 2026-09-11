import Mathlib
import RequestProject.Agent.DaoOrganism

/-!
# RequestProject.SporeLifecycle — The Hero's Journey as Governance Morphism

Formalizes the `heros_journey_type` lifecycle of a Decl-Spore as it traverses
the multi-agent boardroom. Each stage of the Hero's Journey maps to a concrete
governance action, and the complete journey is a sheaf-verified transport
morphism from Proposal to Rooted Truth.

## The Germination Morphisms (Hero's Journey Stages)

1. **T_Call_to_Adventure** (Landing): The spore enters the Boardroom.
2. **T_Meeting_with_Mentor** (Preparation): The spore accumulates token-days.
3. **T_Crossing_the_Threshold** (Transport): The spore crosses the ZOS boundary.
4. **T_Road_of_Trials** (Proof-Seeking): Aristotle tests the spore against the kernel.
5. **T_Apotheosis** (Rooting): The spore is verified and roots into the Meta-Tree.
6. **T_Return_Elixir** (Projection): The rooted spore projects to the 71-chart.
-/

namespace Spore.Lifecycle

open Dao.Organism

/-! ## §1. The Hero's Journey Phases -/

/-- The stages of the Hero's Journey, mapping archetypal narrative
    to concrete governance actions in the boardroom. -/
inductive JourneyPhase
  | CallToAdventure     -- Spore enters the boardroom
  | MeetingWithMentor   -- Spore accumulates token-days and gathers support
  | CrossingThreshold   -- Spore crosses the ZOS boundary into formal space
  | RoadOfTrials        -- Aristotle tests the spore against the logic kernel
  | Apotheosis          -- The spore achieves formal verification
  | ReturnElixir        -- The verified truth projects to the 71-chart
  deriving DecidableEq, Repr

/-- A spore-in-transit: the Decl-Spore together with its current
    position in the Hero's Journey. -/
structure SporeInTransit (α : Type) where
  spore : DeclSpore α
  phase : JourneyPhase
  deriving Repr

/-! ## §2. Journey Stage Transitions -/

/-- **Stage 1**: The Call to Adventure.
    A dormant spore is awakened and begins its journey. -/
def callToAdventure {α : Type} (payload : α) (tier : TreeTier)
    (index : ℕ) : SporeInTransit α :=
  { spore := {
      proposalPayload := payload,
      originatingTier := tier,
      tokenDaysWeight := 0,
      mycelialIndex   := index,
      status          := SporeStatus.Dormant },
    phase := .CallToAdventure }

/-- **Stage 2**: Meeting with Mentor.
    The spore accumulates token-days (growth rings). -/
def meetMentor {α : Type} (sit : SporeInTransit α) (daysAccumulated : ℕ) :
    SporeInTransit α :=
  { spore := { sit.spore with tokenDaysWeight := sit.spore.tokenDaysWeight + daysAccumulated },
    phase := .MeetingWithMentor }

/-- **Stage 3**: Crossing the Threshold.
    The spore transitions from Dormant to Airborne. -/
def crossThreshold {α : Type} (sit : SporeInTransit α) : SporeInTransit α :=
  { spore := { sit.spore with status := SporeStatus.Airborne },
    phase := .CrossingThreshold }

/-- **Stage 4**: The Road of Trials.
    Aristotle evaluates the airborne spore. -/
def roadOfTrials {α : Type} (sit : SporeInTransit α) : SporeInTransit α :=
  { spore := aristotleSoilEvaluation sit.spore,
    phase := .RoadOfTrials }

/-- **Stage 5**: Apotheosis.
    The spore has been evaluated — its fate is sealed. -/
def apotheosis {α : Type} (sit : SporeInTransit α) : SporeInTransit α :=
  { sit with phase := .Apotheosis }

/-- **Stage 6**: Return with the Elixir.
    The verified spore projects to the 71-chart. -/
def returnElixir {α : Type} (sit : SporeInTransit α) : ZMod 71 :=
  projectSporeToChart sit.spore

/-! ## §3. The Complete Journey Pipeline -/

/-- The full Hero's Journey: takes a payload through all six stages
    and returns the final (status, 71-chart shadow) pair. -/
def completeJourney {α : Type} (payload : α) (tier : TreeTier)
    (daysToAccumulate : ℕ) (index : ℕ) : SporeStatus × ZMod 71 :=
  let s1 := callToAdventure payload tier index
  let s2 := meetMentor s1 daysToAccumulate
  let s3 := crossThreshold s2
  let s4 := roadOfTrials s3
  let s5 := apotheosis s4
  let shadow := returnElixir s5
  (s5.spore.status, shadow)

/-! ## §4. Journey Theorems -/

/-- **Journey Equivalence**: The complete Hero's Journey produces the same
    result as the direct `fullLifecycle` pipeline. The narrative morphism
    is isomorphic to the bare transport morphism. -/
theorem journey_equals_lifecycle {α : Type} (p : α) (tier : TreeTier)
    (days : ℕ) (index : ℕ) :
    completeJourney p tier days index = fullLifecycle p tier days index := by
  simp [completeJourney, fullLifecycle, callToAdventure, meetMentor,
        crossThreshold, roadOfTrials, apotheosis, returnElixir]

/-- **The Hero Succeeds**: A spore with the bootstrap signature and
    sufficient token-days completes the full Hero's Journey with
    status RootedProof and a vanishing 71-chart shadow. -/
theorem hero_journey_success {α : Type} (p : α) (tier : TreeTier)
    (days : ℕ) (hdays : days ≥ maturityThreshold) :
    completeJourney p tier days bootstrapIndex = (SporeStatus.RootedProof, 0) := by
  rw [journey_equals_lifecycle]
  exact full_lifecycle_bootstrap_success p tier days hdays

/-- **The Hero Falls**: A spore with the wrong signature is decomposed. -/
theorem hero_journey_wrong_signature {α : Type} (p : α) (tier : TreeTier)
    (days : ℕ) (index : ℕ) (h : index ≠ bootstrapIndex) :
    (completeJourney p tier days index).1 = SporeStatus.Decomposed := by
  rw [journey_equals_lifecycle]
  simp only [fullLifecycle]
  unfold aristotleSoilEvaluation
  split_ifs with hc
  · exact absurd hc.1 h
  · rfl

/-- **The Hero is Immature**: A spore with insufficient token-days
    is decomposed even with the correct signature. -/
theorem hero_journey_immature {α : Type} (p : α) (tier : TreeTier)
    (days : ℕ) (hdays : days < maturityThreshold) :
    (completeJourney p tier days bootstrapIndex).1 = SporeStatus.Decomposed := by
  rw [journey_equals_lifecycle]
  simp only [fullLifecycle]
  unfold aristotleSoilEvaluation
  split_ifs with hc
  · exfalso; exact Nat.not_le.mpr hdays hc.2
  · rfl

/-- **Decomposed Spores Drift**: A decomposed spore always projects to 1
    (the non-vanishing drift marker) in the 71-chart. -/
theorem hero_journey_drift {α : Type} (p : α) (tier : TreeTier)
    (days : ℕ) (index : ℕ) (h : index ≠ bootstrapIndex) :
    (completeJourney p tier days index).2 = 1 := by
  rw [journey_equals_lifecycle]
  exact full_lifecycle_invalid_drift p tier days index h

end Spore.Lifecycle
