import Mathlib

/-!
# The spatial half of the playbook language

The formal counterpart of `web/js/space3d.js`, which is what the statements
`view3d`, `camera3d`, `plot3d`, `parametric3d` and `label3d` are drawn with.

A point written in a playbook travels through three stages before it becomes a
pixel:

1. **normalisation** — the author's `view3d` box is mapped affinely onto the
   cube `[-1,1]³`, so the camera never has to know how big the numbers are
   (a codec node at height `144` and a wave at height `1` are framed alike);
2. **the camera frame** — `eye`, `target` and an up *hint* give a right-handed
   orthonormal frame `(right, up, fwd)`;
3. **perspective** — a point is divided by its depth along `fwd`.

What is proved here is what the renderer relies on:

* `fromCube_toCube` — normalisation is invertible, so no information about a
  point is lost on the way into the cube, and `axisMap_lt` — it keeps the order
  along each axis;
* `toCube_lerp` — normalisation is affine, so a straight segment in the
  author's coordinates is still straight in the cube: that is why a
  `plot3d line` may be drawn from its two projected endpoints alone;
* `frame_orthonormal` — the camera frame really is orthonormal, for every eye,
  target and up hint that are not degenerate, so the camera transform neither
  stretches nor shears the picture;
* `project_ray` — every point of a viewing ray lands on the same pixel, which
  is what makes the projection a perspective one, and `project_target` — the
  target sits at the centre of the frame;
* `depth_lerp`, `depth_clipPoint` — depth is affine along a segment and the
  near-plane clip lands exactly on the near plane;
* `painterSort_perm`, `painterSort_sorted` — the painter's algorithm emits
  every item exactly once, ordered far to near.
-/

namespace Hesper.Space3D

noncomputable section

/-- A point (or vector) of the space a 3D playbook draws in. -/
structure V3 where
  /-- First coordinate. -/
  x : ℝ
  /-- Second coordinate. -/
  y : ℝ
  /-- Third coordinate. -/
  z : ℝ

namespace V3

/-- Difference of two points. -/
def sub (a b : V3) : V3 := ⟨a.x - b.x, a.y - b.y, a.z - b.z⟩

/-- Sum of two points. -/
def add (a b : V3) : V3 := ⟨a.x + b.x, a.y + b.y, a.z + b.z⟩

/-- Scalar multiple. -/
def smul (k : ℝ) (a : V3) : V3 := ⟨k * a.x, k * a.y, k * a.z⟩

/-- Euclidean inner product. -/
def dot (a b : V3) : ℝ := a.x * b.x + a.y * b.y + a.z * b.z

/-- Cross product. -/
def cross (a b : V3) : V3 :=
  ⟨a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x⟩

/-- Euclidean length. -/
def norm (a : V3) : ℝ := Real.sqrt (dot a a)

/-- The unit vector in the direction of `a`; the zero vector is left alone
(exactly as `HesperSpace3D.unit` does). -/
def unit (a : V3) : V3 :=
  if norm a = 0 then ⟨0, 0, 0⟩ else smul (1 / norm a) a

/-- The point a fraction `s` of the way from `a` to `b`. -/
def lerp (a b : V3) (s : ℝ) : V3 := add a (smul s (sub b a))

theorem dot_self_nonneg (a : V3) : 0 ≤ dot a a := by
  have h : dot a a = a.x ^ 2 + a.y ^ 2 + a.z ^ 2 := by simp [dot]; ring
  rw [h]; positivity

@[simp] theorem norm_sq (a : V3) : norm a ^ 2 = dot a a :=
  Real.sq_sqrt (dot_self_nonneg a)

theorem norm_nonneg (a : V3) : 0 ≤ norm a := Real.sqrt_nonneg _

theorem dot_comm (a b : V3) : dot a b = dot b a := by simp [dot]; ring

