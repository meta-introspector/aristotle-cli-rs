import RequestProject.Gvcs.Cylinder

/-!
# The splitter bake-off

A log splitter is the first hydraulic implement most people build, and it is the
cheapest way to find out whether a workshop's hydraulics are any good.  It is
also a genuine design competition: five perfectly sensible builds, all made from
the same shelf of parts, disagree about bore, about pump and about where the oil
comes from, and they disagree about which of them is *best*.

This file runs the competition — the bake-off — and proves who wins.

## The model

* `Supply` — where the oil comes from.  A **single-stage** pump gives one flow at
  every pressure.  A **two-stage** pump gives a large flow while the load is
  light and drops to a small one once the load passes its changeover pressure;
  the same engine then drives a much bigger ram, because the engine only has to
  pay for `pressure × flow`.
* `Log` — the piece of wood: the force needed to split it and the distance the
  wedge travels while that force is on.  The rest of the stroke is free travel.
* `extendTime`, `retractTime`, `cycleTime` — the time for one split: free travel
  at the high flow, the split itself at whatever flow the pump can give at the
  working pressure, and the return stroke (unloaded, so always at high flow) on
  the smaller rod-side area.

## The general results

* `Supply.flowAt_le_hiFlow`, `flowAt_pos` — the flow law is sane.
* `strokeTime_maxForce` — **the bore never changes the work rate.**  At a given
  relief setting and flow, force × speed at the wedge is exactly the pump's
  hydraulic power `relief · Q`, whatever the bore.  A bigger ram buys force and
  pays for it in time, one for one (`bore_tradeoff`).
* `twoStage_faster` — **the two-stage pump is strictly faster**, on the same
  cylinder, at the same relief setting, with the same flow available at the
  working pressure: the free travel and the whole return stroke run at the
  bigger flow, and the split itself takes exactly as long as before.
* `qualifies_iff` — a build splits the log iff its relief pressure on its bore
  area makes the force.

## The bake-off

Five builds (`bigBoreSingle`, `twoStageBig`, `smallSingle`, `twoStageSmall`,
`tractorFed`) against one 20-tonne log.  Proved: the two four-inch builds and
the build fed from the tractor's own 140-bar circuit *cannot split it at all*,
whatever pump is behind them; the two five-inch builds can.  Between the two
survivors the two-stage pump is faster — 18.32 s against 20.74 s — but it costs
more, and per unit of money the plain single-stage build splits more wood per
hour.  `bake_off` bundles the whole verdict, and the honest reading of it is
that the competition has **no single winner**: it depends on whether the builder
is short of time or short of money.
-/

namespace LifeTrac
namespace Splitter

open Real

noncomputable section

/-! ## Where the oil comes from -/

/-- A hydraulic supply for a splitter: a pump and a relief valve.

A *single-stage* pump has `loFlow = hiFlow` and so ignores `changeover`.  A
*two-stage* pump delivers `hiFlow` while the working pressure is at or below
`changeover` and `loFlow` above it — the engine power `p · Q` is what limits
it. -/
structure Supply where
  /-- Flow delivered while the load is light. -/
  hiFlow : ℝ
  /-- Flow delivered once the load passes the changeover pressure. -/
  loFlow : ℝ
  /-- Pressure at which a two-stage pump drops to its small flow. -/
  changeover : ℝ
  /-- Relief-valve setting: the highest pressure the circuit will hold. -/
  relief : ℝ
  loFlow_pos : 0 < loFlow
  loFlow_le : loFlow ≤ hiFlow
  changeover_pos : 0 < changeover
  changeover_le : changeover ≤ relief

namespace Supply

variable (s : Supply)

theorem hiFlow_pos : 0 < s.hiFlow := lt_of_lt_of_le s.loFlow_pos s.loFlow_le

theorem relief_pos : 0 < s.relief := lt_of_lt_of_le s.changeover_pos s.changeover_le

/-- The flow the supply can deliver at a working pressure. -/
def flowAt (p : ℝ) : ℝ := if p ≤ s.changeover then s.hiFlow else s.loFlow

/-- A supply is single-stage when it delivers the same flow at every pressure. -/
def SingleStage : Prop := s.loFlow = s.hiFlow

theorem flowAt_pos (p : ℝ) : 0 < s.flowAt p := by
  unfold flowAt; split
  · exact s.hiFlow_pos
  · exact s.loFlow_pos

