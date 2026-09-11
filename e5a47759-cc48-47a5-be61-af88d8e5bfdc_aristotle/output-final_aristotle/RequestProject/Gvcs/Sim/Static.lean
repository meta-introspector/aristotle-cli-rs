import Mathlib

/-!
# Static circuits: series–parallel networks solved at steady state

A *static* circuit is one in which nothing changes with time: a network of
linear resistive elements driven by a constant potential difference.  The same
theory serves the two circuits of the machine, because the two obey the same
law:

* electrically, a wire of resistivity `ρ`, length `L` and cross-section `A`
  obeys Ohm's law `Δv = R i` with `R = ρ L / A`;
* hydraulically, a hose of radius `a` and length `L` carrying a laminar flow
  obeys Hagen–Poiseuille `Δp = R Q` with `R = 8 μ L / (π a⁴)`.

So both are captured by one datatype, `Net`, of two-terminal networks built
from resistive leaves by putting them in series and in parallel, and one
solution: the drop applied across the network divides between series parts in
proportion to their resistances and is shared by parallel parts.

What is proved here:

* `Net.resistance_pos` — a network of positive resistances has a positive
  resistance;
* `Net.conductance_par` — conductances add in parallel, and
  `Net.resistance_par_lt_left/right`: a parallel branch is always easier than
  either of its parts, while `Net.resistance_le_series_left/right` says a
  series part is always harder;
* Kirchhoff's laws for the solution: `Net.series_current_eq` (one current
  through a series chain, and the drops add: `Net.series_drop_add`) and
  `Net.par_current_add` (currents add at a parallel junction, both parts seeing
  the same drop);
* `Net.dissipation_eq` — the power dissipated in the leaves, added up, is
  exactly the `v²/R` delivered at the terminals: Tellegen's theorem for this
  class of networks, proved by induction on the network;
* `Source.current`, `Source.loadPower` and `Source.loadPower_le`, the maximum
  power transfer theorem: a source of internal resistance `r` never delivers
  more than `E²/(4r)`, and delivers exactly that when the load matches.

Nothing here is specific to electricity or to oil; `wireResistance` and
`hoseResistance` at the end are the two leaves the later files use.
-/

namespace LifeTrac
namespace Static

noncomputable section

open Real

/-! ## Networks -/

/-- A two-terminal network of resistive elements. -/
inductive Net where
  /-- A single resistive element of resistance `r`. -/
  | leaf (r : ℝ) : Net
  /-- Two networks end to end. -/
  | series (a b : Net) : Net
  /-- Two networks side by side. -/
  | par (a b : Net) : Net

namespace Net

/-- Resistance of a network: series add, parallel combine reciprocally. -/
def resistance : Net → ℝ
  | leaf r => r
  | series a b => a.resistance + b.resistance
  | par a b => a.resistance * b.resistance / (a.resistance + b.resistance)

/-- A network is *sound* when every element in it has a positive resistance. -/
inductive Ok : Net → Prop
  /-- A leaf is sound when its resistance is positive. -/
  | leaf {r : ℝ} (h : 0 < r) : Ok (leaf r)
  /-- A series pair is sound when both parts are. -/
  | series {a b : Net} : Ok a → Ok b → Ok (series a b)
  /-- A parallel pair is sound when both parts are. -/
  | par {a b : Net} : Ok a → Ok b → Ok (par a b)

/-- A sound network has a positive resistance. -/
theorem resistance_pos : ∀ {n : Net}, n.Ok → 0 < n.resistance := by
  intro n hn
  induction hn with
  | leaf h => exact h
  | series _ _ iha ihb => exact add_pos iha ihb
  | par _ _ iha ihb => exact div_pos (mul_pos iha ihb) (add_pos iha ihb)

theorem resistance_ne_zero {n : Net} (hn : n.Ok) : n.resistance ≠ 0 :=
  ne_of_gt (resistance_pos hn)

