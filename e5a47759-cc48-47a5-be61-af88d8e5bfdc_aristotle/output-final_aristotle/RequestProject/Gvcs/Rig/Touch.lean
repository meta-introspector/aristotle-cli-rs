import RequestProject.Gvcs.Rig.Drive
import RequestProject.Gvcs.Sim.Interface

/-!
# Thumbs, keys and a mouse

The page is meant to be played on a phone held in two hands, so the input layer
is the part of it that most wants pinning down.  There are three ways in, and
they all end in the *same* pair of axes:

* a **virtual joystick** — a pad of some radius, and a finger somewhere on it.
  `stickAxis` turns the finger's offset from the middle of the pad into a
  demand in thousandths, with a dead zone in the middle so that a thumb resting
  on the pad does nothing;
* **on-screen buttons and the keyboard** — arrows or `WASD` and two buttons,
  which are the same thing at full deflection (`keys_match_stick`);
* **a mouse**, which drives the pad exactly as a finger does: one code path,
  which is why there is nothing more to say about it.

Above that sits `classify`, which reads a *swipe*: a press, a drag and a
release become a tap, a hold, or a swipe in one of four directions, and in the
workshop those pick the block, turn the grid over and change the layer.

What is proved:

* `stickAxis_inRange` — a finger anywhere on (or off) the pad gives a demand of
  at most full scale, so `padInput_valid` gives that **every input the
  interface can produce is a legal command frame** in the sense of
  `RequestProject/Sim/Interface.lean`, and `padInput_inv` that the driving
  invariants of `RequestProject/Rig/Drive.lean` apply to it;
* `stickAxis_dead`, `stickAxis_sat`, `stickAxis_mono`, `stickAxis_odd` — the
  dead zone, the saturation, monotonicity, and that left and right are
  mirror images;
* `classify_horizontal`, `classify_vertical`, `classify_tap`, `classify_scale`
  — a drag along an axis is read as that axis, a short one is a tap, and the
  reading does not depend on how big the screen is;
* `editor_kind_roundtrip`, `editor_layer_roundtrip` — swiping one way and then
  the other leaves the workshop where it started.
-/

namespace LifeTrac
namespace Rig

/-! ## The virtual joystick -/

/-- The dead zone, in thousandths: a finger inside this does nothing. -/
def deadZone : Int := 120

/-- One axis of the pad: the finger's offset `p` from the middle, on a pad of
radius `r`, as a demand in thousandths, with the dead zone and the clamp. -/
def stickAxis (r p : Int) : Int :=
  let raw := clampTo 1000 ((p * 1000).tdiv (max 1 r))
  if -deadZone < raw ∧ raw < deadZone then 0 else raw

/-- A finger anywhere gives a demand of at most full scale. -/
theorem stickAxis_inRange (r p : Int) : |stickAxis r p| ≤ 1000 := by
  simp only [stickAxis]
  split
  · norm_num
  · exact abs_clampTo (by norm_num) _

/-- A thumb resting in the middle of the pad asks for nothing. -/
theorem stickAxis_dead {r p : Int} (h : |p| * 1000 < deadZone * max 1 r) : stickAxis r p = 0 := by
  have hr : (0 : Int) < max 1 r := lt_of_lt_of_le one_pos (le_max_left _ _)
  have hb : |(p * 1000).tdiv (max 1 r)| < deadZone := by
    refine abs_tdiv_lt_of_abs_lt hr ?_
    rw [abs_mul, show |(1000 : Int)| = 1000 from by norm_num]
    exact h
  simp only [stickAxis]
  rw [clampTo_eq_self (le_of_lt (lt_of_lt_of_le hb (by norm_num [deadZone])))]
  rw [abs_lt] at hb
  rw [if_pos ⟨hb.1, hb.2⟩]

/-- A finger at the rim, or past it, asks for everything. -/
theorem stickAxis_sat {r p : Int} (hr : 0 < r) (h : r ≤ p) : stickAxis r p = 1000 := by
  have hmax : max 1 r = r := max_eq_right hr
  have h1 : (1000 : Int) ≤ (p * 1000).tdiv (max 1 r) := by
    rw [hmax, Int.tdiv_eq_ediv_of_nonneg (by nlinarith)]
    have : 1000 * r ≤ p * 1000 := by nlinarith
    exact Int.le_ediv_of_mul_le hr (by linarith)
  simp only [stickAxis, clampTo, min_eq_left h1]
  rw [max_eq_right (by norm_num)]
  norm_num [deadZone]

