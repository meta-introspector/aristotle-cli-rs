/-
# The rendering kernel: worked examples, checked at build time

Every `#guard` below is evaluated by Lean while this file compiles, so
these are executable golden vectors, not comments.  `web/kernel-test.mjs`
pins the JavaScript twin to exactly the same strings; if either side
drifts, one of the two fails.

The last section is the honest counterexample: an archive checkpoint can
be *valid* and still be a **lie**, which is why `Share.resume_eq_replay`
carries an honesty hypothesis rather than assuming one.
-/
import Mathlib
import RequestProject.Kant.Kernel.Games.Lights
import RequestProject.Kant.Kernel.Games.Nim

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel.Demo

open Kant.Kernel

/-! ## Lights: replay, tokens and the runtime -/

/-- Press the leftmost lamp. -/
def press0 : Lights.kernel.Move := (⟨0, by decide⟩ : Fin Lights.width)

/-- Press the fourth lamp. -/
def press3 : Lights.kernel.Move := (⟨3, by decide⟩ : Fin Lights.width)

/-- Two presses from seed 21. -/
def lightsHistory : History Lights.kernel := ⟨21, [press0, press3]⟩

/- Seed 21 deals `10101`. -/
#guard ((Lights.kernel.gen 21).map (fun w => w.cells)) == some [true, false, true, false, true]

/- Replaying the two presses. -/
#guard (lightsHistory.world.map (fun w => w.cells)) == some [false, true, false, true, false]

/- The share token: 64 hex digits of digest, then `4;51;2;;3;` — four
numerals, being seed 21, two moves, lamp 0 and lamp 3. -/
#guard String.ofList (Share.share Lights.kernel lightsHistory) ==
  "b3e399bd8d94ed157fd882df3dc7001ec60d4f2a54f2dfc75b67c86f5379eb884;51;2;;3;"

/- The token reads back as the history it names. -/
#guard ((Share.verify Lights.kernel (Share.share Lights.kernel lightsHistory)).map
  (fun h => (h.seed, h.moves.map (fun m => m.val)))) == some (21, [0, 3])

/- A token with one digest character changed is refused. -/
#guard (Share.verify Lights.kernel
  ('0' :: (Share.share Lights.kernel lightsHistory).drop 1)).isNone

/- A token with one payload character changed is refused. -/
#guard (Share.verify Lights.kernel
  ((Share.share Lights.kernel lightsHistory).take 64 ++
    '9' :: (Share.share Lights.kernel lightsHistory).drop 65)).isNone

/- A token with rubbish appended is refused. -/
#guard (Share.verify Lights.kernel
  (Share.share Lights.kernel lightsHistory ++ ['z'])).isNone

/- A truncated token is refused. -/
#guard (Share.verify Lights.kernel
  ((Share.share Lights.kernel lightsHistory).take 30)).isNone

/-- The runtime after the same two presses, played one at a time. -/
def lightsRuntime : Runtime Lights.kernel :=
  Runtime.dispatch (Runtime.dispatch (Runtime.start Lights.kernel 21) (.act press0)) (.act press3)

#guard (lightsRuntime.past.map (fun m => m.val)) == [0, 3]
#guard (lightsRuntime.world.map (fun w => w.cells)) == some [false, true, false, true, false]

/- Undo keeps the move, in the redo branch. -/
#guard ((Runtime.dispatch lightsRuntime .undo).past.map (fun m => m.val)) == [0]
#guard ((Runtime.dispatch lightsRuntime .undo).future.map (fun m => m.val)) == [3]

/- Redo puts it back exactly. -/
#guard ((Runtime.dispatch (Runtime.dispatch lightsRuntime .undo) .redo).past.map
  (fun m => m.val)) == [0, 3]

/- Rewinding shows the prefix world. -/
#guard ((Runtime.rewind lightsRuntime 1).world.map (fun w => w.cells)) ==
  some [false, true, true, false, true]

/- A divergent move after rewinding truncates the redo branch; the old
branch survives in the token that was already minted. -/
#guard ((Runtime.dispatch (Runtime.rewind lightsRuntime 1) (.act press0)).past.map
  (fun m => m.val)) == [0, 0]
#guard ((Runtime.dispatch (Runtime.rewind lightsRuntime 1) (.act press0)).future.map
  (fun m => m.val)) == []
#guard (Share.verify Lights.kernel (Share.share Lights.kernel lightsHistory)).isSome

/- Loading a token gives a runtime with that history and no redo. -/
#guard ((Runtime.dispatch (Runtime.start Lights.kernel 0)
  (.load 21 [press0, press3])).world.map (fun w => w.cells)) ==
    some [false, true, false, true, false]

/-! ## The render tree -/

/- The picture of the world after the two presses, serialized. -/
#guard String.ofList (RenderTree.serTree (Lights.renderL ⟨[false, true, false, true, false]⟩)) ==
  "n3;div1;5;class6;lights6;n6;button2;9;data-cell;7;data-on1;01;t1;.n6;button2;9;data-cell1;17;data-on1;11;t1;*n6;button2;9;data-cell1;27;data-on1;01;t1;.n6;button2;9;data-cell1;37;data-on1;11;t1;*n6;button2;9;data-cell1;47;data-on1;01;t1;.n1;p1;5;class6;status1;t9;still lit"

