import RequestProject.Nix.NixWars.Trade.Goods

/-!
# The shipyard: parts, custom ships and their statistics

One ship was not enough.  A ship here is not a constant, it is a *build*: a
hull, an engine, a tank, a hold and a livery, chosen out of a catalogue of
seventeen parts (`partCatalog`).  Everything the flight model reads off a ship
— its top throttle notch, the size of its tank, how many units of cargo it can
carry, what it masses and what it cost — is computed from the build
(`shipStats`), so a player who changes a part changes the way the ship flies.

What is proved:

* the catalogue is well formed: distinct names, every part in a real slot,
  every slot stocked (`partCatalog_names_nodup`, `partCatalog_slots`,
  `slotParts_counts`);
* a build is *legal* when its parts exist, the frame carries the mass and the
  engine turns (`ShipOk`), and there are exactly **198** legal builds out of
  the 432 combinations of parts (`legal_build_count`) — so the customizer has
  a real design space with real trade-offs: the biggest engine does not fit
  the smallest hull (`heavy_engine_needs_frame`) and no hull at all carries
  the biggest of everything (`no_hull_carries_everything`);
* every legal build flies: positive throttle, a tank and a hold
  (`shipStats_pos`);
* the statistics move monotonically with the parts — a bigger engine is never
  slower, a bigger tank never smaller (`engine_mono`, `tank_mono`);
* a build is a number and back again (`decodeSpec_encodeSpec`), which is what
  lets a ship travel in a URL, a save file or a token.

Six stock ships (`stockShips`) come off the shelf, all legal
(`stockShips_ok`), all different (`stockShips_nodup`), and no two of them fly
the same (`stockShips_stats_nodup`).
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade

/-! ## Parts -/

/-- A part in the catalogue.  `frame` is the mass a hull can carry (zero for
everything that is not a hull); `thrust`, `tankCap` and `holdCap` are what the
part contributes to the ship's top notch, tank and hold. -/
structure Part where
  /-- Which of the five slots the part goes in: 0 hull, 1 engine, 2 tank,
  3 hold, 4 livery. -/
  slot : Nat
  /-- The part's name in the shop. -/
  name : String
  /-- What it masses. -/
  mass : Nat
  /-- What it costs in credits. -/
  cost : Nat
  /-- Mass the part can carry (hulls only). -/
  frame : Nat
  /-- Throttle notches the part adds. -/
  thrust : Nat
  /-- Fuel the part adds to the tank. -/
  tankCap : Nat
  /-- Cargo units the part adds to the hold. -/
  holdCap : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The shop's catalogue: three hulls, four engines, three tanks, three holds
and four liveries. -/
def partCatalog : List Part :=
  [-- hulls
   ⟨0, "SHARD SLOOP",   6,  40, 22, 2, 4, 2⟩,
   ⟨0, "RING CLIPPER", 10,  90, 34, 3, 6, 4⟩,
   ⟨0, "MONSTER HULK", 16, 190, 52, 4, 8, 8⟩,
   -- engines
   ⟨1, "SPARK I",       4,  30, 0, 1, 0, 0⟩,
   ⟨1, "SPARK III",     7,  70, 0, 2, 0, 0⟩,
   ⟨1, "NOVA DRIVE",   12, 150, 0, 3, 0, 0⟩,
   ⟨1, "MONSTER TORCH",20, 320, 0, 4, 0, 0⟩,
   -- tanks
   ⟨2, "CAN",           3,  20, 0, 0, 24, 0⟩,
   ⟨2, "DRUM",          6,  55, 0, 0, 47, 0⟩,
   ⟨2, "CISTERN",      11, 120, 0, 0, 71, 0⟩,
   -- holds
   ⟨3, "CRATE",         3, 25, 0, 0, 0, 6⟩,
   ⟨3, "BAY",           8, 80, 0, 0, 0, 14⟩,
   ⟨3, "CATHEDRAL",    15, 210, 0, 0, 0, 29⟩,
   -- liveries
   ⟨4, "PLAIN",         0, 0, 0, 0, 0, 0⟩,
   ⟨4, "SHARD BLUE",    1, 12, 0, 0, 0, 0⟩,
   ⟨4, "CROWN GOLD",    1, 47, 0, 0, 0, 0⟩,
   ⟨4, "MONSTER BLACK", 2, 71, 0, 0, 0, 0⟩]

/-- The parts that go in slot `k`. -/
def slotParts (k : Nat) : List Part := partCatalog.filter (fun p => p.slot = k)

/-- The `i`th part of slot `k`. -/
def slotPart (k i : Nat) : Part := (slotParts k).getD i default

/-- How many parts each slot stocks. -/
def slotCount (k : Nat) : Nat := (slotParts k).length

theorem partCatalog_length : partCatalog.length = 17 := by decide

/-- No two parts share a name. -/
theorem partCatalog_names_nodup : (partCatalog.map Part.name).Nodup := by decide

