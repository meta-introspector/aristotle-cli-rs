import Mathlib

/-!
# Voxels: an object is a function

Everything the machine is made of is modelled here as a *function* from a point
of the integer lattice to a bit: `Solid := Vox → Bool`, where `Vox = ℤ × ℤ × ℤ`.
A part is not a list of triangles or a record of dimensions, it is the predicate
"is there material here?", and a machine is built by *composing* those
functions — union, intersection, difference, and pullback along a rigid motion
of the lattice.

This file is the algebra of that representation:

* the Boolean algebra of solids (`cup`, `cap`, `sub`, `neg`, `empty`, `full`);
* `box`, the primitive brick, and the axis-aligned membership test;
* `pull`, the pullback of a solid along a lattice map, of which `move`,
  the quarter-turns `rotZ`, `rotX`, `rotY` and the mirrors are instances, with
  the contravariant composition law that makes assemblies composable;
* `Sub` (one solid inside another), `Apart` (two parts that do not
  interpenetrate) and `Touches` (two parts that share a face), which are how
  parts *interact*;
* `count`, the number of occupied voxels in a finite window, with
  inclusion–exclusion and invariance under rigid motion.

`RequestProject/Voxel/Parts.lean` builds the LifeTrac out of these;
`RequestProject/Voxel/Lua.lean` compiles them to Roblox Lua.
-/

namespace LifeTrac
namespace Voxel

/-- A point of the voxel lattice. -/
abbrev Vox := ℤ × ℤ × ℤ

/-- A solid **is** a function: the occupancy predicate of a region of the
lattice. -/
abbrev Solid := Vox → Bool

namespace Vox

/-- The `x` coordinate of a voxel. -/
def x (v : Vox) : ℤ := v.1
/-- The `y` coordinate of a voxel. -/
def y (v : Vox) : ℤ := v.2.1
/-- The `z` coordinate of a voxel. -/
def z (v : Vox) : ℤ := v.2.2

@[simp] theorem x_mk (a b c : ℤ) : x (a, b, c) = a := rfl
@[simp] theorem y_mk (a b c : ℤ) : y (a, b, c) = b := rfl
@[simp] theorem z_mk (a b c : ℤ) : z (a, b, c) = c := rfl

end Vox

namespace Solid

/-! ## The Boolean algebra of solids -/

/-- Nothing. -/
def empty : Solid := fun _ => false

/-- Everything. -/
def full : Solid := fun _ => true

/-- Union: material where either part has material. -/
def cup (s t : Solid) : Solid := fun v => s v || t v

/-- Intersection: material where both parts have material. -/
def cap (s t : Solid) : Solid := fun v => s v && t v

/-- Complement. -/
def neg (s : Solid) : Solid := fun v => !s v

/-- Difference: `s` with `t` cut out of it. -/
def sub (s t : Solid) : Solid := fun v => s v && !t v

/-- The union of a list of parts — how an assembly is put together. -/
def unions (l : List Solid) : Solid := l.foldr cup empty

@[simp] theorem empty_apply (v : Vox) : empty v = false := rfl
@[simp] theorem full_apply (v : Vox) : full v = true := rfl
@[simp] theorem cup_apply (s t : Solid) (v : Vox) : cup s t v = (s v || t v) := rfl
@[simp] theorem cap_apply (s t : Solid) (v : Vox) : cap s t v = (s v && t v) := rfl
@[simp] theorem neg_apply (s : Solid) (v : Vox) : neg s v = !s v := rfl
@[simp] theorem sub_apply (s t : Solid) (v : Vox) : sub s t v = (s v && !t v) := rfl

@[simp] theorem unions_nil : unions [] = empty := rfl
@[simp] theorem unions_cons (s : Solid) (l : List Solid) :
    unions (s :: l) = cup s (unions l) := rfl

theorem cup_comm (s t : Solid) : cup s t = cup t s := by
  funext v; simp [Bool.or_comm]

theorem cup_assoc (s t u : Solid) : cup (cup s t) u = cup s (cup t u) := by
  funext v; simp [Bool.or_assoc]

