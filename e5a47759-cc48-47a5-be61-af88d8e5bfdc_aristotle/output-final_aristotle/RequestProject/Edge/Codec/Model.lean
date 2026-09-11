/-
# The canonical proof object

This is the semantic object the whole codec exists to move around: a
proof with its inputs, outputs, claims, certificates, errors, provenance
and metadata.  Every format adapter decodes *into* this and encodes *out
of* it; no adapter ever talks to another adapter.

The minimum profile is `id`, `kind`, `inputs`, `outputs`, `status`,
`errors`, `metadata` — everything else may be empty.  Anything a sender
included that this schema does not know about survives in `extensions`
(see `ofVal`, which folds unrecognized fields into it rather than
dropping them).

`toVal` / `ofVal` map a proof object to and from a canonical value, and
`ofVal_toVal` proves that mapping lossless.  Together with
`CVal.decode_encode` that gives the canonical wire form of a proof
object, and with `Canon.cid` its content identity.
-/
import RequestProject.Edge.Codec.Canon

namespace CfDeploy
namespace Codec

/-! ## Vocabularies -/

/-- The standard status vocabulary.  A system must not silently convert
one of these into another: `INVALID` (the operation completed and the
result failed validation) is not `ERROR` (the operation could not be
completed or interpreted). -/
inductive Status where
  | unknown | pending | valid | invalid | partial' | error | conflict | unsupported
  deriving DecidableEq, Repr, Inhabited

namespace Status

def toString : Status → String
  | .unknown => "UNKNOWN"
  | .pending => "PENDING"
  | .valid => "VALID"
  | .invalid => "INVALID"
  | .partial' => "PARTIAL"
  | .error => "ERROR"
  | .conflict => "CONFLICT"
  | .unsupported => "UNSUPPORTED"

/-- Read a status name; anything unrecognized is `UNKNOWN`, never a
guess at a different status. -/
def ofString (s : String) : Status :=
  if s = "UNKNOWN" then .unknown
  else if s = "PENDING" then .pending
  else if s = "VALID" then .valid
  else if s = "INVALID" then .invalid
  else if s = "PARTIAL" then .partial'
  else if s = "ERROR" then .error
  else if s = "CONFLICT" then .conflict
  else if s = "UNSUPPORTED" then .unsupported
  else .unknown

@[simp] theorem ofString_toString (s : Status) : ofString (toString s) = s := by
  cases s <;> rfl

end Status

/-- Diagnostic severity. -/
inductive Severity where
  | info | warning | error | fatal
  deriving DecidableEq, Repr, Inhabited

namespace Severity

def toString : Severity → String
  | .info => "INFO"
  | .warning => "WARNING"
  | .error => "ERROR"
  | .fatal => "FATAL"

def ofString (s : String) : Severity :=
  if s = "INFO" then .info
  else if s = "WARNING" then .warning
  else if s = "ERROR" then .error
  else if s = "FATAL" then .fatal
  else .info

@[simp] theorem ofString_toString (s : Severity) : ofString (toString s) = s := by
  cases s <;> rfl

end Severity

/-- How much of the semantic object survives a conversion. -/
inductive Lossiness where
  | lossless | lossy | partial' | failed
  deriving DecidableEq, Repr, Inhabited

namespace Lossiness

def toString : Lossiness → String
  | .lossless => "LOSSLESS"
  | .lossy => "LOSSY"
  | .partial' => "PARTIAL"
  | .failed => "FAILED"

def ofString (s : String) : Lossiness :=
  if s = "LOSSLESS" then .lossless
  else if s = "LOSSY" then .lossy
  else if s = "PARTIAL" then .partial'
  else if s = "FAILED" then .failed
  else .failed

@[simp] theorem ofString_toString (l : Lossiness) : ofString (toString l) = l := by
  cases l <;> rfl

end Lossiness

/-! ## Field access on canonical objects -/

namespace Fields

