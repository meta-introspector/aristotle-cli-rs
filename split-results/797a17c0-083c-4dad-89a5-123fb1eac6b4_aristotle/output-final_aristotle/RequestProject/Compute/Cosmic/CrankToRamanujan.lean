import Mathlib
import RequestProject.Compute.Cosmic.Crankmining
import RequestProject.Compute.Cosmic.RamanujanCrankBridge

/-!
# CrankToRamanujan — The Inverse Bridge

This module defines the Crank → Ramanujan reconstruction problem and proves
partial converses for special cranks.
-/

set_option maxHeartbeats 4000000

open Crankmining
open CosmicSynthesis
open DA51PrefixClassification PadicEntropyDAG BottMoonshineExperiment
open FiberedUniverse GradedFiberedUniverse CelestialShell Gearbox UnifiedIPLDMemory
open RamanujanCrankBridge

namespace CrankToRamanujan

/-! ## §1. Crank Signature — The Structural Fingerprint -/

/-- The **signature** of a crank: name, evolution steps, and coordinate.
    The modular weight and Bott class are metadata from the RamanujanObj
    (not stored in the crank itself). -/
structure CrankSignature where
  name : String
  dreamCycles : ℕ
  coordinate : S_ss
  deriving DecidableEq, Repr

/-- Extract a signature from a Crank. -/
def extractSignature (c : Crank) : CrankSignature where
  name := c.name.name
  dreamCycles := c.evolutionSteps
  coordinate := c.coordinate

/-- Extract a signature from a RamanujanObj (via the functor). -/
def objSignature (r : RamanujanObj) : CrankSignature where
  name := r.formulaName
  dreamCycles := r.dreamCycles
  coordinate := monsterHash (ramanujanToCrankName r)

/-! ## §2. Reconstruction Specification -/

/-- A **RamanujanReconstruction** certifies that a Crank was produced from
    a specific RamanujanObj via the ramanujanToCrank functor. -/
structure RamanujanReconstruction (c : Crank) where
  source : RamanujanObj
  produced : c = ramanujanToCrank source

/-- A crank's signature matches a RamanujanObj if name, steps, and coordinate agree. -/
def signatureMatch (c : Crank) (r : RamanujanObj) : Prop :=
  c.name.name = r.formulaName ∧
  c.evolutionSteps = r.dreamCycles ∧
  c.coordinate = monsterHash (ramanujanToCrankName r)

/-! ## §3. Forward Direction: RamanujanObj → Crank → Signature -/

/-- The ramanujanToCrank functor produces a crank whose signature matches the source. -/
theorem forward_signature_match (r : RamanujanObj) :
    signatureMatch (ramanujanToCrank r) r := by
  refine ⟨?_, ?_, ?_⟩
  · simp [ramanujanToCrank, Crank.evolveN_preserves_name, mkCrank, ramanujanToCrankName]
  · exact ramanujanToCrank_steps r
  · exact ramanujanToCrank_preserves_hash r

/-- The forward direction gives a valid reconstruction. -/
def forward_reconstruction (r : RamanujanObj) :
    RamanujanReconstruction (ramanujanToCrank r) where
  source := r
  produced := rfl

/-! ## §4. Partial Converse: Signature Uniqueness for ramanujanDelta -/

/-- The signature of the Δ crank. -/
def deltaSignature : CrankSignature :=
  objSignature ramanujanDelta

/-- If a RamanujanObj has the same name, weight, Bott class, and dream cycles
    as ramanujanDelta, then it IS ramanujanDelta. -/
theorem delta_obj_unique (r : RamanujanObj)
    (hname : r.formulaName = "delta_discriminant")
    (hweight : r.modularWeight = 12)
    (hbott : r.bottClass = ⟨4, by omega⟩)
    (hcycles : r.dreamCycles = 24) :
    r = ramanujanDelta := by
  cases r; simp [ramanujanDelta] at *; exact ⟨hname, hweight, hbott, hcycles⟩

/-- Converse for Δ: if a crank matches the Δ signature, its observable data is determined. -/
theorem delta_signature_unique (c : Crank)
    (hmatch : signatureMatch c ramanujanDelta) :
    c.name.name = ramanujanDelta.formulaName ∧
    c.evolutionSteps = ramanujanDelta.dreamCycles ∧
    c.coordinate = monsterHash (ramanujanToCrankName ramanujanDelta) :=
  hmatch

/-! ## §5. Partial Converse: Signature Uniqueness for Pi Series -/

/-- If a crank matches the pi series signature, its observable data is determined. -/
theorem piSeries_signature_unique (c : Crank)
    (hmatch : signatureMatch c ramanujanPiSeries) :
    c.name.name = ramanujanPiSeries.formulaName ∧
    c.evolutionSteps = ramanujanPiSeries.dreamCycles ∧
    c.coordinate = monsterHash (ramanujanToCrankName ramanujanPiSeries) :=
  hmatch

/-! ## §6. Roundtrip Property -/

/-- The roundtrip: RamanujanObj → Crank → extractSignature recovers the objSignature. -/
theorem roundtrip_signature (r : RamanujanObj) :
    extractSignature (ramanujanToCrank r) = objSignature r := by
  simp [extractSignature, objSignature, ramanujanToCrank,
        Crank.evolveN_preserves_name, Crank.evolveN_preserves_coordinate,
        mkCrank, ramanujanToCrankName, Crank.evolveN_steps]

/-- The roundtrip for ramanujanDelta specifically. -/
theorem roundtrip_delta :
    extractSignature (ramanujanToCrank ramanujanDelta) = deltaSignature :=
  roundtrip_signature ramanujanDelta

/-! ## §7. Weak Uniqueness -/

/-- If two RamanujanObj's produce cranks with the same coordinate,
    then their name hashes agree. -/
theorem coord_determines_hash (r₁ r₂ : RamanujanObj)
    (hcoord : (ramanujanToCrank r₁).coordinate = (ramanujanToCrank r₂).coordinate) :
    monsterHash (ramanujanToCrankName r₁) = monsterHash (ramanujanToCrankName r₂) := by
  rw [← ramanujanToCrank_preserves_hash r₁, ← ramanujanToCrank_preserves_hash r₂]
  exact hcoord

/-- If two RamanujanObj's have the same name AND same dream cycles,
    then the cranks are equal. -/
theorem crank_determined_by_name_and_cycles (r₁ r₂ : RamanujanObj)
    (hname : r₁.formulaName = r₂.formulaName)
    (hcycles : r₁.dreamCycles = r₂.dreamCycles) :
    ramanujanToCrank r₁ = ramanujanToCrank r₂ := by
  simp [ramanujanToCrank, ramanujanToCrankName, hname, hcycles]

end CrankToRamanujan
