import RequestProject.Gvcs.Costing
import RequestProject.Gvcs.Bootstrap
import RequestProject.Gvcs.EnergyPlan

/-!
# The real total cost of owning a LifeTrac

`Costing.lean` gives the accounting; this file puts prices into it and works out
what the machine actually costs its owner.

## The price list

Every figure below that is *assumed* is collected here, so that it can be
argued with; everything else is derived from the workflows of the earlier
files.

| assumption | value |
|---|---|
| shop labour, self-build | 25 / hour |
| operator's wage | 20 / hour |
| diesel | 1.50 / litre |
| fuel burn | 8 litres / hour |
| lubricants and filters | 15 % of the fuel bill |
| air-dry firewood, delivered | 0.06 / kg |
| interest on capital | 8 % a year |
| taxes, insurance, housing | 1.5 % of the price a year |
| service life | 12 years |
| use | 500 hours a year |
| salvage, self-built machine | 20 % of its cost |
| salvage, bought machine | 40 % of its price |
| repairs, self-built machine | 10 % of its cost per 1000 hours |
| repairs, bought machine | 8 % of its price per 1000 hours |
| a bought 55 hp utility tractor with loader | 38 000 |
| a contractor with his own machine and driver | 55 / hour |

## Four ways to get a tractor

* `unpaidBuilder` — buy the stock over the counter and build it in your own
  time: **9551** (`Build.lifeTrac_materialCost`).
* `overTheCounter` — the same, valuing the 92 hours of assembly at the shop
  rate: **11 851** (`Build.lifeTrac_totalCost_25`).
* `fromTheGround` — the full bootstrap: raw material at pit-head prices, all
  370.52 hours of the chain at the shop rate, and the 8651.74 kg of firewood
  that powers it: **10 642.26**.
* `boughtIn` — write a cheque to a dealer: **38 000**.

## What comes out

| | self-built | bought in |
|---|---|---|
| ownership, per year | 1536.68 | 4598.00 |
| operating, per hour | 34.99 | 36.84 |
| **cost per hour** | **38.06** | **46.04** |
| cost per year at 500 h | 19 029.23 | 23 018.00 |
| **twelve-year cost of ownership** | **228 350.76** | **276 216.00** |
| of which the machine itself | 11.2 % | 26.6 % |
| a hectare of wheat | 85.63 | 103.58 |
| break-even area, wheat | 2.56 ha | 7.70 ha |
| owning beats hiring above | 76.8 h/yr | 253.2 h/yr |

The two facts worth carrying away are that **the open-source machine is
seventeen per cent cheaper an hour and forty-eight thousand cheaper over its
life**, and that **the tractor is the small part of the cost of a tractor**:
nine tenths of the self-builder's hourly cost is diesel, oil and the man in the
seat, and the whole twelve-year bill is nineteen times what the machine cost to
build.

## The levers, ranked (`the_levers_ranked`)

| what you change | saved over twelve years |
|---|---|
| run it on wood gas instead of diesel | 72 693 |
| build it instead of buying it | 47 865 |
| don't pay yourself for the 92 hours of assembly | 4959 |
| dig your own ore and run the whole bootstrap | 2606 |

with the caveat, proved in `woodGas_per_hectare_barely_wins`, that a
producer-gas engine loses 30 % of its power, and that per *hectare* — the
figure that matters — the wood saves under three per cent, because the extra
hours of the operator's time eat a fuel bill that fell by nine tenths.
-/

namespace LifeTrac
namespace Ownership

open Build

/-! ## The assumed prices -/

/-- Shop labour rate for self-building. -/
def buildRate : ℚ := 25

/-- Delivered price of air-dry firewood, per kilogram. -/
def woodPrice : ℚ := 3/50

/-- What a contractor charges for an hour of the same work, machine and driver
included. -/
def contractorRate : ℚ := 55

/-! ## The four capital costs -/

/-- Buy the stock, build it yourself, and do not pay yourself. -/
def stockPrice : ℚ := 9551

/-- Buy the stock and value the 92 hours of assembly at the shop rate. -/
def counterPrice : ℚ := 11851

