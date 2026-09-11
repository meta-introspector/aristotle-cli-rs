import RequestProject.Gvcs.Factory.Layout
import RequestProject.Gvcs.TechTree.Tier

/-!
# Erecting the shed: the build order as a dependency list

`RequestProject/Factory/Layout.lean` says what the shed *is* — bricks on the
lattice, no clashes, every member inside its capacity.  This file says in what
order it goes up, in the same style as the bootstrap's own installation-order
proofs (`RequestProject/TechTree/Slice.lean`): every step declares what it
consumes, what tools and standing services it needs, and what it erects, and
the order is then *forced* by the resource accounting rather than asserted.

* `siteRaw` — a greenfield site with the machine set already on it (that is the
  premise of the whole exercise: the tractor, the block press, a welder and a
  genset), plus stock and labour.
* `factoryBuildSeq` — grade, press blocks, lay the slab, raise the columns, set
  the cross members, set the door header, lay the purlins, clad, run the
  power/water spine, fit the stations, commission.
* `factoryBuild_valid`, `factoryBuild_commissions` — the sequence runs, and it
  ends holding a commissioned factory.
* `columns_after_slab`, `spine_after_shelter`, `printer_after_spine` — the
  order, read off the list …
* `columns_need_earlier_slab`, `printer_needs_earlier_spine` — … and the same
  facts as *structural* ones: in **any** valid sequence from a site that has no
  slab (no spine) standing, a step that needs one is preceded by the step that
  erects it.
* `columns_before_slab_fails` — and the swap really is rejected, not merely
  unusual.
* `build_covers_design`, `build_prefixes_grounded` — the build order and the
  design agree: the steps place exactly the bricks of `factoryDesign`, and
  after every step what stands is still grounded, so nothing is ever placed in
  mid-air waiting for its support.
-/

namespace LifeTrac
namespace Factory

open TechTree Net

/-! ## The site on day one -/

/-- What is on a greenfield site before anything is built: the machine set,
hand tools, stock and labour.  Everything else in this file is earned. -/
def siteRaw : ResourceState :=
  { consumables := [("labor", 1000), ("clay", 900), ("water", 300), ("aggregate", 300),
                    ("steel_tube", 80), ("heavy_tube", 4), ("pipe", 60), ("cable", 60),
                    ("sheet", 80)]
    toolsBuilt := ["tractor", "ceb_press", "welder", "genset", "hand_tools"]
    infrastructure := [] }

/-! ## The steps -/

/-- Level the pad and the apron next to it.  What the tractor can level in a
bounded number of passes is what fixes the pad, so this is the first step and
it is the machine's own work. -/
def gradePad : Tech :=
  { id := "grade_pad", tier := .hydraulic
    inputs := [], outputs := []
    tools := ["tractor"], erects := ["pad_graded", "machine_parking", "staging_yard"]
    baseLabor := 60, obsDiscount := 0, humanStep := true }

/-- Press compressed-earth blocks for the slab. -/
def pressBlocks : Tech :=
  { id := "press_blocks", tier := .hydraulic
    inputs := [("clay", 800), ("water", 200)], outputs := [("ceb_block", 500)]
    tools := ["ceb_press", "tractor"], erects := []
    baseLabor := 90, obsDiscount := 0, humanStep := true }

/-- Lay the pad: blocks and aggregate on the graded ground. -/
def laySlab : Tech :=
  { id := "lay_slab", tier := .hydraulic
    inputs := [("ceb_block", 500), ("aggregate", 200)], outputs := []
    tools := ["tractor", "pad_graded"], erects := ["slab"]
    baseLabor := 80, obsDiscount := 0, humanStep := true }

/-- Raise the seventeen columns on the slab. -/
def raiseColumns : Tech :=
  { id := "raise_columns", tier := .hydraulic
    inputs := [("steel_tube", 17)], outputs := []
    tools := ["welder", "tractor", "slab"], erects := ["columns"]
    baseLabor := 100, obsDiscount := 0, humanStep := true }

