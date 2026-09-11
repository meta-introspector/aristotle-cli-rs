import RequestProject.Gvcs.Net.Gossip
import RequestProject.Gvcs.Voxel.Core

/-!
# Creative mode: designing parts out of bricks

The creative mode of the game is deliberately *not* a CAD package.  A design is
a set of axis-aligned bricks on the same 5 cm voxel lattice the machine itself
is modelled on (`RequestProject/Voxel/Core.lean`), snapped to the grid, stacked
like plastic bricks.  That is enough to draw a new bucket tooth, a hitch or a
whole implement, and it is little enough to be edited on a phone and shipped to
Roblox as parts.

* `Brick` — a position, an integer size in voxels and a catalogue part id;
  `Brick.solid` is the region of the lattice it fills.
* `Brick.overlaps` — a *decidable* clash test, proved (`overlaps_iff`) to be
  exactly the negation of `Voxel.Solid.Apart`.  This is the editor's collision
  check, and it is the same predicate the proofs about the machine use.
* `Design = Finset Brick`, `Design.Valid` — no two bricks interpenetrate;
  `Design.solid` — the model the renderer draws.
* `Edit`, `applyEdit` — the two operations of the editor, place and remove.
  `applyEdit_valid` — an edit can never break a design; hence `replay_valid`:
  *whatever* edits arrive from *whatever* peers in *whatever* order, the design
  a replica reconstructs from its log is always a legal, non-interpenetrating
  design.  Nothing has to be validated server side.
* `applyEdit_comm` — edits about bricks that do not clash commute, so they can
  be applied the moment they arrive; only edits about clashing bricks need the
  canonical order, which is what `Net.Log` gives them.
* `Grounded` — the plastic-brick rule: every brick sits on the baseplate or on
  another brick, preserved by stacking (`grounded_insert`).
-/

namespace LifeTrac
namespace Net

open Voxel
open Voxel.Solid

/-! ## Bricks -/

/-- A brick of a design: the low corner, the size in voxels along each axis,
and which catalogue part it is (steel plate, tube, tooth, …). -/
structure Brick where
  /-- Low corner, `x`. -/
  x : ℤ
  /-- Low corner, `y`. -/
  y : ℤ
  /-- Low corner, `z`. -/
  z : ℤ
  /-- Size along `x`, in voxels. -/
  dx : ℕ
  /-- Size along `y`, in voxels. -/
  dy : ℕ
  /-- Size along `z`, in voxels. -/
  dz : ℕ
  /-- Which catalogue part the brick is made of. -/
  part : ℕ
deriving DecidableEq, Repr

namespace Brick

/-- The low corner of a brick. -/
def lo (b : Brick) : Vox := (b.x, b.y, b.z)

/-- The high corner of a brick, inclusive. -/
def hi (b : Brick) : Vox := (b.x + b.dx - 1, b.y + b.dy - 1, b.z + b.dz - 1)

/-- The region of the lattice a brick fills. -/
def solid (b : Brick) : Solid := box b.lo b.hi

/-- A brick with a positive size along every axis. -/
def Proper (b : Brick) : Prop := 0 < b.dx ∧ 0 < b.dy ∧ 0 < b.dz

theorem mem_solid (b : Brick) (v : Vox) :
    b.solid v = true ↔
      (b.x ≤ v.x ∧ v.x ≤ b.x + b.dx - 1 ∧ b.y ≤ v.y ∧ v.y ≤ b.y + b.dy - 1 ∧
        b.z ≤ v.z ∧ v.z ≤ b.z + b.dz - 1) := by
  simp [solid, lo, hi]

/-- The editor's clash test: the two bricks meet in every axis.  Decidable, so
the phone and the browser can both run it. -/
def overlaps (b c : Brick) : Bool :=
  decide (max b.x c.x ≤ min (b.x + b.dx - 1) (c.x + c.dx - 1)) &&
  decide (max b.y c.y ≤ min (b.y + b.dy - 1) (c.y + c.dy - 1)) &&
  decide (max b.z c.z ≤ min (b.z + b.dz - 1) (c.z + c.dz - 1))