@[simp] theorem cup_self (s : Solid) : cup s s = s := by funext v; simp

@[simp] theorem cup_empty (s : Solid) : cup s empty = s := by funext v; simp

@[simp] theorem empty_cup (s : Solid) : cup empty s = s := by funext v; simp

theorem cap_comm (s t : Solid) : cap s t = cap t s := by
  funext v; simp [Bool.and_comm]

theorem cap_assoc (s t u : Solid) : cap (cap s t) u = cap s (cap t u) := by
  funext v; simp [Bool.and_assoc]

@[simp] theorem cap_self (s : Solid) : cap s s = s := by funext v; simp

@[simp] theorem cap_empty (s : Solid) : cap s empty = empty := by funext v; simp

@[simp] theorem neg_neg (s : Solid) : neg (neg s) = s := by funext v; simp

theorem sub_eq_cap_neg (s t : Solid) : sub s t = cap s (neg t) := by
  funext v; simp

theorem cap_cup_distrib (s t u : Solid) :
    cap s (cup t u) = cup (cap s t) (cap s u) := by
  funext v; simp [Bool.and_or_distrib_left]

theorem cup_cap_distrib (s t u : Solid) :
    cup s (cap t u) = cap (cup s t) (cup s u) := by
  funext v; simp [Bool.or_and_distrib_left]

theorem neg_cup (s t : Solid) : neg (cup s t) = cap (neg s) (neg t) := by
  funext v; simp

theorem neg_cap (s t : Solid) : neg (cap s t) = cup (neg s) (neg t) := by
  funext v; simp

@[simp] theorem sub_self (s : Solid) : sub s s = empty := by funext v; simp

/-! ## Boxes -/

/-- The brick with corners `lo` and `hi`, both inclusive. -/
def box (lo hi : Vox) : Solid := fun v =>
  decide (lo.x ≤ v.x ∧ v.x ≤ hi.x ∧ lo.y ≤ v.y ∧ v.y ≤ hi.y ∧ lo.z ≤ v.z ∧ v.z ≤ hi.z)

@[simp] theorem box_apply (lo hi v : Vox) :
    box lo hi v =
      decide (lo.x ≤ v.x ∧ v.x ≤ hi.x ∧ lo.y ≤ v.y ∧ v.y ≤ hi.y ∧
        lo.z ≤ v.z ∧ v.z ≤ hi.z) := rfl

theorem mem_box (lo hi v : Vox) :
    box lo hi v = true ↔
      (lo.x ≤ v.x ∧ v.x ≤ hi.x ∧ lo.y ≤ v.y ∧ v.y ≤ hi.y ∧ lo.z ≤ v.z ∧ v.z ≤ hi.z) := by
  simp

/-- A box whose corners are the wrong way round in some axis is empty. -/
theorem box_eq_empty_of_lt {lo hi : Vox} (h : hi.x < lo.x ∨ hi.y < lo.y ∨ hi.z < lo.z) :
    box lo hi = empty := by
  funext v
  simp only [box_apply, empty_apply, decide_eq_false_iff_not]
  rcases h with h | h | h <;> omega

/-- A box is contained in a bigger box. -/
theorem box_mono {lo hi lo' hi' : Vox}
    (hx : lo'.x ≤ lo.x ∧ hi.x ≤ hi'.x) (hy : lo'.y ≤ lo.y ∧ hi.y ≤ hi'.y)
    (hz : lo'.z ≤ lo.z ∧ hi.z ≤ hi'.z) :
    ∀ v, box lo hi v = true → box lo' hi' v = true := by
  intro v hv
  simp only [mem_box] at hv ⊢
  omega

/-! ## Rigid motions: pullback of a solid along a lattice map -/

/-- Pull a solid back along a lattice map: `pull f s` has material at `v`
exactly when `s` has material at `f v`.  Every placement of a part in an
assembly is of this form, and this is where the *composition* of objects as
functions happens. -/
def pull (f : Vox → Vox) (s : Solid) : Solid := fun v => s (f v)

