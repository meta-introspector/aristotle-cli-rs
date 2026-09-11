/-
# Format detection, and the import that never fails

Section 11 fixes the order in which a format is determined:

```text
explicit declared format
        ↓
magic/signature detection
        ↓
syntax detection
        ↓
schema detection
        ↓
heuristic extraction
        ↓
raw text fallback
```

and it adds a rule that matters more than the order:

> A failed parser MUST NOT imply that the data is invalid.

So `decodeAuto` always produces a canonical object.  When the chosen
codec cannot parse the input, the raw-text codec takes over, the original
text is preserved verbatim inside the result, and the fallback is
recorded — the input is *unparsed*, never *discarded*.
-/
import RequestProject.Edge.Codec.Registry

namespace CfDeploy
namespace Codec

/-! ## Formats -/

/-- The formats of the standard profile. -/
inductive Format where
  | canonical
  | ipdl
  | xml
  | csv
  | yaml
  | text
  deriving DecidableEq, Repr, Inhabited

namespace Format

def name : Format → String
  | .canonical => "canonical"
  | .ipdl => "ipdl"
  | .xml => "xml"
  | .csv => "csv"
  | .yaml => "yaml"
  | .text => "text"

def ofName (s : String) : Option Format :=
  if s = "canonical" then some .canonical
  else if s = "ipdl" then some .ipdl
  else if s = "xml" then some .xml
  else if s = "csv" then some .csv
  else if s = "yaml" then some .yaml
  else if s = "text" then some .text
  else none

@[simp] theorem ofName_name (f : Format) : ofName (name f) = some f := by
  cases f <;> rfl

end Format

/-- How the format was decided. -/
inductive Evidence where
  /-- the caller declared it -/
  | declared
  /-- a signature identified it -/
  | signature
  /-- nothing identified it, so it is raw text -/
  | fallback
  deriving DecidableEq, Repr, Inhabited

def Evidence.name : Evidence → String
  | .declared => "declared"
  | .signature => "signature"
  | .fallback => "fallback"

/-! ## Signatures -/

/-- Stripping a literal prefix off a text that starts with it. -/
theorem stripPrefix_append : ∀ (sep r : List Char),
    Text.stripPrefix sep (sep ++ r) = some r := by
  intro sep
  induction sep with
  | nil => intro r; rfl
  | cons a sep ih => intro r; simp [Text.stripPrefix, ih]

theorem stripPrefix_head_ne {a b : Char} (h : a ≠ b) (sep s : List Char) :
    Text.stripPrefix (a :: sep) (b :: s) = none := by
  simp [Text.stripPrefix, h]

/-- The CSV signature: the exact header row of §14. -/
def csvPrefix : List Char := Csv.renderRow Csv.header

theorem csvPrefix_head : ∃ t, csvPrefix = '"' :: t := ⟨_, rfl⟩

/-- A canonical serialization starts with its type tag. -/
def isCanonTag (c : Char) : Bool :=
  c = 'N' || c = 'B' || c = 'I' || c = 'D' || c = 'S' || c = 'R' || c = 'L' || c = 'O'

/-- A flow-style YAML document starts with one of these. -/
def isYamlStart (c : Char) : Bool :=
  c = '{' || c = '[' || c = '"' || c = '!' || c = 'n' || c = 't' || c = 'f' ||
    c = '-' || (Digits.charDigit c).isSome

/-- Signature and syntax detection, in the order of §11. -/
def bySignature (cs : List Char) : Option Format :=
  if (Text.stripPrefix csvPrefix cs).isSome then some .csv
  else
    match cs with
    | [] => none
    | c :: _ =>
        if c = '(' then some .ipdl
        else if c = '<' then some .xml
        else if isCanonTag c then some .canonical
        else if isYamlStart c then some .yaml
        else none

/-- What was detected, and on what evidence. -/
structure Detection where
  format : Format
  evidence : Evidence
  deriving DecidableEq, Repr, Inhabited

