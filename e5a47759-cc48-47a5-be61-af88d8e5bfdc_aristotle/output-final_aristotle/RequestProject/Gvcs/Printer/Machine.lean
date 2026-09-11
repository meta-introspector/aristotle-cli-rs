import RequestProject.Gvcs.Voxel.Core

/-!
# Running a 3D printer

`RequestProject/GVCSEcology.lean` singles out the **3D printer** as the one
machine of the Global Village Construction Set that opens the whole set: given
the printer, four rounds of building produce the other forty-nine.  This file
takes the next step and makes the printer *run*.

A printer here is a machine with

* a build envelope (`Envelope`), a box of voxels it can reach;
* a hot end with a minimum extrusion temperature and a maximum safe
  temperature;
* a homing time.

A print job is a list of instructions (`Instr`) — the abstract syntax of the
G-code the machine actually eats: `G28` home, `M104` set temperature, `G0`
travel, `G1 … E` extrude one voxel, `G4` dwell.  `step` is one instruction of
the machine's operation and `run` is the whole job: an interpreter, so a print
is *executed*, not described.

The machine models the ways a print goes wrong, as sticky faults:

| fault | meaning |
| --- | --- |
| `notHomed` | the machine was told to move before it knew where it was |
| `outOfEnvelope` | the toolpath leaves the build volume |
| `coldExtrude` | filament pushed through a cold nozzle |
| `overheat` | commanded hot-end temperature above the safe maximum |
| `collision` | the nozzle is driven into material already laid down |
| `midAir` | material extruded with nothing under it |

Once faulted the machine is frozen (`run_of_fault`); nothing further is
deposited.  So a job that ends fault-free is a job in which *every* deposit was
made hot, in the envelope, on fresh ground, and resting on the bed or on the
layer below — which is what the theorems at the bottom of this file say.

`RequestProject/Printer/Slice.lean` compiles a solid into such a job and proves
the print comes out equal to the model; `RequestProject/Printer/SelfRep.lean`
prints the printer's own parts.
-/

namespace LifeTrac
namespace Printer

open Voxel

/-! ## The machine -/

/-- The build volume: the voxels `0 ≤ x < sx`, `0 ≤ y < sy`, `0 ≤ z < sz`. -/
structure Envelope where
  /-- Extent along `x`. -/
  sx : ℤ
  /-- Extent along `y`. -/
  sy : ℤ
  /-- Extent along `z`. -/
  sz : ℤ
  deriving DecidableEq, Repr

/-- Can the nozzle reach this voxel? -/
def Envelope.mem (e : Envelope) (v : Vox) : Bool :=
  0 ≤ v.x && v.x < e.sx && 0 ≤ v.y && v.y < e.sy && 0 ≤ v.z && v.z < e.sz

theorem Envelope.mem_iff (e : Envelope) (v : Vox) :
    e.mem v = true ↔
      (0 ≤ v.x ∧ v.x < e.sx) ∧ (0 ≤ v.y ∧ v.y < e.sy) ∧ (0 ≤ v.z ∧ v.z < e.sz) := by
  simp [Envelope.mem, and_assoc]

theorem Envelope.z_nonneg {e : Envelope} {v : Vox} (h : e.mem v = true) : 0 ≤ v.z :=
  ((e.mem_iff v).1 h).2.2.1

/-- A printer: a build volume, a hot end and a homing sequence. -/
structure Machine where
  /-- The build volume. -/
  env : Envelope
  /-- Below this temperature the extruder refuses to push filament. -/
  minTemp : ℤ
  /-- Above this temperature the hot end is destroyed. -/
  maxTemp : ℤ
  /-- Ticks taken by the homing sequence. -/
  homeTicks : ℕ
  deriving DecidableEq, Repr

/-- Manhattan distance, the time the gantry takes to go from `p` to `q`. -/
def dist (p q : Vox) : ℕ :=
  (p.x - q.x).natAbs + (p.y - q.y).natAbs + (p.z - q.z).natAbs

@[simp] theorem dist_self (p : Vox) : dist p p = 0 := by simp [dist]

/-! ## The instruction set -/

