import RequestProject.Gvcs.Attachments
import RequestProject.Gvcs.Plan

/-!
# Mining the ore, with nothing but the machines we built

`RequestProject/Fabrication.lean` takes the seven raw materials — iron ore,
coal, limestone, silica sand, crude oil, latex and copper ore — as given: they
are the base of the production system, dug or grown, and the model says
nothing about where they come from.  This file says where they come from.

The pit is a production system in its own right, described with the same
machinery (`Workflow.Plant`) as the shop.  Its base is *the ground*: an ore
body, a coal seam, a limestone ledge, a sand bank, an oil seep, a rubber grove
and a copper lode — together with the equipment standing in the yard.  And the
whole point of the file is what that equipment is:

> **`mining_uses_only_built_devices`** — every tool used by every mining
> workflow is one of the ten devices the bootstrap produced: the LifeTrac
> itself, and the nine attachments of `RequestProject/Attachments.lean`.  No
> seed tool, no bought-in plant, nothing from outside the system appears
> anywhere in the pit.

The rest of the file is quantitative.  Ore is won in three stages where the
ground is hard — rip and load, crush, screen — and in one where it is not, and
each workflow books the hours the tractor spends on it.  From the raw-material
demand of one machine (`RequestProject/Bootstrap.lean`) that gives the tonnage
that has to come out of the ground and the hours of machine time it takes, and
hence the headline of the whole exercise: what it costs a LifeTrac to dig the
materials for the next LifeTrac.

Quantities are kilograms and times are hours; batches are one tonne, so a
`labor` figure of `1/2` means half an hour per tonne, that is two tonnes an
hour.  The rates are illustrative of a small machine in ordinary ground, and
`RequestProject/Excavation.lean` shows what sets them.
-/

namespace LifeTrac
namespace Mining

set_option maxRecDepth 8000

/-- Everything the pit deals in: the deposits, the devices that work them, the
half-finished streams of rock, and the seven raw materials that come out. -/
inductive Item where
  -- the ground: the base of the mining system
  | oreBody | coalSeam | limestoneLedge | sandBank | oilSeep | rubberGrove | copperLode
  -- the devices, every one of them built in the bootstrap
  | tractor | miningBucket | ripperTooth | rockBreaker | augerDrill | jawCrusher
  | screenDeck | oreTrailer | tapSpout | stillRig
  -- intermediate streams
  | ironRock | ironCrushed | copperRock | copperCrushed
  -- the seven raw materials of the production system
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Item

/-- The deposits: what the pit does not make and cannot make. -/
def deposits : List Item :=
  [oreBody, coalSeam, limestoneLedge, sandBank, oilSeep, rubberGrove, copperLode]

/-- The devices the pit works with — the tractor and its nine attachments.
Every one of them is built by the shop of `RequestProject/Fabrication.lean`
and `RequestProject/Attachments.lean`. -/
def devices : List Item :=
  [tractor, miningBucket, ripperTooth, rockBreaker, augerDrill, jawCrusher, screenDeck,
   oreTrailer, tapSpout, stillRig]

/-- The seven raw materials the pit delivers to the shop. -/
def products : List Item :=
  [ironOre, coal, limestone, silicaSand, crudeOil, latex, copperOre]

/-- The attachment of the mining kit corresponding to a device (the tractor
itself excepted). -/
def ofAttachment : Workflow.Attachment → Item
  | .miningBucket => miningBucket
  | .ripperTooth => ripperTooth
  | .rockBreaker => rockBreaker
  | .augerDrill => augerDrill
  | .jawCrusher => jawCrusher
  | .screenDeck => screenDeck
  | .oreTrailer => oreTrailer
  | .tapSpout => tapSpout
  | .stillRig => stillRig

theorem ofAttachment_injective : Function.Injective ofAttachment := by decide

/-- **The devices are exactly the tractor and the mining kit.**  Nothing else
stands in the yard. -/
theorem devices_eq : devices = tractor :: Workflow.Attachment.all.map ofAttachment := by decide

