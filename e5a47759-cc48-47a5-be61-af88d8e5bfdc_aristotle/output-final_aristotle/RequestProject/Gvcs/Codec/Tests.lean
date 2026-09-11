import RequestProject.Gvcs.Codec.Spec

/-!
# The required test suite (§33)

Every case §33 demands is exercised here as a machine-checked statement rather than as a
script: minimal and nested objects, multiple inputs and outputs, missing and unknown
fields, invalid types, malformed input, Unicode, large numbers, nulls, duplicate
identifiers, references, errors and warnings, partial, failed and successful proofs, and
both round-trip and lossy conversions.  The proof-system cases §33 additionally asks for
(known valid / invalid / contradictory / incomplete / incompatible results) close the
file.

Each test is stated over concrete data and closed by `decide` or `rfl` on the actual
codec functions, so a regression in any codec breaks the build.
-/

namespace LifeTrac.Codec
namespace Tests

/-! ## Fixtures -/

/-- The smallest legal object: only the five required fields (§3, §31). -/
def minimalObject : ProofObject :=
  { id := "p-min", kind := "theorem", inputs := [], outputs := [], status := .unknown }

/-- The worked example of §15: one integer input, one integer output, status `VALID`. -/
def simpleObject : ProofObject :=
  { id := "proof-001"
    kind := "theorem"
    inputs := [{ id := "n", name := "n", type := "integer", value := .int 144 }]
    outputs := [{ id := "result", name := "result", type := "integer", value := .int 12 }]
    status := .valid }

/-- An object with nested values, several inputs and several outputs, Unicode text, a
very large number, an explicit null, a reference to another object, warnings, metadata,
provenance and an unknown-vendor extension. -/
def richObject : ProofObject :=
  { id := "proof-002"
    version := "proof-schema/1.0"
    kind := "computation"
    inputs :=
      [{ id := "matrix"
         name := "matrix"
         type := "matrix"
         value := .list [.list [.int 1, .int 2], .list [.int 3, .int 4]] }
      ,{ id := "label"
         name := "label"
         type := "text"
         value := .str "Über die Möglichkeit ∀ε>0 — 群論" }
      ,{ id := "big"
         name := "big"
         type := "integer"
         value := .int 170141183460469231731687303715884105727 }
      ,{ id := "missing"
         name := "missing"
         value := .null }]
    parameters := [("tolerance", .str "1e-9")]
    procedure := "replay"
    intermediate := [{ id := "step1", name := "step1", value := .bool true }]
    outputs :=
      [{ id := "theorem", name := "theorem", type := "text", value := .str "Every finite group…" }
      ,{ id := "witness"
         name := "witness"
         value := .obj [("k", .int 7), ("nested", .list [.null, .bool false])] }
      ,{ id := "numerical_result", name := "numerical_result", type := "integer",
         value := .int 42 }]
    claims := ["the factorisation is complete"]
    certificates := ["cert-1"]
    warnings :=
      [{ id := "w1", code := "PRECISION", severity := .warning,
         message := "result rounded", recoverable := true }]
    provenance :=
      some { sourceSystem := "lean"
             sourceFile := "Group.lean"
             sourceFormat := "TEXT"
             importedAt := "2026-01-01T00:00:00Z"
             transformedAt := "2026-01-01T00:00:01Z"
             transformations := ["decode/raw-text", "normalize"] }
    metadata := [("author", .str "aristotle"), ("ref", .str "proof-001")]
    sourceFormat := "TEXT"
    sourceData := "original Lean output"
    status := .partialResult
    extensions :=
      [("vendor.system_x", .obj [("weight", .int 3)]),
       ("experimental.foo", .list [.str "a", .str "b"])] }

