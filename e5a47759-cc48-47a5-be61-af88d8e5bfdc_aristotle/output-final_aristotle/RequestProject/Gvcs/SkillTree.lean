import RequestProject.Gvcs.Sources

set_option maxRecDepth 100000

/-!
# The skill tree

A workshop that starts with nothing cannot choose freely between energy
sources.  It can light a fire on the first day; it can burn charcoal as soon
as it can cut wood; it can raise steam once it can cast and machine; it cannot
make a photovoltaic cell until it can make glass, refine silicon and dope a
semiconductor — and each of those rests on everything below it.  This file
makes that ordering precise.

A `Skill` is a capability of the shop.  `prereqs` says what each skill rests
on directly, and `depth` certifies that the dependency graph has no cycles.
On top of that:

* `learn_all` — a body of knowledge that is closed under the tree (whenever
  you have the prerequisites of a skill, you have the skill) contains
  everything: nothing in the tree is unreachable from bare ground.
* `needs` — the transitive prerequisites of a skill, given as data and
  *certified*: it contains the direct prerequisites (`needs_prereqs`), it is
  closed (`needs_saturated`), it contains nothing extraneous
  (`needs_generated`), and no skill needs itself (`needs_irrefl`).
* `learnOrder` — an order in which all twenty-six skills can actually be
  learned, proved complete, duplicate-free, and consistent with the tree.
* `bootstrapSkills` — the skills the LifeTrac shop of
  `RequestProject/Fabrication.lean` actually uses.  Every workflow of the
  production system falls inside it (`every_workflow_within_bootstrapSkills`),
  it is closed downwards, and it contains **no** photovoltaic skill: the
  machine can be built, and the shop run on wood, by a workshop that has never
  heard of a semiconductor (`tractor_without_solar`, `wood_sources_available`,
  `solar_not_available`).

The dividing line runs through electricity: the first generator must be turned
by a wood-fired engine (`first_watt_is_wood`), and solar cells are downstream
of that generator, so **wood comes before sunlight** whatever else happens
(`wood_before_solar`).
-/

namespace LifeTrac
namespace Skills

open Workflow
open EnergySupply

/-- A capability of the workshop. -/
inductive Skill where
  | fire | woodcraft | charcoalBurning | refractoryClay | copperSmelting | glassMaking
  | ironSmelting | blacksmithing | casting | mining | steelMaking | woodGas | machining
  | rolling | oilRefining | steamPower | wireDrawing | electricity | internalCombustion
  | rubberProcessing | arcWelding | hydraulics | siliconRefining | semiconductors
  | tractorBuilding | photovoltaics
  -- the digital branch, and the machine that prints and the machine that thinks
  | electricMotors | polymerExtrusion | photolithography | digitalLogic | integratedCircuits
  | microcontrollers | memoryFabrication | microprocessor | precisionMotion | printer3D
  | computer | programming | proofChecking
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Skill