/-- Dig the ore, run every workflow, and burn the wood: raw material at
pit-head prices, the whole labour chain at the shop rate, and the firewood
that carries the energy. -/
def groundPrice : ℚ := 409726950634327/38500000000

/-- A comparable bought 55 hp utility tractor with a loader. -/
def dealerPrice : ℚ := 38000

/-- `stockPrice` is the bill of materials of `Materials.lean`. -/
theorem stockPrice_eq : stockPrice = Build.lifeTrac.materialCost := by
  rw [Build.lifeTrac_materialCost, stockPrice]

/-- `counterPrice` is that bill plus the assembly labour at `buildRate`. -/
theorem counterPrice_eq : counterPrice = Assembly.totalCost buildRate Build.lifeTrac := by
  rw [buildRate, Build.lifeTrac_totalCost_25, counterPrice]

/-- **What the bootstrap route costs.**  860.06 of raw material at pit-head
prices, 370.52 hours of chain labour at 25, and 8651.74 kg of firewood at
0.06: 10 642.26 in all. -/
theorem groundPrice_eq :
    groundPrice =
      Workflow.rawBill (Workflow.plant.rawDemand Workflow.Item.lifeTrac 1)
        + buildRate * Workflow.plant.laborFor Workflow.Item.lifeTrac 1
        + woodPrice * EnergyPlan.wholeWood := by
  rw [Workflow.lifeTrac_rawBill, Workflow.lifeTrac_laborFor, EnergyPlan.wholeWood_eq,
    groundPrice, buildRate, woodPrice]
  norm_num

/-- **Digging your own ore saves a tenth of the capital cost** — and no more
than that, because the cost is labour, not rock. -/
theorem groundPrice_lt_counterPrice : groundPrice < counterPrice := by
  rw [groundPrice, counterPrice]; norm_num

/-- Even the full bootstrap costs less than a third of the dealer's price. -/
theorem groundPrice_lt_third_dealerPrice : 3 * groundPrice < dealerPrice := by
  rw [groundPrice, dealerPrice]; norm_num

/-! ## The four cost models -/

/-- Buy the stock over the counter, build the machine, value the build time at
the shop rate. -/
def overTheCounter : Costs where
  purchase := counterPrice
  salvageFrac := 1/5
  lifeYears := 12
  annualHours := 500
  interest := 2/25
  insuranceFrac := 3/200
  fuelPerHour := 8
  fuelPrice := 3/2
  lubeFrac := 3/20
  repairRate := 1/10
  wage := 20
  purchase_pos := by rw [counterPrice]; norm_num
  salvageFrac_nonneg := by norm_num
  salvageFrac_lt_one := by norm_num
  lifeYears_pos := by norm_num
  annualHours_pos := by norm_num
  interest_nonneg := by norm_num
  insuranceFrac_nonneg := by norm_num
  fuelPerHour_nonneg := by norm_num
  fuelPrice_nonneg := by norm_num
  lubeFrac_nonneg := by norm_num
  repairRate_nonneg := by norm_num
  wage_nonneg := by norm_num

/-- The same machine, with the builder's own time not charged. -/
def unpaidBuilder : Costs :=
  { overTheCounter with
    purchase := stockPrice
    purchase_pos := by rw [stockPrice]; norm_num }

/-- The machine made from the ground up by the bootstrap of `Bootstrap.lean`. -/
def fromTheGround : Costs :=
  { overTheCounter with
    purchase := groundPrice
    purchase_pos := by rw [groundPrice]; norm_num }

/-- A comparable machine bought from a dealer: dearer, but holding its value
better and repaired at the published rate. -/
def boughtIn : Costs :=
  { overTheCounter with
    purchase := dealerPrice
    salvageFrac := 2/5
    repairRate := 8/100
    purchase_pos := by rw [dealerPrice]; norm_num
    salvageFrac_nonneg := by norm_num
    salvageFrac_lt_one := by norm_num
    repairRate_nonneg := by norm_num }

