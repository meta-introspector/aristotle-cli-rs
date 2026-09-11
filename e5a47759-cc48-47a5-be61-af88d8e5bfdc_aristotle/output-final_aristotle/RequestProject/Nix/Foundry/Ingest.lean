import RequestProject.Nix.NixWars.Frens
import RequestProject.Nix.NixWars.Sha256

/-!
# Ingesting more shards: the scan, the digest, the catalogue

The board already knows how to *play* fifteen doors. This file is the other
half: how a pile of games sitting on somebody's disk becomes shards of the
71-shard DMZ.

The model is the one the Rust tool `shard-ingest` implements (it is emitted
from this development in `RequestProject/Foundry/Emit.lean`):

* a *scan* walks a directory tree and returns one entry per file, with the
  path it was found at (`Tree.scan`). The walk visits every file exactly once
  and never invents a path: `Tree.scan_paths_nodup` over a tree whose sibling
  names are distinct;
* a file becomes a *cartridge* by content: its SHA-256 digest names it, the
  first 32 bits of that digest place it on the ring by the repository's own
  `shardOf`, and the extension picks the engine (`cartOf`). Placement is
  content-addressed, so the same game found at two paths lands on one shard
  (`cartOf_shard_congr`);
* cartridges enter a *catalogue* one at a time, keyed by digest
  (`ingestOne`). Ingestion never drops or reorders what is already there
  (`isPrefix_ingest`), never lets a digest in twice (`ingest_digests_nodup`),
  loses nothing and invents nothing (`mem_digests_ingest`), and running the
  same scan again changes nothing at all (`ingest_idem`).

The last one is what makes the tool safe to point at the same disk twice,
which is what actually happens when there are many more games at home.
-/

set_option autoImplicit false

namespace NixWars
namespace Foundry

/-! ## The scan

A directory tree, as a walk over a disk sees it. Paths are lists of
components rather than strings, because that is what makes "the walk visits
every file exactly once" a statement one can prove. -/

/-- A directory tree: a file with its bytes, or a directory with its children. -/
inductive Tree where
  /-- A file: its name in its directory, and its contents. -/
  | file (name : String) (bytes : List UInt8)
  /-- A directory: its name in its parent, and its children in scan order. -/
  | dir (name : String) (kids : List Tree)
  deriving Inhabited

/-- The name a node carries in its parent directory. -/
def Tree.name : Tree → String
  | .file n _ => n
  | .dir n _ => n

mutual
  /-- A tree is *well formed* when no directory holds two entries of the same
  name — which is what a real filesystem guarantees. -/
  def Tree.wf : Tree → Bool
    | .file _ _ => true
    | .dir _ ks => decide ((ks.map Tree.name).Nodup) && Tree.wfList ks
  /-- `Tree.wf` on every tree of a list. -/
  def Tree.wfList : List Tree → Bool
    | [] => true
    | k :: ks => Tree.wf k && Tree.wfList ks
end

/-- One file, as the walk reports it: the path from the root, and the bytes. -/
abbrev Entry := List String × List UInt8

mutual
  /-- **The walk.** One entry per file, depth first, children in order. -/
  def Tree.scan : Tree → List Entry
    | .file n b => [([n], b)]
    | .dir n ks => (Tree.scanList ks).map (fun e => (n :: e.1, e.2))
  /-- The walk over a list of trees, in order. -/
  def Tree.scanList : List Tree → List Entry
    | [] => []
    | k :: ks => Tree.scan k ++ Tree.scanList ks
end

/-- Every path the walk reports starts at the node it started from. -/
theorem Tree.scan_head (t : Tree) : ∀ e ∈ t.scan, e.1.head? = some t.name := by
  cases t with
  | file n b => intro e he; simp only [Tree.scan, List.mem_singleton] at he; simp [he, Tree.name]
  | dir n ks =>
      intro e he
      simp only [Tree.scan, List.mem_map] at he
      obtain ⟨f, _, rfl⟩ := he
      simp [Tree.name]

/-- Every path the walk over a list reports starts at one of the trees. -/
theorem Tree.scanList_head (ks : List Tree) :
    ∀ e ∈ Tree.scanList ks, ∃ k ∈ ks, e.1.head? = some k.name := by
  induction ks with
  | nil => intro e he; simp [Tree.scanList] at he
  | cons k ks ih =>
      intro e he
      simp only [Tree.scanList, List.mem_append] at he
      rcases he with h | h
      · exact ⟨k, by simp, Tree.scan_head k e h⟩
      · obtain ⟨k', hk', h'⟩ := ih e h
        exact ⟨k', by simp [hk'], h'⟩