/-- Decide the format of a text: an explicit declaration first, then the
signature, then raw text. -/
def detectFormat (declared : Option String) (s : String) : Detection :=
  match declared.bind Format.ofName with
  | some f => ⟨f, .declared⟩
  | none =>
      match bySignature s.toList with
      | some f => ⟨f, .signature⟩
      | none => ⟨.text, .fallback⟩

/-- **A declared format is honoured.** -/
@[simp] theorem detectFormat_declared (f : Format) (s : String) :
    detectFormat (some f.name) s = ⟨f, .declared⟩ := by
  simp [detectFormat]

/-! ## The codec of a format -/

def codecFor : Format → StringCodec
  | .canonical => canonicalCodec
  | .ipdl => ipdlCodec
  | .xml => xmlCodec
  | .csv => csvCodec
  | .yaml => yamlCodec
  | .text => textCodec

/-- The result of an import: the canonical object, how it was obtained,
and the original text, which is kept whatever happened. -/
structure Decoded where
  value : CVal
  format : Format
  evidence : Evidence
  /-- true when the chosen codec could not parse and raw text took over -/
  fellBack : Bool
  /-- the source, preserved verbatim (§26 step 2) -/
  source : String
  deriving Repr, Inhabited

/-- Decode a text without being told what it is.  This function is
total: there is no input it rejects. -/
def decodeAuto (declared : Option String) (s : String) : Decoded :=
  let d0 := detectFormat declared s
  -- a document that begins with whitespace is still that document
  let d := if d0.evidence = .fallback then detectFormat declared s.trimAscii.toString else d0
  match (codecFor d.format).decodeDoc s with
  | some v => ⟨v, d.format, d.evidence, false, s⟩
  | none => ⟨Text.RawText.toVal (Text.detect s), .text, d.evidence, true, s⟩

/-- **The source is always preserved.** -/
@[simp] theorem decodeAuto_source (declared : Option String) (s : String) :
    (decodeAuto declared s).source = s := by
  simp only [decodeAuto]
  split <;> rfl

/-- **A failed parse does not lose the data.**  When no codec could read
the input, the result still contains the original text, exactly. -/
theorem decodeAuto_fallback_preserves (declared : Option String) (s : String)
    (h : (decodeAuto declared s).fellBack = true) :
    (decodeAuto declared s).value = Text.RawText.toVal (Text.detect s) ∧
      (Text.RawText.ofVal (decodeAuto declared s).value).text = s := by
  simp only [decodeAuto] at h ⊢
  split at h
  · simp at h
  · exact ⟨rfl, by simp⟩

/-! ## Detection recognises what the codecs produce -/

theorem bySignature_csv (v : CVal) : bySignature (Csv.encode v).toList = some .csv := by
  have : (Csv.encode v).toList = csvPrefix ++ Csv.renderRows (Csv.rows v "r" "" "") := by
    simp [Csv.encode, Csv.renderRows, csvPrefix, String.toList_ofList]
  simp [bySignature, this, stripPrefix_append]

theorem bySignature_ipdl (v : CVal) : bySignature (Ipdl.encode v).toList = some .ipdl := by
  obtain ⟨t, ht⟩ : ∃ t, Ipdl.emit v = '(' :: t := by
    cases v with
    | bool b => cases b <;> exact ⟨_, rfl⟩
    | _ => exact ⟨_, rfl⟩
  obtain ⟨p, hp⟩ := csvPrefix_head
  simp [bySignature, Ipdl.encode, String.toList_ofList, ht, hp,
    stripPrefix_head_ne (by decide : ('"' : Char) ≠ '(')]

