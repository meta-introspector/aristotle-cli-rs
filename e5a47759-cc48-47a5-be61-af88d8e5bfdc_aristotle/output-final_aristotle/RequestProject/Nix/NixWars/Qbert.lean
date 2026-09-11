import RequestProject.Nix.NixWars.Shards

/-!
# A thirteenth door: Monster Cubes, the Q*bert of the arcade

The cabinet in the corner of the arcade room. A four-row pyramid of ten cubes,
addressed by `(row, col)` with `col ≤ row ≤ 3`:

```
        (0,0)
     (1,0) (1,1)
  (2,0) (2,1) (2,2)
(3,0) (3,1) (3,2) (3,3)
```

The player hops down-left, down-right, up-left or up-right. A hop that lands on
a cube paints it (level one rules: a painted cube stays painted), which scores a
point the first time. A hop off the edge of the pyramid costs a life and drops
the player back on the top cube. When the last life is gone the cabinet freezes.

The headline facts: the pyramid invariant `col ≤ row ≤ 3` is preserved by every
hop, paint is permanent, lives never come back, the score — the number of
painted cubes — never falls, a fall costs exactly one life, and the board is clearable —
`qbert_winnable` names the eleven hops that paint all ten cubes without losing a
life.
-/

namespace NixWars

/-- The state of the Monster Cubes cabinet: where the player stands, the paint
on the ten cubes, and lives. -/
structure Qbert where
  /-- Row of the pyramid the player stands on, `0` at the apex. -/
  row : Nat
  /-- Column within that row. -/
  col : Nat
  /-- Paint on cube `(0,0)`. -/
  c0 : Nat
  /-- Paint on cube `(1,0)`. -/
  c1 : Nat
  /-- Paint on cube `(1,1)`. -/
  c2 : Nat
  /-- Paint on cube `(2,0)`. -/
  c3 : Nat
  /-- Paint on cube `(2,1)`. -/
  c4 : Nat
  /-- Paint on cube `(2,2)`. -/
  c5 : Nat
  /-- Paint on cube `(3,0)`. -/
  c6 : Nat
  /-- Paint on cube `(3,1)`. -/
  c7 : Nat
  /-- Paint on cube `(3,2)`. -/
  c8 : Nat
  /-- Paint on cube `(3,3)`. -/
  c9 : Nat
  /-- Lives left. -/
  lives : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The four hops. -/
inductive QbertCmd
  | dl
  | dr
  | ul
  | ur
  deriving DecidableEq, Repr, Inhabited

/-- How many cubes are painted: the score on the marquee. -/
def qbertPainted (s : Qbert) : Nat :=
  s.c0 + s.c1 + s.c2 + s.c3 + s.c4 + s.c5 + s.c6 + s.c7 + s.c8 + s.c9

/-- Paint the cube at `(r, k)`. Painting is idempotent: a cube that is already
painted stays painted. -/
def qbertPaint (s : Qbert) (r k : Nat) : Qbert :=
  { s with
    c0 := if r = 0 ∧ k = 0 then 1 else s.c0,
    c1 := if r = 1 ∧ k = 0 then 1 else s.c1,
    c2 := if r = 1 ∧ k = 1 then 1 else s.c2,
    c3 := if r = 2 ∧ k = 0 then 1 else s.c3,
    c4 := if r = 2 ∧ k = 1 then 1 else s.c4,
    c5 := if r = 2 ∧ k = 2 then 1 else s.c5,
    c6 := if r = 3 ∧ k = 0 then 1 else s.c6,
    c7 := if r = 3 ∧ k = 1 then 1 else s.c7,
    c8 := if r = 3 ∧ k = 2 then 1 else s.c8,
    c9 := if r = 3 ∧ k = 3 then 1 else s.c9 }

/-- A hop onto the cube at `(r, k)`: stand there and paint it. -/
def qbertHop (s : Qbert) (r k : Nat) : Qbert :=
  { qbertPaint s r k with row := r, col := k }

/-- A hop off the edge: one life, and back to the apex. -/
def qbertFall (s : Qbert) : Qbert :=
  { s with row := 0, col := 0, lives := s.lives - 1 }

/-- The transition function of the cabinet. -/
def qbertStep (s : Qbert) : QbertCmd → Qbert
  | .dl => if s.lives = 0 then s
           else if s.row < 3 then qbertHop s (s.row + 1) s.col else qbertFall s
  | .dr => if s.lives = 0 then s
           else if s.row < 3 then qbertHop s (s.row + 1) (s.col + 1) else qbertFall s
  | .ul => if s.lives = 0 then s
           else if 0 < s.col then qbertHop s (s.row - 1) (s.col - 1) else qbertFall s
  | .ur => if s.lives = 0 then s
           else if s.col < s.row then qbertHop s (s.row - 1) s.col else qbertFall s

