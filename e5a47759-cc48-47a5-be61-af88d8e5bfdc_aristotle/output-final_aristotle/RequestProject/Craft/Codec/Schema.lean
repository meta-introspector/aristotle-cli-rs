/-
# Standard Proof Codec — schema evolution and unknown data (SOP §22, §30, §32)

Schemas are versioned, and the compatibility rules are the usual ones: a patch
difference never matters, a minor difference only ever adds backward-compatible
fields, and a major difference is an incompatible semantic change that an old
reader must refuse rather than misinterpret.

Unknown data survives: `importPreservingUnknown` keeps every field the reader
does not recognise in the extension namespace, and `unknown_field_preserved`
proves it.
-/
import RequestProject.Craft.Codec.Model
import RequestProject.Craft.Codec.Validate

namespace Codec
namespace Schema

open Codec.Enc

/-! ## Versions (SOP §22) -/

/-- A schema version. -/
structure Version where
  /-- Incompatible semantic change. -/
  major : Nat
  /-- Backward-compatible field addition. -/
  minor : Nat
  /-- Bug fix or clarification. -/
  patch : Nat
  deriving Repr, DecidableEq, Inhabited

namespace Version

/-- The printed name of a version, e.g. `proof-schema/1.1`. -/
def toName (v : Version) : String :=
  "proof-schema/" ++ String.ofList (CValue.encNat v.major) ++ "." ++
    String.ofList (CValue.encNat v.minor)

/-- The version this codec implements. -/
def current : Version := ⟨1, 0, 0⟩

end Version

/-- The verdict of a compatibility check. -/
inductive Compat where
  /-- The reader understands everything the writer could have produced. -/
  | COMPATIBLE
  /-- The reader is older: it may meet fields it does not know, which it must
  preserve rather than reinterpret. -/
  | FORWARD_UNKNOWN
  /-- Major versions differ: the reader must refuse. -/
  | INCOMPATIBLE
  deriving Repr, DecidableEq, Inhabited

/-- Compatibility of a reader with a document written against `writer`. -/
def compatibility (reader writer : Version) : Compat :=
  if reader.major ≠ writer.major then Compat.INCOMPATIBLE
  else if writer.minor ≤ reader.minor then Compat.COMPATIBLE
  else Compat.FORWARD_UNKNOWN

/-- A reader always understands its own version. -/
theorem compatibility_refl (v : Version) : compatibility v v = Compat.COMPATIBLE := by
  simp [compatibility]

/-- A patch difference never changes compatibility. -/
theorem compatibility_patch_irrelevant (reader writer : Version) (q : Nat) :
    compatibility reader { writer with patch := q } = compatibility reader writer := rfl

/-- A newer reader reads older documents of the same major version. -/
theorem compatibility_minor_backward (reader writer : Version)
    (hmaj : reader.major = writer.major) (hmin : writer.minor ≤ reader.minor) :
    compatibility reader writer = Compat.COMPATIBLE := by
  simp [compatibility, hmaj, hmin]

/-- An older reader meeting a newer minor version does not claim to understand
it: it reports that unknown material may be present. -/
theorem compatibility_minor_forward (reader writer : Version)
    (hmaj : reader.major = writer.major) (hmin : reader.minor < writer.minor) :
    compatibility reader writer = Compat.FORWARD_UNKNOWN := by
  simp [compatibility, hmaj, Nat.not_le.mpr hmin]

/-- A major difference is always incompatible: an old reader fails safe rather
than silently misinterpreting new semantics. -/
theorem compatibility_major_incompatible (reader writer : Version)
    (hmaj : reader.major ≠ writer.major) :
    compatibility reader writer = Compat.INCOMPATIBLE := by
  simp [compatibility, hmaj]

/-! ## Unknown data (SOP §30) -/

/-- The fields of the canonical proof object this schema version defines. -/
def knownFields : List String :=
  ["id", "version", "kind", "inputs", "assumptions", "parameters", "procedure",
   "intermediate", "outputs", "claims", "certificates", "errors", "warnings",
   "provenance", "metadata", "source_format", "source_data", "status", "extensions"]

/-- The fields of a canonical value this schema version does not define. -/
def unknownFields : CValue → List (String × CValue)
  | .obj fs => fs.filter (fun kv => !knownFields.contains kv.1)
  | _ => []

/-- Append a field to a canonical object, as a newer writer would. -/
def withExtraField (v : CValue) (k : String) (w : CValue) : CValue :=
  match v with
  | .obj fs => .obj (fs ++ [(k, w)])
  | _ => v

/-- Import an object, keeping every field the reader does not recognise in the
extension namespace: unknown does not mean discardable (SOP §30). -/
def importPreservingUnknown (v : CValue) : Option ProofObject :=
  (ProofObject.ofCValue v).map (fun p => { p with extensions := p.extensions ++ unknownFields v })

