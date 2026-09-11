import RequestProject.Solfunmeme.Codec.Line

/-!
# The five codecs

§12–§15 and §10 of the specification, as five values of `RowSyntax` and one
`decide` each.  Everything that makes them codecs — the round trip of §17, the
honest preservation level of §9 — is inherited from `Codec.Line`.

| codec | §  | rows look like |
|-------|----|----------------|
| `ipdl` | 12 | `  (cell object_id=p1 object_type=proof …)` |
| `xml`  | 13 | `  <cell object_id="p1" object_type="proof" …/>` |
| `csv`  | 14 | `p1,proof,status,VALID,string,` |
| `yaml` | 15 | `  - {object_id: "p1", …}` |
| `text` | 10 | tab separated rows under a comment header |

All five carry the *same* six columns of §14, because all five are projections
of the same canonical table, and none of them needs quoting rules of its own:
`Codec.Escape` has already removed every delimiter from every value, including
the brackets an s-expression or flow-mapping reader has to balance.

The last section gives §9 its counterexample: `flatCsv`, the naive "one row per
object" CSV that drops the nesting, is *not* lossless, and that is proved by
exhibiting two different objects with the same flat projection.
-/

namespace Solfunmeme.Codec

/-! ## §12 IPDL -/

/-- IPDL: an s-expression document, one `(cell …)` form per row. -/
def ipdl : RowSyntax where
  name := "ipdl"
  version := "1.0"
  escapeSpace := true
  sep := ' '
  open_ := "  (cell "
  close_ := ")"
  decos :=
    [("object_id=", ""), ("object_type=", ""), ("field=", ""),
     ("value=", ""), ("value_type=", ""), ("parent_id=", "")]
  header :=
    ["(ipdl-document",
     "  :schema \"proof-schema/1.0\"",
     "  :codec \"ipdl/1.0\"",
     "  :cells ("]
  footer := ["  )", ")"]

theorem ipdl_wf : ipdl.WF := by decide

/-- Export a canonical object as IPDL. -/
def toIpdl (p : ProofObject) : String := ipdl.encode p

/-- Import a canonical object from IPDL. -/
def ofIpdl (s : String) : Option ProofObject := ipdl.decode s

theorem ofIpdl_toIpdl (p : ProofObject) : ofIpdl (toIpdl p) = some p :=
  RowSyntax.decode_encode ipdl_wf p

/-! ## §13 XML -/

/-- XML: one `<cell/>` element per row, attributes for the six columns, in a
namespaced root element.  Attribute values are escaped, so `<`, `>`, `&` and
`"` never reach the document. -/
def xml : RowSyntax where
  name := "xml"
  version := "1.0"
  escapeSpace := true
  sep := ' '
  open_ := "  <cell "
  close_ := "/>"
  decos :=
    [("object_id=\"", "\""), ("object_type=\"", "\""), ("field=\"", "\""),
     ("value=\"", "\""), ("value_type=\"", "\""), ("parent_id=\"", "\"")]
  header :=
    ["<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
     "<proof-table xmlns=\"https://solfunmeme.org/codec/proof-table/1.0\" schema=\"proof-schema/1.0\">"]
  footer := ["</proof-table>"]

theorem xml_wf : xml.WF := by decide

/-- Export a canonical object as XML. -/
def toXml (p : ProofObject) : String := xml.encode p

/-- Import a canonical object from XML. -/
def ofXml (s : String) : Option ProofObject := xml.decode s

theorem ofXml_toXml (p : ProofObject) : ofXml (toXml p) = some p :=
  RowSyntax.decode_encode xml_wf p

/-! ## §14 CSV -/

/-- CSV in exactly the convention recommended by §14. -/
def csv : RowSyntax where
  name := "csv"
  version := "1.0"
  escapeSpace := false
  sep := ','
  open_ := ""
  close_ := ""
  decos := [("", ""), ("", ""), ("", ""), ("", ""), ("", ""), ("", "")]
  header := ["object_id,object_type,field,value,value_type,parent_id"]
  footer := []

theorem csv_wf : csv.WF := by decide

/-- Export a canonical object as CSV. -/
def toCsv (p : ProofObject) : String := csv.encode p

/-- Import a canonical object from CSV. -/
def ofCsv (s : String) : Option ProofObject := csv.decode s

theorem ofCsv_toCsv (p : ProofObject) : ofCsv (toCsv p) = some p :=
  RowSyntax.decode_encode csv_wf p

/-! ## §15 YAML -/

