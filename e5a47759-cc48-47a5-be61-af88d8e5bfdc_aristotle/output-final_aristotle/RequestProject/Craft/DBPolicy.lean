import RequestProject.Craft.StrategyDB

/-!
# Playing out of the book, and searching for new strategies

Two things a chess database is for, done here for the tycoon.

**Playing out of the book.** `dbPolicy` plays the best move on record at the
current position.  `dbPolicy_replays_learned_game` proves that this really does
recover a learned strategy: an agent that has learned one game, and plays the
database's recommendation at every position of it, reaches exactly the position
that game reached — so the score of a learned line is available to whoever
holds the database.  (The hypothesis is that the learned game does not repeat a
position; a repeated position is a genuine ambiguity, since the database has
two different recommendations at the same key.)

**Searching for new strategies.** `learnPool` runs a pool of candidate
strategies from a position and folds every resulting game into the database;
`learnPool_ge` proves that the database's opinion of that position is then at
least as good as the best candidate in the pool, and `poolBest_ge` picks the
winning candidate out.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-! ## Playing out of the book -/

/-- If a position has exactly one row, that row is the recommendation. -/
theorem bestEntry_of_atKey_singleton {db : DB} {k : GameState} {e : Entry}
    (h : atKey db k = [e]) : bestEntry db k = some e := by
  simp [bestEntry, h]

/-- When no two rows share a key, the rows at a key are exactly the one row. -/
theorem atKey_of_nodup_keys : ∀ (l : DB), (l.map Entry.key).Nodup → ∀ {e : Entry}, e ∈ l →
    atKey l e.key = [e] := by
  intro l
  induction l with
  | nil => intro _ e he; cases he
  | cons a t ih =>
      intro hnd e he
      simp only [List.map_cons, List.nodup_cons, List.mem_map, not_exists] at hnd
      obtain ⟨hnot, hnd'⟩ := hnd
      rcases List.mem_cons.mp he with rfl | he
      · have hnot' : ∀ b ∈ t, ¬ b.key = e.key := fun b hb hk => hnot b ⟨hb, hk⟩
        simp only [atKey, List.filter_cons, BEq.rfl, if_true, List.cons_eq_cons, true_and,
          List.filter_eq_nil_iff, beq_iff_eq]
        exact hnot'
      · have hne : a.key ≠ e.key := by
          intro hEq
          exact hnot e ⟨he, hEq.symm⟩
        simp only [atKey, List.filter_cons, beq_iff_eq, hne, if_false]
        exact ih hnd' he

/-- The keys a recording contributes are exactly the positions it passed
through, one per move. -/
theorem entriesFrom_keys (res : Nat) : ∀ (ms : List Action) (g : GameState),
    (entriesFrom g res ms).map Entry.key = (ms.scanl GameState.step g).take ms.length := by
  intro ms
  induction ms with
  | nil => intro g; rfl
  | cons m t ih =>
      intro g
      simp only [entriesFrom, List.map_cons, List.scanl_cons, List.length_cons,
        List.take_succ_cons]
      rw [ih (g.step m)]

theorem entriesOf_keys (r : Recording) :
    (entriesOf r).map Entry.key = r.frames.take r.moves.length :=
  entriesFrom_keys r.final.cash r.moves r.init

/-- The general step: if at every position of a play the database recommends
exactly the move the play makes, then the database agent reproduces the play. -/
theorem simulate_dbPolicy_of_indexed (db : DB) (fb : Policy) (res : Nat) :
    ∀ (ms : List Action) (g : GameState),
      (∀ i, (hi : i < ms.length) →
        bestEntry db (GameState.run g (ms.take i))
          = some ⟨GameState.run g (ms.take i), ms[i], res⟩) →
      Policy.simulate (dbPolicy db fb) g ms.length = GameState.run g ms := by
  intro ms
  induction ms with
  | nil => intro g _; rfl
  | cons m t ih =>
      intro g h
      have h0 := h 0 (by simp)
      simp only [List.take_zero, GameState.run_nil, List.getElem_cons_zero] at h0
      have hmove : dbPolicy db fb g = m := dbPolicy_known h0
      simp only [List.length_cons, Policy.simulate, hmove, GameState.run_cons]
      refine ih (g.step m) (fun i hi => ?_)
      have := h (i + 1) (by simpa using hi)
      simpa [List.take_succ_cons, GameState.run_cons] using this

/-- **Playing out of the book.** An agent holding a database that has learned
one game — a game that never repeats a position — and playing the database's
recommendation every move, reaches exactly the position that game reached.
Learning really does hand the strategy over. -/
theorem dbPolicy_replays_learned_game (r : Recording) (fb : Policy)
    (hnd : (r.frames.take r.moves.length).Nodup) :
    Policy.simulate (dbPolicy (learn [] r) fb) r.init r.moves.length = r.final := by
  have hdb : learn [] r = entriesOf r := by simp [learn]
  have hkeys : ((entriesOf r).map Entry.key).Nodup := by
    rw [entriesOf_keys]; exact hnd
  have hmain := simulate_dbPolicy_of_indexed (entriesOf r) fb r.final.cash r.moves r.init ?_
  · rw [hdb, hmain]
    rfl
  · intro i hi
    have hget := entriesFrom_getElem r.init r.final.cash r.moves i hi
    have hmem : (⟨GameState.run r.init (r.moves.take i), r.moves[i], r.final.cash⟩ : Entry)
        ∈ entriesOf r := by
      rw [← hget]
      exact List.getElem_mem (by simpa [entriesOf] using hi)
    exact bestEntry_of_atKey_singleton (atKey_of_nodup_keys _ hkeys hmem)

