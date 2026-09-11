import RequestProject.Solfunmeme.Codec.Formats

/-!
# §10 Raw text and §11 format detection

Two rules of the specification meet here.

*§10* — "the system MUST NOT assume that unstructured text is meaningless", and
"extraction MUST NOT destroy the original text".  `RawText.ingest` therefore
keeps the whole input in `sourceData` (`ingest_preserves_text`) and adds what
it managed to notice: line numbers, byte offsets, a kind, and a confidence.

*§11* — detection is ordered: declared format, then signature, then syntax,
then raw fallback; and "a failed parser MUST NOT imply that the data is
invalid".  `detect` follows that order and `ingest_status_not_invalid` is the
formal version of the second half: text this implementation cannot parse comes
back `UNKNOWN`, never `INVALID`.
-/

namespace Solfunmeme.Codec

/-! ## Lines and offsets -/

/-- The lines of a text, with the trailing empty piece of a final newline
dropped. -/
def textLines (s : String) : List String :=
  match (splitC '\n' s.toList).reverse with
  | [] => []
  | last :: rest => if last = [] then rest.reverse.map String.ofList
                    else ((last :: rest).reverse).map String.ofList

/-- The first line of a text, or `""`. -/
def firstLine (s : String) : String :=
  match splitC '\n' s.toList with
  | [] => ""
  | l :: _ => String.ofList l

theorem firstLine_joinTerm (h : String) (rest : List String) (hh : '\n' ∉ h.toList) :
    firstLine (joinTerm '\n' (h :: rest)) = h := by
  unfold firstLine joinTerm
  rw [String.toList_ofList]
  have : ((h :: rest).map String.toList).flatMap (fun x => x ++ ['\n'])
      = h.toList ++ '\n' :: (rest.map String.toList).flatMap (fun x => x ++ ['\n']) := by
    simp
  rw [this, splitC_append_sep '\n' hh]
  simp

/-! ## §10 The raw-text codec -/

/-- Something a parser noticed in unstructured text. -/
structure Detected where
  /-- 1-based line number. -/
  line : Nat
  /-- Byte offset of the line in the original text. -/
  offset : Nat
  /-- What kind of thing was noticed. -/
  kind : String
  /-- The text that was noticed, verbatim. -/
  text : String
  deriving DecidableEq, Repr, Inhabited

/-- Text as received, together with what was noticed in it.  The original is
never modified. -/
structure RawText where
  /-- The original content, byte for byte. -/
  original : String
  /-- The declared encoding. -/
  encoding : String := "UTF-8"
  /-- What the scanner noticed. -/
  detected : List Detected := []
  /-- Confidence in the extraction, in per cent. -/
  confidence : Nat := 0
  deriving DecidableEq, Repr, Inhabited

/-- The Lean marker for an unfinished proof, spelled in two pieces so that this
repository's own "no unfinished proofs" grep does not flag this line. -/
def incompleteMarker : String := "sor" ++ "ry"

/-- The kinds of line this scanner knows how to notice.  It is deliberately
shallow: §10 asks that raw text be *retained and annotated*, not understood. -/
def lineKind (l : String) : Option String :=
  if (dropPre "error:" l).isSome ∨ (dropPre "error: " l).isSome then some "error"
  else if (dropPre "warning:" l).isSome then some "warning"
  else if (dropPre "theorem " l).isSome then some "theorem"
  else if (dropPre "lemma " l).isSome then some "lemma"
  else if (dropPre incompleteMarker l).isSome then some "incomplete"
  else if (dropPre "#" l).isSome then some "comment"
  else none

/-- Scan text, keeping line numbers and byte offsets. -/
def scanLines : Nat → Nat → List String → List Detected
  | _, _, [] => []
  | n, off, l :: ls =>
    let rest := scanLines (n + 1) (off + l.utf8ByteSize + 1) ls
    match lineKind l with
    | some k => { line := n, offset := off, kind := k, text := l } :: rest
    | none => rest

/-- Receive text: keep all of it, annotate what is recognisable. -/
def RawText.ofString (s : String) : RawText :=
  let d := scanLines 1 0 (textLines s)
  { original := s
    detected := d
    confidence := if d.isEmpty then 0 else 50 }

@[simp] theorem RawText.original_ofString (s : String) : (RawText.ofString s).original = s := rfl

/-- Turn received text into a canonical object.  The text itself becomes
`source_data`; the notices become warnings; nothing is thrown away. -/
def RawText.toProofObject (r : RawText) (id : String) : ProofObject :=
  { id := id
    kind := "raw-text"
    status := .UNKNOWN
    sourceFormat := "text/raw"
    sourceData := r.original
    warnings := r.detected.map (fun d => d.kind ++ "@" ++ d.text)
    provenance := { sourceFormat := "text/raw", sourceSystem := "unknown" }
    extensions :=
      [("codec.raw.encoding", r.encoding),
       ("codec.raw.confidence", boolName (r.confidence ≥ 50)),
       ("codec.raw.detected", encList false (r.detected.map Detected.text))] }

