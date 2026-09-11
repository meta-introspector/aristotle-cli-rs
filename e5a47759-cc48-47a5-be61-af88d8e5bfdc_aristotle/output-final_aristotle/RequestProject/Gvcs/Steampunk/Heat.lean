import Mathlib

/-!
# Steam, ice, wood gas and mirrors: the power train with no electronics in it

The printer of `RequestProject/Printer/` needs shaft power and a cold sink.
This file supplies both without a grid, a battery or a semiconductor, and
counts what it costs.

* **The engine.**  `Engine.efficiency_le_carnot` is the second law as it is
  used here: a heat engine between a boiler at `Th` and a condenser at `Tc`
  cannot beat `1 - Tc/Th`.  `carnot_ice_gt_ambient` is the reason for the ice:
  a condenser held at the melting point of ice has a strictly higher ceiling
  than one held at summer ambient — for a 180 °C boiler, 39.7 % against
  35.3 %.
* **The ice.**  Every joule the engine does not turn into work has to be
  rejected, and rejecting it into ice melts `Q/334 kJ·kg⁻¹` of it
  (`ice_for_print_bounds`: about 32.5 kg of ice for one plate of printer
  parts).
* **The wood.**  `woodFor` converts a shaft-energy requirement into kilograms
  of dry wood through a gasifier and the engine; `wood_for_print_bounds` says
  one plate of printer parts costs between 1.1 and 1.2 kg of wood.
* **The mirrors.**  `heliostat_aims` is the aiming law: a flat mirror whose
  normal bisects the direction the sunlight comes from and the direction of the
  target sends the beam to the target — this is what "mirrors in just the right
  configuration" means, and it is exactly one equation per mirror.
  `mirrors_suffice` counts how many such mirrors the print needs: nine.

All the physical constants are declared as fields of `FuelSpec`, `Sun` and
`Engine`, or as named definitions, so every number below can be traced to the
assumption it came from.  Nothing here claims to model a real boiler's
transients, heat losses in the lines, or the mirrors' tracking errors.
-/

namespace LifeTrac
namespace Steampunk

open RealInnerProductSpace

/-! ## The engine -/

/-- A heat engine working between a boiler and a condenser.  The second law is
carried as a field: it is an assumption of the model, not something proved
here. -/
structure Engine where
  /-- Boiler temperature, kelvin. -/
  Th : ℝ
  /-- Condenser temperature, kelvin. -/
  Tc : ℝ
  /-- Heat taken from the boiler in one cycle, joules. -/
  Qh : ℝ
  /-- Work delivered in one cycle, joules. -/
  W : ℝ
  /-- The condenser is above absolute zero. -/
  hTc : 0 < Tc
  /-- The boiler is hotter than the condenser. -/
  hTh : Tc < Th
  /-- The engine is fired. -/
  hQh : 0 < Qh
  /-- It does not run backwards. -/
  hW : 0 ≤ W
  /-- **The second law**, as an assumption: no engine beats Carnot. -/
  carnot : W / Qh ≤ 1 - Tc / Th

/-- Thermal efficiency. -/
noncomputable def Engine.efficiency (E : Engine) : ℝ := E.W / E.Qh

/-- The Carnot ceiling of a boiler/condenser pair. -/
noncomputable def carnotLimit (Th Tc : ℝ) : ℝ := 1 - Tc / Th

theorem Engine.efficiency_le_carnot (E : Engine) :
    E.efficiency ≤ carnotLimit E.Th E.Tc := E.carnot

/-- Heat rejected into the condenser. -/
noncomputable def Engine.Qc (E : Engine) : ℝ := E.Qh - E.W

theorem Engine.energy_balance (E : Engine) : E.W + E.Qc = E.Qh := by
  simp [Engine.Qc]

