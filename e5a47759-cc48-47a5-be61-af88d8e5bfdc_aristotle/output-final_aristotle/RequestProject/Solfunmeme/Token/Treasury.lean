/-
# Funding the programme out of yield, not out of principal

The proposal put to the holders was:

    "I want to stake against projects and use the interest from them to pay for
     the project.  If you put X sol for project Y and the interest %n is paid
     for the project budget."

This file prices that.  A **position** is a principal staked for a number of
periods at a posted rate, with a pledged share of the interest assigned to a
project's budget.  The theory part contains no number: the yield is linear in
the principal and additive over periods, the pledged budget never exceeds the
yield, and the principal is never spent (`settle_principal`) — which is the
whole point of funding out of interest.

The numbers part answers the only question an investor asks about it: *how big
must the staked pool be to pay for the plan?*  The plan is the thirteen-stage
bootstrap already proved runnable in `RequestProject/Bootstrap/Plan.lean`, and
its cost is not re-entered here — it is taken from that development by theorem
(`bootstrapSpendUSD_eq`).  At an **assumed** 5% a year, held for the thirteen
months the plan takes:

* `stake_funds_the_plan` — the pledged interest covers the whole $1,696.69
  programme exactly when the staked pool is at least $2,036,028/65, i.e.
  $31,323.51 (`stake_threshold_bounds`);
* `stake_funds_the_float` — covering only the $1,069.56 working float needs
  $19,745.73 or more;
* `principal_untouched` — in both cases the principal is still there at the end.

The 5% is an assumption and is named as one (`assumedAnnualYieldRate`); no
theorem here calls it a measurement.  Nothing here says a yield is available, or
that a staked pool exists: the results are conditional statements of the form
"a pool of this size, at this rate, pays for that plan".
-/
import Mathlib
import RequestProject.Solfunmeme.Bootstrap.Plan

namespace SFM.Token

/-! ## The theory: what a staked position pays -/

/-- Dollars, as an exact rational. -/
abbrev USD := ℚ

/-- A staking position: a principal, a rate per year, a horizon in years, and
the share of the interest pledged to a project's budget. -/
structure Position where
  /-- Principal staked, in dollars. -/
  principal : USD
  /-- Yield per year, as a fraction (0.05 is 5%). -/
  rate : ℚ
  /-- How long the position is held, in years. -/
  years : ℚ
  /-- Share of the interest assigned to the project budget, between 0 and 1. -/
  pledge : ℚ
  deriving DecidableEq, Repr

namespace Position

/-- Simple interest earned over the horizon. -/
def yield (p : Position) : USD := p.principal * p.rate * p.years

/-- What the project's budget receives. -/
def budget (p : Position) : USD := p.pledge * p.yield

/-- Settling the position: the principal comes back, the pledged interest goes
to the budget, the rest to the staker. -/
def settle (p : Position) : USD × USD × USD :=
  (p.principal, p.budget, p.yield - p.budget)

/-- **The principal is never spent.** -/
@[simp] theorem settle_principal (p : Position) : (settle p).1 = p.principal := rfl

/-- The yield is linear in the principal: two stakers pooling their money earn
what they would have earned apart. -/
theorem yield_add_principal (p : Position) (x y : USD) (h : p.principal = x + y) :
    p.yield = ({ p with principal := x } : Position).yield
              + ({ p with principal := y } : Position).yield := by
  simp only [yield, h]; ring

/-- The yield is additive over consecutive horizons. -/
theorem yield_add_years (p : Position) (s t : ℚ) (h : p.years = s + t) :
    p.yield = ({ p with years := s } : Position).yield
              + ({ p with years := t } : Position).yield := by
  simp only [yield, h]; ring

/-- The budget never exceeds the interest. -/
theorem budget_le_yield (p : Position) (h1 : p.pledge ≤ 1)
    (hy : 0 ≤ p.yield) : p.budget ≤ p.yield := by
  simpa [budget] using mul_le_of_le_one_left hy h1

