import RequestProject.Gvcs.Sim.Static

/-!
# The electric circuit of the machine

A LifeTrac is a hydraulic machine, but nothing on it moves until the electrics
work: a battery cranks the engine, an alternator puts the charge back, and — in
the version this project models, the one that can be driven by a computer — the
directional valves are shifted by solenoid coils instead of by hand levers.
That is the circuit this file describes, on top of the static network theory of
`Sim/Static.lean`.

* `Battery` — an emf behind an internal resistance, with a charge capacity.
  `Battery.terminal_eq_of_current` gives the sagging terminal voltage under
  load, `Battery.cranking_terminal` the voltage while the starter pulls, and
  `Battery.runTime` how long the battery lasts, decreasing in the draw
  (`Battery.runTime_antitone`).
* `Alternator` — `chargeAfter` is the charge in the battery after running for a
  time with the alternator supplying and the loads drawing;
  `charge_increasing_iff` says the battery gains exactly when the alternator
  out-supplies the loads, and `timeToFull` says when it is full again.
* `Cable` — a run of wire, there and back: `Cable.drop`, and the sizing
  theorem `Cable.drop_le_iff_area`, which turns a voltage-drop budget into a
  minimum conductor area.
* `Fuse` — `Fuse.blows`; a fuse rated above the steady draw does not blow
  (`Fuse.not_blows_of_le`) but a dead short always does
  (`Fuse.short_blows`).
* `Coil` — a solenoid valve coil: holding current `V/R` and power `V²/R`, and
  the coil group of a machine with `n` valves.
* `LifeTracElectrics` — the concrete 12 V system, with numbers: what it draws,
  that a 30 A main fuse carries it, that the battery holds the starter above
  the voltage it needs to crank, that the alternator charges, and how long the
  machine can run its electrics with the engine stopped.

SI units throughout: volts, amperes, ohms, coulombs, seconds — except that
battery capacity is quoted in ampere-hours, as batteries are, and converted
where needed.
-/

namespace LifeTrac
namespace Electric

open Static

noncomputable section

/-! ## Battery -/

/-- A lead-acid battery: an emf behind an internal resistance, holding
`capacityAh` ampere-hours of charge. -/
structure Battery where
  /-- Open-circuit voltage. -/
  emf : ℝ
  /-- Internal resistance. -/
  intern : ℝ
  /-- Capacity, in ampere-hours. -/
  capacityAh : ℝ
  emf_pos : 0 < emf
  intern_pos : 0 < intern
  capacity_pos : 0 < capacityAh

namespace Battery

variable (b : Battery)

/-- The battery, seen as a source of the static theory. -/
def source : Source where
  emf := b.emf
  intern := b.intern
  emf_nonneg := b.emf_pos.le
  intern_pos := b.intern_pos

/-- Terminal voltage when the battery is delivering the current `i`. -/
def terminalAt (i : ℝ) : ℝ := b.emf - b.intern * i

/-- The terminal voltage of the static solution is the terminal voltage at the
current that flows. -/
theorem terminal_eq_of_current (R : ℝ) :
    b.source.terminal R = b.terminalAt (b.source.current R) := rfl

/-- The harder the battery is worked, the lower its terminal voltage. -/
theorem terminalAt_antitone {i j : ℝ} (h : i ≤ j) : b.terminalAt j ≤ b.terminalAt i := by
  simp only [terminalAt]
  have := b.intern_pos
  nlinarith

/-- Voltage at the terminals while the starter draws `i`. -/
theorem cranking_terminal (i : ℝ) : b.terminalAt i = b.emf - b.intern * i := rfl

/-- Charge held, in coulombs. -/
def charge : ℝ := b.capacityAh * 3600

/-- How long, in seconds, the battery can supply a steady current `i`. -/
def runTime (i : ℝ) : ℝ := b.charge / i

theorem runTime_pos {i : ℝ} (hi : 0 < i) : 0 < b.runTime i :=
  div_pos (by have := b.capacity_pos; unfold charge; positivity) hi

/-- A heavier draw is a shorter run. -/
theorem runTime_antitone {i j : ℝ} (hi : 0 < i) (h : i ≤ j) : b.runTime j ≤ b.runTime i := by
  have hc : 0 ≤ b.charge := by have := b.capacity_pos; unfold charge; positivity
  exact div_le_div_of_nonneg_left hc hi h

