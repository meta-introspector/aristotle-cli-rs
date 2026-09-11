/-!
# A quine relay of any length, abstractly

This file is the mathematics of the relay that connects the developments merged
in this repository.  A *stage* is one host program, in one language.  Each
program carries one payload — the same payload, rendered in that language's own
notation — and, when run, prints another one of the programs.  Every program can
print *itself* (the quine property) and every *other* program (the hosting
property); running the stages in turn takes the text all the way around the
cycle back to where it started (the relay property).

Nothing here mentions a particular number of stages: a relay is a nonempty list
of stages, and the cycle theorem `runN_size` is about a trip of `R.size` steps.

## The shape of a program

A stage is given by two blocks of code, `pre` and `post`, and a *shape*:

```
pre  @ head chunk glue chunk glue … chunk tail @  post
```

`@` is the marker; `pre` never contains one, so the payload region is exactly
the text between the first two markers.  Inside that region the payload digits
are laid out in the notation of the host language — as one string literal, as an
array of chunks, as a list, as rows of a table, as text nodes — which is what
`Shape` describes: text before the digits, text between consecutive chunks of
`width` digits, and text after them.  Since the decorations never contain a
decimal digit, *reading* the payload is shape-agnostic: keep the digits and
throw everything else away (`parseDigits`).

The digits are a three-decimal-digits-per-character encoding of `data`, the
concatenation of the five blocks of every stage (`pre`, `post`, and the three
pieces of its shape), separated by the control character `sep`.  A program
therefore carries the source of every program in the relay — including its own —
which is what makes the whole thing a quine relay rather than a mere chain.

The file uses no imports beyond Lean core, so it can be read (and checked)
independently of everything else in the repository.
-/

namespace RequestProject.Relay

/-- The payload marker. -/
def mark : Char := '@'

/-- The separator between the text blocks inside the payload: SOH, the one
control character every host language carries happily inside a string. -/
def sep : Char := Char.ofNat 1

/-- How many payload digits go into one chunk before the shape's glue is
inserted.  Chunking is what lets languages with a limit on the length of a
string literal (C, above all) carry a payload of any size. -/
def width : Nat := 4000

/-! ## The payload codec: three decimal digits per character -/

/-- The decimal digit `n < 10` as a character. -/
def digitChar (n : Nat) : Char := Char.ofNat (48 + n)

/-- Is this character a decimal digit? -/
def isDigit (c : Char) : Bool := 48 ≤ c.toNat && c.toNat ≤ 57

/-- A character code, written with exactly three decimal digits. -/
def enc3 (n : Nat) : List Char :=
  [digitChar (n / 100 % 10), digitChar (n / 10 % 10), digitChar (n % 10)]

/-- The payload encoding: every character becomes three decimal digits. -/
def encode (s : List Char) : List Char := s.flatMap (fun c => enc3 c.toNat)

/-- The numeric value of a decimal digit character. -/
def digitVal? (c : Char) : Option Nat :=
  if 48 ≤ c.toNat ∧ c.toNat ≤ 57 then some (c.toNat - 48) else none

/-- The payload decoding: three decimal digits at a time. -/
def decode : List Char → Option (List Char)
  | [] => some []
  | a :: b :: c :: rest => do
      let x ← digitVal? a
      let y ← digitVal? b
      let z ← digitVal? c
      let tl ← decode rest
      pure (Char.ofNat (100 * x + 10 * y + z) :: tl)
  | _ => none

/-- A character is *codeable* when its code fits in three decimal digits. -/
def Codeable (c : Char) : Prop := c.toNat < 1000

instance (c : Char) : Decidable (Codeable c) := inferInstanceAs (Decidable (c.toNat < 1000))

theorem toNat_ofNat_of_lt {n : Nat} (h : n < 55296) : (Char.ofNat n).toNat = n := by
  have h1 : n.isValidChar := Or.inl h
  rw [Char.ofNat, dif_pos h1]
  simp [Char.toNat, Char.ofNatAux]

theorem toNat_digitChar {k : Nat} (h : k < 10) : (digitChar k).toNat = 48 + k :=
  toNat_ofNat_of_lt (by omega)

theorem digitVal?_digitChar {k : Nat} (h : k < 10) : digitVal? (digitChar k) = some k := by
  have hc : (digitChar k).toNat = 48 + k := toNat_digitChar h
  simp only [digitVal?, hc]
  rw [if_pos (by omega)]
  congr 1
  omega

