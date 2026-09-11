import Mathlib

/-!
# Touch input, part 1: screen geometry and gesture recognition

This is the first file of the *mobile input layer*: the part of the site that
turns a finger on a phone screen into the same events a keyboard and a mouse
would produce.  Everything here is integer arithmetic on screen pixels, so
every definition is computable and every check the page performs is a `decide`
away.

* `Pt` is a screen point and `Rect` an axis-aligned screen rectangle, with the
  half-open convention `x ≤ px < x + w` used by every hit test on the page.
* `Trace` is one finger's journey: where it went down, where it came up, and
  how long it was held.
* `recognize` classifies a trace as a tap, a long press, one of the four
  swipes, or a free drag, against a `GestureCfg` of thresholds.

The recogniser is proved to be *translation invariant* (a swipe is a swipe
wherever on the screen you make it), to *reverse* when the trace is reversed,
to *mirror* when the screen is mirrored, and to fire a directional swipe only
when the finger really did travel that far in that direction.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Touch

/-! ## Points and rectangles -/

/-- A point on the screen, in CSS pixels; `y` grows **downwards**. -/
structure Pt where
  x : Int
  y : Int
deriving DecidableEq, Repr, Inhabited

@[ext] theorem Pt.ext {p q : Pt} (hx : p.x = q.x) (hy : p.y = q.y) : p = q := by
  cases p; cases q; simp_all

/-- An axis-aligned rectangle: origin `(x,y)`, width `w`, height `h`. -/
structure Rect where
  x : Int
  y : Int
  w : Int
  h : Int
deriving DecidableEq, Repr, Inhabited

/-- Half-open containment: `x ≤ px < x + w` and `y ≤ py < y + h`. -/
def Rect.contains (r : Rect) (p : Pt) : Bool :=
  decide (r.x ≤ p.x) && decide (p.x < r.x + r.w) &&
  decide (r.y ≤ p.y) && decide (p.y < r.y + r.h)

/-- Two rectangles overlap when they overlap in both axes. -/
def Rect.overlaps (a b : Rect) : Bool :=
  decide (a.x < b.x + b.w) && decide (b.x < a.x + a.w) &&
  decide (a.y < b.y + b.h) && decide (b.y < a.y + a.h)

/-- `b` is contained in `a`. -/
def Rect.inside (a b : Rect) : Bool :=
  decide (a.x ≤ b.x) && decide (b.x + b.w ≤ a.x + a.w) &&
  decide (a.y ≤ b.y) && decide (b.y + b.h ≤ a.y + a.h)

/-- Translate a rectangle. -/
def Rect.shift (r : Rect) (dx dy : Int) : Rect := ⟨r.x + dx, r.y + dy, r.w, r.h⟩

@[simp] theorem Rect.contains_iff (r : Rect) (p : Pt) :
    r.contains p = true ↔ r.x ≤ p.x ∧ p.x < r.x + r.w ∧ r.y ≤ p.y ∧ p.y < r.y + r.h := by
  simp [Rect.contains, and_assoc]

@[simp] theorem Rect.overlaps_iff (a b : Rect) :
    a.overlaps b = true ↔ a.x < b.x + b.w ∧ b.x < a.x + a.w ∧ a.y < b.y + b.h ∧ b.y < a.y + a.h := by
  simp [Rect.overlaps, and_assoc]

@[simp] theorem Rect.inside_iff (a b : Rect) :
    a.inside b = true ↔ a.x ≤ b.x ∧ b.x + b.w ≤ a.x + a.w ∧ a.y ≤ b.y ∧ b.y + b.h ≤ a.y + a.h := by
  simp [Rect.inside, and_assoc]

