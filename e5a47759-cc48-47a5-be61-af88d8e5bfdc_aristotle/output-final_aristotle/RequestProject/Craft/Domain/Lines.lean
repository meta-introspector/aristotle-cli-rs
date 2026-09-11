/-
# Domain data codec — the generic line layer

Every emitted representation writes one token of the shared token stream per
line.  A format is therefore given by a line renderer, a line parser, a proof
that parsing a rendered line recovers the token, and a proof that a rendered
line contains no newline.

From these four data the whole codec is derived once and for all:

* `LineCodec.emit` / `LineCodec.decode` on record lists and on domain graphs;
* `LineCodec.decode_emit`: decoding an emitted domain graph returns exactly
  that graph, for *every* format (SOP §18);
* `LineCodec.canonicalHash_decode`: the canonical hash recovered from any
  emitted representation is the canonical hash of the graph (SOP §19).
-/
import RequestProject.Craft.Domain.Graph

namespace Domain

/-- A textual format: one line per token, with a verified parser. -/
structure LineCodec where
  /-- Name of the format. -/
  name : String
  /-- Render one token as one line. -/
  render : Tok → String
  /-- Parse one line back into a token. -/
  parse : String → Option Tok
  /-- Parsing a rendered line recovers the token. -/
  round : ∀ t, parse (render t) = some t
  /-- A rendered line never contains a newline. -/
  nl : ∀ t, '\n' ∉ (render t).toList

namespace LineCodec

variable (C : LineCodec)

/-- Emit a token stream as a document. -/
def emitToks (ts : List Tok) : String := joinStr '\n' (ts.map C.render)

/-- Decode a document into a token stream. -/
def parseToks (s : String) : Option (List Tok) := (splitStr '\n' s).mapM C.parse

theorem mapM_parse_render (ts : List Tok) :
    (ts.map C.render).mapM C.parse = some ts := by
  induction ts with
  | nil => rfl
  | cons t ts ih => simp [List.mapM_cons, C.round, ih]

theorem parseToks_emitToks (ts : List Tok) (hne : ts ≠ []) :
    C.parseToks (C.emitToks ts) = some ts := by
  unfold parseToks emitToks
  rw [splitStr_joinStr '\n' (ts.map C.render) (by simpa using hne)
    (by
      intro p hp
      simp only [List.mem_map] at hp
      obtain ⟨t, _, rfl⟩ := hp
      exact C.nl t)]
  exact C.mapM_parse_render ts

/-- Emit a record document. -/
def emitRecs (docId : String) (rs : List Rec) : String := C.emitToks (toToks docId rs)

/-- Decode a record document. -/
def decodeRecs (s : String) : Option (String × List Rec) :=
  match C.parseToks s with
  | some ts => ofToks ts
  | none => none

theorem decodeRecs_emitRecs (docId : String) (rs : List Rec) :
    C.decodeRecs (C.emitRecs docId rs) = some (docId, rs) := by
  unfold decodeRecs emitRecs
  rw [C.parseToks_emitToks (toToks docId rs) (by simp [toToks])]
  exact ofToks_toToks docId rs

/-- Emit a whole domain graph in this format. -/
def emit (g : DomainGraph) : String := C.emitRecs g.id g.toRecs

/-- Decode a whole domain graph from this format. -/
def decode (s : String) : Option DomainGraph :=
  match C.decodeRecs s with
  | some (_, rs) => DomainGraph.ofRecs rs
  | none => none

/-- **Round trip.**  Every format recovers exactly the domain graph that was
emitted (SOP §7, §18). -/
theorem decode_emit (g : DomainGraph) : C.decode (C.emit g) = some g := by
  unfold decode emit
  rw [C.decodeRecs_emitRecs]
  exact g.ofRecs_toRecs

/-- The document identity written by a format is the identity of the graph. -/
theorem decodeRecs_emit_id (g : DomainGraph) :
    (C.decodeRecs (C.emit g)).map Prod.fst = some g.id := by
  unfold emit
  rw [C.decodeRecs_emitRecs]
  rfl

/-- **Hash agreement.**  The canonical hash recovered from an emitted document
is the canonical hash of the graph, in every format (SOP §19). -/
theorem canonicalHash_decode (g : DomainGraph) :
    (C.decode (C.emit g)).map DomainGraph.canonicalHash = some g.canonicalHash := by
  rw [C.decode_emit]
  rfl

/-! ### Everything survives emission

Diagnostics, proofs (with their certificates) and the relation graph are not
side notes: they are part of the canonical object and are recovered from every
representation. -/

/-- Diagnostics attached to the graph survive emission and decoding (SOP §21:
errors are attached to the graph, never thrown away). -/
theorem errors_survive (g : DomainGraph) :
    (C.decode (C.emit g)).map DomainGraph.errors = some g.errors := by
  rw [C.decode_emit]; rfl

/-- Proofs, with their statuses and certificates, survive emission and
decoding (SOP §17). -/
theorem proofs_survive (g : DomainGraph) :
    (C.decode (C.emit g)).map DomainGraph.proofs = some g.proofs := by
  rw [C.decode_emit]; rfl

/-- The typed edges of the proof-to-data graph survive emission and decoding
(SOP §6). -/
theorem relations_survive (g : DomainGraph) :
    (C.decode (C.emit g)).map DomainGraph.relations = some g.relations := by
  rw [C.decode_emit]; rfl

/-- Provenance records survive emission and decoding (SOP §14). -/
theorem provenance_survive (g : DomainGraph) :
    (C.decode (C.emit g)).map DomainGraph.provenance = some g.provenance := by
  rw [C.decode_emit]; rfl

end LineCodec

/-- **Cross-representation invariant** (SOP §18): if two formats emit the same
graph, decoding either document yields the same graph, so all representations
describe the same canonical proof graph. -/
theorem cross_representation (C D : LineCodec) (g : DomainGraph) :
    C.decode (C.emit g) = D.decode (D.emit g) := by
  rw [C.decode_emit, D.decode_emit]

/-- **Hash agreement across formats**: documents emitted by different formats
carry the same canonical hash. -/
theorem cross_representation_hash (C D : LineCodec) (g : DomainGraph) :
    (C.decode (C.emit g)).map DomainGraph.canonicalHash
      = (D.decode (D.emit g)).map DomainGraph.canonicalHash := by
  rw [C.canonicalHash_decode, D.canonicalHash_decode]

/-! ## Building line codecs

Each concrete format renders a token as a list of alternating literal and
escaped pieces joined by a separator character.  These helpers discharge the
two proof obligations of `LineCodec` for such renderings. -/

/-- Render a line as literal and escaped pieces joined by a separator. -/
def line (sep : Char) (ps : List String) : String := joinStr sep ps

theorem line_split (sep : Char) (ps : List String) (hne : ps ≠ [])
    (hfree : ∀ p ∈ ps, sep ∉ p.toList) : splitStr sep (line sep ps) = ps :=
  splitStr_joinStr sep ps hne hfree

theorem line_nl (sep : Char) (hsep : sep ≠ '\n') (ps : List String)
    (h : ∀ p ∈ ps, '\n' ∉ p.toList) : '\n' ∉ (line sep ps).toList :=
  notMem_joinStr (fun hc => hsep hc.symm) h

end Domain
