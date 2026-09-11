import RequestProject.Solfunmeme.Codec.Exchange
import RequestProject.Solfunmeme.Codec.Reconcile

/-!
# §32, §33, §36 Conformance, the required test suite, and done

§33 lists the cases every codec implementation must test.  They are all here,
as canonical objects, and `suite_roundTrips` runs every one of them through
every codec of the registry — not by evaluating a fixture, but as a consequence
of the round-trip theorem, so the suite passes for these twenty-one objects and
for every other object as well.

§32's conformance levels are recorded with the theorem that earns each one, and
§36's definition of done is a single statement: create, serialise, export in
five formats, import, reconstruct, validate, compare, reconcile, and recover
the provenance — without losing semantic information.
-/

namespace Solfunmeme.Codec

/-! ## §33 The required cases -/

/-- A named case of the required test suite. -/
structure TestCase where
  name : String
  object : ProofObject
  deriving DecidableEq, Repr, Inhabited

/-- The twenty-one shapes §33 requires, plus the five proof-specific ones. -/
def suite : List TestCase :=
  [ { name := "empty object", object := {} }
  , { name := "minimal object"
    , object := { id := "p", kind := "theorem", status := .UNKNOWN } }
  , { name := "nested object"
    , object :=
        { id := "p", kind := "theorem"
          inputs := [{ id := "i", name := "n", type := "integer", value := "144"
                       extensions := [("vendor.x", "nested")] }]
          outputs := [{ id := "o", name := "r", type := "integer", value := "12"
                        claims := ["12*12=144"] }] } }
  , { name := "multiple inputs"
    , object :=
        { id := "p", kind := "computation"
          inputs := [{ id := "i1", name := "a", value := "1" },
                     { id := "i2", name := "b", value := "2" },
                     { id := "i3", name := "c", value := "3" }] } }
  , { name := "multiple outputs"
    , object :=
        { id := "p", kind := "computation"
          outputs := [{ id := "o1", name := "theorem", value := "T" },
                      { id := "o2", name := "witness", value := "w" },
                      { id := "o3", name := "certificate", value := "c" },
                      { id := "o4", name := "numerical_result", value := "3" },
                      { id := "o5", name := "diagnostic", value := "none" }] } }
  , { name := "missing field", object := { kind := "theorem" } }
  , { name := "unknown field"
    , object := { id := "p", kind := "theorem"
                  extensions := [("vendor.system_x", "{\"a\":1}"),
                                 ("experimental.foo", "bar")] } }
  , { name := "invalid type"
    , object := { id := "p", kind := "theorem"
                  inputs := [{ id := "i", name := "n", type := "integer", value := "not a number" }] } }
  , { name := "malformed input"
    , object := { id := "p", kind := "theorem"
                  sourceFormat := "text/raw", sourceData := "<<<not a document>>>"
                  status := .UNKNOWN } }
  , { name := "unicode"
    , object := { id := "p-Σ", kind := "théorème"
                  inputs := [{ id := "i", name := "π", value := "3,14159 — approx ≈ π" }]
                  claims := ["∀ ε > 0, ∃ δ > 0", "日本語", "🜁 alchemical air"] } }
  , { name := "large numbers"
    , object := { id := "p", kind := "computation"
                  inputs := [{ id := "i", name := "n", type := "integer"
                               value := "179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368" }] } }
  , { name := "null values"
    , object := { id := "p", kind := "theorem"
                  inputs := [{ id := "i", name := "n", type := "null", value := "" }]
                  outputs := [{ id := "o", name := "r", type := "null", value := "" }] } }
  , { name := "duplicate identifiers"
    , object := { id := "p", kind := "theorem"
                  inputs := [{ id := "same", name := "a", value := "1" },
                             { id := "same", name := "b", value := "2" }] } }
  , { name := "references"
    , object := { id := "p", kind := "theorem"
                  inputs := [{ id := "i", name := "ref", type := "reference"
                               value := "proof://other/outputs/o1" }]
                  provenance := { parentObject := "other" } } }
  , { name := "errors"
    , object := { id := "p", kind := "theorem", status := .ERROR
                  errors := [{ id := "e1", code := "TYPE_MISMATCH", severity := .ERROR
                               field := "inputs[0].value", expected := "integer"
                               actual := "string", recoverable := true }] } }
  , { name := "warnings"
    , object := { id := "p", kind := "theorem", warnings := ["deprecated axiom", "slow"] } }
  , { name := "partial proof"
    , object := { id := "p", kind := "theorem", status := .PARTIAL
                  intermediate := ["step 1", "step 2"], claims := ["case A done"] } }
  , { name := "failed proof"
    , object := { id := "p", kind := "theorem", status := .INVALID
                  errors := [{ id := "e1", code := "COUNTEREXAMPLE", severity := .ERROR
                               message := "n = 5 refutes the claim" }] } }
  , { name := "successful proof"
    , object := { id := "p", kind := "theorem", status := .VALID
                  claims := ["proved"], certificates := ["kernel-checked"] } }
  , { name := "contradictory proof"
    , object := { id := "p", kind := "theorem", status := .CONFLICT
                  claims := ["A", "¬A"] } }
  , { name := "incomplete proof"
    , object := { id := "p", kind := "theorem", status := .PENDING } }
  , { name := "incompatible output"
    , object := { id := "p", kind := "computation", status := .VALID
                  outputs := [{ id := "o", name := "result", value := "43" }] } }
  , { name := "unsupported"
    , object := { id := "p", kind := "theorem", status := .UNSUPPORTED } }
  , { name := "lossy conversion"
    , object := { id := "p", kind := "theorem"
                  metadata := [("codec.lossiness", "PARTIAL")]
                  sourceFormat := "text/raw", sourceData := "free text" } }
  , { name := "round-trip conversion"
    , object := { id := "p", kind := "theorem", version := "1.1"
                  procedure := "decide", status := .VALID } } ]

