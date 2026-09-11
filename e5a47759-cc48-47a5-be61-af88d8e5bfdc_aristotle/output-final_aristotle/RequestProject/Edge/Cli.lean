/-
# `cfdeploy` — the command line tool

    lake exe cfdeploy config   [bundle.tgz] [options] [--init [FILE]] [--json]
    lake exe cfdeploy profiles
    lake exe cfdeploy version   [--json]
    lake exe cfdeploy inspect  <bundle.tgz>
    lake exe cfdeploy select   <bundle.tgz> [selection options] [--json]
    lake exe cfdeploy extract  <outdir> <bundle.tgz> [selection options]
    lake exe cfdeploy plan     <bundle.tgz> --account A --project P [options]
    lake exe cfdeploy tokens   <bundle.tgz> --account A --project P [options]
    lake exe cfdeploy emit     <outdir> <bundle.tgz> --account A --project P [options]
    lake exe cfdeploy script   <bundle.tgz> --account A --project P [options]
    lake exe cfdeploy agent    <outdir>
    lake exe cfdeploy proxy    <outdir> [--name NAME] [--host page.example.com]
    lake exe cfdeploy site     <outdir> [--host cf.example.net] [--name cfdeploy]
    lake exe cfdeploy spa      <outdir> [--host site.pages.dev]
    lake exe cfdeploy gate     <outdir> [--name NAME] [--host page.example.com]
    lake exe cfdeploy share    <bundle.tgz> --account A --project P [options]
    lake exe cfdeploy unshare  <recipe.txt>
    lake exe cfdeploy run      <bundle.tgz> --account A --project P [options]

Options:

    --account ID     Cloudflare account id (required for everything but `inspect`)
    --project NAME   Pages project / Worker script name
    --kv ID          Workers KV namespace id (Worker recipe, the default)
    --pages          use the Pages direct-upload recipe instead
    --zone ID        zone id, enables the DNS record and the cache purge
    --host NAME      hostname to attach
    --user-id ID     Cloudflare user id, used in token resource keys
    --catalog FILE   `name<TAB>id` permission-group catalog (see `docs/TOKENS.md`)
    --no-strip       keep the archive's top-level directory in served paths
    --name NAME      Worker name for `site` (default `cfdeploy`)

Selection options — what of the bundle is actually published:

    --subdir DIR     publish only this directory, served at the root
    --exclude GLOB   prune matching files (repeatable; adds to the preset)
    --include GLOB   publish only matching files (repeatable)
    --drop PATH      prune this one file (repeatable)
    --max-size N     drop files bigger than N bytes (`0` for no cap; `5M`, `800k` work)
    --no-prune       publish the bundle exactly as it is (no preset, no cap)

Configuration — where the hostname and the site directory come from:

    --config FILE    read this `cfdeploy.toml` instead of looking for one
    --no-config      ignore every configuration file
    --profile NAME   apply a named profile (`cfdeploy profiles` lists them)
    --subdir auto    publish the shallowest directory with an `index.html`

The settings are resolved in layers, later layers winning key by key:
the built-in defaults, then the `--profile` (declared in Lean with
`@[cf_site]`, see `RequestProject/Cf/Profiles.lean`, or as a
`[profiles.NAME]` section of a file), then a `cfdeploy.toml` carried
inside the bundle itself, then `./cfdeploy.toml` (or `--config FILE`),
then the command line.  `cfdeploy config` prints the result together
with the layer each key came from, and `cfdeploy config --init` writes a
commented starting file (see `docs/CONFIG.md`).

By default only the *site directory* of the bundle is published: the
shallowest directory with an `index.html` in it, found by
`CfDeploy.Config.detectSiteDir`, served at the root.  `--profile whole`
(or `--subdir ""`) publishes every directory again.  On top of that the
Lean project files, the version-control droppings, nested archives and
`wrangler` configuration are pruned, and nothing above Cloudflare's own
25 MiB per-asset limit is published
(`CfDeploy.Select.defaultSelection`).  `cfdeploy select` shows the whole
bundle with the verdict for each file, and `cfdeploy extract` writes the
published files out as a directory you can serve locally to preview.

`site` takes no bundle: it writes the tool itself as a directory you
install once — a self-contained `index.html` and the `_worker.js` that
serves it and proxies the Cloudflare API at `/cf` (see `docs/HOSTING.md`).
`spa` writes the same page with *nothing* beside it that a Cloudflare
Pages direct upload could read as a project to build: no `wrangler.toml`,
no `_worker.js`, no `package.json` — just `index.html`, `404.html`,
`_headers` and `_redirects` (see `docs/STATIC.md`).

`gate` writes the Worker that lets a page hosted anywhere deploy safely:
a CORS proxy that forwards a request only when it is signed by a client
you enrolled and stays inside that client's own account, zone and named
resources (`CfDeploy.Gate.judge`, and see `docs/GATE.md`).

`script` writes the plan as a POSIX `sh` script of `curl` calls, `agent`
writes the local API proxy that holds your key on your own machine, and
`proxy` writes a standalone CORS-proxy Worker to put in front of the
Cloudflare API — the three ways to deploy when the browser cannot reach
the API directly (see `docs/OFFLINE.md`).