mutual
  /-- **The walk visits every file exactly once**: on a tree whose sibling
  names are distinct, no path is reported twice. -/
  theorem Tree.scan_paths_nodup : ∀ t : Tree, t.wf = true → (t.scan.map Prod.fst).Nodup
    | .file _ _, _ => by simp [Tree.scan]
    | .dir n ks, h => by
        simp only [Tree.wf, Bool.and_eq_true, decide_eq_true_eq] at h
        have hl := Tree.scanList_paths_nodup ks h.1 h.2
        have hmap : ((Tree.scanList ks).map (fun e => n :: e.1)).Nodup := by
          have := List.Nodup.map (f := fun p : List String => n :: p)
            (by intro a b hab; simpa using hab) hl
          simpa [List.map_map, Function.comp_def] using this
        simpa [Tree.scan, List.map_map, Function.comp_def] using hmap
  /-- The list form of `Tree.scan_paths_nodup`. -/
  theorem Tree.scanList_paths_nodup : ∀ ks : List Tree, (ks.map Tree.name).Nodup →
      Tree.wfList ks = true → ((Tree.scanList ks).map Prod.fst).Nodup
    | [], _, _ => by simp [Tree.scanList]
    | k :: ks, hn, h => by
        simp only [Tree.wfList, Bool.and_eq_true] at h
        simp only [List.map_cons, List.nodup_cons, List.mem_map] at hn
        simp only [Tree.scanList, List.map_append, List.nodup_append]
        refine ⟨Tree.scan_paths_nodup k h.1,
          Tree.scanList_paths_nodup ks (by simpa [List.mem_map] using hn.2) h.2, ?_⟩
        intro p hp q hq hpq
        subst hpq
        obtain ⟨e, he, hpe⟩ := List.mem_map.1 hp
        obtain ⟨f, hf, hfe⟩ := List.mem_map.1 hq
        have h1 := Tree.scan_head k e he
        obtain ⟨k', hk', h2⟩ := Tree.scanList_head ks f hf
        rw [hpe] at h1
        rw [hfe] at h2
        have hname : k.name = k'.name := by
          rw [h1] at h2; exact Option.some.inj h2
        exact hn.1 ⟨k', hk', hname.symm⟩
end

/-! ## Cartridges

A file becomes a cartridge by its content: the digest names it, the digest
places it, the extension says what runs it. -/

/-- The value of a hexadecimal digit; anything else counts as zero. -/
def hexVal (c : Char) : Nat :=
  if '0' ≤ c && c ≤ '9' then c.toNat - 48
  else if 'a' ≤ c && c ≤ 'f' then c.toNat - 87
  else if 'A' ≤ c && c ≤ 'F' then c.toNat - 55
  else 0

/-- The first thirty-two bits of a hexadecimal digest, as a number. This is
the identifier the placement rule is applied to. -/
def digestKey (hex : String) : Nat :=
  (hex.toList.take 8).foldl (fun n c => n * 16 + hexVal c) 0

/-- The engine an extension calls for. -/
def engineOfExt (ext : String) : String :=
  if ext == "z80" || ext == "sna" || ext == "tap" || ext == "tzx" then "zx"
  else if ext == "nes" then "nes"
  else if ext == "d64" || ext == "prg" || ext == "t64" then "c64"
  else if ext == "wasm" then "wasm"
  else if ext == "z5" || ext == "z8" then "zmachine"
  else if ext == "bbs" || ext == "ans" || ext == "door" then "door"
  else if ext == "rom" || ext == "bin" then "rom"
  else "unknown"

/-- The engines the shelf knows how to run, chosen by file extension. -/
def engineOf (fileName : String) : String :=
  engineOfExt ((fileName.splitOn ".").getLastD "")

/-- The engines the shelf knows, in the order the emitted tool lists them. -/
def engines : List String := ["zx", "nes", "c64", "wasm", "zmachine", "door", "rom", "unknown"]

