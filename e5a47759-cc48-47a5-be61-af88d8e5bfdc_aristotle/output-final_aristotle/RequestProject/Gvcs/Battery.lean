import RequestProject.Gvcs.PowerCube

/-!
# The nickel-iron battery: rates, lifetime and what a stored kilowatt-hour costs

The Open Source Ecology wiki calls the nickel-iron cell "the only known
lifetime design battery" and makes it the Global Village Construction Set's
primary store of electricity.  This file imports the quantitative part of that
page (*Nickel-Iron Battery*, read in August 2026) and works out what it
implies.

The figures taken from the page are:

* a maximum charge and discharge rate of **C/2**, with **C/4** given as the
  optimal rate;
* a note that discharging at **1C** appears to deliver only about **70 %** of
  the rated capacity — the page itself doubts this figure, so it is used here
  only inside a statement that says "if that is so, then…";
* **3500 cycles at 100 % depth of discharge** for the 2017 sintered-electrode
  cell;
* a service life of order **50 years**, against a few years for lead-acid;
* a capital cost of order **$1000 per kW**, with the page's argument that the
  real cost is that figure divided by the number of lives you get out of the
  core, since only the electrolyte and casing are replaced.

What comes out of them:

* At the maximum rate the pack empties in two hours, at the optimal rate in
  four; halving the rate doubles the runtime (`hours_at_max_rate`,
  `hours_at_optimal_rate`, `optimal_rate_doubles_the_runtime`).
* The page's cost argument, made precise: amortised cost is capital divided by
  life, so a battery that costs `k` times more is cheaper in the long run
  exactly when it lasts more than `k` times longer
  (`cheaper_over_time_iff`).  With fifty years against five, nickel-iron wins
  at up to ten times the price of the thing it replaces
  (`nife_wins_at_ten_times_the_price`).
* "$1000 per kW" is a price on *power*; at the optimal C/4 rate a kilowatt of
  discharge is four kilowatt-hours of capacity, so the same figure is $250 per
  kilowatt-hour (`dollars_per_kWh_at_optimal_rate`), and spread over 3500 full
  cycles that is just over seven cents per kilowatt-hour delivered
  (`cost_per_delivered_kWh`).
-/

namespace LifeTrac
namespace NiFe

noncomputable section

/-! ## Discharge rates

A rate is given as a multiple of `C`: at rate `r` the pack delivers `r` times
its rated capacity per hour, so an ideal constant-current discharge lasts
`1/r` hours. -/

/-- Hours an ideal discharge at `r` times the C rate lasts. -/
def dischargeHours (r : ℝ) : ℝ := 1 / r

/-- The maximum charge or discharge rate the page allows. -/
def maxRate : ℝ := 1 / 2

/-- The rate the page calls optimal. -/
def optimalRate : ℝ := 1 / 4

/-- A slower discharge lasts longer. -/
theorem dischargeHours_antitone {a b : ℝ} (ha : 0 < a) (hab : a < b) :
    dischargeHours b < dischargeHours a := by
  unfold dischargeHours
  exact one_div_lt_one_div_of_lt ha hab

/-- Flat out, the pack lasts two hours. -/
theorem hours_at_max_rate : dischargeHours maxRate = 2 := by
  unfold dischargeHours maxRate; norm_num

/-- At the optimal rate it lasts four. -/
theorem hours_at_optimal_rate : dischargeHours optimalRate = 4 := by
  unfold dischargeHours optimalRate; norm_num

/-- Halving the draw doubles the runtime. -/
theorem optimal_rate_doubles_the_runtime :
    dischargeHours optimalRate = 2 * dischargeHours maxRate := by
  rw [hours_at_optimal_rate, hours_at_max_rate]; norm_num

/-- The optimal rate is inside the maximum. -/
theorem optimalRate_le_maxRate : optimalRate < maxRate := by
  unfold optimalRate maxRate; norm_num

/-! ## Capacity actually delivered

The page reports, with doubt, that a 1C discharge yields only about 70 % of
the rated capacity, against the full capacity at the gentle rates.  The
statement below is conditional on that reading. -/

/-- Fraction of rated capacity the page reports at a 1C discharge. -/
def deliveredAt1C : ℝ := 0.7

/-- **If** a 1C discharge really delivers only 70 % of capacity while a gentle
discharge delivers all of it, then draining the pack slowly gets more than
forty percent more energy out of the same cell. -/
theorem slow_discharge_delivers_more (capacity : ℝ) (hc : 0 < capacity) :
    1.4 * (deliveredAt1C * capacity) < capacity := by
  unfold deliveredAt1C; nlinarith

/-! ## The lifetime-cost argument

The page's claim is that nickel-iron's higher sticker price is not a higher
cost, because the core outlives several of everything it competes with.  Made
precise: what matters is capital divided by life. -/

/-- Cost per year of owning a store that costs `capital` and lasts `life`
years. -/
def amortised (capital life : ℝ) : ℝ := capital / life

/-- Amortised cost falls as the life grows. -/
theorem amortised_antitone_in_life {capital a b : ℝ} (hcap : 0 < capital) (ha : 0 < a)
    (hab : a < b) : amortised capital b < amortised capital a := by
  unfold amortised
  exact div_lt_div_of_pos_left hcap ha hab

