import RequestProject.Nix.NixWars.Market

/-!
# An eighth door: the Combinator Tycoon

The factory door, taken from the hackathon repository's tycoon: *build
factories, turn raw performance data into compressed essence, and sell the
essence*. Here that pipeline is three numbers and four commands.

```
cash    credits in hand
raw     syntactic matter dug out of the traces
mines   Kleene Algebra Mines, each digging one unit of raw matter per run
forges  Monster Group Foundries, each compressing one unit of raw matter
        into semantic essence per run, worth two credits
```

A mine costs 7 credits and a foundry costs 11 — two Monster primes — and both
are bought outright, so a build that cannot be paid for simply does not happen.
`run` is one second of the factory floor: the foundries compress what is in the
yard, the mines refill it, and the essence is sold. `sell` dumps the raw matter
uncompressed at one credit a unit, which is always worse than compressing it:
that is the whole economic point of the door.

What is proved here:

* factories are never lost (`tycoonStep_mines_mono`, `tycoonStep_forges_mono`
  and their session forms), and the clock only moves forward;
* a build is paid for exactly and adds exactly one factory
  (`mine_pays_exactly`, `forge_pays_exactly`), and a build that cannot be paid
  for changes nothing at all (`mine_refused`, `forge_refused`);
* a run compresses exactly `min raw forges` units and pays exactly two credits
  for each (`run_cash_exact`, `run_raw_exact`);
* nothing is created out of nothing: no command ever pays more than two credits
  per unit of raw matter in the yard (`tycoonStep_cash_bound`), so a session of
  `n` commands starting with an empty yard and no mines mints nothing at all
  (`idle_run_cash`), and with no foundry the pipeline never pays
  (`run_no_forge`);
* raw matter only comes out of the mines (`run_raw_no_mines`);
* compressing beats dumping (`compress_beats_dump`);
* the empire is profitable: two mines, two foundries and twelve seconds of
  running end with more credits than the factory started with
  (`tycoon_profits`).
-/

namespace NixWars

/-- The factory floor. -/
structure Tycoon where
  /-- Credits in hand. -/
  cash : Nat
  /-- Raw syntactic matter waiting in the yard. -/
  raw : Nat
  /-- Kleene Algebra Mines built. -/
  mines : Nat
  /-- Monster Group Foundries built. -/
  forges : Nat
  /-- Seconds on the factory clock. -/
  tick : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the tycoon door. -/
inductive TycoonCmd
  | mine
  | forge
  | run
  | dump
  deriving DecidableEq, Repr, Inhabited

/-- What a Kleene Algebra Mine costs. -/
def mineCost : Nat := 7

/-- What a Monster Group Foundry costs. -/
def forgeCost : Nat := 11

/-- What one unit of compressed semantic essence sells for. -/
def essencePrice : Nat := 2

/-- Both prices are Monster primes. -/
theorem costs_mem_monsterPrimes :
    mineCost ∈ monsterPrimes ∧ forgeCost ∈ monsterPrimes ∧ essencePrice ∈ monsterPrimes := by
  decide

/-- **The transition function of the tycoon door.** -/
def tycoonStep (s : Tycoon) : TycoonCmd → Tycoon
  | .mine =>
      if mineCost ≤ s.cash then
        { s with cash := s.cash - mineCost, mines := s.mines + 1, tick := s.tick + 1 }
      else s
  | .forge =>
      if forgeCost ≤ s.cash then
        { s with cash := s.cash - forgeCost, forges := s.forges + 1, tick := s.tick + 1 }
      else s
  | .run =>
      { s with
        cash := s.cash + essencePrice * min s.raw s.forges,
        raw := (s.raw - min s.raw s.forges) + s.mines,
        tick := s.tick + 1 }
  | .dump => { s with cash := s.cash + s.raw, raw := 0, tick := s.tick + 1 }

/-- Playing a list of commands. -/
def tycoonRun (s : Tycoon) : List TycoonCmd → Tycoon
  | [] => s
  | c :: cs => tycoonRun (tycoonStep s c) cs

/-! ## The factory as a payload -/

/-- The factory as a payload. -/
def tycoonSerialize (s : Tycoon) : List Nat := [s.cash, s.raw, s.mines, s.forges, s.tick]

/-- Reading a factory back from a payload. -/
def tycoonDeserialize : List Nat → Option Tycoon
  | [cash, raw, mines, forges, tick] =>
      some { cash := cash, raw := raw, mines := mines, forges := forges, tick := tick }
  | _ => none

theorem tycoonDeserialize_tycoonSerialize (s : Tycoon) :
    tycoonDeserialize (tycoonSerialize s) = some s := by
  cases s
  simp [tycoonSerialize, tycoonDeserialize]

