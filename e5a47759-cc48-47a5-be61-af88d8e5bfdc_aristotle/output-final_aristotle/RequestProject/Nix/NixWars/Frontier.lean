import RequestProject.Nix.NixWars.Shards

/-!
# A fourteenth door: the Frontier Run, a 3D flight

The add-on cabinet: a Frontier-style flight sim, cut down to arithmetic a
proof can hold. The ship flies inside a 16 × 16 × 16 cube of space that wraps
at every face (a 3-torus), pointing along one of the six axis directions:

```
0 : +x   1 : -x   2 : +y   3 : -y   4 : +z   5 : -z
```

Five commands: `turnTo h` points the ship along axis direction `h`, `thrust`
raises the throttle by one notch (three notches maximum), `brake` lowers it,
`fly` moves the ship `speed` cells along its heading and burns `speed` fuel,
and `dock` docks with the station at `frontierStation` — which refuels the
ship, cuts the engines, and, given a second time, releases it again.

The headline facts: the ship never leaves the cube, the heading and the
throttle never leave their ranges, fuel is only ever gained at the station,
docking only happens at the station's cell, flying with an empty tank does
nothing, and the run is flyable — `frontier_winnable` names the twelve
commands that fly a fresh ship from the origin to a docking.
-/

namespace NixWars

/-- The side of the cube of space the frontier run is flown in. -/
def frontierSpan : Nat := 16

/-- The top throttle notch. -/
def frontierMaxSpeed : Nat := 3

/-- A full tank. -/
def frontierTank : Nat := 71

/-- The station: the only cell a ship can dock at. -/
def frontierStation : Nat × Nat × Nat := (6, 4, 2)

/-- The ship. -/
structure Frontier where
  /-- Cell along the first axis. -/
  x : Nat
  /-- Cell along the second axis. -/
  y : Nat
  /-- Cell along the third axis. -/
  z : Nat
  /-- Which of the six axis directions the nose points along. -/
  hdg : Nat
  /-- Throttle notch. -/
  speed : Nat
  /-- Fuel in the tank. -/
  fuel : Nat
  /-- Whether the ship is docked. -/
  docked : Nat
  /-- Command counter. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the flight. -/
inductive FrontierCmd
  | turnTo (h : Nat)
  | thrust
  | brake
  | fly
  | dock
  deriving DecidableEq, Repr, Inhabited

/-- One coordinate, moved `d` cells forward round the torus. -/
def frontierUp (c d : Nat) : Nat := if c + d ≤ 15 then c + d else c + d - 16

/-- One coordinate, moved `d` cells back round the torus. -/
def frontierDown (c d : Nat) : Nat := if d ≤ c then c - d else c + 16 - d

/-- The cell the ship moves to along axis direction `h`: `axis` is the index of
the coordinate (0, 1 or 2) and `c` its current value. -/
def frontierAxis (axis c h d : Nat) : Nat :=
  if h = 2 * axis then frontierUp c d
  else if h = 2 * axis + 1 then frontierDown c d
  else c

/-- The transition function of the flight. -/
def frontierStep (s : Frontier) : FrontierCmd → Frontier
  | .turnTo h =>
      { s with hdg := if h ≤ 5 then h else s.hdg, turn := s.turn + 1 }
  | .thrust =>
      { s with
        speed := if s.docked = 0 ∧ s.speed < 3 then s.speed + 1 else s.speed,
        turn := s.turn + 1 }
  | .brake => { s with speed := s.speed - 1, turn := s.turn + 1 }
  | .fly =>
      if s.docked = 0 ∧ s.speed ≤ s.fuel then
        { s with
          x := frontierAxis 0 s.x s.hdg s.speed,
          y := frontierAxis 1 s.y s.hdg s.speed,
          z := frontierAxis 2 s.z s.hdg s.speed,
          fuel := s.fuel - s.speed,
          turn := s.turn + 1 }
      else { s with turn := s.turn + 1 }
  | .dock =>
      if s.docked = 1 then { s with docked := 0, turn := s.turn + 1 }
      else if s.x = 6 ∧ s.y = 4 ∧ s.z = 2 then
        { s with docked := 1, speed := 0, fuel := frontierTank, turn := s.turn + 1 }
      else { s with turn := s.turn + 1 }

/-- The ship as a payload. -/
def frontierSerialize (s : Frontier) : List Nat :=
  [s.x, s.y, s.z, s.hdg, s.speed, s.fuel, s.docked, s.turn]

