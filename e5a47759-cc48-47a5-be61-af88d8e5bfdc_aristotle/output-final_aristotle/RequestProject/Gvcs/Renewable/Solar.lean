import Mathlib

/-!
# Mirrors, heliostats and the solar boiler

A flat plate in the sun gives hot water and nothing more.  To drive an engine
you need *concentration*: mirrors that put the light of many square metres onto
one, and a receiver hot enough for a Carnot efficiency worth having.  This file
proves the three things a mirror field and its boiler rest on.

**1. Where a heliostat points** (`Vec3`).  A mirror that must send the sun to a
fixed tower is aimed by one rule: its normal bisects the direction of the sun
and the direction of the target.  `heliostat_normal_bisects` proves that rule
is *forced* — any unit normal that reflects the sun onto the target satisfies
`s + t = (2 s·n) n` — and `bisector_reflects_sun` proves it *suffices*.
`heliostat_half_angle` is the consequence the drive mechanism cares about:
`s·t = 2(s·n)² − 1`, the double-angle identity, so **the mirror turns at half
the rate the sun does**.  `reflect_dot_self` checks the reflection is an
isometry, and `reflect_reflect` that it is an involution.

**2. What the field delivers** (`MirrorField`).  `N` mirrors of area `a`, of
reflectivity `r`, at mean cosine efficiency `c`, under a beam `G`, put
`N·a·r·c·G` watts on the receiver; the *concentration* is that divided by the
receiver area.  `stagnationTemp` is where the receiver's losses eat the whole
input, and `stagnationTemp_mono_concentration` is why you need mirrors at all:
`unglazedPlate_stagnation_lt_boiling` shows an unconcentrated collector cannot
even boil water, while `mirrorField_stagnation_high` shows seventeen suns pass
1500 K.

**3. How hot to run it.**  A hotter receiver is a better *engine* and a worse
*collector*.  Multiply the two efficiencies and the product is a strictly
concave-looking function of the receiver temperature with an optimum in closed
form:

```
T* = √(T_ambient · T_stagnation),      η* = (√T_stag − √T_amb)/(√T_stag + √T_amb).
```

That is `overallEff_le_opt` (the inequality, for *every* temperature), together
with `overallEff_opt_value` and `overallEff_opt_value_sqrt`.  For a 300 K day
and a 1200 K receiver it says: run the boiler at 600 K and take one third of
the light as work (`solarBoiler_optimum`, `solarBoiler_optimum_eff`).
-/

namespace LifeTrac
namespace Renewable

open Real

/-! ## Vectors, mirrors and the law of reflection -/

/-- A vector in space.  Only the dot product is needed, so this is kept
elementary and self-contained. -/
structure Vec3 where
  x : ℝ
  y : ℝ
  z : ℝ

namespace Vec3

/-- Euclidean inner product. -/
def dot (u v : Vec3) : ℝ := u.x * v.x + u.y * v.y + u.z * v.z

/-- Sum of two vectors. -/
def add (u v : Vec3) : Vec3 := ⟨u.x + v.x, u.y + v.y, u.z + v.z⟩

/-- Difference of two vectors. -/
def sub (u v : Vec3) : Vec3 := ⟨u.x - v.x, u.y - v.y, u.z - v.z⟩

/-- Reverse of a vector. -/
def neg (v : Vec3) : Vec3 := ⟨-v.x, -v.y, -v.z⟩

/-- Scalar multiple. -/
def smul (c : ℝ) (v : Vec3) : Vec3 := ⟨c * v.x, c * v.y, c * v.z⟩

/-- A unit vector: a direction. -/
def IsDir (v : Vec3) : Prop := dot v v = 1

/-- Two vectors with the same components are equal. -/
theorem eq_of_components {u v : Vec3} (hx : u.x = v.x) (hy : u.y = v.y) (hz : u.z = v.z) :
    u = v := by
  cases u; cases v; simp_all

theorem dot_comm (u v : Vec3) : dot u v = dot v u := by simp only [dot]; ring

