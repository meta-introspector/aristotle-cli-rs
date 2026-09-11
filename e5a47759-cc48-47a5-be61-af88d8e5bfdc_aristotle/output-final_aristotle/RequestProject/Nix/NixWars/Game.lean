import RequestProject.Nix.NixWars.Transports

/-!
# Door games

The BBS runs many games. What they have in common is packaged as `DoorGame`:
a state, a command language, a deterministic step function, and a
serialization of the state as a list of natural numbers -- the payload that the
transports of `RequestProject.NixWars.Transports` carry.

`nixWars` is the flagship game: TradeWars 71 / NixWars, the journey from Sol to
Sgr A*, with fuel, warps and j-invariant navigation. Its states are recorded in
natural numbers, so "fuel never goes negative" is partly a typing statement;
the substance is that a warp is only ever taken when it is affordable, so the
subtraction that pays for it never truncates (`warp_fuel_exact`).
-/

namespace NixWars

/-! ## The generic door game -/

/-- A BBS door game: deterministic, and serializable to a payload. -/
structure DoorGame where
  /-- Game states. -/
  State : Type
  /-- Player commands. -/
  Cmd : Type
  /-- The (deterministic) transition function. -/
  step : State → Cmd → State
  /-- The state as a list of natural numbers. -/
  serialize : State → List Nat
  /-- Reading a state back from a payload. -/
  deserialize : List Nat → Option State
  /-- Serialization is lossless. -/
  deserialize_serialize : ∀ s, deserialize (serialize s) = some s

namespace DoorGame

variable (g : DoorGame)

/-- Play a whole session of commands. -/
def run (s : g.State) : List g.Cmd → g.State
  | [] => s
  | c :: cs => run (g.step s c) cs

@[simp] theorem run_nil (s : g.State) : g.run s [] = s := rfl

@[simp] theorem run_cons (s : g.State) (c : g.Cmd) (cs : List g.Cmd) :
    g.run s (c :: cs) = g.run (g.step s c) cs := rfl

/-- The state codec of a game. -/
def stateCodec : Codec g.State (List Nat) where
  encode := g.serialize
  decode := g.deserialize
  decode_encode := g.deserialize_serialize

/-- **Determinism.** The same commands from the same state always give the same
state: there is nothing hidden in the machine. -/
theorem run_deterministic {s₁ s₂ : g.State} {cs₁ cs₂ : List g.Cmd}
    (hs : s₁ = s₂) (hc : cs₁ = cs₂) : g.run s₁ cs₁ = g.run s₂ cs₂ := by
  rw [hs, hc]

end DoorGame

/-! ## NixWars (TradeWars 71) -/

/-- The player's ship. `dist` is the remaining distance to Sgr A* in
light-years. -/
structure Ship where
  /-- Light-years still to travel to the galactic centre. -/
  dist : Nat
  /-- Remaining fuel. -/
  fuel : Nat
  /-- Credits. -/
  credits : Nat
  /-- Turn counter. -/
  turn : Nat
  /-- Whether j-invariant navigation has been unlocked. -/
  unlocked : Bool
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the door game. -/
inductive ShipCmd
  | warp (d : Nat)
  | scan
  | status
  | jnav
  | unlock
  | quit
  deriving DecidableEq, Repr, Inhabited

/-- Sgr A* is 26673 light-years from Sol. -/
def sgrADistance : Nat := 26673

/-- A fresh ship at Sol. -/
def initialShip : Ship :=
  { dist := sgrADistance, fuel := 100, credits := 10000, turn := 0, unlocked := false }

/-- Fuel needed to cross `d` light-years: one unit per hundred. -/
def warpCost (d : Nat) : Nat := d / 100

/-- Warping: refused (state unchanged) when the tanks are too low. -/
def warpShip (s : Ship) (d : Nat) : Ship :=
  if warpCost d ≤ s.fuel then
    { s with dist := s.dist - d, fuel := s.fuel - warpCost d, turn := s.turn + 1 }
  else s

/-- The transition function of NixWars. `jnav` closes ten percent of the
remaining gap, and only works once the Monster Crown has unlocked it. -/
def shipStep (s : Ship) : ShipCmd → Ship
  | .warp d => warpShip s d
  | .scan => s
  | .status => s
  | .jnav => if s.unlocked then warpShip s (s.dist / 10) else s
  | .unlock => { s with unlocked := true }
  | .quit => s

/-- The ship as a payload. -/
def shipSerialize (s : Ship) : List Nat :=
  [s.dist, s.fuel, s.credits, s.turn, if s.unlocked then 1 else 0]

/-- Reading a ship back from a payload. -/
def shipDeserialize : List Nat → Option Ship
  | [dist, fuel, credits, turn, u] =>
    some { dist := dist, fuel := fuel, credits := credits, turn := turn, unlocked := u != 0 }
  | _ => none

theorem shipDeserialize_shipSerialize (s : Ship) :
    shipDeserialize (shipSerialize s) = some s := by
  cases s with
  | mk dist fuel credits turn unlocked =>
    cases unlocked <;> simp [shipSerialize, shipDeserialize]

/-- **NixWars as a door game.** -/
def nixWars : DoorGame where
  State := Ship
  Cmd := ShipCmd
  step := shipStep
  serialize := shipSerialize
  deserialize := shipDeserialize
  deserialize_serialize := shipDeserialize_shipSerialize