theorem isDigit_digitChar {k : Nat} (h : k < 10) : isDigit (digitChar k) = true := by
  have hc : (digitChar k).toNat = 48 + k := toNat_digitChar h
  simp only [isDigit, hc, Bool.and_eq_true, decide_eq_true_eq]
  omega

theorem decode_enc3_append (n : Nat) (hn : n < 1000) (rest : List Char) :
    decode (enc3 n ++ rest) = (decode rest).map (fun l => Char.ofNat n :: l) := by
  have h1 := digitVal?_digitChar (k := n / 100 % 10) (by omega)
  have h2 := digitVal?_digitChar (k := n / 10 % 10) (by omega)
  have h3 := digitVal?_digitChar (k := n % 10) (by omega)
  have harith : 100 * (n / 100 % 10) + 10 * (n / 10 % 10) + n % 10 = n := by omega
  simp [enc3, decode, h1, h2, h3, harith, Option.map]
  cases decode rest <;> simp

/-- Decoding undoes encoding. -/
theorem decode_encode : ∀ s : List Char, (∀ c ∈ s, Codeable c) → decode (encode s) = some s := by
  intro s
  induction s with
  | nil => intro _; rfl
  | cons c t ih =>
    intro h
    have hc : c.toNat < 1000 := h c (by simp)
    have hsplit : encode (c :: t) = enc3 c.toNat ++ encode t := by simp [encode]
    rw [hsplit, decode_enc3_append _ hc, ih fun x hx => h x (by simp [hx])]
    simp [Char.ofNat_toNat]

/-- Every character of an encoded payload is a decimal digit. -/
theorem isDigit_of_mem_encode (s : List Char) : ∀ c ∈ encode s, isDigit c = true := by
  intro d hd
  simp only [encode, List.mem_flatMap] at hd
  obtain ⟨c, -, hc⟩ := hd
  simp only [enc3, List.mem_cons, List.not_mem_nil, or_false] at hc
  rcases hc with rfl | rfl | rfl <;> exact isDigit_digitChar (by omega)

/-- The payload text consists of decimal digits only, so it contains neither the
marker nor the separator. -/
theorem not_mem_encode (s : List Char) (d : Char) (hd : d.toNat < 48 ∨ 57 < d.toNat) :
    d ∉ encode s := by
  simp only [encode, List.mem_flatMap, not_exists]
  rintro c ⟨-, hc⟩
  have key : ∀ k : Nat, k < 10 → d ≠ digitChar k := by
    intro k hk he
    have := toNat_digitChar hk
    rw [he] at hd
    omega
  simp only [enc3, List.mem_cons, List.not_mem_nil, or_false] at hc
  rcases hc with h | h | h <;> exact key _ (by omega) h

/-! ## Splitting the payload into its blocks -/

/-- Split a list of characters at every occurrence of `c`. -/
def splitOnChar (c : Char) : List Char → List (List Char)
  | [] => [[]]
  | x :: xs =>
      if x = c then [] :: splitOnChar c xs
      else match splitOnChar c xs with
        | [] => [[x]]
        | s :: ss => (x :: s) :: ss

/-- Join blocks with the separator `c` between them. -/
def joinWith (c : Char) : List (List Char) → List Char
  | [] => []
  | [s] => s
  | s :: ss => s ++ c :: joinWith c ss

theorem splitOnChar_of_not_mem (c : Char) : ∀ l : List Char, c ∉ l → splitOnChar c l = [l] := by
  intro l
  induction l with
  | nil => intro _; rfl
  | cons x xs ih =>
    intro h
    have hx : x ≠ c := fun he => h (by simp [he])
    rw [splitOnChar, if_neg hx, ih fun hm => h (by simp [hm])]

theorem splitOnChar_append_sep (c : Char) :
    ∀ l : List Char, c ∉ l → ∀ r : List Char,
      splitOnChar c (l ++ c :: r) = l :: splitOnChar c r := by
  intro l
  induction l with
  | nil => intro _ r; simp [splitOnChar]
  | cons x xs ih =>
    intro h r
    have hx : x ≠ c := fun he => h (by simp [he])
    rw [List.cons_append, splitOnChar, if_neg hx, ih (fun hm => h (by simp [hm])) r]