/-- Reflection of a vector `d` in the plane whose (not necessarily unit)
normal is `n`. -/
noncomputable def reflect (n d : Vec3) : Vec3 := sub d (smul (2 * dot d n / dot n n) n)

/-- Reflection in a unit normal takes its familiar form. -/
theorem reflect_of_isDir {n : Vec3} (hn : IsDir n) (d : Vec3) :
    reflect n d = sub d (smul (2 * dot d n) n) := by
  unfold reflect IsDir at *
  rw [hn, div_one]

/-- **Reflection preserves length.**  A mirror does not change the energy of
a ray, only its direction. -/
theorem reflect_dot_self {n : Vec3} (hn : IsDir n) (d : Vec3) :
    dot (reflect n d) (reflect n d) = dot d d := by
  rw [reflect_of_isDir hn]
  unfold IsDir at hn
  simp only [dot, sub, smul] at *
  linear_combination (4 * (d.x * n.x + d.y * n.y + d.z * n.z) ^ 2) * hn

/-- **Reflection is an involution**: reflect twice and you are back. -/
theorem reflect_reflect {n : Vec3} (hn : IsDir n) (d : Vec3) :
    reflect n (reflect n d) = d := by
  rw [reflect_of_isDir hn, reflect_of_isDir hn]
  unfold IsDir at hn
  refine eq_of_components ?_ ?_ ?_ <;>
    simp only [dot, sub, smul] at * <;>
    [ linear_combination (4 * (d.x * n.x + d.y * n.y + d.z * n.z) * n.x) * hn;
      linear_combination (4 * (d.x * n.x + d.y * n.y + d.z * n.z) * n.y) * hn;
      linear_combination (4 * (d.x * n.x + d.y * n.y + d.z * n.z) * n.z) * hn]

/-- **The heliostat law, necessity.**  If a mirror with unit normal `n` sends
the sun, in direction `s`, to a target in direction `t`, then `n` points along
the bisector `s + t`. -/
theorem heliostat_normal_bisects {n s t : Vec3} (hn : IsDir n)
    (h : reflect n (neg s) = t) : add s t = smul (2 * dot s n) n := by
  rw [reflect_of_isDir hn] at h
  subst h
  refine eq_of_components ?_ ?_ ?_ <;> simp only [dot, add, sub, smul, neg] <;> ring

/-- **The heliostat law, sufficiency.**  Aiming the normal along `s + t` does
send the sun to the target, whenever the two directions are not opposite. -/
theorem bisector_reflects_sun {s t : Vec3} (hs : IsDir s) (ht : IsDir t)
    (hst : dot (add s t) (add s t) ≠ 0) :
    reflect (add s t) (neg s) = t := by
  unfold IsDir at hs ht
  have hd : dot (add s t) (add s t) = 2 + 2 * dot s t := by
    simp only [dot, add] at *
    linear_combination hs + ht
  have hns : dot (neg s) (add s t) = -(1 + dot s t) := by
    simp only [dot, add, neg] at *
    linear_combination -hs
  have hne : (2 : ℝ) + 2 * dot s t ≠ 0 := by rw [hd] at hst; exact hst
  have h1 : (1 : ℝ) + dot s t ≠ 0 := by
    intro h; apply hne; linarith
  unfold reflect
  rw [hns, hd]
  have hc : 2 * -(1 + dot s t) / (2 + 2 * dot s t) = -1 := by
    field_simp
  rw [hc]
  refine eq_of_components ?_ ?_ ?_ <;> simp only [sub, smul, add, neg] <;> ring

/-- **The mirror moves at half the rate of the sun.**  If the normal bisects,
then the angle between sun and target is twice the angle between sun and
normal — here as the double-angle identity `cos 2θ = 2cos²θ − 1`. -/
theorem heliostat_half_angle {n s t : Vec3} (hs : IsDir s)
    (h : add s t = smul (2 * dot s n) n) :
    dot s t = 2 * dot s n ^ 2 - 1 := by
  have h1 : dot s (add s t) = dot s (smul (2 * dot s n) n) := by rw [h]
  unfold IsDir at hs
  simp only [dot, add, smul] at *
  linear_combination h1 - hs

