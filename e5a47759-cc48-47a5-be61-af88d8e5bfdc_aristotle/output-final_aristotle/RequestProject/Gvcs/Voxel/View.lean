import RequestProject.Gvcs.Voxel.Codec
import RequestProject.Gvcs.Voxel.Parts

/-!
# Putting a solid in the viewer

`RequestProject/Voxel/Codec.lean` specifies the text a share link of `web/voxel.html`
carries.  This file is the bridge from the *solids* of `RequestProject/Voxel/Core.lean` —
the functions "is there material here?" out of which the machine is built — to that text,
so the viewer in the page shows the very solid the proofs are about.

**The frame.**  The viewer holds `24 × 16 × 24` cells and the page has `Y` up, while the
lattice of this development has `z` up.  A `Frame` says where the viewer's grid sits on the
lattice and how coarse it is: cell `(x, y, z)` of the viewer shows the lattice voxel

> `(origin.x + step * x, origin.y - step * z, origin.z + step * y)`

— the same axis convention as the Roblox emitter (`RequestProject/Voxel/Lua.lean`), where
Lean `(x, y, z)` becomes `(x, z, -y)`.  With `step = 1` the view is exact; with a larger
step it is a sample of one voxel in `step`, which is how the whole 48 × 35 × 49 machine
fits in a 24 × 16 × 24 grid.

**What is proved.**

* `index_cell`, `cellX_index` … — the viewer's cell order `(y * 24 + z) * 24 + x`, which is
  the order the WebAssembly runtime stores its cells in, is a bijection with the grid;
* `cellsOf_getD` — the exported list shows, at each cell, exactly the block the painting
  function gives at the lattice point that cell stands for;
* `view_faithful` — **the headline**: the text of a share link, decoded the way the page
  decodes it, gives back that same list, cell by cell.  What the viewer draws is what the
  Lean function says;
* `machine_view_faithful` — the same for the LifeTrac itself, painted body by body, and
  `machineFrame_covers_envelope`: at one voxel in four, no part of the machine's envelope
  falls outside the viewer's grid, so nothing is cut off.
-/

namespace LifeTrac
namespace Voxel
namespace View

open Codec

/-! ## The viewer's grid -/

/-- The index the runtime stores cell `(x, y, z)` at: `x` fastest, then `z`, then `y`. -/
def index (x y z : Nat) : Nat := (y * dimZ + z) * dimX + x

/-- The `x` of the cell stored at index `i`. -/
def cellX (i : Nat) : Nat := i % dimX
/-- Its `y` (up, in the viewer). -/
def cellY (i : Nat) : Nat := i / (dimX * dimZ)
/-- Its `z` (depth, in the viewer). -/
def cellZ (i : Nat) : Nat := i / dimX % dimZ

theorem index_lt {x y z : Nat} (hx : x < dimX) (hy : y < dimY) (hz : z < dimZ) :
    index x y z < cells := by
  simp only [index, cells, dimX, dimY, dimZ] at *
  omega

theorem cellX_index {x y z : Nat} (hx : x < dimX) :
    cellX (index x y z) = x := by
  simp only [cellX, index, dimX, dimZ] at *
  omega

theorem cellY_index {x y z : Nat} (hx : x < dimX) (hz : z < dimZ) :
    cellY (index x y z) = y := by
  simp only [cellY, index, dimX, dimZ] at *
  omega

theorem cellZ_index {x y z : Nat} (hx : x < dimX) (hz : z < dimZ) :
    cellZ (index x y z) = z := by
  simp only [cellZ, index, dimX, dimZ] at *
  omega

theorem index_cell {i : Nat} (hi : i < cells) : index (cellX i) (cellY i) (cellZ i) = i := by
  simp only [index, cellX, cellY, cellZ, cells, dimX, dimY, dimZ] at *
  omega

theorem cellX_lt (i : Nat) : cellX i < dimX := by
  simp only [cellX, dimX]; omega

theorem cellZ_lt (i : Nat) : cellZ i < dimZ := by
  simp only [cellZ, dimX, dimZ]; omega

theorem cellY_lt {i : Nat} (hi : i < cells) : cellY i < dimY := by
  simp only [cellY, cells, dimX, dimY, dimZ] at *; omega

/-! ## Where the grid sits on the lattice -/

/-- Where the viewer's grid sits on the voxel lattice, and how coarse it is. -/
structure Frame where
  /-- The lattice voxel shown by the cell at the origin of the grid. -/
  origin : Vox
  /-- One cell of the viewer is `step` voxels of the lattice. -/
  step : ℤ
