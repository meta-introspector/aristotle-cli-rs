import RequestProject.Nix.NixWars.Arcade
import RequestProject.Nix.NixWars.Shards

/-!
# The black-hole experiments: machines that run slower, and the arcade

Reading the shards again, door 1 of the board (`NIXWARS`) has a scanner that
reports `GALACTIC CENTER DETECTED. Sgr A* is here.` when the warp distance
falls below a hundred: there is a black hole in the middle of the shard ring.
This file is the experiment that report is pointing at.

Put a cabinet at radius `r` from a hole of horizon radius `rs`. The clock on
the cabinet runs slow, by the Schwarzschild factor

  `dt/dτ = r / (r - rs)`,

so a game step that costs `k` ticks of the arcade's own clock out in flat space
costs `⌊k·r/(r-rs)⌋` ticks down the well. Three things come out of that, and
they are exactly the three things the room is for.

* **The machines run slower.** `Well.dil` is strictly antitone in the radius
  and blows up at the horizon (`Well.one_lt_dil`, `Well.dil_strictAnti`,
  `Well.dil_horizon`); the integer period does the same
  (`Well.base_le_period`, `Well.period_antitone`, `Well.period_unbounded`),
  and far away the cabinet runs at its native rate again (`Well.period_far`).
  A cabinet lowered to the horizon takes no step ever (`steps_horizon`,
  `frozen_at_horizon`), but a cabinet anywhere outside it takes every step
  eventually (`every_step_eventually`). And the *game* cannot tell:
  the state after `n` of its own steps is the same at any depth
  (`experiment_invariance`). Dilation is a reparametrisation of the schedule,
  not a change of the computation. That is the whole content of the
  experiment: same cartridge, same trace, different wall clock.

* **Why we need arcades.** One clock cannot serve two speeds
  (`one_clock_cannot_serve_two`): if a single period reproduced the step
  counts of two cabinets, the two periods would be equal (`div_ext`). So the
  room has to be a room — a cabinet per speed, each with its own clock — and
  the room's frame is the least common multiple of the periods
  (`dvd_frame`, `frame_minimal`), at which every cabinet lands exactly on a
  step boundary and nobody is caught mid-frame (`frame_whole_steps`).

* **Different people are expert at different speeds.** A player is a reaction
  latency; they can hold a cabinet whose step is at least that long
  (`Masters`). Mastery is upward closed in the period
  (`masters_of_slower`), but it is *not* transferable downwards: for any two
  distinct speeds there is a player who has one and not the other
  (`expertise_is_speed_specific`, `mastery_distinguishes`), and nobody with a
  latency above one tick is expert at everything (`no_universal_player`).
  Hence the floor plan: a spread of periods seats a spread of players
  (`arcade_seats_everyone`), and the well supplies the spread for free, since
  sinking a cabinet deep enough makes it playable by anyone
  (`well_seats_any_player`).

The concrete instance is the hole in the middle of the ring: horizon radius
`numShards = 71`, seven cabinets at radii `72 … 143`, periods
`72, 36, 24, 11, 3, 2, 1` and a room frame of `792` ticks.
-/

namespace NixWars

namespace BlackHole

/-! ## The gravity well -/

/-- A gravity well: the horizon radius of the hole, in shard units. -/
structure Well where
  /-- Schwarzschild radius. -/
  rs : Nat
  /-- A hole with no horizon is not a hole. -/
  rs_pos : 0 < rs

namespace Well

variable (w : Well)

/-- The time dilation factor `dt/dτ = r/(r - rs)`: how many ticks of the
arcade's clock one tick of a cabinet at radius `r` costs. At or inside the
horizon nothing ever completes, which we record as the factor `0`. -/
noncomputable def dil (r : Nat) : ℚ :=
  if r ≤ w.rs then 0 else (r : ℚ) / ((r : ℚ) - (w.rs : ℚ))

/-- At or inside the horizon the factor is the degenerate `0`. -/
theorem dil_horizon {r : Nat} (h : r ≤ w.rs) : w.dil r = 0 := by
  simp [dil, h]

