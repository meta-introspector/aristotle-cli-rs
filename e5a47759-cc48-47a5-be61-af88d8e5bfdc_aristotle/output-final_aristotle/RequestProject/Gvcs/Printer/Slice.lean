import RequestProject.Gvcs.Printer.Machine

/-!
# Slicing: turning a solid into a print job, and running it

`RequestProject/Voxel/Core.lean` represents a part as a `Solid`, a predicate on
the integer lattice.  This file *slices* one: `enum` walks the build volume
bottom layer first, row by row, and lists the voxels of the part; `job` wraps
that list in the G-code preamble — home, heat, then one extrusion per voxel.

The theorems are the ones a slicer ought to come with:

* `mem_enum` — the toolpath visits exactly the voxels of the model that lie in
  the build volume, and nothing else, and visits each one once (`nodup_enum`);
* `run_extrudes` — running a list of extrusions on fresh, supported, in-volume
  voxels faults nowhere and leaves exactly those voxels on the bed;
* `job_prints` — **the part that comes off the bed is the model**: for a
  self-supporting model and a sane hot-end temperature the whole job runs
  without a fault and the deposited set is exactly the model intersected with
  the build volume, one voxel of filament per voxel of part.

Supportedness (`Supported`) is the real constraint: a voxel is either on the
bed or has model material directly beneath it.  That is what printing without
support material means physically, and the machine of `Machine.lean` refuses to
extrude into thin air.
-/

namespace LifeTrac
namespace Printer

open Voxel

/-! ## Self-supporting solids -/

/-- A solid is *self-supporting* if every voxel of it is on the bed or has
material of the same solid directly underneath. -/
def Supported (sol : Solid) : Prop :=
  ∀ v : Vox, sol v = true → v.z = 0 ∨ sol (v.x, v.y, v.z - 1) = true

/-- Support only depends on what is already on the bed, and the bed only
grows. -/
theorem supports_mono {s t : State} (h : s.deposited ⊆ t.deposited) {v : Vox}
    (hv : s.supports v) : t.supports v := by
  rcases hv with hz | hz
  · exact Or.inl hz
  · exact Or.inr (h hz)

/-! ## The toolpath

The path is built the way a printer moves: along `x` within a row, over the
rows of a layer in `y`, then up in `z`. -/

/-- The voxels of `sol` in row `y` of layer `z`, columns `0 … n-1`. -/
def enumRow (sol : Solid) (y z : ℕ) : ℕ → List Vox
  | 0 => []
  | n + 1 => enumRow sol y z n ++
      (if sol ((n : ℤ), (y : ℤ), (z : ℤ)) = true then [(((n : ℤ), (y : ℤ), (z : ℤ)) : Vox)] else [])

/-- The voxels of `sol` in the first `m` rows of layer `z`. -/
def enumRows (sx : ℤ) (sol : Solid) (z : ℕ) : ℕ → List Vox
  | 0 => []
  | m + 1 => enumRows sx sol z m ++ enumRow sol m z sx.toNat

/-- The voxels of `sol` in layer `z` of the build volume. -/
def enumLayer (e : Envelope) (sol : Solid) (z : ℕ) : List Vox :=
  enumRows e.sx sol z e.sy.toNat

/-- The voxels of `sol` in the first `n` layers, bottom layer first. -/
def enumUpto (e : Envelope) (sol : Solid) : ℕ → List Vox
  | 0 => []
  | n + 1 => enumUpto e sol n ++ enumLayer e sol n

/-- The whole toolpath: every voxel of `sol` inside the build volume, bottom
layer first. -/
def enum (e : Envelope) (sol : Solid) : List Vox := enumUpto e sol e.sz.toNat

