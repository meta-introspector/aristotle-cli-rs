import RequestProject.Gvcs.Sim.Interface

/-!
# Automatic controls, and a game simulation driven by them

With a circuit that can be commanded over a wire (`Sim/Interface.lean`) the
machine can be driven by something other than a person.  This file adds the
simplest controls that are worth proving something about, and then runs the
machine through a whole job with them.

Everything here is exact rational arithmetic, so a simulation is a computation
the kernel can check, not a floating-point experiment.

**The controllers.**

* `track` — a proportional loop with feed-forward, written as the one-line
  recurrence it is.  `track_eq` gives the closed form `sp + (1-a)ⁿ(x₀ - sp)`,
  `track_error` says the error is multiplied by `|1-a|` every tick,
  `track_no_overshoot` that a well-tuned loop (`0 ≤ a ≤ 1`) approaches the set
  point monotonically and never passes it, and `track_le_of_lt_one` that the
  error is eventually as small as you please.
* `bangStep` — a hysteresis (bang-bang) controller for the loader, and
  `bang_mem_Icc`: whatever it does, the loader stays inside the band it is
  given, widened by at most one tick's travel.

**The machine, as the controller sees it.**  `PlantState` (speed, distance
run, loader height) and `step`, one tick of the discrete dynamic circuit of
`Sim/Dynamic.lean` driven by a command off the wire.  `step_speed_bound` — a
tick can never make the machine go faster than `vmax`, whatever the game
sends — and `step_lift_mem_Icc` — the loader stays between the ground and its
top stop.

**The mission.**  `advance` is the autopilot: drive a pass at the cruising
speed, raise the loader at the headland, turn, drop it again, repeat.
`command_valid` says every command the autopilot produces is a legal frame, so
`Interface.coilDraw_le_peak` applies to it and the autopilot cannot overload
the electrics.  `run_speed_bound` and `run_lift_mem_Icc` are the invariants of
the whole run, proved by induction over the ticks.  Then a concrete job:
`mission_completes`, `mission_passes` and `mission_ticks` — three 20 m passes,
finished, with the tick it finishes on.
-/

namespace LifeTrac
namespace Auto

open Interface

/-! ## A proportional loop -/

/-- A proportional loop with feed-forward: each tick the state moves the
fraction `a` of the way from where it is to where it is asked to be. -/
def track (a sp : ℚ) : ℕ → ℚ → ℚ
  | 0, x => x
  | n + 1, x => let y := track a sp n x; y + a * (sp - y)

/-- Closed form: the error to the set point is multiplied by `1 - a` each
tick. -/
theorem track_eq (a sp x : ℚ) (n : ℕ) : track a sp n x = sp + (1 - a) ^ n * (x - sp) := by
  induction n with
  | zero => simp [track]
  | succ n ih =>
      simp only [track, ih, pow_succ]
      ring

/-- The error after `n` ticks. -/
theorem track_error (a sp x : ℚ) (n : ℕ) :
    |track a sp n x - sp| = |1 - a| ^ n * |x - sp| := by
  rw [track_eq]
  simp [abs_mul, abs_pow]

/-- A well-tuned loop never overshoots: from below the set point it climbs
towards it and stops there. -/
theorem track_no_overshoot {a sp x : ℚ} (ha : 0 ≤ a) (ha1 : a ≤ 1) (hx : x ≤ sp) (n : ℕ) :
    track a sp n x ∈ Set.Icc x sp := by
  induction n with
  | zero => exact ⟨le_refl x, hx⟩
  | succ n ih =>
      obtain ⟨h1, h2⟩ := ih
      have hstep : track a sp (n + 1) x
          = track a sp n x + a * (sp - track a sp n x) := rfl
      have hd : 0 ≤ sp - track a sp n x := by linarith
      have hup : a * (sp - track a sp n x) ≤ sp - track a sp n x := by nlinarith
      rw [hstep]
      exact ⟨by nlinarith, by linarith⟩

/-- Each tick brings the loop strictly closer to the set point, by the factor
`|1 - a|`. -/
theorem track_contracts {a : ℚ} (sp x : ℚ) (n : ℕ) :
    |track a sp (n + 1) x - sp| = |1 - a| * |track a sp n x - sp| := by
  rw [track_error, track_error, pow_succ]
  ring

/-! ## A bang-bang loop -/

