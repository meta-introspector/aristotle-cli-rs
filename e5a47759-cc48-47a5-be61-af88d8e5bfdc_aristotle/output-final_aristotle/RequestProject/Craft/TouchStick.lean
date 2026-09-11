import RequestProject.Craft.TouchCore

/-!
# Touch input, part 2: the on-screen joystick and the virtual mouse

The pad carries two analogue controls.

* A **joystick**: a circular pad with a knob.  The knob's offset from the
  centre is classified into one of eight compass directions, or `neutral`
  inside the dead zone.  The classification uses only integer comparisons —
  a direction is "horizontal" when the sideways travel is at least twice the
  vertical travel, "vertical" in the mirror-image case, and diagonal in
  between — so it is exactly what the page can compute, and it is proved to
  partition the plane.
* A **virtual mouse**: a trackpad that moves a pointer, which is clamped to
  the screen, plus the standard phone idiom that a tap is a click and a long
  press is a right click.

Proved here: the dead zone is exactly the neutral zone, the classification
respects negation and mirroring, each named direction really does mean travel
that way, opposite directions never share a key, the pointer never leaves the
screen and never moves backwards on a forward flick, and the knob drawn on the
pad never leaves the pad.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Touch

/-! ## The joystick -/

/-- The eight compass directions plus the centre.  `s` is *down the screen*. -/
inductive Dir8
  | neutral | e | ne | n | nw | w | sw | s | se
deriving DecidableEq, Repr, Inhabited

/-- The opposite direction. -/
def Dir8.opposite : Dir8 → Dir8
  | .neutral => .neutral
  | .e => .w | .w => .e | .n => .s | .s => .n
  | .ne => .sw | .sw => .ne | .nw => .se | .se => .nw

/-- The left-to-right mirror image of a direction. -/
def Dir8.mirror : Dir8 → Dir8
  | .neutral => .neutral
  | .e => .w | .w => .e | .n => .n | .s => .s
  | .ne => .nw | .nw => .ne | .se => .sw | .sw => .se

@[simp] theorem Dir8.opposite_opposite (d : Dir8) : d.opposite.opposite = d := by
  cases d <;> rfl

@[simp] theorem Dir8.mirror_mirror (d : Dir8) : d.mirror.mirror = d := by
  cases d <;> rfl

/-- The joystick's geometry: how far the knob may travel and how big the dead
zone is, both in pixels. -/
structure StickCfg where
  radius : Int
  dead : Int
deriving DecidableEq, Repr, Inhabited

/-- A usable joystick: a non-negative dead zone strictly inside the pad. -/
def StickCfg.WF (c : StickCfg) : Prop := 0 ≤ c.dead ∧ c.dead < c.radius

instance (c : StickCfg) : Decidable c.WF := by unfold StickCfg.WF; infer_instance

/-- Squared distance from the centre — integer arithmetic, no square roots. -/
def magSq (v : Pt) : Int := v.x * v.x + v.y * v.y

/-- Negating a vector. -/
def Pt.neg (v : Pt) : Pt := ⟨-v.x, -v.y⟩

/-- Mirroring a vector left to right. -/
def Pt.mirrorX (v : Pt) : Pt := ⟨-v.x, v.y⟩

@[simp] theorem magSq_neg (v : Pt) : magSq v.neg = magSq v := by
  simp only [magSq, Pt.neg]; ring

@[simp] theorem magSq_mirrorX (v : Pt) : magSq v.mirrorX = magSq v := by
  simp only [magSq, Pt.mirrorX]; ring

theorem magSq_nonneg (v : Pt) : 0 ≤ magSq v := by
  have h1 : 0 ≤ v.x * v.x := mul_self_nonneg _
  have h2 : 0 ≤ v.y * v.y := mul_self_nonneg _
  simp only [magSq]; omega

theorem magSq_eq_zero_iff (v : Pt) : magSq v = 0 ↔ v.x = 0 ∧ v.y = 0 := by
  constructor
  · intro h
    have h1 : 0 ≤ v.x * v.x := mul_self_nonneg _
    have h2 : 0 ≤ v.y * v.y := mul_self_nonneg _
    simp only [magSq] at h
    constructor
    · have : v.x * v.x = 0 := by omega
      exact mul_self_eq_zero.mp this
    · have : v.y * v.y = 0 := by omega
      exact mul_self_eq_zero.mp this
  · rintro ⟨hx, hy⟩; simp [magSq, hx, hy]

