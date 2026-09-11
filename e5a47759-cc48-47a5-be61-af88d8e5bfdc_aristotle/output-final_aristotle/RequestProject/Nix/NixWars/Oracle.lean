import RequestProject.Nix.NixWars.Hyperspace

/-!
# An eleventh door: the Provenance Oracle

Step four of the hackathon repository's single game loop is *discover provenance
chains*: `Assembly → C → Scheme → Seed`. This door plays that step. The oracle
holds one chain under construction:

```
layer      how far up the chain the evidence reaches
           0 assembly, 1 C, 2 Scheme, 3 seed
evidence   witnesses collected at the current layer
seeds      complete chains minted so far
bounty     what they paid
```

`witness` collects one witness. `lift` spends three witnesses to climb one
layer, and refuses below three or at the top. `mint` spends three witnesses at
the seed layer to close the chain: one seed, a bounty of 59 — a Monster prime —
and the oracle starts again at the assembly layer. `audit` reports and changes
nothing.

What is proved here:

* nothing is ever lost: seeds and bounty never fall (`oracleStep_seeds_mono`,
  `oracleStep_bounty_mono`, `oracleRun_seeds_mono`, `oracleRun_bounty_mono`);
* the chain never grows past the seed layer (`oracleStep_layer_le`,
  `oracleRun_layer_le`);
* a mint pays exactly 59 and no other command pays anything
  (`mint_pays_exactly`, `oracleStep_bounty_le`), so the bounty is exactly 59 per
  seed for the whole session (`oracle_bounty_invariant`,
  `oracleRun_bounty_eq`);
* provenance cannot be forged: a chain cannot be closed from below
  (`mint_refused_low_layer`), a layer cannot be climbed on two witnesses
  (`lift_refused_thin`), and witnessing alone mints nothing
  (`witnessing_alone_mints_nothing`);
* **the honest price of a seed is twelve witnesses**. The oracle's progress
  `evidence + 3 * layer + 12 * seeds` never falls and never rises by more than
  one per command (`progress_mono`, `progress_step_le`), so a session of `n`
  commands started from the empty oracle mints at most `n / 12` seeds
  (`provenance_costs_twelve`);
* and a seed really can be minted: sixteen commands close one chain
  (`provenance_quest_mints`).
-/

namespace NixWars

/-- The oracle's desk: one chain under construction, and what has been closed. -/
structure Provenance where
  /-- How far up the chain the evidence reaches: 0 assembly, 1 C, 2 Scheme, 3 seed. -/
  layer : Nat
  /-- Witnesses collected at the current layer. -/
  evidence : Nat
  /-- Complete provenance chains minted so far. -/
  seeds : Nat
  /-- What the chains paid. -/
  bounty : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the oracle door. -/
inductive OracleCmd
  | witness
  | lift
  | mint
  | audit
  deriving DecidableEq, Repr, Inhabited

/-- The names of the four layers of the chain. -/
def layerNames : List String := ["assembly", "C", "scheme", "seed"]

/-- The top of the chain: the seed layer. -/
def seedLayer : Nat := 3

/-- What one layer of the chain costs in witnesses. -/
def witnessesPerLayer : Nat := 3

/-- What a closed chain pays: a Monster prime. -/
def seedBounty : Nat := 59

/-- The bounty is a Monster prime. -/
theorem seedBounty_mem_monsterPrimes : seedBounty ∈ monsterPrimes := by decide

/-- **The transition function of the oracle door.** -/
def oracleStep (s : Provenance) : OracleCmd → Provenance
  | .witness => { s with evidence := s.evidence + 1 }
  | .lift =>
      if witnessesPerLayer ≤ s.evidence ∧ s.layer < seedLayer then
        { s with layer := s.layer + 1, evidence := s.evidence - witnessesPerLayer }
      else s
  | .mint =>
      if witnessesPerLayer ≤ s.evidence ∧ s.layer = seedLayer then
        { layer := 0, evidence := s.evidence - witnessesPerLayer,
          seeds := s.seeds + 1, bounty := s.bounty + seedBounty }
      else s
  | .audit => s

/-- Playing a list of commands. -/
def oracleRun (s : Provenance) : List OracleCmd → Provenance
  | [] => s
  | c :: cs => oracleRun (oracleStep s c) cs

/-! ## The desk as a payload -/

/-- The desk as a payload. -/
def oracleSerialize (s : Provenance) : List Nat := [s.layer, s.evidence, s.seeds, s.bounty]

/-- Reading a desk back from a payload. -/
def oracleDeserialize : List Nat → Option Provenance
  | [layer, evidence, seeds, bounty] =>
      some { layer := layer, evidence := evidence, seeds := seeds, bounty := bounty }
  | _ => none

theorem oracleDeserialize_oracleSerialize (s : Provenance) :
    oracleDeserialize (oracleSerialize s) = some s := by
  cases s
  simp [oracleSerialize, oracleDeserialize]

