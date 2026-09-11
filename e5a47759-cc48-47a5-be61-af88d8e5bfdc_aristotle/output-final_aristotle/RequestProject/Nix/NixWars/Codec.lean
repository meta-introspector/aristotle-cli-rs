import Mathlib

/-!
# Codecs: the algebraic core of the stego / modem link layer

Everything that travels between two browser tabs -- a URL fragment, a SLIP
frame, a PPP frame, a morse transmission, a numbers-station broadcast -- is a
`Codec`: an encoder together with a decoder that always recovers what was
encoded.

This file develops, once and for all:

* `Codec α β`, closed under identity, composition and `List`;
* delimiter-based framing (`Codec.delimited`), the generic "put a separator
  after every block" construction;
* positional numerals in an arbitrary radix, giving a codec from a list of
  natural numbers (a game state, say) to a stream of symbols `Sym r`;
* `tableCodec`, which renders symbols as characters, bytes, morse letters or
  spoken digits.

The concrete transports are built from these pieces in
`RequestProject.NixWars.Transports`.
-/

namespace NixWars

/-! ## Option-valued `map` -/

/-- `mapOption f xs` applies the partial function `f` to every element,
succeeding only if every application succeeds. -/
def mapOption {α β : Type} (f : α → Option β) : List α → Option (List β)
  | [] => some []
  | a :: as =>
    match f a with
    | none => none
    | some b =>
      match mapOption f as with
      | none => none
      | some bs => some (b :: bs)

@[simp] theorem mapOption_nil {α β : Type} (f : α → Option β) :
    mapOption f [] = some [] := rfl

theorem mapOption_cons {α β : Type} (f : α → Option β) (a : α) (as : List α) :
    mapOption f (a :: as) =
      match f a with
      | none => none
      | some b =>
        match mapOption f as with
        | none => none
        | some bs => some (b :: bs) := rfl

/-- If `f` inverts `g` pointwise then `mapOption f` inverts `List.map g`. -/
theorem mapOption_map {α β : Type} (f : β → Option α) (g : α → β)
    (h : ∀ a, f (g a) = some a) (as : List α) :
    mapOption f (as.map g) = some as := by
  induction as with
  | nil => rfl
  | cons a as ih => simp [mapOption_cons, h a, ih]

/-! ## Codecs -/

/-- A lossless encoding of `α` into `β`. -/
structure Codec (α : Type) (β : Type) where
  /-- Encode a value. -/
  encode : α → β
  /-- Attempt to decode a value; may fail on malformed input. -/
  decode : β → Option α
  /-- Decoding an encoded value always returns it unchanged. -/
  decode_encode : ∀ a, decode (encode a) = some a

namespace Codec

/-- The identity codec. -/
def refl (α : Type) : Codec α α where
  encode := fun a => a
  decode := fun a => some a
  decode_encode := fun _ => rfl

/-- Codecs compose: encode with the first, then with the second. -/
def comp {α β γ : Type} (c₁ : Codec α β) (c₂ : Codec β γ) : Codec α γ where
  encode := fun a => c₂.encode (c₁.encode a)
  decode := fun c =>
    match c₂.decode c with
    | none => none
    | some b => c₁.decode b
  decode_encode := fun a => by simp [c₂.decode_encode, c₁.decode_encode]

@[simp] theorem comp_encode {α β γ : Type} (c₁ : Codec α β) (c₂ : Codec β γ) (a : α) :
    (c₁.comp c₂).encode a = c₂.encode (c₁.encode a) := rfl