theorem flowAt_le_hiFlow (p : ℝ) : s.flowAt p ≤ s.hiFlow := by
  unfold flowAt; split
  · exact le_rfl
  · exact s.loFlow_le

theorem flowAt_single (h : s.SingleStage) (p : ℝ) : s.flowAt p = s.hiFlow := by
  unfold flowAt SingleStage at *; split
  · rfl
  · exact h

theorem flowAt_of_lt {p : ℝ} (h : s.changeover < p) : s.flowAt p = s.loFlow := by
  unfold flowAt; rw [if_neg (not_le.2 h)]

/-- A single-stage pump of a given flow and relief setting. -/
def single (Q p : ℝ) (hQ : 0 < Q) (hp : 0 < p) : Supply where
  hiFlow := Q
  loFlow := Q
  changeover := p
  relief := p
  loFlow_pos := hQ
  loFlow_le := le_rfl
  changeover_pos := hp
  changeover_le := le_rfl

theorem single_singleStage (Q p : ℝ) (hQ : 0 < Q) (hp : 0 < p) :
    (single Q p hQ hp).SingleStage := rfl

end Supply

/-! ## The wood -/

/-- A log, described by what it takes to split it: the force the wedge must
develop and the distance it travels under that force. -/
structure Log where
  /-- Force needed at the wedge to open the log. -/
  force : ℝ
  /-- Distance the wedge travels while that force is on. -/
  travel : ℝ
  force_pos : 0 < force
  travel_pos : 0 < travel

/-! ## Timing one split -/

variable (c : Cylinder) (s : Supply) (lg : Log)

/-- The pressure the circuit must reach to split the log with this cylinder. -/
def workPressure : ℝ := lg.force / c.capArea

/-- The greatest force the build can put on the wedge: the relief setting on the
full bore area. -/
def maxForce : ℝ := s.relief * c.capArea

/-- Time for the ram to run its whole stroke out at the high flow — the timing
of an unloaded stroke. -/
def strokeTime : ℝ := c.capArea * c.stroke / s.hiFlow

/-- Time to extend for one split: the free travel at the high flow, then the
split itself at whatever flow the pump gives at the working pressure. -/
def extendTime : ℝ :=
  c.capArea * (c.stroke - lg.travel) / s.hiFlow
    + c.capArea * lg.travel / s.flowAt (workPressure c lg)

/-- Time to bring the ram home: the rod-side area at the high flow, since the
return stroke is unloaded. -/
def retractTime : ℝ := c.rodArea * c.stroke / s.hiFlow

/-- One split, out and back. -/
def cycleTime : ℝ := extendTime c s lg + retractTime c s

theorem strokeTime_pos : 0 < strokeTime c s :=
  div_pos (mul_pos c.capArea_pos c.stroke_pos) s.hiFlow_pos

theorem retractTime_pos : 0 < retractTime c s :=
  div_pos (mul_pos c.rodArea_pos c.stroke_pos) s.hiFlow_pos

theorem extendTime_pos (h : lg.travel < c.stroke) : 0 < extendTime c s lg := by
  have h1 : 0 < c.capArea * (c.stroke - lg.travel) / s.hiFlow :=
    div_pos (mul_pos c.capArea_pos (by linarith)) s.hiFlow_pos
  have h2 : 0 < c.capArea * lg.travel / s.flowAt (workPressure c lg) :=
    div_pos (mul_pos c.capArea_pos lg.travel_pos) (s.flowAt_pos _)
  unfold extendTime; linarith

theorem cycleTime_pos (h : lg.travel < c.stroke) : 0 < cycleTime c s lg := by
  have := extendTime_pos c s lg h
  have := retractTime_pos c s
  unfold cycleTime; linarith

/-! ## Bore buys force and pays for it in time -/

/-- **The bore never changes the work rate.**  Force at the wedge times the
speed of the wedge (a full stroke in `strokeTime`) is exactly the hydraulic
power the pump delivers at the relief setting — the bore has cancelled out. -/
theorem strokeTime_maxForce :
    maxForce c s * (c.stroke / strokeTime c s) = s.relief * s.hiFlow := by
  have hA := c.capArea_pos
  have hs := c.stroke_pos
  have hQ := s.hiFlow_pos
  unfold maxForce strokeTime
  field_simp

