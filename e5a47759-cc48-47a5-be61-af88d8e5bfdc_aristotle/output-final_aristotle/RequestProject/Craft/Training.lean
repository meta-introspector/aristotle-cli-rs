import RequestProject.Craft.DBPolicy

/-!
# Training a model to play, and criticising the games it plays

This file adds the *learning* half of the tycoon: a parameterised **model**
that plays the game, a **training loop** that improves the model by self-play,
a **coach** that folds every game — the model's own and anybody else's — into
the strategy database, and a **critic** that reads a finished game back against
the database and points at the moves that were mistakes.

The model is a weight vector.  `Weights.value` scores a position as a linear
combination of the things a tycoon cares about (cash on hand, ore and ingots in
the buffer, and how many miners, smelters and sellers are standing), and
`modelPolicy` plays the candidate move whose resulting position scores highest.
So a model *is* a `Policy`, and everything already proved about policies —
that they cannot break the voxel invariant, that they cannot conjure money, that
their games record and replay exactly — applies to it unchanged.

Training is hill climbing on measured results: `climbStep` plays a full game
with the current weights and with each neighbouring weight vector, and keeps
whichever scored best.

Proved here:

* `pickBest_ge`, `pickBest_max`, `pickBest_mem_or` — the argmax helper is an
  argmax: it never returns something worse than what it started with, nothing
  in the list beats it, and it does not invent an answer;
* `modelPolicy_greedy` — the model really plays a highest-valued candidate;
* `climbStep_ge`, `climb_ge` — **training never regresses**: an epoch of
  training scores at least as well as the weights it started from, and so does
  any number of epochs;
* `climbStep_max`, `climb_local_optimum` — an epoch takes the best neighbour on
  offer, and a fixed point of training is a genuine local optimum;
* `coach_sound`, `coach_bestScore_mono`, `coach_knows_model_game` — **learning
  from other games**: folding a batch of games in keeps every row backed by a
  real game, never lowers what is known at any position, and records the score
  of every game in the batch;
* `critique_sound` — **the critic tells the truth**: every move it flags is one
  the database has strictly out-scored at that very position, and the better
  move it names is the database's own best-scoring row there;
* `critique_improvable` — **and the criticism is actionable**: from a flagged
  move there is a real continuation, playing the same first moves and then the
  critic's suggestion, that finishes strictly higher;
* `critique_nil_of_best` — the critic is quiet on a game that plays a best
  known move every time, so an empty report means something.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-! ## An argmax helper -/

/-- Scan a list keeping the best-scoring element seen so far, starting from a
default. -/
def pickBest {α : Type} (f : α → Nat) : α → List α → α
  | a, [] => a
  | a, x :: t => pickBest f (if f a < f x then x else a) t

/-- The scan never returns something worse than the element it started with. -/
theorem pickBest_ge {α : Type} (f : α → Nat) :
    ∀ (l : List α) (a : α), f a ≤ f (pickBest f a l) := by
  intro l
  induction l with
  | nil => intro a; exact Nat.le_refl _
  | cons x t ih =>
      intro a
      refine Nat.le_trans ?_ (ih (if f a < f x then x else a))
      by_cases h : f a < f x
      · simp [h]; omega
      · simp [h]

/-- Nothing in the list beats the scan's answer. -/
theorem pickBest_max {α : Type} (f : α → Nat) :
    ∀ (l : List α) (a x : α), x ∈ l → f x ≤ f (pickBest f a l) := by
  intro l
  induction l with
  | nil => intro a x hx; cases hx
  | cons y t ih =>
      intro a x hx
      rcases List.mem_cons.mp hx with rfl | hx
      · refine Nat.le_trans ?_ (pickBest_ge f t (if f a < f x then x else a))
        by_cases h : f a < f x
        · simp [h]
        · simp [h]; omega
      · exact ih _ x hx