-- The definitions to unfold when computing with a cost model.
attribute [local simp] Costs.costPerHour Costs.ownershipPerHour Costs.ownershipPerYear
  Costs.depreciationPerYear Costs.interestPerYear Costs.insurancePerYear Costs.salvage
  Costs.operatingPerHour Costs.fuelCostPerHour Costs.lubeCostPerHour Costs.repairPerHour
  Costs.machinePerHour Costs.variablePerHour Costs.annualCost Costs.lifetimeCost
  Costs.lifetimeHours Costs.annualAt Costs.hourlyAt Costs.hireBreakEvenHours
  Costs.netMarginPerHa Costs.fullSeasonProfit Costs.fullBreakEvenArea Costs.hectareCost
  overTheCounter unpaidBuilder fromTheGround boughtIn
  counterPrice stockPrice groundPrice dealerPrice contractorRate

/-! ## The self-built machine -/

/-- **1536.68 a year to have it, 34.99 an hour to use it, 38.06 an hour all
told.** -/
theorem overTheCounter_figures :
    overTheCounter.ownershipPerYear = 4610039/3000 ∧
    overTheCounter.operatingPerHour = 349851/10000 ∧
    overTheCounter.costPerHour = 57087689/1500000 := by
  refine ⟨by norm_num, by norm_num, by norm_num⟩

theorem overTheCounter_costPerHour_bounds :
    38 < overTheCounter.costPerHour ∧ overTheCounter.costPerHour < 39 := by
  constructor <;> · norm_num

/-- **19 029.23 a year, 228 350.76 over twelve years.** -/
theorem overTheCounter_totals :
    overTheCounter.annualCost = 57087689/3000 ∧
    overTheCounter.lifetimeCost = 57087689/250 ∧
    overTheCounter.lifetimeHours = 6000 := by
  refine ⟨by norm_num, by norm_num, by norm_num⟩

/-- **The tractor is the small part of the cost of a tractor.**  Ownership and
repairs together are under an eighth of the hourly cost; the rest is diesel,
oil and the driver. -/
theorem overTheCounter_machine_share_small :
    8 * overTheCounter.machinePerHour < overTheCounter.costPerHour := by
  norm_num

/-- **Nineteen times over.**  Twelve years of owning and working the machine
cost more than nineteen times what the machine cost to build. -/
theorem overTheCounter_lifetime_vs_purchase :
    19 * counterPrice < overTheCounter.lifetimeCost ∧
      overTheCounter.lifetimeCost < 20 * counterPrice := by
  constructor <;> · norm_num

/-! ## Bought in -/

/-- **4598 a year, 36.84 an hour, 46.04 an hour all told; 276 216 over twelve
years.** -/
theorem boughtIn_figures :
    boughtIn.ownershipPerYear = 4598 ∧
    boughtIn.operatingPerHour = 921/25 ∧
    boughtIn.costPerHour = 11509/250 ∧
    boughtIn.lifetimeCost = 276216 := by
  refine ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- For the bought machine the machine really is a large part of the cost: over
a quarter of the hour goes on owning and repairing it. -/
theorem boughtIn_machine_share_large :
    boughtIn.costPerHour < 4 * boughtIn.machinePerHour := by
  norm_num

/-! ## The comparison -/

/-- **The open-source machine is cheaper to own in both halves of the
account** — cheaper to have and cheaper to run — so it is cheaper at every
level of use, with no crossover. -/
theorem overTheCounter_dominates :
    overTheCounter.ownershipPerYear ≤ boughtIn.ownershipPerYear ∧
    overTheCounter.operatingPerHour ≤ boughtIn.operatingPerHour ∧
    ∀ h : ℚ, 0 ≤ h → overTheCounter.annualAt h ≤ boughtIn.annualAt h := by
  refine ⟨by norm_num, by norm_num, fun h hh => ?_⟩
  exact overTheCounter.annualAt_le_of_dominates boughtIn (by norm_num) (by norm_num) hh

/-- **7.98 an hour cheaper — a sixth of the cost of the hour.** -/
theorem hourly_saving :
    boughtIn.costPerHour - overTheCounter.costPerHour = 11966311/1500000 ∧
      6 * (boughtIn.costPerHour - overTheCounter.costPerHour) > boughtIn.costPerHour := by
  refine ⟨by norm_num, by norm_num⟩

