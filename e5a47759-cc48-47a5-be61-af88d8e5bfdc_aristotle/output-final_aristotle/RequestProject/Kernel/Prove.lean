import RequestProject.Kernel.Decide

/-!
# The externalised proof engine, part 6: the prover

`Provable.of_tautology` says a proof *exists*.  This file produces one: a
computable function

    prove : Form → Option Script

that returns an actual proof script for every tautology, and `none` for
everything else — with both halves proved.  It is Kalmár's argument again, but
carried out on proof *terms* instead of on propositions, so it runs.

* `HD` — derivation terms, checked by `HD.conclOf` (what the term concludes)
  and `HD.okIn` (its hypotheses are available).  `HD.Der` bundles the two, and
  `HD.Der.to_hyp` says a checked term is a derivation of the calculus.
* `HD.ded` — **the deduction theorem as a program**: it transforms a term
  proved under one more hypothesis into a term proving the implication.
* `kalmarT`, `dischargeT` — the two constructions of the completeness proof,
  now as functions building terms.
* `HD.toScript` — linearisation into the flat wire format the relay carries,
  with the index arithmetic proved right.
* `prove_sound` / `prove_complete` — the checker accepts what `prove` returns,
  and `prove` returns something exactly when the formula is a tautology.

Nothing here is trusted: `prove` may be re-implemented in any language and its
output is still run through `check`, whose soundness is `check_tautology`.
-/

namespace RequestProject.Kernel

/-! ## Derivation terms -/

/-- A derivation term: a tree of axiom instances, hypotheses and modus ponens
steps.  Unlike `Provable`, this is data, so it can be computed with. -/
inductive HD where
  /-- The instance `a ⇒ (b ⇒ a)` of K. -/
  | axK (a b : Form)
  /-- The instance of S at `a`, `b`, `c`. -/
  | axS (a b c : Form)
  /-- The instance `((a ⇒ ⊥) ⇒ ⊥) ⇒ a` of double negation elimination. -/
  | axDne (a : Form)
  /-- A hypothesis, named by the formula it assumes. -/
  | hyp (a : Form)
  /-- Modus ponens. -/
  | mp (d e : HD)
  deriving Repr, Inhabited

namespace HD

/-- What a term concludes, if it is well formed.  Hypotheses conclude
themselves; whether they are *available* is `okIn`'s business. -/
def conclOf : HD → Option Form
  | .axK a b => some (.imp a (.imp b a))
  | .axS a b c => some (.imp (.imp a (.imp b c)) (.imp (.imp a b) (.imp a c)))
  | .axDne a => some (.imp (.imp (.imp a .fls) .fls) a)
  | .hyp a => some a
  | .mp d e =>
      match conclOf d, conclOf e with
      | some (.imp x y), some z => if x = z then some y else none
      | _, _ => none

/-- Are all the hypotheses of the term available in `Γ`? -/
def okIn (Γ : List Form) : HD → Bool
  | .hyp a => decide (a ∈ Γ)
  | .mp d e => okIn Γ d && okIn Γ e
  | _ => true

/-- `d` is a checked derivation of `f` from `Γ`. -/
def Der (Γ : List Form) (d : HD) (f : Form) : Prop :=
  d.conclOf = some f ∧ d.okIn Γ = true

/-- A checked term really is a derivation of the calculus. -/
theorem Der.to_hyp : ∀ {d : HD} {Γ : List Form} {f : Form}, Der Γ d f → Hyp Γ f := by
  intro d
  induction d with
  | axK a b => rintro Γ f ⟨hc, _⟩; cases hc; exact .axK a b
  | axS a b c => rintro Γ f ⟨hc, _⟩; cases hc; exact .axS a b c
  | axDne a => rintro Γ f ⟨hc, _⟩; cases hc; exact .axDne a
  | hyp a =>
      rintro Γ f ⟨hc, ho⟩
      cases hc
      exact .hyp (by simpa [okIn] using ho)
  | mp d e ihd ihe =>
      rintro Γ f ⟨hc, ho⟩
      simp only [conclOf] at hc
      split at hc
      · rename_i x y z hd he
        split at hc
        · rename_i hxz
          cases hc
          subst hxz
          simp only [okIn, Bool.and_eq_true] at ho
          exact .mp (ihd ⟨hd, ho.1⟩) (ihe ⟨he, ho.2⟩)
        · exact absurd hc (by simp)
      · exact absurd hc (by simp)

