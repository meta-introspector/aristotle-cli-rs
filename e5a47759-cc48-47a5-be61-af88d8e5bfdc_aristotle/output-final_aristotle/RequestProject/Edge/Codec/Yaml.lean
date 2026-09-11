/-
# The YAML codec

YAML is the human-readable projection of the canonical model.  Two
renderings are provided, and they are honest about what they promise:

* `encode` / `decode` — **flow style**, the JSON-compatible subset of
  YAML.  Every key is quoted, every string is quoted, references carry
  the `!ref` tag and exact decimals the `!dec` tag, so nothing is
  ambiguous and the round trip is *proved* (`decode_encode`).

  ```yaml
  {"id": "proof-001", "n": 144, "xs": [null, true, !dec "-125;-2;"]}
  ```

* `block` — **block style**, the layout of the specification's example.
  It is a presentation format: it is emitted, not parsed, and no
  losslessness is claimed for it.

  ```yaml
  id: proof-001
  kind: theorem
  inputs:
    - id: n
      type: integer
      value: 144
  ```

Exact decimals deserve a note.  A canonical `num m e` means the *exact*
rational `m * 10 ^ e`; writing it as a YAML float would hand it to the
receiver's binary floating-point reader and lose that.  The `!dec` tag
keeps it exact, which is what a proof system needs, and it is the kind
of local tag §15 asks codecs to preserve.
-/
import RequestProject.Edge.Codec.Value

namespace CfDeploy
namespace Codec
namespace Yaml

/-! ## Flow style -/

open CVal

/-- A quoted scalar. -/
def quoted (s : String) : List Char := '"' :: (Parse.escY s.toList ++ ['"'])

mutual

/-- Render a canonical value in flow style. -/
def flow : CVal → List Char
  | .null => ['n', 'u', 'l', 'l']
  | .bool true => ['t', 'r', 'u', 'e']
  | .bool false => ['f', 'a', 'l', 's', 'e']
  | .int i => Parse.intChars i
  | .num m e =>
      '!' :: 'd' :: 'e' :: 'c' :: ' ' :: quoted (Parse.intPairStr m e)
  | .str s => quoted s
  | .ref r => '!' :: 'r' :: 'e' :: 'f' :: ' ' :: quoted r
  | .list xs => '[' :: flowItems xs
  | .obj fs => '{' :: flowFields fs

/-- The elements of a flow sequence, closing bracket included. -/
def flowItems : List CVal → List Char
  | [] => [']']
  | [x] => flow x ++ [']']
  | x :: xs => flow x ++ ',' :: ' ' :: flowItems xs

/-- The entries of a flow mapping, closing brace included. -/
def flowFields : List (String × CVal) → List Char
  | [] => ['}']
  | [(k, v)] => quoted k ++ ':' :: ' ' :: (flow v ++ ['}'])
  | (k, v) :: fs => quoted k ++ ':' :: ' ' :: (flow v ++ ',' :: ' ' :: flowFields fs)

end

/-- Read a quoted scalar (the opening quote must already have been
consumed). -/
def readQuoted (cs : List Char) : Option (String × List Char) :=
  (Parse.readY cs).map (fun p => (String.ofList p.1, p.2))

mutual

/-- Parse a flow-style value. -/
def parseFlow : Nat → List Char → Option (CVal × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = '"' then (readQuoted r).map (fun p => (CVal.str p.1, p.2))
      else if c = '[' then (parseItems f r).map (fun p => (CVal.list p.1, p.2))
      else if c = '{' then (parseFields f r).map (fun p => (CVal.obj p.1, p.2))
      else if c = '!' then
        match r with
        | 'd' :: 'e' :: 'c' :: ' ' :: '"' :: r' =>
            match readQuoted r' with
            | some (s, r2) =>
                match Parse.parseIntPairStr s with
                | some (m, e) => some (CVal.num m e, r2)
                | none => none
            | none => none
        | 'r' :: 'e' :: 'f' :: ' ' :: '"' :: r' =>
            (readQuoted r').map (fun p => (CVal.ref p.1, p.2))
        | _ => none
      else if c = 'n' then
        match r with
        | 'u' :: 'l' :: 'l' :: r' => some (CVal.null, r')
        | _ => none
      else if c = 't' then
        match r with
        | 'r' :: 'u' :: 'e' :: r' => some (CVal.bool true, r')
        | _ => none
      else if c = 'f' then
        match r with
        | 'a' :: 'l' :: 's' :: 'e' :: r' => some (CVal.bool false, r')
        | _ => none
      else
        match Parse.readIntOpen (c :: r) with
        | some (i, r') => some (CVal.int i, r')
        | none => none

