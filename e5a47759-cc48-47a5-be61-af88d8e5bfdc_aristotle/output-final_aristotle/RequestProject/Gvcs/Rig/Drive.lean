import RequestProject.Gvcs.Rig.Blocks

/-!
# Driving a rig: the course, and one tick of it

This is the *play* half of the pocket game.  A machine built in
`RequestProject/Rig/Blocks.lean` is put on a closed course; the player has a
throttle, a steering axis and two buttons, and the game advances ten times a
second by `tick`, which is the whole rule book:

* the throttle makes thrust in proportion to the machine's power, but only
  while there is fuel in the tank;
* drag and the brake take speed away in proportion to it, and what is left is
  divided by the mass — so a heavy machine, or a loaded one, is slow to gather
  speed;
* speed is capped, the line across the track is capped, and how fast the line
  may be changed is capped by the machine's *grip*, which is what wheels buy;
* in the pickup zone, near the centre line, a scoop takes on a bite of load per
  tick up to the machine's capacity;
* crossing the line banks ten points per kilogramme carried and empties the
  scoop.

Everything is integer arithmetic — no reals and no floating point — because the
same rule book is compiled to WebAssembly in `RequestProject/Rig/Wasm.lean`,
and `Int.tdiv` is exactly what `i64.div_s` does.

The theorems are the invariants a player may rely on: `tick_inv` (and its
iterate `run_inv`) says the position stays on the lap, the line stays on the
track, the speed stays under the cap, the tank never goes negative and the
scoop never holds more than it can; `tick_fuel_le` says fuel only ever goes
down; `tick_score_le` says the score only ever goes up, and `tick_score_eq`
that it moves only when the line is crossed.
-/

namespace LifeTrac
namespace Rig

/-! ## A division fact

Truncated division is what the machine does; this is the one bound the proofs
need of it. -/

/-- If `|a| ≤ B·b` with `b` positive and `B` non-negative, then `|a ÷ b| ≤ B`,
where `÷` truncates towards zero. -/
theorem abs_tdiv_le_of_abs_le {a b B : Int} (hb : 0 < b) (hB : 0 ≤ B) (h : |a| ≤ B * b) :
    |a.tdiv b| ≤ B := by
  have h1 : (a.tdiv b).natAbs = a.natAbs / b.natAbs := Int.natAbs_tdiv a b
  have habs : ∀ x : Int, |x| = (x.natAbs : Int) := fun x => Int.abs_eq_natAbs x
  have h2 : (a.natAbs : Int) ≤ (B.natAbs : Int) * (b.natAbs : Int) := by
    rw [← habs, ← habs, ← habs, abs_of_nonneg hB, abs_of_nonneg (le_of_lt hb)]
    exact h
  have h2' : a.natAbs ≤ B.natAbs * b.natAbs := by exact_mod_cast h2
  have hbn : 0 < b.natAbs := Int.natAbs_pos.2 (ne_of_gt hb)
  have h4 : a.natAbs / b.natAbs ≤ B.natAbs := by
    calc a.natAbs / b.natAbs ≤ (B.natAbs * b.natAbs) / b.natAbs := Nat.div_le_div_right h2'
      _ = B.natAbs := by rw [Nat.mul_div_cancel _ hbn]
  have h5 : ((a.natAbs / b.natAbs : Nat) : Int) ≤ (B.natAbs : Int) := by exact_mod_cast h4
  have hBn : (B.natAbs : Int) = B := Int.natAbs_of_nonneg hB
  rw [habs (a.tdiv b), h1]
  omega