`run` performs no network calls: it prints the transcript the executor
would produce, gated by which `CF_TOKEN_<role>` variables are actually set
in the environment.  The requests themselves are made by the emitted
JavaScript, the script, or the agent — which is where the credentials
live.
-/
import RequestProject.Edge.Cf.Bundle
import RequestProject.Edge.Cf.JsEmit
import RequestProject.Edge.Cf.Share
import RequestProject.Edge.Cf.Exec
import RequestProject.Edge.Cf.WasmKernel
import RequestProject.Edge.Cf.Site
import RequestProject.Edge.Cf.Select
import RequestProject.Edge.Cf.Offline
import RequestProject.Edge.Cf.Gate
import RequestProject.Edge.Cf.Profiles
import RequestProject.Edge.Codec.Cli

open CfDeploy

namespace CfDeploy.Cli

/-- Parsed command line options. -/
structure Opts where
  account : String := ""
  project : String := "site"
  kv : String := ""
  pages : Bool := false
  zone : Option String := none
  host : Option String := none
  userId : String := "USER_ID"
  catalog : Option String := none
  strip : Bool := true
  /-- Pages production branch -/
  branch : String := "main"
  /-- Worker name for the hosted tool (`cfdeploy site`) -/
  siteName : String := "cfdeploy"
  /-- publish only this directory of the bundle -/
  subdir : String := ""
  /-- extra exclude patterns, on top of the preset -/
  excludes : List String := []
  /-- an allow-list, if given -/
  includes : List String := []
  /-- files struck out by hand -/
  drops : List String := []
  /-- per-file size cap, in bytes -/
  maxBytes : Nat := Select.cloudflareMaxAsset
  /-- publish the bundle exactly as it is -/
  noPrune : Bool := false
  /-- print machine-readable JSON where a command offers it -/
  json : Bool := false
  /-- what the command line itself set, as a configuration layer -/
  flagDoc : Config.Doc := []
  /-- `--config FILE` -/
  configPath : Option String := none
  /-- `--no-config`: ignore every file -/
  noConfig : Bool := false
  /-- `--profile NAME` -/
  profile : Option String := none
  /-- every layer that went into the resolution, in order, for
  `cfdeploy config` -/
  layers : List (String × Config.Doc) := []
  /-- `cfdeploy config --init [FILE]` -/
  init : Option String := none
  deriving Inhabited

/-- `5M`, `800k`, `1234` — a byte count. -/
def parseSize (s : String) : Nat := Config.parseByteSize s

/-- Add one key to the layer the command line contributes; a repeated
list flag accumulates rather than replacing. -/
def Opts.setFlag (o : Opts) (k : String) (v : Config.Value) : Opts :=
  { o with flagDoc := o.flagDoc.filter (fun kv => kv.1 != k) ++ [(k, v)] }

/-- Append to a list-valued key of the command line's layer. -/
def Opts.addFlag (o : Opts) (k : String) (x : String) : Opts :=
  let old := (o.flagDoc.find? (fun kv => kv.1 == k)).bind (fun kv => kv.2.asList)
  o.setFlag k (.arr ((old.getD []) ++ [x]))

partial def parseOpts (args : List String) (o : Opts) : Opts :=
  match args with
  | [] => o
  | "--account" :: v :: rest => parseOpts rest (o.setFlag "site.account" (.str v))
  | "--project" :: v :: rest => parseOpts rest (o.setFlag "site.project" (.str v))
  | "--kv" :: v :: rest => parseOpts rest (o.setFlag "site.kv" (.str v))
  | "--pages" :: rest => parseOpts rest (o.setFlag "site.pages" (.bool true))
  | "--branch" :: v :: rest => parseOpts rest (o.setFlag "site.branch" (.str v))
  | "--zone" :: v :: rest => parseOpts rest (o.setFlag "site.zone" (.str v))
  | "--host" :: v :: rest => parseOpts rest (o.setFlag "site.host" (.str v))
  | "--user-id" :: v :: rest => parseOpts rest (o.setFlag "site.user_id" (.str v))
  | "--name" :: v :: rest => parseOpts rest (o.setFlag "site.worker_name" (.str v))
  | "--subdir" :: v :: rest => parseOpts rest (o.setFlag "publish.subdir" (.str v))
  | "--no-strip" :: rest => parseOpts rest (o.setFlag "publish.strip" (.bool false))
  | "--exclude" :: v :: rest => parseOpts rest (o.addFlag "publish.exclude" v)
  | "--include" :: v :: rest => parseOpts rest (o.addFlag "publish.include" v)
  | "--drop" :: v :: rest => parseOpts rest (o.addFlag "publish.drop" v)
  | "--max-size" :: v :: rest =>
      parseOpts rest (o.setFlag "publish.max_size" (.num (Config.parseByteSize v)))
  | "--no-prune" :: rest => parseOpts rest (o.setFlag "publish.no_prune" (.bool true))
  | "--catalog" :: v :: rest => parseOpts rest { o with catalog := some v }
  | "--config" :: v :: rest => parseOpts rest { o with configPath := some v }
  | "--no-config" :: rest => parseOpts rest { o with noConfig := true }
  | "--profile" :: v :: rest => parseOpts rest { o with profile := some v }
  | "--init" :: v :: rest =>
      if v.startsWith "--" then parseOpts (v :: rest) { o with init := some "cfdeploy.toml" }
      else parseOpts rest { o with init := some v }
  | ["--init"] => { o with init := some "cfdeploy.toml" }
  | "--json" :: rest => parseOpts rest { o with json := true }
  | _ :: rest => parseOpts rest o

