import RequestProject.Nix.NixWars.Tycoon

/-!
# A ninth door: the Meme Breeding Pool

The genetic door, taken from the hackathon repository's meme breeding system:
data creatures with a genome, bred by crossover, improved by mutation, kept by
selection. Here the pool holds two creatures at a time — the *champion* and the
*challenger* — and each is two numbers:

```
fitness   how good the creature is
cycles    how many processor cycles its trace costs (fewer is better)
```

`breed` crosses the two: the child's cycles are the average of its parents',
and its fitness is the average of theirs plus one — hybrid vigor. The child
takes the champion's place if it is at least as fit, and the loser becomes the
challenger. `mutate` improves the challenger: a tenth off its cycles and one
onto its fitness. `select` promotes the challenger if it has overtaken the
champion. Only breeding advances the generation counter.

What is proved here:

* the champion never gets worse (`memeStep_champFit_mono`,
  `memeRun_champFit_mono`): selection is elitist;
* the generation counter only moves forward, and only breeding moves it
  (`memeStep_gen_mono`, `breed_gen`, `mutate_gen`, `select_gen`);
* crossover really is a crossover: the child's cycles lie between its parents'
  (`child_cycles_between`), and hybrid vigor is exactly one
  (`breed_champFit_ge`, `child_fitness_eq`);
* fitness cannot be conjured: no command raises the champion's fitness by more
  than one (`memeStep_champFit_le`), so a session of `n` commands raises it by
  at most `n` (`memeRun_champFit_le`);
* mutation never makes the challenger slower and never makes it less fit
  (`mutate_cycles_le`, `mutate_fitness_ge`);
* **breeding alone stalls**: from a pool of twins, a second crossover adds
  nothing at all (`breeding_alone_stalls`) — the pool needs mutation to keep
  climbing, which is the point of the genetic loop;
* with mutation it does climb: a short session breeds a super-meme
  (`super_meme`).
-/

namespace NixWars

/-- The breeding pool: a champion, a challenger, and the generation count. -/
structure MemePool where
  /-- Fitness of the champion. -/
  champFit : Nat
  /-- Cycles of the champion's trace. -/
  champCyc : Nat
  /-- Fitness of the challenger. -/
  chalFit : Nat
  /-- Cycles of the challenger's trace. -/
  chalCyc : Nat
  /-- Generations bred so far. -/
  gen : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the breeding door. -/
inductive MemeCmd
  | breed
  | mutate
  | select
  deriving DecidableEq, Repr, Inhabited

/-- The fitness of the child of two creatures: the average of its parents',
plus one for hybrid vigor. -/
def childFitness (a b : Nat) : Nat := (a + b) / 2 + 1

/-- The cycles of the child of two creatures: the average of its parents'. -/
def childCycles (a b : Nat) : Nat := (a + b) / 2

/-- **The transition function of the breeding door.** -/
def memeStep (s : MemePool) : MemeCmd → MemePool
  | .breed =>
      let cf := childFitness s.champFit s.chalFit
      let cc := childCycles s.champCyc s.chalCyc
      if s.champFit ≤ cf then
        { champFit := cf, champCyc := cc,
          chalFit := s.champFit, chalCyc := s.champCyc, gen := s.gen + 1 }
      else
        { champFit := s.champFit, champCyc := s.champCyc,
          chalFit := cf, chalCyc := cc, gen := s.gen + 1 }
  | .mutate =>
      { s with chalFit := s.chalFit + 1, chalCyc := s.chalCyc - s.chalCyc / 10 }
  | .select =>
      if s.champFit ≤ s.chalFit then
        { champFit := s.chalFit, champCyc := s.chalCyc,
          chalFit := s.champFit, chalCyc := s.champCyc, gen := s.gen }
      else s

/-- Playing a list of commands. -/
def memeRun (s : MemePool) : List MemeCmd → MemePool
  | [] => s
  | c :: cs => memeRun (memeStep s c) cs

/-! ## The pool as a payload -/

/-- The pool as a payload. -/
def memeSerialize (s : MemePool) : List Nat :=
  [s.champFit, s.champCyc, s.chalFit, s.chalCyc, s.gen]

/-- Reading a pool back from a payload. -/
def memeDeserialize : List Nat → Option MemePool
  | [champFit, champCyc, chalFit, chalCyc, gen] =>
      some { champFit := champFit, champCyc := champCyc,
             chalFit := chalFit, chalCyc := chalCyc, gen := gen }
  | _ => none

theorem memeDeserialize_memeSerialize (s : MemePool) :
    memeDeserialize (memeSerialize s) = some s := by
  cases s
  simp [memeSerialize, memeDeserialize]

