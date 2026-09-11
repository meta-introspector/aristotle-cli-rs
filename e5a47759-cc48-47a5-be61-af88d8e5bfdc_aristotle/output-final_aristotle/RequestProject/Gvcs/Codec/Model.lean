import RequestProject.Gvcs.Codec.Atom

/-!
# The canonical proof object

This module fixes the *canonical model*: the authoritative interchange representation
that every codec of this specification decodes into and encodes out of.  No external
format is canonical; IPDL, XML, CSV, YAML and raw text are all adapters to and from the
types defined here.

The layout follows the specification section by section:

* `Value` — the value language shared by inputs, outputs, parameters and metadata.
* `Status` (§6) and `Severity` (§7) — the status and severity vocabularies.
* `Provenance` (§20), `Transformation` (§21) — the audit types.
* `Input` (§4), `Output` (§5), `Diagnostic` (§7) — the leaf objects.
* `ProofObject` (§3) — the canonical object, with its minimum required fields
  `id`, `kind`, `inputs`, `outputs`, `status` given as explicit fields and everything
  else defaulted, so that a partial producer can still build a legal object.
* `Envelope` (§19) — the exchange envelope.
* `Lossiness` (§9), `Verdict` and `Difference` (§28), `Resolution` (§29),
  `Format` (§11), `Level` (§32) — the vocabularies used by the codec layer itself.

Decidable equality for the types that mention `Value` is *not* derived here: `Value` is
a nested inductive, and equality on it is obtained in `RequestProject.Codec.Encode` from
the injectivity of its document encoding, which is proved rather than assumed.
-/

namespace LifeTrac.Codec

/-- The value language of the canonical model. -/
inductive Value where
  /-- A text value. -/
  | str (s : String)
  /-- An integer value. -/
  | int (i : Int)
  /-- A boolean value. -/
  | bool (b : Bool)
  /-- An explicit null. Distinguished from a missing field. -/
  | null
  /-- An ordered sequence; ordering is semantic. -/
  | list (xs : List Value)
  /-- An ordered record; field order is preserved as given. -/
  | obj (fs : List (String × Value))
  deriving Inhabited, Repr

/-- Proof status vocabulary (§6). A system must never silently convert one into another. -/
inductive Status where
  /-- Insufficient information to determine validity. -/
  | unknown
  /-- Not yet decided; work outstanding. -/
  | pending
  /-- Completed and validated. -/
  | valid
  /-- Completed, and the result failed validation. -/
  | invalid
  /-- Partially established. -/
  | partialResult
  /-- The system could not complete or interpret the operation. -/
  | error
  /-- Several systems produced incompatible results. -/
  | conflict
  /-- The operation is outside what this system supports. -/
  | unsupported
  deriving DecidableEq, Repr, Inhabited

/-- Diagnostic severity (§7). -/
inductive Severity where
  /-- Informational. -/
  | info
  /-- Something to be aware of; the object stays usable. -/
  | warning
  /-- A genuine failure of one operation. -/
  | error
  /-- Unrecoverable. -/
  | fatal
  deriving DecidableEq, Repr, Inhabited

/-- Preservation level of a conversion (§9). -/
inductive Lossiness where
  /-- The complete semantic object survives the conversion. -/
  | lossless
  /-- Some semantic information is dropped. -/
  | lossy
  /-- A declared projection of the object survives. -/
  | partialConv
  /-- The conversion did not produce an object. -/
  | failed
  deriving DecidableEq, Repr, Inhabited

/-- The interchange formats this specification covers (§11). -/
inductive Format where
  /-- The native structured interchange codec (§12). -/
  | ipdl
  /-- XML (§13). -/
  | xml
  /-- The tabular projection (§14). -/
  | csv
  /-- YAML (§15). -/
  | yaml
  /-- Raw, possibly unstructured, text (§10). -/
  | text
  deriving DecidableEq, Repr, Inhabited

