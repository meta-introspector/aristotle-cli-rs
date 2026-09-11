import Mathlib
import RequestProject.Craft.ReplicatorRender

/-!
# The body of the machine, voxel by voxel, built out of its parts

`RequestProject/Parts.lean` says what a machine is made of — a bill of materials, a
list of boxes of parts.  `RequestProject/ReplicatorRender.lean` draws that bill as a
flat elevation of slots.  This file gives the machine an actual **body in space**:

* every `Part` is a small rigid cluster of unit cubes — its `voxels`;
* a machine's parts are laid out on a lattice of **slots**, four voxels apart, so a
  deck's bill of materials becomes a `Model`: a list of parts, each with a place;
* the model's `cells` are the occupied unit cubes of the finished body, and its
  `scene` is those cubes each carrying the part it belongs to and the slot it was
  fitted into;
* a scene is turned into a picture by an isometric projection: cubes are sorted
  back-to-front by depth and drawn as three visible faces each.

The point of the file is that the picture is *made of the parts*, provably:

* `bodyModel_parts` / `bodyModel_countPart` — the body contains exactly the parts of
  the deck's bill of materials, no more and no fewer;
* `bodyModel_cells_nodup` — no two parts occupy the same cube: the body does not
  self-intersect;
* `bodyModel_voxelCount` — the number of cubes in the body is the bill of materials
  weighted by the size of each part;
* `buildModel_cells_succ` — fitting one more part adds exactly that part's own cubes
  and touches nothing else, so the 3-D build matches the assembly film step for step
  (`buildModel_installed`, `scene_filter_slot`);
* `drawOrder_perm` / `drawOrder_sorted` — the drawing shows every cube exactly once,
  in back-to-front order, which is what makes the painter's algorithm right;
* `spin_four` — turning the view four quarter-turns brings it back to where it was.
-/

namespace Replicate

open SelfCopy

/-! ## §1  Voxels -/

/-- A unit cube of the build lattice, addressed by its lowest corner. -/
structure Vox where
  x : Nat
  y : Nat
  z : Nat
deriving DecidableEq, Repr, Inhabited

namespace Vox

/-- Translate a local offset by an origin. -/
def add (a b : Vox) : Vox := ⟨a.x + b.x, a.y + b.y, a.z + b.z⟩

@[simp] theorem add_x (a b : Vox) : (a.add b).x = a.x + b.x := rfl
@[simp] theorem add_y (a b : Vox) : (a.add b).y = a.y + b.y := rfl
@[simp] theorem add_z (a b : Vox) : (a.add b).z = a.z + b.z := rfl

theorem add_right_injective (o : Vox) : Function.Injective (fun v => o.add v) := by
  rintro ⟨a1, a2, a3⟩ ⟨b1, b2, b3⟩ h
  simp only [add, Vox.mk.injEq] at h
  simp_all

end Vox

/-! ## §2  Every part is a cluster of cubes -/

namespace Part

/-- **The shape of a part**: the unit cubes it occupies, as offsets from its own
corner.  Every part fits inside a 3×3×3 block (`voxels_bounded`), which is what lets
the parts be laid out four voxels apart without ever touching. -/
def voxels : Part → List Vox
  | clayBrick   => [⟨0,0,0⟩, ⟨1,0,0⟩]
  | firedPlate  => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩]
  | leverArm    => [⟨0,0,0⟩, ⟨0,1,0⟩, ⟨1,1,0⟩]
  | stoneWeight => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨0,1,0⟩, ⟨1,1,0⟩,
                    ⟨0,0,1⟩, ⟨1,0,1⟩, ⟨0,1,1⟩, ⟨1,1,1⟩]
  | matrixBed   => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨2,0,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩, ⟨2,0,1⟩]
  | reedPin     => [⟨0,0,0⟩, ⟨0,1,0⟩, ⟨0,2,0⟩]
  | pipeSegment => [⟨0,0,0⟩, ⟨0,0,1⟩, ⟨0,0,2⟩]
  | elbow       => [⟨0,0,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩]
  | valveBody   => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨0,1,0⟩, ⟨1,1,0⟩]
  | filterMesh  => [⟨0,0,0⟩, ⟨2,0,0⟩, ⟨1,0,1⟩, ⟨0,0,2⟩, ⟨2,0,2⟩]
  | pumpRotor   => [⟨1,0,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩, ⟨2,0,1⟩, ⟨1,0,2⟩]
  | flange      => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨2,0,0⟩, ⟨0,0,1⟩, ⟨2,0,1⟩,
                    ⟨0,0,2⟩, ⟨1,0,2⟩, ⟨2,0,2⟩]

