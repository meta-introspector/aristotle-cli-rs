import RequestProject.Nix.NixWars.Qbert
import RequestProject.Nix.NixWars.Invaders

/-!
# Training an agent to play the doors

A door game is a deterministic transition system, so an *agent* is nothing more
than a plan: a list of commands. This file builds, inside Lean, the whole loop
the request asks for —

* **play**: a plan is rolled out against a door game (`outcome`, `value`);
* **record**: every state the agent passed through is kept (`traceFrom`), and
  the recording is proved faithful — the last frame of the tape is exactly the
  state the game ends in (`traceFrom_getLast`), and every cut of the tape is
  one step of the game (`traceFrom_step`);
* **critique**: the critic marks the commands that changed nothing
  (`critique`), and the rewrite `prune` removes exactly those, proved to leave
  the outcome alone (`run_prune`), never to lengthen the plan
  (`prune_length_le`) and to leave nothing for the critic to say
  (`tight_prune`);
* **improve**: one round of training takes the champion, breeds a generation of
  challengers out of it (every one-command extension, the pruned champion, and
  a library of games recorded elsewhere) and keeps the best. Training never
  makes the champion worse (`train_ge`), more rounds are never worse than fewer
  (`train_le_train_add`), and anything in the library is matched or beaten
  (`train_ge_library`);
* **learn from other games**: a game recorded at a different cabinet is carried
  over by translating its commands (`transfer`), and a bigger library is never
  worse than a smaller one (`bestOf_mono_pool`).

Everything is generic in the `DoorGame`, then instantiated on two cabinets of
the arcade: Monster Cubes (door 13) and Shard Invaders (door 15). The agent
trained here is not a metaphor — `qbertLearned` is *computed* by the training
loop, and `qbert_learned_clears` says the plan it found paints all ten cubes.
-/

set_option maxRecDepth 40000
set_option maxHeartbeats 2000000

namespace NixWars

namespace Learn

variable {g : DoorGame}

/-! ## Playing and scoring -/

/-- The state a plan leads to. -/
def outcome (g : DoorGame) (start : g.State) (p : List g.Cmd) : g.State :=
  g.run start p

/-- What a plan is worth: the reward of the state it leads to. -/
def value (g : DoorGame) (reward : g.State → Nat) (start : g.State) (p : List g.Cmd) : Nat :=
  reward (outcome g start p)

@[simp] theorem value_nil (reward : g.State → Nat) (start : g.State) :
    value g reward start [] = reward start := rfl

/-! ## Recording a game -/

/-- The tape: every state the agent passes through, starting with `s`. -/
def traceFrom (g : DoorGame) (s : g.State) : List g.Cmd → List g.State
  | [] => [s]
  | c :: cs => s :: traceFrom g (g.step s c) cs

/-- **Every cut in the tape is one command of the game.** -/
theorem traceFrom_step (s : g.State) (c : g.Cmd) (cs : List g.Cmd) :
    traceFrom g s (c :: cs) = s :: traceFrom g (g.step s c) cs := rfl

theorem traceFrom_ne_nil (s : g.State) (p : List g.Cmd) : traceFrom g s p ≠ [] := by
  cases p <;> simp [traceFrom]

/-- A recording has one frame per command, plus the opening frame. -/
theorem traceFrom_length (s : g.State) (p : List g.Cmd) :
    (traceFrom g s p).length = p.length + 1 := by
  induction p generalizing s with
  | nil => rfl
  | cons c cs ih => simp [traceFrom, ih]

/-- The recording opens on the state the agent started in. -/
theorem traceFrom_head (s : g.State) (p : List g.Cmd) :
    (traceFrom g s p).head? = some s := by
  cases p <;> rfl