/-- The sharp form: if `|a| < B·b` with `b` positive then `|a ÷ b| < B`. -/
theorem abs_tdiv_lt_of_abs_lt {a b B : Int} (hb : 0 < b) (h : |a| < B * b) :
    |a.tdiv b| < B := by
  have hB : 0 < B := by nlinarith [abs_nonneg a]
  have h1 : (a.tdiv b).natAbs = a.natAbs / b.natAbs := Int.natAbs_tdiv a b
  have habs : ∀ x : Int, |x| = (x.natAbs : Int) := fun x => Int.abs_eq_natAbs x
  have h2 : (a.natAbs : Int) < (B.natAbs : Int) * (b.natAbs : Int) := by
    rw [← habs, ← habs, ← habs, abs_of_nonneg (le_of_lt hB), abs_of_nonneg (le_of_lt hb)]
    exact h
  have h2' : a.natAbs < B.natAbs * b.natAbs := by exact_mod_cast h2
  have hbn : 0 < b.natAbs := Int.natAbs_pos.2 (ne_of_gt hb)
  have h4 : a.natAbs / b.natAbs < B.natAbs := (Nat.div_lt_iff_lt_mul hbn).2 h2'
  have h5 : ((a.natAbs / b.natAbs : Nat) : Int) < (B.natAbs : Int) := by exact_mod_cast h4
  have hBn : (B.natAbs : Int) = B := Int.natAbs_of_nonneg (le_of_lt hB)
  rw [habs (a.tdiv b), h1]
  omega

/-! ## The course -/

/-- Length of the lap, in millimetres. -/
def track : Int := 120000
/-- How far from the centre line the machine may run, in millimetres. -/
def laneMax : Int := 4000
/-- The speed limit, in millimetres per second. -/
def vmax : Int := 8000
/-- Where the bales start. -/
def zoneLo : Int := 40000
/-- Where they stop. -/
def zoneHi : Int := 50000
/-- How near the centre line the scoop has to be to take a bale. -/
def zoneLane : Int := 1500
/-- How much the scoop takes in one tick, in kilogrammes. -/
def bite : Int := 25
/-- Drag: this many units of resistance per millimetre per second. -/
def dragK : Int := 40
/-- The brake, which is five times the drag. -/
def brakeK : Int := 200
/-- Ticks per second. -/
def tickHz : Int := 10

/-! ## Clamping -/

/-- Hold a number inside `[-b, b]`. -/
def clampTo (b x : Int) : Int := max (-b) (min b x)

theorem abs_clampTo {b : Int} (hb : 0 ≤ b) (x : Int) : |clampTo b x| ≤ b := by
  simp only [clampTo, abs_le]
  constructor
  · exact le_max_left _ _
  · rcases le_total x b with h | h
    · rw [min_eq_right h]
      exact max_le (by omega) h
    · rw [min_eq_left h]
      exact max_le (by omega) le_rfl

theorem clampTo_eq_self {b x : Int} (h : |x| ≤ b) : clampTo b x = x := by
  rw [abs_le] at h
  simp only [clampTo, min_eq_right h.2, max_eq_right h.1]

/-- The form the compiled code uses: two comparisons. -/
theorem clampTo_eq_ite {b : Int} (hb : 0 ≤ b) (x : Int) :
    clampTo b x = if x < -b then -b else if b < x then b else x := by
  simp only [clampTo]
  split_ifs with h1 h2
  · rw [min_eq_right (by omega), max_eq_left (by omega)]
  · rw [min_eq_left (by omega), max_eq_right (by omega)]
  · rw [min_eq_right (by omega), max_eq_right (by omega)]

/-! ## The state of a run -/

/-- Where the machine is, how fast, and how it is doing. -/
structure Drive where
  /-- Millimetres round the lap. -/
  pos : Int
  /-- Millimetres from the centre line, signed. -/
  lane : Int
  /-- Speed, in millimetres per second, signed. -/
  vel : Int
  /-- Fuel left, in millilitres. -/
  fuel : Int
  /-- Load on board, in kilogrammes. -/
  load : Int
  /-- Points banked. -/
  score : Int
  /-- Ticks elapsed. -/
  ticks : Int
  deriving Repr, DecidableEq

/-- What the player is doing this tick. -/
structure Input where
  /-- The throttle axis, `-1000 … 1000`. -/
  throttle : Int
  /-- The steering axis, `-1000 … 1000`. -/
  steer : Int
  /-- Is the scoop down? -/
  scoop : Bool
  /-- Is the brake on? -/
  brake : Bool
  deriving Repr, DecidableEq

/-- Doing nothing. -/
def Input.idle : Input := ⟨0, 0, false, false⟩

