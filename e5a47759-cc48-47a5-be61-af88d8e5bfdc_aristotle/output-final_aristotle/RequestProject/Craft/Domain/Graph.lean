/-
# The canonical domain graph

This file defines the canonical unit of the domain data codec: a domain object
with its inputs, parameters, transformations, outputs, claims, evidence,
proofs, errors and provenance, and the domain graph that collects objects,
proofs, relations, claims, evidence, schemas, errors and provenance records.

A proof is a first-class object: a domain object references proofs by
identifier (`proofRefs`), never by a bare status string, and each proof records
what it consumes, what it produces, what it establishes, what it depends on,
its status and its certificate.

The graph is projected onto the flat record model of `RequestProject.Domain.Rec`
by `DomainGraph.toRecs`, and recovered by `DomainGraph.ofRecs`; the projection
is lossless (`ofRecs_toRecs`).  Every emitted representation is a rendering of
this projection, so all representations describe the same graph.
-/
import RequestProject.Craft.Domain.Rec
import RequestProject.Craft.Codec.Value

namespace Domain

/-! ## Statuses -/

/-- Provenance of truth of a domain value (SOP §4). -/
inductive TruthStatus where
  | PROVEN | DERIVED | VERIFIED | ASSERTED | IMPORTED | INFERRED
  | UNRESOLVED | CONTRADICTED | INVALID
  deriving Repr, DecidableEq, Inhabited

namespace TruthStatus

/-- The wire name of a truth status. -/
def toName : TruthStatus → String
  | PROVEN => "PROVEN" | DERIVED => "DERIVED" | VERIFIED => "VERIFIED"
  | ASSERTED => "ASSERTED" | IMPORTED => "IMPORTED" | INFERRED => "INFERRED"
  | UNRESOLVED => "UNRESOLVED" | CONTRADICTED => "CONTRADICTED" | INVALID => "INVALID"

/-- The truth status with a given wire name. -/
def ofName : String → Option TruthStatus
  | "PROVEN" => some PROVEN | "DERIVED" => some DERIVED | "VERIFIED" => some VERIFIED
  | "ASSERTED" => some ASSERTED | "IMPORTED" => some IMPORTED | "INFERRED" => some INFERRED
  | "UNRESOLVED" => some UNRESOLVED | "CONTRADICTED" => some CONTRADICTED
  | "INVALID" => some INVALID
  | _ => none

theorem ofName_toName (s : TruthStatus) : ofName s.toName = some s := by
  cases s <;> rfl

end TruthStatus

/-- The status of a proof object (SOP §5). -/
inductive ProofStatus where
  | VALID | INVALID | PARTIAL | FAILED | UNKNOWN | CONFLICT
  deriving Repr, DecidableEq, Inhabited

namespace ProofStatus

/-- The wire name of a proof status. -/
def toName : ProofStatus → String
  | VALID => "VALID" | INVALID => "INVALID" | PARTIAL => "PARTIAL"
  | FAILED => "FAILED" | UNKNOWN => "UNKNOWN" | CONFLICT => "CONFLICT"

/-- The proof status with a given wire name. -/
def ofName : String → Option ProofStatus
  | "VALID" => some VALID | "INVALID" => some INVALID | "PARTIAL" => some PARTIAL
  | "FAILED" => some FAILED | "UNKNOWN" => some UNKNOWN | "CONFLICT" => some CONFLICT
  | _ => none

theorem ofName_toName (s : ProofStatus) : ofName s.toName = some s := by
  cases s <;> rfl

end ProofStatus

/-- Relationship types of the proof-to-data graph (SOP §6). -/
inductive RelKind where
  | INPUT_TO | OUTPUT_OF | PROVES | DERIVES | VERIFIES | CONSTRAINS
  | DEPENDS_ON | REFERENCES | CONTRADICTS | REPRODUCES | ENCODES | DECODES
  | PROVEN_BY
  deriving Repr, DecidableEq, Inhabited

namespace RelKind