/-- Set the ten cross members, two to a frame line. -/
def setCrossBeams : Tech :=
  { id := "set_cross_beams", tier := .hydraulic
    inputs := [("steel_tube", 10)], outputs := []
    tools := ["welder", "tractor", "columns"], erects := ["cross_beams"]
    baseLabor := 70, obsDiscount := 0, humanStep := true }

/-- Set the door header: the heavy section, because the door line has no centre
column (`Factory.door_needs_heavy_section`). -/
def setDoorHeader : Tech :=
  { id := "set_door_header", tier := .hydraulic
    inputs := [("heavy_tube", 1)], outputs := []
    tools := ["welder", "tractor", "columns"], erects := ["door_header"]
    baseLabor := 30, obsDiscount := 0, humanStep := true }

/-- Lay the fifteen purlins along the flow. -/
def layPurlins : Tech :=
  { id := "lay_purlins", tier := .hydraulic
    inputs := [("steel_tube", 15)], outputs := []
    tools := ["welder", "tractor", "cross_beams", "door_header"], erects := ["purlins"]
    baseLabor := 60, obsDiscount := 0, humanStep := true }

/-- Clad the roof: from here on the site is under shelter. -/
def cladRoof : Tech :=
  { id := "clad_roof", tier := .hydraulic
    inputs := [("sheet", 80)], outputs := []
    tools := ["purlins", "hand_tools"], erects := ["shelter"]
    baseLabor := 70, obsDiscount := 0, humanStep := true }

/-- Run power and water down one long wall in a single spine. -/
def runSpine : Tech :=
  { id := "run_spine", tier := .hydraulic
    inputs := [("pipe", 60), ("cable", 60)], outputs := []
    tools := ["shelter", "slab", "genset", "hand_tools"]
    erects := ["power_spine", "water_spine"]
    baseLabor := 80, obsDiscount := 0, humanStep := true }

/-- Fit the stock rack at the near end of the flow. -/
def fitStockRack : Tech :=
  { id := "fit_stock_rack", tier := .hydraulic
    inputs := [("steel_tube", 6)], outputs := []
    tools := ["shelter", "welder"], erects := ["stock_rack"]
    baseLabor := 30, obsDiscount := 0, humanStep := true }

/-- Set the press on its footing and tap the spine. -/
def installPress : Tech :=
  { id := "install_press", tier := .hydraulic
    inputs := [("steel_tube", 6)], outputs := []
    tools := ["power_spine", "water_spine", "tractor", "shelter"], erects := ["press_station"]
    baseLabor := 50, obsDiscount := 0, humanStep := true }

/-- Set the cutting station. -/
def installCutting : Tech :=
  { id := "install_cutting", tier := .hydraulic
    inputs := [("steel_tube", 4)], outputs := []
    tools := ["power_spine", "shelter", "tractor"], erects := ["cutting_station"]
    baseLabor := 40, obsDiscount := 0, humanStep := true }

/-- The assembly bench, in the fourth bay. -/
def installAssembly : Tech :=
  { id := "install_assembly", tier := .hydraulic
    inputs := [("steel_tube", 4)], outputs := []
    tools := ["power_spine", "shelter", "tractor"], erects := ["assembly_station"]
    baseLabor := 40, obsDiscount := 0, humanStep := true }

/-- The precision end: printer and circuit work, which the tech tree puts after
shelter and clean power, not before. -/
def installPrinter : Tech :=
  { id := "install_printer", tier := .hydraulic
    inputs := [("steel_tube", 2)], outputs := []
    tools := ["power_spine", "shelter", "press_station", "assembly_station"]
    erects := ["printer_station"]
    baseLabor := 40, obsDiscount := 0, humanStep := true }

/-- Finishing and despatch, at the door end. -/
def installFinishing : Tech :=
  { id := "install_finishing", tier := .hydraulic
    inputs := [("steel_tube", 2)], outputs := []
    tools := ["power_spine", "shelter", "door_header"], erects := ["finishing_station"]
    baseLabor := 30, obsDiscount := 0, humanStep := true }

/-- Commission the shop: every station standing, on the spine, under the
roof. -/
def commission : Tech :=
  { id := "commission", tier := .hydraulic
    inputs := [], outputs := [("factory", 1)]
    tools := ["stock_rack", "press_station", "cutting_station", "assembly_station",
              "printer_station", "finishing_station"], erects := ["factory"]
    baseLabor := 20, obsDiscount := 0, humanStep := true }

