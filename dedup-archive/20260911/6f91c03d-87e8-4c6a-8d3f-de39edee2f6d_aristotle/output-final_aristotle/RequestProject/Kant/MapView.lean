/-
# The map view: posts on a map, as a set of static pages

The upstream Rust pastebin browses posts as a list (`/browse`), as
threads (`/threads`) and as a gallery of Wikidata-keyed enrichments
(`/gallery`).  None of those knows *where* a post is.  This module adds
the missing view: a pin per post, clusters per zoom level, and a
multi-page (MPA) site — one ordinary page per region and per post, so
the whole map can be written to a folder, pinned on IPFS, carried on a
memory stick and opened without a server.

Proved here:

* `mem_visible_iff` — the viewport shows exactly the pins inside it: no
  pin is hidden, none is invented;
* `clusterAt_key` / `clusterAt_contains` — every pin in a cluster is a
  pin whose position really lies in that cluster's tile;
* `keys_nodup` — one cluster per tile;
* `clusters_perm` — **the clusters partition the pins**: flattening the
  clusters gives back exactly the pins, each once;
* `clusters_length` — so the cluster sizes add up to the number of pins:
  the counts on the map are honest;
* `clusters_zoom_out` — two pins in one cluster stay in one cluster when
  the map is zoomed out; clusters merge, they never split;
* `pinRow_title_recoverable` — the reader can recover a post's title from
  the rendered pin;
* `pinRow_no_markup` — a pin cannot inject markup into the map page;
* `pinRow_has_geo` — every rendered pin carries its own `geo:` URI, so
  the position can be copied out of the page;
* `pinRow_has_attribution` — every source cited by a pin is attributed in
  the rendered pin;
* `pinOfElement_attributes_osm` / `pinOfElement_cites_wikidata` /
  `pinOfElement_cites_wikipedia` — an imported OpenStreetMap element
  always credits OSM, and brings its Wikidata entity and its Wikipedia
  article onto the map with it;
* `links_resolve` — every link on every page of the site points at a page
  the site contains: the exported folder has no broken links;
* `post_reachable` — every post is reachable from the index in two
  clicks (index → region → post);
* `path_injective` — distinct pages have distinct file names, so the site
  can be written out without one page overwriting another.
-/
import Mathlib
import RequestProject.Kant.Text
import RequestProject.Kant.Erdfa
import RequestProject.Kant.Geo
import RequestProject.Kant.GeoRef

set_option maxRecDepth 4000
set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.MapView

open Kant Kant.Text Kant.Geo Kant.GeoRef

/-! ## Pins -/

/-- A post shown on the map. -/
structure Pin where
  /-- The post's content witness: its address in the store. -/
  witness : List Char
  /-- The post's title, unescaped. -/
  title : List Char
  /-- Where the post is. -/
  place : Coord
  /-- External records describing the place. -/
  refs : List Ref
deriving DecidableEq, Repr

/-! ## The viewport -/

/-- The pins inside a rectangle of the map. -/
def visible (b : BBox) (ps : List Pin) : List Pin := ps.filter (fun p => b.contains p.place)

/-- **The viewport shows exactly the pins inside it.** -/
theorem mem_visible_iff {b : BBox} {ps : List Pin} {p : Pin} :
    p ∈ visible b ps ↔ p ∈ ps ∧ b.contains p.place = true := by
  simp [visible, List.mem_filter]

theorem visible_length_le (b : BBox) (ps : List Pin) : (visible b ps).length ≤ ps.length :=
  List.length_filter_le _ _

