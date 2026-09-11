/-
# Standard Proof Codec — the canonical proof object

The data model of the specification:

* `Status` (SOP §6), `Severity` (§7), `Lossiness` (§9);
* `Input` (§4), `Output` (§5), `ErrorObj` (§7), `Claim`, `Certificate`,
  `Artifact`;
* `Provenance` (§20), `Transformation` (§21);
* `ProofObject` (§3) and `Envelope` (§19).

Each of these is given an adapter to and from `CValue`, the canonical value,
together with its round-trip theorem: the canonical model is never lost by
being written down as a canonical value.
-/
import RequestProject.Craft.Codec.Canonical

namespace Codec

/-! ## Encoding helpers -/

namespace Enc

/-- `Option`-returning map, used by the structural decoders. -/
def mapOpt {α β : Type} (g : α → Option β) : List α → Option (List β)
  | [] => some []
  | x :: xs =>
      match g x with
      | some y => (mapOpt g xs).map (fun ys => y :: ys)
      | none => none

theorem mapOpt_map {α β : Type} (f : α → β) (g : β → Option α)
    (h : ∀ a, g (f a) = some a) : ∀ xs : List α, mapOpt g (xs.map f) = some xs := by
  intro xs
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [mapOpt, h x, ih]

/-- Encode an optional value, `none` becoming canonical null. -/
def encOpt {α : Type} (f : α → CValue) : Option α → CValue
  | none => .null
  | some a => f a

/-- Decode an optional value. -/
def decOpt {α : Type} (g : CValue → Option α) : CValue → Option (Option α)
  | .null => some none
  | v => (g v).map some

theorem decOpt_encOpt {α : Type} (f : α → CValue) (g : CValue → Option α)
    (hf : ∀ a, f a ≠ CValue.null) (h : ∀ a, g (f a) = some a) :
    ∀ x : Option α, decOpt g (encOpt f x) = some x := by
  intro x
  cases x with
  | none => rfl
  | some a =>
      have := hf a
      unfold encOpt
      cases hfa : f a with
      | null => exact absurd hfa this
      | _ => simp [decOpt, h a]

/-- Encode a string. -/
def encStr (s : String) : CValue := .str s

/-- Decode a string. -/
def decStr : CValue → Option String
  | .str s => some s
  | _ => none

theorem decStr_encStr (s : String) : decStr (encStr s) = some s := rfl

theorem encStr_ne_null (s : String) : encStr s ≠ CValue.null := by
  simp [encStr]

/-- Encode a list of values with an element encoder. -/
def encL {α : Type} (f : α → CValue) (xs : List α) : CValue := .list (xs.map f)

/-- Decode a list of values with an element decoder. -/
def decL {α : Type} (g : CValue → Option α) : CValue → Option (List α)
  | .list xs => mapOpt g xs
  | _ => none

theorem decL_encL {α : Type} (f : α → CValue) (g : CValue → Option α)
    (h : ∀ a, g (f a) = some a) (xs : List α) : decL g (encL f xs) = some xs := by
  simp [decL, encL, mapOpt_map f g h]

/-- Encode a key/value table. -/
def encTable (t : List (String × CValue)) : CValue :=
  .list (t.map (fun p => CValue.obj [("key", .str p.1), ("value", p.2)]))

/-- Decode a key/value table. -/
def decTable : CValue → Option (List (String × CValue))
  | .list xs =>
      mapOpt (fun v =>
        match v with
        | .obj [("key", .str k), ("value", w)] => some (k, w)
        | _ => none) xs
  | _ => none

theorem decTable_encTable (t : List (String × CValue)) : decTable (encTable t) = some t := by
  simp only [encTable, decTable]
  rw [mapOpt_map (fun p : String × CValue => CValue.obj [("key", .str p.1), ("value", p.2)])]
  intro a
  cases a with
  | mk k v => rfl

/-- Field lookup in an encoded object. -/
def fld (v : CValue) (k : String) : Option CValue := v.get? k

theorem fld_cons_hit (k : String) (w : CValue) (fs : List (String × CValue)) :
    fld (.obj ((k, w) :: fs)) k = some w := by
  simp [fld, CValue.get?]

end Enc

open Enc

/-! ## Status vocabulary (SOP §6) -/

