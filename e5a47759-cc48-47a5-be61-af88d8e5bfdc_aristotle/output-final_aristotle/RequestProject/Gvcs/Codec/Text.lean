import RequestProject.Gvcs.Codec.Canonical
import RequestProject.Gvcs.Codec.Xml
import RequestProject.Gvcs.Codec.Yaml
import RequestProject.Gvcs.Codec.Csv

/-!
# The raw-text codec and format detection

Raw text is a first-class input format (§10).  The rule this module implements is that
unstructured text is never assumed to be meaningless and never destroyed: whatever is
extracted from it, the original text is carried along in `sourceData`, together with the
encoding, the line records, and the confidence of the extraction.

Format detection (§11) follows the prescribed order — declared format, signature,
syntax, then raw-text fallback — and a parser that fails does *not* make the artifact
invalid: `ofRawText_status_not_invalid` proves that the fallback object is `UNKNOWN`,
never `INVALID`.
-/

namespace LifeTrac.Codec

/-! ## Lines

Line records are what a diagnostic points at.  Producing them must not lose the text,
which is what `joinLines_splitLines` says.
-/

/-- Split a character list at newlines, keeping empty lines. -/
def splitLines : List Char → List (List Char)
  | [] => [[]]
  | '\n' :: t => [] :: splitLines t
  | c :: t =>
      match splitLines t with
      | l :: ls => (c :: l) :: ls
      | [] => [[c]]

/-- Rejoin split lines with newlines. -/
def joinLines : List (List Char) → List Char
  | [] => []
  | [l] => l
  | l :: ls => l ++ '\n' :: joinLines ls

theorem splitLines_ne_nil (l : List Char) : splitLines l ≠ [] := by
  match l with
  | [] => simp [splitLines]
  | c :: t =>
      by_cases hc : c = '\n'
      · subst hc; simp [splitLines]
      · rw [splitLines]
        · split <;> simp
        · intro u; exact hc u

/-- **Splitting text into lines loses nothing.** -/
theorem joinLines_splitLines (l : List Char) : joinLines (splitLines l) = l := by
  induction l with
  | nil => rfl
  | cons c t ih =>
    by_cases hc : c = '\n'
    · subst hc
      have hne := splitLines_ne_nil t
      obtain ⟨x, xs, hx⟩ := List.exists_cons_of_ne_nil hne
      simp only [splitLines, hx, joinLines, List.nil_append]
      rw [← hx, ih]
    · obtain ⟨x, xs, hx⟩ := List.exists_cons_of_ne_nil (splitLines_ne_nil t)
      have hsplit : splitLines (c :: t) = (c :: x) :: xs := by
        rw [splitLines]
        · rw [hx]
        · intro u; exact hc u
      rw [hsplit]
      cases xs with
      | nil =>
        have : joinLines (splitLines t) = t := ih
        rw [hx] at this
        simp only [joinLines] at this ⊢
        rw [this]
      | cons y ys =>
        have : joinLines (splitLines t) = t := ih
        rw [hx] at this
        simp only [joinLines] at this ⊢
        rw [← this]
        simp

/-- One line of an artifact, with its number and character offset. -/
structure Line where
  /-- 1-based line number. -/
  number : Nat
  /-- Character offset of the first character of the line. -/
  offset : Nat
  /-- The text of the line, without its terminator. -/
  text : String
  deriving DecidableEq, Repr, Inhabited

/-- Number the split lines, recording character offsets. -/
def numberLines (start : Nat) (offset : Nat) : List (List Char) → List Line
  | [] => []
  | l :: ls =>
      { number := start, offset := offset, text := String.ofList l }
        :: numberLines (start + 1) (offset + l.length + 1) ls

/-- Line records of an artifact. -/
def lineRecords (s : String) : List Line := numberLines 1 0 (splitLines s.toList)

/-- Reassemble the text of a list of line records. -/
def linesText (ls : List Line) : String :=
  String.ofList (joinLines (ls.map (fun l => l.text.toList)))

theorem linesText_numberLines (ls : List (List Char)) (n o : Nat) :
    (numberLines n o ls).map (fun l => l.text.toList) = ls := by
  induction ls generalizing n o with
  | nil => rfl
  | cons l t ih => simp [numberLines, ih]

/-- **Line records reassemble into the original text.** -/
theorem linesText_lineRecords (s : String) : linesText (lineRecords s) = s := by
  simp [linesText, lineRecords, linesText_numberLines, joinLines_splitLines]

