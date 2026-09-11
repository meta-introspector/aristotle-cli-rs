import RequestProject.Relay.Templates
import RequestProject.Relay.Seed

/-!
# Writing the relay out

`lake exe quine-relay [dir]` (default `relay/`) writes every program of
`RequestProject.Relay.Templates` and the script that runs the cycle:

```
lake exe quine-relay relay
bash relay/run.sh
```

It also writes `seed.py`, the one-stage relay of `RequestProject.Relay.Seed`:
the smallest program here that reads its own payload and reproduces itself,
and the program `bootstrap.sh` starts from.

`run.sh` runs each stage in turn, every program printing the next, and compares
what comes out with the program this file wrote.  A stage whose interpreter or
compiler is missing is skipped with a notice, so the script stays honest on a
machine with fewer toolchains.  The Lean side of the same statement — that the
cycle closes, that a stage can print itself, and that a stage can print any
other stage — is `relay_cycle`, `program_self` and `program_host`.
-/

namespace RequestProject.Relay

/-- The stages, in relay order. -/
def allStages : List Nat := List.range stages.size

/-- Write every program and the runner script into `dir`. -/
def emit (dir : String) : IO Unit := do
  IO.FS.createDirAll dir
  for i in allStages do
    IO.FS.writeFile (dir ++ "/" ++ fileName i) (program i)
  IO.FS.writeFile (dir ++ "/seed.py") seedProgram
  IO.FS.writeFile (dir ++ "/run-wasm.js") wasmHost
  IO.FS.writeFile (dir ++ "/run.sh") runScript
  IO.println s!"wrote {allStages.length} programs, seed.py and run.sh to {dir}/"
  for i in allStages do
    IO.println s!"  {fileName i}  ({(program i).length} characters)  {language i}  \
      [{project i}]  run: {command i}"

end RequestProject.Relay

/-- `lake exe quine-relay [dir]` -/
def main (args : List String) : IO Unit :=
  RequestProject.Relay.emit (args.headD "relay")
