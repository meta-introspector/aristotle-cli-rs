import RequestProject.Nix.NixWars.Learn
import RequestProject.Nix.NixWars.Frontier

/-!
# Controls: swipe, mouse, joystick and autopilot

The cabinets on the board are played by hand from a keyboard. This file adds
the other three ways of driving them and proves that they are the *same* way:
one classifier turns a pointer displacement into a compass direction, and one
table turns a compass direction into a command of the door. A touch swipe, a
mouse drag and a push of the on-screen joystick all go through that classifier,
so they cannot disagree.

* `octant` reads a displacement `(dx, dy)` (screen coordinates: `y` grows
  downwards) as one of eight compass directions, with a diagonal band of
  factor two;
* `classify` adds a dead zone: a displacement no longer than `dead` is not a
  gesture at all;
* the classifier is proved *scale invariant* (`octant_scale`) -- a long swipe
  and a short one in the same direction give the same command, so the joystick
  knob's travel does not matter -- and *antisymmetric* (`octant_neg`): the
  opposite push is the opposite command;
* the per-door tables `qbertOfDir`, `invadersOfDir`, `shipOfDir`,
  `frontierOfDir` are proved *complete*: every command of the door can be
  produced by some gesture, so nothing on the cabinet is unreachable by
  thumb;
* `cellIndex` is the mouse: a click at a pixel picks the cabinet under it, and
  clicking a cabinet's own cell gives that cabinet back (`cellIndex_origin`);
* `pilot` is autopilot: a state-feedback policy unrolled into a plan, with
  `pilot_add` saying that disengaging and re-engaging the autopilot flies
  exactly the same course. Two autopilots are then flown: the ship's reaches
  Sgr A* on a full tank, and the arcade cabinet's clears the pyramid.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Controls

/-! ## Directions -/

/-- The eight compass directions of a stick. -/
inductive Dir
  | n | ne | e | se | s | sw | w | nw
  deriving DecidableEq, Repr, Inhabited

/-- Every direction, for enumeration. -/
def allDirs : List Dir := [.n, .ne, .e, .se, .s, .sw, .w, .nw]

/-- The direction opposite a direction. -/
def Dir.opposite : Dir → Dir
  | .n => .s | .ne => .sw | .e => .w | .se => .nw
  | .s => .n | .sw => .ne | .w => .e | .nw => .se

@[simp] theorem Dir.opposite_opposite (d : Dir) : d.opposite.opposite = d := by
  cases d <;> rfl

theorem Dir.opposite_ne (d : Dir) : d.opposite ≠ d := by
  cases d <;> decide

theorem mem_allDirs (d : Dir) : d ∈ allDirs := by
  cases d <;> decide

/-! ## Displacements -/

/-- A pointer displacement in screen coordinates: `x` grows to the right and
`y` grows *downwards*, as in the DOM. -/
structure Delta where
  /-- Horizontal displacement, positive to the right. -/
  dx : Int
  /-- Vertical displacement, positive downwards. -/
  dy : Int
  deriving DecidableEq, Repr, Inhabited

namespace Delta

/-- The opposite displacement. -/
def neg (v : Delta) : Delta := ⟨-v.dx, -v.dy⟩

/-- A displacement stretched by a whole factor. -/
def scale (k : Nat) (v : Delta) : Delta := ⟨(k : Int) * v.dx, (k : Int) * v.dy⟩

/-- The squared length of a displacement -- no square roots, so the dead zone
is exact integer arithmetic. -/
def sq (v : Delta) : Nat := v.dx.natAbs * v.dx.natAbs + v.dy.natAbs * v.dy.natAbs

@[simp] theorem sq_neg (v : Delta) : (neg v).sq = v.sq := by
  simp [sq, neg]

@[simp] theorem neg_neg (v : Delta) : (neg (neg v)) = v := by
  simp [neg]

theorem sq_scale (k : Nat) (v : Delta) : (scale k v).sq = k * k * v.sq := by
  simp [sq, scale, Int.natAbs_mul]
  ring

