/-
# Places, and where their facts come from

A pin on the map is worth little without a name, and the names come from
somewhere: the upstream gallery (`src/gallery.rs`) keys its enrichments
by **Wikidata** entity, and any map drawn on **OpenStreetMap** owes the
project an attribution.  This module is the reference layer: how a
position is written down as text, how an external record is named by a
URL, and what has to be printed next to anything taken from those
sources.

Proved here:

* `intValue_decInt` — signed decimal integers write out and read back;
* `readDeg_showDeg` — a micro-degree coordinate written as ordinary
  decimal degrees (six places, e.g. `-0.127500`) reads back *exactly*:
  no floating point anywhere in the round trip;
* `parseGeoUri_geoUri` — a position pasted as a `geo:` URI is the
  position that was copied;
* `parseOsmUrl_osmUrl`, `parseQidUrl_qidUrl`, `parseWikiUrl_wikiUrl` and
  `parseRefUrl_url` — an OpenStreetMap element, a Wikidata entity and a
  Wikipedia article each have a URL that names them uniquely and can be
  read back;
* `titleOfPath_pathOfTitle` — the underscore convention of Wikipedia
  titles is reversible;
* `attribution_ne_nil` and `citation_has_attribution` — every rendered
  citation carries the licence attribution its source requires: it is
  not possible to render a Wikipedia, Wikidata or OSM fact without it;
* `citation_no_markup` — a citation cannot inject markup into the page,
  however hostile the label.
-/
import Mathlib
import RequestProject.Kant.Text
import RequestProject.Kant.Erdfa
import RequestProject.Kant.Cli
import RequestProject.Kant.Geo

set_option maxRecDepth 4000
set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.GeoRef

open Kant Kant.Text Kant.Geo Kant.Cli

/-! ## Decimal numerals with a sign -/

/-- A signed integer in decimal. -/
def decInt (n : Int) : List Char :=
  if n < 0 then '-' :: decNum n.natAbs else decNum n.natAbs

/-- The value of a signed decimal numeral. -/
def intValue (cs : List Char) : Int :=
  if cs.head? = some '-' then -(digitsValue cs.tail : Int) else (digitsValue cs : Int)

theorem decAux_digits (fuel : Nat) : ∀ n c, c ∈ decAux fuel n → '0' ≤ c ∧ c ≤ '9' := by
  induction fuel with
  | zero => intro n c h; simp [decAux] at h
  | succ f ih =>
    intro n c h
    rw [decAux] at h
    by_cases hn : n < 10
    · rw [if_pos hn] at h
      rcases List.mem_singleton.1 h with rfl
      exact digitChar_isDigit hn
    · rw [if_neg hn] at h
      rcases List.mem_append.1 h with h' | h'
      · exact ih _ _ h'
      · rcases List.mem_singleton.1 h' with rfl
        exact digitChar_isDigit (Nat.mod_lt _ (by norm_num))

theorem decNum_digits (n : Nat) : ∀ c ∈ decNum n, '0' ≤ c ∧ c ≤ '9' :=
  fun _ h => decAux_digits _ _ _ h

theorem decNum_ne_dot {n : Nat} {c : Char} (h : c ∈ decNum n) : c ≠ '.' := by
  have := decNum_digits n c h
  intro hc; rw [hc] at this; exact absurd this (by decide)

theorem decNum_ne_minus {n : Nat} {c : Char} (h : c ∈ decNum n) : c ≠ '-' := by
  have := decNum_digits n c h
  intro hc; rw [hc] at this; exact absurd this (by decide)

theorem decAux_ne_nil (fuel n : Nat) (h : n < fuel) : decAux fuel n ≠ [] := by
  cases fuel with
  | zero => omega
  | succ f =>
    rw [decAux]
    by_cases hn : n < 10
    · simp [hn]
    · simp [hn]

theorem decNum_ne_nil (n : Nat) : decNum n ≠ [] := decAux_ne_nil _ _ (by omega)