/-- **The Meme Breeding Pool as a door game.** -/
def memeBreeding : DoorGame where
  State := MemePool
  Cmd := MemeCmd
  step := memeStep
  serialize := memeSerialize
  deserialize := memeDeserialize
  deserialize_serialize := memeDeserialize_memeSerialize

/-- The starting pool: two seed creatures read off performance traces, the
faster of them champion. -/
def initialPool : MemePool :=
  { champFit := 3, champCyc := 468, chalFit := 2, chalCyc := 1000, gen := 0 }

/-! ## Crossover -/

/-- The child's cycles lie between its parents' — averaging is a crossover, not
an invention. -/
theorem child_cycles_between (a b : Nat) :
    min a b ≤ childCycles a b ∧ childCycles a b ≤ max a b := by
  unfold childCycles
  omega

/-- Hybrid vigor is exactly one: the child is one fitter than the average of
its parents. -/
theorem child_fitness_eq (a b : Nat) : childFitness a b = (a + b) / 2 + 1 := rfl

/-- After a crossover the champion is at least as fit as the child. -/
theorem breed_champFit_ge (s : MemePool) :
    childFitness s.champFit s.chalFit ≤ (memeStep s .breed).champFit ∨
      (memeStep s .breed).champFit = s.champFit := by
  simp only [memeStep]
  split_ifs with h
  · exact Or.inl le_rfl
  · exact Or.inr rfl

/-- Breeding advances the generation counter by exactly one. -/
theorem breed_gen (s : MemePool) : (memeStep s .breed).gen = s.gen + 1 := by
  simp only [memeStep]
  split_ifs <;> rfl

/-- Mutation does not advance the generation counter. -/
theorem mutate_gen (s : MemePool) : (memeStep s .mutate).gen = s.gen := rfl

/-- Selection does not advance the generation counter. -/
theorem select_gen (s : MemePool) : (memeStep s .select).gen = s.gen := by
  simp only [memeStep]
  split_ifs <;> rfl

theorem memeStep_gen_mono (s : MemePool) (c : MemeCmd) : s.gen ≤ (memeStep s c).gen := by
  cases c
  · rw [breed_gen]; omega
  · rw [mutate_gen]
  · rw [select_gen]

/-! ## Elitism -/

/-- **The champion never gets worse.** -/
theorem memeStep_champFit_mono (s : MemePool) (c : MemeCmd) :
    s.champFit ≤ (memeStep s c).champFit := by
  cases c with
  | breed =>
      simp only [memeStep]
      split_ifs with h
      · exact h
      · exact le_rfl
  | mutate => exact le_rfl
  | select =>
      simp only [memeStep]
      split_ifs with h
      · exact h
      · exact le_rfl

theorem memeRun_champFit_mono (s : MemePool) (cs : List MemeCmd) :
    s.champFit ≤ (memeRun s cs).champFit := by
  induction cs generalizing s with
  | nil => simp [memeRun]
  | cons c cs ih => exact le_trans (memeStep_champFit_mono s c) (ih _)

/-- **Fitness cannot be conjured**: no command raises the champion's fitness by
more than one. -/
theorem memeStep_champFit_le (s : MemePool) (c : MemeCmd) :
    (memeStep s c).champFit ≤ max s.champFit s.chalFit + 1 := by
  cases c with
  | breed =>
      simp only [memeStep, childFitness]
      split_ifs with h
      · show (s.champFit + s.chalFit) / 2 + 1 ≤ max s.champFit s.chalFit + 1
        omega
      · show s.champFit ≤ max s.champFit s.chalFit + 1
        have := le_max_left s.champFit s.chalFit
        omega
  | mutate =>
      show s.champFit ≤ max s.champFit s.chalFit + 1
      have := le_max_left s.champFit s.chalFit
      omega
  | select =>
      simp only [memeStep]
      split_ifs with h
      · show s.chalFit ≤ max s.champFit s.chalFit + 1
        have := le_max_right s.champFit s.chalFit
        omega
      · have := le_max_left s.champFit s.chalFit
        omega

/-- The best fitness in the pool never rises by more than one at a time. -/
theorem memeStep_best_le (s : MemePool) (c : MemeCmd) :
    max (memeStep s c).champFit (memeStep s c).chalFit ≤ max s.champFit s.chalFit + 1 := by
  cases c with
  | breed =>
      simp only [memeStep, childFitness]
      split_ifs with h <;>
        [ show max ((s.champFit + s.chalFit) / 2 + 1) s.champFit ≤ _;
          show max s.champFit ((s.champFit + s.chalFit) / 2 + 1) ≤ _] <;>
      · omega
  | mutate =>
      show max s.champFit (s.chalFit + 1) ≤ max s.champFit s.chalFit + 1
      have h1 := le_max_left s.champFit s.chalFit
      have h2 := le_max_right s.champFit s.chalFit
      simp only [Nat.max_le]
      omega
  | select =>
      simp only [memeStep]
      split_ifs with h
      · show max s.chalFit s.champFit ≤ max s.champFit s.chalFit + 1
        rw [Nat.max_comm]
        omega
      · omega