/-- The wire name of a relationship type. -/
def toName : RelKind → String
  | INPUT_TO => "INPUT_TO" | OUTPUT_OF => "OUTPUT_OF" | PROVES => "PROVES"
  | DERIVES => "DERIVES" | VERIFIES => "VERIFIES" | CONSTRAINS => "CONSTRAINS"
  | DEPENDS_ON => "DEPENDS_ON" | REFERENCES => "REFERENCES"
  | CONTRADICTS => "CONTRADICTS" | REPRODUCES => "REPRODUCES"
  | ENCODES => "ENCODES" | DECODES => "DECODES" | PROVEN_BY => "PROVEN_BY"

/-- The relationship type with a given wire name. -/
def ofName : String → Option RelKind
  | "INPUT_TO" => some INPUT_TO | "OUTPUT_OF" => some OUTPUT_OF | "PROVES" => some PROVES
  | "DERIVES" => some DERIVES | "VERIFIES" => some VERIFIES | "CONSTRAINS" => some CONSTRAINS
  | "DEPENDS_ON" => some DEPENDS_ON | "REFERENCES" => some REFERENCES
  | "CONTRADICTS" => some CONTRADICTS | "REPRODUCES" => some REPRODUCES
  | "ENCODES" => some ENCODES | "DECODES" => some DECODES | "PROVEN_BY" => some PROVEN_BY
  | _ => none

theorem ofName_toName (k : RelKind) : ofName k.toName = some k := by
  cases k <;> rfl

end RelKind

/-- Booleans on the wire. -/
def bName : Bool → String
  | true => "true" | false => "false"

/-- The boolean with a given wire name. -/
def bOfName : String → Option Bool
  | "true" => some true | "false" => some false | _ => none

theorem bOfName_bName (b : Bool) : bOfName (bName b) = some b := by
  cases b <;> rfl

/-! ## Entities -/

/-- A machine-checkable certificate attached to a proof (SOP §17). -/
structure Cert where
  kind : String
  digest : String
  location : String
  /-- Has the certificate actually been checked by a machine? -/
  machineChecked : Bool
  /-- Has the result been independently reproduced? -/
  reproduced : Bool
  deriving Repr, DecidableEq, Inhabited

/-- A domain object: the canonical unit of the domain (SOP §2). -/
structure DomainObject where
  id : String
  kind : String
  claim : String
  inputs : List String
  parameters : List String
  transformations : List String
  outputs : List String
  claimRefs : List String
  evidenceRefs : List String
  proofRefs : List String
  errorRefs : List String
  truth : TruthStatus
  source : String
  deriving Repr, DecidableEq, Inhabited

/-- A proof object (SOP §3): what it consumes, what it produces, what it
establishes, its status and its certificate. -/
structure DProof where
  id : String
  name : String
  kind : String
  inputs : List String
  assumptions : List String
  procedure : String
  outputs : List String
  claims : List String
  dependencies : List String
  status : ProofStatus
  cert : Cert
  sourceFile : String
  sourceLoc : String
  deriving Repr, DecidableEq, Inhabited

/-- A typed edge of the proof-to-data graph. -/
structure Relation where
  src : String
  kind : RelKind
  dst : String
  deriving Repr, DecidableEq, Inhabited

/-- A claim made about a domain object. -/
structure DClaim where
  id : String
  subject : String
  statement : String
  deriving Repr, DecidableEq, Inhabited

/-- Evidence attached to an object or proof. -/
structure Evidence where
  id : String
  subject : String
  kind : String
  location : String
  deriving Repr, DecidableEq, Inhabited

/-- A diagnostic attached to the graph (SOP §21: errors are attached, never
thrown away). -/
structure DError where
  id : String
  subject : String
  code : String
  message : String
  severity : String
  resolution : String
  resolved : Bool
  deriving Repr, DecidableEq, Inhabited

/-- A schema the package validates against. -/
structure SchemaRef where
  id : String
  name : String
  version : String
  location : String
  deriving Repr, DecidableEq, Inhabited

/-- A provenance record. -/
structure ProvRec where
  id : String
  subject : String
  source : String
  method : String
  timestamp : String
  deriving Repr, DecidableEq, Inhabited