/-- Conductance: the reciprocal of resistance. -/
def conductance (n : Net) : ℝ := 1 / n.resistance

/-- Conductances add in parallel. -/
theorem conductance_par {a b : Net} (ha : a.Ok) (hb : b.Ok) :
    (par a b).conductance = a.conductance + b.conductance := by
  have ha' := resistance_pos ha
  have hb' := resistance_pos hb
  have h1 : a.resistance ≠ 0 := ne_of_gt ha'
  have h2 : b.resistance ≠ 0 := ne_of_gt hb'
  simp only [conductance, resistance, one_div_div]
  field_simp
  ring

/-- A parallel combination is easier than its left part. -/
theorem resistance_par_lt_left {a b : Net} (ha : a.Ok) (hb : b.Ok) :
    (par a b).resistance < a.resistance := by
  have ha' := resistance_pos ha
  have hb' := resistance_pos hb
  rw [resistance, div_lt_iff₀ (by linarith)]
  nlinarith

/-- A parallel combination is easier than its right part. -/
theorem resistance_par_lt_right {a b : Net} (ha : a.Ok) (hb : b.Ok) :
    (par a b).resistance < b.resistance := by
  have ha' := resistance_pos ha
  have hb' := resistance_pos hb
  rw [resistance, div_lt_iff₀ (by linarith)]
  nlinarith

/-- A series combination is harder than its left part. -/
theorem resistance_le_series_left {a b : Net} (hb : b.Ok) :
    a.resistance ≤ (series a b).resistance := by
  have := resistance_pos hb
  simp only [resistance]; linarith

/-- A series combination is harder than its right part. -/
theorem resistance_le_series_right {a b : Net} (ha : a.Ok) :
    b.resistance ≤ (series a b).resistance := by
  have := resistance_pos ha
  simp only [resistance]; linarith

/-! ## The static solution -/

/-- The current a drop `v` drives through the network. -/
def current (n : Net) (v : ℝ) : ℝ := v / n.resistance

/-- The share of the applied drop that falls across the left part of a series
pair. -/
def seriesSplitL (a b : Net) (v : ℝ) : ℝ := v * a.resistance / (a.resistance + b.resistance)

/-- The share of the applied drop that falls across the right part of a series
pair. -/
def seriesSplitR (a b : Net) (v : ℝ) : ℝ := v * b.resistance / (a.resistance + b.resistance)

/-- Kirchhoff's voltage law for a series pair: the two shares add up to the
applied drop. -/
theorem series_drop_add {a b : Net} (ha : a.Ok) (hb : b.Ok) (v : ℝ) :
    seriesSplitL a b v + seriesSplitR a b v = v := by
  have ha' := resistance_pos ha
  have hb' := resistance_pos hb
  have hab : a.resistance + b.resistance ≠ 0 := by positivity
  simp only [seriesSplitL, seriesSplitR, ← add_div]
  rw [div_eq_iff hab]
  ring

/-- Kirchhoff's current law for a series pair: the same current flows in both
parts, and it is the current of the pair. -/
theorem series_current_eq {a b : Net} (ha : a.Ok) (hb : b.Ok) (v : ℝ) :
    a.current (seriesSplitL a b v) = (series a b).current v ∧
      b.current (seriesSplitR a b v) = (series a b).current v := by
  have ha' := resistance_pos ha
  have hb' := resistance_pos hb
  have hab : a.resistance + b.resistance ≠ 0 := by positivity
  constructor <;>
    · simp only [current, seriesSplitL, seriesSplitR, resistance]
      field_simp

/-- Kirchhoff's current law for a parallel pair: both parts see the whole drop,
and their currents add to the current of the pair. -/
theorem par_current_add {a b : Net} (ha : a.Ok) (hb : b.Ok) (v : ℝ) :
    a.current v + b.current v = (par a b).current v := by
  have ha' := resistance_pos ha
  have hb' := resistance_pos hb
  have hab : a.resistance + b.resistance ≠ 0 := by positivity
  simp only [current, resistance]
  field_simp
  ring

