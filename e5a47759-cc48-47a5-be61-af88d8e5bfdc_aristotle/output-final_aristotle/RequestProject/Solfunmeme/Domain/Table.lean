import RequestProject.Solfunmeme.Domain.Model

/-!
# The canonical tabular projection of a whole domain

The codec's tabular convention

```text
object_id, object_type, field, value, value_type, parent_id
```

already carries one proof object losslessly.  The same six columns carry a
whole domain package: the domain header, then the objects, the claims, the
proofs, the relations and the diagnostics, each as a run of consecutive rows.

Because the projection is into the *same* `Cell` type the codec uses, every
syntax the codec already has — IPDL, XML, CSV, YAML, plain text — carries a
domain package with no new parser, and `Domain.Emit` inherits the round trip
from `RowSyntax.parse_render` rather than proving it five times.

The result of this file is `decodeDomainTable_encodeDomainTable`: the whole
canonical graph survives the projection, so every emitted representation is
recoverable and all five are recoverable *to the same graph*.

Nested provenance is folded into one field with `encProv`, so that every record
is a flat run of rows and the block machinery of `Codec.Table` applies
unchanged.  Rows belonging to no known block are not discarded: they are kept
in the domain's extension namespace under `domain.unparsed`.
-/

namespace Solfunmeme.Domain

open Solfunmeme.Codec

/-! ## Provenance as one field -/

/-- A `Provenance` as a single escaped field, so that every record of the
domain table is a flat run of rows. -/
def encProv (v : Provenance) : String :=
  encList false
    [v.sourceSystem, v.sourceFile, v.sourceFormat, v.importedAt, v.transformedAt,
     v.parentObject, encList false v.transformations]

/-- Read a provenance field back. -/
def decProv (s : String) : Option Provenance :=
  match decList s with
  | some [a, b, c, d, e, f, g] =>
    (decList g).map (fun ts =>
      { sourceSystem := a, sourceFile := b, sourceFormat := c, importedAt := d,
        transformedAt := e, parentObject := f, transformations := ts })
  | _ => none

@[simp] theorem decProv_encProv (v : Provenance) : decProv (encProv v) = some v := by
  simp [encProv, decProv]

/-! ## The domain header -/

def domainTriples (d : Domain) : List (String × String × String) :=
  [ ("id", d.id, "identifier")
  , ("name", d.name, "string")
  , ("version", d.version, "string")
  , ("description", d.description, "text")
  , ("provenance", encProv d.provenance, "provenance")
  , ("extensions", encPairs false d.extensions, "pairs") ]

def domainFieldNames : List String :=
  ["id", "name", "version", "description", "provenance", "extensions"]

theorem domainTriples_names (d : Domain) : (domainTriples d).map Prod.fst = domainFieldNames := rfl

/-! ## Domain objects -/

def objectTriples (o : DomainObject) : List (String × String × String) :=
  [ ("id", o.id, "identifier")
  , ("kind", o.kind, "identifier")
  , ("name", o.name, "string")
  , ("claim", o.claim, "text")
  , ("value", o.value, inferType o.value)
  , ("value_type", o.valueType, "type")
  , ("input_refs", encList false o.inputRefs, "list")
  , ("parameters", encPairs false o.parameters, "pairs")
  , ("transformations", encList false o.transformations, "list")
  , ("output_refs", encList false o.outputRefs, "list")
  , ("claim_refs", encList false o.claimRefs, "list")
  , ("evidence", encList false o.evidence, "list")
  , ("proof_refs", encList false o.proofRefs, "list")
  , ("error_refs", encList false o.errorRefs, "list")
  , ("truth_status", o.truth.name, "truth_status")
  , ("source_refs", encList false o.sourceRefs, "list")
  , ("provenance", encProv o.provenance, "provenance")
  , ("extensions", encPairs false o.extensions, "pairs") ]

def objectFieldNames : List String :=
  ["id", "kind", "name", "claim", "value", "value_type", "input_refs", "parameters",
   "transformations", "output_refs", "claim_refs", "evidence", "proof_refs", "error_refs",
   "truth_status", "source_refs", "provenance", "extensions"]

