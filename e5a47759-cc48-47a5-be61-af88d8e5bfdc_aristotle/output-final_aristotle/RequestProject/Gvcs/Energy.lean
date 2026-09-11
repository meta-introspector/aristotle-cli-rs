import RequestProject.Gvcs.Bootstrap

/-!
# The energy in the chain: how much work it takes to build a tractor

`RequestProject/Bootstrap.lean` says how much *material* and how many *hours*
one LifeTrac costs.  This file asks the other question: how much **energy**.

Two kinds of energy have to be told apart, because they come from quite
different places.

* **Process energy** — the shaft work and heat the processes themselves
  consume: melting a kilogram of steel, rolling it, running a lathe for six
  hours.  It is booked per run of a workflow (`procEnergy`) and accumulated
  along the whole chain by `Plant.chainEnergy`, exactly as labour is
  accumulated by `Plant.laborFor`.
* **Fuel energy** — the chemical energy of the fuels the system digs up: the
  coal that becomes coke and the crude oil that becomes plastic, fluid and
  paint.  This is already counted, as mass, in the raw-material demand; here it
  is valued in kilowatt-hours by `fuelValue`.

The general part of the file is a theory of *any* per-run energy accounting on
*any* plant.  Its main result, `Plant.chainEnergy_eq_of_valuation`, says that
a chain accumulation is completely determined by a **unit valuation**: a
number `u i` per unit of each item satisfying `batch · u i = E i + Σ qty · u
input` at every workflow and vanishing on the base.  That turns a recursion
over a production tree with thousands of nodes into one algebraic identity per
workflow, which is how the numbers below are proved.

Energies are kilowatt-hours throughout.  The per-process figures are
illustrative of the machine class and of ordinary small-shop practice — an
induction furnace at 0.6 kWh per kilogram of steel, a welder drawing about
three kilowatts — not quotations from a particular plant.
-/

namespace LifeTrac
namespace Workflow

namespace Plant

variable {Item : Type} (P : Plant Item)

/-! ## Energy accumulated along a production chain -/

/-- The total process energy in the whole chain of workflows behind an order
for `q` units of `i`, when one run of the workflow for `j` takes `E j` of
energy.  Base items carry no process energy: they are dug, not made. -/
def chainEnergy (P : Plant Item) (E : Item → ℚ) (i : Item) (q : ℚ) : ℚ :=
  match _h : P.recipe i with
  | none => 0
  | some r =>
      q / r.batch * E i +
        (r.inputs.attach.map (fun p => P.chainEnergy E p.1.1 (q * p.1.2 / r.batch))).sum
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

@[simp] theorem chainEnergy_base (E : Item → ℚ) {i : Item} (h : P.recipe i = none) (q : ℚ) :
    P.chainEnergy E i q = 0 := by
  rw [Plant.chainEnergy.eq_def, h]

theorem chainEnergy_recipe (E : Item → ℚ) {i : Item} {r : Recipe Item}
    (h : P.recipe i = some r) (q : ℚ) :
    P.chainEnergy E i q =
      q / r.batch * E i + (r.inputs.map (fun p => P.chainEnergy E p.1 (q * p.2 / r.batch))).sum := by
  rw [Plant.chainEnergy.eq_def, h]
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `chainEnergy`, in a form `simp` can apply
repeatedly. -/
theorem chainEnergy_eq (E : Item → ℚ) (i : Item) (q : ℚ) :
    P.chainEnergy E i q =
      match P.recipe i with
      | none => 0
      | some r => q / r.batch * E i +
          (r.inputs.map (fun p => P.chainEnergy E p.1 (q * p.2 / r.batch))).sum := by
  cases h : P.recipe i with
  | none => rw [P.chainEnergy_base E h]
  | some r => rw [P.chainEnergy_recipe E h]