/-- The abstract syntax of the machine's G-code. -/
inductive Instr
  /-- `G28`: home all axes. -/
  | home
  /-- `M104 S⟨t⟩`: set the hot-end temperature. -/
  | setTemp (t : ℤ)
  /-- `G0 X Y Z`: rapid move, no material. -/
  | travel (p : Vox)
  /-- `G1 X Y Z E1`: move to `p` laying down one voxel of material there. -/
  | extrude (p : Vox)
  /-- `G4 P⟨n⟩`: wait. -/
  | dwell (n : ℕ)
  deriving DecidableEq, Repr

/-- The ways a print goes wrong. -/
inductive Fault
  /-- Commanded to move before homing. -/
  | notHomed
  /-- Commanded outside the build volume. -/
  | outOfEnvelope
  /-- Extrusion below the minimum extrusion temperature. -/
  | coldExtrude
  /-- Commanded hot-end temperature above the safe maximum. -/
  | overheat
  /-- Extrusion into a voxel already filled. -/
  | collision
  /-- Extrusion with nothing underneath. -/
  | midAir
  deriving DecidableEq, Repr

/-- The state of the running machine. -/
structure State where
  /-- Where the nozzle is. -/
  pos : Vox
  /-- Hot-end temperature. -/
  temp : ℤ
  /-- Have the axes been homed? -/
  homed : Bool
  /-- The material laid down so far — the part, as it grows. -/
  deposited : Finset Vox
  /-- Voxels of filament consumed. -/
  filament : ℕ
  /-- Elapsed time, in ticks. -/
  clock : ℕ
  /-- The fault that stopped the print, if any. -/
  fault : Option Fault
  deriving DecidableEq

/-- A cold machine with an empty bed, not yet homed. -/
def State.init (ambient : ℤ) : State :=
  { pos := (0, 0, 0), temp := ambient, homed := false, deposited := ∅,
    filament := 0, clock := 0, fault := none }

/-- Is the voxel `p` supported — on the bed, or on material already laid? -/
def State.supports (s : State) (p : Vox) : Prop :=
  p.z = 0 ∨ (p.x, p.y, p.z - 1) ∈ s.deposited

instance (s : State) (p : Vox) : Decidable (s.supports p) := by
  unfold State.supports; infer_instance

/-! ## The interpreter -/

/-- Will an extrusion at `p` succeed?  It must be homed, in the envelope, hot,
aimed at empty space, and supported from below. -/
def extrudeOk (M : Machine) (s : State) (p : Vox) : Bool :=
  s.homed && M.env.mem p && decide (M.minTemp ≤ s.temp) && !decide (p ∈ s.deposited) &&
    decide (s.supports p)

theorem extrudeOk_iff (M : Machine) (s : State) (p : Vox) :
    extrudeOk M s p = true ↔
      s.homed = true ∧ M.env.mem p = true ∧ M.minTemp ≤ s.temp ∧ p ∉ s.deposited ∧
        s.supports p := by
  simp [extrudeOk, and_assoc]

/-- Why an extrusion at `p` would fail — the first rule it breaks. -/
def extrudeFault (M : Machine) (s : State) (p : Vox) : Fault :=
  if s.homed = false then .notHomed
  else if M.env.mem p = false then .outOfEnvelope
  else if s.temp < M.minTemp then .coldExtrude
  else if p ∈ s.deposited then .collision
  else .midAir

/-- One instruction of the machine's operation.  A faulted machine does
nothing at all. -/
def step (M : Machine) (i : Instr) (s : State) : State :=
  if s.fault.isSome then s else
  match i with
  | .home => { s with pos := (0, 0, 0), homed := true, clock := s.clock + M.homeTicks }
  | .setTemp t =>
      if M.maxTemp < t then { s with fault := some .overheat }
      else { s with temp := t, clock := s.clock + (t - s.temp).natAbs }
  | .travel p =>
      if s.homed = false then { s with fault := some .notHomed }
      else if M.env.mem p = false then { s with fault := some .outOfEnvelope }
      else { s with pos := p, clock := s.clock + dist s.pos p }
  | .extrude p =>
      if extrudeOk M s p then
        { s with pos := p, deposited := insert p s.deposited, filament := s.filament + 1, clock := s.clock + dist s.pos p + 1 }
      else { s with fault := some (extrudeFault M s p) }
  | .dwell n => { s with clock := s.clock + n }