theorem objectTriples_names (o : DomainObject) :
    (objectTriples o).map Prod.fst = objectFieldNames := rfl

theorem objectTriples_ne_nil (o : DomainObject) : objectTriples o ≠ [] := by simp [objectTriples]

def objectOfValues : List String → Option DomainObject
  | [a, b, c, d, e, f, g, h, i, j, k, l, m, n, p, q, r, s] =>
    match decList g, decPairs h, decList i, decList j, decList k, decList l, decList m,
        decList n, TruthStatus.ofName p, decList q, decProv r, decPairs s with
    | some inp, some par, some trs, some out, some cls, some ev, some prf, some errs,
      some tr, some src, some prov, some ext =>
      some { id := a, kind := b, name := c, claim := d, value := e, valueType := f,
             inputRefs := inp, parameters := par, transformations := trs, outputRefs := out,
             claimRefs := cls, evidence := ev, proofRefs := prf, errorRefs := errs,
             truth := tr, sourceRefs := src, provenance := prov, extensions := ext }
    | _, _, _, _, _, _, _, _, _, _, _, _ => none
  | _ => none

@[simp] theorem objectOfValues_triples (o : DomainObject) :
    objectOfValues ((objectTriples o).map (fun t => t.2.1)) = some o := by
  simp [objectTriples, objectOfValues]

/-! ## Claims -/

def claimTriples (c : DomainClaim) : List (String × String × String) :=
  [ ("id", c.id, "identifier")
  , ("text", c.text, "text")
  , ("object_ref", c.objectRef, "identifier")
  , ("proof_refs", encList false c.proofRefs, "list")
  , ("truth_status", c.truth.name, "truth_status")
  , ("extensions", encPairs false c.extensions, "pairs") ]

def claimFieldNames : List String :=
  ["id", "text", "object_ref", "proof_refs", "truth_status", "extensions"]

theorem claimTriples_names (c : DomainClaim) :
    (claimTriples c).map Prod.fst = claimFieldNames := rfl

theorem claimTriples_ne_nil (c : DomainClaim) : claimTriples c ≠ [] := by simp [claimTriples]

def claimOfValues : List String → Option DomainClaim
  | [a, b, c, d, e, f] =>
    match decList d, TruthStatus.ofName e, decPairs f with
    | some prf, some tr, some ext =>
      some { id := a, text := b, objectRef := c, proofRefs := prf, truth := tr, extensions := ext }
    | _, _, _ => none
  | _ => none

@[simp] theorem claimOfValues_triples (c : DomainClaim) :
    claimOfValues ((claimTriples c).map (fun t => t.2.1)) = some c := by
  simp [claimTriples, claimOfValues]

/-! ## Proof records -/

def proofTriples (p : ProofRecord) : List (String × String × String) :=
  [ ("id", p.id, "identifier")
  , ("name", p.name, "string")
  , ("kind", p.kind, "identifier")
  , ("source_file", p.sourceFile, "path")
  , ("source_location", p.sourceLocation, "string")
  , ("input_refs", encList false p.inputRefs, "list")
  , ("assumptions", encList false p.assumptions, "list")
  , ("procedure", p.procedure, "text")
  , ("output_refs", encList false p.outputRefs, "list")
  , ("claim_refs", encList false p.claimRefs, "list")
  , ("dependencies", encList false p.dependencies, "list")
  , ("status", p.status.name, "proof_status")
  , ("certificate_kind", p.certificateKind, "identifier")
  , ("certificate_digest", p.certificateDigest, "digest")
  , ("certificate_location", p.certificateLocation, "path")
  , ("validation", p.validation.name, "validation")
  , ("provenance", encProv p.provenance, "provenance")
  , ("extensions", encPairs false p.extensions, "pairs") ]

def proofFieldNames : List String :=
  ["id", "name", "kind", "source_file", "source_location", "input_refs", "assumptions",
   "procedure", "output_refs", "claim_refs", "dependencies", "status", "certificate_kind",
   "certificate_digest", "certificate_location", "validation", "provenance", "extensions"]

theorem proofTriples_names (p : ProofRecord) :
    (proofTriples p).map Prod.fst = proofFieldNames := rfl