/-- The complete domain (SOP §2). -/
structure DomainGraph where
  id : String
  description : String
  objects : List DomainObject
  proofs : List DProof
  relations : List Relation
  claims : List DClaim
  evidence : List Evidence
  errors : List DError
  schemas : List SchemaRef
  provenance : List ProvRec
  deriving Repr, DecidableEq, Inhabited

/-- The empty domain graph. -/
def DomainGraph.empty : DomainGraph :=
  ⟨"", "", [], [], [], [], [], [], [], []⟩

/-! ## Projection onto records -/

/-- A scalar field. -/
def sc (k v : String) : String × Field := (k, .scalar v)

/-- A list-valued field. -/
def it (k : String) (vs : List String) : String × Field := (k, .items vs)

/-- The record of a domain object. -/
def DomainObject.toRec (o : DomainObject) : Rec :=
  ⟨"object", o.id,
    [sc "kind" o.kind, sc "claim" o.claim, it "inputs" o.inputs,
      it "parameters" o.parameters, it "transformations" o.transformations,
      it "outputs" o.outputs, it "claims" o.claimRefs, it "evidence" o.evidenceRefs,
      it "proofs" o.proofRefs, it "errors" o.errorRefs,
      sc "truth" o.truth.toName, sc "source" o.source]⟩

/-- Recover a domain object from its record. -/
def DomainObject.ofRec (r : Rec) : Option DomainObject :=
  match r.kind, r.fields with
  | "object", [("kind", .scalar kind), ("claim", .scalar claim), ("inputs", .items ins),
      ("parameters", .items ps), ("transformations", .items ts), ("outputs", .items outs),
      ("claims", .items cls), ("evidence", .items evs), ("proofs", .items prs),
      ("errors", .items errs), ("truth", .scalar tr), ("source", .scalar src)] =>
      match TruthStatus.ofName tr with
      | some t => some ⟨r.id, kind, claim, ins, ps, ts, outs, cls, evs, prs, errs, t, src⟩
      | none => none
  | _, _ => none

theorem DomainObject.ofRec_toRec (o : DomainObject) : ofRec o.toRec = some o := by
  cases o with
  | mk id kind claim ins ps ts outs cls evs prs errs truth src =>
      cases truth <;> rfl

/-- The record of a proof object. -/
def DProof.toRec (p : DProof) : Rec :=
  ⟨"proof", p.id,
    [sc "name" p.name, sc "kind" p.kind, it "inputs" p.inputs,
      it "assumptions" p.assumptions, sc "procedure" p.procedure,
      it "outputs" p.outputs, it "claims" p.claims, it "dependencies" p.dependencies,
      sc "status" p.status.toName, sc "certificate_kind" p.cert.kind,
      sc "certificate_digest" p.cert.digest, sc "certificate_location" p.cert.location,
      sc "machine_checked" (bName p.cert.machineChecked),
      sc "reproduced" (bName p.cert.reproduced),
      sc "source_file" p.sourceFile, sc "source_location" p.sourceLoc]⟩

/-- Recover a proof object from its record. -/
def DProof.ofRec (r : Rec) : Option DProof :=
  match r.kind, r.fields with
  | "proof", [("name", .scalar name), ("kind", .scalar kind), ("inputs", .items ins),
      ("assumptions", .items asms), ("procedure", .scalar proc), ("outputs", .items outs),
      ("claims", .items cls), ("dependencies", .items deps), ("status", .scalar st),
      ("certificate_kind", .scalar ck), ("certificate_digest", .scalar cd),
      ("certificate_location", .scalar cl), ("machine_checked", .scalar mc),
      ("reproduced", .scalar rp), ("source_file", .scalar sf),
      ("source_location", .scalar sl)] =>
      match ProofStatus.ofName st, bOfName mc, bOfName rp with
      | some s, some m, some r' =>
          some ⟨r.id, name, kind, ins, asms, proc, outs, cls, deps, s, ⟨ck, cd, cl, m, r'⟩, sf, sl⟩
      | _, _, _ => none
  | _, _ => none

theorem DProof.ofRec_toRec (p : DProof) : ofRec p.toRec = some p := by
  cases p with
  | mk id name kind ins asms proc outs cls deps status cert sf sl =>
      cases cert with
      | mk ck cd cl mc rp => cases status <;> cases mc <;> cases rp <;> rfl

