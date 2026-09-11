import RequestProject.Nix.NixWars.Shards

/-!
# A fifth door: Hunt the Wumpus, on the shard ring

The oldest door of them all, played on the 71-shard DMZ of `Shards.lean`
instead of a dodecahedron. The hunter stands on a shard; the wumpus creeps one
shard forward every turn; `move` walks to a shard, `shoot` looses an arrow at
one, and `sense` reports whether the wumpus is next door.

A slain wumpus is parked on the sentinel shard `wumpusSlain = 71`, which is off
the ring — that is what "the wumpus is dead" means, and it is proved to be
permanent (`huntStep_slain`). The other headline facts: arrows are never
gained, being eaten is final, the hunter is only ever eaten on the shard the
wumpus is standing on, and the hunt is winnable.
-/

namespace NixWars

/-- The hunt. -/
structure Hunt where
  /-- The shard the hunter stands on. -/
  room : Nat
  /-- The shard the wumpus stands on, or `wumpusSlain` if it is dead. -/
  wumpus : Nat
  /-- Arrows left in the quiver. -/
  arrows : Nat
  /-- Whether the hunter is still alive. -/
  alive : Bool
  /-- Turn counter. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the door. `move` and `shoot` name a shard. -/
inductive HuntCmd
  | move (r : Nat)
  | shoot (r : Nat)
  | sense
  deriving DecidableEq, Repr, Inhabited

/-- Where a slain wumpus is parked: one past the last shard of the ring, so it
is nowhere the hunter can stand. -/
def wumpusSlain : Nat := 71

/-- The wumpus creeps one shard forward each turn — unless it is dead, in which
case it stays where it is put. -/
def wumpusCreep (w : Nat) : Nat :=
  if wumpusSlain ≤ w then w else if w = 70 then 0 else w + 1

/-- The transition function. -/
def huntStep (s : Hunt) : HuntCmd → Hunt
  | .move r =>
      if ¬ s.alive then s
      else
        let room := if r ≤ 70 then r else s.room
        let w := wumpusCreep s.wumpus
        { room := room, wumpus := w, arrows := s.arrows,
          alive := room ≠ w, turn := s.turn + 1 }
  | .shoot r =>
      if ¬ s.alive then s
      else if s.arrows = 0 then s
      else if r = s.wumpus then
        { s with wumpus := wumpusSlain, arrows := s.arrows - 1, turn := s.turn + 1 }
      else
        { s with wumpus := wumpusCreep s.wumpus, arrows := s.arrows - 1,
                 turn := s.turn + 1 }
  | .sense => s

/-- The hunt as a payload. -/
def huntSerialize (s : Hunt) : List Nat :=
  [s.room, s.wumpus, s.arrows, if s.alive then 1 else 0, s.turn]

/-- Reading a hunt back from a payload. -/
def huntDeserialize : List Nat → Option Hunt
  | [room, wumpus, arrows, a, turn] =>
      some { room := room, wumpus := wumpus, arrows := arrows, alive := a != 0, turn := turn }
  | _ => none

theorem huntDeserialize_huntSerialize (s : Hunt) :
    huntDeserialize (huntSerialize s) = some s := by
  cases s with
  | mk room wumpus arrows alive turn =>
    cases alive <;> simp [huntSerialize, huntDeserialize]

/-- **Hunt the Wumpus as a door game.** -/
def wumpusHunt : DoorGame where
  State := Hunt
  Cmd := HuntCmd
  step := huntStep
  serialize := huntSerialize
  deserialize := huntDeserialize
  deserialize_serialize := huntDeserialize_huntSerialize

/-- A fresh hunt: the hunter on the home shard, the wumpus across the ring,
three arrows. -/
def initialHunt : Hunt :=
  { room := 17, wumpus := 47, arrows := 3, alive := true, turn := 0 }

/-! ### Invariants -/

/-- A creeping wumpus stays on the ring (or stays slain). -/
theorem wumpusCreep_le (w : Nat) (h : w ≤ 70 ∨ w = wumpusSlain) :
    wumpusCreep w ≤ 70 ∨ wumpusCreep w = wumpusSlain := by
  unfold wumpusCreep wumpusSlain at *
  split_ifs with h₁ h₂ <;> omega

/-- **A slain wumpus stays slain.** -/
theorem huntStep_slain (s : Hunt) (h : s.wumpus = wumpusSlain) (c : HuntCmd) :
    (huntStep s c).wumpus = wumpusSlain := by
  cases c with
  | move r =>
      simp only [huntStep]
      split_ifs <;> simp [wumpusCreep, h]
  | shoot r =>
      simp only [huntStep]
      split_ifs <;> simp [wumpusCreep, h]
  | sense => exact h

