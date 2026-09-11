import RequestProject.Gvcs.Net.Strength

/-!
# A concrete factory: pad, spine and bays, as bricks on the lattice

Everything up to now says what a design *has to satisfy*: bricks on the 5 cm
voxel lattice with a decidable clash test (`RequestProject/Net/Design.lean`),
and a member strength check that is the machine frame's own beam theory
(`RequestProject/Net/Strength.lean`).  This file spends that machinery on one
particular building — the greenfield fabrication shed — and discharges the
checks for it.

The shed is a single rectangular pad with the long axis along the material
flow.  In voxels (5 cm each), with `x` along the flow, `y` across it and `z`
up:

* **pad** — a slab `243 × 99 × 2` voxels, that is 12.15 m × 4.95 m × 10 cm.
* **frames** — six frame lines at `x = 0, 48, 96, 144, 192, 240`, that is at
  2.4 m centres.  Each carries a side column at `y = 0` and `y = 96`; the first
  five also carry a centre column at `y = 48`, so the cross members span
  2.4 m — inside the 2–2.5 m band the capacity result asks for.
* **door** — the sixth frame line has *no* centre column, because that is where
  the wide door is.  Its header therefore spans 4.8 m, and is a heavier
  section: `door_needs_heavy_section` shows the standard rail section would
  *not* carry the header load over that span, and the heavy one does.  That is
  the "add a mid-column or step the section up" decision, decided.
* **purlins** — roof members along the flow, one 2.4 m bay each, on three
  lines.
* **spine** — power and water in one run along the `y = 0` long wall, inboard
  of the columns, so every station taps it without crossing the bay.
* **stations** — stock in, press, cutting, assembly, finishing, in that order
  along the flow, all on the spine side.
* **parking and staging** — the machine apron is off the pad entirely, so the
  tractor never crosses the flow; ore and soil staging sits at the stock-in
  end, where the round trip is shortest.

What is proved about it:

* `factoryDesign_valid` — no two members interpenetrate (the editor's own
  clash test, `Design.Valid`).
* `factoryDesign_grounded` — every brick is on the pad or on another brick.
* `factoryDesign_holds` — **every member is inside its capacity**, by
  `Net.Brick.capacity`, which is the frame's `SquareTube.spanCapacity`.
* `factory_rail_span_eq` — every standard member spans exactly 2.4 m.
* `door_needs_heavy_section` — the span check decides the door.
* `factory_edits_sound`, `factory_replay_holds` — the same building placed
  through the network: every placement is a sound edit, so however the edits
  arrive, from whatever peers, in whatever order, what a replica reconstructs
  still holds.
-/

namespace LifeTrac
namespace Factory

open Net

noncomputable section

/-! ## The catalogue: two sections of mild steel -/

/-- The standard member: 150 mm square tube, 3 mm wall — the section the
machine's own main rails are drawn from. -/
def railTube : SquareTube :=
  { width := 0.15, wall := 0.003, wall_pos := by norm_num,
    wall_lt_half_width := by norm_num }

/-- The heavy member, kept for the door header: 200 mm square tube, 6 mm
wall. -/
def heavyTube : SquareTube :=
  { width := 0.2, wall := 0.006, wall_pos := by norm_num,
    wall_lt_half_width := by norm_num }

/-- Catalogue part id of the standard rail section. -/
def railPart : ℕ := 0
/-- Catalogue part id of the heavy section. -/
def heavyPart : ℕ := 1
/-- Catalogue part id of the pad slab. -/
def slabPart : ℕ := 2
/-- Catalogue part id of the service spine (power and water conduit). -/
def spinePart : ℕ := 3
/-- Catalogue part id of a station: a machine standing on the pad. -/
def stationPart : ℕ := 4
/-- Catalogue part id of graded ground: parking apron, material staging. -/
def apronPart : ℕ := 5

/-- The catalogue the shed is drawn from: the heavy section for part
`heavyPart`, the standard rail section for everything else, all of it mild
steel at 250 MPa. -/
def factoryCatalogue : Catalogue where
  tube := fun p => if p = heavyPart then heavyTube else railTube
  yieldStrength := fun _ => 250000000
  yieldStrength_pos := fun _ => by norm_num

/-! ## The bricks -/

/-- The frame lines, at 2.4 m centres along the flow. -/
def frameX : List ℤ := [0, 48, 96, 144, 192, 240]

/-- The frame lines that carry a centre column: all but the door line. -/
def innerFrameX : List ℤ := [0, 48, 96, 144, 192]