/-- Outside the horizon every cabinet runs strictly slow. -/
theorem one_lt_dil {r : Nat} (h : w.rs < r) : 1 < w.dil r := by
  have hpos : (0 : ℚ) < (r : ℚ) - (w.rs : ℚ) := by
    have : (w.rs : ℚ) < (r : ℚ) := by exact_mod_cast h
    linarith
  have hrs : (0 : ℚ) < (w.rs : ℚ) := by exact_mod_cast w.rs_pos
  rw [dil, if_neg (by omega)]
  rw [one_lt_div hpos]
  linarith

/-- Deeper in the well is strictly slower. -/
theorem dil_strictAnti {r₁ r₂ : Nat} (h₁ : w.rs < r₁) (h₂ : r₁ < r₂) :
    w.dil r₂ < w.dil r₁ := by
  have hp₁ : (0 : ℚ) < (r₁ : ℚ) - (w.rs : ℚ) := by
    have : (w.rs : ℚ) < (r₁ : ℚ) := by exact_mod_cast h₁
    linarith
  have hp₂ : (0 : ℚ) < (r₂ : ℚ) - (w.rs : ℚ) := by
    have : (w.rs : ℚ) < (r₂ : ℚ) := by exact_mod_cast (h₁.trans h₂)
    linarith
  have hrs : (0 : ℚ) < (w.rs : ℚ) := by exact_mod_cast w.rs_pos
  have hlt : (r₁ : ℚ) < (r₂ : ℚ) := by exact_mod_cast h₂
  rw [dil, if_neg (by omega), dil, if_neg (by omega), div_lt_div_iff₀ hp₂ hp₁]
  nlinarith

/-- Far from the hole the factor is as close to `1` as you like: at
`(n+1)·rs` and beyond it is within `1/n`. -/
theorem dil_near_one {n r : Nat} (hn : 0 < n) (hr : w.rs * (n + 1) ≤ r) :
    w.dil r ≤ 1 + 1 / (n : ℚ) := by
  have hrs : (0 : ℚ) < (w.rs : ℚ) := by exact_mod_cast w.rs_pos
  have hrsn : w.rs < r := by
    have : w.rs * 1 ≤ w.rs * (n + 1) := Nat.mul_le_mul_left _ (by omega)
    have h2 : w.rs * (n + 1) = w.rs * n + w.rs := by ring
    have h3 : 0 < w.rs * n := Nat.mul_pos w.rs_pos hn
    omega
  have hpos : (0 : ℚ) < (r : ℚ) - (w.rs : ℚ) := by
    have : (w.rs : ℚ) < (r : ℚ) := by exact_mod_cast hrsn
    linarith
  have hnQ : (0 : ℚ) < (n : ℚ) := by exact_mod_cast hn
  have hrQ : (w.rs : ℚ) * ((n : ℚ) + 1) ≤ (r : ℚ) := by exact_mod_cast hr
  rw [dil, if_neg (by omega)]
  rw [div_le_iff₀ hpos]
  have : (1 : ℚ) + 1 / (n : ℚ) = ((n : ℚ) + 1) / (n : ℚ) := by
    field_simp
  rw [this, div_mul_eq_mul_div, le_div_iff₀ hnQ]
  nlinarith

/-! ## The integer clock -/

/-- Host ticks per game step for a cabinet whose native step costs `k` ticks,
placed at radius `r`: the dilation factor, floored. At or inside the horizon
the period is `0`, which the step counter reads as "never". -/
def period (k r : Nat) : Nat :=
  if r ≤ w.rs then 0 else (k * r) / (r - w.rs)

/-- At or inside the horizon there is no period at all. -/
theorem period_horizon {k r : Nat} (h : r ≤ w.rs) : w.period k r = 0 := by
  simp [period, h]

