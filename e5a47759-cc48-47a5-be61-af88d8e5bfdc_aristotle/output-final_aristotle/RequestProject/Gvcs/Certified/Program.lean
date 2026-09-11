import RequestProject.Gvcs.Certified.Crypto
import RequestProject.Gvcs.Net.Match
import RequestProject.Gvcs.Tycoon

/-!
# Certified mode, layer 2: the submitted program and its receipt

In *certified mode* a player does not click moves; he submits a **program** —
a short byte string — which the network executes under the same rule book
(`RequestProject/Game.lean`) that ordinary play uses, and publishes a
**receipt** anyone can recompute.

This file is that language and its execution semantics:

* `CMove` — one instruction: an opcode byte and two argument bytes.  Programs
  are lists of instructions, so a program *is* a byte string; `encodeProg` and
  `decodeProg` are the wire codec and `decodeProg_encodeProg` says the round
  trip is exact.
* `encodeProg_injective` — different programs have different byte strings.
  This is what makes a hash commitment to the bytes bind the strategy: a player
  cannot publish a commitment and then reveal a different program
  (`commitment_binds`).
* `toAction` — what an instruction means in the rule book.  Anything the
  language can express is an ordinary move, so certified play cannot reach
  states ordinary play cannot.
* `runProg` — execution: each instruction is offered to the rule book, and
  dropped if illegal (exactly `Net.applyAction`, the replicated step every peer
  already runs).  `runProg_legal` therefore holds for *any* submitted program,
  including a hostile one: no submission can produce negative cash, negative
  stores or negative fuel.
* `runBudget_eq` — a fair gas limit does not change what an honest submission
  does.
* `runProg_port_eq` — a Lua or JavaScript executor that agrees with the rule
  book instruction by instruction produces the same receipt, so the receipt is
  platform independent.
* `receipt_deterministic` — two honest executors of the same program from the
  same start produce the same receipt, so a disagreement is proof that one of
  them cheated.
-/

namespace LifeTrac
namespace Certified

open Build

/-! ## The instruction set -/

/-- One instruction of a submitted program: an opcode and two argument bytes.
Three bytes on the wire. -/
structure CMove where
  /-- What to do (see `toAction`). -/
  op : Digit
  /-- First argument: which material, where the opcode needs one. -/
  arg : Digit
  /-- Second argument: the quantity. -/
  qty : Digit
deriving DecidableEq, Repr, Inhabited

/-- The wire form of an instruction. -/
def encodeMove (m : CMove) : List Digit := [m.op, m.arg, m.qty]

/-- The wire form of a program: instructions back to back. -/
def encodeProg (p : List CMove) : List Digit := p.flatMap encodeMove

/-- Reading a program off the wire.  A byte string that is not a whole number
of instructions is rejected. -/
def decodeProg : List Digit → Option (List CMove)
  | [] => some []
  | a :: b :: c :: rest => (decodeProg rest).map (fun p => ⟨a, b, c⟩ :: p)
  | _ => none

@[simp] theorem encodeProg_nil : encodeProg [] = [] := rfl

@[simp] theorem encodeProg_cons (m : CMove) (p : List CMove) :
    encodeProg (m :: p) = m.op :: m.arg :: m.qty :: encodeProg p := rfl

@[simp] theorem encodeProg_length (p : List CMove) :
    (encodeProg p).length = 3 * p.length := by
  induction p with
  | nil => rfl
  | cons m p ih => simp [ih]; ring

/-- **The codec is exact.** -/
@[simp] theorem decodeProg_encodeProg (p : List CMove) : decodeProg (encodeProg p) = some p := by
  induction p with
  | nil => rfl
  | cons m p ih => simp [decodeProg, ih]

/-- **The encoding is injective**, so a commitment to the bytes is a commitment
to the program. -/
theorem encodeProg_injective : Function.Injective encodeProg := by
  intro p q h
  have := decodeProg_encodeProg p
  rw [h, decodeProg_encodeProg q] at this
  exact (Option.some_injective _ this).symm

/-- **A commitment binds.**  If the league publishes a hash of the program
bytes before the round and the hash is collision free on the strings actually
used, the player is held to the program he committed to. -/
theorem commitment_binds {H : List Digit → List Digit} (hH : Function.Injective H)
    {p q : List CMove} (h : H (encodeProg p) = H (encodeProg q)) : p = q :=
  encodeProg_injective (hH h)

/-! ## What an instruction means -/

/-- The catalogue order of the materials, used to turn an argument byte into a
material. -/
def materialTable : List Material :=
  [.steelTube4, .steelTube3, .steelTube2, .steelPlate6, .steelPlate12, .roundBar50,
   .boltM12, .nutM12, .weldWire, .hose, .fitting, .fluid, .gearPump, .wheelMotor,
   .cylinder, .controlValve, .engine, .fuelTank, .hydraulicTank, .wheelHub, .tire,
   .seat, .paint, .electricalKit]

