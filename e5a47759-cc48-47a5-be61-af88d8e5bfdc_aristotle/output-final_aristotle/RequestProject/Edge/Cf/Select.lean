/-
# Choosing what actually gets published

An Aristotle bundle is a whole *project*: the Lean sources, `.lake`, the
manifests, the tarballs of earlier runs — and, somewhere inside it, the
handful of files that are the site.  Publishing the lot is slow, leaks
sources nobody asked to publish, and can fail outright (Cloudflare
refuses an asset above 25 MiB, and a `wrangler.toml` in a Pages upload
turns the deployment into a build).

This module is the pruning model: a `Selection` says *which* members of
the bundle are published, and `Select.apply` turns the bundle's assets
into the published ones.  Four independent knobs, in this order:

* `subdir` — publish one directory of the bundle and nothing else; the
  served paths are relative to it (`web/index.html` → `/index.html`);
* `dropPaths` — individual files struck out by hand (the checkboxes in
  the page);
* `includes` — if non-empty, an allow-list: nothing else is published;
* `excludes` — glob patterns, gitignore-flavoured: a pattern with no `/`
  matches any path *segment* (so `.lake` prunes the whole directory and
  `*.lean` every Lean source), a pattern with a `/` matches the path or
  any of its directory prefixes;
* `maxBytes` — a size cap, dropping anything bigger.

`defaultSelection` is the preset for an Aristotle bundle: the Lean
project files, the version-control and editor droppings, nested archives
and `wrangler` configuration are pruned, and the cap is Cloudflare's own
25 MiB per-asset limit.

The theorems below are what makes pruning safe to trust: publishing a
selection can only ever *remove* files (`apply_sublist`, `apply_length_le`,
`mem_apply`), everything published came out of the bundle unchanged but
for its path (`hash_of_mem_apply`), nothing published exceeds the cap
(`size_le_maxBytes_of_mem_apply`), nothing matching an exclude pattern
survives (`keep_eq_false_of_excluded`), nothing outside the chosen
subdirectory survives (`under_subdir_of_mem_apply`), and pruning an
already pruned list changes nothing (`apply_idempotent`).

All of the matching is done on `List Char`, not on `String`: that keeps
the model transparent to the kernel, so the `#guard`s at the bottom are
real compile-time checks of the preset's behaviour on real paths.
-/
import RequestProject.Edge.Cf.Action
import RequestProject.Edge.Cf.Json

namespace CfDeploy
namespace Select

/-! ## Glob matching

`*` matches anything but a `/`, `**` matches anything at all, `?` matches
one character that is not a `/`; everything else is literal. -/

/-- A pattern, read once into tokens: one literal character, `*`, `**`
or `?`. -/
inductive Tok
  /-- this character, exactly -/
  | lit (c : Char)
  /-- `*`: anything within one path segment -/
  | star
  /-- `**`: anything at all, `/` included -/
  | dstar
  /-- `?`: one character, but not `/` -/
  | any
  deriving DecidableEq, Repr, Inhabited

/-- Read a pattern into tokens. -/
def tokenize : List Char → List Tok
  | [] => []
  | '*' :: '*' :: t => .dstar :: tokenize t
  | '*' :: t => .star :: tokenize t
  | '?' :: t => .any :: tokenize t
  | c :: t => .lit c :: tokenize t

/-- Match a tokenized pattern against a path. -/
def matchToks : List Tok → List Char → Bool
  | [], s => s.isEmpty
  | .lit c :: p, d :: t => (c == d) && matchToks p t
  | .any :: p, c :: t => (c != '/') && matchToks p t
  | .star :: p, [] => matchToks p []
  | .star :: p, c :: t => matchToks p (c :: t) || ((c != '/') && matchToks (.star :: p) t)
  | .dstar :: p, [] => matchToks p []
  | .dstar :: p, c :: t => matchToks p (c :: t) || matchToks (.dstar :: p) t
  | _ :: _, [] => false
