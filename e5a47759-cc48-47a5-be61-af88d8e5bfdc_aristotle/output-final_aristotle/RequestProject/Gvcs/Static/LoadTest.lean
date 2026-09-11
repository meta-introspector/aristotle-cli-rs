import RequestProject.Gvcs.Static.Yield
import RequestProject.Gvcs.Static.Beams

/-!
# Stress-testing the LifeTrac frame: rated loads, proof loads and margins

The previous files give the stresses a load produces.  This one puts them
together into the calculation a builder actually performs — *the load test* —
and then carries it out on a concrete LifeTrac.

The general half formalizes the two ideas behind a load test.  A static
structure in the elastic range responds *linearly*: double the load and every
stress doubles.  So the whole state of a critical point can be recorded as the
direct and shear stress it sees *per newton* of applied load, and then

* the load at which the member first yields is `σ_y` divided by the von Mises
  stress per unit load,
* a **proof-load test** at `k` times the rated load, survived without
  yielding, is exactly a certificate that the factor of safety at the rated
  load is at least `k`.

The concrete half instantiates this on a LifeTrac built from 4 in × 4 in ×
¼ in square steel tube in A36 steel (yield 250 MPa), with a 1.2 m loader arm
rated at 4.5 kN (about 1000 lb) at the bucket, and a load carried 0.5 m off
centre so that the cross member is twisted as well as bent.  We prove, from
the theory in the other files and by arithmetic only:

* the bending stress in the arm at the rated load is under 75 MPa;
* the torsional shear stress in the cross member is under 20 MPa;
* the transverse (web) shear stress is under 4.2 MPa;
* the combined von Mises stress is under 82 MPa, a factor of safety above 3;
* the frame passes a proof load of twice the rated load, and in fact still
  does not yield at three times it;
* the pin joint at the bucket carries more than four times the rated load,
  and it is *tear-out of the plate behind the pin*, not shear of the pin nor
  bearing on the plate, that governs it.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Linear response and the proof-load test -/

/-- The stress state at the critical point of a member, per unit of applied
load: `direct` newtons per square metre of direct (bending or axial) stress
and `shear` of shear stress for each newton applied. -/
structure StressResponse where
  /-- Direct stress per unit load. -/
  direct : ℝ
  /-- Shear stress per unit load. -/
  shear : ℝ
  direct_nonneg : 0 ≤ direct
  shear_nonneg : 0 ≤ shear
  loaded : 0 < direct + shear

namespace StressResponse

variable (r : StressResponse)

/-- The von Mises stress the member sees per unit of applied load. -/
def equivalent : ℝ := vonMisesStress r.direct r.shear

theorem equivalent_pos : 0 < r.equivalent := by
  have h1 := r.direct_nonneg
  have h2 := r.shear_nonneg
  have h3 := r.loaded
  unfold equivalent vonMisesStress
  apply Real.sqrt_pos.2
  rcases h1.lt_or_eq with hd | hd
  · nlinarith [sq_nonneg r.shear]
  · have hs : 0 < r.shear := by linarith
    nlinarith [sq_nonneg r.direct]

/-- The von Mises stress at an applied load `F`. -/
def stressAt (F : ℝ) : ℝ := vonMisesStress (r.direct * F) (r.shear * F)

/-- **Linearity**: the stress at load `F` is `F` times the stress per unit
load.  This is the whole content of an elastic load test. -/
theorem stressAt_eq {F : ℝ} (hF : 0 ≤ F) : r.stressAt F = F * r.equivalent := by
  unfold stressAt equivalent vonMisesStress
  rw [show (r.direct * F) ^ 2 + 3 * (r.shear * F) ^ 2
      = F ^ 2 * (r.direct ^ 2 + 3 * r.shear ^ 2) by ring,
    Real.sqrt_mul (by positivity), Real.sqrt_sq hF]

theorem stressAt_zero : r.stressAt 0 = 0 := by
  rw [r.stressAt_eq le_rfl]; ring