/-- Outside the horizon the cabinet is never faster than its native rate. -/
theorem base_le_period {k r : Nat} (h : w.rs < r) : k ≤ w.period k r := by
  rw [period, if_neg (by omega), Nat.le_div_iff_mul_le (by omega)]
  have : r - w.rs ≤ r := Nat.sub_le _ _
  calc k * (r - w.rs) ≤ k * r := Nat.mul_le_mul_left _ this
    _ = k * r := rfl

/-- Outside the horizon a cabinet with a real native rate has a real period. -/
theorem period_pos {k r : Nat} (hk : 0 < k) (h : w.rs < r) : 0 < w.period k r :=
  lt_of_lt_of_le hk (w.base_le_period h)

/-- Cross-multiplication for floored division. -/
theorem div_le_div_of_cross {a b c d : Nat} (hb : 0 < b) (hd : 0 < d)
    (h : a * d ≤ c * b) : a / b ≤ c / d := by
  rw [Nat.le_div_iff_mul_le hd]
  have h1 : a / b * b ≤ a := Nat.div_mul_le_self a b
  have h2 : a / b * d * b = a / b * b * d := by ring
  have h3 : a / b * d * b ≤ c * b := by
    rw [h2]
    calc a / b * b * d ≤ a * d := Nat.mul_le_mul_right _ h1
      _ ≤ c * b := h
  exact Nat.le_of_mul_le_mul_right h3 hb

/-- Deeper in the well is slower: the period only grows as the radius falls. -/
theorem period_antitone {k r₁ r₂ : Nat} (h₁ : w.rs < r₁) (h₂ : r₁ ≤ r₂) :
    w.period k r₂ ≤ w.period k r₁ := by
  have h₁' : w.rs < r₂ := lt_of_lt_of_le h₁ h₂
  rw [period, if_neg (by omega), period, if_neg (by omega)]
  refine div_le_div_of_cross (by omega) (by omega) ?_
  obtain ⟨x, hx⟩ : ∃ x, r₁ = w.rs + x := ⟨r₁ - w.rs, by omega⟩
  obtain ⟨y, hy⟩ : ∃ y, r₂ = w.rs + y := ⟨r₂ - w.rs, by omega⟩
  subst hx; subst hy
  have hxy : x ≤ y := by omega
  simp only [Nat.add_sub_cancel_left]
  calc k * (w.rs + y) * x = k * w.rs * x + k * (x * y) := by ring
    _ ≤ k * w.rs * y + k * (x * y) := by
        have := Nat.mul_le_mul_left (k * w.rs) hxy
        omega
    _ = k * (w.rs + x) * y := by ring

/-- Far outside the hole the cabinet runs at exactly its native rate: beyond
`(k+1)·rs` the floored dilation has come all the way back to `k`. -/
theorem period_far {k r : Nat} (h : (k + 1) * w.rs < r) : w.period k r = k := by
  have hmul : (k + 1) * w.rs = k * w.rs + w.rs := by ring
  have hrs : w.rs < r := by omega
  rw [period, if_neg (by omega)]
  refine Nat.div_eq_of_lt_le (Nat.mul_le_mul_left _ (Nat.sub_le _ _)) ?_
  obtain ⟨x, hx⟩ : ∃ x, r = w.rs + x := ⟨r - w.rs, by omega⟩
  subst hx
  simp only [Nat.add_sub_cancel_left]
  have h1 : k * (w.rs + x) = k * w.rs + k * x := by ring
  have h2 : (k + 1) * x = k * x + x := by ring
  omega

/-- However slow a player, however coarse a clock, there is a well and a
radius outside its horizon with a period at least that long: the well
manufactures arbitrarily slow cabinets. -/
theorem period_unbounded (k N : Nat) (hk : 0 < k) :
    ∃ (w : Well) (r : Nat), w.rs < r ∧ N ≤ w.period k r := by
  refine ⟨⟨N + 1, by omega⟩, N + 2, by simp, ?_⟩
  have : ((⟨N + 1, by omega⟩ : Well)).period k (N + 2) = (k * (N + 2)) / 1 := by
    simp [period]
  rw [this, Nat.div_one]
  calc N ≤ 1 * (N + 2) := by omega
    _ ≤ k * (N + 2) := Nat.mul_le_mul_right _ hk