end Item

open Item

/-! ## The workflows of the pit

Rip and load, crush, screen; tap the grove; drill and still the seep.  Every
batch is one tonne, so the labour figure is hours per tonne. -/

/-- The workflow that wins each item, if the pit wins it at all.  `none` marks
the base: the deposits themselves, and the devices, which are not made in the
pit but built in the shop beforehand. -/
def recipe : Item → Option (Workflow.Recipe Item)
  -- the ground, and the equipment: the base of the mining system
  | oreBody | coalSeam | limestoneLedge | sandBank | oilSeep | rubberGrove | copperLode => none
  | tractor | miningBucket | ripperTooth | rockBreaker | augerDrill | jawCrusher
  | screenDeck | oreTrailer | tapSpout | stillRig => none
  -- iron: rip the face, crush it, screen the crushed rock to a concentrate
  | ironRock =>
      some ⟨1000, [(oreBody, 1000)],
        [tractor, ripperTooth, rockBreaker, miningBucket, oreTrailer], 1/2⟩
  | ironCrushed => some ⟨1000, [(ironRock, 1050)], [tractor, jawCrusher], 2/5⟩
  | ironOre => some ⟨1000, [(ironCrushed, 1250)], [tractor, screenDeck, oreTrailer], 1/5⟩
  -- copper: the same three stages in harder ground and at a poorer yield
  | copperRock =>
      some ⟨1000, [(copperLode, 1000)],
        [tractor, ripperTooth, rockBreaker, miningBucket, oreTrailer], 3/5⟩
  | copperCrushed => some ⟨1000, [(copperRock, 1050)], [tractor, jawCrusher], 2/5⟩
  | copperOre => some ⟨1000, [(copperCrushed, 1200)], [tractor, screenDeck, oreTrailer], 1/5⟩
  -- coal is soft: rip it and load it straight into the trailer
  | coal => some ⟨1000, [(coalSeam, 1100)], [tractor, ripperTooth, miningBucket, oreTrailer], 2/5⟩
  -- limestone is ripped and crushed but needs no screening
  | limestone =>
      some ⟨1000, [(limestoneLedge, 1150)],
        [tractor, ripperTooth, miningBucket, jawCrusher, oreTrailer], 3/5⟩
  -- sand is simply dug and screened
  | silicaSand =>
      some ⟨1000, [(sandBank, 1300)], [tractor, miningBucket, screenDeck, oreTrailer], 3/10⟩
  -- the seep is drilled and the oil run through the still
  | crudeOil => some ⟨1000, [(oilSeep, 1400)], [tractor, augerDrill, stillRig, oreTrailer], 5⟩
  -- the grove is tapped by hand, with the tractor hauling the cups
  | latex => some ⟨1000, [(rubberGrove, 1050)], [tractor, tapSpout, oreTrailer], 20⟩

/-- How far along the pit an item sits. -/
def rank : Item → ℕ
  | oreBody | coalSeam | limestoneLedge | sandBank | oilSeep | rubberGrove | copperLode => 0
  | tractor | miningBucket | ripperTooth | rockBreaker | augerDrill | jawCrusher
  | screenDeck | oreTrailer | tapSpout | stillRig => 0
  | ironRock | copperRock => 1
  | ironCrushed | copperCrushed => 2
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre => 3

/-- **The pit, as a production system.**  The workflows together with the
certificate that they are not circular. -/
def plant : Workflow.Plant Item where
  recipe := recipe
  rank := rank
  batch_pos := by
    intro i r h
    cases i <;> simp only [recipe] at h <;>
      first
        | (injection h with h'; subst h'; norm_num)
        | exact absurd h (by simp)
  qty_nonneg := by
    intro i r h
    cases i <;> simp only [recipe] at h <;>
      first
        | (injection h with h'; subst h'; norm_num)
        | exact absurd h (by simp)
  labor_nonneg := by
    intro i r h
    cases i <;> simp only [recipe] at h <;>
      first
        | (injection h with h'; subst h'; norm_num)
        | exact absurd h (by simp)
  rank_input := by decide
  rank_tool := by decide

