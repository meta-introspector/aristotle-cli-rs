import Mathlib

/-!
# Share links

The formal counterpart of `web/js/share.js`: the code that turns a playbook
into the fragment of a URL (`…/hesper.html#p=u…`) and reads it back, which is
how a rendering is shared — by link, and by the QR code drawn from that link.

The runtime encodes the playbook's UTF-8 bytes with **base64url** (the RFC 4648
alphabet, padding stripped) behind a one-letter tag: `u` for the bytes
themselves, `z` for the raw-deflate stream when the browser has
`CompressionStream` and compression actually helps.  The fragment is then a
field of an `&`-separated key/value list, `p=<payload>`.

What is proved here:

* `decSix_encSix`, `decode_encode` — the base64url codec is lossless: reading a
  payload back yields exactly the bytes it was built from, including the two
  ragged tails (one and two leftover bytes) that carry no padding character;
* `encode_mem_alphabet` — a payload only ever contains characters of the
  base64url alphabet, so it is URL-safe: no `&`, `#`, `=`, `+`, `/` or `%` can
  appear inside it and the surrounding grammar cannot be broken;
* `fromFrag_toFrag` — the tagged fragment round-trips, for *either* branch: if
  the browser's deflate/inflate pair is inverse then a compressed link carries
  the same playbook as an uncompressed one;
* `readP_hashOf`, `share_roundtrip` — reading a whole link back (`#p=…`, with
  the other options in any position) recovers the payload and hence the
  original bytes.

`tests/node/test_share.mjs` checks the shipped JavaScript against the same
statements, and `tests/browser/test_single.mjs` decodes the QR code the share
dialog displays.
-/

namespace Hesper.Share

/-! ## The base64url alphabet -/

/-- The RFC 4648 URL-safe alphabet, in order: this is the table
`bytesToB64url` produces (`+` and `/` already replaced by `-` and `_`). -/
def alphabet : List Char :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_".toList

@[simp] theorem length_alphabet : alphabet.length = 64 := by decide

/-- The character standing for a six-bit group. -/
def encChar (n : ℕ) : Char := alphabet.getD n '?'

/-- The six-bit group a character stands for, if it is in the alphabet. -/
def decChar (c : Char) : Option ℕ := alphabet.idxOf? c

theorem decChar_encChar {n : ℕ} (h : n < 64) : decChar (encChar n) = some n := by
  have : ∀ m ∈ List.range 64, decChar (encChar m) = some m := by decide
  exact this n (List.mem_range.2 h)

theorem encChar_mem_alphabet {n : ℕ} (h : n < 64) : encChar n ∈ alphabet := by
  have : ∀ m ∈ List.range 64, encChar m ∈ alphabet := by decide
  exact this n (List.mem_range.2 h)

/-- The alphabet contains no character with a meaning in a URL fragment. -/
theorem alphabet_url_safe :
    '&' ∉ alphabet ∧ '#' ∉ alphabet ∧ '=' ∉ alphabet ∧ '%' ∉ alphabet ∧
      '+' ∉ alphabet ∧ '/' ∉ alphabet := by decide

/-! ## Bytes to six-bit groups and back -/

/-- Regroup a list of bytes into six-bit groups, three bytes at a time; a tail
of one or two bytes contributes two or three groups (the runtime strips the
`=` padding, so nothing marks the tail). -/
def encSix : List ℕ → List ℕ
  | [] => []
  | [a] => [a / 4, a % 4 * 16]
  | [a, b] => [a / 4, a % 4 * 16 + b / 16, b % 16 * 4]
  | a :: b :: c :: t =>
      a / 4 :: (a % 4 * 16 + b / 16) :: (b % 16 * 4 + c / 64) :: c % 64 :: encSix t

/-- Regroup six-bit groups back into bytes.  A single leftover group cannot
come from any list of bytes, and is rejected. -/
def decSix : List ℕ → Option (List ℕ)
  | [] => some []
  | [_] => none
  | [x, y] => some [x * 4 + y / 16]
  | [x, y, z] => some [x * 4 + y / 16, y % 16 * 16 + z / 4]
  | x :: y :: z :: w :: t => (decSix t).map fun r =>
      (x * 4 + y / 16) :: (y % 16 * 16 + z / 4) :: (z % 4 * 64 + w) :: r

/-- Regrouping is lossless: the bytes come back exactly. -/
theorem decSix_encSix : ∀ l : List ℕ, (∀ x ∈ l, x < 256) → decSix (encSix l) = some l := by
  intro l
  induction l using encSix.induct with
  | case1 => intro _; rfl
  | case2 a =>
      intro h
      have ha := h a (by simp)
      simp only [encSix, decSix, Option.some.injEq, List.cons.injEq, and_true]
      omega
  | case3 a b =>
      intro h
      have ha := h a (by simp)
      have hb := h b (by simp)
      simp only [encSix, decSix, Option.some.injEq, List.cons.injEq, and_true]
      omega
  | case4 a b c t ih =>
      intro h
      have ha := h a (by simp)
      have hb := h b (by simp)
      have hc := h c (by simp)
      have hrest : decSix (encSix t) = some t := ih (fun x hx => h x (by simp [hx]))
      simp only [encSix, decSix, hrest, Option.map_some, Option.some.injEq, List.cons.injEq,
        and_true]
      omega

