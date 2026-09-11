/-
# The raw-text codec

Unstructured text is a first-class input format, not a failure mode.  A
Lean transcript, a compiler log, a proof sketch, a stack trace: the codec
must be able to carry it, and whatever it manages to recognise inside it,
*without* destroying the original.

This file provides

* `RawText` — the original text, its encoding, its lines with numbers and
  offsets, the objects detection found, and the parser's confidence;
* `detect` — the heuristic extractor;
* the preservation theorems: the original text is kept verbatim
  (`detect_text`), the line index recomposes to exactly the original
  (`joinText_lines_detect`), and splitting a line at a separator loses
  nothing (`splitOnFirst_recompose`).

The operational rule of the specification —

```text
PRESERVE → DECODE → NORMALIZE → VALIDATE → RESOLVE → EXCHANGE
```

— begins with PRESERVE, and for raw text that is exactly what these
theorems say.
-/
import RequestProject.Edge.Codec.Model

namespace CfDeploy
namespace Codec
namespace Text

/-! ## Splitting into lines, reversibly -/

/-- Prepend a character to the first line. -/
def consFirst (c : Char) : List (List Char) → List (List Char)
  | [] => [[c]]
  | l :: ls => (c :: l) :: ls

/-- Split a character list at newlines.  The newlines themselves are not
kept: `joinLines` puts them back. -/
def lineChunks : List Char → List (List Char)
  | [] => [[]]
  | '\n' :: r => [] :: lineChunks r
  | c :: r => consFirst c (lineChunks r)

/-- Reassemble the lines of a text. -/
def joinLines : List (List Char) → List Char
  | [] => []
  | [l] => l
  | l :: ls => l ++ '\n' :: joinLines ls

theorem lineChunks_cons {c : Char} (h : c ≠ '\n') (r : List Char) :
    lineChunks (c :: r) = consFirst c (lineChunks r) := by
  rw [lineChunks.eq_def]
  split <;> simp_all

theorem consFirst_ne_nil (c : Char) (ls : List (List Char)) : consFirst c ls ≠ [] := by
  cases ls <;> simp [consFirst]

theorem lineChunks_ne_nil (cs : List Char) : lineChunks cs ≠ [] := by
  cases cs with
  | nil => simp [lineChunks]
  | cons c r =>
      by_cases h : c = '\n'
      · subst h; simp [lineChunks]
      · rw [lineChunks_cons h]; exact consFirst_ne_nil c _

theorem joinLines_consFirst (c : Char) (ls : List (List Char)) :
    joinLines (consFirst c ls) = c :: joinLines ls := by
  cases ls with
  | nil => rfl
  | cons l ls =>
      cases ls with
      | nil => rfl
      | cons m ms => simp [consFirst, joinLines]

/-- **Nothing is lost.**  Splitting a text into lines and joining them
again returns exactly the original text. -/
theorem joinLines_lineChunks (cs : List Char) : joinLines (lineChunks cs) = cs := by
  induction cs with
  | nil => rfl
  | cons c r ih =>
      by_cases h : c = '\n'
      · subst h
        rw [lineChunks]
        cases hl : lineChunks r with
        | nil => exact absurd hl (lineChunks_ne_nil r)
        | cons l ls =>
            rw [hl] at ih
            show [] ++ '\n' :: joinLines (l :: ls) = '\n' :: r
            rw [ih]
            simp
      · rw [lineChunks_cons h, joinLines_consFirst, ih]

/-! ## Separators, without losing what is around them -/

/-- Strip a literal prefix. -/
def stripPrefix : List Char → List Char → Option (List Char)
  | [], s => some s
  | _ :: _, [] => none
  | a :: sep, b :: s => if a = b then stripPrefix sep s else none

theorem stripPrefix_sound : ∀ (sep s r : List Char), stripPrefix sep s = some r → sep ++ r = s := by
  intro sep
  induction sep with
  | nil => intro s r h; simpa [stripPrefix] using h.symm
  | cons a sep ih =>
      intro s r h
      cases s with
      | nil => simp [stripPrefix] at h
      | cons b s =>
          by_cases hab : a = b
          · subst hab
            simp only [stripPrefix] at h
            simpa using ih s r h
          · simp [stripPrefix, hab] at h

/-- Split at the first occurrence of a separator. -/
def splitOnFirst (s sep : List Char) : Option (List Char × List Char) :=
  match stripPrefix sep s with
  | some r => some ([], r)
  | none =>
      match s with
      | [] => none
      | c :: r => (splitOnFirst r sep).map (fun p => (c :: p.1, p.2))