/-- Cosine efficiency of a heliostat: the fraction of its area presented to
the sun, `n · s`. -/
def cosineEfficiency (n s : Vec3) : ℝ := dot n s

/-- The cosine efficiency of a heliostat is never more than one, and is
exactly one only when the target lies in the direction of the sun. -/
theorem cosineEfficiency_le_one {n s : Vec3} (hn : IsDir n) (hs : IsDir s) :
    cosineEfficiency n s ≤ 1 := by
  unfold cosineEfficiency IsDir at *
  simp only [dot] at *
  nlinarith [sq_nonneg (n.x - s.x), sq_nonneg (n.y - s.y), sq_nonneg (n.z - s.z)]

end Vec3

/-! ## A field of mirrors -/

/-- Direct beam irradiance of a clear day, W/m². -/
def dni : ℚ := 900

/-- A field of heliostats aimed at one receiver. -/
structure MirrorField where
  /-- Number of mirrors. -/
  count : ℚ
  /-- Area of one mirror, m². -/
  area : ℚ
  /-- Mirror reflectivity. -/
  reflectivity : ℚ
  /-- Mean cosine efficiency over the field. -/
  cosine : ℚ
  /-- Receiver area, m². -/
  receiver : ℚ
  count_pos : 0 < count
  area_pos : 0 < area
  refl_pos : 0 < reflectivity
  cosine_pos : 0 < cosine
  receiver_pos : 0 < receiver

namespace MirrorField

variable (f : MirrorField)

/-- Radiant power the field puts on the receiver, watts. -/
def power : ℚ := f.count * f.area * f.reflectivity * f.cosine * dni

/-- Concentration ratio: how many suns the receiver sees. -/
def concentration : ℚ := f.count * f.area * f.reflectivity * f.cosine / f.receiver

theorem power_pos : 0 < f.power := by
  unfold power dni
  have := f.count_pos; have := f.area_pos; have := f.refl_pos; have := f.cosine_pos
  positivity

theorem concentration_pos : 0 < f.concentration := by
  unfold concentration
  have := f.count_pos; have := f.area_pos; have := f.refl_pos; have := f.cosine_pos
  have := f.receiver_pos
  positivity

/-- The flux at the receiver is the concentration times the beam. -/
theorem flux_eq : f.power / f.receiver = f.concentration * dni := by
  unfold power concentration
  field_simp

end MirrorField

/-! ## The receiver: how hot, and how hot is too hot -/

/-- Stagnation temperature of a receiver: the temperature at which its losses,
`U` watts per square metre per kelvin, consume the whole concentrated beam, so
that no heat at all comes out.  `ta` is the ambient temperature (kelvin), `c`
the concentration, `g` the beam, `u` the loss coefficient. -/
def stagnationTemp (ta c g u : ℚ) : ℚ := ta + c * g / u

/-- Useful heat per square metre of receiver at temperature `t`. -/
def receiverHeat (ta c g u t : ℚ) : ℚ := c * g - u * (t - ta)

/-- At the stagnation temperature the receiver delivers nothing. -/
theorem receiverHeat_stagnation {ta c g u : ℚ} (hu : u ≠ 0) :
    receiverHeat ta c g u (stagnationTemp ta c g u) = 0 := by
  unfold receiverHeat stagnationTemp
  field_simp
  ring

/-- **Why you need mirrors.**  Stagnation temperature rises with
concentration. -/
theorem stagnationTemp_mono_concentration {ta c d g u : ℚ} (hg : 0 < g) (hu : 0 < u)
    (h : c < d) : stagnationTemp ta c g u < stagnationTemp ta d g u := by
  unfold stagnationTemp
  have : c * g / u < d * g / u := by
    apply div_lt_div_of_pos_right _ hu
    exact mul_lt_mul_of_pos_right h hg
  linarith