theorem intValue_decInt (n : Int) : intValue (decInt n) = n := by
  unfold decInt intValue
  by_cases h : n < 0
  · rw [if_pos h]
    rw [if_pos (by rfl : ('-' :: decNum n.natAbs).head? = some '-')]
    simp only [List.tail_cons, digitsValue_decNum]
    omega
  · rw [if_neg h]
    obtain ⟨c, rest, hcs⟩ : ∃ c rest, decNum n.natAbs = c :: rest := by
      cases hd : decNum n.natAbs with
      | nil => exact absurd hd (decNum_ne_nil _)
      | cons a b => exact ⟨a, b, rfl⟩
    have hc : c ≠ '-' := decNum_ne_minus (by rw [hcs]; exact List.mem_cons_self ..)
    rw [hcs]
    rw [if_neg (by simp [hc])]
    rw [← hcs, digitsValue_decNum]
    omega

/-! ## Degrees

Coordinates are stored as integers (micro-degrees) but written for
people, and for other tools, as decimal degrees with six places. -/

/-- Micro-degrees in one degree. -/
def micro : Nat := 1000000

/-- A fractional part, written with exactly six digits. -/
def pad6 (m : Nat) : List Char := List.replicate (6 - (decNum m).length) '0' ++ decNum m

theorem digitsValue_nil : digitsValue [] = 0 := rfl

theorem digitsValue_replicate_zero (k : Nat) : digitsValue (List.replicate k '0') = 0 := by
  induction k with
  | zero => rfl
  | succ n ih =>
    rw [List.replicate_succ]
    have : digitsValue ('0' :: List.replicate n '0')
        = (List.replicate n '0').foldl
            (fun acc c => if '0' ≤ c ∧ c ≤ '9' then acc * 10 + (c.toNat - 48) else acc) 0 := by
      simp [digitsValue]
    rw [this]
    simpa [digitsValue] using ih

theorem digitsValue_pad6 (m : Nat) : digitsValue (pad6 m) = m := by
  unfold pad6
  rw [digitsValue_append, digitsValue_replicate_zero]
  simpa [digitsValue] using (digitsValue_decNum m)