/-- **A bigger ram is stronger and slower, in the same proportion.**  On the
same stroke and the same supply, going up in bore multiplies both the force and
the stroke time by the ratio of the areas. -/
theorem bore_tradeoff (c₁ c₂ : Cylinder) (hstroke : c₁.stroke = c₂.stroke)
    (h : c₁.bore < c₂.bore) :
    maxForce c₁ s < maxForce c₂ s ∧ strokeTime c₁ s < strokeTime c₂ s := by
  have h1 : c₁.capArea < c₂.capArea := by
    have hb := c₁.bore_pos
    unfold Cylinder.capArea
    have : c₁.bore ^ 2 < c₂.bore ^ 2 := by nlinarith
    nlinarith [pi_pos]
  have hQ := s.hiFlow_pos
  have h2 : c₁.capArea * c₂.stroke < c₂.capArea * c₂.stroke :=
    mul_lt_mul_of_pos_right h1 c₂.stroke_pos
  refine ⟨?_, ?_⟩
  · unfold maxForce
    exact mul_lt_mul_of_pos_left h1 s.relief_pos
  · unfold strokeTime
    rw [hstroke, div_lt_div_iff₀ hQ hQ]
    exact mul_lt_mul_of_pos_right h2 hQ

/-! ## Which builds can split the log at all -/

/-- A build splits the log when its relief pressure on its bore area makes the
force the log needs. -/
def Qualifies : Prop := lg.force ≤ maxForce c s

theorem qualifies_iff : Qualifies c s lg ↔ workPressure c lg ≤ s.relief := by
  unfold Qualifies maxForce workPressure
  rw [div_le_iff₀ c.capArea_pos]

/-! ## The two-stage pump is strictly faster -/

/-- **Two stages beat one.**  Take the same cylinder and the same log, and two
supplies with the same relief setting that offer the *same* flow at the working
pressure — but the second also offers a bigger flow while the load is light.
Then the second is strictly faster over the cycle: the free travel and the whole
return stroke are quicker, and the split itself takes exactly as long. -/
theorem twoStage_faster (s₁ s₂ : Supply) (htravel : lg.travel < c.stroke)
    (hflow : s₁.flowAt (workPressure c lg) = s₂.flowAt (workPressure c lg))
    (hhi : s₁.hiFlow < s₂.hiFlow) :
    cycleTime c s₂ lg < cycleTime c s₁ lg := by
  have hA := c.capArea_pos
  have hR := c.rodArea_pos
  have hst := c.stroke_pos
  have h1 : c.capArea * (c.stroke - lg.travel) / s₂.hiFlow
      < c.capArea * (c.stroke - lg.travel) / s₁.hiFlow :=
    div_lt_div_of_pos_left (by nlinarith) s₁.hiFlow_pos hhi
  have h2 : c.rodArea * c.stroke / s₂.hiFlow < c.rodArea * c.stroke / s₁.hiFlow :=
    div_lt_div_of_pos_left (by positivity) s₁.hiFlow_pos hhi
  unfold cycleTime extendTime retractTime
  rw [hflow]
  linarith

/-! ## The contenders -/

/-- A build on the bench: a cylinder, a supply, and what the parts cost. -/
structure Build where
  /-- What the build is called. -/
  name : String
  /-- The ram. -/
  cyl : Cylinder
  /-- The oil. -/
  supply : Supply
  /-- What the parts cost, in the same money as the rest of the workshop. -/
  price : ℝ
  price_pos : 0 < price

namespace Build

variable (b : Build)

/-- One split, out and back. -/
def cycle (lg : Log) : ℝ := cycleTime b.cyl b.supply lg

/-- The force the build can put on the wedge. -/
def force : ℝ := maxForce b.cyl b.supply

/-- Splits an hour. -/
def perHour (lg : Log) : ℝ := 3600 / b.cycle lg

/-- Splits an hour for each unit of money the build cost. -/
def value (lg : Log) : ℝ := b.perHour lg / b.price

end Build

/-- A five-inch ram: 127 mm bore, 38 mm rod, 600 mm stroke. -/
def bigRam : Cylinder where
  bore := 127 / 2000
  rod := 381 / 20000
  stroke := 3 / 5
  rod_pos := by norm_num
  rod_lt_bore := by norm_num
  stroke_pos := by norm_num

/-- A four-inch ram: 101.6 mm bore, same rod and stroke. -/
def smallRam : Cylinder where
  bore := 127 / 2500
  rod := 381 / 20000
  stroke := 3 / 5
  rod_pos := by norm_num
  rod_lt_bore := by norm_num
  stroke_pos := by norm_num