/-- **Every file gets an engine**, and it is one of the eight the shelf runs. -/
theorem engineOf_mem_engines (fileName : String) : engineOf fileName ∈ engines := by
  unfold engineOf engineOfExt
  split_ifs <;> simp [engines]

/-- The extensions the shelf recognises are routed as advertised. -/
theorem engineOf_known :
    engineOf "manic.z80" = "zx" ∧ engineOf "elite.nes" = "nes" ∧
    engineOf "boulder.d64" = "c64" ∧ engineOf "nixwars.wasm" = "wasm" ∧
    engineOf "zork1.z5" = "zmachine" ∧ engineOf "tradewars.door" = "door" ∧
    engineOf "kernal.rom" = "rom" ∧ engineOf "notes.txt" = "unknown" := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

/-- An ingested game: where it was found, what it is, and where it lives. -/
structure Cart where
  /-- The path the scan found it at, from the root of the shelf. -/
  path : List String
  /-- The SHA-256 digest of the file, in hexadecimal — the cartridge's name. -/
  digest : String
  /-- The size of the file in bytes. -/
  size : Nat
  /-- The engine that runs it. -/
  engine : String
  /-- The shard of the DMZ it is placed on. -/
  shard : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The digest of a file's bytes, in hexadecimal. -/
def digestOf (bytes : List UInt8) : String := Sha256.toHex (Sha256.hashBytes bytes.toArray)

/-- **Ingesting one file.** The digest names it; the digest places it. -/
def cartOf (e : Entry) : Cart :=
  let hex := digestOf e.2
  { path := e.1
    digest := hex
    size := e.2.length
    engine := engineOf (e.1.getLastD "")
    shard := shardOf (digestKey hex) }

/-- Every cartridge lands on a real shard of the DMZ. -/
theorem cartOf_shard_lt (e : Entry) : (cartOf e).shard < numShards := shardOf_lt _

/-- **Placement is content-addressed**: the same game found at two different
paths is placed on the same shard. -/
theorem cartOf_shard_congr (p q : List String) (b : List UInt8) :
    (cartOf (p, b)).shard = (cartOf (q, b)).shard := rfl

/-- …and carries the same digest. -/
theorem cartOf_digest_congr (p q : List String) (b : List UInt8) :
    (cartOf (p, b)).digest = (cartOf (q, b)).digest := rfl

/-- The shard is exactly the placement rule applied to the digest. -/
theorem cartOf_shard_eq (e : Entry) :
    (cartOf e).shard = shardOf (digestKey (cartOf e).digest) := rfl

/-! ## The catalogue

The catalogue is a list of cartridges keyed by digest: a new cartridge is
appended unless its digest is already on the shelf. -/

/-- The digests a catalogue holds. -/
def digests (cat : List Cart) : List String := cat.map Cart.digest

/-- **Ingesting one cartridge**: append it unless the shelf already has it. -/
def ingestOne (cat : List Cart) (c : Cart) : List Cart :=
  if cat.any (fun d => d.digest == c.digest) then cat else cat ++ [c]

/-- **Ingesting a scan**: one cartridge at a time, in scan order. -/
def ingest (cat : List Cart) (cs : List Cart) : List Cart := cs.foldl ingestOne cat

@[simp] theorem ingest_nil (cat : List Cart) : ingest cat [] = cat := rfl

theorem ingest_cons (cat : List Cart) (c : Cart) (cs : List Cart) :
    ingest cat (c :: cs) = ingest (ingestOne cat c) cs := rfl

/-- A digest already on the shelf makes ingestion a no-op. -/
theorem ingestOne_of_mem {cat : List Cart} {c : Cart} (h : c.digest ∈ digests cat) :
    ingestOne cat c = cat := by
  have : cat.any (fun d => d.digest == c.digest) = true := by
    obtain ⟨d, hd, hdc⟩ := List.mem_map.1 h
    exact List.any_eq_true.2 ⟨d, hd, by simp [hdc]⟩
  simp [ingestOne, this]

/-- The digests after one ingestion: the old ones, plus possibly the new one. -/
theorem digests_ingestOne (cat : List Cart) (c : Cart) :
    digests (ingestOne cat c) = digests cat ∨
      digests (ingestOne cat c) = digests cat ++ [c.digest] := by
  unfold ingestOne
  split
  · exact Or.inl rfl
  · exact Or.inr (by simp [digests])