/-- The state a run starts in: at the line, stopped, tank full. -/
def startDrive (m : Machine) : Drive := ⟨0, 0, 0, m.fuelCap, 0, 0, 0⟩

/-! ## One tick -/

/-- The mass the thrust has to shift: the machine plus ten units per kilogramme
carried, plus one, so that it is never zero. -/
def totalMass (m : Machine) (s : Drive) : Int := m.mass + 10 * s.load + 1

/-- **The rule book.**  One tick of the course, a tenth of a second. -/
def tick (m : Machine) (u : Input) (s : Drive) : Drive :=
  let th := clampTo 1000 u.throttle
  let st := clampTo 1000 u.steer
  let live : Int := if 0 < s.fuel then 1 else 0
  let drive := live * (m.power * th).tdiv 1000
  let resist := dragK * s.vel + (if u.brake then brakeK * s.vel else 0)
  let acc := (drive - resist).tdiv (totalMass m s)
  let v := clampTo vmax (s.vel + acc)
  let lane := clampTo laneMax (s.lane + clampTo m.grip ((st * v).tdiv 20000))
  let p := s.pos + v.tdiv tickHz
  let lap := track ≤ p
  let pos := if lap then p - track else if p < 0 then p + track else p
  let burn := live * ((if th < 0 then -th else th) + 200).tdiv 200
  let fuel := max 0 (s.fuel - burn)
  let picking := u.scoop && decide (zoneLo ≤ pos) && decide (pos ≤ zoneHi) &&
    decide (|lane| ≤ zoneLane)
  let load := if picking then min m.cap (s.load + bite) else s.load
  { pos := pos
    lane := lane
    vel := v
    fuel := fuel
    load := if lap then 0 else load
    score := if lap then s.score + 10 * load else s.score
    ticks := s.ticks + 1 }

/-- A whole run: the inputs, tick by tick. -/
def run (m : Machine) : List Input → Drive → Drive
  | [], s => s
  | u :: us, s => run m us (tick m u s)

@[simp] theorem run_nil (m : Machine) (s : Drive) : run m [] s = s := rfl

@[simp] theorem run_cons (m : Machine) (u : Input) (us : List Input) (s : Drive) :
    run m (u :: us) s = run m us (tick m u s) := rfl

/-! ## The invariant -/

/-- What is true of a run at every moment: on the lap, on the track, under the
speed limit, with a tank that is not overdrawn and a scoop that is not
overfull. -/
structure Inv (m : Machine) (s : Drive) : Prop where
  /-- The machine is somewhere on the lap. -/
  pos : 0 ≤ s.pos ∧ s.pos < track
  /-- And somewhere on the track. -/
  lane : |s.lane| ≤ laneMax
  /-- Under the speed limit. -/
  vel : |s.vel| ≤ vmax
  /-- The tank is never overdrawn. -/
  fuel : 0 ≤ s.fuel
  /-- The scoop holds something it can hold. -/
  load : 0 ≤ s.load ∧ s.load ≤ m.cap

/-- A run starts inside the invariant. -/
theorem startDrive_inv {m : Machine} (hf : 0 ≤ m.fuelCap) (hc : 0 ≤ m.cap) :
    Inv m (startDrive m) := by
  refine ⟨⟨le_rfl, ?_⟩, ?_, ?_, hf, le_rfl, hc⟩ <;>
    simp [startDrive, track, laneMax, vmax]