@[simp] theorem pull_apply (f : Vox → Vox) (s : Solid) (v : Vox) :
    pull f s v = s (f v) := rfl

@[simp] theorem pull_id (s : Solid) : pull id s = s := rfl

/-- Pullback is contravariantly functorial: placing a placed part composes the
two maps. -/
theorem pull_pull (f g : Vox → Vox) (s : Solid) :
    pull f (pull g s) = pull (g ∘ f) s := rfl

@[simp] theorem pull_empty (f : Vox → Vox) : pull f empty = empty := rfl
@[simp] theorem pull_full (f : Vox → Vox) : pull f full = full := rfl

theorem pull_cup (f : Vox → Vox) (s t : Solid) :
    pull f (cup s t) = cup (pull f s) (pull f t) := rfl

theorem pull_cap (f : Vox → Vox) (s t : Solid) :
    pull f (cap s t) = cap (pull f s) (pull f t) := rfl

theorem pull_sub (f : Vox → Vox) (s t : Solid) :
    pull f (sub s t) = sub (pull f s) (pull f t) := rfl

theorem pull_unions (f : Vox → Vox) (l : List Solid) :
    pull f (unions l) = unions (l.map (pull f)) := by
  induction l with
  | nil => rfl
  | cons a l ih => simpa [pull_cup] using congrArg (cup (pull f a)) ih

/-- Move a part by `d`. -/
def move (d : Vox) (s : Solid) : Solid := pull (fun v => v - d) s

@[simp] theorem move_apply (d : Vox) (s : Solid) (v : Vox) :
    move d s v = s (v - d) := rfl

@[simp] theorem move_zero (s : Solid) : move 0 s = s := by
  funext v; simp

/-- Moves compose by adding the offsets. -/
theorem move_move (d e : Vox) (s : Solid) :
    move d (move e s) = move (d + e) s := by
  funext v; simp [sub_sub]

theorem move_cup (d : Vox) (s t : Solid) :
    move d (cup s t) = cup (move d s) (move d t) := rfl

theorem move_unions (d : Vox) (l : List Solid) :
    move d (unions l) = unions (l.map (move d)) :=
  pull_unions _ l

/-- Moving a box moves its corners. -/
theorem move_box (d lo hi : Vox) :
    move d (box lo hi) = box (lo + d) (hi + d) := by
  funext v
  simp only [move_apply, box_apply]
  congr 1
  simp only [eq_iff_iff]
  constructor <;>
    (intro h
     obtain ⟨h1, h2, h3, h4, h5, h6⟩ := h
     refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩) <;>
    simp only [Vox.x, Vox.y, Vox.z, Prod.fst_sub, Prod.snd_sub, Prod.fst_add, Prod.snd_add] at * <;>
    omega

/-- A quarter turn about the `z` axis, as a map of the lattice. -/
def rotZmap (v : Vox) : Vox := (-v.y, v.x, v.z)

/-- A quarter turn about the `x` axis. -/
def rotXmap (v : Vox) : Vox := (v.x, -v.z, v.y)

/-- A quarter turn about the `y` axis. -/
def rotYmap (v : Vox) : Vox := (v.z, v.y, -v.x)

/-- Mirror in the plane `x = 0`. -/
def mirrorXmap (v : Vox) : Vox := (-v.x, v.y, v.z)

/-- Turn a part a quarter turn about the `z` axis. -/
def rotZ (s : Solid) : Solid := pull rotZmap s

/-- Turn a part a quarter turn about the `x` axis. -/
def rotX (s : Solid) : Solid := pull rotXmap s

/-- Turn a part a quarter turn about the `y` axis. -/
def rotY (s : Solid) : Solid := pull rotYmap s

/-- Reflect a part in the plane `x = 0`. -/
def mirrorX (s : Solid) : Solid := pull mirrorXmap s