/-- The standard proof status vocabulary. A system must not silently convert
one status into another; the codec keeps them distinct. -/
inductive Status where
  | UNKNOWN | PENDING | VALID | INVALID | PARTIAL | ERROR | CONFLICT | UNSUPPORTED
  deriving Repr, DecidableEq, Inhabited

namespace Status

/-- Wire name of a status. -/
def toName : Status → String
  | UNKNOWN => "UNKNOWN" | PENDING => "PENDING" | VALID => "VALID"
  | INVALID => "INVALID" | PARTIAL => "PARTIAL" | ERROR => "ERROR"
  | CONFLICT => "CONFLICT" | UNSUPPORTED => "UNSUPPORTED"

/-- Status of a wire name. -/
def ofName : String → Option Status
  | "UNKNOWN" => some UNKNOWN | "PENDING" => some PENDING | "VALID" => some VALID
  | "INVALID" => some INVALID | "PARTIAL" => some PARTIAL | "ERROR" => some ERROR
  | "CONFLICT" => some CONFLICT | "UNSUPPORTED" => some UNSUPPORTED
  | _ => none

/-- Encode a status. -/
def toCValue (s : Status) : CValue := .str s.toName

/-- Decode a status. -/
def ofCValue : CValue → Option Status
  | .str s => ofName s
  | _ => none

theorem ofName_toName (s : Status) : ofName s.toName = some s := by
  cases s <;> rfl

theorem ofCValue_toCValue (s : Status) : ofCValue (toCValue s) = some s := by
  cases s <;> rfl

/-- Did the operation complete? `ERROR` means the system could not complete or
interpret the operation; every other status reports a completed operation. -/
def completed : Status → Bool
  | ERROR => false
  | UNSUPPORTED => false
  | _ => true

/-- Did validation reject a completed result? -/
def failedValidation : Status → Bool
  | INVALID => true
  | _ => false

end Status

/-! ## Severity (SOP §7) and lossiness (SOP §9) -/

/-- Diagnostic severity. -/
inductive Severity where
  | INFO | WARNING | ERROR | FATAL
  deriving Repr, DecidableEq, Inhabited

namespace Severity

/-- Wire name of a severity. -/
def toName : Severity → String
  | INFO => "INFO" | WARNING => "WARNING" | ERROR => "ERROR" | FATAL => "FATAL"

/-- Severity of a wire name. -/
def ofName : String → Option Severity
  | "INFO" => some INFO | "WARNING" => some WARNING
  | "ERROR" => some ERROR | "FATAL" => some FATAL
  | _ => none

/-- Encode a severity. -/
def toCValue (s : Severity) : CValue := .str s.toName

/-- Decode a severity. -/
def ofCValue : CValue → Option Severity
  | .str s => ofName s
  | _ => none

theorem ofCValue_toCValue (s : Severity) : ofCValue (toCValue s) = some s := by
  cases s <;> rfl

end Severity

/-- Preservation level of a conversion (SOP §9). -/
inductive Lossiness where
  | LOSSLESS | LOSSY | PARTIAL | FAILED
  deriving Repr, DecidableEq, Inhabited

namespace Lossiness

/-- Wire name of a preservation level. -/
def toName : Lossiness → String
  | LOSSLESS => "LOSSLESS" | LOSSY => "LOSSY" | PARTIAL => "PARTIAL" | FAILED => "FAILED"

/-- Preservation level of a wire name. -/
def ofName : String → Option Lossiness
  | "LOSSLESS" => some LOSSLESS | "LOSSY" => some LOSSY
  | "PARTIAL" => some PARTIAL | "FAILED" => some FAILED
  | _ => none

/-- Encode a preservation level. -/
def toCValue (l : Lossiness) : CValue := .str l.toName

/-- Decode a preservation level. -/
def ofCValue : CValue → Option Lossiness
  | .str s => ofName s
  | _ => none

theorem ofCValue_toCValue (l : Lossiness) : ofCValue (toCValue l) = some l := by
  cases l <;> rfl

end Lossiness

/-! ## Provenance (SOP §20) and transformations (SOP §21) -/

/-- Where an object came from and what was done to it. -/
structure Provenance where
  /-- System that produced the object. -/
  source_system : String
  /-- File the object was read from, if any. -/
  source_file : Option String
  /-- Format the object was read from. -/
  source_format : String
  /-- When the object was imported. -/
  imported_at : String
  /-- When the object was last transformed. -/
  transformed_at : Option String
  /-- Identifiers of the transformations applied, oldest first. -/
  transformations : List String
  /-- Identifier of the object this one was derived from. -/
  parent_object : Option String
  deriving Repr, DecidableEq, Inhabited

