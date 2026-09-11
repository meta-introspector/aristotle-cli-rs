import RequestProject.Gvcs.Sneakernet.Sealed
import RequestProject.Gvcs.Net.Log

/-!
# Sharing a game

The post is one way to move moves about; the other is to hand somebody your
whole log.  `RequestProject/Net/Log.lean` already has the replicated log and
its strong eventual consistency; this file plays a `SealedGame` on it.

* `replayChecked_converges` — two people who have seen the same moves, in
  whatever order and with whatever duplication, are looking at the same
  position;
* `replayChecked_sync` — handing somebody moves they already have does not move
  their game;
* `reach_replayChecked` — and whatever log a replica replays, the position it
  computes is one legal play could have produced: a shared log cannot smuggle
  in an illegal move, because the replica checks every move as it applies it.
-/

namespace LifeTrac
namespace Sneakernet
namespace Share

variable (G : SealedGame) [DecidableEq G.Move]

/-- A replica's position: fold the checked step over the log in canonical
order. -/
noncomputable def replayChecked (s : G.State) (L : Net.Log G.Move) : G.State :=
  Net.replay G.applyChecked s L

/-- **Everybody who has seen the same moves sees the same game.** -/
theorem replayChecked_converges (s : G.State) {L M : Net.Log G.Move}
    (h : ∀ o : Net.Op G.Move, o ∈ L ↔ o ∈ M) :
    replayChecked G s L = replayChecked G s M :=
  Net.eventual_consistency _ _ h

/-- Syncing with somebody who has nothing new does not move the game. -/
theorem replayChecked_sync (s : G.State) (L M : Net.Log G.Move) (h : M ⊆ L) :
    replayChecked G s (Net.merge L M) = replayChecked G s L :=
  Net.replay_merge_self _ _ L M h

omit [DecidableEq G.Move] in
/-- Folding checked moves over a list only ever reaches legal positions. -/
theorem reach_foldl (s : G.State) (l : List (Net.Op G.Move)) :
    G.Reach s (l.foldl (fun t o => G.applyChecked t o.payload) s) := by
  induction l generalizing s with
  | nil => exact SealedGame.Reach.refl s
  | cons o l ih =>
      exact SealedGame.Reach.trans G (G.reach_applyChecked s o.payload) (ih _)

/-- **No cheating through the log either**: whatever log a replica replays, the
position it arrives at is one that legal play could have produced. -/
theorem reach_replayChecked (s : G.State) (L : Net.Log G.Move) :
    G.Reach s (replayChecked G s L) :=
  reach_foldl G s (Net.sortLog L)

end Share
end Sneakernet
end LifeTrac
