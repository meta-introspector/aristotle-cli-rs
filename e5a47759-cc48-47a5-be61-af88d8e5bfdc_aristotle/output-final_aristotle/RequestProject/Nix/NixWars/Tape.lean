import RequestProject.Nix.NixWars.Agents
import RequestProject.Nix.NixWars.Transports

/-!
# The tape: a played game as a code you can paste, share and replay

A game on this board is a pure function on a vector of numbers, so a *game* is
completely described by two things: which door, and the commands that were sent
to it. That pair is a `Play`, and this file makes it into something you can put
on a piece of paper:

* `Play` is a door (its index on the board) together with the commands sent to
  it, each as an index and an argument — the ticker tape of a session;
* `codeCodec` turns a play into a short pasteable code and back again, and
  `linkCodec` into a whole URL, so a game can be *hosted in the address bar*:
  `ofCode_code` says the code always reads back as the game that was recorded,
  and `code_injective` that two different games never share a code;
* `replay` sends a decoded tape to the shipped WebAssembly module, command by
  command, and `replay_push` says that replaying is turn-by-turn: the tape with
  one more turn on it is the tape replayed and one more command sent, so a URL
  that grows by one group of symbols per turn is the same game as one played in
  a single sitting;
* every door's *recorded lesson* — how to play it, the winning line the
  development already proves — is a tape here: `demo_code_wins` says that for
  each of the fifteen doors the shared code decodes to that lesson, and
  replaying it on the shipped module reaches the winning vector.
-/

set_option maxRecDepth 1000000

namespace NixWars
namespace Tape

open Agents

/-! ## A play -/

/-- A recorded game: the door's index on the board, and the commands sent to
it, each as the index of the command and its numeric argument. -/
structure Play where
  /-- Index of the door in `Wasm.boardIR`. -/
  door : Nat
  /-- The commands, in the order they were sent. -/
  moves : List (Nat × Nat)
  deriving Repr, DecidableEq, Inhabited

/-- The number of turns on the tape. -/
def Play.turns (p : Play) : Nat := p.moves.length

/-- The tape truncated to its first `n` turns. -/
def Play.take (p : Play) (n : Nat) : Play := ⟨p.door, p.moves.take n⟩

/-- One more turn on the tape. -/
def Play.push (p : Play) (m : Nat × Nat) : Play := ⟨p.door, p.moves ++ [m]⟩

/-! ## A play as numbers -/

/-- The moves, flattened: command index then argument, over and over. -/
def movesToNats : List (Nat × Nat) → List Nat
  | [] => []
  | (t, a) :: ms => t :: a :: movesToNats ms

/-- Reading the moves back; an odd tail is malformed. -/
def movesOfNats : List Nat → Option (List (Nat × Nat))
  | [] => some []
  | [_] => none
  | t :: a :: rest => (movesOfNats rest).map (fun ms => (t, a) :: ms)

theorem movesOfNats_movesToNats (ms : List (Nat × Nat)) :
    movesOfNats (movesToNats ms) = some ms := by
  induction ms with
  | nil => rfl
  | cons m ms ih =>
      obtain ⟨t, a⟩ := m
      simp [movesToNats, movesOfNats, ih]

/-- A play as a list of numbers: the door, then the moves. -/
def toNats (p : Play) : List Nat := p.door :: movesToNats p.moves

/-- Reading a play back out of a list of numbers. -/
def ofNats : List Nat → Option Play
  | [] => none
  | d :: rest => (movesOfNats rest).map (fun ms => ⟨d, ms⟩)

theorem ofNats_toNats (p : Play) : ofNats (toNats p) = some p := by
  obtain ⟨d, ms⟩ := p
  simp [toNats, ofNats, movesOfNats_movesToNats]

/-- A play is a payload like any other, so it can ride any of the transports. -/
def natCodec : Codec Play (List Nat) :=
  ⟨toNats, ofNats, ofNats_toNats⟩

/-! ## The code, and the link -/

/-- Numbers as URL-safe base-64 text with no address in front of them: the
bare code, short enough to paste into a message. -/
def payloadCodec : Codec (List Nat) String :=
  ((fieldsCodec 64 (by norm_num)).comp (Codec.onList urlSymCodec)).comp stringCodec

/-- **A played game as a pasteable code.** -/
def codeCodec : Codec Play String := natCodec.comp payloadCodec

/-- **A played game as a whole URL** — the game hosted in the address bar. -/
def linkCodec : Codec Play String := natCodec.comp urlTransport