/-- A field a newer writer added is still there after import, in the extension
namespace, and the rest of the object is unaffected (SOP §22, §30). -/
theorem unknown_field_preserved (p : ProofObject) (k : String) (w : CValue)
    (hk : k ∉ knownFields) :
    ∃ q, importPreservingUnknown (withExtraField (ProofObject.toCValue p) k w) = some q ∧
      (k, w) ∈ q.extensions ∧ q.id = p.id ∧ q.inputs = p.inputs ∧ q.outputs = p.outputs ∧
      q.status = p.status := by
  have hdec : ProofObject.ofCValue (withExtraField (ProofObject.toCValue p) k w) = some p := by
    obtain ⟨id, ver, kind, ins, asm, par, prc, itm, outs, cls, crt, ers, wrn, pv, md,
      sfmt, sdat, st, ext⟩ := p
    simp [withExtraField, ProofObject.toCValue, ProofObject.ofCValue, fld, CValue.get?,
      decStr, decOpt_encOpt encStr decStr encStr_ne_null decStr_encStr,
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
  have hmem : (k, w) ∈ unknownFields (withExtraField (ProofObject.toCValue p) k w) := by
    simp only [knownFields, List.mem_cons, List.not_mem_nil] at hk
    push_neg at hk
    simp [withExtraField, ProofObject.toCValue, unknownFields, knownFields, hk]
  refine ⟨{ p with
              extensions := p.extensions ++
                unknownFields (withExtraField (ProofObject.toCValue p) k w) },
    by simp [importPreservingUnknown, hdec], ?_, rfl, rfl, rfl, rfl⟩
  simpa using Or.inr hmem

/-! ## Reading a document written against another version -/

/-- The diagnostic an old reader emits when it meets an incompatible major
version. -/
def incompatibleError (objId : String) (reader writer : Version) : ErrorObj :=
  { id := objId ++ ":schema",
    code := "SCHEMA_INCOMPATIBLE",
    severity := Severity.FATAL,
    message := "the document was written against an incompatible schema version",
    location := none,
    field := some "version",
    object_id := some objId,
    source_system := none,
    source_format := none,
    expected := some reader.toName,
    actual := some writer.toName,
    cause := some "major version change",
    resolution := some "the object was preserved but not interpreted",
    recoverable := false }

/-- Read a document written against `writer`. An incompatible major version is
refused with a diagnostic rather than misread; a newer minor version is read
with its unknown fields preserved. -/
def readAs (objId : String) (reader writer : Version) (v : CValue) :
    Except ErrorObj ProofObject :=
  match compatibility reader writer with
  | Compat.INCOMPATIBLE => .error (incompatibleError objId reader writer)
  | _ =>
      match importPreservingUnknown v with
      | some p => .ok p
      | none => .error (Validate.syntaxError objId)

/-- An old reader refuses a major version change instead of guessing. -/
theorem readAs_major_refused (objId : String) (reader writer : Version)
    (hmaj : reader.major ≠ writer.major) (v : CValue) :
    readAs objId reader writer v = .error (incompatibleError objId reader writer) := by
  simp [readAs, compatibility_major_incompatible reader writer hmaj]

/-- Within a major version a document is read, and any field the reader does
not know is preserved rather than dropped. -/
theorem readAs_minor_preserves_unknown (objId : String) (reader writer : Version)
    (hmaj : reader.major = writer.major) (p : ProofObject) (k : String) (w : CValue)
    (hk : k ∉ knownFields) :
    ∃ q, readAs objId reader writer (withExtraField (ProofObject.toCValue p) k w) = .ok q ∧
      (k, w) ∈ q.extensions := by
  obtain ⟨q, hq, hmem, _⟩ := unknown_field_preserved p k w hk
  refine ⟨q, ?_, hmem⟩
  unfold readAs
  cases hc : compatibility reader writer with
  | COMPATIBLE => simp [hq]
  | FORWARD_UNKNOWN => simp [hq]
  | INCOMPATIBLE =>
      rw [compatibility] at hc
      simp [hmaj] at hc
      split at hc <;> simp_all

/-! ## Conformance levels (SOP §32) -/

/-- The conformance levels of the specification. -/
inductive Conformance where
  /-- Level 0 — Raw: can preserve and exchange arbitrary text. -/
  | RAW
  /-- Level 1 — Structured: can import and export canonical objects. -/
  | STRUCTURED
  /-- Level 2 — Typed: supports schemas, types, inputs, outputs and errors. -/
  | TYPED
  /-- Level 3 — Proof-aware: can validate proof inputs and outputs. -/
  | PROOF_AWARE
  /-- Level 4 — Reconciliation: can compare independent results and resolve
  conflicts. -/
  | RECONCILIATION
  /-- Level 5 — Auditable: provenance, deterministic serialization, hashing,
  transformation ledgers and reproducible exchange. -/
  | AUDITABLE
  deriving Repr, DecidableEq, Inhabited

namespace Conformance

/-- Name of a conformance level. -/
def toName : Conformance → String
  | .RAW => "Level 0 — Raw"
  | .STRUCTURED => "Level 1 — Structured"
  | .TYPED => "Level 2 — Typed"
  | .PROOF_AWARE => "Level 3 — Proof-Aware"
  | .RECONCILIATION => "Level 4 — Reconciliation"
  | .AUDITABLE => "Level 5 — Auditable"

/-- Numeric level. -/
def index : Conformance → Nat
  | .RAW => 0
  | .STRUCTURED => 1
  | .TYPED => 2
  | .PROOF_AWARE => 3
  | .RECONCILIATION => 4
  | .AUDITABLE => 5

/-- The levels are linearly ordered by what they require. -/
theorem index_injective (a b : Conformance) (h : index a = index b) : a = b := by
  cases a <;> cases b <;> simp_all [index]

end Conformance

end Schema
end Codec
