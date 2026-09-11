/-
# The rendering kernel, §1–§2: the abstract game kernel and replay

The renderer specification is written as if `World`, `Move`, `step` and
`Valid` were globally fixed.  They are not: every game has its own.  So
the whole runtime, share and rendering machinery in this layer is written
once, generically, over a **`GameKernel`** record, and each game is an
instance of it.  "A renderer must not import another game's rules" then
becomes a fact about the dependency graph rather than a rule anyone has
to remember.

Two deliberate departures from the original spec, both forced:

* validity is a **`Bool`**, not a `Prop`.  A browser has to check the
  validity of untrusted input, and a `Prop` has no runtime content.  A
  game that wants a propositional reading states `validB w = true ↔ Valid w`
  itself;
* legal-move enumeration (`availableMoves`) lives on the **kernel** side,
  not in the renderer: enumerating legal moves is game semantics, and the
  renderer is forbidden to know the rules.

Proved here:

* `runFrom_append` — prefix compositionality of replay,
  `run w (ms ++ ns) = (run w ms).bind (run · ns)`.  Almost everything in
  the runtime layer is a corollary of this one lemma;
* `replay_valid` — replaying a seed under the kernel yields a valid
  world.  This is the trust anchor of the whole design: a page believes a
  world because it *recomputed* it, not because a digest matched;
* `encodeMove_injective` / `decodeMoves_encodeMoves` — the move codec is
  a real codec, so a token names exactly one move sequence.
-/
import Mathlib
import RequestProject.Kant.Bytes

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel

/-- A seed names a starting position.  Games interpret it however they
like; `gen` may reject seeds it does not understand. -/
abbrev SeedId := Nat

/-! ## The kernel interface -/

/-- Everything the generic runtime needs to know about a game, and
nothing more.  The four proof fields are the obligations an adapter
discharges once; every theorem in this layer is then available to it.