/-- **The recording is faithful.** Its last frame is the state the game really
ends in, so replaying the tape and playing the game agree. -/
theorem traceFrom_getLast (s : g.State) (p : List g.Cmd) :
    (traceFrom g s p).getLast? = some (g.run s p) := by
  induction p generalizing s with
  | nil => rfl
  | cons c cs ih =>
      cases cs with
      | nil => rfl
      | cons d ds =>
          rw [traceFrom_step, traceFrom_step, List.getLast?_cons_cons, ← traceFrom_step]
          exact ih (g.step s c)

/-! ## Improving: keeping the best of a generation -/

/-- Keep the best plan in the pool, defending the incumbent on a tie. -/
def bestOf (g : DoorGame) (reward : g.State → Nat) (start : g.State) :
    List (List g.Cmd) → List g.Cmd → List g.Cmd
  | [], champ => champ
  | p :: ps, champ =>
      bestOf g reward start ps
        (if value g reward start champ < value g reward start p then p else champ)

/-- The winner of a round is the incumbent or one of the challengers. -/
theorem bestOf_eq_or_mem (reward : g.State → Nat) (start : g.State)
    (ps : List (List g.Cmd)) (champ : List g.Cmd) :
    bestOf g reward start ps champ = champ ∨ bestOf g reward start ps champ ∈ ps := by
  induction ps generalizing champ with
  | nil => exact Or.inl rfl
  | cons p ps ih =>
      rw [bestOf]
      by_cases h : value g reward start champ < value g reward start p
      · simp only [h, if_pos]
        rcases ih p with hh | hh
        · exact Or.inr (by rw [hh]; exact List.mem_cons_self)
        · exact Or.inr (List.mem_cons_of_mem _ hh)
      · simp only [h, if_false]
        rcases ih champ with hh | hh
        · exact Or.inl hh
        · exact Or.inr (List.mem_cons_of_mem _ hh)

/-- **A round of training never makes the champion worse.** -/
theorem bestOf_ge_champ (reward : g.State → Nat) (start : g.State)
    (ps : List (List g.Cmd)) (champ : List g.Cmd) :
    value g reward start champ ≤ value g reward start (bestOf g reward start ps champ) := by
  induction ps generalizing champ with
  | nil => exact Nat.le_refl _
  | cons p ps ih =>
      rw [bestOf]
      by_cases h : value g reward start champ < value g reward start p
      · simp only [h, if_pos]
        exact Nat.le_trans (Nat.le_of_lt h) (ih p)
      · simp only [h, if_false]
        exact ih champ

/-- **A round of training matches or beats every challenger it saw.** -/
theorem bestOf_ge_mem (reward : g.State → Nat) (start : g.State)
    (ps : List (List g.Cmd)) (champ : List g.Cmd) {q : List g.Cmd} (hq : q ∈ ps) :
    value g reward start q ≤ value g reward start (bestOf g reward start ps champ) := by
  induction ps generalizing champ with
  | nil => cases hq
  | cons p ps ih =>
      rw [bestOf]
      rcases List.mem_cons.mp hq with hh | hh
      · subst hh
        by_cases h : value g reward start champ < value g reward start q
        · simp only [h, if_pos]
          exact bestOf_ge_champ reward start ps q
        · simp only [h, if_false]
          exact Nat.le_trans (Nat.le_of_not_lt h) (bestOf_ge_champ reward start ps champ)
      · by_cases h : value g reward start champ < value g reward start p
        · simp only [h, if_pos]
          exact ih p hh
        · simp only [h, if_false]
          exact ih champ hh

/-- **More data is never worse.** Training on a pool that contains another pool
does at least as well as training on the smaller one — this is what makes
watching other players, and other games, worth doing. -/
theorem bestOf_mono_pool (reward : g.State → Nat) (start : g.State)
    {ps qs : List (List g.Cmd)} (h : ps ⊆ qs) (champ : List g.Cmd) :
    value g reward start (bestOf g reward start ps champ) ≤
      value g reward start (bestOf g reward start qs champ) := by
  rcases bestOf_eq_or_mem reward start ps champ with hh | hh
  · rw [hh]; exact bestOf_ge_champ reward start qs champ
  · exact bestOf_ge_mem reward start qs champ (h hh)

