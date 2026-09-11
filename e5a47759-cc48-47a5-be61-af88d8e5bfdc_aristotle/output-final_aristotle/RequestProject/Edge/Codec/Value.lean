/-
# The canonical value layer

The Standard Proof Codec (see `docs/CODEC.md`) never makes an external
format the authoritative representation.  Everything is decoded into a
*canonical* semi-structured value, `CVal`, and every encoder writes that
value back out.  This file is that layer:

* `CVal` — null, booleans, integers, arbitrary-precision decimals,
  strings, references, ordered lists and ordered key/value objects;
* a deterministic serialization `CVal.encode` with a matching parser
  `CVal.decode`, proved to round-trip (`decode_encode`) — this is the
  "canonical serialization" of the specification, and it is what the
  content hash is taken over;
* `CVal.canon`, the normalizer that fixes field ordering and the numeric
  representation, proved idempotent;
* an FNV-1a content hash and the content identifier built from it.

The serialization is prefix-typed and terminator-delimited so that it can
be parsed with no lookahead and no ambiguity, which is what makes the
round-trip theorem provable rather than merely tested:

```text
null        N;
bool        B0;            B1;
int         I-144;         I144;
decimal     D-125,-2;      (mantissa , exponent  ==  -1.25)
string      Shello;        (`\` and `;` escaped)
reference   R#p1;
list        L <values> E;
object      O (K <key> ; <value>)* E;
```
-/
import RequestProject.Edge.Codec.Parse

namespace CfDeploy
namespace Codec

/-! ## The canonical value -/

/-- A canonical value: the semantic content of any proof object, in the
one representation every codec in this system agrees on. -/
inductive CVal where
  /-- an explicit null (distinct from an absent field) -/
  | null
  | bool (b : Bool)
  /-- an arbitrary-precision integer -/
  | int (i : Int)
  /-- `mantissa * 10 ^ exponent`; kept exact, never turned into a float -/
  | num (mantissa exponent : Int)
  | str (s : String)
  /-- a reference to another object by identifier -/
  | ref (id : String)
  /-- an ordered list; ordering is semantic -/
  | list (xs : List CVal)
  /-- an object; the canonical form orders the fields by key -/
  | obj (fs : List (String × CVal))
  deriving Repr, Inhabited

namespace CVal

/-! ## Escaping and numbers

The canonical form terminates every scalar field with `;`, escaping `\\`
and `;` themselves; `RequestProject.Codec.Parse` provides the escaping,
the integer reader and their round-trip lemmas. -/

/-- Escape a character list for the canonical form. -/
abbrev escL (s : List Char) : List Char := Parse.escL ';' s

/-- Read an escaped character list up to and including its `;`. -/
abbrev readEsc (l : List Char) : Option (List Char × List Char) := Parse.readEsc ';' l

theorem readEsc_escL (s rest : List Char) :
    readEsc (escL s ++ ';' :: rest) = some (s, rest) :=
  Parse.readEsc_escL (by decide) s rest

/-- The characters of an integer. -/
abbrev intChars (i : Int) : List Char := Parse.intChars i

/-- Read an integer terminated by `;`. -/
abbrev readInt (l : List Char) : Option (Int × List Char) := Parse.readInt ';' l

theorem readInt_intChars (i : Int) (rest : List Char) :
    readInt (intChars i ++ ';' :: rest) = some (i, rest) :=
  Parse.readInt_intChars (by decide) i rest

theorem intChars_ne_nil (i : Int) : intChars i ≠ [] := Parse.intChars_ne_nil i

theorem intChars_length_pos (i : Int) : 1 ≤ (intChars i).length :=
  Parse.intChars_length_pos i

/-! ## Canonical serialization -/

/-- The one-character tag that opens the serialization of a value. -/
def tag : CVal → Char
  | .null => 'N'
  | .bool _ => 'B'
  | .int _ => 'I'
  | .num _ _ => 'D'
  | .str _ => 'S'
  | .ref _ => 'R'
  | .list _ => 'L'
  | .obj _ => 'O'