theorem mem_enumRow (sol : Solid) (y z n : ℕ) (v : Vox) :
    v ∈ enumRow sol y z n ↔
      sol v = true ∧ (0 ≤ v.x ∧ v.x < (n : ℤ)) ∧ v.y = (y : ℤ) ∧ v.z = (z : ℤ) := by
  simp only [Vox.x, Vox.y, Vox.z]
  induction n with
  | zero => simp [enumRow]
  | succ n ih =>
      rw [enumRow, List.mem_append, ih]
      constructor
      · rintro (⟨hs, hx, hy, hz⟩ | h)
        · exact ⟨hs, ⟨hx.1, by push_cast; omega⟩, hy, hz⟩
        · by_cases hc : sol ((n : ℤ), (y : ℤ), (z : ℤ)) = true
          · rw [if_pos hc] at h
            simp only [List.mem_singleton] at h
            subst h
            exact ⟨hc, ⟨by positivity, by push_cast; omega⟩, rfl, rfl⟩
          · rw [if_neg hc] at h; simp at h
      · rintro ⟨hs, ⟨hx0, hx⟩, hy, hz⟩
        rcases lt_or_ge v.1 (n : ℤ) with h | h
        · exact Or.inl ⟨hs, ⟨hx0, h⟩, hy, hz⟩
        · right
          have hv : v = (((n : ℤ), (y : ℤ), (z : ℤ)) : Vox) := by
            obtain ⟨a, b, c⟩ := v
            simp only at hx hx0 h hy hz ⊢
            push_cast at hx
            have ha : a = (n : ℤ) := by omega
            simp [ha, hy, hz]
          subst hv
          rw [if_pos hs]
          simp

theorem nodup_enumRow (sol : Solid) (y z n : ℕ) : (enumRow sol y z n).Nodup := by
  induction n with
  | zero => simp [enumRow]
  | succ n ih =>
      rw [enumRow]
      refine List.Nodup.append ih (by split <;> simp) ?_
      intro v hv hv'
      rw [mem_enumRow] at hv
      by_cases hc : sol ((n : ℤ), (y : ℤ), (z : ℤ)) = true
      · rw [if_pos hc] at hv'
        simp only [List.mem_singleton] at hv'
        subst hv'
        have := hv.2.1.2
        simp only [Vox.x_mk] at this
        omega
      · rw [if_neg hc] at hv'; simp at hv'

theorem mem_enumRows (sx : ℤ) (sol : Solid) (z m : ℕ) (v : Vox) :
    v ∈ enumRows sx sol z m ↔
      sol v = true ∧ (0 ≤ v.x ∧ v.x < sx) ∧ (0 ≤ v.y ∧ v.y < (m : ℤ)) ∧ v.z = (z : ℤ) := by
  induction m with
  | zero => simp [enumRows]
  | succ m ih =>
      rw [enumRows, List.mem_append, ih, mem_enumRow]
      constructor
      · rintro (⟨hs, hx, hy, hz⟩ | ⟨hs, hx, hy, hz⟩)
        · exact ⟨hs, hx, ⟨hy.1, by push_cast; omega⟩, hz⟩
        · exact ⟨hs, ⟨hx.1, by omega⟩, ⟨by omega, by push_cast; omega⟩, hz⟩
      · rintro ⟨hs, hx, hy, hz⟩
        rcases lt_or_ge v.y (m : ℤ) with h | h
        · exact Or.inl ⟨hs, hx, ⟨hy.1, h⟩, hz⟩
        · have hym : v.y = (m : ℤ) := by have := hy.2; push_cast at this; omega
          exact Or.inr ⟨hs, ⟨hx.1, by omega⟩, hym, hz⟩

theorem nodup_enumRows (sx : ℤ) (sol : Solid) (z m : ℕ) : (enumRows sx sol z m).Nodup := by
  induction m with
  | zero => simp [enumRows]
  | succ m ih =>
      rw [enumRows]
      refine List.Nodup.append ih (nodup_enumRow _ _ _ _) ?_
      intro v hv hv'
      rw [mem_enumRows] at hv
      rw [mem_enumRow] at hv'
      have h1 := hv.2.2.1.2
      have h2 := hv'.2.2.1
      omega

theorem mem_enumLayer (e : Envelope) (sol : Solid) (z : ℕ) (v : Vox) :
    v ∈ enumLayer e sol z ↔
      sol v = true ∧ (0 ≤ v.x ∧ v.x < e.sx) ∧ (0 ≤ v.y ∧ v.y < e.sy) ∧ v.z = (z : ℤ) := by
  rw [enumLayer, mem_enumRows]
  constructor
  · rintro ⟨hs, hx, hy, hz⟩; exact ⟨hs, hx, ⟨hy.1, by omega⟩, hz⟩
  · rintro ⟨hs, hx, hy, hz⟩; exact ⟨hs, hx, ⟨hy.1, by omega⟩, hz⟩