end Well

/-! ## What a cabinet has done by time `t` -/

/-- How many game steps a cabinet of period `p` has taken after `t` ticks of
the arcade's clock. `Nat` division sends a period of `0` — a cabinet at the
horizon — to no steps at all, ever. -/
def steps (p t : Nat) : Nat := t / p

/-- A cabinet lowered to the horizon never takes a step, no matter how long
the room waits. -/
theorem steps_horizon (w : Well) {k r : Nat} (h : r ≤ w.rs) (t : Nat) :
    steps (w.period k r) t = 0 := by
  rw [w.period_horizon h]
  simp [steps]

/-- Outside the horizon, every step of the game does eventually happen. -/
theorem every_step_eventually {p : Nat} (hp : 0 < p) (n : Nat) :
    ∃ t, steps p t = n :=
  ⟨n * p, by simp [steps, Nat.mul_div_cancel _ hp]⟩

/-- A slower cabinet has taken no more steps. -/
theorem steps_antitone {p q t : Nat} (hp : 0 < p) (hpq : p ≤ q) :
    steps q t ≤ steps p t :=
  Nat.div_le_div_left hpq hp

/-- **Machines run slower down the well.** By any given time, the cabinet
nearer the hole has taken no more steps than the one further out. -/
theorem deeper_is_slower (w : Well) {k r₁ r₂ t : Nat} (hk : 0 < k)
    (h₁ : w.rs < r₁) (h₂ : r₁ ≤ r₂) :
    steps (w.period k r₁) t ≤ steps (w.period k r₂) t :=
  steps_antitone (w.period_pos hk (lt_of_lt_of_le h₁ h₂)) (w.period_antitone h₁ h₂)

/-- What the screen of a cabinet of period `p` shows at time `t`: the game,
run for as many of its own steps as have fitted in. -/
def observe {σ : Type} (f : σ → σ) (s₀ : σ) (p t : Nat) : σ := f^[steps p t] s₀

/-- **The experiment.** The same cartridge run at two different depths of the
well passes through exactly the same states; only the wall-clock times at
which it reaches them differ. Dilation reparametrises the schedule, it does
not touch the computation. -/
theorem experiment_invariance {σ : Type} (f : σ → σ) (s₀ : σ) {p₁ t₁ p₂ t₂ : Nat}
    (h : steps p₁ t₁ = steps p₂ t₂) :
    observe f s₀ p₁ t₁ = observe f s₀ p₂ t₂ := by
  simp [observe, h]

/-- At the horizon the screen is frozen on the title card for ever. -/
theorem frozen_at_horizon {σ : Type} (f : σ → σ) (s₀ : σ) (t : Nat) :
    observe f s₀ 0 t = s₀ := by
  simp [observe, steps]

/-! ## Why the room has to be a room -/

/-- Two positive periods with the same step counts at all times are equal. -/
theorem div_ext {p q : Nat} (hp : 0 < p) (hq : 0 < q) (h : ∀ t, t / p = t / q) :
    p = q := by
  have h1 : p / q = 1 := by rw [← h p, Nat.div_self hp]
  have h2 : q / p = 1 := by rw [h q, Nat.div_self hq]
  have hqp : q ≤ p := by
    by_contra hc
    rw [Nat.div_eq_of_lt (by omega)] at h1
    omega
  have hpq : p ≤ q := by
    by_contra hc
    rw [Nat.div_eq_of_lt (by omega)] at h2
    omega
  omega

/-- **Why we need arcades.** No single clock can stand in for two cabinets of
different speeds: a machine that reproduced both step counts would force the
two periods to coincide. Different speeds therefore need different cabinets,
which is what a room of cabinets is. -/
theorem one_clock_cannot_serve_two {p q : Nat} (hp : 0 < p) (hq : 0 < q)
    (hne : p ≠ q) :
    ¬ ∃ c : Nat, ∀ t, steps c t = steps p t ∧ steps c t = steps q t := by
  rintro ⟨c, hc⟩
  exact hne (div_ext hp hq (fun t => by
    have := hc t
    simp only [steps] at this
    omega))