/-- An unconcentrated plate (`c = 1`), losing 20 W/m²K on a 900 W/m² day from
a 300 K morning, stagnates below the boiling point of water: **no mirrors, no
steam.** -/
theorem unglazedPlate_stagnation_lt_boiling : stagnationTemp 300 1 dni 20 < 373 := by
  unfold stagnationTemp dni
  norm_num

/-- Seventeen suns on the same receiver reach 1575 K — hot enough for a boiler,
indeed hot enough to need controlling. -/
theorem mirrorField_stagnation_high : 1500 < stagnationTemp 300 17 dni 12 := by
  unfold stagnationTemp dni
  norm_num

/-- The concentration that puts the receiver's stagnation point at 1200 K:
twelve suns. -/
theorem twelve_suns_stagnate_at_1200 : stagnationTemp 300 12 dni 12 = 1200 := by
  unfold stagnationTemp dni
  norm_num

/-! ## The best boiler temperature -/

noncomputable section

/-- Collector efficiency at receiver temperature `t`: the fraction of the
concentrated beam that survives the losses.  It falls linearly from one at
ambient to zero at stagnation. -/
def collectorEff (ta ts t : ℝ) : ℝ := (ts - t) / (ts - ta)

/-- Carnot efficiency of an engine between the receiver at `t` and the
surroundings at `ta`. -/
def carnotEff (ta t : ℝ) : ℝ := 1 - ta / t

/-- Overall solar-to-work efficiency: collector times engine. -/
def overallEff (ta ts t : ℝ) : ℝ := collectorEff ta ts t * carnotEff ta t

theorem overallEff_eq {ta ts t : ℝ} (ht : t ≠ 0) (h : ts - ta ≠ 0) :
    overallEff ta ts t = (ts - t) * (t - ta) / ((ts - ta) * t) := by
  unfold overallEff collectorEff carnotEff
  field_simp

/-- The efficiency vanishes at ambient temperature: an engine with no
temperature difference does no work. -/
theorem overallEff_ambient {ta ts : ℝ} (hta : ta ≠ 0) : overallEff ta ts ta = 0 := by
  unfold overallEff carnotEff
  rw [div_self hta]
  ring

/-- ...and at the stagnation temperature: a collector that delivers no heat
does no work either. -/
theorem overallEff_stagnation (ta ts : ℝ) : overallEff ta ts ts = 0 := by
  unfold overallEff collectorEff
  simp