termination_by p s => p.length + s.length

/-- Glob matching, on characters. -/
def globAux (pat s : List Char) : Bool := matchToks (tokenize pat) s

/-! ## Paths, as segments -/

/-- Split on `/`, keeping empty pieces. -/
def splitSlash : List Char → List (List Char)
  | [] => [[]]
  | '/' :: t => [] :: splitSlash t
  | c :: t =>
      match splitSlash t with
      | g :: gs => (c :: g) :: gs
      | [] => [[c]]

/-- The non-empty path segments: `/a//b/` ↦ `[a, b]`. -/
def segsL (s : List Char) : List (List Char) := (splitSlash s).filter (· != [])

/-- Join segments back with `/`. -/
def joinSlash : List (List Char) → List Char
  | [] => []
  | [g] => g
  | g :: gs => g ++ '/' :: joinSlash gs

/-- Every directory prefix of a path, and the path itself:
`[a, b, c] ↦ [a, a/b, a/b/c]`. -/
def ancestorsL : List (List Char) → List (List Char)
  | [] => []
  | g :: gs => g :: (ancestorsL gs).map (fun r => g ++ '/' :: r)

/-- One pattern against one path.

A pattern with no `/` is matched against every segment of the path — so
`.lake` prunes everything under `.lake/`, and `*.lean` every Lean source
wherever it is.  A pattern with a `/` is matched against the path and
against each of its directory prefixes.  A trailing `/` means "this
directory and everything in it". -/
def patMatchL (pat rel : List Char) : Bool :=
  let pat := match pat with | '/' :: p => p | p => p
  let pat := if pat.getLast? == some '/' then pat ++ ['*', '*'] else pat
  let segs := segsL rel
  if pat.contains '/' then (ancestorsL segs).any (globAux pat)
  else segs.any (globAux pat)

/-- `patMatchL`, on strings. -/
def patMatch (pat rel : String) : Bool := patMatchL pat.toList rel.toList

/-- Does any of these patterns match? -/
def matchesAny (pats : List String) (rel : List Char) : Bool :=
  pats.any (fun p => patMatchL p.toList rel)

/-! ## The selection -/

/-- What of a bundle is published. -/
structure Selection where
  /-- publish only this directory of the bundle; `""` publishes all of it -/
  subdir : String := ""
  /-- if non-empty, an allow-list: a file is published only if it matches -/
  includes : List String := []
  /-- glob patterns that prune a file -/
  excludes : List String := []
  /-- individual paths struck out by hand -/
  dropPaths : List String := []
  /-- drop anything bigger than this many bytes; `0` is no cap -/
  maxBytes : Nat := 0
  deriving Repr, Inhabited, DecidableEq

/-- Why a file of the bundle is, or is not, published. -/
inductive Verdict
  /-- published -/
  | keep
  /-- not under the chosen subdirectory -/
  | outsideSubdir
  /-- struck out by hand -/
  | pruned
  /-- an allow-list is in force and this does not match it -/
  | notIncluded
  /-- pruned by this exclude pattern -/
  | excluded (pat : String)
  /-- bigger than the cap -/
  | tooBig (limit : Nat)
  deriving Repr, DecidableEq, Inhabited

/-- Is this file published? -/
def Verdict.isKeep : Verdict → Bool
  | .keep => true
  | _ => false

/-- A word for the log and the table. -/
def Verdict.reason : Verdict → String
  | .keep => "published"
  | .outsideSubdir => "outside the chosen subdirectory"
  | .pruned => "struck out by hand"
  | .notIncluded => "not in the include list"
  | .excluded p => "excluded by " ++ p
  | .tooBig n => "larger than the " ++ toString n ++ "-byte cap"

/-- A tag for JSON, and for the page's table. -/
def Verdict.tag : Verdict → String
  | .keep => "keep"
  | .outsideSubdir => "outside-subdir"
  | .pruned => "pruned"
  | .notIncluded => "not-included"
  | .excluded _ => "excluded"
  | .tooBig _ => "too-big"