theorem proofTriples_ne_nil (p : ProofRecord) : proofTriples p ≠ [] := by simp [proofTriples]

def proofOfValues : List String → Option ProofRecord
  | [a, b, c, d, e, f, g, h, i, j, k, l, m, n, p, q, r, s] =>
    match decList f, decList g, decList i, decList j, decList k, ProofStatus.ofName l,
        Validation.ofName q, decProv r, decPairs s with
    | some inp, some asm, some out, some cls, some dep, some st, some val, some prov, some ext =>
      some { id := a, name := b, kind := c, sourceFile := d, sourceLocation := e,
             inputRefs := inp, assumptions := asm, procedure := h, outputRefs := out,
             claimRefs := cls, dependencies := dep, status := st, certificateKind := m,
             certificateDigest := n, certificateLocation := p, validation := val,
             provenance := prov, extensions := ext }
    | _, _, _, _, _, _, _, _, _ => none
  | _ => none

@[simp] theorem proofOfValues_triples (p : ProofRecord) :
    proofOfValues ((proofTriples p).map (fun t => t.2.1)) = some p := by
  simp [proofTriples, proofOfValues]

/-! ## Relations -/

def relationTriples (r : Relation) : List (String × String × String) :=
  [ ("source_id", r.sourceId, "identifier")
  , ("relation", r.kind.name, "relation_kind")
  , ("target_id", r.targetId, "identifier")
  , ("note", r.note, "string") ]

def relationFieldNames : List String := ["source_id", "relation", "target_id", "note"]

theorem relationTriples_names (r : Relation) :
    (relationTriples r).map Prod.fst = relationFieldNames := rfl

theorem relationTriples_ne_nil (r : Relation) : relationTriples r ≠ [] := by
  simp [relationTriples]

def relationOfValues : List String → Option Relation
  | [a, b, c, d] =>
    (RelationKind.ofName b).map (fun k => { sourceId := a, kind := k, targetId := c, note := d })
  | _ => none

@[simp] theorem relationOfValues_triples (r : Relation) :
    relationOfValues ((relationTriples r).map (fun t => t.2.1)) = some r := by
  simp [relationTriples, relationOfValues]

/-- The row identity of a relation.  An edge has no identifier of its own, and
the row label is only a label — the decoder reads the four fields positionally
— so the source of the edge is used and the rows stay short. -/
def relationRowId (r : Relation) : String := r.sourceId

/-! ## The whole table -/

/-- The canonical domain package as rows. -/
def encodeDomainTable (d : Domain) : List Cell :=
  blockCells "" d.id "domain" (domainTriples d)
    ++ d.objects.flatMap (fun o => blockCells d.id o.id "object" (objectTriples o))
    ++ d.claims.flatMap (fun c => blockCells d.id c.id "claim" (claimTriples c))
    ++ d.proofs.flatMap (fun p => blockCells d.id p.id "proof" (proofTriples p))
    ++ d.relations.flatMap (fun r =>
         blockCells d.id (relationRowId r) "relation" (relationTriples r))
    ++ d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e))

/-- Rebuild the scalar part of the package from its header row values. -/
def domainOfValues (vs : List String) (objects : List DomainObject) (claims : List DomainClaim)
    (proofs : List ProofRecord) (relations : List Relation) (errors : List Diagnostic)
    (leftover : List Cell) : Option Domain :=
  match vs with
  | [a, b, c, d, e, f] =>
    match decProv e, decPairs f with
    | some prov, some ext =>
      some { id := a, name := b, version := c, description := d, provenance := prov
             objects := objects, claims := claims, proofs := proofs, relations := relations
             errors := errors
             extensions := ext ++ leftover.map (fun cl =>
               ("domain.unparsed." ++ cl.objectType ++ "." ++ cl.objectId ++ "." ++ cl.field,
                 cl.value)) }
    | _, _ => none
  | _ => none