/-- **The comparison in general.**  A dearer store is cheaper over time
exactly when its life outruns its price. -/
theorem cheaper_over_time_iff {c₁ l₁ c₂ l₂ : ℝ} (hl₁ : 0 < l₁) (hl₂ : 0 < l₂) :
    amortised c₁ l₁ < amortised c₂ l₂ ↔ c₁ * l₂ < c₂ * l₁ := by
  unfold amortised
  rw [div_lt_div_iff₀ hl₁ hl₂]

/-- Service life of the nickel-iron cell, in years, as the page gives it. -/
def nifeLife : ℝ := 50

/-- **Nickel-iron at ten times the price still wins**, given the page's fifty
years against a competitor that lasts five or less: whatever the competitor
costs, ten times that spread over fifty years is no more per year. -/
theorem nife_wins_at_ten_times_the_price (c l : ℝ) (hc : 0 < c) (hl : 0 < l) (hl5 : l ≤ 5) :
    amortised (10 * c) nifeLife ≤ amortised c l := by
  unfold amortised nifeLife
  rw [div_le_div_iff₀ (by norm_num) hl]
  nlinarith

/-- And it is strictly cheaper whenever the competitor lasts strictly less
than five years. -/
theorem nife_strictly_wins (c l : ℝ) (hc : 0 < c) (hl : 0 < l) (hl5 : l < 5) :
    amortised (10 * c) nifeLife < amortised c l := by
  unfold amortised nifeLife
  rw [div_lt_div_iff₀ (by norm_num) hl]
  nlinarith

/-! ## From dollars per kilowatt to dollars per kilowatt-hour

The page prices the battery per kilowatt — a price on power.  A store is
bought for its energy, and the two are related by the rate at which it is
allowed to discharge: at C/4 a kilowatt of draw is four kilowatt-hours of
capacity. -/

/-- The page's capital cost, in dollars per kilowatt of discharge. -/
def dollarsPerKW : ℝ := 1000

/-- Capacity, in kilowatt-hours, behind one kilowatt of discharge at rate
`r`. -/
def kWhPerKW (r : ℝ) : ℝ := dischargeHours r

/-- At the optimal rate the page's $1000 per kilowatt is $250 per
kilowatt-hour of storage. -/
theorem dollars_per_kWh_at_optimal_rate : dollarsPerKW / kWhPerKW optimalRate = 250 := by
  unfold dollarsPerKW kWhPerKW
  rw [hours_at_optimal_rate]; norm_num

/-- At the maximum rate the same money buys half the storage: $500 per
kilowatt-hour. -/
theorem dollars_per_kWh_at_max_rate : dollarsPerKW / kWhPerKW maxRate = 500 := by
  unfold dollarsPerKW kWhPerKW
  rw [hours_at_max_rate]; norm_num

/-- Full cycles the 2017 sintered-electrode cell is reported to survive at
100 % depth of discharge. -/
def cycleLife : ℝ := 3500

/-- Dollars per kilowatt-hour *delivered*, over the whole cycle life, at a
given depth of discharge. -/
def costPerDeliveredKWh (dollarsPerStoredKWh cycles depthOfDischarge : ℝ) : ℝ :=
  dollarsPerStoredKWh / (cycles * depthOfDischarge)

/-- **Just over seven cents a kilowatt-hour.**  At $250 of capital per stored
kilowatt-hour and 3500 full cycles, the energy that passes through the battery
in its life carries about 7.1 cents of capital cost apiece — and that is
before any of the page's replacement-of-electrolyte argument, which spreads
the same capital over further lives. -/
theorem cost_per_delivered_kWh :
    |costPerDeliveredKWh 250 cycleLife 1 - 0.0714| < 0.0001 := by
  unfold costPerDeliveredKWh cycleLife
  rw [abs_sub_lt_iff]; norm_num

/-- Shallower cycling costs more per unit delivered, because fewer of the
kilowatt-hours bought are ever used. -/
theorem shallow_cycling_costs_more {d₁ d₂ c s : ℝ} (hs : 0 < s) (hc : 0 < c) (hd₁ : 0 < d₁)
    (hd : d₁ < d₂) : costPerDeliveredKWh s c d₂ < costPerDeliveredKWh s c d₁ := by
  unfold costPerDeliveredKWh
  exact div_lt_div_of_pos_left hs (by positivity) (by nlinarith)

/-! ## Where the battery sits in the construction set -/

/-- The nickel-iron battery is one of the fifty machines, an energy machine
still at planning stage. -/
theorem battery_is_energy : GVCS.Machine.battery.sector = .energy := rfl

theorem battery_is_planned : GVCS.Machine.battery.status = .planning := rfl

/-- Its wiki page says it is built with a 3D printer and the rod and wire
mill, and that it enables the universal power supply. -/
theorem battery_ecology :
    GVCS.builtFrom .battery = [.printer3D, .rodWireMill] ∧
    GVCS.enables .battery = [.ups] :=
  ⟨rfl, rfl⟩

/-- That is why the battery is one of the five machines in the loop which
makes the 3D printer the keystone of the whole set: the printer's casing needs
the printer, through the motor and the battery. -/
theorem battery_is_in_the_printer_loop : GVCS.Machine.battery ∈ GVCS.keystoneLoop := by decide

end

end NiFe
end LifeTrac