/-- A point in two rectangles at once witnesses that they overlap. -/
theorem Rect.overlaps_of_mem {a b : Rect} {p : Pt}
    (ha : a.contains p = true) (hb : b.contains p = true) : a.overlaps b = true := by
  rw [Rect.contains_iff] at ha hb
  rw [Rect.overlaps_iff]
  exact ⟨lt_of_le_of_lt ha.1 hb.2.1, lt_of_le_of_lt hb.1 ha.2.1,
    lt_of_le_of_lt ha.2.2.1 hb.2.2.2, lt_of_le_of_lt hb.2.2.1 ha.2.2.2⟩

/-- Contrapositive of `Rect.overlaps_of_mem`: disjoint rectangles share no point. -/
theorem Rect.not_mem_of_not_overlaps {a b : Rect} {p : Pt}
    (h : a.overlaps b = false) (ha : a.contains p = true) : b.contains p = false := by
  by_contra hb
  simp only [Bool.not_eq_false] at hb
  rw [Rect.overlaps_of_mem ha hb] at h
  exact Bool.noConfusion h

/-- Overlapping is symmetric. -/
theorem Rect.overlaps_comm (a b : Rect) : a.overlaps b = b.overlaps a := by
  simp only [Rect.overlaps]
  by_cases h1 : a.x < b.x + b.w <;> by_cases h2 : b.x < a.x + a.w <;>
    by_cases h3 : a.y < b.y + b.h <;> by_cases h4 : b.y < a.y + a.h <;>
    simp [h1, h2, h3, h4]

/-- Containment transfers along `Rect.inside`. -/
theorem Rect.contains_of_inside {a b : Rect} {p : Pt}
    (h : a.inside b = true) (hb : b.contains p = true) : a.contains p = true := by
  rw [Rect.inside_iff] at h
  rw [Rect.contains_iff] at hb ⊢
  exact ⟨le_trans h.1 hb.1, lt_of_lt_of_le hb.2.1 h.2.1,
    le_trans h.2.2.1 hb.2.2.1, lt_of_lt_of_le hb.2.2.2 h.2.2.2⟩

/-- Moving a rectangle is the same as moving the finger the other way. -/
theorem Rect.shift_contains (r : Rect) (dx dy : Int) (p : Pt) :
    (r.shift dx dy).contains p = true ↔ r.contains ⟨p.x - dx, p.y - dy⟩ = true := by
  simp only [Rect.shift, Rect.contains_iff]
  omega

/-! ## Gestures -/

/-- One finger's journey: down at `start`, up at `finish`, `ms` milliseconds later. -/
structure Trace where
  start : Pt
  finish : Pt
  ms : Nat
deriving DecidableEq, Repr, Inhabited

/-- Horizontal travel of a trace. -/
def Trace.dx (t : Trace) : Int := t.finish.x - t.start.x

/-- Vertical travel of a trace (positive is *downwards*). -/
def Trace.dy (t : Trace) : Int := t.finish.y - t.start.y

/-- Move a whole trace by a vector; the gesture must not change. -/
def Trace.translate (t : Trace) (v : Pt) : Trace :=
  ⟨⟨t.start.x + v.x, t.start.y + v.y⟩, ⟨t.finish.x + v.x, t.finish.y + v.y⟩, t.ms⟩

/-- Run a trace backwards. -/
def Trace.reverse (t : Trace) : Trace := ⟨t.finish, t.start, t.ms⟩

/-- Mirror a trace left-to-right. -/
def Trace.mirrorX (t : Trace) : Trace :=
  ⟨⟨-t.start.x, t.start.y⟩, ⟨-t.finish.x, t.finish.y⟩, t.ms⟩

/-- The thresholds the recogniser works to, all user-editable on the page. -/
structure GestureCfg where
  /-- how far the finger may wander and still count as a tap -/
  slop : Int
  /-- how far it must travel to count as a swipe -/
  swipeMin : Int
  /-- how long a still finger must stay down to count as a long press -/
  holdMs : Nat
deriving DecidableEq, Repr, Inhabited

/-- A sensible configuration: a non-negative tap slop strictly below the swipe
threshold, so the two never compete. -/
def GestureCfg.WF (c : GestureCfg) : Prop := 0 ≤ c.slop ∧ c.slop < c.swipeMin

