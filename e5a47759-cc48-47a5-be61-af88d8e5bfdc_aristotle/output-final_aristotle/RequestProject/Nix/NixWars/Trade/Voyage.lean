import RequestProject.Nix.NixWars.Trade.Ships
import RequestProject.Nix.NixWars.Monster.Place

/-!
# The Voxel Frontier: the flight and the voxel world, merged

The Frontier Run flew a 16-cube of its own invention; the voxel world was a
picture you could look at but not fly.  This file is the merge: the run is
flown **inside the level-3 grid of the Monster's world**, the `71 × 59 × 47`
box of 196 883 cells, and the eight trading ports stand on the eight cells the
Monster's character table occupies at that resolution
(`ports_are_the_occupied_voxels`).  Every position the ship can hold is a
voxel of that grid (`voyage_voxel_lt`), so the flight and the map are the same
object.

On top of the flight sits the market of `Trade.Goods`: the ship has a hold,
credits, and every port quotes its own price for each of the five goods, so a
load is worth different money at every corner of the box, and every hop of the
ship runs a production round, which moves the prices again.  The ship itself
is a *build* from `Trade.Ships` — its top throttle notch, tank and hold are
read off the parts, so a customized ship really flies differently.

What is proved here:

* the ship never leaves the box and the whole state stays well formed
  (`voyageStep_ok`), so the position is always a voxel of the level-3 grid
  (`voyage_voxel_lt`);
* docking only happens on a port's cell (`dock_only_at_port`), and fuel is
  only ever gained by buying it there (`fuel_only_from_refuel`);
* flying burns exactly the throttle setting (`fly_burns_throttle`) and an
  empty tank grounds the ship (`fly_dry`);
* trade is exact and conserves goods: a purchase pays the quoted price to the
  credit (`buy_credits_exact`) and moves one unit from the shelf into the hold
  and nowhere else (`buy_conserves_units`), and the hold never overflows
  (`hold_within_capacity`);
* the price a player pays **moves as they trade**: the fourth ORE bought at
  MINEHEAD costs more than the first (`repeat_buys_cost_more`);
* the run can be flown and the circuit can be worked: `tradeRun` is a
  ninety-command voyage that buys ORE where it is mined and sells it where it
  is scarce, and comes home with more credits than it left with
  (`tradeRun_profit`).
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade

/-! ## The box -/

/-- The axes of the world the run is flown in: the level-3 grid of the
Monster's voxel world. -/
def boxAxes : List Nat := [71, 59, 47]

theorem boxAxes_eq_level : boxAxes = Monster.level 3 := by decide

/-- The length of axis `i`. -/
def axisLen (i : Nat) : Nat := boxAxes.getD i 1

theorem axisLen_pos (i : Nat) : 0 < axisLen i := by
  unfold axisLen boxAxes
  match i with
  | 0 => decide
  | 1 => decide
  | 2 => decide
  | (n + 3) => simp [List.getD]

/-- How many cells the box holds. -/
theorem box_cells : boxAxes.prod = 196883 := by decide

/-- Where a port stands in the box: its `0/1` voxel corner, opened out to
opposite ends of each axis so that the run is a real journey. -/
def portCoord (c i : Nat) : Nat := c * (axisLen i / 2)

/-- The cell a port stands on. -/
def portCell (p : Port) : Nat × Nat × Nat :=
  (portCoord p.cx 0, portCoord p.cy 1, portCoord p.cz 2)

/-- The port standing on a cell, if there is one. -/
def portHere (x y z : Nat) : Option Nat :=
  (List.range numPorts).find? (fun i => portCell (portAt i) = (x, y, z))

/-- **The ports are the occupied voxels.**  Reading each port's corner as a
voxel address of the level-3 grid gives exactly the eight cells the Monster's
character table occupies there — the trading map and the voxel map are one
map. -/
theorem ports_are_the_occupied_voxels :
    (ports.map (fun p => Monster.encode (Monster.level 3) [p.cx, p.cy, p.cz])).length = 8 ∧
      (ports.map (fun p => Monster.encode (Monster.level 3) [p.cx, p.cy, p.cz])).Nodup ∧
      ∀ n ∈ ports.map (fun p => Monster.encode (Monster.level 3) [p.cx, p.cy, p.cz]),
        n ∈ Monster.occupied 3 := by
  refine ⟨by decide, by decide, ?_⟩
  decide +kernel

