import RequestProject.Solfunmeme.Domain.Table

/-!
# Emission: the same domain in every representation

A domain package is emitted as IPDL, XML, CSV, YAML and plain text.  None of
the five is the canonical form; all five are projections of the canonical graph
of `Domain.Model` through the table of `Domain.Table`.

The invariant the request calls the *cross-representation proof invariant* is

```text
decode(IPDL) = decode(XML) = decode(CSV) = decode(YAML) = decode(TEXT) = G
```

and it is `decodeDomain_cross` below.  It is not proved five times: the row
syntaxes are the codec's, the round trip is `RowSyntax.parse_render`, and the
table is lossless, so the invariant is one composition.

Emission may be partitioned — `objects.csv`, `proofs.yaml`, `relations.xml` —
and the parts are recoverable on their own (`decodeObjectsDoc_objectsDoc` and
its siblings), because the parts are exactly the runs of the whole table.
-/

namespace Solfunmeme.Domain

open Solfunmeme.Codec

/-! ## The whole package in one document -/

/-- Emit a domain package in a row syntax. -/
def encodeDomain (r : RowSyntax) (d : Domain) : String := r.render (encodeDomainTable d)

/-- Read a domain package back out of a document. -/
def decodeDomain (r : RowSyntax) (s : String) : Option Domain :=
  (r.parse s).bind decodeDomainTable

/-- Every well-formed row syntax carries a whole domain package losslessly. -/
theorem decodeDomain_encodeDomain {r : RowSyntax} (h : r.WF) (d : Domain) :
    decodeDomain r (encodeDomain r d) = some d := by
  simp [decodeDomain, encodeDomain, RowSyntax.parse_render h, decodeDomainTable_encodeDomainTable]

/-- Emission is deterministic and the document determines the package. -/
theorem encodeDomain_inj {r : RowSyntax} (h : r.WF) {d e : Domain}
    (heq : encodeDomain r d = encodeDomain r e) : d = e := by
  have hd := decodeDomain_encodeDomain h d
  rw [heq, decodeDomain_encodeDomain h e] at hd
  exact (Option.some.inj hd).symm

/-! ## The five deliverable codecs -/

def toDomainIpdl (d : Domain) : String := encodeDomain ipdl d
def ofDomainIpdl (s : String) : Option Domain := decodeDomain ipdl s

def toDomainXml (d : Domain) : String := encodeDomain xml d
def ofDomainXml (s : String) : Option Domain := decodeDomain xml s

def toDomainCsv (d : Domain) : String := encodeDomain csv d
def ofDomainCsv (s : String) : Option Domain := decodeDomain csv s

def toDomainYaml (d : Domain) : String := encodeDomain yaml d
def ofDomainYaml (s : String) : Option Domain := decodeDomain yaml s

def toDomainText (d : Domain) : String := encodeDomain text d
def ofDomainText (s : String) : Option Domain := decodeDomain text s

theorem ofDomainIpdl_toDomainIpdl (d : Domain) : ofDomainIpdl (toDomainIpdl d) = some d :=
  decodeDomain_encodeDomain ipdl_wf d

theorem ofDomainXml_toDomainXml (d : Domain) : ofDomainXml (toDomainXml d) = some d :=
  decodeDomain_encodeDomain xml_wf d

theorem ofDomainCsv_toDomainCsv (d : Domain) : ofDomainCsv (toDomainCsv d) = some d :=
  decodeDomain_encodeDomain csv_wf d

theorem ofDomainYaml_toDomainYaml (d : Domain) : ofDomainYaml (toDomainYaml d) = some d :=
  decodeDomain_encodeDomain yaml_wf d

theorem ofDomainText_toDomainText (d : Domain) : ofDomainText (toDomainText d) = some d :=
  decodeDomain_encodeDomain text_wf d

/-- Every codec of the registry carries a whole domain package. -/
theorem decodeDomain_of_codec (r : RowSyntax) (hr : r ∈ codecs) (d : Domain) :
    decodeDomain r (encodeDomain r d) = some d :=
  decodeDomain_encodeDomain (codecs_wf r hr) d

/-- **The cross-representation invariant.**  Whichever two of the five
representations are decoded, the graph that comes back is the same graph. -/
theorem decodeDomain_cross (r r' : RowSyntax) (hr : r ∈ codecs) (hr' : r' ∈ codecs) (d : Domain) :
    decodeDomain r (encodeDomain r d) = decodeDomain r' (encodeDomain r' d) := by
  rw [decodeDomain_of_codec r hr d, decodeDomain_of_codec r' hr' d]

