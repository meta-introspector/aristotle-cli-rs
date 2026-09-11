import RequestProject.Gvcs.Explosion

/-!
# From ore to tractor: what the whole system actually consumes

`RequestProject/Fabrication.lean` sets up the production system and
`RequestProject/Explosion.lean` works out the raw-material and labour content
of every item in it.  This file collects the answers for the machine itself
and for the workshop that builds it.

Everything below is a consequence of the workflows; no number here is
postulated.  Masses are kilograms and times are hours.
-/

namespace LifeTrac
namespace Workflow

open Item

set_option maxRecDepth 4000

/-- The total mass of raw material in a demand vector.  All seven raw
materials are measured in kilograms, so they may simply be added up. -/
def rawTotal (d : Item → ℚ) : ℚ :=
  d ironOre + d coal + d limestone + d silicaSand + d crudeOil + d latex + d copperOre

/-- Illustrative pit-head prices of the raw materials, per kilogram. -/
def rawPrice : Item → ℚ
  | ironOre => 3/25
  | coal => 3/20
  | limestone => 1/20
  | silicaSand => 3/50
  | crudeOil => 3/5
  | latex => 8/5
  | copperOre => 9/10
  | _ => 0

/-- The bill for the raw material in a demand vector, at `rawPrice`. -/
def rawBill (d : Item → ℚ) : ℚ :=
  d ironOre * rawPrice ironOre + d coal * rawPrice coal + d limestone * rawPrice limestone +
    d silicaSand * rawPrice silicaSand + d crudeOil * rawPrice crudeOil +
    d latex * rawPrice latex + d copperOre * rawPrice copperOre

/-! ## What one tractor takes out of the ground -/

/-- **The raw-material bill of one LifeTrac.**  Following every workflow of
the system back to the ground, one machine takes 2623.09 kg of iron ore,
1332.33 kg of coal, 492.63 kg of limestone, 47.2 kg of silica sand, 67.96 kg
of crude oil, 141.75 kg of latex and 56 kg of copper ore. -/
theorem lifeTrac_rawDemand :
    plant.rawDemand lifeTrac 1 ironOre = 40985767/15625 ∧
    plant.rawDemand lifeTrac 1 coal = 16654149/12500 ∧
    plant.rawDemand lifeTrac 1 limestone = 123157301/250000 ∧
    plant.rawDemand lifeTrac 1 silicaSand = 236/5 ∧
    plant.rawDemand lifeTrac 1 crudeOil = 1699/25 ∧
    plant.rawDemand lifeTrac 1 latex = 567/4 ∧
    plant.rawDemand lifeTrac 1 copperOre = 56 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [ind]

/-- Nothing that the plant makes itself appears in the raw-material demand:
the demand is entirely in raw materials. -/
theorem lifeTrac_demand_raw (x : Item) (hx : plant.recipe x ≠ none) :
    plant.rawDemand lifeTrac 1 x = 0 :=
  plant.rawDemand_eq_zero_of_made hx lifeTrac 1

/-- The seed tools are not consumed: a tool is used, not used up. -/
theorem lifeTrac_demand_seedToolkit (t : Item) (ht : t ∈ seedToolkit) :
    plant.rawDemand lifeTrac 1 t = 0 := by
  fin_cases ht <;> simp [ind]

/-- One machine takes 4760.96 kg of raw material out of the ground. -/
theorem lifeTrac_rawTotal : rawTotal (plant.rawDemand lifeTrac 1) = 1190240053/250000 := by
  simp [rawTotal, ind]; norm_num

theorem lifeTrac_rawTotal_bounds :
    4760 < rawTotal (plant.rawDemand lifeTrac 1) ∧
      rawTotal (plant.rawDemand lifeTrac 1) < 4761 := by
  rw [lifeTrac_rawTotal]; constructor <;> norm_num

/-- **Three kilograms of rock and oil for every kilogram of tractor.**  The
finished machine masses 1539.7 kg (`Build.lifeTrac_mass`); the raw material
behind it is more than three times that, the difference being slag, scale,
swarf and refinery losses. -/
theorem lifeTrac_rawTotal_gt_three_times_mass :
    3 * Build.lifeTrac.mass < rawTotal (plant.rawDemand lifeTrac 1) := by
  rw [Build.lifeTrac_mass, lifeTrac_rawTotal]; norm_num

/-- The raw material for one machine costs 860.06 at pit-head prices. -/
theorem lifeTrac_rawBill : rawBill (plant.rawDemand lifeTrac 1) = 21501498469/25000000 := by
  simp [rawBill, rawPrice, ind]; norm_num

/-- **Where the money goes.**  Buying the machine's stock over the counter
costs 9551 (`Build.lifeTrac_materialCost`) — more than eleven times the value
of the raw material in it.  What a builder pays for is the processing, not the
rock. -/
theorem lifeTrac_purchase_cost_gt_eleven_times_rawBill :
    11 * rawBill (plant.rawDemand lifeTrac 1) < Build.lifeTrac.materialCost := by
  rw [Build.lifeTrac_materialCost, lifeTrac_rawBill]; norm_num