/-- YAML: the human-readable projection, one flow mapping per row. -/
def yaml : RowSyntax where
  name := "yaml"
  version := "1.0"
  escapeSpace := false
  sep := ','
  open_ := "  - {"
  close_ := "}"
  decos :=
    [("object_id: \"", "\""), ("object_type: \"", "\""), ("field: \"", "\""),
     ("value: \"", "\""), ("value_type: \"", "\""), ("parent_id: \"", "\"")]
  header := ["schema: proof-schema/1.0", "codec: yaml/1.0", "cells:"]
  footer := []

theorem yaml_wf : yaml.WF := by decide

/-- Export a canonical object as YAML. -/
def toYaml (p : ProofObject) : String := yaml.encode p

/-- Import a canonical object from YAML. -/
def ofYaml (s : String) : Option ProofObject := yaml.decode s

theorem ofYaml_toYaml (p : ProofObject) : ofYaml (toYaml p) = some p :=
  RowSyntax.decode_encode yaml_wf p

/-! ## §10 Text -/

/-- Plain text: tab separated rows under a comment header.  This is the format
a log or a paste can carry, and it is still a complete canonical object. -/
def text : RowSyntax where
  name := "text"
  version := "1.0"
  escapeSpace := false
  sep := '\t'
  open_ := ""
  close_ := ""
  decos := [("", ""), ("", ""), ("", ""), ("", ""), ("", ""), ("", "")]
  header :=
    ["# canonical proof object, proof-schema/1.0, codec text/1.0",
     "# object_id\tobject_type\tfield\tvalue\tvalue_type\tparent_id"]
  footer := []

theorem text_wf : text.WF := by decide

/-- Export a canonical object as plain text. -/
def toText (p : ProofObject) : String := text.encode p

/-- Import a canonical object from plain text. -/
def ofText (s : String) : Option ProofObject := text.decode s

theorem ofText_toText (p : ProofObject) : ofText (toText p) = some p :=
  RowSyntax.decode_encode text_wf p

/-! ## The registry -/

/-- Every codec this implementation offers, with its declared preservation
level (§9).  All five are lossless, and `codecs_lossless` is the proof. -/
def codecs : List RowSyntax := [ipdl, xml, csv, yaml, text]

/-- §11: the format a document declares, resolved to a codec.  Detection falls
back to `none` rather than to a guess. -/
def codecOfName (n : String) : Option RowSyntax := codecs.find? (fun r => r.name == n)

theorem codecs_wf : ∀ r ∈ codecs, r.WF := by
  intro r hr
  simp [codecs] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact ipdl_wf
  · exact xml_wf
  · exact csv_wf
  · exact yaml_wf
  · exact text_wf

/-- §36: any canonical object can be exported in every codec of the registry
and imported back unchanged. -/
theorem codecs_lossless (r : RowSyntax) (hr : r ∈ codecs) (p : ProofObject) :
    r.decode (r.encode p) = some p :=
  RowSyntax.decode_encode (codecs_wf r hr) p

/-! ## §9 A conversion that is genuinely lossy

The specification warns that "CSV may not be capable of representing arbitrary
nested proof structures without additional conventions".  The convention of §14
is exactly what buys `csv` its losslessness above.  Drop it — flatten each
object to one row of scalars — and the warning becomes a theorem. -/

/-- The naive flat CSV: one row per proof, scalars only, no nesting. -/
def flatCsv (p : ProofObject) : String :=
  joinFields ',' [escape false p.id, escape false p.kind, escape false p.status.name] ++ "\n"

/-- §9: the flat projection must declare itself `PARTIAL`. -/
def flatCsvLossiness : Lossiness := .PARTIAL

/-- And the declaration is honest: two objects that differ in their inputs —
that is, in their proof content — have the same flat projection, so no decoder
whatsoever can invert it. -/
theorem flatCsv_not_injective :
    ∃ p q : ProofObject, p ≠ q ∧ flatCsv p = flatCsv q := by
  refine ⟨{ id := "p1", kind := "theorem", inputs := [{ name := "n", value := "144" }] },
          { id := "p1", kind := "theorem" }, ?_, rfl⟩
  intro h
  exact absurd (congrArg ProofObject.inputs h) (by decide)

/-- Consequently no `decode` can exist for the flat projection: losslessness
would contradict `flatCsv_not_injective`. -/
theorem flatCsv_no_decoder :
    ¬ ∃ dec : String → Option ProofObject, ∀ p : ProofObject, dec (flatCsv p) = some p := by
  rintro ⟨dec, hdec⟩
  obtain ⟨p, q, hne, heq⟩ := flatCsv_not_injective
  have hp := hdec p
  have hq := hdec q
  rw [heq, hq] at hp
  exact hne (Option.some.inj hp).symm

end Solfunmeme.Codec
