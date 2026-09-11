import Mathlib
import RequestProject.Gvcs.Henge.Calendar

/-!
# The clock tower

The henge tells you the day; the tower tells you the hour.  This file models the
tower as a seconds pendulum driving a gear train, and proves the things a
clockmaker has to get right.

* `Tod` — the time of day read off a tick count, and `tod_periodic`: the dial
  closes after 86400 ticks.
* `tod_roundTrip` — hours, minutes and seconds name the tick uniquely.
* `clockTrain`, `clockTrain_ratio` — the train from the escape wheel to the hour
  hand turns 1/720 of a turn per turn of the seconds arbor.
* `hands_coincide_iff` and `coincidences_card` — the hour and minute hands meet
  exactly eleven times in twelve hours, and nowhere else.
* `chimes_in_a_day` — the bell is struck 156 times a day.
* `tower_and_henge_agree` — tick `n` falls on henge date `dateOf (n / 86400)`.
-/

namespace LifeTrac
namespace Henge

open Steampunk

/-! ## The dial -/

/-- Seconds in a day. -/
def secondsPerDay : ℕ := 86400

/-- Seconds in the twelve hours of one turn of the hour hand. -/
def secondsPerTurn : ℕ := 43200

/-- A reading of the tower dial. -/
structure Tod where
  hour : ℕ
  minute : ℕ
  second : ℕ
deriving DecidableEq, Repr

/-- The reading after `n` ticks of the seconds pendulum. -/
def tod (n : ℕ) : Tod :=
  { hour := (n / 3600) % 24, minute := (n / 60) % 60, second := n % 60 }

/-- The tick, within the day, that a reading names. -/
def todTick (t : Tod) : ℕ := t.hour * 3600 + t.minute * 60 + t.second

/-- A reading is on the dial when its fields are in range. -/
def TodValid (t : Tod) : Prop := t.hour < 24 ∧ t.minute < 60 ∧ t.second < 60

instance (t : Tod) : Decidable (TodValid t) := inferInstanceAs (Decidable (_ ∧ _ ∧ _))

@[simp] theorem tod_valid (n : ℕ) : TodValid (tod n) := by
  refine ⟨?_, ?_, ?_⟩ <;> simp [tod] <;> omega

/-- **The dial closes.**  The tower reads the same at the same time each day. -/
theorem tod_periodic (n : ℕ) : tod (n + secondsPerDay) = tod n := by
  have h1 : (n + secondsPerDay) / 3600 % 24 = n / 3600 % 24 := by
    unfold secondsPerDay; omega
  have h2 : (n + secondsPerDay) / 60 % 60 = n / 60 % 60 := by
    unfold secondsPerDay; omega
  have h3 : (n + secondsPerDay) % 60 = n % 60 := by unfold secondsPerDay; omega
  simp [tod, h1, h2, h3]

/-- **The dial is honest.**  Within a day, the reading determines the tick. -/
theorem todTick_tod {n : ℕ} (h : n < secondsPerDay) : todTick (tod n) = n := by
  simp only [todTick, tod, secondsPerDay] at *
  omega

/-- And every valid reading is reached. -/
theorem tod_todTick {t : Tod} (h : TodValid t) : tod (todTick t) = t := by
  obtain ⟨h1, h2, h3⟩ := h
  unfold tod todTick
  have e1 : (t.hour * 3600 + t.minute * 60 + t.second) / 3600 % 24 = t.hour := by omega
  have e2 : (t.hour * 3600 + t.minute * 60 + t.second) / 60 % 60 = t.minute := by omega
  have e3 : (t.hour * 3600 + t.minute * 60 + t.second) % 60 = t.second := by omega
  rw [e1, e2, e3]

/-- The reading and the tick are two names for the same thing. -/
theorem tod_roundTrip {n m : ℕ} (hn : n < secondsPerDay) (hm : m < secondsPerDay)
    (h : tod n = tod m) : n = m := by
  have := todTick_tod hn
  have := todTick_tod hm
  rw [← todTick_tod hn, ← todTick_tod hm, h]

/-! ## The train -/

/-- The train from the seconds arbor to the hour hand: sixty to one, then twelve
to one. -/
def clockTrain : List (ℕ × ℕ) := [(1, 60), (1, 12)]

/-- **The hour hand turns once in twelve hours.** -/
theorem clockTrain_ratio : gearRatio clockTrain = 1 / 720 := by
  norm_num [gearRatio, clockTrain]

/-- The escapement train, extended by the calendar wheel that steps the henge
marker once a day. -/
def calendarTrain : List (ℕ × ℕ) := clockTrain ++ [(1, 2)]

