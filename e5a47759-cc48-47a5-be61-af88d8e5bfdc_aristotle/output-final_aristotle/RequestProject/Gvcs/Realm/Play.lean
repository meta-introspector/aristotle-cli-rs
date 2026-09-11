import RequestProject.Gvcs.Realm.Chain

/-!
# The game is a game

`RequestProject/Realm/Rules.lean` says what a move is and when it is allowed,
and `RequestProject/Realm/Chain.lean` replays a transcript.  Neither of them
says that anything can actually *happen*: a rule book that forbade every move,
or a victory condition no play could ever reach, would satisfy all of it.  This
file rules that out, with witnesses that the kernel checks by computation.

* `never_stuck` — no position is a dead end: `endTurn` is always allowed, so a
  game can always be continued and a player can never be trapped into an
  illegal move.
* `winner_genesis` — the opening position is not already won.
* `valeWealth`, `hordeWealth` — a full legal game each, ending in a victory by
  wealth for the Ash Vale and one for the Iron Horde.  Both conditions of
  `winner` are reachable by both sides.
* `valeSiege` — a full legal game ending in a victory by conquest: the Ash Vale
  soldier crosses the map, kills both Horde workers and then the Horde soldier,
  and `alive` for the Horde falls to zero.
* `realm_is_winnable` — the three of them gathered up: a legal transcript from
  the opening exists that each side wins.
* `march_mover_owns`, `gather_mover_owns`, `build_mover_owns`,
  `strike_mover_owns`, `train_mover_owns` — **you may only move your own
  things**, and only things that have not already acted this turn.  Read
  together with `wf_apply` these are the safety properties of the rules that a
  page's verifier is trusted to enforce.
-/

namespace LifeTrac
namespace Realm

/-! ## The game never deadlocks -/

/-- Handing the turn over is allowed in every position. -/
@[simp] theorem endTurn_legal (s : State) : Legal s Move.endTurn = true := rfl

/-- **No position is a dead end.**  Whatever has happened, the player to move
has something legal to play, so a transcript can always be extended and a page
always has a successor. -/
theorem never_stuck (s : State) : ∃ m, Legal s m = true := ⟨Move.endTurn, endTurn_legal s⟩

/-- A valid transcript can always be extended by one more move. -/
theorem valid_extend {ms : List Move} (h : valid ms = true) :
    ∃ m, valid (ms ++ [m]) = true := by
  refine ⟨Move.endTurn, ?_⟩
  unfold valid at h ⊢
  rw [run, runFrom_concat]
  cases hr : runFrom genesis ms with
  | none => rw [run, hr] at h; simp at h
  | some t => rfl

/-! ## Nobody has won yet -/

/-- The opening position is not already decided. -/
theorem winner_genesis : winner genesis = none := by decide

/-! ## A victory by wealth -/

/-- The Ash Vale plays for money: both its workers work their tile every turn
for eleven full rounds and once more, while the Iron Horde does nothing. -/
def valeWealth : List Move :=
  (List.replicate 11 [Move.gather 49, Move.gather 54, Move.endTurn, Move.endTurn]).flatten
    ++ [Move.gather 49, Move.gather 54]

set_option maxRecDepth 10000 in
/-- The Vale's money game breaks no rule. -/
theorem valeWealth_valid : valid valeWealth = true := by decide

set_option maxRecDepth 10000 in
/-- **A victory by wealth is reachable.**  The Ash Vale reaches `wealthGoal`
gold and `winner` names it. -/
theorem valeWealth_wins : (run valeWealth).map winner = some (some false) := by decide

/-- The same game with the sides swapped: the Ash Vale passes and the Iron
Horde works. -/
def hordeWealth : List Move :=
  (List.replicate 11 [Move.endTurn, Move.gather 9, Move.gather 14, Move.endTurn]).flatten
    ++ [Move.endTurn, Move.gather 9, Move.gather 14]

set_option maxRecDepth 10000 in
/-- The Horde's money game breaks no rule. -/
theorem hordeWealth_valid : valid hordeWealth = true := by decide

set_option maxRecDepth 10000 in
/-- **Either side can win.**  The Iron Horde reaches `wealthGoal` gold in the
mirror game. -/
theorem hordeWealth_wins : (run hordeWealth).map winner = some (some true) := by decide

/-! ## A victory by conquest -/

/-- What the Ash Vale actually does in the siege: step the worker off tile 49,
walk the soldier up the first column, kill the Horde worker on tile 9, walk
east along the second row, kill the worker on tile 14, take its tile and cut
down the Horde soldier on tile 6. -/
def siegeActs : List Move :=
  [.march 49 3, .march 57 0, .march 49 0, .march 41 0, .march 33 0, .march 25 0,
   .strike 17 0, .strike 17 0, .march 17 0,
   .march 9 1, .march 10 1, .march 11 1, .march 12 1,
   .strike 13 1, .strike 13 1, .march 13 1,
   .strike 14 0, .strike 14 0, .strike 14 0]

/-- One Vale action a turn, with the Horde passing in between: the transcript
of the siege. -/
def valeSiege : List Move :=
  match siegeActs.reverse with
  | [] => []
  | last :: rest => (rest.reverse.flatMap (fun a => [a, Move.endTurn, Move.endTurn])) ++ [last]

set_option maxRecDepth 20000 in
/-- The siege breaks no rule. -/
theorem valeSiege_valid : valid valeSiege = true := by decide

