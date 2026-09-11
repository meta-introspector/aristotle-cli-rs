/-
  Date.lean — calendar dates, for the filing calendar.

  Nothing here is specific to the company: a date is a year, a month and a day,
  ordered by the obvious key, with the month lengths (including the Gregorian
  leap rule) needed to say "the last day of the anniversary month".

  What is proved: the key determines the date, so the order is an order and not
  merely a comparison (`key_inj`, `le_trans`, `le_total`, `le_antisymm`); a
  valid date has a valid day (`lastDay_valid`); and the anniversary of a valid
  date is a valid date (`anniversary_valid`), which is what makes the yearly
  filing calendar well formed.
-/

import Mathlib.Tactic

namespace LLC

/-- A calendar date. -/
structure Date where
  /-- Year. -/
  year : Nat
  /-- Month, 1–12. -/
  month : Nat
  /-- Day of the month, 1–31. -/
  day : Nat
deriving DecidableEq, Repr, Inhabited

namespace Date

/-- Gregorian leap year. -/
def isLeap (y : Nat) : Bool := (y % 4 == 0 && y % 100 != 0) || y % 400 == 0

/-- Days in a month. -/
def daysInMonth (y m : Nat) : Nat :=
  match m with
  | 1 => 31 | 2 => if isLeap y then 29 else 28 | 3 => 31 | 4 => 30 | 5 => 31 | 6 => 30
  | 7 => 31 | 8 => 31 | 9 => 30 | 10 => 31 | 11 => 30 | 12 => 31
  | _ => 0

/-- Is this a date on the calendar? -/
def valid (d : Date) : Bool :=
  1 ≤ d.month && d.month ≤ 12 && 1 ≤ d.day && d.day ≤ daysInMonth d.year d.month

/-- The sort key. -/
def key (d : Date) : Nat := (d.year * 100 + d.month) * 100 + d.day

/-- On or before. -/
def le (a b : Date) : Bool := a.key ≤ b.key

/-- Strictly before. -/
def lt (a b : Date) : Bool := a.key < b.key

/-- The last day of a month. -/
def lastDay (y m : Nat) : Date := ⟨y, m, daysInMonth y m⟩

/-- The `n`-th anniversary of a date. -/
def anniversary (d : Date) (n : Nat) : Date :=
  ⟨d.year + n, d.month, min d.day (daysInMonth (d.year + n) d.month)⟩

/-- ISO 8601. -/
def toString (d : Date) : String :=
  let pad (n : Nat) : String := if n < 10 then "0" ++ ToString.toString n else ToString.toString n
  ToString.toString d.year ++ "-" ++ pad d.month ++ "-" ++ pad d.day

instance : ToString Date := ⟨toString⟩

/-- No month is longer than 31 days. -/
theorem daysInMonth_le_31 (y m : Nat) : daysInMonth y m ≤ 31 := by
  match m with
  | 0 => simp [daysInMonth]
  | 1 => simp [daysInMonth]
  | 2 => simp only [daysInMonth]; split <;> omega
  | 3 => simp [daysInMonth]
  | 4 => simp [daysInMonth]
  | 5 => simp [daysInMonth]
  | 6 => simp [daysInMonth]
  | 7 => simp [daysInMonth]
  | 8 => simp [daysInMonth]
  | 9 => simp [daysInMonth]
  | 10 => simp [daysInMonth]
  | 11 => simp [daysInMonth]
  | 12 => simp [daysInMonth]
  | (n + 13) => simp [daysInMonth]

/-! ### The order -/