/-! ## The critic -/

section Critic

variable [DecidableEq g.State]

/-- The critic's notes: the positions, counted from the start of the plan, at
which the agent played a command that changed nothing. -/
def critiqueFrom (g : DoorGame) [DecidableEq g.State] (s : g.State) (i : Nat) :
    List g.Cmd → List Nat
  | [] => []
  | c :: cs =>
      if g.step s c = s then i :: critiqueFrom g (g.step s c) (i + 1) cs
      else critiqueFrom g (g.step s c) (i + 1) cs

/-- The critic's notes on a plan played from the opening state. -/
def critique (g : DoorGame) [DecidableEq g.State] (s : g.State) (p : List g.Cmd) : List Nat :=
  critiqueFrom g s 0 p

/-- The rewrite the critic suggests: drop every command that changes nothing. -/
def prune (g : DoorGame) [DecidableEq g.State] (s : g.State) : List g.Cmd → List g.Cmd
  | [] => []
  | c :: cs =>
      if g.step s c = s then prune g (g.step s c) cs else c :: prune g (g.step s c) cs

theorem prune_cons (s : g.State) (c : g.Cmd) (cs : List g.Cmd) :
    prune g s (c :: cs) =
      if g.step s c = s then prune g (g.step s c) cs else c :: prune g (g.step s c) cs := rfl

/-- **The critic's rewrite is sound**: the pruned plan ends in exactly the same
state as the original. -/
theorem run_prune (s : g.State) (p : List g.Cmd) :
    g.run s (prune g s p) = g.run s p := by
  induction p generalizing s with
  | nil => rfl
  | cons c cs ih =>
      by_cases h : g.step s c = s
      · rw [prune_cons, if_pos h, DoorGame.run_cons, h]
        exact ih s
      · rw [prune_cons, if_neg h, DoorGame.run_cons, DoorGame.run_cons]
        exact ih (g.step s c)

/-- The pruned plan is worth exactly what the original was worth. -/
theorem value_prune (reward : g.State → Nat) (start : g.State) (p : List g.Cmd) :
    value g reward start (prune g start p) = value g reward start p := by
  simp [value, outcome, run_prune]

/-- Pruning never makes a plan longer. -/
theorem prune_length_le (s : g.State) (p : List g.Cmd) :
    (prune g s p).length ≤ p.length := by
  induction p generalizing s with
  | nil => exact Nat.le_refl 0
  | cons c cs ih =>
      by_cases h : g.step s c = s
      · rw [prune_cons, if_pos h, List.length_cons]
        exact Nat.le_succ_of_le (ih (g.step s c))
      · rw [prune_cons, if_neg h, List.length_cons, List.length_cons]
        exact Nat.succ_le_succ (ih (g.step s c))

/-- A plan the critic has nothing to say about: every command moves the game. -/
def Tight (g : DoorGame) (s : g.State) : List g.Cmd → Prop
  | [] => True
  | c :: cs => g.step s c ≠ s ∧ Tight g (g.step s c) cs

/-- **The critic's rewrite is complete**: after pruning, no command is wasted. -/
theorem tight_prune (s : g.State) (p : List g.Cmd) : Tight g s (prune g s p) := by
  induction p generalizing s with
  | nil => trivial
  | cons c cs ih =>
      by_cases h : g.step s c = s
      · rw [prune_cons, if_pos h, h]
        exact ih s
      · rw [prune_cons, if_neg h]
        exact ⟨h, ih (g.step s c)⟩

/-! ## The training loop -/

/-- The challengers a champion breeds: every one-command extension of it, the
critic's pruned version of it, and the library of games recorded elsewhere. -/
def generation (g : DoorGame) [DecidableEq g.State] (cmds : List g.Cmd)
    (library : List (List g.Cmd)) (start : g.State) (champ : List g.Cmd) : List (List g.Cmd) :=
  cmds.map (fun c => champ ++ [c]) ++ prune g start champ :: library