/-- The cross product is orthogonal to its left argument. -/
@[simp] theorem dot_cross_left (a b : V3) : dot (cross a b) a = 0 := by
  simp [dot, cross]; ring

/-- The cross product is orthogonal to its right argument. -/
@[simp] theorem dot_cross_right (a b : V3) : dot (cross a b) b = 0 := by
  simp [dot, cross]; ring

/-- Lagrange's identity. -/
theorem dot_cross_self (a b : V3) :
    dot (cross a b) (cross a b) = dot a a * dot b b - dot a b ^ 2 := by
  simp [dot, cross]; ring

theorem dot_smul_left (k : ℝ) (a b : V3) : dot (smul k a) b = k * dot a b := by
  simp [dot, smul]; ring

theorem dot_smul_right (k : ℝ) (a b : V3) : dot a (smul k b) = k * dot a b := by
  simp [dot, smul]; ring

/-- A vector with a length is normalised to a unit vector. -/
theorem dot_unit_self {a : V3} (h : norm a ≠ 0) : dot (unit a) (unit a) = 1 := by
  have hsq : norm a ^ 2 = dot a a := norm_sq a
  simp only [unit, if_neg h, dot_smul_left, dot_smul_right]
  field_simp
  linarith [hsq]

theorem norm_unit {a : V3} (h : norm a ≠ 0) : norm (unit a) = 1 := by
  have h1 := dot_unit_self h
  simp [norm, h1]

/-- `unit` only rescales, so it does not change orthogonality. -/
theorem dot_unit_left (a b : V3) (h : dot a b = 0) : dot (unit a) b = 0 := by
  by_cases hn : norm a = 0
  · simp [unit, hn, dot]
  · simp [unit, if_neg hn, dot_smul_left, h]

/-- A vector is its length times its direction. -/
theorem dot_eq_norm_mul_dot_unit {a : V3} (h : norm a ≠ 0) (b : V3) :
    dot a b = norm a * dot (unit a) b := by
  simp only [unit, if_neg h, dot_smul_left]
  field_simp

end V3

open V3

/-! ## The `view3d` box -/

/-- The author's spatial window: `view3d x x0..x1 y y0..y1 z z0..z1`. -/
structure Box where
  /-- Low end of the x window. -/
  x0 : ℝ
  /-- High end of the x window. -/
  x1 : ℝ
  /-- Low end of the y window. -/
  y0 : ℝ
  /-- High end of the y window. -/
  y1 : ℝ
  /-- Low end of the z window. -/
  z0 : ℝ
  /-- High end of the z window. -/
  z1 : ℝ

/-- One axis of the normalisation: `[a, b]` onto `[-1, 1]`. -/
def axisMap (v a b : ℝ) : ℝ := if b - a = 0 then 0 else 2 * (v - a) / (b - a) - 1

/-- The inverse of `axisMap`. -/
def axisUnmap (u a b : ℝ) : ℝ := a + (u + 1) / 2 * (b - a)

@[simp] theorem axisMap_low {a b : ℝ} (h : a ≠ b) : axisMap a a b = -1 := by
  have hb : b - a ≠ 0 := sub_ne_zero.mpr (Ne.symm h)
  simp [axisMap, hb]

@[simp] theorem axisMap_high {a b : ℝ} (h : a ≠ b) : axisMap b a b = 1 := by
  have hb : b - a ≠ 0 := sub_ne_zero.mpr (Ne.symm h)
  rw [axisMap, if_neg hb]
  field_simp
  norm_num

theorem axisUnmap_axisMap {a b : ℝ} (h : a ≠ b) (v : ℝ) : axisUnmap (axisMap v a b) a b = v := by
  have hb : b - a ≠ 0 := sub_ne_zero.mpr (Ne.symm h)
  simp only [axisMap, axisUnmap, if_neg hb]
  field_simp
  ring

