import RequestProject.Gvcs.Voxel.Parts

/-!
# From occupancy functions to bricks

A solid is a *function*, and a function cannot be handed to a renderer.  This
file compiles a solid, inside a finite window, into a list of axis-aligned
bricks — maximal runs of occupied voxels along `x` — and proves that the bricks
say exactly what the function said:

* `bricksSolid_bricksOf_sound` — every voxel of every emitted brick really is
  material of the original solid, anywhere in the lattice;
* `bricksSolid_bricksOf_complete` — every material voxel inside the window is
  covered by some emitted brick;
* `bricksOf_correct` — so inside the window the brick list and the function
  are the same solid.

The run-length step is `rowRuns`, whose specification `rowRuns_spec` says that
the runs of a row cover exactly the occupied cells of that row inside the
window.  `RequestProject/Voxel/Lua.lean` turns the bricks into Roblox parts.
-/

namespace LifeTrac
namespace Voxel

open Solid

/-! ## Runs along a row -/

/-- Add the cell at `x` to the runs of the rest of a row, extending the first
run if it starts at `x + 1`. -/
def mergeHead (x : ℤ) : List (ℤ × ℤ) → List (ℤ × ℤ)
  | [] => [(x, 1)]
  | (a, l) :: rest => if a = x + 1 then (x, l + 1) :: rest else (x, 1) :: (a, l) :: rest

/-- The maximal runs of occupied cells of the row `f`, in the `n` cells
starting at `x`.  Each run is a start and a length. -/
def rowRuns (f : ℤ → Bool) (x : ℤ) : ℕ → List (ℤ × ℤ)
  | 0 => []
  | n + 1 => if f x then mergeHead x (rowRuns f (x + 1) n) else rowRuns f (x + 1) n

/-- Is the cell `t` inside one of the runs? -/
def runsCover (rs : List (ℤ × ℤ)) (t : ℤ) : Bool :=
  rs.any (fun p => decide (p.1 ≤ t ∧ t < p.1 + p.2))

@[simp] theorem runsCover_nil (t : ℤ) : runsCover [] t = false := rfl

@[simp] theorem runsCover_cons (p : ℤ × ℤ) (rs : List (ℤ × ℤ)) (t : ℤ) :
    runsCover (p :: rs) t = (decide (p.1 ≤ t ∧ t < p.1 + p.2) || runsCover rs t) := by
  simp [runsCover]

theorem mergeHead_len_pos {rs : List (ℤ × ℤ)} (h : ∀ p ∈ rs, 1 ≤ p.2) (x : ℤ) :
    ∀ p ∈ mergeHead x rs, 1 ≤ p.2 := by
  cases rs with
  | nil =>
      intro p hp
      simp only [mergeHead, List.mem_singleton] at hp
      subst hp
      simp
  | cons a rest =>
      intro p hp
      by_cases hx : a.1 = x + 1
      · simp only [mergeHead, hx, if_pos] at hp
        rcases List.mem_cons.1 hp with rfl | hp
        · have := h a (List.mem_cons_self ..); simp; omega
        · exact h p (List.mem_cons_of_mem _ hp)
      · simp only [mergeHead, hx, if_neg, not_false_iff] at hp
        rcases List.mem_cons.1 hp with rfl | hp
        · simp
        · exact h p hp

/-- Every run produced by `rowRuns` is non-empty. -/
theorem rowRuns_len_pos (f : ℤ → Bool) : ∀ (n : ℕ) (x : ℤ), ∀ p ∈ rowRuns f x n, 1 ≤ p.2 := by
  intro n
  induction n with
  | zero => intro x p hp; simp [rowRuns] at hp
  | succ n ih =>
      intro x p hp
      by_cases hf : f x
      · simp only [rowRuns, hf, if_pos] at hp
        exact mergeHead_len_pos (ih (x + 1)) x p hp
      · simp only [rowRuns, hf, Bool.false_eq_true, if_neg, not_false_iff] at hp
        exact ih (x + 1) p hp

theorem mergeHead_cover {rs : List (ℤ × ℤ)} (h : ∀ p ∈ rs, 1 ≤ p.2) (x t : ℤ) :
    runsCover (mergeHead x rs) t = (decide (t = x) || runsCover rs t) := by
  cases rs with
  | nil =>
      simp only [mergeHead, runsCover_cons, runsCover_nil, Bool.or_false]
      rw [Bool.eq_iff_iff]
      simp only [decide_eq_true_eq]
      omega
  | cons a rest =>
      have ha : 1 ≤ a.2 := h a (List.mem_cons_self ..)
      by_cases hx : a.1 = x + 1
      · simp only [mergeHead, hx, if_pos, runsCover_cons]
        rw [Bool.eq_iff_iff]
        simp only [Bool.or_eq_true, decide_eq_true_eq]
        constructor
        · rintro (h1 | h1)
          · by_cases ht : t = x
            · exact Or.inl ht
            · exact Or.inr (Or.inl (by omega))
          · exact Or.inr (Or.inr h1)
        · rintro (rfl | h1 | h1)
          · left; omega
          · left; omega
          · right; exact h1
      · simp only [mergeHead, hx, if_neg, not_false_iff, runsCover_cons]
        rw [Bool.eq_iff_iff]
        simp only [Bool.or_eq_true, decide_eq_true_eq]
        constructor
        · rintro (h1 | h1)
          · exact Or.inl (by omega)
          · exact Or.inr h1
        · rintro (rfl | h1)
          · left; omega
          · right; exact h1