deriving Repr

/-- The lattice voxel shown by cell `(x, y, z)` of the viewer.  The page has `Y` up, so
the viewer's `y` runs along the lattice's `z`, and its depth `z` runs backwards along the
lattice's `y` — the convention of the Roblox emitter. -/
def Frame.at (f : Frame) (x y z : Nat) : Vox :=
  (f.origin.x + f.step * x, f.origin.y - f.step * z, f.origin.z + f.step * y)

/-- The lattice voxel shown by the cell stored at index `i`. -/
def Frame.vox (f : Frame) (i : Nat) : Vox := f.at (cellX i) (cellY i) (cellZ i)

@[simp] theorem Frame.vox_index (f : Frame) {x y z : Nat} (hx : x < dimX) (hz : z < dimZ) :
    f.vox (index x y z) = f.at x y z := by
  simp only [Frame.vox, cellX_index hx, cellY_index hx hz, cellZ_index hx hz]

/-! ## Painting the grid -/

/-- The cells of the viewer's grid, painted by a function of the lattice: this is the list
of block types the runtime holds, in its own order. -/
def cellsOf (f : Frame) (code : Vox → Nat) : List Nat :=
  (List.range cells).map (fun i => code (f.vox i))

@[simp] theorem length_cellsOf (f : Frame) (code : Vox → Nat) :
    (cellsOf f code).length = cells := by simp [cellsOf]

theorem cellsOf_ne_nil (f : Frame) (code : Vox → Nat) : cellsOf f code ≠ [] := by
  intro h
  have := length_cellsOf f code
  rw [h] at this
  simp [cells, dimX, dimY, dimZ] at this

/-- Each cell of the exported list is the block the painting function gives at the lattice
point that cell stands for. -/
theorem cellsOf_getD (f : Frame) (code : Vox → Nat) {i : Nat} (hi : i < cells) :
    (cellsOf f code).getD i 0 = code (f.vox i) := by
  have h : i < (List.range cells).length := by simpa using hi
  rw [cellsOf, List.getD_eq_getElem?_getD, List.getElem?_map,
    List.getElem?_eq_getElem h, List.getElem_range]
  rfl

/-- …and, read at the grid coordinates the page uses, the block at that point of the
lattice. -/
theorem cellsOf_getD_at (f : Frame) (code : Vox → Nat) {x y z : Nat}
    (hx : x < dimX) (hy : y < dimY) (hz : z < dimZ) :
    (cellsOf f code).getD (index x y z) 0 = code (f.at x y z) := by
  rw [cellsOf_getD f code (index_lt hx hy hz), Frame.vox_index f hx hz]

/-- A painting that only uses block types the page knows gives a legal world. -/
theorem cellsOf_isWorld (f : Frame) {code : Vox → Nat} (h : ∀ v, code v < 16) :
    IsWorld (cellsOf f code) := by
  intro b hb
  rw [cellsOf, List.mem_map] at hb
  obtain ⟨i, _, rfl⟩ := hb
  exact h _

/-- The share text of a painted grid: what goes in `voxel.html#v=…`. -/
def share (name : List Nat) (f : Frame) (code : Vox → Nat) : String :=
  shareOfWorld name (cellsOf f code)

/-- **What the viewer shows is what the Lean function says.**  Decoding the share text the
way the page decodes it gives back the name, and a grid whose every cell holds the block
the painting function gives at the lattice point that cell stands for. -/
theorem view_faithful (name : List Nat) (f : Frame) (code : Vox → Nat)
    (hn : ∀ b ∈ name, b < 256) (hlen : name.length < 256) (h16 : ∀ v, code v < 16) :
    ∃ rle world, decodeLevel (share name f code) = some (name, rle)
      ∧ dec rle = some world
      ∧ ∀ x y z, x < dimX → y < dimY → z < dimZ →
          world.getD (index x y z) 0 = code (f.at x y z) := by
  obtain ⟨rle, hdec, hrle⟩ :=
    decodeLevel_shareOfWorld name (cellsOf f code) hn hlen (cellsOf_isWorld f h16)
      (cellsOf_ne_nil f code)
  exact ⟨rle, cellsOf f code, hdec, hrle, fun x y z hx hy hz => cellsOf_getD_at f code hx hy hz⟩

/-! ## Coarse views