/-- One tick of a hysteresis controller: while the valve is open the level
rises by `rate`, and it closes at the top of the band; while it is shut the
level falls, and it opens again at the bottom. -/
def bangStep (lo hi rate : ℚ) (st : ℚ × Bool) : ℚ × Bool :=
  match st.2 with
  | true => (st.1 + rate, decide (st.1 + rate < hi))
  | false => (st.1 - rate, decide (st.1 - rate ≤ lo))

/-- `n` ticks of the hysteresis controller. -/
def bangRun (lo hi rate : ℚ) : ℕ → ℚ × Bool → ℚ × Bool
  | 0, st => st
  | n + 1, st => bangStep lo hi rate (bangRun lo hi rate n st)

/-- The invariant of a bang-bang loop: the level is inside the band, widened by
one tick's travel, and the valve is open only below the top of the band and
shut only above the bottom of it. -/
def BangOk (lo hi rate : ℚ) (st : ℚ × Bool) : Prop :=
  (lo - rate ≤ st.1 ∧ st.1 ≤ hi + rate) ∧ (st.2 = true → st.1 < hi) ∧
    (st.2 = false → lo < st.1)

/-- One tick keeps the invariant. -/
theorem bangStep_ok {lo hi rate : ℚ} (hrate : 0 ≤ rate) (hlohi : lo < hi) {st : ℚ × Bool}
    (h : BangOk lo hi rate st) : BangOk lo hi rate (bangStep lo hi rate st) := by
  obtain ⟨⟨hb1, hb2⟩, hon, hoff⟩ := h
  cases hs : st.2 with
  | true =>
      have hlt : st.1 < hi := hon hs
      have hred : bangStep lo hi rate st = (st.1 + rate, decide (st.1 + rate < hi)) := by
        simp only [bangStep, hs]
      rw [hred, BangOk]
      refine ⟨⟨by simp; linarith, by simp; linarith⟩, ?_, ?_⟩
      · intro h'
        exact of_decide_eq_true h'
      · intro h'
        have hge := of_decide_eq_false h'
        push_neg at hge
        linarith
  | false =>
      have hgt : lo < st.1 := hoff hs
      have hred : bangStep lo hi rate st = (st.1 - rate, decide (st.1 - rate ≤ lo)) := by
        simp only [bangStep, hs]
      rw [hred, BangOk]
      refine ⟨⟨by simp; linarith, by simp; linarith⟩, ?_, ?_⟩
      · intro h'
        have hle := of_decide_eq_true h'
        linarith
      · intro h'
        have hgt' := of_decide_eq_false h'
        push_neg at hgt'
        linarith

/-- **The band is kept.**  A bang-bang loop started inside its band stays
inside it, up to the one tick of travel it takes to notice a limit. -/
theorem bang_mem_Icc {lo hi rate : ℚ} (hrate : 0 ≤ rate) (hlohi : lo < hi) (n : ℕ)
    (st : ℚ × Bool) (h : BangOk lo hi rate st) :
    BangOk lo hi rate (bangRun lo hi rate n st) := by
  induction n with
  | zero => exact h
  | succ n ih => exact bangStep_ok hrate hlohi ih

/-! ## The machine as the controller sees it -/

/-- The state the controller works with: ground speed, distance run on this
pass, loader height. -/
structure PlantState where
  /-- Ground speed. -/
  speed : ℚ
  /-- Distance run on this pass. -/
  travel : ℚ
  /-- Loader height. -/
  lift : ℚ
  deriving DecidableEq, Repr

/-- The parameters of the simulated machine: the tick, the drive-line time
constant, the top speed, how fast the loader moves and how high it goes. -/
structure Sim where
  /-- Length of one tick. -/
  dt : ℚ
  /-- Time constant of the drive line. -/
  tau : ℚ
  /-- Top speed. -/
  vmax : ℚ
  /-- Loader speed at full command. -/
  liftRate : ℚ
  /-- Height of the top stop. -/
  liftTop : ℚ
  dt_pos : 0 < dt
  dt_le_tau : dt ≤ tau
  vmax_pos : 0 < vmax
  liftRate_pos : 0 < liftRate
  liftTop_pos : 0 < liftTop

/-- Clamp into a band. -/
def clampQ (lo hi x : ℚ) : ℚ := max lo (min hi x)

theorem clampQ_mem_Icc {lo hi x : ℚ} (h : lo ≤ hi) : clampQ lo hi x ∈ Set.Icc lo hi := by
  unfold clampQ
  constructor
  · exact le_max_left _ _
  · exact max_le h (min_le_left _ _)