/-! ## The sequence -/

/-- The steps up to the printer. -/
def beforePrinter : BootstrapSeq :=
  [ gradePad, pressBlocks, laySlab, raiseColumns, setCrossBeams, setDoorHeader,
    layPurlins, cladRoof, runSpine, fitStockRack, installPress, installCutting,
    installAssembly ]

/-- The steps after the printer. -/
def afterPrinter : BootstrapSeq := [installFinishing, commission]

/-- **The build order.** -/
def factoryBuildSeq : BootstrapSeq := beforePrinter ++ installPrinter :: afterPrinter

/-- The catalogue of steps, for the tier check. -/
def factoryCatalog : List Tech := factoryBuildSeq

/-! ## The sequence runs -/

/-- **The build order is feasible on the site as given.** -/
theorem factoryBuild_valid : ValidSequence factoryBuildSeq siteRaw := by decide

/-- It ends with the shop commissioned. -/
theorem factoryBuild_commissions :
    qty (finalState siteRaw factoryBuildSeq).consumables "factory" = 1 := by decide

/-- Every service the sequence leans on is one it erected itself; the only
things taken for granted are the machine set and the stock on the site. -/
theorem factoryBuild_selfHosting :
    ∀ t ∈ factoryBuildSeq, ∀ tool ∈ t.tools,
      tool ∈ producedIds factoryBuildSeq ∨ tool ∈ siteRaw.toolsBuilt := by
  decide

/-- No step reaches above its tier for a tool. -/
theorem factoryBuild_tier_sound : tierSound factoryCatalog factoryBuildSeq = true := by decide

/-- Every step of the erection needs a person. -/
theorem factoryBuild_all_human : ∀ t ∈ factoryBuildSeq, t.humanStep = true := by decide

/-- The labour the whole build costs. -/
theorem factoryBuild_labor : totalLabor siteRaw factoryBuildSeq = 890 := by decide

/-! ## The order, read off the list -/

/-- Where a step with a given id appears. -/
def buildIndexOf (id : String) : ℕ := (factoryBuildSeq.map Tech.id).idxOf id

theorem columns_after_slab : buildIndexOf "lay_slab" < buildIndexOf "raise_columns" := by decide

theorem beams_after_columns :
    buildIndexOf "raise_columns" < buildIndexOf "set_cross_beams" := by decide

theorem purlins_after_beams :
    buildIndexOf "set_cross_beams" < buildIndexOf "lay_purlins" := by decide

theorem spine_after_shelter : buildIndexOf "clad_roof" < buildIndexOf "run_spine" := by decide

theorem printer_after_spine : buildIndexOf "run_spine" < buildIndexOf "install_printer" := by decide

/-- The press comes before the printer: basic press work first, precision
after, which is the order the bootstrap material already encodes. -/
theorem press_before_printer :
    buildIndexOf "install_press" < buildIndexOf "install_printer" := by decide

/-! ## … and the same order as structural facts -/

/-- **Columns cannot go up before the slab.**  In *any* valid sequence from a
site with no slab standing, a step that raises columns is preceded by the step
that lays it — this is the bootstrap's general ordering theorem, instantiated,
not an observation about this one list. -/
theorem columns_need_earlier_slab
    {before after : BootstrapSeq} {raw : ResourceState}
    (hvalid : ValidSequence (before ++ raiseColumns :: after) raw)
    (hraw : ¬ Avail raw "slab") :
    ∃ u ∈ before, "slab" ∈ u.outputs.map Prod.fst ∨ "slab" ∈ u.erects :=
  tool_needs_earlier_producer hvalid (by decide) hraw

/-- **The printer cannot be installed before the power spine.** -/
theorem printer_needs_earlier_spine
    {before after : BootstrapSeq} {raw : ResourceState}
    (hvalid : ValidSequence (before ++ installPrinter :: after) raw)
    (hraw : ¬ Avail raw "power_spine") :
    ∃ u ∈ before, "power_spine" ∈ u.outputs.map Prod.fst ∨ "power_spine" ∈ u.erects :=
  tool_needs_earlier_producer hvalid (by decide) hraw