set_option maxRecDepth 20000 in
/-- **A victory by conquest is reachable.**  Nothing of the Iron Horde is left
on the map, and `winner` names the Ash Vale. -/
theorem valeSiege_wins :
    (run valeSiege).map (fun s => (alive s true, winner s)) = some (0, some false) := by decide

/-! ## The rules are not vacuous -/

/-- **`Realm` is a game that can be played and won.**  There is a legal
transcript from the opening that the Ash Vale wins, one that the Iron Horde
wins, and one that ends by conquest rather than by wealth. -/
theorem realm_is_winnable :
    (∃ ms s, valid ms = true ∧ run ms = some s ∧ winner s = some false) ∧
    (∃ ms s, valid ms = true ∧ run ms = some s ∧ winner s = some true) ∧
    (∃ ms s, valid ms = true ∧ run ms = some s ∧ alive s true = 0 ∧ winner s = some false) := by
  refine ⟨⟨valeWealth, ?_⟩, ⟨hordeWealth, ?_⟩, ⟨valeSiege, ?_⟩⟩
  · have hw := valeWealth_wins
    cases hr : run valeWealth with
    | none => rw [hr] at hw; simp at hw
    | some s =>
      rw [hr] at hw
      exact ⟨s, valeWealth_valid, rfl, by simpa using hw⟩
  · have hw := hordeWealth_wins
    cases hr : run hordeWealth with
    | none => rw [hr] at hw; simp at hw
    | some s =>
      rw [hr] at hw
      exact ⟨s, hordeWealth_valid, rfl, by simpa using hw⟩
  · have hw := valeSiege_wins
    cases hr : run valeSiege with
    | none => rw [hr] at hw; simp at hw
    | some s =>
      rw [hr] at hw
      simp only [Option.map_some, Option.some.injEq, Prod.mk.injEq] at hw
      exact ⟨s, valeSiege_valid, rfl, hw.1, hw.2⟩

/-! ## You may only move your own things -/

/-- A march moves a piece of the player to move, and one that has not acted. -/
theorem march_mover_owns {s s' : State} {p d : Nat} (h : apply s (Move.march p d) = some s') :
    ∃ u, pieceAt s p = some u ∧ u.owner = s.turn ∧ u.acted = false := by
  simp only [apply] at h
  split at h
  · exact absurd h (by simp)
  · rename_i u hu
    split at h
    · exact absurd h (by simp)
    · rename_i hno
      refine ⟨u, hu, ?_, ?_⟩
      · simpa using (not_or.mp hno).1
      · simpa using (not_or.mp hno).2

/-- Gathering is done by a worker of the player to move that has not acted. -/
theorem gather_mover_owns {s s' : State} {p : Nat} (h : apply s (Move.gather p) = some s') :
    ∃ u, pieceAt s p = some u ∧ u.owner = s.turn ∧ u.acted = false ∧ u.kind = UKind.worker := by
  simp only [apply] at h
  split at h
  · exact absurd h (by simp)
  · rename_i u hu
    split at h
    · exact absurd h (by simp)
    · rename_i hno
      exact ⟨u, hu, by simpa [not_or] using hno⟩

/-- Building is done by a worker of the player to move that has not acted. -/
theorem build_mover_owns {s s' : State} {p : Nat} {b : BKind}
    (h : apply s (Move.build p b) = some s') :
    ∃ u, pieceAt s p = some u ∧ u.owner = s.turn ∧ u.acted = false ∧ u.kind = UKind.worker := by
  simp only [apply] at h
  split at h
  · exact absurd h (by simp)
  · rename_i u hu
    split at h
    · exact absurd h (by simp)
    · rename_i hno
      exact ⟨u, hu, by simpa [not_or] using hno⟩

/-- A strike is made by a piece of the player to move that has not acted, and
it lands on a piece of the other side. -/
theorem strike_mover_owns {s s' : State} {p d : Nat} (h : apply s (Move.strike p d) = some s') :
    ∃ u, pieceAt s p = some u ∧ u.owner = s.turn ∧ u.acted = false ∧
      ∃ q v, stepPos p d = some q ∧ pieceAt s q = some v ∧ v.owner ≠ s.turn := by
  simp only [apply] at h
  split at h
  · exact absurd h (by simp)
  · rename_i u hu
    split at h
    · exact absurd h (by simp)
    · rename_i hno
      refine ⟨u, hu, by simpa using (not_or.mp hno).1, by simpa using (not_or.mp hno).2, ?_⟩
      split at h
      · exact absurd h (by simp)
      · rename_i q hq
        split at h
        · exact absurd h (by simp)
        · rename_i v hv
          split at h
          · exact absurd h (by simp)
          · exact ⟨q, v, hq, hv, by assumption⟩

/-- Training is done by a building of the player to move, of the right kind for
the piece, on a tile with nothing standing on it. -/
theorem train_mover_owns {s s' : State} {p : Nat} {k : UKind}
    (h : apply s (Move.train p k) = some s') :
    ∃ b, bldgAt s p = some b ∧ b.owner = s.turn ∧ b.kind = trainer k ∧
      pieceAt s p = none := by
  simp only [apply] at h
  split at h
  · exact absurd h (by simp)
  · rename_i b hb
    split at h
    · exact absurd h (by simp)
    · rename_i hno
      refine ⟨b, hb, by simpa using (not_or.mp hno).1, by simpa using (not_or.mp hno).2, ?_⟩
      split at h
      · exact absurd h (by simp)
      · rename_i hp
        exact Option.not_isSome_iff_eq_none.mp (by simp [hp])

end Realm
end LifeTrac