/-- The room's frame: the shortest stretch of the arcade's clock in which
every cabinet on the floor lands on a step boundary. -/
def frame (ps : List Nat) : Nat := ps.foldr Nat.lcm 1

/-- Every cabinet's period divides the frame. -/
theorem dvd_frame {p : Nat} : ∀ {ps : List Nat}, p ∈ ps → p ∣ frame ps := by
  intro ps
  induction ps with
  | nil => intro h; cases h
  | cons a rest ih =>
    intro h
    rcases List.mem_cons.mp h with h | h
    · subst h; exact Nat.dvd_lcm_left _ _
    · exact dvd_trans (ih h) (Nat.dvd_lcm_right _ _)

/-- The frame is the shortest such stretch. -/
theorem frame_minimal {F : Nat} : ∀ {ps : List Nat}, (∀ p ∈ ps, p ∣ F) → frame ps ∣ F := by
  intro ps
  induction ps with
  | nil => intro _; exact one_dvd F
  | cons a rest ih =>
    intro h
    exact Nat.lcm_dvd (h a (List.mem_cons_self ..))
      (ih (fun p hp => h p (List.mem_cons_of_mem _ hp)))

/-- The frame is a real stretch of time as soon as every cabinet has a real
period. -/
theorem frame_pos : ∀ {ps : List Nat}, (∀ p ∈ ps, 0 < p) → 0 < frame ps := by
  intro ps
  induction ps with
  | nil => intro _; exact Nat.one_pos
  | cons a rest ih =>
    intro h
    have ha : 0 < a := h a (List.mem_cons_self ..)
    have hr : 0 < frame rest := ih (fun p hp => h p (List.mem_cons_of_mem _ hp))
    exact Nat.lcm_pos ha hr

/-- Nobody is caught mid-step at the end of a frame: each cabinet's own steps
tile the frame exactly. -/
theorem frame_whole_steps {ps : List Nat} {p : Nat} (h : p ∈ ps) :
    p * steps p (frame ps) = frame ps :=
  Nat.mul_div_cancel' (dvd_frame h)

/-! ## Players, and expertise at a speed -/

/-- A player is a reaction latency, in ticks of the arcade's clock. They can
hold a cabinet exactly when its step is at least as long as their reaction:
they get to answer every frame the game puts up. -/
def Masters (latency p : Nat) : Prop := 0 < p ∧ latency ≤ p

/-- Skill carries downwards in speed: if you can hold a cabinet you can hold
every slower one. -/
theorem masters_of_slower {L p q : Nat} (h : Masters L p) (hpq : p ≤ q) :
    Masters L q :=
  ⟨lt_of_lt_of_le h.1 hpq, le_trans h.2 hpq⟩

/-- **Expertise is specific to a speed.** For any two different speeds there
is a player who has the slower one and not the faster one. -/
theorem expertise_is_speed_specific {p q : Nat} (hpq : p < q) :
    ∃ L, Masters L q ∧ ¬ Masters L p :=
  ⟨q, ⟨by omega, le_refl q⟩, by rintro ⟨-, h⟩; omega⟩

/-- Different speeds have different experts. -/
theorem mastery_distinguishes {p q : Nat} (hne : p ≠ q) :
    ∃ L, ¬ (Masters L p ↔ Masters L q) := by
  rcases Nat.lt_or_ge p q with h | h
  · obtain ⟨L, hL, hL'⟩ := expertise_is_speed_specific h
    exact ⟨L, fun hiff => hL' (hiff.mpr hL)⟩
  · obtain ⟨L, hL, hL'⟩ := expertise_is_speed_specific (show q < p by omega)
    exact ⟨L, fun hiff => hL' (hiff.mp hL)⟩

/-- Nobody who takes longer than a tick to react is expert at everything. -/
theorem no_universal_player {L : Nat} (hL : 1 < L) : ∃ p, 0 < p ∧ ¬ Masters L p :=
  ⟨1, Nat.one_pos, by rintro ⟨-, h⟩; omega⟩

