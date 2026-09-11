/-
# Catalogue elements as pastebin elements

A catalogue element has to travel the way everything else in this project
travels: as a paste.  So it is rendered into one line of separator-framed
ASCII that can be pasted into a box, put in a URL, carried in a QR code or
stuffed into a picture, and read back exactly.

Proved:

* `parseElement_render` — **the paste round-trips**: any element whose fields are
  within their declared widths is recovered exactly from its own text,
  identity, evidence, attestations and all;
* `render_no_sep` — no field can contain the framing character, so the
  framing is unambiguous;
* `render_injective` — distinct elements have distinct pastes;
* the RDFa block is *rendered from the same record* (`toRdfa`), so the
  markup's shard attribute is the CRT image of the address's class by
  construction (`rdfa_shard_is_derived`) — there is no second field to
  disagree, which is exactly what the legacy block got wrong.
-/
import Mathlib
import RequestProject.Kant.Text
import RequestProject.Kant.Erdfa
import RequestProject.Kant.Moonshine.Record

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Kant.Bytes Kant.Text Kant.Sheaf

/-! ## Framing helpers -/

theorem hexDigit_ne_sep {n : ℕ} (h : n < 16) : hexDigit n ≠ sep := by
  interval_cases n <;> decide

theorem hexDigits_no_sep (k v : ℕ) : sep ∉ hexDigits k v := by
  induction k generalizing v with
  | zero => simp [hexDigits]
  | succ k ih =>
      simp only [hexDigits, List.mem_append, List.mem_singleton, not_or]
      exact ⟨ih (v / 16), fun h => hexDigit_ne_sep (Nat.mod_lt _ (by norm_num)) h.symm⟩

/-- A one-field rendering of a natural number, `k` hex digits wide. -/
theorem hexValue_hexDigits_of_lt {k v : ℕ} (h : v < 16 ^ k) :
    hexValue (hexDigits k v) = some v := by
  rw [hexValue_hexDigits, Nat.mod_eq_of_lt h]

/-! ## Anchor and witness lists -/

/-- Anchors, two fields each: the landmark's identity and the measurement. -/
def renderAnchors : List (Blob × ℕ) → List (List Char)
  | [] => []
  | (b, m) :: rest => hexEncode b :: hexDigits 16 m :: renderAnchors rest

/-- Read `n` anchors off the front of a field list. -/
def parseAnchors : ℕ → List (List Char) → Option (List (Blob × ℕ) × List (List Char))
  | 0, fs => some ([], fs)
  | n + 1, bf :: mf :: fs => do
      let b ← hexDecode bf
      let m ← hexValue mf
      let r ← parseAnchors n fs
      pure ((b, m) :: r.1, r.2)
  | _, _ => none

theorem parseAnchors_renderAnchors (l : List (Blob × ℕ)) (h : ∀ p ∈ l, p.2 < 16 ^ 16)
    (fs : List (List Char)) :
    parseAnchors l.length (renderAnchors l ++ fs) = some (l, fs) := by
  induction l with
  | nil => simp [parseAnchors, renderAnchors]
  | cons p rest ih =>
      obtain ⟨b, m⟩ := p
      have hm : m < 16 ^ 16 := h (b, m) (by simp)
      have hrest : ∀ q ∈ rest, q.2 < 16 ^ 16 := fun q hq => h q (by simp [hq])
      simp only [renderAnchors, List.cons_append, List.length_cons, parseAnchors,
        hexDecode_hexEncode, hexValue_hexDigits_of_lt hm, ih hrest, Option.pure_def]
      rfl

theorem renderAnchors_no_sep (l : List (Blob × ℕ)) : ∀ f ∈ renderAnchors l, sep ∉ f := by
  induction l with
  | nil => simp [renderAnchors]
  | cons p rest ih =>
      obtain ⟨b, m⟩ := p
      intro f hf
      simp only [renderAnchors, List.mem_cons] at hf
      rcases hf with rfl | rfl | hf
      · exact sep_not_mem_hexEncode b
      · exact hexDigits_no_sep 16 m
      · exact ih f hf