/-- The power dissipated in the individual elements, added up over the whole
network, under the static solution driven by the drop `v`. -/
def dissipation : Net → ℝ → ℝ
  | leaf r, v => v ^ 2 / r
  | series a b, v => a.dissipation (seriesSplitL a b v) + b.dissipation (seriesSplitR a b v)
  | par a b, v => a.dissipation v + b.dissipation v

/-- **Tellegen for series–parallel networks.**  The heat made in the elements
is exactly the power `v²/R` that goes in at the terminals. -/
theorem dissipation_eq : ∀ {n : Net}, n.Ok → ∀ v : ℝ, n.dissipation v = v ^ 2 / n.resistance := by
  intro n hn
  induction hn with
  | leaf h => intro v; rfl
  | @series a b ha hb iha ihb =>
      intro v
      have ha' := resistance_pos ha
      have hb' := resistance_pos hb
      have hab : a.resistance + b.resistance ≠ 0 := by positivity
      simp only [dissipation, iha, ihb, seriesSplitL, seriesSplitR, resistance]
      field_simp
  | @par a b ha hb iha ihb =>
      intro v
      have ha' := resistance_pos ha
      have hb' := resistance_pos hb
      have hab : a.resistance + b.resistance ≠ 0 := by positivity
      simp only [dissipation, iha, ihb, resistance]
      field_simp
      ring

/-- The power taken at the terminals is drop times current. -/
theorem dissipation_eq_mul_current {n : Net} (hn : n.Ok) (v : ℝ) :
    n.dissipation v = v * n.current v := by
  rw [dissipation_eq hn, current]; ring

/-- A static network can only absorb power. -/
theorem dissipation_nonneg {n : Net} (hn : n.Ok) (v : ℝ) : 0 ≤ n.dissipation v := by
  rw [dissipation_eq hn]
  exact div_nonneg (sq_nonneg v) (resistance_pos hn).le

/-- The current is monotone in the applied drop… -/
theorem current_mono {n : Net} (hn : n.Ok) {v w : ℝ} (h : v ≤ w) : n.current v ≤ n.current w := by
  unfold current
  gcongr
  exact (resistance_pos hn).le

/-- …and, at a fixed drop, decreasing in the resistance. -/
theorem current_antitone_resistance {m n : Net} (hm : m.Ok) {v : ℝ} (hv : 0 ≤ v)
    (h : m.resistance ≤ n.resistance) : n.current v ≤ m.current v :=
  div_le_div_of_nonneg_left hv (resistance_pos hm) h

end Net

/-! ## A source driving a static load -/

/-- A constant source: an ideal drop `emf` behind an internal resistance
`intern` (a battery, or a pump held at constant pressure behind its own
plumbing). -/
structure Source where
  /-- The open-circuit drop the source makes. -/
  emf : ℝ
  /-- Internal resistance of the source. -/
  intern : ℝ
  emf_nonneg : 0 ≤ emf
  intern_pos : 0 < intern

namespace Source

variable (s : Source)

/-- Current delivered into a load of resistance `R`. -/
def current (R : ℝ) : ℝ := s.emf / (s.intern + R)

/-- Drop at the terminals when a load of resistance `R` is connected: the emf
less the internal drop. -/
def terminal (R : ℝ) : ℝ := s.emf - s.intern * s.current R

/-- The terminal drop is what the load sees. -/
theorem terminal_eq (R : ℝ) (hR : 0 ≤ R) : s.terminal R = R * s.current R := by
  have h : s.intern + R ≠ 0 := by have := s.intern_pos; positivity
  simp only [terminal, current]
  field_simp
  ring

