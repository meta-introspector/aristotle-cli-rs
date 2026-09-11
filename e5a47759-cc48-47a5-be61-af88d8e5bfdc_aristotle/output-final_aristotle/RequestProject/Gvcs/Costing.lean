import RequestProject.Gvcs.Farm

/-!
# The cost of owning a machine

`Materials` says what the tractor costs to *build* and `Farm` says what it can
*earn*.  Neither of them says what it costs to *own*, which is the figure a
buyer actually cares about: the capital tied up in the machine, the interest on
it, the shed it stands in, the fuel and oil it drinks, the parts that wear out
and the operator who drives it.

This file develops that accounting in the standard engineering form (the
ASABE-style split into *ownership* costs, booked per year, and *operating*
costs, booked per hour):

```
ownership per year = depreciation + interest on the average investment
                     + taxes, insurance and housing
operating per hour = fuel + lubricants + repairs + operator
cost per hour      = ownership per year / annual hours + operating per hour
```

Everything is exact rational arithmetic, so every figure below is a decidable
consequence of the input data.  Currency is left abstract — read it as whatever
unit the material prices of `Materials.lean` are quoted in.

The general results are:

* `Costs.costPerHour_eq`, the closed form of the hourly cost as an affine
  function of the purchase price;
* `Costs.hourlyAt_strictAnti`, that the hourly cost falls strictly with
  annual use, but never below `operatingPerHour` (`Costs.operating_lt_hourlyAt`)
  and, past `N` hours a year, by no more than `ownershipPerYear / N`
  (`Costs.hourlyAt_le_of_le`);
* `Costs.breakEvenHours_spec`, the annual usage at which a dear machine with
  cheap running overtakes a cheap machine with dear running, and
  `Costs.annualAt_le_of_dominates`, the case in which no such crossover exists;
* `Costs.fullSeasonProfit_nonneg_iff`, the break-even area of a season once the
  full cost of ownership — not merely the fuel and seed of `Farm.lean` — is
  charged against the crop.

`RequestProject/Ownership.lean` puts numbers into all of it.
-/

namespace LifeTrac
namespace Ownership

open Build

/-! ## The cost model -/

/-- Everything needed to cost the ownership and operation of one machine.

`repairRate` is the fraction of the purchase price spent on repairs and
maintenance per 1000 hours of use; `insuranceFrac` the fraction spent per year
on taxes, insurance and housing; `lubeFrac` the lubricant bill as a fraction of
the fuel bill. -/
structure Costs where
  /-- Delivered capital cost of the machine. -/
  purchase : ℚ
  /-- Fraction of the purchase price recovered at the end of the machine's life. -/
  salvageFrac : ℚ
  /-- Service life, in years. -/
  lifeYears : ℚ
  /-- Hours worked per year. -/
  annualHours : ℚ
  /-- Annual interest rate on the capital. -/
  interest : ℚ
  /-- Taxes, insurance and housing, as a fraction of the purchase price per year. -/
  insuranceFrac : ℚ
  /-- Fuel burn, litres per hour. -/
  fuelPerHour : ℚ
  /-- Fuel price per litre. -/
  fuelPrice : ℚ
  /-- Lubricants, as a fraction of the fuel bill. -/
  lubeFrac : ℚ
  /-- Repairs and maintenance per 1000 hours, as a fraction of the purchase price. -/
  repairRate : ℚ
  /-- Operator's wage per hour. -/
  wage : ℚ
  purchase_pos : 0 < purchase
  salvageFrac_nonneg : 0 ≤ salvageFrac
  salvageFrac_lt_one : salvageFrac < 1
  lifeYears_pos : 0 < lifeYears
  annualHours_pos : 0 < annualHours
  interest_nonneg : 0 ≤ interest
  insuranceFrac_nonneg : 0 ≤ insuranceFrac
  fuelPerHour_nonneg : 0 ≤ fuelPerHour
  fuelPrice_nonneg : 0 ≤ fuelPrice
  lubeFrac_nonneg : 0 ≤ lubeFrac
  repairRate_nonneg : 0 ≤ repairRate
  wage_nonneg : 0 ≤ wage

namespace Costs

variable (c : Costs)

/-- What the machine is worth when it is done with. -/
def salvage : ℚ := c.salvageFrac * c.purchase

/-- Straight-line depreciation, per year. -/
def depreciationPerYear : ℚ := (c.purchase - c.salvage) / c.lifeYears

