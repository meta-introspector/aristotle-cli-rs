/-
# Dark Forest: LMFDB Edition — Zero-Knowledge Proof Interface

This file formalizes the **ZK circuit interface** for the game, going beyond
an abstract commitment scheme to model SNARK-shaped proof objects and
verification. The key structures are:

- `SNARKProof`: an opaque proof object carrying public inputs
- `ZKVerifier`: a verifier with soundness: verification implies the validity
  predicate holds for the claimed public inputs (i.e. ∃ private witnesses
  satisfying the circuit relation)
- `MovePublicInput`: the public inputs to the movement ZK circuit
- `MovePublicInput.Valid`: the validity predicate (∃ path, witnesses, etc.)
- `BSDCertificate`: a certificate for BSD verification with rank evidence

**Soundness model**: The verifier accepts a proof `π` only if the public inputs
`π.claim` satisfy a validity predicate `Valid`. For movement, this means:
there exist private witnesses (j-invariants, a path) such that the path is
valid in the isogeny graph and the fuel cost is bounded. The actual path and
endpoints are never revealed — only their hashes appear as public inputs.
-/

import Mathlib
import RequestProject.DarkForest.IsogenyGraph
import RequestProject.DarkForest.ResourceModel

/-! ## SNARK Proof Objects -/

/-- A **SNARK proof** is an opaque object that attests to the truth of a
    statement about some public inputs.
    The `PublicInput` type parameter is the type of public inputs to the circuit.
    In a real system, `proofData` would be group elements or bytes;
    here we model it abstractly with a soundness guarantee. -/
structure SNARKProof (PublicInput : Type*) where
  /-- The public inputs to the circuit (visible to the verifier) -/
  claim : PublicInput
  /-- Opaque proof data (in a real SNARK, this is a group element / byte string) -/
  proofData : ℕ

/-- A **ZK verifier** checks SNARK proofs with a soundness guarantee.

    The `Valid` predicate captures the circuit relation: `Valid x` means
    "there exist private witnesses such that the circuit is satisfied
    for public input `x`."

    **Soundness**: if `verify` accepts proof `π`, then `Valid π.claim` holds —
    the claimed public inputs genuinely satisfy the circuit relation.
    This models the computational soundness / knowledge-extraction
    property of a SNARK. -/
class ZKVerifier (PublicInput : Type*) (Valid : outParam (PublicInput → Prop)) where
  /-- Deterministic verification function -/
  verify : SNARKProof PublicInput → Bool
  /-- **Soundness**: if the verifier accepts, the public inputs satisfy
      the validity predicate. In particular, this guarantees the existence
      of private witnesses (path, j-invariants) without revealing them. -/
  soundness : ∀ (π : SNARKProof PublicInput), verify π = true → Valid π.claim

/-! ## Movement Circuit -/

/-- The **public inputs** to the movement ZK circuit.
    These are visible on-chain; the private witnesses (actual j-invariants,
    path) are hidden by the proof. -/
structure MovePublicInput where
  /-- Hash of the source position (public input) -/
  srcHash : ℕ
  /-- Hash of the destination position (public input) -/
  dstHash : ℕ
  /-- Fuel cost of the move (public input) -/
  fuelCost : ℕ

/-- The **validity predicate** for the movement circuit.
    `MovePublicInput.Valid F input` asserts:
    there exist private witnesses — source and destination j-invariants,
    a path, and an isogeny graph — such that:
    1. The path is valid in the graph from source to destination
    2. The path cost does not exceed the claimed fuel cost

    This is the existential statement that the SNARK proves without
    revealing the witnesses. -/
def MovePublicInput.Valid (F : Type*) (input : MovePublicInput) : Prop :=
  ∃ (srcValue dstValue : F) (path : List F) (graph : IsogenyGraph F),
    graph.IsValidPath srcValue dstValue path ∧
    graph.pathCost path ≤ input.fuelCost

/-- A **move proof** is a SNARK proof of the movement circuit's public inputs. -/
abbrev MoveProof (_F : Type*) := SNARKProof MovePublicInput

/-! ## Movement fuel bound -/

/-- A verified move proof guarantees that the fuel cost is achievable:
    there exists a valid path in some isogeny graph whose cost is at most
    the claimed fuel cost. Combined with `maxHops`, this bounds the
    actual number of graph hops. -/