theorem library_subset_generation (cmds : List g.Cmd) (library : List (List g.Cmd))
    (start : g.State) (champ : List g.Cmd) :
    library ⊆ generation g cmds library start champ := by
  intro q hq
  exact List.mem_append_right _ (List.mem_cons_of_mem _ hq)

/-- The training loop: `n` rounds of breed-and-keep-the-best. -/
def train (g : DoorGame) [DecidableEq g.State] (reward : g.State → Nat) (start : g.State)
    (cmds : List g.Cmd) (library : List (List g.Cmd)) : Nat → List g.Cmd → List g.Cmd
  | 0, champ => champ
  | n + 1, champ =>
      train g reward start cmds library n
        (bestOf g reward start (generation g cmds library start champ) champ)

/-- **Training never makes the agent worse.** -/
theorem train_ge (reward : g.State → Nat) (start : g.State) (cmds : List g.Cmd)
    (library : List (List g.Cmd)) (n : Nat) (champ : List g.Cmd) :
    value g reward start champ ≤
      value g reward start (train g reward start cmds library n champ) := by
  induction n generalizing champ with
  | zero => exact Nat.le_refl _
  | succ n ih =>
      rw [train]
      exact Nat.le_trans (bestOf_ge_champ reward start _ champ) (ih _)

/-- Training for `n + m` rounds is training for `m` rounds on top of `n`. -/
theorem train_add (reward : g.State → Nat) (start : g.State) (cmds : List g.Cmd)
    (library : List (List g.Cmd)) (n m : Nat) (champ : List g.Cmd) :
    train g reward start cmds library (n + m) champ =
      train g reward start cmds library m (train g reward start cmds library n champ) := by
  induction n generalizing champ with
  | zero => rw [Nat.zero_add]; rfl
  | succ n ih =>
      have hnm : n + 1 + m = (n + m) + 1 := by omega
      rw [hnm, train, train, ih]

/-- **Longer training is never worse.** -/
theorem train_le_train_add (reward : g.State → Nat) (start : g.State) (cmds : List g.Cmd)
    (library : List (List g.Cmd)) (n m : Nat) (champ : List g.Cmd) :
    value g reward start (train g reward start cmds library n champ) ≤
      value g reward start (train g reward start cmds library (n + m) champ) := by
  rw [train_add]
  exact train_ge reward start cmds library m _

/-- **The agent learns from the games it is shown.** After a single round of
training the agent is at least as good as any game in its library — including
games recorded by other players, or carried over from another cabinet. -/
theorem train_ge_library (reward : g.State → Nat) (start : g.State) (cmds : List g.Cmd)
    (library : List (List g.Cmd)) (n : Nat) (champ : List g.Cmd) {q : List g.Cmd}
    (hq : q ∈ library) :
    value g reward start q ≤
      value g reward start (train g reward start cmds library (n + 1) champ) := by
  rw [Nat.add_comm, train_add, train]
  refine Nat.le_trans ?_ (train_ge reward start cmds library n _)
  exact bestOf_ge_mem reward start _ champ (library_subset_generation cmds library start champ hq)

end Critic

/-! ## Carrying a game over from another cabinet -/

/-- A game recorded at one cabinet, read as a plan for another: translate the
commands. -/
def transfer {g₁ g₂ : DoorGame} (f : g₁.Cmd → g₂.Cmd) (p : List g₁.Cmd) : List g₂.Cmd :=
  p.map f

@[simp] theorem transfer_length {g₁ g₂ : DoorGame} (f : g₁.Cmd → g₂.Cmd) (p : List g₁.Cmd) :
    (transfer f p).length = p.length := List.length_map _

end Learn

/-! ## The agent at the Monster Cubes cabinet (door 13) -/