/-- The heavier the load (the smaller its resistance), the more the terminal
drop sags. -/
theorem terminal_mono {R R' : ℝ} (hR : 0 ≤ R) (hRR : R ≤ R') : s.terminal R ≤ s.terminal R' := by
  have h : 0 < s.intern + R := by have := s.intern_pos; linarith
  simp only [terminal, current]
  rw [sub_le_sub_iff_left]
  apply mul_le_mul_of_nonneg_left _ s.intern_pos.le
  exact div_le_div_of_nonneg_left s.emf_nonneg h (by linarith)

/-- Power delivered to the load. -/
def loadPower (R : ℝ) : ℝ := R * s.current R ^ 2

/-- Power lost inside the source. -/
def internalLoss (R : ℝ) : ℝ := s.intern * s.current R ^ 2

/-- The source's own output splits into the load's power and its internal
loss. -/
theorem power_balance (R : ℝ) (hR : 0 ≤ R) :
    s.emf * s.current R = s.loadPower R + s.internalLoss R := by
  have h : 0 < s.intern + R := by have := s.intern_pos; linarith
  have h' : s.intern + R ≠ 0 := ne_of_gt h
  simp only [loadPower, internalLoss, current]
  field_simp
  ring

/-- **Maximum power transfer.**  No load can take more than `E²/(4r)`. -/
theorem loadPower_le (R : ℝ) (hR : 0 ≤ R) : s.loadPower R ≤ s.emf ^ 2 / (4 * s.intern) := by
  have hr := s.intern_pos
  have h : 0 < s.intern + R := by linarith
  have key : R * (s.emf ^ 2 / (s.intern + R) ^ 2) = R * s.emf ^ 2 / (s.intern + R) ^ 2 := by ring
  rw [loadPower, current, div_pow, key, div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith [sq_nonneg (s.intern - R), sq_nonneg s.emf,
    mul_nonneg (sq_nonneg s.emf) (sq_nonneg (s.intern - R))]

/-- …and a matched load takes exactly that. -/
theorem loadPower_matched : s.loadPower s.intern = s.emf ^ 2 / (4 * s.intern) := by
  have hr := s.intern_pos
  have h : s.intern ≠ 0 := ne_of_gt hr
  simp only [loadPower, current]
  field_simp
  ring

end Source

/-! ## The two physical leaves -/

/-- Resistance of a conductor of resistivity `rho`, length `len` and
cross-sectional area `area`. -/
def wireResistance (rho len area : ℝ) : ℝ := rho * len / area

theorem wireResistance_pos {rho len area : ℝ} (hr : 0 < rho) (hl : 0 < len) (ha : 0 < area) :
    0 < wireResistance rho len area := by
  unfold wireResistance; positivity

/-- Thicker wire, less resistance. -/
theorem wireResistance_antitone_area {rho len a a' : ℝ} (hr : 0 ≤ rho) (hl : 0 ≤ len)
    (ha : 0 < a) (h : a ≤ a') : wireResistance rho len a' ≤ wireResistance rho len a :=
  div_le_div_of_nonneg_left (by positivity) ha h

/-- Hydraulic resistance of a hose of radius `a` and length `len` carrying a
laminar flow of a fluid of viscosity `mu`: the Hagen–Poiseuille coefficient
`8 μ L / (π a⁴)`. -/
def hoseResistance (mu len a : ℝ) : ℝ := 8 * mu * len / (π * a ^ 4)

theorem hoseResistance_pos {mu len a : ℝ} (hm : 0 < mu) (hl : 0 < len) (ha : 0 < a) :
    0 < hoseResistance mu len a := by
  unfold hoseResistance
  have : 0 < π := pi_pos
  positivity

/-- Two hoses of the same bore in series behave as one hose of the summed
length — the series law of `Net`, in hydraulic dress. -/
theorem hoseResistance_series (mu a l₁ l₂ : ℝ) :
    (Net.series (Net.leaf (hoseResistance mu l₁ a)) (Net.leaf (hoseResistance mu l₂ a))).resistance
      = hoseResistance mu (l₁ + l₂) a := by
  simp only [Net.resistance, hoseResistance]
  ring

end

end Static
end LifeTrac
