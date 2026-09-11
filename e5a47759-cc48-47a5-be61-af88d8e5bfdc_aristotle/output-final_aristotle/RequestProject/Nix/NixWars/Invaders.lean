import RequestProject.Nix.NixWars.Shards

/-!
# A fifteenth door: Shard Invaders, the second cabinet of the arcade

The cabinet next to Monster Cubes. Five invaders hang in a rank over an
eight-column floor; the rank slides sideways, and every time it hits a wall it
drops one row and reverses. The player moves along the floor and fires straight
up; a shot hits whichever invader is directly overhead.

```
        col: 0 1 2 3 4 5 6 7
  rank (ox=0)  M M M M M . . .
  rank (ox=3)  . . . M M M M M
  floor         . . ^ . . . . .
```

Invader `j` stands over column `ox + j`, so the rank's offset `ox` runs from `0`
to `3` and the whole rank always fits on the floor. The rank has dropped `dy`
rows; at `dy = 5` the invaders have landed and the cabinet freezes.

The headline facts: the cabinet is always legal (`invadersStep_ok`), the rank
never gains an invader (`invadersStep_alive_le`), the drop counter never runs
backwards (`invadersStep_dy_mono`), a landed rank freezes the cabinet
(`invadersStep_landed`), a shot fired under an invader always kills it
(`invaders_fire_hits`), and the rank can be cleared — `invaders_winnable` names
the nine commands that shoot all five invaders down without a single drop.
-/

namespace NixWars

/-- The state of the Shard Invaders cabinet: where the gun stands, where the
rank hangs, which invaders are still alive, and the clock. -/
structure Invaders where
  /-- The gun's column, `0` to `7`. -/
  px : Nat
  /-- The rank's offset: invader `j` stands over column `ox + j`. -/
  ox : Nat
  /-- Which way the rank is sliding: `0` right, `1` left. -/
  dir : Nat
  /-- How many rows the rank has dropped. At `5` it has landed. -/
  dy : Nat
  /-- The leftmost invader. -/
  a0 : Nat
  /-- The second invader. -/
  a1 : Nat
  /-- The third invader. -/
  a2 : Nat
  /-- The fourth invader. -/
  a3 : Nat
  /-- The rightmost invader. -/
  a4 : Nat
  /-- The clock. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The four controls of the cabinet. -/
inductive InvadersCmd
  | left
  | right
  | fire
  | tick
  deriving DecidableEq, Repr, Inhabited

/-- The floor is eight columns wide. -/
def invadersWidth : Nat := 8

/-- The rank has landed once it has dropped this many rows. -/
def invadersFloor : Nat := 5

/-- How many invaders are still in the rank. -/
def invadersAlive (s : Invaders) : Nat := s.a0 + s.a1 + s.a2 + s.a3 + s.a4

/-- The rank has landed: the cabinet is over. -/
def invadersLanded (s : Invaders) : Prop := s.dy = invadersFloor

instance (s : Invaders) : Decidable (invadersLanded s) := by
  unfold invadersLanded; infer_instance

/-- A shot: every invader standing over the gun's column is destroyed. -/
def invadersFire (s : Invaders) : Invaders :=
  { s with
    a0 := if s.ox = s.px then 0 else s.a0,
    a1 := if s.ox + 1 = s.px then 0 else s.a1,
    a2 := if s.ox + 2 = s.px then 0 else s.a2,
    a3 := if s.ox + 3 = s.px then 0 else s.a3,
    a4 := if s.ox + 4 = s.px then 0 else s.a4,
    turn := s.turn + 1 }

/-- The rank slides; at a wall it reverses and drops a row. -/
def invadersTick (s : Invaders) : Invaders :=
  if s.dir = 0 then
    if s.ox < 3 then { s with ox := s.ox + 1, dir := 0, turn := s.turn + 1 }
    else { s with dir := 1, dy := s.dy + 1, turn := s.turn + 1 }
  else
    if 0 < s.ox then { s with ox := s.ox - 1, dir := 1, turn := s.turn + 1 }
    else { s with dir := 0, dy := s.dy + 1, turn := s.turn + 1 }

/-- The transition function of the cabinet. -/
def invadersStep (s : Invaders) : InvadersCmd → Invaders
  | .left => if s.dy = 5 then s else { s with px := s.px - 1, turn := s.turn + 1 }
  | .right => if s.dy = 5 then s
              else { s with px := if s.px < 7 then s.px + 1 else s.px, turn := s.turn + 1 }
  | .fire => if s.dy = 5 then s else invadersFire s
  | .tick => if s.dy = 5 then s else invadersTick s