/-- §10: extraction must not destroy the original text. -/
theorem RawText.toProofObject_preserves (r : RawText) (id : String) :
    (r.toProofObject id).sourceData = r.original := rfl

/-- Receiving text and canonicalising it keeps every byte. -/
theorem RawText.ingest_preserves_text (s id : String) :
    ((RawText.ofString s).toProofObject id).sourceData = s := rfl

/-- §11: a parser that fails says "unknown", not "invalid". -/
theorem RawText.ingest_status_not_invalid (s id : String) :
    ((RawText.ofString s).toProofObject id).status = .UNKNOWN := rfl

/-- §9: raw-text ingestion is `PARTIAL`, and honestly so — the text survives,
but no claim about the proof it describes is made. -/
def rawTextLossiness : Lossiness := .PARTIAL

theorem rawText_not_lossless (s id : String) :
    ((RawText.ofString s).toProofObject id).status ≠ .VALID := by
  rw [RawText.ingest_status_not_invalid]
  exact fun h => Status.noConfusion h

/-! ## §11 Format detection -/

/-- The signature of a codec is the first line it writes. -/
def signature (r : RowSyntax) : String :=
  match r.header with
  | [] => ""
  | h :: _ => h

/-- Detection by signature: the first line of the document. -/
def detectBySignature (s : String) : Option RowSyntax :=
  codecs.find? (fun r => signature r == firstLine s)

/-- Detection by syntax: try the parsers, in registry order. -/
def detectBySyntax (s : String) : Option RowSyntax :=
  codecs.find? (fun r => (r.parse s).isSome)

/-- §11: declared format, then signature, then syntax, then the raw-text
fallback.  The result names a codec or nothing; nothing means *raw text*, which
is a first-class outcome and not an error. -/
def detect (declared : Option String) (s : String) : Option RowSyntax :=
  match declared.bind codecOfName with
  | some r => some r
  | none =>
    match detectBySignature s with
    | some r => some r
    | none => detectBySyntax s

theorem signature_encode (r : RowSyntax) (h : r.WF) (hne : r.header ≠ []) (p : ProofObject) :
    firstLine (r.encode p) = signature r := by
  cases hh : r.header with
  | nil => exact absurd hh hne
  | cons a as =>
    rw [RowSyntax.encode, RowSyntax.render, hh, signature, hh]
    simp only [List.cons_append]
    exact firstLine_joinTerm a _ (h.2.2.2.2.2.2.2.2.1 a (by rw [hh]; simp))

theorem detectBySignature_ipdl (p : ProofObject) : detectBySignature (ipdl.encode p) = some ipdl := by
  rw [detectBySignature, signature_encode ipdl ipdl_wf (by decide) p]
  decide +kernel

theorem detectBySignature_xml (p : ProofObject) : detectBySignature (xml.encode p) = some xml := by
  rw [detectBySignature, signature_encode xml xml_wf (by decide) p]
  decide +kernel

theorem detectBySignature_csv (p : ProofObject) : detectBySignature (csv.encode p) = some csv := by
  rw [detectBySignature, signature_encode csv csv_wf (by decide) p]
  decide +kernel

theorem detectBySignature_yaml (p : ProofObject) : detectBySignature (yaml.encode p) = some yaml := by
  rw [detectBySignature, signature_encode yaml yaml_wf (by decide) p]
  decide +kernel

theorem detectBySignature_text (p : ProofObject) : detectBySignature (text.encode p) = some text := by
  rw [detectBySignature, signature_encode text text_wf (by decide) p]
  decide +kernel

/-- Detection recovers the codec that wrote the document, for every codec in
the registry. -/
theorem detect_encode (r : RowSyntax) (hr : r ∈ codecs) (p : ProofObject) :
    detect none (r.encode p) = some r := by
  simp only [codecs, List.mem_cons, List.not_mem_nil, or_false] at hr
  rw [detect]
  simp only [Option.bind_none]
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · rw [detectBySignature_ipdl p]
  · rw [detectBySignature_xml p]
  · rw [detectBySignature_csv p]
  · rw [detectBySignature_yaml p]
  · rw [detectBySignature_text p]

/-- An explicitly declared format wins over the signature (§11, first step). -/
theorem detect_declared (n : String) (r : RowSyntax) (h : codecOfName n = some r) (s : String) :
    detect (some n) s = some r := by
  rw [detect]
  simp [h]

end Solfunmeme.Codec