/-- Reading the ship back from a payload. -/
def frontierDeserialize : List Nat → Option Frontier
  | [x, y, z, hdg, speed, fuel, docked, turn] =>
      some { x := x, y := y, z := z, hdg := hdg, speed := speed, fuel := fuel,
             docked := docked, turn := turn }
  | _ => none

theorem frontierDeserialize_frontierSerialize (s : Frontier) :
    frontierDeserialize (frontierSerialize s) = some s := by
  cases s; rfl

/-- **The Frontier Run as a door game.** -/
def frontierRun : DoorGame where
  State := Frontier
  Cmd := FrontierCmd
  step := frontierStep
  serialize := frontierSerialize
  deserialize := frontierDeserialize
  deserialize_serialize := frontierDeserialize_frontierSerialize

/-- A fresh ship: at the origin of the cube, nose along `+x`, engines off, a
full tank. -/
def initialFrontier : Frontier :=
  { x := 0, y := 0, z := 0, hdg := 0, speed := 0, fuel := frontierTank, docked := 0,
    turn := 0 }

/-! ### The ship stays inside the cube -/

/-- The ship is a legal ship: inside the cube, pointing along one of the six
axis directions, throttle in range, docked flag a flag. -/
def FrontierOk (s : Frontier) : Prop :=
  s.x ≤ 15 ∧ s.y ≤ 15 ∧ s.z ≤ 15 ∧ s.hdg ≤ 5 ∧ s.speed ≤ 3 ∧ s.docked ≤ 1

/-- A torus step forward stays inside the cube. -/
theorem frontierUp_le (c d : Nat) (hc : c ≤ 15) (hd : d ≤ 3) : frontierUp c d ≤ 15 := by
  unfold frontierUp; split_ifs <;> omega

/-- A torus step back stays inside the cube. -/
theorem frontierDown_le (c d : Nat) (hc : c ≤ 15) (hd : d ≤ 3) : frontierDown c d ≤ 15 := by
  unfold frontierDown; split_ifs <;> omega

theorem frontierAxis_le (axis c h d : Nat) (hc : c ≤ 15) (hd : d ≤ 3) :
    frontierAxis axis c h d ≤ 15 := by
  unfold frontierAxis
  split_ifs
  · exact frontierUp_le c d hc hd
  · exact frontierDown_le c d hc hd
  · exact hc

/-- **The ship never leaves the cube.** Every command keeps the position inside
the 16-cube, the heading among the six directions and the throttle at three
notches or fewer. -/
theorem frontierStep_ok (s : Frontier) (h : FrontierOk s) (c : FrontierCmd) :
    FrontierOk (frontierStep s c) := by
  obtain ⟨hx, hy, hz, hh, hs, hd⟩ := h
  cases c with
  | turnTo k =>
      refine ⟨hx, hy, hz, ?_, hs, hd⟩
      simp only [frontierStep]
      split_ifs <;> omega
  | thrust =>
      refine ⟨hx, hy, hz, hh, ?_, hd⟩
      simp only [frontierStep]
      split_ifs <;> omega
  | brake => exact ⟨hx, hy, hz, hh, by simp only [frontierStep]; omega, hd⟩
  | fly =>
      simp only [frontierStep, FrontierOk]
      split_ifs
      · exact ⟨frontierAxis_le 0 s.x s.hdg s.speed hx hs,
               frontierAxis_le 1 s.y s.hdg s.speed hy hs,
               frontierAxis_le 2 s.z s.hdg s.speed hz hs, hh, hs, hd⟩
      · exact ⟨hx, hy, hz, hh, hs, hd⟩
  | dock =>
      simp only [frontierStep, FrontierOk]
      split_ifs <;> refine ⟨hx, hy, hz, hh, ?_, ?_⟩ <;> simp <;> omega

/-! ### The economy of the tank -/

/-- **Fuel is only ever gained at the station.** Every command but `dock`
leaves the tank no fuller than it found it. -/
theorem frontierStep_fuel_le (s : Frontier) (c : FrontierCmd) (h : c ≠ .dock) :
    (frontierStep s c).fuel ≤ s.fuel := by
  cases c with
  | turnTo k => simp [frontierStep]
  | thrust => simp [frontierStep]
  | brake => simp [frontierStep]
  | fly => simp only [frontierStep]; split_ifs <;> simp
  | dock => exact absurd rfl h

