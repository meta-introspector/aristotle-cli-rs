import RequestProject.Nix.NixWars.BlackHole

/-!
# Do we need a special kind of clock, and how can we tell?

`BlackHole.lean` hangs seven cabinets at seven depths of the well and shows
that the deep ones step more slowly. Two questions are left over, and this
file answers both of them.

## Do we need a special kind of clock?

Yes, and we can say exactly which kind. A clock whose tick is `c` host units
long can only make things happen at multiples of `c`; a cabinet of period `p`
steps at multiples of `p`; so the clock can drive that cabinet exactly when
`c ∣ p` (`drives_iff_dvd`). A single clock that drives the *whole floor* must
therefore have a tick dividing every period, and the coarsest such tick is
their greatest common divisor, `roomTick` (`roomTick_dvd`,
`roomTick_greatest`). At the other end, the room only comes back together at
the least common multiple, `frame` (`dvd_frame`, `frame_minimal` in
`BlackHole.lean`). So the room clock is a *two-scale* instrument: it must
resolve `roomTick` and it must count as far as `frame`, and those two numbers
coincide only when every cabinet on the floor runs at the same speed
(`one_scale_iff_uniform`). A well full of different depths is never uniform,
so the ordinary one-scale clock will not do: for the seven cabinets the tick
is `1` and the frame is `792`, a dynamic range of `792 : 1`
(`sunk_tick`, `sunk_two_scale`, `sunk_resolution`).

## How can we tell?

Not from one screen. A cabinet's own tape — its state after each of its own
steps — is the same at every depth (`no_local_test`), which is
`experiment_invariance` again: proper time cannot see the dilation.

You tell by putting **two** cabinets on **one** clock and reading the gap
between their step counters. Two cabinets disagree at some tick if and only
if their periods differ (`detect_iff`); the first disagreement is exactly one
step of the faster one (`first_disagreement`), so the test is as sensitive as
the room clock allows; and the gap is unbounded (`gap_unbounded`), so the
longer you record the more decisive the reading. Over one room frame the
seven cabinets fall behind the flat-space one by
`781, 770, 759, 720, 528, 396, 0` steps (`sunk_gaps`).
-/

namespace NixWars

namespace BlackHole

/-! ## Which clocks can drive which cabinets -/

/-- A clock of tick `c` **drives** a cabinet of period `p` when every step
boundary of the cabinet falls on a tick of the clock. -/
def Drives (c p : Nat) : Prop := 0 < c ∧ c ∣ p

/-- **What it takes to drive a cabinet.** A clock ticking every `c` host
units can only act at multiples of `c`; a cabinet of period `p` steps at
`p, 2p, 3p, …`; so all of the cabinet's boundaries are clock ticks exactly
when the tick divides the period. -/
theorem drives_iff_dvd (c p : Nat) : (∀ n, c ∣ n * p) ↔ c ∣ p :=
  ⟨fun h => by simpa using h 1, fun h n => h.mul_left n⟩

/-- The room's **tick**: the coarsest clock that drives every cabinet on the
floor, namely the greatest common divisor of their periods. -/
def roomTick (ps : List Nat) : Nat := ps.foldr Nat.gcd 0

/-- The room tick drives every cabinet on the floor. -/
theorem roomTick_dvd {p : Nat} : ∀ {ps : List Nat}, p ∈ ps → roomTick ps ∣ p := by
  intro ps
  induction ps with
  | nil => intro h; cases h
  | cons a rest ih =>
    intro h
    rcases List.mem_cons.mp h with h | h
    · subst h; exact Nat.gcd_dvd_left _ _
    · exact dvd_trans (Nat.gcd_dvd_right _ _) (ih h)

/-- And it is the coarsest such clock: anything that drives the whole floor
divides it. -/
theorem roomTick_greatest {c : Nat} :
    ∀ {ps : List Nat}, (∀ p ∈ ps, c ∣ p) → c ∣ roomTick ps := by
  intro ps
  induction ps with
  | nil => intro _; exact dvd_zero c
  | cons a rest ih =>
    intro h
    exact Nat.dvd_gcd (h a (List.mem_cons_self ..))
      (ih (fun p hp => h p (List.mem_cons_of_mem _ hp)))

