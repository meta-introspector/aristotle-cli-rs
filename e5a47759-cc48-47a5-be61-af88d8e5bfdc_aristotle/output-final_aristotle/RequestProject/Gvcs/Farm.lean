import RequestProject.Gvcs.Materials

/-!
# The farm: implements, field work and the economics of a season

`Materials` says what the tractor costs to build.  This file says what it can
earn.  It models

* an implement (working width and the drawbar pull it needs) and the *field
  capacity* it gives when pulled at a given ground speed — the bridge from the
  kinematics of the machine to hectares per hour;
* a crop as a list of field operations plus a yield and a price;
* the margin of a season, the break-even area and the payback period of the
  machine.

Everything is exact rational arithmetic: areas in hectares, times in hours,
speeds in metres per second, widths in metres, fuel in litres, masses of
produce in tonnes.
-/

namespace LifeTrac
namespace Build

/-! ## Implements and field capacity -/

/-- A towed or mounted implement: its working width in metres and the drawbar
pull in newtons it needs to be pulled through the soil. -/
structure Implement where
  /-- Working width, in metres. -/
  width : ℚ
  /-- Drawbar pull required, in newtons. -/
  draft : ℚ
  width_pos : 0 < width
  draft_nonneg : 0 ≤ draft

namespace Implement

/-- Field capacity in hectares per hour: an implement of width `w` metres
pulled at `v` metres per second covers `w · v` square metres per second, i.e.
`0.36 · w · v` hectares per hour, times the field efficiency `eff` (headland
turns, refilling, overlap). -/
def fieldCapacity (i : Implement) (speed eff : ℚ) : ℚ :=
  (9/25) * i.width * speed * eff

/-- Hours needed to cover `area` hectares. -/
def hoursToWork (i : Implement) (speed eff area : ℚ) : ℚ :=
  area / i.fieldCapacity speed eff

theorem fieldCapacity_pos (i : Implement) {speed eff : ℚ} (hs : 0 < speed)
    (he : 0 < eff) : 0 < i.fieldCapacity speed eff := by
  have := i.width_pos
  unfold fieldCapacity
  positivity

/-- A wider implement covers more ground per hour. -/
theorem fieldCapacity_mono_width {i j : Implement} (h : i.width ≤ j.width)
    {speed eff : ℚ} (hs : 0 ≤ speed) (he : 0 ≤ eff) :
    i.fieldCapacity speed eff ≤ j.fieldCapacity speed eff := by
  unfold fieldCapacity
  have h1 : 0 ≤ speed * eff := mul_nonneg hs he
  have h2 : (9/25 : ℚ) * i.width ≤ (9/25) * j.width := by linarith
  linarith [mul_le_mul_of_nonneg_right h2 h1]

/-- Driving faster covers more ground per hour. -/
theorem fieldCapacity_mono_speed (i : Implement) {s t eff : ℚ} (h : s ≤ t)
    (he : 0 ≤ eff) : i.fieldCapacity s eff ≤ i.fieldCapacity t eff := by
  have hw := i.width_pos.le
  unfold fieldCapacity
  have h1 : 0 ≤ (9/25 : ℚ) * i.width * eff :=
    mul_nonneg (mul_nonneg (by norm_num) hw) he
  linarith [mul_le_mul_of_nonneg_left h h1]

/-- Work is proportional to area: twice the field takes twice as long. -/
theorem hoursToWork_smul (i : Implement) (speed eff k area : ℚ) :
    i.hoursToWork speed eff (k * area) = k * i.hoursToWork speed eff area := by
  unfold hoursToWork
  ring

/-- Doubling the working width halves the time (at the same speed). -/
theorem hoursToWork_double_width (i j : Implement) (h : j.width = 2 * i.width)
    {speed eff area : ℚ} (hs : 0 < speed) (he : 0 < eff) :
    j.hoursToWork speed eff area = i.hoursToWork speed eff area / 2 := by
  have hi := i.width_pos
  have hc : i.fieldCapacity speed eff ≠ 0 := (i.fieldCapacity_pos hs he).ne'
  unfold hoursToWork fieldCapacity at *
  rw [h]
  field_simp

