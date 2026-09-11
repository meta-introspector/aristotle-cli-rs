/-
# Standard Proof Codec — the exchange pipeline (SOP §9, §19–§21, §26, §27, §36)

This module ties the adapters together.  A proof object is exported to a
target format, transported, and imported again; the canonical model is the only
thing the two ends have to agree on.

* `encodeDoc` / `decodeDoc` are the format-indexed adapters.
* `lossiness` declares the preservation level of each format, and
  `lossless_hash_stable` proves that a format declared `LOSSLESS` really does
  return a canonically identical object, so its content hash is unchanged.
* `importArtifact` implements the import SOP of §26 and `exportArtifact` the
  export SOP of §27, both producing transformation-ledger entries (§21) and
  provenance (§20).
* `definition_of_done` is the invariant of §36: a proof object exported to
  IPDL, XML, YAML, canonical text or CSV and imported by another system is
  reconstructed with the same semantics — exactly for the structured formats,
  up to canonical normalisation for text, and up to the documented tabular view
  for CSV.
-/
import RequestProject.Craft.Codec.Ipdl
import RequestProject.Craft.Codec.Xml
import RequestProject.Craft.Codec.Yaml
import RequestProject.Craft.Codec.Csv
import RequestProject.Craft.Codec.Text
import RequestProject.Craft.Codec.Validate

namespace Codec
namespace Pipeline

/-! ## Formats and documents -/

/-- The interchange formats this codec supports. -/
inductive Format where
  /-- The native structured interchange language (SOP §12). -/
  | IPDL
  /-- XML with namespaces, attributes and ordered children (SOP §13). -/
  | XML
  /-- The tabular projection (SOP §14). -/
  | CSV
  /-- The human-readable projection (SOP §15). -/
  | YAML
  /-- Raw text carrying a canonical block (SOP §10). -/
  | TEXT
  /-- The canonical serialization itself (SOP §16). -/
  | CANONICAL
  deriving Repr, DecidableEq, Inhabited

namespace Format

/-- Name of a format. -/
def toName : Format → String
  | .IPDL => "IPDL"
  | .XML => "XML"
  | .CSV => "CSV"
  | .YAML => "YAML"
  | .TEXT => "TEXT"
  | .CANONICAL => "CANONICAL"

end Format

/-- A document in one of the supported formats. -/
inductive Doc where
  /-- An IPDL term. -/
  | ipdl : Ipdl → Doc
  /-- An XML document. -/
  | xml : Xml → Doc
  /-- A YAML document. -/
  | yaml : Yaml → Doc
  /-- A CSV table of projection rows. -/
  | csv : List Csv.Row → Doc
  /-- Raw text. -/
  | text : String → Doc
  /-- A canonical value. -/
  | canonical : CValue → Doc
  deriving Repr, Inhabited

/-- Encode a proof object into a document of the given format. -/
def encodeDoc (f : Format) (p : ProofObject) : Doc :=
  match f with
  | .IPDL => .ipdl (Ipdl.encodeI (ProofObject.toCValue p))
  | .XML => .xml (Xml.encodeX (ProofObject.toCValue p))
  | .YAML => .yaml (Yaml.encodeY (ProofObject.toCValue p))
  | .CSV => .csv (Csv.toRows p)
  | .TEXT => .text (Text.emit (ProofObject.toCValue p))
  | .CANONICAL => .canonical (ProofObject.toCValue p)

/-- Decode a document back into the canonical model. Decoding is where all
format knowledge stops: everything downstream sees canonical values only. -/
def decodeDoc : Doc → Option CValue
  | .ipdl t => some (Ipdl.decodeI t)
  | .xml x => some (Xml.decodeX x)
  | .yaml y => some (Yaml.decodeY y)
  | .csv rows => (Csv.ofRows rows).map ProofObject.toCValue
  | .text s => Text.extract s
  | .canonical v => some v

/-- The rendered form of a document, for systems that exchange bytes. -/
def render : Doc → String
  | .ipdl t => Ipdl.render t
  | .xml x => Xml.render x
  | .yaml y => Yaml.render 0 y
  | .csv rows => String.ofList (Csv.renderTable (Csv.header :: rows.map Csv.Row.cells))
  | .text s => s
  | .canonical v => CValue.serialize v