/-! ## The labour in the whole chain -/

/-- **The labour content of one machine**: 370.52 hours from ore to tractor,
mining excluded. -/
theorem lifeTrac_laborFor : plant.laborFor lifeTrac 1 = 463154719/1250000 := by
  simp

theorem lifeTrac_laborFor_bounds :
    370 < plant.laborFor lifeTrac 1 ∧ plant.laborFor lifeTrac 1 < 371 := by
  rw [lifeTrac_laborFor]; constructor <;> norm_num

/-- **Most of the work is upstream.**  Bolting the machine together from
bought stock takes 92 hours (`Build.lifeTrac_laborHours`); making that stock
from ore takes four times as much again. -/
theorem lifeTrac_laborFor_gt_four_times_assembly :
    4 * Build.lifeTrac.laborHours < plant.laborFor lifeTrac 1 := by
  rw [Build.lifeTrac_laborHours, lifeTrac_laborFor]; norm_num

/-! ## Scaling: a fleet -/

/-- Demand is exactly proportional to the number of machines ordered. -/
theorem rawTotal_smul (q : ℚ) :
    rawTotal (plant.rawDemand lifeTrac q) = q * rawTotal (plant.rawDemand lifeTrac 1) := by
  simp [rawTotal]; ring

/-- Ten machines take ten times as much out of the ground. -/
theorem lifeTrac_rawTotal_ten :
    rawTotal (plant.rawDemand lifeTrac 10) = 1190240053/25000 := by
  rw [rawTotal_smul, lifeTrac_rawTotal]; norm_num

/-- So is the labour. -/
theorem laborFor_smul (q : ℚ) :
    plant.laborFor lifeTrac q = q * plant.laborFor lifeTrac 1 :=
  plant.laborFor_eq_smul_one lifeTrac q

/-! ## Equipping the shop

Before the first machine can be built the shop must build its own tools.
`shopDemand` and `shopLabor` are what that costs. -/

/-- The raw material drawn by one of each shop-built tool. -/
def shopDemand (x : Item) : ℚ :=
  plant.rawDemand weldingTable 1 x + plant.rawDemand cutoffSaw 1 x +
    plant.rawDemand drillPress 1 x + plant.rawDemand torchTable 1 x +
    plant.rawDemand pressBrake 1 x + plant.rawDemand arborPress 1 x +
    plant.rawDemand ironworker 1 x + plant.rawDemand wireDrawBench 1 x +
    plant.rawDemand blendingTank 1 x

/-- The labour of building one of each shop-built tool. -/
def shopLabor : ℚ :=
  plant.laborFor weldingTable 1 + plant.laborFor cutoffSaw 1 + plant.laborFor drillPress 1 +
    plant.laborFor torchTable 1 + plant.laborFor pressBrake 1 + plant.laborFor arborPress 1 +
    plant.laborFor ironworker 1 + plant.laborFor wireDrawBench 1 +
    plant.laborFor blendingTank 1

/-- Equipping the shop takes 2768.39 kg of raw material … -/
theorem shopDemand_rawTotal : rawTotal shopDemand = 55367727/20000 := by
  simp [rawTotal, shopDemand, ind]; norm_num

/-- … and 209.26 hours of work. -/
theorem shopLabor_eq : shopLabor = 20926471/100000 := by
  simp [shopLabor]; norm_num

/-- **The shop is cheaper than the tractor it builds.**  All nine shop-built
tools together take less material out of the ground than one LifeTrac. -/
theorem shopDemand_lt_lifeTrac : rawTotal shopDemand < rawTotal (plant.rawDemand lifeTrac 1) := by
  rw [shopDemand_rawTotal, lifeTrac_rawTotal]; norm_num

/-- The tools cost 348.35 in raw material at pit-head prices. -/
theorem shopDemand_rawBill : rawBill shopDemand = 696706971/2000000 := by
  simp [rawBill, rawPrice, shopDemand, ind]; norm_num

/-! ## The whole undertaking

Starting from nothing but the seed toolkit — a furnace line, a lathe, a mill,
a welder and hand tools — and a supply of ore, coal, limestone, sand, oil,
latex and copper ore, a builder can equip a shop and build a LifeTrac.  This
is what it takes. -/

/-- **From raw materials to a working tractor.**  Everything is producible
from the base (`producible`); the shop tools and the machine together take
7529.35 kg of raw material and 579.79 hours of work. -/
theorem shop_and_tractor :
    (∀ i : Item, plant.Producible i) ∧
    rawTotal shopDemand + rawTotal (plant.rawDemand lifeTrac 1) = 3764673281/500000 ∧
    shopLabor + plant.laborFor lifeTrac 1 = 1449471213/2500000 := by
  refine ⟨producible, ?_, ?_⟩
  · rw [shopDemand_rawTotal, lifeTrac_rawTotal]; norm_num
  · rw [shopLabor_eq, lifeTrac_laborFor]; norm_num

end Workflow
end LifeTrac
