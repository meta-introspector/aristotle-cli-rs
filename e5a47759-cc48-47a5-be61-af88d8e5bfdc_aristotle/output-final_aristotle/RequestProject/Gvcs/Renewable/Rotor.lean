import RequestProject.Gvcs.Renewable.Wind

/-!
# Rotors that push instead of pull: helicopters and drones

`Renewable/Wind.lean` runs the actuator disc *backwards*: a rotor that takes
momentum out of a stream.  Run it forwards — a rotor that puts momentum *into*
still air — and the same one-dimensional theory gives the hovering helicopter
and the hovering quadcopter.

A rotor of area `A` hovering with thrust `T` in air of density `ρ` accelerates
the air through the disc by the **induced velocity** `vᵢ`.  Far below the
rotor the air moves at `2vᵢ`, so the momentum flux is `(ρ A vᵢ)(2vᵢ) = T`,
whence

```
vᵢ = √(T / 2ρA),      P_ideal = T·vᵢ = √(T³ / 2ρA).
```

That is `inducedVelocity` and `hoverPower`, and `thrust_eq_inducedVelocity` is
the momentum balance they come from.

What follows are the facts that decide how a helicopter or a drone is built.

* **Big slow rotors win.**  `hoverPower_strictAnti_area`: at fixed weight the
  hover power falls as the disc grows, like `1/√A`; `powerLoading_eq` puts it
  in the designer's form, `P/T = √(DL/2ρ)` with `DL` the disc loading.
* **What counts is total disc area, not the number of rotors.**
  `multirotorPower_eq_single`: `n` rotors of area `A` sharing the load need
  exactly the power of one rotor of area `nA`.  So
  `quadrotor_eq_helicopter` — a quadcopter whose four rotors have half the
  radius of the helicopter's single rotor hovers on precisely the same ideal
  power — while `four_full_rotors_halve_power` shows that four *full-size*
  rotors would halve it.
* **Nothing is free.**  `hoverPower_le_realPower`: with a figure of merit
  `FM ≤ 1` the real power is at least the ideal one.
* **Endurance.**  `endurance_eq`, `endurance_strictAnti_payload`: a battery
  drone's hover time falls off like `m^{-3/2}`, so `payload_costs_endurance`
  — every gram of payload is paid for twice.
* Worked numbers for a one-tonne helicopter and a two-kilogram quadcopter
  (`helicopter_hoverPower_bounds`, `quadcopter_hoverPower_bounds`,
  `quadcopter_endurance_bounds`).
-/

namespace LifeTrac
namespace Renewable

open Real

noncomputable section

/-! ## Momentum theory of a hovering rotor -/

/-- Induced velocity of a rotor of area `A` hovering with thrust `T` in a
fluid of density `ρ`. -/
def inducedVelocity (T ρ A : ℝ) : ℝ := √(T / (2 * ρ * A))

/-- Ideal power to hover: thrust times induced velocity. -/
def hoverPower (T ρ A : ℝ) : ℝ := T * inducedVelocity T ρ A

/-- Disc loading: thrust carried per square metre of rotor disc. -/
def discLoading (T A : ℝ) : ℝ := T / A

theorem inducedVelocity_nonneg (T ρ A : ℝ) : 0 ≤ inducedVelocity T ρ A :=
  sqrt_nonneg _

theorem inducedVelocity_pos {T ρ A : ℝ} (hT : 0 < T) (hρ : 0 < ρ) (hA : 0 < A) :
    0 < inducedVelocity T ρ A :=
  sqrt_pos.2 (by positivity)

/-- **The momentum balance.**  The thrust equals the mass flow through the
disc times twice the induced velocity — the far-wake speed. -/
theorem thrust_eq_inducedVelocity {T ρ A : ℝ} (hT : 0 ≤ T) (hρ : 0 < ρ) (hA : 0 < A) :
    (ρ * A * inducedVelocity T ρ A) * (2 * inducedVelocity T ρ A) = T := by
  have h : inducedVelocity T ρ A ^ 2 = T / (2 * ρ * A) := by
    unfold inducedVelocity
    exact sq_sqrt (by positivity)
  have : (ρ * A * inducedVelocity T ρ A) * (2 * inducedVelocity T ρ A)
      = 2 * ρ * A * inducedVelocity T ρ A ^ 2 := by ring
  rw [this, h]
  field_simp