/-- **Docking only happens at the station.** A ship that was flying and is now
docked is standing on the station's cell. -/
theorem frontier_dock_only_at_station (s : Frontier) (hfree : s.docked = 0)
    (c : FrontierCmd) (hdock : (frontierStep s c).docked = 1) :
    s.x = 6 ∧ s.y = 4 ∧ s.z = 2 := by
  cases c with
  | turnTo k => simp [frontierStep, hfree] at hdock
  | thrust => simp [frontierStep, hfree] at hdock
  | brake => simp [frontierStep, hfree] at hdock
  | fly => simp only [frontierStep] at hdock; split_ifs at hdock <;> simp_all
  | dock =>
      by_cases h₁ : s.docked = 1
      · omega
      · by_cases h₂ : s.x = 6 ∧ s.y = 4 ∧ s.z = 2
        · exact h₂
        · exfalso
          simp [frontierStep, h₂, hfree] at hdock

/-- **Docking at the station fills the tank and cuts the engines.** -/
theorem frontier_dock_refuels (s : Frontier) (hfree : s.docked = 0)
    (hx : s.x = 6) (hy : s.y = 4) (hz : s.z = 2) :
    frontierStep s .dock =
      { s with docked := 1, speed := 0, fuel := frontierTank, turn := s.turn + 1 } := by
  simp [frontierStep, hfree, hx, hy, hz]

/-- **A dry tank grounds the ship.** With less fuel than throttle, `fly` moves
nothing but the clock. -/
theorem frontier_fly_dry (s : Frontier) (h : s.fuel < s.speed) :
    frontierStep s .fly = { s with turn := s.turn + 1 } := by
  simp only [frontierStep]
  split_ifs with hc
  · omega
  · rfl

/-- **A docked ship does not drift.** -/
theorem frontier_fly_docked (s : Frontier) (h : s.docked = 1) :
    frontierStep s .fly = { s with turn := s.turn + 1 } := by
  simp only [frontierStep]
  split_ifs with hc
  · omega
  · rfl

/-- **Flying burns exactly the throttle setting.** -/
theorem frontier_fly_burn (s : Frontier) (hfree : s.docked = 0) (hf : s.speed ≤ s.fuel) :
    (frontierStep s .fly).fuel + s.speed = s.fuel := by
  simp only [frontierStep]
  split_ifs with hc
  · simp; omega
  · omega

/-- The clock only moves forward. -/
theorem frontierStep_turn (s : Frontier) (c : FrontierCmd) :
    (frontierStep s c).turn = s.turn + 1 := by
  cases c with
  | turnTo k => rfl
  | thrust => rfl
  | brake => rfl
  | fly => simp only [frontierStep]; split_ifs <;> rfl
  | dock => simp only [frontierStep]; split_ifs <;> rfl

/-- The flight plan that reaches the station: point along `+x`, wind the
throttle up to two notches, fly three hops, turn onto `+y`, fly two hops, turn
onto `+z`, fly one hop, and dock. -/
def frontierFlightPlan : List FrontierCmd :=
  [.turnTo 0, .thrust, .thrust, .fly, .fly, .fly, .turnTo 2, .fly, .fly, .turnTo 4, .fly, .dock]

/-- **The run is flyable.** Those twelve commands take a fresh ship from the
origin to the station, dock it, and leave it with a full tank. -/
theorem frontier_winnable :
    frontierRun.run initialFrontier frontierFlightPlan =
      { x := 6, y := 4, z := 2, hdg := 4, speed := 0, fuel := 71, docked := 1, turn := 12 } := by
  rfl

/-- The ship that flew the plan is docked at the station. -/
theorem frontier_plan_docks :
    (frontierRun.run initialFrontier frontierFlightPlan).docked = 1 ∧
      ((frontierRun.run initialFrontier frontierFlightPlan).x,
       (frontierRun.run initialFrontier frontierFlightPlan).y,
       (frontierRun.run initialFrontier frontierFlightPlan).z) = frontierStation := by
  rw [frontier_winnable]
  exact ⟨rfl, rfl⟩

/-- **The cube wraps.** Sixteen cells along an axis at one notch of throttle
bring the ship back where it started. -/
theorem frontier_torus_wraps :
    (frontierRun.run { initialFrontier with speed := 1 } (List.replicate 16 .fly)).x = 0 := by
  rfl

/-! ### The fourteenth door inherits the whole BBS -/

/-- A Frontier Run session as a URL. -/
def frontierUrl (s : GameSession frontierRun) : String := transmit urlTransport s

theorem frontierUrl_roundtrip (s : GameSession frontierRun) :
    receive frontierRun urlTransport (frontierUrl s) = some s :=
  receive_transmit urlTransport s

/-- The Frontier Run is stateless too. -/
theorem frontier_play_eq (s : GameSession frontierRun) (cs : List frontierRun.Cmd) :
    runOverWire (g := frontierRun) urlTransport (frontierUrl s) cs
      = some (frontierUrl { s with state := frontierRun.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
