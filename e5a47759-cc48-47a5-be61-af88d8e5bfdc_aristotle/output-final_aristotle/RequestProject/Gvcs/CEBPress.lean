import RequestProject.Gvcs.PowerCube

/-!
# The Liberator: the compressed-earth-brick press, by the numbers

This file imports the quantitative part of the Open Source Ecology wiki's
account of the **CEB Press** — the machine OSE calls *the Liberator* — and
checks it.

Two wiki pages are used, read in August 2026:

* *CEB Press* — the specification of the standard model: full-size bricks of
  4″ × 6″ × 12″ averaging 25 lb, a guaranteed six bricks a minute at 12.5 gpm
  of hydraulic flow, a system pressure of 2400 psi, a hydraulic solenoid rated
  for at most 10 gpm, a tractor loader supplying about two cubic yards of soil
  an hour, five to forty cents of production cost per block, and the worked
  example of two people raising a round wall six feet high and twenty feet
  across in an eight-hour day.
* *Brick Pressing Rate Calculations* — the derivation of the pressing rate
  from cylinder geometry: a 5″ × 8″ main cylinder with a 2.5″ rod, a
  2.5″ × 14″ drawer cylinder with a 1.25″ rod, and the rule
  `HP = PSI × GPM / 1714` relating engine power to flow.

Everything below follows from those numbers alone.  The wiki's own arithmetic
comes out right (`main_cylinder_volume`, `cycle_volume`, `hpToFlow_18hp_2200`,
`drawer_multiplier`, `velocity_ratio`, and the 8.2 bricks per minute at
14 gpm), with one rounding slip recorded honestly: at 12.9 gpm the rate is
7.54 and not the 7.6 the page states, the difference being that the page
divides by a cycle volume already rounded to 1.7 gallons
(`rate_at_12_9_gpm_is_not_7_6`).

Three consequences are worth stating on their own.

* The advertised six bricks a minute **cannot be reached through the valve the
  page specifies**: six bricks a minute needs 10.26 gpm, and the solenoid is
  rated for 10 (`six_per_minute_needs_more_than_the_rated_valve`).
* The 12.5 gpm figure is otherwise conservative — the geometry alone would
  give 7.3 bricks a minute at that flow (`guarantee_is_conservative`).
* The loader has to keep up with more soil than the page says: six bricks a
  minute is 2.2 cubic yards of *pressed* brick an hour, already more than the
  two cubic yards of soil quoted, before any allowance for compaction
  (`loader_feed_understated`).

The worked wall comes out exactly: it is 720 π bricks, so pressing it takes
2 π hours — six hours and seventeen minutes, comfortably inside the eight-hour
day — but the two builders between them lift more than twenty-five short tons
of brick to do it.
-/

namespace LifeTrac
namespace CEB

open Real

noncomputable section

/-! ## Units -/

/-- Cubic inches in a US gallon. -/
def cubicInchesPerGallon : ℝ := 231

/-- Cubic inches in a cubic foot. -/
def cubicInchesPerCubicFoot : ℝ := 1728

/-- Cubic feet in a cubic yard. -/
def cubicFeetPerCubicYard : ℝ := 27

/-! ## Hydraulic power

The engine sizing uses the same rule of thumb as the rest of the wiki,
`HP = PSI × GPM / 1714`, imported from `RequestProject/PowerCube.lean`. -/

open PowerCube (hpToFlow)

/-- The wiki's 18 hp engine at 2200 psi: 14.0 gpm. -/
theorem hpToFlow_18hp_2200 : |hpToFlow 18 2200 - 14| < 0.05 := by
  unfold hpToFlow; rw [abs_sub_lt_iff]; norm_num

/-- A 16 hp engine at 2200 psi: 12.5 gpm. -/
theorem hpToFlow_16hp_2200 : |hpToFlow 16 2200 - 12.5| < 0.05 := by
  unfold hpToFlow; rw [abs_sub_lt_iff]; norm_num

/-- The 18 hp engine pressing at 2400 psi: 12.9 gpm. -/
theorem hpToFlow_18hp_2400 : |hpToFlow 18 2400 - 12.9| < 0.05 := by
  unfold hpToFlow; rw [abs_sub_lt_iff]; norm_num

/-! ## The two cylinders -/

/-- A double-acting hydraulic cylinder: bore diameter, rod diameter, stroke,
all in inches. -/
structure Cylinder where
  /-- Bore diameter, inches. -/
  bore : ℝ
  /-- Rod diameter, inches. -/
  rod : ℝ
  /-- Stroke, inches. -/
  stroke : ℝ

namespace Cylinder

/-- Oil needed to extend the cylinder: the full swept volume. -/
def extendVolume (c : Cylinder) : ℝ := π * (c.bore / 2) ^ 2 * c.stroke

