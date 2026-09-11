/-
# The IPDL codec

IPDL — the Interchange Proof Description Language — is the native
structured interchange syntax of this codec: a parenthesised, explicitly
typed notation that carries identifiers, types, nesting, references,
annotations, metadata, proof relationships and errors without any
convention that a reader has to know in advance.

```text
(obj (field "id" (str "proof-001"))
     (field "inputs" (list (obj (field "name" (str "n"))
                                (field "value" (int 144)))))
     (field "status" (str "VALID")))
```

Every canonical constructor has its own form, so nothing has to be
guessed from context:

```text
(null)              (bool 1)          (int -144)
(dec 125 -2)        (str "text")      (ref "p1")
(list <value>*)     (obj (field "key" <value>)*)
```

Constructs a sender used that this schema does not know about arrive as
ordinary object fields and are preserved by the model layer's
`extensions`, never discarded.

`decode_encode` proves the adapter lossless in both directions of the
required round trip.
-/
import RequestProject.Edge.Codec.Value

namespace CfDeploy
namespace Codec
namespace Ipdl

open CVal (size sizeItems sizeFields size_pos sizeItems_pos sizeFields_pos)

/-! ## Writing -/

private def q : Char := '"'

/-- A quoted, backslash-escaped string. -/
def strChars (s : String) : List Char :=
  q :: (Parse.escL q s.toList ++ [q])

mutual

/-- The IPDL text of a canonical value, as characters. -/
def emit : CVal → List Char
  | .null => ['(', 'n', 'u', 'l', 'l', ')']
  | .bool b => if b then ['(', 'b', 'o', 'o', 'l', ' ', '1', ')'] else ['(', 'b', 'o', 'o', 'l', ' ', '0', ')']
  | .int i => ['(', 'i', 'n', 't', ' '] ++ Parse.intChars i ++ [')']
  | .num m e => ['(', 'd', 'e', 'c', ' '] ++ Parse.intChars m ++ ' ' :: Parse.intChars e ++ [')']
  | .str s => ['(', 's', 't', 'r', ' '] ++ strChars s ++ [')']
  | .ref r => ['(', 'r', 'e', 'f', ' '] ++ strChars r ++ [')']
  | .list xs => ['(', 'l', 'i', 's', 't'] ++ emitItems xs ++ [')']
  | .obj fs => ['(', 'o', 'b', 'j'] ++ emitFields fs ++ [')']

def emitItems : List CVal → List Char
  | [] => []
  | x :: xs => ' ' :: emit x ++ emitItems xs

def emitFields : List (String × CVal) → List Char
  | [] => []
  | (k, v) :: fs =>
      [' ', '(', 'f', 'i', 'e', 'l', 'd', ' '] ++ strChars k ++ ' ' :: emit v ++ ')' :: emitFields fs

end

/-! ## Reading -/

/-- Read a quoted, escaped string. -/
def readStr : List Char → Option (String × List Char)
  | c :: r =>
      if c = q then
        match Parse.readEsc q r with
        | some (s, r') => some (String.ofList s, r')
        | none => none
      else none
  | [] => none

theorem readStr_strChars (s : String) (rest : List Char) :
    readStr (strChars s ++ rest) = some (s, rest) := by
  simp only [strChars, List.cons_append, List.append_assoc, readStr,
    Parse.readEsc_escL (by decide : q ≠ '\\')]
  simp

/-- Consume a literal character. -/
def expect (c : Char) : List Char → Option (List Char)
  | d :: r => if d = c then some r else none
  | [] => none

mutual