/-- Classify the knob offset `v` into one of the nine directions. -/
def dir8 (c : StickCfg) (v : Pt) : Dir8 :=
  if magSq v ≤ c.dead * c.dead then .neutral
  else if 2 * |v.y| ≤ |v.x| then (if 0 < v.x then .e else .w)
  else if 2 * |v.x| ≤ |v.y| then (if 0 < v.y then .s else .n)
  else if 0 < v.x then (if 0 < v.y then .se else .ne)
  else (if 0 < v.y then .sw else .nw)

/-- The horizontal and vertical zones only meet at the centre: the
classification really does partition the plane. -/
theorem zones_disjoint {v : Pt} (h1 : 2 * |v.y| ≤ |v.x|) (h2 : 2 * |v.x| ≤ |v.y|) :
    v.x = 0 ∧ v.y = 0 := by
  have hx := abs_nonneg v.x
  have hy := abs_nonneg v.y
  have hx0 : |v.x| = 0 := by omega
  have hy0 : |v.y| = 0 := by omega
  exact ⟨abs_eq_zero.mp hx0, abs_eq_zero.mp hy0⟩

/-- **The dead zone is exactly the neutral zone.** -/
theorem dir8_eq_neutral_iff (c : StickCfg) (v : Pt) :
    dir8 c v = .neutral ↔ magSq v ≤ c.dead * c.dead := by
  unfold dir8
  by_cases h : magSq v ≤ c.dead * c.dead
  · simp [h]
  · simp only [h, if_false, iff_false]
    split
    · split <;> exact fun h => Dir8.noConfusion h
    · split
      · split <;> exact fun h => Dir8.noConfusion h
      · split <;> split <;> exact fun h => Dir8.noConfusion h

/-- A direction other than `neutral` needs the knob outside the dead zone. -/
theorem dir8_ne_neutral (c : StickCfg) (v : Pt) (h : dir8 c v ≠ .neutral) :
    c.dead * c.dead < magSq v := by
  by_contra hc
  exact h ((dir8_eq_neutral_iff c v).mpr (by omega))

/-- Inside the dead zone the stick reads neutral. -/
theorem dir8_dead (c : StickCfg) (v : Pt) (h : magSq v ≤ c.dead * c.dead) :
    dir8 c v = .neutral := (dir8_eq_neutral_iff c v).mpr h

/-- Off the diagonal zones the knob offset is nonzero in the reported axis. -/
theorem dir8_ne_zero {c : StickCfg} {v : Pt} (hc : 0 ≤ c.dead) (h : dir8 c v ≠ .neutral) :
    ¬(v.x = 0 ∧ v.y = 0) := by
  rintro ⟨hx, hy⟩
  refine h (dir8_dead c v ?_)
  have : magSq v = 0 := (magSq_eq_zero_iff v).mpr ⟨hx, hy⟩
  have : 0 ≤ c.dead * c.dead := mul_nonneg hc hc
  omega