/-- The segments of the chosen subdirectory. -/
def subdirSegs (sel : Selection) : List (List Char) := segsL sel.subdir.toList

/-- The path of an asset, as segments. -/
def pathSegs (a : Asset) : List (List Char) := segsL a.path.toList

/-- The path an asset is published at, relative to the subdirectory, as
segments. -/
def relSegs (sel : Selection) (a : Asset) : List (List Char) :=
  (pathSegs a).drop (subdirSegs sel).length

/-- The path an asset is published at, relative to the subdirectory. -/
def relOf (sel : Selection) (a : Asset) : List Char := joinSlash (relSegs sel a)

/-! ### The five tests -/

/-- Is the file under the chosen subdirectory? -/
def inSubdir (sel : Selection) (a : Asset) : Bool :=
  (subdirSegs sel).isPrefixOf (pathSegs a)

/-- Was the file struck out by hand? -/
def handDropped (sel : Selection) (a : Asset) : Bool :=
  sel.dropPaths.any (fun p => segsL p.toList == pathSegs a)

/-- Does the file pass the allow-list (vacuously, if there is none)? -/
def included (sel : Selection) (a : Asset) : Bool :=
  sel.includes.isEmpty || matchesAny sel.includes (relOf sel a)

/-- The first exclude pattern that prunes the file, if any. -/
def excludedBy (sel : Selection) (a : Asset) : Option String :=
  sel.excludes.find? (fun p => patMatchL p.toList (relOf sel a))

/-- Is the file over the size cap? -/
def overCap (sel : Selection) (a : Asset) : Bool :=
  sel.maxBytes != 0 && sel.maxBytes < a.size

/-- **The decision**, for one file of the bundle. -/
def verdict (sel : Selection) (a : Asset) : Verdict :=
  if !inSubdir sel a then .outsideSubdir
  else if handDropped sel a then .pruned
  else if !included sel a then .notIncluded
  else
    match excludedBy sel a with
    | some p => .excluded p
    | none => if overCap sel a then .tooBig sel.maxBytes else .keep

/-- Is this file of the bundle published? -/
def keep (sel : Selection) (a : Asset) : Bool := (verdict sel a).isKeep

/-- The path a published file is served at: the same path, unless a
subdirectory was chosen, in which case it is relative to it. -/
def servedOf (sel : Selection) (a : Asset) : String :=
  if (subdirSegs sel).isEmpty then a.path
  else "/" ++ String.ofList (relOf sel a)

/-- A published file, at the path it is published at. -/
def rewrite (sel : Selection) (a : Asset) : Asset := { a with path := servedOf sel a }

/-- **The pruned bundle**: what a selection actually publishes. -/
def apply (sel : Selection) (as : List Asset) : List Asset :=
  (as.filter (keep sel)).map (rewrite sel)

/-- The same, carrying each asset's payload (the file's bytes, for the
CLI and the preview) along with it. -/
def applyWith {α : Type} (sel : Selection) (xs : List (Asset × α)) : List (Asset × α) :=
  (xs.filter (fun x => keep sel x.1)).map (fun x => (rewrite sel x.1, x.2))

/-- Every file of the bundle, with its verdict — the table the page and
`cfdeploy select` show. -/
def report (sel : Selection) (as : List Asset) : List (Asset × Verdict) :=
  as.map (fun a => (a, verdict sel a))

/-- Total size of a list of assets. -/
def totalBytes (as : List Asset) : Nat := as.foldl (fun n a => n + a.size) 0

/-! ## Presets -/

/-- Cloudflare's per-asset limit, for both Pages and Workers KV. -/
def cloudflareMaxAsset : Nat := 26214400