/-- Running a whole job. -/
def run (M : Machine) (p : List Instr) (s : State) : State :=
  p.foldl (fun s i => step M i s) s

@[simp] theorem run_nil (M : Machine) (s : State) : run M [] s = s := rfl

@[simp] theorem run_cons (M : Machine) (i : Instr) (p : List Instr) (s : State) :
    run M (i :: p) s = run M p (step M i s) := rfl

/-- Jobs compose: running `p` then `q` is running `p ++ q`. -/
theorem run_append (M : Machine) (p q : List Instr) (s : State) :
    run M (p ++ q) s = run M q (run M p s) := by
  simp [run, List.foldl_append]

/-! ## Faults are final -/

/-- A faulted machine ignores an instruction. -/
theorem step_of_fault {M : Machine} {s : State} (h : s.fault.isSome) (i : Instr) :
    step M i s = s := by
  simp [step, h]

/-- A faulted machine ignores the rest of the job. -/
theorem run_of_fault {M : Machine} {s : State} (h : s.fault.isSome) (p : List Instr) :
    run M p s = s := by
  induction p generalizing s with
  | nil => rfl
  | cons i p ih => rw [run_cons, step_of_fault h, ih h]

/-- Once faulted, always faulted. -/
theorem fault_persists {M : Machine} {s : State} (h : s.fault.isSome) (p : List Instr) :
    (run M p s).fault.isSome := by
  rw [run_of_fault h]; exact h

/-- **A clean finish means a clean start.**  If the job ends without a fault
then the machine had not faulted when it began. -/
theorem fault_none_of_run_fault_none {M : Machine} {s : State} {p : List Instr}
    (h : (run M p s).fault = none) : s.fault = none := by
  by_contra hs
  have : (run M p s).fault.isSome := fault_persists (Option.isSome_iff_ne_none.2 hs) p
  rw [h] at this; exact absurd this (by simp)

/-- And every step of it was clean. -/
theorem step_fault_none_of_run_fault_none {M : Machine} {s : State} {i : Instr} {p : List Instr}
    (h : (run M (i :: p) s).fault = none) : (step M i s).fault = none :=
  fault_none_of_run_fault_none (p := p) (by rw [← run_cons]; exact h)

/-! ## What a single step can and cannot do -/

theorem step_deposited_subset (M : Machine) (i : Instr) (s : State) :
    s.deposited ⊆ (step M i s).deposited := by
  unfold step
  split
  · exact subset_rfl
  · cases i with
    | extrude q =>
        simp only
        split
        · exact Finset.subset_insert _ _
        · exact subset_rfl
    | _ => simp only; first | exact subset_rfl | (split_ifs <;> exact subset_rfl)

/-- Material is never removed. -/
theorem run_deposited_subset (M : Machine) (p : List Instr) (s : State) :
    s.deposited ⊆ (run M p s).deposited := by
  induction p generalizing s with
  | nil => exact subset_rfl
  | cons i p ih => exact (step_deposited_subset M i s).trans (ih (step M i s))

/-- **Nothing is extruded cold, out of the envelope, into standing material or
into thin air.**  If a step lays material down, all four conditions held. -/
theorem step_extrude_conditions {M : Machine} {q : Vox} {s : State}
    (h : (step M (.extrude q) s).deposited ≠ s.deposited) :
    s.fault = none ∧ s.homed = true ∧ M.env.mem q = true ∧ M.minTemp ≤ s.temp ∧
      q ∉ s.deposited ∧ s.supports q := by
  unfold step at h
  split at h
  · exact absurd rfl h
  · rename_i hf
    simp only [Bool.not_eq_true, Option.isSome_eq_false_iff,
      Option.isNone_iff_eq_none] at hf
    simp only at h
    split at h
    · rename_i hok
      exact ⟨hf, (extrudeOk_iff M s q).1 hok⟩
    · exact absurd rfl h

