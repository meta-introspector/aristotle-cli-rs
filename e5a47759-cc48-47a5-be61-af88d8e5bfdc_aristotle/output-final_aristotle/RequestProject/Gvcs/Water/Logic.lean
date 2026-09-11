import RequestProject.Gvcs.Steampunk.Fluidic

/-!
# Water logic: a sequential computer with water for a signal

`RequestProject/Steampunk/Fluidic.lean` shows that any *combinational* control
law is the steady state of a network of pilot-operated valves.  A 3D printer
needs more than that: it needs state — a program counter, a position register,
a comparison latch.  This file supplies it, in the cheapest medium there is.

The element is a **water NAND**: a tube fed from a head tank, with two pilot
diaphragms; when both pilots carry water the spool shifts and the outlet is
dumped to the low pond.  Signals are water, the supply is head, the "ground" is
the pond, and the only thing spent is head — the water itself is recovered
(`Water/Solar.lean` lifts it back with the sun).

* `WMachine n s` — `s` latch cells, each fed by a water network of the `n`
  input lines together with the current contents of all `s` cells.  A latch
  cell is a pair of tipping buckets: it holds what it was filled with for one
  beat of the siphon clock, which is what makes the loop well defined.
* `water_machine_complete` — **every** finite-state transition law is such a
  machine: for any `f : inputs → state → state` there is a `WMachine` whose
  beat is exactly `f`, using fewer than `s · 4 · 2^(n+s)` valves.
* `water_machine_runs` — and running the machine on a list of inputs is
  running `f` on that list, so the abstract controller and the plumbing agree
  on every trace, not just on one step.
* `waterGateParts_semiconductor_free`, `waterComputer_no_fuel` — a gate is
  glass, hardwood, leather, graphite, bronze and stone; nothing is fabbed and
  nothing is burned.
-/

namespace LifeTrac
namespace Water

open Steampunk
open Steampunk.FCirc

/-! ## Machines -/

/-- A clocked water machine: `n` input lines, `s` latch cells.  `next i` is the
plumbing that fills cell `i` on the next beat, read off the input lines
(`Fin.castAdd`) and the present contents of the cells (`Fin.natAdd`); `init` is
what the cells hold when the clock is started. -/
structure WMachine (n s : ℕ) where
  /-- The network feeding latch cell `i` on the next beat. -/
  next : Fin s → FCirc (n + s)
  /-- The contents of the cells at start-up. -/
  init : Fin s → Bool

namespace WMachine

variable {n s : ℕ}

/-- One beat of the siphon clock: every cell is refilled from its network. -/
def step (M : WMachine n s) (q : Fin s → Bool) (x : Fin n → Bool) : Fin s → Bool :=
  fun i => (M.next i).eval (Fin.append x q)

/-- Run the machine from state `q` on a list of input readings, one per beat. -/
def runFrom (M : WMachine n s) (q : Fin s → Bool) : List (Fin n → Bool) → Fin s → Bool
  | [] => q
  | x :: xs => M.runFrom (M.step q x) xs

/-- Run the machine from start-up. -/
def run (M : WMachine n s) (xs : List (Fin n → Bool)) : Fin s → Bool :=
  M.runFrom M.init xs

/-- Total valve count of the machine: all `s` networks together. -/
def valves (M : WMachine n s) : ℕ :=
  (List.ofFn (fun i => (M.next i).valves)).sum

end WMachine

/-- The abstract controller: iterate a transition law over a list of readings. -/
def iterate {n s : ℕ} (f : (Fin n → Bool) → (Fin s → Bool) → (Fin s → Bool))
    (q : Fin s → Bool) : List (Fin n → Bool) → Fin s → Bool
  | [] => q
  | x :: xs => iterate f (f x q) xs

/-! ## Completeness -/

/-- Splitting a joint reading of inputs and cells back apart. -/
theorem append_castAdd {n s : ℕ} (x : Fin n → Bool) (q : Fin s → Bool) :
    (fun i : Fin n => Fin.append x q (Fin.castAdd s i)) = x := by
  funext i; simp

theorem append_natAdd {n s : ℕ} (x : Fin n → Bool) (q : Fin s → Bool) :
    (fun i : Fin s => Fin.append x q (Fin.natAdd n i)) = q := by
  funext i; simp

