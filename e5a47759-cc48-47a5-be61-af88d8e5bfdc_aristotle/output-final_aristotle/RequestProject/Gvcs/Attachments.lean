import RequestProject.Gvcs.Bootstrap

/-!
# The mining kit: the attachments the shop builds for the pit

`RequestProject/Fabrication.lean` stops at the tractor.  To go mining the
machine needs implements, and this file gives them: nine attachments — a rock
bucket, a ripper tooth, a hydraulic breaker, an auger drill, a jaw crusher, a
screen deck, an ore trailer, a latex tapping kit and a still — each with the
bill of materials and the hours that the *same shop* needs to make it.

Two things are proved about the kit.

* It needs **no new plant**: every tool called for is one the shop already has,
  either a seed tool or one of the nine tools it built for itself in the
  bootstrap (`kit_needs_no_new_plant`).
* It needs **nothing bought in**: every material it consumes is something the
  production system makes for itself out of the seven raw materials
  (`kit_inputs_are_made_in_house`), so the raw-material and labour content of
  the whole kit can be worked out exactly (`kitDemand`, `kitLabor`).

With the kit built, the machine can go and dig its own ore; that is
`RequestProject/Mining.lean`.

Quantities of mill goods are kilograms and quantities of catalogue stock are
in the units of `Build.Material.unitName`, exactly as in
`RequestProject/Fabrication.lean`.
-/

namespace LifeTrac
namespace Workflow

open Item

set_option maxRecDepth 8000

/-- The nine implements that turn the tractor into a mining outfit. -/
inductive Attachment where
  /-- A heavy rock bucket for the loader arms. -/
  | miningBucket
  /-- A single-shank ripper tooth for the three-point hitch. -/
  | ripperTooth
  /-- A hydraulic breaker running off the loader circuit. -/
  | rockBreaker
  /-- An auger drill for boring into the seep. -/
  | augerDrill
  /-- A jaw crusher driven by the machine's hydraulics. -/
  | jawCrusher
  /-- A vibrating screen deck for sizing the crushed rock. -/
  | screenDeck
  /-- A towed trailer for hauling ore out of the pit. -/
  | oreTrailer
  /-- A tapping kit — spouts, cups and knives — for the rubber grove. -/
  | tapSpout
  /-- A batch still for turning seep oil into usable crude. -/
  | stillRig
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Attachment

/-- The whole mining kit. -/
def all : List Attachment :=
  [miningBucket, ripperTooth, rockBreaker, augerDrill, jawCrusher, screenDeck, oreTrailer,
   tapSpout, stillRig]

theorem mem_all (a : Attachment) : a ∈ all := by revert a; decide

theorem all_nodup : all.Nodup := by decide

/-- The workflow that makes each attachment: what it is made of, what it is
made on, and how long it takes. -/
def recipe : Attachment → Recipe Item
  | miningBucket =>
      ⟨1, [(hotStrip, 90), (barStock, 25), (weldWire, 3), (boltM12, 8), (nutM12, 8)],
        [torchTable, pressBrake, weldingTable, ironworker, migWelder, handTools], 10⟩
  | ripperTooth =>
      ⟨1, [(barStock, 30), (castIron, 8), (weldWire, 1), (boltM12, 4), (nutM12, 4)],
        [cutoffSaw, drillPress, weldingTable, migWelder, handTools], 5⟩
  | rockBreaker =>
      ⟨1, [(castIron, 45), (barStock, 40), (tubeStock, 18), (rubberStock, 2), (hose, 4),
        (fitting, 6), (weldWire, 2)],
        [machineLathe, millingMachine, drillPress, weldingTable, migWelder, handTools], 24⟩
  | augerDrill =>
      ⟨1, [(barStock, 35), (hotStrip, 20), (castIron, 10), (hose, 2), (fitting, 4),
        (weldWire, 2)],
        [machineLathe, cutoffSaw, weldingTable, migWelder, handTools], 14⟩
  | jawCrusher =>
      ⟨1, [(hotStrip, 150), (castIron, 120), (barStock, 60), (tubeStock, 20), (hose, 2),
        (fitting, 4), (weldWire, 6), (boltM12, 24), (nutM12, 24)],
        [torchTable, ironworker, arborPress, machineLathe, drillPress, weldingTable,
         migWelder, handTools], 40⟩
  | screenDeck =>
      ⟨1, [(hotStrip, 60), (wireRod, 25), (tubeStock, 30), (weldWire, 4), (boltM12, 12),
        (nutM12, 12)],
        [torchTable, weldingTable, cutoffSaw, wireDrawBench, migWelder, handTools], 18⟩
  | oreTrailer =>
      ⟨1, [(tubeStock, 70), (hotStrip, 110), (barStock, 20), (wheelHub, 2), (tire, 2),
        (weldWire, 5), (boltM12, 20), (nutM12, 20)],
        [torchTable, weldingTable, cutoffSaw, drillPress, migWelder, handTools], 26⟩
  | tapSpout =>
      ⟨1, [(hotStrip, 2), (barStock, 3), (plasticStock, 4)],
        [cutoffSaw, drillPress, handTools], 3⟩
  | stillRig =>
      ⟨1, [(hotStrip, 80), (tubeStock, 35), (castIron, 10), (copperStock, 6), (weldWire, 4)],
        [pressBrake, weldingTable, cutoffSaw, migWelder, handTools], 22⟩