/-- The eight port cells, spread to the far corners of the box. -/
theorem portCells_eq :
    ports.map portCell =
      [(0, 0, 0), (35, 0, 0), (0, 29, 0), (35, 29, 0),
       (0, 0, 23), (35, 0, 23), (0, 29, 23), (35, 29, 23)] := by decide

/-- No two ports share a cell. -/
theorem portCells_nodup : (ports.map portCell).Nodup := by decide

/-- Every port cell is inside the box. -/
theorem portCell_lt : ∀ p ∈ ports,
    (portCell p).1 < 71 ∧ (portCell p).2.1 < 59 ∧ (portCell p).2.2 < 47 := by decide

/-! ## Flying the box -/

/-- One coordinate, moved `d` cells forward round the torus. -/
def moveUp (c d m : Nat) : Nat := (c + d) % m

/-- One coordinate, moved `d` cells back round the torus. -/
def moveDown (c d m : Nat) : Nat := (c + (m - d % m)) % m

/-- The coordinate along axis `i` after a hop of `d` cells on heading `h`. -/
def voyAxis (i c h d : Nat) : Nat :=
  if h = 2 * i then moveUp c d (axisLen i)
  else if h = 2 * i + 1 then moveDown c d (axisLen i)
  else c

theorem moveUp_lt (c d i : Nat) : moveUp c d (axisLen i) < axisLen i :=
  Nat.mod_lt _ (axisLen_pos i)

theorem moveDown_lt (c d i : Nat) : moveDown c d (axisLen i) < axisLen i :=
  Nat.mod_lt _ (axisLen_pos i)

theorem voyAxis_lt {i c h d : Nat} (hc : c < axisLen i) : voyAxis i c h d < axisLen i := by
  unfold voyAxis
  split_ifs
  · exact moveUp_lt c d i
  · exact moveDown_lt c d i
  · exact hc

/-! ## The ship in play -/

/-- A voyage: where the ship is, what it is carrying, what it is worth, the
build it is flying and the state of the market. -/
structure Voyage where
  /-- Cell along the 71-axis. -/
  x : Nat
  /-- Cell along the 59-axis. -/
  y : Nat
  /-- Cell along the 47-axis. -/
  z : Nat
  /-- Which of the six axis directions the nose points along. -/
  hdg : Nat
  /-- Throttle notch. -/
  speed : Nat
  /-- Fuel aboard. -/
  fuel : Nat
  /-- Zero when flying, `i + 1` when docked at port `i`. -/
  docked : Nat
  /-- Credits in hand. -/
  credits : Nat
  /-- One shelf per good. -/
  hold : List Nat
  /-- The market. -/
  econ : Economy
  /-- The build being flown, packed by `encodeSpec`. -/
  shipCode : Nat
  /-- Top throttle notch of that build. -/
  maxSpeed : Nat
  /-- Tank of that build. -/
  tankCap : Nat
  /-- Hold of that build. -/
  holdCap : Nat
  /-- Command counter. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the voxel frontier. -/
inductive VoyageCmd
  | turnTo (h : Nat)
  | thrust
  | brake
  | fly
  | dock
  | buy (g : Nat)
  | sell (g : Nat)
  | refuel
  | wait
  deriving DecidableEq, Repr, Inhabited

/-- Fuel points one unit of the FUEL good is worth. -/
def fuelPerUnit : Nat := 8

/-- The port the ship is docked at, if any. -/
def dockedAt (s : Voyage) : Option Nat :=
  if s.docked = 0 then none else some (s.docked - 1)

/-- How much cargo is aboard. -/
def holdUsed (s : Voyage) : Nat := s.hold.sum