/-- A column: 3 × 3 voxels in plan, 48 voxels (2.4 m) tall, standing on the
pad. -/
def column (fx fy : ℤ) : Brick := ⟨fx, fy, 2, 3, 3, 48, railPart⟩

/-- Every column of the shed: two per frame line, plus a centre column on
every line but the door line. -/
def columns : List Brick :=
  frameX.flatMap (fun fx => [column fx 0, column fx 96]) ++
    innerFrameX.map (fun fx => column fx 48)

/-- A cross member at roof level, spanning from a side column to the centre
column. -/
def crossBeam (fx ylo : ℤ) : Brick := ⟨fx, ylo, 50, 3, 48, 3, railPart⟩

/-- The cross members: two per frame line, on every line but the door line. -/
def crossBeams : List Brick :=
  innerFrameX.flatMap (fun fx => [crossBeam fx 1, crossBeam fx 49])

/-- The door header: the full 4.8 m across, in the heavy section, because the
door line has no centre column. -/
def doorHeader : Brick := ⟨240, 1, 50, 3, 96, 3, heavyPart⟩

/-- A roof member along the flow, one bay long, sitting on the cross
members. -/
def purlin (fx ylo : ℤ) : Brick := ⟨fx + 1, ylo, 53, 48, 3, 3, railPart⟩

/-- The roof members along the flow: three lines, one member per bay. -/
def purlins : List Brick :=
  innerFrameX.flatMap (fun fx => [purlin fx 0, purlin fx 48, purlin fx 96])

/-- The pad: 12.15 m × 4.95 m of 10 cm slab. -/
def slab : Brick := ⟨0, 0, 0, 243, 99, 2, slabPart⟩

/-- The service spine: power and water in one run the whole length of the shed,
inboard of the `y = 0` wall. -/
def serviceSpine : Brick := ⟨0, 3, 2, 243, 3, 3, spinePart⟩

/-- Stock in, at the near end of the flow. -/
def stockIn : Brick := ⟨6, 8, 2, 40, 36, 20, stationPart⟩
/-- The press, in the second bay. -/
def press : Brick := ⟨54, 8, 2, 40, 36, 30, stationPart⟩
/-- Cutting, mid-shed. -/
def cutting : Brick := ⟨102, 8, 2, 40, 36, 24, stationPart⟩
/-- Assembly, in the fourth bay. -/
def assembly : Brick := ⟨150, 8, 2, 40, 36, 20, stationPart⟩
/-- Finishing, at the door end. -/
def finishing : Brick := ⟨198, 8, 2, 40, 36, 20, stationPart⟩

/-- The stations, in flow order. -/
def stations : List Brick := [stockIn, press, cutting, assembly, finishing]

/-- The machine apron: graded ground off the pad, so the tractor never crosses
the flow. -/
def parkingApron : Brick := ⟨0, 105, 0, 243, 60, 2, apronPart⟩

/-- Ore and soil staging, at the stock-in end, where the haul is shortest. -/
def oreStaging : Brick := ⟨-63, 0, 0, 60, 99, 2, apronPart⟩

/-- Every brick of the shed. -/
def factoryBricks : List Brick :=
  [slab, serviceSpine] ++ columns ++ crossBeams ++ [doorHeader] ++ purlins ++
    stations ++ [parkingApron, oreStaging]

/-- The shed as a design. -/
def factoryDesign : Design := factoryBricks.toFinset

/-! ## The clash check -/

/-- A brick's size is a decidable question. -/
instance (b : Brick) : Decidable b.Proper := by unfold Brick.Proper; infer_instance

/-- So is whether a design is grounded. -/
instance (d : Design) : Decidable (Design.Grounded d) := by
  unfold Design.Grounded; infer_instance

/-- The decidable form of `Design.Valid`: no two distinct bricks of the design
answer `true` to the editor's clash test. -/
def Clear (d : Design) : Prop := ∀ b ∈ d, ∀ c ∈ d, b ≠ c → b.overlaps c = false

instance (d : Design) : Decidable (Clear d) := by unfold Clear; infer_instance

theorem valid_of_clear {d : Design} (h : Clear d) : Design.Valid d :=
  fun b hb c hc hbc => Brick.apart_of_not_overlaps (h b hb c hc hbc)

theorem factoryDesign_clear : Clear factoryDesign := by decide

/-- **The shed is a legal design**: no two members interpenetrate, by the
editor's own clash test. -/
theorem factoryDesign_valid : Design.Valid factoryDesign :=
  valid_of_clear factoryDesign_clear

/-- **Everything is supported**: every brick is on the ground plane or rests on
another brick of the design — the pad on the ground, the columns on the pad,
the cross members on the columns, the purlins on the cross members. -/
theorem factoryDesign_grounded : Design.Grounded factoryDesign := by decide