/-- **A bigger load is a bigger stress.** -/
theorem stressAt_mono {F₁ F₂ : ℝ} (h0 : 0 ≤ F₁) (h : F₁ ≤ F₂) :
    r.stressAt F₁ ≤ r.stressAt F₂ := by
  rw [r.stressAt_eq h0, r.stressAt_eq (le_trans h0 h)]
  exact mul_le_mul_of_nonneg_right h r.equivalent_pos.le

/-- The load at which the member first yields. -/
def limitLoad (sy : ℝ) : ℝ := sy / r.equivalent

/-- **The load test.** The member survives a load exactly when the load is
within its limit load. -/
theorem safe_iff {F sy : ℝ} (hF : 0 ≤ F) :
    r.stressAt F ≤ sy ↔ F ≤ r.limitLoad sy := by
  rw [r.stressAt_eq hF, limitLoad, le_div_iff₀ r.equivalent_pos, mul_comm]

theorem limitLoad_pos {sy : ℝ} (hy : 0 < sy) : 0 < r.limitLoad sy :=
  div_pos hy r.equivalent_pos

/-- **What a proof-load test certifies.** If the structure carries `k` times
its rated load `W` without yielding, then its factor of safety at the rated
load is at least `k` — and conversely.  This is why machines are proof-tested
at a multiple of their rating rather than calculated alone. -/
theorem proofTest_iff {W sy k : ℝ} (hW : 0 < W) (hk : 0 ≤ k) :
    r.stressAt (k * W) ≤ sy ↔ k ≤ safetyFactor sy (r.stressAt W) := by
  have he := r.equivalent_pos
  have hs : 0 < r.stressAt W := by
    rw [r.stressAt_eq hW.le]; positivity
  rw [r.stressAt_eq (by positivity), safetyFactor, le_div_iff₀ hs,
    r.stressAt_eq hW.le]
  constructor <;> intro h <;> nlinarith [h]

/-- Passing a proof test at `k` times the rated load implies passing at every
smaller multiple: a test at the higher load subsumes the lower ones. -/
theorem proofTest_mono {W sy k₁ k₂ : ℝ} (hW : 0 ≤ W) (h0 : 0 ≤ k₁) (h : k₁ ≤ k₂)
    (hpass : r.stressAt (k₂ * W) ≤ sy) : r.stressAt (k₁ * W) ≤ sy :=
  le_trans (r.stressAt_mono (by positivity) (mul_le_mul_of_nonneg_right h hW)) hpass

end StressResponse

/-! ## A concrete LifeTrac: 4 in × 4 in × ¼ in tube in A36 steel -/

/-- The frame and loader-arm member: 4 in × 4 in × ¼ in square steel tube,
`0.1016 m` across the flats with a `0.00635 m` wall. -/
def frameTube : SquareTube where
  width := 127 / 1250
  wall := 127 / 20000
  wall_pos := by norm_num
  wall_lt_half_width := by norm_num

/-- Yield strength of A36 structural steel, 250 MPa. -/
def steelYield : ℝ := 250000000

/-- Length of the loader arm, 1.2 m from the pivot to the bucket. -/
def armLength : ℝ := 6 / 5

/-- Rated load at the bucket of one arm: 4.5 kN, about 1000 lb. -/
def ratedLoad : ℝ := 4500

/-- How far off centre the load is carried, twisting the cross member. -/
def loadOffset : ℝ := 1 / 2

/-- Bending stress in the arm under a tip load `F`. -/
def armBendingStress (F : ℝ) : ℝ :=
  frameTube.bendingStress (SquareTube.cantileverMoment F armLength)

/-- Torsional shear stress in the cross member under an off-centre load `F`. -/
def armTorsionStress (F : ℝ) : ℝ := frameTube.torsionShearStress (F * loadOffset)

/-- Transverse shear stress in the walls of the arm under a tip load `F`. -/
def armWebShearStress (F : ℝ) : ℝ := frameTube.webShearStress F

/-- The combined von Mises stress at the critical point of the arm. -/
def armVonMises (F : ℝ) : ℝ := vonMisesStress (armBendingStress F) (armTorsionStress F)