/-- An encoder is injective: distinct states never share a transmission. -/
theorem encode_injective {α β : Type} (c : Codec α β) {a a' : α}
    (h : c.encode a = c.encode a') : a = a' := by
  have h₁ : c.decode (c.encode a) = c.decode (c.encode a') := by rw [h]
  rw [c.decode_encode, c.decode_encode] at h₁
  exact Option.some.inj h₁

/-- Lift a codec to lists, elementwise. -/
def onList {α β : Type} (c : Codec α β) : Codec (List α) (List β) where
  encode := fun as => as.map c.encode
  decode := fun bs => mapOption c.decode bs
  decode_encode := fun as => mapOption_map _ _ c.decode_encode as

end Codec

/-! ## Framing by a delimiter -/

section Split

variable {S : Type} [DecidableEq S]

/-- Split a stream at every occurrence of the delimiter `g`. The result always
has one more block than there are delimiters. -/
def splitOnElem (g : S) : List S → List (List S)
  | [] => [[]]
  | c :: cs =>
    if c = g then [] :: splitOnElem g cs
    else
      match splitOnElem g cs with
      | [] => [[c]]
      | f :: fs => (c :: f) :: fs

theorem splitOnElem_ne_nil (g : S) (cs : List S) : splitOnElem g cs ≠ [] := by
  induction cs with
  | nil => simp [splitOnElem]
  | cons c cs ih =>
    rw [splitOnElem]
    split
    · simp
    · split <;> simp

theorem splitOnElem_append (g : S) (blk rest : List S) (hb : g ∉ blk) :
    splitOnElem g (blk ++ g :: rest) = blk :: splitOnElem g rest := by
  induction blk with
  | nil => simp [splitOnElem]
  | cons c blk ih =>
    have hc : c ≠ g := by intro h; exact hb (by simp [h])
    have hb' : g ∉ blk := fun h => hb (by simp [h])
    have hrec : splitOnElem g (blk ++ g :: rest) = blk :: splitOnElem g rest := ih hb'
    simp [splitOnElem, hc, hrec]

end Split

namespace Codec

variable {α S : Type} [DecidableEq S]

/-- **Framing.** Given a codec for single blocks whose encodings never contain
the delimiter `g`, encode a list of blocks by terminating each with `g`.
This is the shape shared by SLIP frames, morse letters, spoken digit groups and
`.`-separated URL fields. -/
def delimited (c : Codec α (List S)) (g : S) (hg : ∀ a, g ∉ c.encode a) :
    Codec (List α) (List S) where
  encode := fun as => as.flatMap (fun a => c.encode a ++ [g])
  decode := fun l => mapOption c.decode (splitOnElem g l).dropLast
  decode_encode := by
    intro as
    have hsplit : ∀ as : List α,
        splitOnElem g (as.flatMap (fun a => c.encode a ++ [g]))
          = as.map c.encode ++ [[]] := by
      intro as
      induction as with
      | nil => simp [splitOnElem]
      | cons a as ih =>
        have h : (a :: as).flatMap (fun a => c.encode a ++ [g])
            = c.encode a ++ g :: as.flatMap (fun a => c.encode a ++ [g]) := by
          simp [List.flatMap_cons]
        rw [h, splitOnElem_append g _ _ (hg a), ih]
        simp
    simp only [hsplit, List.dropLast_concat]
    exact mapOption_map _ _ c.decode_encode as

@[simp] theorem delimited_encode (c : Codec α (List S)) (g : S) (hg : ∀ a, g ∉ c.encode a)
    (as : List α) :
    (delimited c g hg).encode as = as.flatMap (fun a => c.encode a ++ [g]) := rfl

end Codec

/-! ## Symbols and positional numerals -/

/-- The symbols of a radix-`r` transmission: the digits `0, …, r-1` together
with one extra symbol, `Sym.sep`, used as the field delimiter. -/
abbrev Sym (r : Nat) := Fin (r + 1)

namespace Sym

/-- The delimiter symbol of a radix-`r` alphabet. -/
def sep (r : Nat) : Sym r := Fin.last r

/-- The symbol denoting the digit `d` (the delimiter if `d` is out of range). -/
def ofDigit (r d : Nat) : Sym r := if h : d < r then ⟨d, by omega⟩ else sep r

theorem ofDigit_ne_sep {r d : Nat} (h : d < r) : ofDigit r d ≠ sep r := by
  simp only [ofDigit, dif_pos h, sep, Fin.last]
  intro hc
  exact absurd (congrArg Fin.val hc) (by simpa using Nat.ne_of_lt h)

@[simp] theorem val_ofDigit {r d : Nat} (h : d < r) : (ofDigit r d).val = d := by
  simp [ofDigit, dif_pos h]

end Sym

/-- Little-endian digits of `n` in radix `r`. -/
def natToDigits (r n : Nat) : List Nat :=
  if _h : n < r ∨ r < 2 then [n] else n % r :: natToDigits r (n / r)
decreasing_by exact Nat.div_lt_self (by omega) (by omega)

/-- Value of a little-endian radix-`r` digit string. -/
def digitsToNat (r : Nat) : List Nat → Nat
  | [] => 0
  | d :: ds => d + r * digitsToNat r ds

theorem digitsToNat_natToDigits {r : Nat} (hr : 2 ≤ r) (n : Nat) :
    digitsToNat r (natToDigits r n) = n := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rw [natToDigits]
    by_cases h : n < r ∨ r < 2
    · rw [dif_pos h]
      simp [digitsToNat]
    · rw [dif_neg h]
      have hlt : n / r < n := Nat.div_lt_self (by omega) (by omega)
      simp only [digitsToNat, ih _ hlt]
      exact Nat.mod_add_div n r

theorem natToDigits_lt {r : Nat} (hr : 2 ≤ r) (n : Nat) :
    ∀ d ∈ natToDigits r n, d < r := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rw [natToDigits]
    by_cases h : n < r ∨ r < 2
    · rw [dif_pos h]
      intro d hd
      simp only [List.mem_singleton] at hd
      omega
    · rw [dif_neg h]
      have hlt : n / r < n := Nat.div_lt_self (by omega) (by omega)
      intro d hd
      rcases List.mem_cons.mp hd with h' | h'
      · subst h'; exact Nat.mod_lt _ (by omega)
      · exact ih _ hlt d h'

/-- A natural number as a stream of radix-`r` symbols. -/
def encodeNat (r n : Nat) : List (Sym r) := (natToDigits r n).map (Sym.ofDigit r)

/-- Read back a natural number from a stream of radix-`r` symbols. -/
def decodeNat (r : Nat) (l : List (Sym r)) : Nat := digitsToNat r (l.map Fin.val)

theorem decodeNat_encodeNat {r : Nat} (hr : 2 ≤ r) (n : Nat) :
    decodeNat r (encodeNat r n) = n := by
  have key : ∀ l : List Nat, (∀ d ∈ l, d < r) →
      ((l.map (Sym.ofDigit r)).map Fin.val) = l := by
    intro l hl
    induction l with
    | nil => rfl
    | cons d ds ih =>
      have hd : d < r := hl d (by simp)
      have hds : ∀ d' ∈ ds, d' < r := fun d' hd' => hl d' (by simp [hd'])
      simp [Sym.val_ofDigit hd, ih hds]
  rw [decodeNat, encodeNat, key _ (natToDigits_lt hr n), digitsToNat_natToDigits hr]

theorem sep_notMem_encodeNat {r : Nat} (hr : 2 ≤ r) (n : Nat) :
    Sym.sep r ∉ encodeNat r n := by
  intro hmem
  simp only [encodeNat, List.mem_map] at hmem
  obtain ⟨d, hd, hEq⟩ := hmem
  exact Sym.ofDigit_ne_sep (natToDigits_lt hr n d hd) hEq

/-- Numbers as radix-`r` symbol streams. -/
def natCodec (r : Nat) (hr : 2 ≤ r) : Codec Nat (List (Sym r)) where
  encode := encodeNat r
  decode := fun l => some (decodeNat r l)
  decode_encode := fun n => by rw [decodeNat_encodeNat hr]

/-- **The payload codec.** A list of natural numbers -- the serialized state of
a BBS door game -- as a delimited stream of radix-`r` symbols. -/
def fieldsCodec (r : Nat) (hr : 2 ≤ r) : Codec (List Nat) (List (Sym r)) :=
  Codec.delimited (natCodec r hr) (Sym.sep r) (sep_notMem_encodeNat hr)

/-! ## Rendering symbols -/

/-- Render symbols using a duplicate-free table: the `i`-th symbol becomes the
`i`-th table entry. -/
def tableCodec {X : Type} [DecidableEq X] [Inhabited X] {r : Nat} (tbl : List X)
    (hlen : tbl.length = r + 1) (hnd : tbl.Nodup) : Codec (Sym r) X where
  encode := fun s => tbl.getD s.val default
  decode := fun x => if h : tbl.idxOf x < r + 1 then some ⟨tbl.idxOf x, h⟩ else none
  decode_encode := by
    intro s
    have hs : s.val < tbl.length := by omega
    have hget : tbl.getD s.val default = tbl[s.val] := List.getD_eq_getElem tbl _ hs
    rw [hget]
    have hidx : tbl.idxOf tbl[s.val] = s.val := hnd.idxOf_getElem s.val hs
    rw [hidx]
    simp [Fin.is_lt s]

@[simp] theorem tableCodec_encode {X : Type} [DecidableEq X] [Inhabited X] {r : Nat} (tbl : List X)
    (hlen : tbl.length = r + 1) (hnd : tbl.Nodup) (s : Sym r) (hs : s.val < tbl.length) :
    (tableCodec tbl hlen hnd).encode s = tbl[s.val] :=
  List.getD_eq_getElem tbl _ hs

end NixWars