/-- **Pushing the knob the other way reads the opposite direction.** -/
theorem dir8_neg (c : StickCfg) (v : Pt) (hc : 0 ≤ c.dead) :
    dir8 c v.neg = (dir8 c v).opposite := by
  have hx : |v.neg.x| = |v.x| := by simp [Pt.neg]
  have hy : |v.neg.y| = |v.y| := by simp [Pt.neg]
  unfold dir8
  simp only [magSq_neg, hx, hy]
  by_cases h0 : magSq v ≤ c.dead * c.dead
  · simp [h0, Dir8.opposite]
  simp only [h0, if_false]
  have hnz : ¬(v.x = 0 ∧ v.y = 0) := by
    rintro ⟨hx0, hy0⟩
    have : magSq v = 0 := (magSq_eq_zero_iff v).mpr ⟨hx0, hy0⟩
    have : 0 ≤ c.dead * c.dead := mul_nonneg hc hc
    omega
  by_cases h1 : 2 * |v.y| ≤ |v.x|
  · simp only [h1, if_true]
    have hxne : v.x ≠ 0 := by
      intro hx0
      apply hnz
      refine ⟨hx0, ?_⟩
      rw [hx0] at h1
      simp only [abs_zero] at h1
      have := abs_nonneg v.y
      exact abs_eq_zero.mp (by omega)
    show (if 0 < -v.x then Dir8.e else Dir8.w) = (if 0 < v.x then Dir8.e else Dir8.w).opposite
    rcases lt_trichotomy v.x 0 with hn | he | hp
    · rw [if_pos (by omega), if_neg (by omega)]; rfl
    · exact absurd he hxne
    · rw [if_neg (by omega), if_pos (by omega)]; rfl
  simp only [h1, if_false]
  by_cases h2 : 2 * |v.x| ≤ |v.y|
  · simp only [h2, if_true]
    have hyne : v.y ≠ 0 := by
      intro hy0
      apply h1
      rw [hy0] at h2 ⊢
      simp only [abs_zero] at h2 ⊢
      have := abs_nonneg v.x
      omega
    show (if 0 < -v.y then Dir8.s else Dir8.n) = (if 0 < v.y then Dir8.s else Dir8.n).opposite
    rcases lt_trichotomy v.y 0 with hn | he | hp
    · rw [if_pos (by omega), if_neg (by omega)]; rfl
    · exact absurd he hyne
    · rw [if_neg (by omega), if_pos (by omega)]; rfl
  simp only [h2, if_false]
  have hxne : v.x ≠ 0 := by
    intro hx0
    apply h2
    rw [hx0]
    simp only [abs_zero, mul_zero]
    exact abs_nonneg v.y
  have hyne : v.y ≠ 0 := by
    intro hy0
    apply h1
    rw [hy0]
    simp only [abs_zero, mul_zero]
    exact abs_nonneg v.x
  show (if 0 < -v.x then (if 0 < -v.y then Dir8.se else Dir8.ne)
        else (if 0 < -v.y then Dir8.sw else Dir8.nw))
      = (if 0 < v.x then (if 0 < v.y then Dir8.se else Dir8.ne)
        else (if 0 < v.y then Dir8.sw else Dir8.nw)).opposite
  rcases lt_trichotomy v.x 0 with hxn | hx0 | hxp <;>
    rcases lt_trichotomy v.y 0 with hyn | hy0 | hyp
  · rw [if_pos (by omega), if_pos (by omega), if_neg (by omega), if_neg (by omega)]; rfl
  · exact absurd hy0 hyne
  · rw [if_pos (by omega), if_neg (by omega), if_neg (by omega), if_pos (by omega)]; rfl
  · exact absurd hx0 hxne
  · exact absurd hx0 hxne
  · exact absurd hx0 hxne
  · rw [if_neg (by omega), if_pos (by omega), if_pos (by omega), if_neg (by omega)]; rfl
  · exact absurd hy0 hyne
  · rw [if_neg (by omega), if_neg (by omega), if_pos (by omega), if_pos (by omega)]; rfl

/-- **A reported east really is east**: the knob is right of centre and at
least twice as far right as it is up or down. -/
theorem dir8_e (c : StickCfg) (v : Pt) (h : dir8 c v = .e) : 0 < v.x ∧ 2 * |v.y| ≤ v.x := by
  unfold dir8 at h
  split at h
  · exact absurd h (by decide)
  rename_i h0
  split at h
  · rename_i h1
    split at h
    · rename_i hp
      rw [abs_of_pos hp] at h1
      exact ⟨hp, h1⟩
    · exact absurd h (by decide)
  · split at h
    · split at h <;> exact absurd h (by decide)
    · split at h <;> split at h <;> exact absurd h (by decide)

/-- A reported west really is west. -/
theorem dir8_w (c : StickCfg) (v : Pt) (hc : 0 ≤ c.dead) (h : dir8 c v = .w) :
    v.x < 0 ∧ 2 * |v.y| ≤ -v.x := by
  unfold dir8 at h
  split at h
  · exact absurd h (by decide)
  rename_i h0
  split at h
  · rename_i h1
    split at h
    · exact absurd h (by decide)
    · rename_i hp
      have hx : v.x ≤ 0 := by omega
      rw [abs_of_nonpos hx] at h1
      have hxne : v.x ≠ 0 := by
        intro hx0
        rw [hx0] at h1
        simp only [neg_zero] at h1
        have hy : v.y = 0 := abs_eq_zero.mp (by have := abs_nonneg v.y; omega)
        have hz : magSq v = 0 := (magSq_eq_zero_iff v).mpr ⟨hx0, hy⟩
        have : 0 ≤ c.dead * c.dead := mul_nonneg hc hc
        omega
      exact ⟨by omega, h1⟩
  · split at h
    · split at h <;> exact absurd h (by decide)
    · split at h <;> split at h <;> exact absurd h (by decide)

