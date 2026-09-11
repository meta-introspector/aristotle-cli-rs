import RequestProject.Relay.Templates

/-!
# The data shapes the payload is written in

The relay carries one payload, and every stage writes it down in the notation of
its own language: a plain string, an array of chunks, a list, a keyed table, a
sequence of XML text nodes.  A `Shape` (in `RequestProject.Relay.Core`) is
exactly that notation — text before the digits, glue between chunks, text after
them — and reading it back is shape-agnostic (`parseDigits` keeps the digits).

This file names the shapes the stages use, proves each of them clean (its
decoration has neither a digit nor the marker in it, so a payload written in it
can be read back), and records the consequences: each shape round-trips
(`round_trip`), and the payload can be carried from any of them to any other
without change (`interchange`) — the precise sense in which the same data exists
in all these forms.
-/

namespace RequestProject.Relay

namespace Shapes

/-- The payload as one run of digits, with nothing around it. -/
def raw : Shape := ⟨[], [], []⟩

/-- The payload as an array (or list) of quoted chunks: `"ddd", "ddd"`. -/
def array : Shape := ⟨[], ['"', ',', '\n', ' ', ' ', '"'], []⟩

/-- The payload as adjacent string literals, glued by nothing but a line break:
`"ddd"\n"ddd"`. -/
def concatLines : Shape := ⟨[], ['"', '\n', ' ', ' ', '"'], []⟩

/-- The payload as the rows of a keyed table: `'ddd'),('ddd`.  This is how a
stage would carry it as a table of `(key, chunk)` rows; the SQL stage that did
so was taken out of the relay for being quadratic in the payload, so no stage
uses this shape at the moment. -/
def rows : Shape := ⟨[], ['\'', ')', ',', '\n', ' ', ' ', '(', '\''], []⟩

/-- The payload as XML text nodes: `<payload><d>ddd</d><d>ddd</d></payload>`.
The AWK stage carries it this way, with AWK's line continuation inside the glue
so that the nodes can be spread over several lines of a string literal. -/
def xml : Shape :=
  ⟨['<', 'p', 'a', 'y', 'l', 'o', 'a', 'd', '>', '<', 'd', '>'],
   ['<', '/', 'd', '>', '<', 'd', '>'],
   ['<', '/', 'd', '>', '<', '/', 'p', 'a', 'y', 'l', 'o', 'a', 'd', '>']⟩

/-- The payload as an S-expression list of strings. -/
def sexp : Shape := ⟨['('], ['"', ' ', '"'], [')']⟩

/-- The payload as comma-separated values. -/
def csv : Shape := ⟨[], [','], []⟩

/-- All the shapes named here. -/
def all : List Shape := [raw, array, concatLines, rows, xml, sexp, csv]

/-- Every one of these shapes is clean: no digit and no marker in its
decoration. -/
theorem all_clean : ∀ s ∈ all, s.Clean := by decide

/-- **Every shape round-trips.**  Digits written in any of these notations read
back exactly as they went in. -/
theorem round_trip {s : Shape} (hs : s ∈ all) {d : List Char}
    (hd : ∀ c ∈ d, isDigit c = true) : parseDigits (s.render d) = d :=
  Shape.parse_render s (all_clean s hs) d hd

/-- **The same data in all these forms.**  A payload written in one shape and
read back can be written in any other and read back again unchanged: the relay
is shape-agnostic. -/
theorem interchange {s₁ s₂ : Shape} (h₁ : s₁ ∈ all) (h₂ : s₂ ∈ all) {d : List Char}
    (hd : ∀ c ∈ d, isDigit c = true) :
    parseDigits (s₂.render (parseDigits (s₁.render d))) = d :=
  Shape.commute s₁ s₂ (all_clean s₁ h₁) (all_clean s₂ h₂) d hd

/-- The payload of a relay may be read in any of these shapes: applied to the
digits of a well-formed relay, every rendering carries the same information. -/
theorem interchange_digits (R : Relay) {s₁ s₂ : Shape} (h₁ : s₁ ∈ all) (h₂ : s₂ ∈ all) :
    parseDigits (s₂.render (parseDigits (s₁.render R.digits))) = R.digits :=
  interchange h₁ h₂ (Relay.isDigit_digits R)

/-! ### The shapes of the actual stages

Eleven of the twenty-two stages write the payload as an array of chunks, two as
adjacent string literals, the Scheme stage as one unbroken run of digits, and
the AWK stage as XML text nodes; the rest use the same idea with their own
language's punctuation in the glue. -/

example : stage0.shape = array := by decide      -- JavaScript
example : stage4.shape = array := by decide      -- Ruby
example : stage5.shape = array := by decide      -- Lua
example : stage6.shape = array := by decide      -- PHP
example : stage9.shape = array := by decide      -- C, gcc
example : stage10.shape = array := by decide     -- C, tcc
example : stage14.shape = array := by decide     -- Rust
example : stage15.shape = array := by decide     -- Haskell
example : stage18.shape = array := by decide     -- Prolog
example : stage19.shape = array := by decide     -- R
example : stage20.shape = array := by decide     -- Lean
example : stage8.shape = raw := by decide           -- Scheme, one literal
example : stage12.shape = concatLines := by decide  -- Emacs Lisp
example : stage13.shape = concatLines := by decide  -- Common Lisp
example : stage3.shape.head = xml.head := by decide -- AWK, the XML rendering
example : stage3.shape.tail = xml.tail := by decide

end Shapes

end RequestProject.Relay