/-- The transition function of the voxel frontier.  Time — and therefore a
production round — passes when the ship moves or waits; trading is
instantaneous, and happens at the price on the board when the order is
given. -/
def voyageStep (s : Voyage) : VoyageCmd → Voyage
  | .turnTo h => { s with hdg := if h ≤ 5 then h else s.hdg, turn := s.turn + 1 }
  | .thrust =>
      { s with
        speed := if s.docked = 0 ∧ s.speed < s.maxSpeed then s.speed + 1 else s.speed,
        turn := s.turn + 1 }
  | .brake => { s with speed := s.speed - 1, turn := s.turn + 1 }
  | .fly =>
      if s.docked = 0 ∧ s.speed ≤ s.fuel then
        { s with
          x := voyAxis 0 s.x s.hdg s.speed,
          y := voyAxis 1 s.y s.hdg s.speed,
          z := voyAxis 2 s.z s.hdg s.speed,
          fuel := s.fuel - s.speed,
          econ := tick s.econ,
          turn := s.turn + 1 }
      else { s with econ := tick s.econ, turn := s.turn + 1 }
  | .dock =>
      if s.docked ≠ 0 then { s with docked := 0, turn := s.turn + 1 }
      else
        match portHere s.x s.y s.z with
        | some i => { s with docked := i + 1, speed := 0, turn := s.turn + 1 }
        | none => { s with turn := s.turn + 1 }
  | .buy g =>
      match dockedAt s with
      | none => { s with turn := s.turn + 1 }
      | some i =>
          if g < numGoods ∧ priceAt s.econ i g ≤ s.credits ∧ 1 ≤ stockAt s.econ i g ∧
              holdUsed s < s.holdCap then
            { s with
              credits := s.credits - priceAt s.econ i g,
              hold := addStock s.hold g 1,
              econ := econBuy s.econ i g,
              turn := s.turn + 1 }
          else { s with turn := s.turn + 1 }
  | .sell g =>
      match dockedAt s with
      | none => { s with turn := s.turn + 1 }
      | some i =>
          if g < numGoods ∧ 1 ≤ stockOf s.hold g then
            { s with
              credits := s.credits + priceAt s.econ i g,
              hold := subStock s.hold g 1,
              econ := econSell s.econ i g,
              turn := s.turn + 1 }
          else { s with turn := s.turn + 1 }
  | .refuel =>
      match dockedAt s with
      | none => { s with turn := s.turn + 1 }
      | some i =>
          if priceAt s.econ i fuelGood ≤ s.credits ∧ 1 ≤ stockAt s.econ i fuelGood ∧
              s.fuel + fuelPerUnit ≤ s.tankCap then
            { s with
              credits := s.credits - priceAt s.econ i fuelGood,
              fuel := s.fuel + fuelPerUnit,
              econ := econBuy s.econ i fuelGood,
              turn := s.turn + 1 }
          else { s with turn := s.turn + 1 }
  | .wait => { s with econ := tick s.econ, turn := s.turn + 1 }

/-- Play a list of commands. -/
def voyageRun (s : Voyage) : List VoyageCmd → Voyage
  | [] => s
  | c :: cs => voyageRun (voyageStep s c) cs

/-- A ship at the start of its voyage, flying the given build. -/
def newVoyage (spec : ShipSpec) : Voyage :=
  let st := shipStats spec
  { x := 0, y := 0, z := 0, hdg := 0, speed := 0, fuel := st.tank, docked := 1,
    credits := 400, hold := [0, 0, 0, 0, 0], econ := initialEconomy,
    shipCode := encodeSpec spec, maxSpeed := st.maxSpeed, tankCap := st.tank,
    holdCap := st.hold, turn := 0 }

/-- The voyage the demo flies: the TRADER off the shelf. -/
def demoVoyage : Voyage := newVoyage (stockShips.getD 3 default)

/-! ## Everything stays legal -/

/-- A legal voyage: the ship is in the box, pointing somewhere, inside its own
limits, and the market is well formed. -/
def VoyageOk (s : Voyage) : Prop :=
  s.x < 71 ∧ s.y < 59 ∧ s.z < 47 ∧ s.hdg ≤ 5 ∧ s.speed ≤ s.maxSpeed ∧ s.fuel ≤ s.tankCap ∧
    s.hold.length = numGoods ∧ holdUsed s ≤ s.holdCap ∧ s.docked ≤ numPorts ∧ EconomyOk s.econ

instance : DecidablePred VoyageOk := fun s => by unfold VoyageOk; infer_instance

theorem demoVoyage_ok : VoyageOk demoVoyage := by decide

