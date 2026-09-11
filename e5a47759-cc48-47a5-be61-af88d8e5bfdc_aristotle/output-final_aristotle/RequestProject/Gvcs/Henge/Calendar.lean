import Mathlib
import RequestProject.Gvcs.Steampunk.Stonehenge

/-!
# The henge calendar

A stone circle is a calendar you can walk into.  This file builds the calendar
the circle keeps, and proves that it is a calendar: that counting days forward
from the first midwinter and naming a day by *(year, day of year)* are inverse
operations.

* `yearLength` — 365 days, 366 when the year is a leap year.
* `yearsFrom y n` — the days in the `n` years beginning with year `y`.
* `absDay y d` — the day number of the `d`-th day of year `y`.
* `dateOf n` — the date of day number `n`, found by walking years off the front.
* `absDay_dateOf`, `dateOf_absDay` — the two directions of the round trip.
* `yearsFrom_four_hundred` — every four hundred consecutive years hold exactly
  146097 days, so the calendar is exactly periodic and a stone ring can carry it.

The astronomy the circle actually watches — the Aubrey ring, the Metonic cycle,
the saros — is in `RequestProject/Steampunk/Stonehenge.lean`; this file uses it
rather than repeating it.
-/

namespace LifeTrac
namespace Henge

open Steampunk

/-! ## Years -/

/-- The leap rule: every fourth year, except centuries, except every fourth
century. -/
def isLeap (y : ℕ) : Bool := (y % 4 == 0 && y % 100 != 0) || y % 400 == 0

/-- Days in year `y`. -/
def yearLength (y : ℕ) : ℕ := if isLeap y then 366 else 365

theorem yearLength_pos (y : ℕ) : 0 < yearLength y := by
  unfold yearLength; split <;> norm_num

theorem yearLength_ge (y : ℕ) : 365 ≤ yearLength y := by
  unfold yearLength; split <;> norm_num

theorem yearLength_le (y : ℕ) : yearLength y ≤ 366 := by
  unfold yearLength; split <;> norm_num

/-- **The leap rule repeats every four hundred years.** -/
theorem isLeap_periodic (y : ℕ) : isLeap (y + 400) = isLeap y := by
  unfold isLeap
  have h4 : (y + 400) % 4 = y % 4 := by omega
  have h100 : (y + 400) % 100 = y % 100 := by omega
  have h400 : (y + 400) % 400 = y % 400 := by omega
  rw [h4, h100, h400]

theorem yearLength_periodic (y : ℕ) : yearLength (y + 400) = yearLength y := by
  unfold yearLength; rw [isLeap_periodic]

/-! ## Counting days -/

/-- The number of days in the `n` years starting with year `y`. -/
def yearsFrom : ℕ → ℕ → ℕ
  | _, 0 => 0
  | y, (n + 1) => yearLength y + yearsFrom (y + 1) n

@[simp] theorem yearsFrom_zero (y : ℕ) : yearsFrom y 0 = 0 := rfl

theorem yearsFrom_succ (y n : ℕ) : yearsFrom y (n + 1) = yearLength y + yearsFrom (y + 1) n := rfl

@[simp] theorem yearsFrom_one (y : ℕ) : yearsFrom y 1 = yearLength y := rfl

/-- Counting years is additive: `m` years then `n` more. -/
theorem yearsFrom_add (y m n : ℕ) : yearsFrom y (m + n) = yearsFrom y m + yearsFrom (y + m) n := by
  induction m generalizing y with
  | zero => simp
  | succ m ih =>
      have : y + 1 + m = y + (m + 1) := by omega
      rw [show m + 1 + n = (m + n) + 1 by omega, yearsFrom_succ, yearsFrom_succ, ih, this,
        Nat.add_assoc]

theorem yearsFrom_mono (y : ℕ) {m n : ℕ} (h : m ≤ n) : yearsFrom y m ≤ yearsFrom y n := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le h
  rw [yearsFrom_add]; exact Nat.le_add_right _ _

