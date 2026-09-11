import RequestProject.Gvcs.Game

/-!
# A verified playthrough

A concrete game: a homesteader with 15 000 in the bank, an empty shed and a
field of 20 hectares.  He orders the LifeTrac bill of materials, welds the
machine together himself, fills the tank and puts the 20 hectares into wheat.

Everything below is proved, not simulated: the script is legal from the first
move to the last, the final cash, fuel, calendar and net worth are exactly the
stated rationals, and the same script fails — the shop refuses the order —
if he starts with less money than the bill of materials costs.
-/

namespace LifeTrac
namespace Build

open Material Assembly GameState

/-- The prices of the homestead: fuel at 1.5 a litre, no hired labour (the
owner builds the machine himself), and 60% of the purchase price recovered on
material sold back. -/
def homestead : Market where
  fuelPrice := 3/2
  laborRate := 0
  salvage := 3/5
  fuelPrice_nonneg := by norm_num
  laborRate_nonneg := by norm_num
  salvage_nonneg := by norm_num
  salvage_le_one := by norm_num

/-- The opening position: 15 000 in cash and nothing else. -/
def start : GameState where
  cash := 15000
  stock := Inventory.empty
  built := []
  fuel := 0
  day := 0
  hectares := 0

/-- The script: order the parts, build the tractor, fill the tank, farm 20
hectares of wheat. -/
def firstSeason : List Action :=
  [ .order lifeTrac
  , .fabricate lifeTrac
  , .refuel 400
  , .farm "LifeTrac" wheat 20 ]

theorem start_legal : start.Legal := by
  refine ⟨by norm_num [start], ?_, by norm_num [start]⟩
  intro m
  simp [start, Inventory.empty]

theorem lifeTrac_name : lifeTrac.name = "LifeTrac" := rfl

/-- The whole script is legal, and at the end of the first season the
homesteader owns a LifeTrac, has an empty shelf, 40 litres left in the tank,
18 449 in cash after 17.125 working days, 20 hectares farmed, and a net worth
of 28 060 — 13 060 more than he started with. -/
theorem run_firstSeason :
    ∃ t, run homestead start firstSeason = some t ∧
      t.cash = 18449 ∧
      t.stock = Inventory.empty ∧
      t.fuel = 40 ∧
      t.day = 137/8 ∧
      t.hectares = 20 ∧
      t.hasMachine "LifeTrac" = true ∧
      netWorth homestead t = 28060 := by
  have hw := lifeTrac_wellFormed
  have hcost := lifeTrac_materialCost
  have hlab := lifeTrac_laborHours
  have hfuel := wheat_fuelPerHa
  have hhours := wheat_hoursPerHa
  -- order the bill of materials
  rw [firstSeason, run_cons,
    step_order hw (by simp [start, hcost]; norm_num)]
  rw [Option.bind_some, run_cons]
  -- fabricate the machine
  rw [step_fabricate hw (by intro m; simp [start, Inventory.add, Inventory.empty])
      (by simp [homestead, start, hcost]; norm_num)]
  rw [Option.bind_some, run_cons]
  -- refuel
  rw [step_refuel (by norm_num) (by simp [homestead, start, hcost]; norm_num)]
  rw [Option.bind_some, run_cons]
  -- farm
  rw [step_farm (by simp [hasMachine, lifeTrac_name])
      (by norm_num)
      (by simp [seasonFuel, hfuel, start]; norm_num)
      (by simp [wheat, homestead, start, hcost]; norm_num)]
  rw [Option.bind_some, run_nil]
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simp [start, homestead, hcost, Crop.revenuePerHa, wheat]
    norm_num
  · simp [start]
  · simp [start, seasonFuel, hfuel]
    norm_num
  · simp [start, hlab, seasonHours, hhours]
    norm_num
  · simp [start]
  · simp [hasMachine, lifeTrac_name]
  · have hf : seasonFuel wheat 20 = 360 := by rw [seasonFuel, hfuel]; norm_num
    have hr : wheat.revenuePerHa = 800 := by rw [Crop.revenuePerHa]; norm_num [wheat]
    simp only [netWorth, machineValue, hf, hr, hcost]
    norm_num [start, homestead, wheat, hcost]

/-- Starting with less cash than the bill of materials costs, the very first
move fails: the script cannot be played at all. -/
theorem run_firstSeason_broke :
    run homestead { start with cash := 9000 } firstSeason = none := by
  rw [firstSeason, run_cons,
    step_order_none (by simp [lifeTrac_materialCost]; norm_num)]
  rfl

end Build
end LifeTrac