instance (c : GestureCfg) : Decidable c.WF := by
  unfold GestureCfg.WF; infer_instance

/-- What the recogniser can report. -/
inductive Gesture
  | tap
  | hold
  | swipeL
  | swipeR
  | swipeU
  | swipeD
  | drag
deriving DecidableEq, Repr, Inhabited

/-- The reverse gesture: swipes flip, everything else stays. -/
def Gesture.flip : Gesture → Gesture
  | .swipeL => .swipeR
  | .swipeR => .swipeL
  | .swipeU => .swipeD
  | .swipeD => .swipeU
  | g => g

/-- The mirror-image gesture: only left and right swap. -/
def Gesture.mirror : Gesture → Gesture
  | .swipeL => .swipeR
  | .swipeR => .swipeL
  | g => g

/-- Classify a trace.  A still finger is a tap or a long press; a finger that
travelled at least `swipeMin` on its dominant axis is a swipe that way (ties go
to the horizontal); anything in between is a free drag. -/
def recognize (c : GestureCfg) (t : Trace) : Gesture :=
  if |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop then
    (if c.holdMs ≤ t.ms then .hold else .tap)
  else if max |t.dx| |t.dy| < c.swipeMin then .drag
  else if |t.dy| ≤ |t.dx| then (if 0 < t.dx then .swipeR else .swipeL)
  else (if 0 < t.dy then .swipeD else .swipeU)

@[simp] theorem Trace.dx_translate (t : Trace) (v : Pt) : (t.translate v).dx = t.dx := by
  show (t.finish.x + v.x) - (t.start.x + v.x) = t.finish.x - t.start.x
  ring

@[simp] theorem Trace.dy_translate (t : Trace) (v : Pt) : (t.translate v).dy = t.dy := by
  show (t.finish.y + v.y) - (t.start.y + v.y) = t.finish.y - t.start.y
  ring

@[simp] theorem Trace.ms_translate (t : Trace) (v : Pt) : (t.translate v).ms = t.ms := rfl

@[simp] theorem Trace.dx_reverse (t : Trace) : t.reverse.dx = -t.dx := by
  show t.start.x - t.finish.x = -(t.finish.x - t.start.x)
  ring

@[simp] theorem Trace.dy_reverse (t : Trace) : t.reverse.dy = -t.dy := by
  show t.start.y - t.finish.y = -(t.finish.y - t.start.y)
  ring

@[simp] theorem Trace.ms_reverse (t : Trace) : t.reverse.ms = t.ms := rfl

@[simp] theorem Trace.dx_mirrorX (t : Trace) : t.mirrorX.dx = -t.dx := by
  show -t.finish.x - -t.start.x = -(t.finish.x - t.start.x)
  ring

@[simp] theorem Trace.dy_mirrorX (t : Trace) : t.mirrorX.dy = t.dy := rfl

@[simp] theorem Trace.ms_mirrorX (t : Trace) : t.mirrorX.ms = t.ms := rfl

/-! ### The four branches of the recogniser -/

/-- A still finger: tap or long press. -/
theorem recognize_of_still {c : GestureCfg} {t : Trace}
    (h : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop) :
    recognize c t = if c.holdMs ≤ t.ms then .hold else .tap := by
  simp only [recognize, if_pos h]

/-- A finger that moved past the slop but not as far as the swipe threshold. -/
theorem recognize_of_drag {c : GestureCfg} {t : Trace}
    (h1 : ¬(|t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop))
    (h2 : max |t.dx| |t.dy| < c.swipeMin) : recognize c t = .drag := by
  simp only [recognize, if_neg h1, if_pos h2]

/-- A horizontally dominant swipe. -/
theorem recognize_of_horiz {c : GestureCfg} {t : Trace}
    (h1 : ¬(|t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop))
    (h2 : ¬ max |t.dx| |t.dy| < c.swipeMin) (h3 : |t.dy| ≤ |t.dx|) :
    recognize c t = if 0 < t.dx then .swipeR else .swipeL := by
  simp only [recognize, if_neg h1, if_neg h2, if_pos h3]