/-- Normalisation keeps the order along an axis. -/
theorem axisMap_lt {a b : ℝ} (h : a < b) {v w : ℝ} (hvw : v < w) :
    axisMap v a b < axisMap w a b := by
  have hb : b - a ≠ 0 := sub_ne_zero.mpr (Ne.symm (ne_of_lt h))
  have hpos : 0 < b - a := by linarith
  simp only [axisMap, if_neg hb, sub_lt_sub_iff_right]
  exact (div_lt_div_iff_of_pos_right hpos).mpr (by linarith)

/-- Normalisation is affine. -/
theorem axisMap_lerp {a b : ℝ} (v w s : ℝ) :
    axisMap (v + s * (w - v)) a b = axisMap v a b + s * (axisMap w a b - axisMap v a b) := by
  by_cases hb : b - a = 0
  · simp [axisMap, hb]
  · simp only [axisMap, if_neg hb]
    field_simp
    ring

/-- A point of the author's box, in the normalised cube `[-1,1]³`. -/
def toCube (B : Box) (p : V3) : V3 :=
  ⟨axisMap p.x B.x0 B.x1, axisMap p.y B.y0 B.y1, axisMap p.z B.z0 B.z1⟩

/-- The inverse of `toCube`. -/
def fromCube (B : Box) (q : V3) : V3 :=
  ⟨axisUnmap q.x B.x0 B.x1, axisUnmap q.y B.y0 B.y1, axisUnmap q.z B.z0 B.z1⟩

/-- A box with three genuine windows. -/
structure Box.Proper (B : Box) : Prop where
  /-- The x window is not a point. -/
  hx : B.x0 ≠ B.x1
  /-- The y window is not a point. -/
  hy : B.y0 ≠ B.y1
  /-- The z window is not a point. -/
  hz : B.z0 ≠ B.z1

/-- Normalising a point and reading it back recovers it: nothing about a point
is lost on the way into the cube. -/
theorem fromCube_toCube {B : Box} (hB : B.Proper) (p : V3) : fromCube B (toCube B p) = p := by
  obtain ⟨hx, hy, hz⟩ := hB
  simp [fromCube, toCube, axisUnmap_axisMap hx, axisUnmap_axisMap hy, axisUnmap_axisMap hz]

