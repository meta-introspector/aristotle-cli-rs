import RequestProject.Solfunmeme.Codec.Conformance

/-!
# `solfunmeme-codec`: the reference implementation, runnable

Every command here is the proved definition, compiled.  Nothing in this file
re-implements a format: it calls `Codec.Formats`, `Codec.Exchange` and
`Codec.Reconcile`, so what the executable does is exactly what the theorems say.

    solfunmeme-codec formats                  list the codecs and their signatures
    solfunmeme-codec demo FORMAT              print the worked example in FORMAT
    solfunmeme-codec convert FORMAT FILE      re-encode a document in FORMAT
    solfunmeme-codec import FILE              import and print the report
    solfunmeme-codec id FILE                  the canonical content identity
    solfunmeme-codec validate FILE            the validation report
    solfunmeme-codec compare FILE FILE        the verdict and the differences
    solfunmeme-codec seal FORMAT SRC DST FILE seal an envelope, print it
    solfunmeme-codec suite                    run the §33 suite, all codecs
    solfunmeme-codec fixtures DIR             write the suite as files

`FORMAT` is one of `ipdl`, `xml`, `csv`, `yaml`, `text`.  A `FILE` may be `-`
for standard input; its format is detected (§11), so `convert` is enough to
move a proof between any two of the five.
-/

namespace Solfunmeme.Codec.Cli

open Solfunmeme.Codec

def usage : String :=
  "solfunmeme-codec formats                  list the codecs and their signatures\n" ++
  "solfunmeme-codec demo FORMAT              print the worked example in FORMAT\n" ++
  "solfunmeme-codec convert FORMAT FILE      re-encode a document in FORMAT\n" ++
  "solfunmeme-codec import FILE              import and print the report\n" ++
  "solfunmeme-codec id FILE                  the canonical content identity\n" ++
  "solfunmeme-codec validate FILE            the validation report\n" ++
  "solfunmeme-codec compare FILE FILE        the verdict and the differences\n" ++
  "solfunmeme-codec seal FORMAT SRC DST FILE seal an envelope, print it\n" ++
  "solfunmeme-codec suite                    run the §33 suite, all codecs\n" ++
  "solfunmeme-codec fixtures DIR             write the suite as files\n"

/-- §15's worked example, as a canonical object. -/
def demoObject : ProofObject :=
  { id := "proof-001"
    version := "1.0"
    kind := "theorem"
    inputs := [{ id := "n", name := "n", type := "integer", value := "144" }]
    outputs := [{ id := "result", name := "result", type := "integer", value := "12"
                  claims := ["12 * 12 = 144"] }]
    claims := ["144 has an integer square root"]
    status := .VALID
    provenance := { sourceSystem := "solfunmeme-codec", sourceFormat := "canonical" } }

def readSource (file : String) : IO String :=
  if file = "-" then do
    let stdin ← IO.getStdin
    stdin.readToEnd
  else IO.FS.readFile file

def describe (p : ProofObject) : String :=
  "id         " ++ p.id ++ "\n" ++
  "kind       " ++ p.kind ++ "\n" ++
  "status     " ++ p.status.name ++ "\n" ++
  "inputs     " ++ toString p.inputs.length ++ "\n" ++
  "outputs    " ++ toString p.outputs.length ++ "\n" ++
  "claims     " ++ toString p.claims.length ++ "\n" ++
  "errors     " ++ toString p.errors.length ++ "\n" ++
  "origin     " ++ (if p.provenance.sourceFormat = "" then "(none)" else p.provenance.sourceFormat)

def describeDiagnostic (d : Diagnostic) : String :=
  d.severity.name ++ " " ++ d.code ++ " " ++ d.field ++
    (if d.expected = "" then "" else " expected=" ++ d.expected) ++
    (if d.actual = "" then "" else " actual=" ++ d.actual) ++
    (if d.recoverable then " recoverable" else "")

def describeDifference (d : Difference) : String :=
  d.path ++ ": " ++ d.left ++ " | " ++ d.right ++ " (" ++ d.type ++ ", " ++ d.severity.name ++ ")"