/-- **47 865.24 cheaper over twelve years** — four times the cost of building
the machine in the first place. -/
theorem lifetime_saving :
    boughtIn.lifetimeCost - overTheCounter.lifetimeCost = 11966311/250 ∧
      4 * counterPrice < boughtIn.lifetimeCost - overTheCounter.lifetimeCost := by
  refine ⟨by norm_num, by norm_num⟩

/-- **Digging your own ore barely shows up.**  The full bootstrap saves 2606
over twelve years against buying the stock — a saving of under one part in
eighty of the cost of ownership, because what dominates is the diesel and the
driver, not the steel. -/
theorem bootstrap_saving_is_small :
    fromTheGround.lifetimeCost < overTheCounter.lifetimeCost ∧
    overTheCounter.lifetimeCost - fromTheGround.lifetimeCost =
      325755845559711/125000000000 ∧
    80 * (overTheCounter.lifetimeCost - fromTheGround.lifetimeCost) <
      overTheCounter.lifetimeCost := by
  refine ⟨by norm_num, by norm_num, by norm_num⟩

/-- Not charging yourself for the 92 hours of assembly saves 4959 over twelve
years: rather more than digging your own ore does. -/
theorem unpaid_saving :
    overTheCounter.lifetimeCost - unpaidBuilder.lifetimeCost = 1239700/250 ∧
      overTheCounter.lifetimeCost - fromTheGround.lifetimeCost <
        overTheCounter.lifetimeCost - unpaidBuilder.lifetimeCost := by
  refine ⟨by norm_num, by norm_num⟩

/-! ## Own or hire -/

/-- **Owning pays from seventy-seven hours a year.**  Below that a contractor
at 55 an hour is cheaper; above it the self-built machine is. -/
theorem overTheCounter_hire_crossover :
    overTheCounter.hireBreakEvenHours contractorRate = 46100390/600447 ∧
    (∀ h : ℚ, overTheCounter.annualAt h ≤ contractorRate * h ↔
      overTheCounter.hireBreakEvenHours contractorRate ≤ h) := by
  refine ⟨by norm_num, fun h => overTheCounter.hireBreakEvenHours_spec (by norm_num) h⟩

/-- The bought machine has to work 253 hours a year before it beats the
contractor — **more than three times as much** as the self-built one. -/
theorem boughtIn_hire_crossover :
    boughtIn.hireBreakEvenHours contractorRate = 57475/227 ∧
      3 * overTheCounter.hireBreakEvenHours contractorRate <
        boughtIn.hireBreakEvenHours contractorRate := by
  refine ⟨by norm_num, by norm_num⟩

/-! ## What it does to the wheat

`Farm.lean` computes a gross margin of 653 a hectare for wheat, charging seed
and diesel but neither the operator nor the machine.  Here everything is
charged. -/

/-- **85.63 a hectare of wheat with the self-built machine, 103.58 with the
bought one**, at 2.25 machine hours a hectare. -/
theorem wheat_hectare_cost :
    overTheCounter.hectareCost wheat = 171263067/2000000 ∧
    boughtIn.hectareCost wheat = 103581/1000 := by
  constructor <;> · rw [Costs.hectareCost, wheat_hoursPerHa]; norm_num

/-- The margin left per hectare once the operator, the oil and the repairs are
paid: 601.28 with the self-built machine, 597.11 with the bought one. -/
theorem wheat_net_margins :
    overTheCounter.netMarginPerHa wheat = 24051341/40000 ∧
    boughtIn.netMarginPerHa wheat = 59711/100 := by
  have hm : wheat.marginPerHa (3/2) = 653 := wheat_marginPerHa
  constructor
  · rw [Costs.netMarginPerHa, wheat_hoursPerHa,
      show overTheCounter.fuelPrice = (3/2 : ℚ) from rfl, hm]
    norm_num
  · rw [Costs.netMarginPerHa, wheat_hoursPerHa,
      show boughtIn.fuelPrice = (3/2 : ℚ) from rfl, hm]
    norm_num