/-- What an Aristotle bundle carries that a *site* does not want: the
Lean project and its build tree, version control and editor droppings,
nested archives, and the `wrangler` configuration whose presence turns a
Pages upload into a build. -/
def leanPreset : List String :=
  [".lake", ".git", ".github", ".vscode", ".idea",
   "*.lean", "*.olean", "*.ilean", "*.trace", "*.hash", "*.c", "*.o", "*.a",
   "lakefile.toml", "lakefile.lean", "lake-manifest.json", "lean-toolchain",
   "wrangler.toml", "wrangler.json", "wrangler.jsonc", ".dev.vars",
   "node_modules", ".DS_Store", "*.tar.gz", "*.tgz", "*.zip"]

/-- The default: the preset above, capped at Cloudflare's own limit. -/
def defaultSelection : Selection :=
  { excludes := leanPreset, maxBytes := cloudflareMaxAsset }

/-- Publish the bundle exactly as it is. -/
def everything : Selection := {}

/-! ## JSON, for the emitted artefacts and for the page -/

/-- The selection itself, as JSON. -/
def Selection.json (sel : Selection) : Json :=
  .obj [("subdir", .str sel.subdir),
        ("includes", .arr (sel.includes.map Json.str)),
        ("excludes", .arr (sel.excludes.map Json.str)),
        ("dropPaths", .arr (sel.dropPaths.map Json.str)),
        ("maxBytes", .num (sel.maxBytes : Int))]

/-- The selection report as JSON: every member of the bundle, whether it
is published, where, and if not why not. -/
def reportJson (sel : Selection) (as : List Asset) : Json :=
  .arr ((report sel as).map fun (a, v) =>
    .obj [("path", .str a.path), ("size", .num (a.size : Int)),
          ("contentType", .str a.contentType), ("hash", .str a.hash),
          ("verdict", .str v.tag), ("reason", .str v.reason),
          ("served", .str (if v.isKeep then servedOf sel a else ""))])

/-! ## What pruning is guaranteed to do -/

/-- **Inversion**: a file is published exactly when it passes all five
tests. -/
theorem keep_iff (sel : Selection) (a : Asset) :
    keep sel a = true ↔
      inSubdir sel a = true ∧ handDropped sel a = false ∧ included sel a = true ∧
        excludedBy sel a = none ∧ overCap sel a = false := by
  unfold keep verdict
  cases hi : inSubdir sel a <;> cases hd : handDropped sel a <;> cases hn : included sel a <;>
    cases he : excludedBy sel a <;> cases ho : overCap sel a <;>
      simp [Verdict.isKeep]

theorem mem_apply {sel : Selection} {as : List Asset} {b : Asset} :
    b ∈ apply sel as ↔ ∃ a ∈ as, keep sel a = true ∧ b = rewrite sel a := by
  simp only [apply, List.mem_map, List.mem_filter]
  constructor
  · rintro ⟨a, ⟨ha, hk⟩, rfl⟩; exact ⟨a, ha, hk, rfl⟩
  · rintro ⟨a, ha, hk, rfl⟩; exact ⟨a, ⟨ha, hk⟩, rfl⟩

/-- **Pruning only removes.**  Everything published is a file of the
bundle, unchanged but for the path it is served at. -/
theorem hash_of_mem_apply {sel : Selection} {as : List Asset} {b : Asset}
    (hb : b ∈ apply sel as) :
    ∃ a ∈ as, b.hash = a.hash ∧ b.size = a.size ∧ b.contentType = a.contentType := by
  obtain ⟨a, ha, _, rfl⟩ := mem_apply.mp hb
  exact ⟨a, ha, rfl, rfl, rfl⟩

theorem apply_length_le (sel : Selection) (as : List Asset) :
    (apply sel as).length ≤ as.length := by
  simpa [apply] using as.length_filter_le (keep sel)