/-- The record of a relation. -/
def Relation.toRec (x : Relation) : Rec :=
  ⟨"relation", x.src ++ "|" ++ x.kind.toName ++ "|" ++ x.dst,
    [sc "source" x.src, sc "relation" x.kind.toName, sc "target" x.dst]⟩

/-- Recover a relation from its record. -/
def Relation.ofRec (r : Rec) : Option Relation :=
  match r.kind, r.fields with
  | "relation", [("source", .scalar s), ("relation", .scalar k), ("target", .scalar t)] =>
      match RelKind.ofName k with
      | some kk => some ⟨s, kk, t⟩
      | none => none
  | _, _ => none

theorem Relation.ofRec_toRec (x : Relation) : ofRec x.toRec = some x := by
  cases x with
  | mk s k t => cases k <;> rfl

/-- The record of a claim. -/
def DClaim.toRec (c : DClaim) : Rec :=
  ⟨"claim", c.id, [sc "subject" c.subject, sc "statement" c.statement]⟩

/-- Recover a claim from its record. -/
def DClaim.ofRec (r : Rec) : Option DClaim :=
  match r.kind, r.fields with
  | "claim", [("subject", .scalar s), ("statement", .scalar st)] => some ⟨r.id, s, st⟩
  | _, _ => none

theorem DClaim.ofRec_toRec (c : DClaim) : ofRec c.toRec = some c := by
  cases c; rfl

/-- The record of an evidence item. -/
def Evidence.toRec (e : Evidence) : Rec :=
  ⟨"evidence", e.id, [sc "subject" e.subject, sc "kind" e.kind, sc "location" e.location]⟩

/-- Recover an evidence item from its record. -/
def Evidence.ofRec (r : Rec) : Option Evidence :=
  match r.kind, r.fields with
  | "evidence", [("subject", .scalar s), ("kind", .scalar k), ("location", .scalar l)] =>
      some ⟨r.id, s, k, l⟩
  | _, _ => none

theorem Evidence.ofRec_toRec (e : Evidence) : ofRec e.toRec = some e := by
  cases e; rfl

/-- The record of a diagnostic. -/
def DError.toRec (e : DError) : Rec :=
  ⟨"error", e.id,
    [sc "subject" e.subject, sc "code" e.code, sc "message" e.message,
      sc "severity" e.severity, sc "resolution" e.resolution,
      sc "resolved" (bName e.resolved)]⟩

/-- Recover a diagnostic from its record. -/
def DError.ofRec (r : Rec) : Option DError :=
  match r.kind, r.fields with
  | "error", [("subject", .scalar s), ("code", .scalar c), ("message", .scalar m),
      ("severity", .scalar sv), ("resolution", .scalar rl), ("resolved", .scalar rs)] =>
      match bOfName rs with
      | some b => some ⟨r.id, s, c, m, sv, rl, b⟩
      | none => none
  | _, _ => none

theorem DError.ofRec_toRec (e : DError) : ofRec e.toRec = some e := by
  cases e with
  | mk id s c m sv rl rs => cases rs <;> rfl

/-- The record of a schema reference. -/
def SchemaRef.toRec (s : SchemaRef) : Rec :=
  ⟨"schema", s.id, [sc "name" s.name, sc "version" s.version, sc "location" s.location]⟩

/-- Recover a schema reference from its record. -/
def SchemaRef.ofRec (r : Rec) : Option SchemaRef :=
  match r.kind, r.fields with
  | "schema", [("name", .scalar n), ("version", .scalar v), ("location", .scalar l)] =>
      some ⟨r.id, n, v, l⟩
  | _, _ => none

theorem SchemaRef.ofRec_toRec (s : SchemaRef) : ofRec s.toRec = some s := by
  cases s; rfl

/-- The record of a provenance entry. -/
def ProvRec.toRec (p : ProvRec) : Rec :=
  ⟨"provenance", p.id,
    [sc "subject" p.subject, sc "source" p.source, sc "method" p.method,
      sc "timestamp" p.timestamp]⟩

