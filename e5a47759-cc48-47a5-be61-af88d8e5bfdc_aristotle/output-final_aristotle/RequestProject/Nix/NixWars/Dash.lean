import RequestProject.Nix.NixWars.Session

/-!
# A second door: Monster Dash

The board runs many games, and everything in this development is generic in the
game. Monster Dash is a three-lane runner: the obstacle for turn `t` sits in
lane `t % 3`, `tick` advances the world, `left` and `right` move the runner.

Nothing about the transports has to be redone for it: because it is a
`DoorGame`, it inherits the session, the five wires and the statelessness
theorem.
-/

namespace NixWars

/-- The runner. -/
structure Dash where
  /-- Lane, `0`, `1` or `2`. -/
  lane : Nat
  /-- Score. -/
  score : Nat
  /-- Lives left. -/
  lives : Nat
  /-- Turn counter. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of Monster Dash. -/
inductive DashCmd
  | left
  | right
  | tick
  deriving DecidableEq, Repr, Inhabited

/-- Where the obstacle is on turn `t`. -/
def obstacleLane (t : Nat) : Nat := t % 3

/-- The transition function. A run that has lost all its lives is frozen. -/
def dashStep (s : Dash) : DashCmd → Dash
  | .left => { s with lane := s.lane - 1 }
  | .right => { s with lane := min 2 (s.lane + 1) }
  | .tick =>
    if s.lives = 0 then s
    else if s.lane = obstacleLane s.turn then
      { s with lives := s.lives - 1, turn := s.turn + 1 }
    else { s with score := s.score + 1, turn := s.turn + 1 }

/-- The runner as a payload. -/
def dashSerialize (s : Dash) : List Nat := [s.lane, s.score, s.lives, s.turn]

/-- Reading a runner back from a payload. -/
def dashDeserialize : List Nat → Option Dash
  | [lane, score, lives, turn] =>
    some { lane := lane, score := score, lives := lives, turn := turn }
  | _ => none

theorem dashDeserialize_dashSerialize (s : Dash) :
    dashDeserialize (dashSerialize s) = some s := by
  cases s
  simp [dashSerialize, dashDeserialize]

/-- **Monster Dash as a door game.** -/
def monsterDash : DoorGame where
  State := Dash
  Cmd := DashCmd
  step := dashStep
  serialize := dashSerialize
  deserialize := dashDeserialize
  deserialize_serialize := dashDeserialize_dashSerialize

/-- A fresh runner. -/
def initialDash : Dash := { lane := 1, score := 0, lives := 3, turn := 0 }

/-! ### Invariants -/

/-- Lives are never gained. -/
theorem dashStep_lives_le (s : Dash) (c : DashCmd) : (dashStep s c).lives ≤ s.lives := by
  cases c
  · simp [dashStep]
  · simp [dashStep]
  · simp only [dashStep]
    split_ifs <;> simp

/-- The score never goes down. -/
theorem dashStep_score_ge (s : Dash) (c : DashCmd) : s.score ≤ (dashStep s c).score := by
  cases c
  · simp [dashStep]
  · simp [dashStep]
  · simp only [dashStep]
    split_ifs <;> simp

/-- The runner stays on the track. -/
theorem dashStep_lane_le (s : Dash) (c : DashCmd) (h : s.lane ≤ 2) : (dashStep s c).lane ≤ 2 := by
  cases c
  · simp [dashStep]
    omega
  · simp [dashStep]
  · simp only [dashStep]
    split_ifs <;> simpa using h

/-- A game over is final: ticking a dead runner changes nothing. -/
theorem dashStep_dead (s : Dash) (h : s.lives = 0) : dashStep s .tick = s := by
  simp [dashStep, h]

/-- Dodging works: ticking out of the obstacle's lane costs nothing and scores. -/
theorem dashStep_dodge (s : Dash) (hl : s.lives ≠ 0) (h : s.lane ≠ obstacleLane s.turn) :
    (dashStep s .tick).lives = s.lives ∧ (dashStep s .tick).score = s.score + 1 := by
  simp [dashStep, hl, h]

/-- Lives are never gained over a whole session. -/
theorem dash_run_lives_le (s : Dash) (cs : List DashCmd) :
    (monsterDash.run s cs).lives ≤ s.lives := by
  induction cs generalizing s with
  | nil => exact le_rfl
  | cons c cs ih => exact le_trans (ih (dashStep s c)) (dashStep_lives_le s c)

/-- The score never goes down over a whole session. -/
theorem dash_run_score_ge (s : Dash) (cs : List DashCmd) :
    s.score ≤ (monsterDash.run s cs).score := by
  induction cs generalizing s with
  | nil => exact le_rfl
  | cons c cs ih => exact le_trans (dashStep_score_ge s c) (ih (dashStep s c))

/-! ### The second game inherits the whole BBS

No transport code is written twice: these follow from the generic theorems in
`RequestProject.NixWars.Session`. -/

/-- A Monster Dash session as a URL. -/
def dashUrl (s : GameSession monsterDash) : String := transmit urlTransport s

theorem dashUrl_roundtrip (s : GameSession monsterDash) :
    receive monsterDash urlTransport (dashUrl s) = some s :=
  receive_transmit urlTransport s

/-- A Monster Dash session keyed out in morse. -/
def dashMorse (s : GameSession monsterDash) : List MorseSym := transmit morseTransport s

theorem dashMorse_roundtrip (s : GameSession monsterDash) :
    receive monsterDash morseTransport (dashMorse s) = some s :=
  receive_transmit morseTransport s

/-- Monster Dash is stateless too. -/
theorem dash_play_eq (s : GameSession monsterDash) (cs : List monsterDash.Cmd) :
    runOverWire (g := monsterDash) urlTransport (dashUrl s) cs
      = some (dashUrl { s with state := monsterDash.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
