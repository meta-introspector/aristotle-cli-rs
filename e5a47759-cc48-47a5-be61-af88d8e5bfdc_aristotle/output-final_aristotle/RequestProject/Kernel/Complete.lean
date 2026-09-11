import RequestProject.Kernel.Form

/-!
# The externalised proof engine, part 3: completeness of the calculus

`RequestProject.Kernel.Form` proves the engine *sound*: everything the Hilbert
calculus derives is true under every valuation.  Soundness alone leaves open the
possibility that the calculus is far too weak — the empty calculus is sound too.
This file closes that gap and proves the converse, **completeness**: every
tautology is derivable.

The proof is Kalmár's.  Derivability under hypotheses (`Hyp`) is introduced, the
deduction theorem is proved for it, and then for each formula `f` and valuation
`v` the signed literals of `f`'s variables derive `f` if `v` makes it true and
`¬f` if `v` makes it false (`kalmar`).  Discharging the variables one at a time
with a classical case split (`Hyp.case_split`) turns "true under every
valuation" into a derivation from no hypotheses at all.

Nothing here imports anything beyond Lean core, so the whole argument travels
with the engine.
-/

namespace RequestProject.Kernel

/-! ## Derivability from hypotheses -/

/-- Derivability in the Hilbert calculus from a list of extra hypotheses.  The
axioms and modus ponens are those of `Provable`; `hyp` is the only addition. -/
inductive Hyp (Γ : List Form) : Form → Prop where
  /-- `a ⇒ (b ⇒ a)`. -/
  | axK (a b : Form) : Hyp Γ (.imp a (.imp b a))
  /-- `(a ⇒ (b ⇒ c)) ⇒ ((a ⇒ b) ⇒ (a ⇒ c))`. -/
  | axS (a b c : Form) :
      Hyp Γ (.imp (.imp a (.imp b c)) (.imp (.imp a b) (.imp a c)))
  /-- `((a ⇒ ⊥) ⇒ ⊥) ⇒ a`. -/
  | axDne (a : Form) : Hyp Γ (.imp (.imp (.imp a .fls) .fls) a)
  /-- A hypothesis. -/
  | hyp {a : Form} : a ∈ Γ → Hyp Γ a
  /-- Modus ponens. -/
  | mp {a b : Form} : Hyp Γ (.imp a b) → Hyp Γ a → Hyp Γ b

namespace Hyp

/-- Hypotheses may be added, permuted and duplicated freely. -/
theorem weaken {Γ Δ : List Form} {f : Form} (hsub : ∀ a ∈ Γ, a ∈ Δ) (h : Hyp Γ f) : Hyp Δ f := by
  induction h with
  | axK a b => exact .axK a b
  | axS a b c => exact .axS a b c
  | axDne a => exact .axDne a
  | hyp hm => exact .hyp (hsub _ hm)
  | mp _ _ ih₁ ih₂ => exact .mp ih₁ ih₂

/-- Anything derivable outright is derivable under hypotheses. -/
theorem of_provable {Γ : List Form} {f : Form} (h : Provable f) : Hyp Γ f := by
  induction h with
  | axK a b => exact .axK a b
  | axS a b c => exact .axS a b c
  | axDne a => exact .axDne a
  | mp _ _ ih₁ ih₂ => exact .mp ih₁ ih₂

/-- A derivation from no hypotheses is a derivation. -/
theorem to_provable {f : Form} (h : Hyp [] f) : Provable f := by
  induction h with
  | axK a b => exact .axK a b
  | axS a b c => exact .axS a b c
  | axDne a => exact .axDne a
  | hyp hm => exact absurd hm (by simp)
  | mp _ _ ih₁ ih₂ => exact .mp ih₁ ih₂

/-- `a ⇒ a`, the standard `S K K`. -/
theorem imp_self (Γ : List Form) (a : Form) : Hyp Γ (.imp a a) :=
  .mp (.mp (.axS a (.imp a a) a) (.axK a (.imp a a))) (.axK a a)

/-- Weakening inside an implication: a derived formula is implied by anything. -/
theorem imp_intro {Γ : List Form} {f : Form} (a : Form) (h : Hyp Γ f) : Hyp Γ (.imp a f) :=
  .mp (.axK f a) h

/-- Adding one more hypothesis. -/
theorem cons {Γ : List Form} {a f : Form} (h : Hyp Γ f) : Hyp (a :: Γ) f :=
  weaken (fun _ hx => List.mem_cons_of_mem _ hx) h