/-- The volume the rod itself occupies over the stroke. -/
def rodVolume (c : Cylinder) : ℝ := π * (c.rod / 2) ^ 2 * c.stroke

/-- Oil needed to retract the cylinder: the swept volume less the rod. -/
def retractVolume (c : Cylinder) : ℝ := c.extendVolume - c.rodVolume

/-- Oil for one out-and-back cycle. -/
def cycleVolume (c : Cylinder) : ℝ := c.extendVolume + c.retractVolume

theorem retractVolume_lt_extendVolume (c : Cylinder) (hr : 0 < c.rod)
    (hs : 0 < c.stroke) : c.retractVolume < c.extendVolume := by
  have : 0 < c.rodVolume := by
    unfold rodVolume; positivity
  unfold retractVolume; linarith

end Cylinder

/-- The main pressing cylinder of the Liberator II: 5″ bore, 2.5″ rod,
8″ stroke. -/
def mainCylinder : Cylinder := ⟨5, 2.5, 8⟩

/-- The soil-drawer cylinder: 2.5″ bore, 1.25″ rod, 14″ stroke. -/
def drawerCylinder : Cylinder := ⟨2.5, 1.25, 14⟩

theorem mainCylinder_extendVolume : mainCylinder.extendVolume = 50 * π := by
  unfold Cylinder.extendVolume mainCylinder; ring

theorem drawerCylinder_extendVolume : drawerCylinder.extendVolume = 21.875 * π := by
  unfold Cylinder.extendVolume drawerCylinder; ring

/-- The wiki's 157 cubic inches for the main cylinder. -/
theorem main_cylinder_volume : |mainCylinder.extendVolume - 157| < 0.1 := by
  rw [mainCylinder_extendVolume, abs_sub_lt_iff]
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d6]

/-- The wiki's 39.3 cubic inches of rod. -/
theorem main_rod_volume : |mainCylinder.rodVolume - 39.3| < 0.1 := by
  have h : mainCylinder.rodVolume = 12.5 * π := by
    unfold Cylinder.rodVolume mainCylinder; ring
  rw [h, abs_sub_lt_iff]
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d6]

/-- The wiki's 68.7 cubic inches for the drawer cylinder. -/
theorem drawer_cylinder_volume : |drawerCylinder.extendVolume - 68.7| < 0.1 := by
  rw [drawerCylinder_extendVolume, abs_sub_lt_iff]
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d6]

/-- The control code's "drawer multiplier": retraction takes three quarters of
the time of extension, because the rod takes a quarter of the volume. -/
theorem drawer_multiplier :
    |drawerCylinder.retractVolume / drawerCylinder.extendVolume - 0.75| < 0.005 := by
  have he : drawerCylinder.extendVolume = 21.875 * π := drawerCylinder_extendVolume
  have hr : drawerCylinder.rodVolume = 5.46875 * π := by
    unfold Cylinder.rodVolume drawerCylinder; ring
  have hpi : (0:ℝ) < π := pi_pos
  have h : drawerCylinder.retractVolume / drawerCylinder.extendVolume = 0.75 := by
    unfold Cylinder.retractVolume
    rw [he, hr]
    field_simp
    ring
  rw [h]
  norm_num

/-! ## One cycle of the machine -/

/-- Oil for one complete brick cycle: both cylinders out and back. -/
def cycleVolume : ℝ := mainCylinder.cycleVolume + drawerCylinder.cycleVolume

theorem cycleVolume_eq : cycleVolume = 125.78125 * π := by
  unfold cycleVolume Cylinder.cycleVolume Cylinder.retractVolume Cylinder.extendVolume
    Cylinder.rodVolume mainCylinder drawerCylinder
  ring

/-- The wiki's 395 cubic inches per cycle. -/
theorem cycle_volume : |cycleVolume - 395| < 0.2 := by
  rw [cycleVolume_eq, abs_sub_lt_iff]
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d6]

/-- One cycle in gallons of hydraulic fluid. -/
def cycleGallons : ℝ := cycleVolume / cubicInchesPerGallon

theorem cycleGallons_pos : 0 < cycleGallons := by
  rw [cycleGallons, cycleVolume_eq, cubicInchesPerGallon]
  have := pi_pos
  positivity

/-- The wiki's 1.7 gallons per brick. -/
theorem cycle_gallons : |cycleGallons - 1.71| < 0.005 := by
  rw [cycleGallons, cycleVolume_eq, cubicInchesPerGallon, abs_sub_lt_iff]
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d6]