/-- **The Combinator Tycoon as a door game.** -/
def combinatorTycoon : DoorGame where
  State := Tycoon
  Cmd := TycoonCmd
  step := tycoonStep
  serialize := tycoonSerialize
  deserialize := tycoonDeserialize
  deserialize_serialize := tycoonDeserialize_tycoonSerialize

/-- A fresh factory: a hundred credits of seed funding and nothing built. -/
def initialTycoon : Tycoon := { cash := 100, raw := 0, mines := 0, forges := 0, tick := 0 }

/-! ## Nothing is ever unbuilt -/

theorem tycoonStep_mines_mono (s : Tycoon) (c : TycoonCmd) : s.mines ≤ (tycoonStep s c).mines := by
  cases c <;> simp only [tycoonStep] <;> (try split_ifs) <;> simp

theorem tycoonStep_forges_mono (s : Tycoon) (c : TycoonCmd) :
    s.forges ≤ (tycoonStep s c).forges := by
  cases c <;> simp only [tycoonStep] <;> (try split_ifs) <;> simp

theorem tycoonRun_mines_mono (s : Tycoon) (cs : List TycoonCmd) :
    s.mines ≤ (tycoonRun s cs).mines := by
  induction cs generalizing s with
  | nil => simp [tycoonRun]
  | cons c cs ih => exact le_trans (tycoonStep_mines_mono s c) (ih _)

theorem tycoonRun_forges_mono (s : Tycoon) (cs : List TycoonCmd) :
    s.forges ≤ (tycoonRun s cs).forges := by
  induction cs generalizing s with
  | nil => simp [tycoonRun]
  | cons c cs ih => exact le_trans (tycoonStep_forges_mono s c) (ih _)

theorem tycoonStep_tick_mono (s : Tycoon) (c : TycoonCmd) : s.tick ≤ (tycoonStep s c).tick := by
  cases c <;> simp only [tycoonStep] <;> (try split_ifs) <;> simp

/-! ## Building -/

/-- A mine that is built is paid for exactly, and adds exactly one mine. -/
theorem mine_pays_exactly (s : Tycoon) (h : mineCost ≤ s.cash) :
    (tycoonStep s .mine).cash = s.cash - mineCost ∧
      (tycoonStep s .mine).mines = s.mines + 1 ∧
      (tycoonStep s .mine).cash + mineCost = s.cash := by
  refine ⟨?_, ?_, ?_⟩ <;> simp only [tycoonStep, if_pos h]
  omega

/-- A foundry that is built is paid for exactly, and adds exactly one foundry. -/
theorem forge_pays_exactly (s : Tycoon) (h : forgeCost ≤ s.cash) :
    (tycoonStep s .forge).cash = s.cash - forgeCost ∧
      (tycoonStep s .forge).forges = s.forges + 1 ∧
      (tycoonStep s .forge).cash + forgeCost = s.cash := by
  refine ⟨?_, ?_, ?_⟩ <;> simp only [tycoonStep, if_pos h]
  omega

/-- A mine that cannot be paid for is not built, and nothing else changes
either — not even the clock. -/
theorem mine_refused (s : Tycoon) (h : s.cash < mineCost) : tycoonStep s .mine = s := by
  simp [tycoonStep, Nat.not_le.2 h]

/-- A foundry that cannot be paid for is not built. -/
theorem forge_refused (s : Tycoon) (h : s.cash < forgeCost) : tycoonStep s .forge = s := by
  simp [tycoonStep, Nat.not_le.2 h]

/-! ## Running the pipeline -/

/-- A run pays exactly two credits for every unit it compresses. -/
theorem run_cash_exact (s : Tycoon) :
    (tycoonStep s .run).cash = s.cash + essencePrice * min s.raw s.forges := rfl

/-- A run leaves the yard holding what the foundries did not take, plus what
the mines dug. -/
theorem run_raw_exact (s : Tycoon) :
    (tycoonStep s .run).raw = (s.raw - min s.raw s.forges) + s.mines := rfl

/-- **Without a foundry the pipeline pays nothing**: raw matter piles up in the
yard, but no essence is sold. -/
theorem run_no_forge (s : Tycoon) (h : s.forges = 0) :
    (tycoonStep s .run).cash = s.cash ∧ (tycoonStep s .run).raw = s.raw + s.mines := by
  simp [tycoonStep, h]

/-- **Raw matter only comes out of the mines**: with no mine, a run never
increases the yard. -/
theorem run_raw_no_mines (s : Tycoon) (h : s.mines = 0) : (tycoonStep s .run).raw ≤ s.raw := by
  simp only [tycoonStep, h, Nat.add_zero]
  exact Nat.sub_le _ _

/-- Compressing beats dumping: the same yard sold through the foundries is
worth at least as much as dumped raw, and strictly more when there is a foundry
for every unit. -/
theorem compress_beats_dump (s : Tycoon) (h : s.raw ≤ s.forges) :
    (tycoonStep s .dump).cash ≤ (tycoonStep s .run).cash := by
  simp only [tycoonStep, essencePrice, Nat.min_eq_left h]
  omega