namespace Provenance

/-- Encode provenance. -/
def toCValue (p : Provenance) : CValue :=
  .obj [("source_system", .str p.source_system),
        ("source_file", encOpt encStr p.source_file),
        ("source_format", .str p.source_format),
        ("imported_at", .str p.imported_at),
        ("transformed_at", encOpt encStr p.transformed_at),
        ("transformations", encL encStr p.transformations),
        ("parent_object", encOpt encStr p.parent_object)]

/-- Decode provenance. -/
def ofCValue (v : CValue) : Option Provenance := do
  let ss ← decStr (← fld v "source_system")
  let sf ← decOpt decStr (← fld v "source_file")
  let sfm ← decStr (← fld v "source_format")
  let ia ← decStr (← fld v "imported_at")
  let ta ← decOpt decStr (← fld v "transformed_at")
  let ts ← decL decStr (← fld v "transformations")
  let po ← decOpt decStr (← fld v "parent_object")
  some ⟨ss, sf, sfm, ia, ta, ts, po⟩

theorem ofCValue_toCValue (p : Provenance) : ofCValue (toCValue p) = some p := by
  obtain ⟨ss, sf, sfm, ia, ta, ts, po⟩ := p
  simp [ofCValue, toCValue, fld, CValue.get?, decOpt_encOpt encStr decStr encStr_ne_null
    decStr_encStr, decL_encL encStr decStr decStr_encStr, decStr]

end Provenance

/-- A record of one conversion (SOP §21). -/
structure Transformation where
  /-- Identifier of this transformation. -/
  id : String
  /-- What was done. -/
  operation : String
  /-- Source format. -/
  source : String
  /-- Destination format. -/
  destination : String
  /-- Canonical hash of the input. -/
  input_hash : Nat
  /-- Canonical hash of the output. -/
  output_hash : Nat
  /-- Codec used. -/
  codec : String
  /-- Version of the codec. -/
  codec_version : String
  /-- Declared preservation level. -/
  lossiness : Lossiness
  /-- Errors raised during the conversion. -/
  errors : List String
  /-- Warnings raised during the conversion. -/
  warnings : List String
  deriving Repr, DecidableEq, Inhabited

namespace Transformation

/-- Encode a transformation record. -/
def toCValue (t : Transformation) : CValue :=
  .obj [("id", .str t.id), ("operation", .str t.operation),
        ("source", .str t.source), ("destination", .str t.destination),
        ("input_hash", .int (t.input_hash : Int)),
        ("output_hash", .int (t.output_hash : Int)),
        ("codec", .str t.codec), ("codec_version", .str t.codec_version),
        ("lossiness", t.lossiness.toCValue),
        ("errors", encL encStr t.errors), ("warnings", encL encStr t.warnings)]

/-- Decode a natural number. -/
def decNat : CValue → Option Nat
  | .int n => if 0 ≤ n then some n.toNat else none
  | _ => none

/-- Decode a transformation record. -/
def ofCValue (v : CValue) : Option Transformation := do
  let id ← decStr (← fld v "id")
  let op ← decStr (← fld v "operation")
  let src ← decStr (← fld v "source")
  let dst ← decStr (← fld v "destination")
  let ih ← decNat (← fld v "input_hash")
  let oh ← decNat (← fld v "output_hash")
  let cd ← decStr (← fld v "codec")
  let cv ← decStr (← fld v "codec_version")
  let ls ← Lossiness.ofCValue (← fld v "lossiness")
  let es ← decL decStr (← fld v "errors")
  let ws ← decL decStr (← fld v "warnings")
  some ⟨id, op, src, dst, ih, oh, cd, cv, ls, es, ws⟩

theorem ofCValue_toCValue (t : Transformation) : ofCValue (toCValue t) = some t := by
  obtain ⟨id, op, src, dst, ih, oh, cd, cv, ls, es, ws⟩ := t
  simp [ofCValue, toCValue, fld, CValue.get?, decNat, decStr,
    decL_encL encStr decStr decStr_encStr, Lossiness.ofCValue_toCValue]

end Transformation

/-! ## Inputs (SOP §4) and outputs (SOP §5) -/