/-- Copy a resolved configuration into the fields the commands read. -/
def Opts.withResolved (o : Opts) (r : Config.Resolved) : Opts :=
  { o with
    account := r.account, project := r.project, kv := r.kv, pages := r.pages,
    zone := r.zone?, host := r.hostname?, userId := r.userId, strip := r.strip,
    branch := r.branch,
    siteName := r.workerName, subdir := r.subdir, includes := r.includes,
    excludes := r.excludes, drops := r.drops, maxBytes := r.maxSize,
    noPrune := r.noPrune }

/-- The configuration the layers resolve to. -/
def Opts.resolved (o : Opts) : Config.Resolved := Config.resolve (o.layers.map (·.2))

def Opts.config (o : Opts) : Bundle.SiteConfig :=
  { account := o.account, project := o.project, kvNamespace := o.kv,
    branch := o.branch, zone := o.zone, hostname := o.host }

/-- What of the bundle these options publish. -/
def Opts.selection (o : Opts) : Select.Selection :=
  { subdir := if o.subdir == "auto" then "" else o.subdir
    includes := o.includes
    excludes := (if o.noPrune then [] else Select.leanPreset) ++ o.excludes
    dropPaths := o.drops
    maxBytes := if o.noPrune then 0 else o.maxBytes }

/-- The publishing workflow for a bundle under these options. -/
def workflowFor (o : Opts) (assets : List Asset) : Workflow :=
  let cfg := o.config
  let publish :=
    if o.pages then Bundle.pagesSiteWorkflow cfg assets
    else Bundle.workerSiteWorkflow cfg assets
  .seq publish (Bundle.dnsWorkflow cfg ("https://" ++ cfg.project ++ ".pages.dev"))

/-- Read a permission-group catalog: one `name<TAB>id` pair per line. -/
def readCatalog (path : String) : IO TokenSpec.GroupCatalog := do
  let text ← IO.FS.readFile path
  let lines := text.splitOn "\n"
  return lines.filterMap fun l =>
    match (l.trimAscii.toString.splitOn "\t") with
    | [name, id] => some (name.trimAscii.toString, id.trimAscii.toString)
    | _ => none

/-- Everything in the bundle, each asset with its bytes. -/
def loadPairs (path : String) (strip : Bool) : IO (List (Asset × ByteArray)) := do
  let raw ← IO.FS.readBinFile path
  match Inflate.gunzip raw with
  | none => throw (IO.userError s!"{path}: not a gzip stream, or the checksum failed")
  | some tar =>
      let entries := Tar.entries tar
      return entries.filterMap fun e =>
        let p := Bundle.servedPath strip e.path
        if p == "/" then none
        else some ({ path := p, contentType := Bundle.contentTypeOf e.path,
                     size := e.contents.size,
                     hash := Bundle.hex16 (Bundle.fnv1a64 e.contents) }, e.contents)

/-! ## Resolving the configuration

The layers, in order: the built-in defaults, the `--profile`, the
`cfdeploy.toml` the bundle carries, the one next to you (or `--config`),
and the command line. -/

/-- Read a configuration file, if it is there. -/
def readConfigFile (path : String) : IO (Option Config.Doc) := do
  if ← System.FilePath.pathExists path then
    let text ← IO.FS.readFile path
    return some (Config.parseDoc text)
  else
    return none

/-- The file name a bundle uses to configure its own deployment. -/
def bundleConfigName : String := "/cfdeploy.toml"

/-- The `cfdeploy.toml` a bundle carries at its root, if it carries
one. -/
def bundleConfigDoc (pairs : List (Asset × ByteArray)) : Option Config.Doc :=
  match pairs.find? (fun p => p.1.path == bundleConfigName) with
  | some (_, bytes) =>
      match String.fromUTF8? bytes with
      | some text => some (Config.parseDoc text)
      | none => none
  | none => none

/-- Every profile on offer: the ones declared in Lean with `@[cf_site]`,
plus the `[profiles.NAME]` sections of a file. -/
def availableProfiles (fileDoc : Option Config.Doc) : List Config.Profile :=
  (match fileDoc with | some d => Config.fileProfiles d | none => []) ++ Config.registered

/-- **Resolve the configuration** for a run, and record the layers so
`cfdeploy config` can say where each setting came from. -/
def resolveOpts (o : Opts) (bundle : Option String) : IO Opts := do
  if o.noConfig && o.configPath.isSome then
    throw (IO.userError "--no-config and --config name opposite things; use one of them")
  let fileDoc ←
    if o.noConfig then pure none
    else match o.configPath with
      | some p => do
          match ← readConfigFile p with
          | some d => pure (some (p, d))
          | none => throw (IO.userError s!"{p}: no such configuration file")
      | none => do
          match ← readConfigFile "cfdeploy.toml" with
          | some d => pure (some ("cfdeploy.toml", d))
          | none => pure none
  let pairs ← match bundle with
    | some b => loadPairs b true
    | none => pure []
  let bundleDoc := if o.noConfig then none else bundleConfigDoc pairs
  let mut layers : List (String × Config.Doc) := []
  match o.profile with
  | some name =>
      match Config.findProfile (availableProfiles (fileDoc.map (·.2))) name with
      | some p => layers := layers ++ [("profile " ++ name, p.doc)]
      | none =>
          throw (IO.userError s!"unknown profile `{name}`; available: \
{String.intercalate ", " ((availableProfiles (fileDoc.map (·.2))).map (·.name))}")
  | none => pure ()
  match bundleDoc with
  | some d => layers := layers ++ [("the bundle's cfdeploy.toml", Config.fileBase d)]
  | none => pure ()
  match fileDoc with
  | some (p, d) => layers := layers ++ [(p, Config.fileBase d)]
  | none => pure ()
  layers := layers ++ [("the command line", o.flagDoc)]
  let r := Config.resolve (layers.map (·.2))
  -- the site directory is detected in the paths the deployment will use,
  -- so `--no-strip` detects in the archive's own top-level directory
  let detectPairs ← if r.strip then pure pairs else
      match bundle with | some b => loadPairs b false | none => pure pairs
  let r := if detectPairs.isEmpty then r else r.withDetectedSubdir (detectPairs.map (·.1))
  return { o.withResolved r with layers := layers }