/-- The clash test is exactly interpenetration: it is sound (no false clear)
and complete (no false clash). -/
theorem overlaps_iff (b c : Brick) : b.overlaps c = true ↔ ¬ Apart b.solid c.solid := by
  constructor
  · intro h
    simp only [overlaps, Bool.and_eq_true, decide_eq_true_eq, max_le_iff, le_min_iff] at h
    intro hap
    rcases hap (max b.x c.x, max b.y c.y, max b.z c.z) with h' | h'
    · rw [← Bool.not_eq_true] at h'
      exact h' ((mem_solid b _).2 (by simp only [Vox.x_mk, Vox.y_mk, Vox.z_mk]; omega))
    · rw [← Bool.not_eq_true] at h'
      exact h' ((mem_solid c _).2 (by simp only [Vox.x_mk, Vox.y_mk, Vox.z_mk]; omega))
  · intro h
    by_contra hov
    apply h
    intro v
    by_cases hb : b.solid v = true
    · right
      by_contra hc
      rw [Bool.not_eq_false] at hc
      rw [mem_solid b v] at hb
      rw [mem_solid c v] at hc
      simp only [Bool.not_eq_true, overlaps, Bool.and_eq_false_iff, decide_eq_false_iff_not,
        not_le] at hov
      rcases hov with (h' | h') | h' <;> omega
    · left; exact Bool.not_eq_true _ ▸ hb

theorem apart_of_not_overlaps {b c : Brick} (h : b.overlaps c = false) :
    Apart b.solid c.solid := by
  by_contra hc
  rw [← overlaps_iff] at hc
  rw [h] at hc
  exact Bool.noConfusion hc

theorem overlaps_self (b : Brick) (hb : b.Proper) : b.overlaps b = true := by
  obtain ⟨hx, hy, hz⟩ := hb
  have hx' : (1 : ℤ) ≤ (b.dx : ℤ) := by exact_mod_cast hx
  have hy' : (1 : ℤ) ≤ (b.dy : ℤ) := by exact_mod_cast hy
  have hz' : (1 : ℤ) ≤ (b.dz : ℤ) := by exact_mod_cast hz
  simp only [overlaps, Bool.and_eq_true, decide_eq_true_eq, max_self, min_self]
  refine ⟨⟨?_, ?_⟩, ?_⟩ <;> omega

theorem overlaps_comm (b c : Brick) : b.overlaps c = c.overlaps b := by
  simp only [overlaps, max_comm, min_comm]

/-- Brick `b` rests directly on brick `c`: its underside is `c`'s top face and
their footprints meet.  This is the stud rule of the editor. -/
def restsOn (b c : Brick) : Prop :=
  b.z = c.z + c.dz ∧
  max b.x c.x ≤ min (b.x + b.dx - 1) (c.x + c.dx - 1) ∧
  max b.y c.y ≤ min (b.y + b.dy - 1) (c.y + c.dy - 1)

instance (b c : Brick) : Decidable (restsOn b c) := by unfold restsOn; infer_instance

end Brick

/-! ## Designs -/

/-- A design: a finite set of bricks. -/
abbrev Design := Finset Brick

namespace Design

/-- The region of the lattice a design fills. -/
def solid (d : Design) : Solid := fun v => decide (∃ b ∈ d, b.solid v = true)

theorem mem_solid {d : Design} {v : Vox} :
    solid d v = true ↔ ∃ b ∈ d, b.solid v = true := by
  simp [solid]

@[simp] theorem solid_empty : solid (∅ : Design) = Solid.empty := by
  funext v; simp [solid, Solid.empty]

theorem solid_insert (b : Brick) (d : Design) :
    solid (insert b d) = cup b.solid (solid d) := by
  funext v
  by_cases hb : b.solid v = true
  · simp [solid, hb]
  · simp only [Bool.not_eq_true] at hb
    simp [solid, hb, Solid.cup]

/-- A design is legal when no two of its bricks interpenetrate. -/
def Valid (d : Design) : Prop := ∀ b ∈ d, ∀ c ∈ d, b ≠ c → Apart b.solid c.solid

theorem valid_empty : Valid (∅ : Design) := by intro b hb; simp at hb

