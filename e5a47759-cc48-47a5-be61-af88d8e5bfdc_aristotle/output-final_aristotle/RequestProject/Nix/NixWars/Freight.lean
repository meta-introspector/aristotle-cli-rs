import RequestProject.Nix.NixWars.Controls
import RequestProject.Nix.NixWars.Arcade

/-!
# The freight run: arcade games carried across the galaxy

The arcade is on Sol and the players are not. `galacticFreight` is the door
that moves the cabinets: a freighter with a hold, a tank and a distance to its
next stop, warping from shard to shard and installing one cabinet at each.

The point of the model is that freight is *conserved*. A cabinet that is
aboard is either still aboard or installed somewhere -- it is never lost,
never duplicated and never conjured:

* `convoy_manifest_perm` -- the manifest (hold plus installed) is a
  permutation of what it was before any command;
* `convoy_manifest_nodup` -- no cabinet is ever duplicated;
* `convoy_drop_needs_arrival` -- a cabinet is only ever unloaded at a stop;
* `convoy_warp_fuel_exact` -- a warp that happens is paid for exactly;
* `convoy_landed_mono`, `convoy_fuel_le` -- deliveries never un-happen and
  fuel is never conjured.

Then the run itself, flown by the autopilot of
`RequestProject.NixWars.Controls`: forty-four commands take the whole arcade
-- all twenty-two cabinets -- across twenty-six thousand light-years and install
every one of them (`convoyTour_delivers`, `convoyTour_perm`).
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 400000

namespace NixWars

/-! ## The freighter -/

/-- A freighter on the run: light-years to its next stop, fuel, a turn
counter, the cabinets still in the hold and the cabinets installed so far
(most recent first). -/
structure Convoy where
  /-- Light-years still to travel to the next stop. -/
  dist : Nat
  /-- Remaining fuel. -/
  fuel : Nat
  /-- Turn counter. -/
  turn : Nat
  /-- Cabinet ids still in the hold. -/
  hold : List Nat
  /-- Cabinet ids installed, most recent first. -/
  landed : List Nat
  deriving DecidableEq, Repr, Inhabited

/-- The freighter's commands. -/
inductive ConvoyCmd
  | warp (d : Nat)
  | drop
  | scan
  deriving DecidableEq, Repr, Inhabited

/-- The stops are a fixed leg apart: twenty-two of them span the galaxy. -/
def convoyLeg : Nat := 1334

/-- A warp: refused when the tank is too low, paid for exactly otherwise. -/
def convoyWarp (s : Convoy) (d : Nat) : Convoy :=
  if warpCost d ≤ s.fuel then
    { s with dist := s.dist - d, fuel := s.fuel - warpCost d, turn := s.turn + 1 }
  else s

/-- Unloading a cabinet: only at a stop, and only if there is one in the hold.
The next stop is a leg further on. -/
def convoyDrop (s : Convoy) : Convoy :=
  if s.dist = 0 then
    match s.hold with
    | [] => s
    | c :: rest =>
        { s with hold := rest, landed := c :: s.landed, dist := convoyLeg, turn := s.turn + 1 }
  else s

/-- The transition function of the freight run. -/
def convoyStep (s : Convoy) : ConvoyCmd → Convoy
  | .warp d => convoyWarp s d
  | .drop => convoyDrop s
  | .scan => s

/-- The freighter as a payload: the manifest rides on the wire with the ship,
its length declared so the hold and the delivered list can be told apart. -/
def convoySerialize (s : Convoy) : List Nat :=
  [s.dist, s.fuel, s.turn, s.hold.length] ++ s.hold ++ s.landed

/-- Reading a freighter back from a payload. -/
def convoyDeserialize : List Nat → Option Convoy
  | dist :: fuel :: turn :: n :: rest =>
      some { dist := dist, fuel := fuel, turn := turn,
             hold := rest.take n, landed := rest.drop n }
  | _ => none

theorem convoyDeserialize_convoySerialize (s : Convoy) :
    convoyDeserialize (convoySerialize s) = some s := by
  cases s with
  | mk dist fuel turn hold landed =>
    simp [convoySerialize, convoyDeserialize]

/-- **The freight run as a door game.** -/
def galacticFreight : DoorGame where
  State := Convoy
  Cmd := ConvoyCmd
  step := convoyStep
  serialize := convoySerialize
  deserialize := convoyDeserialize
  deserialize_serialize := convoyDeserialize_convoySerialize

/-! ## Conservation of freight -/

/-- The manifest: every cabinet the freighter is responsible for, aboard or
installed. -/
def convoyManifestOf (s : Convoy) : List Nat := s.hold ++ s.landed