theorem sq_eq_zero {v : Delta} (h : v.sq = 0) : v = ⟨0, 0⟩ := by
  obtain ⟨x, y⟩ := v
  simp only [sq] at h
  have hx : x.natAbs = 0 := by nlinarith [Nat.zero_le x.natAbs, Nat.zero_le y.natAbs]
  have hy : y.natAbs = 0 := by nlinarith [Nat.zero_le x.natAbs, Nat.zero_le y.natAbs]
  simp [Int.natAbs_eq_zero] at hx hy
  simp [hx, hy]

end Delta

/-! ## The classifier -/

/-- The compass direction of a displacement. The diagonal band is a factor of
two: a push is read as horizontal only when it is at least twice as wide as it
is tall, and vertically likewise. -/
def octant (v : Delta) : Dir :=
  if 2 * v.dy.natAbs ≤ v.dx.natAbs then
    (if 0 < v.dx then Dir.e else Dir.w)
  else if 2 * v.dx.natAbs ≤ v.dy.natAbs then
    (if v.dy < 0 then Dir.n else Dir.s)
  else if 0 < v.dx then
    (if v.dy < 0 then Dir.ne else Dir.se)
  else
    (if v.dy < 0 then Dir.nw else Dir.sw)

/-- **The opposite push is the opposite command.** -/
theorem octant_neg (v : Delta) (h : 0 < v.sq) : octant (Delta.neg v) = (octant v).opposite := by
  obtain ⟨x, y⟩ := v
  have h' : x ≠ 0 ∨ y ≠ 0 := by
    by_contra hc
    push_neg at hc
    simp [Delta.sq, hc.1, hc.2] at h
  simp only [octant, Delta.neg, Int.natAbs_neg, Dir.opposite]
  rcases h' with h' | h' <;> split_ifs <;> first
    | rfl
    | (exfalso; omega)

/-- **The length of the push does not matter.** Stretching a displacement by a
positive whole factor -- a longer swipe, a joystick pushed further -- gives the
same direction. -/
theorem octant_scale (k : Nat) (hk : 0 < k) (v : Delta) :
    octant (Delta.scale k v) = octant v := by
  obtain ⟨x, y⟩ := v
  have hx : ((k : Int) * x).natAbs = k * x.natAbs := by
    simp [Int.natAbs_mul]
  have hy : ((k : Int) * y).natAbs = k * y.natAbs := by
    simp [Int.natAbs_mul]
  have hk' : (0 : Int) < (k : Int) := by exact_mod_cast hk
  have hposx : (0 < (k : Int) * x) ↔ 0 < x := by
    constructor
    · intro hh
      by_contra hcon
      push_neg at hcon
      nlinarith
    · intro hh; positivity
  have hnegy : ((k : Int) * y < 0) ↔ y < 0 := by
    constructor
    · intro hh
      by_contra hcon
      push_neg at hcon
      nlinarith
    · intro hh; nlinarith
  have key : ∀ a b : Nat, (2 * (k * b) ≤ k * a) ↔ (2 * b ≤ a) := by
    intro a b
    have hrw : 2 * (k * b) = k * (2 * b) := by ring
    rw [hrw]
    constructor
    · intro hh; exact Nat.le_of_mul_le_mul_left hh hk
    · intro hh; exact Nat.mul_le_mul (le_refl k) hh
  simp only [octant, Delta.scale, hx, hy, key, hposx, hnegy]

/-- Every direction really is produced by some push. -/
theorem octant_surjective (d : Dir) : ∃ v : Delta, octant v = d := by
  cases d
  · exact ⟨⟨0, -10⟩, by decide⟩
  · exact ⟨⟨10, -10⟩, by decide⟩
  · exact ⟨⟨10, 0⟩, by decide⟩
  · exact ⟨⟨10, 10⟩, by decide⟩
  · exact ⟨⟨0, 10⟩, by decide⟩
  · exact ⟨⟨-10, 10⟩, by decide⟩
  · exact ⟨⟨-10, 0⟩, by decide⟩
  · exact ⟨⟨-10, -10⟩, by decide⟩