/-- An explicitly identified object consumed by a proof. -/
structure Input where
  /-- Identifier, unique within the proof object. -/
  id : String
  /-- Human-readable name. -/
  name : String
  /-- Declared type. -/
  type : String
  /-- The value itself, in canonical form. -/
  value : CValue
  /-- Encoding of the original representation, if any. -/
  encoding : Option String
  /-- Units of measurement, if any. -/
  units : Option String
  /-- Declared constraints. -/
  constraints : List String
  /-- Where the input came from. -/
  provenance : Option Provenance
  deriving Repr, DecidableEq, Inhabited

namespace Input

/-- Encode an input. -/
def toCValue (i : Input) : CValue :=
  .obj [("id", .str i.id), ("name", .str i.name), ("type", .str i.type),
        ("value", i.value), ("encoding", encOpt encStr i.encoding),
        ("units", encOpt encStr i.units),
        ("constraints", encL encStr i.constraints),
        ("provenance", encOpt Provenance.toCValue i.provenance)]

/-- Decode an input. -/
def ofCValue (v : CValue) : Option Input := do
  let id ← decStr (← fld v "id")
  let nm ← decStr (← fld v "name")
  let ty ← decStr (← fld v "type")
  let vl ← fld v "value"
  let en ← decOpt decStr (← fld v "encoding")
  let un ← decOpt decStr (← fld v "units")
  let cs ← decL decStr (← fld v "constraints")
  let pv ← decOpt Provenance.ofCValue (← fld v "provenance")
  some ⟨id, nm, ty, vl, en, un, cs, pv⟩

theorem provenance_toCValue_ne_null (p : Provenance) : Provenance.toCValue p ≠ CValue.null := by
  simp [Provenance.toCValue]

theorem ofCValue_toCValue (i : Input) : ofCValue (toCValue i) = some i := by
  obtain ⟨id, nm, ty, vl, en, un, cs, pv⟩ := i
  simp [ofCValue, toCValue, fld, CValue.get?, decStr,
    decOpt_encOpt encStr decStr encStr_ne_null decStr_encStr,
    decL_encL encStr decStr decStr_encStr,
    decOpt_encOpt Provenance.toCValue Provenance.ofCValue provenance_toCValue_ne_null
      Provenance.ofCValue_toCValue]

end Input

/-- An object produced by a proof or computation. -/
structure Output where
  /-- Identifier, unique within the proof object. -/
  id : String
  /-- Human-readable name. -/
  name : String
  /-- Declared type. -/
  type : String
  /-- The value itself, in canonical form. -/
  value : CValue
  /-- Encoding of the original representation, if any. -/
  encoding : Option String
  /-- Claims this output supports. -/
  claims : List String
  /-- Certificate identifier, if the output is certified. -/
  certificate : Option String
  /-- Where the output came from. -/
  provenance : Option Provenance
  deriving Repr, DecidableEq, Inhabited

namespace Output

/-- Encode an output. -/
def toCValue (o : Output) : CValue :=
  .obj [("id", .str o.id), ("name", .str o.name), ("type", .str o.type),
        ("value", o.value), ("encoding", encOpt encStr o.encoding),
        ("claims", encL encStr o.claims),
        ("certificate", encOpt encStr o.certificate),
        ("provenance", encOpt Provenance.toCValue o.provenance)]

/-- Decode an output. -/
def ofCValue (v : CValue) : Option Output := do
  let id ← decStr (← fld v "id")
  let nm ← decStr (← fld v "name")
  let ty ← decStr (← fld v "type")
  let vl ← fld v "value"
  let en ← decOpt decStr (← fld v "encoding")
  let cl ← decL decStr (← fld v "claims")
  let ct ← decOpt decStr (← fld v "certificate")
  let pv ← decOpt Provenance.ofCValue (← fld v "provenance")
  some ⟨id, nm, ty, vl, en, cl, ct, pv⟩

theorem ofCValue_toCValue (o : Output) : ofCValue (toCValue o) = some o := by
  obtain ⟨id, nm, ty, vl, en, cl, ct, pv⟩ := o
  simp [ofCValue, toCValue, fld, CValue.get?, decStr,
    decOpt_encOpt encStr decStr encStr_ne_null decStr_encStr,
    decL_encL encStr decStr decStr_encStr,
    decOpt_encOpt Provenance.toCValue Provenance.ofCValue Input.provenance_toCValue_ne_null
      Provenance.ofCValue_toCValue]

