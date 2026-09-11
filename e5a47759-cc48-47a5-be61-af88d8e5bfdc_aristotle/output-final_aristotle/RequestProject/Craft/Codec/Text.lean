/-
# Standard Proof Codec — raw text codec (SOP §10, §11)

Raw text is a first-class input format. The codec must not assume that
unstructured text is meaningless, and extraction must never destroy the
original.

This file provides:

* `analyze`, which turns arbitrary text into a `RawText` record carrying the
  original text, its declared encoding, its lines with line numbers and
  character offsets, the structures detected in it, and a parser confidence;
* `emit` / `extract`, the direction in which the codec itself writes text: a
  canonical block inside a human-readable report, which is read back exactly.

Proved:

* `original_preserved` — the original text survives extraction verbatim;
* `lines_reconstruct` — the recorded lines, rejoined, are exactly the original
  text, so the line index drops nothing;
* `confidence_le` — the reported confidence is a genuine fraction;
* `extract_emit` — text written by this codec is read back with the same
  semantics (so the raw-text codec is lossless in the direction it writes, and
  only partial when reading foreign text).
-/
import RequestProject.Craft.Codec.Canonical

namespace Codec

namespace Text

open CValue

/-! ## Lines -/

/-- Split text into lines at newline characters. -/
def splitLines : List Char → List (List Char)
  | [] => [[]]
  | c :: cs =>
      if c = '\n' then [] :: splitLines cs
      else
        match splitLines cs with
        | l :: ls => (c :: l) :: ls
        | [] => [[c]]

/-- Rejoin lines with newline characters. -/
def joinLines : List (List Char) → List Char
  | [] => []
  | [l] => l
  | l :: ls => l ++ '\n' :: joinLines ls

theorem splitLines_ne_nil (cs : List Char) : splitLines cs ≠ [] := by
  induction cs with
  | nil => simp [splitLines]
  | cons c cs ih =>
      by_cases h : c = '\n'
      · simp [splitLines, h]
      · simp only [splitLines, if_neg h]
        cases hsplit : splitLines cs with
        | nil => simp
        | cons l ls => simp

/-- Splitting text into lines loses nothing. -/
theorem joinLines_splitLines (cs : List Char) : joinLines (splitLines cs) = cs := by
  induction cs with
  | nil => rfl
  | cons c cs ih =>
      by_cases h : c = '\n'
      · subst h
        cases hsplit : splitLines cs with
        | nil => exact absurd hsplit (splitLines_ne_nil cs)
        | cons l ls =>
            rw [hsplit] at ih
            simp [splitLines, hsplit, joinLines, ih]
      · simp only [splitLines, if_neg h]
        cases hsplit : splitLines cs with
        | nil => exact absurd hsplit (splitLines_ne_nil cs)
        | cons l ls =>
            rw [hsplit] at ih
            cases ls with
            | nil => simpa [joinLines] using congrArg (fun t => c :: t) ih
            | cons l' ls' =>
                simp only [joinLines, List.cons_append]
                simpa [joinLines] using congrArg (fun t => c :: t) ih

/-! ## Detection (SOP §11) -/

/-- Split a line at the first `": "`, the shape of a `key: value` line. -/
def splitAtColon : List Char → Option (List Char × List Char)
  | [] => none
  | ':' :: ' ' :: rest => some ([], rest)
  | c :: rest => (splitAtColon rest).map (fun p => (c :: p.1, p.2))

/-- A structure detected in raw text, with where it was found. -/
structure Detection where
  /-- What kind of structure was recognised. -/
  kind : String
  /-- Line number, counting from 1. -/
  line : Nat
  /-- Character offset of the start of the line. -/
  offset : Nat
  /-- The canonical object extracted from it. -/
  extracted : CValue
  deriving Repr, DecidableEq, Inhabited

/-- Try to read a `key: value` line. -/
def detectLine (n off : Nat) (l : List Char) : Option Detection :=
  match splitAtColon l with
  | some (k, v) =>
      some { kind := "key_value", line := n, offset := off,
             extracted := .obj [("key", .str (String.ofList k)),
                                ("value", .str (String.ofList v))] }
  | none => none

/-- Raw text as a first-class exchange object (SOP §10). -/
structure RawText where
  /-- The original text, preserved verbatim. -/
  text : String
  /-- Declared encoding. -/
  encoding : String
  /-- The lines, as line number, offset and content. -/
  lines : List (Nat × Nat × String)
  /-- The structures detected in the text. -/
  detected : List Detection
  /-- Parser confidence, in parts per thousand. -/
  confidence : Nat
  deriving Repr, DecidableEq, Inhabited

/-- Number lines, recording their character offsets. -/
def annotate : Nat → Nat → List (List Char) → List (Nat × Nat × String)
  | _, _, [] => []
  | n, off, l :: ls => (n, off, String.ofList l) :: annotate (n + 1) (off + l.length + 1) ls

