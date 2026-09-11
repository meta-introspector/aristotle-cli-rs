/-
# Intervals and sound interval arithmetic

Interval soundness cannot be stated once for an unknown `f`: the sketch

    theorem interval_sound : Contains i x → Contains j y → Contains k (f x y)

has `i j k f` free and unrelated, so it is not a theorem about anything.  Here
soundness is stated *per operation*: for each interval operation `op` there is a
lemma saying that if `x` lies in `a` and `y` lies in `b` then `x op y` lies in
`op a b`.

Enclosure only.  Nothing here claims tightness: dependency between operands
(the classic `x - x`) makes interval arithmetic conservative, and the
`sub_self_mem` lemma below records exactly that.
-/
import RequestProject.Economy.Quantities

namespace RequestProject.Economy

/-- A nonempty closed rational interval. -/
structure Interval where
  lo : ℚ
  hi : ℚ
  le : lo ≤ hi
deriving Repr

namespace Interval

@[ext] theorem ext {a b : Interval} (hlo : a.lo = b.lo) (hhi : a.hi = b.hi) : a = b := by
  cases a; cases b; simp_all

instance : DecidableEq Interval := fun a b =>
  decidable_of_iff (a.lo = b.lo ∧ a.hi = b.hi)
    ⟨fun h => Interval.ext h.1 h.2, fun h => by subst h; exact ⟨rfl, rfl⟩⟩

/-- Membership of a rational in an interval. -/
def Contains (i : Interval) (x : ℚ) : Prop := i.lo ≤ x ∧ x ≤ i.hi

instance : Membership ℚ Interval := ⟨fun i x => i.Contains x⟩

@[simp] theorem mem_iff {i : Interval} {x : ℚ} : x ∈ i ↔ i.lo ≤ x ∧ x ≤ i.hi := Iff.rfl

instance (i : Interval) (x : ℚ) : Decidable (x ∈ i) := by
  simp only [mem_iff]; infer_instance

/-- Every interval is inhabited: it contains its own lower endpoint. -/
theorem lo_mem (i : Interval) : i.lo ∈ i := ⟨le_refl _, i.le⟩

/-- The degenerate interval of a known value. -/
def point (x : ℚ) : Interval := ⟨x, x, le_refl _⟩

@[simp] theorem point_mem (x : ℚ) : x ∈ point x := ⟨le_refl _, le_refl _⟩

@[simp] theorem mem_point {x y : ℚ} : y ∈ point x ↔ y = x := by
  simp [point, le_antisymm_iff, And.comm]

/-- The width of an interval — its declared uncertainty. -/
def width (i : Interval) : ℚ := i.hi - i.lo

theorem width_nonneg (i : Interval) : 0 ≤ i.width := by
  simp only [width]; linarith [i.le]

@[simp] theorem width_point (x : ℚ) : (point x).width = 0 := by simp [width, point]

/-! ### Arithmetic, with a soundness lemma per operation -/

def add (a b : Interval) : Interval :=
  ⟨a.lo + b.lo, a.hi + b.hi, by linarith [a.le, b.le]⟩

def neg (a : Interval) : Interval := ⟨-a.hi, -a.lo, by linarith [a.le]⟩

def sub (a b : Interval) : Interval := add a (neg b)

instance : Add Interval := ⟨add⟩
instance : Neg Interval := ⟨neg⟩
instance : Sub Interval := ⟨sub⟩

@[simp] theorem add_lo (a b : Interval) : (a + b).lo = a.lo + b.lo := rfl
@[simp] theorem add_hi (a b : Interval) : (a + b).hi = a.hi + b.hi := rfl
@[simp] theorem neg_lo (a : Interval) : (-a).lo = -a.hi := rfl
@[simp] theorem neg_hi (a : Interval) : (-a).hi = -a.lo := rfl
@[simp] theorem sub_lo (a b : Interval) : (a - b).lo = a.lo - b.hi := by
  show a.lo + -b.hi = _; ring
@[simp] theorem sub_hi (a b : Interval) : (a - b).hi = a.hi - b.lo := by
  show a.hi + -b.lo = _; ring

theorem add_mem {a b : Interval} {x y : ℚ} (hx : x ∈ a) (hy : y ∈ b) : x + y ∈ a + b := by
  obtain ⟨h1, h2⟩ := hx; obtain ⟨h3, h4⟩ := hy
  exact ⟨by simpa using by linarith, by simpa using by linarith⟩

theorem neg_mem {a : Interval} {x : ℚ} (hx : x ∈ a) : -x ∈ -a := by
  obtain ⟨h1, h2⟩ := hx
  exact ⟨by simpa using by linarith, by simpa using by linarith⟩

