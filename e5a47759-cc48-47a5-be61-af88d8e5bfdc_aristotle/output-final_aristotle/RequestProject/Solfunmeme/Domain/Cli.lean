import RequestProject.Solfunmeme.Domain.Report
import RequestProject.Solfunmeme.Domain.Facts

/-!
# `solfunmeme-domain`: the skill, runnable

    solfunmeme-domain domains                 list the packages this build carries
    solfunmeme-domain emit DIR [DOMAIN]       write the whole domain data package
    solfunmeme-domain check DIR [DOMAIN]      re-read the emitted files and compare
    solfunmeme-domain ledger [DOMAIN]         print the proof ledger
    solfunmeme-domain coverage [DOMAIN]       print the coverage report
    solfunmeme-domain roundtrip [DOMAIN]      run the round trip in all five codecs
    solfunmeme-domain validate [DOMAIN]       print the validation diagnostics
    solfunmeme-domain graph [DOMAIN]          print the proof-to-data graph
    solfunmeme-domain text [DOMAIN]           print the raw-text representation
    solfunmeme-domain show FORMAT [DOMAIN]    print one representation
    solfunmeme-domain hash [DOMAIN]           the canonical hash of the package

`DOMAIN` is `dataset` (the default) or `corpus`.  `FORMAT` is one of `ipdl`,
`xml`, `csv`, `yaml`, `text`.

Every command calls the proved definitions: `emit` writes exactly what
`Domain.Emit` encodes, and `check` decodes with the same decoder the round-trip
theorem is about, so a passing `check` is the theorem exercised on real bytes.
-/

namespace Solfunmeme.Domain.Cli

open Solfunmeme.Codec
open Solfunmeme.Domain
open Solfunmeme.Domain.Data

def usage : String :=
  "solfunmeme-domain domains                 list the packages this build carries\n" ++
  "solfunmeme-domain emit DIR [DOMAIN]       write the whole domain data package\n" ++
  "solfunmeme-domain check DIR [DOMAIN]      re-read the emitted files and compare\n" ++
  "solfunmeme-domain ledger [DOMAIN]         print the proof ledger\n" ++
  "solfunmeme-domain coverage [DOMAIN]       print the coverage report\n" ++
  "solfunmeme-domain roundtrip [DOMAIN]      run the round trip in all five codecs\n" ++
  "solfunmeme-domain validate [DOMAIN]       print the validation diagnostics\n" ++
  "solfunmeme-domain graph [DOMAIN]          print the proof-to-data graph\n" ++
  "solfunmeme-domain text [DOMAIN]           print the raw-text representation\n" ++
  "solfunmeme-domain show FORMAT [DOMAIN]    print one representation\n" ++
  "solfunmeme-domain hash [DOMAIN]           the canonical hash of the package\n" ++
  "\nDOMAIN is dataset (default) or corpus; FORMAT is ipdl, xml, csv, yaml or text.\n"

/-- The packages this build carries. -/
def domains : List (String × Domain) :=
  [("dataset", solfunmemeDataset), ("corpus", proofCorpusDomain)]

def domainOf (name : String) : Option Domain :=
  (domains.find? (fun p => p.1 == name)).map Prod.snd

def pick : List String → Option Domain
  | [] => some solfunmemeDataset
  | [n] => domainOf n
  | _ => none

/-- The file extension a codec's documents get. -/
def ext (r : RowSyntax) : String :=
  if r.name == "text" then "txt" else r.name

/-- Every file of the package, as (name, contents).  `whole` is the list of
codecs the entire package is emitted in and `parts` the list the partitioned
emission uses; a large domain declares a smaller set rather than writing
thirty megabytes nobody reads, and the codec report says which set was used. -/
def packageFiles (d : Domain) (whole parts reported : List RowSyntax) : List (String × String) :=
  whole.map (fun r => ("domain." ++ ext r, encodeDomain r d))
    ++ parts.map (fun r => ("objects." ++ ext r, objectsDoc r d))
    ++ parts.map (fun r => ("claims." ++ ext r, claimsDoc r d))
    ++ parts.map (fun r => ("proofs." ++ ext r, proofsDoc r d))
    ++ parts.map (fun r => ("relations." ++ ext r, relationsDoc r d))
    ++ [ ("proof-ledger.csv", ledgerCsv d)
       , ("proof-ledger.yaml", ledgerYaml d)
       , ("provenance.yaml", provenanceYaml d)
       , ("coverage-report.yaml", coverageReportYaml d)
       , ("codec-report.yaml", codecReportYaml d reported whole)
       , ("roundtrip-report.yaml", roundtripReportYaml d reported)
       , ("error-report.yaml", errorReportYaml d) ]
    ++ (if whole.isEmpty then []
        else [ ("relations-closure.csv", relationsCsv d)
             , ("domain-report.txt", domainTextReport d)
             , ("proof-graph.dot", proofGraphDot d) ])