/-- A reported south (down the screen) really is south. -/
theorem dir8_s (c : StickCfg) (v : Pt) (h : dir8 c v = .s) : 0 < v.y ∧ 2 * |v.x| ≤ v.y := by
  unfold dir8 at h
  split at h
  · exact absurd h (by decide)
  split at h
  · split at h <;> exact absurd h (by decide)
  · split at h
    · rename_i h2
      split at h
      · rename_i hp
        rw [abs_of_pos hp] at h2
        exact ⟨hp, h2⟩
      · exact absurd h (by decide)
    · split at h <;> split at h <;> exact absurd h (by decide)

/-- A reported north really is north. -/
theorem dir8_n (c : StickCfg) (v : Pt) (hc : 0 ≤ c.dead) (h : dir8 c v = .n) :
    v.y < 0 ∧ 2 * |v.x| ≤ -v.y := by
  unfold dir8 at h
  split at h
  · exact absurd h (by decide)
  rename_i h0
  split at h
  · split at h <;> exact absurd h (by decide)
  · split at h
    · rename_i h2
      split at h
      · exact absurd h (by decide)
      · rename_i hp
        have hy : v.y ≤ 0 := by omega
        rw [abs_of_nonpos hy] at h2
        have hyne : v.y ≠ 0 := by
          intro hy0
          rw [hy0] at h2
          simp only [neg_zero] at h2
          have hx : v.x = 0 := abs_eq_zero.mp (by have := abs_nonneg v.x; omega)
          have hz : magSq v = 0 := (magSq_eq_zero_iff v).mpr ⟨hx, hy0⟩
          have : 0 ≤ c.dead * c.dead := mul_nonneg hc hc
          omega
        exact ⟨by omega, h2⟩
    · split at h <;> split at h <;> exact absurd h (by decide)

/-! ### From a direction to keys -/

/-- The four movement keys the joystick can hold down. -/
inductive PadKey
  | up | down | left | right
deriving DecidableEq, Repr, Inhabited

/-- Which keys a direction holds down — this is what a game sees. -/
def Dir8.keys : Dir8 → List PadKey
  | .neutral => []
  | .e => [.right]
  | .w => [.left]
  | .n => [.up]
  | .s => [.down]
  | .ne => [.up, .right]
  | .nw => [.up, .left]
  | .se => [.down, .right]
  | .sw => [.down, .left]

/-- **Opposite directions never hold a key in common** — the stick can never
ask a game to walk both ways at once. -/
theorem Dir8.keys_opposite_disjoint (d : Dir8) :
    ∀ k ∈ d.keys, k ∉ d.opposite.keys := by
  cases d <;> decide

/-- Only the neutral direction holds nothing down. -/
theorem Dir8.keys_eq_nil_iff (d : Dir8) : d.keys = [] ↔ d = .neutral := by
  cases d <;> decide

/-- A direction never holds more than two keys, and never repeats one. -/
theorem Dir8.keys_nodup (d : Dir8) : d.keys.Nodup ∧ d.keys.length ≤ 2 := by
  cases d <;> exact ⟨by decide, by decide⟩

/-! ### Drawing the knob -/

/-- Where the page draws the knob: the offset, clamped to the pad in each axis.
(The pad is drawn as a square of side `2 * radius`.) -/
def knob (c : StickCfg) (v : Pt) : Pt :=
  ⟨max (-c.radius) (min c.radius v.x), max (-c.radius) (min c.radius v.y)⟩

/-- **The knob never leaves the pad.** -/
theorem knob_bounded (c : StickCfg) (v : Pt) (h : 0 ≤ c.radius) :
    |(knob c v).x| ≤ c.radius ∧ |(knob c v).y| ≤ c.radius := by
  constructor <;> rw [abs_le] <;> constructor <;> simp only [knob] <;> omega