/-- The cabinet as a payload. -/
def qbertSerialize (s : Qbert) : List Nat :=
  [s.row, s.col, s.c0, s.c1, s.c2, s.c3, s.c4, s.c5, s.c6, s.c7, s.c8, s.c9, s.lives]

/-- Reading the cabinet back from a payload. -/
def qbertDeserialize : List Nat → Option Qbert
  | [row, col, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, lives] =>
      some { row := row, col := col, c0 := c0, c1 := c1, c2 := c2, c3 := c3, c4 := c4,
             c5 := c5, c6 := c6, c7 := c7, c8 := c8, c9 := c9, lives := lives }
  | _ => none

theorem qbertDeserialize_qbertSerialize (s : Qbert) :
    qbertDeserialize (qbertSerialize s) = some s := by
  cases s; rfl

/-- **Monster Cubes as a door game.** -/
def monsterCubes : DoorGame where
  State := Qbert
  Cmd := QbertCmd
  step := qbertStep
  serialize := qbertSerialize
  deserialize := qbertDeserialize
  deserialize_serialize := qbertDeserialize_qbertSerialize

/-- A fresh cabinet: the player on the apex, which counts as painted, and three
lives. -/
def initialQbert : Qbert :=
  { row := 0, col := 0, c0 := 1, c1 := 0, c2 := 0, c3 := 0, c4 := 0, c5 := 0,
    c6 := 0, c7 := 0, c8 := 0, c9 := 0, lives := 3 }

/-! ### The pyramid -/

/-- The player is somewhere on the pyramid. -/
def QbertOn (s : Qbert) : Prop := s.col ≤ s.row ∧ s.row ≤ 3

instance (s : Qbert) : Decidable (QbertOn s) := by unfold QbertOn; infer_instance

/-- **Every hop stays on the pyramid.** A legal hop lands on a cube and a fall
returns to the apex, so `col ≤ row ≤ 3` can never be broken. -/
theorem qbertStep_on (s : Qbert) (h : QbertOn s) (c : QbertCmd) : QbertOn (qbertStep s c) := by
  obtain ⟨hcol, hrow⟩ := h
  cases c <;>
    · simp only [qbertStep, QbertOn]
      split_ifs <;>
        simp_all [qbertHop, qbertFall, qbertPaint] <;> omega

/-- The paint is binary. -/
def QbertBinary (s : Qbert) : Prop :=
  s.c0 ≤ 1 ∧ s.c1 ≤ 1 ∧ s.c2 ≤ 1 ∧ s.c3 ≤ 1 ∧ s.c4 ≤ 1 ∧ s.c5 ≤ 1 ∧ s.c6 ≤ 1 ∧ s.c7 ≤ 1 ∧
    s.c8 ≤ 1 ∧ s.c9 ≤ 1

/-- Painting keeps the paint binary. -/
theorem qbertPaint_binary (s : Qbert) (h : QbertBinary s) (r k : Nat) :
    QbertBinary (qbertPaint s r k) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    · simp only [qbertPaint]
      split_ifs <;> omega

/-- A hop keeps the paint binary. -/
theorem qbertHop_binary (s : Qbert) (h : QbertBinary s) (r k : Nat) :
    QbertBinary (qbertHop s r k) := by
  simpa [qbertHop, QbertBinary] using qbertPaint_binary s h r k

/-- Hopping keeps the paint binary. -/
theorem qbertStep_binary (s : Qbert) (h : QbertBinary s) (c : QbertCmd) :
    QbertBinary (qbertStep s c) := by
  cases c <;>
    · simp only [qbertStep]
      split_ifs
      · exact h
      · exact qbertHop_binary s h _ _
      · exact h

/-- **Paint is permanent.** A painted cube is painted after every hop. -/
theorem qbertStep_paint_persists (s : Qbert) (c : QbertCmd) (h : s.c9 = 1) :
    (qbertStep s c).c9 = 1 := by
  cases c <;>
    · simp only [qbertStep]
      split_ifs <;> simp_all [qbertHop, qbertFall, qbertPaint]

/-- **Lives never come back.** -/
theorem qbertStep_lives_le (s : Qbert) (c : QbertCmd) : (qbertStep s c).lives ≤ s.lives := by
  cases c <;>
    · simp only [qbertStep]
      split_ifs <;> simp [qbertHop, qbertFall, qbertPaint]

/-- A field that is zero or one is not lowered by painting. -/
theorem le_ite_one {P : Prop} [Decidable P] {x : Nat} (hx : x ≤ 1) :
    x ≤ if P then 1 else x := by
  split_ifs <;> omega