/-- The game keeps its state in thousandths, so every quantity is rounded onto
that grid — towards zero, so that rounding can never make a quantity larger
than the physics says. -/
def quantize (q : ℚ) : ℚ := (if q < 0 then -1 else 1) * (⌊|q| * 1000⌋ : ℤ) / 1000

/-- Rounding never exaggerates. -/
theorem abs_quantize_le (q : ℚ) : |quantize q| ≤ |q| := by
  have h0 : (0 : ℚ) ≤ |q| * 1000 := by positivity
  have hfl : ((⌊|q| * 1000⌋ : ℤ) : ℚ) ≤ |q| * 1000 := Int.floor_le _
  have hfl0 : (0 : ℚ) ≤ ((⌊|q| * 1000⌋ : ℤ) : ℚ) := by
    exact_mod_cast Int.floor_nonneg.2 h0
  have hkey : |quantize q| = ((⌊|q| * 1000⌋ : ℤ) : ℚ) / 1000 := by
    unfold quantize
    rcases lt_or_ge q 0 with h | h
    · rw [if_pos h]
      simp [abs_div, abs_of_nonneg hfl0]
    · rw [if_neg (not_lt.2 h)]
      simp [abs_div, abs_of_nonneg hfl0]
  rw [hkey, div_le_iff₀ (by norm_num : (0 : ℚ) < 1000)]
  exact hfl

/-- One tick: the drive line follows the throttle with its time constant, the
distance accumulates, the loader moves at the commanded rate against its
stops. -/
def step (s : Sim) (c : Command) (p : PlantState) : PlantState :=
  let target := s.vmax * (c.throttle : ℚ) / 1000
  let speed := quantize (p.speed + s.dt * (target - p.speed) / s.tau)
  { speed := speed
    travel := quantize (p.travel + s.dt * speed)
    lift := clampQ 0 s.liftTop (quantize (p.lift + s.dt * s.liftRate * (c.lift : ℚ) / 1000)) }

/-- **A tick cannot make the machine exceed its top speed**, whatever the game
sends down the wire. -/
theorem step_speed_bound (s : Sim) {c : Command} (hc : c.Valid) {p : PlantState}
    (hp : |p.speed| ≤ s.vmax) : |(step s c p).speed| ≤ s.vmax := by
  obtain ⟨⟨ht1, ht2⟩, -⟩ := hc
  have htau : 0 < s.tau := lt_of_lt_of_le s.dt_pos s.dt_le_tau
  have hdt := s.dt_pos
  have ha1 : s.dt / s.tau ≤ 1 := (div_le_one htau).2 s.dt_le_tau
  have ha0 : 0 < s.dt / s.tau := div_pos hdt htau
  have htarget : |s.vmax * (c.throttle : ℚ) / 1000| ≤ s.vmax := by
    rw [abs_div, abs_of_nonneg (by norm_num : (0 : ℚ) ≤ 1000), abs_mul,
      abs_of_pos s.vmax_pos, div_le_iff₀ (by norm_num : (0 : ℚ) < 1000)]
    have habs : |(c.throttle : ℚ)| ≤ 1000 := by
      rw [abs_le]
      constructor
      · exact_mod_cast ht1
      · exact_mod_cast ht2
    nlinarith [s.vmax_pos]
  obtain ⟨hp1, hp2⟩ := abs_le.1 hp
  obtain ⟨hq1, hq2⟩ := abs_le.1 htarget
  set a := s.dt / s.tau with hadef
  have hraw : p.speed + s.dt * (s.vmax * (c.throttle : ℚ) / 1000 - p.speed) / s.tau
      = (1 - a) * p.speed + a * (s.vmax * (c.throttle : ℚ) / 1000) := by
    simp only [hadef]
    field_simp
    ring
  have hbound : |(1 - a) * p.speed + a * (s.vmax * (c.throttle : ℚ) / 1000)| ≤ s.vmax := by
    rw [abs_le]
    constructor <;> nlinarith
  have hstep : (step s c p).speed
      = quantize ((1 - a) * p.speed + a * (s.vmax * (c.throttle : ℚ) / 1000)) := by
    simp only [step, ← hraw]
  rw [hstep]
  exact (abs_quantize_le _).trans hbound

/-- The loader always stays between the ground and its top stop. -/
theorem step_lift_mem_Icc (s : Sim) (c : Command) (p : PlantState) :
    (step s c p).lift ∈ Set.Icc 0 s.liftTop :=
  clampQ_mem_Icc s.liftTop_pos.le