/-- Interest on the average investment `(purchase + salvage)/2`, per year. -/
def interestPerYear : ℚ := c.interest * (c.purchase + c.salvage) / 2

/-- Taxes, insurance and housing, per year. -/
def insurancePerYear : ℚ := c.insuranceFrac * c.purchase

/-- The cost of *having* the machine, whether or not it is used: depreciation,
interest, and taxes/insurance/housing. -/
def ownershipPerYear : ℚ :=
  c.depreciationPerYear + c.interestPerYear + c.insurancePerYear

/-- The same, spread over the hours actually worked. -/
def ownershipPerHour : ℚ := c.ownershipPerYear / c.annualHours

/-- Fuel, per hour of work. -/
def fuelCostPerHour : ℚ := c.fuelPerHour * c.fuelPrice

/-- Lubricants and filters, per hour of work. -/
def lubeCostPerHour : ℚ := c.lubeFrac * c.fuelCostPerHour

/-- Repairs and maintenance, per hour of work. -/
def repairPerHour : ℚ := c.repairRate * c.purchase / 1000

/-- The cost of *using* the machine for an hour. -/
def operatingPerHour : ℚ :=
  c.fuelCostPerHour + c.lubeCostPerHour + c.repairPerHour + c.wage

/-- The part of the hourly cost that is attributable to this machine rather
than to the fuel it burns and the man who drives it: ownership plus repairs. -/
def machinePerHour : ℚ := c.ownershipPerHour + c.repairPerHour

/-- The part of the hourly cost that is *not* the fuel: everything a gross
margin computed as in `Farm.lean` leaves out. -/
def overheadPerHour : ℚ :=
  c.ownershipPerHour + c.lubeCostPerHour + c.repairPerHour + c.wage

/-- The non-fuel costs that scale with the hours worked (so, unlike
`overheadPerHour`, excluding the annual ownership charge). -/
def variablePerHour : ℚ := c.lubeCostPerHour + c.repairPerHour + c.wage

/-- **The total cost of ownership, per hour worked.** -/
def costPerHour : ℚ := c.ownershipPerHour + c.operatingPerHour

/-- The total cost of a year of ownership at the planned usage. -/
def annualCost : ℚ := c.ownershipPerYear + c.annualHours * c.operatingPerHour

/-- Hours the machine works over its whole life. -/
def lifetimeHours : ℚ := c.lifeYears * c.annualHours

/-- **The total cost of ownership over the machine's whole life.** -/
def lifetimeCost : ℚ := c.lifeYears * c.annualCost

/-- The hourly cost the machine would have at an annual usage of `h` hours. -/
def hourlyAt (h : ℚ) : ℚ := c.ownershipPerYear / h + c.operatingPerHour

/-- The annual cost the machine would have at an annual usage of `h` hours. -/
def annualAt (h : ℚ) : ℚ := c.ownershipPerYear + h * c.operatingPerHour

/-! ## Signs and closed forms -/

theorem salvage_nonneg : 0 ≤ c.salvage :=
  mul_nonneg c.salvageFrac_nonneg c.purchase_pos.le

theorem salvage_lt_purchase : c.salvage < c.purchase := by
  have := c.purchase_pos
  have := c.salvageFrac_lt_one
  unfold salvage
  nlinarith

theorem depreciationPerYear_pos : 0 < c.depreciationPerYear :=
  div_pos (sub_pos.2 c.salvage_lt_purchase) c.lifeYears_pos

theorem interestPerYear_nonneg : 0 ≤ c.interestPerYear :=
  div_nonneg (mul_nonneg c.interest_nonneg (by linarith [c.salvage_nonneg, c.purchase_pos]))
    (by norm_num)

theorem insurancePerYear_nonneg : 0 ≤ c.insurancePerYear :=
  mul_nonneg c.insuranceFrac_nonneg c.purchase_pos.le

theorem ownershipPerYear_pos : 0 < c.ownershipPerYear := by
  have h₁ := c.depreciationPerYear_pos
  have h₂ := c.interestPerYear_nonneg
  have h₃ := c.insurancePerYear_nonneg
  unfold ownershipPerYear
  linarith

theorem fuelCostPerHour_nonneg : 0 ≤ c.fuelCostPerHour :=
  mul_nonneg c.fuelPerHour_nonneg c.fuelPrice_nonneg