/-! ## Declared preservation levels (SOP §9) -/

/-- The preservation level each format is allowed to claim. Only formats whose
round trip is proved to preserve the whole canonical object claim `LOSSLESS`. -/
def lossiness : Format → Lossiness
  | .CSV => Lossiness.PARTIAL
  | _ => Lossiness.LOSSLESS

/-- Every format except the tabular projection returns the canonical object
unchanged, up to canonical normalisation. -/
theorem decodeDoc_encodeDoc_semEq (f : Format) (hf : f ≠ Format.CSV) (p : ProofObject) :
    ∃ v, decodeDoc (encodeDoc f p) = some v ∧ CValue.semEq v (ProofObject.toCValue p) := by
  cases f with
  | IPDL =>
      exact ⟨_, by simp [encodeDoc, decodeDoc, Ipdl.decodeI_encodeI], CValue.semEq_refl _⟩
  | XML =>
      exact ⟨_, by simp [encodeDoc, decodeDoc, Xml.decodeX_encodeX], CValue.semEq_refl _⟩
  | YAML =>
      exact ⟨_, by simp [encodeDoc, decodeDoc, Yaml.decodeY_encodeY], CValue.semEq_refl _⟩
  | CSV => exact absurd rfl hf
  | TEXT =>
      exact ⟨CValue.normalize (ProofObject.toCValue p),
        by simp [encodeDoc, decodeDoc, Text.extract_emit],
        CValue.normalize_idem _⟩
  | CANONICAL => exact ⟨_, rfl, CValue.semEq_refl _⟩

/-- The structured formats return the canonical object literally. -/
theorem decodeDoc_encodeDoc_structured (f : Format)
    (hf : f = Format.IPDL ∨ f = Format.XML ∨ f = Format.YAML ∨ f = Format.CANONICAL)
    (p : ProofObject) : decodeDoc (encodeDoc f p) = some (ProofObject.toCValue p) := by
  rcases hf with rfl | rfl | rfl | rfl
  · simp [encodeDoc, decodeDoc, Ipdl.decodeI_encodeI]
  · simp [encodeDoc, decodeDoc, Xml.decodeX_encodeX]
  · simp [encodeDoc, decodeDoc, Yaml.decodeY_encodeY]
  · simp [encodeDoc, decodeDoc]

/-- A format that claims `LOSSLESS` keeps the content identity of the object:
its canonical hash is unchanged by the round trip (SOP §9, §16). -/
theorem lossless_hash_stable (f : Format) (hf : f ≠ Format.CSV) (p : ProofObject) :
    ∃ v, decodeDoc (encodeDoc f p) = some v ∧ CValue.hash v = ProofObject.hash p := by
  obtain ⟨v, hv, hsem⟩ := decodeDoc_encodeDoc_semEq f hf p
  exact ⟨v, hv, CValue.hash_congr hsem⟩

/-- The tabular projection is honestly declared `PARTIAL`: it cannot be
lossless, because objects differing outside its columns become the same
table (SOP §9, §14). -/
theorem csv_declared_partial :
    lossiness Format.CSV = Lossiness.PARTIAL ∧
      ∃ p₁ p₂ : ProofObject, p₁ ≠ p₂ ∧ encodeDoc Format.CSV p₁ = encodeDoc Format.CSV p₂ := by
  obtain ⟨p₁, p₂, hne, heq⟩ := Csv.csv_not_lossless
  exact ⟨rfl, p₁, p₂, hne, by simp [encodeDoc, heq]⟩

/-! ## Provenance (SOP §20) and the transformation ledger (SOP §21) -/

/-- Provenance for an artifact read from `f` by `system` at `ts`. -/
def importProvenance (system ts tid : String) (file : Option String) (f : Format)
    (parent : Option String) : Provenance :=
  { source_system := system, source_file := file, source_format := f.toName,
    imported_at := ts, transformed_at := none, transformations := [tid],
    parent_object := parent }

/-- Canonical hash of a document, or `0` when it cannot be decoded. -/
def docHash (d : Doc) : Nat :=
  match decodeDoc d with
  | some v => CValue.hash v
  | none => 0