/-- **A colder sink is a better engine.**  The Carnot ceiling strictly
increases as the condenser is made colder. -/
theorem carnotLimit_strictAnti {Th Tc Tc' : ℝ} (hTh : 0 < Th) (h : Tc < Tc') :
    carnotLimit Th Tc' < carnotLimit Th Tc := by
  simp only [carnotLimit]
  have hlt : Tc / Th < Tc' / Th := by gcongr
  linarith

/-- Melting point of ice, kelvin. -/
def iceTemp : ℝ := 273.15

/-- A warm summer ambient, kelvin. -/
def ambientTemp : ℝ := 293.15

/-- Saturated steam at about 10 bar, kelvin. -/
def boilerTemp : ℝ := 453.15

/-- **Why the ice.**  Condensing against ice rather than against summer air
lifts the ceiling of a 180 °C boiler from 35.3 % to 39.7 %. -/
theorem carnot_ice_gt_ambient :
    carnotLimit boilerTemp ambientTemp < carnotLimit boilerTemp iceTemp :=
  carnotLimit_strictAnti (by norm_num [boilerTemp]) (by norm_num [iceTemp, ambientTemp])

theorem carnot_ice_value :
    0.397 < carnotLimit boilerTemp iceTemp ∧ carnotLimit boilerTemp iceTemp < 0.398 := by
  constructor <;> norm_num [carnotLimit, boilerTemp, iceTemp]

theorem carnot_ambient_value :
    0.353 < carnotLimit boilerTemp ambientTemp ∧
      carnotLimit boilerTemp ambientTemp < 0.354 := by
  constructor <;> norm_num [carnotLimit, boilerTemp, ambientTemp]

/-! ## The ice -/

/-- Latent heat of fusion of water, joules per kilogram. -/
def latentFusion : ℝ := 334000

/-- Kilograms of ice melted by rejecting `Q` joules into an ice bath. -/
noncomputable def iceMelted (Q : ℝ) : ℝ := Q / latentFusion

theorem iceMelted_spec (Q : ℝ) : iceMelted Q * latentFusion = Q := by
  have h : (latentFusion : ℝ) ≠ 0 := by norm_num [latentFusion]
  rw [iceMelted, div_mul_cancel₀ Q h]

theorem iceMelted_mono {Q Q' : ℝ} (h : Q ≤ Q') : iceMelted Q ≤ iceMelted Q' := by
  have hL : (0 : ℝ) < latentFusion := by norm_num [latentFusion]
  simp only [iceMelted]
  gcongr

/-! ## The job to be powered -/

/-- Shaft power the printer asks for while it runs, watts.  A modelling
assumption: gantry, extruder drive and the boiler feed pump. -/
def printerPower : ℝ := 500

/-- The self-print job of `RequestProject/Printer/SelfPrint.lean` takes 3835
ticks, one second each. -/
def printTicks : ℝ := 3835

/-- Shaft energy for one plate of printer parts, joules. -/
noncomputable def printEnergy : ℝ := printerPower * printTicks

theorem printEnergy_value : printEnergy = 1917500 := by
  norm_num [printEnergy, printerPower, printTicks]

/-! ## The wood -/

/-- What the fuel and the machinery are assumed to do. -/
structure FuelSpec where
  /-- Lower heating value of dry wood, joules per kilogram. -/
  lhv : ℝ
  /-- Cold-gas efficiency of the gasifier. -/
  gasifier : ℝ
  /-- Shaft efficiency of the steam engine. -/
  engine : ℝ
  /-- Wood burns. -/
  hlhv : 0 < lhv
  /-- The gasifier delivers something, and not more than it is given. -/
  hgas : 0 < gasifier ∧ gasifier ≤ 1
  /-- So does the engine. -/
  heng : 0 < engine ∧ engine ≤ 1

/-- Shaft joules obtained from one kilogram of wood. -/
noncomputable def FuelSpec.shaftPerKg (f : FuelSpec) : ℝ := f.lhv * f.gasifier * f.engine