theorem bySignature_canonical (v : CVal) : bySignature (CVal.encode v).toList = some .canonical := by
  obtain ⟨t, ht⟩ := CVal.serL_tag v
  obtain ⟨p, hp⟩ := csvPrefix_head
  have hne : ('"' : Char) ≠ CVal.tag v := by cases v <;> simp [CVal.tag]
  have htag : isCanonTag (CVal.tag v) = true := by cases v <;> simp [CVal.tag, isCanonTag]
  have hpar : ¬(CVal.tag v = '(') := by cases v <;> simp [CVal.tag]
  have hlt : ¬(CVal.tag v = '<') := by cases v <;> simp [CVal.tag]
  simp [bySignature, CVal.encode, String.toList_ofList, ht, hp,
    stripPrefix_head_ne hne, hpar, hlt, htag]

theorem bySignature_yaml_obj (fs : List (String × CVal)) :
    bySignature (Yaml.encode (.obj fs)).toList = some .yaml := by
  obtain ⟨p, hp⟩ := csvPrefix_head
  simp [bySignature, Yaml.encode, Yaml.flow, String.toList_ofList, hp,
    stripPrefix_head_ne (by decide : ('"' : Char) ≠ '{'), isCanonTag, isYamlStart]

theorem bySignature_yaml_list (xs : List CVal) :
    bySignature (Yaml.encode (.list xs)).toList = some .yaml := by
  obtain ⟨p, hp⟩ := csvPrefix_head
  simp [bySignature, Yaml.encode, Yaml.flow, String.toList_ofList, hp,
    stripPrefix_head_ne (by decide : ('"' : Char) ≠ '['), isCanonTag, isYamlStart]

theorem bySignature_xml (v : CVal) (h : Xml.noReserved v = true) :
    bySignature (Xml.encode v).toList = some .xml := by
  obtain ⟨p, hp⟩ := csvPrefix_head
  have hw := Xml.wf_ofVal_all.1 v h
  cases hx : Xml.ofVal v with
  | text s => rw [hx] at hw; simp [Xml.isText] at hw
  | elem n a k =>
      simp [bySignature, Xml.encode, Xml.renderDoc, hx, Xml.render,
        String.toList_ofList, hp, stripPrefix_head_ne (by decide : ('"' : Char) ≠ '<')]

/-! ## Auto-decoding recovers what the codecs wrote -/

theorem decodeAuto_ipdl (v : CVal) :
    decodeAuto none (Ipdl.encode v) = ⟨v, .ipdl, .signature, false, Ipdl.encode v⟩ := by
  simp [decodeAuto, detectFormat, bySignature_ipdl, codecFor, ipdlCodec,
    StringCodec.decodeDoc, Ipdl.decode_encode]

theorem decodeAuto_canonical (v : CVal) :
    decodeAuto none (CVal.encode v) = ⟨v, .canonical, .signature, false, CVal.encode v⟩ := by
  simp [decodeAuto, detectFormat, bySignature_canonical, codecFor, canonicalCodec,
    StringCodec.decodeDoc]

theorem decodeAuto_csv (v : CVal) :
    decodeAuto none (Csv.encode v) = ⟨v, .csv, .signature, false, Csv.encode v⟩ := by
  simp [decodeAuto, detectFormat, bySignature_csv, codecFor, csvCodec,
    StringCodec.decodeDoc, Csv.decode_encode]

theorem decodeAuto_yaml_obj (fs : List (String × CVal)) :
    decodeAuto none (Yaml.encode (.obj fs))
      = ⟨.obj fs, .yaml, .signature, false, Yaml.encode (.obj fs)⟩ := by
  simp [decodeAuto, detectFormat, bySignature_yaml_obj, codecFor, yamlCodec,
    StringCodec.decodeDoc, Yaml.decode_encode]

theorem decodeAuto_xml (v : CVal) (h : Xml.noReserved v = true) :
    decodeAuto none (Xml.encode v) = ⟨v, .xml, .signature, false, Xml.encode v⟩ := by
  simp [decodeAuto, detectFormat, bySignature_xml v h, codecFor, xmlCodec,
    StringCodec.decodeDoc, Xml.decode_encode v h]

end Codec
end CfDeploy
