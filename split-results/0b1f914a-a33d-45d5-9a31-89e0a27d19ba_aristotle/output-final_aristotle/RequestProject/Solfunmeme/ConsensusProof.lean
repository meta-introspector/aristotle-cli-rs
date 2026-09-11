/-
# Consensus as a Theorem: Prop-Based Consensus for SOLFUNMEME

Instead of runtime Bool checks, encode consensus evidence as propositions.
Minting requires a proof — impossible states become impossible types.
-/

import Mathlib
import RequestProject.Agent.Consensus
import RequestProject.Solfunmeme.EmojiGrammar

namespace ConsensusProof

open EmojiGrammar

/-! ## §1. Types -/

abbrev AgentId := Nat

structure Proposal where
  id        : Nat
  semantic  : SemanticCompound
  proposer  : AgentId

inductive Vote where
  | accept
  | reject
  deriving DecidableEq, Repr

structure VotingRound where
  proposal    : Proposal
  totalAgents : Nat
  votes       : List (AgentId × Vote)

/-! ## §2. Consensus as a Proposition -/

def acceptCount (r : VotingRound) : Nat :=
  r.votes.countP (fun v => decide (v.2 = Vote.accept))

/-- Consensus reached: a strict majority of votes are accepts. -/
def ConsensusReached (r : VotingRound) : Prop :=
  2 * acceptCount r > r.votes.length

instance : DecidablePred ConsensusReached := fun r =>
  inferInstanceAs (Decidable (2 * acceptCount r > r.votes.length))

/-! ## §3. Proof-Carrying Minting -/

structure CAO where
  hash     : Nat
  semantic : SemanticCompound

def hashCompound (sc : SemanticCompound) : Nat :=
  sc.length * 17

/-- Proof-carrying mint: requires a proof of consensus. -/
def mint (r : VotingRound) (_h : ConsensusReached r) : CAO :=
  { hash := hashCompound r.proposal.semantic
  , semantic := r.proposal.semantic }

theorem mint_semantic (r : VotingRound) (h : ConsensusReached r) :
    (mint r h).semantic = r.proposal.semantic :=
  rfl

theorem mint_deterministic (r₁ r₂ : VotingRound) (h₁ : ConsensusReached r₁)
    (h₂ : ConsensusReached r₂)
    (hp : r₁.proposal.semantic = r₂.proposal.semantic) :
    (mint r₁ h₁).hash = (mint r₂ h₂).hash := by
  simp [mint, hashCompound, hp]

/-! ## §4. Quorum Connection -/

structure QuorumConsensus (n : ℕ) where
  round     : VotingRound
  acceptors : Finset (Fin n)
  isQuorum  : IsQuorum n acceptors

theorem quorum_consensus_overlap (n : ℕ)
    (qc₁ qc₂ : QuorumConsensus n) :
    (qc₁.acceptors ∩ qc₂.acceptors).Nonempty :=
  quorum_intersection n qc₁.acceptors qc₂.acceptors qc₁.isQuorum qc₂.isQuorum

/-! ## §5. Consensus-Gated Evolution -/

structure ConsensusEvolution where
  before    : CAO
  after     : CAO
  round     : VotingRound
  consensus : ConsensusReached round
  semantic_match : after.semantic = round.proposal.semantic

/-- A chain of consensus-gated evolution steps. -/
inductive ConsensusChain : CAO → CAO → Type where
  | nil  : ConsensusChain x x
  | cons : (ev : ConsensusEvolution) →
           ConsensusChain ev.after y →
           ConsensusChain ev.before y

def ConsensusChain.trans :
    ConsensusChain x y → ConsensusChain y z → ConsensusChain x z
  | .nil, c₂ => c₂
  | .cons ev c₁, c₂ => .cons ev (c₁.trans c₂)

def ConsensusChain.length : ConsensusChain x y → Nat
  | .nil => 0
  | .cons _ c => c.length + 1

theorem ConsensusChain.trans_length (c₁ : ConsensusChain x y) (c₂ : ConsensusChain y z) :
    (c₁.trans c₂).length = c₁.length + c₂.length := by
  induction c₁ with
  | nil => simp [ConsensusChain.trans, ConsensusChain.length]
  | cons _ _ ih => simp [ConsensusChain.trans, ConsensusChain.length, ih]; omega

/-! ## §6. Example: A concrete consensus round -/

/-- A voting round with 3 agents, 2 accepting. -/
def exampleRound : VotingRound where
  proposal := { id := 1, semantic := [.rocket, .brain], proposer := 0 }
  totalAgents := 3
  votes := [(0, .accept), (1, .accept), (2, .reject)]

/-- The example round reaches consensus (2 out of 3 accept). -/
theorem example_consensus : ConsensusReached exampleRound := by native_decide

/-- Minting from the example round produces a valid CAO. -/
def exampleMint : CAO := mint exampleRound example_consensus

/-- The minted CAO has the expected semantic content. -/
theorem exampleMint_semantic :
    exampleMint.semantic = [.rocket, .brain] := rfl

end ConsensusProof