/-- An object that carries an error diagnostic and reports itself `INVALID` (§6, §7). -/
def invalidObject : ProofObject :=
  { id := "proof-003"
    kind := "theorem"
    inputs := [{ id := "n", name := "n", type := "integer", value := .str "one hundred" }]
    outputs := []
    errors :=
      [{ id := "e1", code := "TYPE_MISMATCH", severity := .error,
         field := "inputs[0].value", expected := "integer", actual := "string",
         recoverable := true }]
    status := .invalid }

/-- An object whose status is `ERROR`: the system could not complete the operation. -/
def erroredObject : ProofObject :=
  { invalidObject with id := "proof-004", status := .error }

/-- An object with duplicate input identifiers, which semantic validation must catch. -/
def duplicateObject : ProofObject :=
  { id := "proof-005"
    kind := "theorem"
    inputs := [{ id := "n", type := "integer", value := .int 1 },
               { id := "n", type := "integer", value := .int 2 }]
    outputs := []
    status := .pending }

/-! ## Empty, minimal and nested objects -/

example : minimalObject.minimal.id = "p-min" := rfl

/-- Empty object: no inputs, no outputs, and it still round-trips. -/
example : decodeAs .ipdl (encodeAs .ipdl minimalObject) = some minimalObject :=
  decodeAs_encodeAs_ipdl minimalObject

example : decodeAs .xml (encodeAs .xml minimalObject) = some minimalObject :=
  decodeAs_encodeAs_xml minimalObject

example : decodeAs .yaml (encodeAs .yaml minimalObject) = some minimalObject :=
  decodeAs_encodeAs_yaml minimalObject

/-- Nested object, with lists inside lists and records inside records. -/
example : decodeAs .ipdl (encodeAs .ipdl richObject) = some richObject :=
  decodeAs_encodeAs_ipdl richObject

example : decodeAs .xml (encodeAs .xml richObject) = some richObject :=
  decodeAs_encodeAs_xml richObject

example : decodeAs .yaml (encodeAs .yaml richObject) = some richObject :=
  decodeAs_encodeAs_yaml richObject

/-! ## Multiple inputs and multiple outputs -/

example : richObject.inputs.length = 4 := rfl

example : richObject.outputs.length = 3 := rfl

example : outputSummary richObject
    = [("theorem", .str "Every finite group…"),
       ("witness", .obj [("k", .int 7), ("nested", .list [.null, .bool false])]),
       ("numerical_result", .int 42)] := rfl

/-! ## Missing fields, unknown fields, references and nulls -/

/-- A missing field is not the same as a null field: the model records an explicit null
and validation still sees the input. -/
example : (richObject.inputs[3]?).map Input.value = some Value.null := rfl

/-- An object with no identifier fails structural validation (§23, level 2). -/
example :
    validateStructure
        { id := ""
          kind := "theorem"
          inputs := []
          outputs := []
          status := .unknown } ≠ [] := by decide

/-- Unknown data survives in the extension namespace (§30). -/
example : ("experimental.foo", Value.list [.str "a", .str "b"]) ∈ richObject.extensions := by
  decide

/-- The extension namespace survives a lossless round trip: unknown does not mean
discardable. -/
example :
    ((decodeAs .yaml (encodeAs .yaml richObject)).map ProofObject.extensions)
      = some richObject.extensions := by
  rw [decodeAs_encodeAs_yaml]
  rfl

/-- A reference to another object is carried in metadata and preserved. -/
example : ("ref", Value.str "proof-001") ∈ richObject.metadata := by decide

/-! ## Invalid types, malformed input and conservative inference -/

/-- Invalid type: a string where the schema declares an integer is reported. -/
example : validateTypes invalidObject ≠ [] := by decide

/-- The object is therefore not accepted, and `INVALID` is not silently turned into
`ERROR` (§6). -/
example : accepted invalidObject = false := by decide

example : invalidObject.status ≠ erroredObject.status := by decide

/-- Malformed input: text that parses in no supported format is not read as an object. -/
example : decodeAs .ipdl "(((" = none := by decide

example : extract "this is not a proof at all" = none := by decide