/-- The area covered in `hours` hours is `capacity · hours`: work time and area
are inverse to one another. -/
theorem area_of_hours (i : Implement) {speed eff : ℚ} (hs : 0 < speed)
    (he : 0 < eff) (area : ℚ) :
    i.fieldCapacity speed eff * i.hoursToWork speed eff area = area := by
  have hc : i.fieldCapacity speed eff ≠ 0 := (i.fieldCapacity_pos hs he).ne'
  unfold hoursToWork
  field_simp

/-- An implement can be pulled only if the machine's drawbar pull covers its
draft. -/
def Pullable (i : Implement) (drawbarPull : ℚ) : Prop := i.draft ≤ drawbarPull

end Implement

/-! ## Crops and field operations -/

/-- One pass over the field: how many hours per hectare it takes and how much
fuel per hour the machine burns doing it. -/
structure Operation where
  /-- Name of the operation (e.g. "plough"). -/
  name : String
  /-- Hours of work per hectare. -/
  hoursPerHa : ℚ
  /-- Fuel burn, litres per hour. -/
  fuelPerHour : ℚ
  hoursPerHa_nonneg : 0 ≤ hoursPerHa
  fuelPerHour_nonneg : 0 ≤ fuelPerHour

/-- A crop: the passes it needs, the seed and input cost, the yield and the
price of the produce. -/
structure Crop where
  /-- Name of the crop. -/
  name : String
  /-- Seed, fertiliser and other per-hectare inputs. -/
  seedCostPerHa : ℚ
  /-- Yield in tonnes per hectare. -/
  yieldPerHa : ℚ
  /-- Farm-gate price per tonne. -/
  pricePerTonne : ℚ
  /-- The field operations the crop needs, in order. -/
  ops : List Operation
  seedCostPerHa_nonneg : 0 ≤ seedCostPerHa
  yieldPerHa_nonneg : 0 ≤ yieldPerHa
  pricePerTonne_nonneg : 0 ≤ pricePerTonne

namespace Crop

/-- Total machine hours per hectare over the season. -/
def hoursPerHa (c : Crop) : ℚ := (c.ops.map Operation.hoursPerHa).sum

/-- Total fuel per hectare over the season, in litres. -/
def fuelPerHa (c : Crop) : ℚ :=
  (c.ops.map (fun o => o.hoursPerHa * o.fuelPerHour)).sum

/-- Gross revenue per hectare. -/
def revenuePerHa (c : Crop) : ℚ := c.yieldPerHa * c.pricePerTonne

/-- Cash cost per hectare at a given fuel price. -/
def costPerHa (c : Crop) (fuelPrice : ℚ) : ℚ :=
  c.seedCostPerHa + fuelPrice * c.fuelPerHa

/-- Gross margin per hectare. -/
def marginPerHa (c : Crop) (fuelPrice : ℚ) : ℚ :=
  c.revenuePerHa - c.costPerHa fuelPrice

theorem hoursPerHa_nonneg (c : Crop) : 0 ≤ c.hoursPerHa :=
  List.sum_nonneg (by
    intro x hx
    obtain ⟨o, _, rfl⟩ := List.mem_map.1 hx
    exact o.hoursPerHa_nonneg)

theorem fuelPerHa_nonneg (c : Crop) : 0 ≤ c.fuelPerHa :=
  List.sum_nonneg (by
    intro x hx
    obtain ⟨o, _, rfl⟩ := List.mem_map.1 hx
    exact mul_nonneg o.hoursPerHa_nonneg o.fuelPerHour_nonneg)

theorem revenuePerHa_nonneg (c : Crop) : 0 ≤ c.revenuePerHa :=
  mul_nonneg c.yieldPerHa_nonneg c.pricePerTonne_nonneg