end Output

/-! ## Errors (SOP §7) -/

/-- A first-class error object. -/
structure ErrorObj where
  /-- Identifier of this diagnostic. -/
  id : String
  /-- Machine-readable code, e.g. `TYPE_MISMATCH`. -/
  code : String
  /-- Severity. -/
  severity : Severity
  /-- Human-readable message. -/
  message : String
  /-- Where in the source the problem is (line/offset description). -/
  location : Option String
  /-- Which field of the canonical object is affected. -/
  field : Option String
  /-- Which object is affected. -/
  object_id : Option String
  /-- Which system raised the diagnostic. -/
  source_system : Option String
  /-- Which format the data was in. -/
  source_format : Option String
  /-- What was expected. -/
  expected : Option String
  /-- What was found. -/
  actual : Option String
  /-- Cause, when known. -/
  cause : Option String
  /-- Resolution that was applied, when any. -/
  resolution : Option String
  /-- Whether the condition is recoverable. -/
  recoverable : Bool
  deriving Repr, DecidableEq, Inhabited

namespace ErrorObj

/-- Encode an error object. -/
def toCValue (e : ErrorObj) : CValue :=
  .obj [("id", .str e.id), ("code", .str e.code),
        ("severity", e.severity.toCValue), ("message", .str e.message),
        ("location", encOpt encStr e.location), ("field", encOpt encStr e.field),
        ("object_id", encOpt encStr e.object_id),
        ("source_system", encOpt encStr e.source_system),
        ("source_format", encOpt encStr e.source_format),
        ("expected", encOpt encStr e.expected), ("actual", encOpt encStr e.actual),
        ("cause", encOpt encStr e.cause), ("resolution", encOpt encStr e.resolution),
        ("recoverable", .bool e.recoverable)]

/-- Decode a boolean. -/
def decBool : CValue → Option Bool
  | .bool b => some b
  | _ => none

/-- Decode an error object. -/
def ofCValue (v : CValue) : Option ErrorObj := do
  let id ← decStr (← fld v "id")
  let cd ← decStr (← fld v "code")
  let sv ← Severity.ofCValue (← fld v "severity")
  let ms ← decStr (← fld v "message")
  let lo ← decOpt decStr (← fld v "location")
  let fi ← decOpt decStr (← fld v "field")
  let ob ← decOpt decStr (← fld v "object_id")
  let ss ← decOpt decStr (← fld v "source_system")
  let sf ← decOpt decStr (← fld v "source_format")
  let ex ← decOpt decStr (← fld v "expected")
  let ac ← decOpt decStr (← fld v "actual")
  let ca ← decOpt decStr (← fld v "cause")
  let re ← decOpt decStr (← fld v "resolution")
  let rc ← decBool (← fld v "recoverable")
  some ⟨id, cd, sv, ms, lo, fi, ob, ss, sf, ex, ac, ca, re, rc⟩

theorem ofCValue_toCValue (e : ErrorObj) : ofCValue (toCValue e) = some e := by
  obtain ⟨id, cd, sv, ms, lo, fi, ob, ss, sf, ex, ac, ca, re, rc⟩ := e
  simp [ofCValue, toCValue, fld, CValue.get?, decStr, decBool,
    decOpt_encOpt encStr decStr encStr_ne_null decStr_encStr,
    Severity.ofCValue_toCValue]

end ErrorObj

/-! ## Claims, certificates, intermediate artifacts -/

/-- A claim made by a proof. -/
structure Claim where
  /-- Identifier of the claim. -/
  id : String
  /-- The statement being claimed. -/
  statement : String
  /-- Status of the claim. -/
  status : Status
  deriving Repr, DecidableEq, Inhabited

namespace Claim

/-- Encode a claim. -/
def toCValue (c : Claim) : CValue :=
  .obj [("id", .str c.id), ("statement", .str c.statement), ("status", c.status.toCValue)]

/-- Decode a claim. -/
def ofCValue (v : CValue) : Option Claim := do
  let id ← decStr (← fld v "id")
  let st ← decStr (← fld v "statement")
  let s ← Status.ofCValue (← fld v "status")
  some ⟨id, st, s⟩

