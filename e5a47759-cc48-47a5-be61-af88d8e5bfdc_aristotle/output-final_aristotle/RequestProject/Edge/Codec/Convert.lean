/-
# Conversion, and the transformation ledger

A conversion is never allowed to be silent.  §14 asks that every
transformation of an object be recorded with the codec that performed
it and how much of the object survived, and §31 asks that the record be
*appended*: what a previous system wrote about an object may not be
rewritten by the next one.

This module is that ledger.  `convert` reads a text in whatever format
it turns out to be (never failing — see `Detect.decodeAuto`), writes it
out in the requested format, and appends exactly one `Record` to the
object's provenance saying where it came from, where it went, which
codec did it and at what preservation level.  The claim in that record
is not decoration: `record_lossless_iff` ties it to the codecs' own
`lossiness`, and `reimport_of_lossless` shows what such a record buys —
the emitted text reads back as exactly the object that was written.
-/
import RequestProject.Edge.Codec.Reconcile

namespace CfDeploy
namespace Codec
namespace Convert

/-! ## The preservation lattice

A chain of conversions is only as faithful as its worst step. -/

/-- The worse of two preservation levels: `LOSSLESS` is the best,
`FAILED` the worst. -/
def worst : Lossiness → Lossiness → Lossiness
  | .failed, _ => .failed
  | _, .failed => .failed
  | .lossy, _ => .lossy
  | _, .lossy => .lossy
  | .partial', _ => .partial'
  | _, .partial' => .partial'
  | .lossless, .lossless => .lossless

/-- **A chain claims LOSSLESS only when every step is.** -/
@[simp] theorem worst_lossless_iff {a b : Lossiness} :
    worst a b = .lossless ↔ a = .lossless ∧ b = .lossless := by
  cases a <;> cases b <;> simp [worst]

theorem worst_comm (a b : Lossiness) : worst a b = worst b a := by
  cases a <;> cases b <;> rfl

/-! ## A transformation record -/

/-- One conversion, as it appears in an object's provenance (§14). -/
structure Record where
  /-- the format the object was read from -/
  source : String
  /-- the format it was written to -/
  target : String
  /-- the codec that wrote it -/
  codec : String
  /-- that codec's version -/
  codecVersion : String
  /-- how much of the object survived the whole step -/
  lossiness : Lossiness
  /-- when it happened, as supplied by the caller (`""` when unknown) -/
  at' : String := ""
  deriving Repr, DecidableEq, Inhabited

namespace Record

/-- The ledger entry, as one line: everything needed to reconstruct what
was done, and by what. -/
def label (r : Record) : String :=
  r.source ++ "->" ++ r.target ++ " " ++ r.codec ++ "/" ++ r.codecVersion ++
    " " ++ r.lossiness.toString ++ (if r.at' = "" then "" else " " ++ r.at')

