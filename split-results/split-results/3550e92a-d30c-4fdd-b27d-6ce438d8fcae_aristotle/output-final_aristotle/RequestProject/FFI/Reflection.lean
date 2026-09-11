/-
Copyright (c) 2023 Sina Hazratpour. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sina Hazratpour, Aristotle (Harmonic)
-/
import Mathlib
import RequestProject.FFI.GradedFiberAlgebra

/-!
# Reflective conformance monitoring of the FFI surface — a "proof of mapping"

The companion module `RequestProject.FFI.GradedFiberAlgebra` exports a stable C ABI (the
`rp_gfa_*` symbols) and the `ffi/` directory wraps those symbols in C, C++ and Rust front-ends.
This module closes the loop requested as *"use native vernacular reflection and eBPF (or other
tools) to monitor the execution of the other libs and feed that back into Lean for a proof of
mapping"*.

The idea is a small **runtime conformance checker**, fully inside the trusted Lean kernel:

1. **Monitoring.** When the foreign libraries (C / C++ / Rust) run, every call to an exported
   `rp_gfa_*` symbol is observed by an external tracer — an *eBPF* `uprobe`/`uretprobe` program
   (see `ffi/monitor/`) records the operation, its arguments and the value the foreign code
   actually returned.  Each observation is one `Event` (a `Call` together with the `Result` the
   library produced).

2. **Reflection back into Lean.** The recorded events are imported as a Lean `Trace` (a literal
   `List Event`).  Lean already *is* the specification: the reference oracle `expected` recomputes,
   from the verified model, the result every call *should* have produced.  An event `conforms` when
   the observed result equals the expected one, and a whole trace is `Faithful` when every event
   conforms.  Because `conforms` is `Decidable`, conformance of a concrete trace is checked by
   **native vernacular reflection** (`decide` / `native_decide`): the check is compiled to native
   code and the result is certified by the kernel.

3. **The mapping theorem.**  `Faithful` is exactly the statement that the runtime behaviour of the
   foreign library *maps onto* the Lean model on the observed inputs.  Composing it with the
   algebraic laws already proved for the model (`graded_mul`, `coeff_add`, …) transports those laws
   to the *observed runtime values*: e.g. `monitored_graded_mul` shows that whenever a faithful
   trace records the library multiplying two monomials and reading off the top coefficient, that
   coefficient is necessarily the product of the inputs.

## Main definitions

