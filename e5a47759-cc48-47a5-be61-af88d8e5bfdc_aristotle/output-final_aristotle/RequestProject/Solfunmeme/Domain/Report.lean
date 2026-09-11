import RequestProject.Solfunmeme.Domain.Ledger

/-!
# The reports

The emitted package is not only the five representations of the graph: it also
carries the reports that let a reader check the claim the package makes about
itself.

* `coverageReportYaml` — how many objects are proven, partially proven,
  unproven and contradicted, computed from the graph.
* `ledgerCsv` / `ledgerYaml` — the proof ledger: object, claim, proof, status,
  coverage and canonical hash, one line per object-and-proof.
* `relationsCsv` — the closed proof-to-data graph as edges.
* `provenanceYaml` — where each object came from and what has been done to it.
* `codecReportYaml` — every codec, the bytes it produced and the preservation
  level it declares.
* `roundtripReportYaml` — the round trip *performed*, not asserted: the report
  decodes each emitted document and compares the result with the canonical
  graph, and prints the canonical hash it got back.
* `errorReportYaml` — the validation diagnostics, attached rather than thrown
  away.
* `proofGraphDot` — the audit path from a value to the proof, drawable.

Nothing here re-implements the model: every number is read off the same
functions the theorems are about.
-/

namespace Solfunmeme.Domain

open Solfunmeme.Codec

/-! ## Small helpers -/

/-- Escape a string for a double-quoted YAML scalar.  The reports are the
human-readable, deliberately lossy half of the package, so they quote rather
than escape: the canonical documents are the ones with the proved codec. -/
def yamlEscape (s : String) : String :=
  String.ofList (s.toList.flatMap (fun c =>
    if c = '"' then ['\\', '"']
    else if c = '\\' then ['\\', '\\']
    else if c = '\n' || c = '\r' || c = '\t' then [' ']
    else [c]))

def q (s : String) : String := "\"" ++ yamlEscape s ++ "\""

/-- A CSV field in the ordinary convention: quoted when it has to be. -/
def csvField (s : String) : String :=
  if s.any (fun c => c = ',' || c = '"' || c = '\n' || c = '\r') then
    "\"" ++ String.ofList (s.toList.flatMap (fun c =>
      if c = '"' then ['"', '"'] else if c = '\n' || c = '\r' then [' '] else [c])) ++ "\""
  else s

def nl : String := "\n"

def joinLines (xs : List String) : String := String.intercalate nl xs ++ nl

/-! ## Coverage -/

def coverageReportYaml (d : Domain) : String :=
  let c := d.coverageReport
  joinLines
    [ "# domain proof coverage"
    , "domain: " ++ q d.id
    , "canonical_hash: " ++ q (domainHash d)
    , "objects:"
    , "  total: " ++ toString c.objects
    , "  proven: " ++ toString c.proven
    , "  partially_proven: " ++ toString c.partiallyProven
    , "  unproven: " ++ toString c.unproven
    , "  contradicted: " ++ toString c.contradicted
    , "proofs:"
    , "  total: " ++ toString c.proofs
    , "  valid: " ++ toString c.validProofs
    , "  machine_checked: " ++ toString c.machineChecked
    , "  independently_reproduced: " ++ toString c.reproduced
    , "classification:"
    , "  rule: >-"
    , "    an object is PROVEN when it resolves to a VALID proof, PARTIALLY_PROVEN when it"
    , "    resolves only to a PARTIAL one, CONTRADICTED when it or one of its proofs says so,"
    , "    and UNPROVEN otherwise; the classes are proved to partition the objects"
    , "  theorem: Solfunmeme.Domain.Domain.coverageReport_total" ]

/-! ## The proof ledger -/

def ledgerCsvHeader : String :=
  "object_id,claim_id,proof_id,proof_status,truth_status,coverage,validation,canonical_hash"

def ledgerCsvRow (r : LedgerRow) : String :=
  String.intercalate ","
    [csvField r.objectId, csvField r.claimId, csvField r.proofId, csvField r.proofStatus,
     csvField r.truth, csvField r.coverage, csvField r.validation, csvField r.canonicalHash]

def ledgerCsv (d : Domain) : String :=
  joinLines (ledgerCsvHeader :: d.ledgerRows.map ledgerCsvRow)

def ledgerYamlEntry (r : LedgerRow) : List String :=
  [ "  - object: " ++ q r.objectId
  , "    claim: " ++ q r.claimId
  , "    proof: " ++ q r.proofId
  , "    proof_status: " ++ q r.proofStatus
  , "    truth: " ++ q r.truth
  , "    coverage: " ++ q r.coverage
  , "    validation: " ++ q r.validation
  , "    canonical_hash: " ++ q r.canonicalHash ]

def ledgerYaml (d : Domain) : String :=
  joinLines
    ([ "# the proof ledger: the authoritative index from a value to its evidence"
     , "domain: " ++ q d.id
     , "canonical_hash: " ++ q (domainHash d)
     , "lossiness: LOSSY   # a summary; the canonical graph is domain.yaml"
     , "ledger:" ] ++ d.ledgerRows.flatMap ledgerYamlEntry)