/-- **The optimum receiver temperature is the geometric mean of ambient and
stagnation.**  No temperature does better. -/
theorem overallEff_le_opt {ta ts t : ℝ} (hta : 0 < ta) (hts : ta < ts) (ht : 0 < t) :
    overallEff ta ts t ≤ overallEff ta ts (√(ta * ts)) := by
  have hprod : (0 : ℝ) < ta * ts := mul_pos hta (hta.trans hts)
  have hu : 0 < √(ta * ts) := sqrt_pos.2 hprod
  have hu2 : √(ta * ts) ^ 2 = ta * ts := sq_sqrt hprod.le
  have hts' : (0 : ℝ) < ts - ta := by linarith
  rw [overallEff_eq ht.ne' hts'.ne', overallEff_eq hu.ne' hts'.ne']
  rw [div_le_div_iff₀ (mul_pos hts' ht) (mul_pos hts' hu)]
  have key : (ts - √(ta * ts)) * (√(ta * ts) - ta) * ((ts - ta) * t)
      - (ts - t) * (t - ta) * ((ts - ta) * √(ta * ts))
      = (ts - ta) * √(ta * ts) * (t - √(ta * ts)) ^ 2 := by
    linear_combination ((ts - ta) * (t - √(ta * ts))) * hu2
  have h1 : 0 ≤ (ts - ta) * √(ta * ts) * (t - √(ta * ts)) ^ 2 :=
    mul_nonneg (mul_nonneg hts'.le hu.le) (sq_nonneg _)
  linarith

/-- The value at the optimum. -/
theorem overallEff_opt_value {ta ts : ℝ} (hta : 0 < ta) (hts : ta < ts) :
    overallEff ta ts (√(ta * ts)) = (ts + ta - 2 * √(ta * ts)) / (ts - ta) := by
  have hprod : (0 : ℝ) < ta * ts := mul_pos hta (hta.trans hts)
  have hu : 0 < √(ta * ts) := sqrt_pos.2 hprod
  have hu2 : √(ta * ts) ^ 2 = ta * ts := sq_sqrt hprod.le
  have hts' : (0 : ℝ) < ts - ta := by linarith
  rw [overallEff_eq hu.ne' hts'.ne']
  rw [div_eq_div_iff (mul_pos hts' hu).ne' hts'.ne']
  linear_combination (ts - ta) * hu2

/-- The same value in the form an engineer quotes it:
`(√T_stag − √T_amb)/(√T_stag + √T_amb)`. -/
theorem overallEff_opt_value_sqrt {ta ts : ℝ} (hta : 0 < ta) (hts : ta < ts) :
    overallEff ta ts (√(ta * ts)) = (√ts - √ta) / (√ts + √ta) := by
  have hta' : 0 < √ta := sqrt_pos.2 hta
  have hts0 : 0 < √ts := sqrt_pos.2 (hta.trans hts)
  have ea : √ta ^ 2 = ta := sq_sqrt hta.le
  have es : √ts ^ 2 = ts := sq_sqrt (hta.trans hts).le
  have hmul : √(ta * ts) = √ta * √ts := sqrt_mul hta.le ts
  have hts' : (0 : ℝ) < ts - ta := by linarith
  rw [overallEff_opt_value hta hts, hmul]
  rw [div_eq_div_iff hts'.ne' (by linarith : (0 : ℝ) < √ts + √ta).ne']
  linear_combination (-2 * √ts) * ea + (-2 * √ta) * es

/-- The overall efficiency never beats Carnot. -/
theorem overallEff_le_carnot {ta ts t : ℝ} (hts : ta < ts)
    (ht : 0 < t) (hat : ta ≤ t) (hle : t ≤ ts) : overallEff ta ts t ≤ carnotEff ta t := by
  unfold overallEff collectorEff
  have hc0 : 0 ≤ carnotEff ta t := by
    unfold carnotEff
    rw [sub_nonneg, div_le_one ht]
    exact hat
  have hcnn : 0 ≤ (ts - t) / (ts - ta) := div_nonneg (by linarith) (by linarith)
  have hle1 : (ts - t) / (ts - ta) ≤ 1 := by
    rw [div_le_one (by linarith)]
    linarith
  nlinarith

/-! ## A worked solar boiler -/

/-- A boiler whose receiver stagnates at 1200 K on a 300 K day should be run
at 600 K. -/
theorem solarBoiler_optimum : √((300 : ℝ) * 1200) = 600 := by
  rw [show (300 : ℝ) * 1200 = 600 ^ 2 by norm_num]
  exact sqrt_sq (by norm_num)

/-- ...and then it turns exactly one third of the concentrated sunlight into
work. -/
theorem solarBoiler_optimum_eff : overallEff 300 1200 600 = 1 / 3 := by
  unfold overallEff collectorEff carnotEff
  norm_num

/-- Running it hotter is worse, not better: at 900 K the same boiler gets a
quarter, not a third. -/
theorem solarBoiler_too_hot : overallEff 300 1200 900 = 2 / 9 := by
  unfold overallEff collectorEff carnotEff
  norm_num

theorem solarBoiler_too_hot_lt : overallEff 300 1200 900 < overallEff 300 1200 600 := by
  rw [solarBoiler_optimum_eff, solarBoiler_too_hot]
  norm_num

end

end Renewable
end LifeTrac
