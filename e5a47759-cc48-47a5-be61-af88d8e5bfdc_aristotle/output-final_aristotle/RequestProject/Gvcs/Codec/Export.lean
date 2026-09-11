import RequestProject.Gvcs.Codec.Spec

/-!
# The reference implementation's artifacts

§34 asks a reference implementation to lay itself out as `codec/` with `schema/`,
`codecs/`, `canonical/`, `reconcile/`, `provenance/` and `tests/`.  This module produces
the contents of that directory: the schema documents, one worked proof object written by
every codec in the library, its canonical serialization and hash, a reconciliation of two
systems that disagree, the provenance and transformation ledger of the exchange, and the
import/export reports.

Everything here is computed by the very functions the theorems are about, so the files in
`codec/` are output of the verified codec rather than prose describing it.
`lake exe codec [dir]` writes them.
-/

namespace LifeTrac.Codec
namespace Export

/-! ## The worked example -/

/-- The proof object of §15, used as the worked example throughout the artifacts. -/
def sample : ProofObject :=
  { id := "proof-001"
    version := "proof-schema/1.0"
    kind := "theorem"
    inputs :=
      [{ id := "n"
         name := "n"
         type := "integer"
         value := .int 144
         units := "dimensionless"
         constraints := ["n > 0"] }]
    assumptions := ["arithmetic in the natural numbers"]
    parameters := [("method", .str "trial-division")]
    procedure := "factor n and take the largest square divisor"
    intermediate := [{ id := "factors", name := "factors", type := "list",
                       value := .list [.int 2, .int 2, .int 2, .int 2, .int 3, .int 3] }]
    outputs :=
      [{ id := "result"
         name := "result"
         type := "integer"
         value := .int 12
         claims := ["12 * 12 = 144"]
         certificate := some "cert-001" }]
    claims := ["144 is a perfect square"]
    certificates := ["cert-001"]
    warnings := []
    provenance :=
      some { sourceSystem := "lean"
             sourceFile := "Square.lean"
             sourceFormat := "TEXT"
             importedAt := "2026-01-01T00:00:00Z"
             transformedAt := "2026-01-01T00:00:01Z"
             transformations := ["decode/raw-text", "normalize"] }
    metadata := [("author", .str "aristotle"), ("schema", .str "proof-schema/1.0")]
    sourceFormat := "TEXT"
    sourceData := "n = 144, sqrt n = 12"
    status := .valid
    extensions := [("vendor.system_x", .obj [("confidence", .int 100)])] }

/-- A second system's answer to the same question: same subject, different output. -/
def rival : ProofObject :=
  { sample with
    outputs :=
      [{ id := "result", name := "result", type := "integer", value := .int 13,
         claims := ["13 * 13 = 144"] }]
    extensions := [("vendor.system_y", .obj [("confidence", .int 60)])] }

/-! ## Small renderers for the report artifacts -/

/-- Render a lossiness level. -/
def lossinessName (l : Lossiness) : String := l.toName

/-- Render one diagnostic as a YAML block item. -/
def diagnosticYaml (d : Diagnostic) : String :=
  "  - id: " ++ d.id ++ "\n" ++
  "    code: " ++ d.code ++ "\n" ++
  "    severity: " ++ d.severity.toName ++ "\n" ++
  "    field: " ++ d.field ++ "\n" ++
  "    expected: " ++ d.expected ++ "\n" ++
  "    actual: " ++ d.actual ++ "\n" ++
  "    resolution: " ++ d.resolution ++ "\n" ++
  "    recoverable: " ++ (if d.recoverable then "true" else "false") ++ "\n" ++
  "    message: " ++ d.message ++ "\n"