/-- The energy a full battery holds, at its open-circuit voltage. -/
def energy : ℝ := b.charge * b.emf

theorem energy_pos : 0 < b.energy := by
  have := b.capacity_pos
  have := b.emf_pos
  unfold energy charge
  positivity

end Battery

/-! ## Alternator and the charge balance -/

/-- The charging system: the alternator supplies `output` amperes once the
engine runs. -/
structure Alternator where
  /-- Charging current the alternator can supply. -/
  output : ℝ
  output_nonneg : 0 ≤ output

/-- Net current into the battery when the loads draw `load`. -/
def netCharge (a : Alternator) (load : ℝ) : ℝ := a.output - load

/-- Charge in the battery after running for `t` seconds from charge `q₀`. -/
def chargeAfter (a : Alternator) (load q₀ t : ℝ) : ℝ := q₀ + netCharge a load * t

/-- The battery gains charge exactly when the alternator out-supplies the
loads. -/
theorem charge_increasing_iff (a : Alternator) (load q₀ : ℝ) {t : ℝ} (ht : 0 < t) :
    q₀ < chargeAfter a load q₀ t ↔ load < a.output := by
  simp only [chargeAfter, netCharge, lt_add_iff_pos_right]
  constructor
  · intro h
    by_contra hc
    push_neg at hc
    nlinarith
  · intro h
    have : 0 < a.output - load := by linarith
    positivity

/-- A discharged battery is full again after `deficit / net` seconds of
charging. -/
theorem timeToFull (a : Alternator) (load q₀ qfull : ℝ) (h : load < a.output) :
    chargeAfter a load q₀ ((qfull - q₀) / (a.output - load)) = qfull := by
  have hne : a.output - load ≠ 0 := by linarith
  simp only [chargeAfter, netCharge]
  field_simp
  ring

/-! ## Cables -/

/-- A cable run: `length` metres out (and the same back), of conductor area
`area` and resistivity `rho`. -/
structure Cable where
  /-- One-way length of the run. -/
  length : ℝ
  /-- Cross-sectional area of the conductor. -/
  area : ℝ
  /-- Resistivity of the conductor material. -/
  rho : ℝ
  length_pos : 0 < length
  area_pos : 0 < area
  rho_pos : 0 < rho

namespace Cable

variable (c : Cable)

/-- Resistance of the loop: out and back. -/
def resistance : ℝ := wireResistance c.rho (2 * c.length) c.area

theorem resistance_pos : 0 < c.resistance :=
  wireResistance_pos c.rho_pos (by have := c.length_pos; linarith) c.area_pos

/-- Voltage lost in the cable at current `i`. -/
def drop (i : ℝ) : ℝ := c.resistance * i

/-- Heat made in the cable at current `i`. -/
def loss (i : ℝ) : ℝ := c.resistance * i ^ 2

theorem loss_nonneg (i : ℝ) : 0 ≤ c.loss i := by
  have := c.resistance_pos
  unfold loss
  positivity

/-- **Cable sizing.**  At a current `i`, the drop is inside a budget exactly
when the conductor is at least a certain area. -/
theorem drop_le_iff_area {i limit : ℝ} (hlimit : 0 < limit) :
    c.drop i ≤ limit ↔ c.rho * (2 * c.length) * i / limit ≤ c.area := by
  have hA := c.area_pos
  rw [drop, resistance, wireResistance, div_mul_eq_mul_div, div_le_iff₀ hA,
    div_le_iff₀ hlimit]
  constructor <;> intro h <;> nlinarith

end Cable

/-! ## Fuses -/

/-- A fuse of a given rating. -/
structure Fuse where
  /-- Current above which the fuse opens. -/
  rating : ℝ
  rating_pos : 0 < rating

/-- The fuse opens when the current exceeds its rating. -/
def Fuse.blows (f : Fuse) (i : ℝ) : Prop := f.rating < i

theorem Fuse.not_blows_of_le (f : Fuse) {i : ℝ} (h : i ≤ f.rating) : ¬ f.blows i := by
  simp only [Fuse.blows, not_lt]; exact h