/-- A better price means a better margin. -/
theorem marginPerHa_mono_price {c d : Crop} (hy : c.yieldPerHa = d.yieldPerHa)
    (hp : c.pricePerTonne ≤ d.pricePerTonne) (hs : c.seedCostPerHa = d.seedCostPerHa)
    (hf : c.fuelPerHa = d.fuelPerHa) {fuelPrice : ℚ} :
    c.marginPerHa fuelPrice ≤ d.marginPerHa fuelPrice := by
  have hyn := c.yieldPerHa_nonneg
  unfold marginPerHa revenuePerHa costPerHa
  rw [hs, hf, hy] at *
  nlinarith

end Crop

/-! ## The economics of a season -/

/-- Gross margin of a season of `area` hectares of `crop`. -/
def seasonMargin (c : Crop) (fuelPrice area : ℚ) : ℚ := area * c.marginPerHa fuelPrice

/-- Profit of a season, after the fixed costs of owning the machine
(depreciation, insurance, repairs). -/
def seasonProfit (c : Crop) (fuelPrice area fixedCost : ℚ) : ℚ :=
  seasonMargin c fuelPrice area - fixedCost

/-- The area at which a season breaks even. -/
def breakEvenArea (c : Crop) (fuelPrice fixedCost : ℚ) : ℚ :=
  fixedCost / c.marginPerHa fuelPrice

/-- With a positive margin per hectare, a season is profitable exactly above
the break-even area. -/
theorem seasonProfit_nonneg_iff (c : Crop) {fuelPrice fixedCost area : ℚ}
    (hm : 0 < c.marginPerHa fuelPrice) :
    0 ≤ seasonProfit c fuelPrice area fixedCost ↔
      breakEvenArea c fuelPrice fixedCost ≤ area := by
  unfold seasonProfit seasonMargin breakEvenArea
  rw [sub_nonneg, div_le_iff₀ hm]

/-- At exactly the break-even area the season profit is zero. -/
theorem seasonProfit_breakEven (c : Crop) {fuelPrice fixedCost : ℚ}
    (hm : c.marginPerHa fuelPrice ≠ 0) :
    seasonProfit c fuelPrice (breakEvenArea c fuelPrice fixedCost) fixedCost = 0 := by
  unfold seasonProfit seasonMargin breakEvenArea
  field_simp
  ring

/-- Profit is affine, hence monotone, in the area farmed. -/
theorem seasonProfit_mono_area (c : Crop) {fuelPrice fixedCost a b : ℚ}
    (hm : 0 ≤ c.marginPerHa fuelPrice) (hab : a ≤ b) :
    seasonProfit c fuelPrice a fixedCost ≤ seasonProfit c fuelPrice b fixedCost := by
  unfold seasonProfit seasonMargin
  nlinarith

/-- How many seasons it takes for the machine to pay for itself. -/
def paybackSeasons (buildCost profit : ℚ) : ℚ := buildCost / profit

/-- `n` seasons pay the machine off exactly when `n` reaches the payback
period. -/
theorem payback_iff {buildCost profit n : ℚ} (hp : 0 < profit) :
    buildCost ≤ n * profit ↔ paybackSeasons buildCost profit ≤ n := by
  unfold paybackSeasons
  rw [div_le_iff₀ hp]

/-- Machine hours a season of `area` hectares requires. -/
def seasonHours (c : Crop) (area : ℚ) : ℚ := area * c.hoursPerHa

/-- Fuel a season of `area` hectares burns, in litres. -/
def seasonFuel (c : Crop) (area : ℚ) : ℚ := area * c.fuelPerHa

theorem seasonHours_nonneg (c : Crop) {area : ℚ} (h : 0 ≤ area) :
    0 ≤ seasonHours c area := mul_nonneg h c.hoursPerHa_nonneg

theorem seasonFuel_nonneg (c : Crop) {area : ℚ} (h : 0 ≤ area) :
    0 ≤ seasonFuel c area := mul_nonneg h c.fuelPerHa_nonneg

/-! ## A concrete implement and crop -/