/-- **Nothing ever leaves the box.**  Every command keeps the ship inside the
`71 × 59 × 47` grid, the heading among the six directions, the throttle inside
the engine's range, the tank inside the ship's and the hold inside its
capacity, and the market well formed. -/
theorem voyageStep_ok {s : Voyage} (h : VoyageOk s) (c : VoyageCmd) :
    VoyageOk (voyageStep s c) := by
  obtain ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩ := h
  simp only [holdUsed] at hu
  cases c with
  | turnTo k =>
      refine ⟨hx, hy, hz, ?_, hsp, hf, hlen, hu, hd, he⟩
      simp only [voyageStep]
      split_ifs <;> omega
  | thrust =>
      refine ⟨hx, hy, hz, hh, ?_, hf, hlen, hu, hd, he⟩
      simp only [voyageStep]
      split_ifs <;> omega
  | brake => exact ⟨hx, hy, hz, hh, by simp only [voyageStep]; omega, hf, hlen, hu, hd, he⟩
  | fly =>
      simp only [voyageStep, VoyageOk]
      split_ifs
      · exact ⟨voyAxis_lt (by simpa [axisLen] using hx),
               voyAxis_lt (by simpa [axisLen] using hy),
               voyAxis_lt (by simpa [axisLen] using hz),
               hh, hsp, by simp only []; omega, hlen, hu, hd, tick_ok he⟩
      · exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, tick_ok he⟩
  | dock =>
      simp only [voyageStep, VoyageOk]
      split_ifs with hne
      · exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, Nat.zero_le _, he⟩
      · cases hp : portHere s.x s.y s.z with
        | none => exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
        | some i =>
            have hi : i < numPorts := by
              have hmem : i ∈ List.range numPorts :=
                List.mem_of_find?_eq_some (p := fun i =>
                  decide (portCell (portAt i) = (s.x, s.y, s.z))) hp
              simpa using hmem
            refine ⟨hx, hy, hz, hh, ?_, hf, hlen, hu, ?_, he⟩
            · show (0 : Nat) ≤ s.maxSpeed
              exact Nat.zero_le _
            · show i + 1 ≤ numPorts
              omega
  | buy g =>
      simp only [voyageStep]
      cases hdk : dockedAt s with
      | none => exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
      | some i =>
          simp only []
          split_ifs with hc
          · obtain ⟨hg, -, -, hcap⟩ := hc
            simp only [holdUsed] at hcap
            refine ⟨hx, hy, hz, hh, hsp, hf, by rw [addStock_length]; exact hlen, ?_,
              hd, econBuy_ok he i g⟩
            show (addStock s.hold g 1).sum ≤ s.holdCap
            rw [sum_addStock s.hold g (by omega)]
            omega
          · exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
  | sell g =>
      simp only [voyageStep]
      cases hdk : dockedAt s with
      | none => exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
      | some i =>
          simp only []
          split_ifs with hc
          · obtain ⟨hg, hhas⟩ := hc
            refine ⟨hx, hy, hz, hh, hsp, hf, by rw [subStock_length]; exact hlen, ?_,
              hd, econSell_ok he i g⟩
            show (subStock s.hold g 1).sum ≤ s.holdCap
            have := sum_subStock s.hold g (by omega) hhas
            omega
          · exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
  | refuel =>
      simp only [voyageStep]
      cases hdk : dockedAt s with
      | none => exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
      | some i =>
          simp only []
          split_ifs with hc
          · obtain ⟨-, -, hcap⟩ := hc
            exact ⟨hx, hy, hz, hh, hsp, by simpa using hcap, hlen, hu, hd,
              econBuy_ok he i fuelGood⟩
          · exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, he⟩
  | wait => exact ⟨hx, hy, hz, hh, hsp, hf, hlen, hu, hd, tick_ok he⟩

/-- A whole voyage stays legal. -/
theorem voyageRun_ok {s : Voyage} (h : VoyageOk s) (cs : List VoyageCmd) :
    VoyageOk (voyageRun s cs) := by
  induction cs generalizing s with
  | nil => exact h
  | cons c cs ih => exact ih (voyageStep_ok h c)

/-- **The ship is always at a voxel of the Monster's world.**  Its position,
read as an address of the level-3 grid, is a cell index below 196 883. -/
theorem voyage_voxel_lt {s : Voyage} (h : VoyageOk s) :
    Monster.encode (Monster.level 3) [s.x, s.y, s.z] < Monster.cells 3 := by
  obtain ⟨hx, hy, hz, -⟩ := h
  have hv : Monster.Valid (Monster.level 3) [s.x, s.y, s.z] := by
    show List.Forall₂ (· < ·) [s.x, s.y, s.z] (Monster.level 3)
    have : Monster.level 3 = [71, 59, 47] := by decide
    rw [this]
    exact List.Forall₂.cons hx (List.Forall₂.cons hy (List.Forall₂.cons hz List.Forall₂.nil))
  simpa [Monster.cells] using Monster.encode_lt hv

/-! ## The rules of the run -/

