import RequestProject.Kernel.Decide

/-!
# The externalised proof engine, part 7: the classical axiom is not decoration

The engine's calculus has three axiom schemes: `K`, `S` and double negation
elimination.  `Provable.of_tautology` shows the three together are complete, but
that leaves a fair question about the trusted base: is the third one *needed*,
or is the checker carrying a rule it could derive from the other two?

It is needed, and this file proves it.  `ProvableKS` is the calculus with `K`,
`S` and modus ponens only; a three-valued Heyting semantics (`Val3`) validates
those two schemes and modus ponens but refutes both Peirce's law and double
negation elimination, so neither is derivable without the third axiom.  The
engine's third scheme therefore genuinely enlarges what it accepts — and by
`check_tautology` it does so without ever accepting a falsehood.

The three-valued algebra is the only new idea here, and everything about it is
decided by exhaustion over nine cases.
-/

namespace RequestProject.Kernel

/-! ## The implicational fragment without the classical axiom -/

/-- Derivability from `K`, `S` and modus ponens alone: the positive
implicational calculus. -/
inductive ProvableKS : Form → Prop where
  /-- `a ⇒ (b ⇒ a)`. -/
  | axK (a b : Form) : ProvableKS (.imp a (.imp b a))
  /-- `(a ⇒ (b ⇒ c)) ⇒ ((a ⇒ b) ⇒ (a ⇒ c))`. -/
  | axS (a b c : Form) :
      ProvableKS (.imp (.imp a (.imp b c)) (.imp (.imp a b) (.imp a c)))
  /-- Modus ponens. -/
  | mp {a b : Form} : ProvableKS (.imp a b) → ProvableKS a → ProvableKS b

/-- Dropping an axiom scheme can only lose derivations. -/
theorem ProvableKS.to_provable {f : Form} (h : ProvableKS f) : Provable f := by
  induction h with
  | axK a b => exact .axK a b
  | axS a b c => exact .axS a b c
  | mp _ _ ih₁ ih₂ => exact .mp ih₁ ih₂

/-! ## A three-valued Heyting semantics -/

/-- The three-element chain `⊥ < ½ < ⊤`, a Heyting algebra. -/
inductive Val3 where
  /-- The bottom element. -/
  | bot
  /-- The middle element. -/
  | mid
  /-- The top element. -/
  | top
  deriving DecidableEq, Repr, Inhabited

/-- Heyting implication on the chain: `⊤` when `a ≤ b`, and `b` otherwise. -/
def Val3.imp : Val3 → Val3 → Val3
  | .bot, _ => .top
  | .mid, .bot => .bot
  | .mid, .mid => .top
  | .mid, .top => .top
  | .top, b => b

/-- A formula's value in the three-element algebra. -/
def Form.eval3 (v : Nat → Val3) : Form → Val3
  | .var n => v n
  | .fls => .bot
  | .imp a b => (eval3 v a).imp (eval3 v b)

/-- Designated: a formula is valid in the algebra when it takes the top value
under every three-valued assignment. -/
def Valid3 (f : Form) : Prop := ∀ v : Nat → Val3, f.eval3 v = .top

theorem Val3.axK_top : ∀ a b : Val3, a.imp (b.imp a) = .top := by
  intro a b; cases a <;> cases b <;> rfl

theorem Val3.axS_top : ∀ a b c : Val3,
    (a.imp (b.imp c)).imp ((a.imp b).imp (a.imp c)) = .top := by
  intro a b c; cases a <;> cases b <;> cases c <;> rfl

theorem Val3.mp_top : ∀ a b : Val3, a.imp b = .top → a = .top → b = .top := by
  intro a b hab ha
  cases a <;> cases b <;> simp_all [Val3.imp]

/-- **The positive calculus is sound for the three-valued semantics.**  This is
what makes the algebra a separating model: `K`, `S` and modus ponens stay inside
it. -/
theorem ProvableKS.valid3 {f : Form} (h : ProvableKS f) : Valid3 f := by
  induction h with
  | axK a b => intro v; exact Val3.axK_top _ _
  | axS a b c => intro v; exact Val3.axS_top _ _ _
  | mp _ _ ih₁ ih₂ =>
      intro v
      exact Val3.mp_top _ _ (ih₁ v) (ih₂ v)

/-! ## Two formulas the positive calculus cannot reach -/

/-- The assignment that separates them: the first variable takes the middle
value, every other variable the bottom one. -/
def sepVal : Nat → Val3 := fun n => if n = 0 then .mid else .bot

/-- Double negation elimination at `v0` is not valid in the algebra. -/
theorem dne_not_valid3 :
    (Form.imp (.imp (.imp (.var 0) .fls) .fls) (.var 0)).eval3 sepVal ≠ .top := by
  decide

/-- Peirce's law is not valid in the algebra either. -/
theorem peirce_not_valid3 : (peirce (.var 0) (.var 1)).eval3 sepVal ≠ .top := by
  decide

/-- **Double negation elimination is not derivable from `K` and `S`.**  The
engine's third axiom scheme is doing work no combination of the first two
can. -/
theorem dne_not_provableKS :
    ¬ ProvableKS (.imp (.imp (.imp (.var 0) .fls) .fls) (.var 0)) := fun h =>
  dne_not_valid3 (h.valid3 sepVal)

/-- **Peirce's law is not derivable from `K` and `S`** — the standard witness
that the positive calculus is not classical. -/
theorem peirce_not_provableKS : ¬ ProvableKS (peirce (.var 0) (.var 1)) := fun h =>
  peirce_not_valid3 (h.valid3 sepVal)

/-- **The engine's calculus is strictly stronger than the positive one**, and
the witness is a tautology: dropping the classical axiom would lose proofs of
true formulas, which by completeness is exactly what it must not do. -/
theorem axDne_independent :
    ∃ f : Form, Tautology f ∧ Provable f ∧ ¬ ProvableKS f :=
  ⟨peirce (.var 0) (.var 1), by decide, provable_peirce, peirce_not_provableKS⟩

/-- Nothing is lost in the other direction: the positive calculus proves only
tautologies too, so the separation is about strength, not about correctness. -/
theorem ProvableKS.tautology {f : Form} (h : ProvableKS f) : Tautology f :=
  h.to_provable.tautology

end RequestProject.Kernel