/-- A ledger entry for one conversion. -/
def ledgerEntry (tid operation : String) (src dst : Format) (inHash outHash : Nat)
    (l : Lossiness) (errors warnings : List String) : Transformation :=
  { id := tid, operation := operation, source := src.toName, destination := dst.toName,
    input_hash := inHash, output_hash := outHash, codec := dst.toName,
    codec_version := "proof-codec/1.0", lossiness := l, errors := errors,
    warnings := warnings }

/-! ## Export SOP (SOP §27) -/

/-- Export an object: encode it, record the transformation with both hashes and
the declared preservation level, and hand back the artifact. -/
def exportArtifact (tid : String) (f : Format) (p : ProofObject) : Doc × Transformation :=
  let d := encodeDoc f p
  (d, ledgerEntry tid "export" Format.CANONICAL f (ProofObject.hash p) (docHash d)
        (lossiness f) [] (if f = Format.CSV then ["fields outside the table are not exported"]
                          else []))

/-- An export records the hash of what went in and of what came out, and for a
format declared lossless the two agree (SOP §21). -/
theorem exportArtifact_hashes (tid : String) (f : Format) (hf : f ≠ Format.CSV)
    (p : ProofObject) :
    (exportArtifact tid f p).2.input_hash = ProofObject.hash p ∧
      (exportArtifact tid f p).2.output_hash = ProofObject.hash p ∧
      (exportArtifact tid f p).2.lossiness = Lossiness.LOSSLESS := by
  obtain ⟨v, hv, hh⟩ := lossless_hash_stable f hf p
  refine ⟨rfl, ?_, ?_⟩
  · simp [exportArtifact, ledgerEntry, docHash, hv, hh]
  · cases f <;> simp_all [exportArtifact, ledgerEntry, lossiness]

/-- An export always declares its preservation level, and the declaration is
the one the format is entitled to. -/
theorem exportArtifact_declares_lossiness (tid : String) (f : Format) (p : ProofObject) :
    (exportArtifact tid f p).2.lossiness = lossiness f := rfl

/-! ## Import SOP (SOP §26) -/

/-- The report produced by importing an artifact. -/
structure ImportReport where
  /-- The canonical object, when one could be built. -/
  object : Option ProofObject
  /-- The canonical value that was decoded, when the document parsed. -/
  canonical : Option CValue
  /-- Content identity of the decoded value. -/
  hash : Option Nat
  /-- Diagnostics that could not be resolved. -/
  errors : List ErrorObj
  /-- Repairs that were applied automatically. -/
  repairs : List Validate.Repair
  /-- Where the artifact came from. -/
  provenance : Provenance
  /-- Ledger entry for the import. -/
  transformations : List Transformation
  deriving Repr, Inhabited

/-- Import an artifact, following the fourteen steps of SOP §26: the original
text is preserved, the document is decoded into the canonical model, a stable
identity is assigned, syntax, structure and types are validated, recoverable
problems are repaired and recorded, unresolved problems are kept, provenance is
recorded, the canonical hash is computed and an import report is produced. -/
def importArtifact (system ts tid objId : String) (f : Format) (raw : String)
    (d : Doc) : ImportReport :=
  let prov := importProvenance system ts tid none f none
  match decodeDoc d with
  | none =>
      { object := none, canonical := none, hash := none,
        errors := [Validate.syntaxError objId], repairs := [], provenance := prov,
        transformations := [ledgerEntry tid "import" f Format.CANONICAL 0 0
          Lossiness.FAILED ["PARSE_FAILURE"] []] }
  | some v =>
      match ProofObject.ofCValue v with
      | none =>
          { object := none, canonical := some v, hash := some (CValue.hash v),
            errors := Validate.validateStructure objId v ++
              [Validate.typeError objId "payload" "object" v false],
            repairs := [], provenance := prov,
            transformations := [ledgerEntry tid "import" f Format.CANONICAL
              (CValue.hash v) (CValue.hash v) Lossiness.PARTIAL ["STRUCTURE_INVALID"] []] }
      | some p0 =>
          let p1 : ProofObject :=
            { p0 with
                source_format := some f.toName,
                source_data := some raw,
                provenance := some prov }
          let rep := Validate.resolveObject objId p1
          { object := some rep.object, canonical := some v, hash := some (CValue.hash v),
            errors := rep.unresolved, repairs := rep.repairs, provenance := prov,
            transformations := [ledgerEntry tid "import" f Format.CANONICAL
              (CValue.hash v) (CValue.hash v) (lossiness f) [] []] }