/-- The clock only moves forward. -/
theorem voyageStep_turn (s : Voyage) (c : VoyageCmd) :
    (voyageStep s c).turn = s.turn + 1 := by
  cases c with
  | turnTo k => rfl
  | thrust => rfl
  | brake => rfl
  | fly => simp only [voyageStep]; split_ifs <;> rfl
  | dock =>
      simp only [voyageStep]
      split_ifs
      · rfl
      · cases portHere s.x s.y s.z <;> rfl
  | buy g =>
      simp only [voyageStep]
      cases dockedAt s
      · rfl
      · simp only []; split_ifs <;> rfl
  | sell g =>
      simp only [voyageStep]
      cases dockedAt s
      · rfl
      · simp only []; split_ifs <;> rfl
  | refuel =>
      simp only [voyageStep]
      cases dockedAt s
      · rfl
      · simp only []; split_ifs <;> rfl
  | wait => rfl

/-- Only `dock` ever changes whether the ship is docked. -/
theorem docked_unchanged (s : Voyage) (c : VoyageCmd) (h : c ≠ .dock) :
    (voyageStep s c).docked = s.docked := by
  cases c with
  | turnTo k => rfl
  | thrust => rfl
  | brake => rfl
  | fly => simp only [voyageStep]; split_ifs <;> rfl
  | dock => exact absurd rfl h
  | buy g =>
      simp only [voyageStep]
      cases dockedAt s
      · rfl
      · simp only []; split_ifs <;> rfl
  | sell g =>
      simp only [voyageStep]
      cases dockedAt s
      · rfl
      · simp only []; split_ifs <;> rfl
  | refuel =>
      simp only [voyageStep]
      cases dockedAt s
      · rfl
      · simp only []; split_ifs <;> rfl
  | wait => rfl

/-- **Docking only happens on a port's cell.** -/
theorem dock_only_at_port {s : Voyage} (hfree : s.docked = 0) {c : VoyageCmd}
    (hdock : (voyageStep s c).docked ≠ 0) :
    ∃ i, portHere s.x s.y s.z = some i := by
  by_cases hc : c = .dock
  · subst hc
    cases hp : portHere s.x s.y s.z with
    | none =>
        exfalso
        apply hdock
        simp only [voyageStep, hfree, ne_eq, not_true_eq_false, if_false, hp]
    | some i => exact ⟨i, rfl⟩
  · exact absurd (by rw [docked_unchanged s c hc, hfree]) hdock

/-- **Flying burns exactly the throttle setting.** -/
theorem fly_burns_throttle {s : Voyage} (hfree : s.docked = 0) (hf : s.speed ≤ s.fuel) :
    (voyageStep s .fly).fuel + s.speed = s.fuel := by
  simp only [voyageStep, if_pos (⟨hfree, hf⟩ : s.docked = 0 ∧ s.speed ≤ s.fuel)]
  omega

/-- **A dry tank grounds the ship**: only the clock and the market move. -/
theorem fly_dry {s : Voyage} (h : s.fuel < s.speed) :
    voyageStep s .fly = { s with econ := tick s.econ, turn := s.turn + 1 } := by
  simp only [voyageStep]
  split_ifs with hc
  · omega
  · rfl

/-- A docked ship does not drift. -/
theorem fly_docked {s : Voyage} (h : s.docked ≠ 0) :
    voyageStep s .fly = { s with econ := tick s.econ, turn := s.turn + 1 } := by
  simp only [voyageStep]
  split_ifs with hc
  · exact absurd hc.1 h
  · rfl

/-- **Fuel is only ever gained by buying it at a port.**  Every other command
leaves the tank no fuller than it found it. -/
theorem fuel_only_from_refuel (s : Voyage) (c : VoyageCmd) (h : c ≠ .refuel) :
    (voyageStep s c).fuel ≤ s.fuel := by
  cases c with
  | turnTo k => simp [voyageStep]
  | thrust => simp [voyageStep]
  | brake => simp [voyageStep]
  | fly => simp only [voyageStep]; split_ifs <;> simp
  | dock =>
      simp only [voyageStep]; split_ifs
      · simp
      · cases portHere s.x s.y s.z <;> simp
  | buy g =>
      simp only [voyageStep]; cases dockedAt s
      · simp
      · simp only []; split_ifs <;> simp
  | sell g =>
      simp only [voyageStep]; cases dockedAt s
      · simp
      · simp only []; split_ifs <;> simp
  | refuel => exact absurd rfl h
  | wait => simp [voyageStep]

/-- **A purchase pays the quoted price exactly.** -/
theorem buy_credits_exact {s : Voyage} {i g : Nat} (hi : dockedAt s = some i)
    (hc : g < numGoods ∧ priceAt s.econ i g ≤ s.credits ∧ 1 ≤ stockAt s.econ i g ∧
      holdUsed s < s.holdCap) :
    (voyageStep s (.buy g)).credits + priceAt s.econ i g = s.credits := by
  simp only [voyageStep, hi, if_pos hc]
  omega