/-- Normalisation is affine, so a straight segment stays straight: a
`plot3d line` may be drawn from its two projected endpoints. -/
theorem toCube_lerp (B : Box) (p q : V3) (s : ℝ) :
    toCube B (lerp p q s) = lerp (toCube B p) (toCube B q) s := by
  simp only [toCube, lerp, add, smul, sub, V3.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> simpa using axisMap_lerp _ _ s

/-! ## The camera -/

/-- A right-handed orthonormal frame: where the camera's *right*, *up* and
*forward* directions point. -/
structure Frame where
  /-- The direction to the right of the frame. -/
  right : V3
  /-- The direction up the frame. -/
  up : V3
  /-- The viewing direction. -/
  fwd : V3

/-- The frame of a camera at `eye` looking at `target`, with `upHint` only a
hint: the frame's `up` is the part of the hint orthogonal to the view. -/
def frameOf (eye target upHint : V3) : Frame :=
  { right := unit (cross (unit (sub target eye)) upHint),
    up := cross (unit (cross (unit (sub target eye)) upHint)) (unit (sub target eye)),
    fwd := unit (sub target eye) }

/-- The frame is well defined: the camera is somewhere other than its target,
and the up hint is not the viewing direction. -/
structure Frame.Ok (eye target upHint : V3) : Prop where
  /-- The camera does not sit on its target. -/
  hf : norm (sub target eye) ≠ 0
  /-- The up hint is not parallel to the viewing direction. -/
  hr : norm (cross (unit (sub target eye)) upHint) ≠ 0

/-- **The camera frame is orthonormal.**  Its three directions are unit vectors
and pairwise orthogonal, so the camera transform is a rotation: it neither
stretches nor shears the picture. -/
theorem frame_orthonormal {eye target upHint : V3} (h : Frame.Ok eye target upHint) :
    dot (frameOf eye target upHint).right (frameOf eye target upHint).right = 1 ∧
    dot (frameOf eye target upHint).up (frameOf eye target upHint).up = 1 ∧
    dot (frameOf eye target upHint).fwd (frameOf eye target upHint).fwd = 1 ∧
    dot (frameOf eye target upHint).right (frameOf eye target upHint).up = 0 ∧
    dot (frameOf eye target upHint).right (frameOf eye target upHint).fwd = 0 ∧
    dot (frameOf eye target upHint).up (frameOf eye target upHint).fwd = 0 := by
  obtain ⟨hf, hr⟩ := h
  have hff : dot (unit (sub target eye)) (unit (sub target eye)) = 1 := dot_unit_self hf
  have hrr : dot (unit (cross (unit (sub target eye)) upHint))
      (unit (cross (unit (sub target eye)) upHint)) = 1 := dot_unit_self hr
  have hrf : dot (unit (cross (unit (sub target eye)) upHint)) (unit (sub target eye)) = 0 :=
    dot_unit_left _ _ (dot_cross_left _ _)
  refine ⟨hrr, ?_, hff, ?_, hrf, ?_⟩
  · show dot (cross (unit (cross (unit (sub target eye)) upHint)) (unit (sub target eye)))
      (cross (unit (cross (unit (sub target eye)) upHint)) (unit (sub target eye))) = 1
    rw [dot_cross_self, hrr, hff, hrf]; ring
  · show dot (unit (cross (unit (sub target eye)) upHint))
      (cross (unit (cross (unit (sub target eye)) upHint)) (unit (sub target eye))) = 0
    rw [dot_comm]; exact dot_cross_left _ _
  · show dot (cross (unit (cross (unit (sub target eye)) upHint)) (unit (sub target eye)))
      (unit (sub target eye)) = 0
    exact dot_cross_right _ _

/-- A camera: where it is, which way it looks, how long its focal length is and
where the centre of its frame sits in pixels. -/
structure Camera where
  /-- Position of the camera. -/
  eye : V3
  /-- Orientation of the camera. -/
  frame : Frame
  /-- Focal length in pixels (`zoom · (h/2) / tan(fov/2)` in the studio). -/
  focal : ℝ
  /-- Horizontal centre of the frame, in pixels. -/
  cx : ℝ
  /-- Vertical centre of the frame, in pixels. -/
  cy : ℝ
  /-- Depth at which geometry starts to exist. -/
  near : ℝ

namespace Camera

/-- Depth of a point: how far it lies along the viewing direction. -/
def depth (C : Camera) (p : V3) : ℝ := dot (sub p C.eye) C.frame.fwd

/-- Sideways camera coordinate. -/
def viewX (C : Camera) (p : V3) : ℝ := dot (sub p C.eye) C.frame.right

/-- Upward camera coordinate. -/
def viewY (C : Camera) (p : V3) : ℝ := dot (sub p C.eye) C.frame.up

/-- The pixel a point lands on. -/
def project (C : Camera) (p : V3) : ℝ × ℝ :=
  (C.cx + C.focal * viewX C p / depth C p, C.cy - C.focal * viewY C p / depth C p)

/-- The points the camera can see: those in front of the near plane. -/
def Visible (C : Camera) (p : V3) : Prop := C.near < depth C p

/-- **The projection is a perspective one**: every point of the ray from the
eye through `p` lands on the same pixel. -/
theorem project_ray (C : Camera) (p : V3) {k : ℝ} (hk : k ≠ 0) :
    C.project (add C.eye (smul k (sub p C.eye))) = C.project p := by
  have hsub : sub (add C.eye (smul k (sub p C.eye))) C.eye = smul k (sub p C.eye) := by
    simp [sub, add, smul]
  have key : ∀ u v : ℝ, C.focal * (k * u) / (k * v) = C.focal * u / v := by
    intro u v
    rcases eq_or_ne v 0 with hv | hv
    · simp [hv]
    · field_simp
  simp only [project, depth, viewX, viewY, hsub, dot_smul_left, key]

/-- Depth is affine along a segment. -/
theorem depth_lerp (C : Camera) (a b : V3) (s : ℝ) :
    C.depth (lerp a b s) = C.depth a + s * (C.depth b - C.depth a) := by
  simp [depth, lerp, dot, add, smul, sub]; ring

/-- The near-plane clip of `web/js/space3d.js`: the parameter at which a
segment crosses the near plane. -/
def clipParam (C : Camera) (a b : V3) : ℝ :=
  (C.near - C.depth a) / (C.depth b - C.depth a)

/-- **The clipped endpoint sits exactly on the near plane**, so clipping a
segment neither hides a visible part of it nor keeps an invisible one. -/
theorem depth_clipPoint (C : Camera) {a b : V3} (h : C.depth a ≠ C.depth b) :
    C.depth (lerp a b (C.clipParam a b)) = C.near := by
  have hne : C.depth b - C.depth a ≠ 0 := sub_ne_zero.mpr (Ne.symm h)
  rw [depth_lerp, clipParam, div_mul_cancel₀ _ hne]
  ring

end Camera

/-- The camera of a playbook: `camera3d eye … target … up …`, at the given
focal length and frame centre. -/
def cameraOf (eye target upHint : V3) (focal cx cy near : ℝ) : Camera :=
  { eye := eye, frame := frameOf eye target upHint, focal := focal, cx := cx, cy := cy,
    near := near }

/-- **The camera looks at its target**: the target is projected onto the centre
of the frame, whatever the focal length. -/
theorem project_target {eye target upHint : V3} (h : Frame.Ok eye target upHint)
    (focal cx cy near : ℝ) :
    (cameraOf eye target upHint focal cx cy near).project target = (cx, cy) := by
  obtain ⟨hf, hr⟩ := h
  -- the view vector is orthogonal to both screen directions
  have key : ∀ R : V3, dot (unit (sub target eye)) R = 0 → dot (sub target eye) R = 0 := by
    intro R hR
    rw [dot_eq_norm_mul_dot_unit hf R, hR, mul_zero]
  have hR : dot (sub target eye) (frameOf eye target upHint).right = 0 := by
    refine key _ ?_
    rw [dot_comm]
    exact dot_unit_left _ _ (dot_cross_left _ _)
  have hU : dot (sub target eye) (frameOf eye target upHint).up = 0 := by
    refine key _ ?_
    rw [dot_comm]
    exact dot_cross_right _ _
  simp [Camera.project, Camera.viewX, Camera.viewY, cameraOf, hR, hU]

/-! ## Painter's algorithm -/

open scoped Classical in
/-- The order the studio paints in: farthest first, by depth. -/
def painterSort {α : Type*} (key : α → ℝ) (l : List α) : List α :=
  l.mergeSort (fun a b => decide (key b ≤ key a))

/-- **Nothing is lost and nothing is duplicated** by the depth sort. -/
theorem painterSort_perm {α : Type*} (key : α → ℝ) (l : List α) :
    (painterSort key l).Perm l :=
  List.mergeSort_perm _ _

/-- **The frame is painted back to front**: after the sort, no item is drawn
before an item that is farther away. -/
theorem painterSort_sorted {α : Type*} (key : α → ℝ) (l : List α) :
    (painterSort key l).Pairwise (fun a b => key b ≤ key a) := by
  classical
  have htrans : IsTrans α (fun a b => key b ≤ key a) :=
    ⟨fun _ _ _ hab hbc => le_trans hbc hab⟩
  have htotal : Std.Total (fun a b : α => key b ≤ key a) :=
    ⟨fun a b => le_total (key b) (key a)⟩
  exact List.pairwise_mergeSort' _ l

end

end Hesper.Space3D
