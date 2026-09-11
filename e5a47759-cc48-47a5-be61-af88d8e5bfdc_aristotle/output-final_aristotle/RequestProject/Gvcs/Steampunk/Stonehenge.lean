import RequestProject.Gvcs.Steampunk.Fluidic
import Mathlib

/-!
# Stone circles and gear trains: computing without a substrate that switches

The fluidic controller of `RequestProject/Steampunk/Fluidic.lean` switches.
This file is about the other ancient way of computing — not switching at all,
but *counting in a circle*: a marker moved around a ring of holes, or a train
of toothed wheels.  Both are memory-and-arithmetic devices made of stone and
bronze, and both are exactly as expressive as the periodic phenomenon they are
cut for.

* `ring_computes_periodic` — **what a stone circle is**: every prediction that
  repeats with period `p` is a function of the position of one marker on a ring
  of `p` holes, and conversely.  A ring is a modular register, no more and no
  less.
* `aubrey_full_cycle` — the 56-hole ring stepped three holes a year visits all
  fifty-six holes before repeating, because `gcd(3,56) = 1`; and
  `aubrey_matches_node_regression` — the 56/3 = 18.67 years it takes to come
  back round is the 18.6-year regression of the lunar nodes, to within a
  fifteenth of a year.
* `gearRatio_append` and `lunarTrain_ratio` — a gear train multiplies its stage
  ratios, and the two-stage train with 127/32 and 64/19 tooth counts computes
  exactly `254/19`: the 254 sidereal months in the 19 years of the Metonic
  cycle.
* `metonic_close`, `saros_close` — why those integers: 235 synodic months agree
  with 19 tropical years to under a tenth of a day, and 223 synodic months
  agree with 242 draconic months (the saros, the eclipse repeat) to under a
  twentieth of a day.
* `stoneComputerParts_semiconductor_free` — stone, bronze and hardwood; no
  silicon.

The astronomical constants are definitions in this file, so every numerical
claim below can be traced to the mean period it came from.  Nothing here is a
claim about what any particular monument was *for*.
-/

namespace LifeTrac
namespace Steampunk

/-! ## A ring of holes is a modular register -/

/-- Moving the marker `k` holes round a ring of `n`. -/
def ringStep (n k : ℕ) (x : ZMod n) : ZMod n := x + (k : ZMod n)

