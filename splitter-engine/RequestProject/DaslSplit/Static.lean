/-
DaslSplit/Static.lean — Regex-based Surface Syntax Scanner

The 10 functions from StaticSplitJSON.lean + StaticSplit.lean that provide
fast pre-scanning of .lean files without building. No kernel needed — pure string matching.

Dependencies: Lean only. No Mathlib, no DaslSplit.* imports.
-/
import Lean
open Lean System

namespace DaslSplit

/-! ## Name extraction -/

/-- Extract a clean declaration name from a line after a keyword. -/
def cleanName (s : String) : String :=
  let s := (s.splitOn "(").head?.getD s
  let s := (s.splitOn ":").head?.getD s
  s.trimAsciiStart.toString

/-- Count occurrences of a character in a string. -/
def countChar (s : String) (c : Char) : Nat :=
  s.toList.foldl (fun acc ch => if ch == c then acc + 1 else acc) 0

/-! ## Import extraction -/

/-- Extract module names from `import` lines in source. -/
def extractImports (content : String) : List String :=
  let lines := content.splitOn "\n"
  lines.filterMap fun line =>
    let t := line.trimAsciiStart.toString
    if t.startsWith "import " then
      let rest := (t.drop 7).trimAsciiStart.toString
      let mod := (rest.splitOn " ").head?.getD rest
      if mod.isEmpty then none else some mod
    else
      none

/-! ## Declaration scanning -/

/-- Find all top-level declarations in .lean source by regex keyword matching.
    Returns list of (name, kind, line_number). -/
partial def findDeclarations (content : String) : List (String × String × Nat) :=
  let lines := content.splitOn "\n"
  let keywords := [
    ("def ", "def"), ("theorem ", "theorem"), ("lemma ", "lemma"),
    ("example ", "example"), ("inductive ", "inductive"), ("structure ", "structure"),
    ("class ", "class"), ("instance ", "instance"), ("opaque ", "opaque"),
    ("axiom ", "axiom"), ("abbrev ", "abbrev"), ("noncomputable def ", "def")
  ]
  let rec go (i : Nat) (acc : List (String × String × Nat)) : List (String × String × Nat) :=
    if h : i < lines.length then
      let line := lines.get ⟨i, h⟩
      let trimmed := line.trimAsciiStart.toString
      match keywords.find? (fun (kw, _) => trimmed.startsWith kw) with
      | none => go (i+1) acc
      | some (kw, kind) =>
        let rest := (trimmed.drop kw.length).toString
        let name := cleanName ((rest.splitOn " ").head?.getD rest)
        if name.isEmpty || name.startsWith ":" then
          go (i+1) acc
        else
          go (i+1) ((name, kind, i+1) :: acc)
    else
      acc
  go 0 []

/-! ## JSON serialization -/

/-- Render a JSON array of strings. -/
def jsonArray (ss : List String) : String :=
  let items := ss.map (fun s => "\"" ++ s ++ "\"")
  "[" ++ String.intercalate "," items ++ "]"

/-- Render a single declaration as a JSON object. -/
def declJson (name : String) (kind : String) (line : Nat) (imports : List String) : String :=
  let imp := jsonArray imports
  "{\"name\":\"" ++ name ++ "\",\"kind\":\"" ++ kind ++ "\",\"line\":" ++ toString line ++ ",\"imports\":" ++ imp ++ "}"

/-! ## File processing -/

/-- Walk a directory for .lean files, skipping build dirs. -/
partial def walkLeanFiles (dir : FilePath) (acc : List FilePath) : IO (List FilePath) := do
  let mut result := acc
  if <- dir.pathExists then
    let entries <- dir.readDir
    for entry in entries do
      let path := entry.path
      let name := path.fileName.getD ""
      if name.startsWith "." || name == "build" || name == ".lake" || name == "target" then
        pure ()
      else if <- path.isDir then
        result <- walkLeanFiles path result
      else if path.extension == "lean" then
        result := path :: result
  return result

/-- Process a single .lean file, print JSON declarations. -/
def processFile (path : FilePath) : IO Nat := do
  let content <- IO.FS.readFile path
  let decls := findDeclarations content
  let imports := extractImports content
  for (name, kind, line) in decls do
    let json := declJson name kind line imports
    IO.println json
  return decls.length

/-- Generate a per-declaration flake.nix stub. -/
def emitDeclFlake (declName : String) (outDir : FilePath) : IO Unit := do
  let safeName := declName.replace "." "-"
  let declDir := outDir / safeName
  IO.FS.createDirAll declDir
  let flakeContent :=
    "{  description = \"Declaration: " ++ declName ++ "\";\n" ++
    "  inputs = {\n" ++
    "    nixpkgs.url = \"github:NixOS/nixpkgs/nixos-unstable\";\n" ++
    "    flake-utils.url = \"github:numtide/flake-utils\";\n" ++
    "    mathlib.url = \"github:leanprover-community/mathlib4/v4.28.0\";\n" ++
    "    mathlib.flake = false;\n" ++
    "  };\n" ++
    "  outputs = { self, nixpkgs, flake-utils, mathlib }:\n" ++
    "    flake-utils.lib.eachDefaultSystem (system:\n" ++
    "      let pkgs = nixpkgs.legacyPackages.${system};\n" ++
    "      in {\n" ++
    "        packages.default = pkgs.stdenv.mkDerivation {\n" ++
    "          pname = \"decl-" ++ safeName ++ "\";\n" ++
    "          version = \"0.1.0\";\n" ++
    "          src = ./.;\n" ++
    "          buildInputs = [ mathlib ];\n" ++
    "          phases = [ \"unpackPhase\" \"installPhase\" ];\n" ++
    "          installPhase = ''\n" ++
    "            mkdir -p $out\n" ++
    "            cp " ++ declName ++ ".lean $out/\n" ++
    "          '';\n" ++
    "        };\n" ++
    "      });\n" ++
    "}"
  IO.FS.writeFile (declDir / "flake.nix") flakeContent
  IO.FS.writeFile (declDir / s!"{declName}.lean") s!"-- Declaration: {declName}\n-- Extracted by DaslSplit.Static\n"

end DaslSplit