/-- **The deduction theorem.**  What is derivable from `a` and `Γ` is exactly
what `Γ` derives about `a ⇒ ·`. -/
theorem deduction {Γ : List Form} {a b : Form} (h : Hyp (a :: Γ) b) : Hyp Γ (.imp a b) := by
  induction h with
  | axK x y => exact imp_intro a (.axK x y)
  | axS x y z => exact imp_intro a (.axS x y z)
  | axDne x => exact imp_intro a (.axDne x)
  | @hyp x hm =>
      rcases List.mem_cons.1 hm with rfl | hm
      · exact imp_self Γ x
      · exact imp_intro a (.hyp hm)
  | @mp x y _ _ ih₁ ih₂ => exact .mp (.mp (.axS a x y) ih₁) ih₂

/-- The converse of the deduction theorem, which is just modus ponens. -/
theorem undeduction {Γ : List Form} {a b : Form} (h : Hyp Γ (.imp a b)) : Hyp (a :: Γ) b :=
  .mp (cons h) (.hyp (List.mem_cons_self ..))

/-- *Ex falso*: `⊥ ⇒ b`, derived from double negation elimination. -/
theorem exfalso (Γ : List Form) (b : Form) : Hyp Γ (.imp .fls b) :=
  deduction (.mp (.axDne b) (.mp (.axK .fls (.imp b .fls)) (.hyp (List.mem_cons_self ..))))

/-- A classical case split on a formula: if `f` follows both from `p` and from
`¬p`, it follows outright. -/
theorem case_split {Γ : List Form} {p f : Form}
    (h₁ : Hyp Γ (.imp p f)) (h₂ : Hyp Γ (.imp (.imp p .fls) f)) : Hyp Γ f := by
  refine .mp (.axDne f) (deduction ?_)
  -- in the context `(f ⇒ ⊥) :: Γ` we derive `⊥`
  have hfF : Hyp (Form.imp f .fls :: Γ) (.imp f .fls) := .hyp (List.mem_cons_self ..)
  have hnp : Hyp (Form.imp f .fls :: Γ) (.imp p .fls) :=
    deduction (.mp (cons hfF) (.mp (cons (cons h₁)) (.hyp (List.mem_cons_self ..))))
  exact .mp hfF (.mp (cons h₂) hnp)

end Hyp

/-! ## Kalmár's lemma -/

namespace Form

/-- The variables occurring in a formula. -/
def vars : Form → List Nat
  | .var n => [n]
  | .fls => []
  | .imp a b => a.vars ++ b.vars

end Form

/-- The literal a valuation assigns to a variable: `var n` if true, `¬var n` if
false. -/
def lit (v : Nat → Bool) (n : Nat) : Form :=
  if v n then .var n else .neg (.var n)

/-- The hypotheses describing a valuation on a list of variables. -/
def litCtx (v : Nat → Bool) (L : List Nat) : List Form := L.map (lit v)

/-- The formula a valuation makes true: `f` itself, or its negation. -/
def signed (v : Nat → Bool) (f : Form) : Form := if f.eval v then f else f.neg

theorem lit_mem_litCtx {v : Nat → Bool} {L : List Nat} {n : Nat} (h : n ∈ L) :
    lit v n ∈ litCtx v L := List.mem_map_of_mem h