/-- Every part goes in one of the five slots. -/
theorem partCatalog_slots : ∀ p ∈ partCatalog, p.slot < 5 := by decide

/-- Three hulls, four engines, three tanks, three holds, four liveries. -/
theorem slotParts_counts :
    (List.range 5).map slotCount = [3, 4, 3, 3, 4] := by decide

/-! ## A build -/

/-- A custom ship: a name, a part in each of the five slots, and a hue for the
hull (0 … 359, what the renderer paints it). -/
structure ShipSpec where
  /-- What the owner calls it. -/
  name : String
  /-- Index into the hulls. -/
  hull : Nat
  /-- Index into the engines. -/
  engine : Nat
  /-- Index into the tanks. -/
  tank : Nat
  /-- Index into the holds. -/
  hold : Nat
  /-- Index into the liveries. -/
  livery : Nat
  /-- The hue the hull is painted, in degrees. -/
  hue : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The five parts of a build, in slot order. -/
def specParts (s : ShipSpec) : List Part :=
  [slotPart 0 s.hull, slotPart 1 s.engine, slotPart 2 s.tank, slotPart 3 s.hold,
   slotPart 4 s.livery]

/-- What a ship flies like: its top throttle notch, tank, hold, mass and the
credits it cost to build. -/
structure ShipStats where
  /-- Top throttle notch. -/
  maxSpeed : Nat
  /-- Fuel capacity. -/
  tank : Nat
  /-- Cargo capacity. -/
  hold : Nat
  /-- Total mass. -/
  mass : Nat
  /-- Total cost in credits. -/
  cost : Nat
  deriving DecidableEq, Repr, Inhabited

/-- Read the statistics off a build: the engine drives the throttle but never
past what the hull can steer, and the hull adds its own tankage and stowage. -/
def shipStats (s : ShipSpec) : ShipStats :=
  { maxSpeed := min (slotPart 1 s.engine).thrust (slotPart 0 s.hull).thrust,
    tank := (slotPart 0 s.hull).tankCap + (slotPart 2 s.tank).tankCap,
    hold := (slotPart 0 s.hull).holdCap + (slotPart 3 s.hold).holdCap,
    mass := ((specParts s).map Part.mass).sum,
    cost := ((specParts s).map Part.cost).sum }

/-- **A legal build**: every index names a part, the hull's frame carries the
mass, and the engine turns. -/
def ShipOk (s : ShipSpec) : Prop :=
  s.hull < 3 ∧ s.engine < 4 ∧ s.tank < 3 ∧ s.hold < 3 ∧ s.livery < 4 ∧ s.hue < 360 ∧
    (shipStats s).mass ≤ (slotPart 0 s.hull).frame ∧ 1 ≤ (shipStats s).maxSpeed

instance : DecidablePred ShipOk := fun s => by unfold ShipOk; infer_instance

/-- A build with its indices in range, ignoring the frame test. -/
def buildOf (h e t d l : Nat) : ShipSpec :=
  { name := "CUSTOM", hull := h, engine := e, tank := t, hold := d, livery := l, hue := 200 }

/-- All 432 combinations of parts. -/
def allBuilds : List ShipSpec :=
  (List.range 3).flatMap (fun h =>
    (List.range 4).flatMap (fun e =>
      (List.range 3).flatMap (fun t =>
        (List.range 3).flatMap (fun d =>
          (List.range 4).map (fun l => buildOf h e t d l)))))

theorem allBuilds_length : allBuilds.length = 432 := by decide

/-- **The design space.**  Of the 432 ways to bolt the catalogue together, 198
are legal ships: the customizer is a real choice, not a menu with one
answer. -/
theorem legal_build_count : (allBuilds.filter (fun s => decide (ShipOk s))).length = 198 := by
  decide +kernel


/-- **Weight is a constraint.**  The heaviest engine with the biggest tank and
the biggest hold fits *no* hull on the shelf, whatever the livery: there is no
ship that is best at everything. -/
theorem no_hull_carries_everything :
    ∀ h < 3, ∀ l < 4, ¬ ShipOk (buildOf h 3 2 2 l) := by decide

/-- The heaviest engine does not fit the smallest hull at all. -/
theorem heavy_engine_needs_frame : ∀ t < 3, ∀ d < 3, ∀ l < 4, ¬ ShipOk (buildOf 0 3 t d l) := by
  decide

/-- **Every legal ship flies**: it has a throttle, a tank and a hold. -/
theorem shipStats_pos {s : ShipSpec} (h : ShipOk s) :
    1 ≤ (shipStats s).maxSpeed ∧ 1 ≤ (shipStats s).tank ∧ 1 ≤ (shipStats s).hold := by
  obtain ⟨hh, he, ht, hd, hl, -, -, hspd⟩ := h
  refine ⟨hspd, ?_, ?_⟩
  · have : 2 ≤ (slotPart 0 s.hull).tankCap := by interval_cases hu : s.hull <;> decide
    simp only [shipStats]; omega
  · have : 2 ≤ (slotPart 0 s.hull).holdCap := by interval_cases hu : s.hull <;> decide
    simp only [shipStats]; omega

