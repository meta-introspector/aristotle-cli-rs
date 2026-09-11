import RequestProject.Nix.Foundry.Fleet
import RequestProject.Nix.NixWars.Agents

/-!
# The challenge framework: what an agent is asked to do, and what counts as done

The board already publishes one *card* per door — a start vector, a line of
play and the vector that line ends in — and proves that the line, replayed
through the shipped WebAssembly module, lands on that vector
(`NixWars.Agents.agentCards_replay`). This file turns those cards into a
challenge framework the referee can run:

* a `Challenge` is a card with a shard, a bounty and an identifier;
* a `Submission` is an agent's name, a challenge identifier and a line of play;
* `verify` replays the submission *through the shipped module itself* and
  accepts only if it reaches the challenge's goal vector. Nothing about the
  submission is trusted: `verify_sound` says that an accepted submission
  really did drive the module from the challenge's start vector to its goal.
* every challenge is solvable, and the reference line solves it
  (`reference_verifies`) — so the board never sets a challenge it cannot
  itself answer;
* scoring is by *distinct* challenges solved: sending the same solution twice
  earns nothing the second time (`score_duplicate`), and sending more never
  costs anything (`score_mono`).

The referee is the agent of the fleet with that name, and it runs in the lab
zone (`referee_in_lab`).
-/

set_option autoImplicit false

namespace NixWars
namespace Foundry

open NixWars.Agents

/-! ## Challenges -/

/-- A challenge, as the referee publishes it. -/
structure Challenge where
  /-- The challenge identifier: the door number it is set at. -/
  id : Nat
  /-- The export prefix of the door. -/
  door : String
  /-- The name on the marquee. -/
  marquee : String
  /-- What each slot of the state vector means. -/
  fields : List String
  /-- The vector the challenge starts from. -/
  start : List Nat
  /-- The vector a solution has to reach. -/
  goalVector : List Nat
  /-- What reaching it means, in words. -/
  goal : String
  /-- The shard of the DMZ the challenge is posted on. -/
  shard : Nat
  /-- The bounty, in Metameme Coin. -/
  bounty : Nat
  deriving Repr, Inhabited

/-- The challenge set at a door. -/
def challengeOf (c : Card) : Challenge :=
  { id := c.doorNo
    door := c.door
    marquee := c.marquee
    fields := c.fields
    start := c.start
    goalVector := c.finish
    goal := c.goal
    shard := shardOf (frenHash c.door)
    bounty := 10 * c.doorNo }

/-- **The challenge board**: one challenge per door. -/
def challenges : List Challenge := agentCards.map challengeOf

/-- Fifteen doors, fifteen challenges. -/
theorem challenges_length : challenges.length = 15 := rfl

/-- Every challenge is posted on a real shard. -/
theorem challenges_shard_lt : ∀ ch ∈ challenges, ch.shard < numShards := by
  intro ch hch
  obtain ⟨c, _, rfl⟩ := List.mem_map.1 hch
  exact shardOf_lt _

/-- The identifiers are the door numbers, and they are distinct. -/
theorem challenges_ids : challenges.map Challenge.id = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] := by
  rfl

theorem challenges_ids_nodup : (challenges.map Challenge.id).Nodup := by
  rw [challenges_ids]; decide

/-- Every bounty is positive. -/
theorem challenges_bounty_pos : ∀ ch ∈ challenges, 0 < ch.bounty := by
  intro ch hch
  obtain ⟨c, hc, rfl⟩ := List.mem_map.1 hch
  have h : agentCards.map Card.doorNo = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] := rfl
  have hmem : c.doorNo ∈ agentCards.map Card.doorNo := List.mem_map_of_mem hc
  rw [h] at hmem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hmem
  show 0 < 10 * c.doorNo
  omega

/-- Looking a challenge up by identifier. -/
def challengeById (i : Nat) : Option Challenge := challenges.find? (fun ch => ch.id == i)

/-! ## Submissions, and what verification means -/

/-- What an agent sends to the referee. -/
structure Submission where
  /-- The agent's handle. -/
  agent : String
  /-- Which challenge it answers. -/
  challenge : Nat
  /-- The line of play. -/
  moves : List Move
  deriving Repr, Inhabited, DecidableEq

/-- **Verification.** The referee replays the submission through the shipped
WebAssembly module, from the challenge's own start vector, and accepts only if
the module ends on the challenge's goal vector. -/
def verify (s : Submission) : Bool :=
  match challengeById s.challenge with
  | none => false
  | some ch => wasmPlay ch.door s.moves ch.start == some ch.goalVector

/-- **An accepted submission really drove the module to the goal**: nothing
about the submission is taken on trust. -/
theorem verify_sound {s : Submission} (h : verify s = true) :
    ∃ ch, challengeById s.challenge = some ch ∧
      wasmPlay ch.door s.moves ch.start = some ch.goalVector := by
  unfold verify at h
  cases hc : challengeById s.challenge with
  | none => rw [hc] at h; exact absurd h (by simp)
  | some ch =>
      rw [hc] at h
      exact ⟨ch, rfl, by simpa using h⟩

/-- A submission answering a challenge that does not exist is rejected. -/
theorem verify_unknown {s : Submission} (h : challengeById s.challenge = none) :
    verify s = false := by
  unfold verify; rw [h]

/-- The reference solution to a challenge: the line of play the board proves
wins at that door. -/
def referenceSubmission (agent : String) (c : Card) : Submission :=
  { agent := agent, challenge := c.doorNo, moves := c.moves }