/-- **Break-even is 2.56 hectares of wheat for the self-built machine and 7.70
for the bought one** — three times the land to stand still. -/
theorem wheat_break_even_areas :
    overTheCounter.fullBreakEvenArea wheat = 184401560/72154023 ∧
    boughtIn.fullBreakEvenArea wheat = 459800/59711 ∧
    3 * overTheCounter.fullBreakEvenArea wheat < boughtIn.fullBreakEvenArea wheat := by
  have h₁ := wheat_net_margins.1
  have h₂ := wheat_net_margins.2
  refine ⟨?_, ?_, ?_⟩
  · rw [Costs.fullBreakEvenArea, h₁]; norm_num
  · rw [Costs.fullBreakEvenArea, h₂]; norm_num
  · rw [Costs.fullBreakEvenArea, Costs.fullBreakEvenArea, h₁, h₂]; norm_num

/-- **Twenty hectares of wheat no longer pay for the machine in one season.**
`Farm.wheat_20ha_pays_for_the_machine` says they do, but it pays the operator
nothing and charges no depreciation: with the full cost of ownership the season
clears 10 488.99 against a build cost of 11 851, so the machine is paid off
early in its second season instead. -/
theorem wheat_20ha_full_cost :
    overTheCounter.fullSeasonProfit wheat 20 = 12586789/1200 ∧
    overTheCounter.fullSeasonProfit wheat 20 < counterPrice ∧
    counterPrice < 2 * overTheCounter.fullSeasonProfit wheat 20 := by
  have h₁ := wheat_net_margins.1
  refine ⟨?_, ?_, ?_⟩ <;>
    · rw [Costs.fullSeasonProfit, h₁]
      norm_num

/-- A season of twenty hectares is still comfortably profitable, and the
machine is well past break-even area. -/
theorem wheat_20ha_profitable :
    0 ≤ overTheCounter.fullSeasonProfit wheat 20 := by
  have h₁ := wheat_net_margins.1
  rw [Costs.fullSeasonProfit, h₁]
  norm_num

/-! ## What the answer is sensitive to

The cost of ownership is not equally sensitive to all of its inputs.  Two
experiments settle which of them the answer really turns on. -/

/-- The same machine used less, or more, than the assumed 500 hours a year. -/
theorem overTheCounter_usage_sensitivity :
    overTheCounter.hourlyAt 200 = 25601099/600000 ∧
    overTheCounter.hourlyAt 1000 = 109565339/3000000 ∧
    overTheCounter.hourlyAt 1000 < overTheCounter.hourlyAt 200 := by
  refine ⟨by norm_num, by norm_num, overTheCounter.hourlyAt_strictAnti (by norm_num) (by norm_num)⟩

/-- However hard it is worked, the hour never falls below the 34.99 of fuel,
oil, parts and wages. -/
theorem overTheCounter_floor {h : ℚ} (hh : 0 < h) :
    349851/10000 < overTheCounter.hourlyAt h := by
  have := overTheCounter.operating_lt_hourlyAt hh
  rw [show overTheCounter.operatingPerHour = 349851/10000 by norm_num] at this
  exact this

/-- The same machine at a different diesel price. -/
def atFuelPrice (p : ℚ) (hp : 0 ≤ p) : Costs :=
  { overTheCounter with fuelPrice := p, fuelPrice_nonneg := hp }

/-- **Diesel matters three times as much as the machine.**  Doubling the fuel
price to 3.00 adds 13.80 to the hour — more than three times the 4.26 an hour
that owning and repairing the tractor costs in the first place. -/
theorem diesel_price_dominates :
    (atFuelPrice 3 (by norm_num)).costPerHour - overTheCounter.costPerHour = 69/5 ∧
      3 * overTheCounter.machinePerHour <
        (atFuelPrice 3 (by norm_num)).costPerHour - overTheCounter.costPerHour := by
  constructor <;> · norm_num [atFuelPrice]

/-! ## Running it on wood

`Sources.lean` and `EnergyPlan.lean` show that a producer-gas set will run the
machine on 31.49 kg of air-dry wood per hectare tilled, which at 2.25 hours a
hectare is 14 kg an hour.  A gasifier is assumed to cost 2000 to build, and the
engine to lose 30 % of its power on gas, so that everything takes 10/7 as long.
The operator is assumed to tend the gasifier at no extra charge. -/

/-- What a shop-built gasifier and its plumbing are taken to cost. -/
def gasifierPrice : ℚ := 2000