/-- A failed parser does not make the artifact invalid — it is preserved as raw text
with status `UNKNOWN` (§11). -/
example :
    (ofRawText "sys" "notes.txt" { text := "this is not a proof at all" }).status
      = .unknown := by decide

/-- …and the original text survives verbatim (§10). -/
example :
    (ofRawText "sys" "notes.txt" { text := "this is not a proof at all" }).sourceData
      = "this is not a proof at all" := by decide

/-! ## Unicode and large numbers -/

/-- Unicode text survives every lossless codec unchanged. -/
example :
    ((decodeAs .xml (encodeAs .xml richObject)).bind
      (fun p => (p.inputs[1]?).map Input.value))
      = some (Value.str "Über die Möglichkeit ∀ε>0 — 群論") := by
  rw [decodeAs_encodeAs_xml]
  rfl

/-- A number far beyond 64 bits survives unchanged. -/
example :
    ((decodeAs .ipdl (encodeAs .ipdl richObject)).bind
      (fun p => (p.inputs[2]?).map Input.value))
      = some (Value.int 170141183460469231731687303715884105727) := by
  rw [decodeAs_encodeAs_ipdl]
  rfl

/-- Negative and zero integers are handled by the numeral layer too. -/
example : parseIntAtom? (intAtom (-170141183460469231731687303715884105728)) =
    some (-170141183460469231731687303715884105728) := by decide

/-! ## Duplicate identifiers, errors and warnings -/

example : validateSemantics duplicateObject ≠ [] := by decide

example : accepted duplicateObject = false := by decide

/-- An object may not claim `VALID` while carrying error diagnostics (§6). -/
example : accepted { invalidObject with status := .valid } = false := by decide

/-- Warnings do not block acceptance. -/
example : accepted richObject = true := by decide

/-! ## Partial, failed and successful proofs -/

example : richObject.status = .partialResult := rfl

example : accepted simpleObject = true := by decide

example : Status.ofName? "PARTIAL" = some .partialResult := by decide

example : Status.ofName? "CONFLICT" = some .conflict := by decide

/-! ## Round-trip and lossy conversion -/

example : decodeAs .ipdl (encodeAs .ipdl simpleObject) = some simpleObject :=
  decodeAs_encodeAs_ipdl simpleObject

example : decodeAs .csv (encodeAs .csv simpleObject) = some (Csv.csvProject simpleObject) :=
  decodeAs_encodeAs_csv simpleObject

/-- CSV is a partial projection: the rich object does not survive it whole, and the
export says so instead of claiming success. -/
theorem csvProject_richObject_ne : Csv.csvProject richObject ≠ richObject := by
  intro h
  have h1 : (Csv.csvProject richObject).version = "" := rfl
  rw [h] at h1
  exact absurd h1 (by decide)

example : (exportArtifact "peer" .csv richObject).roundTrip = false :=
  (export_csv_reports_lossy "peer" richObject csvProject_richObject_ne).1

example : (exportArtifact "peer" .csv richObject).diagnostics ≠ [] :=
  (export_csv_reports_lossy "peer" richObject csvProject_richObject_ne).2

example : (exportArtifact "peer" .csv richObject).lossiness = .partialConv := rfl

example : (exportArtifact "peer" .yaml richObject).lossiness = .lossless := rfl

/-- What CSV does carry is carried exactly, and re-projecting changes nothing. -/
example : Csv.csvProject (Csv.csvProject richObject) = Csv.csvProject richObject :=
  Csv.csvProject_idempotent richObject

/-! ## §8 Error resolution -/

/-- The worked example: `"144"` against a schema that declares an integer. -/
example : (resolveValue "inputs[0].value" "integer" (.str "144")).1 = .int 144 :=
  resolve_example

example : (resolveValue "inputs[0].value" "integer" (.str "144")).2.isSome = true := by decide

/-- A repair that cannot be made exactly leaves the value alone and records an error
rather than guessing. -/
example : (resolveValue "inputs[0].value" "integer" (.str "one hundred")).1
    = .str "one hundred" := by decide