/-! ## Raw text -/

/-- A raw-text artifact, with everything the raw-text codec must preserve (§10). -/
structure RawText where
  /-- The original text, verbatim. -/
  text : String
  /-- Character encoding as declared by the producer. -/
  encoding : String := "UTF-8"
  /-- Names of structures detected inside the text. -/
  detectedObjects : List String := []
  /-- Parser confidence, in percent. -/
  confidence : Nat := 0
  deriving DecidableEq, Repr, Inhabited

/-! ## Format detection -/

/-- Read text in a named format (§11, §12–§15). -/
def decodeAs : Format → String → Option ProofObject
  | .ipdl, s => (Ipdl.decode s).bind ProofObject.ofDoc
  | .xml, s => (Xml.decode s).bind ProofObject.ofDoc
  | .yaml, s => (Yaml.decode s).bind ProofObject.ofDoc
  | .csv, s => Csv.decode s
  | .text, s =>
      (((Ipdl.decode s).bind ProofObject.ofDoc).orElse fun _ =>
        (((Xml.decode s).bind ProofObject.ofDoc).orElse fun _ =>
          (((Yaml.decode s).bind ProofObject.ofDoc).orElse fun _ => Csv.decode s)))

/-- Heuristic extraction from arbitrary text: try every structured codec in turn. -/
def extract (s : String) : Option ProofObject := decodeAs .text s

/-- Write a canonical object in a named format. -/
def encodeAs : Format → ProofObject → String
  | .ipdl, p => Ipdl.encode p.toDoc
  | .xml, p => Xml.encode p.toDoc
  | .yaml, p => Yaml.encode p.toDoc
  | .csv, p => Csv.encode p
  | .text, p => canonicalText p

/-- The preservation level each codec is allowed to declare (§9). -/
def preservation : Format → Lossiness
  | .csv => .partialConv
  | .text => .partialConv
  | _ => .lossless

/-- Detection order: declared format, then signature, then the CSV header, then raw
text (§11). -/
def detectFormat (declared : Option Format) (s : String) : Format :=
  match declared with
  | some f => f
  | none =>
      if (expect Csv.header s.toList).isSome then .csv
      else
        match s.toList with
        | '(' :: _ => .ipdl
        | '[' :: _ => .ipdl
        | '<' :: _ => .xml
        | '{' :: _ => .yaml
        | _ => .text

@[simp] theorem detectFormat_declared (f : Format) (s : String) :
    detectFormat (some f) s = f := rfl

theorem detect_ipdl (d : Doc) : detectFormat none (Ipdl.encode d) = .ipdl := by
  have h := Ipdl.renderDoc_head d
  cases hr : (Ipdl.renderDoc d) with
  | nil => rw [hr] at h; simp at h
  | cons x xs =>
    rw [hr] at h
    simp only [List.head?_cons, Option.some.injEq] at h
    rcases h with rfl | rfl <;> simp [detectFormat, Ipdl.encode, hr] <;> rfl

theorem detect_xml (d : Doc) : detectFormat none (Xml.encode d) = .xml := by
  obtain ⟨u, hu, -⟩ := Xml.renderDoc_cons d
  simp [detectFormat, Xml.encode, hu]
  rfl

theorem detect_yaml (d : Doc) : detectFormat none (Yaml.encode d) = .yaml := by
  have h := Yaml.renderDoc_head d []
  rw [List.append_nil] at h
  cases hr : (Yaml.renderDoc d) with
  | nil => rw [hr] at h; simp at h
  | cons x xs =>
    rw [hr] at h
    simp only [List.head?_cons, Option.some.injEq] at h
    subst h
    simp [detectFormat, Yaml.encode, hr]
    rfl

theorem detect_csv (p : ProofObject) : detectFormat none (Csv.encode p) = .csv := by
  have h : (Csv.encode p).toList = Csv.header ++ (Csv.toRows p).flatMap Csv.renderRow := by
    simp [Csv.encode, Csv.renderRows]
  simp [detectFormat, h]

/-! ## Round trips through the named formats -/

@[simp] theorem decodeAs_encodeAs_ipdl (p : ProofObject) :
    decodeAs .ipdl (encodeAs .ipdl p) = some p := by
  simp [decodeAs, encodeAs, Ipdl.decode_encode, ProofObject.ofDoc_toDoc]