/-- The code of a play. -/
def code (p : Play) : String := codeCodec.encode p

/-- The link of a play. -/
def link (p : Play) : String := linkCodec.encode p

/-- Reading a code. -/
def ofCode (s : String) : Option Play := codeCodec.decode s

/-- Reading a link. -/
def ofLink (s : String) : Option Play := linkCodec.decode s

/-- **A shared code is the game that was recorded.** -/
theorem ofCode_code (p : Play) : ofCode (code p) = some p := codeCodec.decode_encode p

/-- **A shared link is the game that was recorded.** -/
theorem ofLink_link (p : Play) : ofLink (link p) = some p := linkCodec.decode_encode p

/-- Two different games never share a code. -/
theorem code_injective : Function.Injective code := by
  intro p q h
  have hp : ofCode (code p) = some q := by rw [h]; exact ofCode_code q
  rw [ofCode_code p] at hp
  exact Option.some.inj hp

/-- Two different games never share a link. -/
theorem link_injective : Function.Injective link := by
  intro p q h
  have hp : ofLink (link p) = some q := by rw [h]; exact ofLink_link q
  rw [ofLink_link p] at hp
  exact Option.some.inj hp

/-! ## Naming the door and the commands -/

/-- The door a play belongs to. -/
def doorAt? (i : Nat) : Option Wasm.DoorIR := Wasm.boardIR[i]?

/-- Where a door sits on the board. -/
def doorIdx? (nm : String) : Option Nat := Wasm.boardIR.findIdx? (fun d => d.name == nm)

/-- The name of a door's `j`-th command. -/
def cmdAt? (i j : Nat) : Option String :=
  (doorAt? i).bind (fun d => (d.table[j]?).map Prod.fst)

/-- The commands of one door, read out in words. -/
def namedMoves (d : Wasm.DoorIR) : List (Nat × Nat) → Option (List Move)
  | [] => some []
  | (t, a) :: ms =>
    match d.table[t]? with
    | none => none
    | some c =>
      match namedMoves d ms with
      | none => none
      | some rest => some (⟨c.1, a⟩ :: rest)

/-- The commands of one door, written down as indices. -/
def indexMoves (d : Wasm.DoorIR) : List Move → Option (List (Nat × Nat))
  | [] => some []
  | m :: ms =>
    match d.table.findIdx? (fun p => p.1 == m.tag) with
    | none => none
    | some j =>
      match indexMoves d ms with
      | none => none
      | some rest => some ((j, m.arg) :: rest)

/-- A play read out in words: the door's name and the commands by name. -/
def named (p : Play) : Option (String × List Move) :=
  match doorAt? p.door with
  | none => none
  | some d =>
    match namedMoves d p.moves with
    | none => none
    | some ms => some (d.name, ms)

/-- Recording a line of play: the door and its commands, by name, written down
as a tape. -/
def record (door : String) (ms : List Move) : Option Play :=
  match doorIdx? door with
  | none => none
  | some i =>
    match doorAt? i with
    | none => none
    | some d =>
      match indexMoves d ms with
      | none => none
      | some ns => some ⟨i, ns⟩

/-! ## Replaying a tape on the shipped module -/

/-- **Replaying a tape**: decode the door and the commands, and send them to
the WebAssembly module the page ships, one after another. -/
def replay (p : Play) (st : List Nat) : Option (List Nat) :=
  match named p with
  | none => none
  | some (door, ms) => wasmPlay door ms st

/-- Replaying a code from a starting vector. -/
def runCode (s : String) (st : List Nat) : Option (List Nat) :=
  (ofCode s).bind (fun p => replay p st)

/-- An empty tape leaves the game where it started. -/
@[simp] theorem replay_nil (i : Nat) (st : List Nat) (h : (doorAt? i).isSome) :
    replay ⟨i, []⟩ st = some st := by
  cases hd : doorAt? i with
  | none => rw [hd] at h; exact absurd h (by simp)
  | some d => simp [replay, named, hd, namedMoves, wasmPlay]

/-- Sending two stretches of commands is sending one and then the other. -/
theorem wasmPlay_append (door : String) (ms₁ ms₂ : List Move) (st : List Nat) :
    wasmPlay door (ms₁ ++ ms₂) st = (wasmPlay door ms₁ st).bind (wasmPlay door ms₂) := by
  induction ms₁ generalizing st with
  | nil => simp [wasmPlay]
  | cons m ms ih =>
      cases h : wasmCall door m st with
      | none => simp [wasmPlay, h]
      | some st' => simp [wasmPlay, h, ih]