/-- The scan returns the default or an element of the list — it invents
nothing. -/
theorem pickBest_mem_or {α : Type} (f : α → Nat) :
    ∀ (l : List α) (a : α), pickBest f a l = a ∨ pickBest f a l ∈ l := by
  intro l
  induction l with
  | nil => intro a; exact Or.inl rfl
  | cons x t ih =>
      intro a
      have hstep : pickBest f a (x :: t) = pickBest f (if f a < f x then x else a) t := rfl
      rcases ih (if f a < f x then x else a) with h | h
      · rw [hstep, h]
        by_cases hx : f a < f x
        · exact Or.inr (by simp [hx])
        · exact Or.inl (by simp [hx])
      · exact Or.inr (List.mem_cons_of_mem _ (by rw [hstep]; exact h))

/-! ## The model -/

/-- A model of how to play: how much each feature of a position is worth. -/
structure Weights where
  /-- Weight on cash on hand. -/
  cash : Nat
  /-- Weight on ore in the buffer. -/
  ore : Nat
  /-- Weight on ingots in the buffer. -/
  ingot : Nat
  /-- Weight on each standing miner. -/
  miner : Nat
  /-- Weight on each standing smelter. -/
  smelter : Nat
  /-- Weight on each standing seller. -/
  seller : Nat
deriving DecidableEq, Repr, Inhabited

namespace Weights

/-- What the model thinks a position is worth.  The three factory features are
capped the way the rules cap their usefulness — a second seller sells nothing
extra, and a smelter with no miner feeding it smelts nothing — so the model can
express "enough of that, build something else". -/
def value (w : Weights) (g : GameState) : Nat :=
  w.cash * g.cash + w.ore * g.ore + w.ingot * g.ingot
    + w.miner * Scene.countKind .miner g.scene
    + w.smelter * min (Scene.countKind .smelter g.scene) (Scene.countKind .miner g.scene)
    + w.seller * min (Scene.countKind .seller g.scene) 1

/-- Every weight nudged up and down by `d`: the neighbourhood training
searches. -/
def neighbours (w : Weights) (d : Nat) : List Weights :=
  [{ w with cash := w.cash + d }, { w with cash := w.cash - d },
   { w with ore := w.ore + d }, { w with ore := w.ore - d },
   { w with ingot := w.ingot + d }, { w with ingot := w.ingot - d },
   { w with miner := w.miner + d }, { w with miner := w.miner - d },
   { w with smelter := w.smelter + d }, { w with smelter := w.smelter - d },
   { w with seller := w.seller + d }, { w with seller := w.seller - d }]

end Weights

/-- The moves the model considers in a position: let the world tick, cash out,
or build one part of each kind at the first spot it fits. -/
def candidates (g : GameState) : List Action :=
  [Action.tickWorld, Action.sell g.ingot,
   placeOr g .miner, placeOr g .smelter, placeOr g .seller]

/-- **The model as a player.** It plays the candidate move that leads to the
highest-valued position. -/
def modelPolicy (w : Weights) : Policy :=
  fun g => pickBest (fun a => w.value (g.step a)) Action.tickWorld (candidates g)

/-- The model plays a move it actually considered. -/
theorem modelPolicy_candidate (w : Weights) (g : GameState) :
    modelPolicy w g = Action.tickWorld ∨ modelPolicy w g ∈ candidates g :=
  pickBest_mem_or _ _ _

/-- **The model is greedy**: no candidate move leads to a position it values
more highly than the one it picked. -/
theorem modelPolicy_greedy (w : Weights) (g : GameState) :
    ∀ a ∈ candidates g, w.value (g.step a) ≤ w.value (g.step (modelPolicy w g)) :=
  fun a ha =>
    pickBest_max (fun a => w.value (g.step a)) (candidates g) Action.tickWorld a ha

/-- A model cannot break the voxel invariant either. -/
theorem modelPolicy_wf {w : Weights} {g : GameState} (hg : g.WF) (n : Nat) :
    (Policy.simulate (modelPolicy w) g n).WF :=
  Policy.simulate_wf hg n

/-- A model is bound by the same economy as everybody else. -/
theorem modelPolicy_worth_le {w : Weights} {g : GameState} (hg : g.WF) (n : Nat) :
    GameState.worth (Policy.simulate (modelPolicy w) g n)
      ≤ GameState.worth g + ingotPrice * Scene.maxParts * n :=
  Policy.simulate_worth_le hg n

/-! ## Training -/