/-- **One tick keeps the invariant.** -/
theorem tick_inv {m : Machine} {s : Drive} (hc : 0 ≤ m.cap)
    (u : Input) (h : Inv m s) : Inv m (tick m u s) := by
  obtain ⟨⟨hp0, hp1⟩, hlane, hvel, hfuel, hload0, hload1⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · -- the machine stays on the lap
    simp only [tick]
    have hvb : |clampTo vmax (s.vel +
        ((if 0 < s.fuel then (1:Int) else 0) * (m.power * clampTo 1000 u.throttle).tdiv 1000 -
          (dragK * s.vel + (if u.brake then brakeK * s.vel else 0))).tdiv (totalMass m s))|
        ≤ vmax := abs_clampTo (by norm_num [vmax]) _
    set v := clampTo vmax (s.vel +
        ((if 0 < s.fuel then (1:Int) else 0) * (m.power * clampTo 1000 u.throttle).tdiv 1000 -
          (dragK * s.vel + (if u.brake then brakeK * s.vel else 0))).tdiv (totalMass m s))
      with hvdef
    have hstep : |v.tdiv tickHz| ≤ 800 := by
      refine abs_tdiv_le_of_abs_le (by norm_num [tickHz]) (by norm_num) ?_
      simpa [vmax, tickHz] using hvb
    rw [abs_le] at hstep
    simp only [track] at hp1 ⊢
    split_ifs <;> omega
  · exact abs_clampTo (by norm_num [laneMax]) _
  · exact abs_clampTo (by norm_num [vmax]) _
  · simp only [tick]
    exact le_max_left _ _
  · simp only [tick]
    have hmin : 0 ≤ min m.cap (s.load + bite) ∧ min m.cap (s.load + bite) ≤ m.cap := by
      constructor
      · exact le_min hc (by simp only [bite]; omega)
      · exact min_le_left _ _
    split_ifs <;> simp_all

/-- **A whole run keeps the invariant.** -/
theorem run_inv {m : Machine} (hc : 0 ≤ m.cap) :
    ∀ (us : List Input) {s : Drive}, Inv m s → Inv m (run m us s)
  | [], _, h => h
  | u :: us, _, h => run_inv hc us (tick_inv hc u h)

/-! ## What the numbers do -/

/-- Fuel only ever goes down. -/
theorem tick_fuel_le (m : Machine) (u : Input) (s : Drive) (h : 0 ≤ s.fuel) :
    (tick m u s).fuel ≤ s.fuel := by
  simp only [tick]
  refine max_le h ?_
  have : 0 ≤ (if 0 < s.fuel then (1:Int) else 0) *
      ((if clampTo 1000 u.throttle < 0 then -clampTo 1000 u.throttle
        else clampTo 1000 u.throttle) + 200).tdiv 200 := by
    refine mul_nonneg (by split_ifs <;> norm_num) (Int.tdiv_nonneg ?_ (by norm_num))
    split_ifs with hh
    · omega
    · omega
  omega

/-- The tank never goes negative. -/
theorem tick_fuel_nonneg (m : Machine) (u : Input) (s : Drive) : 0 ≤ (tick m u s).fuel :=
  le_max_left _ _

/-- With the tank dry, the engine makes no thrust. -/
theorem tick_dead_no_drive {m : Machine} {s : Drive} (h : s.fuel ≤ 0) (u : Input) :
    (tick m u s).vel = clampTo vmax (s.vel +
      (-(dragK * s.vel + (if u.brake then brakeK * s.vel else 0))).tdiv (totalMass m s)) := by
  simp only [tick, if_neg (by omega : ¬ 0 < s.fuel)]
  norm_num

/-- The score never goes down. -/
theorem tick_score_le {m : Machine} {s : Drive} (hc : 0 ≤ m.cap) (hl : 0 ≤ s.load) (u : Input) :
    s.score ≤ (tick m u s).score := by
  simp only [tick]
  have hmin : 0 ≤ min m.cap (s.load + bite) := le_min hc (by simp only [bite]; omega)
  split_ifs <;> omega

/-- And it moves only when the line is crossed. -/
theorem tick_score_eq_of_no_lap {m : Machine} {s : Drive} (u : Input)
    (h : ¬ track ≤ s.pos + (tick m u s).vel.tdiv tickHz) :
    (tick m u s).score = s.score := by
  simp only [tick] at h ⊢
  rw [if_neg h]

/-- The clock advances by one. -/
@[simp] theorem tick_ticks (m : Machine) (u : Input) (s : Drive) :
    (tick m u s).ticks = s.ticks + 1 := rfl

/-- A run of `n` ticks takes `n` ticks. -/
theorem run_ticks (m : Machine) : ∀ (us : List Input) (s : Drive),
    (run m us s).ticks = s.ticks + us.length
  | [], s => by simp
  | u :: us, s => by
      rw [run_cons, run_ticks m us, tick_ticks]
      simp only [List.length_cons]
      push_cast
      ring

end Rig
end LifeTrac
