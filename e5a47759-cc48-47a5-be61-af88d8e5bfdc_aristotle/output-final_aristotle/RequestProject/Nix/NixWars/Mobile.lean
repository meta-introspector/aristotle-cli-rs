import RequestProject.Nix.NixWars.Monster.Flight
import RequestProject.Nix.NixWars.Controls

/-!
# The thumb: a mobile-friendly control pad

The cabinets were built for a keyboard.  This file adds the layer a phone
needs, and states what "mobile friendly" means precisely enough to prove:

* the pad is nine controls in a three-by-three grid, laid out in CSS pixels for
  the smallest viewport in common use, `320 × 568`.  Every control is at least
  `44 × 44` — the size a fingertip needs (`pad_targets_big`) — no two controls
  overlap, so nothing can be pressed by accident (`pad_targets_disjoint`), and
  the whole pad fits the viewport without scrolling (`pad_within_viewport`).
  Those three numbers are the ones the emitted pages lay out with;
* a tap is a command of the flight of `Monster/Flight.lean`.  Eight of the nine
  controls are also reachable as swipes, through the classifier of
  `Controls.lean`, and the map from compass direction to control is injective,
  so a swipe cannot mean two things (`dirTap_injective`, `dirTap_covers`);
* the pad has no axis keys — a phone has no room for fifteen of them — so it
  cycles: `AXIS+` steps the nose to the next axis, wrapping.  The proof that
  this is enough is `thumb_reaches_every_axis`: from any heading, in at most
  `dim` taps, the thumb can point the ship down any axis of an `n`-dimensional
  world.  So the whole `n`-dimensional flight is playable with one thumb.
-/

namespace NixWars

namespace Mobile

/-! ## Rectangles -/

/-- A rectangle of the screen, in CSS pixels. -/
structure Rect where
  /-- Left edge. -/
  x : Nat
  /-- Top edge. -/
  y : Nat
  /-- Width. -/
  w : Nat
  /-- Height. -/
  h : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The right edge. -/
def Rect.right (r : Rect) : Nat := r.x + r.w

/-- The bottom edge. -/
def Rect.bottom (r : Rect) : Nat := r.y + r.h

/-- Two rectangles overlap when they share a pixel. -/
def overlaps (a b : Rect) : Bool :=
  decide (a.x < b.right) && decide (b.x < a.right) &&
    decide (a.y < b.bottom) && decide (b.y < a.bottom)

/-- The smallest touch target a fingertip can reliably hit, in CSS pixels. -/
def minTouch : Nat := 44

/-- The viewport the pad is laid out for: the smallest in common use. -/
def viewportW : Nat := 320

/-- … and its height. -/
def viewportH : Nat := 568

/-! ## The pad -/

/-- The nine controls of the pad. -/
inductive Tap
  | /-- Point the nose down the previous axis. -/ axisDown
  | /-- Reverse the nose. -/ flip
  | /-- Point the nose down the next axis. -/ axisUp
  | /-- Throttle up. -/ thrust
  | /-- Move. -/ fly
  | /-- Throttle down. -/ brake
  | /-- Coarser world. -/ ascend
  | /-- Clamp to the station, or release. -/ dock
  | /-- Finer world. -/ descend
  deriving DecidableEq, Repr, Inhabited

/-- The pad, in reading order. -/
def allTaps : List Tap :=
  [.axisDown, .flip, .axisUp, .thrust, .fly, .brake, .ascend, .dock, .descend]

theorem allTaps_length : allTaps.length = 9 := by decide

theorem mem_allTaps (t : Tap) : t ∈ allTaps := by cases t <;> decide

/-- The label the page prints on a control. -/
def Tap.label : Tap → String
  | .axisDown => "AXIS-"
  | .flip => "FLIP"
  | .axisUp => "AXIS+"
  | .thrust => "THRUST"
  | .fly => "FLY"
  | .brake => "BRAKE"
  | .ascend => "ASCEND"
  | .dock => "DOCK"
  | .descend => "DESCEND"