/-- Wood burnt per hour of work, in kilograms. -/
def woodPerHour : ℚ := 500000/35721

/-- The power lost on producer gas, as a stretch factor on the hours a job
takes. -/
def woodGasDerate : ℚ := 10/7

/-- The hourly wood burn is the per-hectare figure of `EnergyPlan.lean` spread
over the 2.25 machine hours a hectare of wheat takes. -/
theorem woodPerHour_eq : woodPerHour = EnergyPlan.woodPerHectare / wheat.hoursPerHa := by
  rw [wheat_hoursPerHa, EnergyPlan.tillage_figures.2, woodPerHour]
  norm_num

/-- The self-built machine with a gasifier on the back, burning wood at 0.06 a
kilogram instead of diesel at 1.50 a litre. -/
def woodGasFuelled : Costs :=
  { overTheCounter with
    purchase := counterPrice + gasifierPrice
    fuelPerHour := woodPerHour
    fuelPrice := woodPrice
    purchase_pos := by rw [counterPrice, gasifierPrice]; norm_num
    fuelPerHour_nonneg := by rw [woodPerHour]; norm_num
    fuelPrice_nonneg := by rw [woodPrice]; norm_num }

attribute [local simp] woodPrice gasifierPrice woodPerHour woodGasFuelled

/-- **0.84 an hour of wood against 12.00 an hour of diesel.**  Ownership rises
with the gasifier, but the hour falls from 38.06 to 25.94 and the twelve-year
bill from 228 350.76 to 155 657.67. -/
theorem woodGas_figures :
    woodGasFuelled.fuelCostPerHour = 10000/11907 ∧
    woodGasFuelled.ownershipPerYear = 1796013/1000 ∧
    woodGasFuelled.costPerHour = 154451319641/5953500000 ∧
    woodGasFuelled.lifetimeCost = 154451319641/992250 := by
  refine ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- **72 693 saved over twelve years — six times what the machine cost to
build.**  Fuel, not capital, is where an open-source machine can win big. -/
theorem woodGas_saving :
    overTheCounter.lifetimeCost - woodGasFuelled.lifetimeCost = 288518872/3969 ∧
      6 * counterPrice < overTheCounter.lifetimeCost - woodGasFuelled.lifetimeCost := by
  refine ⟨by norm_num, by norm_num⟩

/-- The cost of a hectare of wheat on wood gas, the 30 % power loss lengthening
every job by a factor of 10/7. -/
def woodGasHectareCost : ℚ := woodGasFuelled.costPerHour * wheat.hoursPerHa * woodGasDerate

/-- **But per hectare the wood barely wins.**  83.39 against 85.63: the derated
engine takes 10/7 as long, and the extra hours of the operator's time eat all
but three per cent of a fuel bill that fell by nine tenths. -/
theorem woodGas_per_hectare_barely_wins :
    woodGasHectareCost = 154451319641/1852200000 ∧
    woodGasHectareCost < overTheCounter.hectareCost wheat ∧
    overTheCounter.hectareCost wheat < 103/100 * woodGasHectareCost := by
  have h : woodGasHectareCost = 154451319641/1852200000 := by
    rw [woodGasHectareCost, wheat_hoursPerHa, woodGasDerate, woodGas_figures.2.2.1]
    norm_num
  have h' : overTheCounter.hectareCost wheat = 171263067/2000000 := wheat_hectare_cost.1
  refine ⟨h, ?_, ?_⟩
  · rw [h, h']; norm_num
  · rw [h, h']; norm_num

/-- **The lesson of the whole account.**  Rank the levers by what they save
over twelve years: fuelling the machine on wood saves 72 693, building it
rather than buying it saves 47 865, and digging your own ore saves 2606.  The
machine is the cheap part; what it eats is not. -/
theorem the_levers_ranked :
    overTheCounter.lifetimeCost - fromTheGround.lifetimeCost <
      boughtIn.lifetimeCost - overTheCounter.lifetimeCost ∧
    boughtIn.lifetimeCost - overTheCounter.lifetimeCost <
      overTheCounter.lifetimeCost - woodGasFuelled.lifetimeCost := by
  refine ⟨by norm_num, by norm_num⟩

end Ownership
end LifeTrac