/-- What a bundle publishes under these options: the pruned assets with
their bytes, and the whole bundle for the report. -/
def loadSelected (path : String) (o : Opts) : IO (List (Asset × ByteArray) × List Asset) := do
  let pairs ← loadPairs path o.strip
  let all := pairs.map (·.1)
  return (Select.applyWith o.selection pairs, all)

/-- The one-line summary every command prints, so it is never a surprise
what was left out. -/
def pruningSummary (sel : Select.Selection) (all : List Asset) : String :=
  let kept := Select.apply sel all
  let dropped := all.length - kept.length
  s!"publishing {kept.length} of {all.length} file(s), \
{Select.totalBytes kept} of {Select.totalBytes all} byte(s)\
{if dropped == 0 then "" else s!"; {dropped} pruned (see `cfdeploy select`)"}"

/-! ## Commands -/

/-- Print the resolved configuration, key by key, with the layer that
set each one — or write a starting `cfdeploy.toml`. -/
def cmdConfig (bundle : Option String) (o : Opts) : IO Unit := do
  let r := o.resolved
  let r ← match bundle with
    | some b => do
        let pairs ← loadPairs b o.strip
        pure (r.withDetectedSubdir (pairs.map (·.1)))
    | none => pure r
  match o.init with
  | some file =>
      if ← System.FilePath.pathExists file then
        throw (IO.userError s!"{file} already exists; delete it, or name another file")
      IO.FS.writeFile file (Config.template r)
      IO.println s!"wrote {file}"
      IO.println "edit it, then every command reads it: the hostname, the account and"
      IO.println "the directory to publish stop being command-line arguments."
      return
  | none => pure ()
  if o.json then
    IO.println (Json.pretty 0 (Config.resolvedJson r o.layers))
    return
  IO.println "resolved configuration (later layers win):"
  for (name, d) in o.layers do
    IO.println s!"  layer {name}: {d.length} setting(s)"
  IO.println ""
  for (k, v) in r.toDoc do
    let src := (Config.provenance o.layers k).getD "built-in default"
    IO.println s!"  {k} = {Config.renderValue v}    ({src})"
  IO.println ""
  IO.println s!"origin: {r.originUrl}"
  match bundle with
  | some b => do
      let pairs ← loadPairs b o.strip
      let all := pairs.map (·.1)
      match Config.detectSiteDir all with
      | some d =>
          let shown := if d.isEmpty then "(the bundle root)" else d
          IO.println s!"site directory in {b}: {shown}  (`--subdir auto` picks it)"
      | none => IO.println s!"no index.html anywhere in {b}"
      IO.println (pruningSummary (o.withResolved r).selection all)
  | none => pure ()

/-- The build stamp of this binary's page, so what is deployed can be
compared with what was built. -/
def cmdVersion (o : Opts) : IO Unit := do
  if o.json then
    IO.println (Json.render Site.versionJson)
    return
  IO.println s!"cfdeploy build {Site.buildId}"
  IO.println s!"  page          {Site.singlePageHtml.length} chars"
  IO.println s!"  wasm kernel   {WasmKernel.kernelBytes.size} bytes"
  IO.println s!"  config keys   {String.intercalate ", " Config.knownKeys}"
  IO.println s!"  profiles      {String.intercalate ", " (Config.registered.map (·.name))}"
  IO.println ""
  IO.println "the deployed site shows the same stamp in its footer and serves it at"
  IO.println "/version.json; if they differ, re-run `cfdeploy site site` and deploy again."

/-- List the profiles `--profile` accepts. -/
def cmdProfiles (o : Opts) : IO Unit := do
  let fileDoc ←
    if o.noConfig then pure none
    else readConfigFile (o.configPath.getD "cfdeploy.toml")
  let ps := availableProfiles fileDoc
  if o.json then
    IO.println (Json.pretty 0 (.arr (ps.map fun p =>
      .obj [("name", .str p.name), ("about", .str p.about),
            ("sets", Config.docJson p.doc)])))
    return
  IO.println s!"{ps.length} profile(s); `--profile NAME` applies one:"
  for p in ps do
    IO.println s!"  {p.name} — {p.about}"
    for (k, v) in p.doc do
      IO.println s!"      {k} = {Config.renderValue v}"
  IO.println ""
  IO.println "declare your own in RequestProject/Cf/Profiles.lean with @[cf_site],"
  IO.println "or as a [profiles.NAME] section of cfdeploy.toml."

def cmdInspect (path : String) (o : Opts) : IO Unit := do
  let (sel, all) ← loadSelected path o
  let assets := sel.map (·.1)
  IO.println s!"{path}: {all.length} member(s)"
  for a in assets do
    IO.println s!"  {a.hash}  {a.size}  {a.contentType}  {a.path}"
  IO.println (pruningSummary o.selection all)