/-- A single-stage pump: 42 L/min at up to 207 bar. -/
def onePump : Supply := Supply.single (7 / 10000) 20700000 (by norm_num) (by norm_num)

/-- A two-stage pump on the same engine: 60 L/min up to 80 bar, then 15 L/min up
to 207 bar. -/
def twoPump : Supply where
  hiFlow := 1 / 1000
  loFlow := 1 / 4000
  changeover := 8000000
  relief := 20700000
  loFlow_pos := by norm_num
  loFlow_le := by norm_num
  changeover_pos := by norm_num
  changeover_le := by norm_num

/-- The tractor's own circuit: 90 L/min, but its relief is set at 140 bar. -/
def tractorCircuit : Supply :=
  Supply.single (3 / 2000) 14000000 (by norm_num) (by norm_num)

/-- Five inch ram, single-stage pump. -/
def bigBoreSingle : Build := ⟨"5\" bore, single-stage", bigRam, onePump, 950, by norm_num⟩

/-- Five inch ram, two-stage pump. -/
def twoStageBig : Build := ⟨"5\" bore, two-stage", bigRam, twoPump, 1150, by norm_num⟩

/-- Four inch ram, single-stage pump. -/
def smallSingle : Build := ⟨"4\" bore, single-stage", smallRam, onePump, 700, by norm_num⟩

/-- Four inch ram, two-stage pump. -/
def twoStageSmall : Build := ⟨"4\" bore, two-stage", smallRam, twoPump, 900, by norm_num⟩

/-- Five inch ram plumbed into the tractor's own circuit — no pump to buy. -/
def tractorFed : Build := ⟨"5\" bore, off the tractor", bigRam, tractorCircuit, 400, by norm_num⟩

/-- The bake-off log: it takes 200 kN — a little over twenty tonnes — and holds
that force for the first 100 mm of the split. -/
def bigLog : Log where
  force := 200000
  travel := 1 / 10
  force_pos := by norm_num
  travel_pos := by norm_num

/-! ## The verdict -/

theorem bigRam_capArea : bigRam.capArea = π * (16129 / 4000000) := by
  unfold Cylinder.capArea bigRam; norm_num

theorem smallRam_capArea : smallRam.capArea = π * (16129 / 6250000) := by
  unfold Cylinder.capArea smallRam; norm_num

theorem bigRam_rodArea : bigRam.rodArea = π * (1467739 / 400000000) := by
  unfold Cylinder.rodArea bigRam; norm_num

/-- The five-inch builds make the force: 262 kN at the relief setting. -/
theorem bigBoreSingle_qualifies : Qualifies bigRam onePump bigLog := by
  unfold Qualifies maxForce bigLog onePump Supply.single
  rw [bigRam_capArea]
  norm_num
  nlinarith [pi_gt_three]

theorem twoStageBig_qualifies : Qualifies bigRam twoPump bigLog := by
  unfold Qualifies maxForce bigLog twoPump
  rw [bigRam_capArea]
  norm_num
  nlinarith [pi_gt_three]

/-- **The four-inch builds cannot split it**, whichever pump is behind them:
167.8 kN is all the bore will give at 207 bar. -/
theorem smallRam_fails (s : Supply) (h : s.relief = 20700000) :
    ¬ Qualifies smallRam s bigLog := by
  unfold Qualifies maxForce bigLog
  rw [smallRam_capArea, h]
  push_neg
  nlinarith [pi_lt_d6]

theorem smallSingle_fails : ¬ Qualifies smallRam onePump bigLog :=
  smallRam_fails onePump rfl

theorem twoStageSmall_fails : ¬ Qualifies smallRam twoPump bigLog :=
  smallRam_fails twoPump rfl

/-- **The tractor's own circuit cannot split it either**, though it has flow to
spare: its relief is set at 140 bar, and on the same five-inch ram that is
177 kN. -/
theorem tractorFed_fails : ¬ Qualifies bigRam tractorCircuit bigLog := by
  unfold Qualifies maxForce bigLog tractorCircuit Supply.single
  rw [bigRam_capArea]
  push_neg
  nlinarith [pi_lt_d6]