/-- What a model actually achieves: the cash it finishes an `n`-move game with. -/
def score (g : GameState) (n : Nat) (w : Weights) : Nat :=
  (Policy.simulate (modelPolicy w) g n).cash

/-- One epoch of training: play a game with the current weights and with each
neighbouring weight vector, and keep the best. -/
def climbStep (g : GameState) (n d : Nat) (w : Weights) : Weights :=
  pickBest (score g n) w (w.neighbours d)

/-- Training for several epochs. -/
def climb (g : GameState) (n d : Nat) : Nat → Weights → Weights
  | 0, w => w
  | k + 1, w => climb g n d k (climbStep g n d w)

/-- **Training never regresses**: an epoch scores at least as well as the
weights it started from. -/
theorem climbStep_ge (g : GameState) (n d : Nat) (w : Weights) :
    score g n w ≤ score g n (climbStep g n d w) :=
  pickBest_ge _ _ _

/-- An epoch takes the best neighbour on offer. -/
theorem climbStep_max (g : GameState) (n d : Nat) (w v : Weights)
    (hv : v ∈ w.neighbours d) :
    score g n v ≤ score g n (climbStep g n d w) :=
  pickBest_max _ _ _ v hv

/-- **Training never regresses, however long it runs.** -/
theorem climb_ge (g : GameState) (n d : Nat) :
    ∀ (k : Nat) (w : Weights), score g n w ≤ score g n (climb g n d k w) := by
  intro k
  induction k with
  | zero => intro w; exact Nat.le_refl _
  | succ m ih =>
      intro w
      exact Nat.le_trans (climbStep_ge g n d w) (ih (climbStep g n d w))

/-- **A fixed point of training is a local optimum**: when an epoch fails to
improve the score, no neighbouring model would have done better. -/
theorem climb_local_optimum {g : GameState} {n d : Nat} {w : Weights}
    (h : score g n (climbStep g n d w) ≤ score g n w) :
    ∀ v ∈ w.neighbours d, score g n v ≤ score g n w :=
  fun v hv => Nat.le_trans (climbStep_max g n d w v hv) h

/-! ## Recording what the model plays, and learning from everyone -/

/-- The model's own game, as an ordinary recording. -/
def modelGame (g : GameState) (n : Nat) (w : Weights) : Recording :=
  Policy.recordOf (modelPolicy w) g n

/-- The model's recorded game replays to exactly the game it played. -/
theorem modelGame_final (g : GameState) (n : Nat) (w : Weights) :
    (modelGame g n w).final = Policy.simulate (modelPolicy w) g n :=
  Policy.recordOf_final _ _ _

@[simp] theorem modelGame_init (g : GameState) (n : Nat) (w : Weights) :
    (modelGame g n w).init = g := rfl

@[simp] theorem modelGame_moves_length (g : GameState) (n : Nat) (w : Weights) :
    (modelGame g n w).moves.length = n := by
  simp [modelGame]

/-- **The coach**: fold a whole batch of games — the model's own, other models',
human games — into the strategy database. -/
def coach (db : DB) (games : List Recording) : DB := games.foldl learn db

/-- The coach only ever adds rows that a real game backs. -/
theorem coach_sound : ∀ (games : List Recording) {db : DB}, Sound db → Sound (coach db games) := by
  intro games
  induction games with
  | nil => intro db h; exact h
  | cons r t ih => intro db h; exact ih (learn_sound h r)

/-- **Learning from other games never forgets**: what the database knows at any
position can only go up. -/
theorem coach_bestScore_mono :
    ∀ (games : List Recording) (db : DB) (k : GameState),
      bestScore db k ≤ bestScore (coach db games) k := by
  intro games
  induction games with
  | nil => intro db k; exact Nat.le_refl _
  | cons r t ih =>
      intro db k
      exact Nat.le_trans (bestScore_mono_learn db r k) (ih (learn db r) k)