/-- More principal, more budget. -/
theorem budget_mono (r y pl : ℚ) (hr : 0 ≤ r) (hy : 0 ≤ y) (hp : 0 ≤ pl)
    {x x' : USD} (h : x ≤ x') :
    (Position.mk x r y pl).budget ≤ (Position.mk x' r y pl).budget := by
  simp only [budget, yield]
  have : x * r * y ≤ x' * r * y := by
    apply mul_le_mul_of_nonneg_right _ hy
    exact mul_le_mul_of_nonneg_right h hr
  exact mul_le_mul_of_nonneg_left this hp

/-- **The funding threshold.**  A project of a given cost is paid for out of a
fully pledged position exactly when the principal is at least the cost divided
by the rate times the horizon. -/
theorem funds_iff {cost r y x : ℚ} (hr : 0 < r) (hy : 0 < y) :
    cost ≤ (Position.mk x r y 1).budget ↔ cost / (r * y) ≤ x := by
  have hry : 0 < r * y := mul_pos hr hy
  constructor
  · intro h
    rw [div_le_iff₀ hry]
    simp only [budget, yield, one_mul] at h
    calc cost ≤ x * r * y := h
      _ = x * (r * y) := by ring
  · intro h
    rw [div_le_iff₀ hry] at h
    simp only [budget, yield, one_mul]
    calc cost ≤ x * (r * y) := h
      _ = x * r * y := by ring

end Position

/-! ## The numbers: what it takes to fund the bootstrap plan -/

/-- The thirteen-stage bootstrap plan's total spend, in dollars.  Taken from the
plan, not re-entered: see `bootstrapSpendUSD_eq`. -/
def bootstrapSpendUSD : USD := (SFM.Bootstrap.totalCost SFM.Bootstrap.plan : ℚ) / 100

/-- The plan spends $1,696.69. -/
theorem bootstrapSpendUSD_eq : bootstrapSpendUSD = 169669 / 100 := by
  rw [bootstrapSpendUSD, SFM.Bootstrap.total_cost]
  norm_num

/-- The plan's opening working float, in dollars. -/
def bootstrapFloatUSD : USD := (SFM.Bootstrap.openingFloat : ℚ) / 100

/-- The float is $1,069.56. -/
theorem bootstrapFloatUSD_eq : bootstrapFloatUSD = 106956 / 100 := by
  norm_num [bootstrapFloatUSD, SFM.Bootstrap.openingFloat]

/-- **An assumption, not a measurement**: the yield a staked pool is assumed to
earn, 5% a year. -/
def assumedAnnualYieldRate : ℚ := 5 / 100

/-- The plan takes thirteen months. -/
def bootstrapHorizonYears : ℚ := 13 / 12

/-- A fully pledged position of principal `x`, held for the plan's horizon at the
assumed rate. -/
def stakedPool (x : USD) : Position :=
  { principal := x, rate := assumedAnnualYieldRate, years := bootstrapHorizonYears, pledge := 1 }

/-- **The whole programme is paid for by the interest on $2,036,028/65 or
more**, and by nothing less. -/
theorem stake_funds_the_plan (x : USD) :
    bootstrapSpendUSD ≤ (stakedPool x).budget ↔ (2036028 / 65 : ℚ) ≤ x := by
  have hr : (0 : ℚ) < assumedAnnualYieldRate := by norm_num [assumedAnnualYieldRate]
  have hy : (0 : ℚ) < bootstrapHorizonYears := by norm_num [bootstrapHorizonYears]
  rw [stakedPool, Position.funds_iff hr hy, bootstrapSpendUSD_eq]
  norm_num [assumedAnnualYieldRate, bootstrapHorizonYears]

/-- That threshold is $31,323.51 to the cent. -/
theorem stake_threshold_bounds :
    (3132350 : ℚ) / 100 < 2036028 / 65 ∧ (2036028 : ℚ) / 65 < 3132351 / 100 := by
  norm_num

/-- **Funding only the working float** needs $1,283,472/65 — $19,745.73 — or
more. -/
theorem stake_funds_the_float (x : USD) :
    bootstrapFloatUSD ≤ (stakedPool x).budget ↔ (1283472 / 65 : ℚ) ≤ x := by
  have hr : (0 : ℚ) < assumedAnnualYieldRate := by norm_num [assumedAnnualYieldRate]
  have hy : (0 : ℚ) < bootstrapHorizonYears := by norm_num [bootstrapHorizonYears]
  rw [stakedPool, Position.funds_iff hr hy, bootstrapFloatUSD_eq]
  norm_num [assumedAnnualYieldRate, bootstrapHorizonYears]

/-- The float threshold is $19,745.73 to the cent, rounding up. -/
theorem float_threshold_bounds :
    (1974572 : ℚ) / 100 < 1283472 / 65 ∧ (1283472 : ℚ) / 65 < 1974573 / 100 := by
  norm_num

/-- **And the pool is still there afterwards.** -/
theorem principal_untouched (x : USD) : (Position.settle (stakedPool x)).1 = x := rfl

end SFM.Token