/-- Every member of the bundle, with the verdict of the selection. -/
def cmdSelect (path : String) (o : Opts) : IO Unit := do
  let pairs ← loadPairs path o.strip
  let all := pairs.map (·.1)
  let sel := o.selection
  if o.json then
    IO.println (Json.pretty 0 (.obj [("selection", sel.json),
      ("files", Select.reportJson sel all)]))
    return
  IO.println s!"{path}: {all.length} member(s)"
  if sel.subdir != "" then IO.println s!"subdirectory: {sel.subdir}"
  if !sel.includes.isEmpty then
    IO.println s!"include: {String.intercalate ", " sel.includes}"
  IO.println s!"exclude: {String.intercalate ", " sel.excludes}"
  IO.println s!"size cap: {if sel.maxBytes == 0 then "none" else toString sel.maxBytes ++ " bytes"}"
  IO.println ""
  for (a, v) in Select.report sel all do
    let mark := if v.isKeep then "publish" else "prune  "
    let where_ := if v.isKeep then Select.servedOf sel a else v.reason
    IO.println s!"  {mark}  {a.size}  {a.path}  →  {where_}"
  IO.println ""
  IO.println (pruningSummary sel all)

/-- Write the published files out as a real directory, to preview the
site locally (`python3 -m http.server -d <outdir>`). -/
def cmdExtract (outdir path : String) (o : Opts) : IO Unit := do
  let (sel, all) ← loadSelected path o
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  for (a, bytes) in sel do
    let rel := (a.path.drop 1).toString
    let file := dir / rel
    match file.parent with
    | some p => IO.FS.createDirAll p
    | none => pure ()
    IO.FS.writeBinFile file bytes
  IO.println s!"wrote {sel.length} file(s) to {outdir}/"
  IO.println (pruningSummary o.selection all)
  IO.println s!"preview it: python3 -m http.server -d {outdir} 8000"

def printPlan (w : Workflow) : IO Unit := do
  IO.println "plan:"
  for line in w.plan do
    IO.println s!"  {line}"
  IO.println ""
  IO.println "tokens (one per role, least privilege):"
  for t in w.tokens do
    let groups := t.perms.map (fun p => p.groupName ++ " on " ++
      (match p.scope with
       | .user => "user"
       | .account a => "account " ++ a
       | .zone a z => "zone " ++ z ++ " of account " ++ a))
    if groups.isEmpty then
      IO.println s!"  {t.role}: (no API token — signed by the one-project upload JWT)"
    else
      IO.println s!"  {t.role}: {String.intercalate ", " groups}"

def cmdPlan (path : String) (o : Opts) : IO Unit := do
  let (sel, all) ← loadSelected path o
  let w := workflowFor o (sel.map (·.1))
  IO.println (pruningSummary o.selection all)
  IO.println ""
  printPlan w
  IO.println ""
  IO.println "bootstrap (mints those tokens, needs only API Tokens Write on the user):"
  for line in (Bundle.bootstrapWorkflow w).plan do
    IO.println s!"  {line}"
  IO.println ""
  IO.println "teardown (revokes them again when the run finishes; `cfdeploy revoke` prints it alone):"
  for line in (Bundle.teardownWorkflow w).plan do
    IO.println s!"  {line}"

/-- The teardown of a bundle's deployment: one `DELETE /user/tokens/{id}`
per token the bootstrap minted, and then the revoking token itself.  Each
id is written as `{token:ROLE}`; the runner substitutes the id Cloudflare
returned when it minted that role's token, and refuses a step whose
reference it cannot resolve. -/
def cmdRevoke (path : String) (o : Opts) : IO Unit := do
  let (sel, _) ← loadSelected path o
  let w := workflowFor o (sel.map (·.1))
  IO.println s!"the deployment mints {w.tokens.length} scoped token(s); the teardown revokes them:"
  IO.println ""
  printPlan (Bundle.teardownWorkflow w)

def cmdTokens (path : String) (o : Opts) : IO Unit := do
  let (sel, _) ← loadSelected path o
  let w := workflowFor o (sel.map (·.1))
  let catalog ← match o.catalog with
    | some c => readCatalog c
    | none => pure []
  for t in w.tokens do
    if t.perms.isEmpty then
      pure ()
    else
      let missing := TokenSpec.unresolved catalog t
      if !missing.isEmpty then
        IO.println s!"// unresolved permission groups for {t.role}: {String.intercalate ", " missing}"
      IO.println (Json.pretty 0 (t.requestJson o.userId catalog "2030-01-01T00:00:00Z"))

def cmdShare (path : String) (o : Opts) : IO Unit := do
  let (sel, _) ← loadSelected path o
  IO.print (Share.share (workflowFor o (sel.map (·.1))))

def cmdUnshare (path : String) : IO Unit := do
  let text ← IO.FS.readFile path
  match Share.unshare text with
  | none => throw (IO.userError s!"{path}: not a shareable workflow")
  | some w => printPlan w

/-- Read several shared recipes and compose them into one workflow.  The
composite is printed as a plan with its (merged, still per-role) token
bundle, and can be written back out as a recipe of its own — composition
and sharing are closed under each other (`Share.unshare_share_seq`). -/
def cmdCompose (paths : List String) (out : Option String) : IO Unit := do
  let mut w : Workflow := .nil
  for p in paths do
    let text ← IO.FS.readFile p
    match Share.unshare text with
    | none => throw (IO.userError s!"{p}: not a shareable workflow")
    | some w' => w := .seq w w'
  IO.println s!"composed {paths.length} recipe(s): {w.actions.length} step(s), {w.tokens.length} token(s)"
  IO.println ""
  printPlan w
  match out with
  | some f => do
      IO.FS.writeFile f (Share.share w)
      IO.println ""
      IO.println s!"wrote {f}"
  | none => pure ()

