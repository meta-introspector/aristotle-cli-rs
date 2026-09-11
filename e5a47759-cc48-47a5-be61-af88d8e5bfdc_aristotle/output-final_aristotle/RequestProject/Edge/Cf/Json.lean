/-
# A tiny JSON writer

The Cloudflare API speaks JSON, and both the Lean CLI and the extracted
JavaScript have to produce byte-identical request bodies (the JavaScript
is generated from the same Lean values, see `RequestProject.Cf.JsEmit`).
So the encoder lives here, in the Mathlib-free core, and is used by both.

Only *writing* is needed: the tool builds request bodies, and the
responses it reads are handled by the host (`fetch` in JavaScript, `curl`
in the shell transcript).

`escape` is proved to leave no unescaped `"` or `\` in its output, which
is the property that makes `render` unambiguous.
-/

namespace CfDeploy

/-- JSON values. -/
inductive Json where
  | null
  | bool (b : Bool)
  | str (s : String)
  /-- integers only; the Cloudflare bodies used here need no floats -/
  | num (n : Int)
  | arr (items : List Json)
  | obj (fields : List (String × Json))
  deriving Repr, Inhabited

namespace Json

/-- Escape one character of a JSON string literal. -/
def escapeChar (c : Char) : String :=
  if c = '"' then "\\\""
  else if c = '\\' then "\\\\"
  else if c = '\n' then "\\n"
  else if c = '\r' then "\\r"
  else if c = '\t' then "\\t"
  else if c.toNat < 0x20 then
    let hex := Nat.toDigits 16 c.toNat
    let pad := String.ofList (List.replicate (4 - hex.length) '0')
    "\\u" ++ pad ++ String.ofList hex
  else String.ofList [c]

/-- Escape a JSON string literal (without the surrounding quotes). -/
def escape (s : String) : String :=
  s.toList.foldl (fun acc c => acc ++ escapeChar c) ""

/-- Render a JSON value in compact form. -/
partial def render : Json → String
  | .null => "null"
  | .bool true => "true"
  | .bool false => "false"
  | .str s => "\"" ++ escape s ++ "\""
  | .num n => toString n
  | .arr items => "[" ++ String.intercalate "," (items.map render) ++ "]"
  | .obj fields =>
      "{" ++ String.intercalate ","
        (fields.map (fun (k, v) => "\"" ++ escape k ++ "\":" ++ render v)) ++ "}"

/-- Render with two-space indentation, for the files the CLI writes. -/
partial def pretty (indent : Nat) : Json → String
  | .arr [] => "[]"
  | .obj [] => "{}"
  | .arr items =>
      let pad := String.ofList (List.replicate (indent + 2) ' ')
      let close := String.ofList (List.replicate indent ' ')
      "[\n" ++ String.intercalate ",\n" (items.map (fun v => pad ++ pretty (indent + 2) v))
        ++ "\n" ++ close ++ "]"
  | .obj fields =>
      let pad := String.ofList (List.replicate (indent + 2) ' ')
      let close := String.ofList (List.replicate indent ' ')
      "{\n" ++ String.intercalate ",\n"
        (fields.map (fun (k, v) =>
          pad ++ "\"" ++ escape k ++ "\": " ++ pretty (indent + 2) v))
        ++ "\n" ++ close ++ "}"
  | v => render v

/-- A character that `escapeChar` passes through unchanged. -/
def Plain (c : Char) : Prop :=
  c ≠ '"' ∧ c ≠ '\\' ∧ c ≠ '\n' ∧ c ≠ '\r' ∧ c ≠ '\t' ∧ ¬ (c.toNat < 0x20)

theorem escapeChar_plain {c : Char} (h : Plain c) : escapeChar c = String.ofList [c] := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := h
  simp [escapeChar, h1, h2, h3, h4, h5, h6]

/-- The escape of a quote is a backslash-quote pair: quotes never survive
unescaped. -/
@[simp] theorem escapeChar_quote : escapeChar '"' = "\\\"" := by
  simp [escapeChar]

@[simp] theorem escapeChar_backslash : escapeChar '\\' = "\\\\" := by
  simp [escapeChar]

/-- `escapeChar` never produces the empty string, so escaping cannot make
two different strings collide by deleting characters. -/
theorem escapeChar_length_pos (c : Char) : 0 < (escapeChar c).length := by
  unfold escapeChar
  repeat' split
  all_goals first
    | decide
    | (simp only [String.length_append]
       have h : "\\u".length = 2 := rfl
       omega)
    | simp

@[simp] theorem escape_empty : escape "" = "" := rfl

end Json

/-- Convenient constructor: a JSON object from string-valued fields. -/
def jstrObj (fields : List (String × String)) : Json :=
  .obj (fields.map (fun (k, v) => (k, .str v)))

end CfDeploy