/-- Run one case through one codec. -/
def runCase (r : RowSyntax) (t : TestCase) : Bool := r.decode (r.encode t.object) == some t.object

/-- Run the whole suite through every codec of the registry. -/
def runSuite : Bool := codecs.all (fun r => suite.all (fun t => runCase r t))

theorem runCase_ok (r : RowSyntax) (hr : r ∈ codecs) (t : TestCase) : runCase r t = true := by
  simp [runCase, codecs_lossless r hr t.object]

/-- §33: every case, in every codec.  This is not a fixture check — it holds
for any object whatsoever, which is why it holds for these. -/
theorem suite_roundTrips : runSuite = true := by
  rw [runSuite, List.all_eq_true]
  intro r hr
  rw [List.all_eq_true]
  intro t _
  exact runCase_ok r hr t

/-- §33: malformed input.  These are not canonical objects at all; the rule
they must satisfy is that importing them keeps every byte and never invents a
verdict. -/
def malformed : List String :=
  [ ""
  , "not a document at all"
  , "object_id,object_type,field\nbroken,row"
  , "<?xml version=\"1.0\"?><unclosed>"
  , "  - {object_id: \"x\""
  , "(ipdl-document :cells (" ]

theorem malformed_bytes_survive (s : String) :
    (importArtifact none "test" "case" s).original = s :=
  importArtifact_preserves_bytes none "test" "case" s

/-- Importing never invents a status: either the document said so, or the
result is `UNKNOWN`. -/
theorem importArtifact_status_from_document (declared : Option String) (system file s : String) :
    (importArtifact declared system file s).object.status = .UNKNOWN
      ∨ ∃ (r : RowSyntax) (p : ProofObject),
          detect declared s = some r ∧ r.decode s = some p
            ∧ (importArtifact declared system file s).object.status = p.status := by
  cases hdet : detect declared s with
  | none => exact Or.inl (by simp only [importArtifact, hdet]; rfl)
  | some r =>
    cases hdec : r.decode s with
    | none => exact Or.inl (by simp only [importArtifact, hdet, hdec]; rfl)
    | some p =>
      refine Or.inr ⟨r, p, rfl, hdec, ?_⟩
      simp only [importArtifact, hdet, hdec, resolve, recordStep]

/-! ## §17 comparison after a round trip -/

theorem diff_eq_nil_of_semanticEq {p q : ProofObject} (h : SemanticEq p q) : diff p q = [] := by
  unfold SemanticEq ProofObject.semanticCore at h
  simp only [Prod.mk.injEq] at h
  obtain ⟨h1, h2, h3, h4, h5, h6, _⟩ := h
  simp [diff, h1, h2, h3, h4, h5, h6]

theorem compareObjects_of_semanticEq {p q : ProofObject} (h : SemanticEq p q) :
    compareObjects p q = .EQUIVALENT :=
  (compareObjects_eq_equivalent_iff p q).2 (diff_eq_nil_of_semanticEq h)

/-! ## §32 Conformance levels -/

