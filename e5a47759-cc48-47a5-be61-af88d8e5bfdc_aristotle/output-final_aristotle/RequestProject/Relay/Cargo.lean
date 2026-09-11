import RequestProject.Relay.Core

/-!
# Cargo: carrying something *else* around the relay

The relay's programs carry their own source, which is what makes them quines.
This file is about carrying anything else: a *cargo* of arbitrary text — a Lean
file of this repository, say — appended to the code of the first stage, so that

* it is part of the payload every program of the relay carries,
* every program reproduces it byte for byte when it prints the next one,
* it can be read back out of *any* stage, in any language, at any point of the
  trip (`readCargo_prog`),
* and after a full trip around the cycle it is still there, unchanged
  (`cargo_survives_cycle`).

The only demands on the cargo are the ones the payload encoding makes of any
text: every character must be encodable in three decimal digits, and none may be
the separator.  Nothing here bounds its *length* — `cargo_unbounded` says a
relay carrying cargo of any size at all still has all of these properties.  How
much cargo twenty-four real interpreters and compilers will actually carry is a
separate, empirical question; `relay/capacity.py` measures it and `README.md`
reports the answer.
-/

namespace RequestProject.Relay

/-- A stage with cargo added after its code. -/
def StageSpec.withCargo (S : StageSpec) (c : List Char) : StageSpec :=
  ⟨S.pre, S.post ++ c, S.shape⟩

/-- Add the cargo to the first stage of a list of stages. -/
def consCargo (c : List Char) : List StageSpec → List StageSpec
  | [] => []
  | S :: rest => S.withCargo c :: rest

theorem consCargo_ne (c : List Char) {l : List StageSpec} (h : l ≠ []) :
    consCargo c l ≠ [] := by
  cases l with
  | nil => exact absurd rfl h
  | cons S rest => simp [consCargo]


theorem length_consCargo (c : List Char) (l : List StageSpec) :
    (consCargo c l).length = l.length := by
  cases l <;> simp [consCargo]

/-- A stage of a loaded list of stages is one of its stages, possibly with the
cargo added to it. -/
theorem mem_consCargo {c : List Char} {S : StageSpec} {l : List StageSpec}
    (hS : S ∈ consCargo c l) : S ∈ l ∨ ∃ T ∈ l, S = T.withCargo c := by
  cases l with
  | nil => simp [consCargo] at hS
  | cons T rest =>
    simp only [consCargo, List.mem_cons] at hS
    rcases hS with rfl | hS
    · exact Or.inr ⟨T, List.mem_cons_self .., rfl⟩
    · exact Or.inl (List.mem_cons_of_mem T hS)

namespace Relay

variable {R : Relay}

/-- The relay `R`, with `c` carried as cargo in the code of its first stage.
Only the text of stage 0 after its payload changes; every stage still carries
the whole payload, and so every stage carries the cargo. -/
def withCargo (R : Relay) (c : List Char) : Relay where
  stages := consCargo c R.stages
  ne := consCargo_ne c R.ne

@[simp] theorem withCargo_size (R : Relay) (c : List Char) :
    (R.withCargo c).size = R.size := length_consCargo c R.stages

/-- A stage of the loaded relay is a stage of the relay, possibly with the cargo
added to it. -/
theorem mem_withCargo_stages {c : List Char} {S : StageSpec}
    (hS : S ∈ (R.withCargo c).stages) :
    S ∈ R.stages ∨ ∃ T ∈ R.stages, S = T.withCargo c :=
  mem_consCargo hS