/-- A dead short across the battery blows any fuse rated below the short-circuit
current. -/
theorem Fuse.short_blows (f : Fuse) (b : Battery) (h : f.rating < b.emf / b.intern) :
    f.blows (b.source.current 0) := by
  simpa [Fuse.blows, Source.current, Battery.source] using h

/-! ## Solenoid coils -/

/-- A solenoid coil driving a directional valve: resistance `res`, inductance
`ind`. -/
structure Coil where
  /-- Coil resistance. -/
  res : ℝ
  /-- Coil inductance. -/
  ind : ℝ
  res_pos : 0 < res
  ind_pos : 0 < ind

namespace Coil

variable (k : Coil)

/-- Steady (holding) current when the coil is energised at `v` volts. -/
def holdCurrent (v : ℝ) : ℝ := v / k.res

/-- Power the coil turns into heat while it holds. -/
def holdPower (v : ℝ) : ℝ := v ^ 2 / k.res

theorem holdPower_eq (v : ℝ) : k.holdPower v = v * k.holdCurrent v := by
  simp only [holdPower, holdCurrent]; ring

/-- The electrical time constant of the coil. -/
def tau : ℝ := k.ind / k.res

theorem tau_pos : 0 < k.tau := div_pos k.ind_pos k.res_pos

/-- `n` identical coils energised together draw `n` times the current. -/
theorem holdCurrent_group (v : ℝ) (n : ℕ) :
    (n : ℝ) * k.holdCurrent v = n * v / k.res := by
  simp only [holdCurrent]; ring