/-- Looking up by a key that is unique finds exactly the element that carries
it. -/
theorem find?_key_of_mem {α : Type} {β : Type} [DecidableEq β] (key : α → β) :
    ∀ (l : List α), (l.map key).Nodup → ∀ x ∈ l, l.find? (fun y => key y == key x) = some x
  | [], _, x, hx => absurd hx (by simp)
  | a :: l, hn, x, hx => by
      simp only [List.map_cons, List.nodup_cons, List.mem_map] at hn
      rcases List.mem_cons.1 hx with rfl | hx'
      · simp [List.find?_cons_of_pos]
      · by_cases hk : key a = key x
        · exact absurd ⟨x, hx', hk.symm⟩ hn.1
        · rw [List.find?_cons_of_neg (by simpa using hk)]
          exact find?_key_of_mem key l hn.2 x hx'

/-- Each card is the challenge posted at its own door number. -/
theorem challengeById_challengeOf (c : Card) (hc : c ∈ agentCards) :
    challengeById c.doorNo = some (challengeOf c) :=
  find?_key_of_mem Challenge.id challenges challenges_ids_nodup (challengeOf c)
    (List.mem_map_of_mem hc)

/-- **Every challenge is solvable, and the board can solve it**: the reference
line of play verifies, on the shipped module. -/
theorem reference_verifies (agent : String) (c : Card) (hc : c ∈ agentCards) :
    verify (referenceSubmission agent c) = true := by
  unfold verify referenceSubmission
  simp only
  rw [challengeById_challengeOf c hc]
  simpa [challengeOf] using agentCards_replay c hc

/-! ## Scoring

An agent's score is the sum of the bounties of the *distinct* challenges it has
solved. -/

/-- The bounty attached to a challenge identifier. -/
def bountyOf (i : Nat) : Nat :=
  match challengeById i with
  | none => 0
  | some ch => ch.bounty

/-- The distinct challenges an agent has actually solved. -/
def solved (subs : List Submission) (agent : String) : List Nat :=
  ((subs.filter (fun s => s.agent == agent && verify s)).map Submission.challenge).dedup

/-- **The score.** -/
def score (subs : List Submission) (agent : String) : Nat :=
  ((solved subs agent).map bountyOf).sum

/-- An agent that has sent nothing has scored nothing. -/
@[simp] theorem score_nil (agent : String) : score [] agent = 0 := rfl

/-- No challenge is counted twice. -/
theorem solved_nodup (subs : List Submission) (agent : String) : (solved subs agent).Nodup :=
  List.nodup_dedup _

/-- Filtering and deduplicating swallows an immediate repetition. -/
theorem dedup_filter_dup {A B : Type} [DecidableEq B] (f : A → B) (p : A → Bool)
    (a : A) (l : List A) :
    ((List.filter p (a :: a :: l)).map f).dedup = ((List.filter p (a :: l)).map f).dedup := by
  by_cases h : p a = true
  · rw [List.filter_cons_of_pos h, List.filter_cons_of_pos h, List.map_cons, List.map_cons,
      List.dedup_cons_of_mem (by simp)]
  · rw [List.filter_cons_of_neg h, List.filter_cons_of_neg h]

/-- One more entry never lowers a sum taken over the deduplicated keys. -/
theorem sum_dedup_filter_le {A B : Type} [DecidableEq B] (f : A → B) (g : B → Nat)
    (p : A → Bool) (a : A) (l : List A) :
    ((((List.filter p l).map f).dedup).map g).sum
      ≤ ((((List.filter p (a :: l)).map f).dedup).map g).sum := by
  by_cases h : p a = true
  · rw [List.filter_cons_of_pos h, List.map_cons]
    by_cases hm : f a ∈ (List.filter p l).map f
    · rw [List.dedup_cons_of_mem hm]
    · rw [List.dedup_cons_of_notMem hm, List.map_cons]
      simp
  · rw [List.filter_cons_of_neg h]

/-- **Sending the same solution twice earns nothing the second time.** -/
theorem score_duplicate (s : Submission) (subs : List Submission) (agent : String) :
    score (s :: s :: subs) agent = score (s :: subs) agent := by
  unfold score solved
  rw [dedup_filter_dup]

/-- **Sending more never costs anything.** -/
theorem score_mono (s : Submission) (subs : List Submission) (agent : String) :
    score subs agent ≤ score (s :: subs) agent := by
  unfold score solved
  exact sum_dedup_filter_le Submission.challenge bountyOf _ s subs

/-- An entry the filter drops changes nothing. -/
theorem dedup_filter_neg {A B : Type} [DecidableEq B] (f : A → B) (p : A → Bool)
    (a : A) (l : List A) (h : p a = false) :
    ((List.filter p (a :: l)).map f).dedup = ((List.filter p l).map f).dedup := by
  rw [List.filter_cons_of_neg (by simp [h])]

/-- Only solutions that verify score. -/
theorem score_of_unverified (s : Submission) (subs : List Submission) (agent : String)
    (h : verify s = false) : score (s :: subs) agent = score subs agent := by
  unfold score solved
  rw [dedup_filter_neg Submission.challenge _ s subs
    (by simp [h] : (fun t : Submission => t.agent == agent && verify t) s = false)]

/-! ## Who runs it -/

/-- The referee is an agent of the fleet. -/
theorem referee_in_fleet : ∃ a ∈ fleet, a.handle = "referee" := by decide

/-- **The referee runs in the lab zone**, which is the zone the challenge
runner and the ingested cartridges share. -/
theorem referee_in_lab : ∀ a ∈ fleet, a.handle = "referee" → a.zone = Zone.lab := by decide

end Foundry
end NixWars