/-- A document in one codec can be transcoded into any other and still decodes
to the same package: the representations are mutually recoverable. -/
def transcodeDomain (from_ to_ : RowSyntax) (s : String) : Option String :=
  (decodeDomain from_ s).map (encodeDomain to_)

theorem transcodeDomain_roundTrip {r r' : RowSyntax} (h : r.WF) (h' : r'.WF) (d : Domain) :
    (transcodeDomain r r' (encodeDomain r d)).bind (decodeDomain r') = some d := by
  simp [transcodeDomain, decodeDomain_encodeDomain h d, decodeDomain_encodeDomain h' d]

/-- Transcoding through any chain of the five is the identity on packages. -/
theorem transcodeDomain_chain {r r' r'' : RowSyntax} (h : r.WF) (h' : r'.WF) (h'' : r''.WF)
    (d : Domain) :
    ((transcodeDomain r r' (encodeDomain r d)).bind (transcodeDomain r' r'')).bind
        (decodeDomain r'') = some d := by
  simp [transcodeDomain, decodeDomain_encodeDomain h d, decodeDomain_encodeDomain h' d,
    decodeDomain_encodeDomain h'' d]

/-! ## Partitioned emission

`objects.csv`, `proofs.yaml`, `relations.xml`: each part is a document in its
own right, and each part decodes back to its run of the canonical graph. -/

def objectsDoc (r : RowSyntax) (d : Domain) : String := r.render (objectCells d)
def claimsDoc (r : RowSyntax) (d : Domain) : String := r.render (claimCells d)
def proofsDoc (r : RowSyntax) (d : Domain) : String := r.render (proofCells d)
def relationsDoc (r : RowSyntax) (d : Domain) : String := r.render (relationCells d)

def decodeObjectsDoc (r : RowSyntax) (s : String) : Option (List DomainObject) :=
  (r.parse s).bind decodeObjectCells

def decodeClaimsDoc (r : RowSyntax) (s : String) : Option (List DomainClaim) :=
  (r.parse s).bind decodeClaimCells

def decodeProofsDoc (r : RowSyntax) (s : String) : Option (List ProofRecord) :=
  (r.parse s).bind decodeProofCells

def decodeRelationsDoc (r : RowSyntax) (s : String) : Option (List Relation) :=
  (r.parse s).bind decodeRelationCells

theorem decodeObjectsDoc_objectsDoc {r : RowSyntax} (h : r.WF) (d : Domain) :
    decodeObjectsDoc r (objectsDoc r d) = some d.objects := by
  simp [decodeObjectsDoc, objectsDoc, RowSyntax.parse_render h, decodeObjectCells_objectCells]

theorem decodeClaimsDoc_claimsDoc {r : RowSyntax} (h : r.WF) (d : Domain) :
    decodeClaimsDoc r (claimsDoc r d) = some d.claims := by
  simp [decodeClaimsDoc, claimsDoc, RowSyntax.parse_render h, decodeClaimCells_claimCells]

theorem decodeProofsDoc_proofsDoc {r : RowSyntax} (h : r.WF) (d : Domain) :
    decodeProofsDoc r (proofsDoc r d) = some d.proofs := by
  simp [decodeProofsDoc, proofsDoc, RowSyntax.parse_render h, decodeProofCells_proofCells]

theorem decodeRelationsDoc_relationsDoc {r : RowSyntax} (h : r.WF) (d : Domain) :
    decodeRelationsDoc r (relationsDoc r d) = some d.relations := by
  simp [decodeRelationsDoc, relationsDoc, RowSyntax.parse_render h,
    decodeRelationCells_relationCells]

/-- The parts of a partitioned emission reassemble into the whole document, so
partitioning is a presentation choice and not a different package. -/
theorem partition_reassembles (r : RowSyntax) (d : Domain) :
    r.render (domainHeaderCells d ++ objectCells d ++ claimCells d ++ proofCells d
        ++ relationCells d ++ errorCells d) = encodeDomain r d := by
  rw [encodeDomain, encodeDomainTable_partition]

/-! ## Declared preservation level -/

/-- Every one of the five emissions is lossless, and the declaration is proved
rather than asserted. -/
def domainCodecLossiness (_ : RowSyntax) : Lossiness := .LOSSLESS

theorem domainCodecLossiness_honest {r : RowSyntax} (h : r.WF) :
    domainCodecLossiness r = .LOSSLESS ∧ ∀ d : Domain, decodeDomain r (encodeDomain r d) = some d :=
  ⟨rfl, decodeDomain_encodeDomain h⟩

end Solfunmeme.Domain