/-- **Painting never lowers the score.** -/
theorem qbertPaint_painted_ge (s : Qbert) (h : QbertBinary s) (r k : Nat) :
    qbertPainted s ≤ qbertPainted (qbertPaint s r k) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ := h
  simp only [qbertPainted, qbertPaint]
  have e0 := le_ite_one (P := (r = 0 ∧ k = 0)) h0
  have e1 := le_ite_one (P := (r = 1 ∧ k = 0)) h1
  have e2 := le_ite_one (P := (r = 1 ∧ k = 1)) h2
  have e3 := le_ite_one (P := (r = 2 ∧ k = 0)) h3
  have e4 := le_ite_one (P := (r = 2 ∧ k = 1)) h4
  have e5 := le_ite_one (P := (r = 2 ∧ k = 2)) h5
  have e6 := le_ite_one (P := (r = 3 ∧ k = 0)) h6
  have e7 := le_ite_one (P := (r = 3 ∧ k = 1)) h7
  have e8 := le_ite_one (P := (r = 3 ∧ k = 2)) h8
  have e9 := le_ite_one (P := (r = 3 ∧ k = 3)) h9
  omega

/-- A hop never lowers the score. -/
theorem qbertHop_painted_ge (s : Qbert) (h : QbertBinary s) (r k : Nat) :
    qbertPainted s ≤ qbertPainted (qbertHop s r k) := by
  simpa [qbertHop, qbertPainted, qbertPaint] using qbertPaint_painted_ge s h r k

/-- **The score never falls.** With binary paint, no hop can unpaint a cube, so
the count on the marquee only ever climbs. -/
theorem qbertStep_painted_ge (s : Qbert) (h : QbertBinary s) (c : QbertCmd) :
    qbertPainted s ≤ qbertPainted (qbertStep s c) := by
  cases c <;>
    · simp only [qbertStep]
      split_ifs
      · exact le_rfl
      · exact qbertHop_painted_ge s h _ _
      · simp [qbertPainted, qbertFall]

/-- **Game over is final.** With no lives left the cabinet ignores the joystick. -/
theorem qbertStep_dead (s : Qbert) (h : s.lives = 0) (c : QbertCmd) : qbertStep s c = s := by
  cases c <;> simp [qbertStep, h]

/-- **A fall costs exactly one life and returns the player to the apex.** -/
theorem qbert_fall_off_base (s : Qbert) (hl : s.lives ≠ 0) (h : s.row = 3) :
    qbertStep s .dl = { s with row := 0, col := 0, lives := s.lives - 1 } := by
  simp [qbertStep, hl, h, qbertFall]

/-- **A legal hop paints where it lands.** Hopping down-left from a row above
the base paints the cube the player lands on. -/
theorem qbert_dl_paints (s : Qbert) (hl : s.lives ≠ 0) (h : s.row = 0) (hc : s.col = 0) :
    (qbertStep s .dl).c1 = 1 ∧ (qbertStep s .dl).row = 1 ∧ (qbertStep s .dl).col = 0 := by
  simp [qbertStep, hl, h, hc, qbertHop, qbertPaint]

/-- The whole board is painted. -/
def QbertCleared (s : Qbert) : Prop :=
  s.c0 = 1 ∧ s.c1 = 1 ∧ s.c2 = 1 ∧ s.c3 = 1 ∧ s.c4 = 1 ∧ s.c5 = 1 ∧ s.c6 = 1 ∧ s.c7 = 1 ∧
    s.c8 = 1 ∧ s.c9 = 1

/-- The eleven hops that clear the board. -/
def qbertClearingRun : List QbertCmd :=
  [.dl, .dl, .dl, .ur, .dr, .ur, .dr, .ur, .dr, .ul, .ul]

/-- **The board is clearable.** From a fresh cabinet those eleven hops paint all
ten cubes, score ten and lose no lives. -/
theorem qbert_winnable :
    monsterCubes.run initialQbert qbertClearingRun =
      { row := 1, col := 1, c0 := 1, c1 := 1, c2 := 1, c3 := 1, c4 := 1, c5 := 1,
        c6 := 1, c7 := 1, c8 := 1, c9 := 1, lives := 3 } := by
  rfl

/-- The cleared board, stated as such. -/
theorem qbert_run_cleared : QbertCleared (monsterCubes.run initialQbert qbertClearingRun) := by
  rw [qbert_winnable]; exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- **Ten cubes painted, three lives left.** -/
theorem qbert_run_score :
    qbertPainted (monsterCubes.run initialQbert qbertClearingRun) = 10 ∧
      (monsterCubes.run initialQbert qbertClearingRun).lives = 3 := by
  rw [qbert_winnable]
  exact ⟨rfl, rfl⟩

/-! ### The thirteenth door inherits the whole BBS -/

/-- A Monster Cubes session as a URL. -/
def qbertUrl (s : GameSession monsterCubes) : String := transmit urlTransport s

theorem qbertUrl_roundtrip (s : GameSession monsterCubes) :
    receive monsterCubes urlTransport (qbertUrl s) = some s :=
  receive_transmit urlTransport s

/-- Monster Cubes is stateless too. -/
theorem qbert_play_eq (s : GameSession monsterCubes) (cs : List monsterCubes.Cmd) :
    runOverWire (g := monsterCubes) urlTransport (qbertUrl s) cs
      = some (qbertUrl { s with state := monsterCubes.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