/-- What each skill rests on directly. -/
def prereqs : Skill → List Skill
  | fire => []
  | woodcraft => []
  | charcoalBurning => [fire, woodcraft]
  | refractoryClay => [fire]
  | copperSmelting => [charcoalBurning, refractoryClay]
  | glassMaking => [fire, refractoryClay]
  | ironSmelting => [charcoalBurning, refractoryClay]
  | blacksmithing => [ironSmelting]
  | casting => [ironSmelting, refractoryClay]
  | mining => [blacksmithing]
  | steelMaking => [ironSmelting, blacksmithing]
  | woodGas => [charcoalBurning, blacksmithing, casting]
  | machining => [steelMaking, casting]
  | rolling => [steelMaking, blacksmithing]
  | oilRefining => [refractoryClay, machining, steelMaking]
  | steamPower => [casting, machining, blacksmithing]
  | wireDrawing => [rolling, machining]
  | electricity => [copperSmelting, wireDrawing, steamPower]
  | internalCombustion => [casting, machining, oilRefining]
  | rubberProcessing => [machining, steamPower]
  | arcWelding => [electricity, machining]
  | hydraulics => [machining, rubberProcessing, oilRefining]
  | siliconRefining => [glassMaking, charcoalBurning, electricity, mining]
  | semiconductors => [siliconRefining, machining, electricity]
  | tractorBuilding => [hydraulics, arcWelding, internalCombustion, rolling, mining]
  | photovoltaics => [semiconductors, glassMaking, copperSmelting]
  | electricMotors => [electricity, wireDrawing, machining]
  | polymerExtrusion => [oilRefining, rubberProcessing, machining]
  | photolithography => [semiconductors, glassMaking, oilRefining]
  | digitalLogic => [semiconductors, electricity]
  | integratedCircuits => [photolithography, digitalLogic, wireDrawing]
  | microcontrollers => [integratedCircuits, digitalLogic]
  | memoryFabrication => [integratedCircuits, digitalLogic]
  | microprocessor => [integratedCircuits, memoryFabrication, digitalLogic]
  | precisionMotion => [machining, electricMotors, microcontrollers]
  | printer3D => [polymerExtrusion, precisionMotion, microcontrollers, arcWelding]
  | computer => [microprocessor, memoryFabrication, electricity, printer3D]
  | programming => [computer, digitalLogic]
  | proofChecking => [programming, computer]

/-- How far up the tree a skill sits. -/
def depth : Skill → ℕ
  | fire => 0
  | woodcraft => 0
  | charcoalBurning => 1
  | refractoryClay => 1
  | copperSmelting => 2
  | glassMaking => 2
  | ironSmelting => 2
  | blacksmithing => 3
  | casting => 3
  | mining => 4
  | steelMaking => 4
  | woodGas => 4
  | machining => 5
  | rolling => 5
  | oilRefining => 6
  | steamPower => 6
  | wireDrawing => 6
  | electricity => 7
  | internalCombustion => 7
  | rubberProcessing => 7
  | arcWelding => 8
  | hydraulics => 8
  | siliconRefining => 8
  | semiconductors => 9
  | tractorBuilding => 9
  | photovoltaics => 10
  | electricMotors => 8
  | polymerExtrusion => 8
  | photolithography => 10
  | digitalLogic => 10
  | integratedCircuits => 11
  | microcontrollers => 12
  | memoryFabrication => 12
  | microprocessor => 13
  | precisionMotion => 13
  | printer3D => 14
  | computer => 15
  | programming => 16
  | proofChecking => 17

/-- **The tree has no cycles**: every prerequisite sits strictly lower. -/
theorem prereq_depth_lt : ∀ s : Skill, ∀ p ∈ prereqs s, depth p < depth s := by decide

/-- No skill is its own prerequisite. -/
theorem not_prereq_self (s : Skill) : s ∉ prereqs s := fun h =>
  absurd (prereq_depth_lt s s h) (lt_irrefl _)

/-- Strong induction along the tree. -/
theorem strong_depth_induction {M : Skill → Prop}
    (h : ∀ s, (∀ p, depth p < depth s → M p) → M s) : ∀ s, M s := by
  have key : ∀ n s, depth s < n → M s := by
    intro n
    induction n with
    | zero => intro s hs; exact absurd hs (Nat.not_lt_zero _)
    | succ n ih =>
        intro s hs
        exact h s fun p hp => ih p (by omega)
  intro s
  exact key (depth s + 1) s (Nat.lt_succ_self _)

/-- **Nothing in the tree is out of reach.**  A body of knowledge that closes
under the tree — whatever you have the prerequisites for, you have — contains
every skill.  Starting from bare ground, everything can be learned. -/
theorem learn_all {K : Skill → Prop} (hK : ∀ s, (∀ p ∈ prereqs s, K p) → K s) : ∀ s, K s := by
  refine strong_depth_induction (M := K) fun s ih => hK s fun p hp => ih p ?_
  exact prereq_depth_lt s p hp