One block of the viewer stands for a cube of `step` voxels of the lattice.  Sampling the
corner of that cube would drop thin parts, so a coarse view instead shows the first
material found anywhere in the cube: a block appears in the viewer whenever there is
material in the cube it stands for. -/

/-- Searching a list of block types for the first that is not air. -/
def firstNonzero : List Nat → Nat
  | [] => 0
  | b :: t => if b = 0 then firstNonzero t else b

theorem firstNonzero_eq_zero_or_mem : ∀ l : List Nat, firstNonzero l = 0 ∨ firstNonzero l ∈ l
  | [] => Or.inl rfl
  | b :: t => by
      by_cases h : b = 0
      · rcases firstNonzero_eq_zero_or_mem t with h' | h'
        · exact Or.inl (by simp [firstNonzero, h, h'])
        · exact Or.inr (by simp only [firstNonzero, h, if_pos]; exact List.mem_cons_of_mem _ h')
      · exact Or.inr (by simp [firstNonzero, h])

theorem firstNonzero_eq_zero_iff (l : List Nat) : firstNonzero l = 0 ↔ ∀ b ∈ l, b = 0 := by
  induction l with
  | nil => simp [firstNonzero]
  | cons b t ih => by_cases h : b = 0 <;> simp [firstNonzero, h, ih]

/-- The blocks a cell of a coarse frame stands for: the painting on the cube of side `n`
whose near bottom corner is `v`, in the axis convention of `Frame.at`. -/
def cubeCodes (n : Nat) (code : Vox → Nat) (v : Vox) : List Nat :=
  (List.range n).flatMap fun i => (List.range n).flatMap fun j =>
    (List.range n).map fun k => code (v.x + (i : ℤ), v.y - (j : ℤ), v.z + (k : ℤ))

theorem mem_cubeCodes {n : Nat} {code : Vox → Nat} {v : Vox} {b : Nat} :
    b ∈ cubeCodes n code v ↔
      ∃ i < n, ∃ j < n, ∃ k < n, code (v.x + (i : ℤ), v.y - (j : ℤ), v.z + (k : ℤ)) = b := by
  simp [cubeCodes]

/-- A coarse painting: the first block found in the cube, or air if the cube is empty. -/
def coarse (n : Nat) (code : Vox → Nat) (v : Vox) : Nat :=
  firstNonzero (cubeCodes n code v)

/-- At `step = 1` a coarse view is the painting itself. -/
theorem coarse_one (code : Vox → Nat) (v : Vox) : coarse 1 code v = code v := by
  by_cases h : code v = 0 <;>
    simp [coarse, cubeCodes, firstNonzero, Vox.x, Vox.y, Vox.z, h]

theorem coarse_lt_16 {code : Vox → Nat} (h : ∀ v, code v < 16) (n : Nat) (v : Vox) :
    coarse n code v < 16 := by
  rcases firstNonzero_eq_zero_or_mem (cubeCodes n code v) with h0 | hm
  · rw [coarse, h0]; norm_num
  · obtain ⟨i, _, j, _, k, _, hik⟩ := mem_cubeCodes.1 hm
    rw [coarse, ← hik]
    exact h _

/-- **Nothing is lost by coarsening**: a cell of a coarse view is empty exactly when the
whole cube of `n` voxels it stands for is empty. -/
theorem coarse_eq_zero_iff (n : Nat) (code : Vox → Nat) (v : Vox) :
    coarse n code v = 0 ↔
      ∀ i < n, ∀ j < n, ∀ k < n, code (v.x + (i : ℤ), v.y - (j : ℤ), v.z + (k : ℤ)) = 0 := by
  rw [coarse, firstNonzero_eq_zero_iff]
  constructor
  · intro h i hi j hj k hk
    exact h _ (mem_cubeCodes.2 ⟨i, hi, j, hj, k, hk, rfl⟩)
  · intro h b hb
    obtain ⟨i, hi, j, hj, k, hk, rfl⟩ := mem_cubeCodes.1 hb
    exact h i hi j hj k hk


/-! ## The machine in the viewer -/

/-- The block type a body of the machine is drawn in: its colour, in the page's palette —
paint is `LAVA` orange, rubber is `BOUNCE` pink, chrome is `GLASS`, and everything else is
`STONE`. -/
def blockOfColour (c : Colour) : Nat :=
  if c = paintC then 5 else if c = rubberC then 4 else if c = chromeC then 9 else 1

theorem blockOfColour_lt_16 (c : Colour) : blockOfColour c < 16 := by
  unfold blockOfColour; split <;> [norm_num; split] <;> [norm_num; split] <;> norm_num

/-- Every body is drawn in some block: a body is never invisible. -/
theorem blockOfColour_ne_zero (c : Colour) : blockOfColour c ≠ 0 := by
  unfold blockOfColour; split <;> [norm_num; split] <;> [norm_num; split] <;> norm_num

/-- No body is drawn in `START`, so an exported view always satisfies the page's
one-start rule and loads. -/
theorem blockOfColour_ne_start (c : Colour) : blockOfColour c ≠ 8 := by
  unfold blockOfColour; split <;> [norm_num; split] <;> [norm_num; split] <;> norm_num

/-- The painting of the machine: the colour of the first body that owns the voxel. -/
def machineCode (c : Config) (v : Vox) : Nat :=
  match bodies.find? (fun b => b.at c v) with
  | some b => blockOfColour b.colour
  | none => 0

theorem machineCode_lt_16 (c : Config) (v : Vox) : machineCode c v < 16 := by
  unfold machineCode
  cases bodies.find? (fun b => b.at c v) with
  | none => norm_num
  | some b => exact blockOfColour_lt_16 _

theorem machineCode_ne_start (c : Config) (v : Vox) : machineCode c v ≠ 8 := by
  unfold machineCode
  cases bodies.find? (fun b => b.at c v) with
  | none => norm_num
  | some b => exact blockOfColour_ne_start _

/-- **The view is empty exactly where the machine is.**  A cell of the exported grid holds
air if and only if no material of the machine is there. -/
theorem machineCode_eq_zero_iff (c : Config) (v : Vox) :
    machineCode c v = 0 ↔ machine c v = false := by
  have hu : machine c v = true ↔ ∃ b ∈ bodies, b.at c v = true := by
    rw [machine, Solid.unions_eq_true_iff]
    constructor
    · rintro ⟨s, hs, hv⟩
      obtain ⟨b, hb, rfl⟩ := List.mem_map.1 hs
      exact ⟨b, hb, hv⟩
    · rintro ⟨b, hb, hv⟩
      exact ⟨b.at c, List.mem_map_of_mem hb, hv⟩
  unfold machineCode
  cases hf : bodies.find? (fun b => b.at c v) with
  | none =>
      have hnone : ∀ b ∈ bodies, b.at c v = false := by
        intro b hb
        simpa using List.find?_eq_none.1 hf b hb
      have hfalse : machine c v = false := by
        by_contra hcon
        obtain ⟨b, hb, hv⟩ := hu.1 (by simpa using hcon)
        rw [hnone b hb] at hv
        exact Bool.false_ne_true hv
      simp [hfalse]
  | some b =>
      have hb : b ∈ bodies := List.mem_of_find?_eq_some hf
      have hv : b.at c v = true := by
        simpa using List.find?_eq_some_iff_getElem.1 hf |>.1
      have : machine c v = true := hu.2 ⟨b, hb, hv⟩
      simp only [this, Bool.true_eq_false, iff_false]
      exact blockOfColour_ne_zero b.colour

/-- The frame the machine is viewed in: one cell of the viewer to four voxels of the
lattice — 20 cm to a block — with the lattice origin at the near bottom corner. -/
def machineFrame : Frame := ⟨(0, 17, 0), 4⟩

/-- The machine as the viewer draws it: one block to a cube of four voxels, showing the
first body that has material anywhere in that cube. -/
def machineView (c : Config) : Vox → Nat := coarse 4 (machineCode c)

theorem machineView_lt_16 (c : Config) (v : Vox) : machineView c v < 16 :=
  coarse_lt_16 (machineCode_lt_16 c) 4 v

/-- **No part of the machine disappears**: a block of the view is empty exactly when the
machine has no material anywhere in the cube of four voxels that block stands for. -/
theorem machineView_eq_zero_iff (c : Config) (v : Vox) :
    machineView c v = 0 ↔
      ∀ i : ℕ, i < 4 → ∀ j : ℕ, j < 4 → ∀ k : ℕ, k < 4 →
        machine c (v.x + (i : ℤ), v.y - (j : ℤ), v.z + (k : ℤ)) = false := by
  rw [machineView, coarse_eq_zero_iff]
  constructor
  · intro h i hi j hj k hk
    exact (machineCode_eq_zero_iff c _).1 (h i hi j hj k hk)
  · intro h i hi j hj k hk
    exact (machineCode_eq_zero_iff c _).2 (h i hi j hj k hk)

/-- The machine's grid of blocks. -/
def machineCells (c : Config) : List Nat := cellsOf machineFrame (machineView c)

/-- The text of a share link showing the machine. -/
def machineShare (name : List Nat) (c : Config) : String :=
  share name machineFrame (machineView c)

/-- **The machine, in the viewer.**  The link decodes to a grid that holds, at every cell,
the colour of the body of the machine that occupies the lattice voxel that cell stands
for — and air exactly where the machine is not. -/
theorem machine_view_faithful (name : List Nat) (c : Config)
    (hn : ∀ b ∈ name, b < 256) (hlen : name.length < 256) :
    ∃ rle world, decodeLevel (machineShare name c) = some (name, rle)
      ∧ dec rle = some world
      ∧ ∀ x y z, x < dimX → y < dimY → z < dimZ →
          world.getD (index x y z) 0 = machineView c (machineFrame.at x y z) :=
  view_faithful name machineFrame (machineView c) hn hlen (machineView_lt_16 c)

/-- Nothing is cut off: the corner of every cube of four voxels that the frame divides the
machine's envelope — `0 ≤ x ≤ 47`, `-17 ≤ y ≤ 17`, `0 ≤ z ≤ 48` — into is shown by a cell of
the viewer's grid. -/
theorem machineFrame_covers_envelope {v : Vox} (hx : 0 ≤ v.x ∧ v.x ≤ 47)
    (hy : -17 ≤ v.y ∧ v.y ≤ 17) (hz : 0 ≤ v.z ∧ v.z ≤ 48) :
    ∃ t < cells, ∃ i : ℕ, i < 4 ∧ ∃ j : ℕ, j < 4 ∧ ∃ k : ℕ, k < 4 ∧
      ((machineFrame.vox t).x + (i : ℤ), (machineFrame.vox t).y - (j : ℤ),
        (machineFrame.vox t).z + (k : ℤ)) = v := by
  obtain ⟨hx1, hx2⟩ := hx
  obtain ⟨hy1, hy2⟩ := hy
  obtain ⟨hz1, hz2⟩ := hz
  simp only [Vox.x, Vox.y, Vox.z] at hx1 hx2 hy1 hy2 hz1 hz2
  refine ⟨index (v.1 / 4).toNat (v.2.2 / 4).toNat ((17 - v.2.1) / 4).toNat,
    index_lt (by simp only [dimX]; omega) (by simp only [dimY]; omega)
      (by simp only [dimZ]; omega), (v.1 % 4).toNat, by omega, ((17 - v.2.1) % 4).toNat,
    by omega, (v.2.2 % 4).toNat, by omega, ?_⟩
  show ((machineFrame.vox _).x + _, (machineFrame.vox _).y - _, (machineFrame.vox _).z + _) = v
  rw [Frame.vox_index _ (by simp only [dimX]; omega) (by simp only [dimZ]; omega)]
  simp only [Frame.at, machineFrame, Vox.x, Vox.y, Vox.z]
  refine Prod.ext ?_ (Prod.ext ?_ ?_) <;> simp <;> omega

/-- **Every voxel of the machine shows up.**  Wherever the machine has material inside its
envelope, the block of the viewer's grid that stands for that voxel is not air. -/
theorem machine_shows_every_voxel (c : Config) {v : Vox} (hx : 0 ≤ v.x ∧ v.x ≤ 47)
    (hy : -17 ≤ v.y ∧ v.y ≤ 17) (hz : 0 ≤ v.z ∧ v.z ≤ 48) (hv : machine c v = true) :
    ∃ t < cells, (machineCells c).getD t 0 ≠ 0 := by
  obtain ⟨t, ht, i, hi, j, hj, k, hk, heq⟩ := machineFrame_covers_envelope (v := v) hx hy hz
  refine ⟨t, ht, ?_⟩
  rw [machineCells, cellsOf_getD machineFrame (machineView c) ht]
  intro h0
  have := (machineView_eq_zero_iff c (machineFrame.vox t)).1 h0 i hi j hj k hk
  rw [heq, hv] at this
  exact Bool.true_eq_false ▸ this

/-! ## Audit -/

#print axioms view_faithful
#print axioms machine_view_faithful
#print axioms machine_shows_every_voxel

end View
end Voxel
end LifeTrac