/-- Nothing published is bigger than the cap. -/
theorem size_le_maxBytes_of_mem_apply {sel : Selection} {as : List Asset} {b : Asset}
    (hcap : sel.maxBytes ≠ 0) (hb : b ∈ apply sel as) : b.size ≤ sel.maxBytes := by
  obtain ⟨a, _, hk, rfl⟩ := mem_apply.mp hb
  have ho := ((keep_iff sel a).mp hk).2.2.2.2
  simp only [overCap, Bool.and_eq_false_iff, bne_eq_false_iff_eq, decide_eq_false_iff_not,
    Nat.not_lt] at ho
  have hs : (rewrite sel a).size = a.size := rfl
  rw [hs]
  rcases ho with h | h
  · exact absurd h hcap
  · exact h

/-- A file matching an exclude pattern is never published. -/
theorem keep_eq_false_of_excluded {sel : Selection} {a : Asset} {pat : String}
    (hmem : pat ∈ sel.excludes) (hmatch : patMatchL pat.toList (relOf sel a) = true) :
    keep sel a = false := by
  have hsome : (excludedBy sel a).isSome = true := by
    simp only [excludedBy, List.find?_isSome]
    exact ⟨pat, hmem, hmatch⟩
  cases hk : keep sel a with
  | false => rfl
  | true =>
      have := ((keep_iff sel a).mp hk).2.2.2.1
      rw [this] at hsome
      exact absurd hsome (by simp)

/-- A file struck out by hand is never published. -/
theorem keep_eq_false_of_dropped {sel : Selection} {a : Asset} {p : String}
    (hmem : p ∈ sel.dropPaths) (hp : segsL p.toList = pathSegs a) :
    keep sel a = false := by
  have hdrop : handDropped sel a = true := by
    simp only [handDropped, List.any_eq_true]
    exact ⟨p, hmem, by simp [hp]⟩
  cases hk : keep sel a with
  | false => rfl
  | true =>
      have := ((keep_iff sel a).mp hk).2.1
      rw [hdrop] at this
      exact absurd this (by simp)

/-- Everything published came from under the chosen subdirectory. -/
theorem under_subdir_of_mem_apply {sel : Selection} {as : List Asset} {b : Asset}
    (hb : b ∈ apply sel as) :
    ∃ a ∈ as, inSubdir sel a = true ∧ b = rewrite sel a := by
  obtain ⟨a, ha, hk, rfl⟩ := mem_apply.mp hb
  exact ⟨a, ha, ((keep_iff sel a).mp hk).1, rfl⟩

/-- With no subdirectory chosen, publishing does not touch the paths… -/
theorem rewrite_eq_self {sel : Selection} (h : subdirSegs sel = []) (a : Asset) :
    rewrite sel a = a := by
  simp [rewrite, servedOf, h]

theorem map_rewrite_eq_self {sel : Selection} (h : subdirSegs sel = []) :
    ∀ l : List Asset, l.map (rewrite sel) = l := by
  intro l
  induction l with
  | nil => rfl
  | cons a t ih => rw [List.map_cons, rewrite_eq_self h a, ih]

/-- …and what is published is a sublist of the bundle. -/
theorem apply_sublist {sel : Selection} (h : subdirSegs sel = []) (as : List Asset) :
    (apply sel as).Sublist as := by
  have hmap := map_rewrite_eq_self h (as.filter (keep sel))
  simp [apply, hmap, as.filter_sublist (p := keep sel)]

/-- Publishing everything publishes everything. -/
theorem apply_everything (as : List Asset) : apply everything as = as := by
  have hsub : subdirSegs everything = [] := by
    simp [subdirSegs, everything, segsL, splitSlash]
  have hk : ∀ a ∈ as, keep everything a = true := by
    intro a _
    refine (keep_iff everything a).mpr ⟨?_, ?_, ?_, ?_, ?_⟩
    · simp [inSubdir, hsub]
    · simp [handDropped, everything]
    · simp [included, everything]
    · simp [excludedBy, everything]
    · simp [overCap, everything]
  have hfilter : as.filter (keep everything) = as := List.filter_eq_self.mpr hk
  have hmap := map_rewrite_eq_self hsub as
  simp [apply, hfilter, hmap]

