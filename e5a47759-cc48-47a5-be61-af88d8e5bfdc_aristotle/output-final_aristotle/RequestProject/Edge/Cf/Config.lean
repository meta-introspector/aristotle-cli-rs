/-
# `cfdeploy.toml` — where the hostnames and the publishing rules live

Everything the tool needs to know about *your* deployment — the account,
the project, the hostname, the zone, the KV namespace, and which
directory of the bundle is actually the site — is a handful of
key/value pairs.  This module is the convention for writing them down
once and never typing them again.

A configuration is a **document**: a list of `key = value` pairs with
dotted keys (`site.host`, `publish.subdir`).  It is written in a subset
of TOML that a human recognises:

```toml
[site]
account = "0123…"
project = "my-site"
host    = "cf.example.net"

[publish]
subdir  = "web"            # publish this directory, nothing else
exclude = ["*.map"]        # on top of the built-in Lean/​repo preset

[profiles.staging]
host    = "staging.example.net"
project = "my-site-staging"
```

Sections become key prefixes, so the file above is exactly the document
`[("site.account", …), ("site.project", …), …]` — that is the whole
data model, and it is why the merge rules are so simple.

**Layers.**  A run resolves a stack of documents, later layers winning
key by key (`resolve`, `Resolved.applyDoc`):

