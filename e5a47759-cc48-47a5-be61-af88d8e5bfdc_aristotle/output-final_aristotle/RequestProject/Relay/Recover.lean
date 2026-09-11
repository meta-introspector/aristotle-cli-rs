import RequestProject.Relay.Templates

/-!
# One program is the whole relay

`Relay.host_prog` says any program of a well-formed relay reprints the program
of *any stage you name*.  That leaves one thing unsaid: how would a reader know
how many stages to ask for?  This file closes that gap — the length of the ring
is in the payload too, so a single program is enough to recover the entire
relay without being told anything about it.

* `readBlocks` — the blocks of the relay, read out of the text of any program.
* `readSize` — how many stages the ring has, computed from those blocks.
* `rebuildAll` / `rebuildAll_prog` — **the whole ring from one program.**  Read
  the size, then host every stage; what comes back is every program of the
  relay, in order.
* `stages_rebuild_all` — the same for the concrete twenty-two-stage relay: hand
  a reader any one of the twenty-two programs, in any of the twenty-two
  languages, and they can reconstruct the other twenty-one.
-/

namespace RequestProject.Relay

namespace Relay

variable {R : Relay}

/-! ## Reading the relay out of a program -/

/-- The blocks of the relay, read out of the text of a program: take the payload
region, keep the digits whatever notation they are in, decode, and split on the
separator. -/
def readBlocks (t : List Char) : Option (List (List Char)) := do
  let region ← extract t
  let ch ← decode (parseDigits region)
  pure (splitOnChar sep ch)

theorem readBlocks_prog (h : R.WF) (i : Nat) : readBlocks (R.prog i) = some R.blocks := by
  simp only [readBlocks, extract_prog h i, Option.bind_eq_bind, Option.bind_some,
    parse_prog h i, decode_digits h, split_data h, Option.pure_def]

theorem blocks_length (R : Relay) : R.blocks.length = 5 * R.size := by
  have haux : ∀ l : List StageSpec, (l.flatMap StageSpec.blocks).length = 5 * l.length := by
    intro l
    induction l with
    | nil => rfl
    | cons S rest ih =>
        simp only [List.flatMap_cons, List.length_append, ih, List.length_cons,
          List.length_nil, StageSpec.blocks]
        omega
  simpa [blocks, size] using haux R.stages

/-- **How long is the ring?**  Five blocks per stage, so the payload of any one
program says how many stages there are. -/
def readSize (t : List Char) : Option Nat := (readBlocks t).map fun bs => bs.length / 5

theorem readSize_prog (h : R.WF) (i : Nat) : readSize (R.prog i) = some R.size := by
  simp only [readSize, readBlocks_prog h i, Option.map_some, blocks_length]
  congr 1
  omega

/-! ## Rebuilding every program -/

/-- Host the first `n` stages of whatever relay this text belongs to. -/
def hostAll (t : List Char) : Nat → Option (List (List Char))
  | 0 => some []
  | n + 1 => do
      let rest ← hostAll t n
      let p ← host n t
      pure (rest ++ [p])

/-- Rebuild the whole relay from the text of one of its programs: read the
number of stages out of the payload, then host each of them. -/
def rebuildAll (t : List Char) : Option (List (List Char)) :=
  (readSize t).bind (hostAll t)

theorem hostAll_prog (h : R.WF) (i : Nat) : ∀ n, n ≤ R.size →
    hostAll (R.prog i) n = some ((List.range n).map R.prog) := by
  intro n
  induction n with
  | zero => intro _; rfl
  | succ n ih =>
      intro hn
      have hle : n ≤ R.size := Nat.le_of_succ_le hn
      have hlt : n < R.size := hn
      simp only [hostAll, ih hle, Option.bind_eq_bind, Option.bind_some,
        host_prog h i n hlt, List.range_succ, List.map_append, List.map_cons, List.map_nil,
        Option.pure_def]

/-- **The whole ring, from one program.**  Any program of a well-formed relay
determines the number of stages and the text of every one of them. -/
theorem rebuildAll_prog (h : R.WF) (i : Nat) :
    rebuildAll (R.prog i) = some ((List.range R.size).map R.prog) := by
  simp only [rebuildAll, readSize_prog h i, Option.bind_some]
  exact hostAll_prog h i R.size (Nat.le_refl _)

/-- Nothing is missing from what comes back: the rebuilt list has one entry per
stage, and entry `j` is the program of stage `j`. -/
theorem rebuildAll_getElem (h : R.WF) (i : Nat) {l : List (List Char)}
    (hl : rebuildAll (R.prog i) = some l) :
    l.length = R.size ∧ ∀ j (hj : j < l.length), l[j] = R.prog j := by
  rw [rebuildAll_prog h i] at hl
  cases hl
  refine ⟨by simp, ?_⟩
  intro j hj
  simp only [List.length_map, List.length_range] at hj
  simp [List.getElem_map, List.getElem_range]

end Relay

/-! ## The twenty-two-stage relay -/

/-- **Hand a reader one program and they can rebuild the other twenty-one.**
No accompanying description of the relay is needed: the number of stages, and
the text of each, come out of the program's own payload. -/
theorem stages_rebuild_all (i : Nat) :
    Relay.rebuildAll (stages.prog i) = some ((List.range 22).map stages.prog) := by
  have := Relay.rebuildAll_prog stages_wf i
  rwa [stages_size] at this

/-- The reader also learns how long the ring is before asking for anything. -/
theorem stages_readSize (i : Nat) : Relay.readSize (stages.prog i) = some 22 := by
  have := Relay.readSize_prog stages_wf i
  rwa [stages_size] at this

end RequestProject.Relay