/-! ## Searching for new strategies -/

/-- Run every candidate strategy from a position and fold all the resulting
games into the database. -/
def learnPool (db : DB) (cands : List Policy) (g : GameState) (n : Nat) : DB :=
  cands.foldl (fun d pol => learn d (Policy.recordOf pol g n)) db

/-- Searching a pool can only improve the database. -/
theorem bestScore_mono_learnPool : ∀ (cands : List Policy) (db : DB) (g : GameState)
    (n : Nat) (k : GameState), bestScore db k ≤ bestScore (learnPool db cands g n) k := by
  intro cands
  induction cands with
  | nil => intro db g n k; exact le_refl _
  | cons pol t ih =>
      intro db g n k
      exact le_trans (bestScore_mono_learn db (Policy.recordOf pol g n) k)
        (ih (learn db (Policy.recordOf pol g n)) g n k)

/-- **Strategy search.** After running a pool of candidate strategies from a
position and learning all of their games, the database's opinion of that
position is at least as good as every candidate's score. -/
theorem learnPool_ge (cands : List Policy) (db : DB) (g : GameState) {n : Nat} (hn : 0 < n) :
    ∀ pol ∈ cands, (Policy.simulate pol g n).cash ≤ bestScore (learnPool db cands g n) g := by
  induction cands generalizing db with
  | nil => intro pol hp; cases hp
  | cons c t ih =>
      intro pol hp
      rcases List.mem_cons.mp hp with rfl | hp
      · have hmoves : (Policy.recordOf pol g n).moves ≠ [] := by
          intro hE
          have : (Policy.recordOf pol g n).moves.length = n := Policy.recordOf_length pol g n
          rw [hE] at this
          simp at this
          omega
        have h1 : (Policy.recordOf pol g n).final.cash
            ≤ bestScore (learn db (Policy.recordOf pol g n)) g :=
          learn_bestScore_ge db (Policy.recordOf pol g n) hmoves
        have h2 := bestScore_mono_learnPool t (learn db (Policy.recordOf pol g n)) g n g
        rw [Policy.recordOf_final] at h1
        exact le_trans h1 h2
      · exact ih (learn db (Policy.recordOf c g n)) pol hp

/-- The best candidate in a pool, by the score it reaches. -/
def poolBest (cands : List Policy) (g : GameState) (n : Nat) : Option Policy :=
  cands.argmax (fun pol => (Policy.simulate pol g n).cash)

/-- The candidate the search returns is a candidate, … -/
theorem poolBest_mem {cands : List Policy} {g : GameState} {n : Nat} {b : Policy}
    (h : poolBest cands g n = some b) : b ∈ cands :=
  List.argmax_mem h

/-- … and no candidate in the pool scores better than it. -/
theorem poolBest_ge {cands : List Policy} {g : GameState} {n : Nat} {b : Policy}
    (h : poolBest cands g n = some b) :
    ∀ pol ∈ cands, (Policy.simulate pol g n).cash ≤ (Policy.simulate b g n).cash :=
  fun _ hp => List.le_of_mem_argmax (f := fun pol => (Policy.simulate pol g n).cash) hp h

/-! ## The worked example -/

/-- The pool of example strategies. -/
def demoPool : List Policy := [idleBot, frugalBot, buildBot]

/-- Searching the pool from the standard start finds the reinvesting agent. -/
theorem demoPool_best :
    (Policy.simulate buildBot startPos 120).cash
      ≤ bestScore (learnPool [] demoPool startPos 120) startPos :=
  learnPool_ge demoPool [] startPos (by norm_num) buildBot (by simp [demoPool])

/-- And what it finds is exactly the builder's score. -/
theorem demoPool_best_value :
    bestScore (learnPool [] demoPool startPos 120) startPos = 1600 := by native_decide

/-- The builder's game never repeats a position, so the book-following theorem
applies to it. -/
theorem builderGame_nodup :
    ((Policy.recordOf buildBot startPos 120).frames.take 120).Nodup := by native_decide

/-- **A player who learns the builder's game plays the builder's game.** An
agent holding nothing but that one recorded game, and following the database's
recommendation at every move, reaches exactly the position the builder
reached. -/
theorem dbPolicy_replays_builder (fb : Policy) :
    Policy.simulate (dbPolicy (learn [] (Policy.recordOf buildBot startPos 120)) fb)
        startPos 120
      = Policy.simulate buildBot startPos 120 := by
  have h := dbPolicy_replays_learned_game (Policy.recordOf buildBot startPos 120) fb
    builderGame_nodup
  rw [Policy.recordOf_length, Policy.recordOf_final] at h
  exact h

end Tycoon
