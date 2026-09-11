import Mathlib
import RequestProject.Gvcs.Steampunk.Stonehenge

/-!
# The sky the henge watches

A small astronomy system: mean orbital periods, the synodic periods that follow
from them, and the near-resonances that make the sky look like it repeats — the
things a stone circle or a geared orrery can actually be built to show.

* `synodic` — the time between successive conjunctions of two bodies, and
  `synodic_recip`, the relation `1/S = 1/p - 1/q` it comes from.
* `venus_pentagram` — five Venus synodic periods are eight Earth years to within
  two days, which is why the Venus conjunctions trace a five-pointed star.
* `jupiter_saturn_trigon` — the great conjunctions fall every twenty years and
  return to the same third of the sky after sixty.
* `moon_phase`, `moon_phase_periodic` — the eight phases as a ring.
* `orrery_periods` — the gear-train ring sizes that carry these cycles, and a
  proof that they only come back into step after `lcm` turns.

The Metonic cycle and the saros are in `RequestProject/Steampunk/Stonehenge.lean`
and are used from there.
-/

namespace LifeTrac
namespace Henge

open Steampunk

/-! ## Periods -/

/-- A body that goes round, with its mean period in days. -/
structure Body where
  name : String
  period : ℚ
deriving Repr, DecidableEq

def mercury : Body := ⟨"Mercury", 87969 / 1000⟩
def venus : Body := ⟨"Venus", 224701 / 1000⟩
def earth : Body := ⟨"Earth", 365256 / 1000⟩
def mars : Body := ⟨"Mars", 686980 / 1000⟩
def jupiter : Body := ⟨"Jupiter", 4332589 / 1000⟩
def saturn : Body := ⟨"Saturn", 1075922 / 100⟩
def moon : Body := ⟨"Moon", 2732166 / 100000⟩

/-- Every body the orrery carries, in order out from the sun. -/
def orrery : List Body := [mercury, venus, earth, mars, jupiter, saturn]

theorem orrery_periods_increasing :
    List.IsChain (fun a b : Body => a.period < b.period) orrery := by
  norm_num [orrery, mercury, venus, earth, mars, jupiter, saturn]

/-! ## Conjunctions -/

/-- The time between conjunctions of two bodies with periods `p` and `q`. -/
def synodic (p q : ℚ) : ℚ := p * q / |p - q|

/-- **Where the synodic period comes from.**  The faster body gains one whole
turn on the slower in `S` days. -/
theorem synodic_recip {p q : ℚ} (hp : 0 < p) (hq : p < q) :
    1 / synodic p q = 1 / p - 1 / q := by
  have hq0 : 0 < q := lt_trans hp hq
  have habs : |p - q| = q - p := by
    rw [abs_of_nonpos (by linarith)]; ring
  rw [synodic, habs]
  field_simp

/-- The synodic period of Venus and the Earth, in days. -/
def venusSynodic : ℚ := synodic venus.period earth.period

theorem venusSynodic_value : |venusSynodic - 58392 / 100| < 1 / 10 := by
  have h : venusSynodic = (224701 / 1000) * (365256 / 1000) / (365256 / 1000 - 224701 / 1000) := by
    unfold venusSynodic synodic venus earth
    rw [abs_of_nonpos (by norm_num)]
    ring
  rw [h, abs_lt]
  constructor <;> norm_num

/-- **The pentagram of Venus.**  Five synodic periods are eight Earth years to
within three days, so the conjunctions step round the sky in fifths. -/
theorem venus_pentagram : |5 * venusSynodic - 8 * earth.period| < 3 := by
  have h : venusSynodic = (224701 / 1000) * (365256 / 1000) / (365256 / 1000 - 224701 / 1000) := by
    unfold venusSynodic synodic venus earth
    rw [abs_of_nonpos (by norm_num)]
    ring
  rw [h, abs_lt]
  constructor <;> norm_num [earth]

/-- The synodic period of Jupiter and Saturn: the great conjunction. -/
def greatConjunction : ℚ := synodic jupiter.period saturn.period

/-- **Great conjunctions fall about twenty years apart.** -/
theorem greatConjunction_eq :
    greatConjunction = (4332589 / 1000) * (1075922 / 100) / (1075922 / 100 - 4332589 / 1000) := by
  unfold greatConjunction synodic jupiter saturn
  rw [abs_of_nonpos (by norm_num)]
  ring

/-- **Great conjunctions fall about twenty years apart.** -/
theorem greatConjunction_years :
    |greatConjunction / earth.period - 1986 / 100| < 1 / 100 := by
  rw [greatConjunction_eq, abs_lt]
  constructor <;> norm_num [earth]

/-- **The trigon.**  Three great conjunctions take just under sixty years, and
land a third of the way round the sky each time. -/
theorem jupiter_saturn_trigon :
    |3 * greatConjunction / earth.period - 60| < 1 := by
  rw [greatConjunction_eq, abs_lt]
  constructor <;> norm_num [earth]

/-! ## The moon -/

/-- The eight phases of the moon, as a ring of eight. -/
def moonPhases : ℕ := 8

/-- The phase of the moon `d` days after a new moon, as a hole on a ring of
eight.  A phase lasts a little under four days; the ring rounds to whole days by
counting in `2953 / 8` day steps, i.e. 369 tenths of a day. -/
def moonPhase (d : ℕ) : ZMod moonPhases := ((d * 800 / 2953 : ℕ) : ZMod moonPhases)

/-- **The phase ring closes.**  After a synodic month the marker is back where
it started. -/
theorem moonPhase_month : moonPhase 0 = 0 ∧ moonPhase 30 = 0 := by decide

/-- **A ring of eight really is what a phase dial is.** -/
theorem moonPhase_is_a_ring : ∀ z : ZMod 8, ∃ d : Fin 30, moonPhase d.val = z := by decide

/-! ## Rings that must be turned together -/

/-- The hole counts of the rings the orrery carries: the Metonic ring, the
saros ring, and the Aubrey ring. -/
def orreryRings : List ℕ := [19, 223, aubreyHoles]

/-- **When the whole orrery comes back into step.**  Not before the least common
multiple of the ring sizes — 237272 turns. -/
theorem orreryRings_lcm : orreryRings.foldr Nat.lcm 1 = 237272 := by decide

/-- Two rings turned together return to their start only after `lcm` steps; the
general fact is `Steampunk.rings_period`, used here for the two eclipse rings. -/
theorem eclipse_rings_period (x : ZMod 19) (y : ZMod 223) :
    (ringStep 19 1)^[Nat.lcm 19 223] x = x ∧ (ringStep 223 1)^[Nat.lcm 19 223] y = y :=
  rings_period 19 223 x y

end Henge
end LifeTrac