/-- The cabinet as a payload. -/
def invadersSerialize (s : Invaders) : List Nat :=
  [s.px, s.ox, s.dir, s.dy, s.a0, s.a1, s.a2, s.a3, s.a4, s.turn]

/-- Reading the cabinet back from a payload. -/
def invadersDeserialize : List Nat → Option Invaders
  | [px, ox, dir, dy, a0, a1, a2, a3, a4, turn] =>
      some { px := px, ox := ox, dir := dir, dy := dy, a0 := a0, a1 := a1, a2 := a2,
             a3 := a3, a4 := a4, turn := turn }
  | _ => none

theorem invadersDeserialize_invadersSerialize (s : Invaders) :
    invadersDeserialize (invadersSerialize s) = some s := by
  cases s; rfl

/-- **Shard Invaders as a door game.** -/
def shardInvaders : DoorGame where
  State := Invaders
  Cmd := InvadersCmd
  step := invadersStep
  serialize := invadersSerialize
  deserialize := invadersDeserialize
  deserialize_serialize := invadersDeserialize_invadersSerialize

/-- A fresh cabinet: the gun at the left of the floor, five invaders in the
rank, sliding right. -/
def initialInvaders : Invaders :=
  { px := 0, ox := 0, dir := 0, dy := 0, a0 := 1, a1 := 1, a2 := 1, a3 := 1, a4 := 1,
    turn := 0 }

/-! ### The cabinet is always legal -/

/-- A legal cabinet: the gun on the floor, the rank on the floor and sliding one
way or the other, and the rank no lower than the floor. -/
def InvadersOk (s : Invaders) : Prop :=
  s.px ≤ 7 ∧ s.ox ≤ 3 ∧ s.dir ≤ 1 ∧ s.dy ≤ 5

instance (s : Invaders) : Decidable (InvadersOk s) := by unfold InvadersOk; infer_instance

/-- **Every control keeps the cabinet legal.** The gun stays on the eight
columns, the rank stays on the floor, and the rank never drops past the floor. -/
theorem invadersStep_ok (s : Invaders) (h : InvadersOk s) (c : InvadersCmd) :
    InvadersOk (invadersStep s c) := by
  obtain ⟨hp, ho, hd, hy⟩ := h
  cases c <;> simp only [invadersStep, InvadersOk, invadersFire, invadersTick] <;>
    split_ifs <;> simp_all <;> omega

/-- The rank is a rank of flags. -/
def InvadersBinary (s : Invaders) : Prop :=
  s.a0 ≤ 1 ∧ s.a1 ≤ 1 ∧ s.a2 ≤ 1 ∧ s.a3 ≤ 1 ∧ s.a4 ≤ 1

/-- Every control keeps the rank a rank of flags. -/
theorem invadersStep_binary (s : Invaders) (h : InvadersBinary s) (c : InvadersCmd) :
    InvadersBinary (invadersStep s c) := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := h
  cases c <;> simp only [invadersStep, InvadersBinary, invadersFire, invadersTick] <;>
    split_ifs <;> simp_all

/-- **The rank never gains an invader.** Nothing on the cabinet puts an invader
back in the sky. -/
theorem invadersStep_alive_le (s : Invaders) (c : InvadersCmd) :
    invadersAlive (invadersStep s c) ≤ invadersAlive s := by
  cases c <;> simp only [invadersStep, invadersAlive, invadersFire, invadersTick] <;>
    split_ifs <;> simp_all <;> omega

/-- **The rank never rises.** The drop counter only ever runs forwards. -/
theorem invadersStep_dy_mono (s : Invaders) (c : InvadersCmd) :
    s.dy ≤ (invadersStep s c).dy := by
  cases c <;> simp only [invadersStep, invadersFire, invadersTick] <;>
    split_ifs <;> simp_all

/-- **A landed rank freezes the cabinet.** -/
theorem invadersStep_landed (s : Invaders) (h : invadersLanded s) (c : InvadersCmd) :
    invadersStep s c = s := by
  have h5 : s.dy = 5 := h
  cases c <;> simp [invadersStep, h5]

/-- **A shot under an invader always kills it.** With the gun in the leftmost
invader's column, a shot takes it out of the sky. -/
theorem invaders_fire_hits (s : Invaders) (hy : s.dy ≠ 5) (h : s.ox = s.px) :
    (invadersStep s .fire).a0 = 0 := by
  simp [invadersStep, invadersFire, hy, h]

