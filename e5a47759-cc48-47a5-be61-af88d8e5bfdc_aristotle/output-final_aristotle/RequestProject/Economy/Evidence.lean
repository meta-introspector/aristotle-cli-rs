/-
# Evidence, provenance and paid sampling

A hash gives content integrity and nothing else.  That is stated here as a
theorem *with its hypothesis visible*: `same_bytes_of_same_hash` needs
collision-freedom of the digest on the store, supplied as an argument, and
proves only that the bytes agree — never that the publisher is honest, that the
measurement was correct, or that the content describes the world.

A satellite-to-tonnes conversion is a `CalibratedConversion`: an interval, with
provenance, labelled as an assumption.  Its soundness lemma says the converted
interval encloses the converted value; nothing says the calibration is right.
-/
import RequestProject.Economy.Gluing

namespace RequestProject.Economy

inductive EvidenceKind where
  | governmentStatistic | satelliteObservation | osmFeature | shippingRecord
  | companyFiling | fieldSample | expertEstimate
deriving DecidableEq, Repr

/-- How a number came to be: never conflate these. -/
inductive ObservationStatus where
  | reported | estimated | imputed | modeled | settled | unknown
deriving DecidableEq, Repr

structure Source where
  publisher : String
  title : String
  url : String
  publicationDate : Option String
  retrievedDate : String
deriving DecidableEq, Repr

/-- An immutable evidence artifact.  Licensing is recorded per artifact as
data; whether a given licence permits redistribution is a legal question and is
deliberately not decided here. -/
structure Artifact where
  id : String
  kind : EvidenceKind
  source : Source
  contentHash : String
  licenseName : String
  capturedAt : String
  spatialExtent : Option String
deriving DecidableEq, Repr

/-- A content-addressed store. -/
structure ArtifactStore where
  bytesOf : String → Option (List UInt8)

/-- Collision-freedom of the digest, *on this store* — an assumption about the
hash function, carried as a hypothesis. -/
def CollisionFree (digest : List UInt8 → String) (store : ArtifactStore) : Prop :=
  ∀ b₁ b₂, store.bytesOf (digest b₁) = some b₁ → store.bytesOf (digest b₂) = some b₂ →
    digest b₁ = digest b₂ → b₁ = b₂

/-- **What a hash gives you.** Under collision-freedom, equal digests mean
equal bytes.  It does not mean the bytes are true, authorised or well
measured. -/
theorem same_bytes_of_same_hash {digest : List UInt8 → String} {store : ArtifactStore}
    (hcf : CollisionFree digest store) {b₁ b₂ : List UInt8}
    (h₁ : store.bytesOf (digest b₁) = some b₁) (h₂ : store.bytesOf (digest b₂) = some b₂)
    (heq : digest b₁ = digest b₂) : b₁ = b₂ := hcf b₁ b₂ h₁ h₂ heq

/-- A raw observation, kept separate from any interpretation of it. -/
structure RawObservation where
  artifact : Artifact
  description : String
  location : Option String
  observer : Option String

/-- An interpreted, interval-valued estimate of one cell, with its method, its
epistemic status and the artifacts it rests on. -/
structure Estimate where
  cell : Cell
  interval : Interval
  status : ObservationStatus
  method : String
  provenance : List String

/-- Provenance is complete when the estimate names at least one artifact and
every named artifact is in the dossier. -/
def Estimate.HasProvenance (e : Estimate) (dossier : String → Option Artifact) : Prop :=
  e.provenance ≠ [] ∧ ∀ id ∈ e.provenance, (dossier id).isSome = true

instance (e : Estimate) (dossier : String → Option Artifact) :
    Decidable (e.HasProvenance dossier) := by unfold Estimate.HasProvenance; infer_instance

/-! ### Calibrated conversions -/

/-- A named conversion whose factor is an interval, carries provenance, and is
labelled for what it is: an assumption, not a fact about the world. -/
structure CalibratedConversion (src dst : Dim) where
  name : String
  factor : Interval
  provenance : List String
  assumption : String

namespace CalibratedConversion

variable {a b : Dim}

def apply (c : CalibratedConversion a b) (x : IQty a) : IQty b := ⟨c.factor * x.iv⟩

/-- Conversion is sound: any value in the input interval is carried into the
output interval by any factor in the calibration interval. -/
theorem apply_mem (c : CalibratedConversion a b) {X : IQty a} {f x : ℚ}
    (hf : f ∈ c.factor) (hx : x ∈ X.iv) : f * x ∈ (c.apply X).iv :=
  Interval.mul_mem hf hx

end CalibratedConversion

/-- Satellite acreage times a calibrated yield is a mass estimate whose
interval encloses every product of admissible values.  The estimate's status is
`modeled`, and the conversion's provenance travels with it. -/
def satelliteHarvest (area : IQty Dim.area) (yield : IQty Dim.yield) : IQty Dim.mass :=
  IQty.harvest area yield

theorem satelliteHarvest_mem {A : IQty Dim.area} {Y : IQty Dim.yield}
    {a : Qty Dim.area} {y : Qty Dim.yield} (ha : a ∈ A) (hy : y ∈ Y) :
    Qty.harvest a y ∈ satelliteHarvest A Y := IQty.harvest_mem ha hy

/-! ### Paid field sampling

Payment depends on protocol compliance and timeliness.  That it does *not*
depend on the value reported is a theorem, not a promise.
-/

structure SamplingTask where
  id : String
  description : String
  cell : Cell
  rewardCents : Nat
  protocolVersion : String

structure FieldSubmission where
  task : SamplingTask
  workerId : String
  rawEvidenceHash : String
  observedValue : ℚ
  submittedAt : Int
  protocolChecklist : List Bool

/-- The payment rule: full reward for a complete checklist submitted inside the
window, nothing otherwise. -/
def reward (deadline : Int) (s : FieldSubmission) : Nat :=
  if s.protocolChecklist.all id && decide (s.submittedAt ≤ deadline) then s.task.rewardCents else 0

/-- **Payment is value-blind.** Two submissions to the same task that comply
identically and arrive at the same time are paid the same, whatever they
report. -/
theorem reward_independent_of_value (deadline : Int) (s s' : FieldSubmission)
    (htask : s.task = s'.task) (hlist : s.protocolChecklist = s'.protocolChecklist)
    (htime : s.submittedAt = s'.submittedAt) : reward deadline s = reward deadline s' := by
  simp only [reward, hlist, htime, htask]

/-- A submission that fails the checklist is not paid, however plausible its
number. -/
theorem reward_zero_of_incomplete (deadline : Int) (s : FieldSubmission)
    (h : s.protocolChecklist.all id = false) : reward deadline s = 0 := by
  simp [reward, h]

end RequestProject.Economy