theorem pad6_digits (m : Nat) : ∀ c ∈ pad6 m, '0' ≤ c ∧ c ≤ '9' := by
  intro c h
  rcases List.mem_append.1 h with h' | h'
  · rw [List.eq_of_mem_replicate h']; exact ⟨le_refl _, by decide⟩
  · exact decNum_digits m c h'

/-- A micro-degree value written as decimal degrees. -/
def showDeg (n : Int) : List Char :=
  (if n < 0 then ['-'] else []) ++ decNum (n.natAbs / micro) ++ '.' :: pad6 (n.natAbs % micro)

/-- The magnitude of a decimal-degree numeral, in micro-degrees. -/
def readMag (cs : List Char) : Int :=
  ((digitsValue (cs.takeWhile (fun c => c != '.')) : Int)) * (micro : Int) +
    (digitsValue ((cs.dropWhile (fun c => c != '.')).drop 1) : Int)

/-- Read a decimal-degree numeral back as micro-degrees. -/
def readDeg (cs : List Char) : Int :=
  if cs.head? = some '-' then -(readMag cs.tail) else readMag cs

theorem takeWhile_append_sep {s : Char} {a b : List Char} (ha : ∀ c ∈ a, c ≠ s) :
    (a ++ s :: b).takeWhile (fun c => c != s) = a := by
  induction a with
  | nil => simp
  | cons c t ih =>
    have hc : c ≠ s := ha c (List.mem_cons_self ..)
    simp [hc, ih fun d hd => ha d (List.mem_cons_of_mem _ hd)]

theorem dropWhile_append_sep {s : Char} {a b : List Char} (ha : ∀ c ∈ a, c ≠ s) :
    (a ++ s :: b).dropWhile (fun c => c != s) = s :: b := by
  induction a with
  | nil => simp
  | cons c t ih =>
    have hc : c ≠ s := ha c (List.mem_cons_self ..)
    simp [hc, ih fun d hd => ha d (List.mem_cons_of_mem _ hd)]

theorem readMag_mag (m : Nat) :
    readMag (decNum (m / micro) ++ '.' :: pad6 (m % micro)) = (m : Int) := by
  unfold readMag
  rw [takeWhile_append_sep (fun c hc => decNum_ne_dot hc),
      dropWhile_append_sep (fun c hc => decNum_ne_dot hc)]
  simp only [List.drop_succ_cons, List.drop_zero, digitsValue_decNum, digitsValue_pad6]
  have h : m / micro * micro + m % micro = m := Nat.div_add_mod' m micro
  have h' : ((m / micro : Nat) : Int) * (micro : Int) + ((m % micro : Nat) : Int) = (m : Int) := by
    exact_mod_cast h
  exact h'

/-- **A coordinate written out in degrees is the coordinate read back.**
No floating point takes part in the round trip. -/
theorem readDeg_showDeg (n : Int) : readDeg (showDeg n) = n := by
  unfold showDeg readDeg
  by_cases h : n < 0
  · rw [if_pos h]
    rw [show (['-'] ++ decNum (n.natAbs / micro) ++ '.' :: pad6 (n.natAbs % micro))
        = '-' :: (decNum (n.natAbs / micro) ++ '.' :: pad6 (n.natAbs % micro)) by simp]
    rw [if_pos (by rfl : ('-' :: (decNum (n.natAbs / micro) ++ '.' :: pad6 (n.natAbs % micro))).head?
        = some '-')]
    simp only [List.tail_cons]
    rw [readMag_mag]
    omega
  · rw [if_neg h]
    simp only [List.nil_append]
    obtain ⟨c, rest, hcs⟩ : ∃ c rest, decNum (n.natAbs / micro) = c :: rest := by
      cases hd : decNum (n.natAbs / micro) with
      | nil => exact absurd hd (decNum_ne_nil _)
      | cons a b => exact ⟨a, b, rfl⟩
    have hc : c ≠ '-' := decNum_ne_minus (by rw [hcs]; exact List.mem_cons_self ..)
    rw [if_neg (by rw [hcs]; simp [hc])]
    rw [readMag_mag]
    omega

/-! ## A position as text -/

/-- The `geo:` URI of a position, as understood by phones and maps. -/
def geoUri (c : Coord) : List Char :=
  "geo:".toList ++ showDeg c.lat ++ ',' :: showDeg c.lon

/-- Strip a known prefix. -/
def strip (pre s : List Char) : Option (List Char) :=
  if pre.isPrefixOf s then some (s.drop pre.length) else none

theorem strip_append (pre t : List Char) : strip pre (pre ++ t) = some t := by
  unfold strip
  rw [if_pos (List.isPrefixOf_iff_prefix.2 ⟨t, rfl⟩)]
  simp

theorem showDeg_body_ne_comma (n : Int) :
    ∀ d ∈ decNum (n.natAbs / micro) ++ '.' :: pad6 (n.natAbs % micro), d ≠ ',' := by
  intro d hd
  rcases List.mem_append.1 hd with h1 | h1
  · have := decNum_digits _ _ h1
    intro hc; rw [hc] at this; exact absurd this (by decide)
  · rcases List.mem_cons.1 h1 with rfl | h2
    · decide
    · have := pad6_digits _ _ h2
      intro hc; rw [hc] at this; exact absurd this (by decide)

theorem showDeg_ne_comma {n : Int} {c : Char} (h : c ∈ showDeg n) : c ≠ ',' := by
  unfold showDeg at h
  by_cases hn : n < 0
  · rw [if_pos hn] at h
    simp only [List.cons_append, List.mem_cons] at h
    rcases h with rfl | h
    · decide
    · exact showDeg_body_ne_comma n c (by simpa using h)
  · rw [if_neg hn] at h
    simp only [List.nil_append] at h
    exact showDeg_body_ne_comma n c h

/-- Read a position back from a `geo:` URI. -/
def parseGeoUri (s : List Char) : Option Coord :=
  match strip "geo:".toList s with
  | none => none
  | some rest =>
      let latPart := rest.takeWhile (fun c => c != ',')
      let lonPart := (rest.dropWhile (fun c => c != ',')).drop 1
      if lonPart.isEmpty then none else some ⟨readDeg latPart, readDeg lonPart⟩

theorem showDeg_ne_nil (n : Int) : showDeg n ≠ [] := by
  unfold showDeg
  intro h
  have := congrArg List.length h
  simp at this

/-- **A position pasted as a `geo:` URI is the position that was
copied.** -/
theorem parseGeoUri_geoUri (c : Coord) : parseGeoUri (geoUri c) = some c := by
  unfold parseGeoUri geoUri
  rw [show "geo:".toList ++ showDeg c.lat ++ ',' :: showDeg c.lon
      = "geo:".toList ++ (showDeg c.lat ++ ',' :: showDeg c.lon) by simp, strip_append]
  simp only
  rw [takeWhile_append_sep (fun d hd => showDeg_ne_comma hd),
      dropWhile_append_sep (fun d hd => showDeg_ne_comma hd)]
  simp only [List.drop_succ_cons, List.drop_zero]
  rw [if_neg (by simpa [List.isEmpty_iff] using showDeg_ne_nil c.lon)]
  rw [readDeg_showDeg, readDeg_showDeg]

/-! ## External records -/

/-- The three kinds of OpenStreetMap element. -/
inductive OsmKind where
  /-- A single point. -/
  | node
  /-- A line or an area. -/
  | way
  /-- A group of elements. -/
  | relation
deriving DecidableEq, Repr

/-- How the kind appears in a URL. -/
def OsmKind.slug : OsmKind → List Char
  | .node => "node".toList
  | .way => "way".toList
  | .relation => "relation".toList

/-- Read the kind back from its slug. -/
def osmKindOfSlug (s : List Char) : Option OsmKind :=
  if s = "node".toList then some .node
  else if s = "way".toList then some .way
  else if s = "relation".toList then some .relation
  else none

theorem osmKindOfSlug_slug (k : OsmKind) : osmKindOfSlug k.slug = some k := by
  cases k <;> decide

theorem slug_ne_slash (k : OsmKind) : ∀ c ∈ k.slug, c ≠ '/' := by
  cases k <;> (intro c hc; fin_cases hc <;> decide)

/-- An element of the OpenStreetMap database. -/
structure OsmRef where
  /-- Node, way or relation. -/
  kind : OsmKind
  /-- The element's OSM identifier. -/
  id : Nat
deriving DecidableEq, Repr

/-- A Wikidata entity, `Q` followed by a number. -/
structure Qid where
  /-- The number after the `Q`. -/
  num : Nat
deriving DecidableEq, Repr

/-- An article in some language edition of Wikipedia. -/
structure WikiRef where
  /-- Language code, e.g. `en`. -/
  lang : List Char
  /-- Article title, with spaces (not underscores). -/
  title : List Char
deriving DecidableEq, Repr

/-- A reference is usable when its language code is a host label (no dot,
no slash) and its title is a non-empty string without underscores. -/
structure WikiRef.WellFormed (r : WikiRef) : Prop where
  /-- The language code carries no dot. -/
  langNoDot : ∀ c ∈ r.lang, c ≠ '.'
  /-- The language code carries no slash. -/
  langNoSlash : ∀ c ∈ r.lang, c ≠ '/'
  /-- The title uses spaces, not underscores. -/
  titleNoUnderscore : '_' ∉ r.title
  /-- The title is not empty. -/
  titleNonempty : r.title ≠ []

/-- Titles travel in URLs with underscores for spaces. -/
def pathOfTitle (t : List Char) : List Char := t.map (fun c => if c = ' ' then '_' else c)

/-- And come back with spaces for underscores. -/
def titleOfPath (p : List Char) : List Char := p.map (fun c => if c = '_' then ' ' else c)

/-- The underscore convention is reversible for titles that contain no
underscore of their own. -/
theorem titleOfPath_pathOfTitle {t : List Char} (h : '_' ∉ t) :
    titleOfPath (pathOfTitle t) = t := by
  induction t with
  | nil => rfl
  | cons c rest ih =>
    have hc : c ≠ '_' := by intro hu; exact h (hu ▸ List.mem_cons_self ..)
    have hrest : '_' ∉ rest := fun hm => h (List.mem_cons_of_mem _ hm)
    by_cases hsp : c = ' '
    · simpa [pathOfTitle, titleOfPath, hsp] using ih hrest
    · simpa [pathOfTitle, titleOfPath, hsp, hc] using ih hrest

/-- Where an OSM element lives. -/
def osmUrl (r : OsmRef) : List Char :=
  "https://www.openstreetmap.org/".toList ++ r.kind.slug ++ '/' :: decNum r.id

/-- Where a Wikidata entity lives. -/
def qidUrl (q : Qid) : List Char :=
  "https://www.wikidata.org/wiki/Q".toList ++ decNum q.num

/-- Where a Wikipedia article lives. -/
def wikiUrl (r : WikiRef) : List Char :=
  "https://".toList ++ r.lang ++ ".wikipedia.org/wiki/".toList ++ pathOfTitle r.title

/-- Read an OSM element URL. -/
def parseOsmUrl (s : List Char) : Option OsmRef :=
  match strip "https://www.openstreetmap.org/".toList s with
  | none => none
  | some rest =>
      let kindPart := rest.takeWhile (fun c => c != '/')
      let idPart := (rest.dropWhile (fun c => c != '/')).drop 1
      if idPart.isEmpty then none
      else match osmKindOfSlug kindPart with
        | none => none
        | some k => some ⟨k, digitsValue idPart⟩

/-- Read a Wikidata entity URL. -/
def parseQidUrl (s : List Char) : Option Qid :=
  match strip "https://www.wikidata.org/wiki/Q".toList s with
  | none => none
  | some rest => if rest.isEmpty then none else some ⟨digitsValue rest⟩

/-- Read a Wikipedia article URL. -/
def parseWikiUrl (s : List Char) : Option WikiRef :=
  match strip "https://".toList s with
  | none => none
  | some rest =>
      let lang := rest.takeWhile (fun c => c != '.')
      match strip ".wikipedia.org/wiki/".toList (rest.dropWhile (fun c => c != '.')) with
      | none => none
      | some path => if path.isEmpty then none else some ⟨lang, titleOfPath path⟩

/-- **An OSM element URL names exactly that element.** -/
theorem parseOsmUrl_osmUrl (r : OsmRef) : parseOsmUrl (osmUrl r) = some r := by
  unfold parseOsmUrl osmUrl
  rw [show "https://www.openstreetmap.org/".toList ++ r.kind.slug ++ '/' :: decNum r.id
      = "https://www.openstreetmap.org/".toList ++ (r.kind.slug ++ '/' :: decNum r.id) by simp,
      strip_append]
  simp only
  rw [takeWhile_append_sep (slug_ne_slash r.kind),
      dropWhile_append_sep (slug_ne_slash r.kind)]
  simp only [List.drop_succ_cons, List.drop_zero]
  rw [if_neg (by simpa [List.isEmpty_iff] using decNum_ne_nil r.id), osmKindOfSlug_slug,
    digitsValue_decNum]

/-- **A Wikidata URL names exactly that entity.** -/
theorem parseQidUrl_qidUrl (q : Qid) : parseQidUrl (qidUrl q) = some q := by
  unfold parseQidUrl qidUrl
  rw [strip_append]
  simp only
  rw [if_neg (by simpa [List.isEmpty_iff] using decNum_ne_nil q.num), digitsValue_decNum]

theorem pathOfTitle_ne_nil {t : List Char} (h : t ≠ []) : pathOfTitle t ≠ [] := by
  unfold pathOfTitle
  simpa using h

/-- **A Wikipedia URL names exactly that article.** -/
theorem parseWikiUrl_wikiUrl {r : WikiRef} (hw : r.WellFormed) :
    parseWikiUrl (wikiUrl r) = some r := by
  unfold parseWikiUrl wikiUrl
  rw [show "https://".toList ++ r.lang ++ ".wikipedia.org/wiki/".toList ++ pathOfTitle r.title
      = "https://".toList ++ (r.lang ++ '.' :: ("wikipedia.org/wiki/".toList ++ pathOfTitle r.title))
      by rw [show ".wikipedia.org/wiki/".toList = '.' :: "wikipedia.org/wiki/".toList from rfl]; simp,
      strip_append]
  simp only
  rw [takeWhile_append_sep hw.langNoDot, dropWhile_append_sep hw.langNoDot,
      show ('.' :: ("wikipedia.org/wiki/".toList ++ pathOfTitle r.title))
        = ".wikipedia.org/wiki/".toList ++ pathOfTitle r.title from rfl, strip_append]
  simp only
  rw [if_neg (by simpa [List.isEmpty_iff] using pathOfTitle_ne_nil hw.titleNonempty),
      titleOfPath_pathOfTitle hw.titleNoUnderscore]

/-! ## One parser for all three

A pasted URL is dispatched on its host, so the three readers above never
have to guess. -/

/-- The host of an `https://` URL. -/
def hostOf (s : List Char) : List Char :=
  match strip "https://".toList s with
  | none => []
  | some rest => rest.takeWhile (fun c => c != '/')

/-- A reference to an external record. -/
inductive Ref where
  /-- An OpenStreetMap element. -/
  | osm (r : OsmRef)
  /-- A Wikidata entity. -/
  | data (q : Qid)
  /-- A Wikipedia article. -/
  | wiki (r : WikiRef)
deriving DecidableEq, Repr

/-- The canonical URL of a reference. -/
def Ref.url : Ref → List Char
  | .osm r => osmUrl r
  | .data q => qidUrl q
  | .wiki r => wikiUrl r

/-- Read a reference back from its URL. -/
def parseRefUrl (s : List Char) : Option Ref :=
  let host := hostOf s
  if host = "www.openstreetmap.org".toList then (parseOsmUrl s).map Ref.osm
  else if host = "www.wikidata.org".toList then (parseQidUrl s).map Ref.data
  else (parseWikiUrl s).map Ref.wiki

theorem hostOf_osmUrl (r : OsmRef) : hostOf (osmUrl r) = "www.openstreetmap.org".toList := by
  unfold hostOf osmUrl
  rw [show "https://www.openstreetmap.org/".toList ++ r.kind.slug ++ '/' :: decNum r.id
      = "https://".toList ++ ("www.openstreetmap.org".toList ++ '/' ::
          (r.kind.slug ++ '/' :: decNum r.id)) by rfl, strip_append]
  simp only
  exact takeWhile_append_sep (by intro c hc; fin_cases hc <;> decide)

theorem hostOf_qidUrl (q : Qid) : hostOf (qidUrl q) = "www.wikidata.org".toList := by
  unfold hostOf qidUrl
  rw [show "https://www.wikidata.org/wiki/Q".toList ++ decNum q.num
      = "https://".toList ++ ("www.wikidata.org".toList ++ '/' ::
          ("wiki/Q".toList ++ decNum q.num)) by rfl, strip_append]
  simp only
  exact takeWhile_append_sep (by intro c hc; fin_cases hc <;> decide)

theorem hostOf_wikiUrl {r : WikiRef} (hw : r.WellFormed) :
    hostOf (wikiUrl r) = r.lang ++ ".wikipedia.org".toList := by
  unfold hostOf wikiUrl
  rw [show "https://".toList ++ r.lang ++ ".wikipedia.org/wiki/".toList ++ pathOfTitle r.title
      = "https://".toList ++ ((r.lang ++ ".wikipedia.org".toList) ++ '/' ::
          ("wiki/".toList ++ pathOfTitle r.title)) by
        rw [show ".wikipedia.org/wiki/".toList
          = ".wikipedia.org".toList ++ '/' :: "wiki/".toList from rfl]; simp, strip_append]
  simp only
  refine takeWhile_append_sep ?_
  intro c hc
  rcases List.mem_append.1 hc with h | h
  · exact hw.langNoSlash c h
  · fin_cases h <;> decide

/-- A Wikipedia host is never one of the other two. -/
theorem wikiHost_ne {lang : List Char} (h : ∀ c ∈ lang, c ≠ '.') (other : List Char)
    (hother : other = "www.openstreetmap.org".toList ∨ other = "www.wikidata.org".toList) :
    lang ++ ".wikipedia.org".toList ≠ other := by
  intro heq
  have hlang : lang = "www".toList := by
    have h1 : (lang ++ '.' :: "wikipedia.org".toList).takeWhile (fun c => c != '.') = lang :=
      takeWhile_append_sep h
    rcases hother with rfl | rfl <;>
      · rw [show ".wikipedia.org".toList = '.' :: "wikipedia.org".toList from rfl] at heq
        rw [heq] at h1
        simpa using h1.symm
  rw [hlang] at heq
  rcases hother with rfl | rfl <;> exact absurd heq (by decide)

/-- **Every reference is named by its URL, and read back from it.** -/
theorem parseRefUrl_url {r : Ref} (h : ∀ w : WikiRef, r = .wiki w → w.WellFormed) :
    parseRefUrl r.url = some r := by
  cases r with
  | osm a => simp [parseRefUrl, Ref.url, hostOf_osmUrl, parseOsmUrl_osmUrl]
  | data q =>
    simp [parseRefUrl, Ref.url, hostOf_qidUrl, parseQidUrl_qidUrl,
      show ("www.wikidata.org".toList ≠ "www.openstreetmap.org".toList) by decide]
  | wiki w =>
    have hw := h w rfl
    rw [Ref.url, parseRefUrl]
    simp only [hostOf_wikiUrl hw]
    rw [if_neg (wikiHost_ne hw.langNoDot _ (Or.inl rfl)),
        if_neg (wikiHost_ne hw.langNoDot _ (Or.inr rfl))]
    simp [parseWikiUrl_wikiUrl hw]


/-! ## OpenStreetMap tags

An OSM element carries its links to the other two projects as tags:
`wikidata=Q90` and `wikipedia=en:Paris`.  Reading them is how an OSM
extract brings Wikipedia and Wikidata with it. -/

/-- The value of a `wikidata=` tag. -/
def qidTag (q : Qid) : List Char := 'Q' :: decNum q.num

/-- Read one. -/
def parseQidTag (s : List Char) : Option Qid :=
  if s.head? = some 'Q' ∧ s.tail ≠ [] then some ⟨digitsValue s.tail⟩ else none

/-- **A `wikidata=` tag names exactly its entity.** -/
theorem parseQidTag_qidTag (q : Qid) : parseQidTag (qidTag q) = some q := by
  unfold parseQidTag qidTag
  rw [if_pos ⟨rfl, by simpa using decNum_ne_nil q.num⟩]
  simp [digitsValue_decNum]

/-- The value of a `wikipedia=` tag. -/
def wikiTag (r : WikiRef) : List Char := r.lang ++ ':' :: r.title

/-- Read one. -/
def parseWikiTag (s : List Char) : Option WikiRef :=
  let lang := s.takeWhile (fun c => c != ':')
  let rest := (s.dropWhile (fun c => c != ':')).drop 1
  if lang.isEmpty ∨ rest.isEmpty then none else some ⟨lang, rest⟩

/-- **A `wikipedia=` tag names exactly its article**, for a language code
without a colon. -/
theorem parseWikiTag_wikiTag {r : WikiRef} (hlang : ∀ c ∈ r.lang, c ≠ ':')
    (hne : r.lang ≠ []) (htitle : r.title ≠ []) : parseWikiTag (wikiTag r) = some r := by
  unfold parseWikiTag wikiTag
  simp only
  rw [takeWhile_append_sep hlang, dropWhile_append_sep hlang]
  simp only [List.drop_succ_cons, List.drop_zero]
  rw [if_neg (by simp [List.isEmpty_iff, hne, htitle])]

/-- The reference an OSM tag stands for. -/
def refOfTag (key value : List Char) : Option Ref :=
  if key = "wikidata".toList then (parseQidTag value).map Ref.data
  else if key = "wikipedia".toList then (parseWikiTag value).map Ref.wiki
  else none

/-- **An OSM element's `wikidata` tag brings its Wikidata entity with
it.** -/
theorem refOfTag_wikidata (q : Qid) :
    refOfTag "wikidata".toList (qidTag q) = some (.data q) := by
  rw [refOfTag, if_pos rfl, parseQidTag_qidTag]
  rfl

/-- **And its `wikipedia` tag brings the article.** -/
theorem refOfTag_wikipedia {r : WikiRef} (hlang : ∀ c ∈ r.lang, c ≠ ':')
    (hne : r.lang ≠ []) (htitle : r.title ≠ []) :
    refOfTag "wikipedia".toList (wikiTag r) = some (.wiki r) := by
  rw [refOfTag, if_neg (by decide), if_pos rfl, parseWikiTag_wikiTag hlang hne htitle]
  rfl

/-! ## Citations -/

/-- The attribution each source requires. -/
def Ref.attribution : Ref → List Char
  | .osm _ => "© OpenStreetMap contributors, ODbL".toList
  | .data _ => "Wikidata, CC0".toList
  | .wiki _ => "Wikipedia, CC BY-SA 4.0".toList

/-- No source is attribution-free. -/
theorem attribution_ne_nil (r : Ref) : r.attribution ≠ [] := by
  cases r <;> simp [Ref.attribution]

/-- A rendered citation: an escaped label, the URL it points at, and the
attribution, in that order. -/
def citation (r : Ref) (label : List Char) : List Char :=
  "<a href=\"".toList ++ Kant.Erdfa.escape r.url ++ "\">".toList ++
    Kant.Erdfa.escape label ++ "</a> <span class=\"attr\">".toList ++
    Kant.Erdfa.escape r.attribution ++ "</span>".toList

/-- **A citation always carries its attribution.** -/
theorem citation_has_attribution (r : Ref) (label : List Char) :
    containsSub (Kant.Erdfa.escape r.attribution) (citation r label) = true := by
  rw [containsSub_iff_infix]
  refine ⟨"<a href=\"".toList ++ Kant.Erdfa.escape r.url ++ "\">".toList ++
    Kant.Erdfa.escape label ++ "</a> <span class=\"attr\">".toList, "</span>".toList, ?_⟩
  simp [citation]

/-- **A citation cannot inject markup**, whatever the label says. -/
theorem citation_no_markup (label : List Char) :
    '<' ∉ Kant.Erdfa.escape label ∧ '>' ∉ Kant.Erdfa.escape label ∧
      '"' ∉ Kant.Erdfa.escape label :=
  Kant.Erdfa.escape_no_markup label

end Kant.GeoRef