/-! ## Relations -/

def relationsCsv (d : Domain) : String :=
  joinLines
    ("source_id,relation,target_id,note"
      :: d.graph.map (fun r =>
          String.intercalate ","
            [csvField r.sourceId, r.kind.name, csvField r.targetId, csvField r.note]))

/-! ## Provenance -/

def provenanceLines (indent : String) (v : Provenance) : List String :=
  [ indent ++ "source_system: " ++ q v.sourceSystem
  , indent ++ "source_file: " ++ q v.sourceFile
  , indent ++ "source_format: " ++ q v.sourceFormat
  , indent ++ "imported_at: " ++ q v.importedAt
  , indent ++ "transformed_at: " ++ q v.transformedAt
  , indent ++ "parent_object: " ++ q v.parentObject
  , indent ++ "transformations: [" ++
      String.intercalate ", " (v.transformations.map q) ++ "]" ]

def provenanceYaml (d : Domain) : String :=
  joinLines
    ([ "# provenance of the package and of every object in it"
     , "domain: " ++ q d.id
     , "canonical_hash: " ++ q (domainHash d)
     , "package:" ] ++ provenanceLines "  " d.provenance ++
     [ "objects:" ] ++
     d.objects.flatMap (fun o =>
       [ "  - id: " ++ q o.id
       , "    truth: " ++ q o.truth.name
       , "    coverage: " ++ q (d.coverage o).name
       , "    canonical_hash: " ++ q (objectHash o.unstamped)
       , "    proof_refs: [" ++ String.intercalate ", " (o.proofRefs.map q) ++ "]"
       , "    source_refs: [" ++ String.intercalate ", " (o.sourceRefs.map q) ++ "]"
       , "    provenance:" ] ++ provenanceLines "      " o.provenance) ++
     [ "proofs:" ] ++
     d.proofs.flatMap (fun p =>
       [ "  - id: " ++ q p.id
       , "    kind: " ++ q p.kind
       , "    status: " ++ q p.status.name
       , "    validation: " ++ q p.validation.name
       , "    certificate_kind: " ++ q p.certificateKind
       , "    certificate_location: " ++ q p.certificateLocation
       , "    source_file: " ++ q p.sourceFile
       , "    source_location: " ++ q p.sourceLocation
       , "    canonical_hash: " ++ q (proofHash p) ]))

/-! ## The codecs -/

/-- One line of the codec report: what the codec is, how many bytes it
produced, and what preservation level it declares. -/
def codecReportEntry (d : Domain) (written : List RowSyntax) (r : RowSyntax) : List String :=
  let doc := encodeDomain r d
  [ "  - codec: " ++ q r.name
  , "    version: " ++ q r.version
  , "    emitted_as_a_file: " ++
      (if written.any (fun x => x.name == r.name) then "true" else "false")
  , "    bytes: " ++ toString doc.utf8ByteSize
  , "    rows: " ++ toString (encodeDomainTable d).length
  , "    lossiness: LOSSLESS"
  , "    theorem: Solfunmeme.Domain.decodeDomain_encodeDomain" ]

def codecReportYaml (d : Domain) (rs written : List RowSyntax) : String :=
  joinLines
    ([ "# every representation this package is emitted in"
     , "domain: " ++ q d.id
     , "canonical_hash: " ++ q (domainHash d)
     , "canonical_form: >-"
     , "    the canonical form is the domain graph itself; every file below is a projection of"
     , "    it through the tabular convention object_id, object_type, field, value, value_type,"
     , "    parent_id"
     , "codecs:" ] ++ rs.flatMap (codecReportEntry d written) ++
     [ "summary:"
     , "  codecs: " ++ toString rs.length
     , "  all_lossless: true"
     , "  theorem: Solfunmeme.Domain.decodeDomain_of_codec" ])

/-! ## The round trip, performed -/

/-- Decode what was emitted and compare it with the canonical graph.  This is
the report the specification calls for: not "the round trip is proved" but "the
round trip was run, and here is what came back". -/
def roundtripEntry (d : Domain) (r : RowSyntax) : List String :=
  let doc := encodeDomain r d
  let back := decodeDomain r doc
  let ok := back == some d
  let hash := match back with | some e => domainHash e | none => "(no decode)"
  [ "  - codec: " ++ q r.name
  , "    bytes: " ++ toString doc.utf8ByteSize
  , "    decoded: " ++ (if back.isSome then "true" else "false")
  , "    equals_canonical: " ++ (if ok then "true" else "false")
  , "    canonical_hash: " ++ q hash
  , "    result: " ++ (if ok then "PASS" else "FAIL") ]

def roundtripReportYaml (d : Domain) (rs : List RowSyntax) : String :=
  let results := rs.map (fun r => decodeDomain r (encodeDomain r d) == some d)
  joinLines
    ([ "# the round trip, performed at emission time"
     , "domain: " ++ q d.id
     , "canonical_hash: " ++ q (domainHash d)
     , "codecs:" ] ++ rs.flatMap (roundtripEntry d) ++
     [ "summary:"
     , "  checked: " ++ toString results.length
     , "  passed: " ++ toString (results.countP id)
     , "  failed: " ++ toString (results.countP (fun b => !b))
     , "  same_hash_in_every_codec: " ++
         (if results.all id then "true" else "false")
     , "  theorem: Solfunmeme.Domain.domainHash_of_any_codec" ])

