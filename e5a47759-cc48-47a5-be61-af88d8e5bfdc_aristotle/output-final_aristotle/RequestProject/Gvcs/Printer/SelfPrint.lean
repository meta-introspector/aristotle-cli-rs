import RequestProject.Gvcs.Printer.Slice

/-!
# The printer printing its own parts

This file runs the machine of `RequestProject/Printer/Machine.lean` on a real
job: the plastic parts of the printer itself, laid out on the bed and printed
in one batch.

The model is coarse — each voxel is a 10 mm cell of the part, each tick a
second of machine time — but nothing here is asserted: the toolpath is produced
by the slicer of `RequestProject/Printer/Slice.lean`, the machine executes it
instruction by instruction, and the figures below (908 cells of filament, 3835
ticks on the clock) are what the interpreter computes, checked by the kernel.

* `parts_supported` — the layout is self-supporting, so the print is possible
  without support material;
* `selfPrint` — **the printer prints its own parts**: the job runs to
  completion with no fault and the material on the bed is exactly the six
  parts;
* `floating_print_faults` — the contrast: a part with nothing under it stops
  the machine with a `midAir` fault instead of printing.

What the printer *cannot* make — the motors, rods, hot end and electronics —
is counted in `RequestProject/Printer/SelfRep.lean`.
-/

namespace LifeTrac
namespace Printer

open Voxel Voxel.Solid

/-! ## Building self-supporting solids -/

theorem supported_empty : Supported Solid.empty := by
  intro v hv; simp at hv

/-- A brick sitting on the bed is self-supporting. -/
theorem supported_box {lo hi : Vox} (h : lo.z = 0) : Supported (Solid.box lo hi) := by
  intro v hv
  rw [Solid.mem_box] at hv
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hv
  by_cases hz : v.z = 0
  · exact Or.inl hz
  · refine Or.inr ?_
    rw [Solid.mem_box]
    simp only [Vox.x_mk, Vox.y_mk, Vox.z_mk]
    rw [h] at h5 ⊢
    exact ⟨h1, h2, h3, h4, by omega, by omega⟩

/-- The union of two self-supporting solids is self-supporting. -/
theorem Supported.cup {s t : Solid} (hs : Supported s) (ht : Supported t) :
    Supported (Solid.cup s t) := by
  intro v hv
  rw [Solid.cup_apply, Bool.or_eq_true] at hv
  rcases hv with hv | hv
  · rcases hs v hv with h | h
    · exact Or.inl h
    · exact Or.inr (by simp [h])
  · rcases ht v hv with h | h
    · exact Or.inl h
    · exact Or.inr (by simp [h])

/-- An assembly of self-supporting parts is self-supporting. -/
theorem Supported.unions {l : List Solid} (h : ∀ s ∈ l, Supported s) :
    Supported (Solid.unions l) := by
  induction l with
  | nil => exact supported_empty
  | cons s l ih =>
      rw [Solid.unions_cons]
      exact (h s (by simp)).cup (ih fun u hu => h u (by simp [hu]))

/-! ## The machine and its own plastic parts -/

/-- A D3D-sized printer: a 22 × 24 × 8 cell build volume (220 × 240 × 80 mm at
10 mm to the cell), a hot end that will not push filament below 180 °C and
burns out above 260 °C, and a thirty-second homing sequence. -/
def d3d : Machine :=
  { env := { sx := 22, sy := 24, sz := 8 }, minTemp := 180, maxTemp := 260, homeTicks := 30 }

/-- A Z-motor mount: a base plate with an upright web. -/
def zMountLeft : Solid := Solid.cup (Solid.box (0, 0, 0) (7, 7, 1)) (Solid.box (0, 0, 0) (1, 7, 5))

/-- The other Z-motor mount, beside it on the bed. -/
def zMountRight : Solid :=
  Solid.cup (Solid.box (10, 0, 0) (17, 7, 1)) (Solid.box (10, 0, 0) (11, 7, 5))