/-- Two coils across the same supply form a parallel pair of the static
theory. -/
theorem par_of_two (k' : Coil) (v : ℝ) :
    (Net.par (Net.leaf k.res) (Net.leaf k'.res)).current v = k.holdCurrent v + k'.holdCurrent v :=
  (Net.par_current_add (Net.Ok.leaf k.res_pos) (Net.Ok.leaf k'.res_pos) v).symm

end Coil

/-! ## The machine's 12 V system, with numbers -/

/-- The 12 V system of the modelled machine: a 55 Ah battery, a 40 A
alternator, four valve coils, lights and a controller, behind a 30 A main
fuse. -/
structure LifeTracElectrics where
  /-- The battery. -/
  battery : Battery
  /-- The alternator. -/
  alternator : Alternator
  /-- One valve coil (all four are alike). -/
  coil : Coil
  /-- Number of valve coils. -/
  coils : ℕ
  /-- Current the lamps draw. -/
  lights : ℝ
  /-- Current the controller draws. -/
  controller : ℝ
  /-- Current the starter draws while cranking. -/
  starter : ℝ
  /-- The main fuse. -/
  fuse : Fuse
  lights_nonneg : 0 ≤ lights
  controller_nonneg : 0 ≤ controller
  starter_nonneg : 0 ≤ starter

namespace LifeTracElectrics

variable (e : LifeTracElectrics)

/-- Current drawn with `n` of the valve coils energised, at the nominal system
voltage `v`. -/
def draw (v : ℝ) (n : ℕ) : ℝ := (n : ℝ) * e.coil.holdCurrent v + e.lights + e.controller

/-- Worst-case steady draw: every coil energised. -/
def peakDraw (v : ℝ) : ℝ := e.draw v e.coils

/-- The draw grows with the number of coils held. -/
theorem draw_mono {v : ℝ} (hv : 0 ≤ v) {m n : ℕ} (h : m ≤ n) : e.draw v m ≤ e.draw v n := by
  have hc := e.coil.res_pos
  have : (m : ℝ) ≤ n := by exact_mod_cast h
  simp only [draw, Coil.holdCurrent]
  have : (m : ℝ) * (v / e.coil.res) ≤ (n : ℝ) * (v / e.coil.res) := by
    apply mul_le_mul_of_nonneg_right this
    positivity
  linarith

/-- No steady draw is worse than the peak. -/
theorem draw_le_peak {v : ℝ} (hv : 0 ≤ v) {n : ℕ} (h : n ≤ e.coils) :
    e.draw v n ≤ e.peakDraw v := e.draw_mono hv h

end LifeTracElectrics

/-! ### The concrete system -/

/-- A 12.6 V, 55 Ah battery of 20 mΩ internal resistance. -/
def battery12 : Battery where
  emf := 12.6
  intern := 0.02
  capacityAh := 55
  emf_pos := by norm_num
  intern_pos := by norm_num
  capacity_pos := by norm_num

/-- A 40 A alternator. -/
def alternator40 : Alternator where
  output := 40
  output_nonneg := by norm_num

/-- A 12 V valve coil: 8 Ω, 40 mH — 1.5 A, 18 W. -/
def valveCoil : Coil where
  res := 8
  ind := 0.04
  res_pos := by norm_num
  ind_pos := by norm_num

/-- A 30 A main fuse. -/
def mainFuse : Fuse where
  rating := 30
  rating_pos := by norm_num

/-- The machine's electrical system. -/
def lifeTracElectrics : LifeTracElectrics where
  battery := battery12
  alternator := alternator40
  coil := valveCoil
  coils := 4
  lights := 8
  controller := 2
  starter := 150
  fuse := mainFuse
  lights_nonneg := by norm_num
  controller_nonneg := by norm_num
  starter_nonneg := by norm_num

/-- Holding all four valves, with lights and controller on, the machine draws
16 A at 12 V. -/
theorem peakDraw_value : lifeTracElectrics.peakDraw 12 = 16 := by
  norm_num [LifeTracElectrics.peakDraw, LifeTracElectrics.draw, Coil.holdCurrent,
    lifeTracElectrics, valveCoil]

/-- The 30 A main fuse carries the worst steady load. -/
theorem mainFuse_holds : ¬ lifeTracElectrics.fuse.blows (lifeTracElectrics.peakDraw 12) := by
  apply Fuse.not_blows_of_le
  rw [peakDraw_value]
  norm_num [lifeTracElectrics, mainFuse]

/-- …but a short circuit across the battery blows it: the short-circuit current
is 630 A. -/
theorem mainFuse_blows_on_short :
    lifeTracElectrics.fuse.blows (lifeTracElectrics.battery.source.current 0) := by
  apply Fuse.short_blows
  norm_num [lifeTracElectrics, mainFuse, battery12]

/-- While the starter pulls its 150 A the terminals sag to 9.6 V — above the
8 V a starter motor needs, so the engine cranks. -/
theorem cranking_voltage_ok :
    lifeTracElectrics.battery.terminalAt lifeTracElectrics.starter = 9.6 ∧
      (8 : ℝ) ≤ lifeTracElectrics.battery.terminalAt lifeTracElectrics.starter := by
  constructor <;> norm_num [Battery.terminalAt, lifeTracElectrics, battery12]

/-- With the engine running, the alternator covers the whole load and still
puts 24 A back into the battery. -/
theorem alternator_charges :
    netCharge lifeTracElectrics.alternator (lifeTracElectrics.peakDraw 12) = 24 := by
  rw [peakDraw_value]
  norm_num [netCharge, lifeTracElectrics, alternator40]

/-- So the battery is charging whenever the engine runs at working load. -/
theorem charging_when_running (q₀ : ℝ) {t : ℝ} (ht : 0 < t) :
    q₀ < chargeAfter lifeTracElectrics.alternator (lifeTracElectrics.peakDraw 12) q₀ t := by
  rw [charge_increasing_iff _ _ _ ht, peakDraw_value]
  norm_num [lifeTracElectrics, alternator40]

/-- Engine stopped, the battery runs the electrics for 12 375 seconds — three
and a quarter hours. -/
theorem battery_endurance :
    lifeTracElectrics.battery.runTime (lifeTracElectrics.peakDraw 12) = 12375 := by
  rw [peakDraw_value]
  norm_num [Battery.runTime, Battery.charge, lifeTracElectrics, battery12]

/-- A 6 mm² copper cable, 3 m out and back, carrying the peak load, drops well
under half a volt. -/
def mainCable : Cable where
  length := 3
  area := 6e-6
  rho := 1.68e-8
  length_pos := by norm_num
  area_pos := by norm_num
  rho_pos := by norm_num

theorem mainCable_drop_ok : mainCable.drop (lifeTracElectrics.peakDraw 12) ≤ 0.5 := by
  rw [peakDraw_value]
  norm_num [Cable.drop, Cable.resistance, wireResistance, mainCable]

end

end Electric
end LifeTrac