/-- The pad is odd: the same offset the other way is the same demand the other
way. -/
theorem stickAxis_odd (r p : Int) : stickAxis r (-p) = -stickAxis r p := by
  have hneg : ((-p) * 1000).tdiv (max 1 r) = -((p * 1000).tdiv (max 1 r)) := by
    rw [show (-p) * 1000 = -(p * 1000) by ring, Int.neg_tdiv]
  simp only [stickAxis, hneg]
  have hcl : ∀ x : Int, clampTo 1000 (-x) = -clampTo 1000 x := by
    intro x
    simp only [clampTo]
    omega
  rw [hcl]
  split_ifs with h1 h2 h2
  · rfl
  · omega
  · omega
  · rfl

/-- Pushing the pad further never asks for less. -/
theorem stickAxis_mono {r p q : Int} (hr : 0 < r) (hp : 0 ≤ p) (h : p ≤ q) :
    stickAxis r p ≤ stickAxis r q := by
  have hmax : max 1 r = r := max_eq_right hr
  have hmono : (p * 1000).tdiv (max 1 r) ≤ (q * 1000).tdiv (max 1 r) := by
    rw [hmax, Int.tdiv_eq_ediv_of_nonneg (by nlinarith),
      Int.tdiv_eq_ediv_of_nonneg (by nlinarith)]
    exact Int.ediv_le_ediv hr (by nlinarith)
  have hnn : 0 ≤ (p * 1000).tdiv (max 1 r) :=
    Int.tdiv_nonneg (by nlinarith) (le_of_lt (lt_of_lt_of_le one_pos (le_max_left 1 r)))
  have hcl : clampTo 1000 ((p * 1000).tdiv (max 1 r)) ≤ clampTo 1000 ((q * 1000).tdiv (max 1 r)) := by
    simp only [clampTo]
    omega
  have hcl0 : 0 ≤ clampTo 1000 ((p * 1000).tdiv (max 1 r)) := by
    simp only [clampTo]; omega
  simp only [stickAxis]
  split_ifs with h1 h2 h2 <;> omega

/-! ## What the page sends down -/

/-- Where the two thumbs are, and what the buttons are doing.  The left pad is
the steering, the right pad the throttle; `scoop` and `brake` are the two
buttons, on screen or on the keyboard. -/
structure Pad where
  /-- Radius of the pads, in pixels. -/
  radius : Int
  /-- The left thumb's horizontal offset. -/
  leftX : Int
  /-- The right thumb's vertical offset — up the screen is forward, so this is
  negated on the way in. -/
  rightY : Int
  /-- The scoop button. -/
  scoop : Bool
  /-- The brake button. -/
  brake : Bool
  deriving Repr, DecidableEq

/-- The input a pad makes. -/
def padInput (p : Pad) : Input :=
  { throttle := stickAxis p.radius (-p.rightY)
    steer := stickAxis p.radius p.leftX
    scoop := p.scoop
    brake := p.brake }

/-- **Everything the interface can produce is in range.** -/
theorem padInput_inRange (p : Pad) :
    |(padInput p).throttle| ≤ 1000 ∧ |(padInput p).steer| ≤ 1000 :=
  ⟨stickAxis_inRange _ _, stickAxis_inRange _ _⟩

/-- The same input as a command frame of `RequestProject/Sim/Interface.lean`. -/
def padCommand (p : Pad) : Interface.Command :=
  { throttle := (padInput p).throttle
    steer := (padInput p).steer
    lift := if p.scoop then -1000 else 0
    tilt := 0
    ignition := true
    lights := false }

/-- **Every frame the interface can send is a legal frame**, so everything
proved about the wire protocol applies to it. -/
theorem padCommand_valid (p : Pad) : (padCommand p).Valid := by
  have h1 := stickAxis_inRange p.radius (-p.rightY)
  have h2 := stickAxis_inRange p.radius p.leftX
  rw [abs_le] at h1 h2
  refine ⟨⟨h1.1, h1.2⟩, ⟨h2.1, h2.2⟩, ?_, ?_⟩
  · simp only [padCommand, Interface.InRange]
    split <;> norm_num
  · simp only [padCommand, Interface.InRange]
    norm_num

/-- **The driving invariants apply to anything a player can do**: a tick of the
game driven from the pad keeps the machine on the lap, on the track, under the
speed limit, with a tank that is not overdrawn and a scoop that is not
overfull. -/
theorem padInput_inv {m : Machine} {s : Drive} (hc : 0 ≤ m.cap) (p : Pad) (h : Inv m s) :
    Inv m (tick m (padInput p) s) := tick_inv hc _ h

/-! ## The keyboard and the on-screen buttons -/

/-- The keys the game reads: the arrows or `WASD`, and two buttons. -/
structure Keys where
  /-- Forward. -/
  up : Bool
  /-- Back. -/
  down : Bool
  /-- Left. -/
  left : Bool
  /-- Right. -/
  right : Bool
  /-- The scoop. -/
  scoop : Bool
  /-- The brake. -/
  brake : Bool
  deriving Repr, DecidableEq

