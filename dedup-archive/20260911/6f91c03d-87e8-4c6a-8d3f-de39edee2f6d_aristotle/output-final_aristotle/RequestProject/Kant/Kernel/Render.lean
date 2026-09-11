/-
# The rendering kernel, §3–§5 and §15–§18: trees, adapters, and what a
# proof can honestly say about determinism

A renderer is a **projection** of the kernel: a function from a world to
a `RenderTree`, plus a presentation of the kernel's legal moves, plus a
way to read a click back as a move.  It is not allowed to know the rules,
which is why `availableMoves` lives on the kernel and not here.

`RenderTree` is a concrete inductive type with decidable equality and a
canonical serialization, so that a golden test is meaningful:

* `parseForest_serForest` — the serialization round-trips, hence
* `serTree_injective` — two different trees never print the same bytes.

**What is not a theorem.**  `render w = render w` holds of any Lean
function, so "rendering is deterministic" is free and says nothing.  The
real obligation is that the *emitted JavaScript* computes the same tree
as this Lean `render` on the same world; that is discharged by golden
tests (`web/kernel-test.mjs`), not by a proof.  Likewise "byte-identical
across reproducible builds" is a property of the build, checked by
rebuilding.  What *is* proved here is the part that has content:

* `dispatch_act_render` — the tree after a click is the tree of the world
  that `step` produced, and the runtime invariant survives;
* `share_render` — the tree an opened token displays is the tree of the
  replayed world.  §18's `share_render_correct` is this corollary; it is
  not an independent axiom of the design.

Completeness is deliberately weak — "every displayed control decodes to a
move" — because exhaustive enumeration is false for most games with large
move spaces.  `Exhaustive` states the strong version for the games that
can prove it.
-/
import Mathlib
import RequestProject.Kant.Kernel.Runtime
import RequestProject.Kant.Kernel.Share

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel

open GameKernel

/-! ## The tree -/

/-- What a renderer produces: text, or a tagged node with attributes and
children.  Deliberately small, concrete and comparable. -/
inductive RenderTree where
  /-- A run of text. -/
  | text (s : List Char)
  /-- A tagged element. -/
  | node (tag : List Char) (attrs : List (List Char × List Char)) (kids : List RenderTree)
  deriving Repr, Inhabited

namespace RenderTree

/-- Canonical serialization of a forest.  One recursion, so one
induction: `'t'` and `'n'` tag the two shapes, everything else is
length-prefixed by `Kant.Kernel.Codec`. -/
def serForest : List RenderTree → List Char
  | [] => []
  | .text s :: ts => 't' :: (Codec.encStr s ++ serForest ts)
  | .node tag attrs kids :: ts =>
      'n' :: (Codec.encStr tag ++ Codec.encPairs attrs ++ Codec.encNat kids.length ++
        serForest kids ++ serForest ts)
termination_by ts => sizeOf ts

/-- Canonical serialization of one tree. -/
def serTree (t : RenderTree) : List Char := serForest [t]

/-- Fuel enough to parse a forest back: one per node along any path the
parser takes. -/
def forestFuel : List RenderTree → Nat
  | [] => 0
  | .text _ :: ts => 1 + forestFuel ts
  | .node _ _ kids :: ts => 1 + max (forestFuel kids) (forestFuel ts)
termination_by ts => sizeOf ts

/-- Parse `k` serialized trees, with fuel. -/
def parseForest : Nat → Nat → List Char → Option (List RenderTree × List Char)
  | _, 0, cs => some ([], cs)
  | 0, _ + 1, _ => none
  | f + 1, k + 1, cs =>
      match cs with
      | [] => none
      | c :: cs₀ =>
          if c = 't' then
            match Codec.decStr cs₀ with
            | some (s, cs₁) =>
                (parseForest f k cs₁).map (fun p => (RenderTree.text s :: p.1, p.2))
            | none => none
          else if c = 'n' then
            match Codec.decStr cs₀ with
            | some (tag, cs₁) =>
                match Codec.decPairs cs₁ with
                | some (attrs, cs₂) =>
                    match Codec.decNat cs₂ with
                    | some (n, cs₃) =>
                        match parseForest f n cs₃ with
                        | some (kids, cs₄) =>
                            (parseForest f k cs₄).map
                              (fun p => (RenderTree.node tag attrs kids :: p.1, p.2))
                        | none => none
                    | none => none
                | none => none
            | none => none
          else none

/-- **The serialization round-trips**, against any suffix, so trees
concatenate unambiguously. -/
theorem parseForest_serForest :
    ∀ (f : Nat) (ts : List RenderTree) (rest : List Char), forestFuel ts ≤ f →
      parseForest f ts.length (serForest ts ++ rest) = some (ts, rest) := by
  intro f
  induction f with
  | zero =>
      intro ts rest _
      cases ts with
      | nil => simp [serForest, parseForest]
      | cons t ts =>
          exfalso
          cases t with
          | text s => simp [forestFuel] at *
          | node tag attrs kids => simp [forestFuel] at *
  | succ f ih =>
      intro ts rest hfuel
      cases ts with
      | nil => simp [serForest, parseForest]
      | cons t ts =>
          cases t with
          | text s =>
              have hts : forestFuel ts ≤ f := by
                simp only [forestFuel] at hfuel; omega
              simp only [serForest, List.cons_append, List.append_assoc, List.length_cons,
                parseForest, Codec.decStr_encStr, ih ts rest hts]
              simp
          | node tag attrs kids =>
              have hkids : forestFuel kids ≤ f := by
                simp only [forestFuel] at hfuel; omega
              have hts : forestFuel ts ≤ f := by
                simp only [forestFuel] at hfuel; omega
              simp only [serForest, List.cons_append, List.append_assoc, List.length_cons,
                parseForest, Codec.decStr_encStr, Codec.decPairs_encPairs, Codec.decNat_encNat,
                ih kids (serForest ts ++ rest) hkids, ih ts rest hts]
              simp

