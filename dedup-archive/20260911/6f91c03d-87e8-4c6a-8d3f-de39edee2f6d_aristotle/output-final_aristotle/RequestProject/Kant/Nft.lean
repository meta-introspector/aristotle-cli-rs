/-
# The gallery: entity cards, and how they reach the map

The upstream Rust pastebin serves `/gallery`: a wall of *NFT
enrichments*, one per entity, each a directory holding a picture and a
metadata record — the entity's Wikidata id, its name and description, an
IPFS content id for the picture, one for the rendered card, one for the
directory, and a witness.  The page filters them by age (`?time=`) and
by category (`?cat=`) and links each card to `/ipfs/<cid>`.

This module is that view, specified: the record, the filters, the
gateway link, the rendered card — and the missing step, which is that a
card with a position is a pin, so the gallery and the map are two views
of one collection.

Proved here:

* `parseGatewayPath_gatewayPath` — the `/ipfs/<cid>` link of a card names
  exactly the content it came from;
* `mem_gallery_iff` — the wall shows exactly the cards that pass the age
  and category filters, in order: nothing quietly dropped or added;
* `gallery_all` — with both filters open, the wall is the whole
  collection;
* `gallery_length_le` — filtering never invents a card;
* `verify_iff` — a card verifies exactly when its witness is the digest
  of the record it claims to describe: a doctored card is refused;
* `card_name_recoverable` — the reader can recover the entity's name from
  the rendered card;
* `card_no_markup` — a card cannot inject markup, whatever the metadata
  says;
* `card_has_attribution` — a card taken from Wikidata always shows the
  Wikidata attribution;
* `pinOf_place` / `pinOf_refs` / `pinOf_cluster` — a located card becomes
  a map pin at its own position, citing its own entity, clustered by that
  position: the gallery and the map view agree.
-/
import Mathlib
import RequestProject.Kant.Bytes
import RequestProject.Kant.Text
import RequestProject.Kant.Erdfa
import RequestProject.Kant.Geo
import RequestProject.Kant.GeoRef
import RequestProject.Kant.MapView

set_option maxRecDepth 4000
set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Nft

open Kant Kant.Bytes Kant.Text Kant.Geo Kant.GeoRef Kant.MapView

/-! ## Entries -/

/-- One enrichment of the gallery, as the upstream directory holds it. -/
structure Entry where
  /-- The Wikidata entity the card is about. -/
  entity : Qid
  /-- The entity's name. -/
  name : List Char
  /-- A one-line description. -/
  description : List Char
  /-- The category the card is filed under. -/
  category : List Char
  /-- The content id of the picture, on IPFS. -/
  imageCid : List Char
  /-- The bytes the witness is taken over. -/
  record : Blob
  /-- When the card was made, as a numeric key (newer is larger). -/
  time : Nat
  /-- Where the entity is, if it has a place. -/
  place : Option Coord
deriving DecidableEq, Repr

/-- The address of an entry: the digest of the record it describes. -/
def Entry.witness (e : Entry) : List Char := Kant.Bytes.witness e.record

/-- A card claims an address; it verifies when the address is the one its
record has. -/
def verify (e : Entry) (claimed : List Char) : Bool := claimed == e.witness

/-- **A doctored card is refused.** -/
theorem verify_iff (e : Entry) (claimed : List Char) :
    verify e claimed = true ↔ claimed = Kant.Bytes.witness e.record := by
  simp [verify, Entry.witness]

/-! ## The gateway link -/

/-- Where the gateway serves a content id. -/
def gatewayPath (cid : List Char) : List Char := "/ipfs/".toList ++ cid

/-- Read the content id back out of a gateway path. -/
def parseGatewayPath (s : List Char) : Option (List Char) :=
  match strip "/ipfs/".toList s with
  | none => none
  | some rest => if rest.isEmpty then none else some rest

/-- **A card's link names exactly the content it came from.** -/
theorem parseGatewayPath_gatewayPath {cid : List Char} (h : cid ≠ []) :
    parseGatewayPath (gatewayPath cid) = some cid := by
  unfold parseGatewayPath gatewayPath
  rw [strip_append]
  simp only
  rw [if_neg (by simpa [List.isEmpty_iff] using h)]

/-! ## The wall, and its filters

Upstream the wall is filtered by age (`today`, `week`, `month`, `all`)
and by category.  Both are recorded here as a cut-off and an optional
category. -/

/-- What the reader asked to see. -/
structure Query where
  /-- Show nothing older than this (`0` shows everything). -/
  since : Nat
  /-- Show only this category, or all of them. -/
  category : Option (List Char)
deriving DecidableEq, Repr

/-- Does an entry pass the filters? -/
def Query.admits (q : Query) (e : Entry) : Bool :=
  decide (q.since ≤ e.time) &&
    (match q.category with
      | none => true
      | some c => e.category == c)

/-- The wall. -/
def gallery (q : Query) (es : List Entry) : List Entry := es.filter q.admits

/-- **The wall shows exactly the cards that pass the filters.** -/
theorem mem_gallery_iff {q : Query} {es : List Entry} {e : Entry} :
    e ∈ gallery q es ↔ e ∈ es ∧ q.admits e = true := by
  simp [gallery, List.mem_filter]