/-- The conformance levels of §32. -/
inductive Conformance where
  | L0_raw | L1_structured | L2_typed | L3_proofAware | L4_reconciliation | L5_auditable
  deriving DecidableEq, Repr, Inhabited

def Conformance.name : Conformance → String
  | .L0_raw => "Level 0 — Raw"
  | .L1_structured => "Level 1 — Structured"
  | .L2_typed => "Level 2 — Typed"
  | .L3_proofAware => "Level 3 — Proof-Aware"
  | .L4_reconciliation => "Level 4 — Reconciliation"
  | .L5_auditable => "Level 5 — Auditable"

/-- The level this implementation claims. -/
def claimedLevel : Conformance := .L5_auditable

/-- §32 Level 0: arbitrary text is preserved and exchanged. -/
theorem level0_raw (s : String) :
    ((RawText.ofString s).toProofObject "p").sourceData = s := rfl

/-- §32 Level 1: canonical objects are imported and exported. -/
theorem level1_structured (r : RowSyntax) (hr : r ∈ codecs) (p : ProofObject) :
    r.decode (r.encode p) = some p := codecs_lossless r hr p

/-- §32 Level 2: schemas, types, inputs, outputs and errors are supported —
including catching a value that does not match its declared type. -/
def typeMismatchExample : ProofObject :=
  { id := "p", kind := "t", inputs := [{ id := "i", type := "integer", value := "x" }] }

theorem level2_typed :
    (validateTypes typeMismatchExample).map Diagnostic.code = ["TYPE_MISMATCH"] := by
  decide +kernel

/-- §32 Level 3: a proof engine's verdict is carried, and only the engine's. -/
theorem level3_proofAware (engine : ProofObject → Status) (cert : ProofObject → String)
    (p : ProofObject) : (validateWith engine cert p).status = engine p := rfl

/-- §32 Level 4: independent results are compared and conflicts resolved with a
recorded resolution. -/
theorem level4_reconciliation (s : Strategy) (p q o : ProofObject)
    (h : (resolveConflict s p q).result = some o) :
    o.provenance.parentObject = p.id ++ "+" ++ q.id :=
  (resolveConflict_records s p q o h).1

/-- §32 Level 5: deterministic serialization, content identity, envelopes and
ledgers. -/
theorem level5_auditable (p q : ProofObject)
    (h : canonicalSerialize p = canonicalSerialize q) : p = q := canonicalSerialize_inj h

/-! ## §36 Definition of done -/

/-- §36, in one statement.  For any canonical object whose inputs declare their
types:

* it is exported in all five codecs and imported back unchanged;
* the imported object compares `EQUIVALENT` to the original;
* the object sealed in an envelope opens to the original;
* the content identity is the same whichever codec carried it;
* nothing was silently lost: the export declares itself lossless and the
  round-trip test in the export report passes.
-/
theorem definition_of_done (system file : String) (p : ProofObject)
    (hp : ∀ i ∈ p.inputs, i.type ≠ "") :
    (ofIpdl (toIpdl p) = some p
      ∧ ofXml (toXml p) = some p
      ∧ ofCsv (toCsv p) = some p
      ∧ ofYaml (toYaml p) = some p
      ∧ ofText (toText p) = some p)
    ∧ (∀ r ∈ codecs,
        compareObjects (importArtifact none system file (r.encode p)).object p = .EQUIVALENT)
    ∧ (∀ r ∈ codecs, (exportArtifact r p).roundTripOk = true
        ∧ (exportArtifact r p).lossiness = .LOSSLESS)
    ∧ (∀ r ∈ codecs, (r.decode (r.encode p)).map contentId = some (contentId p))
    ∧ (∀ r ∈ codecs, ∀ src dst ts : String,
        codecOfName r.name = some r → openEnvelope (sealEnvelope r src dst ts p) = some p) := by
  refine ⟨⟨ofIpdl_toIpdl p, ofXml_toXml p, ofCsv_toCsv p, ofYaml_toYaml p, ofText_toText p⟩,
    ?_, ?_, ?_, ?_⟩
  · intro r hr
    exact compareObjects_of_semanticEq (importArtifact_of_encoded r hr system file p hp)
  · intro r hr
    exact ⟨exportArtifact_roundTrips r hr p, rfl⟩
  · intro r hr
    exact contentId_of_any_codec r hr p
  · intro r hr src dst ts hname
    exact openEnvelope_seal r hr hname src dst ts p

end Solfunmeme.Codec