theorem yearsFrom_lt_succ (y n : ℕ) : yearsFrom y n < yearsFrom y (n + 1) := by
  have hp := yearLength_pos (y + n)
  rw [yearsFrom_add]
  simp only [yearsFrom_succ, yearsFrom_zero, Nat.add_zero]
  omega

theorem yearsFrom_strictMono (y : ℕ) {m n : ℕ} (h : m < n) : yearsFrom y m < yearsFrom y n :=
  lt_of_lt_of_le (yearsFrom_lt_succ y m) (yearsFrom_mono y h)

set_option maxRecDepth 4000 in
/-- Four hundred years from the first midwinter hold 146097 days. -/
theorem yearsFrom_zero_four_hundred : yearsFrom 0 400 = 146097 := by decide

/-- **The calendar is exactly four-hundred-year periodic.**  *Any* four hundred
consecutive years hold 146097 days — so the ring of years closes, and a stone
circle can be marked with it once and for all. -/
theorem yearsFrom_four_hundred (y : ℕ) : yearsFrom y 400 = 146097 := by
  induction y with
  | zero => exact yearsFrom_zero_four_hundred
  | succ y ih =>
      have h1 : yearsFrom y (400 + 1) = yearsFrom y 400 + yearLength (y + 400) := by
        rw [yearsFrom_add, yearsFrom_one]
      have h2 : yearsFrom y (1 + 400) = yearLength y + yearsFrom (y + 1) 400 := by
        rw [yearsFrom_add, yearsFrom_one]
      have h3 : yearLength (y + 400) = yearLength y := yearLength_periodic y
      rw [show (400 : ℕ) + 1 = 1 + 400 by omega] at h1
      omega

/-- The mean length of a calendar year, in days: `146097 / 400`. -/
def meanYear : ℚ := 146097 / 400

/-- **The calendar tracks the sun.**  Its mean year is within half a minute of
the tropical year. -/
theorem meanYear_close : |meanYear - tropicalYear| < 1 / 2000 := by
  unfold meanYear tropicalYear
  rw [abs_lt]
  constructor <;> norm_num

/-! ## Dates -/

/-- Walk whole years off the front of a day count. -/
def dateOfFuel : ℕ → ℕ → ℕ → ℕ × ℕ
  | 0, y, d => (y, d)
  | f + 1, y, d => if d < yearLength y then (y, d) else dateOfFuel f (y + 1) (d - yearLength y)

/-- The date of day number `n`, counting from the first midwinter. -/
def dateOf (n : ℕ) : ℕ × ℕ := dateOfFuel n 0 n

/-- The day number of the `d`-th day of year `y`. -/
def absDay (y d : ℕ) : ℕ := yearsFrom 0 y + d

/-- The walk lands on a real date, and loses nothing. -/
theorem dateOfFuel_spec :
    ∀ (f y d : ℕ), d ≤ f → ∃ k, (dateOfFuel f y d) = (y + k, d - yearsFrom y k) ∧
      yearsFrom y k ≤ d ∧ d - yearsFrom y k < yearLength (y + k) := by
  intro f
  induction f with
  | zero =>
      intro y d hd
      have hp := yearLength_pos y
      refine ⟨0, ?_, ?_, ?_⟩
      · simp [dateOfFuel]
      · simp
      · simp only [yearsFrom_zero, Nat.sub_zero, Nat.add_zero]
        omega
  | succ f ih =>
      intro y d hd
      by_cases h : d < yearLength y
      · refine ⟨0, ?_, ?_, ?_⟩
        · simp [dateOfFuel, h]
        · simp
        · simpa using h
      · have hlen := yearLength_pos y
        have hd' : d - yearLength y ≤ f := by omega
        obtain ⟨k, hk, hle, hlt⟩ := ih (y + 1) (d - yearLength y) hd'
        refine ⟨k + 1, ?_, ?_, ?_⟩
        · rw [dateOfFuel, if_neg h, hk]
          have hy : y + 1 + k = y + (k + 1) := by omega
          have : d - yearLength y - yearsFrom (y + 1) k = d - yearsFrom y (k + 1) := by
            rw [yearsFrom_succ]; omega
          rw [hy, this]
        · rw [yearsFrom_succ]; omega
        · have hy : y + 1 + k = y + (k + 1) := by omega
          rw [yearsFrom_succ]
          rw [hy] at hlt
          have : d - (yearLength y + yearsFrom (y + 1) k) = d - yearLength y - yearsFrom (y+1) k := by
            omega
          rw [this]
          exact hlt

