/-
# A certified reset-only program: the tight lexer, written in the VM

The rule this recognizer enforces is the tight lexer's: a letter may not follow
a digit immediately (so `12abc` is rejected, `abc 12` is accepted). It is
written here as a two-layer VM program with **no group layers**:

* the bottom reset layer remembers whether the previous symbol was a digit;
* the top reset layer is a one-way error latch: it fires when a letter arrives
  while the bottom layer says "previous symbol was a digit", and never clears.

Everything about it is proved:

* `VM.lexer_accepts` — it recognizes exactly the words in which no digit is
  immediately followed by a letter (stated with `List.IsChain`);
* `VM.lexer_trusted` — its declared trust level is `Trust.reset`, and by
  `VM.Prog.Trusted.subsingleton_of_groupDivides` this certificate is honest:
  **no** nontrivial group divides its transition monoid, and its group capacity
  is exactly `1`.

This is the "no weird machines, by group complexity" statement in its final
form here: not a size bound, and not an appeal to the Krohn-Rhodes theorem, but
a kernel-checked consequence of the program's own layered structure.
-/
import RequestProject.VM.Certification

namespace VM

open KrohnRhodes ComplexityLattice

/-- The lexer's alphabet: letters, digits and spaces. -/
inductive Tok
  | letter
  | digit
  | space
  deriving DecidableEq, Fintype, Repr

namespace Tok

instance : Inhabited Tok := ⟨Tok.space⟩

end Tok

/-- Bottom layer: a reset layer remembering whether the previous symbol was a
digit. -/
def prevDigit : Prog Tok (Bool × Unit) :=
  Prog.reset Bool inferInstance Prog.nil (fun a _ => some (decide (a = Tok.digit)))

/-- The tight lexer: an error latch on top of `prevDigit`. The latch is set when
a letter arrives right after a digit, and is never cleared. -/
def lexer : Prog Tok (Bool × (Bool × Unit)) :=
  Prog.reset Bool inferInstance prevDigit
    (fun a q => if q.1 && decide (a = Tok.letter) then some true else none)

/-- The automaton denoted by the lexer: start with no error and no preceding
digit, accept when the error latch is clear. -/
def lexerDFA : DFA Tok (Bool × (Bool × Unit)) :=
  lexer.toDFA (false, (false, ())) {x | x.1 = false}

/-! ## Semantics -/

/-- Specification of the error latch: `badRun d w` says the word `w`, read with
`d` recording whether the symbol just before it was a digit, contains a digit
immediately followed by a letter. -/
def badRun : Bool → List Tok → Bool
  | _, [] => false
  | d, a :: w => (d && decide (a = Tok.letter)) || badRun (decide (a = Tok.digit)) w

/-- Specification of the bottom layer: whether the last symbol read was a digit.
-/
def lastDigit : Bool → List Tok → Bool
  | d, [] => d
  | _, a :: w => lastDigit (decide (a = Tok.digit)) w