/-- A 1.5 m wide, two-bottom plough needing 8 kN of pull — matched to the
drawbar pull the worked example of `Main.lean` develops. -/
def plough : Implement where
  width := 3/2
  draft := 8000
  width_pos := by norm_num
  draft_nonneg := by norm_num

/-- Ploughing: 1 hectare per hour at 9 litres per hour. -/
def ploughing : Operation where
  name := "plough"
  hoursPerHa := 1
  fuelPerHour := 9
  hoursPerHa_nonneg := by norm_num
  fuelPerHour_nonneg := by norm_num

/-- Drilling the seed: half an hour per hectare at 6 litres per hour. -/
def drilling : Operation where
  name := "drill"
  hoursPerHa := 1/2
  fuelPerHour := 6
  hoursPerHa_nonneg := by norm_num
  fuelPerHour_nonneg := by norm_num

/-- Harvest and carting: three quarters of an hour per hectare at 8 litres per
hour. -/
def harvesting : Operation where
  name := "harvest"
  hoursPerHa := 3/4
  fuelPerHour := 8
  hoursPerHa_nonneg := by norm_num
  fuelPerHour_nonneg := by norm_num

/-- Wheat: plough, drill, harvest; 4 tonnes per hectare at 200 per tonne, with
120 of seed and fertiliser per hectare. -/
def wheat : Crop where
  name := "wheat"
  seedCostPerHa := 120
  yieldPerHa := 4
  pricePerTonne := 200
  ops := [ploughing, drilling, harvesting]
  seedCostPerHa_nonneg := by norm_num
  yieldPerHa_nonneg := by norm_num
  pricePerTonne_nonneg := by norm_num

#eval wheat.hoursPerHa
#eval wheat.fuelPerHa
#eval wheat.marginPerHa (3/2)

/-- A hectare of wheat takes 2.25 machine hours. -/
theorem wheat_hoursPerHa : wheat.hoursPerHa = 9/4 := by
  norm_num [Crop.hoursPerHa, wheat, ploughing, drilling, harvesting]

/-- and burns 18 litres of fuel. -/
theorem wheat_fuelPerHa : wheat.fuelPerHa = 18 := by
  norm_num [Crop.fuelPerHa, wheat, ploughing, drilling, harvesting]

/-- At a fuel price of 1.5 per litre the gross margin is 653 per hectare. -/
theorem wheat_marginPerHa : wheat.marginPerHa (3/2) = 653 := by
  rw [Crop.marginPerHa, Crop.revenuePerHa, Crop.costPerHa, wheat_fuelPerHa]
  norm_num [wheat]

/-- The plough covers 0.864 hectares per hour behind a machine doing 2 m/s at
field efficiency 0.8 … -/
theorem plough_fieldCapacity : plough.fieldCapacity 2 (4/5) = 108/125 := by
  norm_num [Implement.fieldCapacity, plough]

/-- … so a 20 hectare field takes just over 23 hours to plough. -/
theorem plough_hoursToWork_20 :
    plough.hoursToWork 2 (4/5) 20 = 625/27 := by
  norm_num [Implement.hoursToWork, Implement.fieldCapacity, plough]

/-- With 2000 of fixed costs a year, 20 hectares of wheat clear 11 060, so the
9551 of materials in the machine are paid back inside the first season. -/
theorem wheat_20ha_pays_for_the_machine :
    seasonProfit wheat (3/2) 20 2000 = 11060 ∧
    lifeTrac.materialCost ≤ seasonProfit wheat (3/2) 20 2000 := by
  have h : seasonProfit wheat (3/2) 20 2000 = 11060 := by
    norm_num [seasonProfit, seasonMargin, wheat_marginPerHa]
  refine ⟨h, ?_⟩
  rw [h, lifeTrac_materialCost]
  norm_num

/-- Break-even is just over three hectares. -/
theorem wheat_breakEvenArea : breakEvenArea wheat (3/2) 2000 = 2000/653 := by
  rw [breakEvenArea, wheat_marginPerHa]

end Build
end LifeTrac
