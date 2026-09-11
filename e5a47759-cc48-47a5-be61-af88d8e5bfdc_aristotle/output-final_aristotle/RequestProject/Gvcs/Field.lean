import RequestProject.Gvcs.Kinematics

/-!
# Working a field: coverage, headland turns and field efficiency

`Farm.lean` charges a job at a given *field efficiency*.  This file derives
that efficiency instead of assuming it: a rectangular plot is worked in
parallel passes, and the time lost is the time spent turning at the headland,
where the machine is not covering ground.

We prove

* the path length of a boustrophedon coverage is the area divided by the
  working width — whatever the shape of the rectangle;
* the working time splits into productive time plus turning time, so the field
  efficiency is `1` exactly when nothing is spent turning, and is always at
  most `1`;
* long fields are efficient: at a fixed width, lengthening the passes raises
  the efficiency, and a wider implement (fewer passes) raises it too;
* the headland turn of a skid steer is a spin on the spot, whose duration
  follows from the kinematics of the chassis, and is quicker than driving a
  loop of radius greater than half the track;
* the energy needed to pull an implement through the field depends on the
  draft and the width but *not* on the speed: driving faster finishes sooner
  without saving fuel at the drawbar.

Lengths are in metres, speeds in metres per second, times in seconds.
-/

namespace LifeTrac

open Real

noncomputable section

/-- A rectangular plot, worked in passes along its `length`; `width` is the
distance across the passes. -/
structure Plot where
  /-- Length of one pass. -/
  length : ℝ
  /-- Width of the plot, across the passes. -/
  width : ℝ
  length_pos : 0 < length
  width_pos : 0 < width

namespace Plot

variable (p : Plot)

/-- Area of the plot. -/
def area : ℝ := p.length * p.width

theorem area_pos : 0 < p.area := mul_pos p.length_pos p.width_pos

/-- Number of passes needed with an implement of working width `w`. -/
def passes (w : ℝ) : ℝ := p.width / w

theorem passes_pos {w : ℝ} (hw : 0 < w) : 0 < p.passes w :=
  div_pos p.width_pos hw

/-- One pass at least, as long as the implement is no wider than the plot. -/
theorem one_le_passes {w : ℝ} (hw : 0 < w) (h : w ≤ p.width) : 1 ≤ p.passes w :=
  (one_le_div hw).2 h

/-- Distance driven while covering the plot. -/
def pathLength (w : ℝ) : ℝ := p.length * p.passes w

/-- **Coverage.**  The distance driven is the area divided by the working
width, no matter how the rectangle is oriented. -/
theorem pathLength_eq (w : ℝ) : p.pathLength w = p.area / w := by
  unfold pathLength passes area
  ring

/-- The time the machine would take if it never had to turn. -/
def idealTime (w v : ℝ) : ℝ := p.area / (w * v)

/-- The time actually taken: driving the passes, plus one headland turn
between consecutive passes. -/
def workTime (w v turnTime : ℝ) : ℝ :=
  p.pathLength w / v + (p.passes w - 1) * turnTime

theorem workTime_eq (w v turnTime : ℝ) :
    p.workTime w v turnTime = p.idealTime w v + (p.passes w - 1) * turnTime := by
  unfold workTime idealTime
  rw [pathLength_eq]
  ring_nf

theorem idealTime_pos {w v : ℝ} (hw : 0 < w) (hv : 0 < v) : 0 < p.idealTime w v :=
  div_pos p.area_pos (mul_pos hw hv)

theorem idealTime_le_workTime {w v turnTime : ℝ} (hw : 0 < w) (h : w ≤ p.width)
    (ht : 0 ≤ turnTime) : p.idealTime w v ≤ p.workTime w v turnTime := by
  have h1 : 1 ≤ p.passes w := p.one_le_passes hw h
  rw [workTime_eq]
  nlinarith

/-- Field efficiency: the fraction of the working time that is actually spent
covering ground. -/
def fieldEfficiency (w v turnTime : ℝ) : ℝ :=
  p.idealTime w v / p.workTime w v turnTime

/-- **Turning is the whole of the loss.**  The field efficiency never exceeds
one. -/
theorem fieldEfficiency_le_one {w v turnTime : ℝ} (hw : 0 < w) (hv : 0 < v)
    (h : w ≤ p.width) (ht : 0 ≤ turnTime) :
    p.fieldEfficiency w v turnTime ≤ 1 := by
  have h0 : 0 < p.idealTime w v := p.idealTime_pos hw hv
  have h1 : p.idealTime w v ≤ p.workTime w v turnTime :=
    p.idealTime_le_workTime hw h ht
  unfold fieldEfficiency
  rw [div_le_one (by linarith)]
  exact h1