/-- Zooming all the way out shows everything: the hull of the pins
contains every pin. -/
theorem visible_hull (p : Pin) (ps : List Pin) :
    ∀ q ∈ p :: ps, (hull p.place (ps.map Pin.place)).contains q.place = true := by
  intro q hq
  rcases List.mem_cons.1 hq with rfl | hq'
  · exact hull_contains_head _ _
  · exact hull_contains_mem (List.mem_map_of_mem hq')

/-! ## Clusters -/

/-- The tile a pin is clustered into at a zoom level. -/
def clusterKey (z : Nat) (p : Pin) : Tile := tileOf z p.place

/-- The tiles that hold at least one pin, in the order first seen. -/
def keys (z : Nat) (ps : List Pin) : List Tile := (ps.map (clusterKey z)).dedup

/-- The pins of one tile. -/
def clusterAt (z : Nat) (ps : List Pin) (t : Tile) : List Pin :=
  ps.filter (fun p => clusterKey z p == t)

/-- The clusters of the map at a zoom level. -/
def clusters (z : Nat) (ps : List Pin) : List (Tile × List Pin) :=
  (keys z ps).map (fun t => (t, clusterAt z ps t))

theorem keys_nodup (z : Nat) (ps : List Pin) : (keys z ps).Nodup := List.nodup_dedup _

theorem mem_clusterAt_iff {z : Nat} {ps : List Pin} {t : Tile} {p : Pin} :
    p ∈ clusterAt z ps t ↔ p ∈ ps ∧ clusterKey z p = t := by
  simp [clusterAt, List.mem_filter]

/-- Every pin of a cluster has that cluster's tile as its key. -/
theorem clusterAt_key {z : Nat} {ps : List Pin} {t : Tile} {p : Pin}
    (h : p ∈ clusterAt z ps t) : clusterKey z p = t := (mem_clusterAt_iff.1 h).2

/-- And so its position really is inside that tile. -/
theorem clusterAt_contains {z : Nat} {ps : List Pin} {t : Tile} {p : Pin}
    (h : p ∈ clusterAt z ps t) (hv : p.place.Valid) : t.Contains p.place := by
  rw [← clusterAt_key h]
  exact tileOf_contains hv

theorem mem_keys_of_mem {z : Nat} {ps : List Pin} {p : Pin} (h : p ∈ ps) :
    clusterKey z p ∈ keys z ps := by
  rw [keys, List.mem_dedup]
  exact List.mem_map_of_mem h

/-- A sum over a list of distinct keys of a function that vanishes away
from one of them. -/
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

/-- **The clusters partition the pins**: flattening them gives back every
pin exactly once. -/
theorem clusters_perm (z : Nat) (ps : List Pin) :
    ((clusters z ps).flatMap Prod.snd).Perm ps := by
  rw [List.perm_iff_count]
  intro a
  have hmap : (clusters z ps).flatMap Prod.snd
      = (keys z ps).flatMap (fun t => clusterAt z ps t) := by
    simp [clusters, List.flatMap_map]
  rw [hmap, List.count_flatMap]
  have hg : ∀ t : Tile, t ≠ clusterKey z a →
      (List.count a ∘ fun t => clusterAt z ps t) t = 0 := by
    intro t ht
    simp only [Function.comp_apply]
    refine List.count_eq_zero.2 ?_
    intro hmem
    exact ht ((mem_clusterAt_iff.1 hmem).2).symm
  rw [show (List.map (List.count a ∘ fun t => clusterAt z ps t) (keys z ps)).sum
      = if clusterKey z a ∈ keys z ps then (List.count a ∘ fun t => clusterAt z ps t)
          (clusterKey z a) else 0 from
    sum_map_eq_single _ _ _ (keys_nodup z ps) hg]
  by_cases hin : clusterKey z a ∈ keys z ps
  · rw [if_pos hin]
    simp only [Function.comp_apply, clusterAt]
    exact List.count_filter (by simp)
  · rw [if_neg hin]
    refine (List.count_eq_zero.2 ?_).symm
    intro hmem
    exact hin (mem_keys_of_mem hmem)

/-- The cluster counts shown on the map add up to the number of pins. -/
theorem clusters_length (z : Nat) (ps : List Pin) :
    ((clusters z ps).map (fun c => c.2.length)).sum = ps.length := by
  have h := (clusters_perm z ps).length_eq
  rw [List.length_flatMap] at h
  simpa using h

/-- **Clusters merge as the map is zoomed out, and never split.** -/
theorem clusters_zoom_out {z : Nat} {p q : Pin} (hz : 0 < z)
    (h : clusterKey z p = clusterKey z q) : clusterKey (z - 1) p = clusterKey (z - 1) q := by
  unfold clusterKey at h ⊢
  rw [← parent_tileOf p.place hz, ← parent_tileOf q.place hz, h]

/-! ## Rendering a pin -/

/-- One pin as it appears on a map page. -/
def pinRow (p : Pin) : List Char :=
  "<li class=\"pin\" data-geo=\"".toList ++ geoUri p.place ++ "\"><span class=\"t\">".toList ++
    Kant.Erdfa.escape p.title ++ "</span>".toList ++
    (p.refs.flatMap (fun r => ' ' :: citation r r.url)) ++ "</li>".toList

/-- The reader can recover the post's title from the rendered pin. -/
theorem pinRow_title_recoverable (p : Pin) :
    Kant.Erdfa.unescape (Kant.Erdfa.escape p.title) = p.title :=
  Kant.Erdfa.escape_unescape_id p.title

/-- A pin cannot inject markup into the page. -/
theorem pinRow_no_markup (p : Pin) :
    '<' ∉ Kant.Erdfa.escape p.title ∧ '>' ∉ Kant.Erdfa.escape p.title ∧
      '"' ∉ Kant.Erdfa.escape p.title :=
  Kant.Erdfa.escape_no_markup p.title

/-- If an element occurs in a list, its image is an infix of the
flattened images. -/
theorem infix_flatMap {α β : Type} (f : α → List β) {a : α} :
    ∀ {l : List α}, a ∈ l → f a <:+: l.flatMap f := by
  intro l
  induction l with
  | nil => intro h; simp at h
  | cons b t ih =>
    intro h
    rw [List.flatMap_cons]
    rcases List.mem_cons.1 h with rfl | h'
    · exact ⟨[], t.flatMap f, by simp⟩
    · obtain ⟨u, v, huv⟩ := ih h'
      exact ⟨f b ++ u, v, by rw [← huv]; simp⟩

/-- **Every rendered pin carries its own position**, ready to be copied. -/
theorem pinRow_has_geo (p : Pin) : containsSub (geoUri p.place) (pinRow p) = true := by
  rw [containsSub_iff_infix]
  refine ⟨"<li class=\"pin\" data-geo=\"".toList,
    "\"><span class=\"t\">".toList ++ Kant.Erdfa.escape p.title ++ "</span>".toList ++
      (p.refs.flatMap (fun r => ' ' :: citation r r.url)) ++ "</li>".toList, ?_⟩
  simp [pinRow]

/-- **Every source a pin cites is attributed in the rendered pin.** -/
theorem pinRow_has_attribution {p : Pin} {r : Ref} (h : r ∈ p.refs) :
    containsSub (Kant.Erdfa.escape r.attribution) (pinRow p) = true := by
  rw [containsSub_iff_infix]
  have h1 : Kant.Erdfa.escape r.attribution <:+: citation r r.url := by
    rw [← containsSub_iff_infix]
    exact citation_has_attribution r r.url
  have h2 : citation r r.url <:+: ' ' :: citation r r.url := ⟨[' '], [], by simp⟩
  have h3 : (' ' :: citation r r.url) <:+: p.refs.flatMap (fun r => ' ' :: citation r r.url) :=
    infix_flatMap (fun r => ' ' :: citation r r.url) h
  have h4 : p.refs.flatMap (fun r => ' ' :: citation r r.url) <:+: pinRow p := by
    refine ⟨"<li class=\"pin\" data-geo=\"".toList ++ geoUri p.place ++
      "\"><span class=\"t\">".toList ++ Kant.Erdfa.escape p.title ++ "</span>".toList,
      "</li>".toList, ?_⟩
    simp [pinRow]
  exact ((h1.trans h2).trans h3).trans h4

/-! ## Importing an extract

An OpenStreetMap extract is a list of elements, each with a position, a
name and tags — among them the `wikidata` and `wikipedia` tags that carry
the other two projects along.  Turning one into a pin keeps all of it. -/

/-- One element of an OSM extract. -/
structure OsmElement where
  /-- Node, way or relation. -/
  kind : OsmKind
  /-- Its OSM identifier. -/
  id : Nat
  /-- Where it is. -/
  place : Coord
  /-- Its `name` tag. -/
  name : List Char
  /-- Its other tags. -/
  tags : List (List Char × List Char)
deriving DecidableEq, Repr

/-- Everything the element points at: itself on OSM, and whatever its tags
name on Wikidata and Wikipedia. -/
def refsOfElement (e : OsmElement) : List Ref :=
  Ref.osm ⟨e.kind, e.id⟩ :: e.tags.filterMap (fun kv => refOfTag kv.1 kv.2)

/-- The element as a pin. -/
def pinOfElement (witness : List Char) (e : OsmElement) : Pin :=
  { witness := witness, title := e.name, place := e.place, refs := refsOfElement e }

@[simp] theorem pinOfElement_place (w : List Char) (e : OsmElement) :
    (pinOfElement w e).place = e.place := rfl

/-- **An imported element always credits OpenStreetMap.** -/
theorem pinOfElement_attributes_osm (w : List Char) (e : OsmElement) :
    containsSub (Kant.Erdfa.escape (Ref.osm ⟨e.kind, e.id⟩).attribution)
      (pinRow (pinOfElement w e)) = true :=
  pinRow_has_attribution (by simp [pinOfElement, refsOfElement])

/-- **And it brings its Wikidata entity with it.** -/
theorem pinOfElement_cites_wikidata {w : List Char} {e : OsmElement} {q : Qid}
    (h : ("wikidata".toList, qidTag q) ∈ e.tags) :
    Ref.data q ∈ (pinOfElement w e).refs := by
  refine List.mem_cons_of_mem _ ?_
  rw [List.mem_filterMap]
  exact ⟨("wikidata".toList, qidTag q), h, refOfTag_wikidata q⟩

/-- **And its Wikipedia article.** -/
theorem pinOfElement_cites_wikipedia {w : List Char} {e : OsmElement} {r : WikiRef}
    (hlang : ∀ c ∈ r.lang, c ≠ ':') (hne : r.lang ≠ []) (htitle : r.title ≠ [])
    (h : ("wikipedia".toList, wikiTag r) ∈ e.tags) :
    Ref.wiki r ∈ (pinOfElement w e).refs := by
  refine List.mem_cons_of_mem _ ?_
  rw [List.mem_filterMap]
  exact ⟨("wikipedia".toList, wikiTag r), h, refOfTag_wikipedia hlang hne htitle⟩

/-- Importing an extract: one pin per element, in order. -/
def importOsm (witnesses : List (List Char)) (es : List OsmElement) : List Pin :=
  (witnesses.zip es).map (fun p => pinOfElement p.1 p.2)

/-- Importing loses nothing and invents nothing. -/
theorem importOsm_length (witnesses : List (List Char)) (es : List OsmElement) :
    (importOsm witnesses es).length = min witnesses.length es.length := by
  simp [importOsm]

/-! ## The multi-page site

Every page is an ordinary file.  The index links to a page per populated
region, each region page links to the posts pinned in it, and each post
page links back.  Nothing on the map needs a server. -/

/-- A page of the exported map site. -/
inductive Page where
  /-- The world index. -/
  | index
  /-- One region: the pins of a tile. -/
  | region (t : Tile)
  /-- One post, named by its witness. -/
  | post (w : List Char)
deriving DecidableEq, Repr

/-- Where the page is written. -/
def Page.path : Page → List Char
  | .index => "index.html".toList
  | .region t => "map/".toList ++ t.quadkey ++ ".html".toList
  | .post w => "post/".toList ++ w ++ ".html".toList

/-- The pages of the site at a zoom level. -/
def site (z : Nat) (ps : List Pin) : List Page :=
  Page.index :: (keys z ps).map Page.region ++ ps.map (fun p => Page.post p.witness)

/-- What each page links to. -/
def linksOf (z : Nat) (ps : List Pin) : Page → List Page
  | .index => (keys z ps).map Page.region
  | .region t => (clusterAt z ps t).map (fun p => Page.post p.witness)
  | .post _ => [Page.index]

/-- **No link in the exported site is broken.** -/
theorem links_resolve {z : Nat} {ps : List Pin} {pg q : Page} (hpg : pg ∈ site z ps)
    (h : q ∈ linksOf z ps pg) : q ∈ site z ps := by
  cases pg with
  | index =>
    simp only [linksOf, List.mem_map] at h
    obtain ⟨t, ht, rfl⟩ := h
    exact List.mem_cons_of_mem _ (List.mem_append_left _ (List.mem_map_of_mem ht))
  | region t =>
    simp only [linksOf, List.mem_map] at h
    obtain ⟨p, hp, rfl⟩ := h
    exact List.mem_cons_of_mem _
      (List.mem_append_right _ (List.mem_map_of_mem (mem_clusterAt_iff.1 hp).1))
  | post w =>
    simp only [linksOf, List.mem_singleton] at h
    subst h
    exact List.mem_cons_self ..

/-- **Every post is two clicks from the index.** -/
theorem post_reachable {z : Nat} {ps : List Pin} {p : Pin} (h : p ∈ ps) :
    Page.region (clusterKey z p) ∈ linksOf z ps Page.index ∧
      Page.post p.witness ∈ linksOf z ps (Page.region (clusterKey z p)) := by
  constructor
  · exact List.mem_map_of_mem (mem_keys_of_mem h)
  · exact List.mem_map_of_mem (mem_clusterAt_iff.2 ⟨h, rfl⟩)

theorem quadkey_inj {t t' : Tile} (ht : t.x < 2 ^ t.zoom) (ht' : t'.x < 2 ^ t'.zoom)
    (hy : t.y < 2 ^ t.zoom) (hy' : t'.y < 2 ^ t'.zoom) (h : t.quadkey = t'.quadkey) : t = t' := by
  have h1 := quadkey_roundTrip ht hy
  have h2 := quadkey_roundTrip ht' hy'
  rw [h] at h1
  rw [h1] at h2
  exact Option.some.inj h2

/-- **Distinct pages are distinct files**, for tiles inside the grid and
witnesses free of dots. -/
theorem head_index : Page.index.path.head? = some 'i' := rfl

theorem head_region (t : Tile) : (Page.region t).path.head? = some 'm' := rfl

theorem head_post (w : List Char) : (Page.post w).path.head? = some 'p' := rfl

/-- **Distinct pages are distinct files**, for tiles inside the grid, so
the site can be written out without one page overwriting another. -/
theorem path_injective {pg q : Page}
    (hpg : ∀ t, pg = .region t → t.x < 2 ^ t.zoom ∧ t.y < 2 ^ t.zoom)
    (hq : ∀ t, q = .region t → t.x < 2 ^ t.zoom ∧ t.y < 2 ^ t.zoom)
    (h : pg.path = q.path) : pg = q := by
  cases pg with
  | index =>
    cases q with
    | index => rfl
    | region t =>
      exact absurd (congrArg List.head? h)
        (by rw [head_index, head_region]; decide)
    | post w =>
      exact absurd (congrArg List.head? h)
        (by rw [head_index, head_post]; decide)
  | region t =>
    cases q with
    | index =>
      exact absurd (congrArg List.head? h)
        (by rw [head_index, head_region]; decide)
    | region t' =>
      obtain ⟨hx, hy⟩ := hpg t rfl
      obtain ⟨hx', hy'⟩ := hq t' rfl
      simp only [Page.path, List.append_assoc] at h
      exact congrArg Page.region
        (quadkey_inj hx hx' hy hy' (List.append_cancel_right (List.append_cancel_left h)))
    | post w =>
      exact absurd (congrArg List.head? h)
        (by rw [head_region, head_post]; decide)
  | post w =>
    cases q with
    | index =>
      exact absurd (congrArg List.head? h)
        (by rw [head_index, head_post]; decide)
    | region t =>
      exact absurd (congrArg List.head? h)
        (by rw [head_region, head_post]; decide)
    | post w' =>
      simp only [Page.path, List.append_assoc] at h
      exact congrArg Page.post (List.append_cancel_right (List.append_cancel_left h))

end Kant.MapView