/- And it parses back to the very same tree. -/
#guard (RenderTree.parseForest 64 1
  (RenderTree.serTree (Lights.renderL ⟨[false, true, false, true, false]⟩))).isSome

/- Five lamps means five controls, and each one decodes. -/
#guard (Lights.moveUIL ⟨[false, true, false, true, false]⟩).length == 5
#guard ((Lights.moveUIL ⟨[false, true, false, true, false]⟩).map
  (fun a => (Lights.decodeActionL ⟨[false, true, false, true, false]⟩ a).isSome)).all id

/-! ## Nim: the partial `step`, and a rejected move -/

/-- Take two from the first heap. -/
def takeTwo : Nim.kernel.Move := ({ heap := ⟨0, by decide⟩, take := 2 } : Nim.Move)

/-- Take nine from the first heap — more than it holds. -/
def takeNine : Nim.kernel.Move := ({ heap := ⟨0, by decide⟩, take := 9 } : Nim.Move)

/- Seed 7 deals heaps of three, two and one. -/
#guard ((Nim.kernel.gen 7).map (fun w => (w.heaps, w.turn))) == some ([3, 2, 1], false)

/- One legal take, and the turn passes. -/
#guard ((Nim.kernel.replay 7 [takeTwo]).map (fun w => (w.heaps, w.turn))) == some ([1, 2, 1], true)

/- An over-large take is refused by the kernel … -/
#guard (Nim.kernel.replay 7 [takeNine]).isNone

/-- … and the runtime is left *equal*, not merely equivalent. -/
def nimRuntime : Runtime Nim.kernel :=
  Runtime.dispatch (Runtime.start Nim.kernel 7) (.act takeTwo)

#guard ((Runtime.dispatch nimRuntime (.act takeNine)).past.map
  (fun m => (m.heap.val, m.take))) == [(0, 2)]
#guard ((Runtime.dispatch nimRuntime (.act takeNine)).world.map (fun w => w.heaps)) ==
  some [1, 2, 1]

/- The Nim token, in the same format as the Lights one — the codec is
generic, only the move encoding differs. -/
#guard String.ofList (Share.share Nim.kernel ⟨7, [takeTwo]⟩) ==
  "bb7069704e0a863e26277e495839798b17d6f62f628d422c841c219d88aefb514;7;1;;2;"

#guard ((Share.verify Nim.kernel (Share.share Nim.kernel ⟨7, [takeTwo]⟩)).map
  (fun h => (h.seed, h.moves.map (fun m => (m.heap.val, m.take))))) == some (7, [(0, 2)])

/- Six controls for heaps of three, two and one. -/
#guard (Nim.moveUIN ⟨[3, 2, 1], false⟩).length == 6

/-! ## A checkpoint can be valid and still be a lie -/

/-- An archive cell claiming that pressing lamp 0 from seed 21 puts every
lamp out.  It does not — but the claimed world is perfectly *valid*. -/
def dishonestCell : Share.Checkpoint Lights.kernel :=
  ⟨21, [press0], ⟨[false, false, false, false, false]⟩⟩

/- The claimed world passes the validity check a browser can run … -/
#guard Lights.kernel.validB dishonestCell.world

/- … and yet it is not what replaying the covered prefix gives. -/
#guard ((Lights.kernel.replay dishonestCell.seed dishonestCell.covered).map (fun w => w.cells))
  != some dishonestCell.world.cells

/- Which is exactly why resuming from it disagrees with the truth: this
is the trust assumption §14 has to state, not a theorem it can prove. -/
#guard ((Share.resume Lights.kernel dishonestCell []).map (fun w => w.cells))
  != ((Lights.kernel.replay 21 [press0]).map (fun w => w.cells))

/-- The honest cell for the same prefix, by contrast, agrees with replay
everywhere — here, on the continuation `[press3]`. -/
def honestCell : Share.Checkpoint Lights.kernel :=
  ⟨21, [press0], ⟨[false, true, true, false, true]⟩⟩

#guard ((Lights.kernel.replay honestCell.seed honestCell.covered).map (fun w => w.cells))
  == some honestCell.world.cells

#guard ((Share.resume Lights.kernel honestCell [press3]).map (fun w => w.cells))
  == ((Lights.kernel.replay 21 [press0, press3]).map (fun w => w.cells))

/-! ## The archive index -/

/-- An index holding the honest cell under its own key. -/
def cellIndex : Share.Index Lights.kernel :=
  [(Share.checkpointKey Lights.kernel honestCell.seed honestCell.covered, honestCell)]

/- One lookup finds the cell that covers a seed and a prefix. -/
#guard ((Share.lookupCell Lights.kernel cellIndex 21 [press0]).map (fun c => c.world.cells))
  == some honestCell.world.cells

/- A prefix the index does not cover is simply absent. -/
#guard (Share.lookupCell Lights.kernel cellIndex 21 [press0, press3]).isNone

/- Checking a cell by recomputing its prefix accepts the honest one … -/
#guard Share.verifyCell Lights.kernel (fun a b => a.cells == b.cells) honestCell

/- … and refuses the lie, which is the client's only defence: a right key
   says nothing about the body served under it. -/
#guard !Share.verifyCell Lights.kernel (fun a b => a.cells == b.cells) dishonestCell

end Kant.Kernel.Demo