/-- Recover a provenance entry from its record. -/
def ProvRec.ofRec (r : Rec) : Option ProvRec :=
  match r.kind, r.fields with
  | "provenance", [("subject", .scalar s), ("source", .scalar src), ("method", .scalar m),
      ("timestamp", .scalar t)] => some ⟨r.id, s, src, m, t⟩
  | _, _ => none

theorem ProvRec.ofRec_toRec (p : ProvRec) : ofRec p.toRec = some p := by
  cases p; rfl

/-! ## The graph projection -/

/-- The header record carrying the domain identity and description. -/
def DomainGraph.headRec (g : DomainGraph) : Rec :=
  ⟨"domain", g.id, [sc "description" g.description]⟩

/-- The flat record projection of the whole domain graph. -/
def DomainGraph.toRecs (g : DomainGraph) : List Rec :=
  g.headRec :: (g.objects.map DomainObject.toRec ++ g.proofs.map DProof.toRec ++
    g.relations.map Relation.toRec ++ g.claims.map DClaim.toRec ++
    g.evidence.map Evidence.toRec ++ g.errors.map DError.toRec ++
    g.schemas.map SchemaRef.toRec ++ g.provenance.map ProvRec.toRec)

/-- Fold one record into a partially decoded graph. -/
def addRec (g : DomainGraph) (r : Rec) : Option DomainGraph :=
  match r.kind with
  | "domain" =>
      match r.fields with
      | [("description", .scalar d)] => some { g with id := r.id, description := d }
      | _ => none
  | "object" => (DomainObject.ofRec r).map fun o => { g with objects := o :: g.objects }
  | "proof" => (DProof.ofRec r).map fun p => { g with proofs := p :: g.proofs }
  | "relation" => (Relation.ofRec r).map fun x => { g with relations := x :: g.relations }
  | "claim" => (DClaim.ofRec r).map fun c => { g with claims := c :: g.claims }
  | "evidence" => (Evidence.ofRec r).map fun e => { g with evidence := e :: g.evidence }
  | "error" => (DError.ofRec r).map fun e => { g with errors := e :: g.errors }
  | "schema" => (SchemaRef.ofRec r).map fun s => { g with schemas := s :: g.schemas }
  | "provenance" => (ProvRec.ofRec r).map fun p => { g with provenance := p :: g.provenance }
  | _ => none

/-- Decode a flat record list into a domain graph. -/
def DomainGraph.ofRecs : List Rec → Option DomainGraph
  | [] => some DomainGraph.empty
  | r :: rs =>
      match DomainGraph.ofRecs rs with
      | some g => addRec g r
      | none => none

/-! ### Folding one record of each kind -/

theorem addRec_objects (g : DomainGraph) (o : DomainObject) :
    addRec g o.toRec = some { g with objects := o :: g.objects } := by
  have h : addRec g o.toRec
      = (DomainObject.ofRec o.toRec).map (fun y => { g with objects := y :: g.objects }) := rfl
  rw [h, DomainObject.ofRec_toRec]
  rfl

theorem addRec_proofs (g : DomainGraph) (p : DProof) :
    addRec g p.toRec = some { g with proofs := p :: g.proofs } := by
  have h : addRec g p.toRec
      = (DProof.ofRec p.toRec).map (fun y => { g with proofs := y :: g.proofs }) := rfl
  rw [h, DProof.ofRec_toRec]
  rfl

theorem addRec_relations (g : DomainGraph) (x : Relation) :
    addRec g x.toRec = some { g with relations := x :: g.relations } := by
  have h : addRec g x.toRec
      = (Relation.ofRec x.toRec).map (fun y => { g with relations := y :: g.relations }) := rfl
  rw [h, Relation.ofRec_toRec]
  rfl

theorem addRec_claims (g : DomainGraph) (c : DClaim) :
    addRec g c.toRec = some { g with claims := c :: g.claims } := by
  have h : addRec g c.toRec
      = (DClaim.ofRec c.toRec).map (fun y => { g with claims := y :: g.claims }) := rfl
  rw [h, DClaim.ofRec_toRec]
  rfl