/-- **Every game in the batch is on the record afterwards**: the database knows
a line from that game's starting position that is at least as good as the game
itself. -/
theorem coach_knows_game :
    ∀ (games : List Recording) (db : DB) (r : Recording), r ∈ games → r.moves ≠ [] →
      r.final.cash ≤ bestScore (coach db games) r.init := by
  intro games
  induction games with
  | nil => intro db r hr; cases hr
  | cons s t ih =>
      intro db r hr hne
      rcases List.mem_cons.mp hr with rfl | hr
      · exact Nat.le_trans (learn_bestScore_ge db r hne)
          (coach_bestScore_mono t (learn db r) r.init)
      · exact ih (learn db s) r hr hne

/-- A trained model's game, folded in, puts that model's score on the record. -/
theorem coach_knows_model_game (db : DB) (g : GameState) (n : Nat) (w : Weights)
    (hn : n ≠ 0) :
    score g n w ≤ bestScore (coach db [modelGame g n w]) g := by
  have hne : (modelGame g n w).moves ≠ [] := by
    intro h
    have := modelGame_moves_length g n w
    rw [h] at this
    exact hn this.symm
  have := coach_knows_game [modelGame g n w] db (modelGame g n w) (by simp) hne
  simpa [score, modelGame_final] using this

/-- **The model can play out of the book.** A trained model that consults the
database first is still a policy, so its games record and replay like any
other. -/
def bookPolicy (db : DB) (w : Weights) : Policy := dbPolicy db (modelPolicy w)

theorem bookPolicy_known {db : DB} {w : Weights} {g : GameState} {e : Entry}
    (h : bestEntry db g = some e) : bookPolicy db w g = e.move :=
  dbPolicy_known h

theorem bookPolicy_unknown {db : DB} {w : Weights} {g : GameState}
    (h : bestEntry db g = none) : bookPolicy db w g = modelPolicy w g :=
  dbPolicy_unknown h

/-! ## The critic -/

/-- Every row at this position that played this very move. -/
def atKeyMove (db : DB) (k : GameState) (m : Action) : DB :=
  (atKey db k).filter (fun e => e.move == m)

/-- The best score any recorded game reached after playing this move here. -/
def moveScore (db : DB) (k : GameState) (m : Action) : Nat :=
  match (atKeyMove db k m).argmax Entry.result with
  | none => 0
  | some e => e.result

theorem mem_atKeyMove {db : DB} {k : GameState} {m : Action} {e : Entry} :
    e ∈ atKeyMove db k m ↔ (e ∈ db ∧ e.key = k) ∧ e.move = m := by
  simp only [atKeyMove, List.mem_filter, mem_atKey, beq_iff_eq]

/-- One criticism: at this position, on this ply, this move was played, and the
database knows a strictly better one. -/
structure Blunder where
  /-- Which ply of the game. -/
  ply : Nat
  /-- The position it was played in. -/
  key : GameState
  /-- The move that was played. -/
  played : Action
  /-- The database's best-scoring move there. -/
  better : Action
  /-- The best score on record at that position. -/
  bestResult : Nat
  /-- The best score on record after the move that was played. -/
  playedResult : Nat
deriving DecidableEq, Repr, Inhabited

/-- Read a game back against the database, flagging every move the database has
strictly out-scored at that very position. -/
def critiqueFrom (db : DB) (g : GameState) (i : Nat) : List Action → List Blunder
  | [] => []
  | m :: rest =>
      let tail := critiqueFrom db (g.step m) (i + 1) rest
      match bestEntry db g with
      | none => tail
      | some e =>
          if moveScore db g m < e.result then
            ⟨i, g, m, e.move, e.result, moveScore db g m⟩ :: tail
          else tail

/-- The critic's report on a recorded game. -/
def critique (db : DB) (r : Recording) : List Blunder :=
  critiqueFrom db r.init 0 r.moves

