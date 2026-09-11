import RequestProject.Nix.NixWars.Oracle
import RequestProject.Nix.NixWars.Quorum

/-!
# A twelfth door: the Assembly

The hackathon repository runs its factories by *community voting* on a network
of distributed nodes. `Quorum.lean` already has that network: 23 nodes, a quorum
of 12, and 7 Byzantine faults survivable. This door is that vote, played:

```
ayes    nodes that have voted for the proposal
nays    nodes that have voted against
round   proposals decided so far
passed  1 if the proposal on the floor carries, 0 otherwise
```

`aye` and `nay` are one node voting, and are refused once all 23 have voted.
`tally` carries the proposal exactly when a quorum of 12 has voted for it, and
`next` clears the floor for the following round.

What is proved here:

* the floor never holds more votes than there are nodes (`ballotStep_votes_le`,
  `ballotRun_votes_le`);
* **a proposal passes only with a quorum** (`ballot_sound`, `ballotRun_sound`):
  `passed = 1` always comes with at least 12 ayes, whatever sequence of commands
  produced it;
* so the opposition can never have a quorum at the same time
  (`passed_opposition_short`) — this is `paxos_quorum_majority` on the floor;
* rounds only advance on `next`, and only forwards (`ballotStep_round_mono`,
  `aye_round`, `tally_round`);
* twelve ayes carry a proposal (`quorum_carries`) and eleven do not
  (`eleven_is_not_enough`), which is `quorum_minimal` made playable;
* and the seven Byzantine nodes cannot block the assembly: with the faulty
  nodes silent the sixteen honest ones still carry a proposal
  (`byzantine_cannot_block`).
-/

namespace NixWars

/-- The floor of the assembly: the votes on the proposal, the round, and whether
it carried. -/
structure Ballot where
  /-- Nodes that have voted for the proposal. -/
  ayes : Nat
  /-- Nodes that have voted against. -/
  nays : Nat
  /-- Proposals decided so far. -/
  round : Nat
  /-- 1 if the proposal on the floor carries, 0 otherwise. -/
  passed : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the assembly door. -/
inductive VoteCmd
  | aye
  | nay
  | tally
  | next
  deriving DecidableEq, Repr, Inhabited

/-- **The transition function of the assembly door.** -/
def ballotStep (s : Ballot) : VoteCmd → Ballot
  | .aye => if s.ayes + s.nays < paxosNodes then { s with ayes := s.ayes + 1 } else s
  | .nay => if s.ayes + s.nays < paxosNodes then { s with nays := s.nays + 1 } else s
  | .tally => if paxosQuorum ≤ s.ayes then { s with passed := 1 } else s
  | .next => { ayes := 0, nays := 0, round := s.round + 1, passed := 0 }

/-- Playing a list of commands. -/
def ballotRun (s : Ballot) : List VoteCmd → Ballot
  | [] => s
  | c :: cs => ballotRun (ballotStep s c) cs

/-! ## The floor as a payload -/

/-- The floor as a payload. -/
def ballotSerialize (s : Ballot) : List Nat := [s.ayes, s.nays, s.round, s.passed]

/-- Reading a floor back from a payload. -/
def ballotDeserialize : List Nat → Option Ballot
  | [ayes, nays, round, passed] =>
      some { ayes := ayes, nays := nays, round := round, passed := passed }
  | _ => none

theorem ballotDeserialize_ballotSerialize (s : Ballot) :
    ballotDeserialize (ballotSerialize s) = some s := by
  cases s
  simp [ballotSerialize, ballotDeserialize]

/-- **The Assembly as a door game.** -/
def assembly : DoorGame where
  State := Ballot
  Cmd := VoteCmd
  step := ballotStep
  serialize := ballotSerialize
  deserialize := ballotDeserialize
  deserialize_serialize := ballotDeserialize_ballotSerialize

/-- A fresh floor: nobody has voted on the first proposal. -/
def initialBallot : Ballot := { ayes := 0, nays := 0, round := 0, passed := 0 }

/-! ## The floor holds only the nodes there are -/

theorem ballotStep_votes_le (s : Ballot) (c : VoteCmd) (h : s.ayes + s.nays ≤ paxosNodes) :
    (ballotStep s c).ayes + (ballotStep s c).nays ≤ paxosNodes := by
  cases c <;> simp only [ballotStep] <;> (try split_ifs with hc) <;> simp_all <;> omega

theorem ballotRun_votes_le (s : Ballot) (cs : List VoteCmd) (h : s.ayes + s.nays ≤ paxosNodes) :
    (ballotRun s cs).ayes + (ballotRun s cs).nays ≤ paxosNodes := by
  induction cs generalizing s with
  | nil => simpa [ballotRun]
  | cons c cs ih => exact ih (ballotStep s c) (ballotStep_votes_le s c h)

/-! ## A proposal passes only with a quorum -/

/-- What an honest floor looks like: no more votes than nodes, and nothing
carried without a quorum behind it. -/
def Sound (s : Ballot) : Prop :=
  s.ayes + s.nays ≤ paxosNodes ∧ (s.passed = 1 → paxosQuorum ≤ s.ayes)