/-- Render one ledger entry as a YAML block item (§21). -/
def transformationYaml (t : Transformation) : String :=
  "  - id: " ++ t.id ++ "\n" ++
  "    operation: " ++ t.operation ++ "\n" ++
  "    source: " ++ t.source ++ "\n" ++
  "    destination: " ++ t.destination ++ "\n" ++
  "    codec: " ++ t.codec ++ "\n" ++
  "    codec_version: " ++ t.codecVersion ++ "\n" ++
  "    input_hash: " ++ t.inputHash ++ "\n" ++
  "    output_hash: " ++ t.outputHash ++ "\n" ++
  "    lossiness: " ++ t.lossiness.toName ++ "\n"

/-- Render one structured difference (§28). -/
def differenceYaml (d : Difference) : String :=
  "  - path: " ++ d.path ++ "\n" ++
  "    left: " ++ d.left ++ "\n" ++
  "    right: " ++ d.right ++ "\n" ++
  "    type: " ++ d.type ++ "\n" ++
  "    severity: " ++ d.severity.toName ++ "\n" ++
  "    explanation: " ++ d.explanation ++ "\n"

/-- Render provenance (§20). -/
def provenanceYaml (p : Provenance) : String :=
  "source_system: " ++ p.sourceSystem ++ "\n" ++
  "source_file: " ++ p.sourceFile ++ "\n" ++
  "source_format: " ++ p.sourceFormat ++ "\n" ++
  "imported_at: " ++ p.importedAt ++ "\n" ++
  "transformed_at: " ++ p.transformedAt ++ "\n" ++
  "transformations:\n" ++
  String.join (p.transformations.map (fun t => "  - " ++ t ++ "\n"))

/-! ## `schema/` -/

/-- `codec/schema/proof.yaml`. -/
def schemaProof : String :=
"# proof-schema/1.0 — the canonical proof object (§3)
#
# Realised in Lean as LifeTrac.Codec.ProofObject
# (RequestProject/Codec/Model.lean).  Required fields have no default; every
# other field may be omitted.

schema: proof-schema/1.0

required:
  - id        # string, stable identifier
  - kind      # string, e.g. theorem | computation | certificate
  - inputs    # list of input, see input.yaml
  - outputs   # list of output, see output.yaml
  - status    # UNKNOWN | PENDING | VALID | INVALID | PARTIAL | ERROR | CONFLICT | UNSUPPORTED

optional:
  version: string
  assumptions: [string]
  parameters: [{name: string, value: value}]
  procedure: string
  intermediate: [output]
  claims: [string]
  certificates: [string]
  errors: [error]        # see error.yaml
  warnings: [error]
  provenance: provenance
  metadata: [{name: string, value: value}]
  source_format: string  # the format the object was decoded from
  source_data: string    # the original bytes/text, preserved verbatim (§35)
  extensions: [{name: string, value: value}]  # unknown data survives here (§30)

value:
  # the canonical value language: str | int | bool | null | list | obj
  # ordering inside list and obj is semantic and is preserved (§16)
"

/-- `codec/schema/input.yaml`. -/
def schemaInput : String :=
"# Input (§4) — LifeTrac.Codec.Input

required:
  - id

optional:
  name: string
  type: string        # integer | text | matrix | ...
  value: value
  encoding: string
  units: string
  constraints: [string]
  provenance: provenance
"

/-- `codec/schema/output.yaml`. -/
def schemaOutput : String :=
"# Output (§5) — LifeTrac.Codec.Output

required:
  - id

optional:
  name: string
  type: string
  value: value
  encoding: string
  claims: [string]
  certificate: string
  provenance: provenance
"

/-- `codec/schema/error.yaml`. -/
def schemaError : String :=
"# Error / diagnostic (§7) — LifeTrac.Codec.Diagnostic
#
# Errors are first-class exchange objects: they travel with the object rather
# than being discarded (§8, §35).

required:
  - id
  - code

optional:
  severity: INFO | WARNING | ERROR | FATAL
  message: string
  location: string
  field: string
  object_id: string
  source_system: string
  source_format: string
  expected: string
  actual: string
  cause: string
  resolution: string
  recoverable: bool