/-- The fill colour of a part, as `0xRRGGBB`. -/
def color : Part → Nat
  | clayBrick   => 0xb5651d
  | firedPlate  => 0xcf8b4a
  | leverArm    => 0x8a6a3b
  | stoneWeight => 0x6f6a62
  | matrixBed   => 0xa03e2c
  | reedPin     => 0xc9b06a
  | pipeSegment => 0x3d6b8e
  | elbow       => 0x4f88ad
  | valveBody   => 0x2f5570
  | filterMesh  => 0x7fb3c9
  | pumpRotor   => 0x9ad1e0
  | flange      => 0x27455c

/-- Every part is made of at least one cube. -/
theorem voxels_ne_nil (p : Part) : p.voxels ≠ [] := by cases p <;> simp [voxels]

/-- A part never lists the same cube twice. -/
theorem voxels_nodup (p : Part) : p.voxels.Nodup := by cases p <;> decide

/-- **Every part fits in a 3×3×3 block.** -/
theorem voxels_bounded (p : Part) : ∀ v ∈ p.voxels, v.x < 3 ∧ v.y < 3 ∧ v.z < 3 := by
  cases p <;> decide

/-- How many cubes a part is made of. -/
def size (p : Part) : Nat := p.voxels.length

end Part

/-! ## §3  Slots: where the parts go -/

/-- **The slot lattice.**  Slot `i` sits at the lattice point four voxels apart in
each direction: four slots across, four high, and as many rows deep as needed.  The
pitch of 4 is one more than the 3-voxel reach of a part, so distinct slots can never
collide (`slot_cells_disjoint`). -/
def slotPos (i : Nat) : Vox := ⟨4 * (i % 4), 4 * ((i / 4) % 4), 4 * (i / 16)⟩

/-- Distinct slots are distinct places. -/
theorem slotPos_inj : Function.Injective slotPos := by
  intro i j h
  simp only [slotPos, Vox.mk.injEq] at h
  omega

/-! ## §4  A model: parts, each in its slot -/

/-- A part fitted into a slot of the body. -/
structure Placed where
  /-- Which part it is. -/
  part : Part
  /-- Which slot of the lattice it was fitted into. -/
  slot : Nat
deriving DecidableEq, Repr

namespace Placed

/-- The cubes a fitted part occupies. -/
def cells (q : Placed) : List Vox := q.part.voxels.map (fun v => (slotPos q.slot).add v)

theorem cells_nodup (q : Placed) : q.cells.Nodup :=
  (List.nodup_map_iff_inj_on (Part.voxels_nodup q.part)).2
    (fun _ _ _ _ h => Vox.add_right_injective (slotPos q.slot) h)

theorem cells_length (q : Placed) : q.cells.length = q.part.size := by
  simp [cells, Part.size]

theorem cells_ne_nil (q : Placed) : q.cells ≠ [] := by
  simpa [cells] using Part.voxels_ne_nil q.part

end Placed

/-- **Two parts in different slots never share a cube.** -/
theorem slot_cells_disjoint {i j : Nat} (hij : i ≠ j) (p q : Part) (v : Vox)
    (hp : v ∈ (Placed.mk p i).cells) (hq : v ∈ (Placed.mk q j).cells) : False := by
  simp only [Placed.cells, List.mem_map] at hp hq
  obtain ⟨a, ha, hav⟩ := hp
  obtain ⟨b, hb, hbv⟩ := hq
  obtain ⟨hax, hay, haz⟩ := Part.voxels_bounded p a ha
  obtain ⟨hbx, hby, hbz⟩ := Part.voxels_bounded q b hb
  have hx : 4 * (i % 4) + a.x = 4 * (j % 4) + b.x := by
    have := congrArg Vox.x (hav.trans hbv.symm); simpa [slotPos] using this
  have hy : 4 * ((i / 4) % 4) + a.y = 4 * ((j / 4) % 4) + b.y := by
    have := congrArg Vox.y (hav.trans hbv.symm); simpa [slotPos] using this
  have hz : 4 * (i / 16) + a.z = 4 * (j / 16) + b.z := by
    have := congrArg Vox.z (hav.trans hbv.symm); simpa [slotPos] using this
  omega