/-- **A bigger engine is never slower.** -/
theorem engine_thrust_mono : ∀ e < 4, ∀ e' < 4, e ≤ e' →
    (slotPart 1 e).thrust ≤ (slotPart 1 e').thrust := by decide

theorem engine_mono (h e e' t d l : Nat) (he : e ≤ e') (he' : e' < 4) :
    (shipStats (buildOf h e t d l)).maxSpeed ≤ (shipStats (buildOf h e' t d l)).maxSpeed := by
  simp only [shipStats, buildOf]
  exact min_le_min (engine_thrust_mono e (by omega) e' he' he) (Nat.le_refl _)

/-- **A bigger tank is never smaller.** -/
theorem tank_cap_mono : ∀ t < 3, ∀ t' < 3, t ≤ t' →
    (slotPart 2 t).tankCap ≤ (slotPart 2 t').tankCap := by decide

theorem tank_mono (h e t t' d l : Nat) (ht : t ≤ t') (ht' : t' < 3) :
    (shipStats (buildOf h e t d l)).tank ≤ (shipStats (buildOf h e t' d l)).tank := by
  have := tank_cap_mono t (by omega) t' ht' ht
  simp only [shipStats, buildOf]
  omega

/-! ## A build is a number -/

/-- A build's parts as one number: hull, engine, tank, hold, livery and hue
packed in mixed radix. -/
def encodeSpec (s : ShipSpec) : Nat :=
  ((((s.hull * 4 + s.engine) * 3 + s.tank) * 3 + s.hold) * 4 + s.livery) * 360 + s.hue

/-- Reading the parts back out of the number.  The name is not in the number;
it is carried alongside. -/
def decodeSpec (nm : String) (n : Nat) : ShipSpec :=
  { name := nm,
    hue := n % 360,
    livery := n / 360 % 4,
    hold := n / 360 / 4 % 3,
    tank := n / 360 / 4 / 3 % 3,
    engine := n / 360 / 4 / 3 / 3 % 4,
    hull := n / 360 / 4 / 3 / 3 / 4 }

/-- **A ship survives the round trip.**  Packed to a number and read back, a
legal build is the build it was — so a ship can travel in a URL, a save file or
a token. -/
theorem decodeSpec_encodeSpec {s : ShipSpec} (h : ShipOk s) :
    decodeSpec s.name (encodeSpec s) = s := by
  obtain ⟨hh, he, ht, hd, hl, hu, -, -⟩ := h
  obtain ⟨nm, hull, engine, tank, hold, livery, hue⟩ := s
  simp only at hh he ht hd hl hu
  simp only [decodeSpec, encodeSpec, ShipSpec.mk.injEq, true_and]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- The number of a legal build is smaller than the whole design space. -/
theorem encodeSpec_lt {s : ShipSpec} (h : ShipOk s) : encodeSpec s < 432 * 360 := by
  obtain ⟨hh, he, ht, hd, hl, hu, -, -⟩ := h
  unfold encodeSpec
  omega

/-! ## The ships on the shelf -/

/-- Six ships anyone can fly without designing one. -/
def stockShips : List ShipSpec :=
  [⟨"SLOOP",      0, 0, 0, 0, 0, 200⟩,
   ⟨"COURIER",    0, 1, 0, 0, 1, 190⟩,
   ⟨"CLIPPER",    1, 1, 1, 0, 1,  40⟩,
   ⟨"TRADER",     1, 1, 0, 1, 2, 120⟩,
   ⟨"HAULER",     2, 2, 1, 2, 0, 280⟩,
   ⟨"CROWN YACHT",2, 3, 2, 0, 2,  47⟩]

/-- Every ship on the shelf is a legal build. -/
theorem stockShips_ok : ∀ s ∈ stockShips, ShipOk s := by decide

/-- No two of them are the same build. -/
theorem stockShips_nodup : stockShips.Nodup := by decide

/-- **They really are six different ships**: no two fly the same. -/
theorem stockShips_stats_nodup : (stockShips.map shipStats).Nodup := by decide


/-- The statistics of the shelf, spelled out. -/
theorem stockShips_stats :
    stockShips.map shipStats =
      [⟨1, 28,  8, 16, 115⟩,
       ⟨2, 28,  8, 20, 167⟩,
       ⟨2, 53, 10, 27, 252⟩,
       ⟨2, 30, 18, 29, 307⟩,
       ⟨3, 55, 37, 49, 605⟩,
       ⟨4, 79, 14, 51, 702⟩] := by decide

end Trade
end NixWars
