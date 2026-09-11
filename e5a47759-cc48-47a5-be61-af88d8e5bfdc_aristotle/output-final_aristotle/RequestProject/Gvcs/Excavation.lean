import RequestProject.Gvcs.Traction
import RequestProject.Gvcs.Cylinder

/-!
# Digging with the machine: bucket loads, dig cycles and ripping

The mining side of the project needs to know what the tractor can actually
*move*.  This file supplies that: it is the physical half of the ore-mining
development, and the plant model of `RequestProject/Mining.lean` is the
book-keeping half.

Three things limit the output of a pit worked with a loader tractor.

* **The bucket.**  A bucket holds `volume * fillFactor` cubic metres of loose
  material, so it lifts `volume * fillFactor * density` kilograms.  That load
  must not tip the machine forward — the criterion is the loader capacity of
  `RequestProject/Stability.lean` — and the loader must have the breakout
  force to fill it, which is the cylinder/linkage calculation of
  `RequestProject/Cylinder.lean`.
* **The dig cycle.**  Filling, swinging, dumping and travelling to the stockpile
  and back take time; the loading rate is one bucket load per cycle, so it
  falls as the haul gets longer.
* **The rock.**  Loose material can simply be scooped, but rock has to be
  loosened first.  A ripper tooth at depth `d` and width `w` in ground of
  specific resistance `k` needs `k·w·d` newtons of drawbar pull, which the
  traction model of `RequestProject/Traction.lean` caps.

The pit runs at whichever of loading and loosening is the slower: that is
`pitRate`, and the hours to move a given tonnage follow from it.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## The bucket -/

/-- A loader bucket working in material of a given loose density. -/
structure Bucket where
  /-- Struck capacity of the bucket, in cubic metres. -/
  volume : ℝ
  /-- Fill factor: the fraction of the struck capacity actually carried. -/
  fillFactor : ℝ
  /-- Loose (bank-broken) density of the material, in kg/m³. -/
  density : ℝ
  volume_pos : 0 < volume
  fillFactor_pos : 0 < fillFactor
  fillFactor_le_one : fillFactor ≤ 1
  density_pos : 0 < density

namespace Bucket

variable (b : Bucket)

/-- The mass, in kilograms, carried by one bucket load. -/
def payload : ℝ := b.volume * b.fillFactor * b.density

theorem payload_pos : 0 < b.payload :=
  mul_pos (mul_pos b.volume_pos b.fillFactor_pos) b.density_pos

/-- A bucket never carries more than its struck capacity's worth. -/
theorem payload_le_struck : b.payload ≤ b.volume * b.density := by
  have h := b.fillFactor_le_one
  have hv := b.volume_pos
  have hd := b.density_pos
  have hkey : 0 ≤ b.volume * b.density * (1 - b.fillFactor) :=
    mul_nonneg (mul_nonneg hv.le hd.le) (by linarith)
  simp only [payload]
  nlinarith

/-- The weight of a bucket load, in newtons. -/
def load (g : ℝ) : ℝ := b.payload * g

theorem load_pos {g : ℝ} (hg : 0 < g) : 0 < b.load g := mul_pos b.payload_pos hg

/-- **A full bucket must not tip the machine forward.**  Carrying a bucket
load at reach `l` keeps the rear wheels down exactly when the bucket is small
enough — the limiting volume being the tipping capacity divided by the weight
of a cubic metre of the material carried. -/
theorem load_within_capacity_iff (s : SideView) {g l : ℝ} (hg : 0 < g) :
    b.load g ≤ s.maxPayload l ↔
      b.volume ≤ s.maxPayload l / (g * b.fillFactor * b.density) := by
  have hpos : 0 < g * b.fillFactor * b.density :=
    mul_pos (mul_pos hg b.fillFactor_pos) b.density_pos
  rw [le_div_iff₀ hpos]
  simp only [load, payload]
  constructor <;> intro h <;> nlinarith

/-- Restated through the stability criterion: a bucket load at reach `l` is
safe exactly when the rear axle still carries a non-negative load. -/
theorem load_safe_iff (s : SideView) {g l : ℝ} (hl : 0 < l) :
    0 ≤ s.rearAxleLoadWithPayload (b.load g) l ↔ b.load g ≤ s.maxPayload l :=
  s.rear_wheels_grounded_iff hl

end Bucket