/-- The cabinet's states can be told apart, which is what the critic needs. -/
instance : DecidableEq monsterCubes.State := (inferInstance : DecidableEq Qbert)

/-- Likewise at the invaders cabinet. -/
instance : DecidableEq shardInvaders.State := (inferInstance : DecidableEq Invaders)

/-- What the Monster Cubes agent is scored on: ten points a painted cube, one
point a life still in hand. -/
def qbertReward (s : Qbert) : Nat := 10 * qbertPainted s + s.lives

/-- The joystick of the cabinet. -/
def qbertCmds : List QbertCmd := [.dl, .dr, .ul, .ur]

/-- The recorded game the agent is shown: the clearing run of `qbert_winnable`,
as a tape in the library. -/
def qbertLibrary : List (List QbertCmd) := [qbertClearingRun]

/-- The agent trained at the cabinet from nothing: twelve rounds of
breed-and-keep-the-best, with no recorded games at all. -/
def qbertSelfPlayed : List QbertCmd :=
  Learn.train monsterCubes qbertReward initialQbert qbertCmds [] 12 []

/-- The agent trained at the cabinet with the recorded game in its library. -/
def qbertLearned : List QbertCmd :=
  Learn.train monsterCubes qbertReward initialQbert qbertCmds qbertLibrary 12 []

/-- The tape the trained agent records when it plays. -/
def qbertLearnedTape : List Qbert :=
  Learn.traceFrom monsterCubes initialQbert qbertLearned

/-! ## The agent at the Shard Invaders cabinet (door 15) -/

/-- What the Shard Invaders agent is scored on: ten points an invader shot
down, one point a row the rank has not dropped. -/
def invadersReward (s : Invaders) : Nat := 10 * (5 - invadersAlive s) + (5 - s.dy)

/-- The controls of the cabinet. -/
def invadersCmds : List InvadersCmd := [.left, .right, .fire, .tick]

/-- The recorded game: the clearing run of `invaders_winnable`. -/
def invadersLibrary : List (List InvadersCmd) := [invadersClearingRun]

/-- The agent trained at the invaders cabinet. -/
def invadersLearned : List InvadersCmd :=
  Learn.train shardInvaders invadersReward initialInvaders invadersCmds invadersLibrary 10 []

/-- The agent trained at the invaders cabinet with no recorded games. -/
def invadersSelfPlayed : List InvadersCmd :=
  Learn.train shardInvaders invadersReward initialInvaders invadersCmds [] 10 []

/-! ## What the training loop actually found

These are not assumptions about the agent: `qbertLearned` and the rest are
computed by `Learn.train`, and the kernel evaluates them. -/

/-- **The trained agent clears the pyramid.** The plan the loop settled on
paints all ten cubes. -/
theorem qbert_learned_clears : QbertCleared (Learn.outcome monsterCubes initialQbert qbertLearned) :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- The trained agent scores a hundred and three: ten cubes painted, three
lives still in hand. -/
theorem qbert_learned_value :
    Learn.value monsterCubes qbertReward initialQbert qbertLearned = 103 := rfl

/-- Left to itself the greedy loop plateaus at forty-three: it walks down one
edge of the pyramid and then no single hop is an improvement. -/
theorem qbert_selfplay_value :
    Learn.value monsterCubes qbertReward initialQbert qbertSelfPlayed = 43 := rfl

/-- **Watching a recorded game strictly beats self-play here.** -/
theorem qbert_library_beats_selfplay :
    Learn.value monsterCubes qbertReward initialQbert qbertSelfPlayed <
      Learn.value monsterCubes qbertReward initialQbert qbertLearned := by
  rw [qbert_learned_value, qbert_selfplay_value]
  omega

/-- The tape the trained agent records: twelve frames for eleven hops. -/
theorem qbert_learned_tape_length : qbertLearnedTape.length = 12 := rfl

