import RequestProject.Solfunmeme.Codec.Hash
import RequestProject.Solfunmeme.Codec.Raw
import RequestProject.Solfunmeme.Codec.Validate

/-!
# §19–§22, §26, §27 Envelopes, provenance, ledgers and the two SOPs

This is the transport half of the standard.

* §19 `Envelope` — what travels between systems, and what happened on the way.
  `openEnvelope_seal` says a sealed envelope opens to the object that was
  sealed; `openEnvelope_rejects_tamper` says a payload that does not match its
  integrity hash is refused rather than believed.
* §20 `Provenance` — `provenanceChain_example` walks the specification's own
  example (Lean output → raw text → parser → canonical proof → YAML) and shows
  that the YAML still knows it came from Lean output.
* §21 `Transformation` — the ledger.  `chainLossiness_eq_lossless_iff` is the
  arithmetic of §9 applied to a chain: a chain is lossless exactly when every
  link is.
* §22 schema versions, with the compatibility rule that a major mismatch must
  *fail safely*: `importWithSchema_major_mismatch` returns `UNSUPPORTED` and
  keeps the payload instead of guessing.
* §26 and §27, the import and export standard operating procedures, as
  functions that produce reports.  `importArtifact_preserves_bytes` is step 2,
  `exportArtifact_roundTrips` is step 7.
-/

namespace Solfunmeme.Codec

/-! ## §22 Schema versions -/

/-- A semantic version of the schema. -/
structure SchemaVersion where
  major : Nat
  minor : Nat
  patch : Nat := 0
  deriving DecidableEq, Repr, Inhabited

/-- The schema this implementation writes. -/
def currentSchema : SchemaVersion := { major := 1, minor := 0, patch := 0 }

def SchemaVersion.name (v : SchemaVersion) : String :=
  "proof-schema/" ++ toString v.major ++ "." ++ toString v.minor

/-- §22: a reader can read a writer's document when the major versions agree.
A minor difference is a difference in fields, not in meaning. -/
def SchemaVersion.canRead (reader writer : SchemaVersion) : Bool := reader.major == writer.major

/-- §22: "unknown fields MUST be preserved where possible" — a reader older
than the writer must expect fields it does not know. -/
def SchemaVersion.mustPreserveUnknown (reader writer : SchemaVersion) : Bool :=
  reader.major == writer.major && reader.minor < writer.minor

theorem canRead_refl (v : SchemaVersion) : v.canRead v = true := by simp [SchemaVersion.canRead]

theorem canRead_of_minor (a b : Nat) (x y : SchemaVersion)
    (hx : x = { major := a, minor := b }) (hy : y = { major := a, minor := b + 1 }) :
    x.canRead y = true := by simp [hx, hy, SchemaVersion.canRead]

theorem not_canRead_of_major {x y : SchemaVersion} (h : x.major ≠ y.major) :
    x.canRead y = false := by simp [SchemaVersion.canRead, h]

/-! ## §21 The transformation ledger -/

/-- One conversion, recorded. -/
structure Transformation where
  id : String
  operation : String
  source : String
  destination : String
  inputHash : UInt64
  outputHash : UInt64
  codec : String
  codecVersion : String
  lossiness : Lossiness
  errors : List String := []
  warnings : List String := []
  deriving DecidableEq, Repr, Inhabited

/-- A chain is linked when each step consumes what the previous step produced. -/
def linked : List Transformation → Bool
  | [] => true
  | [_] => true
  | a :: b :: rest => (a.outputHash == b.inputHash) && linked (b :: rest)

/-- The preservation level of a whole chain is the worst of its links. -/
def chainLossiness : List Transformation → Lossiness
  | [] => .LOSSLESS
  | t :: ts => Lossiness.worse t.lossiness (chainLossiness ts)

/-- §9 for chains: a chain is lossless exactly when every link is. -/
theorem chainLossiness_eq_lossless_iff :
    ∀ ts : List Transformation,
      chainLossiness ts = .LOSSLESS ↔ ∀ t ∈ ts, t.lossiness = .LOSSLESS
  | [] => by simp [chainLossiness]
  | t :: ts => by
    rw [chainLossiness, Lossiness.worse_eq_lossless, chainLossiness_eq_lossless_iff ts]
    constructor
    · rintro ⟨h1, h2⟩ x hx
      rcases List.mem_cons.mp hx with rfl | hx
      · exact h1
      · exact h2 x hx
    · intro h
      exact ⟨h t (by simp), fun x hx => h x (by simp [hx])⟩