/-- A convenient two-sided bound for a quotient. -/
private theorem abs_div_sub_lt {a b c e : ℝ} (hb : 0 < b) (h1 : (c - e) * b < a)
    (h2 : a < (c + e) * b) : |a / b - c| < e := by
  rw [abs_sub_lt_iff]
  refine ⟨?_, ?_⟩
  · have : a / b < c + e := by rw [div_lt_iff₀ hb]; exact h2
    linarith
  · have : c - e < a / b := by rw [lt_div_iff₀ hb]; exact h1
    linarith

/-! ## Bricks per minute -/

/-- Bricks a minute at a given hydraulic flow, in gallons per minute: one
brick per cycle, one cycle per `cycleGallons` gallons. -/
def brickRate (gpm : ℝ) : ℝ := gpm / cycleGallons

theorem brickRate_eq (gpm : ℝ) : brickRate gpm = gpm * 231 / (125.78125 * π) := by
  rw [brickRate, cycleGallons, cycleVolume_eq, cubicInchesPerGallon]
  have hpi : (0:ℝ) < π := pi_pos
  field_simp

/-- More flow presses more bricks. -/
theorem brickRate_strictMono {a b : ℝ} (h : a < b) : brickRate a < brickRate b := by
  unfold brickRate
  gcongr
  exact cycleGallons_pos

/-- The wiki's headline: 14 gpm gives 8.2 bricks a minute. -/
theorem rate_at_14_gpm : |brickRate 14 - 8.2| < 0.05 := by
  have hpi : (0:ℝ) < π := pi_pos
  rw [brickRate_eq]
  exact abs_div_sub_lt (by positivity) (by nlinarith [pi_lt_d6]) (by nlinarith [pi_gt_d6])

/-- **A rounding slip on the wiki.**  At 12.9 gpm the cylinder geometry gives
7.54 bricks a minute, which rounds to 7.5, not to the 7.6 the page states: the
page divides by a cycle volume already rounded down to 1.7 gallons. -/
theorem rate_at_12_9_gpm_is_not_7_6 : |brickRate 12.9 - 7.54| < 0.01 := by
  have hpi : (0:ℝ) < π := pi_pos
  rw [brickRate_eq]
  exact abs_div_sub_lt (by positivity) (by nlinarith [pi_lt_d6]) (by nlinarith [pi_gt_d6])

/-- **The guarantee is conservative.**  The specification promises six bricks a
minute at 12.5 gpm; the geometry alone would give more than seven. -/
theorem guarantee_is_conservative : 7 < brickRate 12.5 := by
  rw [brickRate_eq]
  have hpi : (0:ℝ) < π := pi_pos
  rw [lt_div_iff₀ (by positivity)]
  nlinarith [pi_lt_d6]

/-- **But not through that valve.**  The page rates the hydraulic solenoid for
at most 10 gpm, and at 10 gpm the machine cannot reach six bricks a minute. -/
theorem six_per_minute_needs_more_than_the_rated_valve : brickRate 10 < 6 := by
  rw [brickRate_eq]
  have hpi : (0:ℝ) < π := pi_pos
  rw [div_lt_iff₀ (by positivity)]
  nlinarith [pi_gt_d6]

/-- Six bricks a minute needs more than ten and a quarter gallons a minute —
a quarter more flow than the specified valve passes. -/
theorem flow_for_six_bricks : 10.25 < 6 * cycleGallons := by
  rw [cycleGallons, cycleVolume_eq, cubicInchesPerGallon]
  nlinarith [pi_gt_d6]

/-! ## What the machine eats and what it makes -/

/-- A full-size brick: 4″ × 6″ × 12″, in cubic inches. -/
def brickVolume : ℝ := 4 * 6 * 12

/-- The average mass of a brick off the Liberator, in pounds. -/
def brickMass : ℝ := 25

/-- Bricks a minute for the standard model, as guaranteed on the wiki. -/
def guaranteedRate : ℝ := 6

/-- Pressed brick produced in an hour at the guaranteed rate, in cubic
yards. -/
def pressedYardsPerHour : ℝ :=
  guaranteedRate * 60 * brickVolume / cubicInchesPerCubicFoot / cubicFeetPerCubicYard

/-- **The loader is under-specified.**  Six bricks a minute is more than two
and a fifth cubic yards of *pressed* brick an hour, so the two cubic yards of
soil an hour the page asks of the tractor loader is already short before any
allowance for the compaction the press performs. -/
theorem loader_feed_understated : 2.2 < pressedYardsPerHour := by
  unfold pressedYardsPerHour guaranteedRate brickVolume cubicInchesPerCubicFoot
    cubicFeetPerCubicYard
  norm_num

/-- The density of a finished brick, in pounds per cubic foot. -/
def brickDensity : ℝ := brickMass / (brickVolume / cubicInchesPerCubicFoot)