theorem addRec_evidence (g : DomainGraph) (e : Evidence) :
    addRec g e.toRec = some { g with evidence := e :: g.evidence } := by
  have h : addRec g e.toRec
      = (Evidence.ofRec e.toRec).map (fun y => { g with evidence := y :: g.evidence }) := rfl
  rw [h, Evidence.ofRec_toRec]
  rfl

theorem addRec_errors (g : DomainGraph) (e : DError) :
    addRec g e.toRec = some { g with errors := e :: g.errors } := by
  have h : addRec g e.toRec
      = (DError.ofRec e.toRec).map (fun y => { g with errors := y :: g.errors }) := rfl
  rw [h, DError.ofRec_toRec]
  rfl

theorem addRec_schemas (g : DomainGraph) (s : SchemaRef) :
    addRec g s.toRec = some { g with schemas := s :: g.schemas } := by
  have h : addRec g s.toRec
      = (SchemaRef.ofRec s.toRec).map (fun y => { g with schemas := y :: g.schemas }) := rfl
  rw [h, SchemaRef.ofRec_toRec]
  rfl

theorem addRec_provenance (g : DomainGraph) (p : ProvRec) :
    addRec g p.toRec = some { g with provenance := p :: g.provenance } := by
  have h : addRec g p.toRec
      = (ProvRec.ofRec p.toRec).map (fun y => { g with provenance := y :: g.provenance }) := rfl
  rw [h, ProvRec.ofRec_toRec]
  rfl

/-! ### The projection is lossless -/

theorem ofRecs_objects (os : List DomainObject) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (os.map DomainObject.toRec ++ rest)
      = some { g with objects := os ++ g.objects } := by
  induction os with
  | nil => simpa using h
  | cons o os ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_objects]

theorem ofRecs_proofs (ps : List DProof) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (ps.map DProof.toRec ++ rest)
      = some { g with proofs := ps ++ g.proofs } := by
  induction ps with
  | nil => simpa using h
  | cons p ps ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_proofs]

theorem ofRecs_relations (xs : List Relation) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (xs.map Relation.toRec ++ rest)
      = some { g with relations := xs ++ g.relations } := by
  induction xs with
  | nil => simpa using h
  | cons x xs ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_relations]

theorem ofRecs_claims (cs : List DClaim) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (cs.map DClaim.toRec ++ rest)
      = some { g with claims := cs ++ g.claims } := by
  induction cs with
  | nil => simpa using h
  | cons c cs ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_claims]

theorem ofRecs_evidence (es : List Evidence) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (es.map Evidence.toRec ++ rest)
      = some { g with evidence := es ++ g.evidence } := by
  induction es with
  | nil => simpa using h
  | cons e es ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_evidence]

theorem ofRecs_errors (es : List DError) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (es.map DError.toRec ++ rest)
      = some { g with errors := es ++ g.errors } := by
  induction es with
  | nil => simpa using h
  | cons e es ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_errors]

theorem ofRecs_schemas (ss : List SchemaRef) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (ss.map SchemaRef.toRec ++ rest)
      = some { g with schemas := ss ++ g.schemas } := by
  induction ss with
  | nil => simpa using h
  | cons s ss ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_schemas]

theorem ofRecs_provenance (ps : List ProvRec) (rest : List Rec) {g : DomainGraph}
    (h : DomainGraph.ofRecs rest = some g) :
    DomainGraph.ofRecs (ps.map ProvRec.toRec ++ rest)
      = some { g with provenance := ps ++ g.provenance } := by
  induction ps with
  | nil => simpa using h
  | cons p ps ih =>
      simp only [List.map_cons, List.cons_append, DomainGraph.ofRecs, ih]
      rw [addRec_provenance]

