import RequestProject.Gvcs.Net.Design
import RequestProject.Gvcs.Static.Beams

/-!
# Will the player's design hold?

`GAMEPLAN.md` §9 asks to connect a player's creative-mode design
(`RequestProject/Net/Design.lean`) to the beam theory the machine's own frame is
checked with (`RequestProject/Static/Beams.lean`), so that "will it hold?" is
decided by the same proofs, not by a second, looser rule invented for the game.
This file is that connection.

* `Catalogue` — what a brick's part id means physically: the square tube it is
  made of and the yield strength of its steel.
* `Brick.span` — a brick's free span in metres, its longest side at 5 cm to the
  voxel.
* `Brick.stress`, `Brick.capacity` — the bending stress a load puts in the
  brick and the greatest load it may carry, *defined* as the frame's
  `SquareTube.spanStress` and `SquareTube.spanCapacity`.
* `Brick.holds_iff` — the editor's verdict is exactly the machine's design
  check `SquareTube.spanStress_le_iff`.
* `Brick.capacity_eq_four_mul_tipLoad` — the same brick cantilevered holds a
  quarter as much, the same comparison the frame obeys.
* `Design.Holds`, `Edit.Sound`, `replay_holds` — **the check survives the
  network**: if every player's editor refuses to place a brick that would not
  hold, then whatever edits arrive from whatever peers in whatever order, the
  design a replica reconstructs from its log holds.
* `railBrick_capacity_bounds` — a worked number for a 15 cm × 3 mm mild-steel
  rail brick 2.4 m long.
-/

namespace LifeTrac
namespace Net

noncomputable section

/-- One voxel of the editor lattice in metres: 5 cm, the pitch the machine
itself is modelled on. -/
def voxelMetres : ℝ := 1 / 20

theorem voxelMetres_pos : 0 < voxelMetres := by norm_num [voxelMetres]

/-- What a part id means physically: the square tube the brick is made of and
the yield strength of its steel. -/
structure Catalogue where
  /-- The section of the member a brick of this part id is. -/
  tube : ℕ → SquareTube
  /-- The yield strength of its steel, in pascals. -/
  yieldStrength : ℕ → ℝ
  /-- Steel yields at a positive stress. -/
  yieldStrength_pos : ∀ p, 0 < yieldStrength p

namespace Brick

/-- The free span of a brick in voxels: its longest side. -/
def spanVox (b : Brick) : ℕ := max b.dx (max b.dy b.dz)

/-- The free span of a brick, in metres. -/
def span (b : Brick) : ℝ := voxelMetres * b.spanVox

theorem span_pos {b : Brick} (hb : b.Proper) : 0 < b.span := by
  have h : 0 < b.spanVox := lt_of_lt_of_le hb.1 (le_max_left _ _)
  have : (0 : ℝ) < (b.spanVox : ℝ) := by exact_mod_cast h
  exact mul_pos voxelMetres_pos this

variable (cat : Catalogue) (b : Brick)

/-- The bending stress a central load `F` puts in the brick, computed by the
frame's own formula. -/
def stress (F : ℝ) : ℝ := (cat.tube b.part).spanStress F b.span

/-- The greatest load the brick may carry between two supports, computed by the
frame's own formula. -/
def capacity : ℝ := (cat.tube b.part).spanCapacity (cat.yieldStrength b.part) b.span

/-- **The editor's verdict is the machine's design check.**  A brick stays
below yield under a load exactly when the load is within its capacity — this is
`SquareTube.spanStress_le_iff`, the same statement that decides the tractor's
own frame rails. -/
theorem holds_iff (hb : b.Proper) (F : ℝ) :
    b.stress cat F ≤ cat.yieldStrength b.part ↔ F ≤ b.capacity cat :=
  SquareTube.spanStress_le_iff _ (span_pos hb)

/-- **Cantilevering costs a factor of four.**  A brick that sticks out — a
bucket tooth, a hitch — carries a quarter of what the same brick supported at
both ends does. -/
theorem capacity_eq_four_mul_tipLoad :
    b.capacity cat =
      4 * (cat.tube b.part).maxTipLoad (cat.yieldStrength b.part) b.span :=
  SquareTube.spanCapacity_eq_four_mul_maxTipLoad _ _ _

theorem capacity_pos (hb : b.Proper) : 0 < b.capacity cat := by
  have hZ := (cat.tube b.part).sectionModulus_pos
  have hy := cat.yieldStrength_pos b.part
  have hL := span_pos hb
  unfold capacity SquareTube.spanCapacity
  positivity

/-- **A longer member holds less.**  Two bricks of the same part: the one with
the longer span has the smaller capacity. -/
theorem capacity_antitone {b c : Brick} (hpart : b.part = c.part) (hb : b.Proper)
    (h : b.span ≤ c.span) : c.capacity cat ≤ b.capacity cat := by
  have hZ := (cat.tube b.part).sectionModulus_pos
  have hy := cat.yieldStrength_pos b.part
  have hbpos := span_pos hb
  unfold capacity
  rw [← hpart]
  unfold SquareTube.spanCapacity
  apply div_le_div_of_nonneg_left (by positivity) hbpos h

end Brick

