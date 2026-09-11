/-
# Composing certified programs: a lexer with one certified counter on top

This is the language design in action. We take the reset-only lexer of
`RequestProject/VM/Examples/ResetLexer.lean` — trust level `Trust.reset` — and
stack on top of it a single group layer over `ZMod 2` that counts letters modulo
two. The composite:

* recognizes exactly the words that pass the lexer's rule *and* contain an even
  number of letters (`VM.checked_accepts`);
* has trust level exactly `(1, 2)` (`VM.checked_trust`): the composition law of
  `RequestProject/VM/Compose.lean` adds the levels (`0 + 1`) and multiplies the
  budgets (`1 * 2`);
* is therefore *not* reset-only (`VM.checked_not_trusted`) — and that is the
  point: the counter is exactly the piece of group structure the program had to
  pay for, and the trust lattice records the price.

Nothing else leaks in: the lexer part of the composite still runs unchanged
(`VM.checked_base_run`), by the simulation theorem for `VM.stack`.
-/
import RequestProject.VM.Examples.ResetLexer
import RequestProject.VM.Compose

namespace VM

open KrohnRhodes

/-- The lexer's state type. -/
abbrev LexSt : Type := Bool × (Bool × Unit)

/-- The lexer's start state. -/
def lexStart : LexSt := (false, (false, ()))

/-- The counter alphabet element contributed by a symbol: letters flip the
parity bit, everything else leaves it alone. -/
def letterStep (a : Tok) : Multiplicative (ZMod 2) :=
  if a = Tok.letter then Multiplicative.ofAdd 1 else 1

/-- The top layer: one group layer over `ZMod 2`, counting letters mod 2. It
reads the input symbol together with the lexer's current state. -/
def parityTop : Prog (Tok × LexSt) (Multiplicative (ZMod 2) × Unit) :=
  Prog.group (Multiplicative (ZMod 2)) inferInstance inferInstance Prog.nil
    (fun x _ => letterStep x.1)

/-- The composite program: the parity counter stacked on the certified lexer. -/
def checked : Stacked Tok LexSt (Multiplicative (ZMod 2) × Unit) := stack lexer parityTop

/-- The composite's start state. -/
def checkedStart : checked.State := ((1 : Multiplicative (ZMod 2)), lexStart)

/-- Accepting states: the lexer's error latch is clear and the letter count is
even. -/
def checkedAccept : Set checked.State := {x | x.1 = 1 ∧ (x.2).1 = false}

/-! ## Trust -/

/-- The composite's declared trust level is exactly `(1, 2)`: one group layer,
group budget two. -/
theorem checked_trust : checked.prog.trust = (1, 2) := by
  rw [checked, stack_trust]
  rfl

/-- So the composite is not reset-only: the counter is genuine group structure,
and the trust lattice records it. -/
theorem checked_not_trusted : ¬ checked.prog.Trusted := by
  intro h
  have hz := congrArg Trust.level h
  rw [checked_trust] at hz
  exact absurd hz (by decide)

/-- The lexer part of the composite still runs exactly as the lexer does. -/
theorem checked_base_run (w : List Tok) :
    checked.baseState (checked.prog.run w checkedStart) = lexer.run w lexStart :=
  stack_baseState_run lexer parityTop w checkedStart

/-! ## Semantics -/

/-- The parity of the number of letters in a word, as a group element. -/
def parityElt : List Tok → Multiplicative (ZMod 2)
  | [] => 1
  | a :: w => letterStep a * parityElt w

lemma checked_run (w : List Tok) (g : Multiplicative (ZMod 2)) (y : LexSt) :
    checked.prog.run w (g, y) = (g * parityElt w, lexer.run w y) := by
  induction w generalizing g y with
  | nil => simp [parityElt, Prog.run]
  | cons a w ih =>
      have hstep : checked.prog.step a (g, y) = (g * letterStep a, lexer.step a y) := rfl
      rw [Prog.run_cons, hstep, ih, Prog.run_cons]
      have : g * letterStep a * parityElt w = g * (letterStep a * parityElt w) := mul_assoc _ _ _
      rw [this]
      rfl