theorem lubeCostPerHour_nonneg : 0 ≤ c.lubeCostPerHour :=
  mul_nonneg c.lubeFrac_nonneg c.fuelCostPerHour_nonneg

theorem repairPerHour_nonneg : 0 ≤ c.repairPerHour :=
  div_nonneg (mul_nonneg c.repairRate_nonneg c.purchase_pos.le) (by norm_num)

theorem operatingPerHour_nonneg : 0 ≤ c.operatingPerHour := by
  have h₁ := c.fuelCostPerHour_nonneg
  have h₂ := c.lubeCostPerHour_nonneg
  have h₃ := c.repairPerHour_nonneg
  have h₄ := c.wage_nonneg
  unfold operatingPerHour
  linarith

theorem ownershipPerHour_pos : 0 < c.ownershipPerHour :=
  div_pos c.ownershipPerYear_pos c.annualHours_pos

theorem costPerHour_pos : 0 < c.costPerHour := by
  have := c.ownershipPerHour_pos
  have := c.operatingPerHour_nonneg
  unfold costPerHour
  linarith

/-- The hourly cost at the planned usage is `hourlyAt` at the planned usage. -/
theorem costPerHour_eq_hourlyAt : c.costPerHour = c.hourlyAt c.annualHours := rfl

theorem annualCost_eq_annualAt : c.annualCost = c.annualAt c.annualHours := rfl

/-- **The closed form.**  The hourly cost is an affine function of the purchase
price: a capital-recovery coefficient times the price, plus the running costs
that do not depend on it. -/
theorem costPerHour_eq :
    c.costPerHour =
      ((1 - c.salvageFrac) / c.lifeYears + c.interest * (1 + c.salvageFrac) / 2
          + c.insuranceFrac) * c.purchase / c.annualHours
        + c.repairRate * c.purchase / 1000
        + (1 + c.lubeFrac) * (c.fuelPerHour * c.fuelPrice) + c.wage := by
  have hl := c.lifeYears_pos.ne'
  have ha := c.annualHours_pos.ne'
  simp only [costPerHour, ownershipPerHour, ownershipPerYear, depreciationPerYear,
    interestPerYear, insurancePerYear, operatingPerHour, fuelCostPerHour, lubeCostPerHour,
    repairPerHour, salvage]
  field_simp
  ring

/-- The whole-life cost, split into the annual charges and the hourly ones. -/
theorem lifetimeCost_eq :
    c.lifetimeCost = c.lifeYears * c.ownershipPerYear + c.lifetimeHours * c.operatingPerHour := by
  unfold lifetimeCost annualCost lifetimeHours
  ring

/-- Over the whole life the ownership charge is the capital lost, plus the
interest and the insurance for every year of it. -/
theorem lifetime_ownership_eq :
    c.lifeYears * c.ownershipPerYear =
      (c.purchase - c.salvage) + c.lifeYears * (c.interestPerYear + c.insurancePerYear) := by
  have hl := c.lifeYears_pos.ne'
  unfold ownershipPerYear depreciationPerYear
  field_simp
  ring

/-- The hourly cost splits into what the machine costs and what running it
costs. -/
theorem costPerHour_split :
    c.costPerHour = c.machinePerHour + (c.fuelCostPerHour + c.lubeCostPerHour + c.wage) := by
  unfold costPerHour machinePerHour operatingPerHour
  ring

/-- Everything a `Farm.lean` gross margin omits, and the fuel it charges. -/
theorem costPerHour_eq_overhead_add_fuel :
    c.costPerHour = c.overheadPerHour + c.fuelCostPerHour := by
  unfold costPerHour overheadPerHour operatingPerHour
  ring

theorem overheadPerHour_eq : c.overheadPerHour = c.ownershipPerHour + c.variablePerHour := by
  unfold overheadPerHour variablePerHour
  ring

theorem variablePerHour_nonneg : 0 ≤ c.variablePerHour := by
  have h₁ := c.lubeCostPerHour_nonneg
  have h₂ := c.repairPerHour_nonneg
  have h₃ := c.wage_nonneg
  unfold variablePerHour
  linarith

/-! ## How the hourly cost depends on the use the machine gets -/

