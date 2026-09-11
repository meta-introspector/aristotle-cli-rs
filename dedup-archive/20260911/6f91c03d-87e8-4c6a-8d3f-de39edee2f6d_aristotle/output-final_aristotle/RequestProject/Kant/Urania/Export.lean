/-
# Urania §3.1 / §8 — the static exporter, generalised past map tiles

`Kant.MapView` already exports a static site with the properties an
archive snapshot needs: no broken links, everything within a bounded
number of clicks, distinct filenames, honest counts.  §8 asks for that
machinery with the *grouping key* made a parameter — a snapshot clusters
by topic, by chain range, by whatever the archiver chooses, not by map
tile.

§8 is also careful about how far the generalisation goes, and this module
follows it exactly:

* the **counting/partition argument is generic**.  It needs nothing of
  the key but decidable equality, and transfers unchanged: the groups
  partition the items, so the counts printed on the index are honest;
* the **filename argument is not generic**.  `Kant.MapView.path_injective`
  rests on quadkeys being injective on in-range tiles.  Here that becomes
  an explicit obligation — `NamingScheme` bundles the naming function
  with the injectivity proof, which must be discharged for each new key
  type.  `slugNaming` below discharges it for one concrete choice.

Proved here:

* `groups_perm` — the groups partition the items;
* `groups_length` — so the counts add up: an index page cannot claim more
  or fewer items than the site holds;
* `groups_key`, `mem_groupAt_iff` — every item in a group really has that
  group's key;
* `links_resolve` — no link in the exported folder is broken;
* `item_reachable` — every item is two clicks from the index;
* `path_injective` — distinct pages are distinct files, *given* a naming
  scheme; and `slugNaming` for an actual key type.
-/
import Mathlib
import RequestProject.Kant.Bytes

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania.Export

open Kant

variable {K V : Type} [DecidableEq K]

/-! ## Grouping -/

/-- The keys present, once each, in order of first appearance. -/
def groupKeys (key : V → K) (vs : List V) : List K := (vs.map key).dedup

/-- The items under one key. -/
def groupAt (key : V → K) (vs : List V) (k : K) : List V := vs.filter (fun v => key v = k)

/-- The site's groups: one entry per key, with its items. -/
def groups (key : V → K) (vs : List V) : List (K × List V) :=
  (groupKeys key vs).map (fun k => (k, groupAt key vs k))

theorem mem_groupAt_iff {key : V → K} {vs : List V} {k : K} {v : V} :
    v ∈ groupAt key vs k ↔ v ∈ vs ∧ key v = k := by
  simp [groupAt, List.mem_filter]

theorem mem_groupKeys_of_mem {key : V → K} {vs : List V} {v : V} (h : v ∈ vs) :
    key v ∈ groupKeys key vs := by
  simp [groupKeys, List.mem_dedup, List.mem_map]
  exact ⟨v, h, rfl⟩

theorem groupKeys_nodup (key : V → K) (vs : List V) : (groupKeys key vs).Nodup :=
  List.nodup_dedup _