/-- Parse the rest of a flow sequence. -/
def parseItems : Nat → List Char → Option (List CVal × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = ']' then some ([], r)
      else
        match parseFlow f (c :: r) with
        | some (x, ']' :: r') => some ([x], r')
        | some (x, ',' :: ' ' :: r') =>
            (parseItems f r').map (fun p => (x :: p.1, p.2))
        | _ => none

/-- Parse the rest of a flow mapping. -/
def parseFields : Nat → List Char → Option (List (String × CVal) × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = '}' then some ([], r)
      else if c = '"' then
        match readQuoted r with
        | some (k, ':' :: ' ' :: r1) =>
            match parseFlow f r1 with
            | some (v, '}' :: r2) => some ([(k, v)], r2)
            | some (v, ',' :: ' ' :: r2) =>
                (parseFields f r2).map (fun p => ((k, v) :: p.1, p.2))
            | _ => none
        | _ => none
      else none

end

/-! ## The round trip -/

theorem quoted_eq (s : String) (rest : List Char) :
    quoted s ++ rest = '"' :: (Parse.escY s.toList ++ '"' :: rest) := by
  simp [quoted]

theorem readQuoted_escY (s : String) (rest : List Char) :
    readQuoted (Parse.escY s.toList ++ '"' :: rest) = some (s, rest) := by
  simp [readQuoted, Parse.readY_escY, String.ofList_toList]

/-- The first character of an integer is a minus sign or a digit. -/
theorem intChars_head (i : Int) : ∃ c t, Parse.intChars i = c :: t ∧
    (c = '-' ∨ ∃ d, Digits.charDigit c = some d) := by
  obtain ⟨c, cs, d, hcs, hd⟩ := Parse.toDigits_head_digit i.natAbs
  by_cases h : i < 0
  · exact ⟨'-', Digits.toDigits i.natAbs, by simp [Parse.intChars, h], Or.inl rfl⟩
  · exact ⟨c, cs, by simp [Parse.intChars, h, hcs], Or.inr ⟨d, hd⟩⟩

/-- The first character of a flow rendering identifies its branch: it is
never a delimiter, so a parser can always tell a value from the end of
the container it sits in. -/
theorem flow_head (v : CVal) :
    ∃ c t, flow v = c :: t ∧ c ≠ ']' ∧ c ≠ '}' ∧ c ≠ ',' := by
  cases v with
  | null => exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | bool b => cases b <;> exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | num m e => exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | ref r => exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | str s => exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | list xs => exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | obj fs => exact ⟨_, _, rfl, by decide, by decide, by decide⟩
  | int i =>
      obtain ⟨c, t, hfl, hcase⟩ := intChars_head i
      have hne : ∀ x : Char, Digits.charDigit x = none → ¬(x = '-') → c ≠ x := by
        rintro x hx hxm rfl
        rcases hcase with h | ⟨d, hd⟩
        · exact hxm h
        · rw [hx] at hd; simp at hd
      exact ⟨c, t, hfl, hne _ (by decide) (by decide), hne _ (by decide) (by decide),
        hne _ (by decide) (by decide)⟩

theorem parse_flow_all : ∀ f : Nat,
    (∀ (v : CVal) (rest : List Char), size v ≤ f →
        (∀ c ∈ rest.head?, Digits.charDigit c = none) →
        parseFlow f (flow v ++ rest) = some (v, rest)) ∧
    (∀ (xs : List CVal) (rest : List Char), sizeItems xs ≤ f →
        parseItems f (flowItems xs ++ rest) = some (xs, rest)) ∧
    (∀ (fs : List (String × CVal)) (rest : List Char), sizeFields fs ≤ f →
        parseFields f (flowFields fs ++ rest) = some (fs, rest)) := by
  intro f
  induction f with
  | zero =>
      refine ⟨?_, ?_, ?_⟩
      · intro v _ h _; exact absurd h (by have := size_pos v; omega)
      · intro xs _ h; exact absurd h (by have := sizeItems_pos xs; omega)
      · intro fs _ h; exact absurd h (by have := sizeFields_pos fs; omega)
  | succ f ih =>
      obtain ⟨ihV, ihI, ihF⟩ := ih
      refine ⟨?_, ?_, ?_⟩
      · intro v rest hv hrest
        cases v with
        | null => simp [flow, parseFlow]
        | bool b => cases b <;> simp [flow, parseFlow]
        | int i =>
            obtain ⟨c, t, hfl, hcase⟩ := intChars_head i
            have hopen : Parse.readIntOpen (c :: (t ++ rest)) = some (i, rest) := by
              have h := Parse.readIntOpen_intChars i rest hrest
              rwa [hfl, List.cons_append] at h
            have hne : ∀ x : Char, Digits.charDigit x = none → ¬(x = '-') → c ≠ x := by
              rintro x hx hxm rfl
              rcases hcase with h | ⟨d, hd⟩
              · exact hxm h
              · rw [hx] at hd; simp at hd
            have hgoal : flow (CVal.int i) ++ rest = c :: (t ++ rest) := by
              simp [flow, hfl]
            rw [hgoal]
            simp only [parseFlow,
              if_neg (hne '"' (by decide) (by decide)),
              if_neg (hne '[' (by decide) (by decide)),
              if_neg (hne '{' (by decide) (by decide)),
              if_neg (hne '!' (by decide) (by decide)),
              if_neg (hne 'n' (by decide) (by decide)),
              if_neg (hne 't' (by decide) (by decide)),
              if_neg (hne 'f' (by decide) (by decide)), hopen]
        | num m e =>
            simp only [flow, List.cons_append, quoted_eq, parseFlow]
            simp only [readQuoted_escY, Parse.parseIntPairStr_intPairStr]
            simp
        | str s =>
            simp only [flow, quoted_eq, parseFlow, readQuoted_escY]
            simp
        | ref r =>
            simp only [flow, List.cons_append, quoted_eq, parseFlow, readQuoted_escY]
            simp
        | list xs =>
            have hxs : sizeItems xs ≤ f := by simp [size] at hv; omega
            simp only [flow, List.cons_append, parseFlow, ihI xs rest hxs]
            simp
        | obj fs =>
            have hfs : sizeFields fs ≤ f := by simp [size] at hv; omega
            simp only [flow, List.cons_append, parseFlow, ihF fs rest hfs]
            simp
      · intro xs rest hxs
        cases xs with
        | nil => simp [flowItems, parseItems]
        | cons x xs =>
            have hx : size x ≤ f := by simp [sizeItems] at hxs; omega
            have hxs' : sizeItems xs ≤ f := by simp [sizeItems] at hxs; omega
            obtain ⟨c, t, hfl, hne1, _, _⟩ := flow_head x
            cases xs with
            | nil =>
                have hv := ihV x (']' :: rest) hx (by intro d hd; simp at hd; subst hd; decide)
                rw [hfl, List.cons_append] at hv
                simp only [flowItems, hfl, List.cons_append, List.append_assoc,
                  List.nil_append, parseItems, if_neg hne1, hv]
            | cons y ys =>
                have hv := ihV x (',' :: ' ' :: (flowItems (y :: ys) ++ rest)) hx
                  (by intro d hd; simp at hd; subst hd; decide)
                rw [hfl, List.cons_append] at hv
                simp only [flowItems, hfl, List.cons_append, List.append_assoc,
                  parseItems, if_neg hne1, hv, ihI (y :: ys) rest hxs']
                simp
      · intro fs rest hfs
        cases fs with
        | nil => simp [flowFields, parseFields]
        | cons p fs =>
            obtain ⟨k, v⟩ := p
            have hv : size v ≤ f := by simp [sizeFields] at hfs; omega
            have hfs' : sizeFields fs ≤ f := by simp [sizeFields] at hfs; omega
            cases fs with
            | nil =>
                have hvv := ihV v ('}' :: rest) hv (by intro d hd; simp at hd; subst hd; decide)
                simp only [flowFields, quoted_eq, List.cons_append, List.append_assoc,
                  List.nil_append, parseFields, if_neg (by decide : ('"' : Char) ≠ '}'),
                  if_true, readQuoted_escY, hvv]
            | cons q qs =>
                have hvv := ihV v (',' :: ' ' :: (flowFields (q :: qs) ++ rest)) hv
                  (by intro d hd; simp at hd; subst hd; decide)
                simp only [flowFields, quoted_eq, List.cons_append, List.append_assoc,
                  parseFields, if_neg (by decide : ('"' : Char) ≠ '}'), if_true,
                  readQuoted_escY, hvv, ihF (q :: qs) rest hfs']
                simp

/-! ## Enough fuel -/

theorem two_le_two_mul_intChars (i : Int) : 2 ≤ 2 * (Parse.intChars i).length := by
  have := Parse.intChars_length_pos i; omega

theorem size_le_flow_all :
    (∀ v : CVal, size v + 1 ≤ 2 * (flow v).length) ∧
    (∀ fs : List (String × CVal), sizeFields fs ≤ 2 * (flowFields fs).length) ∧
    (∀ xs : List CVal, sizeItems xs ≤ 2 * (flowItems xs).length) := by
  refine @flow.mutual_induct
    (fun v => size v + 1 ≤ 2 * (flow v).length)
    (fun fs => sizeFields fs ≤ 2 * (flowFields fs).length)
    (fun xs => sizeItems xs ≤ 2 * (flowItems xs).length)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [size, sizeItems, sizeFields, flow, flowItems, flowFields, quoted,
      two_le_two_mul_intChars] <;> omega

/-! ## The codec -/

/-- Encode a canonical value as flow-style YAML. -/
def encode (v : CVal) : String := String.ofList (flow v)

/-- Decode flow-style YAML; `none` if it is malformed or has trailing
data. -/
def decode (s : String) : Option CVal :=
  match parseFlow (2 * s.length) s.toList with
  | some (v, []) => some v
  | _ => none

/-- **The flow-style YAML codec is lossless.** -/
theorem decode_encode (v : CVal) : decode (encode v) = some v := by
  have hfuel : size v ≤ 2 * (flow v).length := by
    have := size_le_flow_all.1 v
    omega
  have := (parse_flow_all (2 * (flow v).length)).1 v [] hfuel (by simp)
  simp only [decode, encode, String.toList_ofList, String.length_ofList, List.append_nil] at *
  rw [this]

/-! ## Block style, for humans -/

/-- `n` spaces. -/
def indent (n : Nat) : List Char := List.replicate n ' '

/-- A scalar in block style: the same unambiguous spelling as flow
style, so a block document can still be read by eye without guessing at
types. -/
def blockScalar (v : CVal) : List Char := flow v

mutual

/-- Render a value in block style at the given indentation.  Containers
start on the following line. -/
def blockAt (n : Nat) : CVal → List Char
  | .list [] => ['[', ']', '\n']
  | .obj [] => ['{', '}', '\n']
  | .list xs => '\n' :: blockItems n xs
  | .obj fs => '\n' :: blockFields n fs
  | v => blockScalar v ++ ['\n']

def blockItems (n : Nat) : List CVal → List Char
  | [] => []
  | x :: xs => indent n ++ '-' :: ' ' :: blockAt (n + 2) x ++ blockItems n xs

def blockFields (n : Nat) : List (String × CVal) → List Char
  | [] => []
  | (k, v) :: fs =>
      indent n ++ (quoted k ++ ':' :: ' ' :: blockAt (n + 2) v) ++ blockFields n fs

end

/-- A block-style YAML rendering, for human eyes.  This is a
presentation format: there is no block-style parser, and no
losslessness is claimed for it. -/
def block (v : CVal) : String :=
  match v with
  | .list xs => String.ofList (blockItems 0 xs)
  | .obj fs => String.ofList (blockFields 0 fs)
  | _ => String.ofList (blockScalar v ++ ['\n'])

end Yaml
end Codec
end CfDeploy