theorem initialBallot_sound : Sound initialBallot := by
  constructor
  · decide
  · intro h
    exact absurd h (by decide)

/-- **Soundness is an invariant of every command.** -/
theorem ballot_sound (s : Ballot) (c : VoteCmd) (h : Sound s) : Sound (ballotStep s c) := by
  obtain ⟨hv, hp⟩ := h
  cases c with
  | aye =>
      simp only [ballotStep]
      split_ifs with hc
      · exact ⟨by simp; omega, by intro hh; simp at hh ⊢; omega⟩
      · exact ⟨hv, hp⟩
  | nay =>
      simp only [ballotStep]
      split_ifs with hc
      · exact ⟨by simp; omega, by intro hh; simpa using hp (by simpa using hh)⟩
      · exact ⟨hv, hp⟩
  | tally =>
      simp only [ballotStep]
      split_ifs with hc
      · exact ⟨by simpa using hv, by intro _; simpa using hc⟩
      · exact ⟨hv, hp⟩
  | next =>
      refine ⟨?_, ?_⟩
      · show 0 + 0 ≤ paxosNodes
        decide
      · show (0 : Nat) = 1 → _
        intro hh
        exact absurd hh (by decide)

theorem ballotRun_sound (s : Ballot) (cs : List VoteCmd) (h : Sound s) :
    Sound (ballotRun s cs) := by
  induction cs generalizing s with
  | nil => simpa [ballotRun]
  | cons c cs ih => exact ih (ballotStep s c) (ballot_sound s c h)

/-- **A proposal that carries had a quorum behind it**, however the floor got
there. -/
theorem ballotRun_passed_quorum (cs : List VoteCmd)
    (h : (ballotRun initialBallot cs).passed = 1) :
    paxosQuorum ≤ (ballotRun initialBallot cs).ayes :=
  (ballotRun_sound initialBallot cs initialBallot_sound).2 h

/-- **The opposition cannot have a quorum too**: on a sound floor a carried
proposal leaves fewer than twelve nays. This is `paxos_quorum_majority` played
out — two quorums cannot be disjoint. -/
theorem passed_opposition_short (s : Ballot) (h : Sound s) (hp : s.passed = 1) :
    s.nays < paxosQuorum := by
  have h1 := h.1
  have h2 := h.2 hp
  simp only [paxosNodes] at h1
  simp only [paxosQuorum] at h2 ⊢
  omega

/-! ## Rounds -/

theorem ballotStep_round_mono (s : Ballot) (c : VoteCmd) : s.round ≤ (ballotStep s c).round := by
  cases c <;> simp only [ballotStep] <;> (try split_ifs) <;> simp

theorem aye_round (s : Ballot) : (ballotStep s .aye).round = s.round := by
  simp only [ballotStep]
  split_ifs <;> rfl

theorem tally_round (s : Ballot) : (ballotStep s .tally).round = s.round := by
  simp only [ballotStep]
  split_ifs <;> rfl

theorem next_round (s : Ballot) : (ballotStep s .next).round = s.round + 1 := rfl

/-! ## Playing it -/

/-- Twelve ayes and a tally: the proposal carries. -/
theorem quorum_carries :
    ballotRun initialBallot (List.replicate 12 VoteCmd.aye ++ [.tally])
      = { ayes := 12, nays := 0, round := 0, passed := 1 } := by
  decide

/-- Eleven ayes and a tally: it does not. Eleven is genuinely unsafe, as
`quorum_minimal` says. -/
theorem eleven_is_not_enough :
    (ballotRun initialBallot (List.replicate 11 VoteCmd.aye ++ [.tally])).passed = 0 := by
  decide

/-- **The Byzantine nodes cannot block the assembly**: with the seven faulty
nodes silent, the sixteen honest ones still carry the proposal. -/
theorem byzantine_cannot_block :
    (ballotRun initialBallot
      (List.replicate (paxosNodes - byzantineTolerance) VoteCmd.aye ++ [.tally])).passed = 1 := by
  decide

/-- The floor is finite: after 23 votes the next one changes nothing. -/
theorem floor_is_full :
    ballotStep { ayes := 12, nays := 11, round := 3, passed := 1 } .aye
      = { ayes := 12, nays := 11, round := 3, passed := 1 } := by
  decide

/-! ## On the board

Like every other door the assembly is a `DoorGame`, so it inherits the stateless
session and all five wires with no new transport code. -/

/-- The assembly session of a player. -/
def voteSession (i shard : Nat) (st : Ballot) : GameSession assembly :=
  { user := i, shard := shard, game := 12, state := st }

/-- **An assembly session survives any wire intact.** -/
theorem voteSession_roundtrip {X : Type} (t : Codec (List Nat) X)
    (s : GameSession assembly) : receive assembly t (transmit t s) = some s :=
  receive_transmit t s

/-- **The assembly is stateless**: re-serializing after every command gives
exactly the same result as playing locally. -/
theorem vote_play_over_wire {X : Type} (t : Codec (List Nat) X)
    (s : GameSession assembly) (cs : List VoteCmd) :
    runOverWire (g := assembly) t (transmit t s) cs
      = some (transmit t { s with state := assembly.run s.state cs }) :=
  runOverWire_eq t s cs

end NixWars