theorem nodup_enumLayer (e : Envelope) (sol : Solid) (z : ℕ) : (enumLayer e sol z).Nodup :=
  nodup_enumRows _ _ _ _

theorem mem_enumUpto (e : Envelope) (sol : Solid) (n : ℕ) (v : Vox) :
    v ∈ enumUpto e sol n ↔
      sol v = true ∧ (0 ≤ v.x ∧ v.x < e.sx) ∧ (0 ≤ v.y ∧ v.y < e.sy) ∧
        (0 ≤ v.z ∧ v.z < (n : ℤ)) := by
  induction n with
  | zero => simp [enumUpto]
  | succ n ih =>
      rw [enumUpto, List.mem_append, ih, mem_enumLayer]
      constructor
      · rintro (⟨hs, hx, hy, hz⟩ | ⟨hs, hx, hy, hz⟩)
        · exact ⟨hs, hx, hy, hz.1, by push_cast; omega⟩
        · exact ⟨hs, hx, hy, by omega, by push_cast; omega⟩
      · rintro ⟨hs, hx, hy, hz⟩
        rcases lt_or_ge v.z (n : ℤ) with h | h
        · exact Or.inl ⟨hs, hx, hy, hz.1, h⟩
        · refine Or.inr ⟨hs, hx, hy, ?_⟩
          have := hz.2
          push_cast at this
          omega

theorem nodup_enumUpto (e : Envelope) (sol : Solid) (n : ℕ) : (enumUpto e sol n).Nodup := by
  induction n with
  | zero => simp [enumUpto]
  | succ n ih =>
      rw [enumUpto]
      refine List.Nodup.append ih (nodup_enumLayer e sol n) ?_
      intro v hv hv'
      rw [mem_enumUpto] at hv
      rw [mem_enumLayer] at hv'
      have h1 := hv.2.2.2.2
      have h2 := hv'.2.2.2
      omega

/-- **The toolpath visits exactly the model.**  A voxel is on the path iff the
model has material there and the machine can reach it. -/
theorem mem_enum (e : Envelope) (sol : Solid) (v : Vox) :
    v ∈ enum e sol ↔ sol v = true ∧ e.mem v = true := by
  rw [enum, mem_enumUpto, Envelope.mem_iff]
  constructor
  · rintro ⟨hs, hx, hy, hz⟩; exact ⟨hs, hx, hy, hz.1, by omega⟩
  · rintro ⟨hs, hx, hy, hz⟩; exact ⟨hs, hx, hy, hz.1, by omega⟩

/-- No voxel is printed twice. -/
theorem nodup_enum (e : Envelope) (sol : Solid) : (enum e sol).Nodup := nodup_enumUpto e sol _

/-! ## Running a list of extrusions -/

/-- The time the gantry spends walking a toolpath from `p`: one tick per
millimetre of travel and one tick to lay each voxel down. -/
def pathCost : Vox → List Vox → ℕ
  | _, [] => 0
  | p, v :: l => dist p v + 1 + pathCost v l