/-- Read rows back into a canonical domain package. -/
def decodeDomainTable (cs : List Cell) : Option Domain :=
  match takeBlock "domain" domainFieldNames cs with
  | none => none
  | some (hv, cs₁) =>
    let ov := decodeChildrenAll "object" objectFieldNames cs₁
    let cv := decodeChildrenAll "claim" claimFieldNames ov.2
    let pv := decodeChildrenAll "proof" proofFieldNames cv.2
    let rv := decodeChildrenAll "relation" relationFieldNames pv.2
    let ev := decodeChildrenAll "error" diagFieldNames rv.2
    match mapOpt objectOfValues ov.1, mapOpt claimOfValues cv.1, mapOpt proofOfValues pv.1,
        mapOpt relationOfValues rv.1, mapOpt diagOfValues ev.1 with
    | some objs, some cls, some prfs, some rels, some errs =>
      domainOfValues hv objs cls prfs rels errs ev.2
    | _, _, _, _, _ => none

/-! ## The projection is lossless -/

section Boundaries

private theorem nil_object : takeBlock "object" objectFieldNames [] = none := by
  simp [takeBlock, objectFieldNames]

private theorem nil_claim : takeBlock "claim" claimFieldNames [] = none := by
  simp [takeBlock, claimFieldNames]

private theorem nil_proof : takeBlock "proof" proofFieldNames [] = none := by
  simp [takeBlock, proofFieldNames]

private theorem nil_relation : takeBlock "relation" relationFieldNames [] = none := by
  simp [takeBlock, relationFieldNames]

private theorem nil_error : takeBlock "error" diagFieldNames [] = none := by
  simp [takeBlock, diagFieldNames]

/-- Skipping a run of `error` blocks: no other block type is read out of it. -/
private theorem past_errors (ot : String) (names : List String) (parent : String)
    (es : List Diagnostic) (hne : names ≠ []) (hot : ot ≠ "error")
    (hrest : takeBlock ot names [] = none) :
    takeBlock ot names (es.flatMap (fun e => blockCells parent e.id "error" (diagTriples e)))
      = none := by
  have := takeBlock_none_of_blocks (α := Diagnostic) ot "error" parent names diagTriples
    Diagnostic.id es [] hne hot diagTriples_ne_nil hrest
  simpa using this

end Boundaries