/-- **The calendar wheel turns once a day.** -/
theorem calendarTrain_ratio : gearRatio calendarTrain = 1 / 1440 := by
  norm_num [gearRatio, calendarTrain, clockTrain]

/-! ## When the hands meet -/

/-- The hour hand's position, in turns, `t` hours after twelve. -/
def hourTurns (t : ℚ) : ℚ := t / 12

/-- The minute hand's position, in turns, `t` hours after twelve. -/
def minuteTurns (t : ℚ) : ℚ := t

/-- The hands are together when their positions differ by a whole turn. -/
def HandsMeet (t : ℚ) : Prop := ∃ k : ℤ, minuteTurns t - hourTurns t = (k : ℚ)

/-- **Eleven meetings, and no more.**  In the twelve hours from noon the hands
lie together exactly at the times `12k/11`, for `k = 0, …, 10`. -/
theorem hands_meet_iff {t : ℚ} (h0 : 0 ≤ t) (h12 : t < 12) :
    HandsMeet t ↔ ∃ k : ℕ, k < 11 ∧ t = 12 * k / 11 := by
  constructor
  · rintro ⟨k, hk⟩
    have hkt : (k : ℚ) = 11 * t / 12 := by
      rw [← hk]; unfold minuteTurns hourTurns; ring
    have hk0 : (0 : ℚ) ≤ (k : ℚ) := by rw [hkt]; positivity
    have hk11 : (k : ℚ) < 11 := by
      rw [hkt]
      linarith
    have hkz : 0 ≤ k := by exact_mod_cast hk0
    have hkz' : k < 11 := by exact_mod_cast hk11
    refine ⟨k.toNat, by omega, ?_⟩
    have : ((k.toNat : ℤ) : ℚ) = (k : ℚ) := by
      rw [Int.toNat_of_nonneg hkz]
    push_cast at this ⊢
    rw [this, hkt]
    ring
  · rintro ⟨k, hk, rfl⟩
    exact ⟨k, by unfold minuteTurns hourTurns; push_cast; ring⟩

/-- The eleven meeting times, listed. -/
def meetingTimes : List ℚ := (List.range 11).map (fun k : ℕ => 12 * (k : ℚ) / 11)

theorem meetingTimes_length : meetingTimes.length = 11 := by simp [meetingTimes]

theorem meetingTimes_nodup : meetingTimes.Nodup := by
  have hinj : Function.Injective (fun k : ℕ => 12 * (k : ℚ) / 11) := by
    intro a b hab
    simp only [] at hab
    field_simp at hab
    exact_mod_cast hab
  exact List.Nodup.map hinj List.nodup_range

/-- **The hands meet eleven times in twelve hours.** -/
theorem hands_meet_count :
    ∀ t : ℚ, 0 ≤ t → t < 12 → (HandsMeet t ↔ t ∈ meetingTimes) := by
  intro t h0 h12
  rw [hands_meet_iff h0 h12]
  constructor
  · rintro ⟨k, hk, rfl⟩
    exact List.mem_map.2 ⟨k, List.mem_range.2 hk, rfl⟩
  · intro hm
    obtain ⟨k, hk, rfl⟩ := List.mem_map.1 hm
    exact ⟨k, List.mem_range.1 hk, rfl⟩

/-! ## The bell -/

/-- Strikes at the `h`-th hour of the dial: twelve at noon, one at one. -/
def chimesAt (h : ℕ) : ℕ := if h % 12 == 0 then 12 else h % 12

/-- **Then bell is struck 156 times a day.** -/
theorem chimes_in_a_day : ((List.range 24).map chimesAt).sum = 156 := by decide

/-- **And 78 times in a turn of the hour hand.** -/
theorem chimes_in_a_turn : ((List.range 12).map chimesAt).sum = 78 := by decide

/-! ## The tower and the circle -/

/-- The henge date that tick `n` falls on. -/
def tickDate (n : ℕ) : ℕ × ℕ := dateOf (n / secondsPerDay)

/-- **The tower never disagrees with the circle.**  Ticks within one day of each
other that share a day number share a date, and the date is the one the circle
shows. -/
theorem tower_and_henge_agree (n : ℕ) :
    absDay (tickDate n).1 (tickDate n).2 = n / secondsPerDay :=
  absDay_dateOf _

/-- **A day of ticks is a day of the calendar.** -/
theorem tickDate_shift (n : ℕ) : tickDate (n + secondsPerDay) = dateOf (n / secondsPerDay + 1) := by
  unfold tickDate secondsPerDay
  congr 1
  omega

end Henge
end LifeTrac