/-- The corpus package is two orders of magnitude larger than the dataset one,
so it is emitted in the two codecs a reader is most likely to consume and the
rest is available from `solfunmeme-domain show`. -/
def emissionCodecs (d : Domain) : List RowSyntax × List RowSyntax × List RowSyntax :=
  if d.proofs.length > 200 then ([], [csv], [csv, yaml]) else (codecs, codecs, codecs)

def emit (dir : String) (d : Domain) : IO Unit := do
  IO.FS.createDirAll dir
  let (whole, parts, reported) := emissionCodecs d
  for (name, contents) in packageFiles d whole parts reported do
    IO.FS.writeFile (dir ++ "/" ++ name) contents
    IO.println (dir ++ "/" ++ name ++ "  " ++ toString contents.utf8ByteSize ++ " bytes")
  IO.println ("canonical hash " ++ domainHash d)

/-- Read every emitted representation back and compare it with the canonical
graph.  This is the cross-representation invariant, checked on the files. -/
def check (dir : String) (d : Domain) : IO UInt32 := do
  let mut failures := 0
  let (whole, parts, _) := emissionCodecs d
  for r in whole do
    let path := dir ++ "/domain." ++ ext r
    let present ← System.FilePath.pathExists path
    if !present then
      IO.println ("MISSING  " ++ path)
      failures := failures + 1
    else
      let text ← IO.FS.readFile path
      match decodeDomain r text with
      | none =>
        IO.println ("UNREADABLE  " ++ path)
        failures := failures + 1
      | some e =>
        if e == d then
          IO.println ("OK  " ++ path ++ "  " ++ domainHash e)
        else
          IO.println ("DIFFERENT  " ++ path ++ "  " ++ domainHash e ++ " ≠ " ++ domainHash d)
          failures := failures + 1
  for (part, cells) in
      [("objects", objectCells d), ("claims", claimCells d), ("proofs", proofCells d),
       ("relations", relationCells d)] do
    for r in parts do
      let path := dir ++ "/" ++ part ++ "." ++ ext r
      let present ← System.FilePath.pathExists path
      if !present then
        IO.println ("MISSING  " ++ path)
        failures := failures + 1
      else
        let text ← IO.FS.readFile path
        match r.parse text with
        | some cs =>
          if cs == cells then IO.println ("OK  " ++ path)
          else
            IO.println ("DIFFERENT  " ++ path)
            failures := failures + 1
        | none =>
          IO.println ("UNREADABLE  " ++ path)
          failures := failures + 1
  if failures == 0 then
    IO.println "all representations decode to the same canonical graph"
    return 0
  else
    IO.println (toString failures ++ " representation(s) failed")
    return 1

def ledgerText (d : Domain) : String :=
  let pad (n : Nat) (s : String) : String :=
    if s.length ≥ n then s ++ " " else s ++ String.ofList (List.replicate (n - s.length) ' ')
  let header := pad 34 "object" ++ pad 52 "proof" ++ pad 10 "status" ++ pad 18 "coverage" ++ "truth"
  String.intercalate "\n"
    (header :: d.ledgerRows.map (fun r =>
      pad 34 r.objectId ++ pad 52 r.proofId ++ pad 10 r.proofStatus ++ pad 18 r.coverage ++ r.truth))

def run : List String → IO UInt32
  | ["domains"] => do
    for (name, d) in domains do
      IO.println (name ++ "  " ++ d.id ++ "  objects " ++ toString d.objects.length ++
        "  claims " ++ toString d.claims.length ++ "  proofs " ++ toString d.proofs.length ++
        "  hash " ++ domainHash d)
    return 0
  | "emit" :: dir :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => emit dir d; return 0
  | "check" :: dir :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => check dir d
  | "ledger" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => IO.println (ledgerText d); return 0
  | "coverage" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => IO.print (coverageReportYaml d); return 0
  | "roundtrip" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d =>
      let (_, _, reported) := emissionCodecs d
      IO.print (roundtripReportYaml d reported)
      return (if reported.all (fun r => decodeDomain r (encodeDomain r d) == some d) then 0 else 1)
  | "validate" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d =>
      IO.print (errorReportYaml d)
      return (if d.validate.isEmpty then 0 else 1)
  | "graph" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => IO.print (proofGraphDot d); return 0
  | "text" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => IO.print (domainTextReport d); return 0
  | "show" :: fmt :: rest => do
    match codecOfName fmt, pick rest with
    | some r, some d => IO.print (encodeDomain r d); return 0
    | _, _ => IO.eprintln usage; return 2
  | "hash" :: rest => do
    match pick rest with
    | none => IO.eprintln usage; return 2
    | some d => IO.println (domainHash d); return 0
  | _ => do
    IO.eprintln usage
    return 2

end Solfunmeme.Domain.Cli

def main (args : List String) : IO UInt32 := Solfunmeme.Domain.Cli.run args