/-- Conformance levels (§32). -/
inductive Level where
  /-- Level 0 — can preserve and exchange arbitrary text. -/
  | raw
  /-- Level 1 — can import and export canonical objects. -/
  | structured
  /-- Level 2 — supports schemas, types, inputs, outputs and errors. -/
  | typed
  /-- Level 3 — can validate proof inputs and outputs. -/
  | proofAware
  /-- Level 4 — can compare independent results and resolve conflicts. -/
  | reconciliation
  /-- Level 5 — provenance, deterministic serialization, hashing, ledgers. -/
  | auditable
  deriving DecidableEq, Repr, Inhabited

/-- Provenance of an object (§20). -/
structure Provenance where
  /-- System the object came from. -/
  sourceSystem : String := ""
  /-- File or stream the object came from. -/
  sourceFile : String := ""
  /-- Format the object was read from. -/
  sourceFormat : String := ""
  /-- Import timestamp, as recorded by the importer. -/
  importedAt : String := ""
  /-- Timestamp of the last transformation. -/
  transformedAt : String := ""
  /-- Identifiers of the transformations applied, oldest first. -/
  transformations : List String := []
  /-- Identifier of the object this one was derived from. -/
  parent : Option String := none
  deriving DecidableEq, Repr, Inhabited

/-- A transformation ledger entry (§21). -/
structure Transformation where
  /-- Identifier of this ledger entry. -/
  id : String
  /-- What was done, e.g. `decode`, `encode`, `resolve`. -/
  operation : String
  /-- Source description (system, file or format). -/
  source : String := ""
  /-- Destination description. -/
  destination : String := ""
  /-- Canonical hash of the input. -/
  inputHash : String := ""
  /-- Canonical hash of the output. -/
  outputHash : String := ""
  /-- Codec used. -/
  codec : String := ""
  /-- Version of that codec. -/
  codecVersion : String := ""
  /-- Declared preservation level of the conversion. -/
  lossiness : Lossiness := .lossless
  /-- Errors raised during the conversion. -/
  errors : List String := []
  /-- Warnings raised during the conversion. -/
  warnings : List String := []
  deriving DecidableEq, Repr, Inhabited

/-- An input consumed by a proof (§4). -/
structure Input where
  /-- Stable identifier, unique inside the proof object. -/
  id : String
  /-- Human-facing name. -/
  name : String := ""
  /-- Declared type, e.g. `integer`, `text`, `matrix`. -/
  type : String := ""
  /-- The value itself, in the canonical value language. -/
  value : Value := .null
  /-- Encoding of the original representation, when it matters. -/
  encoding : String := ""
  /-- Units, when the value is dimensional. -/
  units : String := ""
  /-- Constraints the value is declared to satisfy. -/
  constraints : List String := []
  /-- Where this input came from. -/
  provenance : Option Provenance := none
  deriving Repr, Inhabited

/-- An output produced by a proof (§5). -/
structure Output where
  /-- Stable identifier, unique inside the proof object. -/
  id : String
  /-- Human-facing name. -/
  name : String := ""
  /-- Declared type. -/
  type : String := ""
  /-- The value itself. -/
  value : Value := .null
  /-- Encoding of the original representation. -/
  encoding : String := ""
  /-- Claims this output is asserted to establish. -/
  claims : List String := []
  /-- Certificate backing the output, when one exists. -/
  certificate : Option String := none
  /-- Where this output came from. -/
  provenance : Option Provenance := none
  deriving Repr, Inhabited

/-- An error or warning, as a first-class exchange object (§7). -/
structure Diagnostic where
  /-- Identifier of this diagnostic. -/
  id : String
  /-- Machine-readable code, e.g. `TYPE_MISMATCH`. -/
  code : String
  /-- How bad it is. -/
  severity : Severity := .error
  /-- Human-readable message. -/
  message : String := ""
  /-- Location in the source artifact, e.g. a line/column or byte offset. -/
  location : String := ""
  /-- Path of the offending field, e.g. `inputs[0].value`. -/
  field : String := ""
  /-- Identifier of the object the diagnostic is about. -/
  objectId : String := ""
  /-- System that raised it. -/
  sourceSystem : String := ""
  /-- Format being processed when it was raised. -/
  sourceFormat : String := ""
  /-- What was expected. -/
  expected : String := ""
  /-- What was found. -/
  actual : String := ""
  /-- Cause, when known. -/
  cause : String := ""
  /-- Resolution applied or proposed. -/
  resolution : String := ""
  /-- Whether the condition is recoverable. -/
  recoverable : Bool := false
  deriving DecidableEq, Repr, Inhabited