/-- Splitting undoes joining, as long as no block contains the separator. -/
theorem splitOnChar_joinWith (c : Char) :
    ∀ ls : List (List Char), ls ≠ [] → (∀ s ∈ ls, c ∉ s) →
      splitOnChar c (joinWith c ls) = ls := by
  intro ls
  induction ls with
  | nil => intro h; exact absurd rfl h
  | cons s ss ih =>
    intro _ hmem
    cases ss with
    | nil => exact splitOnChar_of_not_mem c s (hmem s (by simp))
    | cons t tt =>
      have hj : joinWith c (s :: t :: tt) = s ++ c :: joinWith c (t :: tt) := rfl
      rw [hj, splitOnChar_append_sep c s (hmem s (by simp)),
        ih (by simp) fun x hx => hmem x (by simp [hx])]

/-- Every character of a join is either the separator or a character of a block. -/
theorem mem_joinWith (c : Char) :
    ∀ ls : List (List Char), ∀ d ∈ joinWith c ls, d = c ∨ ∃ s ∈ ls, d ∈ s := by
  intro ls
  induction ls with
  | nil => intro d hd; simp [joinWith] at hd
  | cons s ss ih =>
    intro d hd
    cases ss with
    | nil =>
      exact Or.inr ⟨s, by simp, hd⟩
    | cons t tt =>
      have hj : joinWith c (s :: t :: tt) = s ++ c :: joinWith c (t :: tt) := rfl
      rw [hj] at hd
      rcases List.mem_append.1 hd with h | h
      · exact Or.inr ⟨s, by simp, h⟩
      · rcases List.mem_cons.1 h with h | h
        · exact Or.inl h
        · rcases ih d h with h' | ⟨u, hu, hdu⟩
          · exact Or.inl h'
          · exact Or.inr ⟨u, by simp [hu], hdu⟩

/-! ## Data shapes

A *shape* is how a stage's language writes the payload down: some text before
the digits, some glue between consecutive chunks of `width` digits, and some
text after them.  One shape gives a plain string literal, another an array of
string chunks, another a list, another the rows of a table, another a sequence
of XML text nodes.  All of them are read back the same way, by keeping the
digits and dropping everything else. -/

/-- A list none of whose characters satisfy `p` filters to nothing. -/
theorem filter_eq_nil_of_all_false (p : Char → Bool) :
    ∀ l : List Char, (∀ c ∈ l, p c = false) → l.filter p = [] := by
  intro l
  induction l with
  | nil => intro _; rfl
  | cons y ys ih =>
    intro h
    rw [List.filter_cons, if_neg (by simp [h y (by simp)])]
    exact ih fun c hc => h c (by simp [hc])

/-- A list all of whose characters satisfy `p` is unchanged by filtering. -/
theorem filter_eq_self_of_all_true (p : Char → Bool) :
    ∀ l : List Char, (∀ c ∈ l, p c = true) → l.filter p = l := by
  intro l
  induction l with
  | nil => intro _; rfl
  | cons y ys ih =>
    intro h
    rw [List.filter_cons, if_pos (h y (by simp)), ih fun c hc => h c (by simp [hc])]

/-- Insert `g` after every `w` characters, but never after the last chunk.
The `fuel` argument makes the recursion structural; `chunkJoin` supplies
enough of it. -/
def chunkAux (w : Nat) (g : List Char) : Nat → List Char → List Char
  | _, [] => []
  | 0, l => l
  | n + 1, l =>
      let a := l.take w
      let b := l.drop w
      if b = [] then a else a ++ g ++ chunkAux w g n b

/-- Lay `l` out in chunks of `w` characters glued together with `g`. -/
def chunkJoin (w : Nat) (g l : List Char) : List Char := chunkAux w g (l.length + 1) l