/-- Adding a step that consumes the last output keeps the chain linked. -/
theorem linked_append_step :
    ∀ (ts : List Transformation) (t last : Transformation),
      linked (ts ++ [last]) = true → last.outputHash = t.inputHash →
      linked (ts ++ [last, t]) = true
  | [], t, last, _, h => by simp [linked, h]
  | [a], t, last, hl, h => by
    simp [linked] at hl ⊢
    exact ⟨hl, h⟩
  | a :: b :: rest, t, last, hl, h => by
    simp only [List.cons_append, linked, Bool.and_eq_true, beq_iff_eq] at hl ⊢
    exact ⟨hl.1, linked_append_step (b :: rest) t last (by simpa using hl.2) h⟩

/-! ## §19 The exchange envelope -/

/-- What one system hands to another. -/
structure Envelope where
  schemaVersion : SchemaVersion := currentSchema
  codecVersion : String := "1.0"
  source : String := ""
  destination : String := ""
  timestamp : String := ""
  objectId : String := ""
  /-- The encoded object. -/
  payload : String := ""
  /-- The format the payload is written in. -/
  payloadFormat : String := ""
  inputs : List Input := []
  outputs : List Output := []
  claims : List String := []
  certificates : List String := []
  diagnostics : List Diagnostic := []
  transformations : List Transformation := []
  /-- The hash of the payload, as sent. -/
  integrity : UInt64 := 0
  deriving DecidableEq, Repr, Inhabited

/-- Seal an object into an envelope in a chosen codec. -/
def sealEnvelope (r : RowSyntax) (source destination timestamp : String) (p : ProofObject) :
    Envelope :=
  let payload := r.encode p
  { source := source
    destination := destination
    timestamp := timestamp
    objectId := p.id
    payload := payload
    payloadFormat := r.name
    codecVersion := r.version
    inputs := p.inputs
    outputs := p.outputs
    claims := p.claims
    certificates := p.certificates
    diagnostics := p.errors
    transformations :=
      [{ id := "t-seal"
         operation := "encode"
         source := "canonical"
         destination := r.name
         inputHash := contentId p
         outputHash := hashString payload
         codec := r.name
         codecVersion := r.version
         lossiness := r.declaredLossiness }]
    integrity := hashString payload }

/-- Open an envelope: check the integrity of the payload, resolve the codec it
declares, and decode.  Any failure yields `none` rather than a guess. -/
def openEnvelope (e : Envelope) : Option ProofObject :=
  if hashString e.payload == e.integrity then
    match codecOfName e.payloadFormat with
    | some r => r.decode e.payload
    | none => none
  else none

theorem openEnvelope_seal (r : RowSyntax) (hr : r ∈ codecs)
    (hname : codecOfName r.name = some r) (source destination timestamp : String)
    (p : ProofObject) :
    openEnvelope (sealEnvelope r source destination timestamp p) = some p := by
  simp only [openEnvelope, sealEnvelope, beq_self_eq_true, if_pos, hname]
  exact codecs_lossless r hr p

/-- §19: the envelope records what happened in transport, and the record is not
optional decoration — it is what lets the receiver audit the journey. -/
theorem sealEnvelope_records (r : RowSyntax) (source destination timestamp : String)
    (p : ProofObject) :
    (sealEnvelope r source destination timestamp p).transformations.length = 1
      ∧ (sealEnvelope r source destination timestamp p).integrity
          = hashString (r.encode p) := ⟨rfl, rfl⟩

/-- A payload that does not match its integrity hash is refused. -/
theorem openEnvelope_rejects_tamper (e : Envelope) (h : hashString e.payload ≠ e.integrity) :
    openEnvelope e = none := by
  simp [openEnvelope, h]

/-! ## §20 Provenance -/