set_option maxHeartbeats 2000000 in
theorem decodeDomainTable_encodeDomainTable (d : Domain) :
    decodeDomainTable (encodeDomainTable d) = some d := by
  -- the tails each block must not run into
  have hb_rel : takeBlock "relation" relationFieldNames
      (d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e))) = none :=
    past_errors "relation" relationFieldNames d.id d.errors (by simp [relationFieldNames])
      (by decide) nil_relation
  have hb_prf : takeBlock "proof" proofFieldNames
      (d.relations.flatMap (fun r =>
          blockCells d.id (relationRowId r) "relation" (relationTriples r))
        ++ d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e))) = none := by
    refine takeBlock_none_of_blocks (α := Relation) "proof" "relation" d.id proofFieldNames
      relationTriples relationRowId d.relations _ (by simp [proofFieldNames]) (by decide)
      relationTriples_ne_nil ?_
    exact past_errors "proof" proofFieldNames d.id d.errors (by simp [proofFieldNames])
      (by decide) nil_proof
  have hb_cls : takeBlock "claim" claimFieldNames
      (d.proofs.flatMap (fun p => blockCells d.id p.id "proof" (proofTriples p))
        ++ (d.relations.flatMap (fun r =>
              blockCells d.id (relationRowId r) "relation" (relationTriples r))
          ++ d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e)))) = none := by
    refine takeBlock_none_of_blocks (α := ProofRecord) "claim" "proof" d.id claimFieldNames
      proofTriples ProofRecord.id d.proofs _ (by simp [claimFieldNames]) (by decide)
      proofTriples_ne_nil ?_
    refine takeBlock_none_of_blocks (α := Relation) "claim" "relation" d.id claimFieldNames
      relationTriples relationRowId d.relations _ (by simp [claimFieldNames]) (by decide)
      relationTriples_ne_nil ?_
    exact past_errors "claim" claimFieldNames d.id d.errors (by simp [claimFieldNames])
      (by decide) nil_claim
  have hb_obj : takeBlock "object" objectFieldNames
      (d.claims.flatMap (fun c => blockCells d.id c.id "claim" (claimTriples c))
        ++ (d.proofs.flatMap (fun p => blockCells d.id p.id "proof" (proofTriples p))
          ++ (d.relations.flatMap (fun r =>
                blockCells d.id (relationRowId r) "relation" (relationTriples r))
            ++ d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e))))) = none := by
    refine takeBlock_none_of_blocks (α := DomainClaim) "object" "claim" d.id objectFieldNames
      claimTriples DomainClaim.id d.claims _ (by simp [objectFieldNames]) (by decide)
      claimTriples_ne_nil ?_
    refine takeBlock_none_of_blocks (α := ProofRecord) "object" "proof" d.id objectFieldNames
      proofTriples ProofRecord.id d.proofs _ (by simp [objectFieldNames]) (by decide)
      proofTriples_ne_nil ?_
    refine takeBlock_none_of_blocks (α := Relation) "object" "relation" d.id objectFieldNames
      relationTriples relationRowId d.relations _ (by simp [objectFieldNames]) (by decide)
      relationTriples_ne_nil ?_
    exact past_errors "object" objectFieldNames d.id d.errors (by simp [objectFieldNames])
      (by decide) nil_object
  -- the header
  have hheader := takeBlock_blockCells "" d.id "domain" (domainTriples d)
    (d.objects.flatMap (fun o => blockCells d.id o.id "object" (objectTriples o))
      ++ (d.claims.flatMap (fun c => blockCells d.id c.id "claim" (claimTriples c))
        ++ (d.proofs.flatMap (fun p => blockCells d.id p.id "proof" (proofTriples p))
          ++ (d.relations.flatMap (fun r =>
                blockCells d.id (relationRowId r) "relation" (relationTriples r))
            ++ d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e))))))
  rw [domainTriples_names] at hheader
  -- the five runs
  have hobj := decodeChildrenAll_blocks "object" d.id objectFieldNames objectTriples
    DomainObject.id objectTriples_names objectTriples_ne_nil d.objects _ hb_obj
  have hcls := decodeChildrenAll_blocks "claim" d.id claimFieldNames claimTriples
    DomainClaim.id claimTriples_names claimTriples_ne_nil d.claims _ hb_cls
  have hprf := decodeChildrenAll_blocks "proof" d.id proofFieldNames proofTriples
    ProofRecord.id proofTriples_names proofTriples_ne_nil d.proofs _ hb_prf
  have hrel := decodeChildrenAll_blocks "relation" d.id relationFieldNames relationTriples
    relationRowId relationTriples_names relationTriples_ne_nil d.relations _ hb_rel
  have herr := decodeChildrenAll_blocks "error" d.id diagFieldNames diagTriples
    Diagnostic.id diagTriples_names diagTriples_ne_nil d.errors [] nil_error
  rw [List.append_nil] at herr
  have hmo : mapOpt objectOfValues
      (d.objects.map (fun o => (objectTriples o).map (fun t => t.2.1))) = some d.objects :=
    mapOpt_map _ _ objectOfValues_triples d.objects
  have hmc : mapOpt claimOfValues
      (d.claims.map (fun c => (claimTriples c).map (fun t => t.2.1))) = some d.claims :=
    mapOpt_map _ _ claimOfValues_triples d.claims
  have hmp : mapOpt proofOfValues
      (d.proofs.map (fun p => (proofTriples p).map (fun t => t.2.1))) = some d.proofs :=
    mapOpt_map _ _ proofOfValues_triples d.proofs
  have hmr : mapOpt relationOfValues
      (d.relations.map (fun r => (relationTriples r).map (fun t => t.2.1))) = some d.relations :=
    mapOpt_map _ _ relationOfValues_triples d.relations
  have hme : mapOpt diagOfValues
      (d.errors.map (fun e => (diagTriples e).map (fun t => t.2.1))) = some d.errors :=
    mapOpt_map _ _ diagOfValues_triples d.errors
  simp only [encodeDomainTable, decodeDomainTable, List.append_assoc, hheader, hobj, hcls,
    hprf, hrel, herr, hmo, hmc, hmp, hmr, hme]
  simp [domainTriples, domainOfValues]

/-- The projection determines the package. -/
theorem encodeDomainTable_inj {d e : Domain} (h : encodeDomainTable d = encodeDomainTable e) :
    d = e := by
  have hd := decodeDomainTable_encodeDomainTable d
  rw [h, decodeDomainTable_encodeDomainTable e] at hd
  exact (Option.some.inj hd).symm