# Status vocabulary reminder (§6): INVALID != ERROR.
#   ERROR    system could not complete or interpret the operation
#   INVALID  operation completed and the result failed validation
#   CONFLICT several systems produced incompatible results
#   UNKNOWN  insufficient information to determine validity
"

/-- `codec/schema/envelope.yaml`. -/
def schemaEnvelope : String :=
"# Exchange envelope (§19) — LifeTrac.Codec.Envelope

schema_version: proof-schema/1.0
codec_version: proof-codec/1.0

fields:
  source: string
  destination: string
  timestamp: string
  object_id: string
  payload: proof            # the canonical object
  diagnostics: [error]
  transformations: [transformation]   # the ledger of §21
  integrity: string         # canonical hash of the payload

# openEnvelope checks `integrity` against the hash of the payload it carries and
# refuses the envelope when they disagree (LifeTrac.Codec.open_tampered).
"

/-! ## `codecs/` — the worked example in every format -/

/-- The example written as IPDL (§12). -/
def sampleIpdl : String := encodeAs .ipdl sample

/-- The example written as XML (§13). -/
def sampleXml : String := encodeAs .xml sample

/-- The example written as CSV (§14) — a partial projection. -/
def sampleCsv : String := encodeAs .csv sample

/-- The example written as YAML (§15). -/
def sampleYaml : String := encodeAs .yaml sample

/-- The example written as raw text (§10). -/
def sampleText : String := encodeAs .text sample

/-- `codec/codecs/README.md`. -/
def codecsReadme : String :=
"# codecs/

One worked proof object (`proof-001`, the example of §15) written by every codec
in the library.  Each file is the output of `LifeTrac.Codec.encodeAs`, and each
can be read back by `LifeTrac.Codec.decodeAs`.

| file | codec | Lean module | preservation (§9) |
| --- | --- | --- | --- |
| `ipdl/proof-001.ipdl` | IPDL (§12) | `RequestProject/Codec/Ipdl.lean` | LOSSLESS |
| `xml/proof-001.xml` | XML (§13) | `RequestProject/Codec/Xml.lean` | LOSSLESS |
| `csv/proof-001.csv` | CSV (§14) | `RequestProject/Codec/Csv.lean` | PARTIAL |
| `yaml/proof-001.yaml` | YAML (§15) | `RequestProject/Codec/Yaml.lean` | LOSSLESS |
| `text/proof-001.txt` | raw text (§10) | `RequestProject/Codec/Text.lean` | PARTIAL |

`LifeTrac.Codec.codec_roundTrip` proves, for every one of these codecs, that
decoding what it encoded returns exactly the projection the table declares; the
CSV file is the tabular projection `Csv.csvProject`, and the export of a richer
object through CSV reports the conversion as lossy instead of claiming success
(`export_csv_reports_lossy`).
"

/-! ## `canonical/` -/

/-- The canonical serialization of the example (§16). -/
def sampleCanonical : String := canonicalText sample

/-- Its content hash (§16). -/
def sampleHash : String := canonicalHash sample

/-- `codec/canonical/README.md`. -/
def canonicalReadme : String :=
"# canonical/

* `proof-001.canonical` — the deterministic serialization of the worked example.
  Field order, identifiers, numerals and escaping are fixed, so the same object
  always produces the same bytes.
* `proof-001.hash` — the FNV-1a hash of that serialization: the content identity
  used by envelopes and by the transformation ledger.

The parser, serializer, validator and hasher §34 asks for are, respectively,
`ProofObject.ofDoc` / `ofCanonicalText`, `ProofObject.toDoc` / `canonicalText`,
`validate` (RequestProject/Codec/Sop.lean) and `canonicalHash`.

`canonicalText_inj` proves the serialization determines the object: two objects
with the same canonical text are equal.  `ne_of_hash_ne` therefore lets a
differing hash stand as proof that two objects differ.
"

/-! ## `reconcile/` -/