theorem Valid.subset {d e : Design} (h : Valid d) (hs : e ⊆ d) : Valid e :=
  fun b hb c hc hbc => h b (hs hb) c (hs hc) hbc

theorem Valid.erase {d : Design} (h : Valid d) (b : Brick) : Valid (d.erase b) :=
  h.subset (Finset.erase_subset _ _)

/-- The editor's test for whether a brick may be dropped where the player is
holding it. -/
def Fits (d : Design) (b : Brick) : Prop := ∀ c ∈ d, b.overlaps c = false

instance (d : Design) (b : Brick) : Decidable (Fits d b) := by unfold Fits; infer_instance

theorem valid_insert {d : Design} (h : Valid d) {b : Brick} (hb : Fits d b) :
    Valid (insert b d) := by
  intro p hp q hq hpq
  rcases Finset.mem_insert.1 hp with rfl | hp'
  · rcases Finset.mem_insert.1 hq with rfl | hq'
    · exact absurd rfl hpq
    · exact Brick.apart_of_not_overlaps (hb q hq')
  · rcases Finset.mem_insert.1 hq with rfl | hq'
    · exact (Brick.apart_of_not_overlaps (hb p hp')).symm
    · exact h p hp' q hq' hpq

/-! ## The plastic-brick rule -/

/-- Every brick of the design is on the baseplate `z = 0` or rests on another
brick of the design. -/
def Grounded (d : Design) : Prop :=
  ∀ b ∈ d, b.z = 0 ∨ ∃ c ∈ d, b.restsOn c

theorem grounded_empty : Grounded (∅ : Design) := by intro b hb; simp at hb

/-- Stacking keeps a design grounded. -/
theorem grounded_insert {d : Design} (h : Grounded d) {b : Brick}
    (hb : b.z = 0 ∨ ∃ c ∈ d, b.restsOn c) : Grounded (insert b d) := by
  intro p hp
  rcases Finset.mem_insert.1 hp with rfl | hp
  · rcases hb with hb | ⟨c, hc, hbc⟩
    · exact Or.inl hb
    · exact Or.inr ⟨c, Finset.mem_insert_of_mem hc, hbc⟩
  · rcases h p hp with h' | ⟨c, hc, hpc⟩
    · exact Or.inl h'
    · exact Or.inr ⟨c, Finset.mem_insert_of_mem hc, hpc⟩

end Design

/-! ## Edits as replicated operations -/

/-- The two operations of the creative-mode editor. -/
inductive Edit
  | /-- Put this brick into the design (ignored if it would clash). -/
    place (b : Brick)
  | /-- Take this brick out of the design. -/
    remove (b : Brick)
deriving DecidableEq, Repr

namespace Edit

/-- The brick an edit is about. -/
def brick : Edit → Brick
  | place b => b
  | remove b => b

end Edit

/-- Applying an edit.  A placement that would clash with what is already there
is a no-op — that is how two players who place overlapping bricks while
disconnected are reconciled: the one that sorts first in the canonical log
order wins, and both replicas agree on which that is. -/
def applyEdit (d : Design) : Edit → Design
  | .place b => if Design.Fits d b then insert b d else d
  | .remove b => d.erase b

/-- **An edit can never corrupt a design.** -/
theorem applyEdit_valid {d : Design} (h : Design.Valid d) (e : Edit) :
    Design.Valid (applyEdit d e) := by
  cases e with
  | place b =>
      by_cases hb : Design.Fits d b
      · rw [applyEdit, if_pos hb]; exact Design.valid_insert h hb
      · rw [applyEdit, if_neg hb]; exact h
  | remove b => exact h.erase b

theorem valid_foldl (l : List (Op Edit)) {d : Design} (hd : Design.Valid d) :
    Design.Valid (l.foldl (fun s o => applyEdit s o.payload) d) := by
  induction l generalizing d with
  | nil => exact hd
  | cons o l ih => exact ih (applyEdit_valid hd o.payload)

/-- **However the edits arrive, the design is legal.**  A replica that replays
its log — its own offline edits, a friend's edits handed over device to device,
a batch downloaded from the relay — always ends up with a design whose bricks
do not interpenetrate.  No server-side validation is needed. -/
theorem replay_valid (L : Log Edit) : Design.Valid (replay applyEdit ∅ L) :=
  valid_foldl _ Design.valid_empty

/-! ## Commuting edits -/

theorem fits_insert {d : Design} {b c : Brick} :
    Design.Fits (insert c d) b ↔ Design.Fits d b ∧ b.overlaps c = false := by
  constructor
  · intro h
    exact ⟨fun e he => h e (Finset.mem_insert_of_mem he), h c (Finset.mem_insert_self _ _)⟩
  · rintro ⟨h, hc⟩ e he
    rcases Finset.mem_insert.1 he with rfl | he
    · exact hc
    · exact h e he

theorem fits_erase {d : Design} {b c : Brick} (h : b.overlaps c = false) :
    Design.Fits (d.erase c) b ↔ Design.Fits d b := by
  constructor
  · intro hf e he
    by_cases hec : e = c
    · subst hec; exact h
    · exact hf e (Finset.mem_erase.2 ⟨hec, he⟩)
  · intro hf e he
    exact hf e (Finset.mem_of_mem_erase he)

/-- Two edits about bricks that do not clash commute: a client may apply them
the instant they arrive, in either order, and still agree with every other
client.  Only edits about clashing bricks need the canonical order of
`Net.Log`, which is exactly what that order is for. -/
theorem applyEdit_comm (d : Design) (e₁ e₂ : Edit) (h₁ : e₁.brick.Proper)
    (h : e₁.brick.overlaps e₂.brick = false) :
    applyEdit (applyEdit d e₁) e₂ = applyEdit (applyEdit d e₂) e₁ := by
  have hne : e₁.brick ≠ e₂.brick := by
    intro hbc
    rw [hbc] at h₁ h
    rw [Brick.overlaps_self _ h₁] at h
    exact Bool.noConfusion h
  have h' : e₂.brick.overlaps e₁.brick = false := by
    rw [Brick.overlaps_comm]; exact h
  cases e₁ with
  | place b =>
      cases e₂ with
      | place c =>
          simp only [Edit.brick] at hne h h'
          simp only [applyEdit]
          by_cases hb : Design.Fits d b
          · by_cases hc : Design.Fits d c
            · have h1 : Design.Fits (insert b d) c := fits_insert.2 ⟨hc, h'⟩
              have h2 : Design.Fits (insert c d) b := fits_insert.2 ⟨hb, h⟩
              rw [if_pos hb, if_pos hc, if_pos h1, if_pos h2]
              exact Finset.insert_comm _ _ _
            · have h1 : ¬ Design.Fits (insert b d) c := fun hcon => hc (fits_insert.1 hcon).1
              rw [if_pos hb, if_neg hc, if_neg h1, if_pos hb]
          · by_cases hc : Design.Fits d c
            · have h2 : ¬ Design.Fits (insert c d) b := fun hcon => hb (fits_insert.1 hcon).1
              rw [if_neg hb, if_pos hc, if_neg h2]
            · rw [if_neg hb, if_neg hc, if_neg hb]
      | remove c =>
          simp only [Edit.brick] at hne h h'
          simp only [applyEdit]
          by_cases hb : Design.Fits d b
          · have h2 : Design.Fits (d.erase c) b := (fits_erase h).2 hb
            rw [if_pos hb, if_pos h2]
            exact Finset.erase_insert_of_ne hne
          · have h2 : ¬ Design.Fits (d.erase c) b := fun hcon => hb ((fits_erase h).1 hcon)
            rw [if_neg hb, if_neg h2]
  | remove b =>
      cases e₂ with
      | place c =>
          simp only [Edit.brick] at hne h h'
          simp only [applyEdit]
          by_cases hc : Design.Fits d c
          · have h2 : Design.Fits (d.erase b) c := (fits_erase h').2 hc
            rw [if_pos hc, if_pos h2]
            exact (Finset.erase_insert_of_ne (Ne.symm hne)).symm
          · have h2 : ¬ Design.Fits (d.erase b) c := fun hcon => hc ((fits_erase h').1 hcon)
            rw [if_neg hc, if_neg h2]
      | remove c => exact Finset.erase_right_comm

end Net
end LifeTrac