/-- A shot at an empty column leaves the rank alone. -/
theorem invaders_fire_misses (s : Invaders) (hy : s.dy ≠ 5)
    (h0 : s.ox ≠ s.px) (h1 : s.ox + 1 ≠ s.px) (h2 : s.ox + 2 ≠ s.px)
    (h3 : s.ox + 3 ≠ s.px) (h4 : s.ox + 4 ≠ s.px) :
    invadersAlive (invadersStep s .fire) = invadersAlive s := by
  simp [invadersStep, invadersFire, invadersAlive, hy, h0, h1, h2, h3, h4]

/-- **The gun never walks off the floor**, at either end. -/
theorem invaders_gun_left_wall (s : Invaders) (hy : s.dy ≠ 5) (h : s.px = 0) :
    (invadersStep s .left).px = 0 := by
  simp [invadersStep, hy, h]

theorem invaders_gun_right_wall (s : Invaders) (hy : s.dy ≠ 5) (h : s.px = 7) :
    (invadersStep s .right).px = 7 := by
  simp [invadersStep, hy, h]

/-- **The rank bounces off the right wall**, reversing and dropping a row. -/
theorem invaders_bounce_right (s : Invaders) (hy : s.dy ≠ 5) (hd : s.dir = 0) (ho : s.ox = 3) :
    (invadersStep s .tick).dir = 1 ∧ (invadersStep s .tick).dy = s.dy + 1 ∧
      (invadersStep s .tick).ox = 3 := by
  simp [invadersStep, invadersTick, hy, hd, ho]

/-- **The rank bounces off the left wall** the same way. -/
theorem invaders_bounce_left (s : Invaders) (hy : s.dy ≠ 5) (hd : s.dir = 1) (ho : s.ox = 0) :
    (invadersStep s .tick).dir = 0 ∧ (invadersStep s .tick).dy = s.dy + 1 ∧
      (invadersStep s .tick).ox = 0 := by
  simp [invadersStep, invadersTick, hy, hd, ho]

/-! ### The rank can be cleared -/

/-- The rank is gone. -/
def InvadersCleared (s : Invaders) : Prop := invadersAlive s = 0

/-- The nine commands that clear the rank: fire, step right, fire, and so on
along the floor. -/
def invadersClearingRun : List InvadersCmd :=
  [.fire, .right, .fire, .right, .fire, .right, .fire, .right, .fire]

/-- **The rank can be cleared.** From a fresh cabinet those nine commands shoot
all five invaders down; the rank never slides, so it never drops a row. -/
theorem invaders_winnable :
    shardInvaders.run initialInvaders invadersClearingRun =
      { px := 4, ox := 0, dir := 0, dy := 0, a0 := 0, a1 := 0, a2 := 0, a3 := 0, a4 := 0,
        turn := 9 } := by
  rfl

/-- The cleared sky, stated as such. -/
theorem invaders_run_cleared :
    InvadersCleared (shardInvaders.run initialInvaders invadersClearingRun) := by
  rw [invaders_winnable]; rfl

/-- **Five kills and not one drop.** -/
theorem invaders_run_score :
    invadersAlive (shardInvaders.run initialInvaders invadersClearingRun) = 0 ∧
      (shardInvaders.run initialInvaders invadersClearingRun).dy = 0 := by
  rw [invaders_winnable]
  exact ⟨rfl, rfl⟩

/-- **The rank lands if you leave it alone.** Left to slide, the invaders reach
the floor: thirty ticks from a fresh cabinet and the cabinet is frozen. -/
theorem invaders_rank_lands :
    (shardInvaders.run initialInvaders (List.replicate 30 .tick)).dy = 5 := by
  rfl

/-! ### The fifteenth door inherits the whole BBS -/

/-- A Shard Invaders session as a URL. -/
def invadersUrl (s : GameSession shardInvaders) : String := transmit urlTransport s

theorem invadersUrl_roundtrip (s : GameSession shardInvaders) :
    receive shardInvaders urlTransport (invadersUrl s) = some s :=
  receive_transmit urlTransport s

/-- Shard Invaders is stateless too. -/
theorem invaders_play_eq (s : GameSession shardInvaders) (cs : List shardInvaders.Cmd) :
    runOverWire (g := shardInvaders) urlTransport (invadersUrl s) cs
      = some (invadersUrl { s with state := shardInvaders.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