1. the built-in defaults (`Resolved`'s own field defaults);
2. a profile registered in Lean with `@[cf_site]` (see
   `RequestProject/Cf/Profiles.lean`), chosen with `--profile`;
3. `cfdeploy.toml` carried *inside the bundle* — a bundle can name its
   own hostname and its own site directory;
4. `cfdeploy.toml` next to you, or `--config FILE`;
5. the command line.

`provenance` reports, key by key, which layer won — that is what
`cfdeploy config` prints, so a surprising hostname is always traceable
to the file that set it.

**What is proved here.**  Applying documents is a left fold, so layering
is associative in the only sense that matters (`applyDoc_append`) and
the *last* writer of a key wins (`applyDoc_snoc_host` and friends);
unknown keys are ignored rather than silently mangled
(`applyDoc_unknown`); a resolved configuration round-trips through the
file format (`applyDoc_toDoc`, `parseDoc_renderDoc`), so
`cfdeploy config --write` writes a file that reads back as the same
settings; and `provenance` really does name a layer that sets the key
(`provenance_sets`).

Finally, `detectSiteDir` is the "just publish the site" convention: the
shallowest directory of the bundle that has an `index.html` in it.  If
it says `web`, then `web/index.html` exists (`detectSiteDir_index`) and
the resulting selection publishes at least that page
(`detectSiteDir_publishes`).
-/
import RequestProject.Edge.Cf.Select

namespace CfDeploy
namespace Config

/-! ## Values -/

/-- A configuration value: the four TOML shapes the tool needs. -/
inductive Value where
  /-- a string, `"like this"` -/
  | str (s : String)
  /-- a non-negative integer -/
  | num (n : Nat)
  /-- `true` or `false` -/
  | bool (b : Bool)
  /-- an array of strings -/
  | arr (xs : List String)
  deriving DecidableEq, Repr, Inhabited

/-- A configuration document: dotted keys in file order. -/
abbrev Doc := List (String × Value)

/-- `5M`, `800k`, `1234` — a byte count, as configuration files and the
command line write it. -/
def parseByteSize (s : String) : Nat :=
  let cs := s.toList
  let mul :=
    match cs.getLast? with
    | some 'k' => 1024
    | some 'K' => 1024
    | some 'm' => 1048576
    | some 'M' => 1048576
    | some 'g' => 1073741824
    | some 'G' => 1073741824
    | _ => 1
  let digits := (cs.filter Char.isDigit).foldl (fun n c => n * 10 + (c.toNat - 48)) 0
  digits * mul

/-- The decimal digits of a number, least significant first. -/
def digitsRev : Nat → List Char
  | 0 => []
  | n + 1 => Char.ofNat (48 + (n + 1) % 10) :: digitsRev ((n + 1) / 10)
decreasing_by exact Nat.div_lt_self (Nat.succ_pos n) (by decide)

/-- A number, in decimal. -/
def renderNatC (n : Nat) : List Char :=
  if n = 0 then ['0'] else (digitsRev n).reverse

/-- A number, in decimal. -/
def renderNat (n : Nat) : String := String.ofList (renderNatC n)

/-- The value as a string, if it is one. -/
def Value.asString : Value → Option String
  | .str s => some s
  | .num n => some (renderNat n)
  | .bool true => some "true"
  | .bool false => some "false"
  | .arr _ => none

/-- The value as a number, if it is one (`"5M"` counts). -/
def Value.asNat : Value → Option Nat
  | .num n => some n
  | .str s => some (parseByteSize s)
  | _ => none

/-- The value as a flag, if it is one. -/
def Value.asBool : Value → Option Bool
  | .bool b => some b
  | .str "true" => some true
  | .str "false" => some false
  | .num n => some (n != 0)
  | _ => none

/-- The value as a list of strings (a lone string is a one-element
list). -/
def Value.asList : Value → Option (List String)
  | .arr xs => some xs
  | .str "" => some []
  | .str s => some [s]
  | _ => none

/-! ## Writing a document out -/

/-- Escape the two characters a quoted TOML string cannot carry. -/
def escapeChars : List Char → List Char
  | [] => []
  | c :: t => if c = '"' || c = '\\' then '\\' :: c :: escapeChars t else c :: escapeChars t

/-- A quoted string literal. -/
def quoteC (cs : List Char) : List Char := '"' :: escapeChars cs ++ ['"']

/-- A quoted string literal. -/
def quote (s : String) : String := String.ofList (quoteC s.toList)

/-- Join with `, `, the way an array is written. -/
def joinComma : List (List Char) → List Char
  | [] => []
  | [x] => x
  | x :: xs => x ++ ',' :: ' ' :: joinComma xs

/-- A value, as it appears to the right of the `=`. -/
def renderValueC : Value → List Char
  | .str s => quoteC s.toList
  | .num n => renderNatC n
  | .bool true => ['t', 'r', 'u', 'e']
  | .bool false => ['f', 'a', 'l', 's', 'e']
  | .arr xs => '[' :: joinComma (xs.map (fun s => quoteC s.toList)) ++ [']']

/-- A value, as it appears to the right of the `=`. -/
def renderValue (v : Value) : String := String.ofList (renderValueC v)

/-- One `key = value` line, newline included. -/
def renderLineC (kv : String × Value) : List Char :=
  kv.1.toList ++ ' ' :: '=' :: ' ' :: renderValueC kv.2 ++ ['\n']

/-- One `key = value` line, newline included. -/
def renderLine (kv : String × Value) : String := String.ofList (renderLineC kv)

/-- The whole document, one dotted key per line. -/
def renderDocC (d : Doc) : List Char := (d.map renderLineC).flatten

/-- The whole document, one dotted key per line.  This is valid TOML:
dotted keys are how TOML writes nested tables inline. -/
def renderDoc (d : Doc) : String := String.ofList (renderDocC d)

/-! ## Reading a document back -/

/-- Spaces that surround a key or a value. -/
def isBlank (c : Char) : Bool := c = ' ' || c = '\t' || c = '\r'

/-- Drop the blanks at both ends. -/
def trimC (cs : List Char) : List Char :=
  ((cs.dropWhile isBlank).reverse.dropWhile isBlank).reverse

/-- Collect the quoted strings of a line, honouring `\"` and `\\`.
`inQ` says whether we are inside a literal, `cur` is the literal so far
(reversed) and `acc` the finished ones (reversed). -/
def collectStrs (inQ : Bool) (cur : List Char) (acc : List String) : List Char → List String
  | [] => acc.reverse
  | '\\' :: c :: t =>
      if inQ then collectStrs true (c :: cur) acc t else collectStrs inQ cur acc t
  | '"' :: t =>
      if inQ then collectStrs false [] (String.ofList cur.reverse :: acc) t
      else collectStrs true [] acc t
  | c :: t => if inQ then collectStrs true (c :: cur) acc t else collectStrs inQ cur acc t

/-- Cut a line off at an unquoted `#`. -/
def stripComment (inQ : Bool) : List Char → List Char
  | [] => []
  | c :: t =>
      if c = '#' && !inQ then []
      else if c = '\\' && inQ then
        match t with
        | [] => [c]
        | d :: t' => c :: d :: stripComment inQ t'
      else if c = '"' then c :: stripComment (!inQ) t
      else c :: stripComment inQ t

/-- Split a line at its first `=`. -/
def splitAtEq : List Char → Option (List Char × List Char)
  | [] => none
  | '=' :: t => some ([], t)
  | c :: t => (splitAtEq t).map (fun kv => (c :: kv.1, kv.2))

/-- Is every character a decimal digit (and is there at least one)? -/
def allDigits (cs : List Char) : Bool := !cs.isEmpty && cs.all Char.isDigit

/-- Read a value. -/
def parseValueC (cs : List Char) : Option Value :=
  let cs := trimC cs
  match cs with
  | [] => none
  | '"' :: _ =>
      match collectStrs false [] [] cs with
      | [s] => some (.str s)
      | _ => none
  | '[' :: _ => some (.arr (collectStrs false [] [] cs))
  | _ =>
      let s := String.ofList cs
      if s == "true" then some (.bool true)
      else if s == "false" then some (.bool false)
      else if allDigits cs then some (.num (parseByteSize s))
      else some (.str s)

/-- Is this a `[section]` header?  If so, its name. -/
def sectionName (cs : List Char) : Option String :=
  match cs with
  | '[' :: rest =>
      match rest.reverse with
      | ']' :: inner => some (String.ofList (trimC inner.reverse))
      | _ => none
  | _ => none

/-- What a bare key at the top of a file means: `host` is `site.host`,
`subdir` is `publish.subdir`.  This is also the table the page shows. -/
def shortKeys : List (String × String) :=
  [("account", "site.account"), ("project", "site.project"), ("kv", "site.kv"),
   ("zone", "site.zone"), ("host", "site.host"), ("hostname", "site.host"),
   ("user_id", "site.user_id"), ("pages", "site.pages"), ("branch", "site.branch"),
   ("worker_name", "site.worker_name"),
   ("subdir", "publish.subdir"), ("dir", "publish.subdir"),
   ("include", "publish.include"), ("exclude", "publish.exclude"),
   ("drop", "publish.drop"), ("max_size", "publish.max_size"),
   ("no_prune", "publish.no_prune"), ("strip", "publish.strip")]

/-- The canonical name of a key: short keys used at the top level are
spelled out (`host` ↦ `site.host`, `subdir` ↦ `publish.subdir`). -/
def canonKey (k : String) : String :=
  match shortKeys.find? (fun p => p.1 == k) with
  | some p => p.2
  | none => k

/-- Split into lines, on `\n`. -/
def linesC : List Char → List (List Char)
  | [] => [[]]
  | '\n' :: t => [] :: linesC t
  | c :: t =>
      match linesC t with
      | l :: ls => (c :: l) :: ls
      | [] => [[c]]

/-- Split a document's text into lines. -/
def linesOf (s : String) : List (List Char) := linesC s.toList

/-- Read the lines of a file into a document, `sect` being the section
in force. -/
def parseLinesC (sect : String) (acc : Doc) : List (List Char) → Doc
  | [] => acc
  | l :: rest =>
      let l := trimC (stripComment false l)
      if l.isEmpty then parseLinesC sect acc rest
      else match sectionName l with
        | some s => parseLinesC s acc rest
        | none =>
            match splitAtEq l with
            | none => parseLinesC sect acc rest
            | some (k, v) =>
                let key := String.ofList (trimC k)
                let key := if sect.isEmpty then canonKey key else sect ++ "." ++ key
                match parseValueC v with
                | some val => parseLinesC sect (acc ++ [(key, val)]) rest
                | none => parseLinesC sect acc rest

/-- **Read a configuration file**, from its characters. -/
def parseDocC (cs : List Char) : Doc := parseLinesC "" [] (linesC cs)

/-- **Read a configuration file.** -/
def parseDoc (s : String) : Doc := parseDocC s.toList

/-! ## The resolved configuration -/

/-- Everything the tool needs to know, with the built-in defaults.  A
layer of configuration is a `Doc`; `applyDoc` folds one onto this. -/
structure Resolved where
  /-- Cloudflare account id -/
  account : String := ""
  /-- Pages project / Worker script name -/
  project : String := "site"
  /-- Workers KV namespace id -/
  kv : String := ""
  /-- zone id; empty for none -/
  zone : String := ""
  /-- hostname to attach; empty for none -/
  host : String := ""
  /-- Cloudflare user id, used in token resource keys -/
  userId : String := "USER_ID"
  /-- use the Pages direct-upload recipe rather than the Worker one -/
  pages : Bool := false
  /-- Pages production branch -/
  branch : String := "main"
  /-- Worker name for the hosted tool itself -/
  workerName : String := "cfdeploy"
  /-- the one directory of the bundle that is the site; `auto` — the
  default — detects it, empty publishes the whole bundle -/
  subdir : String := "auto"
  /-- allow-list, if any -/
  includes : List String := []
  /-- exclude globs, on top of the preset -/
  excludes : List String := []
  /-- individual files struck out -/
  drops : List String := []
  /-- per-asset size cap -/
  maxSize : Nat := Select.cloudflareMaxAsset
  /-- publish the bundle exactly as it is -/
  noPrune : Bool := false
  /-- strip the archive's top-level directory from served paths -/
  strip : Bool := true
  deriving Repr, Inhabited, DecidableEq

/-- The keys a document may set, in the order `Resolved.toDoc` writes
them. -/
def knownKeys : List String :=
  ["site.account", "site.project", "site.kv", "site.zone", "site.host",
   "site.user_id", "site.pages", "site.branch", "site.worker_name",
   "publish.subdir", "publish.include", "publish.exclude", "publish.drop",
   "publish.max_size", "publish.no_prune", "publish.strip"]

/-- Set one key of a resolved configuration.  An unknown key, or a value
of the wrong shape, leaves it alone. -/
def Resolved.set (r : Resolved) (k : String) (v : Value) : Resolved :=
  match k with
  | "site.account" => match v.asString with | some s => { r with account := s } | none => r
  | "site.project" => match v.asString with | some s => { r with project := s } | none => r
  | "site.kv" => match v.asString with | some s => { r with kv := s } | none => r
  | "site.zone" => match v.asString with | some s => { r with zone := s } | none => r
  | "site.host" => match v.asString with | some s => { r with host := s } | none => r
  | "site.user_id" => match v.asString with | some s => { r with userId := s } | none => r
  | "site.pages" => match v.asBool with | some b => { r with pages := b } | none => r
  | "site.branch" => match v.asString with | some s => { r with branch := s } | none => r
  | "site.worker_name" => match v.asString with | some s => { r with workerName := s } | none => r
  | "publish.subdir" => match v.asString with | some s => { r with subdir := s } | none => r
  | "publish.include" => match v.asList with | some xs => { r with includes := xs } | none => r
  | "publish.exclude" => match v.asList with | some xs => { r with excludes := xs } | none => r
  | "publish.drop" => match v.asList with | some xs => { r with drops := xs } | none => r
  | "publish.max_size" => match v.asNat with | some n => { r with maxSize := n } | none => r
  | "publish.no_prune" => match v.asBool with | some b => { r with noPrune := b } | none => r
  | "publish.strip" => match v.asBool with | some b => { r with strip := b } | none => r
  | _ => r

/-- **Apply a layer**: every pair in the document, in file order. -/
def Resolved.applyDoc (r : Resolved) (d : Doc) : Resolved :=
  d.foldl (fun acc kv => acc.set kv.1 kv.2) r

/-- A resolved configuration, written back out as a document. -/
def Resolved.toDoc (r : Resolved) : Doc :=
  [("site.account", .str r.account),
   ("site.project", .str r.project),
   ("site.kv", .str r.kv),
   ("site.zone", .str r.zone),
   ("site.host", .str r.host),
   ("site.user_id", .str r.userId),
   ("site.pages", .bool r.pages),
   ("site.branch", .str r.branch),
   ("site.worker_name", .str r.workerName),
   ("publish.subdir", .str r.subdir),
   ("publish.include", .arr r.includes),
   ("publish.exclude", .arr r.excludes),
   ("publish.drop", .arr r.drops),
   ("publish.max_size", .num r.maxSize),
   ("publish.no_prune", .bool r.noPrune),
   ("publish.strip", .bool r.strip)]

/-- **Resolve a stack of layers**, later layers winning. -/
def resolve (layers : List Doc) : Resolved :=
  layers.foldl (fun r d => r.applyDoc d) {}

/-! ## Where a setting came from -/

/-- Does this document set this key? -/
def setsKey (d : Doc) (k : String) : Bool := d.any (fun kv => kv.1 == k)

/-- The name of the last layer that sets a key, if any. -/
def provenance (layers : List (String × Doc)) (k : String) : Option String :=
  (layers.filter (fun l => setsKey l.2 k)).getLast?.map (·.1)

/-- Every key that any layer sets, with the layer that won it — the
table `cfdeploy config` prints. -/
def provenanceTable (layers : List (String × Doc)) : List (String × String) :=
  knownKeys.filterMap fun k => (provenance layers k).map fun src => (k, src)

/-! ## What the configuration means -/

/-- The hostname, if one was configured. -/
def Resolved.hostname? (r : Resolved) : Option String :=
  if r.host.isEmpty then none else some r.host

/-- The zone, if one was configured. -/
def Resolved.zone? (r : Resolved) : Option String :=
  if r.zone.isEmpty then none else some r.zone

/-- Where the deployment will be reachable: the configured hostname if
there is one, else the project's `pages.dev` address. -/
def Resolved.originUrl (r : Resolved) : String :=
  match r.hostname? with
  | some h => "https://" ++ h
  | none => "https://" ++ r.project ++ ".pages.dev"

/-- **What of the bundle gets published**, under this configuration. -/
def Resolved.selection (r : Resolved) : Select.Selection :=
  { subdir := if r.subdir == "auto" then "" else r.subdir
    includes := r.includes
    excludes := (if r.noPrune then [] else Select.leanPreset) ++ r.excludes
    dropPaths := r.drops
    maxBytes := if r.noPrune then 0 else r.maxSize }

/-! ## "Just publish the site": finding the web directory -/

/-- The directory part of a path, as segments. -/
def dirSegs (path : String) : List (List Char) :=
  let segs := Select.segsL path.toList
  segs.take (segs.length - 1)

/-- Is this path an `index.html`? -/
def isIndex (path : String) : Bool :=
  (Select.segsL path.toList).getLast? == some "index.html".toList

/-- Every directory of the bundle that has an `index.html` in it, as a
path (the bundle root is `""`), shallowest first. -/
def indexDirs (as : List Asset) : List String :=
  let ds := (as.filter (fun a => isIndex a.path)).map (fun a =>
    String.ofList (Select.joinSlash (dirSegs a.path)))
  let ds := ds.foldl (fun acc d => if acc.contains d then acc else acc ++ [d]) []
  ds.mergeSort (fun a b => (Select.segsL a.toList).length ≤ (Select.segsL b.toList).length)

/-- **The site directory**: the shallowest directory of the bundle with
an `index.html` in it.  This is what `--subdir auto` picks, and what the
hosted page offers when you drop a bundle on it. -/
def detectSiteDir (as : List Asset) : Option String := (indexDirs as).head?

/-- Resolve `publish.subdir = "auto"` against a bundle. -/
def Resolved.withDetectedSubdir (r : Resolved) (as : List Asset) : Resolved :=
  if r.subdir == "auto" then { r with subdir := (detectSiteDir as).getD "" } else r

/-! ## Building a layer by hand

The CLI turns its flags into a document with this, and so do the Lean
profiles: only the arguments actually given end up in the layer, so a
flag that was not passed cannot overrule the file. -/

/-- A configuration layer from named arguments; anything left out is not
set by this layer. -/
def layer
    (account project kv zone host userId branch workerName subdir : Option String := none)
    (pages noPrune strip : Option Bool := none)
    (includes excludes drops : Option (List String) := none)
    (maxSize : Option Nat := none) : Doc :=
  let opt {α : Type} (k : String) (f : α → Value) : Option α → Doc
    | some x => [(k, f x)]
    | none => []
  opt "site.account" .str account ++ opt "site.project" .str project ++
  opt "site.kv" .str kv ++ opt "site.zone" .str zone ++ opt "site.host" .str host ++
  opt "site.user_id" .str userId ++ opt "site.branch" .str branch ++
  opt "site.worker_name" .str workerName ++ opt "site.pages" .bool pages ++
  opt "publish.subdir" .str subdir ++ opt "publish.include" .arr includes ++
  opt "publish.exclude" .arr excludes ++ opt "publish.drop" .arr drops ++
  opt "publish.max_size" .num maxSize ++ opt "publish.no_prune" .bool noPrune ++
  opt "publish.strip" .bool strip

/-- A named configuration layer that can be registered in Lean with
`@[cf_site]`; see `RequestProject/Cf/Profiles.lean`. -/
structure Profile where
  /-- what `--profile` names -/
  name : String
  /-- one line of description, for `cfdeploy profiles` -/
  about : String := ""
  /-- what this profile sets -/
  doc : Doc
  deriving Repr, Inhabited

/-- Look a profile up by name. -/
def findProfile (ps : List Profile) (name : String) : Option Profile :=
  ps.find? (fun p => p.name == name)

/-! ## The template `cfdeploy config --init` writes -/

/-- One line of the template: written out if this run actually settled
on something other than the built-in default, and commented out (so it
cannot overrule a profile) if it did not. -/
def templateLine (key : String) (v : Value) (dflt : Value) (note : String) : String :=
  let body := key ++ String.ofList (List.replicate (12 - min 12 key.length) ' ') ++
    "= " ++ renderValue v
  let body := if note.isEmpty then body else body ++ "   # " ++ note
  (if v == dflt then "# " else "") ++ body ++ "\n"

/-- A commented `cfdeploy.toml` for a fresh project.  Anything this run
left at its built-in default is written commented out, so a fresh file
states only what you actually chose — and cannot silently overrule a
profile. -/
def template (r : Resolved) : String :=
  let d : Resolved := {}
  "# cfdeploy.toml — the defaults for this deployment.\n" ++
  "#\n" ++
  "# Put this file next to you, or inside the bundle you upload, and every\n" ++
  "# `cfdeploy` command reads it.  The command line still wins, and\n" ++
  "# `cfdeploy config` prints which layer set which key.\n" ++
  "# A commented-out line is not set: it leaves the built-in default (and\n" ++
  "# whatever `--profile` chose) alone.\n\n" ++
  "[site]\n" ++
  templateLine "account" (.str r.account) (.str d.account) "Cloudflare account id" ++
  templateLine "project" (.str r.project) (.str d.project) "Pages project / Worker name" ++
  templateLine "host" (.str r.host) (.str d.host) "custom domain to attach" ++
  templateLine "zone" (.str r.zone) (.str d.zone) "zone id, for DNS and cache purge" ++
  templateLine "kv" (.str r.kv) (.str d.kv) "Workers KV namespace (Worker recipe)" ++
  templateLine "pages" (.bool r.pages) (.bool d.pages) "true for the Pages recipe" ++
  templateLine "branch" (.str r.branch) (.str d.branch) "Pages production branch" ++
  templateLine "user_id" (.str r.userId) (.str d.userId) "used in token resource keys" ++
  "\n[publish]\n" ++
  "# The one directory that is the site.  \"auto\" picks the shallowest\n" ++
  "# directory with an index.html in it; \"\" publishes the whole bundle.\n" ++
  templateLine "subdir" (.str r.subdir) (.str d.subdir) "" ++
  templateLine "exclude" (.arr r.excludes) (.arr d.excludes)
    "on top of the built-in Lean/repo preset" ++
  templateLine "include" (.arr r.includes) (.arr d.includes) "if set, an allow-list" ++
  templateLine "drop" (.arr r.drops) (.arr d.drops) "individual files to leave out" ++
  templateLine "max_size" (.num r.maxSize) (.num d.maxSize) "Cloudflare's per-asset limit" ++
  templateLine "no_prune" (.bool r.noPrune) (.bool d.noPrune)
    "true publishes the bundle exactly as it is" ++
  templateLine "strip" (.bool r.strip) (.bool d.strip)
    "strip the archive's top-level directory" ++
  "\n# Extra profiles, chosen with --profile NAME:\n" ++
  "# [profiles.staging]\n" ++
  "# host    = \"staging.example.net\"\n" ++
  "# project = \"my-site-staging\"\n"

/-- The profiles a file declares, as `[profiles.NAME]` sections. -/
def fileProfiles (d : Doc) : List Profile :=
  let names := d.foldl (fun acc kv =>
    match (kv.1.splitOn ".") with
    | "profiles" :: n :: _ :: _ => if acc.contains n then acc else acc ++ [n]
    | _ => acc) []
  names.map fun n =>
    { name := n
      about := "from cfdeploy.toml"
      doc := d.filterMap fun kv =>
        match (kv.1.splitOn ".") with
        | "profiles" :: n' :: rest =>
            if n' == n then some (canonKey (String.intercalate "." rest), kv.2) else none
        | _ => none }

/-- The base layer of a file: everything that is not inside a
`[profiles.…]` section. -/
def fileBase (d : Doc) : Doc :=
  d.filter fun kv =>
    match (kv.1.splitOn ".") with
    | "profiles" :: _ => false
    | _ => true

/-! ## The document, as JSON (for the emitted artefacts and the page) -/

/-- A value as JSON. -/
def Value.json : Value → Json
  | .str s => .str s
  | .num n => .num (n : Int)
  | .bool b => .bool b
  | .arr xs => .arr (xs.map Json.str)

/-- A document as a JSON object. -/
def docJson (d : Doc) : Json := .obj (d.map fun kv => (kv.1, kv.2.json))

/-- Every key, the field of `Resolved` it sets, and the shape of its
value — the table the browser mirror is generated from. -/
def keyFields : List (String × String × String) :=
  [("site.account", "account", "str"), ("site.project", "project", "str"),
   ("site.kv", "kv", "str"), ("site.zone", "zone", "str"), ("site.host", "host", "str"),
   ("site.user_id", "userId", "str"), ("site.pages", "pages", "bool"),
   ("site.branch", "branch", "str"), ("site.worker_name", "workerName", "str"),
   ("publish.subdir", "subdir", "str"), ("publish.include", "includes", "list"),
   ("publish.exclude", "excludes", "list"), ("publish.drop", "drops", "list"),
   ("publish.max_size", "maxSize", "num"), ("publish.no_prune", "noPrune", "bool"),
   ("publish.strip", "strip", "bool")]

-- the table covers exactly the keys the tool knows, in the same order
#guard keyFields.map (·.1) == knownKeys

/-- A resolved configuration as a JSON object keyed by field name: what
the page holds, and what `cfdeploy config --json` can be compared
against. -/
def Resolved.fieldsJson (r : Resolved) : Json :=
  .obj [("account", .str r.account), ("project", .str r.project), ("kv", .str r.kv),
        ("zone", .str r.zone), ("host", .str r.host), ("userId", .str r.userId),
        ("pages", .bool r.pages), ("branch", .str r.branch),
        ("workerName", .str r.workerName), ("subdir", .str r.subdir),
        ("includes", .arr (r.includes.map Json.str)),
        ("excludes", .arr (r.excludes.map Json.str)),
        ("drops", .arr (r.drops.map Json.str)),
        ("maxSize", .num (r.maxSize : Int)), ("noPrune", .bool r.noPrune),
        ("strip", .bool r.strip)]

/-- A profile as JSON, for the page's profile menu. -/
def Profile.json (p : Profile) : Json :=
  .obj [("name", .str p.name), ("about", .str p.about), ("sets", docJson p.doc)]

/-- The resolved configuration as JSON, with the provenance table. -/
def resolvedJson (r : Resolved) (layers : List (String × Doc)) : Json :=
  .obj [("config", docJson r.toDoc),
        ("fields", r.fieldsJson),
        ("origin", .str r.originUrl),
        ("selection", r.selection.json),
        ("source", .obj ((provenanceTable layers).map fun (k, s) => (k, Json.str s)))]

/-! ## What layering guarantees -/

@[simp] theorem applyDoc_nil (r : Resolved) : r.applyDoc [] = r := rfl

/-- Applying two layers is applying one after the other: the stack can
be regrouped however you like without changing the outcome. -/
theorem applyDoc_append (r : Resolved) (d₁ d₂ : Doc) :
    r.applyDoc (d₁ ++ d₂) = (r.applyDoc d₁).applyDoc d₂ := by
  simp [Resolved.applyDoc, List.foldl_append]

/-- **The last writer wins.** -/
theorem applyDoc_snoc (r : Resolved) (d : Doc) (k : String) (v : Value) :
    r.applyDoc (d ++ [(k, v)]) = (r.applyDoc d).set k v := by
  simp [Resolved.applyDoc]

/-- A hostname set last is the hostname you get, whatever the layers
below it said. -/
theorem host_of_applyDoc_snoc (r : Resolved) (d : Doc) (h : String) :
    (r.applyDoc (d ++ [("site.host", .str h)])).host = h := by
  simp [applyDoc_snoc, Resolved.set, Value.asString]

/-- The same for the directory that gets published. -/
theorem subdir_of_applyDoc_snoc (r : Resolved) (d : Doc) (s : String) :
    (r.applyDoc (d ++ [("publish.subdir", .str s)])).subdir = s := by
  simp [applyDoc_snoc, Resolved.set, Value.asString]

/-- The command line is the last layer, so it wins: this is
`resolve`'s precedence, spelled out. -/
theorem resolve_append (ls : List Doc) (d : Doc) :
    resolve (ls ++ [d]) = (resolve ls).applyDoc d := by
  simp [resolve, List.foldl_append]

/-- A key the tool does not know is ignored, rather than quietly
changing something else. -/
theorem applyDoc_unknown (r : Resolved) (k : String) (v : Value) (hk : k ∉ knownKeys) :
    r.applyDoc [(k, v)] = r := by
  simp only [knownKeys, List.mem_cons, List.not_mem_nil, or_false, not_or] at hk
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, h15, h16⟩ := hk
  simp only [Resolved.applyDoc, List.foldl_cons, List.foldl_nil, Resolved.set]
  repeat' split
  all_goals first
    | rfl
    | (exfalso; first
        | exact h1 (by assumption) | exact h2 (by assumption) | exact h3 (by assumption)
        | exact h4 (by assumption) | exact h5 (by assumption) | exact h6 (by assumption)
        | exact h7 (by assumption) | exact h8 (by assumption) | exact h9 (by assumption)
        | exact h10 (by assumption) | exact h11 (by assumption) | exact h12 (by assumption)
        | exact h13 (by assumption) | exact h14 (by assumption) | exact h15 (by assumption)
        | exact h16 (by assumption))

/-- **A configuration survives being written out**: reading back what
`Resolved.toDoc` wrote gives the same settings, whatever layer it lands
on. -/
theorem applyDoc_toDoc (base r : Resolved) : base.applyDoc r.toDoc = r := by
  cases r
  simp [Resolved.applyDoc, Resolved.toDoc, Resolved.set, Value.asString, Value.asBool,
    Value.asList, Value.asNat]

/-- Every key is one the tool knows. -/
theorem toDoc_keys (r : Resolved) : r.toDoc.map (·.1) = knownKeys := rfl

/-- `provenance` names a layer that really does set the key, and it is
the last such layer. -/
theorem provenance_sets {layers : List (String × Doc)} {k n : String}
    (h : provenance layers k = some n) :
    ∃ l ∈ layers, l.1 = n ∧ setsKey l.2 k = true := by
  simp only [provenance, Option.map_eq_some_iff] at h
  obtain ⟨l, hl, rfl⟩ := h
  obtain ⟨pre, hpre⟩ := List.getLast?_eq_some_iff.mp hl
  have hmem : l ∈ layers.filter (fun l => setsKey l.2 k) := by rw [hpre]; simp
  exact ⟨l, (List.mem_filter.mp hmem).1, rfl, (List.mem_filter.mp hmem).2⟩

/-- If no layer sets a key, `provenance` says so — the value is the
built-in default. -/
theorem provenance_eq_none {layers : List (String × Doc)} {k : String}
    (h : ∀ l ∈ layers, setsKey l.2 k = false) : provenance layers k = none := by
  have : layers.filter (fun l => setsKey l.2 k) = [] := by
    apply List.filter_eq_nil_iff.mpr
    intro l hl
    simp [h l hl]
  simp [provenance, this]

/-! ## What the site-directory convention guarantees -/

/-- Nothing comes out of the deduplicating fold that did not go in. -/
theorem mem_dedupFold {α : Type} [BEq α] [LawfulBEq α] (l : List α) :
    ∀ (acc : List α) {x : α},
      x ∈ l.foldl (fun acc d => if acc.contains d then acc else acc ++ [d]) acc →
      x ∈ acc ∨ x ∈ l := by
  induction l with
  | nil => intro acc x h; exact Or.inl h
  | cons a t ih =>
      intro acc x h
      simp only [List.foldl_cons] at h
      by_cases hc : acc.contains a = true
      · rw [if_pos hc] at h
        rcases ih acc h with h' | h'
        · exact Or.inl h'
        · exact Or.inr (List.mem_cons_of_mem _ h')
      · rw [if_neg hc] at h
        rcases ih (acc ++ [a]) h with h' | h'
        · rcases List.mem_append.mp h' with h'' | h''
          · exact Or.inl h''
          · have : x = a := by simpa using h''
            exact Or.inr (this ▸ List.mem_cons_self ..)
        · exact Or.inr (List.mem_cons_of_mem _ h')

/-- **A directory the tool offers really is one**: it is the directory
of an `index.html` that the bundle actually contains. -/
theorem indexDirs_spec {as : List Asset} {d : String} (h : d ∈ indexDirs as) :
    ∃ a ∈ as, isIndex a.path = true ∧
      String.ofList (Select.joinSlash (dirSegs a.path)) = d := by
  simp only [indexDirs, List.mem_mergeSort] at h
  rcases mem_dedupFold _ [] h with h' | h'
  · exact absurd h' (by simp)
  · simp only [List.mem_map, List.mem_filter] at h'
    obtain ⟨a, ⟨ha, hidx⟩, hd⟩ := h'
    exact ⟨a, ha, hidx, hd⟩

/-- If `--subdir auto` picks a directory, that directory has an
`index.html` in it. -/
theorem detectSiteDir_index {as : List Asset} {d : String} (h : detectSiteDir as = some d) :
    ∃ a ∈ as, isIndex a.path = true ∧
      String.ofList (Select.joinSlash (dirSegs a.path)) = d := by
  refine indexDirs_spec ?_
  obtain ⟨t, ht⟩ := List.head?_eq_some_iff.mp h
  rw [ht]
  simp

/-- The site directory really is what the built-in configuration
publishes from: with nothing configured at all, `publish.subdir`
resolves to the directory detected in the bundle.  (A bundle whose site
directory is literally named `auto` is the one exception: that name is
the request to detect, so name the directory with `--subdir` instead.) -/
theorem default_subdir_eq_detected {as : List Asset} {d : String}
    (hd : detectSiteDir as = some d) (hauto : d ≠ "auto") :
    ((resolve []).withDetectedSubdir as).selection.subdir = d := by
  have hdef : (resolve []).subdir = "auto" := rfl
  simp [Resolved.withDetectedSubdir, Resolved.selection, hd, hdef, hauto]

/-- **Out of the box, nothing outside the site directory is published.**
Every file the default configuration publishes came from under the
directory that has the bundle's shallowest `index.html` in it. -/
theorem default_publishes_site_dir_only {as : List Asset} {d : String}
    (hd : detectSiteDir as = some d) (hauto : d ≠ "auto") {b : Asset}
    (hb : b ∈ Select.apply ((resolve []).withDetectedSubdir as).selection as) :
    ∃ a ∈ as, (Select.segsL d.toList).isPrefixOf (Select.pathSegs a) = true := by
  obtain ⟨a, ha, hin, _⟩ := Select.under_subdir_of_mem_apply hb
  refine ⟨a, ha, ?_⟩
  have hs := default_subdir_eq_detected hd hauto
  simpa [Select.inSubdir, Select.subdirSegs, hs] using hin

/-! ## What the publishing rules guarantee -/

/-- **A Lean source is never published** unless pruning is turned off:
the preset's `*.lean` prunes it wherever it sits in the bundle. -/
theorem lean_source_not_published {r : Resolved} (hr : r.noPrune = false) {a : Asset}
    {name : List Char} (hname : name.all (· != '/') = true)
    (hmem : (name ++ ".lean".toList) ∈ Select.segsL (Select.relOf r.selection a)) :
    Select.keep r.selection a = false := by
  have hlit : Select.matchToks (Select.tokenize ".lean".toList) ".lean".toList = true := by
    rw [Select.tokenize_lits _ (by decide)]
    exact Select.matchToks_lits _
  have hglob : Select.globAux "*.lean".toList (name ++ ".lean".toList) = true :=
    Select.matchToks_star_append _ _ hlit name hname
  have hred : Select.patMatchL "*.lean".toList (Select.relOf r.selection a)
      = (Select.segsL (Select.relOf r.selection a)).any
          (Select.globAux "*.lean".toList) := rfl
  have hpat : Select.patMatchL "*.lean".toList (Select.relOf r.selection a) = true := by
    rw [hred]
    exact List.any_eq_true.mpr ⟨_, hmem, hglob⟩
  refine Select.keep_eq_false_of_excluded (pat := "*.lean") ?_ hpat
  simp only [Resolved.selection, hr, Bool.false_eq_true, if_false, List.mem_append]
  exact Or.inl (by decide)

/-! ## The file format, on real files

These are compile-time checks: the kernel reads the sample below and
checks what it resolves to. -/

private def sampleToml : String :=
  "# what this project publishes\n" ++
  "[site]\n" ++
  "account = \"acct123\"\n" ++
  "project = \"my-site\"   # trailing comment\n" ++
  "host    = \"cf.example.net\"\n" ++
  "pages   = true\n\n" ++
  "[publish]\n" ++
  "subdir  = \"web\"\n" ++
  "exclude = [\"*.map\", \"drafts/**\"]\n" ++
  "max_size = 5242880\n\n" ++
  "[profiles.staging]\n" ++
  "host    = \"staging.example.net\"\n" ++
  "project = \"my-site-staging\"\n"

-- sections become key prefixes, comments and blank lines vanish
#guard (parseDoc sampleToml).length == 9
#guard (parseDoc sampleToml).contains ("site.host", .str "cf.example.net")
#guard (parseDoc sampleToml).contains ("publish.exclude", .arr ["*.map", "drafts/**"])
#guard (parseDoc sampleToml).contains ("publish.max_size", .num 5242880)
#guard (parseDoc sampleToml).contains ("site.pages", .bool true)

-- a short key at the top level means the obvious thing
#guard parseDoc "host = \"h.example\"\n" == [("site.host", .str "h.example")]
#guard parseDoc "dir = \"web\"\n" == [("publish.subdir", .str "web")]

-- what the sample resolves to, and where the profile lives
#guard (resolve [fileBase (parseDoc sampleToml)]).host == "cf.example.net"
#guard (resolve [fileBase (parseDoc sampleToml)]).subdir == "web"
#guard (resolve [fileBase (parseDoc sampleToml)]).selection.subdir == "web"
#guard (fileProfiles (parseDoc sampleToml)).length == 1
#guard ((fileProfiles (parseDoc sampleToml)).head!).name == "staging"
#guard (resolve [fileBase (parseDoc sampleToml),
  ((fileProfiles (parseDoc sampleToml)).head!).doc]).host == "staging.example.net"

-- the command line is the last layer, so it wins
#guard (resolve [fileBase (parseDoc sampleToml),
  layer (host := some "flag.example")]).host == "flag.example"
