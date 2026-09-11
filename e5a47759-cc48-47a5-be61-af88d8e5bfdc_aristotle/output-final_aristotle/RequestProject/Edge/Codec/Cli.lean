/-
# `cfdeploy codec` — the interchange layer on the command line

Four subcommands, each a thin shell around the proved machinery:

```text
cfdeploy codec list                                   the registry and what it claims
cfdeploy codec check   <file> [--from F]              detect, identify, validate
cfdeploy codec convert <file> --to F [--from F] [--out FILE]
cfdeploy codec diff    <a> <b>                        semantic comparison
```

Nothing here decides anything on its own: the format is decided by
`Detect.detectFormat`, the conversion by `Convert.convert`, the verdict
by `Reconcile.verdict`, and the preservation level printed against a
conversion is the one the codecs themselves declare.
-/
import RequestProject.Edge.Codec.Convert

namespace CfDeploy
namespace Codec
namespace Cli

/-! ## Rendering -/

def pad (s : String) (n : Nat) : String :=
  if s.length ≥ n then s else s ++ String.ofList (List.replicate (n - s.length) ' ')

/-- One line per codec: the §9 conformance table. -/
def registryLines : List String :=
  codecs.map fun c =>
    "  " ++ pad c.name 12 ++ pad c.version 6 ++ pad c.lossiness.toString 10 ++
      (match c.lossiness with
       | .lossless => "round trip proved in Lean"
       | _ => "no round-trip claim")

/-- An empty field, shown as such rather than as blank space. -/
def orNone (s : String) : String := if s = "" then "(none)" else s

/-- The names of the registered codecs, for an error message. -/
def formatNames : String := String.intercalate ", " (codecs.map (fun c => c.name))

def errorLine (e : CError) : String :=
  "    " ++ pad e.severity.toString 8 ++ pad e.code 22 ++ e.message ++
    (if e.field = "" then "" else "  (" ++ e.field ++ ")")

def reportLines (r : Validate.Report) : List String :=
  let level (name : String) (es : List CError) : List String :=
    ("  " ++ pad name 12 ++ (if es.isEmpty then "ok" else Parse.intStr es.length ++ " error(s)"))
      :: es.map errorLine
  level "1 syntax" r.syntax' ++ level "2 structure" r.structure' ++
    level "3 type" r.type' ++ level "4 semantics" r.semantics

def differenceLine (d : Reconcile.Difference) : String :=
  "  " ++ pad d.path 28 ++ pad d.type 18 ++ pad d.severity.toString 8 ++ d.explanation

/-! ## The subcommands -/

def cmdList : IO Unit := do
  IO.println "codec       ver   preservation  claim"
  for l in registryLines do IO.println l
  IO.println ""
  IO.println "A codec cannot be registered as LOSSLESS without a machine-checked proof"
  IO.println "that decoding its encoding returns the value it was given (Codec.StringCodec)."

/-- Read a file, decide what it is, identify it, and validate it. -/
def cmdCheck (path : String) (declared : Option String) : IO Unit := do
  let src ← IO.FS.readFile path
  let d := decodeAuto declared src
  let p := Convert.objectOf d
  IO.println s!"file        {path} ({src.length} chars)"
  IO.println s!"format      {d.format.name} (by {(detectFormat declared src).evidence.name})"
  if d.fellBack then
    IO.println "            the declared codec could not parse it; kept as raw text, verbatim"
  IO.println s!"cid         {ProofObject.cid p}"
  IO.println s!"id          {orNone p.id}"
  IO.println s!"kind        {orNone p.kind}"
  IO.println s!"status      {p.status.toString}"
  IO.println s!"inputs      {p.inputs.length}   outputs {p.outputs.length}"
  IO.println s!"errors      {p.errors.length}   warnings {p.warnings.length}"
  if !(Convert.ledger p).isEmpty then
    IO.println "ledger"
    for l in Convert.ledger p do IO.println s!"  {l}"
  IO.println "validation"
  for l in reportLines (Validate.validate d.format src p) do IO.println l
  let r := Validate.validate d.format src p
  IO.println (if r.ok then "verdict     valid at every level"
              else s!"verdict     {r.all.length} finding(s); the object is kept either way")

