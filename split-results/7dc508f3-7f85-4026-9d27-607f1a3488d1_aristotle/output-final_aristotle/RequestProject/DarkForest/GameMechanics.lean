/-
# Dark Forest: LMFDB Edition — Game Mechanics

This file formalizes the core **game state** and **game mechanics**, tying
together the isogeny graph (map), modular form resource model, ZK proof
interface, and BSD verification into a playable game framework.

Key formalizations:
- Player state (position, resources, fleet)
- Commitment scheme (fog of war)
- Turn mechanics (move, mine, attack, verifyBSD)
- `resolveMove` is **wired into `processAction`** via `MoveProof` payloads
- BSD verification uses `BSDCertificate` for scaled rewards
- Fog-of-war invariant preservation for all action types
-/

import Mathlib
import RequestProject.DarkForest.IsogenyGraph
import RequestProject.DarkForest.ResourceModel
import RequestProject.DarkForest.ZKInterface

open Classical in
noncomputable section

/-! ## Hash Commitments (Fog of War) -/

/-- A **commitment** hides a value behind a hash.
    In Dark Forest, players commit to their position without revealing it. -/
structure Commitment (α : Type*) where
  /-- The committed value (private to the player) -/
  value : α
  /-- Random salt for hiding -/
  salt : ℕ
  /-- The hash output (public on-chain) -/
  hash : ℕ

/-- A commitment scheme provides hashing and verification.
    **Binding**: same hash implies same value (collision resistance). -/
class CommitmentScheme (α : Type*) where
  commit : α → ℕ → ℕ
  binding : ∀ (v₁ v₂ : α) (s₁ s₂ : ℕ),
    commit v₁ s₁ = commit v₂ s₂ → v₁ = v₂

/-- A commitment is **well-formed** if its hash equals `commit value salt`. -/
def Commitment.wellFormed {α : Type*} [CommitmentScheme α] (c : Commitment α) : Prop :=
  CommitmentScheme.commit c.value c.salt = c.hash

/-! ## Player State -/

/-- A **player** in Dark Forest: LMFDB Edition. -/
structure Player (F : Type*) where
  /-- Player identifier -/
  id : ℕ
  /-- Current position as a committed j-invariant -/
  position : Commitment F
  /-- Accumulated resources -/
  resources : ℕ
  /-- Movement fuel remaining this turn -/
  fuel : ℕ
  /-- Military strength (for attacks) -/
  fleetPower : ℕ
  /-- Modular form descriptor for current location's resource farm -/
  farm : ModFormDescriptor
  /-- Number of Fourier coefficients computed at current location -/
  coefficientsComputed : ℕ

namespace Player

variable {F : Type*}

/-- A player's **total value** is their resources plus fleet plus defensive bonus. -/
def totalValue (p : Player F) (sv : StrategicValue) : ℕ :=
  p.resources + p.fleetPower + sv.defensiveBonus

/-- Total value is always positive. -/
theorem totalValue_pos (p : Player F) (sv : StrategicValue) :
    0 < p.totalValue sv := by
  unfold totalValue
  linarith [StrategicValue.defensiveBonus_pos sv]

end Player

/-! ## Game Actions -/

/-- The possible **actions** a player can take each turn.
    Movement carries a `MoveProof` whose public inputs (`MovePublicInput`)
    contain srcHash, dstHash, and fuelCost. The ZK verifier checks that
    private witnesses (path, j-invariants) exist satisfying the circuit.
    BSD verification carries a certificate with rank evidence. -/
inductive GameAction (F : Type*) where
  /-- Move to a new j-invariant, proved valid by a SNARK.
      The `MoveProof` bundles public inputs (hashes, fuel cost) and an opaque proof.
      The `Commitment F` is the new committed position after the move. -/
  | move (proof : MoveProof F) (newCommitment : Commitment F)
  /-- Mine: compute more Fourier coefficients at current location -/
  | mine (newCoefficients : ℕ)
  /-- Attack another player's revealed position -/
  | attack (targetHash : ℕ) (fleetSize : ℕ)
  /-- Verify BSD for current location, with certificate evidence -/
  | verifyBSD (cert : BSDCertificate)
  /-- Do nothing (stealth mode) -/
  | idle

/-! ## Turn Resolution: Mining -/