/-- A successful extrusion lays down exactly the commanded voxel. -/
theorem step_extrude_ok {M : Machine} {q : Vox} {s : State} (hf : s.fault = none)
    (hh : s.homed = true) (he : M.env.mem q = true) (ht : M.minTemp ≤ s.temp)
    (hd : q ∉ s.deposited) (hs : s.supports q) :
    step M (.extrude q) s =
      { s with pos := q, deposited := insert q s.deposited,
               filament := s.filament + 1, clock := s.clock + dist s.pos q + 1 } := by
  have hok : extrudeOk M s q = true := (extrudeOk_iff M s q).2 ⟨hh, he, ht, hd, hs⟩
  simp [step, hf, hok]

/-- If an extrusion does not fault, it deposited its voxel. -/
theorem step_extrude_deposited {M : Machine} {q : Vox} {s : State}
    (h : (step M (.extrude q) s).fault = none) :
    (step M (.extrude q) s).deposited = insert q s.deposited ∧
      (step M (.extrude q) s).filament = s.filament + 1 ∧
      (step M (.extrude q) s).clock = s.clock + dist s.pos q + 1 ∧
      (step M (.extrude q) s).pos = q ∧
      (step M (.extrude q) s).homed = s.homed ∧
      (step M (.extrude q) s).temp = s.temp ∧
      q ∉ s.deposited ∧ M.env.mem q = true ∧ s.supports q := by
  have hf : s.fault = none :=
    fault_none_of_run_fault_none (M := M) (p := [Instr.extrude q]) (by simpa using h)
  have hok : extrudeOk M s q = true := by
    by_contra hok
    have hok' : extrudeOk M s q = false := by simpa using hok
    rw [show step M (.extrude q) s = { s with fault := some (extrudeFault M s q) } by
      simp [step, hf, hok']] at h
    simp at h
  obtain ⟨hh, he, ht, hd, hs⟩ := (extrudeOk_iff M s q).1 hok
  rw [step_extrude_ok hf hh he ht hd hs]
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, hd, he, hs⟩

/-! ## Invariants of a whole run -/

/-- Everything on the bed is inside the build volume. -/
def State.InEnvelope (M : Machine) (s : State) : Prop :=
  ∀ v ∈ s.deposited, M.env.mem v = true

/-- Nothing on the bed floats: each voxel sits on the bed or on another
voxel. -/
def State.NoOverhang (s : State) : Prop :=
  ∀ v ∈ s.deposited, v.z = 0 ∨ (v.x, v.y, v.z - 1) ∈ s.deposited

theorem step_deposited_eq_of_not_extrude {M : Machine} {i : Instr} {s : State}
    (h : ∀ q, i ≠ Instr.extrude q) : (step M i s).deposited = s.deposited := by
  unfold step
  split
  · rfl
  · cases i with
    | extrude q => exact absurd rfl (h q)
    | _ => simp only; try split_ifs; all_goals rfl

theorem step_inEnvelope {M : Machine} {i : Instr} {s : State} (h : s.InEnvelope M) :
    (step M i s).InEnvelope M := by
  intro v hv
  cases i with
  | extrude q =>
      by_cases hd : (step M (Instr.extrude q) s).deposited = s.deposited
      · exact h v (hd ▸ hv)
      · obtain ⟨hf, hh, he, ht, hq, hs⟩ := step_extrude_conditions hd
        rw [step_extrude_ok hf hh he ht hq hs] at hv
        simp only at hv
        rcases Finset.mem_insert.1 hv with rfl | hv
        · exact he
        · exact h v hv
  | _ =>
      exact h v (by rwa [step_deposited_eq_of_not_extrude (fun q hq => Instr.noConfusion hq)] at hv)

/-- **A print never leaves the build volume.**  Whatever the job, every voxel
of the finished part is inside the envelope. -/
theorem run_inEnvelope (M : Machine) (p : List Instr) {s : State} (h : s.InEnvelope M) :
    (run M p s).InEnvelope M := by
  induction p generalizing s with
  | nil => exact h
  | cons i p ih => exact ih (step_inEnvelope h)

theorem step_noOverhang {M : Machine} {i : Instr} {s : State} (h : s.NoOverhang) :
    (step M i s).NoOverhang := by
  intro v hv
  cases i with
  | extrude q =>
      by_cases hd : (step M (Instr.extrude q) s).deposited = s.deposited
      · rw [hd] at hv ⊢; exact h v hv
      · obtain ⟨hf, hh, he, ht, hq, hs⟩ := step_extrude_conditions hd
        rw [step_extrude_ok hf hh he ht hq hs] at hv ⊢
        simp only at hv ⊢
        rcases Finset.mem_insert.1 hv with rfl | hv
        · rcases hs with hz | hz
          · exact Or.inl hz
          · exact Or.inr (Finset.mem_insert_of_mem hz)
        · rcases h v hv with hz | hz
          · exact Or.inl hz
          · exact Or.inr (Finset.mem_insert_of_mem hz)
  | _ =>
      rw [step_deposited_eq_of_not_extrude (fun q hq => Instr.noConfusion hq)] at hv ⊢
      exact h v hv

/-- **Nothing is printed in mid-air.**  Every voxel of the finished part rests
on the bed or on another voxel of the part. -/
theorem run_noOverhang (M : Machine) (p : List Instr) {s : State} (h : s.NoOverhang) :
    (run M p s).NoOverhang := by
  induction p generalizing s with
  | nil => exact h
  | cons i p ih => exact ih (step_noOverhang h)

/-- **Filament is conserved**, one step at a time. -/
theorem step_filament_eq_card {M : Machine} {i : Instr} {s : State}
    (h : s.deposited.card = s.filament) :
    (step M i s).deposited.card = (step M i s).filament := by
  unfold step
  split
  · exact h
  · cases i with
    | extrude q =>
        simp only
        split
        · rename_i hok
          have hd := ((extrudeOk_iff M s q).1 hok).2.2.2.1
          simp [Finset.card_insert_of_notMem hd, h]
        · exact h
    | _ => simp only; first | exact h | (split_ifs <;> exact h)

/-- **Filament in equals part out.**  Every voxel of filament pushed through
the nozzle becomes exactly one voxel of part. -/
theorem run_filament_eq_card (M : Machine) (p : List Instr) {s : State}
    (h : s.deposited.card = s.filament) :
    (run M p s).deposited.card = (run M p s).filament := by
  induction p generalizing s with
  | nil => exact h
  | cons i p ih => exact ih (step_filament_eq_card h)

/-- The clock never runs backwards. -/
theorem step_clock_mono (M : Machine) (i : Instr) (s : State) : s.clock ≤ (step M i s).clock := by
  unfold step
  split
  · exact le_rfl
  · cases i with
    | home => simp
    | setTemp t => simp only; split <;> simp
    | travel p => simp only; split_ifs <;> simp
    | extrude p => simp only; split <;> (simp; try omega)
    | dwell n => simp

theorem run_clock_mono (M : Machine) (p : List Instr) (s : State) :
    s.clock ≤ (run M p s).clock := by
  induction p generalizing s with
  | nil => exact le_rfl
  | cons i p ih => exact (step_clock_mono M i s).trans (ih (step M i s))

/-! ## The initial state satisfies the invariants -/

@[simp] theorem init_fault (a : ℤ) : (State.init a).fault = none := rfl
@[simp] theorem init_deposited (a : ℤ) : (State.init a).deposited = ∅ := rfl
@[simp] theorem init_filament (a : ℤ) : (State.init a).filament = 0 := rfl
@[simp] theorem init_clock (a : ℤ) : (State.init a).clock = 0 := rfl

theorem init_inEnvelope (M : Machine) (a : ℤ) : (State.init a).InEnvelope M := by
  intro v hv; simp [State.init] at hv

theorem init_noOverhang (a : ℤ) : (State.init a).NoOverhang := by
  intro v hv; simp [State.init] at hv

/-- **The part that comes off the bed is a real part.**  Whatever job is run
from cold, the material on the bed is inside the build volume, rests on the bed
or on itself, and weighs exactly what was fed in. -/
theorem print_is_sound (M : Machine) (a : ℤ) (p : List Instr) :
    (run M p (State.init a)).InEnvelope M ∧
    (run M p (State.init a)).NoOverhang ∧
    (run M p (State.init a)).deposited.card = (run M p (State.init a)).filament :=
  ⟨run_inEnvelope M p (init_inEnvelope M a), run_noOverhang M p (init_noOverhang a),
   run_filament_eq_card M p (by simp)⟩

end Printer
end LifeTrac