def cmdRun (path : String) (o : Opts) : IO Unit := do
  let (sel, all) ← loadSelected path o
  let w := workflowFor o (sel.map (·.1))
  IO.println (pruningSummary o.selection all)
  -- the wallet: a credential for every role whose CF_TOKEN_<role> is set,
  -- carrying the grants that role's token was minted with
  let mut wallet : Wallet := []
  IO.println s!"{w.actions.length} step(s), {w.tokens.length} role(s); \
looking for one CF_TOKEN_<role> per role:"
  for t in w.tokens do
    let var := envVarOfRole t.role
    match ← IO.getEnv var with
    | some _ =>
        wallet := wallet ++ [⟨t.role, t.perms⟩]
        IO.println s!"  found   {var}  (role {t.role})"
    | none =>
        if t.perms.isEmpty then
          IO.println s!"  n/a     {var}  (role {t.role} needs no API token)"
        else
          IO.println s!"  missing {var}  (role {t.role}: \
{String.intercalate ", " (t.perms.map Perm.groupName)})"
  IO.println s!"wallet: {wallet.length} of {w.tokens.length} role token(s) present"
  IO.println ""
  let total := w.actions.length
  let mut i := 0
  let mut performed := 0
  let mut denied := 0
  for a in w.actions do
    i := i + 1
    let outcome := Exec.step wallet a
    match outcome with
    | .performed _ _ => performed := performed + 1
    | _ => denied := denied + 1
    IO.println s!"  [{i}/{total}] {Exec.auditLine a outcome} — {a.describe}"
  IO.println ""
  IO.println s!"transcript: {performed} step(s) would be performed, {denied} refused"
  if denied != 0 then
    IO.println "refused steps have no credential of their own role; mint the tokens \
with `cfdeploy tokens`,"
    IO.println "export them as CF_TOKEN_<role>, or run the emitted plan with \
`node <outdir>/run-deploy.mjs`."

/-- The plan as a shell script of `curl` calls, for when the browser
cannot reach the API. -/
def cmdScript (path : String) (o : Opts) : IO Unit := do
  let (sel, _) ← loadSelected path o
  IO.print (Offline.deployShellScript o.userId (workflowFor o (sel.map (·.1))))

/-- Write the standalone CORS proxy Worker, ready for `wrangler deploy`. -/
def cmdProxy (outdir : String) (o : Opts) : IO Unit := do
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir / "_worker.js") Offline.corsProxyWorkerJs
  IO.FS.writeFile (dir / "wrangler.toml")
    (Offline.corsProxyWranglerToml o.siteName (o.host.map (fun h => "https://" ++ h)))
  IO.FS.writeFile (dir / "README.md") (Offline.corsProxyReadme o.siteName)
  IO.println s!"wrote {outdir}/_worker.js, wrangler.toml, README.md"
  IO.println s!"deploy it: cd {outdir} && npx wrangler deploy"
  IO.println "then put the URL it prints, with /cf or /?apiurl= on the end,"
  IO.println "into the page's API base field."

/-- Write the gate: the CORS proxy that forwards only what an enrolled
client signed. -/
def cmdGate (outdir : String) (o : Opts) : IO Unit := do
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir / "_worker.js") Gate.gateWorkerJs
  IO.FS.writeFile (dir / "wrangler.toml")
    (Gate.gateWranglerToml o.siteName (o.host.map (fun h => "https://" ++ h)))
  IO.FS.writeFile (dir / "cf-gate-client.mjs") Gate.gateClientJs
  IO.FS.writeFile (dir / "README.md") (Gate.gateReadme o.siteName)
  IO.println s!"wrote {outdir}/_worker.js (the gate), wrangler.toml, cf-gate-client.mjs, README.md"
  IO.println s!"deploy it:   cd {outdir} && npx wrangler deploy"
  IO.println "enrol a client, from the page's \"Copy this client's enrolment\":"
  IO.println "             npx wrangler secret put CFDEPLOY_CLIENTS"
  IO.println "optionally let the gate hold the credential, so the browser never sees one:"
  IO.println "             npx wrangler secret put CF_API_TOKEN"
  IO.println "then put the Worker's URL in the page's API base field."

/-- Write the tool as a *static* site: one page, and nothing a Pages
direct upload could mistake for a project to build. -/
def cmdSpa (outdir : String) (o : Opts) : IO Unit := do
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir / "index.html") Site.singlePageHtml
  IO.FS.writeFile (dir / "404.html") Site.singlePageHtml
  IO.FS.writeFile (dir / "_headers") Site.headersFile
  IO.FS.writeFile (dir / "_redirects") Site.redirectsFile
  IO.FS.writeFile (dir / "README.md") (Site.spaReadmeMd o.host)
  IO.println s!"wrote {outdir}/index.html ({Site.singlePageHtml.length} chars, self-contained:"
  IO.println s!"      bundle reader, selection, preview, plan builder, token minter, deployment"
  IO.println s!"      client, gate client and the {WasmKernel.kernelBytes.size}-byte wasm kernel"
  IO.println s!"      are all inlined), 404.html, _headers, _redirects, README.md"
  IO.println "no wrangler.toml, no _worker.js, no package.json, no functions/ — nothing here"
  IO.println "is a build step, so a Pages direct upload takes it as it is."
  IO.println s!"upload it:   drag {outdir} into Pages (Direct Upload), or"
  IO.println s!"             cd {outdir} && npx wrangler pages deploy ."
  IO.println "the API is cross-origin from a static host: use the page's last panel"
  IO.println "(deploy.sh, the agent, or `cfdeploy gate`) to actually deploy."

