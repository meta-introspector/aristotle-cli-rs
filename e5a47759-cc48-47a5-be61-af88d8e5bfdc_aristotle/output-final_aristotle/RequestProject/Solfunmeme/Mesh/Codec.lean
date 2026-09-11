import RequestProject.Solfunmeme.Mesh.Post
import RequestProject.Solfunmeme.Meme.Proofs.Share
import RequestProject.Solfunmeme.Onchain.Proofs.Base58

/-!
# Cards: a signed market view as a string, a URL and a set of QR fragments

A **card** is a signed post packed into bytes and rendered as base-58 text —
the same alphabet Solana uses, so it survives a URL fragment, a QR code, a chat
message and the low bits of a meme (`Mesh.Skin`) without escaping.

The point of this file is one theorem repeated at every layer: what you share
is what the other side reads back.

* `decodeCard_encodeCard` — the byte format round trips;
* `ofCode_toCode` — so does the text;
* `ofUrl_toUrl` — so does a link, and the fragment is recovered from any
  `#`-free base URL, meaning the same card works on any static host;
* `assemble_fragments` — a card too long for one QR code splits into numbered
  fragments that reassemble exactly, and `assemble_eq_none_of_missing` shows a
  set with a fragment missing is rejected rather than silently truncated.

Together with `Mesh.Post.message_injective` this is what lets a stranger import
a quote, re-derive its chart, check its signatures offline and co-sign it.
-/

namespace Mesh.Codec

open Meme.Share (natToLE8 leToNat)

/-! ## ASCII strings on the wire -/

/-- The wire is byte oriented, so the strings in a card must be ASCII.  Every
field the game generates — base-58 keys, base-58 signatures, digests — already
is; a title is checked. -/
def asciiB (s : String) : Bool := s.toList.all (fun c => c.toNat < 128)

/-- A string is ASCII. -/
def Ascii (s : String) : Prop := asciiB s = true

instance (s : String) : Decidable (Ascii s) := inferInstanceAs (Decidable (asciiB s = true))

theorem ascii_mem {s : String} (h : Ascii s) : ∀ c ∈ s.toList, c.toNat < 128 := by
  intro c hc
  simpa using (List.all_eq_true.mp h) c hc

/-- ASCII bytes of a string. -/
def asciiBytes (s : String) : List UInt8 := s.toList.map (fun c => UInt8.ofNat c.toNat)

/-- The string of a list of ASCII bytes. -/
def asciiString (bs : List UInt8) : String := String.ofList (bs.map (fun b => Char.ofNat b.toNat))

@[simp] theorem asciiBytes_length (s : String) : (asciiBytes s).length = s.toList.length := by
  simp [asciiBytes]

theorem asciiString_asciiBytes {s : String} (h : Ascii s) : asciiString (asciiBytes s) = s := by
  have key : ∀ c ∈ s.toList,
      ((fun b : UInt8 => Char.ofNat b.toNat) ∘ fun c : Char => UInt8.ofNat c.toNat) c = c := by
    intro c hc
    have hlt : c.toNat < 128 := ascii_mem h c hc
    have h2 : (UInt8.ofNat c.toNat).toNat = c.toNat := by
      simp [Nat.mod_eq_of_lt (by omega : c.toNat < 256)]
    simp only [Function.comp_apply, h2, Char.ofNat_toNat]
  simp only [asciiString, asciiBytes, List.map_map]
  rw [List.map_congr_left key]
  simp

/-! ## Readers -/

/-- A reader consumes a prefix of the byte string and returns the rest. -/
abbrev R (α : Type) := List UInt8 → Option (α × List UInt8)

/-- Read one little-endian 64-bit number. -/
def readNat : R Nat := fun bs =>
  if 8 ≤ bs.length then some (leToNat (bs.take 8), bs.drop 8) else none

theorem readNat_append {n : Nat} (hn : n < Meme.Share.bound) (rest : List UInt8) :
    readNat (natToLE8 n ++ rest) = some (n, rest) := by
  have hlen : (natToLE8 n).length = 8 := Meme.Share.natToLE8_length n
  simp only [readNat, List.length_append, hlen]
  rw [if_pos (by omega), List.take_append_of_le_length (by omega),
    List.take_of_length_le (by omega), List.drop_append_of_le_length (by omega),
    List.drop_of_length_le (by omega), List.nil_append,
    Meme.Share.leToNat_natToLE8 hn]