/-- Hover power in closed form: `P = √(T³ / 2ρA)`. -/
theorem hoverPower_eq_sqrt {T ρ A : ℝ} (hT : 0 ≤ T) (hρ : 0 < ρ) (hA : 0 < A) :
    hoverPower T ρ A = √(T ^ 3 / (2 * ρ * A)) := by
  unfold hoverPower inducedVelocity
  rw [show T ^ 3 / (2 * ρ * A) = T ^ 2 * (T / (2 * ρ * A)) by field_simp,
    sqrt_mul (by positivity), sqrt_sq hT]

theorem hoverPower_nonneg {T ρ A : ℝ} (hT : 0 ≤ T) : 0 ≤ hoverPower T ρ A :=
  mul_nonneg hT (sqrt_nonneg _)

/-- **Power loading.**  The power spent per newton of lift is fixed by the
disc loading alone: `P/T = √(DL / 2ρ)`.  A helicopter is a machine for keeping
the disc loading low. -/
theorem powerLoading_eq {T ρ A : ℝ} (hT : 0 < T) (hρ : 0 < ρ) (hA : 0 < A) :
    hoverPower T ρ A / T = √(discLoading T A / (2 * ρ)) := by
  unfold hoverPower inducedVelocity discLoading
  have hcancel : T * √(T / (2 * ρ * A)) / T = √(T / (2 * ρ * A)) := by
    field_simp
  have harg : T / (2 * ρ * A) = T / A / (2 * ρ) := by
    rw [div_div]
    ring_nf
  rw [hcancel, harg]

/-- **Big rotors are cheap rotors.**  At fixed thrust, hover power strictly
decreases as the disc grows. -/
theorem hoverPower_strictAnti_area {T ρ A B : ℝ} (hT : 0 < T) (hρ : 0 < ρ)
    (hA : 0 < A) (hAB : A < B) : hoverPower T ρ B < hoverPower T ρ A := by
  unfold hoverPower inducedVelocity
  have hB : 0 < B := hA.trans hAB
  have : T / (2 * ρ * B) < T / (2 * ρ * A) :=
    div_lt_div_of_pos_left hT (by positivity) (by nlinarith)
  exact mul_lt_mul_of_pos_left (sqrt_lt_sqrt (by positivity) this) hT

/-- Hover power grows with the weight to be carried. -/
theorem hoverPower_strictMono_thrust {T S ρ A : ℝ} (hT : 0 < T) (hρ : 0 < ρ)
    (hA : 0 < A) (hTS : T < S) : hoverPower T ρ A < hoverPower S ρ A := by
  have h1 : inducedVelocity T ρ A < inducedVelocity S ρ A := by
    unfold inducedVelocity
    refine sqrt_lt_sqrt (by positivity) ?_
    gcongr
  have h2 : 0 < inducedVelocity T ρ A := inducedVelocity_pos hT hρ hA
  unfold hoverPower
  nlinarith

/-! ## One rotor or many -/

/-- Total power of `n` rotors of area `A` each, sharing a thrust `T`. -/
def multirotorPower (n : ℕ) (T ρ A : ℝ) : ℝ := n * hoverPower (T / n) ρ A

/-- **Only the total disc area matters.**  Spreading the load over `n` rotors
of area `A` costs exactly what one rotor of area `nA` costs. -/
theorem multirotorPower_eq_single {n : ℕ} (hn : 0 < n) {T ρ A : ℝ}
    (hρ : 0 < ρ) (hA : 0 < A) :
    multirotorPower n T ρ A = hoverPower T ρ (n * A) := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  unfold multirotorPower hoverPower inducedVelocity
  rw [show T / n / (2 * ρ * A) = (T / (2 * ρ * (n * A))) by field_simp]
  field_simp