/-- Write the local agent. -/
def cmdAgent (outdir : String) : IO Unit := do
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir / "cf-agent.mjs") Offline.agentJs
  IO.println s!"wrote {outdir}/cf-agent.mjs"
  IO.println "run it where your key already is:"
  IO.println s!"  CF_API_TOKEN=... node {outdir}/cf-agent.mjs"
  IO.println "then paste the API base it prints into the page."

def cmdEmit (outdir path : String) (o : Opts) : IO Unit := do
  let (sel, all) ← loadSelected path o
  let assets := sel.map (·.1)
  let w := workflowFor o assets
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  IO.FS.createDirAll (dir / "assets")
  IO.FS.writeFile (dir / "deploy-plan.json")
    (Json.pretty 0 (JsEmit.planJson o.userId w) ++ "\n")
  IO.FS.writeFile (dir / "manifest.json")
    (Json.pretty 0 (Bundle.manifestJson assets) ++ "\n")
  IO.FS.writeFile (dir / "selection.json")
    (Json.pretty 0 (.obj [("selection", o.selection.json),
      ("files", Select.reportJson o.selection all)]) ++ "\n")
  IO.FS.writeFile (dir / "cf-log.mjs") JsEmit.logModuleJs
  IO.FS.writeFile (dir / "cf-deploy.mjs") (JsEmit.deployClientJs o.userId w)
  IO.FS.writeFile (dir / "cf-tokens.mjs") JsEmit.tokenClientJs
  IO.FS.writeFile (dir / "run-deploy.mjs") JsEmit.nodeRunnerJs
  IO.FS.writeFile (dir / "index.html") JsEmit.uiHtml
  IO.FS.writeFile (dir / "worker.mjs") (JsEmit.workerJs assets)
  IO.FS.writeFile (dir / "recipe.txt") (Share.share w)
  IO.FS.writeFile (dir / "deploy.sh") (Offline.deployShellScript o.userId w)
  IO.FS.writeFile (dir / "cf-agent.mjs") Offline.agentJs
  IO.FS.writeBinFile (dir / "cf_deploy_kernel.wasm") WasmKernel.kernelBytes
  -- the asset bodies, content addressed, ready for the KV writes — and
  -- the serving Worker under the name `deploy.sh` looks for
  for (a, bytes) in sel do
    IO.FS.writeBinFile (dir / "assets" / a.hash) bytes
  IO.FS.writeFile (dir / "assets" / Offline.fileNameOf ("worker:" ++ o.project))
    (JsEmit.workerJs assets)
  IO.println (pruningSummary o.selection all)
  IO.println s!"wrote {outdir}/deploy-plan.json ({w.actions.length} steps)"
  IO.println s!"wrote {outdir}/cf-log.mjs, cf-deploy.mjs, cf-tokens.mjs, worker.mjs, recipe.txt"
  IO.println s!"wrote {outdir}/index.html and run-deploy.mjs (serve {outdir}/, or run"
  IO.println s!"      `node {outdir}/run-deploy.mjs --dry-run` — both log every step)"
  IO.println s!"wrote {outdir}/deploy.sh (the same plan as curl: `sh {outdir}/deploy.sh --dry-run`)"
  IO.println s!"wrote {outdir}/cf-agent.mjs (the local API proxy, for a browser blocked by CORS)"
  IO.println s!"wrote {outdir}/selection.json (what was published, and what was pruned, and why)"
  IO.println s!"wrote {outdir}/cf_deploy_kernel.wasm ({WasmKernel.kernelBytes.size} bytes)"
  IO.println s!"wrote {outdir}/assets/ ({assets.length} file(s))"

/-- Emit the tool itself as a site: one self-contained page, and the
Worker that serves it and proxies the Cloudflare API on its own origin.
Unlike `emit`, this carries no bundle and no plan — the page reads the
`.tgz` you drop on it and builds the plan in the browser, from the same
model. -/
def cmdSite (outdir : String) (o : Opts) : IO Unit := do
  let dir : System.FilePath := outdir
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir / "index.html") Site.singlePageHtml
  IO.FS.writeFile (dir / "_worker.js") Site.workerFileJs
  IO.FS.writeFile (dir / "cf-core.mjs") Site.coreModuleMjs
  IO.FS.writeFile (dir / "cf-agent.mjs") Offline.agentJs
  IO.FS.writeFile (dir / "wrangler.toml") (Site.wranglerToml o.siteName o.host)
  IO.FS.writeFile (dir / "README.md") (Site.readmeMd o.host)
  IO.println s!"wrote {outdir}/index.html ({Site.singlePageHtml.length} chars, self-contained:"
  IO.println s!"      bundle reader, selection, preview, plan builder, token minter, deployment"
  IO.println s!"      client and the {WasmKernel.kernelBytes.size}-byte wasm kernel are all inlined)"
  IO.println s!"wrote {outdir}/_worker.js (that page, plus the /cf API proxy)"
  IO.println s!"wrote {outdir}/cf-agent.mjs (the local API proxy, for a page hosted elsewhere)"
  IO.println s!"wrote {outdir}/cf-core.mjs, wrangler.toml, README.md"
  match o.host with
  | some h => IO.println s!"deploy it: cd {outdir} && npx wrangler deploy   (route: {h})"
  | none => IO.println s!"deploy it: cd {outdir} && npx wrangler deploy, or upload the directory to Pages"