/-- An axis from a pair of keys: both or neither is nothing. -/
def keyAxis (neg pos : Bool) : Int :=
  (if pos then 1000 else 0) - (if neg then 1000 else 0)

theorem keyAxis_inRange (a b : Bool) : |keyAxis a b| ≤ 1000 := by
  simp only [keyAxis]
  cases a <;> cases b <;> norm_num

/-- The input the keys make. -/
def keyInput (k : Keys) : Input :=
  { throttle := keyAxis k.down k.up
    steer := keyAxis k.left k.right
    scoop := k.scoop
    brake := k.brake }

/-- **A key is a thumb at the rim.**  Holding the right arrow asks for exactly
what the pad asks for with the thumb on the right edge, so a player on a laptop
and a player on a phone are playing the same game. -/
theorem keys_match_stick {r : Int} (hr : 0 < r) (scoop brake : Bool) :
    keyInput ⟨false, false, false, true, scoop, brake⟩ =
      padInput ⟨r, r, 0, scoop, brake⟩ := by
  have h1 : stickAxis r r = 1000 := stickAxis_sat hr le_rfl
  have h2 : stickAxis r 0 = 0 := by
    refine stickAxis_dead ?_
    simp only [abs_zero, zero_mul]
    have : (0 : Int) < max 1 r := lt_of_lt_of_le one_pos (le_max_left _ _)
    simp only [deadZone]
    nlinarith
  simp [keyInput, padInput, keyAxis, h1, h2]
  

/-! ## Swipes -/

/-- Which way a swipe went. -/
inductive Dir where
  /-- Up the screen. -/
  | up
  /-- Down the screen. -/
  | down
  /-- To the left. -/
  | left
  /-- To the right. -/
  | right
  deriving Repr, DecidableEq

/-- What a press, a drag and a release amount to. -/
inductive Gesture where
  /-- A short press that did not move. -/
  | tap
  /-- A long press that did not move. -/
  | hold
  /-- A drag. -/
  | swipe (d : Dir)
  deriving Repr, DecidableEq

/-- How far a finger may move and still count as still, in pixels. -/
def tapRadius : Int := 24
/-- How long a press has to be to count as a hold, in milliseconds. -/
def holdMs : Nat := 400

/-- **Reading a gesture**: a drag by `(dx, dy)` pixels over `dt` milliseconds. -/
def classify (dx dy : Int) (dt : Nat) : Gesture :=
  if |dx| ≤ tapRadius ∧ |dy| ≤ tapRadius then
    (if dt < holdMs then Gesture.tap else Gesture.hold)
  else if |dy| ≤ |dx| then
    (if 0 < dx then Gesture.swipe .right else Gesture.swipe .left)
  else
    (if 0 < dy then Gesture.swipe .down else Gesture.swipe .up)

/-- A finger that barely moved is a tap or a hold, never a swipe. -/
theorem classify_tap {dx dy : Int} {dt : Nat} (hx : |dx| ≤ tapRadius) (hy : |dy| ≤ tapRadius) :
    classify dx dy dt = Gesture.tap ∨ classify dx dy dt = Gesture.hold := by
  rw [classify, if_pos (And.intro hx hy)]
  by_cases hdt : dt < holdMs
  · exact Or.inl (by rw [if_pos hdt])
  · exact Or.inr (by rw [if_neg hdt])

/-- A drag along the screen is read as a sideways swipe. -/
theorem classify_horizontal {dx : Int} {dt : Nat} (h : tapRadius < |dx|) :
    classify dx 0 dt = Gesture.swipe (if 0 < dx then .right else .left) := by
  have hne : ¬ (|dx| ≤ tapRadius ∧ |(0 : Int)| ≤ tapRadius) := fun hc => absurd hc.1 (by omega)
  rw [classify, if_neg hne, if_pos (by simp)]
  by_cases hd : 0 < dx <;> simp [hd]

/-- A drag up or down the screen is read as an up or down swipe. -/
theorem classify_vertical {dy : Int} {dt : Nat} (h : tapRadius < |dy|) :
    classify 0 dy dt = Gesture.swipe (if 0 < dy then .down else .up) := by
  have hne : ¬ (|(0 : Int)| ≤ tapRadius ∧ |dy| ≤ tapRadius) := fun hc => absurd hc.2 (by omega)
  have hlt : ¬ |dy| ≤ |(0 : Int)| := by
    simp only [abs_zero, tapRadius] at h ⊢
    omega
  rw [classify, if_neg hne, if_neg hlt]
  by_cases hd : 0 < dy <;> simp [hd]

