import RequestProject.Gvcs.Net.Gossip
import RequestProject.Gvcs.Game

/-!
# The game itself, replicated

`RequestProject/Game.lean` is the rule book: `Build.step` returns `none`
exactly when a move is not allowed.  `RequestProject/Net/Log.lean` is the
transport: a growing set of operations that every replica replays in the same
canonical order.  Putting the two together gives a multiplayer game with no
referee.

* `applyAction` — the replicated step: play the move if the rule book allows
  it, otherwise ignore it.  Every replica runs the same rule book on the same
  operations, so a client that submits an illegal move does not gain anything
  by it — the move is dropped identically everywhere.
* `applyAction_legal`, `replay_legal` — the invariants of the single-player
  game (no negative cash, no negative stores, no negative fuel) survive
  replication: *whatever* stream of moves, from whatever peer, in whatever
  order, the state every replica computes is a legal state.
* `match_converges` — after a peer-to-peer sync round every player, on every
  platform, sees exactly the same game.
* `applyAction_port_eq` — a port that implements the rule book faithfully
  computes the same game as the reference.
-/

namespace LifeTrac
namespace Net

open Build
open Build.GameState

/-- Moves are compared for equality only in the model, so classical decidability
is enough here; a real client compares their serialised form. -/
noncomputable instance : DecidableEq Action := Classical.decEq _

/-- The replicated rule book: apply the move if it is legal, otherwise ignore
it.  Since every replica holds the same rule book and eventually the same set
of moves, they all drop the same illegal moves. -/
noncomputable def applyAction (mk : Market) (s : GameState) (a : Action) : GameState :=
  (Build.step mk s a).getD s

theorem applyAction_eq_of_legal {mk : Market} {s t : GameState} {a : Action}
    (h : Build.step mk s a = some t) : applyAction mk s a = t := by
  simp [applyAction, h]

theorem applyAction_eq_self_of_illegal {mk : Market} {s : GameState} {a : Action}
    (h : Build.step mk s a = none) : applyAction mk s a = s := by
  simp [applyAction, h]

/-- A move can never take a replica to an illegal state. -/
theorem applyAction_legal {mk : Market} {s : GameState} (hs : s.Legal) (a : Action) :
    (applyAction mk s a).Legal := by
  rcases h : Build.step mk s a with _ | t
  · rw [applyAction_eq_self_of_illegal h]; exact hs
  · rw [applyAction_eq_of_legal h]; exact step_legal hs h

theorem legal_foldl (mk : Market) (l : List (Op Action)) {s : GameState} (hs : s.Legal) :
    (l.foldl (fun s o => applyAction mk s o.payload) s).Legal := by
  induction l generalizing s with
  | nil => exact hs
  | cons o l ih => exact ih (applyAction_legal hs o.payload)

/-- **The rules hold without a referee.**  Whatever moves a replica has
received — its own, a friend's, a batch from the relay, in any order, with
duplicates — the state it computes obeys the invariants of the game. -/
theorem replay_legal (mk : Market) {init : GameState} (hs : init.Legal) (L : Log Action) :
    (replay (applyAction mk) init L).Legal :=
  legal_foldl mk _ hs

/-- **One game across all platforms.**  After a peer-to-peer sync round, every
peer — phone, browser, Roblox client, always-on relay — computes exactly the
same game state. -/
theorem match_converges (mk : Market) (init : GameState) {n : ℕ} (hub : Fin n)
    (net : Network Action n) (k k' : Fin n) :
    replay (applyAction mk) init (fullSync hub net k) =
      replay (applyAction mk) init (fullSync hub net k') :=
  fullSync_replay _ _ hub net k k'

/-- **A faithful port is the same game.**  Any implementation of the rule book
that agrees move by move with `applyAction` — the Lua one inside Roblox, the
JavaScript one in the browser shell — reconstructs the same state from the same
log. -/
theorem applyAction_port_eq (mk : Market) (impl : GameState → Action → GameState)
    (h : ∀ s a, impl s a = applyAction mk s a) (init : GameState) (L : Log Action) :
    replay impl init L = replay (applyAction mk) init L :=
  replay_impl_eq _ impl h init L

/-- **Offline play is not second class.**  Moves made while disconnected are in
everybody's log after the next sync round, so they are replayed by everybody. -/
theorem offline_moves_adopted {n : ℕ} (hub i : Fin n) (ops : Log Action)
    (net : Network Action n) (k : Fin n) : ops ⊆ fullSync hub (offlinePlay i ops net) k :=
  offline_then_sync hub i ops net k

end Net
end LifeTrac