/-- Pruning an already pruned bundle changes nothing (when no
subdirectory is chosen, so that the paths did not move). -/
theorem apply_idempotent {sel : Selection} (h : subdirSegs sel = []) (as : List Asset) :
    apply sel (apply sel as) = apply sel as := by
  simp only [apply, map_rewrite_eq_self h, List.filter_filter, Bool.and_self]

/-- The bytes published never exceed the bytes in the bundle. -/
theorem totalBytes_apply_le (sel : Selection) (as : List Asset) :
    totalBytes (apply sel as) ≤ totalBytes as := by
  have key : ∀ (l : List Asset) (m n : Nat), m ≤ n →
      (apply sel l).foldl (fun k a => k + a.size) m ≤ l.foldl (fun k a => k + a.size) n := by
    intro l
    induction l with
    | nil => intro m n h; simpa [apply] using h
    | cons a as ih =>
        intro m n h
        by_cases hk : keep sel a = true
        · have hs : (rewrite sel a).size = a.size := rfl
          simp only [apply, List.filter_cons, hk, if_pos, List.map_cons, List.foldl_cons, hs]
          exact ih (m + a.size) (n + a.size) (Nat.add_le_add_right h _)
        · have hk' : keep sel a = false := by simpa using hk
          simp only [apply, List.filter_cons, hk', Bool.false_eq_true, if_false, List.foldl_cons]
          exact ih m (n + a.size) (Nat.le_trans h (Nat.le_add_right _ _))
  exact key as 0 0 (Nat.le_refl 0)

/-- Pruning with the payloads alongside prunes exactly the same files —
what `cfdeploy emit` writes to disk is what the model publishes. -/
theorem applyWith_fst {α : Type} (sel : Selection) (xs : List (Asset × α)) :
    (applyWith sel xs).map (·.1) = apply sel (xs.map (·.1)) := by
  induction xs with
  | nil => simp [applyWith, apply]
  | cons x xs ih =>
      by_cases hk : keep sel x.1 = true
      · simp only [applyWith, apply, List.map_cons, List.filter_cons, hk, if_pos,
          List.map_cons] at ih ⊢
        simp [ih]
      · have hk' : keep sel x.1 = false := by simpa using hk
        simp only [applyWith, apply, List.map_cons, List.filter_cons, hk',
          Bool.false_eq_true, if_false] at ih ⊢
        simp [ih]

/-! ## What `*` and `**` match

`matchToks_star_append` is the reason `*.lean` prunes every Lean source:
whatever the name in front of the extension, as long as it stays inside
one path segment, the pattern matches. -/

/-- `*` swallows anything that stays inside one path segment. -/
theorem matchToks_star_append (p : List Tok) (suf : List Char) (h : matchToks p suf = true) :
    ∀ pre : List Char, pre.all (· != '/') = true →
      matchToks (.star :: p) (pre ++ suf) = true := by
  intro pre
  induction pre with
  | nil => intro _; cases suf <;> simp [matchToks, h]
  | cons c t ih =>
      intro hall
      simp only [List.all_cons, Bool.and_eq_true] at hall
      have ht := ih hall.2
      simp only [List.cons_append, matchToks, Bool.or_eq_true]
      exact Or.inr (by simp [hall.1, ht])

/-- `**` swallows anything at all. -/
theorem matchToks_dstar_append (p : List Tok) (suf : List Char) (h : matchToks p suf = true) :
    ∀ pre : List Char, matchToks (.dstar :: p) (pre ++ suf) = true := by
  intro pre
  induction pre with
  | nil => cases suf <;> simp [matchToks, h]
  | cons c t ih =>
      simp only [List.cons_append, matchToks, Bool.or_eq_true]
      exact Or.inr ih

/-- A pattern with no wildcard in it is all literals… -/
theorem tokenize_lits : ∀ s : List Char, s.all (fun c => c != '*' && c != '?') = true →
    tokenize s = s.map Tok.lit := by
  intro s
  induction s with
  | nil => intro _; simp [tokenize]
  | cons c t ih =>
      intro h
      simp only [List.all_cons, Bool.and_eq_true, bne_iff_ne, ne_eq] at h
      obtain ⟨⟨h1, h2⟩, ht⟩ := h
      have hc : tokenize (c :: t) = Tok.lit c :: tokenize t := by
        cases t with
        | nil => simp [tokenize]
        | cons d t' => simp [tokenize, h1]
      rw [hc, ih ht, List.map_cons]

theorem matchToks_lits : ∀ s : List Char, matchToks (s.map Tok.lit) s = true := by
  intro s
  induction s with
  | nil => simp [matchToks]
  | cons c t ih => simp [matchToks, ih]

/-- …and so it matches its own text: an exact file name in the exclude
list prunes that file. -/
theorem globAux_literal (s : List Char) (h : s.all (fun c => c != '*' && c != '?') = true) :
    globAux s s = true := by
  rw [globAux, tokenize_lits s h]
  exact matchToks_lits s

/-! ## The preset, on real paths

These are compile-time checks: the model is evaluated by the kernel on
the paths an Aristotle bundle really contains. -/

private def A (p : String) (n : Nat := 10) : Asset :=
  { path := p, contentType := "text/plain", size := n, hash := "h" }

-- the pattern language
#guard patMatch "*.lean" "/RequestProject/Cf/Site.lean"
#guard !patMatch "*.lean" "/dist/kernel.olean"
#guard patMatch ".lake" "/.lake/build/lib/Foo.olean"
#guard patMatch "docs/**" "/docs/DESIGN.md"
#guard !patMatch "docs/**" "/web/docs.html"
#guard patMatch "web/" "/web/index.html"
#guard patMatch "*.tar.gz" "/x-aristotle.tar.gz"
#guard patMatch "index.html" "/web/index.html"
#guard !patMatch "index.htm" "/web/index.html"
#guard patMatch "?ndex.html" "/web/index.html"

-- the default preset prunes a Lean project and keeps a site
#guard !keep defaultSelection (A "/RequestProject/Cf/Site.lean")
#guard !keep defaultSelection (A "/lakefile.toml")
#guard !keep defaultSelection (A "/lake-manifest.json")
#guard !keep defaultSelection (A "/lean-toolchain")
#guard !keep defaultSelection (A "/.lake/build/lib/RequestProject.olean")
#guard !keep defaultSelection (A "/wrangler.toml")
#guard !keep defaultSelection (A "/aristotle.tar.gz")
#guard !keep defaultSelection (A "/big.bin" 30000000)
#guard keep defaultSelection (A "/web/index.html")
#guard keep defaultSelection (A "/dist/kernel.wasm")
#guard keep defaultSelection (A "/README.md")

-- the verdicts say why
#guard (verdict defaultSelection (A "/x.lean")).tag == "excluded"
#guard (verdict defaultSelection (A "/big.bin" 99999999)).tag == "too-big"
#guard (verdict { subdir := "web" } (A "/docs/x.md")).tag == "outside-subdir"
#guard (verdict { includes := ["*.html"] } (A "/x.css")).tag == "not-included"
#guard (verdict { dropPaths := ["/x.css"] } (A "/x.css")).tag == "pruned"

-- a subdirectory is published at the root
#guard keep { subdir := "web" } (A "/web/index.html")
#guard servedOf { subdir := "web" } (A "/web/app/main.js") == "/app/main.js"
#guard servedOf { subdir := "" } (A "/web/index.html") == "/web/index.html"
#guard (apply { subdir := "web" } [A "/web/index.html", A "/docs/x.md"]).map (·.path)
  == ["/index.html"]

-- pruning is only ever removal
#guard (apply defaultSelection [A "/a.lean", A "/index.html"]).length == 1
#guard apply everything [A "/a.lean"] == [A "/a.lean"]
#guard totalBytes [A "/a" 3, A "/b" 4] == 7

end Select
end CfDeploy