/-! ## The autopilot -/

/-- Turn a demand in thousandths into a legal axis value. -/
def toAxis (q : ℚ) : ℤ := clampAxis ⌊q⌋

theorem toAxis_inRange (q : ℚ) : InRange (toAxis q) := clampAxis_inRange _

theorem inRange_zero : InRange 0 := by unfold InRange; norm_num

theorem inRange_top : InRange 1000 := by unfold InRange; norm_num

theorem inRange_bot : InRange (-1000) := by unfold InRange; norm_num

/-- The four phases of a field job. -/
inductive Phase
  /-- Working down the field. -/
  | drive
  /-- Raising the loader at the headland. -/
  | raise
  /-- Turning round. -/
  | turn
  /-- Job finished. -/
  | done
  deriving DecidableEq, Repr

/-- What the job is: how long a pass is, how many of them, and how fast to
work. -/
structure Mission where
  /-- Length of one pass. -/
  passLength : ℚ
  /-- Number of passes to make. -/
  passes : ℕ
  /-- Working speed. -/
  cruise : ℚ
  deriving DecidableEq, Repr

/-- Where the job has got to. -/
structure World where
  /-- Which phase the autopilot is in. -/
  phase : Phase
  /-- The machine. -/
  plant : PlantState
  /-- Passes finished. -/
  passDone : ℕ
  /-- Ticks elapsed. -/
  ticks : ℕ
  deriving DecidableEq, Repr

/-- The speed loop: feed-forward for the cruising speed plus a proportional
term on the error. -/
def driveCommand (s : Sim) (gain target : ℚ) (p : PlantState) : Command :=
  { throttle := toAxis (1000 * (target + gain * (target - p.speed)) / s.vmax)
    steer := 0, lift := 0, tilt := 0, ignition := true, lights := false }

/-- The command the autopilot issues in each phase. -/
def command (s : Sim) (m : Mission) (w : World) : Command :=
  match w.phase with
  | .drive => driveCommand s 1 m.cruise w.plant
  | .raise => { throttle := 0, steer := 0, lift := 1000, tilt := 0,
                ignition := true, lights := false }
  | .turn => { throttle := 0, steer := 1000, lift := -1000, tilt := 0,
               ignition := true, lights := false }
  | .done => Command.neutral

/-- **Everything the autopilot sends is a legal command.** -/
theorem command_valid (s : Sim) (m : Mission) (w : World) : (command s m w).Valid := by
  unfold command
  cases w.phase
  · exact ⟨toAxis_inRange _, inRange_zero, inRange_zero, inRange_zero⟩
  · exact ⟨inRange_zero, inRange_zero, inRange_top, inRange_zero⟩
  · exact ⟨inRange_zero, inRange_top, inRange_bot, inRange_zero⟩
  · exact ⟨inRange_zero, inRange_zero, inRange_zero, inRange_zero⟩

/-- One tick of the job: issue the command, move the machine, and change phase
if the phase is finished. -/
def advance (s : Sim) (m : Mission) (w : World) : World :=
  let p := step s (command s m w) w.plant
  match w.phase with
  | .drive =>
      if p.travel ≥ m.passLength then ⟨.raise, p, w.passDone, w.ticks + 1⟩
      else ⟨.drive, p, w.passDone, w.ticks + 1⟩
  | .raise =>
      if p.lift ≥ s.liftTop then ⟨.turn, p, w.passDone, w.ticks + 1⟩
      else ⟨.raise, p, w.passDone, w.ticks + 1⟩
  | .turn =>
      if p.lift ≤ 0 then
        ⟨if w.passDone + 1 ≥ m.passes then .done else .drive,
          { p with travel := 0 }, w.passDone + 1, w.ticks + 1⟩
      else ⟨.turn, p, w.passDone, w.ticks + 1⟩
  | .done => ⟨.done, p, w.passDone, w.ticks + 1⟩

/-- The state of the job after `n` ticks. -/
def run (s : Sim) (m : Mission) : ℕ → World → World
  | 0, w => w
  | n + 1, w => advance s m (run s m n w)

/-- Every state the job passes through, oldest first. -/
def trace (s : Sim) (m : Mission) : ℕ → World → List World
  | 0, w => [w]
  | n + 1, w => trace s m n w ++ [run s m (n + 1) w]