/-- **Nothing already on the shelf is dropped or moved**: the old catalogue is
a prefix of the new one. -/
theorem isPrefix_ingestOne (cat : List Cart) (c : Cart) : cat <+: ingestOne cat c := by
  unfold ingestOne
  split
  · exact List.prefix_rfl
  · exact ⟨[c], rfl⟩

/-- The catalogue only ever grows at the end. -/
theorem isPrefix_ingest (cat : List Cart) (cs : List Cart) : cat <+: ingest cat cs := by
  induction cs generalizing cat with
  | nil => exact List.prefix_rfl
  | cons c cs ih => exact (isPrefix_ingestOne cat c).trans (ih (ingestOne cat c))

/-- **A digest enters the catalogue at most once.** -/
theorem ingestOne_digests_nodup {cat : List Cart} (h : (digests cat).Nodup) (c : Cart) :
    (digests (ingestOne cat c)).Nodup := by
  unfold ingestOne
  split
  · exact h
  · rename_i hno
    simp only [digests, List.map_append, List.map_cons, List.map_nil]
    refine List.Nodup.append h (by simp) ?_
    refine List.disjoint_left.2 ?_
    intro a ha hb
    simp only [List.mem_singleton] at hb
    subst hb
    obtain ⟨d, hd, hdc⟩ := List.mem_map.1 ha
    exact hno (List.any_eq_true.2 ⟨d, hd, by simp [hdc]⟩)

/-- **No digest is ever on the shelf twice.** -/
theorem ingest_digests_nodup {cat : List Cart} (h : (digests cat).Nodup) (cs : List Cart) :
    (digests (ingest cat cs)).Nodup := by
  induction cs generalizing cat with
  | nil => exact h
  | cons c cs ih => exact ih (ingestOne_digests_nodup h c)

/-- **Nothing is lost and nothing is invented**: the digests of the catalogue
after a scan are exactly the old ones together with the scanned ones. -/
theorem mem_digests_ingest (cat : List Cart) (cs : List Cart) (x : String) :
    x ∈ digests (ingest cat cs) ↔ x ∈ digests cat ∨ x ∈ digests cs := by
  induction cs generalizing cat with
  | nil => simp [digests]
  | cons c cs ih =>
      rw [ingest_cons, ih]
      unfold ingestOne
      split
      · rename_i hany
        have hmem : c.digest ∈ digests cat := by
          obtain ⟨d, hd, hdc⟩ := List.any_eq_true.1 hany
          exact List.mem_map.2 ⟨d, hd, by simpa using hdc⟩
        constructor
        · rintro (hx | hx)
          · exact Or.inl hx
          · exact Or.inr (by simp [digests] at hx ⊢; exact Or.inr hx)
        · rintro (hx | hx)
          · exact Or.inl hx
          · simp only [digests, List.map_cons, List.mem_cons] at hx
            rcases hx with rfl | hx
            · exact Or.inl hmem
            · exact Or.inr hx
      · constructor
        · rintro (hx | hx)
          · simp only [digests, List.map_append, List.map_cons, List.map_nil,
              List.mem_append, List.mem_singleton] at hx
            rcases hx with hx | rfl
            · exact Or.inl hx
            · exact Or.inr (by simp [digests])
          · exact Or.inr (by simp [digests] at hx ⊢; exact Or.inr hx)
        · rintro (hx | hx)
          · exact Or.inl (by simp [digests] at hx ⊢; exact Or.inl hx)
          · simp only [digests, List.map_cons, List.mem_cons] at hx
            rcases hx with rfl | hx
            · exact Or.inl (by simp [digests])
            · exact Or.inr hx

/-- Everything scanned is on the shelf afterwards. -/
theorem digests_subset_ingest (cat cs : List Cart) :
    ∀ x ∈ digests cs, x ∈ digests (ingest cat cs) :=
  fun _ hx => (mem_digests_ingest cat cs _).2 (Or.inr hx)

/-- **Pointing the tool at the same disk twice changes nothing.** -/
theorem ingest_idem (cat cs : List Cart) : ingest (ingest cat cs) cs = ingest cat cs := by
  have key : ∀ (ds : List Cart) (base : List Cart),
      (∀ x ∈ digests ds, x ∈ digests base) → ingest base ds = base := by
    intro ds
    induction ds with
    | nil => intro base _; rfl
    | cons d ds ih =>
        intro base hsub
        have hd : d.digest ∈ digests base := hsub d.digest (by simp [digests])
        rw [ingest_cons, ingestOne_of_mem hd]
        exact ih base (fun x hx => hsub x (by simp [digests] at hx ⊢; exact Or.inr hx))
  exact key cs (ingest cat cs) (digests_subset_ingest cat cs)

