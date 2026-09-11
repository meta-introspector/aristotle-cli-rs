import RequestProject.Craft.Agents

/-!
# The strategy database

A chess database stores games, indexes **every position** they pass through,
and answers the question "what has been played here before, and how did it turn
out?".  This file is that, for the tycoon.

`learn db r` folds a recording into the database: for each position of the
game it stores the move that was played there and the score the game finally
reached.  `variations db k` lists everything known about a position, and
`bestEntry db k` picks the best-scoring continuation.

Proved here:

* `learn_sound` — the database only ever contains **backed** entries: every
  stored `(position, move, score)` really is the start of a game that reached
  that score;
* `learn_knows_every_position` — a learned game is indexed at *every* one of its
  positions, not just at its start, so a position reached by a different route
  finds it (`transposition`);
* `bestEntry_mem`, `bestEntry_max`, `bestEntry_backed` — the recommendation is a
  real, best-scoring, achievable continuation;
* `bestScore_mono_learn`, `learn_bestScore_ge` — **learning never forgets and
  never regresses**: the best known score at a position can only go up, and
  after learning a game it is at least that game's score;
* `branch_from_frame` — **branching a new line**: a player can take any stored
  game, rewind to any frame, and continue with their own moves; the result is
  exactly the game that starts from that frame.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-- One database row: at this position, this move was played, and the game that
played it finished with this much cash. -/
structure Entry where
  /-- The position, used as the index key. -/
  key : GameState
  /-- The move played there. -/
  move : Action
  /-- The score (final cash) of the game this row came from. -/
  result : Nat
deriving DecidableEq, Repr, Inhabited

/-- A strategy database. -/
abbrev DB := List Entry

/-- A row is *backed* when some continuation of its move really does reach its
score: the row is not an opinion, it is a game that was played. -/
def Backed (e : Entry) : Prop :=
  ∃ rest : List Action, (GameState.run (e.key.step e.move) rest).cash = e.result

/-- A database is sound when every row in it is backed. -/
def Sound (db : DB) : Prop := ∀ e ∈ db, Backed e

theorem sound_nil : Sound ([] : DB) := by intro e he; cases he

/-! ## Learning a game -/

/-- Index a game position by position: at each position, the move played and
the game's final score. -/
def entriesFrom (g : GameState) (result : Nat) : List Action → List Entry
  | [] => []
  | m :: rest => ⟨g, m, result⟩ :: entriesFrom (g.step m) result rest

/-- Every position of a recording, with the move played there and the score the
game reached. -/
def entriesOf (r : Recording) : List Entry :=
  entriesFrom r.init r.final.cash r.moves

/-- Fold a recorded game into the database. -/
def learn (db : DB) (r : Recording) : DB := db ++ entriesOf r

@[simp] theorem entriesFrom_length (g : GameState) (res : Nat) (ms : List Action) :
    (entriesFrom g res ms).length = ms.length := by
  induction ms generalizing g with
  | nil => rfl
  | cons m t ih => simp [entriesFrom, ih]

@[simp] theorem entriesOf_length (r : Recording) : (entriesOf r).length = r.moves.length := by
  simp [entriesOf]

theorem entriesFrom_getElem (g : GameState) (res : Nat) (ms : List Action) (i : Nat)
    (hi : i < ms.length) :
    (entriesFrom g res ms)[i]'(by simpa using hi)
      = ⟨GameState.run g (ms.take i), ms[i], res⟩ := by
  induction ms generalizing g i with
  | nil => simp at hi
  | cons m t ih =>
      cases i with
      | zero => simp [entriesFrom]
      | succ n =>
          simp only [List.length_cons, Nat.add_lt_add_iff_right] at hi
          simp only [entriesFrom, List.getElem_cons_succ]
          rw [ih (g.step m) n hi]
          simp

/-- **Every row a game contributes is backed by that game.** -/
theorem entriesFrom_backed (g : GameState) (ms : List Action) :
    ∀ e ∈ entriesFrom g (GameState.run g ms).cash ms, Backed e := by
  induction ms generalizing g with
  | nil => intro e he; cases he
  | cons m t ih =>
      intro e he
      rcases List.mem_cons.mp he with rfl | he
      · exact ⟨t, rfl⟩
      · exact ih (g.step m) e he

theorem entriesOf_backed (r : Recording) : ∀ e ∈ entriesOf r, Backed e :=
  entriesFrom_backed r.init r.moves

/-- **Learning preserves soundness**: the database never acquires a row that no
game supports. -/
theorem learn_sound {db : DB} (h : Sound db) (r : Recording) : Sound (learn db r) := by
  intro e he
  rcases List.mem_append.mp he with he | he
  · exact h e he
  · exact entriesOf_backed r e he