/-- **A quadcopter is a helicopter.**  Four rotors of radius `R/2` have the
same total disc area as one rotor of radius `R`, and therefore hover on
exactly the same ideal power. -/
theorem quadrotor_eq_helicopter {T ρ R : ℝ} (hρ : 0 < ρ) (hR : 0 < R) :
    multirotorPower 4 T ρ (discArea (R / 2)) = hoverPower T ρ (discArea R) := by
  rw [multirotorPower_eq_single (by norm_num) hρ (discArea_pos (by positivity))]
  congr 1
  unfold discArea
  push_cast
  ring

/-- **...but four full-size rotors halve the power.**  Four rotors of radius
`R` need half of what one rotor of radius `R` needs, because the disc area is
four times larger and power goes as `1/√A`. -/
theorem four_full_rotors_halve_power {T ρ R : ℝ} (hT : 0 ≤ T) (hρ : 0 < ρ) (hR : 0 < R) :
    multirotorPower 4 T ρ (discArea R) = hoverPower T ρ (discArea R) / 2 := by
  have hA : (0 : ℝ) < discArea R := discArea_pos hR
  rw [multirotorPower_eq_single (by norm_num) hρ hA]
  unfold hoverPower inducedVelocity
  have h4 : ((4 : ℕ) : ℝ) * discArea R = 4 * discArea R := by push_cast; ring
  rw [h4]
  rw [show T / (2 * ρ * (4 * discArea R)) = (T / (2 * ρ * discArea R)) / 4 by
    field_simp]
  rw [sqrt_div (by positivity) 4, show √(4 : ℝ) = 2 by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num]; exact sqrt_sq (by norm_num)]
  ring

/-! ## Figure of merit -/

/-- Real hover power of a rotor whose figure of merit is `fm`: the ideal power
divided by `fm`. -/
def realHoverPower (fm T ρ A : ℝ) : ℝ := hoverPower T ρ A / fm

/-- **No rotor beats the momentum theory.**  With a figure of merit at most
one, the power actually required is at least the ideal power. -/
theorem hoverPower_le_realPower {fm T ρ A : ℝ} (hT : 0 ≤ T) (h0 : 0 < fm)
    (h1 : fm ≤ 1) : hoverPower T ρ A ≤ realHoverPower fm T ρ A := by
  unfold realHoverPower
  rw [le_div_iff₀ h0]
  nlinarith [hoverPower_nonneg (ρ := ρ) (A := A) hT]

/-! ## Endurance of a battery aircraft -/

/-- Hover endurance, in hours, of an aircraft with `E` watt-hours of usable
battery, figure of merit `fm`, weight `T` newtons and disc area `A`. -/
def endurance (E fm T ρ A : ℝ) : ℝ := E / realHoverPower fm T ρ A

theorem endurance_eq {E fm T ρ A : ℝ} (hT : 0 < T) (hρ : 0 < ρ) (hA : 0 < A) :
    endurance E fm T ρ A = E * fm / √(T ^ 3 / (2 * ρ * A)) := by
  unfold endurance realHoverPower
  rw [hoverPower_eq_sqrt hT.le hρ hA]
  field_simp

/-- **Payload is paid for twice.**  A heavier aircraft, everything else equal,
hovers for strictly less time. -/
theorem endurance_strictAnti_payload {E fm T S ρ A : ℝ} (hE : 0 < E) (hfm : 0 < fm)
    (hT : 0 < T) (hρ : 0 < ρ) (hA : 0 < A) (hTS : T < S) :
    endurance E fm S ρ A < endurance E fm T ρ A := by
  unfold endurance realHoverPower
  have h1 : hoverPower T ρ A < hoverPower S ρ A :=
    hoverPower_strictMono_thrust hT hρ hA hTS
  have h2 : 0 < hoverPower T ρ A := by
    unfold hoverPower
    exact mul_pos hT (inducedVelocity_pos hT hρ hA)
  refine div_lt_div_of_pos_left hE (by positivity) ?_
  gcongr