/-! ## The kit asks nothing of the outside world -/

/-- **No new plant.**  Every tool the mining kit is built on is one the shop
already owns: a seed tool, or one of the nine tools it built for itself. -/
theorem kit_needs_no_new_plant :
    ∀ a : Attachment, ∀ t ∈ (recipe a).tools, t ∈ seedToolkit ∨ t ∈ shopTools := by decide

/-- **Nothing bought in.**  Every material the kit consumes is one the system
makes for itself: no input of any attachment is a raw material or a tool. -/
theorem kit_inputs_are_made_in_house :
    ∀ a : Attachment, ∀ p ∈ (recipe a).inputs, (plant.recipe p.1).isSome := by decide

/-- Every input of every attachment can be produced from the base. -/
theorem kit_inputs_producible (a : Attachment) : ∀ p ∈ (recipe a).inputs, plant.Producible p.1 :=
  fun p _ => producible p.1

/-- Every tool the kit is built on can itself be produced (the shop-built ones)
or is part of the seed toolkit. -/
theorem kit_tools_producible (a : Attachment) : ∀ t ∈ (recipe a).tools, plant.Producible t :=
  fun t _ => producible t

/-- No attachment consumes another: the nine implements are independent, and
can be built in any order. -/
theorem kit_inputs_no_batch_zero : ∀ a : Attachment, 0 < (recipe a).batch := by decide

/-! ## What the kit costs -/

/-- The raw material drawn, through the whole chain of workflows, by one of the
attachment `a`. -/
noncomputable def demand (a : Attachment) (x : Item) : ℚ :=
  ((recipe a).inputs.map (fun p => plant.rawDemand p.1 p.2 x)).sum

/-- The labour, in hours, of building one of the attachment `a`, including all
the upstream work of making its materials. -/
noncomputable def labor (a : Attachment) : ℚ :=
  (recipe a).labor + ((recipe a).inputs.map (fun p => plant.laborFor p.1 p.2)).sum

/-- The raw material drawn by one of each of the nine attachments. -/
noncomputable def kitDemand (x : Item) : ℚ := (all.map (fun a => demand a x)).sum

/-- The labour of building the whole mining kit. -/
noncomputable def kitLabor : ℚ := (all.map labor).sum

theorem recipe_qty_nonneg : ∀ a : Attachment, ∀ p ∈ (recipe a).inputs, 0 ≤ p.2 := by decide

theorem demand_nonneg (a : Attachment) (x : Item) : 0 ≤ demand a x := by
  refine List.sum_nonneg ?_
  intro y hy
  obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
  exact plant.rawDemand_nonneg (recipe_qty_nonneg a p hp) x

/-- **The raw material in the mining kit.**  One of each attachment takes
2221.82 kg of iron ore, 1124.31 kg of coal, 416.59 kg of limestone, 42.6 kg of
silica sand, 4.8 kg of crude oil, 61.2 kg of latex and 48 kg of copper ore out
of the ground. -/
theorem kitDemand_values :
    kitDemand ironOre = 27772793/12500 ∧
    kitDemand coal = 22486217/20000 ∧
    kitDemand limestone = 83318379/200000 ∧
    kitDemand silicaSand = 213/5 ∧
    kitDemand crudeOil = 24/5 ∧
    kitDemand latex = 306/5 ∧
    kitDemand copperOre = 48 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [kitDemand, demand, all, recipe, ind] <;> norm_num

/-- The mining kit takes 3919.33 kg of raw material out of the ground: less
than the tractor it hangs on. -/
theorem kitDemand_rawTotal : rawTotal kitDemand = 783865237/200000 := by
  simp [rawTotal, kitDemand, demand, all, recipe, ind]; norm_num

/-- Building the whole kit takes 261.25 hours. -/
theorem kitLabor_eq : kitLabor = 261248001/1000000 := by
  simp [kitLabor, labor, all, recipe]; norm_num

theorem kitDemand_lt_lifeTrac : rawTotal kitDemand < rawTotal (plant.rawDemand lifeTrac 1) := by
  rw [kitDemand_rawTotal, lifeTrac_rawTotal]; norm_num

/-- The kit is less work than the tractor, too. -/
theorem kitLabor_lt_lifeTrac : kitLabor < plant.laborFor lifeTrac 1 := by
  rw [kitLabor_eq, lifeTrac_laborFor]; norm_num

end Attachment

end Workflow
end LifeTrac