/-- **The bending stress at the rated load is under 75 MPa.** -/
theorem armBendingStress_rated : armBendingStress ratedLoad ≤ 75000000 := by
  unfold armBendingStress ratedLoad armLength SquareTube.cantileverMoment
    SquareTube.bendingStress SquareTube.sectionModulus SquareTube.inertia
    SquareTube.innerWidth frameTube
  norm_num

/-- **The torsional shear stress in the cross member is under 20 MPa.** -/
theorem armTorsionStress_rated : armTorsionStress ratedLoad ≤ 20000000 := by
  unfold armTorsionStress ratedLoad loadOffset SquareTube.torsionShearStress
    SquareTube.enclosedArea SquareTube.midWidth frameTube
  norm_num

/-- **The transverse shear stress in the walls is under 4.2 MPa** — an order of
magnitude below the bending stress, which is why a loader arm is sized on
bending. -/
theorem armWebShearStress_rated : armWebShearStress ratedLoad ≤ 4200000 := by
  unfold armWebShearStress ratedLoad SquareTube.webShearStress
    transverseShearStress SquareTube.firstMoment SquareTube.webWidth
    SquareTube.inertia SquareTube.innerWidth frameTube
  norm_num

/-- **The combined stress at the rated load is under 82 MPa**, well inside the
250 MPa yield strength of the steel. -/
theorem armVonMises_rated : armVonMises ratedLoad ≤ 82000000 := by
  unfold armVonMises
  rw [vonMises_le_iff (by norm_num)]
  unfold armBendingStress armTorsionStress ratedLoad armLength loadOffset
    SquareTube.cantileverMoment SquareTube.bendingStress
    SquareTube.sectionModulus SquareTube.inertia SquareTube.innerWidth
    SquareTube.torsionShearStress SquareTube.enclosedArea SquareTube.midWidth
    frameTube
  norm_num

/-- **The factor of safety of the loaded arm is better than three.** -/
theorem armSafetyFactor_rated : 3 ≤ safetyFactor steelYield (armVonMises ratedLoad) := by
  have hpos : 0 < armVonMises ratedLoad := by
    unfold armVonMises vonMisesStress
    apply Real.sqrt_pos.2
    unfold armBendingStress ratedLoad armLength SquareTube.cantileverMoment
      SquareTube.bendingStress SquareTube.sectionModulus SquareTube.inertia
      SquareTube.innerWidth frameTube
    positivity
  rw [safetyFactor, le_div_iff₀ hpos]
  have h : armVonMises ratedLoad ≤ 82000000 := armVonMises_rated
  unfold steelYield
  linarith

/-- **The frame passes a proof load of twice its rating.** -/
theorem passes_double_proof_load : armVonMises (2 * ratedLoad) ≤ steelYield := by
  unfold armVonMises steelYield
  rw [vonMises_le_iff (by norm_num)]
  unfold armBendingStress armTorsionStress ratedLoad armLength loadOffset
    SquareTube.cantileverMoment SquareTube.bendingStress
    SquareTube.sectionModulus SquareTube.inertia SquareTube.innerWidth
    SquareTube.torsionShearStress SquareTube.enclosedArea SquareTube.midWidth
    frameTube
  norm_num

/-- **… and does not yield even at three times the rated load.** -/
theorem passes_triple_proof_load : armVonMises (3 * ratedLoad) ≤ steelYield := by
  unfold armVonMises steelYield
  rw [vonMises_le_iff (by norm_num)]
  unfold armBendingStress armTorsionStress ratedLoad armLength loadOffset
    SquareTube.cantileverMoment SquareTube.bendingStress
    SquareTube.sectionModulus SquareTube.inertia SquareTube.innerWidth
    SquareTube.torsionShearStress SquareTube.enclosedArea SquareTube.midWidth
    frameTube
  norm_num

/-! ### Holding the machine's own weight between the wheels -/

/-- Mass of the LifeTrac as costed in `RequestProject.Materials`, 1540 kg. -/
def machineMass : ℝ := 1540

/-- Standard gravity. -/
def gravity : ℝ := 981 / 100

