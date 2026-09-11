/-
# The five emitted representations

Each format renders one token of the shared token stream per line, as literal
pieces interleaved with escaped domain strings and joined by a separator that
escaping removes from the data.  Every format therefore comes with

* `*Parse_render`: parsing a rendered line recovers the token exactly, and
* `*Render_nl`: a rendered line never contains a newline,

which is all `LineCodec` needs; the document-level round trip, the graph-level
round trip and the cross-representation invariant then hold for every format by
`LineCodec.decode_emit` and `cross_representation`.
-/
import RequestProject.Craft.Domain.Lines

namespace Domain

/-- Discharge "no separator occurs in any rendered piece": literal pieces are
checked by evaluation, data pieces are escaped. -/
macro "piece_free_tac" : tactic =>
  `(tactic|
      (intro p hp
       simp only [List.mem_cons, List.not_mem_nil, or_false] at hp
       try casesm* _ ∨ _
       all_goals subst_vars
       all_goals first | decide | exact esc_delim_free (by decide) _))

/-! ## Raw text -/

/-- Render a token as a line of the raw-text representation. -/
def textRender : Tok → String
  | .header d => line '|' ["DOMAIN", esc d]
  | .recStart k i => line '|' ["RECORD", esc k, esc i]
  | .scalar k v => line '|' ["FIELD", esc k, esc v]
  | .listStart k => line '|' ["LIST", esc k]
  | .item v => line '|' ["ITEM", esc v]
  | .listEnd => line '|' ["END-LIST"]
  | .recEnd => line '|' ["END-RECORD"]
  | .footer => line '|' ["END-DOMAIN"]

/-- Parse a line of the raw-text representation. -/
def textParse (s : String) : Option Tok :=
  match splitStr '|' s with
  | ["DOMAIN", d] => some (.header (unesc d))
  | ["RECORD", k, i] => some (.recStart (unesc k) (unesc i))
  | ["FIELD", k, v] => some (.scalar (unesc k) (unesc v))
  | ["LIST", k] => some (.listStart (unesc k))
  | ["ITEM", v] => some (.item (unesc v))
  | ["END-LIST"] => some .listEnd
  | ["END-RECORD"] => some .recEnd
  | ["END-DOMAIN"] => some .footer
  | _ => none

theorem textParse_render (t : Tok) : textParse (textRender t) = some t := by
  cases t with
  | header d =>
      simp only [textRender, textParse]
      rw [line_split '|' ["DOMAIN", esc d] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | recStart k i =>
      simp only [textRender, textParse]
      rw [line_split '|' ["RECORD", esc k, esc i] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | scalar k v =>
      simp only [textRender, textParse]
      rw [line_split '|' ["FIELD", esc k, esc v] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listStart k =>
      simp only [textRender, textParse]
      rw [line_split '|' ["LIST", esc k] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | item v =>
      simp only [textRender, textParse]
      rw [line_split '|' ["ITEM", esc v] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listEnd =>
      simp only [textRender, textParse]
      rw [line_split '|' ["END-LIST"] (by simp) (by piece_free_tac)]
      rfl
  | recEnd =>
      simp only [textRender, textParse]
      rw [line_split '|' ["END-RECORD"] (by simp) (by piece_free_tac)]
      rfl
  | footer =>
      simp only [textRender, textParse]
      rw [line_split '|' ["END-DOMAIN"] (by simp) (by piece_free_tac)]
      rfl

theorem textRender_nl (t : Tok) : '\n' ∉ (textRender t).toList := by
  cases t <;>
    exact line_nl _ (by decide) _ (by piece_free_tac)

/-- The raw-text codec. -/
def textCodec : LineCodec := ⟨"TEXT", textRender, textParse, textParse_render, textRender_nl⟩

/-! ## IPDL -/

/-- Render a token as a line of the IPDL representation. -/
def ipdlRender : Tok → String
  | .header d => line '"' ["domain ", esc d, " {"]
  | .recStart k i => line '"' ["  record ", esc k, " ", esc i, " {"]
  | .scalar k v => line '"' ["    ", esc k, " = ", esc v, ";"]
  | .listStart k => line '"' ["    ", esc k, " = ["]
  | .item v => line '"' ["      ", esc v, ","]
  | .listEnd => line '"' ["    ];"]
  | .recEnd => line '"' ["  }"]
  | .footer => line '"' ["}"]

/-- Parse a line of the IPDL representation. -/
def ipdlParse (s : String) : Option Tok :=
  match splitStr '"' s with
  | ["domain ", d, " {"] => some (.header (unesc d))
  | ["  record ", k, " ", i, " {"] => some (.recStart (unesc k) (unesc i))
  | ["    ", k, " = ", v, ";"] => some (.scalar (unesc k) (unesc v))
  | ["    ", k, " = ["] => some (.listStart (unesc k))
  | ["      ", v, ","] => some (.item (unesc v))
  | ["    ];"] => some (.listEnd)
  | ["  }"] => some (.recEnd)
  | ["}"] => some (.footer)
  | _ => none

theorem ipdlParse_render (t : Tok) : ipdlParse (ipdlRender t) = some t := by
  cases t with
  | header d =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["domain ", esc d, " {"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | recStart k i =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["  record ", esc k, " ", esc i, " {"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | scalar k v =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["    ", esc k, " = ", esc v, ";"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listStart k =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["    ", esc k, " = ["] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | item v =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["      ", esc v, ","] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listEnd =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["    ];"] (by simp) (by piece_free_tac)]
      rfl
  | recEnd =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["  }"] (by simp) (by piece_free_tac)]
      rfl
  | footer =>
      simp only [ipdlRender, ipdlParse]
      rw [line_split '"' ["}"] (by simp) (by piece_free_tac)]
      rfl

theorem ipdlRender_nl (t : Tok) : '\n' ∉ (ipdlRender t).toList := by
  cases t <;>
    exact line_nl _ (by decide) _ (by piece_free_tac)

/-- The IPDL codec. -/
def ipdlCodec : LineCodec :=
  ⟨"IPDL", ipdlRender, ipdlParse, ipdlParse_render, ipdlRender_nl⟩

/-! ## XML -/

/-- Render a token as a line of the XML representation. -/
def xmlRender : Tok → String
  | .header d => line '"' ["<domain-package id=", esc d, ">"]
  | .recStart k i => line '"' ["<record kind=", esc k, " id=", esc i, ">"]
  | .scalar k v => line '"' ["  <field key=", esc k, " value=", esc v, "/>"]
  | .listStart k => line '"' ["  <field key=", esc k, ">"]
  | .item v => line '"' ["    <item value=", esc v, "/>"]
  | .listEnd => line '"' ["  </field>"]
  | .recEnd => line '"' ["</record>"]
  | .footer => line '"' ["</domain-package>"]

/-- Parse a line of the XML representation. -/
def xmlParse (s : String) : Option Tok :=
  match splitStr '"' s with
  | ["<domain-package id=", d, ">"] => some (.header (unesc d))
  | ["<record kind=", k, " id=", i, ">"] => some (.recStart (unesc k) (unesc i))
  | ["  <field key=", k, " value=", v, "/>"] => some (.scalar (unesc k) (unesc v))
  | ["  <field key=", k, ">"] => some (.listStart (unesc k))
  | ["    <item value=", v, "/>"] => some (.item (unesc v))
  | ["  </field>"] => some (.listEnd)
  | ["</record>"] => some (.recEnd)
  | ["</domain-package>"] => some (.footer)
  | _ => none

theorem xmlParse_render (t : Tok) : xmlParse (xmlRender t) = some t := by
  cases t with
  | header d =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["<domain-package id=", esc d, ">"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | recStart k i =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["<record kind=", esc k, " id=", esc i, ">"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | scalar k v =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["  <field key=", esc k, " value=", esc v, "/>"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listStart k =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["  <field key=", esc k, ">"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | item v =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["    <item value=", esc v, "/>"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listEnd =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["  </field>"] (by simp) (by piece_free_tac)]
      rfl
  | recEnd =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["</record>"] (by simp) (by piece_free_tac)]
      rfl
  | footer =>
      simp only [xmlRender, xmlParse]
      rw [line_split '"' ["</domain-package>"] (by simp) (by piece_free_tac)]
      rfl

theorem xmlRender_nl (t : Tok) : '\n' ∉ (xmlRender t).toList := by
  cases t <;>
    exact line_nl _ (by decide) _ (by piece_free_tac)

/-- The XML codec. -/
def xmlCodec : LineCodec :=
  ⟨"XML", xmlRender, xmlParse, xmlParse_render, xmlRender_nl⟩

/-! ## YAML -/

/-- Render a token as a line of the YAML representation. -/
def yamlRender : Tok → String
  | .header d => line '\'' ["- domain: ", esc d, ""]
  | .recStart k i => line '\'' ["- record: {kind: ", esc k, ", id: ", esc i, "}"]
  | .scalar k v => line '\'' ["- field: {key: ", esc k, ", value: ", esc v, "}"]
  | .listStart k => line '\'' ["- list: {key: ", esc k, "}"]
  | .item v => line '\'' ["- item: ", esc v, ""]
  | .listEnd => line '\'' ["- list_end: true"]
  | .recEnd => line '\'' ["- record_end: true"]
  | .footer => line '\'' ["- end: true"]

/-- Parse a line of the YAML representation. -/
def yamlParse (s : String) : Option Tok :=
  match splitStr '\'' s with
  | ["- domain: ", d, ""] => some (.header (unesc d))
  | ["- record: {kind: ", k, ", id: ", i, "}"] => some (.recStart (unesc k) (unesc i))
  | ["- field: {key: ", k, ", value: ", v, "}"] => some (.scalar (unesc k) (unesc v))
  | ["- list: {key: ", k, "}"] => some (.listStart (unesc k))
  | ["- item: ", v, ""] => some (.item (unesc v))
  | ["- list_end: true"] => some (.listEnd)
  | ["- record_end: true"] => some (.recEnd)
  | ["- end: true"] => some (.footer)
  | _ => none

theorem yamlParse_render (t : Tok) : yamlParse (yamlRender t) = some t := by
  cases t with
  | header d =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- domain: ", esc d, ""] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | recStart k i =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- record: {kind: ", esc k, ", id: ", esc i, "}"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | scalar k v =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- field: {key: ", esc k, ", value: ", esc v, "}"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listStart k =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- list: {key: ", esc k, "}"] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | item v =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- item: ", esc v, ""] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listEnd =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- list_end: true"] (by simp) (by piece_free_tac)]
      rfl
  | recEnd =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- record_end: true"] (by simp) (by piece_free_tac)]
      rfl
  | footer =>
      simp only [yamlRender, yamlParse]
      rw [line_split '\'' ["- end: true"] (by simp) (by piece_free_tac)]
      rfl

theorem yamlRender_nl (t : Tok) : '\n' ∉ (yamlRender t).toList := by
  cases t <;>
    exact line_nl _ (by decide) _ (by piece_free_tac)

/-- The YAML codec. -/
def yamlCodec : LineCodec :=
  ⟨"YAML", yamlRender, yamlParse, yamlParse_render, yamlRender_nl⟩

/-! ## CSV -/

/-- Render a token as a line of the CSV representation. -/
def csvRender : Tok → String
  | .header d => line ',' ["DOMAIN", esc d, ""]
  | .recStart k i => line ',' ["RECORD", esc k, esc i]
  | .scalar k v => line ',' ["FIELD", esc k, esc v]
  | .listStart k => line ',' ["LIST", esc k, ""]
  | .item v => line ',' ["ITEM", esc v, ""]
  | .listEnd => line ',' ["LIST_END", "", ""]
  | .recEnd => line ',' ["RECORD_END", "", ""]
  | .footer => line ',' ["END", "", ""]

/-- Parse a line of the CSV representation. -/
def csvParse (s : String) : Option Tok :=
  match splitStr ',' s with
  | ["DOMAIN", d, ""] => some (.header (unesc d))
  | ["RECORD", k, i] => some (.recStart (unesc k) (unesc i))
  | ["FIELD", k, v] => some (.scalar (unesc k) (unesc v))
  | ["LIST", k, ""] => some (.listStart (unesc k))
  | ["ITEM", v, ""] => some (.item (unesc v))
  | ["LIST_END", "", ""] => some (.listEnd)
  | ["RECORD_END", "", ""] => some (.recEnd)
  | ["END", "", ""] => some (.footer)
  | _ => none

theorem csvParse_render (t : Tok) : csvParse (csvRender t) = some t := by
  cases t with
  | header d =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["DOMAIN", esc d, ""] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | recStart k i =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["RECORD", esc k, esc i] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | scalar k v =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["FIELD", esc k, esc v] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listStart k =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["LIST", esc k, ""] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | item v =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["ITEM", esc v, ""] (by simp) (by piece_free_tac)]
      simp only [unesc_esc]
  | listEnd =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["LIST_END", "", ""] (by simp) (by piece_free_tac)]
      rfl
  | recEnd =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["RECORD_END", "", ""] (by simp) (by piece_free_tac)]
      rfl
  | footer =>
      simp only [csvRender, csvParse]
      rw [line_split ',' ["END", "", ""] (by simp) (by piece_free_tac)]
      rfl

theorem csvRender_nl (t : Tok) : '\n' ∉ (csvRender t).toList := by
  cases t <;>
    exact line_nl _ (by decide) _ (by piece_free_tac)

/-- The CSV codec. -/
def csvCodec : LineCodec :=
  ⟨"CSV", csvRender, csvParse, csvParse_render, csvRender_nl⟩

/-! ## The emitted representation set -/

/-- The five required representations (SOP §8). -/
def allCodecs : List LineCodec := [ipdlCodec, xmlCodec, csvCodec, yamlCodec, textCodec]

/-- Every emitted representation decodes back to the domain graph it was
emitted from (SOP §18, §20 step 7). -/
theorem all_roundtrip (g : DomainGraph) :
    ∀ C ∈ allCodecs, C.decode (C.emit g) = some g := by
  intro C _
  exact C.decode_emit g

/-- All five representations of a graph decode to the same canonical graph. -/
theorem all_agree (g : DomainGraph) :
    ∀ C ∈ allCodecs, ∀ D ∈ allCodecs, C.decode (C.emit g) = D.decode (D.emit g) := by
  intro C _ D _
  exact cross_representation C D g

end Domain