/-- A floor of real cabinets has a real tick. -/
theorem roomTick_pos : ∀ {ps : List Nat}, ps ≠ [] → (∀ p ∈ ps, 0 < p) → 0 < roomTick ps := by
  intro ps
  cases ps with
  | nil => intro h; exact absurd rfl h
  | cons a rest =>
    intro _ h
    show 0 < Nat.gcd a (roomTick rest)
    exact Nat.gcd_pos_of_pos_left _ (h a (List.mem_cons_self ..))

/-- The tick is finer than the frame: the room's two scales are nested. -/
theorem roomTick_dvd_frame : ∀ {ps : List Nat}, ps ≠ [] → roomTick ps ∣ frame ps := by
  intro ps
  cases ps with
  | nil => intro h; exact absurd rfl h
  | cons a rest =>
    intro _
    exact dvd_trans (Nat.gcd_dvd_left _ _) (dvd_frame (List.mem_cons_self ..))

/-- A floor on which every cabinet runs at the same speed. -/
def Uniform (ps : List Nat) : Prop := ∀ p ∈ ps, ∀ q ∈ ps, p = q

/-- On a uniform floor the tick is the common period. -/
theorem roomTick_const {a : Nat} :
    ∀ {ps : List Nat}, ps ≠ [] → (∀ p ∈ ps, p = a) → roomTick ps = a := by
  intro ps
  induction ps with
  | nil => intro h; exact absurd rfl h
  | cons b rest ih =>
    intro _ h
    have hb : b = a := h b (List.mem_cons_self ..)
    subst hb
    by_cases hr : rest = []
    · subst hr; simp [roomTick]
    · have : roomTick rest = b := ih hr (fun p hp => h p (List.mem_cons_of_mem _ hp))
      show Nat.gcd b (roomTick rest) = b
      rw [this, Nat.gcd_self]

/-- On a uniform floor the frame is the common period too. -/
theorem frame_const {a : Nat} :
    ∀ {ps : List Nat}, ps ≠ [] → (∀ p ∈ ps, p = a) → frame ps = a := by
  intro ps
  induction ps with
  | nil => intro h; exact absurd rfl h
  | cons b rest ih =>
    intro _ h
    have hb : b = a := h b (List.mem_cons_self ..)
    subst hb
    by_cases hr : rest = []
    · subst hr; simp [frame]
    · have : frame rest = b := ih hr (fun p hp => h p (List.mem_cons_of_mem _ hp))
      show Nat.lcm b (frame rest) = b
      rw [this, Nat.lcm_self]

/-- **The room clock is genuinely two-scale.** Its resolution `roomTick` and
its period `frame` are the same number exactly when every cabinet on the floor
runs at the same speed. A floor with two speeds on it therefore needs a clock
that resolves finer than any one cabinet's step and counts further than any
one cabinet's step — which is what "a special kind of clock" means. -/
theorem one_scale_iff_uniform {ps : List Nat} (hne : ps ≠ []) (hpos : ∀ p ∈ ps, 0 < p) :
    roomTick ps = frame ps ↔ Uniform ps := by
  constructor
  · intro heq
    have key : ∀ p ∈ ps, p = roomTick ps := by
      intro p hp
      refine Nat.dvd_antisymm ?_ (roomTick_dvd hp)
      rw [heq]; exact dvd_frame hp
    intro p hp q hq
    rw [key p hp, key q hq]
  · intro huni
    obtain ⟨a, rest, rfl⟩ : ∃ a rest, ps = a :: rest := by
      cases ps with
      | nil => exact absurd rfl hne
      | cons a rest => exact ⟨a, rest, rfl⟩
    have hall : ∀ p ∈ a :: rest, p = a := fun p hp => huni p hp a (List.mem_cons_self ..)
    rw [roomTick_const hne hall, frame_const hne hall]

/-- The **dynamic range** the room clock has to cover: how many ticks there
are in a frame. -/
def resolution (ps : List Nat) : Nat := frame ps / roomTick ps

/-! ## Telling the difference -/

/-- The **gap** an observer records at tick `t`: how many steps the cabinet of
period `p` is ahead of the cabinet of period `q`. -/
def gap (p q t : Nat) : Nat := steps p t - steps q t

/-- A cabinet's own tape: after `n` of its own steps it is in state `f^[n] s₀`,
whatever its period. -/
theorem proper_trace {σ : Type} (f : σ → σ) (s₀ : σ) {p : Nat} (hp : 0 < p) (n : Nat) :
    observe f s₀ p (n * p) = f^[n] s₀ := by
  show f^[steps p (n * p)] s₀ = f^[n] s₀
  rw [show steps p (n * p) = n from Nat.mul_div_cancel n hp]