/-- The skills learnable from nothing, as an inductive predicate. -/
inductive Learned : Skill → Prop
  | learn {s : Skill} : (∀ p ∈ prereqs s, Learned p) → Learned s

theorem learned (s : Skill) : Learned s := learn_all (fun _ h => .learn h) s

/-! ## The transitive prerequisites -/

/-- Everything a skill rests on, directly or indirectly.  Certified by
`needs_prereqs`, `needs_saturated` and `needs_generated` below. -/
def needs : Skill → List Skill
  | fire => []
  | woodcraft => []
  | charcoalBurning => [fire, woodcraft]
  | refractoryClay => [fire]
  | copperSmelting => [fire, woodcraft, charcoalBurning, refractoryClay]
  | glassMaking => [fire, refractoryClay]
  | ironSmelting => [fire, woodcraft, charcoalBurning, refractoryClay]
  | blacksmithing => [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting]
  | casting => [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting]
  | mining => [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing]
  | steelMaking => [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing]
  | woodGas =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting]
  | machining =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking]
  | rolling =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, steelMaking]
  | oilRefining =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining]
  | steamPower =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining]
  | wireDrawing =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining, rolling]
  | electricity =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, ironSmelting,
        blacksmithing, casting, steelMaking, machining, rolling, steamPower, wireDrawing]
  | internalCombustion =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining, oilRefining]
  | rubberProcessing =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining, steamPower]
  | arcWelding =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, ironSmelting,
        blacksmithing, casting, steelMaking, machining, rolling, steamPower, wireDrawing,
        electricity]
  | hydraulics =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining, oilRefining, steamPower, rubberProcessing]
  | siliconRefining =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, steamPower, wireDrawing,
        electricity]
  | semiconductors =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, steamPower, wireDrawing,
        electricity, siliconRefining]
  | tractorBuilding =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, internalCombustion, rubberProcessing, arcWelding, hydraulics]
  | photovoltaics =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, steamPower, wireDrawing,
        electricity, siliconRefining, semiconductors]
  | electricMotors =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, ironSmelting,
        blacksmithing, casting, steelMaking, machining, rolling, steamPower, wireDrawing,
        electricity]
  | polymerExtrusion =>
      [fire, woodcraft, charcoalBurning, refractoryClay, ironSmelting, blacksmithing, casting,
        steelMaking, machining, oilRefining, steamPower, rubberProcessing]
  | photolithography =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, siliconRefining, semiconductors]
  | digitalLogic =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, steamPower, wireDrawing,
        electricity, siliconRefining, semiconductors]
  | integratedCircuits =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, siliconRefining, semiconductors, photolithography, digitalLogic]
  | microcontrollers =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, siliconRefining, semiconductors, photolithography, digitalLogic,
        integratedCircuits]
  | memoryFabrication =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, siliconRefining, semiconductors, photolithography, digitalLogic,
        integratedCircuits]
  | microprocessor =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, siliconRefining, semiconductors, photolithography, digitalLogic,
        integratedCircuits, memoryFabrication]
  | precisionMotion =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, siliconRefining, electricMotors, semiconductors,
        photolithography, digitalLogic, integratedCircuits, microcontrollers]
  | printer3D =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, rubberProcessing, arcWelding, siliconRefining, electricMotors,
        polymerExtrusion, semiconductors, photolithography, digitalLogic, integratedCircuits,
        microcontrollers, precisionMotion]
  | computer =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, rubberProcessing, arcWelding, siliconRefining, electricMotors,
        polymerExtrusion, semiconductors, photolithography, digitalLogic, integratedCircuits,
        microcontrollers, memoryFabrication, microprocessor, precisionMotion, printer3D]
  | programming =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, rubberProcessing, arcWelding, siliconRefining, electricMotors,
        polymerExtrusion, semiconductors, photolithography, digitalLogic, integratedCircuits,
        microcontrollers, memoryFabrication, microprocessor, precisionMotion, printer3D, computer]
  | proofChecking =>
      [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
        blacksmithing, casting, mining, steelMaking, machining, rolling, oilRefining, steamPower,
        wireDrawing, electricity, rubberProcessing, arcWelding, siliconRefining, electricMotors,
        polymerExtrusion, semiconductors, photolithography, digitalLogic, integratedCircuits,
        microcontrollers, memoryFabrication, microprocessor, precisionMotion, printer3D, computer,
        programming]

