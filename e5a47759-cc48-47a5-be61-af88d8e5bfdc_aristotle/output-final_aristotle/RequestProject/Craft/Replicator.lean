import RequestProject.Craft.Parts

/-!
# The replicator: fabricate the parts, assemble the copy, run it again

`RequestProject/SelfCopying.lean` proves the *informational* fixed point — the deck
that comes off the press is the deck that built the workshop.  `RequestProject/Parts.lean`
adds the *physical* accounting — boxes of parts, assembly, fabrication.  This file
closes the loop between them.

A deck **replicates** when

1. its machines can fabricate parts (it contains a press / fabricator),
2. a full fabrication run makes exactly the deck's bill of materials,
3. that output assembles the entire deck, in deck order, with **nothing left over**,
4. and the assembled copy emits the very deck it was built from.

`replicates_of_checkEntry` proves that the mechanical judge of the earlier file is
already enough: any deck it accepts replicates in this stronger, physical sense.
The clay entry, the clay workshop and **the pipe version** — the same machine built
out of pipe segments, elbows, valves and a pump rotor instead of clay bricks and a
stone weight — are all shown to replicate.

`generation_eq` is the endless form: generation `n` of the deck is the deck, for
every `n`, so every copy calls for the same boxes of parts as the original
(`deckBOM_generation`).
-/

namespace Replicate

open SelfCopy

/-! ## §1  What replication means -/

/-- **The replication predicate.**  Fabricate, assemble, and come out with the deck
you started from and an empty floor. -/
def Replicates (cs : CardSet) : Prop :=
  Productive cs ∧
  (∀ p, fabricate (deckPartSeq cs) (deckPartSeq cs).length p = deckBOM cs p) ∧
  (∃ left, assembleDeck (deckBOM cs) cs = some left ∧ ∀ p, left p = 0) ∧
  SelfCopying cs

/-- **Main theorem.**  Every deck the judge accepts replicates physically: its own
machines make its own parts, those parts assemble it exactly, and the assembled copy
prints the deck again. -/
theorem replicates_of_checkEntry (cs : CardSet) (h : checkEntry cs = true) :
    Replicates cs := by
  rw [checkEntry, Bool.and_eq_true, Bool.and_eq_true] at h
  obtain ⟨⟨hp, hv⟩, _⟩ := h
  refine ⟨hp, fun p => fabricate_deck cs p, ?_, selfCopying_of_deckOrder cs hp hv⟩
  obtain ⟨left, hleft, hzero⟩ := assembleDeck_exact cs
  exact ⟨left, hleft, hzero⟩

/-! ## §2  The pipe version

The same fixed point with a different body: no clay brick and no stone weight
anywhere.  A pipe network pushes slurry through an extrusion die; the "press" is a
pinch valve closing on a moving strip, and the tablet it prints is a stamped
flange blank. -/

/-- The pipe machine, as one card. -/
def pipePressCard : Card :=
  { name := "pipe tablet press", tier := 0, raw := [.clay, .water],
    needs := [], press := true }

/-- **The pipe entry.**  One node, no clay bricks in it. -/
def pipeMonogram : CardSet := [pipePressCard]

def pipeFurnaceCard : Card :=
  { name := "pipe furnace", tier := 0, raw := [.clay, .fire], needs := [], press := false }

def pipeExtruderCard : Card :=
  { name := "pipe extruder", tier := 0, raw := [.clay, .water], needs := [], press := false }

def pipeWorksPressCard : Card :=
  { name := "pipe tablet press", tier := 1, raw := [.clay, .water],
    needs := ["pipe furnace", "pipe extruder"], press := true }

/-- The three-machine pipe network: furnace, extruder, press. -/
def pipeWorks : CardSet := [pipeFurnaceCard, pipeExtruderCard, pipeWorksPressCard]

theorem pipeMonogram_accepted : checkEntry pipeMonogram = true := by decide

theorem pipeWorks_accepted : checkEntry pipeWorks = true := by decide

/-! ## §3  All four entries replicate -/

theorem monogram_replicates : Replicates monogram :=
  replicates_of_checkEntry _ monogram_accepted

theorem workshop_replicates : Replicates workshop :=
  replicates_of_checkEntry _ workshop_accepted

theorem pipeMonogram_replicates : Replicates pipeMonogram :=
  replicates_of_checkEntry _ pipeMonogram_accepted

theorem pipeWorks_replicates : Replicates pipeWorks :=
  replicates_of_checkEntry _ pipeWorks_accepted

/-- The pipe version really is a different body: not one clay brick and not one
stone weight goes into it. -/
theorem pipe_has_no_clay :
    deckBOM pipeWorks .clayBrick = 0 ∧ deckBOM pipeWorks .stoneWeight = 0 := by
  constructor <;> rfl

/-- …and the clay version uses no pipe segment. -/
theorem clay_has_no_pipe : deckBOM workshop .pipeSegment = 0 := rfl

/-! ## §4  Generation after generation

The copy is not merely *a* machine; it is the same machine, so it copies again.
`generation cs n` is the deck the `n`-th copy prints. -/

/-- Run the loop `n` times: build the workshop from the deck, let the press print,
build from what it printed, and so on. -/
def generation (cs : CardSet) : Nat → CardSet
  | 0 => cs
  | n + 1 => emit ((generation cs n).map build)

/-- **Endless replication.**  Every generation is the original deck. -/
theorem generation_eq (cs : CardSet) (hp : Productive cs) : ∀ n, generation cs n = cs := by
  intro n
  induction n with
  | zero => rfl
  | succ n ih =>
      rw [generation, ih]
      exact emit_map_build cs hp

/-- Hence every generation calls for exactly the same boxes of parts. -/
theorem deckBOM_generation (cs : CardSet) (hp : Productive cs) (n : Nat) (p : Part) :
    deckBOM (generation cs n) p = deckBOM cs p := by
  rw [generation_eq cs hp n]

/-- And every generation replicates in its turn. -/
theorem generation_replicates (cs : CardSet) (h : checkEntry cs = true) (n : Nat) :
    Replicates (generation cs n) := by
  have hp : Productive cs := by
    rw [checkEntry, Bool.and_eq_true, Bool.and_eq_true] at h
    exact h.1.1
  rw [generation_eq cs hp n]
  exact replicates_of_checkEntry cs h

/-! ## §5  Evaluation -/

section Eval

/-- The boxes of parts for a deck, as pairs. -/
def boxList (cs : CardSet) : List (String × Nat) :=
  (deckBoxes cs).map (fun b => (b.part.name, b.count))

/-- How many fabrication cycles a whole copy takes. -/
def cycles (cs : CardSet) : Nat := (deckPartSeq cs).length

#eval boxList monogram
#eval boxList workshop
#eval boxList pipeMonogram
#eval boxList pipeWorks
#eval (cycles monogram, cycles workshop, cycles pipeMonogram, cycles pipeWorks)
-- the floor is empty when the copy is standing
#eval (assembleDeck (deckBOM workshop) workshop).map (fun s => Stock.eqOn s Stock.empty)
#eval (assembleDeck (deckBOM pipeWorks) pipeWorks).map (fun s => Stock.eqOn s Stock.empty)
-- one part short and assembly is refused
#eval (assembleDeck (Stock.sub (deckBOM pipeWorks) (fun p => if p = .elbow then 1 else 0))
        pipeWorks).isSome
#eval generation workshop 5 == workshop
#eval generation pipeWorks 5 == pipeWorks

end Eval

end Replicate