/-- A vertically dominant swipe. -/
theorem recognize_of_vert {c : GestureCfg} {t : Trace}
    (h1 : ¬(|t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop))
    (h2 : ¬ max |t.dx| |t.dy| < c.swipeMin) (h3 : ¬ |t.dy| ≤ |t.dx|) :
    recognize c t = if 0 < t.dy then .swipeD else .swipeU := by
  simp only [recognize, if_neg h1, if_neg h2, if_neg h3]

/-- A finger that moved past the slop is never reported as a tap or a hold. -/
theorem recognize_ne_tap_hold {c : GestureCfg} {t : Trace}
    (h1 : ¬(|t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop)) :
    recognize c t ≠ .tap ∧ recognize c t ≠ .hold := by
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2]; exact ⟨by decide, by decide⟩
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3]
    split <;> exact ⟨by decide, by decide⟩
  · rw [recognize_of_vert h1 h2 h3]
    split <;> exact ⟨by decide, by decide⟩

/-! ### Invariances -/

/-- **Gestures are position independent**: the same finger movement anywhere on
the screen is recognised the same way. -/
theorem recognize_translate (c : GestureCfg) (t : Trace) (v : Pt) :
    recognize c (t.translate v) = recognize c t := by
  simp only [recognize, Trace.dx_translate, Trace.dy_translate, Trace.ms_translate]

/-- **Running a trace backwards flips the swipe**, and leaves taps, long presses
and drags alone. -/
theorem recognize_reverse (c : GestureCfg) (t : Trace) (h : t.dx ≠ 0 ∨ t.dy ≠ 0) :
    recognize c t.reverse = (recognize c t).flip := by
  have hx : |t.reverse.dx| = |t.dx| := by simp
  have hy : |t.reverse.dy| = |t.dy| := by simp
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1, recognize_of_still (by rw [hx, hy]; exact h1)]
    simp only [Trace.ms_reverse]
    split <;> rfl
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2, recognize_of_drag (by rw [hx, hy]; exact h1) (by rw [hx, hy]; exact h2)]
    rfl
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3,
      recognize_of_horiz (by rw [hx, hy]; exact h1) (by rw [hx, hy]; exact h2) (by rw [hx, hy]; exact h3)]
    have hdx : t.dx ≠ 0 := by
      rcases h with h | h
      · exact h
      · intro h0
        apply h
        have : |t.dy| ≤ 0 := by rw [h0] at h3; simpa using h3
        have := abs_nonneg t.dy
        have : |t.dy| = 0 := le_antisymm ‹|t.dy| ≤ 0› ‹0 ≤ |t.dy|›
        exact abs_eq_zero.mp this
    simp only [Trace.dx_reverse]
    rcases lt_trichotomy t.dx 0 with hn | h0 | hp
    · rw [if_pos (by omega), if_neg (by omega)]; rfl
    · exact absurd h0 hdx
    · rw [if_neg (by omega), if_pos (by omega)]; rfl
  · rw [recognize_of_vert h1 h2 h3,
      recognize_of_vert (by rw [hx, hy]; exact h1) (by rw [hx, hy]; exact h2) (by rw [hx, hy]; exact h3)]
    have hdy : t.dy ≠ 0 := by
      intro h0
      apply h3
      rw [h0]
      simp
    simp only [Trace.dy_reverse]
    rcases lt_trichotomy t.dy 0 with hn | h0 | hp
    · rw [if_pos (by omega), if_neg (by omega)]; rfl
    · exact absurd h0 hdy
    · rw [if_neg (by omega), if_pos (by omega)]; rfl