@[simp] theorem decodeAs_encodeAs_xml (p : ProofObject) :
    decodeAs .xml (encodeAs .xml p) = some p := by
  simp [decodeAs, encodeAs, Xml.decode_encode, ProofObject.ofDoc_toDoc]

@[simp] theorem decodeAs_encodeAs_yaml (p : ProofObject) :
    decodeAs .yaml (encodeAs .yaml p) = some p := by
  simp [decodeAs, encodeAs, Yaml.decode_encode, ProofObject.ofDoc_toDoc]

@[simp] theorem decodeAs_encodeAs_csv (p : ProofObject) :
    decodeAs .csv (encodeAs .csv p) = some (Csv.csvProject p) := by
  simp [decodeAs, encodeAs, Csv.decode_encode]

@[simp] theorem extract_canonicalText (p : ProofObject) :
    extract (canonicalText p) = some p := by
  simp [extract, decodeAs, canonicalText, Ipdl.decode_encode, ProofObject.ofDoc_toDoc]

@[simp] theorem decodeAs_encodeAs_text (p : ProofObject) :
    decodeAs .text (encodeAs .text p) = some p := extract_canonicalText p

/-! ## The raw-text codec -/

/-- The diagnostic recorded when no structure could be extracted.  It is a warning, not
an error: a failed parser does not make the artifact invalid (§11). -/
def noStructureWarning (encoding : String) : Diagnostic :=
  { id := "raw-1", code := "NO_STRUCTURE_DETECTED", severity := .warning,
    message := "no structured reading was found; the original text is preserved verbatim",
    sourceFormat := "TEXT", expected := "IPDL, XML, YAML or CSV", actual := encoding,
    resolution := "object preserved unresolved", recoverable := true }

/-- Read a raw-text artifact into the canonical model, preserving the original text
whatever happens (§10). -/
def ofRawText (sourceSystem sourceFile : String) (r : RawText) : ProofObject :=
  let prov : Provenance :=
    { sourceSystem := sourceSystem, sourceFile := sourceFile,
      sourceFormat := (detectFormat none r.text).toName,
      transformations := ["decode/raw-text"] }
  match extract r.text with
  | some p =>
      { p with
        sourceFormat := (detectFormat none r.text).toName,
        sourceData := r.text,
        provenance := some prov }
  | none =>
      { id := hashText r.text, kind := "raw-text", inputs := [], outputs := [],
        status := .unknown, sourceFormat := "TEXT", sourceData := r.text,
        provenance := some prov,
        metadata := [("encoding", .str r.encoding), ("confidence", .int r.confidence),
                     ("lines", .int (lineRecords r.text).length)],
        warnings := [noStructureWarning r.encoding],
        extensions := [("raw.detected_objects", .list (r.detectedObjects.map Value.str))] }

/-- **Extraction never destroys the original text** (§10). -/
theorem ofRawText_preserves (sys file : String) (r : RawText) :
    (ofRawText sys file r).sourceData = r.text := by
  simp only [ofRawText]
  cases extract r.text <;> rfl

/-- **A failed parse does not make an artifact invalid** (§11). -/
theorem ofRawText_status_not_invalid (sys file : String) (r : RawText)
    (h : extract r.text = none) : (ofRawText sys file r).status = .unknown := by
  simp [ofRawText, h]

/-- Raw text that does hold a canonical object is read as that object. -/
theorem ofRawText_of_canonical (sys file : String) (p : ProofObject) (enc : String)
    (dets : List String) (conf : Nat) :
    ofRawText sys file (RawText.mk (canonicalText p) enc dets conf)
      = { p with
          sourceFormat := "IPDL",
          sourceData := canonicalText p,
          provenance := some (Provenance.mk sys file "IPDL" "" "" ["decode/raw-text"] none) } := by
  have hd : detectFormat none (canonicalText p) = .ipdl := detect_ipdl p.toDoc
  simp only [ofRawText, extract_canonicalText, hd]
  rfl

/-- What a raw-text export carries: the canonical text, plus the line records that let a
diagnostic point back into it. -/
def toRawText (p : ProofObject) : RawText :=
  { text := canonicalText p, encoding := "UTF-8",
    detectedObjects := ["proof/" ++ p.id], confidence := 100 }

theorem toRawText_text (p : ProofObject) : (toRawText p).text = canonicalText p := rfl

/-- A canonical object exported as raw text can be read back from it. -/
theorem extract_toRawText (p : ProofObject) : extract (toRawText p).text = some p :=
  extract_canonicalText p

end LifeTrac.Codec