/-- A gesture: a displacement outside the dead zone. Inside it, nothing
happens -- a tap is not a swipe, and a resting thumb is not a push. -/
def classify (dead : Nat) (v : Delta) : Option Dir :=
  if v.sq ≤ dead * dead then none else some (octant v)

/-- **The dead zone is dead.** -/
theorem classify_dead {dead : Nat} {v : Delta} (h : v.sq ≤ dead * dead) :
    classify dead v = none := by
  simp [classify, h]

/-- Outside the dead zone the gesture is the octant. -/
theorem classify_live {dead : Nat} {v : Delta} (h : dead * dead < v.sq) :
    classify dead v = some (octant v) := by
  simp [classify, Nat.not_le.mpr h]

/-- A gesture is registered exactly when it leaves the dead zone. -/
theorem classify_isSome {dead : Nat} {v : Delta} :
    (classify dead v).isSome = true ↔ dead * dead < v.sq := by
  by_cases h : v.sq ≤ dead * dead
  · simp [classify, h, Nat.not_lt.mpr h]
  · simp [classify, h, Nat.lt_of_not_le h]

/-- **The opposite swipe is the opposite command**, dead zone and all. -/
theorem classify_neg (dead : Nat) (v : Delta) :
    classify dead (Delta.neg v) = (classify dead v).map Dir.opposite := by
  by_cases h : v.sq ≤ dead * dead
  · simp [classify, h]
  · have hlt : dead * dead < v.sq := Nat.lt_of_not_le h
    have hpos : 0 < v.sq := Nat.lt_of_le_of_lt (Nat.zero_le _) hlt
    simp [classify, h, octant_neg v hpos]

