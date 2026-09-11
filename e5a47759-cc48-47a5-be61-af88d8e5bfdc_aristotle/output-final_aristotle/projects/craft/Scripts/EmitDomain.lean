/-
# Emit the domain data package

Build and run with

```
lake build emitdomain
./.lake/build/bin/emitdomain
```

The program writes, into `domain/`,

* the whole domain graph in all five representations (`domain.ipdl`,
  `domain.xml`, `domain.csv`, `domain.yaml`, `domain.txt`);
* the relational CSV projections (`objects.csv`, `proofs.csv`, `claims.csv`,
  `relations.csv`, `inputs.csv`, `outputs.csv`, `evidence.csv`,
  `provenance.csv`, `errors.csv`);
* the proof ledger (`proof-ledger.csv`, `proof-ledger.yaml`);
* `provenance.yaml` and `proof-coverage.txt`;
* the reports (`codec-report.yaml`, `roundtrip-report.yaml`,
  `error-report.yaml`, `loss-report.yaml`);
* a small self-contained sub-package in `domain/sample/`, which is decoded
  end to end from its own bytes by the verified decoder.

Verification performed on the artefacts themselves:

1. every emitted file is read back and compared line by line with the rendered
   token stream, so the bytes on disk are exactly `LineCodec.emit`;
2. every line read back is parsed with the verified parser and compared with
   the token it was rendered from;
3. the sample package is decoded from its bytes with `LineCodec.decode` and
   compared with the canonical sub-graph.

Together with the theorems `Domain.LineCodec.decode_emit` and
`Domain.cross_representation`, this establishes that each emitted file decodes
to the canonical domain graph.
-/
import RequestProject.Domain.Instance

open Domain

/-- Write a list of lines, separated (not terminated) by newlines, so that the
file content is exactly `joinStr '\n' ls`, i.e. `LineCodec.emit`. -/
def writeLines (path : System.FilePath) (ls : List String) : IO Unit := do
  IO.FS.withFile path .write fun h => do
    let mut first := true
    for l in ls do
      if first then first := false else h.putStr "\n"
      h.putStr l

def csvRow (cs : List String) : String := joinStr ',' (cs.map esc)

def outDir : System.FilePath := "domain"

def yamlQ (s : String) : String := "\"" ++ esc s ++ "\""

def say (m : String) : IO Unit := do
  IO.println m
  (← IO.getStdout).flush

structure FormatOut where
  codec : LineCodec
  file : String
  sample : String

def formats : List FormatOut :=
  [⟨ipdlCodec, "domain.ipdl", "sample.ipdl"⟩, ⟨xmlCodec, "domain.xml", "sample.xml"⟩,
   ⟨csvCodec, "domain.csv", "sample.csv"⟩, ⟨yamlCodec, "domain.yaml", "sample.yaml"⟩,
   ⟨textCodec, "domain.txt", "sample.txt"⟩]

/-- The self-contained sub-package: the part of the domain that describes the
codec itself. -/
def sampleGraph : DomainGraph :=
  let os := Corpus.objects.filter (fun o => o.source.startsWith "RequestProject/Domain/Rec")
  let ids := os.map (fun o => o.id)
  let ps := Corpus.proofs.filter (fun p => p.outputs.any (fun x => ids.contains x))
  let cs := Corpus.claims.filter (fun c => ids.contains c.subject)
  let base : DomainGraph :=
    { id := "requestproject-domain-codec-sample",
      description := "the record/token backbone of the domain codec, as a self-contained package",
      objects := os, proofs := ps, relations := [], claims := cs,
      evidence := Corpus.evidence.filter (fun e => e.subject == "RequestProject.Domain.Rec"),
      errors := [], schemas := Corpus.schemas,
      provenance := Corpus.provenance.filter (fun p => p.subject == "RequestProject.Domain.Rec") }
  { base with relations := derivedRelations base }