/-- Weight of the machine, about 15.1 kN. -/
def machineWeight : ℝ := machineMass * gravity

/-- Span of the frame rails between the axles, 1.5 m. -/
def frameSpan : ℝ := 3 / 2

/-- Bending stress in one of the two frame rails, each carrying half the
weight of the machine at mid-span — the conservative way to count it, since in
reality the weight is spread along the rail. -/
def railBendingStress : ℝ := frameTube.spanStress (machineWeight / 2) frameSpan

/-- **A frame rail holding half the machine's weight works at under 40 MPa.**
(Spreading that weight along the rail instead of hanging it at mid-span would
halve the figure again.) -/
theorem railBendingStress_bound : railBendingStress ≤ 40000000 := by
  unfold railBendingStress SquareTube.spanStress simplySupportedMoment
    machineWeight machineMass gravity frameSpan SquareTube.bendingStress
    SquareTube.sectionModulus SquareTube.inertia SquareTube.innerWidth frameTube
  norm_num

/-- **The rails carry the machine with a factor of safety better than six.** -/
theorem railSafetyFactor : 6 ≤ safetyFactor steelYield railBendingStress := by
  have hpos : 0 < railBendingStress := by
    unfold railBendingStress SquareTube.spanStress simplySupportedMoment
      machineWeight machineMass gravity frameSpan SquareTube.bendingStress
      SquareTube.sectionModulus SquareTube.inertia SquareTube.innerWidth frameTube
    norm_num
  rw [safetyFactor, le_div_iff₀ hpos]
  have h := railBendingStress_bound
  unfold steelYield
  linarith

/-! ### The pin at the bucket -/

/-- The bucket pin: one 1 in pin in double shear through a ¼ in plate, the
hole one inch from the edge; A36 steel throughout, taking the shear strength
as 144 MPa (the `σ_y/√3` of the von Mises criterion) and the bearing strength
as the full 250 MPa. -/
def bucketPin : PinnedJoint where
  count := 1
  pinRadius := 127 / 10000
  plate := 127 / 20000
  edge := 127 / 5000
  planes := 2
  pinShear := 144000000
  bearing := 250000000
  plateShear := 144000000
  count_pos := by norm_num
  planes_pos := by norm_num
  pinRadius_pos := by norm_num
  plate_pos := by norm_num
  edge_gt := by norm_num
  pinShear_pos := by norm_num
  bearing_pos := by norm_num
  plateShear_pos := by norm_num

/-- **Tear-out of the plate behind the pin is what governs the bucket joint**:
it is the weakest of the three failure modes, so the joint's capacity is its
tear-out capacity.  Making the pin fatter would buy nothing; moving the hole
further from the edge is what helps. -/
theorem bucketPin_tearOut_governs : bucketPin.capacity = bucketPin.tearOutLimit := by
  have hpi := Real.pi_gt_three
  have h1 : bucketPin.tearOutLimit ≤ bucketPin.shearLimit := by
    unfold PinnedJoint.tearOutLimit PinnedJoint.shearLimit bucketPin
    push_cast
    nlinarith [hpi]
  have h2 : bucketPin.tearOutLimit ≤ bucketPin.bearingLimit := by
    unfold PinnedJoint.tearOutLimit PinnedJoint.bearingLimit bucketPin
    push_cast
    norm_num
  unfold PinnedJoint.capacity
  rw [min_eq_right h2]
  exact min_eq_right h1

/-- **The bucket pin joint carries more than four times the rated load.** -/
theorem bucketPin_capacity_rated : 4 * ratedLoad ≤ bucketPin.capacity := by
  have hpi := Real.pi_gt_three
  rw [PinnedJoint.safe_iff]
  refine ⟨?_, ?_, ?_⟩
  · unfold PinnedJoint.shearLimit bucketPin ratedLoad
    push_cast
    nlinarith [hpi]
  · unfold PinnedJoint.bearingLimit bucketPin ratedLoad
    push_cast
    norm_num
  · unfold PinnedJoint.tearOutLimit bucketPin ratedLoad
    push_cast
    norm_num

end

end LifeTrac