/-- **Extraction does not destroy the text.**  Whatever a split found,
the two halves and the separator recompose to the original line. -/
theorem splitOnFirst_recompose : ∀ (s sep a b : List Char),
    splitOnFirst s sep = some (a, b) → a ++ sep ++ b = s := by
  intro s
  induction s with
  | nil =>
      intro sep a b h
      rw [splitOnFirst] at h
      cases hp : stripPrefix sep [] with
      | some r =>
          rw [hp] at h
          simp only [Option.some.injEq, Prod.mk.injEq] at h
          obtain ⟨ha, hb⟩ := h
          subst ha; subst hb
          simpa using stripPrefix_sound sep [] r hp
      | none => rw [hp] at h; simp at h
  | cons c t ih =>
      intro sep a b h
      rw [splitOnFirst] at h
      cases hp : stripPrefix sep (c :: t) with
      | some r =>
          rw [hp] at h
          simp only [Option.some.injEq, Prod.mk.injEq] at h
          obtain ⟨ha, hb⟩ := h
          subst ha; subst hb
          simpa using stripPrefix_sound sep (c :: t) r hp
      | none =>
          rw [hp] at h
          simp only [Option.map_eq_some_iff] at h
          obtain ⟨p, hp', heq⟩ := h
          obtain ⟨ha, hb⟩ := Prod.mk.injEq .. ▸ heq
          cases a with
          | nil => simp at ha
          | cons a0 a' =>
              simp only [List.cons.injEq] at ha
              obtain ⟨h0, h1⟩ := ha
              subst h0
              have := ih sep a' b (by rw [hp']; rw [← h1, ← hb])
              simp [this]

/-- Does the text contain this substring? -/
def containsSub (s sub : List Char) : Bool :=
  match stripPrefix sub s with
  | some _ => true
  | none =>
      match s with
      | [] => false
      | _ :: r => containsSub r sub

/-! ## The raw-text object -/

/-- One line of the original text, with its number (from 1) and the
character offset at which it starts. -/
structure Line where
  number : Nat
  offset : Nat
  text : String
  deriving Repr, Inhabited, DecidableEq

/-- Something detection recognised inside the text.  `text` is the exact
substring it was recognised from, so the finding can always be traced
back to the original. -/
structure Detected where
  kind : String
  line : Nat
  offset : Nat
  text : String
  value : CVal
  deriving Repr, Inhabited

/-- A raw text and everything that was learned about it.  The original is
always present, whatever detection did or did not manage. -/
structure RawText where
  text : String
  encoding : String := "utf-8"
  lines : List Line := []
  detected : List Detected := []
  /-- the share of lines that were recognised, in percent -/
  confidence : Nat := 0
  deriving Repr, Inhabited

/-! ## Building the line index -/

/-- Number the chunks of a text, tracking character offsets. -/
def numberLines (n off : Nat) : List (List Char) → List Line
  | [] => []
  | l :: ls => ⟨n, off, String.ofList l⟩ :: numberLines (n + 1) (off + l.length + 1) ls

theorem map_text_numberLines : ∀ (ls : List (List Char)) (n off : Nat),
    (numberLines n off ls).map (fun l => l.text.toList) = ls := by
  intro ls
  induction ls with
  | nil => intros; rfl
  | cons l ls ih => intro n off; simp [numberLines, ih]

/-- Put the lines of a raw text back together. -/
def joinText (ls : List Line) : String :=
  String.ofList (joinLines (ls.map (fun l => l.text.toList)))

/-! ## Detection -/

/-- The heuristics.  Each returns the kind it recognised, and the
canonical object extracted from the line. -/
def detectLine (l : Line) : Option Detected :=
  let cs := l.text.toList
  if containsSub cs " error:".toList || containsSub cs "error:".toList then
    some ⟨"diagnostic.error", l.number, l.offset, l.text,
      .obj [("severity", .str "ERROR"), ("message", .str l.text)]⟩
  else if containsSub cs "warning:".toList then
    some ⟨"diagnostic.warning", l.number, l.offset, l.text,
      .obj [("severity", .str "WARNING"), ("message", .str l.text)]⟩
  else if containsSub cs "sorry".toList then
    some ⟨"proof.incomplete", l.number, l.offset, l.text,
      .obj [("marker", .str "sorry"), ("message", .str l.text)]⟩
  else if (stripPrefix "theorem ".toList cs).isSome
      || (stripPrefix "lemma ".toList cs).isSome then
    some ⟨"proof.statement", l.number, l.offset, l.text,
      .obj [("statement", .str l.text)]⟩
  else
    match splitOnFirst cs ": ".toList with
    | some (k, v) =>
        if k.isEmpty || containsSub k [' '] then none
        else some ⟨"field", l.number, l.offset, l.text,
          .obj [("key", .str (String.ofList k)), ("value", .str (String.ofList v))]⟩
    | none => none