theorem ofCValue_toCValue (c : Claim) : ofCValue (toCValue c) = some c := by
  obtain ⟨id, st, s⟩ := c
  simp [ofCValue, toCValue, fld, CValue.get?, decStr, Status.ofCValue_toCValue]

end Claim

/-- A certificate accompanying an output. -/
structure Certificate where
  /-- Identifier of the certificate. -/
  id : String
  /-- What kind of certificate this is. -/
  kind : String
  /-- The certificate payload. -/
  value : CValue
  deriving Repr, DecidableEq, Inhabited

namespace Certificate

/-- Encode a certificate. -/
def toCValue (c : Certificate) : CValue :=
  .obj [("id", .str c.id), ("kind", .str c.kind), ("value", c.value)]

/-- Decode a certificate. -/
def ofCValue (v : CValue) : Option Certificate := do
  let id ← decStr (← fld v "id")
  let kd ← decStr (← fld v "kind")
  let vl ← fld v "value"
  some ⟨id, kd, vl⟩

theorem ofCValue_toCValue (c : Certificate) : ofCValue (toCValue c) = some c := by
  obtain ⟨id, kd, vl⟩ := c
  simp [ofCValue, toCValue, fld, CValue.get?, decStr]

end Certificate

/-- An intermediate proof artifact. -/
structure Artifact where
  /-- Identifier of the artifact. -/
  id : String
  /-- What kind of artifact this is. -/
  kind : String
  /-- The artifact payload. -/
  value : CValue
  deriving Repr, DecidableEq, Inhabited

namespace Artifact

/-- Encode an intermediate artifact. -/
def toCValue (a : Artifact) : CValue :=
  .obj [("id", .str a.id), ("kind", .str a.kind), ("value", a.value)]

/-- Decode an intermediate artifact. -/
def ofCValue (v : CValue) : Option Artifact := do
  let id ← decStr (← fld v "id")
  let kd ← decStr (← fld v "kind")
  let vl ← fld v "value"
  some ⟨id, kd, vl⟩

theorem ofCValue_toCValue (a : Artifact) : ofCValue (toCValue a) = some a := by
  obtain ⟨id, kd, vl⟩ := a
  simp [ofCValue, toCValue, fld, CValue.get?, decStr]

end Artifact

/-! ## The canonical proof object (SOP §3) -/

/-- The canonical proof object: the authoritative interchange representation of
a proof with inputs and outputs. -/
structure ProofObject where
  /-- Stable identifier. -/
  id : String
  /-- Schema version this object conforms to. -/
  version : String
  /-- What kind of proof object this is. -/
  kind : String
  /-- Inputs consumed. -/
  inputs : List Input
  /-- Assumptions relied on. -/
  assumptions : List String
  /-- Parameters of the procedure. -/
  parameters : List (String × CValue)
  /-- The procedure that was run. -/
  procedure : Option String
  /-- Intermediate artifacts. -/
  intermediate : List Artifact
  /-- Outputs produced. -/
  outputs : List Output
  /-- Claims made. -/
  claims : List Claim
  /-- Certificates supplied. -/
  certificates : List Certificate
  /-- Errors. -/
  errors : List ErrorObj
  /-- Warnings. -/
  warnings : List ErrorObj
  /-- Provenance. -/
  provenance : Option Provenance
  /-- Free-form metadata. -/
  metadata : List (String × CValue)
  /-- The format the object was imported from. -/
  source_format : Option String
  /-- The original source text, preserved verbatim (SOP §10, §26). -/
  source_data : Option String
  /-- Status. -/
  status : Status
  /-- Constructs with no canonical equivalent, preserved (SOP §30). -/
  extensions : List (String × CValue)
  deriving Repr, DecidableEq, Inhabited

namespace ProofObject

/-- Encode a proof object as a canonical value. -/
def toCValue (p : ProofObject) : CValue :=
  .obj [("id", .str p.id), ("version", .str p.version), ("kind", .str p.kind),
        ("inputs", encL Input.toCValue p.inputs),
        ("assumptions", encL encStr p.assumptions),
        ("parameters", encTable p.parameters),
        ("procedure", encOpt encStr p.procedure),
        ("intermediate", encL Artifact.toCValue p.intermediate),
        ("outputs", encL Output.toCValue p.outputs),
        ("claims", encL Claim.toCValue p.claims),
        ("certificates", encL Certificate.toCValue p.certificates),
        ("errors", encL ErrorObj.toCValue p.errors),
        ("warnings", encL ErrorObj.toCValue p.warnings),
        ("provenance", encOpt Provenance.toCValue p.provenance),
        ("metadata", encTable p.metadata),
        ("source_format", encOpt encStr p.source_format),
        ("source_data", encOpt encStr p.source_data),
        ("status", p.status.toCValue),
        ("extensions", encTable p.extensions)]