/-- Labour is the special case of chain energy in which each run costs its own
hours. -/
theorem laborFor_eq_chainEnergy (E : Item → ℚ)
    (hE : ∀ i r, P.recipe i = some r → E i = r.labor) (i : Item) (q : ℚ) :
    P.laborFor i q = P.chainEnergy E i q := by
  refine P.rankInduction (M := fun i => ∀ q, P.laborFor i q = P.chainEnergy E i q)
    (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none => rw [P.laborFor_base hr, P.chainEnergy_base E hr]
  | some r =>
      rw [P.laborFor_recipe hr, P.chainEnergy_recipe E hr, hE i r hr]
      refine congrArg (fun s => q / r.batch * r.labor + s) (congrArg List.sum ?_)
      refine List.map_congr_left ?_
      intro p hp
      exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _

/-- **A unit valuation determines the whole chain.**  If `u` vanishes on the
base and every workflow balances — a batch's worth of output is worth the
energy of the run plus the energy in its inputs — then the energy in the chain
behind an order is simply the size of the order times the unit value of what
is ordered. -/
theorem chainEnergy_eq_of_valuation (E u : Item → ℚ)
    (hbase : ∀ i, P.recipe i = none → u i = 0)
    (hstep : ∀ i r, P.recipe i = some r →
      r.batch * u i = E i + (r.inputs.map (fun p => p.2 * u p.1)).sum) :
    ∀ i q, P.chainEnergy E i q = q * u i := by
  refine P.rankInduction (M := fun i => ∀ q, P.chainEnergy E i q = q * u i) (fun i ih q => ?_)
  cases hr : P.recipe i with
  | none => rw [P.chainEnergy_base E hr, hbase i hr]; ring
  | some r =>
      rw [P.chainEnergy_recipe E hr]
      have hb : (0:ℚ) < r.batch := P.batch_pos i r hr
      have hmap : (r.inputs.map (fun p => P.chainEnergy E p.1 (q * p.2 / r.batch)))
          = r.inputs.map (fun p => q / r.batch * (p.2 * u p.1)) := by
        refine List.map_congr_left ?_
        intro p hp
        rw [ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _]
        field_simp
      rw [hmap, List.sum_map_mul_left r.inputs (fun p => p.2 * u p.1) (q / r.batch),
        ← mul_add, ← hstep i r hr]
      field_simp

/-- The energy in an order is proportional to its size. -/
theorem chainEnergy_smul (E : Item → ℚ) (i : Item) (c q : ℚ) :
    P.chainEnergy E i (c * q) = c * P.chainEnergy E i q := by
  refine P.rankInduction (M := fun i => ∀ q, P.chainEnergy E i (c * q) = c * P.chainEnergy E i q)
    (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none => simp [P.chainEnergy_base E hr]
  | some r =>
      rw [P.chainEnergy_recipe E hr, P.chainEnergy_recipe E hr, mul_add, ← List.sum_map_mul_left]
      congr 1
      · ring
      · refine congrArg List.sum (List.map_congr_left ?_)
        intro p hp
        have hcalc : c * q * p.2 / r.batch = c * (q * p.2 / r.batch) := by ring
        rw [hcalc, ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩]

/-- Nothing is made for nothing, and nothing is made from nothing: with
non-negative per-run energies the chain energy of a non-negative order is
non-negative. -/
theorem chainEnergy_nonneg (E : Item → ℚ) (hE : ∀ i, 0 ≤ E i) {i : Item} {q : ℚ} (hq : 0 ≤ q) :
    0 ≤ P.chainEnergy E i q := by
  refine P.rankInduction (M := fun i => ∀ q, 0 ≤ q → 0 ≤ P.chainEnergy E i q)
    (fun i ih q hq => ?_) i q hq
  cases hr : P.recipe i with
  | none => simp [P.chainEnergy_base E hr]
  | some r =>
      rw [P.chainEnergy_recipe E hr]
      have hb : (0:ℚ) < r.batch := P.batch_pos i r hr
      have h1 : 0 ≤ q / r.batch * E i := mul_nonneg (div_nonneg hq hb.le) (hE i)
      have h2 : 0 ≤ (r.inputs.map (fun p => P.chainEnergy E p.1 (q * p.2 / r.batch))).sum := by
        refine List.sum_nonneg ?_
        intro y hy
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
        exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
          (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr p hp)) hb.le)
      linarith

end Plant

/-! ## The energy of the LifeTrac processes -/

open Item

set_option maxRecDepth 8000