theorem FuelSpec.shaftPerKg_pos (f : FuelSpec) : 0 < f.shaftPerKg :=
  mul_pos (mul_pos f.hlhv f.hgas.1) f.heng.1

/-- Kilograms of wood for a shaft-energy requirement. -/
noncomputable def FuelSpec.woodFor (f : FuelSpec) (E : ℝ) : ℝ := E / f.shaftPerKg

theorem FuelSpec.woodFor_spec (f : FuelSpec) (E : ℝ) : f.woodFor E * f.shaftPerKg = E := by
  rw [FuelSpec.woodFor, div_mul_cancel₀ E f.shaftPerKg_pos.ne']

/-- Heat that must be rejected to get `E` joules of work out of the engine. -/
noncomputable def FuelSpec.rejectedFor (f : FuelSpec) (E : ℝ) : ℝ := E / f.engine - E

theorem FuelSpec.rejectedFor_nonneg (f : FuelSpec) {E : ℝ} (hE : 0 ≤ E) :
    0 ≤ f.rejectedFor E := by
  have h1 : 0 < f.engine := f.heng.1
  have h2 : f.engine ≤ 1 := f.heng.2
  have : E ≤ E / f.engine := by
    rw [le_div_iff₀ h1]
    nlinarith
  simpa [FuelSpec.rejectedFor] using this

/-- A village gasifier and a village steam engine: dry hardwood at 15 MJ/kg, a
gasifier at 75 %, an engine at 15 % — comfortably under the Carnot ceiling
of `carnot_ice_value`. -/
noncomputable def villageFuel : FuelSpec where
  lhv := 15000000
  gasifier := 0.75
  engine := 0.15
  hlhv := by norm_num
  hgas := by norm_num
  heng := by norm_num

theorem villageFuel_under_carnot : villageFuel.engine < carnotLimit boilerTemp iceTemp := by
  have := carnot_ice_value.1
  norm_num [villageFuel] at *
  linarith

/-- **The wood bill of one plate.**  Between 1.1 and 1.2 kg of dry wood prints
the printer's own plastic parts. -/
theorem wood_for_print_bounds :
    1.1 < villageFuel.woodFor printEnergy ∧ villageFuel.woodFor printEnergy < 1.2 := by
  constructor <;>
    norm_num [FuelSpec.woodFor, FuelSpec.shaftPerKg, villageFuel, printEnergy,
      printerPower, printTicks]

/-- **The ice bill of one plate.**  Rejecting the waste heat of that same job
into an ice bath melts between 32 and 33 kg of ice. -/
theorem ice_for_print_bounds :
    32 < iceMelted (villageFuel.rejectedFor printEnergy) ∧
      iceMelted (villageFuel.rejectedFor printEnergy) < 33 := by
  constructor <;>
    norm_num [iceMelted, latentFusion, FuelSpec.rejectedFor, villageFuel, printEnergy,
      printerPower, printTicks]

/-! ## The mirrors

A heliostat is a flat mirror on a pivot.  Its job is to take the sunlight
coming in along a fixed direction and put it on a fixed target: the boiler.
The whole of the "just the right configuration" is the single equation below,
one per mirror. -/

/-- Reflection of a propagation direction `d` in a mirror with unit normal
`n`. -/
noncomputable def reflectDir {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (n d : E) : E := d - (2 * ⟪d, n⟫) • n

/-- **The aiming law.**  If the sunlight arrives along the unit vector `s` and
the boiler lies along the unit vector `v` from the mirror, then the mirror
whose normal is the normalised bisector `(v - s)/‖v - s‖` reflects the beam
exactly onto the boiler. -/
theorem heliostat_aims {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (s v : E) (hs : ‖s‖ = 1) (hv : ‖v‖ = 1) (hne : v ≠ s) :
    reflectDir (‖v - s‖⁻¹ • (v - s)) s = v := by
  have hsub : v - s ≠ 0 := sub_ne_zero.mpr hne
  have hnorm : 0 < ‖v - s‖ := norm_pos_iff.mpr hsub
  have hsq : ‖v - s‖ ^ 2 = 2 - 2 * ⟪s, v⟫ := by
    rw [@norm_sub_sq_real]
    rw [hs, hv, real_inner_comm]
    ring
  have hip : ⟪s, v - s⟫ = ⟪s, v⟫ - 1 := by
    rw [inner_sub_right, real_inner_self_eq_norm_sq, hs]
    ring
  have hne' : ‖v - s‖ ^ 2 ≠ 0 := by positivity
  simp only [reflectDir, real_inner_smul_right, smul_smul]
  rw [hip]
  have hcoef : 2 * (‖v - s‖⁻¹ * (⟪s, v⟫ - 1)) * ‖v - s‖⁻¹ = -1 := by
    have h2 : (⟪s, v⟫ - 1) = -(‖v - s‖ ^ 2) / 2 := by
      rw [hsq]; ring
    rw [h2]
    field_simp
  rw [hcoef]
  simp

/-- What the sun and the mirrors are assumed to deliver. -/
structure Sun where
  /-- Direct normal irradiance, watts per square metre. -/
  flux : ℝ
  /-- Area of one mirror, square metres. -/
  area : ℝ
  /-- Reflectivity of a silvered or polished mirror. -/
  refl : ℝ
  /-- Efficiency of the receiver and engine together. -/
  engine : ℝ
  /-- The sun is up. -/
  hflux : 0 < flux
  /-- The mirror has area. -/
  harea : 0 < area
  /-- It reflects something. -/
  hrefl : 0 < refl ∧ refl ≤ 1
  /-- The engine delivers something. -/
  heng : 0 < engine ∧ engine ≤ 1

/-- Shaft watts from `k` mirrors. -/
noncomputable def Sun.shaftPower (S : Sun) (k : ℕ) : ℝ :=
  k * S.area * S.flux * S.refl * S.engine

theorem Sun.shaftPower_mono (S : Sun) {j k : ℕ} (h : j ≤ k) :
    S.shaftPower j ≤ S.shaftPower k := by
  have hk : (j : ℝ) ≤ (k : ℝ) := by exact_mod_cast h
  have h1 : 0 < S.area := S.harea
  have h2 : 0 < S.flux := S.hflux
  have h3 : 0 < S.refl := S.hrefl.1
  have h4 : 0 < S.engine := S.heng.1
  have hprod : 0 ≤ S.area * S.flux * S.refl * S.engine := by positivity
  simp only [Sun.shaftPower]
  calc (j : ℝ) * S.area * S.flux * S.refl * S.engine
      = (j : ℝ) * (S.area * S.flux * S.refl * S.engine) := by ring
    _ ≤ (k : ℝ) * (S.area * S.flux * S.refl * S.engine) :=
        mul_le_mul_of_nonneg_right hk hprod
    _ = (k : ℝ) * S.area * S.flux * S.refl * S.engine := by ring

/-- A clear day, half-square-metre mirrors of polished steel, the same 15 %
engine. -/
noncomputable def villageSun : Sun where
  flux := 900
  area := 0.5
  refl := 0.85
  engine := 0.15
  hflux := by norm_num
  harea := by norm_num
  hrefl := by norm_num
  heng := by norm_num

/-- **Nine mirrors run the printer, eight do not.**  At 900 W/m² a half square
metre of 85 % mirror behind a 15 % engine is 57.4 shaft watts, so the 500 W the
machine asks for needs nine mirrors — and eight fall short. -/
theorem mirrors_suffice :
    villageSun.shaftPower 8 < printerPower ∧ printerPower ≤ villageSun.shaftPower 9 := by
  constructor <;> norm_num [Sun.shaftPower, villageSun, printerPower]

end Steampunk
end LifeTrac