lemma parityElt_eq_one_iff (w : List Tok) :
    parityElt w = 1 ↔ Even (w.countP (fun a => decide (a = Tok.letter))) := by
  induction w with
  | nil => simp [parityElt]
  | cons a w ih =>
      have hcount : (a :: w).countP (fun a => decide (a = Tok.letter))
          = (if a = Tok.letter then 1 else 0) + w.countP (fun a => decide (a = Tok.letter)) := by
        by_cases ha : a = Tok.letter <;> simp [ha, Nat.add_comm]
      by_cases ha : a = Tok.letter
      · have hstep : parityElt (a :: w) = Multiplicative.ofAdd 1 * parityElt w := by
          rw [parityElt, letterStep, if_pos ha]
        rw [hstep, hcount, if_pos ha]
        constructor
        · intro h
          have hne : parityElt w ≠ 1 := by
            intro hone
            rw [hone, mul_one] at h
            exact absurd h (by decide)
          have hpar : ¬ Even (w.countP (fun a => decide (a = Tok.letter))) := fun hev =>
            hne (ih.2 hev)
          rw [Nat.add_comm, Nat.even_add_one]
          exact hpar
        · intro h
          have hodd : ¬ Even (w.countP (fun a => decide (a = Tok.letter))) := by
            rw [Nat.add_comm, Nat.even_add_one] at h
            exact h
          have hne : parityElt w ≠ 1 := fun hone => hodd (ih.1 hone)
          -- in a group of order two, the two nontrivial elements coincide
          have : parityElt w = Multiplicative.ofAdd 1 := by
            revert hne
            generalize parityElt w = z
            revert z
            decide
          rw [this]
          decide
      · have hstep : parityElt (a :: w) = parityElt w := by
          rw [parityElt, letterStep, if_neg ha, one_mul]
        rw [hstep, hcount, if_neg ha, Nat.zero_add]
        exact ih

/-- **The composite's language.** It accepts exactly the words that pass the
lexer's rule (no digit immediately followed by a letter) and contain an even
number of letters. -/
theorem checked_accepts (w : List Tok) :
    w ∈ checked.prog.accepts checkedStart checkedAccept ↔
      (List.IsChain TokOk w ∧ Even (w.countP (fun a => decide (a = Tok.letter)))) := by
  have hrun : (checked.prog.toDFA checkedStart checkedAccept).eval w
      = ((1 : Multiplicative (ZMod 2)) * parityElt w, lexer.run w lexStart) := by
    rw [DFA.eval, Prog.evalFrom_toDFA]
    exact checked_run w 1 lexStart
  have hlex : (lexer.run w lexStart).1 = false ↔ List.IsChain TokOk w := by
    have h := lexer_accepts w
    have heval : (lexer.toDFA (false, (false, ())) {x | x.1 = false}).eval w
        = lexer.run w lexStart :=
      Prog.evalFrom_toDFA lexer (false, (false, ())) {x | x.1 = false} lexStart w
    have hmem : (w ∈ lexer.accepts (false, (false, ())) {x | x.1 = false})
        ↔ ((lexer.toDFA (false, (false, ())) {x | x.1 = false}).eval w).1 = false := Iff.rfl
    rw [hmem, heval] at h
    exact h
  constructor
  · intro hw
    have hmem : (checked.prog.toDFA checkedStart checkedAccept).eval w ∈ checkedAccept := hw
    rw [hrun] at hmem
    obtain ⟨h1, h2⟩ := hmem
    rw [one_mul] at h1
    exact ⟨hlex.1 h2, (parityElt_eq_one_iff w).1 h1⟩
  · rintro ⟨hchain, heven⟩
    show (checked.prog.toDFA checkedStart checkedAccept).eval w ∈ checkedAccept
    rw [hrun]
    exact ⟨by rw [one_mul]; exact (parityElt_eq_one_iff w).2 heven, hlex.2 hchain⟩

end VM