/-- Two different trees never serialize the same way. -/
theorem serTree_injective : Function.Injective serTree := by
  intro a b hab
  have hf : forestFuel [a] ≤ forestFuel [a] + forestFuel [b] := by omega
  have hg : forestFuel [b] ≤ forestFuel [a] + forestFuel [b] := by omega
  have ha := parseForest_serForest (forestFuel [a] + forestFuel [b]) [a] [] hf
  have hb := parseForest_serForest (forestFuel [a] + forestFuel [b]) [b] [] hg
  rw [serTree, serTree] at hab
  simp only [List.length_cons, List.length_nil] at ha hb
  rw [hab] at ha
  rw [hb] at ha
  simpa using ha.symm

/-- Decidable equality, via the injective serialization: a golden test
can compare trees. -/
instance : DecidableEq RenderTree := fun a b =>
  decidable_of_iff (serTree a = serTree b)
    ⟨fun h => serTree_injective h, fun h => by rw [h]⟩

end RenderTree

/-! ## The adapter -/

/-- A control the user can operate: a label to show and an opaque payload
the adapter understands. -/
structure RenderAction where
  /-- What the control says. -/
  label : List Char
  /-- What pressing it means to the adapter. -/
  payload : List Nat
  deriving DecidableEq, Repr, Inhabited

/-- The renderer side of a game: it draws worlds, lays out controls, and
reads a control back as a move *in the state it was drawn for* (the same
click means different things in different states).

It does **not** decide legality: `decodeAction` may return a move that
`step` refuses, and the runtime refuses it.  Soundness is by
construction — the only way to reach a new world is `step`. -/
structure GameRenderer (K : GameKernel) where
  /-- The projection: a world's picture. -/
  render : K.World → RenderTree
  /-- The controls to show for a world. -/
  moveUI : K.World → List RenderAction
  /-- Read a control back as a move. -/
  decodeAction : K.World → RenderAction → Option K.Move
  /-- **Weak completeness**: every control that is displayed means
  something.  (Strong completeness — every legal move has a control — is
  `Exhaustive` below, an optional per-game theorem.) -/
  moveUI_decodes : ∀ (w : K.World) (a : RenderAction), a ∈ moveUI w → (decodeAction w a).isSome

variable {K : GameKernel}

/-- The strong form of completeness, for games whose move space is small
enough to enumerate in the interface. -/
def Exhaustive (G : GameRenderer K) : Prop :=
  ∀ (w : K.World) (m : K.Move), m ∈ K.availableMoves w →
    ∃ a ∈ G.moveUI w, G.decodeAction w a = some m

/-- The move a control means in the runtime's current state. -/
def GameRenderer.decodeIn (G : GameRenderer K) (r : Runtime K) (a : RenderAction) :
    Option K.Move :=
  r.world.bind (fun w => G.decodeAction w a)

/-- The user interface's only entry point: a click becomes a move, or
nothing at all. -/
def GameRenderer.onAction (G : GameRenderer K) (r : Runtime K) (a : RenderAction) : Runtime K :=
  match G.decodeIn r a with
  | some m => Runtime.dispatch r (.act m)
  | none => r

/-- A control that means nothing in this state does nothing. -/
theorem onAction_eq_self_of_undecodable (G : GameRenderer K) (r : Runtime K) {a : RenderAction}
    (h : G.decodeIn r a = none) : G.onAction r a = r := by
  simp only [GameRenderer.onAction, h]

/-- **§18, restated against the runtime.**  Pressing a control that
decodes to a legal move advances the runtime by exactly that move, the
invariant survives, and the new picture is the picture of the new
world. -/
theorem onAction_render (G : GameRenderer K) (r : Runtime K) (hr : r.Wf)
    {w w' : K.World} {a : RenderAction} {m : K.Move}
    (hw : r.world = some w) (ha : G.decodeAction w a = some m) (hs : K.step w m = some w') :
    (G.onAction r a).world = some w' ∧
      (G.onAction r a).Wf ∧
      (G.onAction r a).world.map G.render = some (G.render w') := by
  have hd : G.decodeIn r a = some m := by
    rw [GameRenderer.decodeIn, hw]
    exact ha
  have hop : G.onAction r a = Runtime.dispatch r (.act m) := by
    simp only [GameRenderer.onAction, hd]
  obtain ⟨hworld, _, _⟩ := Runtime.apply_world hw hs
  refine ⟨?_, ?_, ?_⟩ <;> rw [hop]
  · exact hworld
  · exact Runtime.dispatch_wf r (.act m) hr
  · show (Runtime.apply r m).world.map G.render = some (G.render w')
    rw [hworld]
    rfl

/-- The decoded move really was what the control said; nothing else can
enter the history. -/
theorem dispatch_act_rejected (r : Runtime K) {m : K.Move}
    (h : r.world.bind (fun w => K.step w m) = none) : Runtime.dispatch r (.act m) = r :=
  Runtime.apply_eq_self_of_rejected h

/-- **§18's `share_render_correct`, as a corollary rather than an
axiom.**  The picture an opened token shows is the picture of the world
its history replays to. -/
theorem share_render (G : GameRenderer K) (h : History K) :
    (Share.verify K (Share.share K h)).map (fun hh => hh.world.map G.render)
      = some ((K.replay h.seed h.moves).map G.render) := by
  rw [Share.verify_share]
  rfl

end Kant.Kernel