/-- The day of year a date names is a real day of that year. -/
theorem dateOf_valid (n : ℕ) : (dateOf n).2 < yearLength (dateOf n).1 := by
  obtain ⟨k, hk, _, hlt⟩ := dateOfFuel_spec n 0 n (le_refl n)
  rw [dateOf, hk]
  exact hlt

/-- **Reading the circle inverts counting the days.** -/
theorem absDay_dateOf (n : ℕ) : absDay (dateOf n).1 (dateOf n).2 = n := by
  obtain ⟨k, hk, hle, _⟩ := dateOfFuel_spec n 0 n (le_refl n)
  rw [dateOf, hk]
  simp only [absDay, Nat.zero_add]
  omega

/-- A day number determines its date. -/
theorem absDay_inj {y d y' d' : ℕ} (h : d < yearLength y) (h' : d' < yearLength y')
    (heq : absDay y d = absDay y' d') : y = y' ∧ d = d' := by
  have key : ∀ a b c e : ℕ, e < yearLength b → absDay a c = absDay b e → a ≤ b := by
    intro a b c e he habs
    by_contra hab
    have hb : b + 1 ≤ a := by omega
    have h1 : yearsFrom 0 (b + 1) ≤ yearsFrom 0 a := yearsFrom_mono 0 hb
    have h2 : yearsFrom 0 (b + 1) = yearsFrom 0 b + yearLength b := by
      rw [yearsFrom_add, yearsFrom_one, Nat.zero_add]
    simp only [absDay] at habs
    omega
  have hle : y ≤ y' := key y y' d d' h' heq
  have hge : y' ≤ y := key y' y d' d h heq.symm
  have hyy : y = y' := le_antisymm hle hge
  subst hyy
  simp only [absDay] at heq
  exact ⟨rfl, by omega⟩

/-- **Counting the days inverts reading the circle.** -/
theorem dateOf_absDay {y d : ℕ} (h : d < yearLength y) : dateOf (absDay y d) = (y, d) := by
  have hv := dateOf_valid (absDay y d)
  have ha := absDay_dateOf (absDay y d)
  obtain ⟨h1, h2⟩ := absDay_inj hv h ha
  exact Prod.ext h1 h2

/-! ## What the circle is for -/

/-- The four quarters of the henge year.  The year begins at midwinter
sunrise: the day the sun rises furthest to the south-east. -/
inductive Quarter
  | midwinter | spring | midsummer | autumn
deriving DecidableEq, Repr

/-- The quarter a day of year falls in. -/
def quarterOf (y d : ℕ) : Quarter :=
  let L := yearLength y
  if d < L / 4 then .midwinter
  else if d < L / 2 then .spring
  else if d < 3 * L / 4 then .midsummer
  else .autumn

@[simp] theorem quarterOf_zero (y : ℕ) : quarterOf y 0 = Quarter.midwinter := by
  have h := yearLength_ge y
  have h4 : 0 < yearLength y / 4 := by omega
  simp only [quarterOf, if_pos h4]

/-- The Aubrey marker after `y` years: three holes a year on a ring of 56. -/
def aubreyMarker (y : ℕ) : ZMod aubreyHoles := (aubreyStep * y : ℕ)

set_option maxRecDepth 10000 in
/-- **The marker never repeats before the ring is spent.**  Fifty-six years of
three-hole steps visit all fifty-six holes. -/
theorem aubreyMarker_full :
    ∀ z : ZMod 56, ∃ y : Fin 56, aubreyMarker y.val = z := by
  decide

end Henge
end LifeTrac