/-- An import always records provenance, whatever happened to the document. -/
theorem importArtifact_provenance (system ts tid objId : String) (f : Format)
    (raw : String) (d : Doc) :
    (importArtifact system ts tid objId f raw d).provenance =
      importProvenance system ts tid none f none := by
  unfold importArtifact
  split
  · rfl
  · split <;> rfl

/-- An import always records exactly one ledger entry, naming the format it
read (SOP §21). -/
theorem importArtifact_ledger (system ts tid objId : String) (f : Format)
    (raw : String) (d : Doc) :
    ∃ t, (importArtifact system ts tid objId f raw d).transformations = [t] ∧
      t.id = tid ∧ t.source = f.toName ∧ t.destination = "CANONICAL" := by
  unfold importArtifact
  split
  · exact ⟨_, rfl, rfl, rfl, rfl⟩
  · split
    · refine ⟨_, rfl, ?_, ?_, ?_⟩ <;> rfl
    · refine ⟨_, rfl, ?_, ?_, ?_⟩ <;> rfl

/-- A document that cannot be decoded produces no object but always produces a
diagnostic: nothing is dropped silently, and the failure is reported as an
error rather than as an invalid proof (SOP §6, §11, §26). -/
theorem importArtifact_failure_reported (system ts tid objId : String) (f : Format)
    (raw : String) (d : Doc) (h : decodeDoc d = none) :
    (importArtifact system ts tid objId f raw d).object = none ∧
      (importArtifact system ts tid objId f raw d).errors ≠ [] ∧
      (importArtifact system ts tid objId f raw d).transformations.head?.map
        Transformation.lossiness = some Lossiness.FAILED := by
  simp [importArtifact, h, ledgerEntry]

/-- Whenever an object is produced, the artifact it came from is preserved
verbatim on it, together with the format it was read from (SOP §10, §26). -/
theorem importArtifact_preserves_source (system ts tid objId : String) (f : Format)
    (raw : String) (d : Doc) (q : ProofObject)
    (h : (importArtifact system ts tid objId f raw d).object = some q) :
    q.source_data = some raw ∧ q.source_format = some f.toName ∧
      q.provenance = some (importProvenance system ts tid none f none) := by
  unfold importArtifact at h
  split at h
  · simp at h
  · split at h
    · simp at h
    · rw [Option.some.injEq] at h
      subst h
      exact ⟨rfl, rfl, rfl⟩

/-! ## Round trip through the pipeline (SOP §17, §36) -/

/-- A well-typed object: every input and output already has its declared type,
so the import protocol has nothing to repair. -/
def WellTyped (p : ProofObject) : Prop :=
  ∀ i ∈ p.inputs, Validate.typeMatches i.type i.value = true

/-- Export followed by import reconstructs the object: identity, kind, status,
inputs and outputs all come back, and the source artifact is attached
(SOP §26, §27, §36). -/
theorem export_import_recovers (system ts tid objId raw : String) (f : Format)
    (hf : f = Format.IPDL ∨ f = Format.XML ∨ f = Format.YAML ∨ f = Format.CANONICAL)
    (p : ProofObject) (hw : WellTyped p) :
    ∃ q, (importArtifact system ts tid objId f raw (encodeDoc f p)).object = some q ∧
      q.id = p.id ∧ q.kind = p.kind ∧ q.status = p.status ∧
      q.inputs = p.inputs ∧ q.outputs = p.outputs ∧ q.claims = p.claims ∧
      q.certificates = p.certificates ∧ q.metadata = p.metadata ∧
      q.source_data = some raw := by
  have hdec := decodeDoc_encodeDoc_structured f hf p
  have hrep := Validate.repairInputs_of_typed p.id 0 p.inputs hw
  refine ⟨(Validate.resolveObject objId
      { p with
          source_format := some f.toName,
          source_data := some raw,
          provenance := some (importProvenance system ts tid none f none) }).object,
    ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simp [importArtifact, hdec, ProofObject.ofCValue_toCValue]
  all_goals simp [Validate.resolveObject, hrep]