/-- **The critic tells the truth.** Every flagged move sits at a position where
the database's own best row scores strictly higher than anything ever achieved
after the move that was played, and the suggested move is that best row's
move. -/
theorem critique_sound (db : DB) :
    ∀ (ms : List Action) (g : GameState) (i : Nat) (b : Blunder),
      b ∈ critiqueFrom db g i ms →
      moveScore db b.key b.played < b.bestResult ∧
      bestScore db b.key = b.bestResult ∧
      bestMove db b.key = some b.better ∧
      b.playedResult = moveScore db b.key b.played := by
  intro ms
  induction ms with
  | nil => intro g i b hb; cases hb
  | cons m rest ih =>
      intro g i b hb
      simp only [critiqueFrom] at hb
      rcases h : bestEntry db g with _ | e
      · rw [h] at hb; exact ih _ _ b hb
      · rw [h] at hb
        by_cases hlt : moveScore db g m < e.result
        · simp only [hlt, if_true, List.mem_cons] at hb
          rcases hb with rfl | hb
          · exact ⟨hlt, by simp [bestScore, h], by simp [bestMove, h], rfl⟩
          · exact ih _ _ b hb
        · simp only [hlt, if_false] at hb
          exact ih _ _ b hb

/-- **The criticism is actionable.** In a sound database, a flagged move has a
real alternative: a game that plays the same first `b.ply` moves, then the
critic's suggestion, and finishes strictly higher than anything on record after
the move that was actually played. -/
theorem critique_improvable {db : DB} (hs : Sound db) {b : Blunder}
    (hbest : bestMove db b.key = some b.better)
    (hres : bestScore db b.key = b.bestResult)
    (hlt : moveScore db b.key b.played < b.bestResult) :
    ∃ rest : List Action,
      (GameState.run (b.key.step b.better) rest).cash = b.bestResult ∧
      moveScore db b.key b.played < (GameState.run (b.key.step b.better) rest).cash := by
  rcases h : bestEntry db b.key with _ | e
  · simp [bestMove, h] at hbest
  · have hmove : e.move = b.better := by simpa [bestMove, h] using hbest
    have hresult : e.result = b.bestResult := by simpa [bestScore, h] using hres
    obtain ⟨rest, hrest⟩ := bestEntry_backed hs h
    refine ⟨rest, ?_, ?_⟩
    · rw [← hmove, hrest, hresult]
    · rw [← hmove, hrest, hresult]; exact hlt