/-- **Spreading the fixed cost.**  The more the machine is used, the less each
hour of it costs. -/
theorem hourlyAt_strictAnti {h₁ h₂ : ℚ} (h₁pos : 0 < h₁) (hlt : h₁ < h₂) :
    c.hourlyAt h₂ < c.hourlyAt h₁ := by
  have hown := c.ownershipPerYear_pos
  have h₂pos : 0 < h₂ := h₁pos.trans hlt
  unfold hourlyAt
  have : c.ownershipPerYear / h₂ < c.ownershipPerYear / h₁ :=
    div_lt_div_of_pos_left hown h₁pos hlt
  linarith

/-- However hard the machine is worked, an hour of it costs more than the fuel,
oil, parts and wages of that hour. -/
theorem operating_lt_hourlyAt {h : ℚ} (hpos : 0 < h) :
    c.operatingPerHour < c.hourlyAt h := by
  have := div_pos c.ownershipPerYear_pos hpos
  unfold hourlyAt
  linarith

/-- Past `N` hours a year, the fixed cost adds at most `ownershipPerYear / N`
to the hour. -/
theorem hourlyAt_le_of_le {N h : ℚ} (hN : 0 < N) (hNh : N ≤ h) :
    c.hourlyAt h ≤ c.operatingPerHour + c.ownershipPerYear / N := by
  have hown := c.ownershipPerYear_pos.le
  have : c.ownershipPerYear / h ≤ c.ownershipPerYear / N :=
    div_le_div_of_nonneg_left hown hN hNh
  unfold hourlyAt
  linarith

/-- The annual cost is affine in the hours worked, so it is monotone in them. -/
theorem annualAt_mono {h₁ h₂ : ℚ} (hle : h₁ ≤ h₂) : c.annualAt h₁ ≤ c.annualAt h₂ := by
  have := c.operatingPerHour_nonneg
  unfold annualAt
  nlinarith

theorem annualAt_eq_mul_hourlyAt {h : ℚ} (hpos : 0 < h) :
    c.annualAt h = h * c.hourlyAt h := by
  unfold annualAt hourlyAt
  field_simp

/-! ## Comparing two machines -/

/-- The annual usage at which machine `d` — dearer to own, cheaper to run —
overtakes machine `c`. -/
def breakEvenHours (d : Costs) : ℚ :=
  (d.ownershipPerYear - c.ownershipPerYear) / (c.operatingPerHour - d.operatingPerHour)

/-- **The crossover.**  If `d` runs more cheaply by the hour than `c`, then `d`
is the cheaper machine to have exactly from `breakEvenHours` hours a year
upwards. -/
theorem breakEvenHours_spec (d : Costs) (hop : d.operatingPerHour < c.operatingPerHour)
    (h : ℚ) :
    d.annualAt h ≤ c.annualAt h ↔ c.breakEvenHours d ≤ h := by
  have hpos : 0 < c.operatingPerHour - d.operatingPerHour := by linarith
  unfold annualAt breakEvenHours
  rw [div_le_iff₀ hpos]
  constructor <;> intro hh <;> nlinarith

/-- At the crossover the two machines cost the same. -/
theorem breakEvenHours_eq (d : Costs) (hop : d.operatingPerHour < c.operatingPerHour) :
    d.annualAt (c.breakEvenHours d) = c.annualAt (c.breakEvenHours d) := by
  have hne : c.operatingPerHour - d.operatingPerHour ≠ 0 := by
    intro hc; rw [sub_eq_zero] at hc; exact absurd hc hop.ne'
  unfold annualAt breakEvenHours
  field_simp
  ring

/-- **No crossover.**  A machine that is both cheaper to own and cheaper to run
is cheaper at every level of use. -/
theorem annualAt_le_of_dominates (d : Costs) (hown : c.ownershipPerYear ≤ d.ownershipPerYear)
    (hop : c.operatingPerHour ≤ d.operatingPerHour) {h : ℚ} (hh : 0 ≤ h) :
    c.annualAt h ≤ d.annualAt h := by
  unfold annualAt
  nlinarith

/-- … and its hour is cheaper too. -/
theorem hourlyAt_le_of_dominates (d : Costs) (hown : c.ownershipPerYear ≤ d.ownershipPerYear)
    (hop : c.operatingPerHour ≤ d.operatingPerHour) {h : ℚ} (hh : 0 < h) :
    c.hourlyAt h ≤ d.hourlyAt h := by
  have : c.ownershipPerYear / h ≤ d.ownershipPerYear / h := by gcongr
  unfold hourlyAt
  linarith

/-- The annual usage at which owning the machine becomes cheaper than hiring
the same work done at `rate` an hour, all found. -/
def hireBreakEvenHours (rate : ℚ) : ℚ := c.ownershipPerYear / (rate - c.operatingPerHour)