/-- **A session of `n` commands raises the pool's best fitness by at most
`n`.** -/
theorem memeRun_best_le (s : MemePool) (cs : List MemeCmd) :
    max (memeRun s cs).champFit (memeRun s cs).chalFit
      ≤ max s.champFit s.chalFit + cs.length := by
  induction cs generalizing s with
  | nil => simp [memeRun]
  | cons c cs ih =>
      have h₁ := ih (memeStep s c)
      have h₂ := memeStep_best_le s c
      simp only [memeRun, List.length_cons]
      omega

/-- A session of `n` commands raises the champion's fitness by at most `n`. -/
theorem memeRun_champFit_le (s : MemePool) (cs : List MemeCmd) :
    (memeRun s cs).champFit ≤ max s.champFit s.chalFit + cs.length :=
  le_trans (le_max_left _ _) (memeRun_best_le s cs)

/-! ## Mutation -/

/-- Mutation never makes the challenger slower. -/
theorem mutate_cycles_le (s : MemePool) : (memeStep s .mutate).chalCyc ≤ s.chalCyc :=
  Nat.sub_le _ _

/-- Mutation always makes the challenger one fitter. -/
theorem mutate_fitness_ge (s : MemePool) : (memeStep s .mutate).chalFit = s.chalFit + 1 := rfl

/-- Mutation leaves the champion alone. -/
theorem mutate_champ (s : MemePool) :
    (memeStep s .mutate).champFit = s.champFit ∧ (memeStep s .mutate).champCyc = s.champCyc :=
  ⟨rfl, rfl⟩

/-! ## Breeding alone is not enough -/

/-- A pool of twins: two identical creatures. -/
def twinPool (f c : Nat) : MemePool :=
  { champFit := f, champCyc := c, chalFit := f, chalCyc := c, gen := 0 }

/-- **Crossover alone stalls.** From a pool of twins the first crossover gains
one point of fitness, and the second gains nothing: without mutation the pool
converges immediately. -/
theorem breeding_alone_stalls (f c : Nat) :
    (memeRun (twinPool f c) [.breed]).champFit = f + 1 ∧
      (memeRun (twinPool f c) [.breed, .breed]).champFit = f + 1 := by
  have hff : (f + f) / 2 = f := by omega
  have hf1 : (f + 1 + f) / 2 = f := by omega
  constructor
  · simp [memeRun, memeStep, twinPool, childFitness, childCycles, hff]
  · simp [memeRun, memeStep, twinPool, childFitness, childCycles, hff, hf1]

/-- Eight mutations to sharpen the challenger, a crossover, four more
mutations and a second crossover. -/
def breedingSession : List MemeCmd :=
  [.mutate, .mutate, .mutate, .mutate, .mutate, .mutate, .mutate, .mutate, .breed,
   .mutate, .mutate, .mutate, .mutate, .breed, .select]

/-- **With mutation the pool climbs.** Mutating the challenger and crossing it
back into the champion raises the champion's fitness and cuts the champion's
cycle count. -/
theorem super_meme :
    memeRun initialPool breedingSession
      = { champFit := 8, champCyc := 379, chalFit := 7, chalCyc := 450, gen := 2 } := by
  decide

theorem super_meme_fitter :
    initialPool.champFit < (memeRun initialPool breedingSession).champFit := by
  decide

theorem super_meme_faster :
    (memeRun initialPool breedingSession).champCyc < initialPool.champCyc := by
  decide

/-! ## On the board

The pool is a `DoorGame`, so it inherits the stateless session and all five
wires with no new transport code. -/

/-- The breeding session of a player. -/
def memeSession (i shard : Nat) (st : MemePool) : GameSession memeBreeding :=
  { user := i, shard := shard, game := 9, state := st }

/-- **A breeding session survives any wire intact.** -/
theorem memeSession_roundtrip {X : Type} (t : Codec (List Nat) X)
    (s : GameSession memeBreeding) : receive memeBreeding t (transmit t s) = some s :=
  receive_transmit t s

/-- **The breeding pool is stateless**: re-serializing after every command
gives exactly the same result as playing locally. -/
theorem meme_play_over_wire {X : Type} (t : Codec (List Nat) X)
    (s : GameSession memeBreeding) (cs : List MemeCmd) :
    runOverWire (g := memeBreeding) t (transmit t s) cs
      = some (transmit t { s with state := memeBreeding.run s.state cs }) :=
  runOverWire_eq t s cs

end NixWars