/-- The process energy of one run of each workflow, in kilowatt-hours: the
heat and shaft work the process itself takes, over and above the chemical
energy of the material it consumes.  Mill goods are per kilogram; shop tools,
stock items and assemblies are per run, and are about the machine time of the
workflow at typical small-shop powers (a MIG welder ≈ 3 kW, a lathe ≈ 2 kW, a
plasma table ≈ 4 kW). -/
def procEnergy : Item → ℚ
  -- mill goods, per kilogram
  | coke => 1/10
  | pigIron => 1/5
  | steel => 3/5
  | hotStrip => 3/20
  | barStock => 3/20
  | wireRod => 1/5
  | castIron => 7/10
  | tubeStock => 1/10
  | plasticStock => 1
  | oilStock => 1/5
  | rubberStock => 4/5
  | copperStock => 3
  -- the tools the shop builds for itself
  | weldingTable => 24
  | cutoffSaw => 25
  | drillPress => 24
  | torchTable => 120
  | pressBrake => 60
  | arborPress => 72
  | ironworker => 78
  | wireDrawBench => 35
  | blendingTank => 6
  -- catalogue stock
  | steelTube4 => 3/10
  | steelTube3 => 3/10
  | steelTube2 => 3/10
  | steelPlate6 => 1
  | steelPlate12 => 3/2
  | roundBar50 => 1/2
  | boltM12 => 2
  | nutM12 => 1
  | weldWire => 1/10
  | hose => 1/10
  | fitting => 1/5
  | fluid => 1/50
  | paint => 1/50
  | wheelHub => 9/2
  | tire => 8
  | seat => 3
  | fuelTank => 6
  | hydraulicTank => 9
  | gearPump => 18
  | wheelMotor => 30
  | cylinder => 15
  | controlValve => 24
  | electricalKit => 3
  | engine => 180
  -- assemblies
  | frame => 72
  | wheelModule => 8
  | powerUnit => 24
  | controlStation => 16
  | loader => 48
  | finishing => 6
  | lifeTrac => 20
  -- the base of the system: raw materials and seed tools carry no process energy
  | _ => 0

theorem procEnergy_nonneg (i : Item) : 0 ≤ procEnergy i := by
  cases i <;> norm_num [procEnergy]

/-- The cumulative process energy of one unit of each item: everything the
whole chain behind it consumes.  These numbers are not postulated —
`unitEnergy_balance` checks each one against its workflow, and
`chainEnergy_eq_unitEnergy` concludes that they are exactly what the chain
accumulates. -/
def unitEnergy : Item → ℚ
  | coke => 1/10
  | pigIron => 1/4
  | steel => 22/25
  | hotStrip => 537/500
  | barStock => 537/500
  | wireRod => 1383/1250
  | castIron => 77/80
  | tubeStock => 29887/25000
  | plasticStock => 1
  | oilStock => 1/5
  | rubberStock => 4/5
  | copperStock => 3
  | weldingTable => 118327/1000
  | cutoffSaw => 14443/200
  | drillPress => 4199/50
  | torchTable => 341849/1250
  | pressBrake => 5796/25
  | arborPress => 1881/8
  | ironworker => 463/2
  | wireDrawBench => 45551/400
  | blendingTank => 657/20
  | steelTube4 => 1419689/50000
  | steelTube3 => 2637669/125000
  | steelTube2 => 706151/62500
  | steelPlate6 => 6569/125
  | steelPlate12 => 26151/250
  | roundBar50 => 86809/5000
  | boltM12 => 1861/12500
  | nutM12 => 331/6250
  | weldWire => 31543/25000
  | hose => 2879/3125
  | fitting => 9833/25000
  | fluid => 1/5
  | paint => 29/50
  | wheelHub => 17347/1000
  | tire => 31472/625
  | seat => 1197/100
  | fuelTank => 7833/500
  | hydraulicTank => 26721/1000
  | gearPump => 7559/250
  | wheelMotor => 14829/250
  | cylinder => 23088/625
  | controlValve => 15277/400
  | electricalKit => 6861/500
  | engine => 69259/200
  | frame => 21125253/31250
  | wheelModule => 4070303/25000
  | powerUnit => 6113721/12500
  | controlStation => 25277777/125000
  | loader => 103589793/250000
  | finishing => 9173/625
  | lifeTrac => 616903111/250000
  | _ => 0

/-- The base of the system carries no embodied process energy. -/
theorem unitEnergy_base (i : Item) (h : plant.recipe i = none) : unitEnergy i = 0 := by
  cases i <;> first | rfl | (exact absurd h (by simp [plant_recipe, recipe]))

