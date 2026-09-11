import RequestProject.Gvcs.Sim.Wire

/-!
# The control extractor

`lake exe control [webdir] [robloxdir]` writes the game side of the control
interface out of the Lean development:

* `<webdir>/control.mjs` — the browser implementation of the command and
  telemetry protocol of `RequestProject/Sim/Interface.lean`;
* `<webdir>/control-vectors.json` — conformance vectors: commands and the exact
  bytes Lean's own encoder produces for them, for `tools/check_control.mjs` to
  check the JavaScript against;
* `<webdir>/mission.json` — the autopilot run of `RequestProject/Sim/Auto.lean`
  tick by tick, so a game can replay the verified mission;
* `<robloxdir>/LifeTracControl.lua` — the same protocol as a Roblox
  ModuleScript.

The defaults are `web` and `roblox`.
-/

open LifeTrac Wire

/-- Write the four files. -/
def main (args : List String) : IO Unit := do
  let webDir := args[0]? |>.getD "web"
  let robloxDir := args[1]? |>.getD "roblox"
  IO.FS.createDirAll webDir
  IO.FS.createDirAll robloxDir
  IO.FS.writeFile (webDir ++ "/control.mjs") controlJs
  IO.FS.writeFile (webDir ++ "/control-vectors.json") vectorsJson
  IO.FS.writeFile (webDir ++ "/mission.json") missionJson
  IO.FS.writeFile (robloxDir ++ "/LifeTracControl.lua") controlLua
  IO.println s!"wrote {webDir}/control.mjs, {webDir}/control-vectors.json, \
{webDir}/mission.json and {robloxDir}/LifeTracControl.lua"