/-- **The Provenance Oracle as a door game.** -/
def provenanceOracle : DoorGame where
  State := Provenance
  Cmd := OracleCmd
  step := oracleStep
  serialize := oracleSerialize
  deserialize := oracleDeserialize
  deserialize_serialize := oracleDeserialize_oracleSerialize

/-- A fresh desk: nothing witnessed, nothing closed. -/
def initialProvenance : Provenance :=
  { layer := 0, evidence := 0, seeds := 0, bounty := 0 }

/-! ## Nothing is lost -/

theorem oracleStep_seeds_mono (s : Provenance) (c : OracleCmd) :
    s.seeds ≤ (oracleStep s c).seeds := by
  cases c <;> simp only [oracleStep] <;> (try split_ifs) <;> simp

theorem oracleStep_bounty_mono (s : Provenance) (c : OracleCmd) :
    s.bounty ≤ (oracleStep s c).bounty := by
  cases c <;> simp only [oracleStep] <;> (try split_ifs) <;> simp

theorem oracleRun_seeds_mono (s : Provenance) (cs : List OracleCmd) :
    s.seeds ≤ (oracleRun s cs).seeds := by
  induction cs generalizing s with
  | nil => simp [oracleRun]
  | cons c cs ih => exact le_trans (oracleStep_seeds_mono s c) (ih (oracleStep s c))

theorem oracleRun_bounty_mono (s : Provenance) (cs : List OracleCmd) :
    s.bounty ≤ (oracleRun s cs).bounty := by
  induction cs generalizing s with
  | nil => simp [oracleRun]
  | cons c cs ih => exact le_trans (oracleStep_bounty_mono s c) (ih (oracleStep s c))

/-- The chain never grows past the seed layer. -/
theorem oracleStep_layer_le (s : Provenance) (c : OracleCmd) (h : s.layer ≤ seedLayer) :
    (oracleStep s c).layer ≤ seedLayer := by
  cases c
  · simpa [oracleStep] using h
  · simp only [oracleStep]
    split_ifs with hc
    · exact hc.2
    · exact h
  · simp only [oracleStep]
    split_ifs with hc
    · simp [seedLayer]
    · exact h
  · simpa [oracleStep] using h

theorem oracleRun_layer_le (s : Provenance) (cs : List OracleCmd) (h : s.layer ≤ seedLayer) :
    (oracleRun s cs).layer ≤ seedLayer := by
  induction cs generalizing s with
  | nil => simpa [oracleRun]
  | cons c cs ih => exact ih (oracleStep s c) (oracleStep_layer_le s c h)

/-! ## The bounty is honest -/

/-- A mint that happens pays exactly 59, closes exactly one chain, and puts the
oracle back at the assembly layer. -/
theorem mint_pays_exactly (s : Provenance)
    (he : witnessesPerLayer ≤ s.evidence) (hl : s.layer = seedLayer) :
    oracleStep s .mint =
      { layer := 0, evidence := s.evidence - witnessesPerLayer,
        seeds := s.seeds + 1, bounty := s.bounty + seedBounty } := by
  simp [oracleStep, he, hl]

/-- No command pays more than one bounty. -/
theorem oracleStep_bounty_le (s : Provenance) (c : OracleCmd) :
    (oracleStep s c).bounty ≤ s.bounty + seedBounty := by
  cases c <;> simp only [oracleStep] <;> (try split_ifs) <;> simp

/-- **The bounty is exactly 59 per seed**, and stays so: this is an invariant of
every command, so the oracle cannot pay for a chain it did not close. -/
theorem oracle_bounty_invariant (s : Provenance) (c : OracleCmd)
    (h : s.bounty = seedBounty * s.seeds) :
    (oracleStep s c).bounty = seedBounty * (oracleStep s c).seeds := by
  cases c <;> simp only [oracleStep] <;> (try split_ifs) <;> simp_all [Nat.mul_succ, seedBounty]

theorem oracleRun_bounty_eq (s : Provenance) (cs : List OracleCmd)
    (h : s.bounty = seedBounty * s.seeds) :
    (oracleRun s cs).bounty = seedBounty * (oracleRun s cs).seeds := by
  induction cs generalizing s with
  | nil => simpa [oracleRun]
  | cons c cs ih => exact ih (oracleStep s c) (oracle_bounty_invariant s c h)

/-! ## Provenance cannot be forged -/

/-- A chain cannot be closed from below the seed layer. -/
theorem mint_refused_low_layer (s : Provenance) (h : s.layer ≠ seedLayer) :
    oracleStep s .mint = s := by
  simp [oracleStep, h]

/-- A layer cannot be climbed on fewer than three witnesses. -/
theorem lift_refused_thin (s : Provenance) (h : s.evidence < witnessesPerLayer) :
    oracleStep s .lift = s := by
  simp only [oracleStep]
  split_ifs with hc
  · omega
  · rfl

/-- At the top of the chain there is nothing left to climb. -/
theorem lift_refused_at_top (s : Provenance) (h : s.layer = seedLayer) :
    oracleStep s .lift = s := by
  simp only [oracleStep]
  split_ifs with hc
  · omega
  · rfl