/-- Every group really is six bits wide, so it names a character. -/
theorem encSix_lt : ∀ l : List ℕ, (∀ x ∈ l, x < 256) → ∀ y ∈ encSix l, y < 64 := by
  intro l
  induction l using encSix.induct with
  | case1 => intro _ y hy; simp [encSix] at hy
  | case2 a =>
      intro h y hy
      have ha := h a (by simp)
      simp only [encSix, List.mem_cons, List.not_mem_nil, or_false] at hy
      rcases hy with rfl | rfl <;> omega
  | case3 a b =>
      intro h y hy
      have ha := h a (by simp)
      have hb := h b (by simp)
      simp only [encSix, List.mem_cons, List.not_mem_nil, or_false] at hy
      rcases hy with rfl | rfl | rfl <;> omega
  | case4 a b c t ih =>
      intro h y hy
      have ha := h a (by simp)
      have hb := h b (by simp)
      have hc := h c (by simp)
      simp only [encSix, List.mem_cons] at hy
      rcases hy with rfl | rfl | rfl | rfl | hy
      · omega
      · omega
      · omega
      · omega
      · exact ih (fun x hx => h x (by simp [hx])) y hy

/-- A payload is as long as base64 without padding: `⌈4n/3⌉` characters. -/
theorem length_encSix : ∀ l : List ℕ, (encSix l).length = (4 * l.length + 2) / 3 := by
  intro l
  induction l using encSix.induct with
  | case1 => rfl
  | case2 a => simp [encSix]
  | case3 a b => simp [encSix]
  | case4 a b c t ih => simp only [encSix, List.length_cons, ih]; omega

/-! ## base64url -/

/-- `bytesToB64url`: bytes to the characters of a payload. -/
def encode (bs : List ℕ) : List Char := (encSix bs).map encChar

/-- `b64urlToBytes`, total: characters back to bytes, refusing anything that is
not a payload. -/
def decode (s : List Char) : Option (List ℕ) := (s.mapM decChar).bind decSix

theorem mapM_decChar_map_encChar :
    ∀ ns : List ℕ, (∀ n ∈ ns, n < 64) → (ns.map encChar).mapM decChar = some ns := by
  intro ns
  induction ns with
  | nil => intro _; rfl
  | cons n ns ih =>
      intro h
      have hn := decChar_encChar (h n (by simp))
      have hrest := ih (fun m hm => h m (by simp [hm]))
      simp [List.mapM_cons, hn, hrest]

/-- **The payload of a share link is lossless**: decoding what was encoded
returns the original bytes. -/
theorem decode_encode (bs : List ℕ) (h : ∀ x ∈ bs, x < 256) : decode (encode bs) = some bs := by
  have := mapM_decChar_map_encChar (encSix bs) (encSix_lt bs h)
  simp [decode, encode, this, decSix_encSix bs h]

/-- **A payload is URL-safe**: it consists of alphabet characters only. -/
theorem encode_mem_alphabet (bs : List ℕ) (h : ∀ x ∈ bs, x < 256) :
    ∀ c ∈ encode bs, c ∈ alphabet := by
  intro c hc
  obtain ⟨n, hn, rfl⟩ := List.mem_map.1 hc
  exact encChar_mem_alphabet (encSix_lt bs h n hn)

theorem encode_no_amp (bs : List ℕ) (h : ∀ x ∈ bs, x < 256) : '&' ∉ encode bs := by
  intro hmem
  exact alphabet_url_safe.1 (encode_mem_alphabet bs h '&' hmem)

/-! ## The tagged fragment

`toFragment` deflates when it can and when deflating helps, and tags the result
`z`; otherwise it tags the plain bytes `u`.  The browser's compressor is not
modelled — it is a parameter here, together with the only property the studio
relies on: inflating what was deflated gives the bytes back. -/

/-- `toFragment`, with the browser's raw-deflate as a parameter (`none` when
the browser has no `CompressionStream`). -/
def toFrag (deflate : List ℕ → Option (List ℕ)) (bs : List ℕ) : List Char :=
  match deflate bs with
  | some z => if z.length < bs.length then 'z' :: encode z else 'u' :: encode bs
  | none => 'u' :: encode bs

/-- `fromFragment`, with the browser's raw-inflate as a parameter. -/
def fromFrag (inflate : List ℕ → Option (List ℕ)) : List Char → Option (List ℕ)
  | 'z' :: r => (decode r).bind inflate
  | 'u' :: r => decode r
  | _ => none