lemma lexer_evalFrom (w : List Tok) (e d : Bool) :
    lexerDFA.evalFrom (e, (d, ())) w = ((e || badRun d w), (lastDigit d w, ())) := by
  induction w generalizing e d with
  | nil => simp [DFA.evalFrom, badRun, lastDigit]
  | cons a w ih =>
      have hstep : lexerDFA.evalFrom (e, (d, ())) (a :: w)
          = lexerDFA.evalFrom (lexer.step a (e, (d, ()))) w := rfl
      have hstep' : lexer.step a (e, (d, ()))
          = ((if d && decide (a = Tok.letter) then true else e), (decide (a = Tok.digit), ())) := by
        show ((if d && decide (a = Tok.letter) then some true else none).getD e,
          prevDigit.step a (d, ())) = _
        cases h : (d && decide (a = Tok.letter)) <;> simp <;> rfl
      rw [hstep, hstep', ih]
      have hbad : badRun d (a :: w)
          = ((d && decide (a = Tok.letter)) || badRun (decide (a = Tok.digit)) w) := rfl
      have hlast : lastDigit d (a :: w) = lastDigit (decide (a = Tok.digit)) w := rfl
      rw [hbad, hlast]
      cases h : (d && decide (a = Tok.letter)) <;> simp

/-- The "no digit immediately followed by a letter" rule, as a relation between
consecutive symbols. -/
def TokOk (x y : Tok) : Prop := ¬ (x = Tok.digit ∧ y = Tok.letter)

lemma badRun_eq_false_iff (d : Bool) (w : List Tok) :
    badRun d w = false ↔
      ((d = true → w.head? ≠ some Tok.letter) ∧ List.IsChain TokOk w) := by
  induction w generalizing d with
  | nil => simp [badRun]
  | cons a w ih =>
      have hbad : badRun d (a :: w)
          = ((d && decide (a = Tok.letter)) || badRun (decide (a = Tok.digit)) w) := rfl
      rw [hbad, List.isChain_cons]
      simp only [Bool.or_eq_false_iff, Bool.and_eq_false_iff, ih, List.head?_cons,
        Option.some.injEq, ne_eq]
      constructor
      · rintro ⟨hhead, hrest, hchain⟩
        refine ⟨?_, ?_, hchain⟩
        · intro hd hae
          rcases hhead with h | h
          · exact absurd hd (by simp [h])
          · exact absurd hae (by simpa using h)
        · intro b hb hbad'
          have hw : w.head? ≠ some Tok.letter := hrest (by simp [hbad'.1])
          exact hw (by rw [← hbad'.2]; exact hb)
      · rintro ⟨hhead, hchain, hrest⟩
        refine ⟨?_, ?_, hrest⟩
        · by_cases hd : d = true
          · exact Or.inr (by simpa using hhead hd)
          · exact Or.inl (by simpa using hd)
        · intro hdig hw
          have hadig : a = Tok.digit := by simpa using hdig
          exact hchain Tok.letter hw ⟨hadig, rfl⟩

/-- **The lexer's language.** It accepts exactly the words in which no digit is
immediately followed by a letter. -/
theorem lexer_accepts (w : List Tok) :
    w ∈ lexer.accepts (false, (false, ())) {x | x.1 = false} ↔ List.IsChain TokOk w := by
  have h : lexerDFA.eval w = ((false || badRun false w), (lastDigit false w, ())) :=
    lexer_evalFrom w false false
  have hmem : w ∈ lexer.accepts (false, (false, ())) {x | x.1 = false}
      ↔ (lexerDFA.eval w).1 = false := Iff.rfl
  rw [hmem, h]
  simp only [Bool.false_or]
  rw [badRun_eq_false_iff]
  simp

/-- Concretely: `12abc` is rejected. -/
example : ¬ ([Tok.digit, Tok.digit, Tok.letter] ∈
    lexer.accepts (false, (false, ())) {x | x.1 = false}) := by
  rw [lexer_accepts]
  intro h
  have h2 := (List.isChain_cons.1 h).2
  exact (List.isChain_cons.1 h2).1 Tok.letter rfl ⟨rfl, rfl⟩

/-- Concretely: `abc 12` is accepted. -/
example : [Tok.letter, Tok.space, Tok.digit, Tok.digit] ∈
    lexer.accepts (false, (false, ())) {x | x.1 = false} := by
  rw [lexer_accepts]
  refine List.isChain_cons.2 ⟨?_, List.isChain_cons.2 ⟨?_, List.isChain_cons.2 ⟨?_,
    List.isChain_singleton _⟩⟩⟩ <;>
  · intro y hy
    simp only [List.head?_cons, Option.mem_def, Option.some.injEq] at hy
    subst hy
    simp [TokOk]

/-! ## The certificate -/

/-- The lexer declares the least trust level: no group layers, empty group
budget. -/
theorem lexer_trust : lexer.trust = Trust.reset := rfl

theorem lexer_trusted : lexer.Trusted := lexer_trust

/-- Its transition monoid is aperiodic — proved from the cascade structure, not
cited. -/
theorem lexer_isAperiodic : IsAperiodic lexer.monoid := lexer_trusted.isAperiodic

/-- **No weird machines, by group complexity.** No nontrivial group divides the
lexer's transition monoid. -/
theorem lexer_no_nontrivial_group {G : Type} [Group G] (hG : GroupDivides lexer.monoid G) :
    Subsingleton G :=
  lexer_trusted.subsingleton_of_groupDivides hG

/-- In lattice terms: none of the catalogued nodes of capacity `≥ 2` occurs in
the lexer's decomposition. -/
theorem lexer_not_gpA5 : ¬ GroupDivides lexer.monoid gpA5 :=
  lexer_trusted.not_groupDivides_node isAt_gpA5 (by norm_num)

theorem lexer_not_gpZ2 : ¬ GroupDivides lexer.monoid gpZ2 :=
  lexer_trusted.not_groupDivides_node isAt_gpZ2 (by norm_num)

/-- Its group capacity is exactly `1`: the only group of state permutations it
realizes is trivial. -/
theorem lexer_dfaGroupCapacity : dfaGroupCapacity lexerDFA = 1 :=
  lexer_trusted.dfaGroupCapacity_eq_one _ _

end VM