/-- Endurance scales as the inverse three-halves power of the weight: a drone
made twice as heavy hovers `2√2 ≈ 2.83` times less long, not twice. -/
theorem endurance_three_halves {E fm T ρ A c : ℝ} (hT : 0 < T) (hρ : 0 < ρ)
    (hA : 0 < A) (hc : 0 < c) :
    endurance E fm (c * T) ρ A = endurance E fm T ρ A / √(c ^ 3) := by
  rw [endurance_eq hT hρ hA, endurance_eq (by positivity) hρ hA]
  rw [show (c * T) ^ 3 / (2 * ρ * A) = c ^ 3 * (T ^ 3 / (2 * ρ * A)) by ring]
  rw [sqrt_mul (by positivity)]
  field_simp

/-! ## Worked machines -/

/-- A one-tonne helicopter: weight 9810 N, main rotor disc 50 m² (radius about
four metres), sea-level air.  Its ideal hover power is between 87 and 88
kilowatts; with a figure of merit of 0.7 the engine must deliver about 125 kW,
which is what such a machine actually has. -/
theorem helicopter_hoverPower_bounds :
    87000 < hoverPower 9810 airDensity 50 ∧ hoverPower 9810 airDensity 50 < 88000 := by
  rw [hoverPower_eq_sqrt (by norm_num) (by unfold airDensity; norm_num) (by norm_num)]
  unfold airDensity
  constructor
  · rw [show (87000 : ℝ) = √(87000 ^ 2) by rw [sqrt_sq]; norm_num]
    apply sqrt_lt_sqrt (by norm_num)
    norm_num
  · rw [show (88000 : ℝ) = √(88000 ^ 2) by rw [sqrt_sq]; norm_num]
    apply sqrt_lt_sqrt (by positivity)
    norm_num

/-- A two-kilogram quadcopter with 25 cm propellers (radius 0.125 m, four of
them, total disc area about 0.196 m²): thrust 19.62 N.  The ideal hover power
is about 125 W — and its disc loading, a hundred newtons per square metre, is
*half* the helicopter's, so per newton of lift the little machine is on paper
the better hoverer.  What it loses, it loses to its figure of merit and its
motors, not to the momentum theory. -/
theorem quadcopter_hoverPower_bounds :
    124 < hoverPower 19.62 airDensity 0.196 ∧ hoverPower 19.62 airDensity 0.196 < 127 := by
  rw [hoverPower_eq_sqrt (by norm_num) (by unfold airDensity; norm_num) (by norm_num)]
  unfold airDensity
  constructor
  · rw [show (124 : ℝ) = √(124 ^ 2) by rw [sqrt_sq]; norm_num]
    apply sqrt_lt_sqrt (by norm_num)
    norm_num
  · rw [show (127 : ℝ) = √(127 ^ 2) by rw [sqrt_sq]; norm_num]
    apply sqrt_lt_sqrt (by positivity)
    norm_num

/-- With 60 Wh of usable battery and a figure of merit of 0.7, that quadcopter
hovers for between 0.33 and 0.34 hours — twenty minutes, the familiar
number. -/
theorem quadcopter_endurance_bounds :
    0.33 < endurance 60 0.7 19.62 airDensity 0.196 ∧
      endurance 60 0.7 19.62 airDensity 0.196 < 0.34 := by
  obtain ⟨h1, h2⟩ := quadcopter_hoverPower_bounds
  have hP : 0 < hoverPower 19.62 airDensity 0.196 := by linarith
  have heq : endurance 60 0.7 19.62 airDensity 0.196
      = 42 / hoverPower 19.62 airDensity 0.196 := by
    unfold endurance realHoverPower
    rw [div_div_eq_mul_div]
    norm_num
  rw [heq]
  constructor
  · rw [lt_div_iff₀ hP]; linarith
  · rw [div_lt_iff₀ hP]; linarith

end

end Renewable
end LifeTrac
