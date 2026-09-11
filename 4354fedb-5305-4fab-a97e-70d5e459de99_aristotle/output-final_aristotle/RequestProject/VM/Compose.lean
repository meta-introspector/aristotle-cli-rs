/-
# Composition of programs, and the algebra of trust

A language of certified programs is only useful if certificates *compose*. This
file gives the VM its composition operator and proves that trust levels add up
in the expected way.

The operator is `VM.stack p q`: `p` is a program over the alphabet `A`, and `q`
is a program over the alphabet `A × Q`, i.e. a program that may read both the
input letter and the state of `p`. Stacking `q` on top of `p` produces a single
program over `A` whose state carries both machines, together with projections
back onto each of them.

* `VM.stack_baseState_step` / `VM.stack_topState_step` — the composite really is
  the two machines running side by side: the projections commute with the step
  functions, so `p` runs unchanged inside the composite and `q` runs on the
  letter paired with `p`'s current state. This is exactly the wreath-product
  (cascade) discipline: information flows upward only.
* `VM.stack_groupDepth`, `VM.stack_groupCapacity`, `VM.stack_trust` — the
  declared trust level of a composite is the *sum* of the levels and the
  *product* of the group budgets of its parts.
* `VM.stack_trusted` — **composition preserves certificates**: stacking a
  reset-only program on a reset-only program yields a reset-only program, which
  by `VM.Prog.Trusted.subsingleton_of_groupDivides` still has no nontrivial
  group divisor. Trust is compositional, not merely per-program.
* `VM.trust_le_stack_left` / `VM.trust_le_stack_right` — and composition is
  monotone for the trust order: a composite is never more trusted than either
  of its parts.
-/
import RequestProject.VM.Certification

namespace VM

open KrohnRhodes

variable {A Q : Type}

/-- The result of stacking: a single program together with the projections onto
the two machines it simulates. -/
structure Stacked (A Q R : Type) where
  /-- The state type of the composite program. -/
  State : Type
  /-- The composite program. -/
  prog : Prog A State
  /-- Projection onto the state of the base machine. -/
  baseState : State → Q
  /-- Projection onto the state of the machine stacked on top. -/
  topState : State → R

/-- **Composition.** `stack p q` runs `q` on top of `p`: every layer of `q` reads
the input letter paired with the current state of `p`, alongside the states of
the layers of `q` below it. -/
def stack (p : Prog A Q) : {R : Type} → Prog (A × Q) R → Stacked A Q R
  | _, Prog.nil => ⟨Q, p, id, fun _ => ()⟩
  | _, Prog.reset R hR q act =>
      let s := stack p q
      ⟨R × s.State, Prog.reset R hR s.prog (fun a x => act (a, s.baseState x) (s.topState x)),
        fun x => s.baseState x.2, fun x => (x.1, s.topState x.2)⟩
  | _, Prog.group G hG hF q act =>
      let s := stack p q
      ⟨G × s.State, Prog.group G hG hF s.prog (fun a x => act (a, s.baseState x) (s.topState x)),
        fun x => s.baseState x.2, fun x => (x.1, s.topState x.2)⟩

/-! ## The composite simulates both machines -/

/-- The base machine runs unchanged inside the composite. -/
theorem stack_baseState_step (p : Prog A Q) : {R : Type} → (q : Prog (A × Q) R) →
    ∀ (a : A) (x : (stack p q).State),
      (stack p q).baseState ((stack p q).prog.step a x) = p.step a ((stack p q).baseState x)
  | _, Prog.nil, a, x => rfl
  | _, Prog.reset R hR q act, a, x => by
      obtain ⟨r, y⟩ := x
      exact stack_baseState_step p q a y
  | _, Prog.group G hG hF q act, a, x => by
      obtain ⟨g, y⟩ := x
      exact stack_baseState_step p q a y

/-- The stacked machine runs on the letter paired with the base machine's state.
-/
theorem stack_topState_step (p : Prog A Q) : {R : Type} → (q : Prog (A × Q) R) →
    ∀ (a : A) (x : (stack p q).State),
      (stack p q).topState ((stack p q).prog.step a x)
        = q.step (a, (stack p q).baseState x) ((stack p q).topState x)
  | _, Prog.nil, a, x => rfl
  | _, Prog.reset R hR q act, a, x => by
      obtain ⟨r, y⟩ := x
      exact Prod.ext rfl (stack_topState_step p q a y)
  | _, Prog.group G hG hF q act, a, x => by
      obtain ⟨g, y⟩ := x
      exact Prod.ext rfl (stack_topState_step p q a y)

/-! ## Simulation along whole words -/

/-- Running a program on a word. -/
def Prog.run {Q : Type} (p : Prog A Q) : List A → Q → Q
  | [], x => x
  | a :: w, x => p.run w (p.step a x)

@[simp] lemma Prog.run_nil {Q : Type} (p : Prog A Q) (x : Q) : p.run [] x = x := rfl

lemma Prog.run_cons {Q : Type} (p : Prog A Q) (a : A) (w : List A) (x : Q) :
    p.run (a :: w) x = p.run w (p.step a x) := rfl

/-- Running a program is running the automaton it denotes. -/
lemma Prog.evalFrom_toDFA {Q : Type} (p : Prog A Q) (start : Q) (accept : Set Q) (x : Q)
    (w : List A) : (p.toDFA start accept).evalFrom x w = p.run w x := by
  induction w generalizing x with
  | nil => rfl
  | cons a w ih => exact ih (p.step a x)