/-- The slowest cabinet on the floor. -/
def slowest (ps : List Nat) : Nat := ps.foldr max 0

/-- The slowest cabinet is a cabinet on the floor. -/
theorem slowest_mem : ∀ {ps : List Nat}, ps ≠ [] → slowest ps ∈ ps := by
  intro ps
  induction ps with
  | nil => intro h; exact absurd rfl h
  | cons a rest ih =>
    intro _
    by_cases hr : rest = []
    · subst hr; simp [slowest]
    · have hmem := ih hr
      simp only [slowest, List.foldr_cons] at *
      rcases Nat.le_total a (List.foldr max 0 rest) with h | h
      · rw [max_eq_right h]; exact List.mem_cons_of_mem _ hmem
      · rw [max_eq_left h]; exact List.mem_cons_self ..

/-- **Why the floor plan is a spread of speeds.** Every player whose reaction
is no slower than the slowest cabinet finds a cabinet on the floor that they
are expert at — and by `mastery_distinguishes` the cabinets of distinct
periods have distinct sets of experts, so each speed on the floor is really
seating a different crowd. -/
theorem arcade_seats_everyone {ps : List Nat} {L : Nat} (hne : ps ≠ [])
    (h0 : 0 < slowest ps) (hL : L ≤ slowest ps) :
    ∃ p ∈ ps, Masters L p :=
  ⟨slowest ps, slowest_mem hne, h0, hL⟩

/-- **The well seats everyone.** However slow the player, a cabinet sunk deep
enough into a gravity well is a cabinet they are expert at. The hole is an
inexhaustible supply of slow machines. -/
theorem well_seats_any_player (L k : Nat) (hk : 0 < k) :
    ∃ (w : Well) (r : Nat), w.rs < r ∧ Masters L (w.period k r) := by
  obtain ⟨w, r, hr, hL⟩ := Well.period_unbounded k L hk
  exact ⟨w, r, hr, w.period_pos hk hr, hL⟩

/-! ## The hole in the middle of the ring

Door 1's scanner reports Sgr A* at the centre of the shard ring; we take its
horizon radius to be `numShards = 71` shard units and stand seven cabinets of
native rate `1` at radii `72 … 143`. -/

/-- The hole at the galactic centre of the shard ring. -/
def sgrA : Well := ⟨numShards, by decide⟩

/-- Where the seven cabinets of the experiment stand. -/
def depths : List Nat := [72, 73, 74, 78, 100, 142, 143]

/-- Their periods, in ticks of the arcade's clock. -/
def sunkPeriods : List Nat := depths.map (sgrA.period 1)

theorem sunkPeriods_eq : sunkPeriods = [72, 36, 24, 11, 3, 2, 1] := by decide

/-- The seven cabinets really are seven different speeds. -/
theorem sunkPeriods_nodup : sunkPeriods.Nodup := by decide

/-- Sorted deepest-first: the nearer the hole, the slower the machine. -/
theorem sunkPeriods_sorted : sunkPeriods.Pairwise (· > ·) := by decide

/-- Every cabinet has a real clock. -/
theorem sunkPeriods_pos : ∀ p ∈ sunkPeriods, 0 < p := by decide

/-- The room's frame: 792 ticks, after which all seven cabinets are back on a
step boundary together. -/
theorem sunk_frame : frame sunkPeriods = 792 := by decide

/-- And 792 is the shortest such frame. -/
theorem sunk_frame_minimal {F : Nat} (h : ∀ p ∈ sunkPeriods, p ∣ F) : 792 ∣ F := by
  have := frame_minimal (F := F) h
  rwa [sunk_frame] at this

/-- In one frame the deepest cabinet takes 11 steps and the shallowest 792:
one room, seventy-two-fold spread of speeds. -/
theorem sunk_frame_steps :
    sunkPeriods.map (fun p => steps p 792) = [11, 22, 33, 72, 264, 396, 792] := by
  decide

end BlackHole

end NixWars