/-- **The whole tool, as a function**: walk a shelf, ingest what it finds. -/
def ingestTree (cat : List Cart) (t : Tree) : List Cart :=
  ingest cat (t.scan.map cartOf)

/-- Re-running the tool on an unchanged shelf changes nothing. -/
theorem ingestTree_idem (cat : List Cart) (t : Tree) :
    ingestTree (ingestTree cat t) t = ingestTree cat t :=
  ingest_idem cat _

/-- Every cartridge of a freshly built catalogue sits on a real shard. -/
theorem ingestTree_shard_lt (t : Tree) :
    ∀ c ∈ ingestTree [] t, c.shard < numShards := by
  have main : ∀ (cs : List Cart) (cat : List Cart),
      (∀ c ∈ cat, c.shard < numShards) → (∀ c ∈ cs, c.shard < numShards) →
      ∀ c ∈ ingest cat cs, c.shard < numShards := by
    intro cs
    induction cs with
    | nil => intro cat hcat _ c hc; exact hcat c hc
    | cons d ds ih =>
        intro cat hcat hds c hc
        refine ih (ingestOne cat d) ?_ (fun x hx => hds x (by simp [hx])) c hc
        intro x hx
        unfold ingestOne at hx
        split at hx
        · exact hcat x hx
        · rcases List.mem_append.1 hx with h | h
          · exact hcat x h
          · simp only [List.mem_singleton] at h
            exact h ▸ hds d (by simp)
  refine main _ [] (by simp) ?_
  intro c hc
  obtain ⟨e, _, rfl⟩ := List.mem_map.1 hc
  exact cartOf_shard_lt e

/-- The catalogue holds no digest twice, however the shelf is arranged. -/
theorem ingestTree_nodup (t : Tree) : (digests (ingestTree [] t)).Nodup :=
  ingest_digests_nodup (by simp [digests]) _

/-! ## A shelf, ingested

A small worked example: the shelf as the tool sees it, with one game filed
twice under two names — which the catalogue notices. -/

/-- Three games and a duplicate, on a shelf. -/
def exampleShelf : Tree :=
  .dir "games"
    [ .dir "spectrum"
        [ .file "manic.z80" [0x4d, 0x41, 0x4e, 0x49, 0x43],
          .file "jetset.z80" [0x4a, 0x53, 0x57] ],
      .dir "nes" [ .file "elite.nes" [0x45, 0x4c, 0x49, 0x54, 0x45] ],
      .dir "backup" [ .file "manic-copy.z80" [0x4d, 0x41, 0x4e, 0x49, 0x43] ] ]

/-- The example shelf is a real filesystem: no directory holds a name twice. -/
theorem exampleShelf_wf : exampleShelf.wf = true := by decide

/-- The walk finds four files. -/
theorem exampleShelf_scan_length : exampleShelf.scan.length = 4 := by decide

/-- No path is reported twice. -/
theorem exampleShelf_paths_nodup : (exampleShelf.scan.map Prod.fst).Nodup :=
  Tree.scan_paths_nodup _ exampleShelf_wf

/-- The catalogue of the example shelf. -/
def exampleCatalog : List Cart := ingestTree [] exampleShelf

/-- **The duplicate is caught**: four files, three cartridges. -/
theorem exampleCatalog_length : exampleCatalog.length = 3 := by native_decide

/-- The three cartridges are the three distinct games, with their engines. -/
theorem exampleCatalog_engines : exampleCatalog.map Cart.engine = ["zx", "zx", "nes"] := by
  native_decide

/-- The copy of `manic.z80` in `backup/` would have been placed on the same
shard as the original, because the shard comes from the content. -/
theorem exampleCatalog_dedup_shard :
    (cartOf (["games", "backup", "manic-copy.z80"], [0x4d, 0x41, 0x4e, 0x49, 0x43])).shard =
      (cartOf (["games", "spectrum", "manic.z80"], [0x4d, 0x41, 0x4e, 0x49, 0x43])).shard := rfl

end Foundry
end NixWars