@[simp] theorem plant_recipe : plant.recipe = recipe := rfl

@[simp] theorem plant_rank : plant.rank = rank := rfl

/-! ## Only the devices we built -/

/-- **The headline.**  Every tool used by every workflow in the pit is one of
the ten devices the bootstrap produced: the LifeTrac itself, or one of the
nine attachments the shop built for it. -/
theorem mining_uses_only_built_devices (i : Item) (r : Workflow.Recipe Item)
    (h : plant.recipe i = some r) : ∀ t ∈ r.tools, t ∈ devices := by
  revert i r h; decide

/-- No deposit is ever used as a tool, and no stream of rock: the pit is
worked entirely with machines. -/
theorem tools_are_not_material (i : Item) (r : Workflow.Recipe Item)
    (h : plant.recipe i = some r) : ∀ t ∈ r.tools, t ∉ deposits ∧ t ∉ products := by
  revert i r h; decide

/-- **The tractor does all the work.**  Every single workflow of the pit needs
the machine itself. -/
theorem every_workflow_uses_the_tractor (i : Item) (r : Workflow.Recipe Item)
    (h : plant.recipe i = some r) : tractor ∈ r.tools := by
  revert i r h; decide

/-- No device is ever consumed: the kit is used, not used up. -/
theorem devices_not_consumed (i : Item) (r : Workflow.Recipe Item)
    (h : plant.recipe i = some r) : ∀ p ∈ r.inputs, p.1 ∉ devices := by
  revert i r h; decide

/-- The pit satisfies the standing hypothesis of the plan theory. -/
theorem plant_toolsNotConsumed : plant.ToolsNotConsumed := by
  intro t ht j r hj p hp
  obtain ⟨k, rk, hk, htk⟩ := ht
  have h1 : t ∈ devices := mining_uses_only_built_devices k rk hk t htk
  have h2 : p.1 ∉ devices := devices_not_consumed j r hj p hp
  rintro rfl
  exact h2 h1

/-! ## The base of the pit -/

/-- **The pit is based on the ground and on the kit, and on nothing else.** -/
theorem base_eq (i : Item) : plant.recipe i = none ↔ i ∈ deposits ∨ i ∈ devices := by
  revert i; decide

/-- Nothing makes a deposit. -/
theorem deposits_base : ∀ i ∈ deposits, plant.recipe i = none := by decide

/-- The pit does not make its own machines; the shop does. -/
theorem devices_base : ∀ i ∈ devices, plant.recipe i = none := by decide

/-- Every one of the seven raw materials is won by the pit. -/
theorem products_have_recipe : ∀ i ∈ products, (plant.recipe i).isSome := by decide

/-- **Everything the pit delivers can be got out of the ground with the kit.** -/
theorem producible (i : Item) : plant.Producible i := plant.producible i

/-! ## What has to come out of the ground -/

/-- The mass of ground worked in a demand vector: all deposits are measured in
kilograms, so they may simply be added up. -/
def groundTotal (d : Item → ℚ) : ℚ :=
  d oreBody + d coalSeam + d limestoneLedge + d sandBank + d oilSeep + d rubberGrove +
    d copperLode

/-- `ind i x` is `1` when `x` is `i` and `0` otherwise. -/
def ind (i x : Item) : ℚ := if x = i then 1 else 0

@[simp] theorem ind_self (i : Item) : ind i i = 1 := by simp [ind]

/-! ### The deposit content and the machine time of each product

Each lemma follows the workflows back to the ground; nothing is postulated. -/

@[simp] theorem rd_oreBody (q : ℚ) (x : Item) : plant.rawDemand oreBody q x = q * ind oreBody x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = oreBody <;> simp [h]

@[simp] theorem rd_coalSeam (q : ℚ) (x : Item) :
    plant.rawDemand coalSeam q x = q * ind coalSeam x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = coalSeam <;> simp [h]