theorem ringStep_iterate (n k : ℕ) (x : ZMod n) :
    ∀ t : ℕ, (ringStep n k)^[t] x = x + (t * k : ℕ) := by
  intro t
  induction t with
  | zero => simp
  | succ t ih =>
      rw [Function.iterate_succ_apply', ih, ringStep]
      push_cast
      ring

/-- **What a stone circle computes.**  A prediction repeating with period `p`
is exactly a function of the marker's position on a ring of `p` holes. -/
theorem ring_computes_periodic {α : Type*} (p : ℕ) [NeZero p] (f : ℕ → α)
    (hf : ∀ t, f (t + p) = f t) :
    ∃ g : ZMod p → α, ∀ t, f t = g (t : ZMod p) := by
  refine ⟨fun x => f x.val, fun t => ?_⟩
  have hper : Function.Periodic f p := hf
  show f t = f ((t : ZMod p)).val
  rw [ZMod.val_natCast]
  exact (hper.map_mod_nat t).symm

/-- And conversely: anything read off a ring repeats with the ring's period. -/
theorem ring_periodic {α : Type*} (p : ℕ) (g : ZMod p → α) :
    ∀ t : ℕ, (fun t : ℕ => g (t : ZMod p)) (t + p) = (fun t : ℕ => g (t : ZMod p)) t := by
  intro t
  simp

/-! ## The fifty-six holes -/

/-- Holes in the ring. -/
def aubreyHoles : ℕ := 56

/-- Holes the marker is advanced each year. -/
def aubreyStep : ℕ := 3

/-- **The marker uses the whole ring.**  Three holes a year on fifty-six holes
returns to the start only after fifty-six years, having stood in every hole. -/
theorem aubrey_full_cycle :
    (∀ t ∈ Finset.Ico 1 aubreyHoles, ((t * aubreyStep : ℕ) : ZMod aubreyHoles) ≠ 0) ∧
      ((aubreyHoles * aubreyStep : ℕ) : ZMod aubreyHoles) = 0 := by
  constructor
  · decide
  · decide

/-- One turn of the marker round the ring, in years. -/
def aubreyTurn : ℚ := 56 / 3

/-- The regression period of the lunar nodes, in years: the cycle on which
eclipse seasons — and therefore eclipses — recur. -/
def nodeRegression : ℚ := 186 / 10

/-- **Why three holes a year.**  A turn of the marker is the regression of the
lunar nodes to within a fifteenth of a year. -/
theorem aubrey_matches_node_regression : |aubreyTurn - nodeRegression| < 1 / 14 := by
  rw [abs_lt]
  constructor <;> norm_num [aubreyTurn, nodeRegression]

/-! ## Gear trains -/

/-- The turns of the output per turn of the input, for a train of stages, each
a driver wheel meshing a driven wheel. -/
def gearRatio (l : List (ℕ × ℕ)) : ℚ := (l.map (fun p => (p.1 : ℚ) / p.2)).prod

@[simp] theorem gearRatio_nil : gearRatio [] = 1 := rfl

/-- **Trains compose by multiplication.** -/
theorem gearRatio_append (l₁ l₂ : List (ℕ × ℕ)) :
    gearRatio (l₁ ++ l₂) = gearRatio l₁ * gearRatio l₂ := by
  simp [gearRatio, List.map_append]

/-- A two-stage train: a 127-tooth wheel driven from 32, and 64 driving 19. -/
def lunarTrain : List (ℕ × ℕ) := [(127, 32), (64, 19)]

/-- **The train computes the Metonic lunar count.**  Its ratio is exactly
`254/19` — the 254 sidereal months of the 19-year cycle, per year. -/
theorem lunarTrain_ratio : gearRatio lunarTrain = 254 / 19 := by
  norm_num [gearRatio, lunarTrain]

/-- The 254 sidereal months are the 235 synodic months plus the 19 turns of the
sun: the moon laps the sun once a year. -/
theorem sidereal_eq_synodic_add_years : 235 + 19 = 254 := by norm_num

/-! ## Why those integers -/

/-- Mean synodic month (new moon to new moon), days. -/
def synodicMonth : ℚ := 29530589 / 1000000

/-- Mean draconic month (node to node), days. -/
def draconicMonth : ℚ := 27212221 / 1000000

/-- Mean tropical year, days. -/
def tropicalYear : ℚ := 3652422 / 10000

/-- **The Metonic cycle.**  235 months and 19 years agree to under a tenth of a
day. -/
theorem metonic_close : |235 * synodicMonth - 19 * tropicalYear| < 1 / 10 := by
  rw [abs_lt]
  constructor <;> norm_num [synodicMonth, tropicalYear]

/-- **The saros.**  223 synodic months and 242 draconic months agree to under a
twentieth of a day, which is why eclipses repeat on it. -/
theorem saros_close : |223 * synodicMonth - 242 * draconicMonth| < 1 / 20 := by
  rw [abs_lt]
  constructor <;> norm_num [synodicMonth, draconicMonth]

/-- The saros in days. -/
def sarosDays : ℚ := 223 * synodicMonth

theorem saros_days_bounds : 6585 < sarosDays ∧ sarosDays < 6586 := by
  constructor <;> norm_num [sarosDays, synodicMonth]

/-! ## Several rings at once -/

/-- Two rings, of `m` and `n` holes, turned together, repeat only after
`lcm m n` steps — so coprime rings multiply the reach of the machine. -/
theorem rings_period (m n : ℕ) (x : ZMod m) (y : ZMod n) :
    ((ringStep m 1)^[Nat.lcm m n] x = x) ∧ ((ringStep n 1)^[Nat.lcm m n] y = y) := by
  have hm : ((Nat.lcm m n : ℕ) : ZMod m) = 0 :=
    (ZMod.natCast_eq_zero_iff _ _).2 (Nat.dvd_lcm_left m n)
  have hn : ((Nat.lcm m n : ℕ) : ZMod n) = 0 :=
    (ZMod.natCast_eq_zero_iff _ _).2 (Nat.dvd_lcm_right m n)
  constructor
  · rw [ringStep_iterate]
    simp [hm]
  · rw [ringStep_iterate]
    simp [hn]

/-- A 19-hole Metonic ring and a 223-hole saros ring come back into step only
after 4237 steps. -/
theorem metonic_saros_lcm : Nat.lcm 19 223 = 4237 := by decide

/-! ## What it is made of -/

/-- The parts of a stone-and-bronze calculator. -/
def stoneComputerParts : List Part :=
  [ ⟨"ring of holes", .stone, 1⟩
  , ⟨"marker stone", .stone, 3⟩
  , ⟨"gear blank", .bronze, 8⟩
  , ⟨"arbor", .bronze, 4⟩
  , ⟨"index plate", .bronze, 1⟩
  , ⟨"frame", .hardwood, 1⟩ ]

/-- **No silicon in the calculator either.** -/
theorem stoneComputerParts_semiconductor_free :
    ∀ p ∈ stoneComputerParts, p.mat.semiconductor = false := by
  decide

end Steampunk
end LifeTrac