/-- With both filters open, the wall is the whole collection. -/
theorem gallery_all (es : List Entry) : gallery ⟨0, none⟩ es = es := by
  simp [gallery, Query.admits]

theorem gallery_length_le (q : Query) (es : List Entry) :
    (gallery q es).length ≤ es.length := List.length_filter_le _ _

/-! ## The card -/

/-- The entity's own reference. -/
def Entry.ref (e : Entry) : Ref := .data e.entity

/-- A card as it appears on the wall. -/
def card (e : Entry) : List Char :=
  "<figure class=\"nft\"><img src=\"".toList ++ Kant.Erdfa.escape (gatewayPath e.imageCid) ++
    "\" alt=\"".toList ++ Kant.Erdfa.escape e.name ++
    "\"><figcaption><b>".toList ++ Kant.Erdfa.escape e.name ++ "</b> ".toList ++
    Kant.Erdfa.escape e.description ++ " ".toList ++ citation e.ref e.ref.url ++
    "</figcaption></figure>".toList

/-- The reader can recover the entity's name from the card. -/
theorem card_name_recoverable (e : Entry) :
    Kant.Erdfa.unescape (Kant.Erdfa.escape e.name) = e.name :=
  Kant.Erdfa.escape_unescape_id e.name

/-- A card cannot inject markup. -/
theorem card_no_markup (e : Entry) :
    ('<' ∉ Kant.Erdfa.escape e.name ∧ '>' ∉ Kant.Erdfa.escape e.name ∧
        '"' ∉ Kant.Erdfa.escape e.name) ∧
      ('<' ∉ Kant.Erdfa.escape e.description ∧ '>' ∉ Kant.Erdfa.escape e.description ∧
        '"' ∉ Kant.Erdfa.escape e.description) :=
  ⟨Kant.Erdfa.escape_no_markup e.name, Kant.Erdfa.escape_no_markup e.description⟩

/-- **A card always shows where its facts come from.** -/
theorem card_has_attribution (e : Entry) :
    containsSub (Kant.Erdfa.escape e.ref.attribution) (card e) = true := by
  rw [containsSub_iff_infix]
  have h1 : Kant.Erdfa.escape e.ref.attribution <:+: citation e.ref e.ref.url := by
    rw [← containsSub_iff_infix]
    exact citation_has_attribution e.ref e.ref.url
  refine h1.trans ⟨"<figure class=\"nft\"><img src=\"".toList ++
    Kant.Erdfa.escape (gatewayPath e.imageCid) ++ "\" alt=\"".toList ++
    Kant.Erdfa.escape e.name ++ "\"><figcaption><b>".toList ++ Kant.Erdfa.escape e.name ++
    "</b> ".toList ++ Kant.Erdfa.escape e.description ++ " ".toList,
    "</figcaption></figure>".toList, ?_⟩
  simp [card]

/-! ## From the wall to the map -/

/-- A located card, as a pin on the map. -/
def pinOf (e : Entry) (c : Coord) : Pin :=
  { witness := e.witness, title := e.name, place := c, refs := [e.ref] }

@[simp] theorem pinOf_place (e : Entry) (c : Coord) : (pinOf e c).place = c := rfl

@[simp] theorem pinOf_refs (e : Entry) (c : Coord) : (pinOf e c).refs = [e.ref] := rfl

/-- The pin of a card is clustered by the card's own position. -/
theorem pinOf_cluster (z : Nat) (e : Entry) (c : Coord) :
    clusterKey z (pinOf e c) = tileOf z c := rfl

/-- The located cards of a collection, as pins. -/
def pins (es : List Entry) : List Pin :=
  es.filterMap (fun e => (e.place).map (pinOf e))

/-- Exactly the located cards become pins. -/
theorem mem_pins_iff {es : List Entry} {p : Pin} :
    p ∈ pins es ↔ ∃ e ∈ es, ∃ c, e.place = some c ∧ p = pinOf e c := by
  constructor
  · intro h
    rw [pins, List.mem_filterMap] at h
    obtain ⟨e, he, hp⟩ := h
    cases hc : e.place with
    | none => rw [hc] at hp; simp at hp
    | some c =>
      rw [hc] at hp
      simp only [Option.map_some, Option.some.injEq] at hp
      exact ⟨e, he, c, hc, hp.symm⟩
  · rintro ⟨e, he, c, hc, rfl⟩
    rw [pins, List.mem_filterMap]
    exact ⟨e, he, by rw [hc]; rfl⟩

/-- Every pin of the gallery carries its card's attribution. -/
theorem pins_have_attribution {es : List Entry} {p : Pin} (h : p ∈ pins es) :
    ∃ r ∈ p.refs, containsSub (Kant.Erdfa.escape r.attribution) (pinRow p) = true := by
  obtain ⟨e, -, c, -, rfl⟩ := mem_pins_iff.1 h
  exact ⟨e.ref, by simp, pinRow_has_attribution (by simp)⟩

end Kant.Nft