/-- **Own or hire.**  If the contractor's rate beats nothing but the running
costs, owning the machine pays exactly from `hireBreakEvenHours` hours a year
upwards. -/
theorem hireBreakEvenHours_spec {rate : ℚ} (hr : c.operatingPerHour < rate) (h : ℚ) :
    c.annualAt h ≤ rate * h ↔ c.hireBreakEvenHours rate ≤ h := by
  have hpos : 0 < rate - c.operatingPerHour := by linarith
  unfold annualAt hireBreakEvenHours
  rw [div_le_iff₀ hpos]
  constructor <;> intro hh <;> nlinarith

/-- Below that usage, hiring is cheaper. -/
theorem hire_cheaper_below {rate h : ℚ} (hr : c.operatingPerHour < rate)
    (hlt : h < c.hireBreakEvenHours rate) : rate * h < c.annualAt h := by
  by_contra hc
  push_neg at hc
  exact absurd ((c.hireBreakEvenHours_spec hr h).1 hc) (not_le.2 hlt)

/-! ## What it does to the farm

`Farm.seasonProfit` charges the crop with seed and fuel and takes the fixed
cost of the machine as a free parameter.  Here that parameter is filled in from
the cost model, and the operator, the lubricants and the repairs — which
`Farm.marginPerHa` also omits — are charged as well. -/

/-- The full cost of covering one hectare of a crop: every hour the crop needs,
charged at the full hourly cost of ownership. -/
def hectareCost (crop : Crop) : ℚ := c.costPerHour * crop.hoursPerHa

/-- The margin per hectare after the machine's non-fuel running costs (the fuel
and seed already being charged by `Crop.marginPerHa`), but before the annual
ownership charge. -/
def netMarginPerHa (crop : Crop) : ℚ :=
  crop.marginPerHa c.fuelPrice - c.variablePerHour * crop.hoursPerHa

/-- **The profit of a season, with nothing left out**: the crop's gross margin,
less the operator, lubricants and repairs of every hour it takes, less the
whole year's ownership charge. -/
def fullSeasonProfit (crop : Crop) (area : ℚ) : ℚ :=
  area * c.netMarginPerHa crop - c.ownershipPerYear

/-- The area that has to be farmed before the machine has paid for its year. -/
def fullBreakEvenArea (crop : Crop) : ℚ := c.ownershipPerYear / c.netMarginPerHa crop

theorem fullSeasonProfit_eq_seasonProfit (crop : Crop) (area : ℚ) :
    c.fullSeasonProfit crop area =
      seasonProfit crop c.fuelPrice area c.ownershipPerYear
        - area * (c.variablePerHour * crop.hoursPerHa) := by
  unfold fullSeasonProfit netMarginPerHa seasonProfit seasonMargin
  ring

/-- **The honest break-even.**  With a positive net margin, a season pays for
the machine exactly above `fullBreakEvenArea`. -/
theorem fullSeasonProfit_nonneg_iff (crop : Crop) (hm : 0 < c.netMarginPerHa crop) (area : ℚ) :
    0 ≤ c.fullSeasonProfit crop area ↔ c.fullBreakEvenArea crop ≤ area := by
  unfold fullSeasonProfit fullBreakEvenArea
  rw [sub_nonneg, div_le_iff₀ hm]

/-- At exactly the break-even area the season washes its face. -/
theorem fullSeasonProfit_breakEven (crop : Crop) (hm : c.netMarginPerHa crop ≠ 0) :
    c.fullSeasonProfit crop (c.fullBreakEvenArea crop) = 0 := by
  unfold fullSeasonProfit fullBreakEvenArea
  field_simp
  ring

/-- Charging the full cost of ownership can only make a season look worse than
the gross-margin arithmetic of `Farm.lean` does. -/
theorem fullSeasonProfit_le_seasonProfit (crop : Crop) {area : ℚ} (ha : 0 ≤ area) :
    c.fullSeasonProfit crop area ≤ seasonProfit crop c.fuelPrice area c.ownershipPerYear := by
  rw [fullSeasonProfit_eq_seasonProfit]
  have h₁ : 0 ≤ c.variablePerHour * crop.hoursPerHa :=
    mul_nonneg c.variablePerHour_nonneg crop.hoursPerHa_nonneg
  nlinarith

end Costs
end Ownership
end LifeTrac