/-- The reading does not depend on how big the screen is: scaling a drag up
gives the same gesture, provided it was already a swipe. -/
theorem classify_scale {dx dy : Int} {dt : Nat} {k : Int} (hk : 0 < k)
    (h : ¬ (|dx| ≤ tapRadius ∧ |dy| ≤ tapRadius))
    (h' : ¬ (|k * dx| ≤ tapRadius ∧ |k * dy| ≤ tapRadius)) :
    classify (k * dx) (k * dy) dt = classify dx dy dt := by
  have habs : ∀ x : Int, |k * x| = k * |x| := fun x => by rw [abs_mul, abs_of_pos hk]
  have hiff : (|k * dy| ≤ |k * dx|) ↔ (|dy| ≤ |dx|) := by
    rw [habs, habs]
    exact ⟨fun hle => le_of_mul_le_mul_left hle hk,
      fun hle => mul_le_mul_of_nonneg_left hle hk.le⟩
  have hpos : ∀ x : Int, ¬ 0 < x → ¬ 0 < k * x := by
    intro x hx hc
    exact hx (by by_contra hxx; push_neg at hxx; nlinarith)
  rw [classify, classify, if_neg h', if_neg h]
  by_cases hcase : |dy| ≤ |dx|
  · rw [if_pos (hiff.2 hcase), if_pos hcase]
    by_cases hd : 0 < dx
    · rw [if_pos hd, if_pos (mul_pos hk hd)]
    · rw [if_neg hd, if_neg (hpos dx hd)]
  · rw [if_neg (fun hc => hcase (hiff.1 hc)), if_neg hcase]
    by_cases hd : 0 < dy
    · rw [if_pos hd, if_pos (mul_pos hk hd)]
    · rw [if_neg hd, if_neg (hpos dy hd)]

/-! ## The workshop -/

/-- What the editor is showing: which layer, and which block the next tap will
put down. -/
structure Editor where
  /-- The layer on show, `0 … gridD - 1`. -/
  layer : Nat
  /-- The block the next tap puts down, `0 … 6`. -/
  kind : Nat
  deriving Repr, DecidableEq

/-- The editor is showing something it can show. -/
def Editor.Ok (e : Editor) : Prop := e.layer < gridD ∧ e.kind < kindN

/-- A swipe in the workshop: sideways turns the layer over, up and down pick
the block.  Both wrap round, so nothing is ever out of reach on a small
screen. -/
def Editor.swipe (e : Editor) : Dir → Editor
  | .left => { e with layer := (e.layer + gridD - 1) % gridD }
  | .right => { e with layer := (e.layer + 1) % gridD }
  | .up => { e with kind := (e.kind + 1) % kindN }
  | .down => { e with kind := (e.kind + kindN - 1) % kindN }

/-- Swiping never leaves the workshop showing something it cannot show. -/
theorem Editor.swipe_ok {e : Editor} (h : e.Ok) (d : Dir) : (e.swipe d).Ok := by
  obtain ⟨hl, hk⟩ := h
  cases d <;>
    exact ⟨by simp only [Editor.swipe]; first
              | exact hl
              | exact Nat.mod_lt _ (by norm_num [gridD]),
           by simp only [Editor.swipe]; first
              | exact hk
              | exact Nat.mod_lt _ (by norm_num [kindN])⟩

/-- Picking the next block and then the previous one leaves the same block. -/
theorem editor_kind_roundtrip {e : Editor} (h : e.Ok) :
    ((e.swipe .up).swipe .down).kind = e.kind := by
  obtain ⟨-, hk⟩ := h
  simp only [Editor.swipe, kindN] at hk ⊢
  omega

/-- Turning the grid over and back leaves the same layer. -/
theorem editor_layer_roundtrip {e : Editor} (h : e.Ok) :
    ((e.swipe .right).swipe .left).layer = e.layer := by
  obtain ⟨hl, -⟩ := h
  simp only [Editor.swipe, gridD] at hl ⊢
  omega

/-! ## Tapping a cell -/

/-- The cell a tap lands on: the grid is drawn as `gridW` columns and `gridH`
rows of square buttons of side `sq`, with cell `(0,0)` of the layer at the
origin of the picture. -/
def tapCell (sq px py : Nat) (layer : Nat) : Option Nat :=
  if sq = 0 then none
  else
    let cx := px / sq
    let cy := py / sq
    if cx < gridW ∧ cy < gridH ∧ layer < gridD then
      some (cellIdx cx cy layer)
    else none

/-- A tap that lands on the grid names a cell of the grid. -/
theorem tapCell_lt {sq px py layer i : Nat} (h : tapCell sq px py layer = some i) :
    i < gridN := by
  simp only [tapCell] at h
  split at h
  · exact absurd h (by simp)
  · split at h
    · next hc =>
        obtain ⟨h1, h2, h3⟩ := hc
        have hi : i = cellIdx (px / sq) (py / sq) layer := by simpa using h.symm
        subst hi
        exact cellIdx_lt h1 h2 h3
    · exact absurd h (by simp)

end Rig
end LifeTrac