/-- The single-stage five-inch build takes `6.6014 π` seconds a split. -/
theorem bigBoreSingle_cycle :
    bigBoreSingle.cycle bigLog = π * (18483834 / 2800000) := by
  have h : bigBoreSingle.cycle bigLog = cycleTime bigRam onePump bigLog := rfl
  rw [h]
  unfold cycleTime extendTime retractTime
  have hone : onePump.flowAt (workPressure bigRam bigLog) = onePump.hiFlow :=
    Supply.flowAt_single onePump rfl _
  rw [bigRam_capArea, bigRam_rodArea, hone]
  simp only [bigRam, onePump, Supply.single, bigLog]
  ring

/-- The two-stage five-inch build takes `5.8306 π` seconds a split. -/
theorem twoStageBig_cycle :
    twoStageBig.cycle bigLog = π * (23322534 / 4000000) := by
  have hlo : twoPump.flowAt (workPressure bigRam bigLog) = twoPump.loFlow := by
    refine Supply.flowAt_of_lt _ ?_
    unfold workPressure bigLog twoPump
    rw [bigRam_capArea]
    rw [lt_div_iff₀ (by positivity)]
    nlinarith [pi_lt_d6]
  have h : twoStageBig.cycle bigLog = cycleTime bigRam twoPump bigLog := rfl
  rw [h]
  unfold cycleTime extendTime retractTime
  rw [bigRam_capArea, bigRam_rodArea, hlo]
  simp only [bigRam, twoPump, bigLog]
  ring

/-- Numerically: 20.73 s and 18.31 s. -/
theorem bigBoreSingle_cycle_bounds :
    20.7 < bigBoreSingle.cycle bigLog ∧ bigBoreSingle.cycle bigLog < 20.75 := by
  rw [bigBoreSingle_cycle]
  constructor
  · nlinarith [pi_gt_d6]
  · nlinarith [pi_lt_d6]

theorem twoStageBig_cycle_bounds :
    18.3 < twoStageBig.cycle bigLog ∧ twoStageBig.cycle bigLog < 18.35 := by
  rw [twoStageBig_cycle]
  constructor
  · nlinarith [pi_gt_d6]
  · nlinarith [pi_lt_d6]

/-- **On the clock, the two-stage pump wins.** -/
theorem twoStageBig_faster : twoStageBig.cycle bigLog < bigBoreSingle.cycle bigLog := by
  rw [twoStageBig_cycle, bigBoreSingle_cycle]
  nlinarith [pi_gt_three]

/-- Hence it splits more wood in an hour. -/
theorem twoStageBig_more_per_hour :
    bigBoreSingle.perHour bigLog < twoStageBig.perHour bigLog := by
  have h1 : (0:ℝ) < twoStageBig.cycle bigLog := by
    rw [twoStageBig_cycle]; nlinarith [pi_gt_three]
  unfold Build.perHour
  exact div_lt_div_of_pos_left (by norm_num) h1 twoStageBig_faster

/-- **On the money, the single-stage pump wins.**  Splits per hour for each unit
of money spent are higher for the cheaper build, because the two-stage pump
costs 21 % more and buys 13 % more wood. -/
theorem bigBoreSingle_better_value :
    twoStageBig.value bigLog < bigBoreSingle.value bigLog := by
  have hpi := pi_gt_three
  have hp1 : bigBoreSingle.price = 950 := rfl
  have hp2 : twoStageBig.price = 1150 := rfl
  unfold Build.value Build.perHour
  rw [bigBoreSingle_cycle, twoStageBig_cycle, hp1, hp2, div_div, div_div,
    div_lt_div_iff₀ (by nlinarith) (by nlinarith)]
  nlinarith

/-- **The bake-off, in one statement.**  Of the five builds, three cannot split
the log at all; of the two that can, the two-stage pump is the faster and the
single-stage pump is the better buy.  There is no single winner. -/
theorem bake_off :
    ¬ Qualifies smallRam onePump bigLog ∧
    ¬ Qualifies smallRam twoPump bigLog ∧
    ¬ Qualifies bigRam tractorCircuit bigLog ∧
    Qualifies bigRam onePump bigLog ∧
    Qualifies bigRam twoPump bigLog ∧
    twoStageBig.cycle bigLog < bigBoreSingle.cycle bigLog ∧
    twoStageBig.value bigLog < bigBoreSingle.value bigLog :=
  ⟨smallSingle_fails, twoStageSmall_fails, tractorFed_fails, bigBoreSingle_qualifies,
    twoStageBig_qualifies, twoStageBig_faster, bigBoreSingle_better_value⟩

end

end Splitter
end LifeTrac