/-! ## The check over a whole design, and over the network -/

namespace Design

/-- A design *holds* under an assignment of loads when every brick in it is
within its capacity. -/
def Holds (cat : Catalogue) (load : Brick → ℝ) (d : Design) : Prop :=
  ∀ b ∈ d, load b ≤ b.capacity cat

theorem holds_empty (cat : Catalogue) (load : Brick → ℝ) : Holds cat load (∅ : Design) := by
  intro b hb
  exact absurd hb (Finset.notMem_empty b)

theorem Holds.subset {cat : Catalogue} {load : Brick → ℝ} {d e : Design}
    (h : Holds cat load d) (hs : e ⊆ d) : Holds cat load e :=
  fun b hb => h b (hs hb)

theorem Holds.erase {cat : Catalogue} {load : Brick → ℝ} {d : Design}
    (h : Holds cat load d) (b : Brick) : Holds cat load (d.erase b) :=
  h.subset (Finset.erase_subset _ _)

theorem Holds.insert {cat : Catalogue} {load : Brick → ℝ} {d : Design} {b : Brick}
    (h : Holds cat load d) (hb : load b ≤ b.capacity cat) :
    Holds cat load (insert b d) := by
  intro c hc
  rcases Finset.mem_insert.1 hc with rfl | hc
  · exact hb
  · exact h c hc

end Design

/-- An edit is *sound* when the editor was right to let it through: a placement
only of a brick that holds its load; a removal always. -/
def Edit.Sound (cat : Catalogue) (load : Brick → ℝ) : Edit → Prop
  | .place b => load b ≤ b.capacity cat
  | .remove _ => True

/-- A sound edit keeps a holding design holding. -/
theorem applyEdit_holds {cat : Catalogue} {load : Brick → ℝ} {d : Design}
    (h : Design.Holds cat load d) {e : Edit} (he : e.Sound cat load) :
    Design.Holds cat load (applyEdit d e) := by
  cases e with
  | place b =>
      by_cases hb : Design.Fits d b
      · rw [applyEdit, if_pos hb]; exact h.insert he
      · rw [applyEdit, if_neg hb]; exact h
  | remove b => exact h.erase b

theorem holds_foldl {cat : Catalogue} {load : Brick → ℝ} (l : List (Op Edit))
    (hl : ∀ o ∈ l, (Op.payload o).Sound cat load) {d : Design}
    (hd : Design.Holds cat load d) :
    Design.Holds cat load (l.foldl (fun s o => applyEdit s o.payload) d) := by
  induction l generalizing d with
  | nil => exact hd
  | cons o l ih =>
      exact ih (fun p hp => hl p (List.mem_cons_of_mem _ hp))
        (applyEdit_holds hd (hl o List.mem_cons_self))

/-- **The strength check survives the network.**  If every player's editor
refused to place a brick that would not carry its load, then whatever edits
arrive, from whatever peers, in whatever order, the design a replica
reconstructs from its log holds — and it holds by the machine's own beam
theory, not by a game rule. -/
theorem replay_holds {cat : Catalogue} {load : Brick → ℝ} (L : Log Edit)
    (hL : ∀ o ∈ L, (Op.payload o).Sound cat load) :
    Design.Holds cat load (replay applyEdit ∅ L) :=
  holds_foldl _ (fun o ho => hL o (mem_sortLog.1 ho)) (Design.holds_empty cat load)

/-- A design that holds and is legal is exactly what the editor promises: no
interpenetration (`replay_valid`) and no overloaded member. -/
theorem replay_valid_and_holds {cat : Catalogue} {load : Brick → ℝ} (L : Log Edit)
    (hL : ∀ o ∈ L, (Op.payload o).Sound cat load) :
    Design.Valid (replay applyEdit ∅ L) ∧ Design.Holds cat load (replay applyEdit ∅ L) :=
  ⟨replay_valid L, replay_holds L hL⟩

/-! ## A worked brick -/

/-- Mild steel at 250 MPa, every part a 15 cm square tube of 3 mm wall — the
section the machine's own main rails are drawn from. -/
def railCatalogue : Catalogue where
  tube := fun _ => { width := 0.15, wall := 0.003, wall_pos := by norm_num,
                     wall_lt_half_width := by norm_num }
  yieldStrength := fun _ => 250000000
  yieldStrength_pos := fun _ => by norm_num

/-- A rail brick: 48 voxels long, that is 2.4 m. -/
def railBrick : Brick :=
  { x := 0, y := 0, z := 0, dx := 48, dy := 3, dz := 3, part := 0 }

theorem railBrick_span : railBrick.span = 2.4 := by
  norm_num [Brick.span, Brick.spanVox, railBrick, voxelMetres]

/-- The rail brick holds a little over 35 kN at mid-span. -/
theorem railBrick_capacity_bounds :
    35000 < railBrick.capacity railCatalogue ∧ railBrick.capacity railCatalogue < 35600 := by
  constructor <;>
    · norm_num [Brick.capacity, SquareTube.spanCapacity, SquareTube.sectionModulus,
        SquareTube.inertia, SquareTube.innerWidth, railCatalogue, railBrick_span]

end

end Net
end LifeTrac