/-! ### Fuel, distance and turns -/

/-- A warp that is taken is paid for exactly: the subtraction never truncates,
so the displayed fuel is the real fuel. -/
theorem warp_fuel_exact (s : Ship) (d : Nat) (h : warpCost d ≤ s.fuel) :
    (warpShip s d).fuel + warpCost d = s.fuel := by
  simp [warpShip, h]

/-- A warp that is refused changes nothing. -/
theorem warp_refused (s : Ship) (d : Nat) (h : ¬ warpCost d ≤ s.fuel) :
    warpShip s d = s := by simp [warpShip, h]

theorem warpShip_fuel_le (s : Ship) (d : Nat) : (warpShip s d).fuel ≤ s.fuel := by
  by_cases h : warpCost d ≤ s.fuel <;> simp [warpShip, h]

theorem warpShip_dist_le (s : Ship) (d : Nat) : (warpShip s d).dist ≤ s.dist := by
  by_cases h : warpCost d ≤ s.fuel <;> simp [warpShip, h]

theorem warpShip_turn_le (s : Ship) (d : Nat) : s.turn ≤ (warpShip s d).turn := by
  by_cases h : warpCost d ≤ s.fuel <;> simp [warpShip, h]

/-- **Fuel never increases.** -/
theorem step_fuel_le (s : Ship) (c : ShipCmd) : (shipStep s c).fuel ≤ s.fuel := by
  cases c with
  | warp d => exact warpShip_fuel_le s d
  | jnav => by_cases h : s.unlocked <;> simp [shipStep, h, warpShip_fuel_le]
  | _ => simp [shipStep]

/-- **The galactic centre only ever gets closer.** -/
theorem step_dist_le (s : Ship) (c : ShipCmd) : (shipStep s c).dist ≤ s.dist := by
  cases c with
  | warp d => exact warpShip_dist_le s d
  | jnav => by_cases h : s.unlocked <;> simp [shipStep, h, warpShip_dist_le]
  | _ => simp [shipStep]

/-- **Turns only move forward.** -/
theorem step_turn_le (s : Ship) (c : ShipCmd) : s.turn ≤ (shipStep s c).turn := by
  cases c with
  | warp d => exact warpShip_turn_le s d
  | jnav => by_cases h : s.unlocked <;> simp [shipStep, h, warpShip_turn_le]
  | _ => simp [shipStep]

/-- Fuel never increases along a whole session. -/
theorem run_fuel_le (s : Ship) (cs : List ShipCmd) : (nixWars.run s cs).fuel ≤ s.fuel := by
  induction cs generalizing s with
  | nil => exact le_rfl
  | cons c cs ih => exact le_trans (ih (shipStep s c)) (step_fuel_le s c)

/-- The distance to Sgr A* never increases along a whole session. -/
theorem run_dist_le (s : Ship) (cs : List ShipCmd) : (nixWars.run s cs).dist ≤ s.dist := by
  induction cs generalizing s with
  | nil => exact le_rfl
  | cons c cs ih => exact le_trans (ih (shipStep s c)) (step_dist_le s c)

/-- **Fuel is never negative and never overspent:** the fuel left plus the fuel
burned by an accepted warp is exactly the fuel there was. -/
theorem fuel_conservation (s : Ship) (d : Nat) (h : warpCost d ≤ s.fuel) :
    (shipStep s (.warp d)).fuel + warpCost d = s.fuel :=
  warp_fuel_exact s d h

/-! ### Winning the game -/

/-- Short hops of 99 light-years are free (`99 / 100 = 0`), so they can always
be taken. -/
theorem warp99_dist (s : Ship) : (warpShip s 99).dist = s.dist - 99 := by
  simp [warpShip, warpCost]

theorem warp99_fuel (s : Ship) : (warpShip s 99).fuel = s.fuel := by
  simp [warpShip, warpCost]

theorem run_warp99 (s : Ship) (n : Nat) :
    (nixWars.run s (List.replicate n (ShipCmd.warp 99))).dist = s.dist - 99 * n ∧
    (nixWars.run s (List.replicate n (ShipCmd.warp 99))).fuel = s.fuel := by
  induction n generalizing s with
  | zero => simp
  | succ n ih =>
    have hstep : nixWars.step s (ShipCmd.warp 99) = warpShip s 99 := rfl
    rw [List.replicate_succ, DoorGame.run_cons, hstep]
    obtain ⟨hd, hf⟩ := ih (warpShip s 99)
    refine ⟨?_, ?_⟩
    · rw [hd, warp99_dist]
      omega
    · rw [hf, warp99_fuel]

/-- **The game can be won.** Two hundred and seventy short hops bring the ship
from Sol to Sgr A*, without ever running the tanks dry. -/
theorem nixWars_winnable :
    (nixWars.run initialShip (List.replicate 270 (ShipCmd.warp 99))).dist = 0 ∧
    (nixWars.run initialShip (List.replicate 270 (ShipCmd.warp 99))).fuel = 100 := by
  obtain ⟨hd, hf⟩ := run_warp99 initialShip 270
  refine ⟨?_, ?_⟩
  · rw [hd]
    simp [initialShip, sgrADistance]
  · rw [hf]
    rfl

end NixWars