/-- Parse one IPDL value. -/
def parse : Nat → List Char → Option (CVal × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c ≠ '(' then none
      else
        match r with
        | 'n' :: 'u' :: 'l' :: 'l' :: ')' :: t => some (.null, t)
        | 'b' :: 'o' :: 'o' :: 'l' :: ' ' :: b :: ')' :: t =>
            if b = '1' then some (.bool true, t)
            else if b = '0' then some (.bool false, t)
            else none
        | 'i' :: 'n' :: 't' :: ' ' :: t =>
            (Parse.readInt ')' t).map (fun p => (CVal.int p.1, p.2))
        | 'd' :: 'e' :: 'c' :: ' ' :: t =>
            match Parse.readInt ' ' t with
            | some (m, t1) => (Parse.readInt ')' t1).map (fun p => (CVal.num m p.1, p.2))
            | none => none
        | 's' :: 't' :: 'r' :: ' ' :: t =>
            match readStr t with
            | some (s, t1) => (expect ')' t1).map (fun t2 => (CVal.str s, t2))
            | none => none
        | 'r' :: 'e' :: 'f' :: ' ' :: t =>
            match readStr t with
            | some (s, t1) => (expect ')' t1).map (fun t2 => (CVal.ref s, t2))
            | none => none
        | 'l' :: 'i' :: 's' :: 't' :: t =>
            (parseItems f t).map (fun p => (CVal.list p.1, p.2))
        | 'o' :: 'b' :: 'j' :: t =>
            (parseFields f t).map (fun p => (CVal.obj p.1, p.2))
        | _ => none

/-- Parse the elements of a `(list …)` up to its closing parenthesis. -/
def parseItems : Nat → List Char → Option (List CVal × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = ')' then some ([], r)
      else if c = ' ' then
        match parse f r with
        | some (x, r') => (parseItems f r').map (fun p => (x :: p.1, p.2))
        | none => none
      else none

/-- Parse the fields of an `(obj …)` up to its closing parenthesis. -/
def parseFields : Nat → List Char → Option (List (String × CVal) × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = ')' then some ([], r)
      else if c = ' ' then
        match r with
        | '(' :: 'f' :: 'i' :: 'e' :: 'l' :: 'd' :: ' ' :: t =>
            match readStr t with
            | some (k, t1) =>
                match t1 with
                | ' ' :: t2 =>
                    match parse f t2 with
                    | some (v, t3) =>
                        match expect ')' t3 with
                        | some t4 => (parseFields f t4).map (fun p => ((k, v) :: p.1, p.2))
                        | none => none
                    | none => none
                | _ => none
            | none => none
        | _ => none
      else none

end

/-! ## The round trip -/

theorem parse_emit_all : ∀ f : Nat,
    (∀ (v : CVal) (rest : List Char), size v ≤ f →
        parse f (emit v ++ rest) = some (v, rest)) ∧
    (∀ (xs : List CVal) (rest : List Char), sizeItems xs ≤ f →
        parseItems f (emitItems xs ++ ')' :: rest) = some (xs, rest)) ∧
    (∀ (fs : List (String × CVal)) (rest : List Char), sizeFields fs ≤ f →
        parseFields f (emitFields fs ++ ')' :: rest) = some (fs, rest)) := by
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
        | null => simp [emit, parse]
        | bool b => cases b <;> simp [emit, parse]
        | int i =>
            simp only [emit, List.append_assoc, List.cons_append, List.nil_append, parse]
            simp [Parse.readInt_intChars (by decide : Digits.charDigit ')' = none)]
        | num m e =>
            simp only [emit, List.append_assoc, List.cons_append, List.nil_append, parse]
            simp [Parse.readInt_intChars (by decide : Digits.charDigit ' ' = none),
              Parse.readInt_intChars (by decide : Digits.charDigit ')' = none)]
        | str s =>
            simp only [emit, List.append_assoc, List.cons_append, List.nil_append, parse,
              readStr_strChars]
            simp [expect]
        | ref r =>
            simp only [emit, List.append_assoc, List.cons_append, List.nil_append, parse,
              readStr_strChars]
            simp [expect]
        | list xs =>
            have hxs : sizeItems xs ≤ f := by simp [size] at hv; omega
            simp only [emit, List.append_assoc, List.cons_append, List.nil_append, parse]
            simp [ihI xs rest hxs]
        | obj fs =>
            have hfs : sizeFields fs ≤ f := by simp [size] at hv; omega
            simp only [emit, List.append_assoc, List.cons_append, List.nil_append, parse]
            simp [ihF fs rest hfs]
      · intro xs rest hxs
        cases xs with
        | nil => simp [emitItems, parseItems]
        | cons x xs =>
            have hx : size x ≤ f := by simp [sizeItems] at hxs; omega
            have hxs' : sizeItems xs ≤ f := by simp [sizeItems] at hxs; omega
            have hchars : emitItems (x :: xs) ++ ')' :: rest
                = ' ' :: (emit x ++ (emitItems xs ++ ')' :: rest)) := by
              simp [emitItems, List.append_assoc]
            rw [hchars, parseItems]
            simp only [if_neg (by decide : (' ' : Char) ≠ ')'), ihV x _ hx]
            simp [ihI xs rest hxs']
      · intro fs rest hfs
        cases fs with
        | nil => simp [emitFields, parseFields]
        | cons p fs =>
            obtain ⟨k, v⟩ := p
            have hv : size v ≤ f := by simp [sizeFields] at hfs; omega
            have hfs' : sizeFields fs ≤ f := by simp [sizeFields] at hfs; omega
            have hchars : emitFields ((k, v) :: fs) ++ ')' :: rest
                = ' ' :: '(' :: 'f' :: 'i' :: 'e' :: 'l' :: 'd' :: ' ' ::
                    (strChars k ++ ' ' :: (emit v ++ ')' :: (emitFields fs ++ ')' :: rest))) := by
              simp [emitFields, List.append_assoc]
            rw [hchars, parseFields]
            simp only [if_neg (by decide : (' ' : Char) ≠ ')'),
              readStr_strChars, ihV v _ hv, expect]
            simp [ihF fs rest hfs']

/-! ## The codec -/

/-- Write a canonical value as IPDL. -/
def encode (v : CVal) : String := String.ofList (emit v)

/-- Read IPDL back; `none` if it is malformed or has trailing data. -/
def decode (s : String) : Option CVal :=
  match parse s.length s.toList with
  | some (v, []) => some v
  | _ => none

theorem size_le_emit_all :
    (∀ v : CVal, size v ≤ (emit v).length) ∧
    (∀ fs : List (String × CVal), sizeFields fs ≤ (emitFields fs).length + 1) ∧
    (∀ xs : List CVal, sizeItems xs ≤ (emitItems xs).length + 1) := by
  refine @emit.mutual_induct
    (fun v => size v ≤ (emit v).length)
    (fun fs => sizeFields fs ≤ (emitFields fs).length + 1)
    (fun xs => sizeItems xs ≤ (emitItems xs).length + 1)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [size, sizeItems, sizeFields, emit, emitItems, emitFields, strChars] <;> omega

/-- **Round trip.**  IPDL is a lossless projection of the canonical
model: `Canonical → IPDL → Canonical` is the identity. -/
@[simp] theorem decode_encode (v : CVal) : decode (encode v) = some v := by
  have hlen : size v ≤ (String.ofList (emit v)).length := by
    have := size_le_emit_all.1 v
    simpa using this
  have := (parse_emit_all _).1 v [] hlen
  simp only [decode, encode, String.toList_ofList, List.append_nil] at *
  rw [this]

/-- IPDL text determines the value it denotes. -/
theorem encode_injective {v w : CVal} (h : encode v = encode w) : v = w := by
  have hv := decode_encode v
  rw [h, decode_encode w] at hv
  exact (Option.some.inj hv).symm

end Ipdl
end Codec
end CfDeploy