/-- Decode a proof object from a canonical value. -/
def ofCValue (v : CValue) : Option ProofObject := do
  let id ← decStr (← fld v "id")
  let ver ← decStr (← fld v "version")
  let kind ← decStr (← fld v "kind")
  let ins ← decL Input.ofCValue (← fld v "inputs")
  let asm ← decL decStr (← fld v "assumptions")
  let par ← decTable (← fld v "parameters")
  let prc ← decOpt decStr (← fld v "procedure")
  let itm ← decL Artifact.ofCValue (← fld v "intermediate")
  let outs ← decL Output.ofCValue (← fld v "outputs")
  let cls ← decL Claim.ofCValue (← fld v "claims")
  let crt ← decL Certificate.ofCValue (← fld v "certificates")
  let ers ← decL ErrorObj.ofCValue (← fld v "errors")
  let wrn ← decL ErrorObj.ofCValue (← fld v "warnings")
  let pv ← decOpt Provenance.ofCValue (← fld v "provenance")
  let md ← decTable (← fld v "metadata")
  let sfmt ← decOpt decStr (← fld v "source_format")
  let sdat ← decOpt decStr (← fld v "source_data")
  let st ← Status.ofCValue (← fld v "status")
  let ext ← decTable (← fld v "extensions")
  some ⟨id, ver, kind, ins, asm, par, prc, itm, outs, cls, crt, ers, wrn, pv, md,
        sfmt, sdat, st, ext⟩

/-- The canonical proof object survives being written down as a canonical value
(SOP §3, §17). -/
theorem ofCValue_toCValue (p : ProofObject) : ofCValue (toCValue p) = some p := by
  obtain ⟨id, ver, kind, ins, asm, par, prc, itm, outs, cls, crt, ers, wrn, pv, md,
    sfmt, sdat, st, ext⟩ := p
  simp [ofCValue, toCValue, fld, CValue.get?, decStr,
    decOpt_encOpt encStr decStr encStr_ne_null decStr_encStr,
    decL_encL encStr decStr decStr_encStr,
    decL_encL Input.toCValue Input.ofCValue Input.ofCValue_toCValue,
    decL_encL Artifact.toCValue Artifact.ofCValue Artifact.ofCValue_toCValue,
    decL_encL Output.toCValue Output.ofCValue Output.ofCValue_toCValue,
    decL_encL Claim.toCValue Claim.ofCValue Claim.ofCValue_toCValue,
    decL_encL Certificate.toCValue Certificate.ofCValue Certificate.ofCValue_toCValue,
    decL_encL ErrorObj.toCValue ErrorObj.ofCValue ErrorObj.ofCValue_toCValue,
    decOpt_encOpt Provenance.toCValue Provenance.ofCValue Input.provenance_toCValue_ne_null
      Provenance.ofCValue_toCValue,
    decTable_encTable, Status.ofCValue_toCValue]

/-- The minimal interchange profile (SOP §31). -/
def hasMinimalProfile (v : CValue) : Bool :=
  (fld v "id").isSome && (fld v "kind").isSome && (fld v "inputs").isSome &&
  (fld v "outputs").isSome && (fld v "status").isSome && (fld v "errors").isSome &&
  (fld v "metadata").isSome

/-- Every encoded proof object satisfies the minimal interchange profile. -/
theorem hasMinimalProfile_toCValue (p : ProofObject) :
    hasMinimalProfile (toCValue p) = true := by
  simp [hasMinimalProfile, toCValue, fld, CValue.get?]

/-- Content identity of a proof object (SOP §16). -/
def hash (p : ProofObject) : Nat := CValue.hash (toCValue p)

/-- Canonical serialization of a proof object. -/
def serialize (p : ProofObject) : String := CValue.serialize (toCValue p)