/-- Write the lines, read them back, and check that the file is exactly the
rendered token stream and that every line re-parses to the token it came
from. -/
def emitAndCheck (path : System.FilePath) (C : LineCodec) (toks : List Tok) :
    IO (Nat × Bool × Bool) := do
  let ls := toks.map C.render
  writeLines path ls
  let back ← IO.FS.lines path
  let bytesOk := back == ls.toArray
  let tokArr := toks.toArray
  let mut parseOk := back.size == tokArr.size
  for i in [0:back.size] do
    if h : i < back.size then
      if C.parse back[i] != some tokArr[i]! then
        parseOk := false
  let size := (← IO.FS.readFile path).length
  return (size, bytesOk, parseOk)

def main : IO Unit := do
  let g := Corpus.graph
  IO.FS.createDirAll outDir
  IO.FS.createDirAll (outDir / "sample")
  let toks := toToks g.id g.toRecs
  let hash := g.canonicalHash
  say s!"domain    {g.id}"
  say s!"objects   {g.objects.length}"
  say s!"proofs    {g.proofs.length}"
  say s!"relations {g.relations.length}"
  say s!"tokens    {toks.length}"
  say s!"hash      {hash}"

  let sg := sampleGraph
  let stoks := toToks sg.id sg.toRecs
  let shash := sg.canonicalHash

  let mut report : List String := []
  let mut rtreport : List String := []
  for f in formats do
    let (size, bytesOk, parseOk) ← emitAndCheck (outDir / f.file) f.codec toks
    say s!"wrote {f.file} ({size} characters) bytes={bytesOk} parse={parseOk}"
    -- the sample package, decoded end to end from its own bytes
    let (ssize, sbytesOk, _) ← emitAndCheck (outDir / "sample" / f.sample) f.codec stoks
    let scontent ← IO.FS.readFile (outDir / "sample" / f.sample)
    let sdecoded := f.codec.decode scontent
    let sOk := sdecoded == some sg
    let sHashOk := (sdecoded.map DomainGraph.canonicalHash) == some shash
    say s!"  sample/{f.sample} ({ssize} characters) decode={sOk} hash={sHashOk}"
    report := report ++
      [s!"  - format: {f.codec.name}", s!"    file: {f.file}",
       s!"    characters: {size}", s!"    lines: {toks.length}",
       s!"    canonical_hash: \"{hash}\"",
       s!"    sample_file: sample/{f.sample}", s!"    sample_characters: {ssize}"]
    rtreport := rtreport ++
      [s!"  - format: {f.codec.name}", s!"    file: {f.file}",
       s!"    file_is_exactly_emit: {bytesOk}",
       s!"    every_line_reparses_to_its_token: {parseOk}",
       s!"    sample_file: sample/{f.sample}",
       s!"    sample_bytes_match: {sbytesOk}",
       s!"    sample_decoded_equals_canonical: {sOk}",
       s!"    sample_canonical_hash_matches: {sHashOk}"]

  -- relational CSV projections
  writeLines (outDir / "objects.csv")
    (csvRow ["object_id", "kind", "truth", "coverage", "proof_count", "canonical_hash", "source"] ::
      g.objects.map (fun o =>
        csvRow [o.id, o.kind, o.truth.toName, (objectCoverage g o).toName,
          toString o.proofRefs.length, toString o.canonicalHash, o.source]))
  writeLines (outDir / "proofs.csv")
    (csvRow ["proof_id", "name", "kind", "status", "certificate_kind", "certificate_digest",
        "machine_checked", "reproduced", "source_file", "source_location", "canonical_hash"] ::
      g.proofs.map (fun p =>
        csvRow [p.id, p.name, p.kind, p.status.toName, p.cert.kind, p.cert.digest,
          bName p.cert.machineChecked, bName p.cert.reproduced, p.sourceFile, p.sourceLoc,
          toString p.canonicalHash]))
  writeLines (outDir / "claims.csv")
    (csvRow ["claim_id", "subject", "statement"] ::
      g.claims.map (fun c => csvRow [c.id, c.subject, c.statement]))
  writeLines (outDir / "relations.csv")
    (csvRow ["source_id", "relation", "target_id"] ::
      g.relations.map (fun r => csvRow [r.src, r.kind.toName, r.dst]))
  writeLines (outDir / "inputs.csv")
    (csvRow ["proof_id", "input_id"] ::
      g.proofs.flatMap (fun p => p.inputs.map (fun i => csvRow [p.id, i])))
  writeLines (outDir / "outputs.csv")
    (csvRow ["proof_id", "output_id"] ::
      g.proofs.flatMap (fun p => p.outputs.map (fun o => csvRow [p.id, o])))
  writeLines (outDir / "evidence.csv")
    (csvRow ["evidence_id", "subject", "kind", "location"] ::
      g.evidence.map (fun e => csvRow [e.id, e.subject, e.kind, e.location]))
  writeLines (outDir / "provenance.csv")
    (csvRow ["provenance_id", "subject", "source", "method", "timestamp"] ::
      g.provenance.map (fun p => csvRow [p.id, p.subject, p.source, p.method, p.timestamp]))
  writeLines (outDir / "errors.csv")
    (csvRow ["error_id", "subject", "code", "severity", "resolved", "message", "resolution"] ::
      g.errors.map (fun e =>
        csvRow [e.id, e.subject, e.code, e.severity, bName e.resolved, e.message, e.resolution]))
  say "wrote relational CSV projections"

  -- the proof ledger
  let rows := ledger g
  writeLines (outDir / "proof-ledger.csv")
    (csvRow ["object_id", "claim_id", "proof_id", "proof_status", "coverage", "canonical_hash"] ::
      rows.map (fun r =>
        csvRow [r.objectId, r.claimId, r.proofId, r.proofStatus, r.coverage.toName,
          toString r.canonicalHash]))
  writeLines (outDir / "proof-ledger.yaml")
    ("ledger:" :: rows.flatMap (fun r =>
      [s!"  - object: {yamlQ r.objectId}", s!"    claim: {yamlQ r.claimId}",
       s!"    proof: {yamlQ r.proofId}", s!"    proof_status: {yamlQ r.proofStatus}",
       s!"    coverage: {yamlQ r.coverage.toName}",
       s!"    canonical_hash: \"{r.canonicalHash}\""]))
  say s!"wrote proof ledger ({rows.length} rows)"

  -- provenance
  writeLines (outDir / "provenance.yaml")
    (["domain: " ++ yamlQ g.id, "canonical_hash: \"" ++ toString hash ++ "\"", "provenance:"] ++
      g.provenance.flatMap (fun p =>
        [s!"  - id: {yamlQ p.id}", s!"    subject: {yamlQ p.subject}",
         s!"    source: {yamlQ p.source}", s!"    method: {yamlQ p.method}",
         s!"    timestamp: {yamlQ p.timestamp}"]))

  -- coverage
  let (pv, pp, up, ct) := coverageCounts g
  writeLines (outDir / "proof-coverage.txt")
    ["Domain Proof Coverage", "",
     s!"Domain:                   {g.id}",
     s!"Objects:                  {g.objects.length}",
     s!"Proven:                   {pv}",
     s!"Partially proven:         {pp}",
     s!"Unproven:                 {up}",
     s!"Contradicted:             {ct}",
     "",
     s!"Proofs:                   {g.proofs.length}",
     s!"  VALID:                  {(g.proofs.filter (fun p => p.status == .VALID)).length}",
     s!"  PARTIAL:                {(g.proofs.filter (fun p => p.status == .PARTIAL)).length}",
     s!"  INVALID:                {(g.proofs.filter (fun p => p.status == .INVALID)).length}",
     s!"  FAILED:                 {(g.proofs.filter (fun p => p.status == .FAILED)).length}",
     s!"  UNKNOWN:                {(g.proofs.filter (fun p => p.status == .UNKNOWN)).length}",
     s!"  CONFLICT:               {(g.proofs.filter (fun p => p.status == .CONFLICT)).length}",
     "",
     s!"Machine-checked:          {(g.proofs.filter (fun p => p.cert.machineChecked)).length}",
     s!"Independently reproduced: {(g.proofs.filter (fun p => p.cert.reproduced)).length}",
     "",
     s!"Relations:                {g.relations.length}",
     s!"Claims:                   {g.claims.length}",
     s!"Evidence records:         {g.evidence.length}",
     s!"Provenance records:       {g.provenance.length}",
     s!"Errors:                   {g.errors.length}",
     "",
     s!"Well formed (every reference resolves):        {wellFormedB g}",
     s!"Relation complete (every implied edge present): {relationComplete g}",
     "",
     "Unproven objects are the definition-like declarations of the corpus:",
     "they are ASSERTED constructions, not claims, so no proof establishes them."]
  say s!"coverage: proven={pv} partial={pp} unproven={up} contradicted={ct}"

  -- reports
  writeLines (outDir / "codec-report.yaml")
    (["domain: " ++ yamlQ g.id,
      "canonical_hash: \"" ++ toString hash ++ "\"",
      s!"objects: {g.objects.length}", s!"proofs: {g.proofs.length}",
      s!"relations: {g.relations.length}", s!"claims: {g.claims.length}",
      s!"evidence: {g.evidence.length}", s!"provenance: {g.provenance.length}",
      s!"errors: {g.errors.length}", s!"schemas: {g.schemas.length}",
      s!"tokens: {toks.length}",
      s!"well_formed: {wellFormedB g}",
      s!"relation_complete: {relationComplete g}",
      "sample_domain: " ++ yamlQ sg.id,
      "sample_canonical_hash: \"" ++ toString shash ++ "\"",
      "representations:"] ++ report)
  writeLines (outDir / "roundtrip-report.yaml")
    (["domain: " ++ yamlQ g.id,
      "method: >",
      "  every emitted file is read back from disk and compared line by line with the",
      "  rendered token stream, and every line read back is parsed with the verified",
      "  parser and compared with the token it was rendered from; the sample package is",
      "  additionally decoded end to end from its own bytes",
      "theorems:",
      "  - \"Domain.LineCodec.decode_emit : decode (emit g) = some g, for every format\"",
      "  - \"Domain.cross_representation : all five representations decode to the same graph\"",
      "  - \"Domain.LineCodec.canonicalHash_decode : the decoded graph has the canonical hash\"",
      "results:"] ++ rtreport)
  writeLines (outDir / "error-report.yaml")
    (["domain: " ++ yamlQ g.id, s!"errors: {g.errors.length}", "entries:"] ++
      g.errors.flatMap (fun e =>
        [s!"  - id: {yamlQ e.id}", s!"    subject: {yamlQ e.subject}",
         s!"    code: {yamlQ e.code}", s!"    severity: {yamlQ e.severity}",
         s!"    resolved: {bName e.resolved}", s!"    message: {yamlQ e.message}",
         s!"    resolution: {yamlQ e.resolution}"]))
  writeLines (outDir / "loss-report.yaml")
    ["domain: " ++ yamlQ g.id,
     "declared_lossy_transformations:",
     "  - id: reference-truncation",
     "    where: \"catalogue extraction (scripts/build_domain.py)\"",
     "    description: \"reference lists (proof inputs and dependencies) are truncated to 6 entries\"",
     "    affects: \"Domain.DProof.inputs, Domain.DProof.dependencies\"",
     "  - id: statement-truncation",
     "    where: \"catalogue extraction (scripts/build_domain.py)\"",
     "    description: \"claim texts are the declaration statement collapsed to one line, truncated to 320 characters\"",
     "    affects: \"Domain.DClaim.statement, Domain.DomainObject.claim\"",
     "codec_losses: none",
     "note: >",
     "  the five representations are lossless with respect to the canonical graph;",
     "  see roundtrip-report.yaml and the theorem Domain.LineCodec.decode_emit"]
  say "done"