/-! ## The dig cycle -/

/-- One load-haul-dump cycle: time to fill the bucket, time to dump and
re-position, and a round trip to the stockpile. -/
structure DigCycle where
  /-- Seconds spent crowding the bucket full. -/
  fillTime : ℝ
  /-- Seconds spent raising, dumping and re-positioning. -/
  dumpTime : ℝ
  /-- One-way haul distance to the stockpile, in metres. -/
  haul : ℝ
  /-- Travel speed, in metres per second. -/
  speed : ℝ
  fillTime_pos : 0 < fillTime
  dumpTime_pos : 0 < dumpTime
  haul_nonneg : 0 ≤ haul
  speed_pos : 0 < speed

namespace DigCycle

variable (c : DigCycle)

/-- The time, in seconds, of one complete cycle. -/
def cycleTime : ℝ := c.fillTime + c.dumpTime + 2 * c.haul / c.speed

theorem cycleTime_pos : 0 < c.cycleTime := by
  have h1 := c.fillTime_pos
  have h2 := c.dumpTime_pos
  have h3 := c.haul_nonneg
  have h4 := c.speed_pos
  have : 0 ≤ 2 * c.haul / c.speed := by positivity
  simp only [cycleTime]
  linarith

/-- Working at the face, with nothing to haul, is the quickest cycle there
is. -/
theorem cycleTime_ge : c.fillTime + c.dumpTime ≤ c.cycleTime := by
  have h3 := c.haul_nonneg
  have h4 := c.speed_pos
  have : 0 ≤ 2 * c.haul / c.speed := by positivity
  simp only [cycleTime]
  linarith

/-- A longer haul is a longer cycle. -/
theorem cycleTime_mono_haul {c₁ c₂ : DigCycle} (hf : c₁.fillTime = c₂.fillTime)
    (hd : c₁.dumpTime = c₂.dumpTime) (hs : c₁.speed = c₂.speed) (h : c₁.haul ≤ c₂.haul) :
    c₁.cycleTime ≤ c₂.cycleTime := by
  have hsp : 0 < c₂.speed := c₂.speed_pos
  simp only [cycleTime, hf, hd, hs]
  have : 2 * c₁.haul / c₂.speed ≤ 2 * c₂.haul / c₂.speed := by gcongr
  linarith

/-- The loading rate, in kilograms per hour: one bucket load per cycle. -/
def loadRate (b : Bucket) : ℝ := 3600 * b.payload / c.cycleTime

theorem loadRate_pos (b : Bucket) : 0 < c.loadRate b := by
  have hb := b.payload_pos
  have hc := c.cycleTime_pos
  simp only [loadRate]
  exact div_pos (by linarith) hc

/-- A bigger bucket loads faster. -/
theorem loadRate_mono {b₁ b₂ : Bucket} (h : b₁.payload ≤ b₂.payload) :
    c.loadRate b₁ ≤ c.loadRate b₂ := by
  have := c.cycleTime_pos
  simp only [loadRate]
  gcongr

/-- **Hauling costs output.**  The rate at the face, with no haul at all, is
an upper bound for the rate of any cycle with the same bucket and the same
fill and dump times. -/
theorem loadRate_le_faceRate (b : Bucket) :
    c.loadRate b ≤ 3600 * b.payload / (c.fillTime + c.dumpTime) := by
  have h1 := c.fillTime_pos
  have h2 := c.dumpTime_pos
  have hb := b.payload_pos
  have := c.cycleTime_ge
  apply div_le_div_of_nonneg_left (by positivity) (by linarith) this

end DigCycle

/-! ## Loosening the ground -/

/-- The drawbar pull, in newtons, needed to pull a ripper tooth of width `w`
metres at depth `d` metres through ground of specific resistance `k` newtons
per square metre of cut. -/
def ripResistance (k w d : ℝ) : ℝ := k * w * d

/-- **How deep the machine can rip.**  With `P` newtons of drawbar pull
available, a tooth of width `w` in ground of resistance `k` can be pulled at
depth `d` exactly when `d ≤ P / (k·w)`. -/
theorem rip_feasible_iff {k w d P : ℝ} (hk : 0 < k) (hw : 0 < w) :
    ripResistance k w d ≤ P ↔ d ≤ P / (k * w) := by
  rw [le_div_iff₀ (mul_pos hk hw)]
  simp only [ripResistance]
  constructor <;> intro h <;> nlinarith