/-- **A batch of good extrusions runs clean.**  If every voxel of `l` is
distinct, reachable, unoccupied and supported at the start, the machine lays
all of them down and faults nowhere. -/
theorem run_extrudes {M : Machine} {s : State} {l : List Vox}
    (hnd : l.Nodup) (hf : s.fault = none) (hh : s.homed = true) (ht : M.minTemp ≤ s.temp)
    (henv : ∀ v ∈ l, M.env.mem v = true) (hfresh : ∀ v ∈ l, v ∉ s.deposited)
    (hsupp : ∀ v ∈ l, s.supports v) :
    (run M (l.map Instr.extrude) s).fault = none ∧
      (run M (l.map Instr.extrude) s).deposited = s.deposited ∪ l.toFinset ∧
      (run M (l.map Instr.extrude) s).filament = s.filament + l.length ∧
      (run M (l.map Instr.extrude) s).homed = true ∧
      (run M (l.map Instr.extrude) s).temp = s.temp := by
  induction l generalizing s with
  | nil => exact ⟨hf, by simp, by simp, hh, rfl⟩
  | cons v l ih =>
      have hv : M.env.mem v = true := henv v (by simp)
      have hvf : v ∉ s.deposited := hfresh v (by simp)
      have hvs : s.supports v := hsupp v (by simp)
      have hstep := step_extrude_ok hf hh hv ht hvf hvs
      have hsub : s.deposited ⊆ (step M (Instr.extrude v) s).deposited :=
        step_deposited_subset M _ s
      have hnd' : l.Nodup := hnd.of_cons
      have hvnot : v ∉ l := by simpa using hnd.notMem
      obtain ⟨e1, e2, e3, e4, e5⟩ :=
        ih (s := step M (Instr.extrude v) s) hnd'
          (by rw [hstep]; exact hf) (by rw [hstep]; exact hh) (by rw [hstep]; exact ht)
          (fun w hw => henv w (by simp [hw]))
          (fun w hw => by
            rw [hstep]
            simp only [Finset.mem_insert, not_or]
            exact ⟨fun hwv => hvnot (hwv ▸ hw), hfresh w (by simp [hw])⟩)
          (fun w hw => supports_mono hsub (hsupp w (by simp [hw])))
      refine ⟨by simpa using e1, ?_, ?_, by simpa using e4, ?_⟩
      · simp only [List.map_cons, run_cons]
        rw [e2, hstep]
        simp only [List.toFinset_cons]
        rw [Finset.insert_union, Finset.union_insert]
      · simp only [List.map_cons, run_cons]
        rw [e3, hstep]
        simp only [List.length_cons]
        omega
      · simp only [List.map_cons, run_cons]
        rw [e5, hstep]

/-- **How long the print takes.**  A run of extrusions that ends without a
fault took exactly the time of walking its toolpath. -/
theorem run_extrudes_clock {M : Machine} {s : State} {l : List Vox}
    (h : (run M (l.map Instr.extrude) s).fault = none) :
    (run M (l.map Instr.extrude) s).clock = s.clock + pathCost s.pos l := by
  induction l generalizing s with
  | nil => simp [pathCost]
  | cons v l ih =>
      simp only [List.map_cons, run_cons] at h ⊢
      have hstep : (step M (Instr.extrude v) s).fault = none :=
        fault_none_of_run_fault_none h
      obtain ⟨-, -, hclock, hpos, -⟩ := step_extrude_deposited hstep
      rw [ih h, hclock, hpos]
      simp only [pathCost]
      omega

/-! ## The print job -/

/-- The G-code of a print: home, heat, then the toolpath. -/
def job (M : Machine) (t : ℤ) (sol : Solid) : List Instr :=
  Instr.home :: Instr.setTemp t :: (enum M.env sol).map Instr.extrude

/-- The state after the preamble: homed, at temperature, bed empty. -/
theorem run_preamble (M : Machine) (t a : ℤ) (ht : t ≤ M.maxTemp) :
    run M [Instr.home, Instr.setTemp t] (State.init a) =
      { pos := (0, 0, 0), temp := t, homed := true, deposited := ∅, filament := 0,
        clock := M.homeTicks + (t - a).natAbs, fault := none } := by
  simp [run, step, State.init, not_lt.2 ht]