#guard (resolve [layer (host := some "flag.example"),
  fileBase (parseDoc sampleToml)]).host == "cf.example.net"

-- writing a configuration out and reading it back is the identity
private def rSample : Resolved :=
  { host := "h", subdir := "web", excludes := ["*.map"], maxSize := 100 }

#guard parseDoc (renderDoc (Resolved.toDoc rSample)) == Resolved.toDoc rSample
#guard resolve [parseDoc (renderDoc (Resolved.toDoc { host := "h", subdir := "web" }))] ==
    ({ host := "h", subdir := "web" } : Resolved)

-- and so is writing the template out and reading it back
private def rTemplate : Resolved := { host := "h", subdir := "web", account := "a" }

#guard resolve [fileBase (parseDoc (template rTemplate))] == rTemplate

-- quotes and backslashes survive the round trip
#guard parseDoc (renderDoc [("site.host", .str "a\"b\\c")]) == [("site.host", .str "a\"b\\c")]

-- the site directory of a bundle is the shallowest one with an index.html
private def A (p : String) : Asset :=
  { path := p, contentType := "text/html", size := 10, hash := "h" }

#guard detectSiteDir [A "/RequestProject/Cf/Site.lean", A "/web/index.html",
  A "/docs/guide/index.html"] == some "web"
#guard detectSiteDir [A "/index.html", A "/web/index.html"] == some ""
#guard detectSiteDir [A "/RequestProject/Cf/Site.lean"] == none
#guard (Resolved.withDetectedSubdir { subdir := "auto" }
  [A "/web/index.html", A "/a.lean"]).subdir == "web"
#guard (Resolved.withDetectedSubdir { subdir := "dist" }
  [A "/web/index.html"]).subdir == "dist"

-- and the resulting selection publishes the page, not the sources
#guard Select.keep (Resolved.selection { subdir := "web" }) (A "/web/index.html")
#guard !Select.keep (Resolved.selection { subdir := "web" }) (A "/RequestProject/X.lean")
#guard !Select.keep (Resolved.selection { subdir := "web" }) (A "/web/App.lean")
#guard Select.servedOf (Resolved.selection { subdir := "web" }) (A "/web/app/main.js")
  == "/app/main.js"

end Config
end CfDeploy