/-- Read `n` raw bytes. -/
def readBytes (n : Nat) : R (List UInt8) := fun bs =>
  if n ≤ bs.length then some (bs.take n, bs.drop n) else none

theorem readBytes_append (b rest : List UInt8) :
    readBytes b.length (b ++ rest) = some (b, rest) := by
  simp only [readBytes, List.length_append]
  rw [if_pos (by omega), List.take_append_of_le_length (by omega),
    List.take_of_length_le (by omega), List.drop_append_of_le_length (by omega),
    List.drop_of_length_le (by omega), List.nil_append]

/-- A length-prefixed ASCII string. -/
def frameStr (s : String) : List UInt8 := natToLE8 (asciiBytes s).length ++ asciiBytes s

/-- Read a length-prefixed ASCII string. -/
def readStr : R String := fun bs => do
  let (n, r) ← readNat bs
  let (b, r') ← readBytes n r
  pure (asciiString b, r')

/-- A string is *shareable* when it is ASCII and short enough to frame. -/
def strWfB (s : String) : Bool := asciiB s && s.toList.length < Meme.Share.bound

/-- A shareable string. -/
def StrWf (s : String) : Prop := strWfB s = true

instance (s : String) : Decidable (StrWf s) := inferInstanceAs (Decidable (strWfB s = true))

theorem StrWf.ascii {s : String} (h : StrWf s) : Ascii s :=
  (Bool.and_eq_true _ _ |>.mp h).1

theorem StrWf.len {s : String} (h : StrWf s) : s.toList.length < Meme.Share.bound := by
  simpa using (Bool.and_eq_true _ _ |>.mp h).2

theorem readStr_append {s : String} (h : StrWf s) (rest : List UInt8) :
    readStr (frameStr s ++ rest) = some (s, rest) := by
  have hlen : (asciiBytes s).length < Meme.Share.bound := by simpa using h.len
  simp only [readStr, frameStr, List.append_assoc]
  rw [readNat_append hlen]
  simp only [Option.bind_eq_bind, Option.bind_some]
  rw [readBytes_append]
  simp [asciiString_asciiBytes h.ascii]

/-- Read a fixed number of items. -/
def readList {α : Type} (f : R α) : Nat → R (List α)
  | 0, bs => some ([], bs)
  | k + 1, bs => do
      let (a, r) ← f bs
      let (l, r') ← readList f k r
      pure (a :: l, r')

theorem readList_append {α : Type} {f : R α} {enc : α → List UInt8} {l : List α}
    (h : ∀ a ∈ l, ∀ rest, f (enc a ++ rest) = some (a, rest)) (rest : List UInt8) :
    readList f l.length (l.flatMap enc ++ rest) = some (l, rest) := by
  induction l with
  | nil => simp [readList]
  | cons a t ih =>
    simp only [List.flatMap_cons, List.length_cons, readList, List.append_assoc]
    rw [h a (by simp) _]
    simp only [Option.bind_eq_bind, Option.bind_some]
    rw [ih (fun b hb => h b (by simp [hb]))]
    simp

/-- A length-prefixed list. -/
def frameList {α : Type} (enc : α → List UInt8) (l : List α) : List UInt8 :=
  natToLE8 l.length ++ l.flatMap enc

/-- Read a length-prefixed list. -/
def readVec {α : Type} (f : R α) : R (List α) := fun bs => do
  let (n, r) ← readNat bs
  readList f n r

theorem readVec_append {α : Type} {f : R α} {enc : α → List UInt8} {l : List α}
    (hlen : l.length < Meme.Share.bound)
    (h : ∀ a ∈ l, ∀ rest, f (enc a ++ rest) = some (a, rest)) (rest : List UInt8) :
    readVec f (frameList enc l ++ rest) = some (l, rest) := by
  simp only [readVec, frameList, List.append_assoc]
  rw [readNat_append hlen]
  simpa using readList_append h rest

/-! ## The card format -/

/-- A quote, as forty bytes. -/
def encQuote (q : Quote) : List UInt8 :=
  natToLE8 q.token ++ natToLE8 q.venue ++ natToLE8 q.slot ++ natToLE8 q.price ++ natToLE8 q.size

/-- Read a quote. -/
def readQuote : R Quote := fun bs => do
  let (t, r1) ← readNat bs
  let (v, r2) ← readNat r1
  let (s, r3) ← readNat r2
  let (p, r4) ← readNat r3
  let (z, r5) ← readNat r4
  pure ({ token := t, venue := v, slot := s, price := p, size := z }, r5)

theorem readQuote_append {q : Quote} (h : q.wf = true) (rest : List UInt8) :
    readQuote (encQuote q ++ rest) = some (q, rest) := by
  simp only [Quote.wf, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩ := h
  have hb : Meme.Share.bound = bound := rfl
  simp only [readQuote, encQuote, List.append_assoc]
  rw [readNat_append (hb ▸ h1)]
  simp only [Option.bind_eq_bind, Option.bind_some]
  rw [readNat_append (hb ▸ h2)]
  simp only [Option.bind_some]
  rw [readNat_append (hb ▸ h3)]
  simp only [Option.bind_some]
  rw [readNat_append (hb ▸ h4)]
  simp only [Option.bind_some]
  rw [readNat_append (hb ▸ h5)]
  cases q; rfl

/-- An endorsement: signer key and signature. -/
def encEndorsement (e : Endorsement) : List UInt8 := frameStr e.signer ++ frameStr e.sig

/-- Read an endorsement. -/
def readEndorsement : R Endorsement := fun bs => do
  let (k, r1) ← readStr bs
  let (s, r2) ← readStr r1
  pure ({ signer := k, sig := s }, r2)

theorem readEndorsement_append {e : Endorsement} (hk : StrWf e.signer) (hs : StrWf e.sig)
    (rest : List UInt8) : readEndorsement (encEndorsement e ++ rest) = some (e, rest) := by
  simp only [readEndorsement, encEndorsement, List.append_assoc]
  rw [readStr_append hk]
  simp only [Option.bind_eq_bind, Option.bind_some]
  rw [readStr_append hs]
  cases e; rfl

/-- A view. -/
def encView (v : View) : List UInt8 :=
  frameStr v.title ++ natToLE8 v.token ++ natToLE8 v.fromSlot ++ natToLE8 v.toSlot ++
    frameList encQuote v.quotes

/-- Read a view. -/
def readView : R View := fun bs => do
  let (t, r1) ← readStr bs
  let (k, r2) ← readNat r1
  let (f, r3) ← readNat r2
  let (o, r4) ← readNat r3
  let (qs, r5) ← readVec readQuote r4
  pure ({ title := t, token := k, fromSlot := f, toSlot := o, quotes := qs }, r5)

/-- What a view must satisfy to be shareable. -/
def viewWfB (v : View) : Bool :=
  strWfB v.title && v.token < bound && v.fromSlot < bound && v.toSlot < bound &&
    v.quotes.length < bound && v.quotes.all Quote.wf

/-- A shareable view. -/
def ViewWf (v : View) : Prop := viewWfB v = true

instance (v : View) : Decidable (ViewWf v) := inferInstanceAs (Decidable (viewWfB v = true))

theorem viewWf_parts {v : View} (h : ViewWf v) :
    StrWf v.title ∧ v.token < bound ∧ v.fromSlot < bound ∧ v.toSlot < bound ∧
      v.quotes.length < bound ∧ ∀ q ∈ v.quotes, q.wf = true := by
  simp only [ViewWf, viewWfB, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true] at h
  exact ⟨h.1.1.1.1.1, h.1.1.1.1.2, h.1.1.1.2, h.1.1.2, h.1.2, h.2⟩

theorem readView_append {v : View} (h : ViewWf v) (rest : List UInt8) :
    readView (encView v ++ rest) = some (v, rest) := by
  obtain ⟨ht, hk, hf, ho, hn, hq⟩ := viewWf_parts h
  have hb : Meme.Share.bound = bound := rfl
  simp only [readView, encView, List.append_assoc]
  rw [readStr_append ht]
  simp only [Option.bind_eq_bind, Option.bind_some]
  rw [readNat_append (hb ▸ hk)]
  simp only [Option.bind_some]
  rw [readNat_append (hb ▸ hf)]
  simp only [Option.bind_some]
  rw [readNat_append (hb ▸ ho)]
  simp only [Option.bind_some]
  rw [readVec_append (enc := encQuote) (hb ▸ hn) (fun q hq' rest' => readQuote_append (hq q hq') rest')]
  cases v; rfl

/-- A signed post, as bytes. -/
def encCard (sp : SignedPost) : List UInt8 :=
  frameStr sp.post.author ++ natToLE8 sp.post.seq ++ natToLE8 sp.post.time ++
    frameList frameStr sp.post.imports ++ encView sp.post.view ++
    frameList encEndorsement sp.sigs

/-- Read a signed post. -/
def readCard : R SignedPost := fun bs => do
  let (a, r1) ← readStr bs
  let (n, r2) ← readNat r1
  let (t, r3) ← readNat r2
  let (imp, r4) ← readVec readStr r3
  let (v, r5) ← readView r4
  let (sg, r6) ← readVec readEndorsement r5
  pure ({ post := { author := a, seq := n, time := t, imports := imp, view := v },
          sigs := sg }, r6)

/-- What a card must satisfy to be shareable: ASCII strings, 64-bit numbers. -/
def cardWfB (sp : SignedPost) : Bool :=
  strWfB sp.post.author && sp.post.seq < bound && sp.post.time < bound &&
    sp.post.imports.length < bound && sp.post.imports.all strWfB &&
    viewWfB sp.post.view && sp.sigs.length < bound &&
    sp.sigs.all (fun e => strWfB e.signer && strWfB e.sig)

/-- A shareable card. -/
def CardWf (sp : SignedPost) : Prop := cardWfB sp = true

instance (sp : SignedPost) : Decidable (CardWf sp) :=
  inferInstanceAs (Decidable (cardWfB sp = true))

theorem cardWf_parts {sp : SignedPost} (h : CardWf sp) :
    StrWf sp.post.author ∧ sp.post.seq < bound ∧ sp.post.time < bound ∧
      sp.post.imports.length < bound ∧ (∀ s ∈ sp.post.imports, StrWf s) ∧
      ViewWf sp.post.view ∧ sp.sigs.length < bound ∧
      (∀ e ∈ sp.sigs, StrWf e.signer ∧ StrWf e.sig) := by
  simp only [CardWf, cardWfB, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true,
    StrWf, ViewWf] at h ⊢
  exact ⟨h.1.1.1.1.1.1.1, h.1.1.1.1.1.1.2, h.1.1.1.1.1.2, h.1.1.1.1.2, h.1.1.1.2,
    h.1.1.2, h.1.2, fun e he => h.2 e he⟩

/-- **The byte format round trips.** -/
theorem decodeCard_encodeCard {sp : SignedPost} (hwf : CardWf sp) (rest : List UInt8) :
    readCard (encCard sp ++ rest) = some (sp, rest) := by
  obtain ⟨hauthor, hseq, htime, himpLen, himpWf, hview, hsigLen, hsigWf⟩ := cardWf_parts hwf
  have hb : Meme.Share.bound = bound := rfl
  simp only [readCard, encCard, List.append_assoc]
  rw [readStr_append hauthor]
  simp only [Option.bind_eq_bind, Option.bind_some]
  rw [readNat_append (hb ▸ hseq)]
  simp only [Option.bind_some]
  rw [readNat_append (hb ▸ htime)]
  simp only [Option.bind_some]
  rw [readVec_append (enc := frameStr) (hb ▸ himpLen)
    (fun s hs rest' => readStr_append (himpWf s hs) rest')]
  simp only [Option.bind_some]
  rw [readView_append hview]
  simp only [Option.bind_some]
  rw [readVec_append (enc := encEndorsement) (hb ▸ hsigLen)
    (fun e he rest' => readEndorsement_append (hsigWf e he).1 (hsigWf e he).2 rest')]
  obtain ⟨⟨a, n, t, imp, v⟩, sg⟩ := sp
  rfl

/-! ## Text, links and QR fragments -/

/-- The card as base-58 text. -/
def toCode (sp : SignedPost) : String := Solana.Base58.encode (encCard sp)

/-- Parse a card from base-58 text. -/
def ofCode (s : String) : Option SignedPost := do
  let bs ← Solana.Base58.decode s
  let (sp, _) ← readCard bs
  pure sp

/-- **The text round trips.** -/
theorem ofCode_toCode {sp : SignedPost} (h : CardWf sp) : ofCode (toCode sp) = some sp := by
  simp [ofCode, toCode, Solana.Base58.decode_encode,
    show readCard (encCard sp) = some (sp, []) by
      simpa using decodeCard_encodeCard h []]

/-- A shareable link: any static base plus the card in the fragment.  The host
never sees the fragment, so a card can be shared through a page that does not
hold it. -/
def toUrl (base : String) (sp : SignedPost) : String := base ++ "#" ++ toCode sp

/-- The fragment of a URL: everything after the first `#`. -/
def fragment (u : String) : String :=
  String.ofList ((u.toList.dropWhile (fun c => c ≠ '#')).drop 1)

theorem dropWhile_ne_hash {b : List Char} (hb : '#' ∉ b) (u : List Char) :
    (b ++ u).dropWhile (fun c => c ≠ '#') = u.dropWhile (fun c => c ≠ '#') := by
  induction b with
  | nil => simp
  | cons c t ih =>
    have ht : '#' ∉ t := fun h => hb (List.mem_cons_of_mem _ h)
    have hcne : c ≠ '#' := fun h => hb (by simp [h])
    rw [List.cons_append, List.dropWhile_cons, if_pos (by simpa using hcne)]
    exact ih ht

theorem valueChar_mem {d : Nat} (hd : d < 58) :
    Solana.Base58.valueChar d ∈ Solana.Base58.alphabetList := by
  have hlen : d < Solana.Base58.alphabetList.length := by
    rw [Solana.Base58.alphabetList_length]; exact hd
  simp only [Solana.Base58.valueChar, List.getElem?_eq_getElem hlen, Option.getD_some]
  exact List.getElem_mem hlen

/-- A base-58 code never contains a `#`. -/
theorem base58_no_hash (bs : List UInt8) : '#' ∉ (Solana.Base58.encode bs).toList := by
  rw [Solana.Base58.encode_eq]
  simp only [String.toList_ofList, List.mem_append, not_or]
  refine ⟨?_, ?_⟩
  · intro h
    have := List.eq_of_mem_replicate h
    simp at this
  · intro h
    obtain ⟨d, hd, hdc⟩ := List.mem_map.mp h
    have hlt : d < 58 := Solana.Digits.digitsBE_lt 58 (by norm_num) _ d hd
    have hmem := valueChar_mem hlt
    rw [hdc] at hmem
    revert hmem
    decide

/-- **A link round trips**, from any base URL that carries no fragment of its
own. -/
theorem ofUrl_toUrl {base : String} (hbase : '#' ∉ base.toList) {sp : SignedPost}
    (h : CardWf sp) : ofCode (fragment (toUrl base sp)) = some sp := by
  have hfrag : fragment (toUrl base sp) = toCode sp := by
    simp only [fragment, toUrl, toCode]
    rw [show (base ++ "#" ++ Solana.Base58.encode (encCard sp)).toList
        = base.toList ++ ('#' :: (Solana.Base58.encode (encCard sp)).toList) by
          simp [show "#".toList = ['#'] from rfl],
      dropWhile_ne_hash hbase]
    simp
  rw [hfrag, ofCode_toCode h]

/-! ### QR fragments -/

/-- Split a list into pieces of at most `k`. -/
def splitEvery {α : Type} (k : Nat) : List α → List (List α)
  | [] => []
  | x :: xs =>
      if k = 0 then [x :: xs]
      else (x :: xs).take k :: splitEvery k ((x :: xs).drop k)
  termination_by l => l.length
  decreasing_by
    simp only [List.length_drop, List.length_cons]
    omega

theorem flatten_splitEvery {α : Type} {k : Nat} (hk : 0 < k) (l : List α) :
    (splitEvery k l).flatten = l := by
  induction l using splitEvery.induct k with
  | case1 => simp [splitEvery]
  | case2 x xs h => omega
  | case3 x xs _ ih =>
    rw [splitEvery]
    simp only [if_neg (by omega : ¬ k = 0), List.flatten_cons, ih]
    exact List.take_append_drop k (x :: xs)

/-- One QR code's worth of a card. -/
structure Frag where
  /-- Position of this fragment, counting from zero. -/
  idx : Nat
  /-- How many fragments there are altogether. -/
  total : Nat
  /-- This fragment's slice of the code. -/
  body : String
  deriving DecidableEq, Repr, Inhabited

/-- Number the pieces of a cut-up card, starting at `i`. -/
def fragsFrom (total : Nat) : Nat → List (List Char) → List Frag
  | _, [] => []
  | i, p :: ps => { idx := i, total := total, body := String.ofList p } :: fragsFrom total (i + 1) ps

/-- Cut a card's text into numbered fragments, each small enough for a QR
code. -/
def fragments (k : Nat) (code : String) : List Frag :=
  let pieces := splitEvery k code.toList
  fragsFrom pieces.length 0 pieces

/-- The fragments are numbered `i, i+1, …` without a gap. -/
def indexedFrom : Nat → List Frag → Bool
  | _, [] => true
  | i, f :: fs => (f.idx == i) && indexedFrom (i + 1) fs

/-- Put a set of fragments back together, refusing anything incomplete or out
of order. -/
def assemble (fs : List Frag) : Option String :=
  if fs.all (fun f => f.total == fs.length) && indexedFrom 0 fs
  then some (String.ofList (fs.flatMap (fun f => f.body.toList)))
  else none

@[simp] theorem fragsFrom_length (t i : Nat) (ps : List (List Char)) :
    (fragsFrom t i ps).length = ps.length := by
  induction ps generalizing i with
  | nil => simp [fragsFrom]
  | cons p ps ih => simp [fragsFrom, ih]

theorem fragsFrom_total (t i : Nat) (ps : List (List Char)) :
    ∀ f ∈ fragsFrom t i ps, f.total = t := by
  induction ps generalizing i with
  | nil => simp [fragsFrom]
  | cons p ps ih =>
    intro f hf
    rcases List.mem_cons.mp hf with rfl | hf'
    · rfl
    · exact ih (i + 1) f hf'

theorem indexedFrom_fragsFrom (t i : Nat) (ps : List (List Char)) :
    indexedFrom i (fragsFrom t i ps) = true := by
  induction ps generalizing i with
  | nil => simp [fragsFrom, indexedFrom]
  | cons p ps ih => simp [fragsFrom, indexedFrom, ih]

theorem fragsFrom_flatMap (t i : Nat) (ps : List (List Char)) :
    (fragsFrom t i ps).flatMap (fun f => f.body.toList) = ps.flatten := by
  induction ps generalizing i with
  | nil => simp [fragsFrom]
  | cons p ps ih => simp [fragsFrom, ih]

/-- **A card cut into QR codes reassembles.** -/
theorem assemble_fragments {k : Nat} (hk : 0 < k) (code : String) :
    assemble (fragments k code) = some code := by
  have hall : (fragments k code).all (fun f => f.total == (fragments k code).length) = true := by
    simp only [List.all_eq_true, fragments, fragsFrom_length, beq_iff_eq]
    exact fun f hf => fragsFrom_total _ 0 _ f hf
  have hord : indexedFrom 0 (fragments k code) = true := indexedFrom_fragsFrom _ 0 _
  have hbody : (fragments k code).flatMap (fun f => f.body.toList) = code.toList := by
    rw [fragments, fragsFrom_flatMap, flatten_splitEvery hk]
  rw [assemble, if_pos (by rw [hall, hord]; rfl), hbody]
  simp

/-- **An incomplete set of fragments is refused.**  If any fragment says the
card has a different number of pieces than are present, nothing is decoded —
so a truncated QR sequence cannot be mistaken for a shorter card. -/
theorem assemble_eq_none_of_missing {fs : List Frag} {f : Frag} (hf : f ∈ fs)
    (h : f.total ≠ fs.length) : assemble fs = none := by
  have hno : (fs.all (fun g => g.total == fs.length)) = false := by
    rw [Bool.eq_false_iff]
    intro hall
    exact h (by simpa using (List.all_eq_true.mp hall) f hf)
  simp [assemble, hno]

end Mesh.Codec