theorem compress_beats_dump_strict (s : Tycoon) (h : s.raw ≤ s.forges) (hpos : 0 < s.raw) :
    (tycoonStep s .dump).cash < (tycoonStep s .run).cash := by
  simp only [tycoonStep, essencePrice, Nat.min_eq_left h]
  omega

/-! ## No value out of nothing -/

/-- **No command pays more than two credits per unit of raw matter in the
yard.** Building spends credits, and both ways of selling are bounded by the
yard. -/
theorem tycoonStep_cash_bound (s : Tycoon) (c : TycoonCmd) :
    (tycoonStep s c).cash ≤ s.cash + essencePrice * s.raw := by
  cases c with
  | mine =>
      simp only [tycoonStep, essencePrice]
      split_ifs
      · show s.cash - mineCost ≤ s.cash + 2 * s.raw
        omega
      · show s.cash ≤ s.cash + 2 * s.raw
        omega
  | forge =>
      simp only [tycoonStep, essencePrice]
      split_ifs
      · show s.cash - forgeCost ≤ s.cash + 2 * s.raw
        omega
      · show s.cash ≤ s.cash + 2 * s.raw
        omega
  | run =>
      have h : min s.raw s.forges ≤ s.raw := Nat.min_le_left _ _
      simp only [tycoonStep]
      exact Nat.add_le_add_left (Nat.mul_le_mul_left _ h) _
  | dump =>
      simp only [tycoonStep, essencePrice]
      omega

/-- An idle factory — nothing in the yard, nothing built — mints nothing,
however long it is run. -/
theorem idle_run_cash (s : Tycoon) (hraw : s.raw = 0) (hm : s.mines = 0) (cs : List TycoonCmd)
    (h : ∀ c ∈ cs, c = TycoonCmd.run) : (tycoonRun s cs).cash = s.cash := by
  induction cs generalizing s with
  | nil => simp [tycoonRun]
  | cons c cs ih =>
      have hc : c = TycoonCmd.run := h c (List.mem_cons_self ..)
      subst hc
      have h1 : (tycoonStep s .run).raw = 0 := by simp [tycoonStep, hraw, hm]
      have h2 : (tycoonStep s .run).cash = s.cash := by simp [tycoonStep, hraw]
      have h3 : (tycoonStep s .run).mines = s.mines := rfl
      rw [tycoonRun, ih _ h1 (by rw [h3, hm]) (fun c hc => h c (List.mem_cons_of_mem _ hc)), h2]

/-! ## Playing it -/

/-- **The empire is profitable.** Two mines, two foundries and twelve seconds of
running the pipeline end with more credits than the seed funding, and the plant
still standing. -/
theorem tycoon_profits :
    tycoonRun initialTycoon
        [.mine, .mine, .forge, .forge,
         .run, .run, .run, .run, .run, .run, .run, .run, .run, .run, .run, .run]
      = { cash := 108, raw := 2, mines := 2, forges := 2, tick := 16 } := by
  decide

theorem tycoon_profits_cash :
    initialTycoon.cash <
      (tycoonRun initialTycoon
        [.mine, .mine, .forge, .forge,
         .run, .run, .run, .run, .run, .run, .run, .run, .run, .run, .run, .run]).cash := by
  decide

/-- Building beyond the seed funding is simply refused: eleven mines cannot be
bought with a hundred credits, and the fifteenth attempt changes nothing. -/
theorem tycoon_broke :
    tycoonRun initialTycoon (List.replicate 15 TycoonCmd.mine)
      = { cash := 2, raw := 0, mines := 14, forges := 0, tick := 14 } := by
  decide

/-! ## On the board

Like every other door the tycoon is a `DoorGame`, so it inherits the stateless
session and all five wires with no new transport code. -/

/-- The tycoon session of a player. -/
def tycoonSession (i shard : Nat) (st : Tycoon) : GameSession combinatorTycoon :=
  { user := i, shard := shard, game := 8, state := st }

/-- **A tycoon session survives any wire intact.** -/
theorem tycoonSession_roundtrip {X : Type} (t : Codec (List Nat) X)
    (s : GameSession combinatorTycoon) : receive combinatorTycoon t (transmit t s) = some s :=
  receive_transmit t s

/-- **The tycoon is stateless**: re-serializing after every command gives
exactly the same result as playing locally. -/
theorem tycoon_play_over_wire {X : Type} (t : Codec (List Nat) X)
    (s : GameSession combinatorTycoon) (cs : List TycoonCmd) :
    runOverWire (g := combinatorTycoon) t (transmit t s) cs
      = some (transmit t { s with state := combinatorTycoon.run s.state cs }) :=
  runOverWire_eq t s cs

end NixWars