/--
The canonical proof object (§3).

`id`, `kind`, `inputs`, `outputs` and `status` are the minimum required fields; every
other field has a default, so an object can be built by a producer that has nothing
else to say.
-/
structure ProofObject where
  /-- Stable identifier. -/
  id : String
  /-- Schema/content version of this object. -/
  version : String := ""
  /-- What kind of proof this is, e.g. `theorem`, `computation`, `certificate`. -/
  kind : String
  /-- Inputs consumed. -/
  inputs : List Input
  /-- Assumptions the proof is relative to. -/
  assumptions : List String := []
  /-- Named parameters of the procedure. -/
  parameters : List (String × Value) := []
  /-- Description or identifier of the procedure followed. -/
  procedure : String := ""
  /-- Intermediate artifacts, recorded as outputs. -/
  intermediate : List Output := []
  /-- Outputs produced. -/
  outputs : List Output
  /-- Claims made by the proof. -/
  claims : List String := []
  /-- Certificates accompanying the proof. -/
  certificates : List String := []
  /-- Errors attached to the object. -/
  errors : List Diagnostic := []
  /-- Warnings attached to the object. -/
  warnings : List Diagnostic := []
  /-- Provenance of the object. -/
  provenance : Option Provenance := none
  /-- Free-form metadata. -/
  metadata : List (String × Value) := []
  /-- Format the object was decoded from. -/
  sourceFormat : String := ""
  /-- The original bytes/text, preserved verbatim. -/
  sourceData : String := ""
  /-- Status of the proof. -/
  status : Status
  /-- Data with no canonical equivalent, kept under a vendor namespace (§30). -/
  extensions : List (String × Value) := []
  deriving Repr, Inhabited

/-- The exchange envelope (§19). -/
structure Envelope where
  /-- Version of the proof schema in force. -/
  schemaVersion : String := "proof-schema/1.0"
  /-- Version of the codec that produced the envelope. -/
  codecVersion : String := "proof-codec/1.0"
  /-- Sending system. -/
  source : String := ""
  /-- Receiving system. -/
  destination : String := ""
  /-- When the envelope was produced. -/
  timestamp : String := ""
  /-- Identifier of the payload object. -/
  objectId : String := ""
  /-- The canonical object being transported. -/
  payload : ProofObject
  /-- Diagnostics raised during transport. -/
  diagnostics : List Diagnostic := []
  /-- The transformation ledger for this transport (§21). -/
  transformations : List Transformation := []
  /-- Integrity token: the canonical hash of the payload. -/
  integrity : String := ""
  deriving Repr, Inhabited

/-- Verdict of the semantic comparator (§28). -/
inductive Verdict where
  /-- The two objects mean the same thing. -/
  | equivalent
  /-- They differ, but not in a way that makes them incompatible. -/
  | different
  /-- They make incompatible claims about the same thing. -/
  | conflict
  /-- They are not about the same thing, so no comparison is meaningful. -/
  | incomparable
  /-- One of them lacks the information needed to compare. -/
  | incomplete
  deriving DecidableEq, Repr, Inhabited

/-- A structured difference between two canonical objects (§28). -/
structure Difference where
  /-- Path into the object, e.g. `outputs[0].value`. -/
  path : String
  /-- Rendering of the left-hand value. -/
  left : String
  /-- Rendering of the right-hand value. -/
  right : String
  /-- Kind of difference, e.g. `VALUE_MISMATCH`. -/
  type : String
  /-- Severity of the difference. -/
  severity : Severity
  /-- Why the difference matters. -/
  explanation : String := ""
  deriving DecidableEq, Repr, Inhabited