/-- The runs of a row cover exactly the occupied cells of that row inside the
window: run-length encoding loses nothing and invents nothing. -/
theorem rowRuns_spec (f : ℤ → Bool) : ∀ (n : ℕ) (x t : ℤ),
    runsCover (rowRuns f x n) t = (f t && decide (x ≤ t ∧ t < x + n)) := by
  intro n
  induction n with
  | zero => intro x t; simp [rowRuns]
  | succ n ih =>
      intro x t
      by_cases hf : f x
      · rw [rowRuns, if_pos hf, mergeHead_cover (rowRuns_len_pos f n (x + 1)), ih (x + 1) t]
        by_cases ht : t = x
        · subst ht
          simp only [decide_true, Bool.true_or, hf, Bool.true_and]
          symm
          simp only [decide_eq_true_eq]
          constructor
          · omega
          · push_cast; omega
        · simp only [ht, decide_false, Bool.false_or]
          cases hft : f t
          · simp
          · simp only [Bool.true_and, decide_eq_decide]
            push_cast
            omega
      · rw [rowRuns, if_neg (by simpa using hf), ih (x + 1) t]
        by_cases ht : t = x
        · subst ht
          simp only [Bool.not_eq_true] at hf
          simp [hf]
        · cases hft : f t
          · simp
          · simp only [Bool.true_and, decide_eq_decide]
            push_cast
            omega

/-! ## Bricks -/

/-- A brick: `len` voxels of material in a row, starting at `x0`, in the row
`(y, z)`.  This is what a renderer can draw with one box. -/
structure Brick where
  /-- The `x` coordinate of the first voxel. -/
  x0 : ℤ
  /-- How many voxels long the brick is. -/
  len : ℤ
  /-- The row's `y`. -/
  y : ℤ
  /-- The row's `z`. -/
  z : ℤ
deriving Repr, DecidableEq, Inhabited

/-- The solid a brick stands for. -/
def Brick.solid (b : Brick) : Solid := box (b.x0, b.y, b.z) (b.x0 + b.len - 1, b.y, b.z)

/-- The solid a list of bricks stands for. -/
def bricksSolid (bs : List Brick) : Solid := unions (bs.map Brick.solid)

/-- The integers from `lo` to `hi` inclusive. -/
def rowList (lo hi : ℤ) : List ℤ := (List.range (hi - lo + 1).toNat).map (fun i : ℕ => lo + (i : ℤ))

theorem mem_rowList {lo hi a : ℤ} : a ∈ rowList lo hi ↔ (lo ≤ a ∧ a ≤ hi) := by
  simp only [rowList, List.mem_map, List.mem_range]
  constructor
  · rintro ⟨i, hi', rfl⟩
    have h : (i : ℤ) < ((hi - lo + 1).toNat : ℤ) := by exact_mod_cast hi'
    omega
  · rintro ⟨h1, h2⟩
    exact ⟨(a - lo).toNat, by omega, by omega⟩

/-- The rows of a window. -/
def yzPairs (lo hi : Vox) : List (ℤ × ℤ) :=
  (rowList lo.y hi.y).flatMap (fun y => (rowList lo.z hi.z).map (fun z => (y, z)))

theorem mem_yzPairs {lo hi : Vox} {p : ℤ × ℤ} :
    p ∈ yzPairs lo hi ↔ (lo.y ≤ p.1 ∧ p.1 ≤ hi.y ∧ lo.z ≤ p.2 ∧ p.2 ≤ hi.z) := by
  simp only [yzPairs, List.mem_flatMap, List.mem_map, mem_rowList]
  constructor
  · rintro ⟨y, ⟨hy1, hy2⟩, z, ⟨hz1, hz2⟩, rfl⟩
    exact ⟨hy1, hy2, hz1, hz2⟩
  · rintro ⟨h1, h2, h3, h4⟩
    exact ⟨p.1, ⟨h1, h2⟩, p.2, ⟨h3, h4⟩, rfl⟩

/-- Compile a solid into bricks, inside the window from `lo` to `hi`. -/
def bricksOf (s : Solid) (lo hi : Vox) : List Brick :=
  (yzPairs lo hi).flatMap (fun p =>
    (rowRuns (fun x => s (x, p.1, p.2)) lo.x (hi.x - lo.x + 1).toNat).map
      (fun r => ⟨r.1, r.2, p.1, p.2⟩))