@[simp] theorem rd_limestoneLedge (q : ℚ) (x : Item) :
    plant.rawDemand limestoneLedge q x = q * ind limestoneLedge x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = limestoneLedge <;> simp [h]

@[simp] theorem rd_sandBank (q : ℚ) (x : Item) :
    plant.rawDemand sandBank q x = q * ind sandBank x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = sandBank <;> simp [h]

@[simp] theorem rd_oilSeep (q : ℚ) (x : Item) :
    plant.rawDemand oilSeep q x = q * ind oilSeep x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = oilSeep <;> simp [h]

@[simp] theorem rd_rubberGrove (q : ℚ) (x : Item) :
    plant.rawDemand rubberGrove q x = q * ind rubberGrove x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = rubberGrove <;> simp [h]

@[simp] theorem rd_copperLode (q : ℚ) (x : Item) :
    plant.rawDemand copperLode q x = q * ind copperLode x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = copperLode <;> simp [h]

@[simp] theorem lf_oreBody (q : ℚ) : plant.laborFor oreBody q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]

@[simp] theorem lf_coalSeam (q : ℚ) : plant.laborFor coalSeam q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]

@[simp] theorem lf_limestoneLedge (q : ℚ) : plant.laborFor limestoneLedge q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]

@[simp] theorem lf_sandBank (q : ℚ) : plant.laborFor sandBank q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]

@[simp] theorem lf_oilSeep (q : ℚ) : plant.laborFor oilSeep q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]

@[simp] theorem lf_rubberGrove (q : ℚ) : plant.laborFor rubberGrove q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]

@[simp] theorem lf_copperLode (q : ℚ) : plant.laborFor copperLode q = 0 := by
  rw [Workflow.Plant.laborFor_eq]; simp [plant_recipe, recipe]


/-! ### The three-stage iron circuit -/

@[simp] theorem rd_ironRock (q : ℚ) (x : Item) :
    plant.rawDemand ironRock q x = q * (1 * ind oreBody x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_oreBody]
  ring

@[simp] theorem lf_ironRock (q : ℚ) : plant.laborFor ironRock q = q * (1/2000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_oreBody]
  ring

@[simp] theorem rd_ironCrushed (q : ℚ) (x : Item) :
    plant.rawDemand ironCrushed q x = q * (21/20 * ind oreBody x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_ironRock]
  ring

@[simp] theorem lf_ironCrushed (q : ℚ) : plant.laborFor ironCrushed q = q * (37/40000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_ironRock]
  ring

/-- **One kilogram of iron ore takes 1.3125 kg out of the ore body**: five per
cent is lost as fines in the crusher and a fifth is rejected on the screen. -/
@[simp] theorem rd_ironOre (q : ℚ) (x : Item) :
    plant.rawDemand ironOre q x = q * (21/16 * ind oreBody x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_ironCrushed]
  ring

/-- Ripping, crushing and screening a tonne of iron ore is 1.356 hours of
machine time. -/
@[simp] theorem lf_ironOre (q : ℚ) : plant.laborFor ironOre q = q * (217/160000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_ironCrushed]
  ring

/-! ### The copper circuit -/

@[simp] theorem rd_copperRock (q : ℚ) (x : Item) :
    plant.rawDemand copperRock q x = q * (1 * ind copperLode x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_copperLode]
  ring

@[simp] theorem lf_copperRock (q : ℚ) : plant.laborFor copperRock q = q * (3/5000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_copperLode]
  ring

@[simp] theorem rd_copperCrushed (q : ℚ) (x : Item) :
    plant.rawDemand copperCrushed q x = q * (21/20 * ind copperLode x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_copperRock]
  ring

@[simp] theorem lf_copperCrushed (q : ℚ) : plant.laborFor copperCrushed q = q * (103/100000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_copperRock]
  ring

@[simp] theorem rd_copperOre (q : ℚ) (x : Item) :
    plant.rawDemand copperOre q x = q * (63/50 * ind copperLode x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_copperCrushed]
  ring