`validB` replaces the spec's `Valid : World → Prop` (see the module
header), and `availableMoves` lives here rather than in the renderer. -/
structure GameKernel where
  /-- The game's state. -/
  World : Type
  /-- The game's atomic transition. -/
  Move : Type
  /-- Apply a move.  `none` means "illegal in this state". -/
  step : World → Move → Option World
  /-- The starting world of a seed, if the seed is one this game knows. -/
  gen : SeedId → Option World
  /-- Structural validity, decidable because untrusted input must be
  checked in the browser. -/
  validB : World → Bool
  /-- The legal moves of a state: kernel-side, because this is a rule. -/
  availableMoves : World → List Move
  /-- Canonical encoding of a move as a list of naturals. -/
  encodeMove : Move → List Nat
  /-- Its decoder, in rest-passing style, so moves concatenate. -/
  decodeMove : List Nat → Option (Move × List Nat)
  /-- The codec is a codec: this is what makes a share token name exactly
  one move sequence. -/
  decodeMove_encodeMove :
    ∀ (m : Move) (rest : List Nat), decodeMove (encodeMove m ++ rest) = some (m, rest)
  /-- A generated world is valid. -/
  gen_valid : ∀ (s : SeedId) (w : World), gen s = some w → validB w = true
  /-- Validity is preserved by legal moves. -/
  step_valid :
    ∀ (w : World) (m : Move) (w' : World), validB w = true → step w m = some w' → validB w' = true
  /-- The enumerated moves really are legal. -/
  availableMoves_legal : ∀ (w : World) (m : Move), m ∈ availableMoves w → (step w m).isSome

namespace GameKernel

variable {K : GameKernel}

/-! ## Replay -/

/-- Apply a list of moves in order, stopping at the first rejection. -/
def runFrom (K : GameKernel) (w : K.World) : List K.Move → Option K.World
  | [] => some w
  | m :: ms => match K.step w m with
      | some w' => K.runFrom w' ms
      | none => none

/-- Replay a whole history: generate the seed, then run the moves. -/
def replay (K : GameKernel) (s : SeedId) (ms : List K.Move) : Option K.World :=
  (K.gen s).bind (fun w => K.runFrom w ms)

@[simp] theorem runFrom_nil (w : K.World) : K.runFrom w [] = some w := rfl

@[simp] theorem runFrom_cons (w : K.World) (m : K.Move) (ms : List K.Move) :
    K.runFrom w (m :: ms) = (K.step w m).bind (fun w' => K.runFrom w' ms) := by
  cases h : K.step w m <;> simp [runFrom, h]

/-- **Prefix compositionality.**  Replaying `ms ++ ns` is replaying `ms`
and then `ns`.  Opening the token of a prefix reconstructs exactly the
world that the longer history passed through, without knowing the rest. -/
theorem runFrom_append (w : K.World) (ms ns : List K.Move) :
    K.runFrom w (ms ++ ns) = (K.runFrom w ms).bind (fun w' => K.runFrom w' ns) := by
  induction ms generalizing w with
  | nil => simp
  | cons m ms ih =>
      cases h : K.step w m with
      | none => simp [h]
      | some w' => simp [h, ih]

/-- The same, from a seed. -/
theorem replay_append (s : SeedId) (ms ns : List K.Move) :
    K.replay s (ms ++ ns) = (K.replay s ms).bind (fun w => K.runFrom w ns) := by
  cases h : K.gen s <;> simp [replay, h, runFrom_append]

@[simp] theorem replay_nil (s : SeedId) : K.replay s [] = K.gen s := by
  cases h : K.gen s <;> simp [replay, h]

/-- A replayed prefix is defined whenever the whole history is. -/
theorem replay_isSome_of_prefix {s : SeedId} {ms ns : List K.Move}
    (h : (K.replay s (ms ++ ns)).isSome) : (K.replay s ms).isSome := by
  rw [replay_append] at h
  cases hm : K.replay s ms with
  | none => simp [hm] at h
  | some _ => simp

/-- Truncating a history to its first `k` moves keeps it replayable. -/
theorem replay_take_isSome {s : SeedId} {ms : List K.Move} (k : Nat)
    (h : (K.replay s ms).isSome) : (K.replay s (ms.take k)).isSome :=
  replay_isSome_of_prefix (ms := ms.take k) (ns := ms.drop k) (by simpa using h)

/-! ## Validity is preserved by replay -/

theorem runFrom_valid {w w' : K.World} {ms : List K.Move}
    (hv : K.validB w = true) (h : K.runFrom w ms = some w') : K.validB w' = true := by
  induction ms generalizing w with
  | nil =>
      rw [runFrom_nil] at h
      cases h
      exact hv
  | cons m ms ih =>
      rw [runFrom_cons] at h
      cases hs : K.step w m with
      | none => rw [hs] at h; simp at h
      | some w₁ =>
          rw [hs] at h
          exact ih (K.step_valid w m w₁ hv hs) (by simpa using h)

/-- **The trust anchor.**  A world obtained by replaying a seed under the
kernel is valid — not because anything was signed or hashed, but because
it was recomputed. -/
theorem replay_valid {s : SeedId} {ms : List K.Move} {w : K.World}
    (h : K.replay s ms = some w) : K.validB w = true := by
  rw [replay] at h
  cases hg : K.gen s with
  | none => rw [hg] at h; simp at h
  | some w₀ =>
      rw [hg] at h
      exact runFrom_valid (K.gen_valid s w₀ hg) (by simpa using h)

/-! ## The move codec -/

/-- A move sequence encodes as its moves' encodings, concatenated.  The
length is carried separately by the share codec. -/
def encodeMoves (K : GameKernel) (ms : List K.Move) : List Nat :=
  ms.flatMap K.encodeMove

/-- Decode exactly `n` moves, returning what is left. -/
def decodeMoves (K : GameKernel) : Nat → List Nat → Option (List K.Move × List Nat)
  | 0, ns => some ([], ns)
  | k + 1, ns => match K.decodeMove ns with
      | some (m, rest) => (K.decodeMoves k rest).map (fun p => (m :: p.1, p.2))
      | none => none

/-- The codec round-trips, so a token determines its move sequence. -/
theorem decodeMoves_encodeMoves (ms : List K.Move) (rest : List Nat) :
    K.decodeMoves ms.length (K.encodeMoves ms ++ rest) = some (ms, rest) := by
  induction ms with
  | nil => simp [decodeMoves, encodeMoves]
  | cons m ms ih =>
      simp only [encodeMoves, List.flatMap_cons, List.append_assoc, List.length_cons,
        decodeMoves, K.decodeMove_encodeMove m]
      simp only [encodeMoves] at ih
      simp [ih]

theorem encodeMove_injective : Function.Injective K.encodeMove := by
  intro a b h
  have ha := K.decodeMove_encodeMove a ([] : List Nat)
  have hb := K.decodeMove_encodeMove b ([] : List Nat)
  rw [h, hb] at ha
  simpa using ha.symm

/-- Distinct histories of the same length have distinct encodings. -/
theorem encodeMoves_injective {ms ns : List K.Move} (hlen : ms.length = ns.length)
    (h : K.encodeMoves ms = K.encodeMoves ns) : ms = ns := by
  have ha := decodeMoves_encodeMoves (K := K) ms ([] : List Nat)
  have hb := decodeMoves_encodeMoves (K := K) ns ([] : List Nat)
  rw [h, hlen, hb] at ha
  simpa using ha.symm

end GameKernel

end Kant.Kernel