/-- Every voxel of every emitted brick is material of the original solid: the
compiler invents nothing, anywhere. -/
theorem bricksSolid_bricksOf_sound (s : Solid) (lo hi v : Vox) :
    bricksSolid (bricksOf s lo hi) v = true → s v = true := by
  intro hv
  rw [bricksSolid, unions_eq_true_iff] at hv
  obtain ⟨t, ht, hvt⟩ := hv
  obtain ⟨b, hb, rfl⟩ := List.mem_map.1 ht
  obtain ⟨p, hp, hbp⟩ := List.mem_flatMap.1 hb
  obtain ⟨r, hr, rfl⟩ := List.mem_map.1 hbp
  simp only [Brick.solid, mem_box, Vox.x_mk, Vox.y_mk, Vox.z_mk] at hvt
  obtain ⟨hx1, hx2, hy1, hy2, hz1, hz2⟩ := hvt
  have hcov : runsCover (rowRuns (fun x => s (x, p.1, p.2)) lo.x (hi.x - lo.x + 1).toNat) v.x
      = true := by
    refine List.any_eq_true.2 ⟨r, hr, ?_⟩
    simp only [decide_eq_true_eq]
    omega
  rw [rowRuns_spec] at hcov
  simp only [Bool.and_eq_true] at hcov
  have hs := hcov.1
  have : v = (v.x, p.1, p.2) := by
    have hy : v.y = p.1 := le_antisymm hy2 hy1
    have hz : v.z = p.2 := le_antisymm hz2 hz1
    simp only [Vox.x, Vox.y, Vox.z] at hy hz ⊢
    exact Prod.ext rfl (Prod.ext hy hz)
  rw [this]
  exact hs

/-- Every material voxel inside the window is covered by an emitted brick: the
compiler loses nothing. -/
theorem bricksSolid_bricksOf_complete (s : Solid) (lo hi v : Vox)
    (hw : lo.x ≤ v.x ∧ v.x ≤ hi.x ∧ lo.y ≤ v.y ∧ v.y ≤ hi.y ∧ lo.z ≤ v.z ∧ v.z ≤ hi.z)
    (hs : s v = true) : bricksSolid (bricksOf s lo hi) v = true := by
  obtain ⟨hx1, hx2, hy1, hy2, hz1, hz2⟩ := hw
  have hf : s (v.x, v.y, v.z) = true := hs
  have hcov : runsCover (rowRuns (fun x => s (x, v.y, v.z)) lo.x (hi.x - lo.x + 1).toNat) v.x
      = true := by
    rw [rowRuns_spec]
    simp only [hf, Bool.true_and, decide_eq_true_eq]
    omega
  obtain ⟨r, hr, hcv⟩ := List.any_eq_true.1 hcov
  simp only [decide_eq_true_eq] at hcv
  rw [bricksSolid, unions_eq_true_iff]
  refine ⟨Brick.solid ⟨r.1, r.2, v.y, v.z⟩, ?_, ?_⟩
  · refine List.mem_map.2 ⟨⟨r.1, r.2, v.y, v.z⟩, ?_, rfl⟩
    refine List.mem_flatMap.2 ⟨(v.y, v.z), mem_yzPairs.2 ⟨hy1, hy2, hz1, hz2⟩, ?_⟩
    exact List.mem_map.2 ⟨r, hr, rfl⟩
  · simp only [Brick.solid, mem_box, Vox.x_mk, Vox.y_mk, Vox.z_mk]
    omega

/-- Inside the window, the bricks and the occupancy function are the same
solid. -/
theorem bricksOf_correct (s : Solid) (lo hi v : Vox)
    (hw : lo.x ≤ v.x ∧ v.x ≤ hi.x ∧ lo.y ≤ v.y ∧ v.y ≤ hi.y ∧ lo.z ≤ v.z ∧ v.z ≤ hi.z) :
    bricksSolid (bricksOf s lo hi) v = s v := by
  cases hb : bricksSolid (bricksOf s lo hi) v
  · cases hs : s v
    · rfl
    · exact absurd (bricksSolid_bricksOf_complete s lo hi v hw hs) (by simp [hb])
  · exact (bricksSolid_bricksOf_sound s lo hi v hb).symm

/-- Bricks compose the way solids do: the bricks of a union of two parts cover
the union of the parts. -/
theorem bricksSolid_append (bs cs : List Brick) :
    bricksSolid (bs ++ cs) = cup (bricksSolid bs) (bricksSolid cs) := by
  funext v
  simp only [bricksSolid, List.map_append, cup_apply]
  induction bs with
  | nil => simp
  | cons b bs ih => simp [ih, Bool.or_assoc]

end Voxel
end LifeTrac