/-- **There is no local test.** Read against its own clock, a cabinet's tape
is the same at every depth of the well: nothing a single screen shows can
reveal how slowly it is running. This is why the experiment needs an outside
clock at all. -/
theorem no_local_test {σ : Type} (f : σ → σ) (s₀ : σ) {p q : Nat}
    (hp : 0 < p) (hq : 0 < q) (n : Nat) :
    observe f s₀ p (n * p) = observe f s₀ q (n * q) := by
  rw [proper_trace f s₀ hp n, proper_trace f s₀ hq n]

/-- **The two-cabinet test is exactly right.** On a shared clock two cabinets
read differently at some tick if and only if they really do run at different
speeds: the test never fires on equal speeds and never misses unequal ones. -/
theorem detect_iff {p q : Nat} (hp : 0 < p) (hq : 0 < q) :
    (∃ t, steps p t ≠ steps q t) ↔ p ≠ q := by
  constructor
  · rintro ⟨t, ht⟩ rfl
    exact ht rfl
  · intro hne
    by_contra hc
    push_neg at hc
    exact hne (div_ext hp hq (fun t => hc t))

/-- **How soon we can tell.** Two cabinets of different speeds agree until the
faster one has taken its first step, and disagree from that tick on: the
detector fires at tick `p`, and not one tick earlier. -/
theorem first_disagreement {p q : Nat} (hp : 0 < p) (hpq : p < q) :
    (∀ t, t < p → steps p t = steps q t) ∧ steps p p = 1 ∧ steps q p = 0 := by
  refine ⟨fun t ht => ?_, ?_, ?_⟩
  · show t / p = t / q
    rw [Nat.div_eq_of_lt ht, Nat.div_eq_of_lt (ht.trans hpq)]
  · show p / p = 1
    exact Nat.div_self hp
  · show p / q = 0
    exact Nat.div_eq_of_lt hpq

/-- **The reading is as decisive as you like.** Record for long enough and the
faster cabinet is ahead by any number of steps you care to name. -/
theorem gap_unbounded {p q : Nat} (hp : 0 < p) (hpq : p < q) (N : Nat) :
    ∃ t, N ≤ gap p q t := by
  have hq : 0 < q := hp.trans hpq
  refine ⟨N * p * q, ?_⟩
  have h1 : steps p (N * p * q) = N * q := by
    show N * p * q / p = N * q
    rw [show N * p * q = N * q * p by ring]
    exact Nat.mul_div_cancel _ hp
  have h2 : steps q (N * p * q) = N * p := by
    show N * p * q / q = N * p
    exact Nat.mul_div_cancel _ hq
  have : N * 1 ≤ N * q - N * p := by
    have hle : N * p + N * 1 ≤ N * q := by
      have := Nat.mul_le_mul_left N (show p + 1 ≤ q by omega)
      calc N * p + N * 1 = N * (p + 1) := by ring
        _ ≤ N * q := this
    omega
  show N ≤ steps p (N * p * q) - steps q (N * p * q)
  rw [h1, h2]
  omega

/-! ## The seven cabinets of the well -/

/-- The room tick of the well's floor is a single host unit: the fastest
cabinet already steps every tick, so the clock cannot be any coarser. -/
theorem sunk_tick : roomTick sunkPeriods = 1 := by decide

/-- **The well's floor needs a two-scale clock**: its tick and its frame are
different numbers, so no one-scale clock will do. -/
theorem sunk_two_scale : roomTick sunkPeriods ≠ frame sunkPeriods := by decide

/-- And the range the clock has to cover is seven hundred and ninety-two to
one. -/
theorem sunk_resolution : resolution sunkPeriods = 792 := by decide

/-- The floor of the well is not uniform, which is why the special clock is
needed at all. -/
theorem sunk_not_uniform : ¬ Uniform sunkPeriods := by
  intro h
  have h72 : (72 : Nat) ∈ sunkPeriods := by rw [sunkPeriods_eq]; simp
  have h1 : (1 : Nat) ∈ sunkPeriods := by rw [sunkPeriods_eq]; simp
  have : (72 : Nat) = 1 := h 72 h72 1 h1
  omega

/-- **The recorded difference.** Over one room frame, how far each of the
seven cabinets falls behind the one out in flat space. -/
theorem sunk_gaps :
    sunkPeriods.map (fun p => gap 1 p 792) = [781, 770, 759, 720, 528, 396, 0] := by
  decide

end BlackHole

end NixWars