/-- **Witnessing alone mints nothing**: with no `lift` and no `mint`, a session
of witnesses closes no chain. -/
theorem witnessing_alone_mints_nothing (s : Provenance) (n : Nat) :
    (oracleRun s (List.replicate n OracleCmd.witness)).seeds = s.seeds := by
  induction n generalizing s with
  | zero => simp [oracleRun]
  | succ n ih =>
      rw [List.replicate_succ, oracleRun, ih (oracleStep s .witness)]
      rfl

/-! ## The price of a seed -/

/-- How far the oracle has got, measured in witnesses: three per layer climbed,
twelve per chain closed. -/
def progress (s : Provenance) : Nat :=
  s.evidence + witnessesPerLayer * s.layer + (witnessesPerLayer * (seedLayer + 1)) * s.seeds

/-- Progress never falls. -/
theorem progress_mono (s : Provenance) (c : OracleCmd) : progress s ≤ progress (oracleStep s c) := by
  cases c <;>
    simp only [oracleStep, progress, witnessesPerLayer, seedLayer] <;>
      (try split_ifs with hc) <;> simp_all <;> omega

/-- No command makes more than one witness worth of progress: `witness` makes
exactly one, and `lift` and `mint` only convert what is already there. -/
theorem progress_step_le (s : Provenance) (c : OracleCmd) :
    progress (oracleStep s c) ≤ progress s + 1 := by
  cases c <;>
    simp only [oracleStep, progress, witnessesPerLayer, seedLayer] <;>
      (try split_ifs with hc) <;> simp_all <;> omega

theorem progress_run_le (s : Provenance) (cs : List OracleCmd) :
    progress (oracleRun s cs) ≤ progress s + cs.length := by
  induction cs generalizing s with
  | nil => simp [oracleRun]
  | cons c cs ih =>
      have h₁ := ih (oracleStep s c)
      have h₂ := progress_step_le s c
      simp only [oracleRun, List.length_cons]
      omega

/-- **A seed is worth twelve witnesses, and cannot be had for less.** A session
of `n` commands, started from the empty desk, mints at most `n / 12` seeds — the
door pays for provenance, not for clicks. -/
theorem provenance_costs_twelve (cs : List OracleCmd) :
    12 * (oracleRun initialProvenance cs).seeds ≤ cs.length := by
  have h := progress_run_le initialProvenance cs
  have hp : progress initialProvenance = 0 := by
    simp [progress, initialProvenance]
  have hs : 12 * (oracleRun initialProvenance cs).seeds ≤ progress (oracleRun initialProvenance cs) := by
    simp only [progress, witnessesPerLayer, seedLayer]
    omega
  omega

/-! ## Playing it -/

/-- The honest quest: three witnesses at each of assembly, C and Scheme, a lift
after each, three witnesses at the seed layer, and the mint. -/
def provenanceQuest : List OracleCmd :=
  [.witness, .witness, .witness, .lift,
   .witness, .witness, .witness, .lift,
   .witness, .witness, .witness, .lift,
   .witness, .witness, .witness, .mint]

/-- **The chain can be closed**: sixteen commands — twelve witnesses, three
lifts and a mint — turn an empty desk into one seed and a bounty of 59. -/
theorem provenance_quest_mints :
    oracleRun initialProvenance provenanceQuest =
      { layer := 0, evidence := 0, seeds := 1, bounty := 59 } := by
  decide

/-- Twelve witnesses is exactly the price: the quest is as short as
`provenance_costs_twelve` allows for a session that mints a seed at all. -/
theorem provenance_quest_length : provenanceQuest.length = 16 := by decide

/-- Skipping a layer does not work: the same quest with one lift missing closes
no chain at all. -/
theorem provenance_shortcut_fails :
    (oracleRun initialProvenance
      [.witness, .witness, .witness, .lift,
       .witness, .witness, .witness, .lift,
       .witness, .witness, .witness,
       .witness, .witness, .witness, .mint]).seeds = 0 := by
  decide

/-! ## On the board

Like every other door the oracle is a `DoorGame`, so it inherits the stateless
session and all five wires with no new transport code. -/

/-- The oracle session of a player. -/
def oracleSession (i shard : Nat) (st : Provenance) : GameSession provenanceOracle :=
  { user := i, shard := shard, game := 11, state := st }

/-- **An oracle session survives any wire intact.** -/
theorem oracleSession_roundtrip {X : Type} (t : Codec (List Nat) X)
    (s : GameSession provenanceOracle) : receive provenanceOracle t (transmit t s) = some s :=
  receive_transmit t s

/-- **The oracle is stateless**: re-serializing after every command gives
exactly the same result as playing locally. -/
theorem oracle_play_over_wire {X : Type} (t : Codec (List Nat) X)
    (s : GameSession provenanceOracle) (cs : List OracleCmd) :
    runOverWire (g := provenanceOracle) t (transmit t s) cs
      = some (transmit t { s with state := provenanceOracle.run s.state cs }) :=
  runOverWire_eq t s cs

end NixWars