/-- A brick off the Liberator is 150 lb per cubic foot — about 2.4 times the
density of water, which is what compaction of earth is for. -/
theorem brick_density : brickDensity = 150 := by
  unfold brickDensity brickMass brickVolume cubicInchesPerCubicFoot
  norm_num

/-! ## The worked wall

The page's example: two people, one eight-hour day, a round wall six feet
high, twenty feet across and one foot thick. -/

/-- Height of the example wall, in feet. -/
def wallHeight : ℝ := 6

/-- Diameter of the example wall, in feet. -/
def wallDiameter : ℝ := 20

/-- Thickness of the example wall, in feet. -/
def wallThickness : ℝ := 1

/-- The masonry volume of the wall, in cubic feet: the circumference times the
height times the thickness. -/
def wallVolume : ℝ := π * wallDiameter * wallHeight * wallThickness

/-- One brick, in cubic feet. -/
def brickCubicFeet : ℝ := brickVolume / cubicInchesPerCubicFoot

theorem brickCubicFeet_eq : brickCubicFeet = 1 / 6 := by
  unfold brickCubicFeet brickVolume cubicInchesPerCubicFoot; norm_num

/-- Bricks in the wall. -/
def wallBricks : ℝ := wallVolume / brickCubicFeet

/-- The wall is exactly 720 π bricks — a little over two thousand two
hundred. -/
theorem wallBricks_eq : wallBricks = 720 * π := by
  unfold wallBricks wallVolume wallDiameter wallHeight wallThickness
  rw [brickCubicFeet_eq]
  ring

theorem wallBricks_approx : |wallBricks - 2262| < 1 := by
  rw [wallBricks_eq, abs_sub_lt_iff]
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d6]

/-- Hours of pressing the wall takes at the guaranteed six bricks a minute. -/
def wallPressingHours : ℝ := wallBricks / guaranteedRate / 60

/-- **The wall takes exactly 2 π hours to press** — six hours and seventeen
minutes. -/
theorem wallPressingHours_eq : wallPressingHours = 2 * π := by
  unfold wallPressingHours guaranteedRate
  rw [wallBricks_eq]
  ring

/-- So the eight-hour day claimed on the wiki does hold, with an hour and
three quarters to spare for moving and laying. -/
theorem wall_fits_the_day : wallPressingHours < 8 := by
  rw [wallPressingHours_eq]
  nlinarith [pi_lt_d6]

/-- Pounds of brick in the wall. -/
def wallMass : ℝ := wallBricks * brickMass

/-- **It is a great deal of lifting.**  The wall is more than twenty-five
short tons of brick, so each of the two builders handles over twelve tons in
the day — one brick every twenty-five seconds for eight hours. -/
theorem wall_is_heavy_work : 50000 < wallMass ∧ 25000 < wallMass / 2 := by
  have h : wallMass = 18000 * π := by
    unfold wallMass brickMass; rw [wallBricks_eq]; ring
  constructor <;> rw [h] <;> nlinarith [pi_gt_d6]

/-- Bricks each of the two builders must place per minute over an eight-hour
day: fewer than three. -/
theorem bricks_per_person_per_minute : wallBricks / 2 / (8 * 60) < 3 := by
  rw [wallBricks_eq]
  nlinarith [pi_lt_d6]

/-! ## What a wall costs

The page gives five to forty cents of production cost per block, the spread
covering the cement used for stabilisation and the price of labour. -/

/-- Cost of the wall in dollars, at `centsPerBlock` cents a block. -/
def wallCost (centsPerBlock : ℝ) : ℝ := wallBricks * centsPerBlock / 100

/-- At the bottom of the range the wall's blocks cost under 115 dollars; at
the top, under 905. -/
theorem wall_cost_range : wallCost 5 < 115 ∧ wallCost 40 < 905 := by
  constructor <;> · unfold wallCost; rw [wallBricks_eq]; nlinarith [pi_lt_d6]

/-! ## Where the press sits in the construction set -/

/-- The CEB press is a habitat machine of the GVCS. -/
theorem cebPress_is_habitat : GVCS.Machine.cebPress.sector = .habitat := rfl

/-- It is the machine the wiki's completion table rates highest. -/
theorem cebPress_is_almost_done : GVCS.Machine.cebPress.status = .almostDone := rfl

/-- It is fabricated with the furnace, the welder, the torch table and the
ironworker, and it runs on a power cube, a soil pulverizer and the tractor:
the press is downstream of most of the shop. -/
theorem cebPress_ecology :
    GVCS.builtFrom .cebPress =
      [.inductionFurnace, .welder, .torchTable, .ironworker] ∧
    GVCS.uses .cebPress = [.powerCube, .soilPulverizer, .tractor] :=
  ⟨rfl, rfl⟩

end

end CEB
end LifeTrac
