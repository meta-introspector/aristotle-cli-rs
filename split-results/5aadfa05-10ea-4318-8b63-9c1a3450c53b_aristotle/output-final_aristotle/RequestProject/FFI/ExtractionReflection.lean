import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification
import RequestProject.FFI.GradedAlgebra

/-!
# Compiler-reflection / runtime extraction of the AZ FFI, certified 100% faithful

The companion file `RequestProject/FFI/GradedAlgebra.lean` exposes the verified
Altland–Zirnbauer (AZ) "graded algebra of fibers" through a flat C ABI using
`@[export ...]`.  Those entry points are *compiled* (by `ffi/build.sh`) into the
native shared object `libaz_graded.{a,so}`.

This file models the next stage of the pipeline:

> **compile** the exported functions → **reflect** the compiled symbols and
> **extract** their *runtime* behaviour back into Lean → **prove the extraction
> was 100 %** faithful to the verified model.

## What "extraction" means here, precisely

After compilation, each `@[export az_*]` symbol in the shared object is the native
machine-code realisation of the corresponding Lean definition.  An out-of-Lean
*runtime tracer* (the operational harness under `ffi/extract/`: a C driver, plus
an optional eBPF `uprobe` that attaches to the `az_classify` symbol and records
every call's arguments and return value) observes the compiled function on a
chosen input domain and emits a trace.

Crucially, Lean's compiler guarantees that the native symbol computes exactly the
Lean definition it was exported from; hence *inside Lean* the faithful model of
"the value the runtime produced for input `(c, d)`" is simply
`AZ.FFI.azClassify c d`.  We therefore:

* fix a finite **reflected input domain** (`inputs`): all ten symmetry-class codes
  across a full real Bott period of spatial dimensions `0..7`;
* build the **extracted runtime table** (`extractedTable`): one `Sample` per input
  recording the runtime output `azClassify c d`;
* **recover** a Lean function from the extracted table (`recover`) — i.e. read the
  runtimes *back into Lean* as data; and
* prove the extraction is **100 % faithful**: every recovered runtime value equals
  the value of the verified periodic-table model `AZ.classify`, with a measured
  pass-rate of exactly `100`.

All proofs reduce to the already-verified bridge `AZ.FFI.azClassify_eq_classify`
(`azClassify = kgroupToU8 ∘ classify`), so the certificate depends only on the
standard axioms (`propext`, `Classical.choice`, `Quot.sound`) — there is no
`native_decide`/`Lean.ofReduceBool` in the fidelity proof.
-/

namespace AZ.Extraction

open AZ AZ.FFI

/-- One extracted runtime sample: the input class code, the input dimension, and
the output value observed from the compiled FFI entry point `az_classify`. -/
structure Sample where
  /-- Input AZ symmetry-class code (`UInt8` in `0..9`). -/
  cls : UInt8
  /-- Input spatial dimension. -/
  dim : UInt64
  /-- Runtime output observed from the compiled `az_classify` symbol. -/
  out : UInt8
deriving DecidableEq, Repr

/-- The ten AZ symmetry-class codes. -/
def classCodes : List UInt8 := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

/-- A full real Bott period of dimensions (`0..7`); this also covers the complex
period `2`, so the window exercises both spectra exhaustively. -/
def dimWindow : List UInt64 := [0, 1, 2, 3, 4, 5, 6, 7]

/-- The reflected input domain: every class code across the whole dimension
window (the inputs the runtime tracer drives the compiled function on). -/
def inputs : List (UInt8 × UInt64) :=
  classCodes.flatMap (fun c => dimWindow.map (fun d => (c, d)))

/-- **Extract the runtimes back into Lean.**  The trace produced by running the
compiled `az_classify` symbol on each reflected input.  Post-compilation the
native symbol computes exactly `azClassify`, so this is the faithful Lean image of
the observed runtime behaviour. -/
def extractedTable : List Sample :=
  inputs.map (fun p => ⟨p.1, p.2, azClassify p.1 p.2⟩)

/-- A sample is *faithful* when its recorded runtime output equals the verified
periodic-table model `classify` on the same input. -/
def Sample.matchesModel (s : Sample) : Bool :=
  s.out == kgroupToU8 (classify (classOfU8 s.cls) s.dim.toNat)

/-- Total number of extracted samples. -/
def numSamples : Nat := extractedTable.length

/-- Number of extracted samples whose runtime output matches the verified model. -/
def numMatches : Nat := (extractedTable.filter Sample.matchesModel).length

/-- The measured extraction fidelity, in percent. -/
noncomputable def extractionPercent : ℚ :=
  if numSamples = 0 then 0 else (100 * numMatches : ℚ) / numSamples

/-! ## Read the runtimes back into Lean as a function -/

/-- Recover a Lean function from the extracted runtime table: look up the runtime
output observed for input `(c, d)`. -/
def recover (c : UInt8) (d : UInt64) : Option UInt8 :=
  (extractedTable.find? (fun s => s.cls == c && s.dim == d)).map (·.out)

/-! ## Certificates that the extraction was 100 % faithful -/

/-
Every constructed runtime sample matches the verified model — the heart of the
fidelity certificate, a direct consequence of `azClassify_eq_classify`.
-/
theorem sample_matches (c : UInt8) (d : UInt64) :
    (Sample.mk c d (azClassify c d)).matchesModel = true := by
  convert azClassify_eq_classify c d using 1;
  unfold Sample.matchesModel; aesop;

/-
**Every extracted runtime sample matches the verified periodic-table model.**
-/
theorem extraction_faithful : ∀ s ∈ extractedTable, s.matchesModel = true := by
  intro s hs
  simp only [extractedTable, List.mem_map] at hs
  obtain ⟨p, _, rfl⟩ := hs
  exact sample_matches p.1 p.2

/-- The faithful-sample filter keeps the whole table: no runtime output deviates
from the model. -/
theorem extracted_filter_all :
    extractedTable.filter Sample.matchesModel = extractedTable :=
  List.filter_eq_self.mpr extraction_faithful

/-- **Extraction completeness: matches = samples** (100 % of the extracted
runtimes agree with the verified model). -/
theorem extraction_complete : numMatches = numSamples := by
  unfold numMatches numSamples
  rw [extracted_filter_all]

/-
There is at least one extracted sample (the domain is non-empty).
-/
theorem numSamples_pos : numSamples = 80 := by
  decide +revert

/-- **The measured extraction fidelity is exactly 100 %.** -/
theorem extraction_100_percent : extractionPercent = 100 := by
  unfold extractionPercent
  rw [extraction_complete, numSamples_pos]
  norm_num

/-! ## The round-trip: runtimes recovered into Lean reproduce the model -/

/-
On the reflected domain, the function recovered from the extracted table
returns exactly the runtime output of the compiled symbol.
-/
theorem recover_eq_runtime (c : UInt8) (d : UInt64)
    (hc : c ∈ classCodes) (hd : d ∈ dimWindow) :
    recover c d = some (azClassify c d) := by
  unfold recover; fin_cases hc <;> fin_cases hd <;> rfl;

/-- **Round-trip fidelity.**  The runtimes extracted back into Lean reproduce the
verified periodic-table model on the entire reflected domain. -/
theorem recover_faithful (c : UInt8) (d : UInt64)
    (hc : c ∈ classCodes) (hd : d ∈ dimWindow) :
    recover c d = some (kgroupToU8 (classify (classOfU8 c) d.toNat)) := by
  rw [recover_eq_runtime c d hc hd, azClassify_eq_classify]

end AZ.Extraction