@[simp] theorem mirrorXmap_mirrorXmap (v : Vox) : mirrorXmap (mirrorXmap v) = v := by
  simp [mirrorXmap, Vox.x, Vox.y, Vox.z]

/-- Mirroring twice is the identity. -/
@[simp] theorem mirrorX_mirrorX (s : Solid) : mirrorX (mirrorX s) = s := by
  funext v; simp [mirrorX, pull]

/-- Four quarter turns about the `z` axis are the identity. -/
@[simp] theorem rotZ_four (s : Solid) : rotZ (rotZ (rotZ (rotZ s))) = s := by
  funext v; simp [rotZ, pull, rotZmap, Vox.x, Vox.y, Vox.z]

/-- Four quarter turns about the `x` axis are the identity. -/
@[simp] theorem rotX_four (s : Solid) : rotX (rotX (rotX (rotX s))) = s := by
  funext v; simp [rotX, pull, rotXmap, Vox.x, Vox.y, Vox.z]

/-- Four quarter turns about the `y` axis are the identity. -/
@[simp] theorem rotY_four (s : Solid) : rotY (rotY (rotY (rotY s))) = s := by
  funext v; simp [rotY, pull, rotYmap, Vox.x, Vox.y, Vox.z]

theorem rotZ_cup (s t : Solid) : rotZ (cup s t) = cup (rotZ s) (rotZ t) := rfl
theorem mirrorX_cup (s t : Solid) : mirrorX (cup s t) = cup (mirrorX s) (mirrorX t) := rfl

/-! ## How parts interact -/

/-- `s` is a part of `t`. -/
def Sub (s t : Solid) : Prop := ∀ v, s v = true → t v = true

/-- Two parts do not interpenetrate. -/
def Apart (s t : Solid) : Prop := ∀ v, s v = false ∨ t v = false

/-- A list of parts, no two of which interpenetrate. -/
def PairwiseApart (l : List Solid) : Prop := l.Pairwise Apart

@[refl] theorem Sub.rfl (s : Solid) : Sub s s := fun _ h => h

theorem Sub.trans {s t u : Solid} (h₁ : Sub s t) (h₂ : Sub t u) : Sub s u :=
  fun v h => h₂ v (h₁ v h)

theorem Sub.antisymm {s t : Solid} (h₁ : Sub s t) (h₂ : Sub t s) : s = t := by
  funext v
  cases hs : s v <;> cases ht : t v
  · rfl
  · have := h₂ v ht; simp [hs] at this
  · have := h₁ v hs; simp [ht] at this
  · rfl

theorem sub_cup_left (s t : Solid) : Sub s (cup s t) := by
  intro v h; simp [h]

theorem sub_cup_right (s t : Solid) : Sub t (cup s t) := by
  intro v h; simp [h]

theorem cap_sub_left (s t : Solid) : Sub (cap s t) s := by
  intro v h
  simp only [cap_apply, Bool.and_eq_true] at h
  exact h.1

theorem sub_of_mem_unions {l : List Solid} {s : Solid} (h : s ∈ l) : Sub s (unions l) := by
  induction l with
  | nil => cases h
  | cons a l ih =>
      rcases List.mem_cons.1 h with rfl | h
      · exact sub_cup_left _ _
      · exact (ih h).trans (sub_cup_right _ _)

theorem Apart.symm {s t : Solid} (h : Apart s t) : Apart t s := fun v =>
  (h v).symm

theorem apart_iff_cap_empty {s t : Solid} : Apart s t ↔ cap s t = empty := by
  constructor
  · intro h; funext v; rcases h v with h | h <;> simp [h]
  · intro h v
    have := congrFun h v
    simp only [cap_apply, empty_apply, Bool.and_eq_false_iff] at this
    exact this

theorem Apart.mono {s t s' t' : Solid} (h : Apart s t) (hs : Sub s' s) (ht : Sub t' t) :
    Apart s' t' := by
  intro v
  rcases h v with hv | hv
  · left
    by_contra hc
    simp only [Bool.not_eq_false] at hc
    rw [hs v hc] at hv; exact Bool.noConfusion hv
  · right
    by_contra hc
    simp only [Bool.not_eq_false] at hc
    rw [ht v hc] at hv; exact Bool.noConfusion hv