/-- A body: the parts fitted into it so far, in fitting order. -/
abbrev Model := List Placed

namespace Model

/-- Every cube the body occupies. -/
def cells (m : Model) : List Vox := m.flatMap Placed.cells

@[simp] theorem cells_nil : cells [] = [] := rfl

@[simp] theorem cells_cons (q : Placed) (m : Model) :
    cells (q :: m) = q.cells ++ cells m := rfl

theorem cells_append (m m' : Model) : cells (m ++ m') = cells m ++ cells m' := by
  simp [cells, List.flatMap_append]

/-- How many cubes the body is made of. -/
def voxelCount (m : Model) : Nat := (cells m).length

theorem voxelCount_eq_sum (m : Model) :
    voxelCount m = (m.map (fun q => q.part.size)).sum := by
  induction m with
  | nil => rfl
  | cons q m ih =>
      simp only [voxelCount, cells_cons, List.length_append, List.map_cons, List.sum_cons,
        Placed.cells_length] at *
      omega

end Model

/-! ## §5  Laying a bill of materials out into a body -/

/-- **Lay parts out into slots**, one part per slot, starting at slot `i`. -/
def layout (i : Nat) : List Part → Model
  | [] => []
  | p :: ps => ⟨p, i⟩ :: layout (i + 1) ps

@[simp] theorem layout_nil (i : Nat) : layout i [] = [] := rfl

@[simp] theorem layout_cons (i : Nat) (p : Part) (ps : List Part) :
    layout i (p :: ps) = ⟨p, i⟩ :: layout (i + 1) ps := rfl

theorem layout_length (l : List Part) (i : Nat) : (layout i l).length = l.length := by
  induction l generalizing i with
  | nil => rfl
  | cons p ps ih => simp [ih]

/-- The parts of a laid-out body are the parts it was given, in order. -/
theorem layout_map_part (l : List Part) (i : Nat) : (layout i l).map Placed.part = l := by
  induction l generalizing i with
  | nil => rfl
  | cons p ps ih => simp [ih]