/-- Chunking only inserts characters of the glue. -/
theorem mem_chunkAux (w : Nat) (g : List Char) :
    ∀ (n : Nat) (l : List Char), ∀ c ∈ chunkAux w g n l, c ∈ g ∨ c ∈ l := by
  intro n
  induction n with
  | zero =>
    intro l c hc
    cases l with
    | nil => simp [chunkAux] at hc
    | cons x xs => exact Or.inr (by simpa [chunkAux] using hc)
  | succ n ih =>
    intro l c hc
    cases l with
    | nil => simp [chunkAux] at hc
    | cons x xs =>
      by_cases hb : (x :: xs).drop w = []
      · have hthis : chunkAux w g (n + 1) (x :: xs) = (x :: xs).take w := by simp [chunkAux, hb]
        rw [hthis] at hc
        exact Or.inr (List.mem_of_mem_take hc)
      · have he : chunkAux w g (n + 1) (x :: xs)
            = (x :: xs).take w ++ g ++ chunkAux w g n ((x :: xs).drop w) := by
          simp [chunkAux, hb]
        rw [he] at hc
        rcases List.mem_append.1 hc with h | h
        · rcases List.mem_append.1 h with h | h
          · exact Or.inr (List.mem_of_mem_take h)
          · exact Or.inl h
        · rcases ih ((x :: xs).drop w) c h with h' | h'
          · exact Or.inl h'
          · exact Or.inr (List.mem_of_mem_drop h')

theorem mem_chunkJoin (w : Nat) (g l : List Char) (c : Char) (hc : c ∈ chunkJoin w g l) :
    c ∈ g ∨ c ∈ l := mem_chunkAux w g _ l c hc

/-- Filtering a chunked layout with a predicate the glue never satisfies gives
back the filtered original: the glue is invisible to the reader. -/
theorem filter_chunkAux (w : Nat) (g : List Char) (p : Char → Bool)
    (hg : ∀ c ∈ g, p c = false) :
    ∀ (n : Nat) (l : List Char), (chunkAux w g n l).filter p = l.filter p := by
  intro n
  induction n with
  | zero => intro l; cases l <;> simp [chunkAux]
  | succ n ih =>
    intro l
    cases l with
    | nil => simp [chunkAux]
    | cons x xs =>
      have hsplit : (x :: xs).take w ++ (x :: xs).drop w = x :: xs := List.take_append_drop w _
      by_cases hb : (x :: xs).drop w = []
      · have hthis : chunkAux w g (n + 1) (x :: xs) = (x :: xs).take w := by simp [chunkAux, hb]
        rw [hb, List.append_nil] at hsplit
        rw [hthis, hsplit]
      · have he : chunkAux w g (n + 1) (x :: xs)
            = (x :: xs).take w ++ g ++ chunkAux w g n ((x :: xs).drop w) := by
          simp [chunkAux, hb]
        rw [he]
        have hgf : g.filter p = [] := filter_eq_nil_of_all_false p g hg
        have hrhs : List.filter p (x :: xs)
            = List.filter p ((x :: xs).take w) ++ List.filter p ((x :: xs).drop w) := by
          rw [← List.filter_append, hsplit]
        rw [hrhs]
        simp only [List.filter_append, hgf, List.append_nil, ih ((x :: xs).drop w)]

/-- How a stage's language writes the payload down. -/
structure Shape where
  /-- Text before the first chunk of digits. -/
  head : List Char
  /-- Text between consecutive chunks of digits. -/
  glue : List Char
  /-- Text after the last chunk of digits. -/
  tail : List Char
  deriving Inhabited, DecidableEq

/-- The blocks of a shape. -/
def Shape.blocks (s : Shape) : List (List Char) := [s.head, s.glue, s.tail]

/-- Render the payload digits in this shape. -/
def Shape.render (s : Shape) (d : List Char) : List Char :=
  s.head ++ chunkJoin width s.glue d ++ s.tail

/-- Read a payload back out of any shape: keep the digits, drop the decoration. -/
def parseDigits (t : List Char) : List Char := t.filter isDigit

/-- A shape is *clean* when its decoration contains no decimal digit (so the
digits can be read back out of it) and no marker (so the payload region of a
program is still delimited by the first two markers). -/
def Shape.Clean (s : Shape) : Prop :=
  ∀ b ∈ s.blocks, ∀ c ∈ b, isDigit c = false ∧ c ≠ mark

instance (s : Shape) : Decidable s.Clean := by
  unfold Shape.Clean; infer_instance

/-- **Shapes round-trip.** Whatever notation a stage uses for the payload, the
digits read back out of it are the digits that went in. -/
theorem Shape.parse_render (s : Shape) (hs : s.Clean) (d : List Char)
    (hd : ∀ c ∈ d, isDigit c = true) : parseDigits (s.render d) = d := by
  have hglue : ∀ c ∈ s.glue, isDigit c = false := fun c hc => (hs _ (by simp [Shape.blocks]) c hc).1
  have hfilter : ∀ (b : List Char), (∀ c ∈ b, isDigit c = false) → b.filter isDigit = [] :=
    filter_eq_nil_of_all_false isDigit
  have hdd : d.filter isDigit = d := filter_eq_self_of_all_true isDigit d hd
  simp only [parseDigits, Shape.render, List.filter_append,
    hfilter s.head (fun c hc => (hs _ (by simp [Shape.blocks]) c hc).1),
    hfilter s.tail (fun c hc => (hs _ (by simp [Shape.blocks]) c hc).1),
    chunkJoin, filter_chunkAux width s.glue isDigit hglue, hdd]
  simp

/-- **Shapes commute.** The payload can be moved from any shape to any other and
back: the same data really does exist in all these forms. -/
theorem Shape.commute (s₁ s₂ : Shape) (h₁ : s₁.Clean) (h₂ : s₂.Clean) (d : List Char)
    (hd : ∀ c ∈ d, isDigit c = true) :
    parseDigits (s₂.render (parseDigits (s₁.render d))) = d := by
  rw [s₁.parse_render h₁ d hd, s₂.parse_render h₂ d hd]

/-- The marker never occurs in a rendered payload. -/
theorem Shape.mark_not_mem_render (s : Shape) (hs : s.Clean) (d : List Char)
    (hd : mark ∉ d) : mark ∉ s.render d := by
  intro hm
  simp only [Shape.render, List.mem_append] at hm
  have hblk : ∀ b ∈ s.blocks, mark ∉ b := fun b hb hmb => (hs b hb mark hmb).2 rfl
  rcases hm with (h | h) | h
  · exact hblk s.head (by simp [Shape.blocks]) h
  · rcases mem_chunkJoin _ _ _ _ h with h' | h'
    · exact hblk s.glue (by simp [Shape.blocks]) h'
    · exact hd h'
  · exact hblk s.tail (by simp [Shape.blocks]) h

/-! ## Reading the payload out of a program -/

/-- The text after the first marker, if there is one. -/
def afterMark (t : List Char) : Option (List Char) :=
  match t.dropWhile (· ≠ mark) with
  | [] => none
  | _ :: rest => some rest

/-- The text of a program up to its first marker. -/
def upToMark (t : List Char) : List Char := t.takeWhile (· ≠ mark)

/-- The payload region of a program: the text between its first two markers. -/
def extract (t : List Char) : Option (List Char) := (afterMark t).map upToMark

theorem dropWhile_frame : ∀ pre : List Char, mark ∉ pre → ∀ r : List Char,
    (pre ++ mark :: r).dropWhile (· ≠ mark) = mark :: r := by
  intro pre
  induction pre with
  | nil => intro _ r; simp
  | cons x xs ih =>
    intro h r
    have hx : x ≠ mark := fun he => h (by simp [he])
    rw [List.cons_append, List.dropWhile_cons_of_pos (by simpa using hx),
      ih (fun hm => h (by simp [hm])) r]

theorem takeWhile_frame : ∀ pay : List Char, mark ∉ pay → ∀ r : List Char,
    (pay ++ mark :: r).takeWhile (· ≠ mark) = pay := by
  intro pay
  induction pay with
  | nil => intro _ r; simp
  | cons x xs ih =>
    intro h r
    have hx : x ≠ mark := fun he => h (by simp [he])
    rw [List.cons_append, List.takeWhile_cons_of_pos (by simpa using hx),
      ih (fun hm => h (by simp [hm])) r]

/-- The payload region of a framed program is exactly the framed text. -/
theorem extract_frame (pre pay post : List Char)
    (hpre : mark ∉ pre) (hpay : mark ∉ pay) :
    extract (pre ++ mark :: (pay ++ mark :: post)) = some pay := by
  simp only [extract, afterMark, dropWhile_frame pre hpre]
  simp only [Option.map_some, upToMark, takeWhile_frame pay hpay]

/-! ## The relay -/

/-- One stage of the relay: the code before the payload, the code after it, and
the notation the payload is written in. -/
structure StageSpec where
  /-- The text of the stage before its payload. -/
  pre : List Char
  /-- The text of the stage after its payload. -/
  post : List Char
  /-- How this stage writes the payload down. -/
  shape : Shape
  deriving Inhabited, DecidableEq

/-- The five text blocks of a stage, in the order the payload carries them. -/
def StageSpec.blocks (S : StageSpec) : List (List Char) :=
  [S.pre, S.post, S.shape.head, S.shape.glue, S.shape.tail]

/-- A relay: a nonempty list of stages. -/
structure Relay where
  /-- The stages, in the order the relay visits them. -/
  stages : List StageSpec
  /-- A relay has at least one stage. -/
  ne : stages ≠ []

namespace Relay

variable {R : Relay}

/-- The number of stages. -/
def size (R : Relay) : Nat := R.stages.length

theorem size_pos (R : Relay) : 0 < R.size := by
  cases h : R.stages with
  | nil => exact absurd h R.ne
  | cons a l => simp [size, h]

/-- Stage number `i`, counted around the cycle. -/
def stage (R : Relay) (i : Nat) : StageSpec := R.stages.getD (i % R.size) default

theorem stage_of_lt (R : Relay) {i : Nat} (h : i < R.size) :
    R.stage i = R.stages.getD i default := by
  simp [stage, Nat.mod_eq_of_lt h]

/-- All the text blocks of the relay: five per stage, in stage order. -/
def blocks (R : Relay) : List (List Char) := R.stages.flatMap StageSpec.blocks

/-- The data every program carries: all the blocks, separated by `sep`. -/
def data (R : Relay) : List Char := joinWith sep R.blocks

/-- The payload digits every program carries. -/
def digits (R : Relay) : List Char := encode R.data

/-- The text of the program at stage `i`. -/
def prog (R : Relay) (i : Nat) : List Char :=
  (R.stage i).pre ++ mark :: ((R.stage i).shape.render R.digits ++ mark :: (R.stage i).post)

/-- A relay is *well formed* when every block is encodable and separator-free,
no `pre` block contains the marker, and every shape is clean. -/
structure WF (R : Relay) : Prop where
  /-- Every character of every block is encodable in three decimal digits. -/
  codeable : ∀ S ∈ R.stages, ∀ b ∈ S.blocks, ∀ c ∈ b, Codeable c
  /-- No block contains the separator. -/
  sep_free : ∀ S ∈ R.stages, ∀ b ∈ S.blocks, sep ∉ b
  /-- The code before a payload never contains the marker. -/
  mark_free : ∀ S ∈ R.stages, mark ∉ S.pre
  /-- Every shape is digit-free and marker-free. -/
  clean : ∀ S ∈ R.stages, S.shape.Clean

/-- Well-formedness as one Boolean scan of the blocks, so that a concrete relay
can be checked by computation. -/
def check (R : Relay) : Bool :=
  R.stages.all fun S =>
    S.blocks.all (fun b => b.all fun c => decide (c.toNat < 1000) && !(c == sep))
      && (!S.pre.contains mark)
      && S.shape.blocks.all (fun b => b.all fun c => !isDigit c && !(c == mark))

/-- A relay that passes the scan is well formed. -/
theorem wf_of_check {R : Relay} (h : R.check = true) : R.WF := by
  simp only [check, List.all_eq_true, Bool.and_eq_true,
    decide_eq_true_eq, Bool.not_eq_eq_eq_not, Bool.not_true, List.contains_eq_mem,
    decide_eq_false_iff_not] at h
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro S hS b hb c hc
    exact ((h S hS).1.1 b hb c hc).1
  · intro S hS b hb hmem
    exact absurd (((h S hS).1.1 b hb sep hmem).2) (by simp)
  · intro S hS
    exact (h S hS).1.2
  · intro S hS b hb c hc
    have := (h S hS).2 b hb c hc
    refine ⟨by simpa using this.1, ?_⟩
    simpa using this.2

theorem mem_stages (R : Relay) (i : Nat) : R.stage i ∈ R.stages := by
  have hlt : i % R.size < R.size := Nat.mod_lt _ R.size_pos
  have : R.stages[i % R.size]? = some (R.stages[i % R.size]'hlt) := by
    exact List.getElem?_eq_getElem hlt
  simp only [stage, List.getD, this, Option.getD]
  exact List.getElem_mem hlt

end Relay

/-- The universal interpreter of the relay: rebuild the program of stage `j` out
of the text of any program of the relay.  This is what each of the programs
actually does when it runs — read the digits out of its own payload region, no
matter what notation they are written in, decode them into the blocks, and print
block `5j`, the digits laid out in stage `j`'s own shape, and block `5j+1`. -/
def host (j : Nat) (t : List Char) : Option (List Char) := do
  let region ← extract t
  let d := parseDigits region
  let ch ← decode d
  let segs := splitOnChar sep ch
  let pre ← segs[5 * j]?
  let post ← segs[5 * j + 1]?
  let hd ← segs[5 * j + 2]?
  let gl ← segs[5 * j + 3]?
  let tl ← segs[5 * j + 4]?
  pure (pre ++ mark :: (hd ++ chunkJoin width gl d ++ tl ++ mark :: post))

/-- Running the program of stage `i` of a relay of `n` stages: it hosts its
successor around the cycle. -/
def run (n i : Nat) (t : List Char) : Option (List Char) := host ((i + 1) % n) t

/-- Running the relay for `k` steps, starting at stage `i` of `n`. -/
def runN (n : Nat) : Nat → Nat → List Char → Option (List Char)
  | 0, _, t => some t
  | k + 1, i, t => (run n i t).bind fun t' => runN n k ((i + 1) % n) t'

namespace Relay

variable {R : Relay}

/-- Indexing the blocks: block `5j+k` is the `k`-th block of stage `j`. -/
theorem blocks_getElem_aux (l : List StageSpec) (j k : Nat) (hj : j < l.length) (hk : k < 5) :
    (l.flatMap StageSpec.blocks)[5 * j + k]? = (l[j]'hj).blocks[k]? := by
  induction l generalizing j with
  | nil => exact absurd hj (by simp)
  | cons S rest ih =>
    cases j with
    | zero =>
      have hlen : S.blocks.length = 5 := by simp [StageSpec.blocks]
      simp only [List.flatMap_cons, Nat.mul_zero, Nat.zero_add]
      rw [List.getElem?_append_left (by omega)]
      simp
    | succ j =>
      have hlen : S.blocks.length = 5 := by simp [StageSpec.blocks]
      have hj' : j < rest.length := by simpa using hj
      have hidx : 5 * (j + 1) + k = S.blocks.length + (5 * j + k) := by omega
      simp only [List.flatMap_cons, hidx]
      rw [List.getElem?_append_right (by omega)]
      simp only [Nat.add_sub_cancel_left]
      simpa using ih j hj'

theorem blocks_getElem (R : Relay) {j : Nat} (hj : j < R.size) {k : Nat} (hk : k < 5) :
    R.blocks[5 * j + k]? = (R.stage j).blocks[k]? := by
  have h := blocks_getElem_aux R.stages j k hj hk
  rw [blocks, h]
  congr 1
  rw [stage_of_lt R hj, List.getD]
  simp [List.getElem?_eq_getElem hj]

theorem mem_blocks_iff (R : Relay) (b : List Char) :
    b ∈ R.blocks ↔ ∃ S ∈ R.stages, b ∈ S.blocks := by
  simp [blocks, List.mem_flatMap]

theorem blocks_ne (R : Relay) : R.blocks ≠ [] := by
  cases h : R.stages with
  | nil => exact absurd h R.ne
  | cons S rest => simp [blocks, h, StageSpec.blocks]

theorem isDigit_digits (R : Relay) : ∀ c ∈ R.digits, isDigit c = true :=
  isDigit_of_mem_encode _

theorem mark_not_mem_digits (R : Relay) : mark ∉ R.digits :=
  not_mem_encode _ _ (Or.inr (by decide))

theorem codeable_data (h : R.WF) : ∀ c ∈ R.data, Codeable c := by
  intro c hc
  rcases mem_joinWith sep R.blocks c hc with rfl | ⟨s, hs, hcs⟩
  · show (sep : Char).toNat < 1000
    rw [sep, toNat_ofNat_of_lt (by omega)]
    omega
  · obtain ⟨S, hS, hbS⟩ := (mem_blocks_iff R s).1 hs
    exact h.codeable S hS s hbS c hcs

theorem decode_digits (h : R.WF) : decode R.digits = some R.data :=
  decode_encode _ (codeable_data h)

theorem split_data (h : R.WF) : splitOnChar sep R.data = R.blocks :=
  splitOnChar_joinWith sep R.blocks (blocks_ne R) (by
    intro s hs
    obtain ⟨S, hS, hbS⟩ := (mem_blocks_iff R s).1 hs
    exact h.sep_free S hS s hbS)

/-- The payload region of a program of a well-formed relay is that program's
rendering of the relay's digits. -/
theorem extract_prog (h : R.WF) (i : Nat) :
    extract (R.prog i) = some ((R.stage i).shape.render R.digits) :=
  extract_frame _ _ _ (h.mark_free _ (mem_stages R i))
    (Shape.mark_not_mem_render _ (h.clean _ (mem_stages R i)) _ (mark_not_mem_digits R))

/-- Whatever shape a program carries its payload in, the digits read back out of
it are the relay's digits. -/
theorem parse_prog (h : R.WF) (i : Nat) :
    parseDigits ((R.stage i).shape.render R.digits) = R.digits :=
  Shape.parse_render _ (h.clean _ (mem_stages R i)) _ (isDigit_digits R)

/-- **Hosting.** Any program of a well-formed relay reprints the program of any
stage `j` — itself included. -/
theorem host_prog (h : R.WF) (i j : Nat) (hj : j < R.size) :
    host j (R.prog i) = some (R.prog j) := by
  have hex := extract_prog h i
  have hpar := parse_prog h i
  have h0 := blocks_getElem R hj (k := 0) (by omega)
  have h1 := blocks_getElem R hj (k := 1) (by omega)
  have h2 := blocks_getElem R hj (k := 2) (by omega)
  have h3 := blocks_getElem R hj (k := 3) (by omega)
  have h4 := blocks_getElem R hj (k := 4) (by omega)
  simp only [StageSpec.blocks, Nat.add_zero, List.getElem?_cons_zero, List.getElem?_cons_succ] at h0 h1 h2 h3 h4
  simp only [host, hex, Option.bind_eq_bind, Option.bind_some, hpar, decode_digits h,
    split_data h, h0, h1, h2, h3, h4]
  simp only [prog, Shape.render, List.append_assoc]
  rfl

/-- **The quine property.** Every program of the relay prints itself. -/
theorem host_self (h : R.WF) (i : Nat) (hi : i < R.size) :
    host i (R.prog i) = some (R.prog i) := host_prog h i i hi

/-- **One relay step.** Running stage `i` prints the program of the next stage. -/
theorem run_prog (h : R.WF) (i : Nat) :
    run R.size i (R.prog i) = some (R.prog ((i + 1) % R.size)) :=
  host_prog h i _ (Nat.mod_lt _ R.size_pos)

/-- Two indices that agree around the cycle name the same program. -/
theorem prog_congr (R : Relay) {a b : Nat} (hab : a % R.size = b % R.size) :
    R.prog a = R.prog b := by
  simp only [prog, stage, hab]

/-- Running `k` steps from stage `i` lands on stage `i + k`, around the cycle. -/
theorem runN_eq (h : R.WF) : ∀ (k i : Nat),
    runN R.size k i (R.prog i) = some (R.prog ((i + k) % R.size)) := by
  intro k
  induction k with
  | zero =>
    intro i
    simp only [runN, Nat.add_zero]
    rw [prog_congr R (a := i) (b := i % R.size)
      (Nat.mod_eq_of_lt (Nat.mod_lt _ R.size_pos)).symm]
  | succ k ih =>
    intro i
    have hstep : run R.size i (R.prog i) = some (R.prog ((i + 1) % R.size)) := run_prog h i
    have harith : ((i + 1) % R.size + k) % R.size = (i + (k + 1)) % R.size := by
      rw [Nat.mod_add_mod]
      congr 1
      omega
    simp only [runN, hstep, Option.bind_some, ih ((i + 1) % R.size), harith]

/-- **The relay closes.** As many steps as there are stages return the program
you started from. -/
theorem runN_size (h : R.WF) (i : Nat) (hi : i < R.size) :
    runN R.size R.size i (R.prog i) = some (R.prog i) := by
  rw [runN_eq h R.size i]
  congr 1
  have : (i + R.size) % R.size = i % R.size := by
    simp [Nat.add_mod_right]
  rw [this, Nat.mod_eq_of_lt hi]

end Relay

end RequestProject.Relay