theorem Apart.cup {s t u : Solid} (h₁ : Apart s u) (h₂ : Apart t u) :
    Apart (cup s t) u := by
  intro v
  rcases h₁ v with h | h
  · rcases h₂ v with h' | h'
    · left; simp [h, h']
    · right; exact h'
  · right; exact h

/-- Interpenetration is tested pointwise, so it survives any placement. -/
theorem Apart.pull {s t : Solid} (h : Apart s t) (f : Vox → Vox) :
    Apart (pull f s) (pull f t) := fun v => h (f v)

/-- Two boxes separated along one axis do not interpenetrate. -/
theorem apart_box_of_sep {lo hi lo' hi' : Vox}
    (h : hi.x < lo'.x ∨ hi'.x < lo.x ∨ hi.y < lo'.y ∨ hi'.y < lo.y ∨
      hi.z < lo'.z ∨ hi'.z < lo.z) :
    Apart (box lo hi) (box lo' hi') := by
  intro v
  by_cases h1 : box lo hi v = true
  · right
    simp only [mem_box] at h1
    simp only [box_apply, decide_eq_false_iff_not]
    omega
  · left; simpa using h1

/-- Two parts touch if some voxel of one is face-adjacent to a voxel of the
other — this is where a weld or a bolt goes. -/
def Touches (s t : Solid) : Prop :=
  ∃ v d, s v = true ∧ t (v + d) = true ∧
    (d = ((1 : ℤ), (0 : ℤ), (0 : ℤ)) ∨ d = (-1, 0, 0) ∨ d = (0, 1, 0) ∨ d = (0, -1, 0) ∨
      d = (0, 0, 1) ∨ d = (0, 0, -1))

theorem Touches.symm {s t : Solid} (h : Touches s t) : Touches t s := by
  obtain ⟨v, d, hs, ht, hd⟩ := h
  refine ⟨v + d, -d, ht, by simpa using hs, ?_⟩
  rcases hd with rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp [Prod.ext_iff]

/-! ## Slabs: bounding a part along one axis

A part of the machine is usually kept out of another part's way by a plain
separation along one axis — the loader arms ride above the engine deck, the
left wheels are outboard of the right ones.  `Within` records such a bound and
`apart_of_slab_sep` turns two bounds into non-interpenetration. -/

/-- Every voxel of `s` has its `f`-coordinate between `a` and `b`. -/
def Within (f : Vox → ℤ) (a b : ℤ) (s : Solid) : Prop :=
  ∀ v, s v = true → a ≤ f v ∧ f v ≤ b

theorem Within.mono {f : Vox → ℤ} {a b a' b' : ℤ} {s : Solid} (h : Within f a b s)
    (ha : a' ≤ a) (hb : b ≤ b') : Within f a' b' s := fun v hv =>
  ⟨le_trans ha (h v hv).1, le_trans (h v hv).2 hb⟩

theorem Within.of_sub {f : Vox → ℤ} {a b : ℤ} {s t : Solid} (h : Within f a b t)
    (hst : Sub s t) : Within f a b s := fun v hv => h v (hst v hv)

theorem Within.cup {f : Vox → ℤ} {a b : ℤ} {s t : Solid} (hs : Within f a b s)
    (ht : Within f a b t) : Within f a b (cup s t) := by
  intro v hv
  simp only [cup_apply, Bool.or_eq_true] at hv
  rcases hv with hv | hv
  · exact hs v hv
  · exact ht v hv

theorem Within.empty {f : Vox → ℤ} {a b : ℤ} : Within f a b empty := by
  intro v hv; exact absurd hv (by simp)

theorem Within.unions {f : Vox → ℤ} {a b : ℤ} {l : List Solid}
    (h : ∀ s ∈ l, Within f a b s) : Within f a b (unions l) := by
  induction l with
  | nil => exact Within.empty
  | cons c l ih =>
      exact (h c (List.mem_cons_self ..)).cup (ih fun s hs => h s (List.mem_cons_of_mem _ hs))

theorem within_box_x (lo hi : Vox) : Within Vox.x lo.x hi.x (box lo hi) := by
  intro v hv; simp only [mem_box] at hv; omega

theorem within_box_y (lo hi : Vox) : Within Vox.y lo.y hi.y (box lo hi) := by
  intro v hv; simp only [mem_box] at hv; omega

theorem within_box_z (lo hi : Vox) : Within Vox.z lo.z hi.z (box lo hi) := by
  intro v hv; simp only [mem_box] at hv; omega

/-- Two parts confined to apart slabs along the same axis cannot
interpenetrate. -/
theorem apart_of_slab_sep {f : Vox → ℤ} {a b a' b' : ℤ} {s t : Solid}
    (hs : Within f a b s) (ht : Within f a' b' t) (hsep : b < a' ∨ b' < a) :
    Apart s t := by
  intro v
  by_cases hv : s v = true
  · right
    by_contra hc
    simp only [Bool.not_eq_false] at hc
    have h1 := hs v hv
    have h2 := ht v hc
    omega
  · left; simpa using hv

/-- Every voxel of `s` has its `f`-coordinate at least `a`. -/
def Above (f : Vox → ℤ) (a : ℤ) (s : Solid) : Prop := ∀ v, s v = true → a ≤ f v

/-- Every voxel of `s` has its `f`-coordinate at most `b`. -/
def Below (f : Vox → ℤ) (b : ℤ) (s : Solid) : Prop := ∀ v, s v = true → f v ≤ b

theorem Within.above {f : Vox → ℤ} {a b : ℤ} {s : Solid} (h : Within f a b s) :
    Above f a s := fun v hv => (h v hv).1

theorem Within.below {f : Vox → ℤ} {a b : ℤ} {s : Solid} (h : Within f a b s) :
    Below f b s := fun v hv => (h v hv).2

theorem Above.mono {f : Vox → ℤ} {a a' : ℤ} {s : Solid} (h : Above f a s) (ha : a' ≤ a) :
    Above f a' s := fun v hv => le_trans ha (h v hv)

theorem Above.of_sub {f : Vox → ℤ} {a : ℤ} {s t : Solid} (h : Above f a t) (hst : Sub s t) :
    Above f a s := fun v hv => h v (hst v hv)

theorem Above.cup {f : Vox → ℤ} {a : ℤ} {s t : Solid} (hs : Above f a s) (ht : Above f a t) :
    Above f a (cup s t) := by
  intro v hv
  simp only [cup_apply, Bool.or_eq_true] at hv
  rcases hv with hv | hv
  · exact hs v hv
  · exact ht v hv

theorem Above.empty {f : Vox → ℤ} {a : ℤ} : Above f a empty := by
  intro v hv; exact absurd hv (by simp)

theorem Above.unions {f : Vox → ℤ} {a : ℤ} {l : List Solid} (h : ∀ s ∈ l, Above f a s) :
    Above f a (unions l) := by
  induction l with
  | nil => exact Above.empty
  | cons c l ih =>
      exact (h c (List.mem_cons_self ..)).cup (ih fun s hs => h s (List.mem_cons_of_mem _ hs))

/-- A part that stays above a plane and one that stays below it cannot
interpenetrate. -/
theorem apart_of_above_below {f : Vox → ℤ} {a b : ℤ} {s t : Solid}
    (hs : Above f a s) (ht : Below f b t) (hab : b < a) : Apart s t := by
  intro v
  by_cases hv : s v = true
  · right
    by_contra hc
    simp only [Bool.not_eq_false] at hc
    have := hs v hv
    have := ht v hc
    omega
  · left; simpa using hv

/-- A part's height is unchanged by driving it along the ground. -/
theorem above_z_move_x {a t : ℤ} {s : Solid} (h : Above Vox.z a s) :
    Above Vox.z a (move (t, 0, 0) s) := by
  intro v hv
  simp only [move_apply] at hv
  have := h _ hv
  simpa [Vox.z, Prod.snd_sub] using this

/-- Driving a part along `x` shifts its `x` bounds and leaves the others. -/
theorem within_x_move_x {a b t : ℤ} {s : Solid} (h : Within Vox.x a b s) :
    Within Vox.x (a + t) (b + t) (move (t, 0, 0) s) := by
  intro v hv
  simp only [move_apply] at hv
  have := h _ hv
  simp only [Vox.x, Prod.fst_sub] at this ⊢
  omega

theorem within_y_move_x {a b t : ℤ} {s : Solid} (h : Within Vox.y a b s) :
    Within Vox.y a b (move (t, 0, 0) s) := by
  intro v hv
  simp only [move_apply] at hv
  have := h _ hv
  simpa [Vox.y, Prod.snd_sub] using this

theorem within_z_move_x {a b t : ℤ} {s : Solid} (h : Within Vox.z a b s) :
    Within Vox.z a b (move (t, 0, 0) s) := by
  intro v hv
  simp only [move_apply] at hv
  have := h _ hv
  simpa [Vox.z, Prod.snd_sub] using this

theorem unions_eq_true_iff (l : List Solid) (v : Vox) :
    unions l v = true ↔ ∃ s ∈ l, s v = true := by
  induction l with
  | nil => simp
  | cons a l ih => simp [ih]

/-! ## Counting voxels in a window -/

/-- The number of occupied voxels of `s` inside the window `w`. -/
def count (w : Finset Vox) (s : Solid) : ℕ := (w.filter (fun v => s v = true)).card

theorem count_empty (w : Finset Vox) : count w empty = 0 := by
  simp [count]

theorem count_mono {s t : Solid} (w : Finset Vox) (h : Sub s t) :
    count w s ≤ count w t := by
  apply Finset.card_le_card
  intro v hv
  simp only [Finset.mem_filter] at hv ⊢
  exact ⟨hv.1, h v hv.2⟩

/-- Inclusion–exclusion for voxel counts. -/
theorem count_cup_add_count_cap (w : Finset Vox) (s t : Solid) :
    count w (cup s t) + count w (cap s t) = count w s + count w t := by
  classical
  simp only [count]
  have h1 : w.filter (fun v => cup s t v = true) =
      (w.filter (fun v => s v = true)) ∪ (w.filter (fun v => t v = true)) := by
    ext v; simp [Finset.mem_filter, Finset.mem_union, and_or_left]
  have h2 : w.filter (fun v => cap s t v = true) =
      (w.filter (fun v => s v = true)) ∩ (w.filter (fun v => t v = true)) := by
    ext v; simp only [Finset.mem_filter, Finset.mem_inter, cap_apply, Bool.and_eq_true]; tauto
  rw [h1, h2, Finset.card_union_add_card_inter]

/-- Parts that do not interpenetrate occupy the sum of their voxels. -/
theorem count_cup_of_apart (w : Finset Vox) {s t : Solid} (h : Apart s t) :
    count w (cup s t) = count w s + count w t := by
  have := count_cup_add_count_cap w s t
  rw [apart_iff_cap_empty.1 h, count_empty] at this
  omega

/-- Moving a part moves its occupied voxels: counting a placed part in a window
is counting the part in the pushed-forward window. -/
theorem count_pull (w : Finset Vox) (s : Solid) {f : Vox → Vox}
    (hf : Function.Injective f) :
    count w (pull f s) = count (w.image f) s := by
  classical
  simp only [count, pull_apply]
  rw [Finset.filter_image, Finset.card_image_of_injective _ hf]

theorem count_move (w : Finset Vox) (s : Solid) (d : Vox) :
    count w (move d s) = count (w.image (fun v => v - d)) s :=
  count_pull w s (fun a b hab => by
    have : a - d + d = b - d + d := by rw [hab]
    simpa using this)

end Solid
end Voxel
end LifeTrac