/-- The verdict of comparing the two systems' answers (§28). -/
def reconcileVerdict : String :=
  match compareObjects sample rival with
  | .equivalent => "EQUIVALENT"
  | .different => "DIFFERENT"
  | .conflict => "CONFLICT"
  | .incomparable => "INCOMPARABLE"
  | .incomplete => "INCOMPLETE"

/-- `codec/reconcile/diff.yaml`: the structured differences between the two answers. -/
def reconcileDiff : String :=
  "left: " ++ canonicalHash sample ++ "\n" ++
  "right: " ++ canonicalHash rival ++ "\n" ++
  "verdict: " ++ reconcileVerdict ++ "\n" ++
  "differences:\n" ++
  String.join ((differences sample rival).map differenceYaml)

/-- `codec/reconcile/resolution.yaml`: what a `merge` resolution recorded (§29). -/
def reconcileResolution : String :=
  match resolveConflict .merge sample rival with
  | none => "resolution: none\nreason: the strategy escalates rather than inventing an object\n"
  | some r =>
      "strategy: merge\n" ++
      "left: " ++ r.left ++ "\n" ++
      "right: " ++ r.right ++ "\n" ++
      "result_status: " ++ r.result.status.toName ++ "\n" ++
      "result_hash: " ++ canonicalHash r.result ++ "\n" ++
      "diagnostics:\n" ++ String.join (r.diagnostics.map diagnosticYaml) ++
      "transformations:\n" ++ transformationYaml r.recorded ++
      "result:\n  " ++ encodeAs .yaml r.result ++ "\n"

/-! ## `provenance/` -/

/-- `codec/provenance/proof-001.yaml`: where the object came from and what happened to
it on the way (§20, §21). -/
def provenanceArtifact : String :=
  (match sample.provenance with
   | some p => provenanceYaml p
   | none => "source_system: unknown\n") ++
  "object_id: " ++ sample.id ++ "\n" ++
  "canonical_hash: " ++ sampleHash ++ "\n" ++
  "ledger:\n" ++
  String.join
    ([transformation "t1" "decode" "TEXT" "Square.lean" "canonical" .partialConv
        (hashText sample.sourceData) sampleHash,
      transformation "t2" "encode" "YAML" "canonical" "peer" .lossless
        sampleHash (hashText sampleYaml)].map transformationYaml)

/-! ## `tests/` -/

/-- The export report for one format, rendered (§27). -/
def exportReportText (f : Format) (p : ProofObject) : String :=
  let e := exportArtifact "peer" f p
  "- format: " ++ f.toName ++ "\n" ++
  "  lossiness: " ++ e.lossiness.toName ++ "\n" ++
  "  round_trip: " ++ (if e.roundTrip then "PASS" else "REPORTED LOSSY") ++ "\n" ++
  "  bytes: " ++ intAtom e.artifact.length ++ "\n" ++
  "  output_hash: " ++ e.transformation.outputHash ++ "\n"

/-- `codec/tests/roundtrip.yaml`: the §17 round-trip test run on the worked example. -/
def roundTripReport : String :=
  "object: " ++ sample.id ++ "\n" ++
  "canonical_hash: " ++ sampleHash ++ "\n" ++
  "exports:\n" ++
  String.join ([Format.ipdl, .xml, .csv, .yaml, .text].map (fun f => exportReportText f sample))

/-- `codec/tests/README.md`. -/
def testsReadme : String :=
"# tests/

The test suite §33 requires is `RequestProject/Codec/Tests.lean`: every case is a
machine-checked statement about the codec functions themselves, so a regression
breaks the build rather than a report.

Covered there: empty object, minimal object, nested object, multiple inputs,
multiple outputs, missing field, unknown field, invalid type, malformed input,
Unicode, large numbers, null values, duplicate identifiers, references, errors,
warnings, partial proofs, failed proofs, successful proofs, round-trip
conversion and lossy conversion; and, for the proof-specific cases, a known
valid proof, a known invalid proof, a known contradictory proof, a known
incomplete proof and a known incompatible output.