/-! ## The span checks -/

/-- The capacity of a standard member over a span `L`: `4 σ_y Z / L`. -/
theorem rail_capacity_eq {b : Brick} (hp : b.part = railPart) :
    b.capacity factoryCatalogue = 84742.56 / b.span := by
  unfold Brick.capacity SquareTube.spanCapacity
  rw [hp]
  norm_num [factoryCatalogue, railTube, railPart, heavyPart, SquareTube.sectionModulus,
    SquareTube.inertia, SquareTube.innerWidth]

/-- The capacity of a heavy member over a span `L`. -/
theorem heavy_capacity_eq {b : Brick} (hp : b.part = heavyPart) :
    b.capacity factoryCatalogue = 292334.72 / b.span := by
  unfold Brick.capacity SquareTube.spanCapacity
  rw [hp]
  norm_num [factoryCatalogue, heavyTube, heavyPart, SquareTube.sectionModulus,
    SquareTube.inertia, SquareTube.innerWidth]

/-- A brick of `n` voxels' longest side spans `n / 20` metres. -/
theorem span_of_spanVox {b : Brick} {n : ℕ} (h : b.spanVox = n) :
    b.span = (n : ℝ) / 20 := by
  rw [Brick.span, h, voxelMetres]; ring

/-- **A standard member on a 2.4 m span.** -/
theorem rail_capacity_at_bay {b : Brick} (hp : b.part = railPart) (hs : b.spanVox = 48) :
    b.capacity factoryCatalogue = 84742.56 / 2.4 := by
  rw [rail_capacity_eq hp, span_of_spanVox hs]; norm_num

/-- … and it holds over 35 kN there. -/
theorem rail_capacity_at_bay_gt {b : Brick} (hp : b.part = railPart) (hs : b.spanVox = 48) :
    35000 < b.capacity factoryCatalogue := by
  rw [rail_capacity_at_bay hp hs]; norm_num

/-! ## Loads -/

/-- The design loads, in newtons at mid-span: 12 kN on a standard member (roof,
services and a hoist point), 20 kN on the door header (the same, plus the door
leaf), and nothing in bending on the members that bear directly on the ground —
the pad, the spine run, the stations and the aprons. -/
def factoryLoad (b : Brick) : ℝ :=
  if b.part = heavyPart then 20000 else if b.part = railPart then 12000 else 0

/-- The door header, in the heavy section, carries its 20 kN over 4.8 m with
room to spare. -/
theorem doorHeader_capacity_gt : 60000 < doorHeader.capacity factoryCatalogue := by
  rw [heavy_capacity_eq (by rfl), span_of_spanVox (n := 96) (by decide)]
  norm_num

/-- The same header in the *standard* section would not do. -/
theorem doorHeader_rail_capacity_lt :
    ({doorHeader with part := railPart} : Brick).capacity factoryCatalogue < 18000 := by
  rw [rail_capacity_eq (by rfl), span_of_spanVox (n := 96) (by decide)]
  norm_num

/-- **The span check decides the door.**  Over the 4.8 m the wide door needs,
the standard rail section is below the header load and the heavy section is
above it: either put a mid-column in, or step the section up — and the capacity
result says which. -/
theorem door_needs_heavy_section :
    ({doorHeader with part := railPart} : Brick).capacity factoryCatalogue <
        factoryLoad doorHeader ∧
      factoryLoad doorHeader < doorHeader.capacity factoryCatalogue := by
  have h₁ := doorHeader_rail_capacity_lt
  have h₂ := doorHeader_capacity_gt
  have hl : factoryLoad doorHeader = 20000 := by norm_num [factoryLoad, doorHeader]
  rw [hl]
  exact ⟨by linarith, by linarith⟩

/-- **Doubling the span halves the capacity.**  Two bricks of the same section,
one twice as long as the other. -/
theorem capacity_of_double_span (cat : Catalogue) {b c : Brick} (hp : b.part = c.part)
    (hb : 0 < b.span) (hc : c.span = 2 * b.span) :
    c.capacity cat = b.capacity cat / 2 := by
  unfold Brick.capacity SquareTube.spanCapacity
  rw [← hp, hc]
  field_simp

/-! ## Every member of the shed holds -/

/-- The facts about the shed that decidability settles: every brick has a
positive size, every standard member spans exactly 48 voxels, and the only
heavy member is the door header. -/
theorem factory_brick_facts :
    ∀ b ∈ factoryDesign,
      b.Proper ∧ (b.part = railPart → b.spanVox = 48) ∧ (b.part = heavyPart → b = doorHeader) := by
  decide