/-! ### The basic constructions -/

theorem Der.mp' {Γ : List Form} {d e : HD} {x y : Form}
    (h₁ : Der Γ d (.imp x y)) (h₂ : Der Γ e x) : Der Γ (.mp d e) y := by
  obtain ⟨hc₁, ho₁⟩ := h₁
  obtain ⟨hc₂, ho₂⟩ := h₂
  exact ⟨by simp [conclOf, hc₁, hc₂], by simp [okIn, ho₁, ho₂]⟩

theorem Der.hyp' {Γ : List Form} {a : Form} (h : a ∈ Γ) : Der Γ (.hyp a) a :=
  ⟨rfl, by simp [okIn, h]⟩

theorem Der.axK' (Γ : List Form) (a b : Form) : Der Γ (.axK a b) (.imp a (.imp b a)) :=
  ⟨rfl, rfl⟩

theorem Der.axS' (Γ : List Form) (a b c : Form) :
    Der Γ (.axS a b c) (.imp (.imp a (.imp b c)) (.imp (.imp a b) (.imp a c))) := ⟨rfl, rfl⟩

theorem Der.axDne' (Γ : List Form) (a : Form) :
    Der Γ (.axDne a) (.imp (.imp (.imp a .fls) .fls) a) := ⟨rfl, rfl⟩

/-- Availability of hypotheses only grows with the context. -/
theorem okIn_mono : ∀ (d : HD) {Γ Δ : List Form}, (∀ a ∈ Γ, a ∈ Δ) →
    d.okIn Γ = true → d.okIn Δ = true := by
  intro d
  induction d with
  | axK a b => intro _ _ _ _; rfl
  | axS a b c => intro _ _ _ _; rfl
  | axDne a => intro _ _ _ _; rfl
  | hyp a => intro Γ Δ hsub ho; simpa [okIn] using hsub a (by simpa [okIn] using ho)
  | mp d e ihd ihe =>
      intro Γ Δ hsub ho
      simp only [okIn, Bool.and_eq_true] at ho ⊢
      exact ⟨ihd hsub ho.1, ihe hsub ho.2⟩

/-- Weakening leaves the term untouched — only its context changes. -/
theorem Der.weaken {d : HD} {Γ Δ : List Form} {f : Form} (hsub : ∀ a ∈ Γ, a ∈ Δ)
    (h : Der Γ d f) : Der Δ d f :=
  ⟨h.1, okIn_mono d hsub h.2⟩

/-- Adding a hypothesis. -/
theorem Der.cons' {Γ : List Form} {a f : Form} {d : HD} (h : Der Γ d f) : Der (a :: Γ) d f :=
  Der.weaken (fun _ hx => List.mem_cons_of_mem _ hx) h

/-- `a ⇒ a` as a term. -/
def idOf (a : Form) : HD := .mp (.mp (.axS a (.imp a a) a) (.axK a (.imp a a))) (.axK a a)

theorem Der.idOf (Γ : List Form) (a : Form) : Der Γ (HD.idOf a) (.imp a a) :=
  Der.mp' (Der.mp' (Der.axS' Γ a (.imp a a) a) (Der.axK' Γ a (.imp a a))) (Der.axK' Γ a a)

/-- Weakening inside an implication, as a term. -/
def impIntro (a : Form) (d : HD) : HD := .mp (.axK ((conclOf d).getD .fls) a) d

theorem Der.impIntro {Γ : List Form} {d : HD} {f : Form} (a : Form) (h : Der Γ d f) :
    Der Γ (HD.impIntro a d) (.imp a f) := by
  have hc : (conclOf d).getD .fls = f := by rw [h.1]; rfl
  show Der Γ (HD.mp (HD.axK ((conclOf d).getD .fls) a) d) _
  rw [hc]
  exact Der.mp' (Der.axK' Γ f a) h