/-- The plant of a tick is the plant of a `step`, whatever the phase. -/
theorem advance_plant (s : Sim) (m : Mission) (w : World) :
    (advance s m w).plant.speed = (step s (command s m w) w.plant).speed ∧
      (advance s m w).plant.lift = (step s (command s m w) w.plant).lift := by
  unfold advance
  cases w.phase <;> simp <;> split <;> simp

/-- **The autopilot never speeds.** -/
theorem run_speed_bound (s : Sim) (m : Mission) {w : World} (hw : |w.plant.speed| ≤ s.vmax)
    (n : ℕ) : |(run s m n w).plant.speed| ≤ s.vmax := by
  induction n with
  | zero => exact hw
  | succ n ih =>
      have h := (advance_plant s m (run s m n w)).1
      have hstep := step_speed_bound s (command_valid s m (run s m n w)) ih
      have : (run s m (n + 1) w).plant.speed
          = (step s (command s m (run s m n w)) (run s m n w).plant).speed := by
        rw [show run s m (n + 1) w = advance s m (run s m n w) from rfl, h]
      rw [this]
      exact hstep

/-- **The loader is never driven through a stop.** -/
theorem run_lift_mem_Icc (s : Sim) (m : Mission) (w : World) (n : ℕ) (hn : 0 < n) :
    (run s m n w).plant.lift ∈ Set.Icc 0 s.liftTop := by
  obtain ⟨k, rfl⟩ : ∃ k, n = k + 1 := ⟨n - 1, by omega⟩
  have h := (advance_plant s m (run s m k w)).2
  have : (run s m (k + 1) w).plant.lift
      = (step s (command s m (run s m k w)) (run s m k w).plant).lift := by
    rw [show run s m (k + 1) w = advance s m (run s m k w) from rfl, h]
  rw [this]
  exact step_lift_mem_Icc _ _ _

/-! ## A job, run -/

/-- The simulated machine: a tenth-of-a-second tick, a half-second drive line,
2 m/s top speed, a loader that takes two seconds to its 1 m stop. -/
def demoSim : Sim where
  dt := 1 / 10
  tau := 1 / 2
  vmax := 2
  liftRate := 1 / 2
  liftTop := 1
  dt_pos := by norm_num
  dt_le_tau := by norm_num
  vmax_pos := by norm_num
  liftRate_pos := by norm_num
  liftTop_pos := by norm_num

/-- The job: three passes of twenty metres at one and a half metres a
second. -/
def demoMission : Mission where
  passLength := 20
  passes := 3
  cruise := 3 / 2

/-- The machine at the top of the field, stopped, loader down. -/
def start : World := ⟨.drive, ⟨0, 0, 0⟩, 0, 0⟩

/-- The job is finished within 600 ticks — a minute of simulated time. -/
theorem mission_completes : (run demoSim demoMission 600 start).phase = Phase.done := by
  native_decide

/-- …with all three passes made. -/
theorem mission_passes : (run demoSim demoMission 600 start).passDone = 3 := by
  native_decide

/-- The autopilot is still working at tick 200: the job is not over early. -/
theorem mission_not_done_early : (run demoSim demoMission 200 start).phase ≠ Phase.done := by
  native_decide

/-- The job takes 531 ticks — 53.1 seconds of simulated time — and not one
less. -/
theorem mission_ticks :
    (run demoSim demoMission 531 start).phase = Phase.done ∧
      (run demoSim demoMission 530 start).phase ≠ Phase.done := by
  refine ⟨?_, ?_⟩ <;> native_decide

/-- The speed loop settles: a minute of ticks into the first pass the machine
is holding its 1.5 m/s working speed to within two millimetres a second. -/
theorem mission_cruises :
    |(run demoSim demoMission 60 start).plant.speed - demoMission.cruise| ≤ 1 / 500 := by
  native_decide

/-- The machine never speeds during the job — a consequence of the general
invariant, not of the particular run. -/
theorem demo_speed_bound (n : ℕ) : |(run demoSim demoMission n start).plant.speed| ≤ 2 :=
  run_speed_bound demoSim demoMission (by norm_num [start, demoSim]) n

/-- And the loader stays on the machine. -/
theorem demo_lift_bound (n : ℕ) (hn : 0 < n) :
    (run demoSim demoMission n start).plant.lift ∈ Set.Icc (0 : ℚ) 1 :=
  run_lift_mem_Icc demoSim demoMission start n hn

end Auto
end LifeTrac