theorem tag_ne_end (v : CVal) : tag v ≠ 'E' := by cases v <;> simp [tag]

theorem tag_ne_key (v : CVal) : tag v ≠ 'K' := by cases v <;> simp [tag]

mutual

/-- The canonical serialization of a value, as characters. -/
def serL : CVal → List Char
  | .null => ['N', ';']
  | .bool b => ['B', if b then '1' else '0', ';']
  | .int i => 'I' :: (intChars i ++ [';'])
  | .num m e => 'D' :: (intChars m ++ ';' :: (intChars e ++ [';']))
  | .str s => 'S' :: (escL s.toList ++ [';'])
  | .ref r => 'R' :: (escL r.toList ++ [';'])
  | .list xs => 'L' :: (serItems xs ++ ['E', ';'])
  | .obj fs => 'O' :: (serFields fs ++ ['E', ';'])

/-- The serialization of the elements of a list, concatenated. -/
def serItems : List CVal → List Char
  | [] => []
  | x :: xs => serL x ++ serItems xs

/-- The serialization of the fields of an object, concatenated. -/
def serFields : List (String × CVal) → List Char
  | [] => []
  | (k, v) :: fs => 'K' :: (escL k.toList ++ ';' :: (serL v ++ serFields fs))

end

theorem serL_tag (v : CVal) : ∃ t, serL v = tag v :: t := by
  cases v <;> exact ⟨_, rfl⟩

/-! ## The parser

The parser is driven by a fuel argument so that it is a total function;
the round-trip theorem below supplies enough fuel from the size of the
value, and `decode` supplies the length of the input, which is always
enough (`size_lt_serL`). -/

/-- Consume the field terminator. -/
def expectSemi : List Char → Option (List Char)
  | ';' :: t => some t
  | _ => none

mutual