@[simp] theorem lf_copperOre (q : ℚ) : plant.laborFor copperOre q = q * (359/250000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_copperCrushed]
  ring

/-! ### The single-stage workings -/

@[simp] theorem rd_coal (q : ℚ) (x : Item) :
    plant.rawDemand coal q x = q * (11/10 * ind coalSeam x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_coalSeam]
  ring

@[simp] theorem lf_coal (q : ℚ) : plant.laborFor coal q = q * (1/2500) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_coalSeam]
  ring

@[simp] theorem rd_limestone (q : ℚ) (x : Item) :
    plant.rawDemand limestone q x = q * (23/20 * ind limestoneLedge x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_limestoneLedge]
  ring

@[simp] theorem lf_limestone (q : ℚ) : plant.laborFor limestone q = q * (3/5000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_limestoneLedge]
  ring

@[simp] theorem rd_silicaSand (q : ℚ) (x : Item) :
    plant.rawDemand silicaSand q x = q * (13/10 * ind sandBank x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_sandBank]
  ring

@[simp] theorem lf_silicaSand (q : ℚ) : plant.laborFor silicaSand q = q * (3/10000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_sandBank]
  ring

@[simp] theorem rd_crudeOil (q : ℚ) (x : Item) :
    plant.rawDemand crudeOil q x = q * (7/5 * ind oilSeep x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_oilSeep]
  ring

@[simp] theorem lf_crudeOil (q : ℚ) : plant.laborFor crudeOil q = q * (1/200) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_oilSeep]
  ring

@[simp] theorem rd_latex (q : ℚ) (x : Item) :
    plant.rawDemand latex q x = q * (21/20 * ind rubberGrove x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_rubberGrove]
  ring

/-- **Tapping is the slow job**: a tonne of dry latex is twenty hours' work,
against half an hour for a tonne of run-of-mine rock. -/
@[simp] theorem lf_latex (q : ℚ) : plant.laborFor latex q = q * (1/50) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_rubberGrove]
  ring

/-! ## Every product comes out of exactly one deposit -/

/-- A deposit's indicator vanishes away from the deposits. -/
theorem ind_eq_zero_of_not_mem {d x : Item} (hd : d ∈ deposits) (hx : x ∉ deposits) :
    ind d x = 0 := by
  simp only [ind, ite_eq_right_iff]
  rintro rfl
  exact absurd hd hx

/-- The demand of an order for one of the seven raw materials is carried
entirely by the deposits: no device and nothing the pit makes appears in it. -/
theorem rawDemand_supported_on_deposits (i : Item) (hi : i ∈ products) (q : ℚ) (x : Item)
    (hx : x ∉ deposits) : plant.rawDemand i q x = 0 := by
  have h1 := ind_eq_zero_of_not_mem (d := oreBody) (by decide) hx
  have h2 := ind_eq_zero_of_not_mem (d := coalSeam) (by decide) hx
  have h3 := ind_eq_zero_of_not_mem (d := limestoneLedge) (by decide) hx
  have h4 := ind_eq_zero_of_not_mem (d := sandBank) (by decide) hx
  have h5 := ind_eq_zero_of_not_mem (d := oilSeep) (by decide) hx
  have h6 := ind_eq_zero_of_not_mem (d := rubberGrove) (by decide) hx
  have h7 := ind_eq_zero_of_not_mem (d := copperLode) (by decide) hx
  fin_cases hi <;> simp [h1, h2, h3, h4, h5, h6, h7]

/-- **More comes out of the ground than goes to the shop.**  Every tonne of
finished raw material costs strictly more than a tonne of deposit: the
difference is fines, screen rejects, still bottoms and the water in the
latex. -/
theorem groundTotal_gt_one (i : Item) (hi : i ∈ products) (q : ℚ) (hq : 0 < q) :
    q < groundTotal (plant.rawDemand i q) := by
  fin_cases hi <;> · simp [groundTotal, ind]; linarith

end Mining
end LifeTrac