def usage : String :=
  "cfdeploy — self-hosted Cloudflare deployment for Aristotle bundles\n\n" ++
  "  cfdeploy config  [bundle.tgz] [options] [--init [FILE]] [--json]\n" ++
  "  cfdeploy profiles [--json]\n" ++
  "  cfdeploy version [--json]\n" ++
  "  cfdeploy inspect <bundle.tgz>\n" ++
  "  cfdeploy select  <bundle.tgz> [--subdir D] [--exclude G] [--include G] [--max-size N] [--json]\n" ++
  "  cfdeploy extract <outdir> <bundle.tgz> [selection options]\n" ++
  "  cfdeploy plan    <bundle.tgz> --account A --project P [--kv NS] [--pages] [--zone Z --host H]\n" ++
  "  cfdeploy tokens  <bundle.tgz> --account A --project P [--catalog groups.tsv] [--user-id U]\n" ++
  "  cfdeploy revoke  <bundle.tgz> --account A --project P [...]\n" ++
  "  cfdeploy emit    <outdir> <bundle.tgz> --account A --project P [...]\n" ++
  "  cfdeploy script  <bundle.tgz> --account A --project P [...]   > deploy.sh\n" ++
  "  cfdeploy agent   <outdir>\n" ++
  "  cfdeploy proxy   <outdir> [--name NAME] [--host page.example.com]\n" ++
  "  cfdeploy gate    <outdir> [--name NAME] [--host page.example.com]\n" ++
  "  cfdeploy spa     <outdir> [--host pages.dev host]\n" ++
  "  cfdeploy site    <outdir> [--host cf.example.net] [--name cfdeploy]\n" ++
  "  cfdeploy share   <bundle.tgz> --account A --project P [...]\n" ++
  "  cfdeploy unshare <recipe.txt>\n" ++
  "  cfdeploy compose <recipe.txt>... [--out merged.txt]\n" ++
  "  cfdeploy run     <bundle.tgz> --account A --project P [...]\n" ++
  "  cfdeploy codec   list | check <file> | convert <file> --to F | diff <a> <b>\n\n" ++
  "selection: --subdir DIR|auto --exclude GLOB --include GLOB --drop PATH --max-size N --no-prune\n" ++
  "config:    --config FILE --no-config --profile NAME   (see docs/CONFIG.md)\n"

end CfDeploy.Cli

open CfDeploy.Cli in
/-- Options, with the configuration layers resolved against a bundle. -/
def optsFor (rest : List String) (bundle : Option String) : IO Opts :=
  resolveOpts (parseOpts rest {}) bundle

open CfDeploy.Cli in
def main (args : List String) : IO UInt32 := do
  match args with
  | "config" :: rest => do
      let (bundle, flags) := match rest with
        | a :: t => if a.startsWith "--" then (none, rest) else (some a, t)
        | [] => (none, rest)
      cmdConfig bundle (← optsFor flags bundle); return 0
  | "profiles" :: rest => do cmdProfiles (parseOpts rest {}); return 0
  | "version" :: rest => do cmdVersion (parseOpts rest {}); return 0
  | "inspect" :: path :: rest => do cmdInspect path (← optsFor rest (some path)); return 0
  | "select" :: path :: rest => do cmdSelect path (← optsFor rest (some path)); return 0
  | "extract" :: outdir :: path :: rest => do
      cmdExtract outdir path (← optsFor rest (some path)); return 0
  | "plan" :: path :: rest => do cmdPlan path (← optsFor rest (some path)); return 0
  | "tokens" :: path :: rest => do cmdTokens path (← optsFor rest (some path)); return 0
  | "revoke" :: path :: rest => do cmdRevoke path (← optsFor rest (some path)); return 0
  | "share" :: path :: rest => do cmdShare path (← optsFor rest (some path)); return 0
  | "unshare" :: path :: _ => cmdUnshare path; return 0
  | "compose" :: rest =>
      let out := match rest.dropWhile (· != "--out") with
        | _ :: f :: _ => some f
        | _ => none
      let files := rest.takeWhile (· != "--out")
      if files.isEmpty then
        IO.print usage; return 1
      else
        cmdCompose files out; return 0
  | "run" :: path :: rest => do cmdRun path (← optsFor rest (some path)); return 0
  | "emit" :: outdir :: path :: rest => do
      cmdEmit outdir path (← optsFor rest (some path)); return 0
  | "script" :: path :: rest => do cmdScript path (← optsFor rest (some path)); return 0
  | "agent" :: outdir :: _ => cmdAgent outdir; return 0
  | "proxy" :: outdir :: rest => do cmdProxy outdir (← optsFor rest none); return 0
  | "gate" :: outdir :: rest => do cmdGate outdir (← optsFor rest none); return 0
  | "spa" :: outdir :: rest => do cmdSpa outdir (← optsFor rest none); return 0
  | "site" :: outdir :: rest => do cmdSite outdir (← optsFor rest none); return 0
  | "codec" :: rest => CfDeploy.Codec.Cli.run rest
  | _ => IO.print usage; return 1