/-- The catalogue lists every material exactly once, so an argument byte can
name any of them. -/
theorem materialTable_complete : ∀ m : Material, m ∈ materialTable := by
  decide

/-- The material an argument byte names. -/
def materialOf (d : Digit) : Material := materialTable.getD d.val default

/-- The meaning of an instruction: opcode modulo four selects buy, sell,
refuel or farm; the quantity byte is the amount.  Every instruction denotes an
ordinary move of the rule book, so certified play is a *restriction* of
ordinary play, never an extension of it. -/
def toAction (m : CMove) : Action :=
  match m.op.val % 4 with
  | 0 => .buy (materialOf m.arg) (m.qty.val : ℚ)
  | 1 => .sell (materialOf m.arg) (m.qty.val : ℚ)
  | 2 => .refuel (m.qty.val : ℚ)
  | _ => .farm "LifeTrac" wheat (m.qty.val : ℚ)

/-! ## Execution -/

/-- Running a program: offer each instruction to the rule book, keeping the
state unchanged when the move is illegal.  This is `Net.applyAction`, the same
replicated step ordinary multiplayer already uses, so a certified run and a
hand-played run are executed by identical code. -/
noncomputable def runProg (mk : Market) (s : GameState) (p : List CMove) : GameState :=
  p.foldl (fun s m => Net.applyAction mk s (toAction m)) s

@[simp] theorem runProg_nil (mk : Market) (s : GameState) : runProg mk s [] = s := rfl

@[simp] theorem runProg_cons (mk : Market) (s : GameState) (m : CMove) (p : List CMove) :
    runProg mk s (m :: p) = runProg mk (Net.applyAction mk s (toAction m)) p := rfl

theorem runProg_append (mk : Market) (s : GameState) (p q : List CMove) :
    runProg mk s (p ++ q) = runProg mk (runProg mk s p) q := by
  induction p generalizing s with
  | nil => rfl
  | cons m p ih => simp [ih]

/-- **No submitted program can break the game.**  Whatever bytes a player
uploads — a good strategy, a bad one, or an attack — the state the executors
compute still has non-negative cash, stores and fuel. -/
theorem runProg_legal {mk : Market} {s : GameState} (hs : s.Legal) (p : List CMove) :
    (runProg mk s p).Legal := by
  induction p generalizing s with
  | nil => exact hs
  | cons m p ih => exact ih (Net.applyAction_legal hs (toAction m))

/-- Execution under a gas limit: only the first `b` instructions are run. -/
noncomputable def runBudget (mk : Market) (s : GameState) (b : ℕ) (p : List CMove) : GameState :=
  runProg mk s (p.take b)

/-- **A fair gas limit costs an honest player nothing.**  A program within
budget runs to completion. -/
theorem runBudget_eq {mk : Market} {s : GameState} {b : ℕ} {p : List CMove}
    (h : p.length ≤ b) : runBudget mk s b p = runProg mk s p := by
  rw [runBudget, List.take_of_length_le h]

/-- **A faithful executor computes the same run.**  A Lua or JavaScript
implementation that agrees with the rule book on every move reproduces the
certified state exactly. -/
theorem runProg_port_eq (mk : Market) (impl : GameState → Action → GameState)
    (h : ∀ s a, impl s a = Net.applyAction mk s a) (s : GameState) (p : List CMove) :
    p.foldl (fun s m => impl s (toAction m)) s = runProg mk s p := by
  induction p generalizing s with
  | nil => rfl
  | cons m p ih => rw [List.foldl_cons, h, runProg_cons]; exact ih _

/-! ## Receipts -/

/-- What an executor publishes about a run: the state it ended in and how many
instructions it charged for. -/
structure Receipt where
  /-- The state the program ended in. -/
  final : GameState
  /-- The number of instructions executed. -/
  gas : ℕ

/-- The honest receipt of a run. -/
noncomputable def receiptOf (mk : Market) (s : GameState) (p : List CMove) : Receipt :=
  ⟨runProg mk s p, p.length⟩

/-- **Receipts are checkable.**  Anyone holding the starting state and the
program can recompute the receipt; two honest executors agree, so any
disagreement convicts one of them. -/
theorem receipt_deterministic (mk : Market) (s : GameState) (p : List CMove)
    (r₁ r₂ : Receipt) (h₁ : r₁ = receiptOf mk s p) (h₂ : r₂ = receiptOf mk s p) :
    r₁ = r₂ := by rw [h₁, h₂]

/-- The receipt charges exactly the gas the program uses. -/
@[simp] theorem receiptOf_gas (mk : Market) (s : GameState) (p : List CMove) :
    (receiptOf mk s p).gas = p.length := rfl

/-- A certified run ends in a legal state. -/
theorem receiptOf_legal {mk : Market} {s : GameState} (hs : s.Legal) (p : List CMove) :
    (receiptOf mk s p).final.Legal := runProg_legal hs p

end Certified
end LifeTrac