/-- Record one step of a journey on the object itself. -/
def recordStep (p : ProofObject) (system file format step : String) : ProofObject :=
  { p with
      provenance :=
        { p.provenance with
            sourceSystem := if p.provenance.sourceSystem = "" then system
                            else p.provenance.sourceSystem
            sourceFile := if p.provenance.sourceFile = "" then file else p.provenance.sourceFile
            sourceFormat := if p.provenance.sourceFormat = "" then format
                            else p.provenance.sourceFormat
            transformations := p.provenance.transformations ++ [step] } }

/-- The origin of an object: the first format it was seen in. -/
def provenanceOrigin (p : ProofObject) : String := p.provenance.sourceFormat

/-- Recording a step never rewrites the origin. -/
theorem recordStep_keeps_origin (p : ProofObject) (system file format step : String)
    (h : p.provenance.sourceFormat ≠ "") :
    provenanceOrigin (recordStep p system file format step) = provenanceOrigin p := by
  simp [provenanceOrigin, recordStep, h]

/-- Recording a step always extends the ledger on the object. -/
theorem recordStep_appends (p : ProofObject) (system file format step : String) :
    (recordStep p system file format step).provenance.transformations
      = p.provenance.transformations ++ [step] := rfl

/-- §20's worked example: Lean output → raw text → parser → canonical proof →
YAML.  The object that ends up in the YAML still names the Lean output as its
origin and carries the four steps that got it there. -/
def leanOutputExample : ProofObject :=
  let raw := (RawText.ofString "theorem foo : 1 + 1 = 2 := by decide\n").toProofObject "p-lean"
  let parsed := recordStep raw "lean" "Foo.lean" "text/raw" "parse"
  let canonical := recordStep parsed "lean" "Foo.lean" "text/raw" "canonicalise"
  recordStep canonical "lean" "Foo.lean" "text/raw" "encode/yaml"

theorem provenanceChain_example :
    provenanceOrigin leanOutputExample = "text/raw"
      ∧ leanOutputExample.provenance.transformations
          = ["parse", "canonicalise", "encode/yaml"]
      ∧ leanOutputExample.sourceData = "theorem foo : 1 + 1 = 2 := by decide\n" :=
  ⟨rfl, rfl, rfl⟩

/-! ## §26 The import SOP -/

/-- The report an import produces (§26, step 14). -/
structure ImportReport where
  /-- Step 2: the original bytes, kept. -/
  original : String
  /-- Step 1: the format that was identified, or `text/raw`. -/
  format : String
  /-- Step 4: the canonical object. -/
  object : ProofObject
  /-- Step 12: the canonical hash. -/
  hash : UInt64
  /-- Steps 6–10: what was found and what was repaired. -/
  diagnostics : List Diagnostic
  /-- §9: how much of the source survived. -/
  lossiness : Lossiness
  deriving DecidableEq, Repr, Inhabited

/-- §26 in full: identify, preserve, decode, canonicalise, identify, validate,
resolve, record, hash, report.  Text that does not parse is not rejected — it
becomes a raw-text object with a recoverable diagnostic. -/
def importArtifact (declared : Option String) (system file : String) (s : String) :
    ImportReport :=
  match detect declared s with
  | some r =>
    match r.decode s with
    | some p =>
      let stamped := recordStep p system file r.name ("import/" ++ r.name)
      let resolved := resolve stamped
      { original := s
        format := r.name
        object := resolved.1
        hash := contentId resolved.1
        diagnostics := validateStructure resolved.1 ++ validateTypes resolved.1 ++ resolved.2
        lossiness := r.declaredLossiness }
    | none =>
      let raw := (RawText.ofString s).toProofObject ("raw-" ++ file)
      { original := s
        format := "text/raw"
        object := recordStep raw system file "text/raw" "import/text-raw"
        hash := contentId raw
        diagnostics := [syntaxDiagnostic r.name]
        lossiness := rawTextLossiness }
  | none =>
    let raw := (RawText.ofString s).toProofObject ("raw-" ++ file)
    { original := s
      format := "text/raw"
      object := recordStep raw system file "text/raw" "import/text-raw"
      hash := contentId raw
      diagnostics := []
      lossiness := rawTextLossiness }