`roundtrip.yaml` in this directory is the §17 round-trip test executed on the
worked example: for each codec, the declared preservation level, whether the
object came back whole, and the hash of the artifact.
"

/-! ## `codec/README.md` -/

/-- The top-level README of the reference implementation. -/
def readme : String :=
"# codec/ — reference implementation artifacts

This directory is the §34 layout of the Standard Proof Codec.  Everything in it
is written by `lake exe codec`, which runs the verified Lean implementation in
`RequestProject/Codec/`; nothing here is hand-maintained.

```
codec/
├── schema/       the schema documents (§3–§7, §19, §22)
├── codecs/       one worked object written by every codec (§10, §12–§15)
├── canonical/    deterministic serialization and content hash (§16)
├── reconcile/    two systems compared, and the recorded resolution (§28–§29)
├── provenance/   where the object came from, and its ledger (§20–§21)
└── tests/        the required test suite and the round-trip report (§17, §33)
```

## Where each section of the specification lives

| § | subject | Lean |
| --- | --- | --- |
| 3 | canonical proof object | `Codec/Model.lean` — `ProofObject` |
| 4–5 | inputs and outputs | `Codec/Model.lean` — `Input`, `Output` |
| 6 | status vocabulary | `Codec/Model.lean` — `Status`, `status_error_ne_invalid` |
| 7 | error objects | `Codec/Model.lean` — `Diagnostic`, `Severity` |
| 8 | error resolution | `Codec/Sop.lean` — `resolveValue`, `resolve_records_repair` |
| 9 | lossless vs lossy | `Codec/Spec.lean` — `declaredProjection`, `Csv.not_lossless` |
| 10 | raw text codec | `Codec/Text.lean` — `RawText`, `ofRawText_preserves` |
| 11 | format detection | `Codec/Text.lean` — `detectFormat`, `detect_*` |
| 12 | IPDL codec | `Codec/Ipdl.lean` — `Ipdl.decode_encode` |
| 13 | XML codec | `Codec/Xml.lean` — `Xml.decode_encode` |
| 14 | CSV codec | `Codec/Csv.lean` — `Csv.decode_encode` |
| 15 | YAML codec | `Codec/Yaml.lean` — `Yaml.decode_encode` |
| 16 | canonical serialization | `Codec/Canonical.lean` — `canonicalText_inj`, `canonicalHash` |
| 17 | round-trip requirement | `Codec/Spec.lean` — `codec_roundTrip`, `roundTrip_semantic` |
| 18 | O(N) vs O(N²) | `Codec/Spec.lean` — `hub_lt_pairwise` |
| 19 | exchange envelope | `Codec/Canonical.lean` — `sealEnvelope`, `open_sealEnvelope` |
| 20–21 | provenance and ledger | `Codec/Canonical.lean` — `transformation`, `chained` |
| 23 | validation levels | `Codec/Sop.lean` — `validateSyntax/Structure/Types/Semantics` |
| 26–27 | import and export SOP | `Codec/Sop.lean` — `importArtifact`, `exportArtifact` |
| 28 | comparison | `Codec/Reconcile.lean` — `compareObjects`, `differences` |
| 29 | conflict resolution | `Codec/Reconcile.lean` — `resolveConflict`, `resolution_is_recorded` |
| 30 | unknown data | `Codec/Model.lean` — `extensions`; `merge_keeps_other` |
| 31 | minimal profile | `Codec/Spec.lean` — `ofMinimal`, `minimal_roundTrip` |
| 32 | conformance levels | `Codec/Spec.lean` — `Conforms`, `conforms` |
| 33 | required test suite | `Codec/Tests.lean` |
| 36 | definition of done | `Codec/Spec.lean` — `definition_of_done` |
"

end Export
end LifeTrac.Codec