/-- **A fragment carries the playbook unchanged**, whichever branch it took:
provided the browser's inflate undoes its deflate, reading the fragment back
gives exactly the bytes it was made from. -/
theorem fromFrag_toFrag {deflate inflate : List ℕ → Option (List ℕ)} (bs : List ℕ)
    (hbs : ∀ x ∈ bs, x < 256)
    (hbytes : ∀ z, deflate bs = some z → ∀ x ∈ z, x < 256)
    (hinv : ∀ z, deflate bs = some z → inflate z = some bs) :
    fromFrag inflate (toFrag deflate bs) = some bs := by
  unfold toFrag
  cases hd : deflate bs with
  | none => simpa [fromFrag] using decode_encode bs hbs
  | some z =>
      by_cases hlen : z.length < bs.length
      · simp only [hlen, if_true]
        simp [fromFrag, decode_encode z (hbytes z hd), hinv z hd]
      · simp only [hlen, if_false]
        simpa [fromFrag] using decode_encode bs hbs

/-! ## The fragment grammar

A link is `#p=<payload>&t=…&ui=…`: `&`-separated fields, of which `p` carries
the playbook.  Since a payload contains no `&`, the field is read back
whole. -/

/-- Split on `&`, the way `parseHash` does. -/
def splitAmp : List Char → List (List Char)
  | [] => [[]]
  | c :: t =>
      if c = '&' then [] :: splitAmp t
      else (c :: (splitAmp t).headD []) :: (splitAmp t).tail

theorem splitAmp_of_not_mem : ∀ l : List Char, '&' ∉ l → splitAmp l = [l] := by
  intro l
  induction l with
  | nil => intro _; rfl
  | cons c t ih =>
      intro h
      have hc : c ≠ '&' := fun hc => h (by simp [hc])
      have ht : '&' ∉ t := fun ht => h (by simp [ht])
      simp [splitAmp, hc, ih ht]

theorem splitAmp_append (opts : List Char) :
    ∀ l : List Char, '&' ∉ l → splitAmp (l ++ '&' :: opts) = l :: splitAmp opts := by
  intro l
  induction l with
  | nil => intro _; simp [splitAmp]
  | cons c t ih =>
      intro h
      have hc : c ≠ '&' := fun hc => h (by simp [hc])
      have ht : '&' ∉ t := fun ht => h (by simp [ht])
      simp [splitAmp, hc, ih ht]

/-- The `p=…` field of a fragment. -/
def readP (h : List Char) : Option (List Char) :=
  let body := match h with | '#' :: t => t | _ => h
  (splitAmp body).findSome? fun part =>
    match part with
    | 'p' :: '=' :: rest => some rest
    | _ => none

/-- The link the share dialog writes: the payload in the `p` field, followed by
the presentation options. -/
def hashOf (payload : List Char) (opts : List Char) : List Char :=
  '#' :: 'p' :: '=' :: (payload ++ if opts = [] then [] else '&' :: opts)

theorem readP_hashOf (payload opts : List Char) (h : '&' ∉ payload) :
    readP (hashOf payload opts) = some payload := by
  by_cases ho : opts = []
  · have hn : '&' ∉ 'p' :: '=' :: payload := by
      simp only [List.mem_cons, not_or]
      exact ⟨by decide, by decide, h⟩
    simp [readP, hashOf, ho, splitAmp_of_not_mem _ hn]
  · have hsplit : splitAmp ('p' :: '=' :: (payload ++ '&' :: opts))
        = ('p' :: '=' :: payload) :: splitAmp opts := by
      have := splitAmp_append opts ('p' :: '=' :: payload) (by
        simp only [List.mem_cons, not_or]
        exact ⟨by decide, by decide, h⟩)
      simpa using this
    simp [readP, hashOf, ho, hsplit]

/-- **A share link reproduces the playbook it was made from**: what the studio
writes into the address bar is read back — the `p` field is found among the
options, its payload is decoded, and the browser's inflate (when the link took
the compressed branch) returns the original bytes. -/
theorem share_roundtrip {deflate inflate : List ℕ → Option (List ℕ)} (bs : List ℕ)
    (opts : List Char)
    (hbs : ∀ x ∈ bs, x < 256)
    (hbytes : ∀ z, deflate bs = some z → ∀ x ∈ z, x < 256)
    (hinv : ∀ z, deflate bs = some z → inflate z = some bs) :
    (readP (hashOf (toFrag deflate bs) opts)).bind (fromFrag inflate) = some bs := by
  have hamp : '&' ∉ toFrag deflate bs := by
    unfold toFrag
    cases hd : deflate bs with
    | none =>
        simp only [List.mem_cons, not_or]
        exact ⟨by decide, encode_no_amp bs hbs⟩
    | some z =>
        by_cases hlen : z.length < bs.length
        · simp only [hlen, if_true, List.mem_cons, not_or]
          exact ⟨by decide, encode_no_amp z (hbytes z hd)⟩
        · simp only [hlen, if_false, List.mem_cons, not_or]
          exact ⟨by decide, encode_no_amp bs hbs⟩
  rw [readP_hashOf _ _ hamp]
  simpa using fromFrag_toFrag bs hbs hbytes hinv

end Hesper.Share