/-- **A learned game is indexed at every position it passed through** — exactly
the way a chess database indexes every position of a game, not only the
opening. -/
theorem learn_knows_every_position (db : DB) (r : Recording) (i : Nat)
    (hi : i < r.moves.length) :
    (⟨r.frames[i]'(by simp; omega), r.moves[i], r.final.cash⟩ : Entry) ∈ learn db r := by
  have hframe : r.frames[i]'(by simp; omega) = GameState.run r.init (r.moves.take i) :=
    Recording.frames_getElem r i (by simp; omega)
  rw [hframe]
  refine List.mem_append.mpr (Or.inr ?_)
  have := entriesFrom_getElem r.init r.final.cash r.moves i hi
  exact this ▸ List.getElem_mem (by simpa [entriesOf] using hi)

/-! ## Querying the database -/

/-- Every row stored at a position. -/
def atKey (db : DB) (k : GameState) : DB := db.filter (fun e => e.key == k)

/-- Everything known about a position: the moves that have been played there
and the scores the games that played them reached. -/
def variations (db : DB) (k : GameState) : List (Action × Nat) :=
  (atKey db k).map (fun e => (e.move, e.result))

theorem mem_atKey {db : DB} {k : GameState} {e : Entry} :
    e ∈ atKey db k ↔ e ∈ db ∧ e.key = k := by
  simp [atKey, List.mem_filter, and_comm]

/-- The variation list is exactly the set of rows stored at that position. -/
theorem mem_variations {db : DB} {k : GameState} {m : Action} {v : Nat} :
    (m, v) ∈ variations db k ↔ (⟨k, m, v⟩ : Entry) ∈ db := by
  constructor
  · intro h
    simp only [variations, List.mem_map] at h
    obtain ⟨e, he, heq⟩ := h
    obtain ⟨hmem, hkey⟩ := mem_atKey.mp he
    cases e with
    | mk key move result =>
        simp only [Prod.mk.injEq] at heq
        cases heq.1; cases heq.2; cases hkey
        exact hmem
  · intro h
    refine List.mem_map.mpr ⟨⟨k, m, v⟩, mem_atKey.mpr ⟨h, rfl⟩, rfl⟩

/-- The best-scoring row stored at a position. -/
def bestEntry (db : DB) (k : GameState) : Option Entry :=
  (atKey db k).argmax Entry.result

/-- The database's recommendation at a position. -/
def bestMove (db : DB) (k : GameState) : Option Action :=
  (bestEntry db k).map Entry.move

/-- The best score ever reached from a position, as far as the database knows. -/
def bestScore (db : DB) (k : GameState) : Nat :=
  match bestEntry db k with
  | none => 0
  | some e => e.result

/-- The recommendation comes from a row genuinely stored at that position. -/
theorem bestEntry_mem {db : DB} {k : GameState} {e : Entry} (h : bestEntry db k = some e) :
    e ∈ db ∧ e.key = k :=
  mem_atKey.mp (List.argmax_mem h)

/-- The recommendation is the best-scoring thing on record at that position. -/
theorem bestEntry_max {db : DB} {k : GameState} {e : Entry} (h : bestEntry db k = some e) :
    ∀ e' ∈ db, e'.key = k → e'.result ≤ e.result := by
  intro e' he' hk
  exact List.le_of_mem_argmax (mem_atKey.mpr ⟨he', hk⟩) h

/-- **The recommendation is achievable**: in a sound database, the recommended
move really does start a game that reaches the advertised score. -/
theorem bestEntry_backed {db : DB} (hs : Sound db) {k : GameState} {e : Entry}
    (h : bestEntry db k = some e) :
    ∃ rest : List Action, (GameState.run (k.step e.move) rest).cash = e.result := by
  have hmem := bestEntry_mem h
  obtain ⟨rest, hrest⟩ := hs e hmem.1
  exact ⟨rest, by rw [← hmem.2]; exact hrest⟩

/-- Something is recommended exactly when something is on record. -/
theorem bestEntry_isSome {db : DB} {k : GameState} {e : Entry} (he : e ∈ db) (hk : e.key = k) :
    (bestEntry db k).isSome := by
  rcases h : bestEntry db k with _ | b
  · simp only [bestEntry, List.argmax_eq_none] at h
    have : e ∈ atKey db k := mem_atKey.mpr ⟨he, hk⟩
    rw [h] at this
    cases this
  · rfl

/-- The stored score at a position is a real score: it is at least the score of
every game on record there. -/
theorem le_bestScore {db : DB} {k : GameState} {e : Entry} (he : e ∈ db) (hk : e.key = k) :
    e.result ≤ bestScore db k := by
  rcases h : bestEntry db k with _ | b
  · simp only [bestEntry, List.argmax_eq_none] at h
    have : e ∈ atKey db k := mem_atKey.mpr ⟨he, hk⟩
    rw [h] at this
    cases this
  · simp only [bestScore, h]
    exact bestEntry_max h e he hk

/-! ## Learning improves the database -/

/-- **Learning never forgets**: the best known score at any position can only
go up. -/
theorem bestScore_mono_learn (db : DB) (r : Recording) (k : GameState) :
    bestScore db k ≤ bestScore (learn db r) k := by
  rcases h : bestEntry db k with _ | b
  · simp [bestScore, h]
  · have hmem := bestEntry_mem h
    have : b ∈ learn db r := List.mem_append.mpr (Or.inl hmem.1)
    simpa [bestScore, h] using le_bestScore this hmem.2

/-- **Learning a game records its score**: after folding a game in, the database
knows a line from its starting position that is at least as good. -/
theorem learn_bestScore_ge (db : DB) (r : Recording) (h : r.moves ≠ []) :
    r.final.cash ≤ bestScore (learn db r) r.init := by
  have hlen : 0 < r.moves.length := List.length_pos_iff.mpr h
  have hmem := learn_knows_every_position db r 0 hlen
  have hframe : r.frames[0]'(by simp) = r.init := by
    simpa using Recording.frames_getElem r 0 (by simp)
  rw [hframe] at hmem
  exact le_bestScore hmem rfl

/-- **Transposition**: two games that pass through the same position both show
up among that position's variations, whichever route they took to get there. -/
theorem transposition (db : DB) (r₁ r₂ : Recording) (i j : Nat)
    (hi : i < r₁.moves.length) (hj : j < r₂.moves.length)
    (hsame : r₁.frames[i]'(by simp; omega) = r₂.frames[j]'(by simp; omega)) :
    (r₁.moves[i], r₁.final.cash) ∈ variations (learn (learn db r₁) r₂)
        (r₁.frames[i]'(by simp; omega)) ∧
    (r₂.moves[j], r₂.final.cash) ∈ variations (learn (learn db r₁) r₂)
        (r₁.frames[i]'(by simp; omega)) := by
  constructor
  · refine mem_variations.mpr (List.mem_append.mpr (Or.inl ?_))
    exact learn_knows_every_position db r₁ i hi
  · refine mem_variations.mpr ?_
    rw [hsame]
    exact learn_knows_every_position (learn db r₁) r₂ j hj

/-! ## Playing from the database -/

/-- An agent that plays the database's recommendation when the position is
known, and falls back on its own judgement when it is not. -/
def dbPolicy (db : DB) (fallback : Policy) : Policy :=
  fun g => (bestMove db g).getD (fallback g)

/-- In a known position the database agent plays the recommended move. -/
theorem dbPolicy_known {db : DB} {fallback : Policy} {g : GameState} {e : Entry}
    (h : bestEntry db g = some e) : dbPolicy db fallback g = e.move := by
  simp [dbPolicy, bestMove, h]

/-- In an unknown position it plays the fallback. -/
theorem dbPolicy_unknown {db : DB} {fallback : Policy} {g : GameState}
    (h : bestEntry db g = none) : dbPolicy db fallback g = fallback g := by
  simp [dbPolicy, bestMove, h]

/-- **Branching a new line.** A player can rewind a stored game to any frame and
continue with moves of their own; the result is exactly the game that starts
from that frame — which is what makes the database explorable. -/
theorem branch_from_frame (r : Recording) (k : Nat) (hk : k < r.frames.length)
    (bs : List Action) :
    GameState.run r.init (r.moves.take k ++ bs) = GameState.run (r.frames[k]) bs := by
  rw [GameState.run_append, Recording.frames_getElem r k hk]

/-! ## A worked database -/

/-- The three example agents, each recorded for 120 moves from the standard
start. -/
def demoGames : List Recording :=
  [Policy.recordOf idleBot startPos 120,
   Policy.recordOf frugalBot startPos 120,
   Policy.recordOf buildBot startPos 120]

/-- The database after learning all three example games. -/
def demoDB : DB := demoGames.foldl learn []

theorem demoDB_sound : Sound demoDB := by
  unfold demoDB demoGames
  simp only [List.foldl_cons, List.foldl_nil]
  exact learn_sound (learn_sound (learn_sound sound_nil _) _) _

/-- Three moves are on record in the starting position: one per game. -/
theorem demoDB_start_variations : (variations demoDB startPos).length = 3 := by native_decide

/-- The database's opinion of the start is the best of the three games — the
builder's score. -/
theorem demoDB_start_best :
    bestScore demoDB startPos = (Policy.simulate buildBot startPos 120).cash := by
  native_decide

/-- And its recommendation there is the builder's first move: buy a seller. -/
theorem demoDB_start_move : bestMove demoDB startPos = some (.place .seller ⟨0, 0, 0⟩) := by
  native_decide

end Tycoon