/-- **Every standard member of the shed spans exactly 2.4 m** — bay spacing is
a decided question, not an aesthetic one. -/
theorem factory_rail_span_eq :
    ∀ b ∈ factoryDesign, b.part = railPart → b.span = 2.4 := by
  intro b hb hp
  rw [span_of_spanVox ((factory_brick_facts b hb).2.1 hp)]
  norm_num

/-- **The shed holds.**  Every member is inside the capacity the machine's own
beam theory gives it, under the design loads. -/
theorem factoryDesign_holds : Design.Holds factoryCatalogue factoryLoad factoryDesign := by
  intro b hb
  obtain ⟨hprop, hrail, hheavy⟩ := factory_brick_facts b hb
  unfold factoryLoad
  split_ifs with h₁ h₂
  · rw [hheavy h₁]
    have := doorHeader_capacity_gt
    linarith
  · have := rail_capacity_at_bay_gt h₂ (hrail h₂)
    linarith
  · exact le_of_lt (Brick.capacity_pos _ _ hprop)

/-- The shed is both legal and strong enough — the two promises the editor
makes, discharged for one concrete building. -/
theorem factoryDesign_valid_and_holds :
    Design.Valid factoryDesign ∧ Design.Holds factoryCatalogue factoryLoad factoryDesign :=
  ⟨factoryDesign_valid, factoryDesign_holds⟩

/-! ## The layout heuristic, as checked statements -/

/-- **The machine never crosses the flow**: the parking apron is off the pad
altogether, on the far side across the flow. -/
theorem parking_off_the_pad :
    slab.y + slab.dy - 1 < parkingApron.y ∧ parkingApron.overlaps slab = false := by
  decide

/-- **Staging is at the stock-in end**: the ore and soil staging sits off the
pad at the low-`x` end, next to the first station, so the haul round trip is
short. -/
theorem staging_at_stock_end :
    oreStaging.x + oreStaging.dx - 1 < slab.x ∧ oreStaging.overlaps slab = false := by
  decide

/-- **The stations are in flow order**: stock in, press, cutting, assembly,
finishing, strictly increasing along the long axis, and all of them on the
pad. -/
theorem stations_in_flow_order :
    stockIn.x < press.x ∧ press.x < cutting.x ∧ cutting.x < assembly.x ∧
      assembly.x < finishing.x ∧
      ∀ s ∈ stations, slab.x ≤ s.x ∧ s.x + s.dx - 1 ≤ slab.x + slab.dx - 1 := by
  decide

/-- **Every station taps the spine without crossing the bay**: the spine runs
the whole length of the shed along one long wall, and every station sits inside
that run and on the spine's side of the centre column line. -/
theorem stations_reach_the_spine :
    ∀ s ∈ stations,
      serviceSpine.x ≤ s.x ∧ s.x + s.dx - 1 ≤ serviceSpine.x + serviceSpine.dx - 1 ∧
        serviceSpine.y + serviceSpine.dy ≤ s.y ∧ s.y + s.dy - 1 < 48 := by
  decide

/-! ## The same shed, built over the network -/

/-- Placing the shed, brick by brick. -/
def factoryEdits : List Edit := factoryBricks.map Edit.place

/-- **Every placement is a sound edit**: no editor anywhere has to accept an
overloaded member to build this shed. -/
theorem factory_edits_sound : ∀ e ∈ factoryEdits, e.Sound factoryCatalogue factoryLoad := by
  intro e he
  obtain ⟨b, hb, rfl⟩ := List.mem_map.1 he
  have hmem : b ∈ factoryDesign := List.mem_toFinset.2 hb
  exact factoryDesign_holds b hmem

/-- **The shed survives the network.**  A log containing only placements of the
shed's own bricks replays, on any peer and in any arrival order, to a design in
which every member holds. -/
theorem factory_replay_holds (L : Log Edit) (h : ∀ o ∈ L, o.payload ∈ factoryEdits) :
    Design.Holds factoryCatalogue factoryLoad (replay applyEdit ∅ L) :=
  replay_holds L (fun o ho => factory_edits_sound _ (h o ho))

/-- … and it replays to a legal design too. -/
theorem factory_replay_valid_and_holds (L : Log Edit) (h : ∀ o ∈ L, o.payload ∈ factoryEdits) :
    Design.Valid (replay applyEdit ∅ L) ∧
      Design.Holds factoryCatalogue factoryLoad (replay applyEdit ∅ L) :=
  ⟨replay_valid L, factory_replay_holds L h⟩

end

end Factory
end LifeTrac