/-- Witnesses, one field each. -/
def renderBlobs (l : List Blob) : List (List Char) := l.map hexEncode

def parseBlobs : ℕ → List (List Char) → Option (List Blob × List (List Char))
  | 0, fs => some ([], fs)
  | n + 1, bf :: fs => do
      let b ← hexDecode bf
      let r ← parseBlobs n fs
      pure (b :: r.1, r.2)
  | _, _ => none

theorem parseBlobs_renderBlobs (l : List Blob) (fs : List (List Char)) :
    parseBlobs l.length (renderBlobs l ++ fs) = some (l, fs) := by
  induction l with
  | nil => simp [parseBlobs, renderBlobs]
  | cons b rest ih =>
      simp only [renderBlobs, List.map_cons, List.cons_append, List.length_cons, parseBlobs,
        hexDecode_hexEncode, Option.pure_def]
      rw [show List.map hexEncode rest = renderBlobs rest from rfl, ih]
      rfl

theorem renderBlobs_no_sep (l : List Blob) : ∀ f ∈ renderBlobs l, sep ∉ f := by
  intro f hf
  simp only [renderBlobs, List.mem_map] at hf
  obtain ⟨b, -, rfl⟩ := hf
  exact sep_not_mem_hexEncode b

/-! ## The paste -/

/-- The format tag: a paste that starts with this is a catalogue element. -/
def exchangeMagic : List Char := "kant-moonshine-1".toList

/-- Field widths a paste can carry. -/
def CatalogElement.Fits (e : CatalogElement) : Prop :=
  e.anchors.length < 16 ^ 2 ∧ (∀ p ∈ e.anchors, p.2 < 16 ^ 16) ∧
  e.witnesses.length < 16 ^ 2 ∧ e.measureScale < 16 ^ 8 ∧ e.witnessThreshold < 16 ^ 8

instance (e : CatalogElement) : Decidable e.Fits := by unfold CatalogElement.Fits; infer_instance

/-- The fields of a catalogue element, in order. -/
def CatalogElement.fields (e : CatalogElement) : List (List Char) :=
  [ exchangeMagic
  , hexEncode e.identity
  , hexDigits 1 e.typ.val
  , e.encoding.name
  , eigenName e.eigen
  , hexDigits 1 e.bott.val
  , (match e.irrep with | none => "-".toList | some i => hexDigits 2 i.val)
  , hexDigits 8 e.measureScale
  , hexDigits 8 e.witnessThreshold
  , hexDigits 2 e.anchors.length ]
  ++ renderAnchors e.anchors
  ++ [hexDigits 2 e.witnesses.length]
  ++ renderBlobs e.witnesses

/-- The paste: one line of text. -/
def CatalogElement.render (e : CatalogElement) : List Char := joinFields e.fields

/-- Read a bounded index from a hex field. -/
def finOf (n : ℕ) (f : List Char) : Option (Fin n) :=
  (hexValue f).bind (fun v => if h : v < n then some ⟨v, h⟩ else none)

theorem finOf_hexDigits {n k : ℕ} (i : Fin n) (h : i.val < 16 ^ k) :
    finOf n (hexDigits k i.val) = some i := by
  simp only [finOf, hexValue_hexDigits_of_lt h, Option.bind_some, dif_pos i.isLt]

/-- Read the optional representation index. -/
def parseIrrep (f : List Char) : Option (Option IrrepIndex) :=
  if f = "-".toList then some none else (finOf 194 f).map some