/-- **Nothing is lost, duplicated or conjured.** Every command permutes the
manifest -- in fact only `drop` moves anything, and it moves one cabinet from
the hold to the ground. -/
theorem convoy_manifest_perm (s : Convoy) (c : ConvoyCmd) :
    (convoyManifestOf (convoyStep s c)).Perm (convoyManifestOf s) := by
  cases c with
  | warp d =>
      simp only [convoyStep, convoyWarp]
      split <;> exact List.Perm.refl _
  | scan => exact List.Perm.refl _
  | drop =>
      simp only [convoyStep, convoyDrop]
      split
      · rename_i h
        cases hh : s.hold with
        | nil => exact List.Perm.refl _
        | cons a t =>
            simp only [convoyManifestOf, hh]
            exact List.perm_middle
      · exact List.Perm.refl _

/-- The manifest keeps its size. -/
theorem convoy_manifest_length (s : Convoy) (c : ConvoyCmd) :
    (convoyManifestOf (convoyStep s c)).length = (convoyManifestOf s).length :=
  (convoy_manifest_perm s c).length_eq

/-- **No cabinet is ever duplicated.** -/
theorem convoy_manifest_nodup (s : Convoy) (c : ConvoyCmd) (h : (convoyManifestOf s).Nodup) :
    (convoyManifestOf (convoyStep s c)).Nodup :=
  (convoy_manifest_perm s c).nodup_iff.mpr h

/-- **A cabinet is only unloaded at a stop.** -/
theorem convoy_drop_needs_arrival (s : Convoy) (h : s.dist ≠ 0) :
    convoyStep s .drop = s := by
  simp [convoyStep, convoyDrop, h]

/-- With an empty hold there is nothing to unload. -/
theorem convoy_drop_empty (s : Convoy) (h : s.hold = []) : convoyStep s .drop = s := by
  simp only [convoyStep, convoyDrop, h]
  split <;> rfl

/-- **A warp is paid for exactly**: no truncation hides a debt. -/
theorem convoy_warp_fuel_exact (s : Convoy) (d : Nat) (h : warpCost d ≤ s.fuel) :
    (convoyStep s (.warp d)).fuel + warpCost d = s.fuel := by
  simp only [convoyStep, convoyWarp, if_pos h]
  omega

/-- **Fuel is never conjured.** -/
theorem convoy_fuel_le (s : Convoy) (c : ConvoyCmd) : (convoyStep s c).fuel ≤ s.fuel := by
  cases c with
  | warp d =>
      simp only [convoyStep, convoyWarp]
      split <;> simp
  | drop =>
      simp only [convoyStep, convoyDrop]
      split
      · split <;> simp
      · exact le_refl _
  | scan => exact le_refl _

/-- **Deliveries never un-happen.** -/
theorem convoy_landed_mono (s : Convoy) (c : ConvoyCmd) :
    s.landed.length ≤ (convoyStep s c).landed.length := by
  cases c with
  | warp d =>
      simp only [convoyStep, convoyWarp]
      split <;> simp
  | drop =>
      simp only [convoyStep, convoyDrop]
      split
      · split <;> simp
      · exact le_refl _
  | scan => exact le_refl _

/-- **The hold only ever empties.** -/
theorem convoy_hold_le (s : Convoy) (c : ConvoyCmd) :
    (convoyStep s c).hold.length ≤ s.hold.length := by
  cases c with
  | warp d =>
      simp only [convoyStep, convoyWarp]
      split <;> simp
  | drop =>
      simp only [convoyStep, convoyDrop]
      split
      · split
        · simp
        · rename_i heq
          simp [heq]
      · exact le_refl _
  | scan => exact le_refl _

/-- Conservation over a whole run, not just one command. -/
theorem convoy_run_manifest_perm (s : Convoy) (p : List ConvoyCmd) :
    (convoyManifestOf (galacticFreight.run s p)).Perm (convoyManifestOf s) := by
  induction p generalizing s with
  | nil => exact List.Perm.refl _
  | cons c cs ih =>
      exact (ih (convoyStep s c)).trans (convoy_manifest_perm s c)

/-! ## The run: the whole arcade, across the galaxy -/

/-- The arcade has twenty-two cabinets on its floor. -/
theorem arcadeFloor_length : arcadeFloor.length = 22 := rfl

/-- The manifest of the freight run: every cabinet in the arcade, by index. -/
def arcadeManifest : List Nat := List.range arcadeFloor.length

theorem arcadeManifest_length : arcadeManifest.length = 22 := rfl

theorem arcadeManifest_nodup : arcadeManifest.Nodup := List.nodup_range

/-- The freighter as it leaves Sol: the whole arcade in the hold, a leg to the
first stop, and three hundred units of fuel. -/
def initialConvoy : Convoy :=
  { dist := convoyLeg, fuel := 300, turn := 0, hold := arcadeManifest, landed := [] }