theorem annotate_contents :
    ∀ (ls : List (List Char)) (n off : Nat),
      (annotate n off ls).map (fun t => t.2.2.toList) = ls := by
  intro ls
  induction ls with
  | nil => intro n off; rfl
  | cons l ls ih => intro n off; simp [annotate, ih]

/-- Analyse arbitrary text (SOP §10, §11): preserve it, index its lines, and
extract whatever structure can be recognised. -/
def analyze (encoding : String) (s : String) : RawText :=
  let ls := splitLines s.toList
  let numbered := annotate 1 0 ls
  let detected := numbered.filterMap (fun t => detectLine t.1 t.2.1 t.2.2.toList)
  { text := s, encoding := encoding, lines := numbered, detected := detected,
    confidence := if numbered.length = 0 then 0 else 1000 * detected.length / numbered.length }

/-- Represent analysed raw text as a canonical value; the original text is one
of the fields, so extraction cannot destroy it (SOP §10). -/
def toCValue (r : RawText) : CValue :=
  .obj [("$text.original", .str r.text),
        ("$text.encoding", .str r.encoding),
        ("$text.lines", .list (r.lines.map (fun t =>
          CValue.obj [("line", .int (t.1 : Int)), ("offset", .int (t.2.1 : Int)),
                      ("content", .str t.2.2)]))),
        ("$text.detected", .list (r.detected.map (fun d =>
          CValue.obj [("kind", .str d.kind), ("line", .int (d.line : Int)),
                      ("offset", .int (d.offset : Int)), ("extracted", d.extracted)]))),
        ("$text.confidence", .int (r.confidence : Int))]

/-- Extraction never destroys the original text (SOP §10). -/
theorem original_preserved (encoding s : String) :
    (toCValue (analyze encoding s)).get? "$text.original" = some (.str s) := by
  simp [toCValue, analyze, CValue.get?]

/-- The recorded line index drops nothing: rejoining the recorded lines gives
back exactly the original text. -/
theorem lines_reconstruct (encoding s : String) :
    joinLines ((analyze encoding s).lines.map (fun t => t.2.2.toList)) = s.toList := by
  simp only [analyze, annotate_contents]
  exact joinLines_splitLines s.toList

/-- The reported confidence is a fraction of the lines that were recognised. -/
theorem confidence_le (encoding s : String) : (analyze encoding s).confidence ≤ 1000 := by
  simp only [analyze]
  split
  · exact Nat.zero_le _
  · rename_i h
    have hlen : (List.filterMap
        (fun t => detectLine t.1 t.2.1 t.2.2.toList) (annotate 1 0 (splitLines s.toList))).length
        ≤ (annotate 1 0 (splitLines s.toList)).length := List.length_filterMap_le _ _
    have hpos : 0 < (annotate 1 0 (splitLines s.toList)).length := Nat.pos_of_ne_zero h
    calc 1000 * _ / (annotate 1 0 (splitLines s.toList)).length
        ≤ 1000 * (annotate 1 0 (splitLines s.toList)).length /
            (annotate 1 0 (splitLines s.toList)).length :=
          Nat.div_le_div_right (Nat.mul_le_mul_left 1000 hlen)
      _ = 1000 := by rw [Nat.mul_div_cancel _ hpos]

/-! ## Writing and reading canonical text -/

/-- The header line the codec writes before a canonical block. -/
def headerLine : String := "PROOF-CANONICAL/1.0"

/-- Write a canonical value as a raw-text artifact. -/
def emit (v : CValue) : String :=
  String.ofList (headerLine.toList ++ '\n' :: (CValue.serialize v).toList)

/-- Read a canonical value out of a raw-text artifact, if it carries one. -/
def extract (s : String) : Option CValue :=
  match s.toList.dropWhile (fun c => c ≠ '\n') with
  | '\n' :: rest => CValue.decode rest
  | _ => none

/-- Text written by this codec is read back with the same semantics: the
raw-text codec is lossless in the direction it writes (SOP §10, §17). -/
theorem extract_emit (v : CValue) : extract (emit v) = some (CValue.normalize v) := by
  have hhdr : headerLine.toList.dropWhile (fun c => c ≠ '\n') = [] := by decide
  unfold extract emit
  rw [String.toList_ofList, List.dropWhile_append]
  simp only [hhdr, List.isEmpty_nil]
  have : (fun c => decide (c ≠ '\n')) '\n' = false := by decide
  simp only [List.dropWhile, this]
  simpa [CValue.serialize] using CValue.decode_enc (CValue.normalize v)

/-- A failed parse does not mean the data is invalid (SOP §11): whatever the
extractor makes of a text, the text itself and its complete line index are
still there. -/
theorem failed_parse_preserves_everything (encoding s : String) :
    (toCValue (analyze encoding s)).get? "$text.original" = some (.str s) ∧
      joinLines ((analyze encoding s).lines.map (fun t => t.2.2.toList)) = s.toList :=
  ⟨original_preserved encoding s, lines_reconstruct encoding s⟩

end Text
end Codec