/-- The direct prerequisites are among the transitive ones. -/
theorem needs_prereqs : ∀ s : Skill, ∀ p ∈ prereqs s, p ∈ needs s := by decide

/-- The transitive prerequisites are closed: whatever they rest on is there
too. -/
theorem needs_saturated : ∀ s : Skill, ∀ p ∈ needs s, ∀ q ∈ prereqs p, q ∈ needs s := by decide

/-- Nothing extraneous: everything in `needs s` is a prerequisite of `s` or is
needed by one. -/
theorem needs_generated :
    ∀ s : Skill, ∀ p ∈ needs s, ∃ q ∈ prereqs s, p = q ∨ p ∈ needs q := by decide

/-- **No skill needs itself.** -/
theorem needs_irrefl : ∀ s : Skill, s ∉ needs s := by decide

/-- Everything a skill needs sits strictly lower in the tree. -/
theorem depth_lt_of_mem_needs : ∀ s : Skill, ∀ p ∈ needs s, depth p < depth s := by decide

/-- **A body of knowledge closed under the tree contains everything its
members need.**  You cannot hold a skill honestly without holding all of its
prerequisites. -/
theorem needs_subset_of_closed (K : Skill → Prop) (hK : ∀ s, K s → ∀ p ∈ prereqs s, K p) :
    ∀ s, K s → ∀ p ∈ needs s, K p := by
  refine strong_depth_induction (M := fun s => K s → ∀ p ∈ needs s, K p) ?_
  intro s ih hs p hp
  obtain ⟨q, hq, hpq⟩ := needs_generated s p hp
  have hKq : K q := hK s hs q hq
  rcases hpq with rfl | hpq
  · exact hKq
  · exact ih q (prereq_depth_lt s q hq) hKq p hpq

/-! ## An order in which to learn everything -/

/-- One order in which the whole tree can be climbed. -/
def learnOrder : List Skill :=
  [fire, woodcraft, charcoalBurning, refractoryClay, copperSmelting, glassMaking, ironSmelting,
   blacksmithing, casting, mining, steelMaking, woodGas, machining, rolling, oilRefining,
   steamPower, wireDrawing, electricity, internalCombustion, rubberProcessing, arcWelding,
   hydraulics, siliconRefining, electricMotors, polymerExtrusion, semiconductors,
   tractorBuilding, photovoltaics, photolithography, digitalLogic, integratedCircuits,
   microcontrollers, memoryFabrication, microprocessor, precisionMotion, printer3D, computer,
   programming, proofChecking]

theorem learnOrder_nodup : learnOrder.Nodup := by decide

theorem learnOrder_complete : ∀ s : Skill, s ∈ learnOrder := by decide

theorem learnOrder_length : learnOrder.length = 39 := by decide

/-- **The order is a real curriculum**: nothing is taught before what it rests
on. -/
theorem learnOrder_sound :
    ∀ s : Skill, ∀ p ∈ prereqs s, learnOrder.idxOf p < learnOrder.idxOf s := by decide

/-! ## Where the energy sources sit in the tree -/

/-- The ways the shop can make energy. -/
inductive Source where
  | openFire | charcoalRetort | woodGasEngine | steamEngine | solarArray
  deriving DecidableEq, Repr, Fintype, Inhabited