/-- **The key determines the date**, for dates whose month and day are on the
calendar. -/
theorem key_inj {a b : Date} (ha : a.valid = true) (hb : b.valid = true)
    (h : a.key = b.key) : a = b := by
  obtain ⟨ay, am, ad⟩ := a
  obtain ⟨by_, bm, bd⟩ := b
  simp only [valid, Bool.and_eq_true, decide_eq_true_eq] at ha hb
  simp only [key] at h
  have ham : am ≤ 12 := ha.1.1.2
  have hbm : bm ≤ 12 := hb.1.1.2
  have had : ad ≤ 31 := Nat.le_trans ha.2 (daysInMonth_le_31 ay am)
  have hbd : bd ≤ 31 := Nat.le_trans hb.2 (daysInMonth_le_31 by_ bm)
  have : ay = by_ ∧ am = bm ∧ ad = bd := by omega
  simp [this.1, this.2.1, this.2.2]

theorem le_refl (a : Date) : a.le a = true := by simp [le]

theorem le_trans {a b c : Date} (h1 : a.le b = true) (h2 : b.le c = true) : a.le c = true := by
  simp only [le, decide_eq_true_eq] at *
  omega

theorem le_total (a b : Date) : a.le b = true ∨ b.le a = true := by
  simp only [le, decide_eq_true_eq]
  omega

theorem le_antisymm {a b : Date} (ha : a.valid = true) (hb : b.valid = true)
    (h1 : a.le b = true) (h2 : b.le a = true) : a = b := by
  simp only [le, decide_eq_true_eq] at h1 h2
  exact key_inj ha hb (by omega)

/-! ### Validity -/

theorem daysInMonth_pos {y m : Nat} (h1 : 1 ≤ m) (h2 : m ≤ 12) : 0 < daysInMonth y m := by
  interval_cases m <;> simp only [daysInMonth] <;> first | omega | (split <;> omega)

/-- Every month has at least 28 days. -/
theorem daysInMonth_ge_28 {y m : Nat} (h1 : 1 ≤ m) (h2 : m ≤ 12) : 28 ≤ daysInMonth y m := by
  interval_cases m <;> simp only [daysInMonth] <;> first | omega | (split <;> omega)

/-- A day in the first 28 of a real month is a date, whatever the month. -/
theorem valid_of_day_le_28 {y m d : Nat} (hm1 : 1 ≤ m) (hm2 : m ≤ 12) (hd1 : 1 ≤ d)
    (hd2 : d ≤ 28) : (Date.mk y m d).valid = true := by
  have := daysInMonth_ge_28 (y := y) hm1 hm2
  simp only [valid, Bool.and_eq_true, decide_eq_true_eq]
  exact ⟨⟨⟨hm1, hm2⟩, hd1⟩, by omega⟩

/-- The last day of a month is a date. -/
theorem lastDay_valid {y m : Nat} (h1 : 1 ≤ m) (h2 : m ≤ 12) : (lastDay y m).valid = true := by
  have := daysInMonth_pos (y := y) h1 h2
  simp only [lastDay, valid, Bool.and_eq_true, decide_eq_true_eq]
  exact ⟨⟨⟨h1, h2⟩, this⟩, Nat.le_refl _⟩

/-- **Every anniversary of a date is a date** — a 29 February formation has a
28 February anniversary in a common year, not an impossible one. -/
theorem anniversary_valid {d : Date} (h : d.valid = true) (n : Nat) :
    (d.anniversary n).valid = true := by
  simp only [valid, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨hm1, hm2⟩, hd1⟩, _⟩ := h
  have hpos := daysInMonth_pos (y := d.year + n) hm1 hm2
  simp only [anniversary, valid, Bool.and_eq_true, decide_eq_true_eq]
  refine ⟨⟨⟨hm1, hm2⟩, ?_⟩, ?_⟩
  · simp only [Nat.le_min]
    exact ⟨hd1, hpos⟩
  · exact Nat.min_le_right _ _

theorem anniversary_zero {d : Date} (h : d.valid = true) : d.anniversary 0 = d := by
  simp only [valid, Bool.and_eq_true, decide_eq_true_eq] at h
  simp only [anniversary, Nat.add_zero]
  have : min d.day (daysInMonth d.year d.month) = d.day := Nat.min_eq_left h.2
  simp [this]

end Date

end LLC