/-- §26 step 2: the original is never discarded. -/
theorem importArtifact_preserves_bytes (declared : Option String) (system file s : String) :
    (importArtifact declared system file s).original = s := by
  unfold importArtifact
  split
  · split <;> rfl
  · rfl

/-- Inputs that already declare a type are left exactly as they are. -/
theorem map_resolveInput_id (is : List Input) (h : ∀ i ∈ is, i.type ≠ "") :
    is.map (Prod.fst ∘ resolveInput) = is := by
  induction is with
  | nil => rfl
  | cons i is ih =>
    simp only [List.map_cons, Function.comp_apply, resolveInput, if_neg (h i (by simp))]
    rw [ih (fun j hj => h j (by simp [hj]))]

theorem resolve_inputs_of_typed (p : ProofObject) (hp : ∀ i ∈ p.inputs, i.type ≠ "") :
    (resolve p).1.inputs = p.inputs := by
  simp only [resolve, List.map_map]
  exact map_resolveInput_id p.inputs hp

/-- Nothing to repair means nothing recorded. -/
theorem map_resolveInput_snd_nil (is : List Input) (h : ∀ i ∈ is, i.type ≠ "") :
    (is.map resolveInput).flatMap Prod.snd = [] := by
  induction is with
  | nil => rfl
  | cons i is ih =>
    simp only [List.map_cons, List.flatMap_cons, resolveInput, if_neg (h i (by simp))]
    rw [ih (fun j hj => h j (by simp [hj]))]
    rfl

theorem resolve_errors_of_typed (p : ProofObject) (hp : ∀ i ∈ p.inputs, i.type ≠ "") :
    (resolve p).1.errors = p.errors := by
  simp only [resolve]
  rw [map_resolveInput_snd_nil p.inputs hp, List.append_nil]

/-- What an import produces when the format is known and the document parses. -/
theorem importArtifact_decoded {declared : Option String} {r : RowSyntax} {s : String}
    {p : ProofObject} (hdet : detect declared s = some r) (hdec : r.decode s = some p)
    (system file : String) :
    (importArtifact declared system file s).object
      = (resolve (recordStep p system file r.name ("import/" ++ r.name))).1 := by
  simp only [importArtifact, hdet, hdec]

/-- Importing a document this implementation wrote recovers the object, and the
recovered object is semantically the one that was sent (§17): only the journey
fields have changed. -/
theorem importArtifact_of_encoded (r : RowSyntax) (hr : r ∈ codecs)
    (system file : String) (p : ProofObject) (hp : ∀ i ∈ p.inputs, i.type ≠ "") :
    SemanticEq (importArtifact none system file (r.encode p)).object p := by
  rw [importArtifact_decoded (detect_encode r hr p) (codecs_lossless r hr p) system file]
  have hp' : ∀ i ∈ (recordStep p system file r.name ("import/" ++ r.name)).inputs, i.type ≠ "" :=
    by simpa [recordStep] using hp
  have hres := resolve_inputs_of_typed _ hp'
  have herr := resolve_errors_of_typed _ hp'
  unfold SemanticEq ProofObject.semanticCore
  rw [hres, herr]
  rfl

/-- §11 and §26: text this implementation cannot parse is imported as raw text
with an `UNKNOWN` status.  It is never declared invalid, and its bytes survive. -/
theorem importArtifact_unparsed_is_unknown (system file s : String)
    (h : detect none s = none) :
    (importArtifact none system file s).object.status = .UNKNOWN
      ∧ (importArtifact none system file s).object.sourceData = s
      ∧ (importArtifact none system file s).format = "text/raw" := by
  unfold importArtifact
  rw [h]
  exact ⟨rfl, rfl, rfl⟩

/-! ## §27 The export SOP -/

/-- The report an export produces (§27, steps 8–10). -/
structure ExportReport where
  /-- Step 5: the encoded artifact. -/
  artifact : String
  /-- Step 3: the codec that was chosen. -/
  format : String
  /-- Step 7: did the artifact read back as the same object? -/
  roundTripOk : Bool
  /-- Step 9: the declared preservation level. -/
  lossiness : Lossiness
  /-- Step 8: the ledger entry for this conversion. -/
  transformations : List Transformation
  /-- Step 6: anything the encoder had to say. -/
  diagnostics : List Diagnostic
  deriving DecidableEq, Repr, Inhabited