/-- Naming a tape with one more turn on it names one more command. -/
theorem namedMoves_append_one (d : Wasm.DoorIR) (ms : List (Nat × Nat)) (m : Nat × Nat) :
    namedMoves d (ms ++ [m]) =
      (namedMoves d ms).bind (fun l =>
        (d.table[m.1]?).map (fun c => l ++ [(⟨c.1, m.2⟩ : Move)])) := by
  induction ms with
  | nil =>
      cases h : d.table[m.1]? with
      | none => simp [namedMoves, h]
      | some c => simp [namedMoves, h]
  | cons a ms ih =>
      obtain ⟨t, x⟩ := a
      cases ht : d.table[t]? with
      | none => simp [namedMoves, ht]
      | some c =>
          cases hms : namedMoves d ms with
          | none => simp [namedMoves, ht, hms] at ih ⊢; simp [ih]
          | some l =>
              cases hm : d.table[m.1]? with
              | none => simp [namedMoves, ht, hms, hm] at ih ⊢; simp [ih]
              | some c' => simp [namedMoves, ht, hms, hm] at ih ⊢; simp [ih]

/-- **Turn by turn.** The tape with one more turn on it replays to the state
the shorter tape reaches with that one command sent — so a page that grows the
code in its address bar by one turn at a time is playing the same game as one
that was played in a single sitting. -/
theorem replay_push (p : Play) (m : Nat × Nat) (st : List Nat) :
    replay (p.push m) st =
      (replay p st).bind (fun s =>
        (named p).bind (fun q =>
          (cmdAt? p.door m.1).bind (fun tag => wasmCall q.1 ⟨tag, m.2⟩ s))) := by
  obtain ⟨i, ms⟩ := p
  simp only [Play.push, replay, named, doorAt?, cmdAt?]
  cases hd : Wasm.boardIR[i]? with
  | none => simp
  | some d =>
      dsimp only [Option.bind_some]
      rw [namedMoves_append_one]
      cases hms : namedMoves d ms with
      | none => simp
      | some l =>
          cases hm : d.table[m.1]? with
          | none => cases wasmPlay d.name l st <;> simp
          | some c =>
              simp only [Option.bind_some, Option.map_some]
              rw [wasmPlay_append]
              cases hplay : wasmPlay d.name l st with
              | none => simp
              | some s =>
                  simp only [Option.bind_some, wasmPlay]
                  cases wasmCall d.name ⟨c.1, m.2⟩ s <;> rfl

/-! ## How to play each door: the lessons, as tapes

`Agents.agentCards` carries, for each of the fifteen doors, a line of play the
development proves wins, together with the vector it ends in. Each one is
recorded here as a tape, so that "how to play this game" is a code a visitor
can paste in and watch. -/

/-- The lesson of one door, as a tape. -/
def lesson (c : Card) : Option Play := record c.door c.moves

/-- Every lesson records, and reads back as exactly the card's line of play. -/
def lessonsRecord : Bool :=
  agentCards.all (fun c =>
    decide ((lesson c).bind named = some (c.door, c.moves)))

theorem lessonsRecord_eq_true : lessonsRecord = true := by rfl

/-- **How to play, in one code.** For each of the fifteen doors there is a
tape: it reads back as the door and the winning line of play the development
proves, and replaying it on the shipped WebAssembly module — after a round trip
through the shared code — lands exactly on the winning vector. -/
theorem demo_code_wins (c : Card) (hc : c ∈ agentCards) :
    ∃ p : Play, lesson c = some p ∧
      ofCode (code p) = some p ∧
      named p = some (c.door, c.moves) ∧
      runCode (code p) c.start = some c.finish := by
  have hall := lessonsRecord_eq_true
  unfold lessonsRecord at hall
  rw [List.all_eq_true] at hall
  have hc' := hall c hc
  simp only [decide_eq_true_eq] at hc'
  cases hp : lesson c with
  | none => rw [hp] at hc'; simp at hc'
  | some p =>
      rw [hp] at hc'
      simp only [Option.bind_some] at hc'
      refine ⟨p, rfl, ofCode_code p, hc', ?_⟩
      simp only [runCode, ofCode_code, Option.bind_some, replay, hc']
      exact agentCards_replay c hc

end Tape
end NixWars