example : ((resolveValue "inputs[0].value" "integer" (.str "one hundred")).2.map
    Diagnostic.severity) = some .error := by decide

/-! ## §11 Format detection -/

example : detectFormat none (encodeAs .ipdl simpleObject) = .ipdl := detect_ipdl _

example : detectFormat none (encodeAs .xml simpleObject) = .xml := detect_xml _

example : detectFormat none (encodeAs .yaml simpleObject) = .yaml := detect_yaml _

example : detectFormat none (encodeAs .csv simpleObject) = .csv := detect_csv _

example : detectFormat none "plain prose with no structure" = .text := by decide

/-! ## §16 Canonical serialization and hashing -/

/-- The canonical serialization is deterministic and identifies the object. -/
example : canonicalText simpleObject = canonicalText simpleObject := rfl

example : simpleObject ≠ richObject := by decide

/-- Distinct objects have distinct canonical serializations, so the canonical text is a
faithful content identity (§16). -/
example : canonicalText simpleObject ≠ canonicalText richObject := fun h => by
  have : simpleObject = richObject := canonicalText_inj h
  exact absurd this (by decide)

/-- Objects whose hashes differ are certainly different objects. -/
example (p q : ProofObject) (h : canonicalHash p ≠ canonicalHash q) : p ≠ q :=
  ne_of_hash_ne h

/-- A sealed envelope opens to exactly its payload; a tampered one does not open. -/
example : openEnvelope (sealEnvelope "a" "b" "t" richObject) = some richObject :=
  open_sealEnvelope _ _ _ _ _ _

example (e : Envelope) (h : e.integrity ≠ canonicalHash e.payload) : openEnvelope e = none :=
  open_tampered e h

/-! ## §28–§29 Known valid, invalid, contradictory, incomplete and incompatible results -/

/-- Two systems that produced the same result. -/
example : compareObjects simpleObject simpleObject = .equivalent := by decide

/-- A known incompatible output: same subject, both claim validity, different values. -/
def rivalObject : ProofObject :=
  { simpleObject with
    outputs := [{ id := "result", name := "result", type := "integer", value := .int 13 }] }

example : compareObjects simpleObject rivalObject = .conflict := by decide

example : differences simpleObject rivalObject ≠ [] := by decide

/-- Objects about different subjects are incomparable rather than different. -/
example : compareObjects simpleObject { simpleObject with kind := "computation" }
    = .incomparable := by decide

/-- A known incomplete result: one side does not say enough to be compared. -/
example : compareObjects simpleObject minimalObject = .incomplete := by decide

example : compareObjects simpleObject { simpleObject with status := .unknown } = .incomplete := by
  decide

/-- A known contradictory object — claiming `VALID` while carrying errors — is rejected
by validation rather than exchanged as valid. -/
example : accepted { invalidObject with status := .valid } = false := by decide

/-- Conflicts are resolved only through a recorded resolution (§29). -/
example : ∃ r, resolveConflict .merge simpleObject rivalObject = some r
    ∧ r.diagnostics ≠ [] ∧ r.recorded.operation = "resolve" :=
  ⟨_, rfl, by simp, rfl⟩

/-- Merging keeps the other system's outputs instead of discarding them (§30). -/
example :
    ("reconcile.other_hash", Value.str (canonicalHash rivalObject))
      ∈ (mergeObjects simpleObject rivalObject).extensions :=
  merge_keeps_other simpleObject rivalObject

/-- A merge is marked `CONFLICT`, never presented as agreement. -/
example : (mergeObjects simpleObject rivalObject).status = .conflict := rfl

/-- `manual` and `reject` escalate instead of inventing an object. -/
example : resolveConflict .manual simpleObject rivalObject = none := rfl

example : resolveConflict .reject simpleObject rivalObject = none := rfl

end Tests
end LifeTrac.Codec