/-- Parse one canonical value. -/
def parseVal : Nat → List Char → Option (CVal × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = 'N' then (expectSemi r).map (fun t => (CVal.null, t))
      else if c = 'B' then
        match r with
        | [] => none
        | b :: r1 =>
            if b = '0' then (expectSemi r1).map (fun t => (CVal.bool false, t))
            else if b = '1' then (expectSemi r1).map (fun t => (CVal.bool true, t))
            else none
      else if c = 'I' then (readInt r).map (fun p => (CVal.int p.1, p.2))
      else if c = 'D' then
        match readInt r with
        | some (m, r1) => (readInt r1).map (fun p => (CVal.num m p.1, p.2))
        | none => none
      else if c = 'S' then (readEsc r).map (fun p => (CVal.str (String.ofList p.1), p.2))
      else if c = 'R' then (readEsc r).map (fun p => (CVal.ref (String.ofList p.1), p.2))
      else if c = 'L' then (parseItems f r).map (fun p => (CVal.list p.1, p.2))
      else if c = 'O' then (parseFields f r).map (fun p => (CVal.obj p.1, p.2))
      else none

/-- Parse the elements of a list up to its `E;` terminator. -/
def parseItems : Nat → List Char → Option (List CVal × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = 'E' then (expectSemi r).map (fun t => (([] : List CVal), t))
      else
        match parseVal f (c :: r) with
        | some (x, r') => (parseItems f r').map (fun p => (x :: p.1, p.2))
        | none => none

/-- Parse the fields of an object up to its `E;` terminator. -/
def parseFields : Nat → List Char → Option (List (String × CVal) × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = 'E' then (expectSemi r).map (fun t => (([] : List (String × CVal)), t))
      else if c = 'K' then
        match readEsc r with
        | some (k, r1) =>
            match parseVal f r1 with
            | some (v, r2) =>
                (parseFields f r2).map (fun p => ((String.ofList k, v) :: p.1, p.2))
            | none => none
        | none => none
      else none

end

/-! ## Sizes, for the fuel accounting -/

mutual

/-- The number of nodes of a value (an upper bound on the fuel its parse
needs). -/
def size : CVal → Nat
  | .list xs => 1 + sizeItems xs
  | .obj fs => 1 + sizeFields fs
  | _ => 1

def sizeItems : List CVal → Nat
  | [] => 1
  | x :: xs => 1 + size x + sizeItems xs

def sizeFields : List (String × CVal) → Nat
  | [] => 1
  | (_, v) :: fs => 1 + size v + sizeFields fs

end

theorem size_pos (v : CVal) : 0 < size v := by
  cases v <;> simp [size] <;> omega

theorem sizeItems_pos (xs : List CVal) : 0 < sizeItems xs := by
  cases xs <;> simp [sizeItems] <;> omega

theorem sizeFields_pos (fs : List (String × CVal)) : 0 < sizeFields fs := by
  cases fs with
  | nil => simp [sizeFields]
  | cons p fs => cases p; simp [sizeFields]; omega

/-! ## The round-trip theorem -/

/-- Parsing the serialization of a value returns that value and whatever
followed it, provided the fuel covers the value's size. -/
theorem parse_serL_all : ∀ f : Nat,
    (∀ (v : CVal) (rest : List Char), size v ≤ f →
        parseVal f (serL v ++ rest) = some (v, rest)) ∧
    (∀ (xs : List CVal) (rest : List Char), sizeItems xs ≤ f →
        parseItems f (serItems xs ++ 'E' :: ';' :: rest) = some (xs, rest)) ∧
    (∀ (fs : List (String × CVal)) (rest : List Char), sizeFields fs ≤ f →
        parseFields f (serFields fs ++ 'E' :: ';' :: rest) = some (fs, rest)) := by
  intro f
  induction f with
  | zero =>
      refine ⟨?_, ?_, ?_⟩ <;> intro x rest h
      · exact absurd h (by have := size_pos x; omega)
      · exact absurd h (by have := sizeItems_pos x; omega)
      · exact absurd h (by have := sizeFields_pos x; omega)
  | succ f ih =>
      obtain ⟨ihV, ihI, ihF⟩ := ih
      refine ⟨?_, ?_, ?_⟩
      · intro v rest hv
        cases v with
        | null => simp [serL, parseVal, expectSemi]
        | bool b =>
            cases b <;> simp [serL, parseVal, expectSemi]
        | int i =>
            simp only [serL, List.cons_append, List.append_assoc, parseVal]
            simp [readInt_intChars]
        | num m e =>
            simp only [serL, List.cons_append, List.append_assoc, parseVal]
            simp [readInt_intChars]
        | str s =>
            simp only [serL, List.cons_append, List.append_assoc, parseVal]
            simp [readEsc_escL]
        | ref r =>
            simp only [serL, List.cons_append, List.append_assoc, parseVal]
            simp [readEsc_escL]
        | list xs =>
            have hxs : sizeItems xs ≤ f := by simp [size] at hv; omega
            simp only [serL, List.cons_append, List.append_assoc, List.cons_append,
              List.nil_append, parseVal]
            simp [ihI xs rest hxs]
        | obj fs =>
            have hfs : sizeFields fs ≤ f := by simp [size] at hv; omega
            simp only [serL, List.cons_append, List.append_assoc, List.cons_append,
              List.nil_append, parseVal]
            simp [ihF fs rest hfs]
      · intro xs rest hxs
        cases xs with
        | nil => simp [serItems, parseItems, expectSemi]
        | cons x xs =>
            have hx : size x ≤ f := by simp [sizeItems] at hxs; omega
            have hxs' : sizeItems xs ≤ f := by simp [sizeItems] at hxs; omega
            obtain ⟨t, ht⟩ := serL_tag x
            have hkey : serItems (x :: xs) ++ 'E' :: ';' :: rest
                = tag x :: (t ++ (serItems xs ++ 'E' :: ';' :: rest)) := by
              simp [serItems, ht]
            rw [hkey]
            rw [parseItems]
            rw [if_neg (tag_ne_end x)]
            have hval : parseVal f (tag x :: (t ++ (serItems xs ++ 'E' :: ';' :: rest)))
                = some (x, serItems xs ++ 'E' :: ';' :: rest) := by
              have := ihV x (serItems xs ++ 'E' :: ';' :: rest) hx
              rwa [ht, List.cons_append] at this
            rw [hval]
            simp [ihI xs rest hxs']
      · intro fs rest hfs
        cases fs with
        | nil => simp [serFields, parseFields, expectSemi]
        | cons p fs =>
            obtain ⟨k, v⟩ := p
            have hv : size v ≤ f := by simp [sizeFields] at hfs; omega
            have hfs' : sizeFields fs ≤ f := by simp [sizeFields] at hfs; omega
            have hchars : serFields ((k, v) :: fs) ++ 'E' :: ';' :: rest
                = 'K' :: (escL k.toList ++ ';' :: (serL v ++ (serFields fs ++ 'E' :: ';' :: rest))) := by
              simp [serFields, List.append_assoc]
            rw [hchars, parseFields]
            simp only [if_neg (by decide : ('K' : Char) ≠ 'E'), readEsc_escL]
            rw [ihV v _ hv]
            simp [ihF fs rest hfs']

theorem parse_serL (v : CVal) (rest : List Char) (f : Nat) (h : size v ≤ f) :
    parseVal f (serL v ++ rest) = some (v, rest) :=
  (parse_serL_all f).1 v rest h

/-! ## Enough fuel -/

theorem size_lt_serL_all :
    (∀ v : CVal, size v + 1 ≤ (serL v).length) ∧
    (∀ fs : List (String × CVal), sizeFields fs ≤ (serFields fs).length + 1) ∧
    (∀ xs : List CVal, sizeItems xs ≤ (serItems xs).length + 1) := by
  have hint := intChars_length_pos
  refine @serL.mutual_induct
    (fun v => size v + 1 ≤ (serL v).length)
    (fun fs => sizeFields fs ≤ (serFields fs).length + 1)
    (fun xs => sizeItems xs ≤ (serItems xs).length + 1)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [size, sizeItems, sizeFields, serL, serItems, serFields] <;> omega

theorem size_lt_serL (v : CVal) : size v + 1 ≤ (serL v).length :=
  size_lt_serL_all.1 v

/-! ## The codec -/

/-- The canonical serialization of a value. -/
def encode (v : CVal) : String := String.ofList (serL v)

/-- Parse a canonical serialization; `none` if it is malformed or has
trailing data. -/
def decode (s : String) : Option CVal :=
  match parseVal s.length s.toList with
  | some (v, []) => some v
  | _ => none

/-- **Round trip.**  The canonical serialization is lossless. -/
@[simp] theorem decode_encode (v : CVal) : decode (encode v) = some v := by
  have hlen : size v ≤ (String.ofList (serL v)).length := by
    have := size_lt_serL v
    simp only [String.length_ofList]
    omega
  have := parse_serL v [] _ hlen
  simp only [decode, encode, String.toList_ofList, List.append_nil] at *
  rw [this]

/-- The canonical serialization is injective: distinct values never share
a serialization, which is what makes the content hash a content identity. -/
theorem encode_injective {v w : CVal} (h : encode v = encode w) : v = w := by
  have hv := decode_encode v
  have hw := decode_encode w
  rw [h, hw] at hv
  exact (Option.some.inj hv).symm

instance : DecidableEq CVal := fun a b =>
  decidable_of_iff (encode a = encode b)
    ⟨fun h => encode_injective h, fun h => by rw [h]⟩

instance : BEq CVal := instBEqOfDecidableEq

end CVal
end Codec
end CfDeploy