/-- Conflict resolution strategies (§29). -/
inductive Strategy where
  /-- Keep the object from the nominated source system. -/
  | preferSource
  /-- Keep the object that carries a validated status. -/
  | preferVerified
  /-- Keep the object with the later timestamp. -/
  | preferNewer
  /-- Escalate to a human. -/
  | manual
  /-- Merge the two objects. -/
  | merge
  /-- Reject both. -/
  | reject
  deriving DecidableEq, Repr, Inhabited

/-- The minimum interchange profile (§31). -/
structure MinimalProfile where
  /-- Identifier. -/
  id : String
  /-- Kind. -/
  kind : String
  /-- Inputs. -/
  inputs : List Input
  /-- Outputs. -/
  outputs : List Output
  /-- Status. -/
  status : Status
  /-- Errors. -/
  errors : List Diagnostic
  /-- Metadata. -/
  metadata : List (String × Value)
  deriving Repr, Inhabited

/-- The minimum-profile projection of a canonical object (§31). -/
def ProofObject.minimal (p : ProofObject) : MinimalProfile :=
  { id := p.id, kind := p.kind, inputs := p.inputs, outputs := p.outputs,
    status := p.status, errors := p.errors, metadata := p.metadata }

/-- Rendering of a status in the standard vocabulary (§6). -/
def Status.toName : Status → String
  | .unknown => "UNKNOWN"
  | .pending => "PENDING"
  | .valid => "VALID"
  | .invalid => "INVALID"
  | .partialResult => "PARTIAL"
  | .error => "ERROR"
  | .conflict => "CONFLICT"
  | .unsupported => "UNSUPPORTED"

/-- Parsing of a status name; unknown spellings are rejected rather than guessed. -/
def Status.ofName? (s : String) : Option Status :=
  if s = "UNKNOWN" then some .unknown
  else if s = "PENDING" then some .pending
  else if s = "VALID" then some .valid
  else if s = "INVALID" then some .invalid
  else if s = "PARTIAL" then some .partialResult
  else if s = "ERROR" then some .error
  else if s = "CONFLICT" then some .conflict
  else if s = "UNSUPPORTED" then some .unsupported
  else none

@[simp] theorem Status.ofName_toName (s : Status) : Status.ofName? s.toName = some s := by
  cases s <;> rfl

/-- Rendering of a severity (§7). -/
def Severity.toName : Severity → String
  | .info => "INFO"
  | .warning => "WARNING"
  | .error => "ERROR"
  | .fatal => "FATAL"

/-- Parsing of a severity name. -/
def Severity.ofName? (s : String) : Option Severity :=
  if s = "INFO" then some .info
  else if s = "WARNING" then some .warning
  else if s = "ERROR" then some .error
  else if s = "FATAL" then some .fatal
  else none

@[simp] theorem Severity.ofName_toName (s : Severity) : Severity.ofName? s.toName = some s := by
  cases s <;> rfl

/-- Rendering of a preservation level (§9). -/
def Lossiness.toName : Lossiness → String
  | .lossless => "LOSSLESS"
  | .lossy => "LOSSY"
  | .partialConv => "PARTIAL"
  | .failed => "FAILED"

/-- Parsing of a preservation level. -/
def Lossiness.ofName? (s : String) : Option Lossiness :=
  if s = "LOSSLESS" then some .lossless
  else if s = "LOSSY" then some .lossy
  else if s = "PARTIAL" then some .partialConv
  else if s = "FAILED" then some .failed
  else none

@[simp] theorem Lossiness.ofName_toName (l : Lossiness) :
    Lossiness.ofName? l.toName = some l := by
  cases l <;> rfl

/-- Name of a format. -/
def Format.toName : Format → String
  | .ipdl => "IPDL"
  | .xml => "XML"
  | .csv => "CSV"
  | .yaml => "YAML"
  | .text => "TEXT"

/-- `ERROR` and `INVALID` are different statuses, and the codec never conflates them (§6). -/
theorem status_error_ne_invalid : Status.error ≠ Status.invalid := by decide

/-- Status names are distinct, so the vocabulary can be transported as text. -/
theorem status_toName_injective : Function.Injective Status.toName := by
  intro a b h
  have := congrArg Status.ofName? h
  simpa using this

end LifeTrac.Codec