theorem parseIrrep_render (o : Option IrrepIndex) :
    parseIrrep (match o with | none => "-".toList | some i => hexDigits 2 i.val) = some o := by
  rcases o with _ | i
  · simp [parseIrrep]
  · have hne : hexDigits 2 i.val ≠ "-".toList := by
      intro hcon
      have h2 : (hexDigits 2 i.val).length = 2 := hexDigits_length 2 i.val
      rw [hcon] at h2
      exact absurd h2 (by decide)
    simp [parseIrrep, hne, finOf_hexDigits i (k := 2) (by have := i.isLt; omega)]

/-- Read the witness count and the witnesses that follow it. -/
def parseWitnesses : List (List Char) → Option (List Blob)
  | [] => none
  | wcf :: rest => (hexValue wcf).bind (fun wc => (parseBlobs wc rest).map Prod.fst)

theorem parseWitnesses_render (l : List Blob) (h : l.length < 16 ^ 2) :
    parseWitnesses (hexDigits 2 l.length :: renderBlobs l) = some l := by
  simp only [parseWitnesses, hexValue_hexDigits_of_lt h, Option.bind_some]
  rw [show renderBlobs l = renderBlobs l ++ [] from (List.append_nil _).symm,
    parseBlobs_renderBlobs]
  rfl

/-- Read a catalogue element out of a paste. -/
def parseElement (s : List Char) : Option CatalogElement :=
  match splitFields s with
  | magic :: idf :: tf :: encf :: eigf :: bottf :: irrf :: msf :: wtf :: acf :: rest =>
      if magic ≠ exchangeMagic then none else
      Option.bind (hexDecode idf) fun identity =>
      Option.bind (finOf 16 tf) fun typ =>
      Option.bind (parseEncodingStrict encf) fun enc =>
      Option.bind (parseEigenSpace eigf) fun eig =>
      Option.bind (finOf 8 bottf) fun bott =>
      Option.bind (parseIrrep irrf) fun irr =>
      Option.bind (hexValue msf) fun ms =>
      Option.bind (hexValue wtf) fun wt =>
      Option.bind (hexValue acf) fun ac =>
      Option.bind (parseAnchors ac rest) fun ar =>
      Option.bind (parseWitnesses ar.2) fun wl =>
      some { identity := identity
             typ := typ
             encoding := enc
             eigen := eig
             bott := bott
             irrep := irr
             anchors := ar.1
             measureScale := ms
             witnesses := wl
             witnessThreshold := wt }
  | _ => none

theorem render_no_sep (e : CatalogElement) : ∀ f ∈ e.fields, sep ∉ f := by
  intro f hf
  rw [CatalogElement.fields] at hf
  rcases List.mem_append.mp hf with h | h
  · rcases List.mem_append.mp h with h | h
    · rcases List.mem_append.mp h with h | h
      · simp only [List.mem_cons, List.not_mem_nil, or_false] at h
        rcases h with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
        · decide
        · exact sep_not_mem_hexEncode _
        · exact hexDigits_no_sep 1 _
        · cases e.encoding <;> decide
        · cases e.eigen <;> decide
        · exact hexDigits_no_sep 1 _
        · rcases e.irrep with _ | i
          · decide
          · exact hexDigits_no_sep 2 _
        · exact hexDigits_no_sep 8 _
        · exact hexDigits_no_sep 8 _
        · exact hexDigits_no_sep 2 _
      · exact renderAnchors_no_sep _ f h
    · simp only [List.mem_singleton] at h
      subst h
      exact hexDigits_no_sep 2 _
  · exact renderBlobs_no_sep _ f h