/-- **A longer swipe in the same direction is the same command.** -/
theorem classify_scale (dead k : Nat) (hk : 0 < k) (v : Delta)
    (h : dead * dead < v.sq) : classify dead (Delta.scale k v) = classify dead v := by
  have hle : v.sq ≤ k * k * v.sq := Nat.le_mul_of_pos_left _ (Nat.mul_pos hk hk)
  have h' : dead * dead < (Delta.scale k v).sq := by
    rw [Delta.sq_scale]; omega
  rw [classify_live h', classify_live h, octant_scale k hk v]

/-! ## One classifier for touch, mouse and stick

A touch swipe is the displacement between `touchstart` and `touchend`; a mouse
drag is the displacement between `mousedown` and `mouseup`; a push of the
on-screen stick is the displacement of the knob from the centre of its gate.
All three are the same function of two points, so the three controls cannot
drift apart. -/

/-- A point on the screen. -/
structure Point where
  /-- Horizontal pixel coordinate. -/
  x : Int
  /-- Vertical pixel coordinate, growing downwards. -/
  y : Int
  deriving DecidableEq, Repr, Inhabited

/-- The displacement from one point to another. -/
def drag (p q : Point) : Delta := ⟨q.x - p.x, q.y - p.y⟩

/-- A touch swipe. -/
def swipeGesture (dead : Nat) (p q : Point) : Option Dir := classify dead (drag p q)

/-- A mouse drag. -/
def mouseGesture (dead : Nat) (p q : Point) : Option Dir := classify dead (drag p q)

/-- A push of the on-screen joystick: the knob, at `q`, relative to the centre
of the gate, at `p`. -/
def stickGesture (dead : Nat) (centre knob : Point) : Option Dir :=
  classify dead (drag centre knob)

/-- **Mouse and touch agree.** The same displacement is the same command
whichever device made it. -/
theorem mouse_eq_swipe (dead : Nat) (p q : Point) :
    mouseGesture dead p q = swipeGesture dead p q := rfl

/-- **The stick agrees with them too.** -/
theorem stick_eq_swipe (dead : Nat) (p q : Point) :
    stickGesture dead p q = swipeGesture dead p q := rfl

/-- **Dragging back is the opposite command.** -/
theorem swipe_symm (dead : Nat) (p q : Point) :
    swipeGesture dead q p = (swipeGesture dead p q).map Dir.opposite := by
  have hd : drag q p = Delta.neg (drag p q) := by
    simp only [drag, Delta.neg, Delta.mk.injEq]
    omega
  simp [swipeGesture, hd, classify_neg]

/-! ### The joystick gate

The knob is dragged inside a square gate of half-width `r`; the page clamps it
there. Clamping is only cosmetic: the command comes from the raw displacement,
so a thumb that leaves the gate still steers. -/

/-- Clamp a coordinate into `[-r, r]`. -/
def clamp1 (r : Nat) (t : Int) : Int :=
  if t < -(r : Int) then -(r : Int) else if (r : Int) < t then (r : Int) else t

/-- The drawn position of the knob: the push, clamped to the gate. -/
def knob (r : Nat) (v : Delta) : Delta := ⟨clamp1 r v.dx, clamp1 r v.dy⟩

theorem clamp1_bounds (r : Nat) (t : Int) : -(r : Int) ≤ clamp1 r t ∧ clamp1 r t ≤ (r : Int) := by
  unfold clamp1
  split_ifs with h1 h2 <;> constructor <;> omega

/-- **The knob stays in its gate.** -/
theorem knob_in_gate (r : Nat) (v : Delta) :
    (knob r v).dx.natAbs ≤ r ∧ (knob r v).dy.natAbs ≤ r := by
  obtain ⟨h1, h2⟩ := clamp1_bounds r v.dx
  obtain ⟨h3, h4⟩ := clamp1_bounds r v.dy
  constructor <;> simp only [knob] <;> omega

/-- A push already inside the gate is drawn where it is. -/
theorem knob_id (r : Nat) (v : Delta) (hx : v.dx.natAbs ≤ r) (hy : v.dy.natAbs ≤ r) :
    knob r v = v := by
  obtain ⟨x, y⟩ := v
  simp only at hx hy
  simp only [knob, clamp1, Delta.mk.injEq]
  refine ⟨?_, ?_⟩ <;> split_ifs <;> omega

/-! ## From a direction to a command

Each cabinet gets a table. The tables are total -- every direction does
something -- and complete: every command of the cabinet is some direction, so
the whole game is playable with a thumb. -/

/-- Monster Cubes: the pyramid is diagonal, so the four diagonals are the four
hops and the cardinal directions fall in with their nearest diagonal. -/
def qbertOfDir : Dir → QbertCmd
  | .nw | .w => .ul
  | .ne | .n => .ur
  | .sw | .s => .dl
  | .se | .e => .dr

/-- Shard Invaders: left and right walk the gun, up fires, down lets the rank
drop. -/
def invadersOfDir : Dir → InvadersCmd
  | .w | .nw | .sw => .left
  | .e | .ne | .se => .right
  | .n => .fire
  | .s => .tick

/-- NixWars: up is ahead, the diagonals are the long and the short hop, down is
j-invariant navigation, and the flanks scan and read the crown. -/
def shipOfDir : Dir → ShipCmd
  | .n => .warp 99
  | .ne => .warp 999
  | .nw => .warp 9
  | .s => .jnav
  | .e => .scan
  | .w => .status
  | .se => .unlock
  | .sw => .status

/-- Frontier Run: up thrusts, down brakes, the flanks turn, the corners fly and
dock. -/
def frontierOfDir : Dir → FrontierCmd
  | .n => .thrust
  | .s => .brake
  | .e => .turnTo 2
  | .w => .turnTo 6
  | .ne => .fly
  | .nw => .fly
  | .se => .dock
  | .sw => .dock

/-- The command a swipe sends to Monster Cubes. -/
def qbertSwipe (dead : Nat) (v : Delta) : Option QbertCmd := (classify dead v).map qbertOfDir

/-- The command a swipe sends to Shard Invaders. -/
def invadersSwipe (dead : Nat) (v : Delta) : Option InvadersCmd :=
  (classify dead v).map invadersOfDir

/-- The command a swipe sends to the ship. -/
def shipSwipe (dead : Nat) (v : Delta) : Option ShipCmd := (classify dead v).map shipOfDir

/-- **Every hop of the pyramid is a swipe.** -/
theorem qbertSwipe_covers (c : QbertCmd) : ∃ v : Delta, qbertSwipe 8 v = some c := by
  cases c
  · exact ⟨⟨-40, 40⟩, by decide⟩
  · exact ⟨⟨40, 40⟩, by decide⟩
  · exact ⟨⟨-40, -40⟩, by decide⟩
  · exact ⟨⟨40, -40⟩, by decide⟩

/-- **Every command of the gun is a swipe.** -/
theorem invadersSwipe_covers (c : InvadersCmd) : ∃ v : Delta, invadersSwipe 8 v = some c := by
  cases c
  · exact ⟨⟨-40, 0⟩, by decide⟩
  · exact ⟨⟨40, 0⟩, by decide⟩
  · exact ⟨⟨0, -40⟩, by decide⟩
  · exact ⟨⟨0, 40⟩, by decide⟩

/-- **Every direction does something** -- there is no dead direction on the
stick, only the dead zone at its centre. -/
theorem qbertOfDir_surjective (c : QbertCmd) : ∃ d : Dir, qbertOfDir d = c := by
  cases c
  · exact ⟨.sw, rfl⟩
  · exact ⟨.se, rfl⟩
  · exact ⟨.nw, rfl⟩
  · exact ⟨.ne, rfl⟩

theorem invadersOfDir_surjective (c : InvadersCmd) : ∃ d : Dir, invadersOfDir d = c := by
  cases c
  · exact ⟨.w, rfl⟩
  · exact ⟨.e, rfl⟩
  · exact ⟨.n, rfl⟩
  · exact ⟨.s, rfl⟩

/-- The swipe that plays a hop: a right inverse of the pyramid's table. -/
def dirOfQbertCmd : QbertCmd → Dir
  | .ul => .nw | .ur => .ne | .dl => .sw | .dr => .se

/-- **Every hop has its swipe.** -/
theorem qbertOfDir_dirOfQbertCmd (c : QbertCmd) : qbertOfDir (dirOfQbertCmd c) = c := by
  cases c <;> rfl

/-- The swipe that plays a command of the gun. -/
def dirOfInvadersCmd : InvadersCmd → Dir
  | .left => .w | .right => .e | .fire => .n | .tick => .s

/-- **Every command of the gun has its swipe.** -/
theorem invadersOfDir_dirOfInvadersCmd (c : InvadersCmd) :
    invadersOfDir (dirOfInvadersCmd c) = c := by
  cases c <;> rfl

/-- **Opposite swipes are opposite hops** on the pyramid: swiping back undoes
the direction, though not necessarily the paint. -/
theorem qbertSwipe_neg (dead : Nat) (v : Delta) :
    qbertSwipe dead (Delta.neg v)
      = (qbertSwipe dead v).map (fun c => match c with
          | .dl => .ur | .ur => .dl | .dr => .ul | .ul => .dr) := by
  simp only [qbertSwipe, classify_neg, Option.map_map]
  cases h : classify dead v with
  | none => rfl
  | some d => cases d <;> rfl

/-! ## The mouse: clicking a cabinet

The arcade floor is a grid of cabinets. A click at a pixel picks the cabinet
whose cell contains it. -/

/-- The cabinet under a click, on a `cols`-wide grid of `w × h` cells. -/
def cellIndex (cols w h : Nat) (p : Point) : Nat :=
  (p.y.toNat / h) * cols + (p.x.toNat / w)

/-- The top-left pixel of cell `i`. -/
def cellOrigin (cols w h : Nat) (i : Nat) : Point :=
  ⟨((i % cols) * w : Nat), ((i / cols) * h : Nat)⟩

/-- **Clicking a cabinet picks that cabinet.** -/
theorem cellIndex_origin (cols w h i : Nat) (hw : 0 < w) (hh : 0 < h) :
    cellIndex cols w h (cellOrigin cols w h i) = i := by
  have h1 : (((i / cols) * h : Nat) : Int).toNat = (i / cols) * h := Int.toNat_natCast _
  have h2 : (((i % cols) * w : Nat) : Int).toNat = (i % cols) * w := Int.toNat_natCast _
  simp only [cellIndex, cellOrigin, h1, h2, Nat.mul_div_cancel _ hh, Nat.mul_div_cancel _ hw]
  exact Nat.div_add_mod' i cols

/-- **A click inside the floor picks a cabinet of the floor.** -/
theorem cellIndex_lt (cols w h rows : Nat) (p : Point)
    (hx : p.x.toNat < cols * w) (hy : p.y.toNat < rows * h) :
    cellIndex cols w h p < rows * cols := by
  have hxx : p.x.toNat / w < cols := Nat.div_lt_of_lt_mul (by rw [Nat.mul_comm]; exact hx)
  have hyy : p.y.toNat / h < rows := Nat.div_lt_of_lt_mul (by rw [Nat.mul_comm]; exact hy)
  simp only [cellIndex]
  calc (p.y.toNat / h) * cols + (p.x.toNat / w)
      < (p.y.toNat / h) * cols + cols := by omega
    _ = ((p.y.toNat / h) + 1) * cols := by ring
    _ ≤ rows * cols := Nat.mul_le_mul_right cols (by omega)

/-! ## Autopilot

An autopilot is a policy -- a command chosen from the state -- unrolled into a
plan. Because the doors are deterministic, the plan an autopilot flies is
completely determined by where it is engaged and for how long. -/

/-- The plan an autopilot flies: `n` commands, each chosen from the state it is
issued in. -/
def pilot (g : DoorGame) (policy : g.State → g.Cmd) : g.State → Nat → List g.Cmd
  | _, 0 => []
  | s, n + 1 => policy s :: pilot g policy (g.step s (policy s)) n

variable {g : DoorGame}

@[simp] theorem pilot_zero (policy : g.State → g.Cmd) (s : g.State) :
    pilot g policy s 0 = [] := rfl

@[simp] theorem pilot_succ (policy : g.State → g.Cmd) (s : g.State) (n : Nat) :
    pilot g policy s (n + 1) = policy s :: pilot g policy (g.step s (policy s)) n := rfl

/-- **The autopilot flies for exactly as long as it is engaged.** -/
@[simp] theorem pilot_length (policy : g.State → g.Cmd) (s : g.State) (n : Nat) :
    (pilot g policy s n).length = n := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp [pilot, ih]

/-- **Disengaging and re-engaging the autopilot flies the same course.**
Handing control back to the pilot and immediately taking it again changes
nothing: the plan splits exactly at the moment of the handover. -/
theorem pilot_add (policy : g.State → g.Cmd) (s : g.State) (m n : Nat) :
    pilot g policy s (m + n)
      = pilot g policy s m ++ pilot g policy (g.run s (pilot g policy s m)) n := by
  induction m generalizing s with
  | zero => simp
  | succ m ih =>
    have : m + 1 + n = (m + n) + 1 := by omega
    rw [this]
    simp only [pilot_succ, List.cons_append, DoorGame.run_cons]
    rw [ih]

/-- The state an autopilot leaves the game in. -/
def autoRun (g : DoorGame) (policy : g.State → g.Cmd) (s : g.State) (n : Nat) : g.State :=
  g.run s (pilot g policy s n)

@[simp] theorem autoRun_zero (policy : g.State → g.Cmd) (s : g.State) :
    autoRun g policy s 0 = s := rfl

@[simp] theorem autoRun_succ (policy : g.State → g.Cmd) (s : g.State) (n : Nat) :
    autoRun g policy s (n + 1) = autoRun g policy (g.step s (policy s)) n := rfl

/-- **Autopilot is iteration of the closed loop.** -/
theorem autoRun_add (policy : g.State → g.Cmd) (s : g.State) (m n : Nat) :
    autoRun g policy s (m + n) = autoRun g policy (autoRun g policy s m) n := by
  simp only [autoRun, pilot_add]
  induction m generalizing s with
  | zero => simp
  | succ m ih => simpa using ih (g.step s (policy s))

/-- The tape an autopilot records, for the demo: every state it passed
through. -/
def pilotTape (g : DoorGame) (policy : g.State → g.Cmd) (s : g.State) (n : Nat) : List g.State :=
  Learn.traceFrom g s (pilot g policy s n)

/-- **The tape is faithful**: it is one frame per command plus the frame the
autopilot started in. -/
theorem pilotTape_length (policy : g.State → g.Cmd) (s : g.State) (n : Nat) :
    (pilotTape g policy s n).length = n + 1 := by
  simp [pilotTape, Learn.traceFrom_length s]

/-- **The last frame of the tape is where the autopilot left the game.** -/
theorem pilotTape_getLast (policy : g.State → g.Cmd) (s : g.State) (n : Nat) :
    (pilotTape g policy s n).getLast? = some (autoRun g policy s n) :=
  Learn.traceFrom_getLast s _

/-- The tape of an autopilot is never empty. -/
theorem pilotTape_ne_nil (policy : g.State → g.Cmd) (s : g.State) (n : Nat) :
    pilotTape g policy s n ≠ [] :=
  Learn.traceFrom_ne_nil s _

/-! ### The ship's autopilot -/

/-- The ship's autopilot: hold ninety-nine light-years a jump, and take the
last short hop exactly. Ninety-nine light-years is one hop under the hundred a
unit of fuel buys, so the course is free. -/
def shipAuto (s : Ship) : ShipCmd :=
  if 99 ≤ s.dist then .warp 99 else .warp s.dist

/-- **The autopilot arrives.** Two hundred and seventy jumps from Sol put the
ship on Sgr A*. -/
theorem shipAuto_arrives : (autoRun nixWars shipAuto initialShip 270).dist = 0 := by
  rfl

/-- **And it arrives on a full tank**: every jump it plans is under the hundred
light-years a unit of fuel buys. -/
theorem shipAuto_fuel : (autoRun nixWars shipAuto initialShip 270).fuel = 100 := by
  rfl

/-- Two hundred and sixty-nine jumps are not enough: the autopilot's course is
tight. -/
theorem shipAuto_not_early : (autoRun nixWars shipAuto initialShip 269).dist = 42 := by
  rfl

/-- Once arrived the autopilot holds station: the ship stays on Sgr A*. -/
theorem shipAuto_holds (n : Nat) :
    (autoRun nixWars shipAuto (autoRun nixWars shipAuto initialShip 270) n).dist = 0 := by
  have hstep : ∀ s : Ship, s.dist = 0 → (nixWars.step s (shipAuto s)).dist = 0 := by
    intro s hs
    show (shipStep s (shipAuto s)).dist = 0
    simp only [shipAuto, hs]
    norm_num [shipStep, warpShip, warpCost, hs]
  have h : ∀ (m : Nat) (s : Ship), s.dist = 0 → (autoRun nixWars shipAuto s m).dist = 0 := by
    intro m
    induction m with
    | zero => intro s hs; exact hs
    | succ m ih => intro s hs; exact ih _ (hstep s hs)
  exact h n _ shipAuto_arrives

/-! ### The cabinet's autopilot

A greedy policy: hop onto a fresh cube if one is next to you, otherwise climb
back towards the apex. It is a state-feedback controller -- it looks only at
the cabinet in front of it -- and it clears the pyramid. -/

/-- Does this hop paint a cube that was not painted? -/
def qbertGains (s : Qbert) (c : QbertCmd) : Bool :=
  decide (qbertPainted s < qbertPainted (qbertStep s c))

/-- The cabinet's autopilot. -/
def qbertAuto (s : Qbert) : QbertCmd :=
  if qbertGains s .dl then .dl
  else if qbertGains s .dr then .dr
  else if qbertGains s .ur then .ur
  else if qbertGains s .ul then .ul
  else if s.col < s.row then .ur
  else if 0 < s.col then .ul
  else if s.row < 3 then .dr
  else .ur

/-- **A hop that paints is not a fall**: falling off the edge paints nothing,
so a gaining hop leaves the lives alone. -/
theorem qbertGains_lives (s : Qbert) (c : QbertCmd) (h : qbertGains s c = true) :
    (qbertStep s c).lives = s.lives := by
  cases c <;>
    · simp only [qbertGains, decide_eq_true_eq, qbertStep] at h ⊢
      split_ifs at h ⊢ <;>
        simp_all [qbertHop, qbertFall, qbertPaint, qbertPainted]

/-- **The autopilot never walks off the pyramid.** From any square of the
pyramid with a life left, the command it chooses is a legal hop. -/
theorem qbertAuto_lives (s : Qbert) (hon : QbertOn s) (hl : 0 < s.lives) :
    (qbertStep s (qbertAuto s)).lives = s.lives := by
  obtain ⟨hcol, hrow⟩ := hon
  unfold qbertAuto
  split_ifs with h1 h2 h3 h4 h5 h6 h7
  · exact qbertGains_lives s .dl h1
  · exact qbertGains_lives s .dr h2
  · exact qbertGains_lives s .ur h3
  · exact qbertGains_lives s .ul h4
  · simp [qbertStep, h5, qbertHop, qbertPaint, Nat.ne_of_gt hl]
  · simp [qbertStep, h6, qbertHop, qbertPaint, Nat.ne_of_gt hl]
  · simp [qbertStep, h7, qbertHop, qbertPaint, Nat.ne_of_gt hl]
  · simp only [qbertStep]
    have : s.row = 3 := by omega
    have hcr : s.col < s.row := by omega
    simp [hcr, qbertHop, qbertPaint, Nat.ne_of_gt hl]

/-- **The cabinet's autopilot keeps all three lives, for ever.** -/
theorem qbertAuto_no_falls (n : Nat) :
    (autoRun monsterCubes qbertAuto initialQbert n).lives = 3 ∧
      QbertOn (autoRun monsterCubes qbertAuto initialQbert n) := by
  have key : ∀ (m : Nat) (s : Qbert), QbertOn s → s.lives = 3 →
      (autoRun monsterCubes qbertAuto s m).lives = 3 ∧
        QbertOn (autoRun monsterCubes qbertAuto s m) := by
    intro m
    induction m with
    | zero => intro s hon hl; exact ⟨hl, hon⟩
    | succ m ih =>
      intro s hon hl
      refine ih _ (qbertStep_on s hon _) ?_
      have := qbertAuto_lives s hon (by omega)
      simpa [hl] using this
  exact key n initialQbert (by decide) rfl

/-- **The autopilot clears the pyramid**, in eleven hops -- the same length as
the hand-played clearing run, found by the policy rather than written down. -/
theorem qbertAuto_clears : QbertCleared (autoRun monsterCubes qbertAuto initialQbert 11) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- Ten cubes painted and three lives left. -/
theorem qbertAuto_score :
    qbertPainted (autoRun monsterCubes qbertAuto initialQbert 11) = 10 ∧
      (autoRun monsterCubes qbertAuto initialQbert 11).lives = 3 := ⟨rfl, rfl⟩

/-- The autopilot's plan, for the demo tape. -/
def qbertAutoPlan : List QbertCmd := pilot monsterCubes qbertAuto initialQbert 11

theorem qbertAutoPlan_eq :
    qbertAutoPlan = [.dl, .dl, .dl, .ur, .dr, .ur, .dr, .ur, .dr, .ul, .ul] := by
  rfl

/-- **The autopilot rediscovers the hand-played clearing run.** -/
theorem qbertAutoPlan_eq_clearingRun : qbertAutoPlan = qbertClearingRun := by
  rfl

end Controls
end NixWars