/-- **Being eaten is final.** -/
theorem huntStep_dead (s : Hunt) (h : s.alive = false) (c : HuntCmd) :
    huntStep s c = s := by
  cases c <;> simp [huntStep, h]

/-- Arrows are never gained. -/
theorem huntStep_arrows_le (s : Hunt) (c : HuntCmd) : (huntStep s c).arrows ≤ s.arrows := by
  cases c with
  | move r => simp only [huntStep]; split_ifs <;> simp
  | shoot r => simp only [huntStep]; split_ifs <;> simp
  | sense => simp [huntStep]

/-- Turns only move forward. -/
theorem huntStep_turn_ge (s : Hunt) (c : HuntCmd) : s.turn ≤ (huntStep s c).turn := by
  cases c with
  | move r => simp only [huntStep]; split_ifs <;> simp
  | shoot r => simp only [huntStep]; split_ifs <;> simp
  | sense => simp [huntStep]

/-- **The hunter is only ever eaten where the wumpus is standing.** If a move
kills the hunter, it is because it walked onto the wumpus's shard. -/
theorem hunt_eaten_iff (s : Hunt) (r : Nat) (halive : s.alive = true) :
    (huntStep s (.move r)).alive = false ↔
      (huntStep s (.move r)).room = (huntStep s (.move r)).wumpus := by
  simp [huntStep, halive]

/-- Shooting the wumpus's shard slays it and spends one arrow. -/
theorem hunt_shoot_hits (s : Hunt) (halive : s.alive = true) (ha : s.arrows ≠ 0) :
    (huntStep s (.shoot s.wumpus)).wumpus = wumpusSlain ∧
      (huntStep s (.shoot s.wumpus)).arrows + 1 = s.arrows := by
  have h : huntStep s (.shoot s.wumpus)
      = { s with wumpus := wumpusSlain, arrows := s.arrows - 1, turn := s.turn + 1 } := by
    simp [huntStep, halive, ha]
  rw [h]
  refine ⟨rfl, ?_⟩
  show s.arrows - 1 + 1 = s.arrows
  omega

/-- A shot from an empty quiver changes nothing. -/
theorem hunt_shoot_empty (s : Hunt) (h : s.arrows = 0) (r : Nat) :
    huntStep s (.shoot r) = s := by
  simp only [huntStep, h]
  split_ifs <;> rfl

/-- Arrows are never gained over a whole session. -/
theorem hunt_run_arrows_le (s : Hunt) (cs : List HuntCmd) :
    (wumpusHunt.run s cs).arrows ≤ s.arrows := by
  induction cs generalizing s with
  | nil => exact le_rfl
  | cons c cs ih => exact le_trans (ih (huntStep s c)) (huntStep_arrows_le s c)

/-- A slain wumpus stays slain over a whole session. -/
theorem hunt_run_slain (s : Hunt) (h : s.wumpus = wumpusSlain) (cs : List HuntCmd) :
    (wumpusHunt.run s cs).wumpus = wumpusSlain := by
  induction cs generalizing s with
  | nil => exact h
  | cons c cs ih => exact ih (huntStep s c) (huntStep_slain s h c)

/-- **The hunt is winnable.** From a fresh hunt, wait one turn and put an arrow
into shard 48: the wumpus is slain, the hunter is alive, and two arrows are
left. -/
theorem hunt_winnable :
    wumpusHunt.run initialHunt [.move 17, .shoot 48] =
      { room := 17, wumpus := wumpusSlain, arrows := 2, alive := true, turn := 2 } := by
  rfl

/-! ### The fifth door inherits the whole BBS -/

/-- A Hunt the Wumpus session as a URL. -/
def huntUrl (s : GameSession wumpusHunt) : String := transmit urlTransport s

theorem huntUrl_roundtrip (s : GameSession wumpusHunt) :
    receive wumpusHunt urlTransport (huntUrl s) = some s :=
  receive_transmit urlTransport s

/-- Hunt the Wumpus is stateless too. -/
theorem hunt_play_eq (s : GameSession wumpusHunt) (cs : List wumpusHunt.Cmd) :
    runOverWire (g := wumpusHunt) urlTransport (huntUrl s) cs
      = some (huntUrl { s with state := wumpusHunt.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