/-- **The paste round-trips.** -/
theorem parseElement_render {e : CatalogElement} (h : e.Fits) :
    parseElement e.render = some e := by
  obtain ⟨hac, ham, hwc, hms, hwt⟩ := h
  have hsplit : splitFields e.render = e.fields :=
    splitFields_joinFields (by simp [CatalogElement.fields]) (render_no_sep e)
  have htyp : e.typ.val < 16 ^ 1 := by simp
  have hbott : e.bott.val < 16 ^ 1 := by have := e.bott.isLt; omega
  rw [parseElement, hsplit]
  simp only [CatalogElement.fields, List.cons_append, List.nil_append, List.append_assoc]
  rw [if_neg (by simp)]
  rw [hexDecode_hexEncode, Option.bind_some, finOf_hexDigits e.typ htyp, Option.bind_some,
    parseEncodingStrict_name, Option.bind_some, parseEigenSpace_name, Option.bind_some,
    finOf_hexDigits e.bott hbott, Option.bind_some, parseIrrep_render, Option.bind_some,
    hexValue_hexDigits_of_lt hms, Option.bind_some, hexValue_hexDigits_of_lt hwt,
    Option.bind_some, hexValue_hexDigits_of_lt (show e.anchors.length < 16 ^ 2 from hac),
    Option.bind_some, parseAnchors_renderAnchors e.anchors ham, Option.bind_some,
    parseWitnesses_render e.witnesses hwc, Option.bind_some]

theorem render_injective {a b : CatalogElement} (ha : a.Fits) (hb : b.Fits)
    (h : a.render = b.render) : a = b := by
  have := parseElement_render ha
  rw [h, parseElement_render hb] at this
  exact (Option.some.inj this).symm

/-! ## The RDFa block, rendered from the same record -/

/-- Decimal digits of a natural number, most significant first. -/
def decDigits (n : ℕ) : List Char :=
  if n < 10 then [Char.ofNat (48 + n)] else decDigits (n / 10) ++ [Char.ofNat (48 + n % 10)]
  decreasing_by omega

/-- The shard attribute text: the three coordinates of the address's class. -/
def shardAttr (e : CatalogElement) : List Char :=
  let c := e.coords
  decDigits c.1.val ++ ",".toList ++ decDigits c.2.1.val ++ ",".toList ++ decDigits c.2.2.val

/-- One `<meta property=… content=… />` line, with the content escaped. -/
def metaLine (prop content : List Char) : List Char :=
  "<meta property=\"".toList ++ Kant.Erdfa.escape prop ++ "\" content=\"".toList ++
    Kant.Erdfa.escape content ++ "\" />".toList

/-- The corrected block: identity is the full digest, the address is
canonical, and the shard is derived from it. -/
def toRdfa (e : CatalogElement) : List Char :=
  "<div typeof=\"dasl:SheafCell\" about=\"urn:kant:".toList ++ hexEncode e.identity ++
    "\">".toList ++
  metaLine "dasl:contentDigest".toList (hexEncode e.identity) ++
  metaLine "dasl:compactAddress".toList e.address.renderHex ++
  metaLine "dasl:objectType".toList (hexDigits 1 e.typ.val) ++
  metaLine "dasl:encoding".toList e.encoding.name ++
  metaLine "dasl:eigenspace".toList (eigenName e.eigen) ++
  metaLine "dasl:bott".toList (bottAttr e.bott) ++
  metaLine "dasl:crtModulus".toList (decDigits 196883) ++
  metaLine "dasl:crtClass".toList (decDigits e.address.cls) ++
  metaLine "dasl:crtCoordinates".toList (shardAttr e) ++
  metaLine "dasl:primeBasis".toList "71,59,47".toList ++
  metaLine "dasl:shadowAnchorCount".toList (hexDigits 2 e.anchors.length) ++
  metaLine "dasl:witnessThreshold".toList (hexDigits 8 e.witnessThreshold) ++
  "</div>".toList

/-- **The markup's shard is the address's class, read through the CRT.**  It
is not a second assertion that could disagree — it is a rendering of the
derived value. -/
theorem rdfa_shard_is_derived (e : CatalogElement) :
    shardAttr e =
      (let c := coordsOf ((e.address.cls : ℕ) : ZMod 196883)
       decDigits c.1.val ++ ",".toList ++ decDigits c.2.1.val ++ ",".toList ++
         decDigits c.2.2.val) := by
  simp only [shardAttr, CatalogElement.coords_eq_of_address]

end Kant.Moonshine