theorem move_valid_fuel_bound {F : Type*}
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (π : MoveProof F) (hv : ZKVerifier.verify π = true) :
    ∃ (srcValue dstValue : F) (path : List F) (graph : IsogenyGraph F),
      graph.IsValidPath srcValue dstValue path ∧
      graph.pathCost path ≤ π.claim.fuelCost :=
  ZKVerifier.soundness π hv

/-- A verified move with positive fuel cost bounds the number of isogeny hops:
    at most `fuelCost / ℓ` edges in any valid witness path. -/
theorem move_valid_hop_bound {F : Type*}
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (π : MoveProof F) (hv : ZKVerifier.verify π = true)
    (hfuel : 0 < π.claim.fuelCost) :
    ∃ (path : List F) (graph : IsogenyGraph F),
      path.length - 1 ≤ π.claim.fuelCost / graph.ell := by
  obtain ⟨_, _, path, graph, _, hcost⟩ := ZKVerifier.soundness π hv
  exact ⟨path, graph, graph.maxHops ⟨π.claim.fuelCost, hfuel⟩ path hcost⟩

/-! ## BSD Verification Circuit -/

/-- Evidence for a BSD verification claim.
    In the game, verifying BSD for an elliptic curve at a location
    grants strategic value proportional to the analytic rank.

    The certificate includes:
    - The claimed analytic rank
    - The conductor (level) of the associated modular form
    - A bound on the height to which L-function zeros have been verified -/
structure BSDCertificate where
  /-- The claimed analytic rank (order of vanishing of L(E, s) at s = 1) -/
  claimedRank : ℕ
  /-- The conductor of the elliptic curve -/
  conductor : ℕ
  /-- conductor is positive -/
  conductor_pos : 0 < conductor
  /-- Height to which zeros of the L-function have been checked -/
  verificationHeight : ℕ
  /-- The verification height must be positive (nontrivial computation) -/
  height_pos : 0 < verificationHeight

/-- The **strategic value** produced by a verified BSD certificate. -/
def BSDCertificate.toStrategicValue (cert : BSDCertificate) : StrategicValue where
  analyticRank := cert.claimedRank
  bsdVerified := true
  grhVerifiedHeight := cert.verificationHeight

/-- The **resource reward** for a BSD verification.
    Scales as: baseReward × (rank + 1) × log₂(conductor) × log₂(height).
    This replaces the magic constant 1,000,000 with a formula that
    rewards genuinely harder mathematical computations. -/
def BSDCertificate.resourceReward (cert : BSDCertificate) : ℕ :=
  let baseReward := 10000
  let rankMultiplier := cert.claimedRank + 1
  let conductorBonus := Nat.log 2 cert.conductor + 1
  let heightBonus := Nat.log 2 cert.verificationHeight + 1
  baseReward * rankMultiplier * conductorBonus * heightBonus

/-- BSD reward is always positive. -/
theorem BSDCertificate.resourceReward_pos (cert : BSDCertificate) :
    0 < cert.resourceReward := by
  unfold resourceReward
  positivity

/-- Higher analytic rank gives at least as much reward (all else equal). -/
theorem BSDCertificate.reward_mono_rank (c₁ c₂ : BSDCertificate)
    (hr : c₁.claimedRank ≤ c₂.claimedRank)
    (hc : c₁.conductor = c₂.conductor)
    (hh : c₁.verificationHeight = c₂.verificationHeight) :
    c₁.resourceReward ≤ c₂.resourceReward := by
  unfold BSDCertificate.resourceReward;
  simp +decide [ mul_comm, mul_left_comm, hc, hh ];
  grind +ring

/-- Higher verification height gives at least as much reward (all else equal). -/
theorem BSDCertificate.reward_mono_height (c₁ c₂ : BSDCertificate)
    (hr : c₁.claimedRank = c₂.claimedRank)
    (hc : c₁.conductor = c₂.conductor)
    (hh : c₁.verificationHeight ≤ c₂.verificationHeight) :
    c₁.resourceReward ≤ c₂.resourceReward := by
  unfold BSDCertificate.resourceReward;
  simpa only [ hr, hc ] using Nat.mul_le_mul_left _ ( Nat.succ_le_succ ( Nat.log_mono_right hh ) )

/-- A verified BSD certificate always produces `bsdVerified = true`. -/
theorem BSDCertificate.toStrategicValue_verified (cert : BSDCertificate) :
    cert.toStrategicValue.bsdVerified = true := rfl

/-- The strategic value records the correct rank. -/
theorem BSDCertificate.toStrategicValue_rank (cert : BSDCertificate) :
    cert.toStrategicValue.analyticRank = cert.claimedRank := rfl