/-- Loading a well-formed relay with encodable, separator-free cargo leaves it
well formed. -/
theorem withCargo_wf (h : R.WF) {c : List Char}
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) : (R.withCargo c).WF := by
  have hblocks : ∀ (T : StageSpec) (_ : T ∈ R.stages) (b : List Char),
      b ∈ (T.withCargo c).blocks →
        (∀ ch ∈ b, Codeable ch) ∧ sep ∉ b := by
    intro T hT b hb
    simp only [StageSpec.withCargo, StageSpec.blocks, List.mem_cons,
      List.not_mem_nil, or_false] at hb
    have hT' : ∀ b' ∈ T.blocks, (∀ ch ∈ b', Codeable ch) ∧ sep ∉ b' := by
      intro b' hb'
      exact ⟨h.codeable T hT b' hb', h.sep_free T hT b' hb'⟩
    rcases hb with rfl | rfl | rfl | rfl | rfl
    · exact hT' T.pre (by simp [StageSpec.blocks])
    · refine ⟨?_, ?_⟩
      · intro ch hch
        rcases List.mem_append.1 hch with hch | hch
        · exact (hT' T.post (by simp [StageSpec.blocks])).1 ch hch
        · exact hcode ch hch
      · intro hmem
        rcases List.mem_append.1 hmem with hmem | hmem
        · exact (hT' T.post (by simp [StageSpec.blocks])).2 hmem
        · exact hsep hmem
    · exact hT' T.shape.head (by simp [StageSpec.blocks])
    · exact hT' T.shape.glue (by simp [StageSpec.blocks])
    · exact hT' T.shape.tail (by simp [StageSpec.blocks])
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro S hS b hb ch hch
    rcases mem_withCargo_stages hS with hS' | ⟨T, hT, rfl⟩
    · exact h.codeable S hS' b hb ch hch
    · exact (hblocks T hT b hb).1 ch hch
  · intro S hS b hb
    rcases mem_withCargo_stages hS with hS' | ⟨T, hT, rfl⟩
    · exact h.sep_free S hS' b hb
    · exact (hblocks T hT b hb).2
  · intro S hS
    rcases mem_withCargo_stages hS with hS' | ⟨T, hT, rfl⟩
    · exact h.mark_free S hS'
    · exact h.mark_free T hT
  · intro S hS
    rcases mem_withCargo_stages hS with hS' | ⟨T, hT, rfl⟩
    · exact h.clean S hS'
    · exact h.clean T hT

/-- Block 1 of the loaded relay is the code of stage 0 with the cargo after it. -/
theorem withCargo_blocks_one (R : Relay) (c : List Char) :
    (R.withCargo c).blocks[1]? = some ((R.stage 0).post ++ c) := by
  cases h : R.stages with
  | nil => exact absurd h R.ne
  | cons T rest =>
    have hstage : R.stage 0 = T := by
      have hpos : 0 < R.size := R.size_pos
      simp [stage, Nat.zero_mod, h, List.getD]
    simp [withCargo, consCargo, blocks, h, StageSpec.blocks, StageSpec.withCargo, hstage]

end Relay

/-- Read the last `n` characters of the second block of a program's payload:
the cargo a loaded relay carries.  Like every other reading of a payload this
is shape-agnostic — keep the digits, decode them, split into blocks. -/
def readCargo (n : Nat) (t : List Char) : Option (List Char) := do
  let region ← extract t
  let ch ← decode (parseDigits region)
  let b ← (splitOnChar sep ch)[1]?
  pure (b.drop (b.length - n))

namespace Relay

variable {R : Relay}

/-- **Every program carries the cargo.** Whatever stage you look at, and in
whatever language it is written, the cargo can be read back out of it whole. -/
theorem readCargo_prog (h : R.WF) {c : List Char}
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) (i : Nat) :
    readCargo c.length ((R.withCargo c).prog i) = some c := by
  have hwf : (R.withCargo c).WF := withCargo_wf h hcode hsep
  have hex := extract_prog hwf i
  have hpar := parse_prog hwf i
  simp only [readCargo, hex, Option.bind_eq_bind, Option.bind_some, hpar,
    decode_digits hwf, split_data hwf, withCargo_blocks_one R c]
  have hlen : ((R.stage 0).post ++ c).length - c.length = (R.stage 0).post.length := by
    simp
  rw [hlen, List.drop_left]
  rfl

/-- **One step keeps the cargo.** The program a stage prints carries the same
cargo it did. -/
theorem readCargo_step (h : R.WF) {c : List Char}
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) (i : Nat) :
    (run (R.withCargo c).size i ((R.withCargo c).prog i)).bind (readCargo c.length)
      = some c := by
  rw [run_prog (withCargo_wf h hcode hsep) i]
  exact readCargo_prog h hcode hsep _

/-- **The cargo goes all the way around.** After as many runs as there are
stages the text is the program it started from, and the cargo is still in it. -/
theorem cargo_survives_cycle (h : R.WF) {c : List Char}
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) (i : Nat) (hi : i < R.size) :
    runN (R.withCargo c).size (R.withCargo c).size i ((R.withCargo c).prog i)
        = some ((R.withCargo c).prog i)
      ∧ readCargo c.length ((R.withCargo c).prog i) = some c := by
  refine ⟨runN_size (withCargo_wf h hcode hsep) i ?_, readCargo_prog h hcode hsep i⟩
  simpa using hi

/-- **No bound on the cargo.** For every length there is a cargo of that length
which any well-formed relay carries around its whole cycle: the model puts no
limit on how much can pass through. -/
theorem cargo_unbounded (h : R.WF) (n : Nat) :
    ∃ c : List Char, c.length = n ∧
      ∀ i, readCargo n ((R.withCargo c).prog i) = some c := by
  refine ⟨List.replicate n 'x', List.length_replicate .., fun i => ?_⟩
  have hcode : ∀ ch ∈ List.replicate n 'x', Codeable ch := by
    intro ch hch
    rw [List.eq_of_mem_replicate hch]
    decide
  have hsep : sep ∉ List.replicate n 'x' := by
    intro hmem
    have := List.eq_of_mem_replicate hmem
    simp [sep] at this
  have := readCargo_prog h hcode hsep i
  rwa [List.length_replicate] at this

end Relay

end RequestProject.Relay
