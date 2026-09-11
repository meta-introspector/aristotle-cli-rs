import RequestProject.Craft.Tycoon

/-!
# Recording and replaying games, in SVG

A **recording** is a starting position plus the list of moves that were played
from it — nothing else.  Because `GameState.step` is total and deterministic,
the whole game can be reconstructed from that: `Recording.frames` is the list
of positions the game passed through, and `Recording.final` is where it ended.

Proved here:

* `frames_length`, `frames_head` — a recording of `n` moves replays to `n + 1`
  positions, starting at the position that was recorded;
* `frames_getElem` — **replay is faithful**: the `i`-th frame of the replay is
  exactly the position reached after the first `i` recorded moves;
* `final_eq_frames_getLast` — the replay ends where the game ended;
* `frames_take` — **scrubbing the timeline is sound**: replaying only the first
  `k` moves gives exactly the first `k + 1` frames of the full replay;
* `frames_wf` — every frame of a replay satisfies the voxel invariant;
* `svgFrames_length`, `svgAnimation_groups` — the SVG film of a recording has
  one frame per position, each of them the renderer's picture of that position.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-- A recorded game: where it started and what was played. -/
structure Recording where
  /-- The position the recording starts from. -/
  init : GameState
  /-- The moves, in order.  Illegal moves are kept; they replay as no-ops. -/
  moves : List Action
deriving DecidableEq, Repr, Inhabited

namespace Recording

/-- Every position the recorded game passed through, starting position first. -/
def frames (r : Recording) : List GameState :=
  r.moves.scanl GameState.step r.init

/-- Where the recorded game ended. -/
def final (r : Recording) : GameState := GameState.run r.init r.moves

@[simp] theorem frames_length (r : Recording) : r.frames.length = r.moves.length + 1 :=
  List.length_scanl

theorem frames_ne_nil (r : Recording) : r.frames ≠ [] := by
  intro h
  have := frames_length r
  rw [h] at this
  simp at this

@[simp] theorem frames_head (r : Recording) : r.frames.head? = some r.init := by
  cases r with
  | mk init moves => cases moves <;> simp [frames]

private theorem scanl_getElem (g : GameState) (ms : List Action) (i : Nat)
    (hi : i < (ms.scanl GameState.step g).length) :
    (ms.scanl GameState.step g)[i] = GameState.run g (ms.take i) := by
  induction ms generalizing g i with
  | nil =>
      simp only [List.scanl_nil, List.length_singleton] at hi
      interval_cases i
      simp
  | cons a t ih =>
      cases i with
      | zero => simp
      | succ n =>
          simp only [List.scanl_cons] at hi ⊢
          simp only [List.length_cons, Nat.add_lt_add_iff_right] at hi
          rw [List.getElem_cons_succ, ih _ n hi]
          simp

/-- **Replay is faithful.** The `i`-th frame of the replay is the position the
recorded game was in after its first `i` moves. -/
theorem frames_getElem (r : Recording) (i : Nat) (hi : i < r.frames.length) :
    r.frames[i] = GameState.run r.init (r.moves.take i) :=
  scanl_getElem r.init r.moves i hi

/-- The replay ends exactly where the recorded game ended. -/
theorem final_eq_frames_getLast (r : Recording) :
    r.final = r.frames.getLast (frames_ne_nil r) := by
  have hlen := frames_length r
  rw [List.getLast_eq_getElem]
  rw [frames_getElem r _ (by omega)]
  simp [final]

private theorem scanl_take (g : GameState) (ms : List Action) (k : Nat) :
    (ms.take k).scanl GameState.step g = (ms.scanl GameState.step g).take (k + 1) := by
  induction ms generalizing g k with
  | nil => cases k <;> simp
  | cons a t ih =>
      cases k with
      | zero => simp
      | succ n => simp [List.scanl_cons, ih]

/-- **Scrubbing the timeline is sound.** Replaying the first `k` moves of a
recording produces exactly the first `k + 1` frames of the full replay: a
partial replay is a prefix of the whole. -/
theorem frames_take (r : Recording) (k : Nat) :
    (Recording.mk r.init (r.moves.take k)).frames = r.frames.take (k + 1) :=
  scanl_take r.init r.moves k

/-- Cutting a recording short cannot change what came before. -/
theorem final_take (r : Recording) (k : Nat) :
    (Recording.mk r.init (r.moves.take k)).final = GameState.run r.init (r.moves.take k) := rfl

/-- Every position in a replay satisfies the voxel invariant. -/
theorem frames_wf {r : Recording} (h : r.init.WF) : ∀ g ∈ r.frames, g.WF := by
  intro g hg
  obtain ⟨i, hi, rfl⟩ := List.getElem_of_mem hg
  rw [frames_getElem r i hi]
  exact GameState.run_wf h _

/-- The final position of a replay satisfies the voxel invariant. -/
theorem final_wf {r : Recording} (h : r.init.WF) : r.final.WF :=
  GameState.run_wf h _

/-! ## The SVG film -/

/-- One rendered picture per frame: the film of the game. -/
def svgFrames (r : Recording) : List String :=
  r.frames.map (fun g => renderSVG g.scene)

@[simp] theorem svgFrames_length (r : Recording) :
    (r.svgFrames).length = r.moves.length + 1 := by
  simp [svgFrames]

/-- Each picture in the film is the renderer's picture of the corresponding
position of the replay. -/
theorem svgFrames_getElem (r : Recording) (i : Nat) (hi : i < r.frames.length) :
    (r.svgFrames)[i]'(by simpa [svgFrames] using hi)
      = renderSVG (GameState.run r.init (r.moves.take i)).scene := by
  simp only [svgFrames, List.getElem_map]
  rw [frames_getElem r i hi]

/-- One frame of the film, as an SVG group that the player can step to. -/
def svgGroup (i : Nat) (g : GameState) : String :=
  "<g id=\"f" ++ toString i ++ "\" data-tick=\"" ++ toString g.tick ++
  "\" data-cash=\"" ++ toString g.cash ++ "\">" ++
  String.join ((render g.scene).map svgQuad) ++ "</g>"

/-- The whole recording as a single SVG document, one group per frame. -/
def svgAnimation (r : Recording) : String :=
  svgHeader ++ String.join (r.frames.mapIdx svgGroup) ++ svgFooter

/-- The film has exactly one group per position of the replay. -/
theorem svgAnimation_groups (r : Recording) :
    (r.frames.mapIdx svgGroup).length = r.moves.length + 1 := by
  simp

/-- The animation is a well-formed SVG document. -/
theorem svgAnimation_wraps (r : Recording) :
    ∃ body, r.svgAnimation = svgHeader ++ body ++ svgFooter :=
  ⟨String.join (r.frames.mapIdx svgGroup), rfl⟩

end Recording

end Tycoon