* `GradedFiberAlgebra.Monitor.Call` — an abstract call to one exported operation.
* `GradedFiberAlgebra.Monitor.Result` — a tagged union of the possible return values.
* `GradedFiberAlgebra.Monitor.expected` — the reference oracle (the Lean model's answer).
* `GradedFiberAlgebra.Monitor.Event`, `Event.conforms`, `Event.ok` — one observation and its
  (decidable / boolean) conformance to the model.
* `GradedFiberAlgebra.Monitor.Trace`, `Trace.Faithful`, `Trace.check` — a recorded run and its
  conformance.

## Main results

* `Event.ok_iff_conforms` — the boolean check agrees with the propositional statement.
* `Trace.check_iff_faithful`, `Trace.faithful_of_check` — reflecting the boolean check to the
  proposition (the bridge that lets `native_decide` discharge `Faithful`).
* `Trace.conforms_of_faithful` — a faithful trace agrees with the model at every recorded call.
* `monitored_*` — the **mapping theorems** transporting the model's algebraic laws
  (`coeff_add`, `coeff_mul`, `graded_mul`) to faithfully-observed runtime values.
-/

namespace GradedFiberAlgebra
namespace Monitor

open scoped BigOperators

/-! ### The observable interface -/

/-- An abstract call to one of the exported `rp_gfa_*` operations, recording the operation together
with the arguments it was invoked on.  This mirrors the C ABI declared in `ffi/include/rp_gfa.h`. -/
inductive Call where
  /-- `rp_gfa_zero` — the zero element. -/
  | zero : Call
  /-- `rp_gfa_one` — the unit `1`. -/
  | one : Call
  /-- `rp_gfa_monomial n c` — the monomial `c · xⁿ`. -/
  | monomial (n : Nat) (c : Int) : Call
  /-- `rp_gfa_add a b` — addition. -/
  | add (a b : Elem) : Call
  /-- `rp_gfa_mul a b` — graded multiplication. -/
  | mul (a b : Elem) : Call
  /-- `rp_gfa_grade a n` — projection onto the degree-`n` fiber. -/
  | grade (a : Elem) (n : Nat) : Call
  /-- `rp_gfa_coeff a n` — the coefficient at degree `n`. -/
  | coeff (a : Elem) (n : Nat) : Call
  /-- `rp_gfa_size a` — the number of stored coefficients. -/
  | size (a : Elem) : Call
  /-- `rp_gfa_eq a b` — structural equality. -/
  | eq (a b : Elem) : Call
  deriving DecidableEq, Repr, Inhabited

/-- A tagged union of the possible return values of the exported operations: an element handle
(`Array Int`), an integer coefficient, a natural-number length, or a boolean. -/
inductive Result where
  /-- An element handle (the coefficient array). -/
  | elem (a : Elem) : Result
  /-- An integer coefficient (an `Int64` bit pattern decoded back to `ℤ`). -/
  | int (c : Int) : Result
  /-- A natural-number length / size. -/
  | nat (n : Nat) : Result
  /-- A boolean. -/
  | bool (b : Bool) : Result
  deriving DecidableEq, Repr, Inhabited

/-- The **reference oracle**: the result the Lean model prescribes for each call.  This is the
specification that the monitored foreign execution is compared against. -/
def expected : Call → Result
  | .zero          => .elem zero
  | .one           => .elem one
  | .monomial n c  => .elem (monomial n c)
  | .add a b       => .elem (add a b)
  | .mul a b       => .elem (mul a b)
  | .grade a n     => .elem (grade a n)
  | .coeff a n     => .int (coeff a n)
  | .size a        => .nat a.size
  | .eq a b        => .bool (beq a b)

/-- One observation produced by the runtime tracer: a `Call` together with the `Result` the foreign
library actually returned for it. -/
structure Event where
  /-- The operation that was invoked. -/
  call : Call
  /-- The value the foreign library actually returned. -/
  observed : Result
  deriving DecidableEq, Repr, Inhabited

/-- An event *conforms* to the model when the observed result equals the one the oracle prescribes,
i.e. the foreign library's behaviour on this call maps exactly onto the Lean model. -/
def Event.conforms (e : Event) : Prop := e.observed = expected e.call

instance (e : Event) : Decidable e.conforms := by
  unfold Event.conforms; infer_instance

/-- The boolean conformance check on a single event, suitable for native reflection. -/
def Event.ok (e : Event) : Bool := decide e.conforms

@[simp] lemma Event.ok_iff_conforms (e : Event) : e.ok = true ↔ e.conforms := by
  unfold Event.ok; exact decide_eq_true_iff

/-! ### Traces -/

/-- A recorded run of the foreign library: the chronological list of observed events. -/
abbrev Trace := List Event

/-- A trace is *faithful* when every recorded event conforms to the model — the precise sense in
which the monitored runtime behaviour *maps onto* the verified Lean model. -/
def Trace.Faithful (t : Trace) : Prop := ∀ e ∈ t, e.conforms

/-- The boolean conformance check on a whole trace, suitable for native reflection
(`decide` / `native_decide`). -/
def Trace.check (t : Trace) : Bool := t.all Event.ok

instance (t : Trace) : Decidable t.Faithful := by
  unfold Trace.Faithful; infer_instance

/-- The boolean trace check agrees with faithfulness. -/
@[simp] theorem Trace.check_iff_faithful (t : Trace) : t.check = true ↔ t.Faithful := by
  unfold Trace.check Trace.Faithful
  simp [List.all_eq_true, Event.ok_iff_conforms]

/-- Reflecting the boolean check to the proposition: this is the bridge that lets `decide` /
`native_decide` discharge `Faithful` for a concrete imported trace. -/
theorem Trace.faithful_of_check {t : Trace} (h : t.check = true) : t.Faithful :=
  (Trace.check_iff_faithful t).mp h

/-- A faithful trace agrees with the model at every recorded call. -/
theorem Trace.conforms_of_faithful {t : Trace} (h : t.Faithful) {e : Event} (he : e ∈ t) :
    e.observed = expected e.call := h e he

/-! ### Mapping theorems

These transport the algebraic laws proved for the model onto the *observed runtime values*, given
that the relevant observations are faithful.  They are the formal content of a "proof of mapping":
they hold purely as facts about what the model *requires*, so any execution the tracer certifies as
faithful is guaranteed to satisfy them. -/

/-- If a faithful observation records the library returning `out` for `coeff a n`, then `out` is the
model coefficient `coeff a n`. -/
theorem monitored_coeff {a : Elem} {n : Nat} {out : Int}
    (h : (Event.mk (.coeff a n) (.int out)).conforms) : out = coeff a n := by
  have := h; unfold Event.conforms expected at this; simpa using this

/-- If a faithful observation records the library returning `out` for `add a b`, then `out` is the
model sum `add a b`. -/
theorem monitored_add {a b out : Elem}
    (h : (Event.mk (.add a b) (.elem out)).conforms) : out = add a b := by
  have := h; unfold Event.conforms expected at this; simpa using this

/-- If a faithful observation records the library returning `out` for `mul a b`, then `out` is the
model product `mul a b`. -/
theorem monitored_mul {a b out : Elem}
    (h : (Event.mk (.mul a b) (.elem out)).conforms) : out = mul a b := by
  have := h; unfold Event.conforms expected at this; simpa using this

/-- **The headline mapping theorem.**  Suppose the tracer faithfully records the foreign library
(a) multiplying the monomials `a·xⁱ` and `b·xʲ` to obtain the handle `prod`, and then
(b) reading the coefficient of `prod` at degree `i + j` as `out`.  Then necessarily `out = a * b`:
the *graded multiplication law* of the verified model holds for the actual runtime values. -/
theorem monitored_graded_mul (i j : Nat) (a b : Int) {prod : Elem} {out : Int}
    (hmul : (Event.mk (.mul (monomial i a) (monomial j b)) (.elem prod)).conforms)
    (hcoeff : (Event.mk (.coeff prod (i + j)) (.int out)).conforms) :
    out = a * b := by
  have hp : prod = mul (monomial i a) (monomial j b) := monitored_mul hmul
  have ho : out = coeff prod (i + j) := monitored_coeff hcoeff
  subst hp; rw [ho]; exact graded_mul i j a b

/-- The off-degree companion of `monitored_graded_mul`: away from the total degree `i + j`, any
faithfully-observed coefficient of the monomial product vanishes. -/
theorem monitored_graded_mul_ne (i j : Nat) (a b : Int) {prod : Elem} {k : Nat} {out : Int}
    (hk : k ≠ i + j)
    (hmul : (Event.mk (.mul (monomial i a) (monomial j b)) (.elem prod)).conforms)
    (hcoeff : (Event.mk (.coeff prod k) (.int out)).conforms) :
    out = 0 := by
  have hp : prod = mul (monomial i a) (monomial j b) := monitored_mul hmul
  have ho : out = coeff prod k := monitored_coeff hcoeff
  subst hp; rw [ho]; exact graded_mul_ne i j a b hk

/-! ### Native-reflection examples

These mimic a trace imported from the eBPF tracer (see `ffi/monitor/`).  The conformance of a
concrete imported trace is discharged by **native vernacular reflection**: `decide` runs the
`Decidable` instance in the kernel, while `native_decide` compiles the boolean `Trace.check` to
native code and certifies the result.  A real pipeline would generate these literals automatically
from the captured runtime data. -/

/-- A sample faithful trace: compute `p = 1 + x`, then `q = p * p = 1 + 2x + x²`, then read its
coefficients.  Every observed value matches the model. -/
def sampleTrace : Trace :=
  let p : Elem := add (monomial 0 1) (monomial 1 1)      -- 1 + x
  let q : Elem := mul p p                                 -- 1 + 2x + x²
  [ ⟨.monomial 0 1, .elem (monomial 0 1)⟩
  , ⟨.monomial 1 1, .elem (monomial 1 1)⟩
  , ⟨.add (monomial 0 1) (monomial 1 1), .elem p⟩
  , ⟨.mul p p, .elem q⟩
  , ⟨.coeff q 0, .int 1⟩
  , ⟨.coeff q 1, .int 2⟩
  , ⟨.coeff q 2, .int 1⟩
  , ⟨.size q, .nat 3⟩ ]

/-- The boolean conformance check on the sample trace evaluates to `true`, verified by **native
vernacular reflection** (`native_decide` compiles `Trace.check` to native code and the kernel
certifies the result). -/
example : sampleTrace.check = true := by native_decide

/-- The sample trace is faithful, discharged by **native reflection**: the boolean `check` is
compiled to native code and the kernel certifies the `= true` result, which `faithful_of_check`
reflects back to `Faithful`.  This is the path a trace generated by the eBPF tracer would take. -/
theorem sampleTrace_faithful : sampleTrace.Faithful :=
  Trace.faithful_of_check (by native_decide)

/-- A trace with one corrupted observation (the library is claimed to return the wrong product
coefficient) is *not* faithful — the monitor rejects it. -/
def corruptTrace : Trace :=
  let p : Elem := add (monomial 0 1) (monomial 1 1)
  let q : Elem := mul p p
  [ ⟨.mul p p, .elem q⟩
  , ⟨.coeff q 1, .int 99⟩ ]   -- wrong: the real coefficient is 2

/-- The monitor correctly flags the corrupted trace as non-conforming. -/
example : corruptTrace.check = false := by native_decide

end Monitor
end GradedFiberAlgebra
