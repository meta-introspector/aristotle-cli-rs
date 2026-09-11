import RequestProject.Craft.RealmPage

/-!
# A demonstration game

Thirty-nine moves of Realm, played out to a win for Red: the border skirmish on
the hills, the two cities, and the storming of the blue capital.  This is the game
the published pages of `realm/` carry.

The facts below are checked by evaluation, so `demo_wins` and friends additionally
use `Lean.ofReduceBool`; the general theorems they instantiate do not.
-/

namespace Realm

/-- The demonstration game: 39 legal moves ending in Red's victory. -/
def demo : List Move :=
  [ .march 1 .east, .march 2 .east, .gather 0, .endTurn,
    .found 3, .strike 4 .west, .endTurn,
    .strike 1 .east, .march 2 .north, .gather 0, .endTurn,
    .strike 4 .west, .endTurn,
    .march 2 .east, .found 0, .endTurn,
    .train 0 .worker, .endTurn,
    .march 2 .south, .endTurn,
    .strike 4 .west, .gather 5, .endTurn,
    .strike 2 .east, .train 1 .worker, .endTurn,
    .gather 5, .endTurn,
    .march 2 .east, .endTurn,
    .gather 5, .endTurn,
    .strike 2 .south, .endTurn,
    .endTurn,
    .strike 2 .south, .endTurn,
    .endTurn,
    .strike 2 .south ]

/-- The position the demonstration game ends in. -/
def demoFinal : Option State := play initial demo

/-- The page published after move `n` of the demonstration game. -/
def demoPage (n : Nat) : Page := pageOf initial demo n

/-- Every move of the demonstration game is legal. -/
theorem demo_playable : (play initial demo).isSome = true := by native_decide

/-- The demonstration game is 39 moves long. -/
theorem demo_length : demo.length = 39 := by decide

/-- Its chain therefore has one block per move. -/
theorem demo_chain_length : (record initial demo).length = 39 :=
  (record_length initial demo (by rw [demo_playable])).trans demo_length

/-- Red wins it. -/
theorem demo_wins : demoFinal.map winner = some (some 0) := by native_decide

/-- And the game really is over: no move at all is legal in the final position. -/
theorem demo_over (s : State) (h : demoFinal = some s) (mv : Move) : step s mv = none := by
  have hw : winner s = some 0 := by
    have := demo_wins
    rw [h] at this
    simpa using this
  exact over_terminal hw mv

/-- Every page of the demonstration game verifies on its own. -/
theorem demoPage_valid (n : Nat) : (demoPage n).valid = true := page_valid initial demo n

/-- Each page carries the previous page unchanged inside it. -/
theorem demoPage_extends (n : Nat) : (demoPage n).blocks <+: (demoPage (n + 1)).blocks :=
  page_extends initial demo n

end Realm