/-- **The roof cannot be clad before the purlins are laid.** -/
theorem cladding_needs_earlier_purlins
    {before after : BootstrapSeq} {raw : ResourceState}
    (hvalid : ValidSequence (before ++ cladRoof :: after) raw)
    (hraw : ¬ Avail raw "purlins") :
    ∃ u ∈ before, "purlins" ∈ u.outputs.map Prod.fst ∨ "purlins" ∈ u.erects :=
  tool_needs_earlier_producer hvalid (by decide) hraw

/-- A greenfield site has none of the three standing. -/
theorem siteRaw_has_nothing_standing :
    ¬ Avail siteRaw "slab" ∧ ¬ Avail siteRaw "power_spine" ∧ ¬ Avail siteRaw "purlins" := by
  decide

/-- On this site the printer step is therefore preceded by the spine step. -/
theorem factoryBuild_printer_after_spine_reason :
    ∃ u ∈ beforePrinter, "power_spine" ∈ u.outputs.map Prod.fst ∨ "power_spine" ∈ u.erects :=
  printer_needs_earlier_spine factoryBuild_valid siteRaw_has_nothing_standing.2.1

/-- **And the swap is really rejected**: raising the columns before the slab is
laid does not merely look wrong, it fails the checker. -/
theorem columns_before_slab_fails :
    ¬ ValidSequence
        [gradePad, pressBlocks, raiseColumns, laySlab, setCrossBeams] siteRaw := by
  decide

/-- Likewise the printer before the spine. -/
theorem printer_before_spine_fails :
    ¬ ValidSequence
        [gradePad, pressBlocks, laySlab, raiseColumns, setCrossBeams, setDoorHeader,
         layPurlins, cladRoof, installPrinter] siteRaw := by
  decide

/-! ## The build order and the design agree -/

/-- Which bricks of `factoryDesign` each step puts on the lattice. -/
def stepBricks (id : String) : List Brick :=
  if id = "grade_pad" then [parkingApron, oreStaging]
  else if id = "lay_slab" then [slab]
  else if id = "raise_columns" then columns
  else if id = "set_cross_beams" then crossBeams
  else if id = "set_door_header" then [doorHeader]
  else if id = "lay_purlins" then purlins
  else if id = "run_spine" then [serviceSpine]
  else if id = "fit_stock_rack" then [stockIn]
  else if id = "install_press" then [press]
  else if id = "install_cutting" then [cutting]
  else if id = "install_assembly" then [assembly]
  else if id = "install_finishing" then [finishing]
  else []

/-- The bricks the first `k` steps put down. -/
def buildPrefixBricks (k : ℕ) : List Brick :=
  (factoryBuildSeq.take k).flatMap (fun t => stepBricks t.id)

/-- What stands after the first `k` steps. -/
def buildPrefix (k : ℕ) : Design := (buildPrefixBricks k).toFinset

/-- **The build order places exactly the design** — no member unaccounted for,
none placed twice. -/
theorem build_covers_design :
    buildPrefix factoryBuildSeq.length = factoryDesign ∧
      (buildPrefixBricks factoryBuildSeq.length).length = factoryBricks.length := by
  decide

/-- **Nothing is ever placed in mid-air.**  After every step of the build, what
stands is a grounded design: each brick is on the ground or on a brick that a
previous step (or an earlier brick of the same step) already put there. -/
theorem build_prefixes_grounded :
    ∀ k ≤ factoryBuildSeq.length, Design.Grounded (buildPrefix k) := by decide

/-- **And it never clashes on the way up**: every intermediate state is a legal
design as well, so the editor would accept the build step by step. -/
theorem build_prefixes_clear : ∀ k ≤ factoryBuildSeq.length, Clear (buildPrefix k) := by
  decide +kernel

theorem build_prefixes_valid :
    ∀ k ≤ factoryBuildSeq.length, Design.Valid (buildPrefix k) :=
  fun k hk => valid_of_clear (build_prefixes_clear k hk)

end Factory
end LifeTrac