/-- The skill each energy source is unlocked by. -/
def Source.skill : Source → Skill
  | .openFire => fire
  | .charcoalRetort => charcoalBurning
  | .woodGasEngine => woodGas
  | .steamEngine => steamPower
  | .solarArray => photovoltaics

/-- The sources that burn wood. -/
def woodSources : List Source := [.openFire, .charcoalRetort, .woodGasEngine, .steamEngine]

/-- A source can be run by a workshop that knows the skill it needs and
everything that skill rests on. -/
def Source.available (K : List Skill) (src : Source) : Prop :=
  src.skill ∈ K ∧ ∀ p ∈ needs src.skill, p ∈ K

instance (K : List Skill) (src : Source) : Decidable (src.available K) := by
  unfold Source.available; infer_instance

/-- **Sunlight is the deepest thing in the tree.**  Photovoltaics sits at
depth ten; every wood-burning source sits at six or less. -/
theorem woodSources_shallow :
    ∀ src ∈ woodSources, depth src.skill < depth Source.solarArray.skill := by decide

/-- **The first watt is a wood-fired watt.**  Electricity rests on steam
power, which burns wood, and every semiconductor skill rests on
electricity. -/
theorem first_watt_is_wood :
    steamPower ∈ needs electricity ∧ electricity ∈ needs siliconRefining ∧
      electricity ∈ needs photovoltaics := by decide

/-- **Wood comes before sunlight.**  Everything a wood-fired steam set needs
is needed by a solar cell as well, and a solar cell needs seven things more —
so no development path reaches photovoltaics without passing through
wood. -/
theorem wood_before_solar :
    (∀ p ∈ steamPower :: needs steamPower, p ∈ needs photovoltaics) ∧
      glassMaking ∈ needs photovoltaics ∧ glassMaking ∉ needs steamPower := by decide

/-- Solar cells rest on fire and on charcoal: even the silicon is reduced with
carbon. -/
theorem solar_needs_charcoal :
    fire ∈ needs photovoltaics ∧ charcoalBurning ∈ needs photovoltaics ∧
      charcoalBurning ∈ needs siliconRefining := by decide

/-! ## The skills the LifeTrac shop actually uses -/

/-- The knowledge the workshop of `RequestProject/Fabrication.lean` needs: how
to build the tractor, everything that rests on, and the wood gas plant that
runs the shop. -/
def bootstrapSkills : List Skill := tractorBuilding :: woodGas :: needs tractorBuilding

theorem bootstrapSkills_length : bootstrapSkills.length = 22 := by decide

theorem bootstrapSkills_nodup : bootstrapSkills.Nodup := by decide

/-- The shop's knowledge is honest: it contains everything it rests on. -/
theorem bootstrapSkills_closed :
    ∀ s ∈ bootstrapSkills, ∀ p ∈ prereqs s, p ∈ bootstrapSkills := by decide

/-- **The tractor can be built without solar cells.**  None of the
photovoltaic chain is in the shop's knowledge. -/
theorem tractor_without_solar :
    photovoltaics ∉ bootstrapSkills ∧ semiconductors ∉ bootstrapSkills ∧
      siliconRefining ∉ bootstrapSkills ∧ glassMaking ∉ bootstrapSkills := by decide

/-- **Every wood-burning source is available to that shop.** -/
theorem wood_sources_available : ∀ src ∈ woodSources, src.available bootstrapSkills := by decide

/-- **The solar array is not.**  Photovoltaics is exactly the capability the
bootstrap lacks. -/
theorem solar_not_available : ¬ Source.solarArray.available bootstrapSkills := by decide

/-- To add solar to the shop, four skills have to be learned, and no more:
glass making, silicon refining, semiconductors and photovoltaics. -/
theorem solar_gap :
    ∀ p ∈ photovoltaics :: needs photovoltaics,
      p ∈ bootstrapSkills ∨
        p ∈ [glassMaking, siliconRefining, semiconductors, photovoltaics] := by decide