/-! ## Errors -/

def errorReportYaml (d : Domain) : String :=
  let ds := d.validate
  joinLines
    ([ "# validation diagnostics, attached to the package rather than thrown away"
     , "domain: " ++ q d.id
     , "canonical_hash: " ++ q (domainHash d)
     , "checks:"
     , "  - UNRESOLVED_PROOF_REF"
     , "  - UNRESOLVED_CLAIM_REF"
     , "  - UNRESOLVED_OBJECT_REF"
     , "  - UNRESOLVED_DEPENDENCY"
     , "  - UNJUSTIFIED_PROVEN"
     , "  - CONTRADICTION"
     , "  - UNCERTIFIED_VALID"
     , "  - DANGLING_RELATION"
     , "diagnostics:" ] ++
     ds.flatMap (fun e =>
       [ "  - code: " ++ q e.code
       , "    severity: " ++ q e.severity.name
       , "    object: " ++ q e.objectId
       , "    message: " ++ q e.message ]) ++
     [ "summary:"
     , "  count: " ++ toString ds.length
     , "  well_formed: " ++ (if ds.isEmpty then "true" else "false")
     , "  carried_errors: " ++ toString d.errors.length ])

/-! ## The graph, drawable -/

def proofGraphDot (d : Domain) : String :=
  joinLines
    ([ "digraph proof_coverage {"
     , "  rankdir=LR;"
     , "  node [shape=box];" ] ++
     d.objects.map (fun o =>
       "  " ++ q o.id ++ " [shape=box, label=" ++ q (o.id ++ "\\n" ++ (d.coverage o).name) ++ "];") ++
     d.claims.map (fun c => "  " ++ q c.id ++ " [shape=note];") ++
     d.proofs.map (fun p =>
       "  " ++ q p.id ++ " [shape=ellipse, label=" ++ q (p.id ++ "\\n" ++ p.status.name) ++ "];") ++
     d.graph.map (fun r =>
       "  " ++ q r.sourceId ++ " -> " ++ q r.targetId ++ " [label=" ++ q r.kind.name ++ "];") ++
     [ "}" ])

/-! ## The text representation

Raw text is not second class: it carries the domain description, the objects,
the claims, the proofs, the inputs, the outputs, the relationships, the
diagnostics and the provenance, in a form a person can read. -/

def domainTextReport (d : Domain) : String :=
  joinLines
    ([ "DOMAIN: " ++ d.id
     , "NAME: " ++ d.name
     , "VERSION: " ++ d.version
     , "CANONICAL HASH: " ++ domainHash d
     , ""
     , "DESCRIPTION:"
     , "  " ++ d.description
     , "" ] ++
     d.objects.flatMap (fun o =>
       [ "OBJECT: " ++ o.id
       , "TYPE: " ++ o.kind
       , "VALUE: " ++ o.value
       , "TRUTH: " ++ o.truth.name
       , "COVERAGE: " ++ (d.coverage o).name
       , "HASH: " ++ objectHash o.unstamped
       , "CLAIM:"
       , "  " ++ o.claim
       , "PROVEN BY:" ] ++
       (if o.proofRefs.isEmpty then ["  (nothing)"] else o.proofRefs.map (fun r => "  " ++ r)) ++
       [ "SOURCE:" ] ++
       (if o.sourceRefs.isEmpty then ["  (none)"] else o.sourceRefs.map (fun r => "  " ++ r)) ++
       [ "" ]) ++
     d.proofs.flatMap (fun p =>
       [ "PROOF: " ++ p.id
       , "KIND: " ++ p.kind
       , "STATUS: " ++ p.status.name
       , "VALIDATION: " ++ p.validation.name
       , "CERTIFICATE: " ++ p.certificateKind ++ " at " ++ p.certificateLocation
       , "LOCATION: " ++ p.sourceFile ++ " " ++ p.sourceLocation
       , "INPUTS:" ] ++
       (if p.inputRefs.isEmpty then ["  (none)"] else p.inputRefs.map (fun r => "  " ++ r)) ++
       [ "OUTPUTS:" ] ++
       (if p.outputRefs.isEmpty then ["  (none)"] else p.outputRefs.map (fun r => "  " ++ r)) ++
       [ "" ]) ++
     [ "DIAGNOSTICS:" ] ++
     (if d.validate.isEmpty then ["  (none)"]
      else d.validate.map (fun e => "  " ++ e.severity.name ++ " " ++ e.code ++ " " ++ e.objectId)) ++
     [ ""
     , "PROVENANCE:"
     , "  source system: " ++ d.provenance.sourceSystem
     , "  source file: " ++ d.provenance.sourceFile
     , "  imported at: " ++ d.provenance.importedAt
     , "  transformations: " ++ String.intercalate ", " d.provenance.transformations ])

end Solfunmeme.Domain