/-- **Mirroring the screen mirrors the gesture**: left and right swipes swap and
nothing else changes — so a left-handed layout needs no separate recogniser. -/
theorem recognize_mirrorX (c : GestureCfg) (t : Trace) (h : t.dx ≠ 0 ∨ |t.dx| < |t.dy|) :
    recognize c t.mirrorX = (recognize c t).mirror := by
  have hx : |t.mirrorX.dx| = |t.dx| := by simp
  have hy : |t.mirrorX.dy| = |t.dy| := by simp
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1, recognize_of_still (by rw [hx, hy]; exact h1)]
    simp only [Trace.ms_mirrorX]
    split <;> rfl
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2, recognize_of_drag (by rw [hx, hy]; exact h1) (by rw [hx, hy]; exact h2)]
    rfl
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3,
      recognize_of_horiz (by rw [hx, hy]; exact h1) (by rw [hx, hy]; exact h2) (by rw [hx, hy]; exact h3)]
    have hdx : t.dx ≠ 0 := by
      rcases h with h | h
      · exact h
      · exact absurd h3 (by omega)
    simp only [Trace.dx_mirrorX]
    rcases lt_trichotomy t.dx 0 with hn | h0 | hp
    · rw [if_pos (by omega), if_neg (by omega)]; rfl
    · exact absurd h0 hdx
    · rw [if_neg (by omega), if_pos (by omega)]; rfl
  · rw [recognize_of_vert h1 h2 h3,
      recognize_of_vert (by rw [hx, hy]; exact h1) (by rw [hx, hy]; exact h2) (by rw [hx, hy]; exact h3)]
    simp only [Trace.dy_mirrorX]
    split <;> rfl

/-! ### What each answer means -/

/-- A finger that did not move is a tap or a long press, never a swipe. -/
theorem recognize_still (c : GestureCfg) (t : Trace) (hs : 0 ≤ c.slop)
    (h : t.start = t.finish) :
    recognize c t = if c.holdMs ≤ t.ms then .hold else .tap := by
  have hx : t.dx = 0 := by simp [Trace.dx, h]
  have hy : t.dy = 0 := by simp [Trace.dy, h]
  exact recognize_of_still (by rw [hx, hy]; simp only [abs_zero]; exact ⟨hs, hs⟩)

/-- A tap is exactly a short, still touch. -/
theorem recognize_eq_tap_iff (c : GestureCfg) (t : Trace) :
    recognize c t = .tap ↔ (|t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop) ∧ t.ms < c.holdMs := by
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1]
    by_cases h2 : c.holdMs ≤ t.ms
    · rw [if_pos h2]
      simp only [h1, true_and]
      exact ⟨fun h => Gesture.noConfusion h, fun h => absurd h2 (by omega)⟩
    · rw [if_neg h2]
      simp only [h1, true_and, true_iff]
      omega
  · exact ⟨fun h => absurd h (recognize_ne_tap_hold h1).1, fun h => absurd h.1 h1⟩

/-- A long press is exactly a still touch held past the threshold. -/
theorem recognize_eq_hold_iff (c : GestureCfg) (t : Trace) :
    recognize c t = .hold ↔ (|t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop) ∧ c.holdMs ≤ t.ms := by
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1]
    by_cases h2 : c.holdMs ≤ t.ms
    · rw [if_pos h2]; exact ⟨fun _ => ⟨h1, h2⟩, fun _ => rfl⟩
    · rw [if_neg h2]
      simp only [h1, true_and]
      exact ⟨fun h => absurd h (by decide), fun h => absurd h h2⟩
  · exact ⟨fun h => absurd h (recognize_ne_tap_hold h1).2, fun h => absurd h.1 h1⟩

/-- **A right swipe means the finger really did go right, far enough**, and
further right than it went up or down. -/
theorem recognize_swipeR (c : GestureCfg) (t : Trace) (h : recognize c t = .swipeR) :
    c.swipeMin ≤ t.dx ∧ |t.dy| ≤ t.dx := by
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1] at h; split at h <;> exact Gesture.noConfusion h
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2] at h; exact Gesture.noConfusion h
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3] at h
    by_cases h4 : 0 < t.dx
    · rw [abs_of_pos h4] at h2 h3
      exact ⟨by omega, h3⟩
    · rw [if_neg h4] at h; exact Gesture.noConfusion h
  · rw [recognize_of_vert h1 h2 h3] at h; split at h <;> exact Gesture.noConfusion h