/-! ## Every workflow of the production system is inside the tree -/

open Workflow.Item

/-- The skill each item of the production system is made by — for the raw
materials, the skill needed to win them; for the seed tools, the skill needed
to work them. -/
def skillOf : Workflow.Item → Skill
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre => mining
  | cokeOven => charcoalBurning
  | blastFurnace => ironSmelting
  | inductionFurnace => steelMaking
  | rollingMill | tubeMill => rolling
  | foundry => casting
  | refinery => oilRefining
  | copperSmelter => copperSmelting
  | rubberMill => rubberProcessing
  | machineLathe | millingMachine => machining
  | migWelder => arcWelding
  | handTools => blacksmithing
  | coke => charcoalBurning
  | pigIron => ironSmelting
  | steel => steelMaking
  | hotStrip | barStock | wireRod | tubeStock => rolling
  | castIron => casting
  | plasticStock | oilStock => oilRefining
  | rubberStock => rubberProcessing
  | copperStock => copperSmelting
  | weldingTable | torchTable | blendingTank => arcWelding
  | cutoffSaw | drillPress | pressBrake | arborPress | ironworker => machining
  | wireDrawBench => wireDrawing
  | steelTube4 | steelTube3 | steelTube2 | steelPlate6 | steelPlate12 | roundBar50 => rolling
  | boltM12 | nutM12 | fitting | wheelHub => machining
  | weldWire => wireDrawing
  | hose | tire | seat => rubberProcessing
  | fluid | paint => oilRefining
  | fuelTank | hydraulicTank => arcWelding
  | gearPump | wheelMotor | cylinder | controlValve => hydraulics
  | electricalKit => electricity
  | engine => internalCombustion
  | frame | wheelModule | powerUnit | controlStation | loader | finishing | lifeTrac =>
      tractorBuilding

/-- **The whole production system fits inside the shop's knowledge.**  Every
one of the seventy-two items — ore at the pit, mill goods, shop tools,
catalogue stock and the machine itself — is made by a skill the bootstrap
possesses. -/
theorem every_workflow_within_bootstrapSkills :
    ∀ i : Workflow.Item, skillOf i ∈ bootstrapSkills := by decide

/-- **And none of it needs a semiconductor.**  No workflow of the LifeTrac is
a photovoltaic one: the machine is buildable before solar power exists. -/
theorem no_workflow_needs_solar : ∀ i : Workflow.Item, skillOf i ≠ photovoltaics := by decide

/-! ## The digital branch: the printer and the computer

Thirteen skills carry the shop past the tractor and into the machines that
make other machines out of information: motors and extruded polymer for the
3D printer, and the whole silicon chain — lithography, logic, integrated
circuits, memory, a processor — for the computer.  The printer is a
prerequisite of the computer, not the other way round: the case, the fan
shroud and the card guides are printed, while the printer itself needs only
one chip, a microcontroller.

The last two skills are the ones this project itself uses: `programming`, and
`proofChecking` — running a proof checker on the machine. -/

/-- The skills of the digital branch, in the order they can be learned. -/
def digitalSkills : List Skill :=
  [electricMotors, polymerExtrusion, photolithography, digitalLogic, integratedCircuits,
   microcontrollers, memoryFabrication, microprocessor, precisionMotion, printer3D, computer,
   programming, proofChecking]

theorem digitalSkills_length : digitalSkills.length = 13 := by decide

/-- **The printer comes before the computer.**  Its case is printed, so the
printer is one of the things a computer rests on — and the printer needs only
a microcontroller, not a processor. -/
theorem printer_before_computer :
    printer3D ∈ prereqs computer ∧ printer3D ∈ needs computer ∧
      microprocessor ∉ needs printer3D ∧ memoryFabrication ∉ needs printer3D := by decide