/-- **Mine action**: compute more Fourier coefficients, increasing resource output. -/
def resolveMine {F : Type*} (p : Player F) (newCoeffs : ℕ) : Player F :=
  let newTotal := p.coefficientsComputed + newCoeffs
  let output := p.farm.resourceOutput newTotal
  { p with
    coefficientsComputed := newTotal
    resources := p.resources + output }

/-- Mining always increases resources. -/
theorem mine_increases_resources {F : Type*} (p : Player F) (n : ℕ) :
    p.resources ≤ (resolveMine p n).resources := by
  unfold resolveMine; simp

/-- Mining always increases the number of known coefficients. -/
theorem mine_increases_coefficients {F : Type*} (p : Player F) (n : ℕ) :
    p.coefficientsComputed ≤ (resolveMine p n).coefficientsComputed := by
  unfold resolveMine; simp

/-- Mining preserves the position commitment. -/
theorem resolveMine_preserves_position {F : Type*} (p : Player F) (n : ℕ) :
    (resolveMine p n).position = p.position := by
  unfold resolveMine; rfl

/-- Mining preserves the player's id. -/
theorem resolveMine_preserves_id {F : Type*} (p : Player F) (n : ℕ) :
    (resolveMine p n).id = p.id := by
  unfold resolveMine; rfl

/-! ## Turn Resolution: Movement -/