theorem layout_append (l l' : List Part) (i : Nat) :
    layout i (l ++ l') = layout i l ++ layout (i + l.length) l' := by
  induction l generalizing i with
  | nil => simp
  | cons p ps ih =>
      rw [List.cons_append, layout_cons, layout_cons, ih (i + 1), List.cons_append,
        List.length_cons, show i + 1 + ps.length = i + (ps.length + 1) by omega]

/-- Every slot used by `layout i l` is at least `i`. -/
theorem layout_slot_ge (l : List Part) (i : Nat) : ∀ q ∈ layout i l, i ≤ q.slot := by
  induction l generalizing i with
  | nil => simp
  | cons p ps ih =>
      intro q hq
      rcases List.mem_cons.mp hq with rfl | hq
      · exact Nat.le_refl _
      · exact Nat.le_of_succ_le (ih (i + 1) q hq)

/-- Every slot used by `layout i l` is less than `i + l.length`. -/
theorem layout_slot_lt (l : List Part) (i : Nat) : ∀ q ∈ layout i l, q.slot < i + l.length := by
  induction l generalizing i with
  | nil => simp
  | cons p ps ih =>
      intro q hq
      rcases List.mem_cons.mp hq with rfl | hq
      · simp
      · have := ih (i + 1) q hq
        simp only [List.length_cons]
        omega

theorem mem_cells_layout {l : List Part} {i : Nat} {v : Vox} (h : v ∈ Model.cells (layout i l)) :
    ∃ q ∈ layout i l, v ∈ q.cells := by
  simpa [Model.cells, List.mem_flatMap] using h

/-- **A laid-out body does not self-intersect**: no cube is used twice. -/
theorem layout_cells_nodup (l : List Part) (i : Nat) : (Model.cells (layout i l)).Nodup := by
  induction l generalizing i with
  | nil => simp
  | cons p ps ih =>
      rw [layout_cons, Model.cells_cons, List.nodup_append]
      refine ⟨Placed.cells_nodup _, ih (i + 1), ?_⟩
      intro a ha b hb
      rintro rfl
      obtain ⟨q, hq, hqa⟩ := mem_cells_layout hb
      have hge : i + 1 ≤ q.slot := layout_slot_ge ps (i + 1) q hq
      have hne : i ≠ q.slot := by omega
      exact slot_cells_disjoint hne p q.part a ha (by simpa using hqa)

/-! ## §6  The body of a deck -/

/-- **The body of a deck**: its whole bill of materials, part by part, laid out on
the slot lattice in fabrication order. -/
def bodyModel (cs : CardSet) : Model := layout 0 (order cs)

/-- **The body after `j` parts have been fitted.** -/
def buildModel (cs : CardSet) (j : Nat) : Model := layout 0 ((order cs).take j)

/-- The finished body is the body at the end of the assembly phase. -/
theorem buildModel_full (cs : CardSet) : buildModel cs (order cs).length = bodyModel cs := by
  simp [buildModel, bodyModel]

/-- **The body is made of exactly the parts of the deck.** -/
theorem bodyModel_parts (cs : CardSet) : (bodyModel cs).map Placed.part = order cs :=
  layout_map_part _ _

/-- **The body contains exactly the deck's bill of materials**: for every kind of
part, the body holds as many of them as the bill calls for. -/
theorem bodyModel_countPart (cs : CardSet) (p : Part) :
    countPart ((bodyModel cs).map Placed.part) p = deckBOM cs p := by
  rw [bodyModel_parts]
  exact countPart_deckPartSeq cs p

/-- The body has one fitted part per fabrication cycle. -/
theorem bodyModel_length (cs : CardSet) : (bodyModel cs).length = (order cs).length :=
  layout_length _ _

/-- **The body does not self-intersect.** -/
theorem bodyModel_cells_nodup (cs : CardSet) : (Model.cells (bodyModel cs)).Nodup :=
  layout_cells_nodup _ _

theorem buildModel_cells_nodup (cs : CardSet) (j : Nat) :
    (Model.cells (buildModel cs j)).Nodup := layout_cells_nodup _ _

/-- The parts fitted after `j` steps are exactly the parts the assembly film says are
installed at frame `j`. -/
theorem buildModel_installed (cs : CardSet) (j : Nat) (p : Part) :
    countPart ((buildModel cs j).map Placed.part) p = (asmFrame cs j).installed p := by
  rw [buildModel, layout_map_part]
  rfl

/-- **One part, one step.**  Fitting the `j`-th part extends the body by exactly that
part's own cubes and changes nothing already built. -/
theorem buildModel_cells_succ (cs : CardSet) (j : Nat) (p : Part) (h : (order cs)[j]? = some p) :
    Model.cells (buildModel cs (j + 1)) =
      Model.cells (buildModel cs j) ++ (Placed.mk p j).cells := by
  have hlen : j < (order cs).length := by
    have := List.getElem?_eq_some_iff.mp h
    exact this.1
  have htake : (order cs).take (j + 1) = (order cs).take j ++ [p] := by
    rw [List.take_add_one, h]
    rfl
  rw [buildModel, buildModel, htake, layout_append, Model.cells_append]
  congr 1
  simp [List.length_take, Nat.min_eq_left (Nat.le_of_lt hlen), Model.cells]

/-- The number of cubes in the body after `j` parts is the total size of those parts. -/
theorem buildModel_voxelCount (cs : CardSet) (j : Nat) :
    Model.voxelCount (buildModel cs j) = (((order cs).take j).map Part.size).sum := by
  rw [Model.voxelCount_eq_sum, buildModel]
  rw [show (fun q : Placed => q.part.size) = Part.size ∘ Placed.part from rfl,
    ← List.map_map, layout_map_part]

/-! ### The body's cube count, read off the bill of materials -/

private theorem sum_ite_all (f : Part → Nat) (q : Part) :
    (Part.all.map (fun p => if q = p then f p else 0)).sum = f q := by
  cases q <;> simp [Part.all]

private theorem sum_map_add' (L : List Part) (g h : Part → Nat) :
    (L.map (fun p => g p + h p)).sum = (L.map g).sum + (L.map h).sum := by
  induction L with
  | nil => simp
  | cons a L ih => simp only [List.map_cons, List.sum_cons, ih]; omega

private theorem sum_map_eq_sum_count (l : List Part) (f : Part → Nat) :
    (l.map f).sum = (Part.all.map (fun p => countPart l p * f p)).sum := by
  induction l with
  | nil => simp [countPart]
  | cons q l ih =>
      have hcount : ∀ p : Part, countPart (q :: l) p = (if q = p then 1 else 0) + countPart l p := by
        intro p
        by_cases h : q = p <;> simp [countPart, h]
        omega
      have : (Part.all.map (fun p => countPart (q :: l) p * f p)).sum =
          (Part.all.map (fun p => (if q = p then f p else 0))).sum +
          (Part.all.map (fun p => countPart l p * f p)).sum := by
        rw [← sum_map_add']
        refine congrArg List.sum (List.map_congr_left ?_)
        intro p _
        rw [hcount p]
        by_cases h : q = p <;> simp [h, Nat.add_mul]
      rw [List.map_cons, List.sum_cons, ih, this, sum_ite_all]

/-- **The size of the body, from the bill of materials.**  The finished body has one
cube for each cube of each part the deck calls for. -/
theorem bodyModel_voxelCount (cs : CardSet) :
    Model.voxelCount (bodyModel cs) =
      (Part.all.map (fun p => deckBOM cs p * p.size)).sum := by
  rw [Model.voxelCount_eq_sum,
    show (fun q : Placed => q.part.size) = Part.size ∘ Placed.part from rfl,
    ← List.map_map, bodyModel_parts, sum_map_eq_sum_count (order cs) Part.size]
  refine congrArg List.sum (List.map_congr_left ?_)
  intro p _
  rw [show order cs = deckPartSeq cs from rfl, countPart_deckPartSeq]

/-- **Every copy has the same body.**  Generation `n` of a productive deck is laid
out exactly like the original. -/
theorem bodyModel_generation (cs : CardSet) (hp : Productive cs) (n : Nat) :
    bodyModel (generation cs n) = bodyModel cs := by
  rw [generation_eq cs hp n]

/-! ## §7  Scenes: cubes that know what they are -/

/-- One drawn cube: where it is, which part it belongs to, and which slot that part
was fitted into. -/
structure Cell where
  /-- The cube's position on the lattice. -/
  pos : Vox
  /-- The part this cube belongs to. -/
  part : Part
  /-- The slot that part was fitted into — the step of the build that added it. -/
  slot : Nat
deriving DecidableEq, Repr

/-- **The scene of a body**: every cube of every fitted part, tagged with its part. -/
def sceneOf (m : Model) : List Cell :=
  m.flatMap (fun q => q.cells.map (fun v => ⟨v, q.part, q.slot⟩))

@[simp] theorem sceneOf_nil : sceneOf [] = [] := rfl

@[simp] theorem sceneOf_cons (q : Placed) (m : Model) :
    sceneOf (q :: m) = q.cells.map (fun v => ⟨v, q.part, q.slot⟩) ++ sceneOf m := rfl

theorem sceneOf_append (m m' : Model) : sceneOf (m ++ m') = sceneOf m ++ sceneOf m' := by
  simp [sceneOf, List.flatMap_append]

/-- The scene's cubes are exactly the body's cubes. -/
theorem sceneOf_pos (m : Model) : (sceneOf m).map Cell.pos = Model.cells m := by
  induction m with
  | nil => rfl
  | cons q m ih =>
      simp [sceneOf_cons, Model.cells_cons, List.map_map, Function.comp_def, ih]

/-- **No two cubes of a scene sit in the same place.** -/
theorem sceneOf_nodup {m : Model} (h : (Model.cells m).Nodup) : (sceneOf m).Nodup := by
  have : ((sceneOf m).map Cell.pos).Nodup := by rw [sceneOf_pos]; exact h
  exact List.Nodup.of_map Cell.pos this

/-- Every cube of a laid-out body carries the slot of the part it belongs to. -/
theorem sceneOf_slot_lt (l : List Part) (i : Nat) :
    ∀ c ∈ sceneOf (layout i l), c.slot < i + l.length := by
  intro c hc
  simp only [sceneOf, List.mem_flatMap, List.mem_map] at hc
  obtain ⟨q, hq, v, _, rfl⟩ := hc
  exact layout_slot_lt l i q hq

theorem sceneOf_slot_ge (l : List Part) (i : Nat) : ∀ c ∈ sceneOf (layout i l), i ≤ c.slot := by
  intro c hc
  simp only [sceneOf, List.mem_flatMap, List.mem_map] at hc
  obtain ⟨q, hq, v, _, rfl⟩ := hc
  exact layout_slot_ge l i q hq

/-- **The build is a filter of the finished body.**  The cubes of the finished body
whose part was fitted in one of the first `j` steps are exactly the cubes of the body
after `j` steps — which is what lets the 3-D view play the assembly back by hiding
cubes rather than by drawing a different picture. -/
theorem scene_filter_slot (cs : CardSet) (j : Nat) :
    (sceneOf (bodyModel cs)).filter (fun c => decide (c.slot < j)) =
      sceneOf (buildModel cs j) := by
  by_cases hj : j ≤ (order cs).length
  · have hsplit : order cs = (order cs).take j ++ (order cs).drop j :=
      (List.take_append_drop j (order cs)).symm
    have hlen : ((order cs).take j).length = j := by
      simp [List.length_take, Nat.min_eq_left hj]
    rw [bodyModel]
    conv_lhs => rw [hsplit]
    rw [layout_append, sceneOf_append, List.filter_append, hlen, Nat.zero_add]
    have h1 : (sceneOf (layout 0 ((order cs).take j))).filter (fun c => decide (c.slot < j)) =
        sceneOf (layout 0 ((order cs).take j)) := by
      refine List.filter_eq_self.mpr ?_
      intro c hc
      have := sceneOf_slot_lt ((order cs).take j) 0 c hc
      simp only [decide_eq_true_eq]
      omega
    have h2 : (sceneOf (layout j ((order cs).drop j))).filter (fun c => decide (c.slot < j)) = [] := by
      refine List.filter_eq_nil_iff.mpr ?_
      intro c hc
      have := sceneOf_slot_ge ((order cs).drop j) j c hc
      simp only [decide_eq_true_eq, not_lt]
      omega
    rw [h1, h2, List.append_nil, buildModel]
  · have hj' : (order cs).length ≤ j := by omega
    have : (order cs).take j = order cs := List.take_of_length_le hj'
    rw [buildModel, this, bodyModel]
    refine List.filter_eq_self.mpr ?_
    intro c hc
    have := sceneOf_slot_lt (order cs) 0 c hc
    simp only [decide_eq_true_eq]
    omega

/-- The scene of a deck's finished body. -/
def bodyScene (cs : CardSet) : List Cell := sceneOf (bodyModel cs)

theorem bodyScene_nodup (cs : CardSet) : (bodyScene cs).Nodup :=
  sceneOf_nodup (bodyModel_cells_nodup cs)

theorem bodyScene_length (cs : CardSet) : (bodyScene cs).length = Model.voxelCount (bodyModel cs) := by
  have := congrArg List.length (sceneOf_pos (bodyModel cs))
  simpa [bodyScene, Model.voxelCount] using this

/-! ## §8  Turning the view

A quarter-turn about the vertical axis, inside a box of side `n`.  Four of them are
the identity (`spin_four`), so the four orientations really are a spin. -/

/-- The cubes of a scene stay inside a box of side `n`. -/
def Bounded (n : Nat) (s : List Cell) : Prop := ∀ c ∈ s, c.pos.x ≤ n ∧ c.pos.z ≤ n

/-- A quarter-turn of one cube about the vertical axis of the box of side `n`. -/
def yaw (n : Nat) (c : Cell) : Cell := ⟨⟨c.pos.z, c.pos.y, n - c.pos.x⟩, c.part, c.slot⟩

/-- A quarter-turn of a whole scene. -/
def yawScene (n : Nat) (s : List Cell) : List Cell := s.map (yaw n)

/-- `k` quarter-turns. -/
def spin (n : Nat) : List Cell → Nat → List Cell
  | s, 0 => s
  | s, k + 1 => yawScene n (spin n s k)

theorem yaw_bounded {n : Nat} {s : List Cell} (h : Bounded n s) : Bounded n (yawScene n s) := by
  intro c hc
  simp only [yawScene, List.mem_map] at hc
  obtain ⟨d, hd, rfl⟩ := hc
  exact ⟨(h d hd).2, Nat.sub_le _ _⟩

theorem spin_bounded {n : Nat} {s : List Cell} (h : Bounded n s) (k : Nat) :
    Bounded n (spin n s k) := by
  induction k with
  | zero => exact h
  | succ k ih => exact yaw_bounded ih

/-- A quarter-turn is injective on a scene that fits in the box. -/
theorem yaw_inj_on {n : Nat} {c d : Cell} (hc : c.pos.x ≤ n) (hd : d.pos.x ≤ n)
    (h : yaw n c = yaw n d) : c = d := by
  obtain ⟨⟨cx, cy, cz⟩, cp, cs⟩ := c
  obtain ⟨⟨dx, dy, dz⟩, dp, ds⟩ := d
  simp only [yaw, Cell.mk.injEq, Vox.mk.injEq] at h ⊢
  obtain ⟨⟨h1, h2, h3⟩, h4, h5⟩ := h
  simp at hc hd
  exact ⟨⟨by omega, h2, h1⟩, h4, h5⟩

/-- Turning keeps the cubes distinct. -/
theorem yaw_nodup {n : Nat} {s : List Cell} (hb : Bounded n s) (h : s.Nodup) :
    (yawScene n s).Nodup := by
  refine List.Nodup.map_on ?_ h
  intro c hc d hd hcd
  exact yaw_inj_on (hb c hc).1 (hb d hd).1 hcd

theorem spin_nodup {n : Nat} {s : List Cell} (hb : Bounded n s) (h : s.Nodup) (k : Nat) :
    (spin n s k).Nodup := by
  induction k with
  | zero => exact h
  | succ k ih => exact yaw_nodup (spin_bounded hb k) ih

/-- **Four quarter-turns bring the view back.** -/
theorem spin_four {n : Nat} {s : List Cell} (hb : Bounded n s) : spin n s 4 = s := by
  have key : ∀ c ∈ s, (fun c => yaw n (yaw n (yaw n (yaw n c)))) c = id c := by
    intro c hc
    obtain ⟨hx, hz⟩ := hb c hc
    obtain ⟨⟨cx, cy, cz⟩, cp, cs⟩ := c
    simp only at hx hz
    simp only [yaw, id_eq, Cell.mk.injEq, Vox.mk.injEq]
    and_intros <;> first | trivial | omega
  show yawScene n (yawScene n (yawScene n (yawScene n s))) = s
  simp only [yawScene, List.map_map]
  rw [show (yaw n ∘ yaw n ∘ yaw n ∘ yaw n) = fun c => yaw n (yaw n (yaw n (yaw n c))) from rfl,
    List.map_congr_left (g := id) key, List.map_id]

/-- The side of the smallest box, centred on the origin corner, that a scene fits in. -/
def extent (s : List Cell) : Nat := (s.map (fun c => max c.pos.x c.pos.z)).foldr max 0

theorem extent_bounded (s : List Cell) : Bounded (extent s) s := by
  intro c hc
  induction s with
  | nil => simp at hc
  | cons d s ih =>
      rcases List.mem_cons.mp hc with rfl | hc'
      · constructor <;> simp [extent]
      · have := ih hc'
        simp only [extent, List.map_cons, List.foldr_cons] at this ⊢
        omega

/-! ## §9  Drawing: the painter's algorithm -/

/-- How far a cube is from the eye: the eye looks down the `(1,1,1)` diagonal, so the
larger `x + y + z`, the nearer the cube. -/
def depth (c : Cell) : Nat := c.pos.x + c.pos.y + c.pos.z

/-- **The order to draw a scene in**: farthest cube first. -/
def drawOrder (s : List Cell) : List Cell := s.mergeSort (fun a b => decide (depth a ≤ depth b))

/-- **Nothing is dropped and nothing is drawn twice**: the drawing is a rearrangement
of the scene. -/
theorem drawOrder_perm (s : List Cell) : (drawOrder s).Perm s :=
  List.mergeSort_perm s _

theorem drawOrder_length (s : List Cell) : (drawOrder s).length = s.length :=
  (drawOrder_perm s).length_eq

/-- **Back to front.**  Each cube is drawn no nearer than the one before it, so a
nearer cube always paints over a farther one — which is exactly what makes the flat
picture read as a solid. -/
theorem drawOrder_sorted (s : List Cell) :
    (drawOrder s).Pairwise (fun a b => depth a ≤ depth b) := by
  have h := List.pairwise_mergeSort
    (le := fun a b => decide (depth a ≤ depth b))
    (by intro a b c hab hbc; simp only [decide_eq_true_eq] at *; omega)
    (by intro a b; simp only [Bool.or_eq_true, decide_eq_true_eq]; omega) s
  exact h.imp (by simp only [decide_eq_true_eq]; exact id)

/-- Every cube of the scene is still in the drawing. -/
theorem mem_drawOrder {s : List Cell} {c : Cell} : c ∈ drawOrder s ↔ c ∈ s :=
  (drawOrder_perm s).mem_iff

end Replicate