/-- Ripping deeper needs more pull. -/
theorem ripResistance_mono {k w d₁ d₂ : ℝ} (hk : 0 ≤ k) (hw : 0 ≤ w) (h : d₁ ≤ d₂) :
    ripResistance k w d₁ ≤ ripResistance k w d₂ := by
  simp only [ripResistance]
  have : 0 ≤ k * w := mul_nonneg hk hw
  nlinarith

/-- The mass of ground loosened per hour by a tooth of width `w` at depth `d`
drawn at `v` metres per second through material of bank density `rho`, allowing
for a duty factor `duty ∈ [0,1]` (the fraction of the hour actually spent
ripping). -/
def ripRate (w d v rho duty : ℝ) : ℝ := 3600 * duty * (w * d * v * rho)

theorem ripRate_nonneg {w d v rho duty : ℝ} (hw : 0 ≤ w) (hd : 0 ≤ d) (hv : 0 ≤ v)
    (hrho : 0 ≤ rho) (hduty : 0 ≤ duty) : 0 ≤ ripRate w d v rho duty := by
  simp only [ripRate]
  positivity

/-- **What the drawbar pull buys.**  Since the depth is capped by the
available pull, so is the tonnage loosened per hour: it can never exceed
`3600·duty·P·v·rho/k`, whatever tooth is fitted. -/
theorem ripRate_le_of_pull {k w d v rho duty P : ℝ} (hk : 0 < k) (hv : 0 ≤ v)
    (hrho : 0 ≤ rho) (hduty : 0 ≤ duty) (h : ripResistance k w d ≤ P) :
    ripRate w d v rho duty ≤ 3600 * duty * (P * v * rho / k) := by
  have hwd : w * d ≤ P / k := by
    rw [le_div_iff₀ hk]
    simp only [ripResistance] at h
    nlinarith
  have hvr : 0 ≤ v * rho := mul_nonneg hv hrho
  have hstep : w * d * v * rho ≤ P * v * rho / k := by
    calc w * d * v * rho = w * d * (v * rho) := by ring
      _ ≤ P / k * (v * rho) := by nlinarith
      _ = P * v * rho / k := by ring
  simp only [ripRate]
  nlinarith [mul_nonneg hduty (sub_nonneg.2 hstep)]

/-! ## What the pit produces -/

/-- The output of the pit, in kilograms per hour: whichever of loosening the
ground and loading it out is the slower. -/
def pitRate (loosen loadOut : ℝ) : ℝ := min loosen loadOut

theorem pitRate_le_loosen (loosen loadOut : ℝ) : pitRate loosen loadOut ≤ loosen :=
  min_le_left _ _

theorem pitRate_le_loadOut (loosen loadOut : ℝ) : pitRate loosen loadOut ≤ loadOut :=
  min_le_right _ _

/-- When the rock is the bottleneck — as it is for a small machine in hard
ground — a bigger bucket makes no difference at all. -/
theorem pitRate_eq_loosen {loosen loadOut : ℝ} (h : loosen ≤ loadOut) :
    pitRate loosen loadOut = loosen := min_eq_left h

theorem pitRate_pos {loosen loadOut : ℝ} (h1 : 0 < loosen) (h2 : 0 < loadOut) :
    0 < pitRate loosen loadOut := lt_min h1 h2

/-- The hours needed to win a given mass of material at a given pit rate. -/
def pitHours (rate mass : ℝ) : ℝ := mass / rate

/-- The pit does indeed deliver the mass in that time. -/
theorem pitHours_spec {rate mass : ℝ} (hrate : 0 < rate) :
    rate * pitHours rate mass = mass := by
  simp only [pitHours]
  field_simp

/-- A faster pit is a shorter job. -/
theorem pitHours_antitone {r₁ r₂ mass : ℝ} (h1 : 0 < r₁) (h : r₁ ≤ r₂) (hm : 0 ≤ mass) :
    pitHours r₂ mass ≤ pitHours r₁ mass :=
  div_le_div_of_nonneg_left hm h1 h

/-- Twice the tonnage takes twice as long. -/
theorem pitHours_smul (rate mass c : ℝ) : pitHours rate (c * mass) = c * pitHours rate mass := by
  simp only [pitHours]
  ring

end

end LifeTrac