/-! ## The partition

For a large domain the table may be emitted in parts.  The parts are exactly
the runs of the whole table, so a partitioned emission is the same data. -/

def domainHeaderCells (d : Domain) : List Cell := blockCells "" d.id "domain" (domainTriples d)

def objectCells (d : Domain) : List Cell :=
  d.objects.flatMap (fun o => blockCells d.id o.id "object" (objectTriples o))

def claimCells (d : Domain) : List Cell :=
  d.claims.flatMap (fun c => blockCells d.id c.id "claim" (claimTriples c))

def proofCells (d : Domain) : List Cell :=
  d.proofs.flatMap (fun p => blockCells d.id p.id "proof" (proofTriples p))

def relationCells (d : Domain) : List Cell :=
  d.relations.flatMap (fun r => blockCells d.id (relationRowId r) "relation" (relationTriples r))

def errorCells (d : Domain) : List Cell :=
  d.errors.flatMap (fun e => blockCells d.id e.id "error" (diagTriples e))

/-- Concatenating the parts gives the whole table back. -/
theorem encodeDomainTable_partition (d : Domain) :
    encodeDomainTable d =
      domainHeaderCells d ++ objectCells d ++ claimCells d ++ proofCells d ++ relationCells d
        ++ errorCells d := rfl

/-- Read a run of objects back on its own, so that `objects.csv` is a document
in its own right. -/
def decodeObjectCells (cs : List Cell) : Option (List DomainObject) :=
  mapOpt objectOfValues (decodeChildrenAll "object" objectFieldNames cs).1

theorem decodeObjectCells_objectCells (d : Domain) :
    decodeObjectCells (objectCells d) = some d.objects := by
  have h := decodeChildrenAll_blocks "object" d.id objectFieldNames objectTriples
    DomainObject.id objectTriples_names objectTriples_ne_nil d.objects [] nil_object
  rw [List.append_nil] at h
  simp only [decodeObjectCells, objectCells, h]
  exact mapOpt_map _ _ objectOfValues_triples d.objects

def decodeProofCells (cs : List Cell) : Option (List ProofRecord) :=
  mapOpt proofOfValues (decodeChildrenAll "proof" proofFieldNames cs).1

theorem decodeProofCells_proofCells (d : Domain) :
    decodeProofCells (proofCells d) = some d.proofs := by
  have h := decodeChildrenAll_blocks "proof" d.id proofFieldNames proofTriples
    ProofRecord.id proofTriples_names proofTriples_ne_nil d.proofs [] nil_proof
  rw [List.append_nil] at h
  simp only [decodeProofCells, proofCells, h]
  exact mapOpt_map _ _ proofOfValues_triples d.proofs

def decodeRelationCells (cs : List Cell) : Option (List Relation) :=
  mapOpt relationOfValues (decodeChildrenAll "relation" relationFieldNames cs).1

theorem decodeRelationCells_relationCells (d : Domain) :
    decodeRelationCells (relationCells d) = some d.relations := by
  have h := decodeChildrenAll_blocks "relation" d.id relationFieldNames relationTriples
    relationRowId relationTriples_names relationTriples_ne_nil d.relations [] nil_relation
  rw [List.append_nil] at h
  simp only [decodeRelationCells, relationCells, h]
  exact mapOpt_map _ _ relationOfValues_triples d.relations

def decodeClaimCells (cs : List Cell) : Option (List DomainClaim) :=
  mapOpt claimOfValues (decodeChildrenAll "claim" claimFieldNames cs).1

theorem decodeClaimCells_claimCells (d : Domain) :
    decodeClaimCells (claimCells d) = some d.claims := by
  have h := decodeChildrenAll_blocks "claim" d.id claimFieldNames claimTriples
    DomainClaim.id claimTriples_names claimTriples_ne_nil d.claims [] nil_claim
  rw [List.append_nil] at h
  simp only [decodeClaimCells, claimCells, h]
  exact mapOpt_map _ _ claimOfValues_triples d.claims

end Solfunmeme.Domain