/-- An empty object of the given identity and kind, with everything else
omitted: the smallest legal proof object (SOP §31). -/
def minimal (id kind : String) (status : Status) : ProofObject :=
  { id := id, version := "proof-schema/1.0", kind := kind, inputs := [], assumptions := [],
    parameters := [], procedure := none, intermediate := [], outputs := [], claims := [],
    certificates := [], errors := [], warnings := [], provenance := none, metadata := [],
    source_format := none, source_data := none, status := status, extensions := [] }

end ProofObject

/-! ## The exchange envelope (SOP §19) -/

/-- What was exchanged, between whom, and what happened in transport. -/
structure Envelope where
  /-- Schema version of the payload. -/
  schema_version : String
  /-- Version of the codec that produced the envelope. -/
  codec_version : String
  /-- Sending system. -/
  source : String
  /-- Receiving system. -/
  destination : String
  /-- When the envelope was produced. -/
  timestamp : String
  /-- Identifier of the payload object. -/
  object_id : String
  /-- The proof object being exchanged. -/
  payload : ProofObject
  /-- Diagnostics raised in transport. -/
  diagnostics : List ErrorObj
  /-- Transformations applied in transport (SOP §21). -/
  transformations : List Transformation
  /-- Canonical hash of the payload. -/
  integrity : Nat
  deriving Repr, DecidableEq, Inhabited

namespace Envelope

/-- Encode an envelope. Inputs, outputs, claims and certificates are surfaced
at the envelope level as the specification requires, taken from the payload. -/
def toCValue (e : Envelope) : CValue :=
  .obj [("schema_version", .str e.schema_version),
        ("codec_version", .str e.codec_version),
        ("source", .str e.source), ("destination", .str e.destination),
        ("timestamp", .str e.timestamp), ("object_id", .str e.object_id),
        ("payload", ProofObject.toCValue e.payload),
        ("inputs", encL Input.toCValue e.payload.inputs),
        ("outputs", encL Output.toCValue e.payload.outputs),
        ("claims", encL Claim.toCValue e.payload.claims),
        ("certificates", encL Certificate.toCValue e.payload.certificates),
        ("diagnostics", encL ErrorObj.toCValue e.diagnostics),
        ("transformations", encL Transformation.toCValue e.transformations),
        ("integrity", .int (e.integrity : Int))]

/-- Decode an envelope. -/
def ofCValue (v : CValue) : Option Envelope := do
  let sv ← decStr (← fld v "schema_version")
  let cv ← decStr (← fld v "codec_version")
  let sc ← decStr (← fld v "source")
  let ds ← decStr (← fld v "destination")
  let ts ← decStr (← fld v "timestamp")
  let oi ← decStr (← fld v "object_id")
  let pl ← ProofObject.ofCValue (← fld v "payload")
  let dg ← decL ErrorObj.ofCValue (← fld v "diagnostics")
  let tr ← decL Transformation.ofCValue (← fld v "transformations")
  let ig ← Transformation.decNat (← fld v "integrity")
  some ⟨sv, cv, sc, ds, ts, oi, pl, dg, tr, ig⟩

theorem ofCValue_toCValue (e : Envelope) : ofCValue (toCValue e) = some e := by
  obtain ⟨sv, cv, sc, ds, ts, oi, pl, dg, tr, ig⟩ := e
  simp [ofCValue, toCValue, fld, CValue.get?, decStr, Transformation.decNat,
    ProofObject.ofCValue_toCValue,
    decL_encL ErrorObj.toCValue ErrorObj.ofCValue ErrorObj.ofCValue_toCValue,
    decL_encL Transformation.toCValue Transformation.ofCValue
      Transformation.ofCValue_toCValue]

/-- Seal a proof object into an envelope, recording its canonical hash. -/
def sealObject (schema codec src dst ts : String) (p : ProofObject)
    (diagnostics : List ErrorObj) (transformations : List Transformation) : Envelope :=
  { schema_version := schema, codec_version := codec, source := src, destination := dst,
    timestamp := ts, object_id := p.id, payload := p, diagnostics := diagnostics,
    transformations := transformations, integrity := ProofObject.hash p }

/-- A sealed envelope carries the hash of exactly the payload it carries. -/
theorem integrity_seal (schema codec src dst ts : String) (p : ProofObject)
    (d : List ErrorObj) (t : List Transformation) :
    (sealObject schema codec src dst ts p d t).integrity =
      ProofObject.hash (sealObject schema codec src dst ts p d t).payload := rfl

end Envelope
end Codec