/-- **The proof checker rests on the computer, and the computer on the
Earth.**  Checking a proof needs a program, a program needs a computer, and
the computer needs fire, wood, ore, sand and a pick: the whole of the bottom
of the tree is underneath it. -/
theorem proofChecking_rests_on_ground :
    computer ∈ needs proofChecking ∧ programming ∈ needs proofChecking ∧
      fire ∈ needs proofChecking ∧ woodcraft ∈ needs proofChecking ∧
      mining ∈ needs proofChecking ∧ ironSmelting ∈ needs proofChecking ∧
      glassMaking ∈ needs proofChecking := by decide

/-- **A proof is thirty-three skills deep.**  Nothing about proof checking is
self-supporting: it needs thirty-three of the other thirty-eight skills, and
it sits at depth seventeen. -/
theorem proofChecking_needs_length : (needs proofChecking).length = 33 ∧ depth proofChecking = 17 :=
  by decide

/-- **The five it does not need.**  A shop can check proofs without ever
learning to gasify wood, build a tractor, work hydraulics, run an internal
combustion engine or make a solar cell — but not without anything else in the
tree. -/
theorem proofChecking_independent :
    ∀ s : Skill, s ∉ proofChecking :: needs proofChecking ↔
      s ∈ [woodGas, internalCombustion, hydraulics, tractorBuilding, photovoltaics] := by decide

/-- **The tractor and the computer share a trunk.**  Everything up to and
including machining is needed by both; the two branches part company only
above it. -/
theorem common_trunk :
    (∀ p ∈ machining :: needs machining, p ∈ needs tractorBuilding ∧ p ∈ needs computer) ∧
      hydraulics ∉ needs computer ∧ digitalLogic ∉ needs tractorBuilding := by decide

/-- **The first watt is still a wood-fired watt.**  The computer rests on
electricity, electricity on steam, and steam on wood. -/
theorem computer_burns_wood :
    electricity ∈ needs computer ∧ steamPower ∈ needs computer ∧
      charcoalBurning ∈ needs computer := by decide

/-- **A shop that can make a computer can make a solar cell.**  Every
prerequisite of photovoltaics is already in place once the computer is built,
so the array is one skill away — and everything photovoltaics rests on is
something the computer rests on too. -/
theorem solar_within_reach_of_computer :
    (∀ p ∈ prereqs photovoltaics, p ∈ needs computer) ∧
      (∀ p ∈ needs photovoltaics, p ∈ needs computer) := by decide

/-- The knowledge a fabrication shop needs in order to build a 3D printer and
a computer and run a proof checker on it: proof checking, everything that
rests on, and the wood gas plant that powers the shop. -/
def fabSkills : List Skill := proofChecking :: woodGas :: needs proofChecking

theorem fabSkills_length : fabSkills.length = 35 := by decide

theorem fabSkills_nodup : fabSkills.Nodup := by decide

/-- The fab's knowledge is honest: it contains everything it rests on. -/
theorem fabSkills_closed : ∀ s ∈ fabSkills, ∀ p ∈ prereqs s, p ∈ fabSkills := by decide

/-- **The fab is the bootstrap shop plus the digital branch, minus the
tractor.**  Every skill of the wood-and-iron bootstrap except the three that
belong to the machine itself is part of the fab as well. -/
theorem bootstrap_within_fabSkills :
    ∀ s ∈ bootstrapSkills, s ∈ fabSkills ∨
      s ∈ [hydraulics, internalCombustion, tractorBuilding] := by decide

/-- Every source of energy the bootstrap shop could run, the fab can run
too. -/
theorem fab_wood_sources_available : ∀ src ∈ woodSources, src.available fabSkills := by decide

/-- And this time the solar array *is* available: the fab that can make a
processor can make a photovoltaic cell as soon as it learns the last step. -/
theorem fab_solar_one_step_away :
    ¬ Source.solarArray.available fabSkills ∧
      ∀ p ∈ needs photovoltaics, p ∈ fabSkills := by decide

end Skill
end Skills
end LifeTrac