/-- The recorded tape ends exactly where the game ends — the general
faithfulness result, at this cabinet. -/
theorem qbert_learned_tape_faithful :
    qbertLearnedTape.getLast? = some (Learn.outcome monsterCubes initialQbert qbertLearned) :=
  Learn.traceFrom_getLast (g := monsterCubes) initialQbert qbertLearned

/-- **The trained agent clears the sky at the invaders cabinet too.** -/
theorem invaders_learned_clears :
    InvadersCleared (Learn.outcome shardInvaders initialInvaders invadersLearned) := rfl

/-- Fifty-five: five invaders shot down and not a row dropped. -/
theorem invaders_learned_value :
    Learn.value shardInvaders invadersReward initialInvaders invadersLearned = 55 := rfl

/-- Self-play at the invaders cabinet stalls after the first shot. -/
theorem invaders_selfplay_value :
    Learn.value shardInvaders invadersReward initialInvaders invadersSelfPlayed = 15 := rfl

/-! ## Learning from another cabinet -/

/-- How a game recorded at the invaders cabinet reads as hops on the pyramid. -/
def invadersToQbert : InvadersCmd → QbertCmd
  | .left => .ul
  | .right => .ur
  | .fire => .dl
  | .tick => .dr

/-- The library the cross-training agent is shown: the invaders game carried
over to the pyramid, and the pyramid game itself. -/
def qbertCrossLibrary : List (List QbertCmd) :=
  Learn.transfer (g₁ := shardInvaders) (g₂ := monsterCubes) invadersToQbert invadersClearingRun ::
    qbertLibrary

/-- The agent trained on both recorded games. -/
def qbertCrossTrained : List QbertCmd :=
  Learn.train monsterCubes qbertReward initialQbert qbertCmds qbertCrossLibrary 12 []

/-- **The cross-trained agent is at least as good as anything it was shown** —
an instance of `Learn.train_ge_library`, applied to the game carried over from
the other cabinet. -/
theorem qbert_cross_ge_transferred :
    Learn.value monsterCubes qbertReward initialQbert
        (Learn.transfer (g₁ := shardInvaders) (g₂ := monsterCubes)
          invadersToQbert invadersClearingRun) ≤
      Learn.value monsterCubes qbertReward initialQbert qbertCrossTrained :=
  Learn.train_ge_library (g := monsterCubes) qbertReward initialQbert qbertCmds
    qbertCrossLibrary 11 [] List.mem_cons_self

/-- The cross-trained agent still clears the pyramid. -/
theorem qbert_cross_value :
    Learn.value monsterCubes qbertReward initialQbert qbertCrossTrained = 103 := rfl

/-! ## The critic at work

A plan that throws all three lives away and then keeps hopping: the last two
commands are played on a frozen cabinet, so they change nothing. -/

/-- Five hops off the apex: three falls, then two commands on a dead cabinet. -/
def qbertWastefulRun : List QbertCmd := [.ul, .ul, .ul, .ul, .ul]

/-- **The critic finds the wasted commands**, and only those: positions three
and four, the two played after the last life was gone. -/
theorem qbert_critique_wasteful :
    Learn.critique monsterCubes initialQbert qbertWastefulRun = [3, 4] := rfl

/-- The rewrite drops exactly those two commands. -/
theorem qbert_prune_wasteful :
    Learn.prune monsterCubes initialQbert qbertWastefulRun = [.ul, .ul, .ul] := rfl

/-- And the pruned plan is worth exactly what the original was worth — the
general soundness result, at this cabinet. -/
theorem qbert_prune_wasteful_value :
    Learn.value monsterCubes qbertReward initialQbert
        (Learn.prune monsterCubes initialQbert qbertWastefulRun) =
      Learn.value monsterCubes qbertReward initialQbert qbertWastefulRun :=
  Learn.value_prune (g := monsterCubes) qbertReward initialQbert qbertWastefulRun

end NixWars
