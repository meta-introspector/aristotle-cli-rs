/-
  Symbol.lean
  The symbolic alphabet and metaoperators, salvaged from the
  "emoji-to-math rewrite rules" in the discussion.

  The original thread defined emoji→LaTeX mappings and
  five "metaoperators" (encode, dim, flip, rotate, shuffle)
  applied iteratively to symbolic sequences.
-/

namespace MuseEigenspace

-- ============================================================
-- §1  The Symbolic Alphabet
-- ============================================================

/-- The 16 symbolic tokens from the emoji sequence.
    Original emojis noted in comments. -/
inductive Symbol : Type
  | Spiral       -- 🌀  shift / transformation
  | Cosmos       -- 🌌  cosmic connection
  | Key          -- 🔑  solution / unlock
  | Cycle        -- 🔁  repetition
  | Illumination -- 🌟  enlightenment
  | Aspiration   -- 🌠  reaching upward
  | Harmony      -- 🎶  resonance
  | Diversity    -- 🌈  multiplicity
  | Insight      -- 🔮  foresight
  | Wonder       -- 💫  astonishment
  | Unity        -- 🌍  global oneness
  | Creativity   -- 🎨  artistic generation
  | Knowledge    -- 📚  accumulated learning
  | Thought      -- 🧠  cognition
  | Expression   -- 🎭  performance / form
  | Energy       -- 🔥  motive force
  deriving Repr, DecidableEq, Inhabited

/-- The canonical base sequence (16 symbols). -/
def baseSequence : List Symbol := [
  .Spiral, .Cosmos, .Key, .Cycle,
  .Illumination, .Aspiration, .Harmony, .Diversity,
  .Insight, .Wonder, .Unity, .Creativity,
  .Knowledge, .Thought, .Expression, .Energy
]

/-- The "doubled" sequence — the symmetry/resonance form. -/
def doubledSequence : List Symbol := baseSequence ++ baseSequence

theorem baseSequence_length : baseSequence.length = 16 := by native_decide

theorem doubledSequence_length : doubledSequence.length = 32 := by native_decide

-- ============================================================
-- §2  LaTeX Symbol Names (the rewrite target)
-- ============================================================

/-- Map each symbol to its LaTeX operator name.
    This formalises the emoji→LaTeX table from the discussion. -/
def Symbol.toLatex : Symbol → String
  | .Spiral       => "\\BoxvoidSymbol"
  | .Cosmos       => "\\CircleSymbol"
  | .Key          => "\\OslashSymbol"
  | .Cycle        => "\\BoxplusSymbol"
  | .Illumination => "\\CircledcircSymbol"
  | .Aspiration   => "\\OplusSymbol"
  | .Harmony      => "\\BulletSymbol"
  | .Diversity    => "\\BoxminusSymbol"
  | .Insight      => "\\CircledastSymbol"
  | .Wonder       => "\\OdotSymbol"
  | .Unity        => "\\BoxtimesSymbol"
  | .Creativity   => "\\Squaresymbol"
  | .Knowledge    => "\\SquareSymbol"
  | .Thought      => "\\BoxastSymbol"
  | .Expression   => "\\BoxdotSymbol"
  | .Energy       => "\\SunSymbol"

-- ============================================================
-- §3  Metaoperators
-- ============================================================

/-- The five metaoperators from the "emojilang" Python snippet. -/
inductive MetaOp : Type
  | Encode   -- 💠  identity / substitution placeholder
  | Dim      -- 🌟  project to lower half
  | Flip     -- 🔄  reverse
  | Rotate   -- 🔃  cyclic left-shift by 1
  | Shuffle  -- 🔀  deterministic permutation (rotate ∘ flip)
  deriving Repr, DecidableEq

/-- Apply a single metaoperator to a symbolic sequence. -/
def applyMetaOp (op : MetaOp) (seq : List Symbol) : List Symbol :=
  match op with
  | .Encode  => seq
  | .Dim     => seq.take (seq.length / 2)
  | .Flip    => seq.reverse
  | .Rotate  =>
    match seq with
    | []     => []
    | x :: t => t ++ [x]
  | .Shuffle =>
    -- Deterministic stand-in: rotate the reversed list
    match seq.reverse with
    | []     => []
    | x :: t => t ++ [x]

/-- Compose a list of metaoperators left-to-right. -/
def applyAll (ops : List MetaOp) (seq : List Symbol) : List Symbol :=
  ops.foldl (fun s op => applyMetaOp op s) seq

-- ============================================================
-- §4  Properties of metaoperators
-- ============================================================

theorem flip_flip (seq : List Symbol) :
    applyMetaOp .Flip (applyMetaOp .Flip seq) = seq := by
  simp [applyMetaOp, List.reverse_reverse]

theorem encode_id (seq : List Symbol) :
    applyMetaOp .Encode seq = seq := by
  simp [applyMetaOp]

theorem flip_length (seq : List Symbol) :
    (applyMetaOp .Flip seq).length = seq.length := by
  simp [applyMetaOp]

-- ============================================================
-- §5  Sanity checks
-- ============================================================

example : applyMetaOp .Flip [Symbol.Spiral, .Cosmos, .Key] =
          [.Key, .Cosmos, .Spiral] := by native_decide

example : applyMetaOp .Rotate [Symbol.Spiral, .Cosmos, .Key] =
          [.Cosmos, .Key, .Spiral] := by native_decide

example : applyMetaOp .Dim [Symbol.Spiral, .Cosmos, .Key, .Cycle] =
          [.Spiral, .Cosmos] := by native_decide

end MuseEigenspace