/-- Detect what can be detected in each line. -/
def detectLines : List Line → List Detected
  | [] => []
  | l :: ls =>
      match detectLine l with
      | some d => d :: detectLines ls
      | none => detectLines ls

/-- Import a raw text: preserve it, index its lines, extract what can be
extracted, and record how much of it was recognised. -/
def detect (s : String) (encoding : String := "utf-8") : RawText :=
  let ls := numberLines 1 0 (lineChunks s.toList)
  let ds := detectLines ls
  { text := s
    encoding := encoding
    lines := ls
    detected := ds
    confidence := if ls.isEmpty then 0 else 100 * ds.length / ls.length }

/-- **The original survives.** -/
@[simp] theorem detect_text (s : String) (enc : String) : (detect s enc).text = s := rfl

/-- **The line index is exact.**  Rejoining the indexed lines returns the
original text character for character. -/
theorem joinText_lines_detect (s : String) (enc : String) :
    joinText (detect s enc).lines = s := by
  simp only [joinText, detect, map_text_numberLines, joinLines_lineChunks,
    String.ofList_toList]

/-! ## The raw text as a canonical object -/

namespace Line

def toVal (l : Line) : CVal :=
  .obj [("number", .int l.number), ("offset", .int l.offset), ("text", .str l.text)]

/-- A natural-number field. -/
def natOf (fs : List (String × CVal)) (k : String) : Nat :=
  match Fields.find fs k with
  | some (.int i) => i.toNat
  | _ => 0

def ofVal (v : CVal) : Line :=
  match v with
  | .obj fs => ⟨natOf fs "number", natOf fs "offset", Fields.str fs "text"⟩
  | _ => ⟨0, 0, ""⟩

@[simp] theorem ofVal_toVal (l : Line) : ofVal (toVal l) = l := by
  cases l
  simp [ofVal, toVal, natOf, Fields.find, Fields.str]

end Line

namespace Detected

def toVal (d : Detected) : CVal :=
  .obj [ ("kind", .str d.kind), ("line", .int d.line), ("offset", .int d.offset)
       , ("text", .str d.text), ("value", d.value) ]

def ofVal (v : CVal) : Detected :=
  match v with
  | .obj fs =>
      ⟨Fields.str fs "kind", Line.natOf fs "line", Line.natOf fs "offset",
        Fields.str fs "text", Fields.val fs "value"⟩
  | _ => ⟨"", 0, 0, "", .null⟩

@[simp] theorem ofVal_toVal (d : Detected) : ofVal (toVal d) = d := by
  cases d
  simp [ofVal, toVal, Line.natOf, Fields.find, Fields.str, Fields.val]

end Detected

namespace RawText

theorem map_ofVal_toVal_lines (ls : List Line) :
    ls.map (Line.ofVal ∘ Line.toVal) = ls := by
  induction ls with
  | nil => rfl
  | cons l ls ih => simp [ih]

theorem map_ofVal_toVal_detected (ds : List Detected) :
    ds.map (Detected.ofVal ∘ Detected.toVal) = ds := by
  induction ds with
  | nil => rfl
  | cons d ds ih => simp [ih]

/-- The canonical form of a raw text.  Nothing is summarised away: the
original text is a field like any other. -/
def toVal (r : RawText) : CVal :=
  .obj [ ("confidence", .int r.confidence)
       , ("detected", .list (r.detected.map Detected.toVal))
       , ("encoding", .str r.encoding)
       , ("lines", .list (r.lines.map Line.toVal))
       , ("original_text", .str r.text) ]

def ofVal (v : CVal) : RawText :=
  match v with
  | .obj fs =>
      { text := Fields.str fs "original_text"
        encoding := Fields.str fs "encoding"
        lines := (Fields.items fs "lines").map Line.ofVal
        detected := (Fields.items fs "detected").map Detected.ofVal
        confidence := Line.natOf fs "confidence" }
  | _ => { text := "" }

@[simp] theorem ofVal_toVal (r : RawText) : ofVal (toVal r) = r := by
  cases r
  simp [ofVal, toVal, Line.natOf, Fields.find, Fields.str, Fields.items,
    map_ofVal_toVal_lines, map_ofVal_toVal_detected]

end RawText

/-- **Raw text round-trips through the canonical model**, original text
included. -/
theorem canonical_roundtrip (s : String) :
    (RawText.ofVal (RawText.toVal (detect s))).text = s := by
  simp

end Text
end Codec
end CfDeploy