theorem DomainGraph.ofRecs_toRecs (g : DomainGraph) : ofRecs g.toRecs = some g := by
  obtain ⟨gid, gdesc, os, ps, xs, cs, evs, errs, ss, prs⟩ := g
  have h0 : ofRecs [] = some DomainGraph.empty := rfl
  have h1 : ofRecs (prs.map ProvRec.toRec)
      = some ⟨"", "", [], [], [], [], [], [], [], prs⟩ := by
    simpa [DomainGraph.empty] using ofRecs_provenance prs [] h0
  have h2 : ofRecs (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec)
      = some ⟨"", "", [], [], [], [], [], [], ss, prs⟩ := by
    simpa using ofRecs_schemas ss _ h1
  have h3 : ofRecs (errs.map DError.toRec ++ (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec))
      = some ⟨"", "", [], [], [], [], [], errs, ss, prs⟩ := by
    simpa using ofRecs_errors errs _ h2
  have h4 : ofRecs (evs.map Evidence.toRec ++ (errs.map DError.toRec ++
      (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec)))
      = some ⟨"", "", [], [], [], [], evs, errs, ss, prs⟩ := by
    simpa using ofRecs_evidence evs _ h3
  have h5 : ofRecs (cs.map DClaim.toRec ++ (evs.map Evidence.toRec ++ (errs.map DError.toRec ++
      (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec))))
      = some ⟨"", "", [], [], [], cs, evs, errs, ss, prs⟩ := by
    simpa using ofRecs_claims cs _ h4
  have h6 : ofRecs (xs.map Relation.toRec ++ (cs.map DClaim.toRec ++ (evs.map Evidence.toRec ++
      (errs.map DError.toRec ++ (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec)))))
      = some ⟨"", "", [], [], xs, cs, evs, errs, ss, prs⟩ := by
    simpa using ofRecs_relations xs _ h5
  have h7 : ofRecs (ps.map DProof.toRec ++ (xs.map Relation.toRec ++ (cs.map DClaim.toRec ++
      (evs.map Evidence.toRec ++ (errs.map DError.toRec ++
        (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec))))))
      = some ⟨"", "", [], ps, xs, cs, evs, errs, ss, prs⟩ := by
    simpa using ofRecs_proofs ps _ h6
  have h8 : ofRecs (os.map DomainObject.toRec ++ (ps.map DProof.toRec ++
      (xs.map Relation.toRec ++ (cs.map DClaim.toRec ++ (evs.map Evidence.toRec ++
        (errs.map DError.toRec ++ (ss.map SchemaRef.toRec ++ prs.map ProvRec.toRec)))))))
      = some ⟨"", "", os, ps, xs, cs, evs, errs, ss, prs⟩ := by
    simpa using ofRecs_objects os _ h7
  simp only [toRecs, List.append_assoc, ofRecs, h8, addRec, headRec, sc]

/-! ## Canonical value and hash -/

open Codec

/-- A field as a canonical value. -/
def Field.toCValue : Field → CValue
  | .scalar s => .obj [("scalar", .str s)]
  | .items vs => .obj [("items", .list (vs.map .str))]

/-- A record as a canonical value. -/
def Rec.toCValue (r : Rec) : CValue :=
  .obj [("kind", .str r.kind), ("id", .str r.id),
    ("fields", .list (r.fields.map (fun f => .obj [("key", .str f.1), ("value", f.2.toCValue)])))]

/-- The canonical value of the whole domain graph. -/
def DomainGraph.toCValue (g : DomainGraph) : CValue :=
  .obj [("domain", .str g.id), ("records", .list (g.toRecs.map Rec.toCValue))]

/-- The canonical content hash of a domain object (SOP §19). -/
def DomainObject.canonicalHash (o : DomainObject) : Nat :=
  CValue.hash (Rec.toCValue o.toRec)

/-- The canonical content hash of a proof object. -/
def DProof.canonicalHash (p : DProof) : Nat :=
  CValue.hash (Rec.toCValue p.toRec)

/-- The canonical content hash of the whole domain graph. -/
def DomainGraph.canonicalHash (g : DomainGraph) : Nat :=
  CValue.hash g.toCValue

theorem DomainObject.canonicalHash_congr {o o' : DomainObject} (h : o = o') :
    o.canonicalHash = o'.canonicalHash := by rw [h]

theorem DomainGraph.canonicalHash_congr {g g' : DomainGraph} (h : g = g') :
    g.canonicalHash = g'.canonicalHash := by rw [h]

end Domain