/-- **The print is the model.**  For a self-supporting model and a hot end set
between the extrusion minimum and the safe maximum, the whole job runs without
a fault, and what is left on the bed is exactly the model, restricted to the
build volume — one voxel of filament for each voxel of part. -/
theorem job_prints (M : Machine) (sol : Solid) (t a : ℤ) (hsup : Supported sol)
    (hlo : M.minTemp ≤ t) (hhi : t ≤ M.maxTemp) :
    (run M (job M t sol) (State.init a)).fault = none ∧
      (∀ v, v ∈ (run M (job M t sol) (State.init a)).deposited ↔
        (sol v = true ∧ M.env.mem v = true)) ∧
      (run M (job M t sol) (State.init a)).filament = (enum M.env sol).length ∧
      (run M (job M t sol) (State.init a)).deposited.card = (enum M.env sol).length ∧
      (run M (job M t sol) (State.init a)).clock =
        M.homeTicks + (t - a).natAbs + pathCost (0, 0, 0) (enum M.env sol) := by
  have hpre := run_preamble M t a hhi
  set s : State :=
    { pos := ((0 : ℤ), (0 : ℤ), (0 : ℤ)), temp := t, homed := true, deposited := ∅, filament := 0,
      clock := M.homeTicks + (t - a).natAbs, fault := none } with hs
  have hjob : run M (job M t sol) (State.init a) =
      run M ((enum M.env sol).map Instr.extrude) s := by
    rw [job, show (Instr.home :: Instr.setTemp t :: (enum M.env sol).map Instr.extrude) =
      [Instr.home, Instr.setTemp t] ++ (enum M.env sol).map Instr.extrude from rfl,
      run_append, hpre]
  have key : ∀ n : ℕ, n ≤ M.env.sz.toNat →
      (run M ((enumUpto M.env sol n).map Instr.extrude) s).fault = none ∧
      (run M ((enumUpto M.env sol n).map Instr.extrude) s).deposited =
        (enumUpto M.env sol n).toFinset ∧
      (run M ((enumUpto M.env sol n).map Instr.extrude) s).filament =
        (enumUpto M.env sol n).length ∧
      (run M ((enumUpto M.env sol n).map Instr.extrude) s).homed = true ∧
      (run M ((enumUpto M.env sol n).map Instr.extrude) s).temp = t := by
    intro n
    induction n with
    | zero =>
        intro _
        refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> rw [enumUpto] <;> simp [hs]
    | succ n ih =>
        intro hn
        obtain ⟨i1, i2, i3, i4, i5⟩ := ih (by omega)
        have hnz : (n : ℤ) < M.env.sz := by omega
        set s' : State := run M ((enumUpto M.env sol n).map Instr.extrude) s with hs'
        obtain ⟨l1, l2, l3, l4, l5⟩ := run_extrudes (M := M) (s := s') (l := enumLayer M.env sol n)
          (nodup_enumLayer _ _ _) i1 i4 (by rw [i5]; exact hlo)
          (by
            intro v hv
            rw [mem_enumLayer] at hv
            rw [Envelope.mem_iff]
            exact ⟨hv.2.1, hv.2.2.1, by omega, by omega⟩)
          (by
            intro v hv
            rw [mem_enumLayer] at hv
            rw [i2, List.mem_toFinset, mem_enumUpto]
            intro hc
            have h1 := hc.2.2.2.2
            have h2 := hv.2.2.2
            omega)
          (by
            intro v hv
            rw [mem_enumLayer] at hv
            have hzv : v.z = (n : ℤ) := hv.2.2.2
            rcases Nat.eq_zero_or_pos n with rfl | hpos
            · exact Or.inl (by simpa using hzv)
            · refine Or.inr ?_
              have hzne : v.z ≠ 0 := by omega
              have hbelow : sol (v.x, v.y, v.z - 1) = true := (hsup v hv.1).resolve_left hzne
              rw [i2, List.mem_toFinset, mem_enumUpto]
              refine ⟨hbelow, ?_, ?_, ?_⟩
              · simpa using hv.2.1
              · simpa using hv.2.2.1
              · simp only [Vox.z_mk]
                omega)
        refine ⟨?_, ?_, ?_, ?_, ?_⟩
        · rw [enumUpto, List.map_append, run_append, ← hs']; exact l1
        · rw [enumUpto, List.map_append, run_append, ← hs', l2, i2, List.toFinset_append]
        · rw [enumUpto, List.map_append, run_append, ← hs', l3, i3, List.length_append]
        · rw [enumUpto, List.map_append, run_append, ← hs']; exact l4
        · rw [enumUpto, List.map_append, run_append, ← hs', l5, i5]
  obtain ⟨k1, k2, k3, -, -⟩ := key M.env.sz.toNat le_rfl
  have hclock : (run M ((enum M.env sol).map Instr.extrude) s).clock =
      M.homeTicks + (t - a).natAbs + pathCost (0, 0, 0) (enum M.env sol) := by
    rw [run_extrudes_clock (by rw [enum]; exact k1), hs]
  rw [hjob]
  refine ⟨by rw [enum]; exact k1, ?_, ?_, ?_, hclock⟩
  · intro v
    rw [enum, k2, List.mem_toFinset]
    exact mem_enum M.env sol v
  · rw [enum, k3]
  · rw [enum, k2, List.toFinset_card_of_nodup (nodup_enumUpto M.env sol _)]

end Printer
end LifeTrac