/-- Import a document, whatever format it is in. -/
def importFile (file : String) : IO (ImportReport × String) := do
  let s ← readSource file
  return (importArtifact none "solfunmeme-codec" file s, s)

def main (args : List String) : IO UInt32 := do
  match args with
  | ["formats"] =>
      for r in codecs do
        IO.println (r.name ++ "/" ++ r.version ++ "  " ++ signature r)
      return 0
  | ["demo", fmt] =>
      match codecOfName fmt with
      | none => IO.eprintln ("unknown format " ++ fmt); return 1
      | some r => IO.print (r.encode demoObject); return 0
  | ["convert", fmt, file] =>
      match codecOfName fmt with
      | none => IO.eprintln ("unknown format " ++ fmt); return 1
      | some r =>
          let (rep, _) ← importFile file
          if rep.format = "text/raw" then
            IO.eprintln "the document did not parse in any known codec; nothing was discarded"
            IO.print (r.encode rep.object)
            return 1
          else
            IO.print (r.encode rep.object)
            return 0
  | ["import", file] =>
      let (rep, _) ← importFile file
      IO.println ("format     " ++ rep.format)
      IO.println ("lossiness  " ++ rep.lossiness.name)
      IO.println ("hash       " ++ toString rep.hash)
      IO.println (describe rep.object)
      for d in rep.diagnostics do
        IO.println ("diagnostic " ++ describeDiagnostic d)
      return 0
  | ["id", file] =>
      let (rep, _) ← importFile file
      IO.println (toString rep.hash)
      return 0
  | ["validate", file] =>
      let (rep, _) ← importFile file
      let v := validate rep.object
      IO.println ("reached    " ++ v.reached.name)
      if v.diagnostics.isEmpty then
        IO.println "clean      yes"
        return 0
      else
        for d in v.diagnostics do
          IO.println ("diagnostic " ++ describeDiagnostic d)
        return 1
  | ["compare", a, b] =>
      let (ra, _) ← importFile a
      let (rb, _) ← importFile b
      let v := compareObjects ra.object rb.object
      IO.println ("verdict    " ++ v.name)
      for d in diff ra.object rb.object do
        IO.println ("difference " ++ describeDifference d)
      return (if v = .EQUIVALENT then 0 else 1)
  | ["seal", fmt, src, dst, file] =>
      match codecOfName fmt with
      | none => IO.eprintln ("unknown format " ++ fmt); return 1
      | some r =>
          let (rep, _) ← importFile file
          let e := sealEnvelope r src dst "" rep.object
          IO.println ("schema     " ++ e.schemaVersion.name)
          IO.println ("codec      " ++ e.payloadFormat ++ "/" ++ e.codecVersion)
          IO.println ("source     " ++ e.source)
          IO.println ("destination " ++ e.destination)
          IO.println ("object     " ++ e.objectId)
          IO.println ("integrity  " ++ toString e.integrity)
          IO.println "payload"
          IO.print e.payload
          return 0
  | ["suite"] =>
      let mut failures := 0
      for r in codecs do
        for t in suite do
          if runCase r t then
            IO.println ("ok    " ++ r.name ++ "  " ++ t.name)
          else
            failures := failures + 1
            IO.println ("FAIL  " ++ r.name ++ "  " ++ t.name)
      IO.println ("cases " ++ toString (codecs.length * suite.length) ++
        ", failures " ++ toString failures)
      return (if failures = 0 then 0 else 1)
  | ["fixtures", dir] =>
      IO.FS.createDirAll dir
      let mut n := 0
      for t in suite do
        n := n + 1
        for r in codecs do
          let name := dir ++ "/case-" ++ toString n ++ "." ++ r.name
          IO.FS.writeFile name (r.encode t.object)
      IO.println ("wrote " ++ toString (suite.length * codecs.length) ++ " fixtures to " ++ dir)
      return 0
  | _ => IO.print usage; return 0

end Solfunmeme.Codec.Cli

/-- `lake exe solfunmeme-codec` -/
def main (args : List String) : IO UInt32 := Solfunmeme.Codec.Cli.main args