/-- Nothing is lost exactly when nothing is spent turning. -/
theorem fieldEfficiency_eq_one {w v : ℝ} (hw : 0 < w) (hv : 0 < v) :
    p.fieldEfficiency w v 0 = 1 := by
  have h0 : 0 < p.idealTime w v := p.idealTime_pos hw hv
  unfold fieldEfficiency
  rw [workTime_eq, mul_zero, add_zero, div_self h0.ne']

/-- An auxiliary monotonicity fact: `a ↦ a/(a+c)` increases. -/
theorem ratio_mono {a b c : ℝ} (ha : 0 < a) (hc : 0 ≤ c) (h : a ≤ b) :
    a / (a + c) ≤ b / (b + c) := by
  have hb : 0 < b := lt_of_lt_of_le ha h
  rw [div_le_div_iff₀ (by linarith) (by linarith)]
  nlinarith

/-- **Long fields are efficient.**  At the same plot width, lengthening the
passes raises the field efficiency: the same number of headland turns is spread
over more work. -/
theorem fieldEfficiency_mono_length {w v turnTime : ℝ} (q : Plot) (hw : 0 < w)
    (hv : 0 < v) (ht : 0 ≤ turnTime) (hwq : p.width = q.width)
    (hle : w ≤ p.width) (h : p.length ≤ q.length) :
    p.fieldEfficiency w v turnTime ≤ q.fieldEfficiency w v turnTime := by
  have hpq : p.passes w = q.passes w := by unfold passes; rw [hwq]
  have hc : 0 ≤ (p.passes w - 1) * turnTime := by
    have := p.one_le_passes hw hle
    nlinarith
  have hia : 0 < p.idealTime w v := p.idealTime_pos hw hv
  have hab : p.idealTime w v ≤ q.idealTime w v := by
    unfold idealTime area
    apply div_le_div_of_nonneg_right _ (mul_pos hw hv).le
    rw [hwq]
    exact mul_le_mul_of_nonneg_right h q.width_pos.le
  rw [hpq] at hc
  unfold fieldEfficiency
  rw [workTime_eq, workTime_eq, hpq]
  exact ratio_mono hia hc hab

/-- **The energy at the drawbar does not depend on the speed.**  Pulling an
implement of draft `F` through the plot costs `F · area / w` of work however
fast the machine is driven; speed buys time, not fuel. -/
theorem draftEnergy_eq (F w : ℝ) : F * p.pathLength w = F * p.area / w := by
  rw [pathLength_eq]
  ring

/-- The power at the drawbar is the draft times the speed, and multiplied by
the productive time it gives back exactly the energy above. -/
theorem draftPower_mul_idealTime {F w v : ℝ} (hv : v ≠ 0) :
    (F * v) * p.idealTime w v = F * p.area / w := by
  unfold idealTime
  field_simp

end Plot

/-! ## The headland turn of a skid steer

A skid-steer machine turns at the end of a pass by counter-rotating its two
sides: the left wheels run at `-vw` and the right wheels at `vw`, so the
machine spins on the spot. -/

/-- Time for a skid-steer chassis to spin through half a turn with its wheels
running at `±vw`. -/
def spinTurnTime (track vw : ℝ) : ℝ := π * track / (2 * vw)

/-- **The headland turn from the kinematics.**  Counter-rotating the two sides
at `±vw` turns the machine through exactly `π` radians — a half turn, lining it
up for the next pass — in `spinTurnTime`. -/
theorem Chassis.spinTurn (c : Chassis) {vw : ℝ} (hv : 0 < vw) :
    c.angVel (-vw) vw * spinTurnTime c.track vw = π := by
  have h1 := c.track_pos.ne'
  have h2 := hv.ne'
  unfold Chassis.angVel spinTurnTime
  field_simp
  ring

/-- The machine really does stay put during that turn: its linear velocity is
zero throughout. -/
theorem Chassis.spinTurn_linVel (c : Chassis) (vw : ℝ) :
    c.linVel (-vw) vw = 0 := by
  unfold Chassis.linVel
  ring

/-- **Spinning beats looping.**  Turning on the spot takes less time than
driving a half-circle of radius `R` at the same wheel speed as soon as `R`
exceeds half the track — which it always does for a machine that has to come
back onto the neighbouring pass. -/
theorem spinTurnTime_lt_loopTurnTime {track vw R : ℝ}
    (hv : 0 < vw) (hR : track / 2 < R) :
    spinTurnTime track vw < π * R / vw := by
  have hpi := pi_pos
  unfold spinTurnTime
  rw [div_lt_div_iff₀ (by positivity) hv]
  have h2 : track < 2 * R := by linarith
  nlinarith [mul_pos hpi hv]

end

end LifeTrac