/-- **Every finite-state control law is plumbing.**  For any transition
function `f` on `s` latch cells driven by `n` input lines, and any start-up
state, there is a water machine whose beat is exactly `f`, built from fewer
than `s · 4 · 2^(n+s)` valves. -/
theorem water_machine_complete (n s : ℕ)
    (f : (Fin n → Bool) → (Fin s → Bool) → (Fin s → Bool)) (q0 : Fin s → Bool) :
    ∃ M : WMachine n s, M.init = q0 ∧ (∀ q x, M.step q x = f x q) ∧
      M.valves ≤ s * (4 * 2 ^ (n + s)) := by
  classical
  have hchoice : ∀ i : Fin s, ∃ c : FCirc (n + s),
      (∀ y, c.eval y = f (fun j => y (Fin.castAdd s j)) (fun j => y (Fin.natAdd n j)) i) ∧
        c.valves + 4 ≤ 4 * 2 ^ (n + s) := by
    intro i
    exact fluidic_complete_valves (n + s)
      (fun y => f (fun j => y (Fin.castAdd s j)) (fun j => y (Fin.natAdd n j)) i)
  choose c hc hv using hchoice
  refine ⟨⟨c, q0⟩, rfl, ?_, ?_⟩
  · intro q x
    funext i
    show (c i).eval (Fin.append x q) = f x q i
    rw [hc i, append_castAdd, append_natAdd]
  · have hle : ∀ i : Fin s, (c i).valves ≤ 4 * 2 ^ (n + s) := fun i => by
      have := hv i; omega
    have hsum : (List.ofFn (fun i : Fin s => (c i).valves)).sum ≤ s * (4 * 2 ^ (n + s)) := by
      have hlen : (List.ofFn (fun i : Fin s => (c i).valves)).length = s := by simp
      calc (List.ofFn (fun i : Fin s => (c i).valves)).sum
          ≤ (List.ofFn (fun i : Fin s => (c i).valves)).length * (4 * 2 ^ (n + s)) := by
            refine List.sum_le_card_nsmul _ _ ?_
            intro y hy
            obtain ⟨i, hi⟩ := List.mem_ofFn.mp hy
            exact hi ▸ hle i
        _ = s * (4 * 2 ^ (n + s)) := by rw [hlen]
    simpa [WMachine.valves] using hsum

/-- A machine whose beat is `f` runs `f`, beat for beat, on every trace. -/
theorem water_machine_runs {n s : ℕ} (M : WMachine n s)
    (f : (Fin n → Bool) → (Fin s → Bool) → (Fin s → Bool))
    (hstep : ∀ q x, M.step q x = f x q) (q : Fin s → Bool) (xs : List (Fin n → Bool)) :
    M.runFrom q xs = iterate f q xs := by
  induction xs generalizing q with
  | nil => rfl
  | cons x xs ih => simp [WMachine.runFrom, iterate, hstep, ih]

/-- **The controller, in water.**  Any finite-state control law, run on any
trace of sensor readings, is reproduced exactly by a water machine of bounded
size. -/
theorem water_computes_any_controller (n s : ℕ)
    (f : (Fin n → Bool) → (Fin s → Bool) → (Fin s → Bool)) (q0 : Fin s → Bool) :
    ∃ M : WMachine n s, M.valves ≤ s * (4 * 2 ^ (n + s)) ∧
      ∀ xs, M.run xs = iterate f q0 xs := by
  obtain ⟨M, hinit, hstep, hv⟩ := water_machine_complete n s f q0
  refine ⟨M, hv, fun xs => ?_⟩
  rw [WMachine.run, hinit, water_machine_runs M f hstep]

/-! ## What a water gate is made of -/

/-- The parts of one water NAND: a glass body with two diaphragm pilots, a
bronze spool weighted with stone, seated on graphite, on a hardwood block. -/
def waterGateParts : List Part :=
  [ ⟨"glass tube body", .glass, 1⟩
  , ⟨"bronze spool", .bronze, 1⟩
  , ⟨"stone counterweight", .stone, 1⟩
  , ⟨"pilot diaphragm", .leather, 2⟩
  , ⟨"graphite seat", .graphite, 2⟩
  , ⟨"hardwood block", .hardwood, 1⟩
  , ⟨"leather return strap", .leather, 1⟩ ]

/-- **No silicon in a water gate.** -/
theorem waterGateParts_semiconductor_free :
    ∀ p ∈ waterGateParts, p.mat.semiconductor = false := by decide

/-- A water NAND is nine pieces. -/
theorem waterGateParts_qty : (waterGateParts.map Part.qty).sum = 9 := by decide

/-- Nothing in a water gate has to be cast or forged: no part of it is steel or
cast iron, so a village with a glassblower and a woodshop can make one. -/
theorem waterGateParts_no_foundry :
    ∀ p ∈ waterGateParts, p.mat ≠ Material.steel ∧ p.mat ≠ Material.castIron := by decide

/-- What the machine consumes while it computes. -/
inductive Consumable where
  /-- Water, which comes back down to the pond. -/
  | water
  /-- Sunlight, which lifts it again. -/
  | sunlight
  /-- Anything burned. -/
  | fuel
  deriving DecidableEq, Repr

/-- The running consumables of a water computer. -/
def waterComputerConsumes : List Consumable := [.water, .sunlight]

/-- **Nothing is burned.**  A water computer's running inputs are water and
sunlight, and it recovers the water. -/
theorem waterComputer_no_fuel : Consumable.fuel ∉ waterComputerConsumes := by decide

/-- Parts in a whole water machine, gate by gate. -/
def gateParts {n s : ℕ} (M : WMachine n s) : ℕ :=
  M.valves * (waterGateParts.map Part.qty).sum

end Water
end LifeTrac