/-- **Every workflow balances.**  A batch's worth of output embodies exactly
the energy of the run plus the energy embodied in what the run consumes. -/
theorem unitEnergy_balance (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    r.batch * unitEnergy i = procEnergy i + (r.inputs.map (fun p => p.2 * unitEnergy p.1)).sum := by
  cases i <;> simp only [plant_recipe, recipe] at h <;>
    first
      | (injection h with h'; subst h'; norm_num [unitEnergy, procEnergy])
      | (exact absurd h (by simp))

/-- **The energy in the chain, in closed form.**  The process energy behind an
order for `q` units of any item is `q` times the unit figure of `unitEnergy`. -/
theorem chainEnergy_eq_unitEnergy (i : Item) (q : ℚ) :
    plant.chainEnergy procEnergy i q = q * unitEnergy i :=
  plant.chainEnergy_eq_of_valuation procEnergy unitEnergy unitEnergy_base unitEnergy_balance i q

/-! ## The fuel dug out of the ground -/

/-- The chemical energy of the raw materials, in kilowatt-hours per kilogram:
coal at 28.8 MJ/kg and crude oil at 41.8 MJ/kg.  Ore, limestone and sand carry
none. -/
def fuelValue : Item → ℚ
  | coal => 8
  | crudeOil => 58/5
  | _ => 0

/-- The chemical energy of a raw-material demand vector. -/
def fuelEnergy (d : Item → ℚ) : ℚ := d coal * fuelValue coal + d crudeOil * fuelValue crudeOil

/-! ## The answers for one machine -/

/-- **The process energy of one LifeTrac: 2467.61 kWh.** -/
theorem lifeTrac_processEnergy :
    plant.chainEnergy procEnergy lifeTrac 1 = 616903111/250000 := by
  rw [chainEnergy_eq_unitEnergy]; norm_num [unitEnergy]

/-- **The fuel dug for one LifeTrac: 11 446.99 kWh**, the chemical energy of
the 1332.33 kg of coal and 67.96 kg of crude oil in its raw-material bill. -/
theorem lifeTrac_fuelEnergy :
    fuelEnergy (plant.rawDemand lifeTrac 1) = 35771848/3125 := by
  have hc : plant.rawDemand lifeTrac 1 coal = 16654149/12500 := lifeTrac_rawDemand.2.1
  have ho : plant.rawDemand lifeTrac 1 crudeOil = 1699/25 := lifeTrac_rawDemand.2.2.2.2.1
  rw [fuelEnergy, hc, ho]
  norm_num [fuelValue]

/-- The whole energy demand of one machine: process energy plus the chemical
energy of the fuel it consumes. -/
def totalEnergy (i : Item) (q : ℚ) : ℚ :=
  plant.chainEnergy procEnergy i q + fuelEnergy (plant.rawDemand i q)

/-- **One LifeTrac costs 13 914.60 kWh** from bare ore. -/
theorem lifeTrac_totalEnergy : totalEnergy lifeTrac 1 = 3478650951/250000 := by
  rw [totalEnergy, lifeTrac_processEnergy, lifeTrac_fuelEnergy]; norm_num

theorem lifeTrac_totalEnergy_bounds :
    13914 < totalEnergy lifeTrac 1 ∧ totalEnergy lifeTrac 1 < 13915 := by
  rw [lifeTrac_totalEnergy]; constructor <;> norm_num

/-- **Most of the energy is fuel, not machine time.**  The coal and oil in the
bill carry more than four times the energy the shop's own processes use. -/
theorem fuel_dominates_process :
    4 * plant.chainEnergy procEnergy lifeTrac 1 < fuelEnergy (plant.rawDemand lifeTrac 1) := by
  rw [lifeTrac_processEnergy, lifeTrac_fuelEnergy]; norm_num

/-- The process energy of the nine tools the shop must build for itself:
1393.19 kWh. -/
def shopKitEnergy : ℚ :=
  (Item.shopTools.map (fun t => plant.chainEnergy procEnergy t 1)).sum

theorem shopKitEnergy_eq : shopKitEnergy = 13931937/10000 := by
  simp only [shopKitEnergy, Item.shopTools, List.map_cons, List.map_nil, List.sum_cons,
    List.sum_nil, chainEnergy_eq_unitEnergy]
  norm_num [unitEnergy]

/-- Equipping the shop and building the first machine: 3860.81 kWh of process
energy. -/
theorem bootstrap_processEnergy :
    plant.chainEnergy procEnergy lifeTrac 1 + shopKitEnergy = 60325096/15625 := by
  rw [lifeTrac_processEnergy, shopKitEnergy_eq]; norm_num

/-- The shop kit is a real overhead but not the main one: it costs less than
sixty per cent of the machine it is built to make. -/
theorem shopKit_less_than_machine :
    shopKitEnergy < 3/5 * plant.chainEnergy procEnergy lifeTrac 1 := by
  rw [lifeTrac_processEnergy, shopKitEnergy_eq]; norm_num

/-- Energy, like material and labour, is proportional to the size of the
fleet: ten tractors take ten times the energy of one. -/
theorem totalEnergy_smul (i : Item) (q : ℚ) : totalEnergy i q = q * totalEnergy i 1 := by
  rw [totalEnergy, totalEnergy]
  have h1 : plant.chainEnergy procEnergy i q = q * plant.chainEnergy procEnergy i 1 := by
    simpa using plant.chainEnergy_smul procEnergy i q 1
  have h2 : plant.rawDemand i q = fun x => q * plant.rawDemand i 1 x :=
    plant.rawDemand_eq_smul_one i q
  rw [h1, h2, fuelEnergy, fuelEnergy]
  ring

end Workflow
end LifeTrac