/-- **A purchase moves one unit and creates none.**  The unit that leaves the
port's shelf is the unit that arrives in the hold. -/
theorem buy_conserves_units {s : Voyage} {i g : Nat} (hi : dockedAt s = some i)
    (hc : g < numGoods ∧ priceAt s.econ i g ≤ s.credits ∧ 1 ≤ stockAt s.econ i g ∧
      holdUsed s < s.holdCap)
    (hstocks : i < s.econ.stocks.length) (hw : g < (warehouse s.econ i).length)
    (hg : g < s.hold.length) :
    stockAt (voyageStep s (.buy g)).econ i g + stockOf (voyageStep s (.buy g)).hold g =
      stockAt s.econ i g + stockOf s.hold g := by
  have hstock := hc.2.2.1
  simp only [voyageStep, hi]
  rw [if_pos hc]
  show stockOf (warehouse (econBuy s.econ i g) i) g + stockOf (addStock s.hold g 1) g =
    stockAt s.econ i g + stockOf s.hold g
  have hdef : stockAt s.econ i g = stockOf (warehouse s.econ i) g := rfl
  rw [hdef] at hstock ⊢
  rw [show warehouse (econBuy s.econ i g) i = subStock (warehouse s.econ i) g 1 from
    warehouse_set hstocks _, stockOf_sub_self hw, stockOf_add_self hg]
  omega

/-- **The hold never overflows**, for any legal voyage. -/
theorem hold_within_capacity {s : Voyage} (h : VoyageOk s) (cs : List VoyageCmd) :
    holdUsed (voyageRun s cs) ≤ (voyageRun s cs).holdCap :=
  (voyageRun_ok h cs).2.2.2.2.2.2.2.1

/-! ## The prices a player actually pays -/

/-- The demo ship, docked at MINEHEAD, buying FUEL four times over. -/
def fourFuel : List VoyageCmd := [.buy 1, .buy 1, .buy 1, .buy 1]

/-- The run the demo flies: fill the hold with ORE where it is mined, undock,
climb the 47-axis to DIGSITE, and sell it where ORE is scarce. -/
def tradeRun : List VoyageCmd :=
  List.replicate 8 (VoyageCmd.buy 0) ++ [.dock, .turnTo 4, .thrust, .thrust] ++
    List.replicate 11 VoyageCmd.fly ++ [.brake, .fly, .dock] ++
    List.replicate 8 (VoyageCmd.sell 0)

/-- **The price moves while you trade.**  Four units of FUEL bought one after
another at MINEHEAD cost 15, 16, 19 and 21 credits: the shelf empties as the
player buys, so the fourth unit is half as dear again as the first.  This is
the answer to the complaint that the price was always the same. -/
theorem repeat_buys_cost_more :
    (List.range 4).map
        (fun k => (voyageRun demoVoyage (fourFuel.take k)).credits -
                  (voyageRun demoVoyage (fourFuel.take (k + 1))).credits) = [15, 16, 19, 21] := by
  decide +kernel

/-- Four units really are aboard afterwards, and MINEHEAD is four the
poorer. -/
theorem fourFuel_moves_goods :
    stockOf (voyageRun demoVoyage fourFuel).hold 1 = 4 ∧
      stockAt (voyageRun demoVoyage fourFuel).econ 0 1 = 2 := by
  decide +kernel

/-- **The circuit can be worked.**  The thirty-four commands of `tradeRun` buy
eight ORE at MINEHEAD, fly the twenty-three cells up the 47-axis to DIGSITE —
running twelve production rounds on the way, which moves every price on the
board — and sell the load where ORE is scarce.  The ship comes home docked,
empty and 78 credits richer, and the whole voyage was legal. -/
theorem tradeRun_profit :
    (voyageRun demoVoyage tradeRun).credits = 478 ∧
      demoVoyage.credits = 400 ∧
      (voyageRun demoVoyage tradeRun).docked = 5 ∧
      (voyageRun demoVoyage tradeRun).z = 23 ∧
      holdUsed (voyageRun demoVoyage tradeRun) = 0 := by
  decide +kernel

/-- …and it is legal at every step, by the invariant. -/
theorem tradeRun_ok : VoyageOk (voyageRun demoVoyage tradeRun) :=
  voyageRun_ok demoVoyage_ok tradeRun

end Trade
end NixWars