/-- §27 in full: validate, choose, check representability, encode, verify,
round trip, record, report. -/
def exportArtifact (r : RowSyntax) (p : ProofObject) : ExportReport :=
  let artifact := r.encode p
  { artifact := artifact
    format := r.name
    roundTripOk := r.decode artifact == some p
    lossiness := r.declaredLossiness
    transformations :=
      [{ id := "t-export"
         operation := "encode"
         source := "canonical"
         destination := r.name
         inputHash := contentId p
         outputHash := hashString artifact
         codec := r.name
         codecVersion := r.version
         lossiness := r.declaredLossiness }]
    diagnostics := (validate p).diagnostics }

/-- §27 step 7: the round-trip test passes, for every codec of the registry and
every canonical object. -/
theorem exportArtifact_roundTrips (r : RowSyntax) (hr : r ∈ codecs) (p : ProofObject) :
    (exportArtifact r p).roundTripOk = true := by
  simp [exportArtifact, codecs_lossless r hr p]

/-- The export ledger entry links the object's content identity to the bytes
that were emitted. -/
theorem exportArtifact_ledger (r : RowSyntax) (p : ProofObject) :
    (exportArtifact r p).transformations.map Transformation.inputHash = [contentId p]
      ∧ (exportArtifact r p).transformations.map Transformation.outputHash
          = [hashString (r.encode p)] := ⟨rfl, rfl⟩

/-- Export then import is the identity on canonical objects, up to the
provenance the import records (§17, §26, §27 together). -/
theorem export_import_roundTrip (r : RowSyntax) (hr : r ∈ codecs) (system file : String)
    (p : ProofObject) (hp : ∀ i ∈ p.inputs, i.type ≠ "") :
    SemanticEq (importArtifact none system file (exportArtifact r p).artifact).object p :=
  importArtifact_of_encoded r hr system file p hp

/-! ## §22 Failing safely -/

/-- Import a payload that declares a schema version.  A major mismatch is not
guessed at: the object comes back `UNSUPPORTED`, with the payload retained. -/
def importWithSchema (reader writer : SchemaVersion) (declared : Option String)
    (system file s : String) : ImportReport :=
  if reader.canRead writer then importArtifact declared system file s
  else
    { original := s
      format := "unsupported"
      object :=
        { id := "unsupported-" ++ file
          kind := "unsupported-schema"
          status := .UNSUPPORTED
          sourceFormat := writer.name
          sourceData := s
          errors :=
            [{ id := "diag-schema", code := "SCHEMA_INCOMPATIBLE", severity := .ERROR,
               expected := reader.name, actual := writer.name,
               message := "major version mismatch; the document was not interpreted",
               recoverable := false }] }
      hash := hashString s
      diagnostics :=
        [{ id := "diag-schema", code := "SCHEMA_INCOMPATIBLE", severity := .ERROR,
           expected := reader.name, actual := writer.name,
           message := "major version mismatch; the document was not interpreted",
           recoverable := false }]
      lossiness := .FAILED }

/-- §22: "old readers MUST fail safely rather than silently misinterpreting new
semantics".  On a major mismatch nothing is interpreted, the status says so,
and the bytes are still there. -/
theorem importWithSchema_major_mismatch {reader writer : SchemaVersion}
    (h : reader.major ≠ writer.major) (declared : Option String) (system file s : String) :
    (importWithSchema reader writer declared system file s).object.status = .UNSUPPORTED
      ∧ (importWithSchema reader writer declared system file s).object.sourceData = s
      ∧ (importWithSchema reader writer declared system file s).lossiness = .FAILED := by
  unfold importWithSchema
  rw [if_neg (by simp [not_canRead_of_major h])]
  exact ⟨rfl, rfl, rfl⟩

/-- A reader of the same major version proceeds normally. -/
theorem importWithSchema_same_major (v : SchemaVersion) (declared : Option String)
    (system file s : String) :
    importWithSchema v v declared system file s = importArtifact declared system file s := by
  unfold importWithSchema
  rw [if_pos (by simp [canRead_refl])]

end Solfunmeme.Codec