/-- The X carriage: a plate with a raised boss for the hot end. -/
def xCarriage : Solid :=
  Solid.cup (Solid.box (0, 10, 0) (9, 15, 1)) (Solid.box (3, 10, 0) (6, 15, 4))

/-- A belt clamp. -/
def beltClamp : Solid := Solid.box (12, 10, 0) (15, 13, 2)

/-- The filament spool holder. -/
def spoolHolder : Solid :=
  Solid.cup (Solid.box (0, 18, 0) (11, 21, 1)) (Solid.box (4, 18, 0) (7, 21, 6))

/-- The fan duct. -/
def fanDuct : Solid :=
  Solid.cup (Solid.box (14, 16, 0) (19, 21, 1)) (Solid.box (14, 16, 0) (15, 21, 4))

/-- The six printed parts of the printer, arranged on the bed for one batch. -/
def printerParts : Solid :=
  Solid.unions [zMountLeft, zMountRight, xCarriage, beltClamp, spoolHolder, fanDuct]

/-- Everything in the batch rests on the bed, so the whole plate is
self-supporting. -/
theorem parts_supported : Supported printerParts := by
  refine Supported.unions ?_
  intro s hs
  fin_cases hs <;>
    first
      | exact supported_box rfl
      | exact (supported_box rfl).cup (supported_box rfl)

/-! ## The run -/

set_option maxRecDepth 1000000
set_option maxHeartbeats 2000000

/-- The batch is 908 cells of plastic. -/
theorem printerParts_cells : (enum d3d.env printerParts).length = 908 := by decide

/-- Walking that toolpath takes 3620 ticks. -/
theorem printerParts_pathCost : pathCost (0, 0, 0) (enum d3d.env printerParts) = 3620 := by decide

/-- **The printer prints its own parts.**  Starting cold at 20 °C and heating
to 205 °C, the machine executes the whole job without a fault; what is left on
the bed is exactly the six parts; it consumes 908 cells of filament, one per
cell of part, and the clock reads 3835 ticks — thirty to home, a hundred and
eighty-five to heat, and 3620 of printing. -/
theorem selfPrint :
    (run d3d (job d3d 205 printerParts) (State.init 20)).fault = none ∧
      (∀ v, v ∈ (run d3d (job d3d 205 printerParts) (State.init 20)).deposited ↔
        (printerParts v = true ∧ d3d.env.mem v = true)) ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).filament = 908 ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).deposited.card = 908 ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).clock = 3835 := by
  obtain ⟨h1, h2, h3, h4, h5⟩ :=
    job_prints d3d printerParts 205 20 parts_supported (by decide) (by decide)
  refine ⟨h1, h2, ?_, ?_, ?_⟩
  · rw [h3, printerParts_cells]
  · rw [h4, printerParts_cells]
  · rw [h5, printerParts_pathCost]; rfl

/-! ## What the machine will not do -/

/-- A small printer, for the counterexample. -/
def tiny : Machine :=
  { env := { sx := 4, sy := 4, sz := 6 }, minTemp := 180, maxTemp := 260, homeTicks := 30 }

/-- A block hanging three layers above the bed. -/
def floating : Solid := Solid.box (0, 0, 3) (2, 2, 5)

/-- It is not self-supporting. -/
theorem floating_not_supported : ¬ Supported floating := by
  intro h
  rcases h (0, 0, 3) (by decide) with h' | h'
  · exact absurd h' (by decide)
  · exact absurd h' (by decide)

/-- **And the machine refuses to print it.**  The job for the floating block
stops with a mid-air fault, having laid down nothing. -/
theorem floating_print_faults :
    (run tiny (job tiny 205 floating) (State.init 20)).fault = some Fault.midAir ∧
      (run tiny (job tiny 205 floating) (State.init 20)).deposited = ∅ := by
  constructor <;> decide

end Printer
end LifeTrac