/-- The invariant of SOP §36. A proof object with inputs and outputs can be
created, serialized, exported as IPDL, XML, YAML, CSV or raw text, imported by
another system, reconstructed as canonical data, and compared against the
original — without silently losing semantic information. The structured
formats return the object itself; raw text returns it up to canonical
normalisation; CSV returns the documented tabular view, and says so. -/
theorem definition_of_done (p : ProofObject) :
    -- IPDL, XML, YAML and the canonical serialization return the object itself
    (∀ f, (f = Format.IPDL ∨ f = Format.XML ∨ f = Format.YAML ∨ f = Format.CANONICAL) →
        decodeDoc (encodeDoc f p) = some (ProofObject.toCValue p) ∧
        (decodeDoc (encodeDoc f p)).bind ProofObject.ofCValue = some p ∧
        lossiness f = Lossiness.LOSSLESS) ∧
    -- raw text returns it up to canonical normalisation, with the same hash
    (∃ v, decodeDoc (encodeDoc Format.TEXT p) = some v ∧
        CValue.semEq v (ProofObject.toCValue p) ∧
        CValue.hash v = ProofObject.hash p ∧ lossiness Format.TEXT = Lossiness.LOSSLESS) ∧
    -- CSV returns the documented view, and declares itself partial
    (∃ q, (Csv.ofRows (Csv.toRows p)) = some q ∧ Csv.view q = Csv.view p ∧
        lossiness Format.CSV = Lossiness.PARTIAL) := by
  refine ⟨?_, ?_, ?_⟩
  · intro f hf
    have hdec := decodeDoc_encodeDoc_structured f hf p
    refine ⟨hdec, by simp [hdec, ProofObject.ofCValue_toCValue], ?_⟩
    rcases hf with rfl | rfl | rfl | rfl <;> rfl
  · obtain ⟨v, hv, hsem⟩ := decodeDoc_encodeDoc_semEq Format.TEXT (by decide) p
    exact ⟨v, hv, hsem, CValue.hash_congr hsem, rfl⟩
  · obtain ⟨q, hq, hview⟩ := Csv.csv_view_roundtrip p
    exact ⟨q, hq, hview, rfl⟩

/-- Cross-system exchange (SOP §18): two systems that speak different formats
agree, because both decode to the same canonical object. -/
theorem cross_system_agreement (f g : Format)
    (hf : f = Format.IPDL ∨ f = Format.XML ∨ f = Format.YAML ∨ f = Format.CANONICAL)
    (hg : g = Format.IPDL ∨ g = Format.XML ∨ g = Format.YAML ∨ g = Format.CANONICAL)
    (p : ProofObject) : decodeDoc (encodeDoc f p) = decodeDoc (encodeDoc g p) := by
  rw [decodeDoc_encodeDoc_structured f hf p, decodeDoc_encodeDoc_structured g hg p]

/-! ## Sealing an exchange (SOP §19) -/

/-- Export an object and seal it into an exchange envelope, recording the
transformation and the payload's content identity. -/
def sealExport (schema tid src dst ts : String) (f : Format) (p : ProofObject) :
    Doc × Envelope :=
  let (d, t) := exportArtifact tid f p
  (d, Envelope.sealObject schema "proof-codec/1.0" src dst ts p [] [t])

/-- The sealed envelope carries the hash of its payload and the ledger entry of
the export that produced the artifact. -/
theorem sealExport_records (schema tid src dst ts : String) (f : Format) (p : ProofObject) :
    (sealExport schema tid src dst ts f p).2.integrity = ProofObject.hash p ∧
      (sealExport schema tid src dst ts f p).2.transformations =
        [(exportArtifact tid f p).2] ∧
      (sealExport schema tid src dst ts f p).1 = encodeDoc f p := ⟨rfl, rfl, rfl⟩

end Pipeline
end Codec