/-- **An empty report means something.** If at every position the game passed
through the move it played is as good as anything the database knows there, the
critic has nothing to say. -/
theorem critique_nil_of_best (db : DB) :
    ∀ (ms : List Action) (g : GameState) (i : Nat),
      (∀ j : Nat, ∀ hj : j < ms.length,
        bestScore db (GameState.run g (ms.take j))
          ≤ moveScore db (GameState.run g (ms.take j)) (ms[j]'hj)) →
      critiqueFrom db g i ms = [] := by
  intro ms
  induction ms with
  | nil => intro g i _; rfl
  | cons m rest ih =>
      intro g i h
      have h0 := h 0 (by simp)
      simp only [List.take_zero, GameState.run_nil, List.getElem_cons_zero] at h0
      have htail : critiqueFrom db (g.step m) (i + 1) rest = [] := by
        refine ih (g.step m) (i + 1) ?_
        intro j hj
        have := h (j + 1) (by simpa using hj)
        simpa using this
      simp only [critiqueFrom, htail]
      rcases hb : bestEntry db g with _ | e
      · rfl
      · have : e.result ≤ moveScore db g m := by
          have : bestScore db g = e.result := by simp [bestScore, hb]
          omega
        simp [Nat.not_lt.mpr this]

/-! ## A worked training run -/

/-- The model everybody starts from: it only counts cash, so it never spends
any — it watches the clock for a hundred and twenty moves and finishes with the
grant it was given. -/
def baseWeights : Weights :=
  { cash := 1, ore := 0, ingot := 0, miner := 0, smelter := 0, seller := 0 }

/-- The population the first stage of training searches: eight candidate models,
differing in how much they like ore, ingots and each kind of machine. -/
def modelPool : List Weights :=
  [{ cash := 1, ore := 0, ingot := 0, miner := 21, smelter := 36, seller := 51 },
   { cash := 1, ore := 0, ingot := 0, miner := 25, smelter := 45, seller := 70 },
   { cash := 1, ore := 1, ingot := 1, miner := 30, smelter := 50, seller := 80 },
   { cash := 1, ore := 2, ingot := 3, miner := 40, smelter := 70, seller := 120 },
   { cash := 2, ore := 0, ingot := 0, miner := 60, smelter := 90, seller := 140 },
   { cash := 1, ore := 0, ingot := 3, miner := 40, smelter := 70, seller := 120 },
   { cash := 1, ore := 2, ingot := 3, miner := 45, smelter := 80, seller := 130 },
   { cash := 1, ore := 2, ingot := 3, miner := 35, smelter := 60, seller := 100 }]

/-- **Stage one of training**: play a full game with every model in the
population and keep the best. -/
def poolTrain (g : GameState) (n : Nat) (pool : List Weights) (w : Weights) : Weights :=
  pickBest (score g n) w pool

/-- Population search never returns a model worse than the one it started
from. -/
theorem poolTrain_ge (g : GameState) (n : Nat) (pool : List Weights) (w : Weights) :
    score g n w ≤ score g n (poolTrain g n pool w) :=
  pickBest_ge _ _ _

/-- Population search returns the best model in the population. -/
theorem poolTrain_max (g : GameState) (n : Nat) (pool : List Weights) (w v : Weights)
    (hv : v ∈ pool) : score g n v ≤ score g n (poolTrain g n pool w) :=
  pickBest_max _ _ _ v hv

/-- The best model in the population, measured on 120-move games from the
standard start. -/
def pooledWeights : Weights := poolTrain startPos 120 modelPool baseWeights

/-- **The trained model**: the best of the population, then two epochs of hill
climbing with a step of eight. -/
def trainedWeights : Weights := climb startPos 120 8 2 pooledWeights

/-- The trained model's game, recorded. -/
def trainedGame : Recording := modelGame startPos 120 trainedWeights

/-- The database after the coach has folded in the three example games and the
trained model's own game. -/
def coachedDB : DB := coach demoDB [trainedGame]

theorem coachedDB_sound : Sound coachedDB :=
  coach_sound [trainedGame] demoDB_sound

/-- **The training run, measured** (checked by evaluation).  The untrained model
finishes with the grant it started with; population search finds a model that
finishes with 1805; two epochs of hill climbing lift that to 2095, which is
ahead of the hand-written `buildBot`.  The critic, reading the games back
against the coached database, has nothing to say about the trained model's own
game and plenty to say about the idle one. -/
theorem training_report :
    score startPos 120 baseWeights = 150 ∧
    score startPos 120 pooledWeights = 1805 ∧
    score startPos 120 trainedWeights = 2095 ∧
    (Policy.simulate buildBot startPos 120).cash = 1600 ∧
    (critique coachedDB trainedGame).length = 0 ∧
    0 < (critique coachedDB (Policy.recordOf idleBot startPos 120)).length := by
  native_decide

/-- **Training improved the model.** -/
theorem trained_beats_base :
    score startPos 120 baseWeights < score startPos 120 trainedWeights := by
  have h := training_report
  omega

/-- **Hill climbing improved on population search.** -/
theorem trained_beats_pooled :
    score startPos 120 pooledWeights < score startPos 120 trainedWeights := by
  have h := training_report
  omega

/-- **The trained model outplays the hand-written agent.** -/
theorem trained_beats_buildBot :
    (Policy.simulate buildBot startPos 120).cash < score startPos 120 trainedWeights := by
  have h := training_report
  omega

/-- The critic is quiet about the trained model's own game. -/
theorem critique_trained_empty : critique coachedDB trainedGame = [] := by
  have h := training_report
  exact List.eq_nil_of_length_eq_zero h.2.2.2.2.1

/-- The critic has plenty to say about the idle game. -/
theorem critique_idler_nonempty :
    critique coachedDB (Policy.recordOf idleBot startPos 120) ≠ [] := by
  have h := training_report
  intro hnil
  rw [hnil] at h
  simp at h

/-- The trained model plays a legal, invariant-preserving game. -/
theorem trained_wf : (Policy.simulate (modelPolicy trainedWeights) startPos 120).WF :=
  modelPolicy_wf startPos_wf 120

/-- The trained model's score is on the record after the coach folds its game
in. -/
theorem coachedDB_knows_trained :
    score startPos 120 trainedWeights ≤ bestScore coachedDB startPos :=
  coach_knows_model_game demoDB startPos 120 trainedWeights (by decide)

end Tycoon