/-- The record as a canonical value, for systems that want it
structured rather than as a line. -/
def toVal (r : Record) : CVal :=
  .obj [ ("at", .str r.at')
       , ("codec", .str r.codec)
       , ("codecVersion", .str r.codecVersion)
       , ("lossiness", .str r.lossiness.toString)
       , ("source", .str r.source)
       , ("target", .str r.target) ]

end Record

/-! ## Appending to the ledger -/

/-- The transformation ledger of an object, oldest first. -/
def ledger (p : ProofObject) : List String := p.provenance.transformations

/-- Append a record.  Nothing already in the ledger is touched, and
nothing outside the provenance is either — in particular the status is
not (§6). -/
def note (p : ProofObject) (r : Record) : ProofObject :=
  { p with
      provenance :=
        { p.provenance with
            transformations := p.provenance.transformations ++ [r.label]
            transformedAt := if r.at' = "" then p.provenance.transformedAt else r.at' } }

/-- **The ledger grows by exactly the step that was taken.** -/
@[simp] theorem ledger_note (p : ProofObject) (r : Record) :
    ledger (note p r) = ledger p ++ [r.label] := rfl

/-- **§31: the ledger is append-only.**  Whatever an earlier system
wrote is still there, in order, at the front. -/
theorem ledger_note_prefix (p : ProofObject) (r : Record) :
    (ledger p).IsPrefix (ledger (note p r)) := ⟨[r.label], rfl⟩

/-- **§6: a conversion does not change what the object says about
itself.**  Recording a transformation touches the provenance and
nothing else. -/
theorem note_preserves_payload (p : ProofObject) (r : Record) :
    (note p r).id = p.id ∧ (note p r).kind = p.kind ∧
      (note p r).status = p.status ∧ (note p r).inputs = p.inputs ∧
      (note p r).outputs = p.outputs ∧ (note p r).errors = p.errors ∧
      (note p r).metadata = p.metadata ∧ (note p r).sourceData = p.sourceData ∧
      (note p r).extensions = p.extensions :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- The same statement about the minimum interchange profile. -/
@[simp] theorem note_minimal (p : ProofObject) (r : Record) :
    (note p r).minimal = p.minimal := rfl

/-! ## From a text to an object, and back -/

/-- The canonical object of a decoded text.  A decoded value that is
already an object is read as one — `ProofObject.ofVal` folds fields this
schema does not know about into `extensions` rather than dropping them —
and anything else is carried whole under `extensions.value`.  Either way
the source text is kept verbatim. -/
def objectOf (d : Decoded) : ProofObject :=
  match ProofObject.ofVal d.value with
  | some p => { p with sourceFormat := d.format.name, sourceData := d.source }
  | none =>
      { extensions := [("value", d.value)]
        sourceFormat := d.format.name
        sourceData := d.source }

/-- **Nothing is discarded on import.**  Whatever happened, the text
that was read is still in the object. -/
@[simp] theorem objectOf_sourceData (d : Decoded) : (objectOf d).sourceData = d.source := by
  unfold objectOf; split <;> rfl

/-- Read a text into the canonical model, deciding its format if it was
not declared.  This never fails (`Detect.decodeAuto`). -/
def import' (declared : Option String) (src : String) : ProofObject :=
  objectOf (decodeAuto declared src)

/-- Write an object out in a format. -/
def emit (target : Format) (p : ProofObject) : String :=
  (codecFor target).encode (ProofObject.toVal p)

/-- **A lossless target reads back exactly what was written**, ledger
and all. -/
theorem decode_emit (target : Format) (p : ProofObject)
    (hl : (codecFor target).lossiness = .lossless)
    (hd : (codecFor target).domain (ProofObject.toVal p) = true) :
    (codecFor target).decode (emit target p) = some (ProofObject.toVal p) :=
  (codecFor target).lossless_on_domain hl _ hd

/-- **Re-importing a lossless export returns the same object**, up to
the two fields that record where it has just been read from. -/
theorem reimport_of_lossless (target : Format) (p : ProofObject)
    (hl : (codecFor target).lossiness = .lossless)
    (hd : (codecFor target).domain (ProofObject.toVal p) = true) :
    import' (some target.name) (emit target p) =
      { p with sourceFormat := target.name, sourceData := emit target p } := by
  have hdec : decodeAuto (some target.name) (emit target p) =
      ⟨ProofObject.toVal p, target, .declared, false, emit target p⟩ := by
    simp [decodeAuto, StringCodec.decodeDoc, decode_emit target p hl hd]
  simp [import', objectOf, hdec]

/-- **The object survives a lossless export and re-import.**  Its
minimum profile, its provenance and its ledger are unchanged. -/
theorem reimport_minimal (target : Format) (p : ProofObject)
    (hl : (codecFor target).lossiness = .lossless)
    (hd : (codecFor target).domain (ProofObject.toVal p) = true) :
    (import' (some target.name) (emit target p)).minimal = p.minimal ∧
      (import' (some target.name) (emit target p)).provenance = p.provenance ∧
      ledger (import' (some target.name) (emit target p)) = ledger p := by
  rw [reimport_of_lossless target p hl hd]
  exact ⟨rfl, rfl, rfl⟩

/-! ## The conversion itself -/

/-- What a conversion produced: the text, the object as it now stands
(with the new ledger entry), the record that was appended, how the
source format was decided, whether the source had to fall back to raw
text, and what validation made of it. -/
structure Outcome where
  text : String
  object : ProofObject
  record : Record
  detection : Detection
  /-- true when the source could not be parsed and was kept as raw text -/
  fellBack : Bool
  report : Validate.Report

/-- The preservation level of reading a text in `source` and writing it
in `target`: the worse of the two codecs' own levels, and `PARTIAL`
whenever the source had to fall back to raw text. -/
def stepLossiness (source target : Format) (fellBack : Bool) : Lossiness :=
  if fellBack then worst .partial' (codecFor target).lossiness
  else worst (codecFor source).lossiness (codecFor target).lossiness

/-- Convert a text into another format, recording the step. -/
def convert (declared : Option String) (target : Format) (at' : String) (src : String) :
    Outcome :=
  let d := decodeAuto declared src
  let p0 := objectOf d
  let c := codecFor target
  let r : Record :=
    { source := d.format.name, target := target.name, codec := c.name
      codecVersion := c.version
      lossiness := stepLossiness d.format target d.fellBack
      at' := at' }
  let p := note p0 r
  { text := emit target p
    object := p
    record := r
    detection := ⟨d.format, d.evidence⟩
    fellBack := d.fellBack
    report := Validate.validate d.format src p }

/-- **The source text is never lost by a conversion.** -/
@[simp] theorem convert_sourceData (declared : Option String) (target : Format)
    (at' src : String) : (convert declared target at' src).object.sourceData = src := by
  simp [convert, note]

/-- **Exactly one entry is appended per conversion**, after everything
the object already carried. -/
theorem convert_ledger (declared : Option String) (target : Format) (at' src : String) :
    ledger (convert declared target at' src).object =
      ledger (import' declared src) ++ [(convert declared target at' src).record.label] := rfl

/-- **§31, for a conversion: the ledger is append-only.** -/
theorem convert_ledger_prefix (declared : Option String) (target : Format) (at' src : String) :
    (ledger (import' declared src)).IsPrefix
      (ledger (convert declared target at' src).object) :=
  ledger_note_prefix _ _

/-- **§6: converting does not change the object's own claims.** -/
theorem convert_preserves_minimal (declared : Option String) (target : Format)
    (at' src : String) :
    (convert declared target at' src).object.minimal = (import' declared src).minimal := rfl

/-- **The recorded level is honest.**  A conversion records `LOSSLESS`
exactly when the source parsed and both codecs are lossless. -/
theorem convert_lossless_iff (declared : Option String) (target : Format) (at' src : String) :
    (convert declared target at' src).record.lossiness = .lossless ↔
      (decodeAuto declared src).fellBack = false ∧
        (codecFor (decodeAuto declared src).format).lossiness = .lossless ∧
        (codecFor target).lossiness = .lossless := by
  simp only [convert, stepLossiness]
  cases h : (decodeAuto declared src).fellBack <;> simp

/-- **What a `LOSSLESS` record buys.**  When a conversion records
`LOSSLESS`, its text decodes back to exactly the object it wrote. -/
theorem convert_text_decodes (declared : Option String) (target : Format) (at' src : String)
    (hrec : (convert declared target at' src).record.lossiness = .lossless)
    (hd : (codecFor target).domain
      (ProofObject.toVal (convert declared target at' src).object) = true) :
    (codecFor target).decode (convert declared target at' src).text =
      some (ProofObject.toVal (convert declared target at' src).object) :=
  decode_emit target _ ((convert_lossless_iff declared target at' src).1 hrec).2.2 hd

/-- **A lossless conversion preserves content identity**: what comes
back out of the text is the very value whose `cid` was reported. -/
theorem convert_cid (declared : Option String) (target : Format) (at' src : String)
    (hrec : (convert declared target at' src).record.lossiness = .lossless)
    (hd : (codecFor target).domain
      (ProofObject.toVal (convert declared target at' src).object) = true) :
    ((codecFor target).decode (convert declared target at' src).text).map Canon.cid =
      some (ProofObject.cid (convert declared target at' src).object) := by
  rw [convert_text_decodes declared target at' src hrec hd]
  rfl

/-! ## Chains of conversions

Several conversions in a row: each step reads the text the previous one
wrote, and appends its own record.  Nothing rewrites what came before. -/

/-- Convert through a sequence of formats, oldest record first. -/
def pipeline (declared : Option String) (at' src : String) : List Format → Option Outcome
  | [] => none
  | t :: ts =>
      some (ts.foldl (fun o t' => convert (some o.record.target) t' at' o.text)
        (convert declared t at' src))

/-- A format whose codec loses nothing, on any value. -/
def Faithful (f : Format) : Prop :=
  (codecFor f).lossiness = .lossless ∧ ∀ v, (codecFor f).domain v = true

theorem faithful_canonical : Faithful .canonical := ⟨rfl, fun _ => rfl⟩
theorem faithful_ipdl : Faithful .ipdl := ⟨rfl, fun _ => rfl⟩
theorem faithful_csv : Faithful .csv := ⟨rfl, fun _ => rfl⟩
theorem faithful_yaml : Faithful .yaml := ⟨rfl, fun _ => rfl⟩

/-- An outcome whose text really is its object written in the format it
names — which is what `convert` produces. -/
def Wf (o : Outcome) (f : Format) : Prop :=
  o.record.target = f.name ∧ o.text = emit f o.object

theorem convert_wf (declared : Option String) (target : Format) (at' src : String) :
    Wf (convert declared target at' src) target := ⟨rfl, rfl⟩

/-- **One step of a chain keeps everything the previous steps wrote.**
Reading back a faithfully written text and converting it again appends
the new record to the ledger that was already there. -/
theorem ledger_step {o : Outcome} {f : Format} (hw : Wf o f) (hf : Faithful f)
    (t' : Format) (at' : String) :
    ledger (convert (some o.record.target) t' at' o.text).object =
      ledger o.object ++ [(convert (some o.record.target) t' at' o.text).record.label] := by
  rw [convert_ledger]
  congr 1
  rw [hw.1, hw.2]
  exact (reimport_minimal f o.object hf.1 (hf.2 _)).2.2

theorem foldl_ledger_length (at' : String) : ∀ (ts : List Format) (o : Outcome) (f : Format),
    Wf o f → Faithful f → (∀ g ∈ ts, Faithful g) →
    (ledger (ts.foldl (fun o t' => convert (some o.record.target) t' at' o.text) o).object).length
      = (ledger o.object).length + ts.length := by
  intro ts
  induction ts with
  | nil => intro o _ _ _ _; simp
  | cons u us ih =>
      intro o f hw hf hus
      have hu : Faithful u := hus u (by simp)
      have hstep := ledger_step hw hf u at'
      have := ih (convert (some o.record.target) u at' o.text) u (convert_wf _ _ _ _) hu
        (fun g hg => hus g (by simp [hg]))
      simp only [List.foldl_cons, this, hstep, List.length_append, List.length_cons,
        List.length_nil, List.length_cons]
      omega

/-- **Every step of a chain is recorded, in order.**  A chain through
`n` faithful formats appends exactly `n` entries to whatever the object
already carried, and none of them replaces an earlier one. -/
theorem pipeline_ledger_length (declared : Option String) (at' src : String)
    (t : Format) (ts : List Format) (hf : ∀ f ∈ t :: ts, Faithful f) :
    ∃ o, pipeline declared at' src (t :: ts) = some o ∧
      (ledger o.object).length = (ledger (import' declared src)).length + 1 + ts.length := by
  refine ⟨_, rfl, ?_⟩
  rw [foldl_ledger_length at' ts (convert declared t at' src) t (convert_wf _ _ _ _)
    (hf t (by simp)) (fun g hg => hf g (by simp [hg]))]
  rw [convert_ledger declared t at' src]
  simp

end Convert
end Codec
end CfDeploy