/-- The first value stored under a key. -/
def find (fs : List (String × CVal)) (k : String) : Option CVal :=
  match fs with
  | [] => none
  | (k', v) :: r => if k' = k then some v else find r k

/-- A string field; the empty string when absent or of another type (the
validator, not the decoder, is where type mismatches are reported). -/
def str (fs : List (String × CVal)) (k : String) : String :=
  match find fs k with
  | some (.str s) => s
  | _ => ""

def bool (fs : List (String × CVal)) (k : String) : Bool :=
  match find fs k with
  | some (.bool b) => b
  | _ => false

def val (fs : List (String × CVal)) (k : String) : CVal :=
  (find fs k).getD .null

def items (fs : List (String × CVal)) (k : String) : List CVal :=
  match find fs k with
  | some (.list xs) => xs
  | _ => []

def obj (fs : List (String × CVal)) (k : String) : List (String × CVal) :=
  match find fs k with
  | some (.obj o) => o
  | _ => []

/-- Fields the schema does not know about; they are kept, not dropped. -/
def unknown (known : List String) (fs : List (String × CVal)) : List (String × CVal) :=
  fs.filter (fun p => !known.contains p.1)

/-- A list of strings as a canonical value. -/
def ofStrList (ss : List String) : CVal := .list (ss.map CVal.str)

/-- Read a list of strings back. -/
def toStrList (xs : List CVal) : List String :=
  xs.map (fun v => match v with | .str s => s | _ => "")

@[simp] theorem toStrList_ofStrList (ss : List String) :
    toStrList (ss.map CVal.str) = ss := by
  induction ss with
  | nil => rfl
  | cons s ss ih => simp [toStrList] at *; exact ih

end Fields

/-! ## Provenance -/

/-- Where an object came from and what has been done to it. -/
structure Provenance where
  sourceSystem : String := ""
  sourceFile : String := ""
  sourceFormat : String := ""
  importedAt : String := ""
  transformedAt : String := ""
  /-- identifiers of the transformations in the ledger, oldest first -/
  transformations : List String := []
  /-- the object this one was derived from, `""` when it is original -/
  parentObject : String := ""
  deriving Repr, Inhabited, DecidableEq

namespace Provenance

def toVal (p : Provenance) : CVal :=
  .obj [ ("importedAt", .str p.importedAt)
       , ("parentObject", .str p.parentObject)
       , ("sourceFile", .str p.sourceFile)
       , ("sourceFormat", .str p.sourceFormat)
       , ("sourceSystem", .str p.sourceSystem)
       , ("transformations", Fields.ofStrList p.transformations)
       , ("transformedAt", .str p.transformedAt) ]

def ofFields (fs : List (String × CVal)) : Provenance :=
  { sourceSystem := Fields.str fs "sourceSystem"
    sourceFile := Fields.str fs "sourceFile"
    sourceFormat := Fields.str fs "sourceFormat"
    importedAt := Fields.str fs "importedAt"
    transformedAt := Fields.str fs "transformedAt"
    transformations := Fields.toStrList (Fields.items fs "transformations")
    parentObject := Fields.str fs "parentObject" }

def ofVal (v : CVal) : Provenance :=
  match v with
  | .obj fs => ofFields fs
  | _ => {}

@[simp] theorem ofVal_toVal (p : Provenance) : ofVal (toVal p) = p := by
  cases p
  simp [ofVal, toVal, ofFields, Fields.str, Fields.find, Fields.items, Fields.ofStrList]

end Provenance

/-! ## Inputs and outputs -/

/-- An explicitly identified object consumed by a proof. -/
structure CInput where
  id : String := ""
  name : String := ""
  type : String := ""
  value : CVal := .null
  encoding : String := ""
  units : String := ""
  constraints : List String := []
  provenance : Provenance := {}
  extensions : List (String × CVal) := []
  deriving Repr, Inhabited

/-- An object produced by a proof or computation. -/
structure COutput where
  id : String := ""
  name : String := ""
  type : String := ""
  value : CVal := .null
  encoding : String := ""
  claims : List String := []
  certificate : String := ""
  provenance : Provenance := {}
  extensions : List (String × CVal) := []
  deriving Repr, Inhabited

/-- A first-class error or diagnostic. -/
structure CError where
  id : String := ""
  code : String := ""
  severity : Severity := .error
  message : String := ""
  location : String := ""
  field : String := ""
  objectId : String := ""
  sourceSystem : String := ""
  sourceFormat : String := ""
  expected : String := ""
  actual : String := ""
  cause : String := ""
  resolution : String := ""
  recoverable : Bool := false
  deriving Repr, Inhabited

namespace CInput

def known : List String :=
  ["constraints", "encoding", "extensions", "id", "name", "provenance", "type", "units", "value"]

def toVal (x : CInput) : CVal :=
  .obj [ ("constraints", Fields.ofStrList x.constraints)
       , ("encoding", .str x.encoding)
       , ("extensions", .obj x.extensions)
       , ("id", .str x.id)
       , ("name", .str x.name)
       , ("provenance", x.provenance.toVal)
       , ("type", .str x.type)
       , ("units", .str x.units)
       , ("value", x.value) ]

def ofVal (v : CVal) : CInput :=
  match v with
  | .obj fs =>
      { id := Fields.str fs "id"
        name := Fields.str fs "name"
        type := Fields.str fs "type"
        value := Fields.val fs "value"
        encoding := Fields.str fs "encoding"
        units := Fields.str fs "units"
        constraints := Fields.toStrList (Fields.items fs "constraints")
        provenance := Provenance.ofVal (Fields.val fs "provenance")
        extensions := Fields.obj fs "extensions" ++ Fields.unknown known fs }
  | _ => {}

@[simp] theorem ofVal_toVal (x : CInput) : ofVal (toVal x) = x := by
  cases x
  simp [ofVal, toVal, Fields.str, Fields.find, Fields.items, Fields.val, Fields.obj,
    Fields.unknown, known, Fields.ofStrList, Provenance.ofVal, Provenance.toVal, Provenance.ofFields]

end CInput

namespace COutput

def known : List String :=
  ["certificate", "claims", "encoding", "extensions", "id", "name", "provenance", "type", "value"]

def toVal (x : COutput) : CVal :=
  .obj [ ("certificate", .str x.certificate)
       , ("claims", Fields.ofStrList x.claims)
       , ("encoding", .str x.encoding)
       , ("extensions", .obj x.extensions)
       , ("id", .str x.id)
       , ("name", .str x.name)
       , ("provenance", x.provenance.toVal)
       , ("type", .str x.type)
       , ("value", x.value) ]

def ofVal (v : CVal) : COutput :=
  match v with
  | .obj fs =>
      { id := Fields.str fs "id"
        name := Fields.str fs "name"
        type := Fields.str fs "type"
        value := Fields.val fs "value"
        encoding := Fields.str fs "encoding"
        claims := Fields.toStrList (Fields.items fs "claims")
        certificate := Fields.str fs "certificate"
        provenance := Provenance.ofVal (Fields.val fs "provenance")
        extensions := Fields.obj fs "extensions" ++ Fields.unknown known fs }
  | _ => {}

@[simp] theorem ofVal_toVal (x : COutput) : ofVal (toVal x) = x := by
  cases x
  simp [ofVal, toVal, Fields.str, Fields.find, Fields.items, Fields.val, Fields.obj,
    Fields.unknown, known, Fields.ofStrList, Provenance.ofVal, Provenance.toVal, Provenance.ofFields]

end COutput

namespace CError

def toVal (x : CError) : CVal :=
  .obj [ ("actual", .str x.actual)
       , ("cause", .str x.cause)
       , ("code", .str x.code)
       , ("expected", .str x.expected)
       , ("field", .str x.field)
       , ("id", .str x.id)
       , ("location", .str x.location)
       , ("message", .str x.message)
       , ("objectId", .str x.objectId)
       , ("recoverable", .bool x.recoverable)
       , ("resolution", .str x.resolution)
       , ("severity", .str x.severity.toString)
       , ("sourceFormat", .str x.sourceFormat)
       , ("sourceSystem", .str x.sourceSystem) ]

def ofVal (v : CVal) : CError :=
  match v with
  | .obj fs =>
      { id := Fields.str fs "id"
        code := Fields.str fs "code"
        severity := Severity.ofString (Fields.str fs "severity")
        message := Fields.str fs "message"
        location := Fields.str fs "location"
        field := Fields.str fs "field"
        objectId := Fields.str fs "objectId"
        sourceSystem := Fields.str fs "sourceSystem"
        sourceFormat := Fields.str fs "sourceFormat"
        expected := Fields.str fs "expected"
        actual := Fields.str fs "actual"
        cause := Fields.str fs "cause"
        resolution := Fields.str fs "resolution"
        recoverable := Fields.bool fs "recoverable" }
  | _ => {}

@[simp] theorem ofVal_toVal (x : CError) : ofVal (toVal x) = x := by
  cases x
  simp [ofVal, toVal, Fields.str, Fields.find, Fields.bool]

end CError

/-! ## The proof object -/

/-- A proof with its inputs and outputs, in the canonical model. -/
structure ProofObject where
  id : String := ""
  version : String := "proof-schema/1.0"
  kind : String := ""
  inputs : List CInput := []
  assumptions : List String := []
  parameters : List (String × CVal) := []
  procedure : String := ""
  intermediate : List CVal := []
  outputs : List COutput := []
  claims : List String := []
  certificates : List String := []
  errors : List CError := []
  warnings : List CError := []
  provenance : Provenance := {}
  metadata : List (String × CVal) := []
  /-- the format this object was decoded from -/
  sourceFormat : String := ""
  /-- the bytes or text it was decoded from, kept verbatim -/
  sourceData : String := ""
  status : Status := .unknown
  extensions : List (String × CVal) := []
  deriving Repr, Inhabited

namespace ProofObject

def known : List String :=
  ["assumptions", "certificates", "claims", "errors", "extensions", "id", "inputs",
   "intermediate", "kind", "metadata", "outputs", "parameters", "procedure",
   "provenance", "sourceData", "sourceFormat", "status", "version", "warnings"]

/-- The canonical value of a proof object: fields in a fixed order, so
that the serialization is deterministic. -/
def toVal (p : ProofObject) : CVal :=
  .obj [ ("assumptions", Fields.ofStrList p.assumptions)
       , ("certificates", Fields.ofStrList p.certificates)
       , ("claims", Fields.ofStrList p.claims)
       , ("errors", .list (p.errors.map CError.toVal))
       , ("extensions", .obj p.extensions)
       , ("id", .str p.id)
       , ("inputs", .list (p.inputs.map CInput.toVal))
       , ("intermediate", .list p.intermediate)
       , ("kind", .str p.kind)
       , ("metadata", .obj p.metadata)
       , ("outputs", .list (p.outputs.map COutput.toVal))
       , ("parameters", .obj p.parameters)
       , ("procedure", .str p.procedure)
       , ("provenance", p.provenance.toVal)
       , ("sourceData", .str p.sourceData)
       , ("sourceFormat", .str p.sourceFormat)
       , ("status", .str p.status.toString)
       , ("version", .str p.version)
       , ("warnings", .list (p.warnings.map CError.toVal)) ]

/-- Read a proof object back.  Unrecognized fields are folded into
`extensions` rather than discarded. -/
def ofVal (v : CVal) : Option ProofObject :=
  match v with
  | .obj fs =>
      some
        { id := Fields.str fs "id"
          version := Fields.str fs "version"
          kind := Fields.str fs "kind"
          inputs := (Fields.items fs "inputs").map CInput.ofVal
          assumptions := Fields.toStrList (Fields.items fs "assumptions")
          parameters := Fields.obj fs "parameters"
          procedure := Fields.str fs "procedure"
          intermediate := Fields.items fs "intermediate"
          outputs := (Fields.items fs "outputs").map COutput.ofVal
          claims := Fields.toStrList (Fields.items fs "claims")
          certificates := Fields.toStrList (Fields.items fs "certificates")
          errors := (Fields.items fs "errors").map CError.ofVal
          warnings := (Fields.items fs "warnings").map CError.ofVal
          provenance := Provenance.ofVal (Fields.val fs "provenance")
          metadata := Fields.obj fs "metadata"
          sourceFormat := Fields.str fs "sourceFormat"
          sourceData := Fields.str fs "sourceData"
          status := Status.ofString (Fields.str fs "status")
          extensions := Fields.obj fs "extensions" ++ Fields.unknown known fs }
  | _ => none

theorem map_ofVal_toVal_inputs (xs : List CInput) :
    xs.map (CInput.ofVal ∘ CInput.toVal) = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

theorem map_ofVal_toVal_outputs (xs : List COutput) :
    xs.map (COutput.ofVal ∘ COutput.toVal) = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

theorem map_ofVal_toVal_errors (xs : List CError) :
    xs.map (CError.ofVal ∘ CError.toVal) = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

/-- **Lossless.**  A proof object is exactly recoverable from its
canonical value; together with `CVal.decode_encode` that makes the
canonical wire form of a proof object lossless too. -/
@[simp] theorem ofVal_toVal (p : ProofObject) : ofVal (toVal p) = some p := by
  cases p
  simp [ofVal, toVal, Fields.str, Fields.find, Fields.items, Fields.val, Fields.obj,
    Fields.unknown, known, Fields.ofStrList, map_ofVal_toVal_inputs, map_ofVal_toVal_outputs,
    map_ofVal_toVal_errors]

/-- The canonical serialization of a proof object. -/
def encode (p : ProofObject) : String := CVal.encode (Canon.canon (toVal p))

/-- Its content identifier. -/
def cid (p : ProofObject) : String := Canon.cid (toVal p)

/-! ## The minimum interchange profile -/

/-- The fields a system must be able to exchange to participate at all. -/
structure Minimal where
  id : String
  kind : String
  inputs : List CInput
  outputs : List COutput
  status : Status
  errors : List CError
  metadata : List (String × CVal)
  deriving Repr, Inhabited

def minimal (p : ProofObject) : Minimal :=
  { id := p.id, kind := p.kind, inputs := p.inputs, outputs := p.outputs,
    status := p.status, errors := p.errors, metadata := p.metadata }

end ProofObject
end Codec
end CfDeploy