theorem sub_mem {a b : Interval} {x y : ℚ} (hx : x ∈ a) (hy : y ∈ b) : x - y ∈ a - b := by
  obtain ⟨h1, h2⟩ := hx; obtain ⟨h3, h4⟩ := hy
  exact ⟨by simpa using by linarith, by simpa using by linarith⟩

/-- Interval arithmetic is *enclosing*, not tight: `a - a` is not the point `0`
unless `a` is degenerate, because the two occurrences of `x` are treated as
independent.  This is the standard dependency problem, recorded as a lemma so
that nobody reads `sub_mem` as an equality. -/
theorem sub_self_width (a : Interval) : (a - a).width = 2 * a.width := by
  simp only [width, sub_lo, sub_hi]; ring

/-- One-sided monotone bound used to prove `mul_mem`. -/
private theorem between_mul_right {l h x : ℚ} (t : ℚ) (h1 : l ≤ x) (h2 : x ≤ h) :
    min (l * t) (h * t) ≤ x * t ∧ x * t ≤ max (l * t) (h * t) := by
  rcases le_or_gt 0 t with ht | ht
  · have hl : l * t ≤ x * t := mul_le_mul_of_nonneg_right h1 ht
    have hh : x * t ≤ h * t := mul_le_mul_of_nonneg_right h2 ht
    exact ⟨le_trans (min_le_left _ _) hl, le_trans hh (le_max_right _ _)⟩
  · have ht' : t ≤ 0 := le_of_lt ht
    have hl : x * t ≤ l * t := mul_le_mul_of_nonpos_right h1 ht'
    have hh : h * t ≤ x * t := mul_le_mul_of_nonpos_right h2 ht'
    exact ⟨le_trans (min_le_right _ _) hh, le_trans hl (le_max_left _ _)⟩

def mul (a b : Interval) : Interval where
  lo := min (min (a.lo * b.lo) (a.lo * b.hi)) (min (a.hi * b.lo) (a.hi * b.hi))
  hi := max (max (a.lo * b.lo) (a.lo * b.hi)) (max (a.hi * b.lo) (a.hi * b.hi))
  le := le_trans (le_trans (min_le_left _ _) (min_le_left _ _))
          (le_trans (le_max_left _ _) (le_max_left _ _))

instance : Mul Interval := ⟨mul⟩

@[simp] theorem mul_lo (a b : Interval) :
    (a * b).lo = min (min (a.lo * b.lo) (a.lo * b.hi)) (min (a.hi * b.lo) (a.hi * b.hi)) := rfl
@[simp] theorem mul_hi (a b : Interval) :
    (a * b).hi = max (max (a.lo * b.lo) (a.lo * b.hi)) (max (a.hi * b.lo) (a.hi * b.hi)) := rfl

theorem mul_mem {a b : Interval} {x y : ℚ} (hx : x ∈ a) (hy : y ∈ b) : x * y ∈ a * b := by
  obtain ⟨hx1, hx2⟩ := hx
  obtain ⟨hy1, hy2⟩ := hy
  -- bound `x * y` between `a.lo * y` and `a.hi * y`
  obtain ⟨hA1, hA2⟩ := between_mul_right (l := a.lo) (h := a.hi) (x := x) y hx1 hx2
  -- bound `a.lo * y` and `a.hi * y` by the four corner products
  obtain ⟨hB1, hB2⟩ := between_mul_right (l := b.lo) (h := b.hi) (x := y) a.lo hy1 hy2
  obtain ⟨hC1, hC2⟩ := between_mul_right (l := b.lo) (h := b.hi) (x := y) a.hi hy1 hy2
  rw [mul_comm b.lo a.lo, mul_comm b.hi a.lo] at hB1 hB2
  rw [mul_comm b.lo a.hi, mul_comm b.hi a.hi] at hC1 hC2
  rw [mul_comm y a.lo] at hB1 hB2
  rw [mul_comm y a.hi] at hC1 hC2
  constructor
  · refine le_trans ?_ hA1
    refine le_min ?_ ?_
    · exact le_trans (min_le_left _ _) hB1
    · exact le_trans (min_le_right _ _) hC1
  · refine le_trans hA2 ?_
    refine max_le ?_ ?_
    · exact le_trans hB2 (le_max_left _ _)
    · exact le_trans hC2 (le_max_right _ _)