/-- A left swipe means the finger really did go left, far enough. -/
theorem recognize_swipeL (c : GestureCfg) (t : Trace) (h : recognize c t = .swipeL) :
    t.dx ≤ -c.swipeMin ∧ |t.dy| ≤ -t.dx := by
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1] at h; split at h <;> exact Gesture.noConfusion h
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2] at h; exact Gesture.noConfusion h
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3] at h
    by_cases h4 : 0 < t.dx
    · rw [if_pos h4] at h; exact Gesture.noConfusion h
    · rw [abs_of_nonpos (by omega : t.dx ≤ 0)] at h2 h3
      exact ⟨by omega, h3⟩
  · rw [recognize_of_vert h1 h2 h3] at h; split at h <;> exact Gesture.noConfusion h

/-- A downward swipe means the finger really did go down, far enough. -/
theorem recognize_swipeD (c : GestureCfg) (t : Trace) (h : recognize c t = .swipeD) :
    c.swipeMin ≤ t.dy ∧ |t.dx| < t.dy := by
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1] at h; split at h <;> exact Gesture.noConfusion h
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2] at h; exact Gesture.noConfusion h
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3] at h; split at h <;> exact Gesture.noConfusion h
  · rw [recognize_of_vert h1 h2 h3] at h
    by_cases h4 : 0 < t.dy
    · rw [abs_of_pos h4] at h2 h3
      exact ⟨by omega, by omega⟩
    · rw [if_neg h4] at h; exact Gesture.noConfusion h

/-- An upward swipe means the finger really did go up, far enough. -/
theorem recognize_swipeU (c : GestureCfg) (t : Trace) (h : recognize c t = .swipeU) :
    t.dy ≤ -c.swipeMin ∧ |t.dx| < -t.dy := by
  by_cases h1 : |t.dx| ≤ c.slop ∧ |t.dy| ≤ c.slop
  · rw [recognize_of_still h1] at h; split at h <;> exact Gesture.noConfusion h
  by_cases h2 : max |t.dx| |t.dy| < c.swipeMin
  · rw [recognize_of_drag h1 h2] at h; exact Gesture.noConfusion h
  by_cases h3 : |t.dy| ≤ |t.dx|
  · rw [recognize_of_horiz h1 h2 h3] at h; split at h <;> exact Gesture.noConfusion h
  · rw [recognize_of_vert h1 h2 h3] at h
    by_cases h4 : 0 < t.dy
    · rw [if_pos h4] at h; exact Gesture.noConfusion h
    · rw [abs_of_nonpos (by omega : t.dy ≤ 0)] at h2 h3
      exact ⟨by omega, by omega⟩

/-- Under a well-formed configuration a swipe is never also a tap: every
directional answer needs travel strictly past the tap slop. -/
theorem swipe_not_tap (c : GestureCfg) (t : Trace) (hc : c.WF)
    (h : recognize c t = .swipeR ∨ recognize c t = .swipeL ∨
         recognize c t = .swipeU ∨ recognize c t = .swipeD) :
    c.slop < max |t.dx| |t.dy| := by
  obtain ⟨-, hlt⟩ := hc
  have hax := abs_nonneg t.dx
  have hay := abs_nonneg t.dy
  have hbx := le_abs_self t.dx
  have hby := le_abs_self t.dy
  have hbx' := neg_abs_le t.dx
  have hby' := neg_abs_le t.dy
  rcases h with h | h | h | h
  · have := (recognize_swipeR c t h).1; omega
  · have := (recognize_swipeL c t h).1; omega
  · have := (recognize_swipeU c t h).1; omega
  · have := (recognize_swipeD c t h).1; omega

end Touch