/-- A sum over a nodup key list where only one key contributes. -/
theorem sum_map_eq_single {β : Type} [DecidableEq β] (g : β → Nat) (k₀ : β) :
    ∀ (ks : List β), ks.Nodup → (∀ k, k ≠ k₀ → g k = 0) →
      (ks.map g).sum = if k₀ ∈ ks then g k₀ else 0 := by
  intro ks
  induction ks with
  | nil => intro _ _; simp
  | cons k t ih =>
    intro hnd h0
    have hnd' : t.Nodup := (List.nodup_cons.1 hnd).2
    have hk : k ∉ t := (List.nodup_cons.1 hnd).1
    by_cases hkk : k = k₀
    · subst hkk
      simp [ih hnd' h0, hk]
    · simp [h0 k hkk, ih hnd' h0, Ne.symm hkk]

/-- **The groups partition the items.**  This is the argument §8 calls
generic: it needs nothing of the key but decidable equality. -/
theorem groups_perm [DecidableEq V] (key : V → K) (vs : List V) :
    ((groups key vs).flatMap Prod.snd).Perm vs := by
  rw [List.perm_iff_count]
  intro a
  have hmap : (groups key vs).flatMap Prod.snd
      = (groupKeys key vs).flatMap (fun k => groupAt key vs k) := by
    simp [groups, List.flatMap_map]
  rw [hmap, List.count_flatMap]
  have hg : ∀ k : K, k ≠ key a →
      (List.count a ∘ fun k => groupAt key vs k) k = 0 := by
    intro k hk
    simp only [Function.comp_apply]
    refine List.count_eq_zero.2 ?_
    intro hmem
    exact hk ((mem_groupAt_iff.1 hmem).2).symm
  rw [show (List.map (List.count a ∘ fun k => groupAt key vs k) (groupKeys key vs)).sum
      = if key a ∈ groupKeys key vs then (List.count a ∘ fun k => groupAt key vs k)
          (key a) else 0 from
    sum_map_eq_single _ _ _ (groupKeys_nodup key vs) hg]
  by_cases hin : key a ∈ groupKeys key vs
  · rw [if_pos hin]
    simp only [Function.comp_apply, groupAt]
    exact List.count_filter (by simp)
  · rw [if_neg hin]
    refine (List.count_eq_zero.2 ?_).symm
    intro hmem
    exact hin (mem_groupKeys_of_mem hmem)

/-- **The counts shown are honest**: the group sizes add up to the number
of items. -/
theorem groups_length [DecidableEq V] (key : V → K) (vs : List V) :
    ((groups key vs).map (fun g => g.2.length)).sum = vs.length := by
  have h := (groups_perm key vs).length_eq
  rw [List.length_flatMap] at h
  simpa using h

/-! ## The exported site -/

/-- A page of an exported snapshot. -/
inductive Page (K : Type) where
  /-- The index. -/
  | index
  /-- One group. -/
  | group (k : K)
  /-- One item, named by its content address. -/
  | item (w : List Char)
deriving DecidableEq, Repr

/-- A naming scheme for a key type: how a group is turned into a file
name, and the proof that distinct keys give distinct names.

This is §8's explicit obligation.  It does **not** come for free with the
counting argument: it has to be discharged for every key type. -/
structure NamingScheme (K : Type) where
  /-- The file-name stem for a key. -/
  name : K → List Char
  /-- Distinct keys, distinct names. -/
  name_inj : Function.Injective name
  /-- Names carry no path separator and no dot, so a stem can neither
  escape its folder nor run into the extension. -/
  name_plain : ∀ k, '/' ∉ name k ∧ '.' ∉ name k

/-- Where a page is written. -/
def Page.path (N : NamingScheme K) : Page K → List Char
  | .index => "index.html".toList
  | .group k => "group/".toList ++ N.name k ++ ".html".toList
  | .item w => "content/".toList ++ w ++ ".html".toList

/-- The pages of the exported snapshot. -/
def site (key : V → K) (addr : V → List Char) (vs : List V) : List (Page K) :=
  Page.index :: (groupKeys key vs).map Page.group ++ vs.map (fun v => Page.item (addr v))

/-- What each page links to. -/
def linksOf (key : V → K) (addr : V → List Char) (vs : List V) : Page K → List (Page K)
  | .index => (groupKeys key vs).map Page.group
  | .group k => (groupAt key vs k).map (fun v => Page.item (addr v))
  | .item _ => [Page.index]

/-- **No link in the exported folder is broken.** -/
theorem links_resolve {key : V → K} {addr : V → List Char} {vs : List V} {pg q : Page K}
    (hpg : pg ∈ site key addr vs) (h : q ∈ linksOf key addr vs pg) :
    q ∈ site key addr vs := by
  cases pg with
  | index =>
    simp only [linksOf, List.mem_map] at h
    obtain ⟨k, hk, rfl⟩ := h
    exact List.mem_cons_of_mem _ (List.mem_append_left _ (List.mem_map_of_mem hk))
  | group k =>
    simp only [linksOf, List.mem_map] at h
    obtain ⟨v, hv, rfl⟩ := h
    exact List.mem_cons_of_mem _
      (List.mem_append_right _ (List.mem_map_of_mem (mem_groupAt_iff.1 hv).1))
  | item w =>
    simp only [linksOf, List.mem_singleton] at h
    subst h
    exact List.mem_cons_self ..

/-- **Every item is two clicks from the index.** -/
theorem item_reachable {key : V → K} {addr : V → List Char} {vs : List V} {v : V}
    (h : v ∈ vs) :
    Page.group (key v) ∈ linksOf key addr vs Page.index ∧
      Page.item (addr v) ∈ linksOf key addr vs (Page.group (key v)) := by
  refine ⟨List.mem_map_of_mem (mem_groupKeys_of_mem h), ?_⟩
  exact List.mem_map_of_mem (mem_groupAt_iff.2 ⟨h, rfl⟩)

omit [DecidableEq K] in
theorem head_index (N : NamingScheme K) :
    ((Page.index : Page K).path N).head? = some 'i' := rfl

omit [DecidableEq K] in
theorem head_group (N : NamingScheme K) (k : K) :
    ((Page.group k).path N).head? = some 'g' := rfl

omit [DecidableEq K] in
theorem head_item (N : NamingScheme K) (w : List Char) :
    ((Page.item w).path N).head? = some 'c' := rfl

omit [DecidableEq K] in
/-- **Distinct pages are distinct files** — given a naming scheme.  The
naming obligation is exactly where the map-tile proof does not transfer:
here it is discharged by `N.name_inj`, which every new key type must
supply. -/
theorem path_injective {N : NamingScheme K} {pg q : Page K} (h : pg.path N = q.path N) :
    pg = q := by
  cases pg with
  | index =>
    cases q with
    | index => rfl
    | group k =>
      exact absurd (congrArg List.head? h) (by rw [head_index, head_group]; decide)
    | item w =>
      exact absurd (congrArg List.head? h) (by rw [head_index, head_item]; decide)
  | group k =>
    cases q with
    | index =>
      exact absurd (congrArg List.head? h) (by rw [head_index, head_group]; decide)
    | group k' =>
      simp only [Page.path, List.append_assoc] at h
      exact congrArg Page.group
        (N.name_inj (List.append_cancel_right (List.append_cancel_left h)))
    | item w =>
      exact absurd (congrArg List.head? h) (by rw [head_group, head_item]; decide)
  | item w =>
    cases q with
    | index =>
      exact absurd (congrArg List.head? h) (by rw [head_index, head_item]; decide)
    | group k =>
      exact absurd (congrArg List.head? h) (by rw [head_group, head_item]; decide)
    | item w' =>
      simp only [Page.path, List.append_assoc] at h
      exact congrArg Page.item (List.append_cancel_right (List.append_cancel_left h))

/-! ## Discharging the obligation for one key type

A snapshot that groups by an opaque slug — the shape §3.1 asks for, since
a topic hint in a filename is a metadata leak — needs the slug naming to
be injective.  Slugs are hex strings, so it is. -/

/-- A slug is a string of lowercase hex digits — opaque, and in
particular carrying no topic hint (§3.1). -/
def IsHexSlug (s : List Char) : Prop := ∀ c ∈ s, (Kant.Bytes.hexVal c).isSome

/-- Hex slugs as a key type: naming is the identity, and the obligation
is discharged on the subtype of hex strings. -/
def slugNaming : NamingScheme { s : List Char // IsHexSlug s } where
  name := fun s => s.1
  name_inj := by
    intro a b h
    exact Subtype.ext h
  name_plain := by
    rintro ⟨s, hs⟩
    refine ⟨fun hmem => ?_, fun hmem => ?_⟩
    · have := hs _ hmem
      revert this
      decide
    · have := hs _ hmem
      revert this
      decide

end Kant.Urania.Export