/-- Inside the pad the knob follows the finger exactly. -/
theorem knob_id (c : StickCfg) (v : Pt) (hx : |v.x| ≤ c.radius) (hy : |v.y| ≤ c.radius) :
    knob c v = v := by
  rw [abs_le] at hx hy
  apply Pt.ext
  · show max (-c.radius) (min c.radius v.x) = v.x
    omega
  · show max (-c.radius) (min c.radius v.y) = v.y
    omega

/-! ## The virtual mouse -/

/-- What a touch on the trackpad turns into. -/
inductive MouseEvent
  | click
  | rightClick
  | drag
  | move
deriving DecidableEq, Repr, Inhabited

/-- The phone idiom: a tap is a click, a long press is a right click, a swipe
or a free drag moves the pointer with the button down. -/
def mouseOfGesture : Gesture → MouseEvent
  | .tap => .click
  | .hold => .rightClick
  | .drag => .drag
  | _ => .move

/-- The pointer state: where the cursor is. -/
structure MouseState where
  pos : Pt
deriving DecidableEq, Repr, Inhabited

/-- Clamp a point into a rectangle (which must have positive width and height). -/
def clampPt (r : Rect) (p : Pt) : Pt :=
  ⟨max r.x (min (r.x + r.w - 1) p.x), max r.y (min (r.y + r.h - 1) p.y)⟩

/-- Move the pointer by `d`, scaled by the sensitivity numerator `sens` over
eight, and clamped to the screen. -/
def MouseState.moveBy (screen : Rect) (sens : Int) (st : MouseState) (d : Pt) : MouseState :=
  ⟨clampPt screen ⟨st.pos.x + d.x * sens / 8, st.pos.y + d.y * sens / 8⟩⟩

/-- **The pointer is always on screen.** -/
theorem clampPt_mem (r : Rect) (p : Pt) (hw : 0 < r.w) (hh : 0 < r.h) :
    r.contains (clampPt r p) = true := by
  rw [Rect.contains_iff]
  simp only [clampPt]
  omega

/-- A pointer already on screen is left alone by the clamp. -/
theorem clampPt_id (r : Rect) (p : Pt) (h : r.contains p = true) : clampPt r p = p := by
  rw [Rect.contains_iff] at h
  apply Pt.ext
  · show max r.x (min (r.x + r.w - 1) p.x) = p.x
    omega
  · show max r.y (min (r.y + r.h - 1) p.y) = p.y
    omega

/-- **However the trackpad is used, the pointer stays on the screen.** -/
theorem moveBy_mem (screen : Rect) (sens : Int) (st : MouseState) (d : Pt)
    (hw : 0 < screen.w) (hh : 0 < screen.h) :
    screen.contains (st.moveBy screen sens d).pos = true :=
  clampPt_mem screen _ hw hh

/-- A trackpad touch that goes nowhere leaves an on-screen pointer where it is. -/
theorem moveBy_zero (screen : Rect) (sens : Int) (st : MouseState)
    (h : screen.contains st.pos = true) :
    st.moveBy screen sens ⟨0, 0⟩ = st := by
  have : (⟨st.pos.x + 0 * sens / 8, st.pos.y + 0 * sens / 8⟩ : Pt) = st.pos := by
    simp
  simp only [MouseState.moveBy, this, clampPt_id screen st.pos h]

/-- **A rightward flick never moves the pointer left.** -/
theorem moveBy_mono_x (screen : Rect) (sens : Int) (st : MouseState) (d : Pt)
    (hs : 0 ≤ sens) (hd : 0 ≤ d.x) (h : screen.contains st.pos = true) :
    st.pos.x ≤ (st.moveBy screen sens d).pos.x := by
  rw [Rect.contains_iff] at h
  have hnn : 0 ≤ d.x * sens / 8 := Int.ediv_nonneg (mul_nonneg hd hs) (by norm_num)
  simp only [MouseState.moveBy, clampPt]
  omega

/-- A tap on the trackpad is a click, and nothing else is. -/
theorem mouse_click_iff (c : GestureCfg) (t : Trace) :
    mouseOfGesture (recognize c t) = .click ↔ recognize c t = .tap := by
  cases recognize c t <;> simp [mouseOfGesture]

/-- A long press on the trackpad is a right click, and nothing else is. -/
theorem mouse_rightClick_iff (c : GestureCfg) (t : Trace) :
    mouseOfGesture (recognize c t) = .rightClick ↔ recognize c t = .hold := by
  cases recognize c t <;> simp [mouseOfGesture]

end Touch