/-- On nonnegative intervals the product is the obvious one. -/
theorem mul_of_nonneg {a b : Interval} (ha : 0 ≤ a.lo) (hb : 0 ≤ b.lo) :
    (a * b).lo = a.lo * b.lo ∧ (a * b).hi = a.hi * b.hi := by
  have ha' : 0 ≤ a.hi := le_trans ha a.le
  have hb' : 0 ≤ b.hi := le_trans hb b.le
  constructor
  · simp only [mul_lo]
    have h1 : a.lo * b.lo ≤ a.lo * b.hi := mul_le_mul_of_nonneg_left b.le ha
    have h2 : a.lo * b.lo ≤ a.hi * b.lo := mul_le_mul_of_nonneg_right a.le hb
    have h3 : a.lo * b.lo ≤ a.hi * b.hi := le_trans h1 (mul_le_mul_of_nonneg_right a.le hb')
    exact le_antisymm (le_trans (min_le_left _ _) (min_le_left _ _))
      (le_min (le_min (le_refl _) h1) (le_min h2 h3))
  · simp only [mul_hi]
    have h1 : a.lo * b.lo ≤ a.hi * b.hi := by nlinarith [a.le, b.le]
    have h2 : a.lo * b.hi ≤ a.hi * b.hi := mul_le_mul_of_nonneg_right a.le hb'
    have h3 : a.hi * b.lo ≤ a.hi * b.hi := mul_le_mul_of_nonneg_left b.le ha'
    exact le_antisymm (max_le (max_le h1 h2) (max_le h3 (le_refl _)))
      (le_trans (le_max_right _ _) (le_max_right _ _))

/-- Scaling by a rational constant. -/
def smul (c : ℚ) (a : Interval) : Interval := mul (point c) a

theorem smul_mem {a : Interval} {c x : ℚ} (hx : x ∈ a) : c * x ∈ smul c a :=
  mul_mem (point_mem c) hx

/-! ### Intersection, overlap, and the conflict witness -/

/-- Two intervals overlap when they share a point. -/
def Overlaps (a b : Interval) : Prop := a.lo ≤ b.hi ∧ b.lo ≤ a.hi

instance (a b : Interval) : Decidable (Overlaps a b) := by unfold Overlaps; infer_instance

theorem overlaps_comm {a b : Interval} (h : Overlaps a b) : Overlaps b a := ⟨h.2, h.1⟩

theorem overlaps_refl (a : Interval) : Overlaps a a := ⟨a.le, a.le⟩

/-- Overlap is exactly nonempty intersection. -/
theorem overlaps_iff_exists_mem {a b : Interval} : Overlaps a b ↔ ∃ x, x ∈ a ∧ x ∈ b := by
  constructor
  · rintro ⟨h1, h2⟩
    exact ⟨max a.lo b.lo, ⟨le_max_left _ _, max_le a.le h2⟩, ⟨le_max_right _ _, max_le h1 b.le⟩⟩
  · rintro ⟨x, ⟨ha1, ha2⟩, ⟨hb1, hb2⟩⟩
    exact ⟨le_trans ha1 hb2, le_trans hb1 ha2⟩

/-- Two intervals are *separated* when one lies strictly below the other.  This
is the content of a conflict certificate. -/
def Separated (a b : Interval) : Prop := b.hi < a.lo ∨ a.hi < b.lo

instance (a b : Interval) : Decidable (Separated a b) := by unfold Separated; infer_instance

/-- Conflict-witness soundness: a separation witness really does rule out any
common value.  This is the direction that makes a published conflict
certificate meaningful. -/
theorem not_exists_mem_of_separated {a b : Interval} (h : Separated a b) :
    ¬ ∃ x, x ∈ a ∧ x ∈ b := by
  rintro ⟨x, ⟨ha1, ha2⟩, ⟨hb1, hb2⟩⟩
  rcases h with h | h <;> linarith

theorem separated_iff_not_overlaps {a b : Interval} : Separated a b ↔ ¬ Overlaps a b := by
  constructor
  · intro h hov
    exact not_exists_mem_of_separated h (overlaps_iff_exists_mem.mp hov)
  · intro h
    unfold Overlaps at h
    unfold Separated
    by_contra hc
    push_neg at hc
    exact h ⟨by linarith [hc.1], by linarith [hc.2]⟩

/-- The intersection of two overlapping intervals. -/
def inter (a b : Interval) (h : Overlaps a b) : Interval :=
  ⟨max a.lo b.lo, min a.hi b.hi, le_min (max_le a.le h.2) (max_le h.1 b.le)⟩

@[simp] theorem mem_inter {a b : Interval} {h : Overlaps a b} {x : ℚ} :
    x ∈ inter a b h ↔ x ∈ a ∧ x ∈ b := by
  simp only [mem_iff, inter, max_le_iff, le_min_iff]
  constructor
  · rintro ⟨⟨h1, h2⟩, h3, h4⟩; exact ⟨⟨h1, h3⟩, h2, h4⟩
  · rintro ⟨⟨h1, h2⟩, h3, h4⟩; exact ⟨⟨h1, h3⟩, h2, h4⟩

/-- Adding evidence never widens the accepted set: an intersection is contained
in each of its factors. -/
theorem inter_subset_left {a b : Interval} {h : Overlaps a b} {x : ℚ}
    (hx : x ∈ inter a b h) : x ∈ a := (mem_inter.mp hx).1

theorem inter_subset_right {a b : Interval} {h : Overlaps a b} {x : ℚ}
    (hx : x ∈ inter a b h) : x ∈ b := (mem_inter.mp hx).2

theorem inter_width_le {a b : Interval} {h : Overlaps a b} :
    (inter a b h).width ≤ a.width ∧ (inter a b h).width ≤ b.width := by
  simp only [width, inter]
  constructor
  · have := min_le_left a.hi b.hi
    have := le_max_left a.lo b.lo
    linarith
  · have := min_le_right a.hi b.hi
    have := le_max_right a.lo b.lo
    linarith

end Interval

/-! ### Dimension-indexed intervals

An uncertain quantity is an interval that also carries its dimension, so the
same elaboration-time discipline applies to uncertain values.
-/

/-- An uncertain quantity of dimension `d`. -/
structure IQty (d : Dim) where
  iv : Interval
deriving Repr

namespace IQty

/-- The values of dimension `d` consistent with an uncertain quantity. -/
def Contains {d : Dim} (q : IQty d) (x : Qty d) : Prop := x.value ∈ q.iv

instance {d : Dim} : Membership (Qty d) (IQty d) := ⟨fun q x => q.Contains x⟩

@[simp] theorem mem_iff {d : Dim} {q : IQty d} {x : Qty d} :
    x ∈ q ↔ q.iv.lo ≤ x.value ∧ x.value ≤ q.iv.hi := Iff.rfl

instance {d : Dim} (q : IQty d) (x : Qty d) : Decidable (x ∈ q) :=
  decidable_of_iff (x.value ∈ q.iv) Iff.rfl

def point {d : Dim} (x : Qty d) : IQty d := ⟨Interval.point x.value⟩

instance {d : Dim} : Add (IQty d) := ⟨fun a b => ⟨a.iv + b.iv⟩⟩
instance {d : Dim} : Sub (IQty d) := ⟨fun a b => ⟨a.iv - b.iv⟩⟩
instance {d : Dim} : Neg (IQty d) := ⟨fun a => ⟨-a.iv⟩⟩

@[simp] theorem add_iv {d : Dim} (a b : IQty d) : (a + b).iv = a.iv + b.iv := rfl
@[simp] theorem sub_iv {d : Dim} (a b : IQty d) : (a - b).iv = a.iv - b.iv := rfl

theorem add_mem {d : Dim} {a b : IQty d} {x y : Qty d} (hx : x ∈ a) (hy : y ∈ b) :
    x + y ∈ a + b := Interval.add_mem hx hy

theorem sub_mem {d : Dim} {a b : IQty d} {x y : Qty d} (hx : x ∈ a) (hy : y ∈ b) :
    x - y ∈ a - b := Interval.sub_mem hx hy

theorem neg_mem {d : Dim} {a : IQty d} {x : Qty d} (hx : x ∈ a) : -x ∈ -a :=
  Interval.neg_mem hx

/-- Multiplication of uncertain quantities multiplies the dimensions. -/
def mul {d₁ d₂ : Dim} (a : IQty d₁) (b : IQty d₂) : IQty (d₁ * d₂) := ⟨a.iv * b.iv⟩

theorem mul_mem {d₁ d₂ : Dim} {a : IQty d₁} {b : IQty d₂} {x : Qty d₁} {y : Qty d₂}
    (hx : x ∈ a) (hy : y ∈ b) : Qty.mul x y ∈ mul a b := Interval.mul_mem hx hy

/-- Transport an uncertain quantity along an equality of dimensions. -/
def cast {d₁ d₂ : Dim} (_h : d₁ = d₂) (a : IQty d₁) : IQty d₂ := ⟨a.iv⟩

/-- Sound `area × yield` propagation: the harvest interval encloses every
product of an area in the acreage interval with a yield in the yield interval.
This is the milestone theorem for the satellite estimate. -/
def harvest (a : IQty Dim.area) (y : IQty Dim.yield) : IQty Dim.mass :=
  cast Dim.area_mul_yield (mul a y)

theorem harvest_mem {A : IQty Dim.area} {Y : IQty Dim.yield}
    {a : Qty Dim.area} {y : Qty Dim.yield} (ha : a ∈ A) (hy : y ∈ Y) :
    Qty.harvest a y ∈ harvest A Y := Interval.mul_mem ha hy

/-- The width of an uncertain quantity: its declared uncertainty. -/
def width {d : Dim} (a : IQty d) : ℚ := a.iv.width

end IQty

end RequestProject.Economy