/-- **Kalmár's lemma.**  The signed literals of any list of variables covering
`f` derive `f` when the valuation makes it true, and `¬f` when it does not. -/
theorem kalmar : ∀ (f : Form) (v : Nat → Bool) (L : List Nat),
    (∀ n ∈ f.vars, n ∈ L) → Hyp (litCtx v L) (signed v f) := by
  intro f
  induction f with
  | var n =>
      intro v L hL
      have hn : n ∈ L := hL n (by simp [Form.vars])
      have : signed v (.var n) = lit v n := by
        by_cases hv : v n = true <;> simp [signed, lit, Form.eval, hv]
      rw [this]
      exact .hyp (lit_mem_litCtx hn)
  | fls =>
      intro v L _
      have : signed v .fls = .imp .fls .fls := by simp [signed, Form.eval, Form.neg]
      rw [this]
      exact Hyp.imp_self _ _
  | imp a b iha ihb =>
      intro v L hL
      have hLa : ∀ n ∈ a.vars, n ∈ L := fun n hn => hL n (by simp [Form.vars, hn])
      have hLb : ∀ n ∈ b.vars, n ∈ L := fun n hn => hL n (by simp [Form.vars, hn])
      have ha : Hyp (litCtx v L) (signed v a) := iha v L hLa
      have hb : Hyp (litCtx v L) (signed v b) := ihb v L hLb
      by_cases hbv : b.eval v = true
      · -- `b` is true, so `a ⇒ b` is true and follows from `b`
        have hbb : Hyp (litCtx v L) b := by simpa [signed, hbv] using hb
        have : signed v (.imp a b) = .imp a b := by simp [signed, Form.eval, hbv]
        rw [this]
        exact Hyp.imp_intro a hbb
      · simp only [Bool.not_eq_true] at hbv
        by_cases hav : a.eval v = true
        · -- `a` true, `b` false: `a ⇒ b` is false, and we derive its negation
          have haa : Hyp (litCtx v L) a := by simpa [signed, hav] using ha
          have hnb : Hyp (litCtx v L) (.imp b .fls) := by
            simpa [signed, hbv, Form.neg] using hb
          have : signed v (.imp a b) = .imp (.imp a b) .fls := by
            simp [signed, Form.eval, hav, hbv, Form.neg]
          rw [this]
          exact Hyp.deduction (.mp (Hyp.cons hnb) (.mp (.hyp (List.mem_cons_self ..))
            (Hyp.cons haa)))
        · -- `a` false: `a ⇒ b` is true, and follows from `¬a`
          simp only [Bool.not_eq_true] at hav
          have hna : Hyp (litCtx v L) (.imp a .fls) := by
            simpa [signed, hav, Form.neg] using ha
          have : signed v (.imp a b) = .imp a b := by
            simp [signed, Form.eval, hav]
          rw [this]
          exact Hyp.deduction (.mp (Hyp.exfalso _ b)
            (.mp (Hyp.cons hna) (.hyp (List.mem_cons_self ..))))

/-! ## Discharging the variables -/

theorem litCtx_congr {v w : Nat → Bool} {L : List Nat} (h : ∀ n ∈ L, v n = w n) :
    litCtx v L = litCtx w L := by
  simp only [litCtx]
  exact List.map_congr_left fun n hn => by simp [lit, h n hn]

/-- If a formula is derivable from the signed literals of `L` under *every*
valuation, it is derivable from no hypotheses at all. -/
theorem elim_vars : ∀ (L : List Nat) (f : Form),
    (∀ v : Nat → Bool, Hyp (litCtx v L) f) → Hyp [] f := by
  intro L
  induction L with
  | nil => intro f h; simpa [litCtx] using h (fun _ => true)
  | cons n L ih =>
      intro f h
      refine ih f fun v => ?_
      by_cases hn : n ∈ L
      · -- the variable is already in the context: plain weakening
        refine Hyp.weaken ?_ (h v)
        intro x hx
        simp only [litCtx, List.map_cons, List.mem_cons] at hx
        rcases hx with rfl | hx
        · exact lit_mem_litCtx hn
        · exact hx
      · -- split on the value of the fresh variable
        have hctx : ∀ b : Bool, litCtx (fun m => if m = n then b else v m) L = litCtx v L := by
          intro b
          refine litCtx_congr fun m hm => ?_
          have : m ≠ n := fun h => hn (h ▸ hm)
          simp [this]
        have hT := h (fun m => if m = n then true else v m)
        have hF := h (fun m => if m = n then false else v m)
        rw [litCtx, List.map_cons, ← litCtx] at hT hF
        rw [hctx true] at hT
        rw [hctx false] at hF
        have hlitT : lit (fun m => if m = n then true else v m) n = .var n := by simp [lit]
        have hlitF : lit (fun m => if m = n then false else v m) n = .neg (.var n) := by simp [lit]
        rw [hlitT] at hT
        rw [hlitF] at hF
        exact Hyp.case_split (Hyp.deduction hT) (Hyp.deduction hF)

/-! ## Completeness -/

/-- **Completeness of the engine's calculus.**  Every formula true under every
valuation is derivable.  Together with `Provable.tautology` this says the
Hilbert system the portable checker implements is exactly classical
propositional logic — the engine is not merely safe, it is not missing
anything. -/
theorem Provable.of_tautology {f : Form} (h : Tautology f) : Provable f := by
  refine Hyp.to_provable (elim_vars f.vars f fun v => ?_)
  have := kalmar f v f.vars fun n hn => hn
  simpa [signed, h v] using this

/-- **Derivability is truth.** -/
theorem provable_iff_tautology {f : Form} : Provable f ↔ Tautology f :=
  ⟨Provable.tautology, Provable.of_tautology⟩

/-- Consistency, restated: a formula and its negation are never both derivable. -/
theorem not_provable_and_neg {f : Form} (h₁ : Provable f) (h₂ : Provable f.neg) : False := by
  have := (Provable.mp h₂ h₁).tautology (fun _ => true)
  simp [Form.eval] at this

end RequestProject.Kernel