/-! ### The deduction theorem as a program -/

/-- **The deduction theorem, computed.**  `ded a d` rewrites a term that uses
the hypothesis `a` into one that does not, proving `a ⇒ ·` instead.  The
`getD` defaults are unreachable on well-formed input, as `Der.ded` shows. -/
def ded (a : Form) : HD → HD
  | .hyp x => if x = a then idOf a else impIntro a (.hyp x)
  | .mp d e =>
      .mp (.mp (.axS a ((conclOf e).getD .fls) ((conclOf (.mp d e)).getD .fls))
        (ded a d)) (ded a e)
  | d => impIntro a d

theorem Der.ded : ∀ {d : HD} {Γ : List Form} {a b : Form},
    Der (a :: Γ) d b → Der Γ (HD.ded a d) (.imp a b) := by
  intro d
  induction d with
  | axK x y =>
      rintro Γ a b ⟨hc, _⟩
      cases hc
      exact Der.impIntro a (Der.axK' Γ x y)
  | axS x y z =>
      rintro Γ a b ⟨hc, _⟩
      cases hc
      exact Der.impIntro a (Der.axS' Γ x y z)
  | axDne x =>
      rintro Γ a b ⟨hc, _⟩
      cases hc
      exact Der.impIntro a (Der.axDne' Γ x)
  | hyp x =>
      rintro Γ a b ⟨hc, ho⟩
      cases hc
      have hx : x ∈ a :: Γ := by simpa [okIn] using ho
      by_cases hxa : x = a
      · subst hxa
        simpa [HD.ded] using Der.idOf Γ x
      · have : x ∈ Γ := by
          rcases List.mem_cons.1 hx with rfl | h
          · exact absurd rfl hxa
          · exact h
        simpa [HD.ded, hxa] using Der.impIntro a (Der.hyp' this)
  | mp d e ihd ihe =>
      rintro Γ a b ⟨hc, ho⟩
      simp only [conclOf] at hc
      split at hc
      · rename_i x y z hd he
        split at hc
        · rename_i hxz
          cases hc
          subst hxz
          simp only [okIn, Bool.and_eq_true] at ho
          have h₁ : Der Γ (HD.ded a d) (.imp a (.imp x b)) := ihd ⟨hd, ho.1⟩
          have h₂ : Der Γ (HD.ded a e) (.imp a x) := ihe ⟨he, ho.2⟩
          have hce : (conclOf e).getD .fls = x := by rw [he]; rfl
          have hcm : (conclOf (HD.mp d e)).getD .fls = b := by
            simp [conclOf, hd, he]
          show Der Γ (HD.mp (HD.mp (HD.axS a _ _) (HD.ded a d)) (HD.ded a e)) _
          rw [hce, hcm]
          exact Der.mp' (Der.mp' (Der.axS' Γ a x b) h₁) h₂
        · exact absurd hc (by simp)
      · exact absurd hc (by simp)

/-! ### Ex falso and the classical case split, as terms -/

/-- `⊥ ⇒ b` as a term. -/
def exfalsoT (b : Form) : HD :=
  ded .fls (.mp (.axDne b) (.mp (.axK .fls (.imp b .fls)) (.hyp .fls)))

theorem Der.exfalsoT (Γ : List Form) (b : Form) : Der Γ (HD.exfalsoT b) (.imp .fls b) :=
  Der.ded (Γ := Γ) (a := .fls) (b := b)
    (Der.mp' (Der.axDne' _ b)
      (Der.mp' (Der.axK' _ .fls (.imp b .fls)) (Der.hyp' (List.mem_cons_self ..))))

/-- The classical case split as a term: from `p ⇒ f` and `¬p ⇒ f`, a proof of
`f`. -/
def caseSplitT (p f : Form) (d₁ d₂ : HD) : HD :=
  .mp (.axDne f)
    (ded (.imp f .fls)
      (.mp (.hyp (.imp f .fls))
        (.mp d₂ (ded p (.mp (.hyp (.imp f .fls)) (.mp d₁ (.hyp p)))))))

theorem Der.caseSplitT {Γ : List Form} {p f : Form} {d₁ d₂ : HD}
    (h₁ : Der Γ d₁ (.imp p f)) (h₂ : Der Γ d₂ (.imp (.imp p .fls) f)) :
    Der Γ (HD.caseSplitT p f d₁ d₂) f := by
  refine Der.mp' (Der.axDne' Γ f) (Der.ded ?_)
  have hfF : Der (Form.imp f .fls :: Γ) (.hyp (.imp f .fls)) (.imp f .fls) :=
    Der.hyp' (List.mem_cons_self ..)
  have hnp : Der (Form.imp f .fls :: Γ)
      (HD.ded p (.mp (.hyp (.imp f .fls)) (.mp d₁ (.hyp p)))) (.imp p .fls) :=
    Der.ded (Der.mp' (Der.cons' hfF) (Der.mp' (Der.cons' (Der.cons' h₁))
      (Der.hyp' (List.mem_cons_self ..))))
  exact Der.mp' hfF (Der.mp' (Der.cons' h₂) hnp)

end HD

/-! ## Kalmár's construction, as a program -/

/-- Kalmár's derivation, built as a term: from the signed literals of `f`'s
variables under `v`, a proof of `f` or of `¬f` according to `v`. -/
def kalmarT (v : Nat → Bool) : Form → HD
  | .var n => .hyp (lit v n)
  | .fls => HD.idOf .fls
  | .imp a b =>
      if b.eval v then HD.impIntro a (kalmarT v b)
      else if a.eval v then
        HD.ded (.imp a b) (.mp (kalmarT v b) (.mp (.hyp (.imp a b)) (kalmarT v a)))
      else
        HD.ded a (.mp (HD.exfalsoT b) (.mp (kalmarT v a) (.hyp a)))

theorem kalmarT_der : ∀ (f : Form) (v : Nat → Bool) (L : List Nat),
    (∀ n ∈ f.vars, n ∈ L) → HD.Der (litCtx v L) (kalmarT v f) (signed v f) := by
  intro f
  induction f with
  | var n =>
      intro v L hL
      have hn : n ∈ L := hL n (by simp [Form.vars])
      have hsig : signed v (.var n) = lit v n := by
        by_cases hv : v n = true <;> simp [signed, lit, Form.eval, hv]
      rw [hsig]
      exact HD.Der.hyp' (lit_mem_litCtx hn)
  | fls =>
      intro v L _
      have hsig : signed v .fls = .imp .fls .fls := by simp [signed, Form.eval, Form.neg]
      rw [hsig]
      exact HD.Der.idOf _ _
  | imp a b iha ihb =>
      intro v L hL
      have hLa : ∀ n ∈ a.vars, n ∈ L := fun n hn => hL n (by simp [Form.vars, hn])
      have hLb : ∀ n ∈ b.vars, n ∈ L := fun n hn => hL n (by simp [Form.vars, hn])
      have ha : HD.Der (litCtx v L) (kalmarT v a) (signed v a) := iha v L hLa
      have hb : HD.Der (litCtx v L) (kalmarT v b) (signed v b) := ihb v L hLb
      by_cases hbv : b.eval v = true
      · have hbb : HD.Der (litCtx v L) (kalmarT v b) b := by
          rwa [show signed v b = b by simp [signed, hbv]] at hb
        rw [show signed v (.imp a b) = .imp a b by simp [signed, Form.eval, hbv]]
        rw [show kalmarT v (.imp a b) = HD.impIntro a (kalmarT v b) by simp [kalmarT, hbv]]
        exact HD.Der.impIntro a hbb
      · simp only [Bool.not_eq_true] at hbv
        by_cases hav : a.eval v = true
        · have haa : HD.Der (litCtx v L) (kalmarT v a) a := by
            rwa [show signed v a = a by simp [signed, hav]] at ha
          have hnb : HD.Der (litCtx v L) (kalmarT v b) (.imp b .fls) := by
            rwa [show signed v b = .imp b .fls by simp [signed, hbv, Form.neg]] at hb
          rw [show signed v (.imp a b) = .imp (.imp a b) .fls by
            simp [signed, Form.eval, hav, hbv, Form.neg]]
          rw [show kalmarT v (.imp a b)
              = HD.ded (.imp a b) (.mp (kalmarT v b) (.mp (.hyp (.imp a b)) (kalmarT v a))) by
            simp [kalmarT, hav, hbv]]
          exact HD.Der.ded (HD.Der.mp' (HD.Der.cons' hnb)
            (HD.Der.mp' (HD.Der.hyp' (List.mem_cons_self ..)) (HD.Der.cons' haa)))
        · simp only [Bool.not_eq_true] at hav
          have hna : HD.Der (litCtx v L) (kalmarT v a) (.imp a .fls) := by
            rwa [show signed v a = .imp a .fls by simp [signed, hav, Form.neg]] at ha
          rw [show signed v (.imp a b) = .imp a b by simp [signed, Form.eval, hav]]
          rw [show kalmarT v (.imp a b)
              = HD.ded a (.mp (HD.exfalsoT b) (.mp (kalmarT v a) (.hyp a))) by
            simp [kalmarT, hav, hbv]]
          exact HD.Der.ded (HD.Der.mp' (HD.Der.exfalsoT _ b)
            (HD.Der.mp' (HD.Der.cons' hna) (HD.Der.hyp' (List.mem_cons_self ..))))

/-! ## Discharging the hypotheses, as a program -/

/-- Discharge the listed variables one at a time, splitting on each.  `base`
supplies, for every valuation, a term proving `f` from that valuation's
literals. -/
def dischargeT (f : Form) (base : (Nat → Bool) → HD) : List Nat → (Nat → Bool) → HD
  | [], v => base v
  | n :: L, v =>
      if n ∈ L then dischargeT f base L v
      else
        dischargeT f
          (fun w => HD.caseSplitT (.var n) f
            (HD.ded (.var n) (base (fun m => if m = n then true else w m)))
            (HD.ded (.neg (.var n)) (base (fun m => if m = n then false else w m))))
          L v

theorem dischargeT_der : ∀ (L : List Nat) (f : Form) (base : (Nat → Bool) → HD),
    (∀ v, HD.Der (litCtx v L) (base v) f) → ∀ v, HD.Der [] (dischargeT f base L v) f := by
  intro L
  induction L with
  | nil => intro f base h v; simpa [dischargeT, litCtx] using h v
  | cons n L ih =>
      intro f base h v
      by_cases hn : n ∈ L
      · rw [dischargeT, if_pos hn]
        refine ih f base (fun w => ?_) v
        refine HD.Der.weaken ?_ (h w)
        intro x hx
        simp only [litCtx, List.map_cons, List.mem_cons] at hx
        rcases hx with rfl | hx
        · exact lit_mem_litCtx hn
        · exact hx
      · rw [dischargeT, if_neg hn]
        refine ih f _ (fun w => ?_) v
        have hctx : ∀ b : Bool, litCtx (fun m => if m = n then b else w m) L = litCtx w L := by
          intro b
          refine litCtx_congr fun m hm => ?_
          have hmn : m ≠ n := fun hEq => hn (hEq ▸ hm)
          simp [hmn]
        have hT := h (fun m => if m = n then true else w m)
        have hF := h (fun m => if m = n then false else w m)
        rw [litCtx, List.map_cons, ← litCtx, hctx true,
          show lit (fun m => if m = n then true else w m) n = Form.var n by simp [lit]] at hT
        rw [litCtx, List.map_cons, ← litCtx, hctx false,
          show lit (fun m => if m = n then false else w m) n = (Form.var n).neg by
            simp [lit]] at hF
        exact HD.Der.caseSplitT (HD.Der.ded hT) (HD.Der.ded hF)

/-- The derivation term the prover builds for a formula. -/
def proveTerm (f : Form) : HD := dischargeT f (fun v => kalmarT v f) f.vars (fun _ => false)

theorem proveTerm_der {f : Form} (h : Tautology f) : HD.Der [] (proveTerm f) f := by
  refine dischargeT_der f.vars f (fun v => kalmarT v f) (fun v => ?_) _
  have hk := kalmarT_der f v f.vars (fun n hn => hn)
  rwa [show signed v f = f by simp [signed, h v]] at hk

/-! ## Linearisation into the wire format -/

/-- Flatten a derivation term into a proof script: the sub-proofs in order,
with the line references shifted to match. -/
def HD.toScript : HD → Script
  | .axK a b => [.axK a b]
  | .axS a b c => [.axS a b c]
  | .axDne a => [.axDne a]
  | .hyp _ => []
  | .mp d e =>
      let s₁ := d.toScript
      let s₂ := e.toScript
      s₁ ++ Script.shift s₁.length s₂ ++ [.mp (s₁.length - 1) (s₁.length + s₂.length - 1)]

theorem checkAux_length : ∀ (script : Script) (ctx ctx' : List Form),
    checkAux ctx script = some ctx' → ctx'.length = ctx.length + script.length := by
  intro script
  induction script with
  | nil => intro ctx ctx' h; cases h; simp
  | cons s rest ih =>
      intro ctx ctx' h
      simp only [checkAux] at h
      split at h
      · exact absurd h (by simp)
      · rename_i f _
        have := ih (ctx ++ [f]) ctx' h
        simp only [List.length_append, List.length_cons, List.length_nil] at this ⊢
        omega

/-- **The linearisation is correct.**  A hypothesis-free checked term becomes a
script the checker accepts, with the term's conclusion on the last line. -/
theorem HD.toScript_check : ∀ (d : HD) (f : Form), HD.Der [] d f →
    ∃ pre : List Form, checkAux [] d.toScript = some (pre ++ [f]) := by
  intro d
  induction d with
  | axK a b => rintro f ⟨hc, _⟩; cases hc; exact ⟨[], rfl⟩
  | axS a b c => rintro f ⟨hc, _⟩; cases hc; exact ⟨[], rfl⟩
  | axDne a => rintro f ⟨hc, _⟩; cases hc; exact ⟨[], rfl⟩
  | hyp a => rintro f ⟨_, ho⟩; exact absurd ho (by simp [okIn])
  | mp d e ihd ihe =>
      rintro f ⟨hc, ho⟩
      simp only [conclOf] at hc
      split at hc
      · rename_i x y z hd he
        split at hc
        · rename_i hxz
          cases hc
          subst hxz
          simp only [okIn, Bool.and_eq_true] at ho
          obtain ⟨p₁, h₁⟩ := ihd (.imp x f) ⟨hd, ho.1⟩
          obtain ⟨p₂, h₂⟩ := ihe x ⟨he, ho.2⟩
          -- the two sub-scripts, then one modus ponens line
          have hl₁ : (p₁ ++ [Form.imp x f]).length = [].length + d.toScript.length :=
            checkAux_length _ _ _ h₁
          have hl₂ : (p₂ ++ [x]).length = [].length + e.toScript.length :=
            checkAux_length _ _ _ h₂
          simp only [List.length_append, List.length_singleton, List.length_nil,
            Nat.zero_add] at hl₁ hl₂
          refine ⟨(p₁ ++ [.imp x f]) ++ (p₂ ++ [x]), ?_⟩
          have hstep : checkAux (p₁ ++ [Form.imp x f]) (Script.shift d.toScript.length e.toScript)
              = some ((p₁ ++ [Form.imp x f]) ++ (p₂ ++ [x])) := by
            have := checkAux_shift e.toScript [] (p₂ ++ [x]) (p₁ ++ [Form.imp x f]) h₂
            rw [List.append_nil] at this
            rwa [show (p₁ ++ [Form.imp x f]).length = d.toScript.length by
              simp only [List.length_append, List.length_cons, List.length_nil]; omega] at this
          rw [HD.toScript, List.append_assoc, checkAux_append d.toScript _ [] _ h₁,
            checkAux_append (Script.shift d.toScript.length e.toScript) _ _ _ hstep]
          have hi : ((p₁ ++ [Form.imp x f]) ++ (p₂ ++ [x]))[d.toScript.length - 1]?
              = some (.imp x f) := by
            rw [show d.toScript.length - 1 = p₁.length by omega,
              List.getElem?_append_left (by simp), List.getElem?_append_right (by omega)]
            simp
          have hj : ((p₁ ++ [Form.imp x f]) ++ (p₂ ++ [x]))[d.toScript.length +
              e.toScript.length - 1]? = some x := by
            rw [show d.toScript.length + e.toScript.length - 1 = (p₁.length + 1) + p₂.length by
                omega,
              List.getElem?_append_right (by simp), List.getElem?_append_right (by simp)]
            simp
          have hmp : stepCheck ((p₁ ++ [Form.imp x f]) ++ (p₂ ++ [x]))
              (Step.mp (d.toScript.length - 1) (d.toScript.length + e.toScript.length - 1))
              = some f := by
            simp only [stepCheck, hi, hj, if_true]
          simp only [checkAux, hmp]
        · exact absurd hc (by simp)
      · exact absurd hc (by simp)

/-! ## The prover -/

/-- **The prover.**  For a tautology, a proof script the portable checker
accepts; for anything else, `none`.  Both halves are proved below, and the
decision in front is `isTautology`, so this is a total decision procedure that
returns evidence when it says yes. -/
def prove (f : Form) : Option Script :=
  if isTautology f then some (proveTerm f).toScript else none

/-- **The prover is sound**: what it returns, the checker accepts as a proof of
the formula asked for. -/
theorem prove_sound {f : Form} {script : Script} (h : prove f = some script) :
    check script = some f := by
  simp only [prove] at h
  split at h
  · rename_i ht
    cases h
    obtain ⟨pre, hp⟩ := HD.toScript_check _ f (proveTerm_der (isTautology_iff.1 ht))
    simp [check, hp]
  · exact absurd h (by simp)

/-- **The prover is complete**: it succeeds on every tautology. -/
theorem prove_complete {f : Form} (h : Tautology f) :
    ∃ script : Script, prove f = some script ∧ check script = some f := by
  refine ⟨(proveTerm f).toScript, ?_, ?_⟩
  · simp [prove, isTautology_iff.2 h]
  · exact prove_sound (by simp [prove, isTautology_iff.2 h])

/-- The prover refuses exactly the non-tautologies. -/
theorem prove_eq_none_iff {f : Form} : prove f = none ↔ ¬ Tautology f := by
  constructor
  · intro h ht
    obtain ⟨script, hs, _⟩ := prove_complete ht
    rw [h] at hs
    exact absurd hs (by simp)
  · intro h
    simp only [prove]
    split
    · rename_i ht; exact absurd (isTautology_iff.1 ht) h
    · rfl

/-- **What the prover means for the engine as a whole.**  A formula is true
under every valuation exactly when `prove` hands back a script, and that script
passes the same `check` a browser or a WebAssembly port runs. -/
theorem prove_isSome_iff_tautology {f : Form} : (prove f).isSome = true ↔ Tautology f := by
  constructor
  · intro h
    obtain ⟨script, hs⟩ := Option.isSome_iff_exists.1 h
    exact check_tautology (prove_sound hs)
  · intro h
    obtain ⟨script, hs, _⟩ := prove_complete h
    simp [hs]

/-! ## Worked instances, proved by running the prover -/

/-- The prover finds a proof of Peirce's law, and the checker accepts it. -/
theorem prove_peirce :
    ∃ script : Script, prove (peirce (.var 0) (.var 1)) = some script ∧
      check script = some (peirce (.var 0) (.var 1)) :=
  prove_complete (by decide)

/-- And of the contraposition law. -/
theorem prove_contrapose :
    ∃ script : Script, prove (.imp (.imp (.var 0) (.var 1))
        (.imp (.imp (.var 1) .fls) (.imp (.var 0) .fls))) = some script ∧
      check script = some (.imp (.imp (.var 0) (.var 1))
        (.imp (.imp (.var 1) .fls) (.imp (.var 0) .fls))) :=
  prove_complete (by decide)

/-- A formula that is not a tautology gets no script at all. -/
theorem prove_var_none : prove (.var 0) = none :=
  prove_eq_none_iff.2 fun h => by simpa [Form.eval] using h (fun _ => false)

end RequestProject.Kernel