/-- The position of the `i`-th control: a three-by-three grid of `96 × 64`
buttons across the bottom of the viewport. -/
def padRect (i : Nat) : Rect :=
  { x := 8 + (i % 3) * 104, y := 300 + (i / 3) * 72, w := 96, h := 64 }

/-- The control a tap is drawn in. -/
def tapRect : Tap → Rect
  | .axisDown => padRect 0
  | .flip => padRect 1
  | .axisUp => padRect 2
  | .thrust => padRect 3
  | .fly => padRect 4
  | .brake => padRect 5
  | .ascend => padRect 6
  | .dock => padRect 7
  | .descend => padRect 8

/-- **Every control is big enough for a fingertip.** -/
theorem pad_targets_big : ∀ t ∈ allTaps, minTouch ≤ (tapRect t).w ∧ minTouch ≤ (tapRect t).h := by
  decide

/-- **No two controls overlap**, so a tap means exactly one thing. -/
theorem pad_targets_disjoint :
    ∀ s ∈ allTaps, ∀ t ∈ allTaps, s ≠ t → overlaps (tapRect s) (tapRect t) = false := by
  decide

/-- **The pad fits the smallest viewport** without scrolling. -/
theorem pad_within_viewport :
    ∀ t ∈ allTaps, (tapRect t).right ≤ viewportW ∧ (tapRect t).bottom ≤ viewportH := by
  decide

/-- The gap the layout leaves between neighbouring controls. -/
theorem pad_gap : (padRect 1).x - (padRect 0).right = 8 := by decide

/-! ## Swipes -/

/-- The control a swipe stands for.  Eight of the nine are reachable this way;
`FLIP` is the button that is not, because the eight compass directions are
spent. -/
def dirTap : Controls.Dir → Tap
  | .n => .thrust
  | .s => .brake
  | .e => .axisUp
  | .w => .axisDown
  | .ne => .fly
  | .sw => .dock
  | .nw => .ascend
  | .se => .descend

/-- A swipe cannot mean two things. -/
theorem dirTap_injective : ∀ a ∈ Controls.allDirs, ∀ b ∈ Controls.allDirs,
    dirTap a = dirTap b → a = b := by decide

/-- Everything on the pad but `FLIP` is reachable by swipe. -/
theorem dirTap_covers (t : Tap) (h : t ≠ Tap.flip) : ∃ d, dirTap d = t := by
  cases t
  · exact ⟨.w, rfl⟩
  · exact absurd rfl h
  · exact ⟨.e, rfl⟩
  · exact ⟨.n, rfl⟩
  · exact ⟨.ne, rfl⟩
  · exact ⟨.s, rfl⟩
  · exact ⟨.nw, rfl⟩
  · exact ⟨.sw, rfl⟩
  · exact ⟨.se, rfl⟩

/-- A swipe that survives the dead zone of `Controls.classify` is a control. -/
def swipeTap (dead : Nat) (v : Controls.Delta) : Option Tap :=
  (Controls.classify dead v).map dirTap

/-- Every control but `FLIP` is produced by some swipe. -/
theorem swipeTap_covers (t : Tap) (h : t ≠ Tap.flip) :
    ∃ v : Controls.Delta, swipeTap 8 v = some t := by
  cases t
  · exact ⟨⟨-40, 0⟩, by decide⟩
  · exact absurd rfl h
  · exact ⟨⟨40, 0⟩, by decide⟩
  · exact ⟨⟨0, -40⟩, by decide⟩
  · exact ⟨⟨40, -40⟩, by decide⟩
  · exact ⟨⟨0, 40⟩, by decide⟩
  · exact ⟨⟨-40, -40⟩, by decide⟩
  · exact ⟨⟨-40, 40⟩, by decide⟩
  · exact ⟨⟨40, 40⟩, by decide⟩

/-! ## One thumb, `n` dimensions -/

/-- What a tap does to the ship. -/
def Tap.act (s : Monster.Ship) : Tap → Monster.Cmd
  | .axisDown => .aim (if s.ax = 0 then s.dim - 1 else s.ax - 1)
  | .flip => .flip
  | .axisUp => .aim ((s.ax + 1) % max s.dim 1)
  | .thrust => .thrust
  | .fly => .fly
  | .brake => .brake
  | .ascend => .ascend
  | .dock => .dock
  | .descend => .descend