/-- **The freighter's autopilot**: close the leg, install a cabinet, repeat;
once the hold is empty there is nothing left to do but scan. -/
def convoyAuto (s : Convoy) : ConvoyCmd :=
  if s.hold = [] then .scan
  else if s.dist = 0 then .drop
  else .warp s.dist

/-- The plan the autopilot flies: two commands a stop, twenty-two stops. -/
def convoyTour : List ConvoyCmd := Controls.pilot galacticFreight convoyAuto initialConvoy 44

theorem convoyTour_length : convoyTour.length = 44 := by
  simp [convoyTour]

/-- The freighter at the end of the run. -/
def convoyDelivered : Convoy := galacticFreight.run initialConvoy convoyTour

/-- **The whole arcade is delivered.** Forty-four autopilot commands empty the
hold: all twenty-two cabinets are installed. -/
theorem convoyTour_delivers : convoyDelivered.hold = [] ∧ convoyDelivered.landed.length = 22 :=
  ⟨rfl, rfl⟩

/-- **And they are the cabinets that were loaded** -- the delivery list is the
manifest, in the order it was carried. -/
theorem convoyTour_perm : convoyDelivered.landed.Perm arcadeManifest := by
  have h : convoyDelivered.landed = arcadeManifest.reverse := by rfl
  rw [h]
  exact arcadeManifest.reverse_perm

/-- **The run crosses the galaxy**: twenty-two legs of 1334 light-years is
29348, past the 26673 light-years from Sol to Sgr A*. -/
theorem convoyTour_distance : 22 * convoyLeg = 29348 ∧ sgrADistance ≤ 22 * convoyLeg :=
  ⟨rfl, by decide⟩

/-- **And it is flown on the fuel it left with**: thirteen units a leg, two
hundred and eighty-six for the run, fourteen in the tank on arrival. -/
theorem convoyTour_fuel : convoyDelivered.fuel = 14 := rfl

/-- Forty-three commands are not enough: the last cabinet is still aboard. -/
theorem convoyTour_tight :
    (Controls.autoRun galacticFreight convoyAuto initialConvoy 43).hold.length = 1 := rfl

/-- The tape of the run, one frame per command, for the demo. -/
def convoyTape : List Convoy := Controls.pilotTape galacticFreight convoyAuto initialConvoy 44

theorem convoyTape_length : convoyTape.length = 45 := by
  simpa using Controls.pilotTape_length (g := galacticFreight) convoyAuto initialConvoy 44

/-- **The tape is faithful**: its last frame is the freighter as the run leaves
it. -/
theorem convoyTape_getLast : convoyTape.getLast? = some convoyDelivered := by
  unfold convoyTape convoyDelivered convoyTour
  exact Controls.pilotTape_getLast (g := galacticFreight) convoyAuto initialConvoy 44

/-- Nothing was lost on the way: the manifest at the end is a permutation of
the manifest at the start. -/
theorem convoyTour_conserved :
    (convoyManifestOf convoyDelivered).Perm (convoyManifestOf initialConvoy) := by
  unfold convoyDelivered
  exact convoy_run_manifest_perm initialConvoy convoyTour

/-! ## The stops

The cabinets are installed on twenty-two different shards of the 71-shard DMZ,
one a leg. Seven is invertible modulo 71, so the stops never repeat. -/

/-- The shard the `i`-th cabinet is installed on. -/
def convoyStopShard (i : Nat) : Nat := (7 * i + 5) % 71

/-- The twenty-two stops of the run. -/
def convoyStops : List Nat := (List.range 22).map convoyStopShard

theorem convoyStops_length : convoyStops.length = 22 := rfl

/-- **Every cabinet gets its own shard**: no stop is visited twice. -/
theorem convoyStops_nodup : convoyStops.Nodup := by decide

/-- Every stop is a shard of the ring. -/
theorem convoyStops_lt : ∀ s ∈ convoyStops, s < 71 := by decide

/-! ## The freight run rides the same wires

Being a `DoorGame`, the freight run inherits the session, the transports and
the statelessness proof of the rest of the board with no new code. -/

/-- A freight session as a URL. -/
def convoyUrl (s : GameSession galacticFreight) : String := transmit urlTransport s

theorem convoyUrl_roundtrip (s : GameSession galacticFreight) :
    receive galacticFreight urlTransport (convoyUrl s) = some s :=
  receive_transmit urlTransport s

/-- The freight run is stateless too: playing it over the wire is playing it. -/
theorem convoy_play_eq (s : GameSession galacticFreight) (cs : List galacticFreight.Cmd) :
    runOverWire (g := galacticFreight) urlTransport (convoyUrl s) cs
      = some (convoyUrl { s with state := galacticFreight.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