/-- **Move action**: Resolve a player's movement given verified public inputs.
    Takes the `MovePublicInput` (extracted from the verified proof's `.claim`)
    and a new commitment for the destination.
    If the player has sufficient fuel, updates their position and decreases fuel.
    The ZK soundness guarantee ensures a valid path exists without revealing it. -/
def resolveMove {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F) : Player F :=
  if p.fuel ≥ input.fuelCost then
    { p with
      position := newPos,
      fuel := p.fuel - input.fuelCost }
  else
    p -- Insufficient fuel: player stays idle

/-- Moving with insufficient fuel leaves the player unchanged. -/
theorem resolveMove_no_fuel {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F)
    (h : p.fuel < input.fuelCost) :
    resolveMove input p newPos = p := by
  unfold resolveMove
  simp [Nat.not_le.mpr h]

/-- Moving with sufficient fuel updates position. -/
theorem resolveMove_success {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F)
    (h : p.fuel ≥ input.fuelCost) :
    (resolveMove input p newPos).position = newPos := by
  unfold resolveMove
  simp [h]

/-- Movement preserves the player's id. -/
theorem resolveMove_preserves_id {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F) :
    (resolveMove input p newPos).id = p.id := by
  unfold resolveMove; split <;> rfl

/-- Movement preserves resources. -/
theorem resolveMove_preserves_resources {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F) :
    (resolveMove input p newPos).resources = p.resources := by
  unfold resolveMove; split <;> rfl

/-- Movement decreases fuel (or stays the same if insufficient). -/
theorem resolveMove_fuel_le {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F) :
    (resolveMove input p newPos).fuel ≤ p.fuel := by
  unfold resolveMove
  split
  · simp
  · simp

/-- If the new commitment is well-formed, movement preserves commitment well-formedness. -/
theorem resolveMove_preserves_commitment {F : Type*} [CommitmentScheme F]
    (input : MovePublicInput) (p : Player F)
    (newPos : Commitment F)
    (h_new_wf : newPos.wellFormed)
    (h_old_wf : p.position.wellFormed) :
    (resolveMove input p newPos).position.wellFormed := by
  unfold resolveMove
  split
  · exact h_new_wf
  · exact h_old_wf

/-! ## Turn Resolution: Attack -/

/-- **Attack action**: Resolve combat between an attacker and a defender. -/
def resolveAttack {F : Type*} (attacker : Player F) (defender : Player F)
    (sv : StrategicValue) (fleetSize : ℕ) : (Player F × Player F) :=
  let effectiveAttackerPower := min fleetSize attacker.fleetPower
  let defenderDefense := defender.totalValue sv
  if effectiveAttackerPower > defenderDefense then
    let loot := defender.resources / 2
    ( { attacker with
        resources := attacker.resources + loot,
        fleetPower := attacker.fleetPower - (defenderDefense / 2) },
      { defender with
        resources := defender.resources - loot,
        fleetPower := defender.fleetPower / 2 } )
  else
    ( { attacker with fleetPower := attacker.fleetPower - effectiveAttackerPower },
      { defender with fleetPower := defender.fleetPower - (effectiveAttackerPower / 4) } )

/-- An attacker who wins always gains resources. -/
theorem attack_winner_gains {F : Type*} (a d : Player F) (sv : StrategicValue) (fs : ℕ)
    (h_win : min fs a.fleetPower > d.totalValue sv) :
    a.resources ≤ (resolveAttack a d sv fs).1.resources := by
  unfold resolveAttack
  simp [h_win]

/-- A defender who wins never gains resources. -/
theorem attack_defender_resources_preserved {F : Type*}
    (a d : Player F) (sv : StrategicValue) (fs : ℕ)
    (h_lose : ¬(min fs a.fleetPower > d.totalValue sv)) :
    (resolveAttack a d sv fs).2.resources = d.resources := by
  unfold resolveAttack
  simp [h_lose]

/-- Attack preserves attacker's position. -/
theorem resolveAttack_preserves_attacker_position {F : Type*}
    (a d : Player F) (sv : StrategicValue) (fs : ℕ) :
    (resolveAttack a d sv fs).1.position = a.position := by
  unfold resolveAttack
  simp only
  split <;> rfl

/-- Attack preserves defender's position. -/
theorem resolveAttack_preserves_defender_position {F : Type*}
    (a d : Player F) (sv : StrategicValue) (fs : ℕ) :
    (resolveAttack a d sv fs).2.position = d.position := by
  unfold resolveAttack
  simp only
  split <;> rfl

/-! ## Turn Resolution: BSD Verification -/

/-- **BSD verification action**: Given a valid BSD certificate, update the player's
    resources and strategic value. The reward scales with the certificate's
    rank, conductor, and verification height — replacing the old magic constant. -/
def resolveBSD {F : Type*} (p : Player F) (cert : BSDCertificate) : Player F :=
  { p with resources := p.resources + cert.resourceReward }

/-- BSD verification always increases resources. -/
theorem bsd_increases_resources {F : Type*} (p : Player F) (cert : BSDCertificate) :
    p.resources < (resolveBSD p cert).resources := by
  unfold resolveBSD
  simp
  exact cert.resourceReward_pos

/-- BSD verification preserves position. -/
theorem resolveBSD_preserves_position {F : Type*} (p : Player F) (cert : BSDCertificate) :
    (resolveBSD p cert).position = p.position := by
  unfold resolveBSD; rfl

/-! ## Game State -/

/-- The full **game state** on-chain. -/
structure GameState (F : Type*) where
  /-- All registered players -/
  players : List (Player F)
  /-- The isogeny graph (map) -/
  graph : IsogenyGraph F
  /-- Current turn number -/
  turn : ℕ
  /-- Set of revealed position hashes (via exploration or combat) -/
  revealedPositions : List ℕ
  /-- Strategic values for locations (keyed by position hash) -/
  strategicValues : ℕ → StrategicValue

/-- The game advances by one turn. -/
def GameState.nextTurn {F : Type*} (gs : GameState F) : GameState F :=
  { gs with turn := gs.turn + 1 }

/-- Turn number strictly increases. -/
theorem GameState.turn_increases {F : Type*} (gs : GameState F) :
    gs.turn < gs.nextTurn.turn := by
  unfold nextTurn; simp

/-! ## Fog of War Invariants -/

/-- A **valid game state** satisfies the fog of war invariant:
    every player's on-chain hash is consistent with their private data. -/
structure ValidGameState (F : Type*) [CommitmentScheme F] extends GameState F where
  fog_invariant : ∀ p ∈ toGameState.players, p.position.wellFormed

/-! ## Economic Theorems -/

/-- **Resource inequality**: an eigenform location always out-produces a
    non-eigenform location with the same weight, level, and discovery level. -/
theorem eigenform_dominates {F : Type*} (p₁ p₂ : Player F)
    (h_same : p₁.farm.weight = p₂.farm.weight ∧
              p₁.farm.level = p₂.farm.level ∧
              p₁.farm.hasCM = p₂.farm.hasCM)
    (h₁ : p₁.farm.isEigenform = true)
    (h₂ : p₂.farm.isEigenform = false)
    (h_coeff : p₁.coefficientsComputed = p₂.coefficientsComputed) :
    p₂.farm.resourceOutput p₂.coefficientsComputed ≤
    p₁.farm.resourceOutput p₁.coefficientsComputed := by
  rw [h_coeff]
  exact ModFormDescriptor.eigenform_bonus p₁.farm p₂.farm h_same h₁ h₂ _

/-! ## The Modularity Theorem as a Game Mechanic -/

/-- The **modularity correspondence**: every elliptic curve base (military outpost)
    has an associated weight-2 modular form (resource farm). -/
def modularityCorrespondence (_j : F) (conductor : ℕ) (hN : 0 < conductor) :
    ModFormDescriptor where
  weight := 2
  weight_ge := le_refl 2
  weight_even := ⟨1, rfl⟩
  level := conductor
  level_pos := hN
  isEigenform := true
  hasCM := false

theorem modularity_weight_two (j : F) (N : ℕ) (hN : 0 < N) :
    (modularityCorrespondence j N hN).weight = 2 := rfl

theorem modularity_is_eigenform (j : F) (N : ℕ) (hN : 0 < N) :
    (modularityCorrespondence j N hN).isEigenform = true := rfl

/-- **Strategic consequence**: the modularity correspondence guarantees
    the eigenform resource bonus for every elliptic curve location. -/
theorem modularity_gives_eigenform_bonus (j : F) (N : ℕ) (hN : 0 < N)
    (d_other : ModFormDescriptor)
    (h_other_not_eigen : d_other.isEigenform = false)
    (h_same_params : d_other.weight = 2 ∧ d_other.level = N ∧ d_other.hasCM = false)
    (c : ℕ) :
    d_other.resourceOutput c ≤ (modularityCorrespondence j N hN).resourceOutput c := by
  apply ModFormDescriptor.eigenform_bonus
  · exact ⟨h_same_params.1.symm, h_same_params.2.1.symm, h_same_params.2.2.symm⟩
  · rfl
  · exact h_other_not_eigen

/-! ## State Transition System -/

/-- Find the index of a player by their id. -/
def findPlayerIdx {F : Type*} (players : List (Player F)) (playerId : ℕ) : Option ℕ :=
  players.findIdx? (fun p => decide (p.id = playerId))

/-- Find the index of a player by their position hash. -/
def findPlayerByHash {F : Type*} (players : List (Player F)) (hash : ℕ) : Option ℕ :=
  players.findIdx? (fun p => decide (p.position.hash = hash))

/-- Safely get a player from a list with a default. -/
def getPlayer {F : Type*} (players : List (Player F)) (idx : ℕ)
    (default : Player F) : Player F :=
  players.getD idx default

/-- **Main state transition function**.
    Given the current state, a player id, and their chosen action,
    produce the next game state.

    **Movement** is now fully wired: the `move` variant carries a `MoveProof`
    which is verified via the `ZKVerifier` instance. On successful verification,
    soundness guarantees `MovePublicInput.Valid F` holds for the proof's
    public inputs — meaning a valid path exists. Then `resolveMove` is invoked
    with `proof.claim` (the public inputs: srcHash, dstHash, fuelCost).

    **BSD verification** uses `BSDCertificate` for scaled rewards instead of
    a magic constant. -/
def GameState.processAction {F : Type*} [CommitmentScheme F]
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (gs : GameState F) (playerId : ℕ) (action : GameAction F)
    (defaultPlayer : Player F) : GameState F :=
  match findPlayerIdx gs.players playerId with
  | none => gs  -- Player not found, state unchanged
  | some idx =>
    let p := getPlayer gs.players idx defaultPlayer
    match action with
    | GameAction.idle => gs.nextTurn

    | GameAction.mine n =>
      let newP := resolveMine p n
      { gs.nextTurn with players := gs.players.set idx newP }

    | GameAction.move proof newCommitment =>
      -- Verify the SNARK proof via the ZKVerifier instance
      if _hv : ZKVerifier.verify proof = true then
        -- Soundness guarantees: ∃ private witnesses making proof.claim valid
        -- (see `move_valid_fuel_bound` and `move_valid_hop_bound`)
        -- We use proof.claim (the public inputs) directly
        let input := proof.claim
        -- Check that the proof's source hash matches the player's position hash
        if input.srcHash = p.position.hash then
          -- Check that the destination hash matches the new commitment
          if input.dstHash = newCommitment.hash then
            let newP := resolveMove input p newCommitment
            { gs.nextTurn with players := gs.players.set idx newP }
          else gs.nextTurn  -- Destination hash mismatch
        else gs.nextTurn  -- Source hash mismatch
      else gs.nextTurn  -- Proof verification failed

    | GameAction.attack targetHash fleetSize =>
      match findPlayerByHash gs.players targetHash with
      | none => gs.nextTurn
      | some dIdx =>
        if idx = dIdx then gs.nextTurn
        else
          let defender := getPlayer gs.players dIdx defaultPlayer
          let sv := gs.strategicValues targetHash
          let (newAttacker, newDefender) := resolveAttack p defender sv fleetSize
          let updatedPlayers := (gs.players.set idx newAttacker).set dIdx newDefender
          { gs.nextTurn with
            players := updatedPlayers,
            revealedPositions := targetHash :: gs.revealedPositions }

    | GameAction.verifyBSD cert =>
      let newP := resolveBSD p cert
      { gs.nextTurn with players := gs.players.set idx newP }

/-! ## Turn Advancement -/

/-
Processing any action when the player is found always advances the turn counter.
-/
theorem processAction_advances_turn {F : Type*} [CommitmentScheme F]
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (gs : GameState F) (pId : ℕ) (action : GameAction F)
    (dp : Player F)
    (h_found : (findPlayerIdx gs.players pId).isSome = true) :
    gs.turn < (gs.processAction pId action dp).turn := by
  grind +locals

/-! ## Fog-of-War Invariant Preservation -/

/-- Helper: mining preserves commitment well-formedness. -/
theorem resolveMine_preserves_wellFormed {F : Type*} [CommitmentScheme F]
    (p : Player F) (n : ℕ) (h : p.position.wellFormed) :
    (resolveMine p n).position.wellFormed := by
  rwa [resolveMine_preserves_position]

/-- Helper: BSD verification preserves commitment well-formedness. -/
theorem resolveBSD_preserves_wellFormed {F : Type*} [CommitmentScheme F]
    (p : Player F) (cert : BSDCertificate) (h : p.position.wellFormed) :
    (resolveBSD p cert).position.wellFormed := by
  rwa [resolveBSD_preserves_position]

/-- `getPlayer` returns a well-formed player if all list players and the default are well-formed. -/
theorem getPlayer_wellFormed {F : Type*} [CommitmentScheme F]
    (players : List (Player F)) (idx : ℕ) (dp : Player F)
    (h_all : ∀ p ∈ players, p.position.wellFormed)
    (h_dp : dp.position.wellFormed) :
    (getPlayer players idx dp).position.wellFormed := by
  unfold getPlayer
  simp only [List.getD]
  cases h : players[idx]? with
  | none => exact h_dp
  | some p => exact h_all p (List.mem_of_getElem? h)

/-- If a property holds for all elements of a list and for `x`, then it holds
    for all elements of `l.set i x`. This is the key lemma for all fog-of-war
    invariant preservation proofs. -/
theorem forall_mem_set {α : Type*} {P : α → Prop} {l : List α} {i : ℕ} {x : α}
    (h_all : ∀ a ∈ l, P a) (h_x : P x) :
    ∀ a ∈ l.set i x, P a := by
  intro a ha
  rcases List.mem_or_eq_of_mem_set ha with h | h
  · exact h_all a h
  · exact h ▸ h_x

/-- Double `List.set` preserves a property if it holds for all original elements
    and both new elements. -/
theorem forall_mem_set_set {α : Type*} {P : α → Prop} {l : List α} {i j : ℕ} {x y : α}
    (h_all : ∀ a ∈ l, P a) (h_x : P x) (h_y : P y) :
    ∀ a ∈ (l.set i x).set j y, P a :=
  forall_mem_set (forall_mem_set h_all h_x) h_y

/-- **Mining preserves the fog-of-war invariant**.
    Since `resolveMine` does not change any player's position or commitment,
    all hash commitments remain valid after a mine action. -/
theorem valid_state_preserved_by_mining {F : Type*} [CommitmentScheme F]
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (vgs : ValidGameState F) (pId : ℕ) (n : ℕ)
    (dp : Player F)
    (h_dp : dp.position.wellFormed) :
    let nextState := vgs.toGameState.processAction pId (GameAction.mine n) dp
    ∀ p ∈ nextState.players,
      p.position.wellFormed := by
  simp only [GameState.processAction]
  cases findPlayerIdx vgs.toGameState.players pId with
  | none => exact vgs.fog_invariant
  | some idx =>
    exact forall_mem_set vgs.fog_invariant
      (resolveMine_preserves_wellFormed _ _
        (getPlayer_wellFormed _ _ _ vgs.fog_invariant h_dp))

/-- **Movement preserves the fog-of-war invariant** when the new commitment
    is well-formed. The ZK proof ensures path validity; the commitment scheme
    ensures the new hash is binding. -/
theorem valid_state_preserved_by_move {F : Type*} [CommitmentScheme F]
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (vgs : ValidGameState F) (pId : ℕ)
    (proof : MoveProof F) (newCommit : Commitment F)
    (dp : Player F)
    (h_dp : dp.position.wellFormed)
    (h_new_wf : newCommit.wellFormed) :
    let nextState := vgs.toGameState.processAction pId (GameAction.move proof newCommit) dp
    ∀ p ∈ nextState.players,
      p.position.wellFormed := by
  simp only [GameState.processAction]
  cases findPlayerIdx vgs.toGameState.players pId with
  | none => exact vgs.fog_invariant
  | some idx =>
    have h_p_wf := getPlayer_wellFormed _ idx _ vgs.fog_invariant h_dp
    simp only [GameState.nextTurn]
    split -- verify
    · split -- srcHash
      · split -- dstHash
        · exact forall_mem_set vgs.fog_invariant
            (resolveMove_preserves_commitment _ _ _ h_new_wf h_p_wf)
        · exact vgs.fog_invariant
      · exact vgs.fog_invariant
    · exact vgs.fog_invariant

/-- **Attack preserves the fog-of-war invariant**.
    Since `resolveAttack` does not change any player's position commitment,
    all hash commitments remain valid after an attack action. -/
theorem valid_state_preserved_by_attack {F : Type*} [CommitmentScheme F]
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (vgs : ValidGameState F) (pId : ℕ) (targetHash : ℕ) (fleetSize : ℕ)
    (dp : Player F)
    (h_dp : dp.position.wellFormed) :
    let nextState := vgs.toGameState.processAction pId
        (GameAction.attack targetHash fleetSize) dp
    ∀ p ∈ nextState.players,
      p.position.wellFormed := by
  simp only [GameState.processAction]
  cases findPlayerIdx vgs.toGameState.players pId with
  | none => exact vgs.fog_invariant
  | some idx =>
    cases findPlayerByHash vgs.toGameState.players targetHash with
    | none => exact vgs.fog_invariant
    | some dIdx =>
      simp only [GameState.nextTurn]
      split -- idx = dIdx
      · exact vgs.fog_invariant
      · have h_a_wf := getPlayer_wellFormed _ idx _ vgs.fog_invariant h_dp
        have h_d_wf := getPlayer_wellFormed _ dIdx _ vgs.fog_invariant h_dp
        apply forall_mem_set_set vgs.fog_invariant
        · rw [resolveAttack_preserves_attacker_position]; exact h_a_wf
        · rw [resolveAttack_preserves_defender_position]; exact h_d_wf

/-
**BSD verification preserves the fog-of-war invariant**.
    Since `resolveBSD` does not change any player's position commitment,
    all hash commitments remain valid after a BSD verification action.
-/
theorem valid_state_preserved_by_bsd {F : Type*} [CommitmentScheme F]
    [ZKVerifier MovePublicInput (MovePublicInput.Valid F)]
    (vgs : ValidGameState F) (pId : ℕ) (cert : BSDCertificate)
    (dp : Player F)
    (h_dp : dp.position.wellFormed) :
    let nextState := vgs.toGameState.processAction pId (GameAction.verifyBSD cert) dp
    ∀ p ∈ nextState.players,
      p.position.wellFormed := by
  cases vgs;
  grind +locals

end