/-- One tap. -/
def tap (s : Monster.Ship) (t : Tap) : Monster.Ship := Monster.step s (t.act s)

/-- A run of taps. -/
def tapRun (s : Monster.Ship) (ts : List Tap) : Monster.Ship := ts.foldl tap s

/-- Tapping keeps the ship legal: the pad cannot fly it out of the world. -/
theorem tap_ok {s : Monster.Ship} (h : Monster.Ok s) (t : Tap) : Monster.Ok (tap s t) :=
  Monster.step_ok h _

theorem tapRun_ok {s : Monster.Ship} (h : Monster.Ok s) (ts : List Tap) :
    Monster.Ok (tapRun s ts) := by
  induction ts generalizing s with
  | nil => exact h
  | cons t ts ih => exact ih (tap_ok h t)

theorem tap_axisUp_dim (s : Monster.Ship) : (tap s Tap.axisUp).dim = s.dim := rfl

/-- `AXIS+` steps the nose one axis on, wrapping round the world. -/
theorem tap_axisUp_ax {s : Monster.Ship} (h : 0 < s.dim) :
    (tap s Tap.axisUp).ax = (s.ax + 1) % s.dim := by
  have hmax : max s.dim 1 = s.dim := by omega
  have hlt : (s.ax + 1) % s.dim < s.dim := Nat.mod_lt _ h
  simp [tap, Tap.act, Monster.step, hmax, hlt]

/-- After `k` taps of `AXIS+` the nose points down axis `ax + k`, counted round
the world. -/
theorem axisUp_iterate {s : Monster.Ship} (h : 0 < s.dim) (hax : s.ax < s.dim) (k : Nat) :
    (tapRun s (List.replicate k Tap.axisUp)).ax = (s.ax + k) % s.dim ∧
      (tapRun s (List.replicate k Tap.axisUp)).dim = s.dim := by
  induction k generalizing s with
  | zero => exact ⟨by simpa [tapRun] using (Nat.mod_eq_of_lt hax).symm, rfl⟩
  | succ k ih =>
    have hd' : (tap s Tap.axisUp).dim = s.dim := rfl
    have hax' : (tap s Tap.axisUp).ax = (s.ax + 1) % s.dim := tap_axisUp_ax h
    have hpos' : 0 < (tap s Tap.axisUp).dim := by rw [hd']; exact h
    have hlt' : (tap s Tap.axisUp).ax < (tap s Tap.axisUp).dim := by
      rw [hax', hd']; exact Nat.mod_lt _ h
    obtain ⟨hax'', hdim''⟩ := ih hpos' hlt'
    have hrun : tapRun s (List.replicate (k + 1) Tap.axisUp)
        = tapRun (tap s Tap.axisUp) (List.replicate k Tap.axisUp) := rfl
    refine ⟨?_, ?_⟩
    · rw [hrun, hax'', hax', hd', Nat.mod_add_mod]
      congr 1
      omega
    · rw [hrun, hdim'', hd']

/-- **One thumb reaches every axis.**  However many dimensions the world has,
and wherever the nose is pointing, some number of taps of `AXIS+` — at most one
per axis — points it down the axis the pilot wants. -/
theorem thumb_reaches_every_axis {s : Monster.Ship} (h : Monster.Ok s) (hdim : 0 < s.dim)
    (target : Nat) (ht : target < s.dim) :
    ∃ k, k < s.dim ∧ (tapRun s (List.replicate k Tap.axisUp)).ax = target := by
  have hax : s.ax < s.dim := by
    rcases h.ax_ok with hlt | h0
    · exact hlt
    · omega
  refine ⟨(target + s.dim - s.ax) % s.dim, Nat.mod_lt _ hdim, ?_⟩
  rw [(axisUp_iterate hdim hax _).1, Nat.add_mod_mod,
    show s.ax + (target + s.dim - s.ax) = target + s.dim by omega, Nat.add_mod_right,
    Nat.mod_eq_of_lt ht]

end Mobile

end NixWars