/-- Along a whole word, the base machine of a composite runs exactly as it would
on its own. -/
theorem stack_baseState_run (p : Prog A Q) {R : Type} (q : Prog (A × Q) R) :
    ∀ (w : List A) (x : (stack p q).State),
      (stack p q).baseState ((stack p q).prog.run w x) = p.run w ((stack p q).baseState x) := by
  intro w
  induction w with
  | nil => intro x; rfl
  | cons a w ih =>
      intro x
      rw [Prog.run_cons, Prog.run_cons, ih, stack_baseState_step p q a x]

/-- And the stacked machine runs on the letters paired with the base machine's
successive states. -/
theorem stack_topState_run (p : Prog A Q) {R : Type} (q : Prog (A × Q) R) :
    ∀ (w : List A) (x : (stack p q).State),
      (stack p q).topState ((stack p q).prog.run w x)
        = q.run (w.zip (w.scanl (fun s a => p.step a s) ((stack p q).baseState x)))
            ((stack p q).topState x) := by
  intro w
  induction w with
  | nil => intro x; rfl
  | cons a w ih =>
      intro x
      have hstep := stack_topState_step p q a x
      have hbase := stack_baseState_step p q a x
      rw [Prog.run_cons, ih, hstep, hbase, List.scanl_cons, List.zip_cons_cons, Prog.run_cons]

/-! ## The algebra of trust -/

/-- Levels add under composition. -/
theorem stack_groupDepth (p : Prog A Q) : {R : Type} → (q : Prog (A × Q) R) →
    (stack p q).prog.groupDepth = q.groupDepth + p.groupDepth
  | _, Prog.nil => by simp [stack, Prog.groupDepth]
  | _, Prog.reset R hR q act => by
      show (stack p q).prog.groupDepth = _
      rw [stack_groupDepth p q]
      rfl
  | _, Prog.group G hG hF q act => by
      show (stack p q).prog.groupDepth + 1 = _
      rw [stack_groupDepth p q]
      show q.groupDepth + p.groupDepth + 1 = q.groupDepth + 1 + p.groupDepth
      omega

/-- Group budgets multiply under composition. -/
theorem stack_groupCapacity (p : Prog A Q) : {R : Type} → (q : Prog (A × Q) R) →
    (stack p q).prog.groupCapacity = q.groupCapacity * p.groupCapacity
  | _, Prog.nil => by simp [stack, Prog.groupCapacity]
  | _, Prog.reset R hR q act => by
      show (stack p q).prog.groupCapacity = _
      rw [stack_groupCapacity p q]
      rfl
  | _, Prog.group G hG hF q act => by
      show (@Fintype.card G hF) * (stack p q).prog.groupCapacity = _
      rw [stack_groupCapacity p q]
      show (@Fintype.card G hF) * (q.groupCapacity * p.groupCapacity)
        = (@Fintype.card G hF) * q.groupCapacity * p.groupCapacity
      ring

/-- **The trust composition law**: levels add, budgets multiply. -/
theorem stack_trust (p : Prog A Q) {R : Type} (q : Prog (A × Q) R) :
    (stack p q).prog.trust = (q.trust.level + p.trust.level, q.trust.capacity * p.trust.capacity) :=
  Prod.ext (stack_groupDepth p q) (stack_groupCapacity p q)

/-- **Certificates compose.** A reset-only program stacked on a reset-only
program is reset-only — and therefore still has no nontrivial group divisor. -/
theorem stack_trusted {p : Prog A Q} (hp : p.Trusted) {R : Type} {q : Prog (A × Q) R}
    (hq : q.Trusted) : (stack p q).prog.Trusted := by
  have h : (stack p q).prog.groupDepth = 0 := by
    rw [stack_groupDepth p q, hq.groupDepth_eq_zero, hp.groupDepth_eq_zero]
  exact (Prog.trust_eq_reset_iff _).2 h

/-- Composition is monotone for the trust order: the composite is at least as
complex as the program it is stacked on. -/
theorem trust_le_stack_left (p : Prog A Q) {R : Type} (q : Prog (A × Q) R) :
    p.trust ≤ (stack p q).prog.trust := by
  refine ⟨?_, ?_⟩
  · show p.groupDepth ≤ (stack p q).prog.groupDepth
    rw [stack_groupDepth p q]
    omega
  · show p.groupCapacity ≤ (stack p q).prog.groupCapacity
    rw [stack_groupCapacity p q]
    exact Nat.le_mul_of_pos_left _ (Prog.one_le_groupCapacity q)

/-- ... and at least as complex as the program stacked on top of it. -/
theorem trust_le_stack_right (p : Prog A Q) {R : Type} (q : Prog (A × Q) R) :
    q.trust ≤ (stack p q).prog.trust := by
  refine ⟨?_, ?_⟩
  · show q.groupDepth ≤ (stack p q).prog.groupDepth
    rw [stack_groupDepth p q]
    omega
  · show q.groupCapacity ≤ (stack p q).prog.groupCapacity
    rw [stack_groupCapacity p q]
    exact Nat.le_mul_of_pos_right _ (Prog.one_le_groupCapacity p)

/-- The join of the parts' trust levels is a lower bound for the composite's:
the trust lattice order is respected by composition. -/
theorem sup_trust_le_stack (p : Prog A Q) {R : Type} (q : Prog (A × Q) R) :
    p.trust ⊔ q.trust ≤ (stack p q).prog.trust :=
  sup_le (trust_le_stack_left p q) (trust_le_stack_right p q)

end VM