/-- Convert a file into another format, recording the step. -/
def cmdConvert (path : String) (declared : Option String) (target : String)
    (out : Option String) (at' : String) : IO UInt32 := do
  match Format.ofName target with
  | none =>
      IO.eprintln s!"unknown format: {target}"
      IO.eprintln s!"known formats: {formatNames}"
      return 1
  | some t =>
      let src ← IO.FS.readFile path
      let o := Convert.convert declared t at' src
      let summary :=
        [ s!"read        {path} as {o.detection.format.name} (by {o.detection.evidence.name})"
        , s!"wrote       {t.name} with {o.record.codec}/{o.record.codecVersion}"
        , s!"preservation {o.record.lossiness.toString}" ++
            (if o.fellBack then "  (the source could not be parsed and was kept as raw text)"
             else "")
        , s!"cid         {ProofObject.cid o.object}"
        , "ledger" ] ++ (Convert.ledger o.object).map (fun l => "  " ++ l)
      match out with
      | some f =>
          IO.FS.writeFile f o.text
          for l in summary do IO.println l
          IO.println s!"wrote       {f} ({o.text.length} chars)"
      | none =>
          for l in summary do IO.eprintln l
          IO.print o.text
      return 0

/-- Compare two files semantically. -/
def cmdDiff (left right : String) : IO UInt32 := do
  let a ← IO.FS.readFile left
  let b ← IO.FS.readFile right
  let da := decodeAuto none a
  let db := decodeAuto none b
  let va := ProofObject.toVal (Convert.objectOf da)
  let vb := ProofObject.toVal (Convert.objectOf db)
  -- what a file records about where it has been is not what it says
  let strip (v : CVal) : CVal :=
    match ProofObject.ofVal v with
    | some p => ProofObject.toVal { p with provenance := {}, sourceFormat := "", sourceData := "" }
    | none => v
  let sa := strip va
  let sb := strip vb
  let v := Reconcile.verdict sa sb true true
  let ds := Reconcile.differences sa sb
  IO.println s!"left        {left} ({da.format.name})  cid {Canon.cid sa}"
  IO.println s!"right       {right} ({db.format.name})  cid {Canon.cid sb}"
  IO.println s!"verdict     {v.name}"
  if ds.isEmpty then
    IO.println "            no semantic difference (field order and numeric spelling ignored)"
  else
    IO.println s!"differences {ds.length}"
    for d in ds do IO.println (differenceLine d)
  IO.println "            nothing was merged: a difference is reported, not resolved"
  return (if ds.isEmpty then 0 else 1)

/-! ## Dispatch -/

def usage : String :=
  "cfdeploy codec — the interchange layer (docs/CODECS.md)\n\n" ++
  "  cfdeploy codec list\n" ++
  "  cfdeploy codec check   <file> [--from FORMAT]\n" ++
  "  cfdeploy codec convert <file> --to FORMAT [--from FORMAT] [--out FILE] [--at STAMP]\n" ++
  "  cfdeploy codec diff    <a> <b>\n\n" ++
  "formats: canonical, ipdl, xml, csv, yaml, text\n"

/-- The value of `--flag` in an argument list. -/
def flag (args : List String) (name : String) : Option String :=
  match args.dropWhile (· != name) with
  | _ :: v :: _ => some v
  | _ => none

def run (args : List String) : IO UInt32 := do
  match args with
  | ["list"] => cmdList; return 0
  | "check" :: path :: rest => cmdCheck path (flag rest "--from"); return 0
  | "convert" :: path :: rest =>
      match flag rest "--to" with
      | none => IO.print usage; return 1
      | some t =>
          let at' := (flag rest "--at").getD ""
          cmdConvert path (flag rest "--from") t (flag rest "--out") at'
  | "diff" :: a :: b :: _ => cmdDiff a b
  | _ => IO.print usage; return 1

end Cli
end Codec
end CfDeploy
