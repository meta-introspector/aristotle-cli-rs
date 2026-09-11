import RequestProject.Kernel.Form

/-!
# The externalised proof engine, part 2: the checker and the mutator

A *proof script* is a flat list of steps, each of which either names an axiom
instance or applies modus ponens to two earlier lines.  Checking a script is a
single left-to-right pass with no search, no unification and no metavariables —
which is precisely what makes the engine portable: the whole of `check` is a
fold over a list, and a JavaScript or WebAssembly re-implementation is a direct
transcription (`www/prover.html` is one, pinned to this one by the conformance
vectors of `RequestProject.Kernel.Vectors`).

Two theorems carry the weight.

* `check_tautology` — **the safety property of the mutator.**  Whatever list of
  steps the checker accepts, the formula it returns is true under every
  valuation.  It holds for *every* script, so no matter how a script was
  produced — written by hand, transported through twenty-two languages, or
  produced by randomly editing another script in a browser — an accepted result
  is a theorem.  A mutator cannot be unsound; at worst it produces a script the
  checker rejects.
* `check_subst` — **the mutation that always succeeds.**  Substituting formulas
  for variables throughout a script maps accepted scripts to accepted scripts,
  and the conclusion is substituted accordingly.  This is the one edit a
  mutating search can make blindly and never lose a proof.
-/

namespace RequestProject.Kernel

/-! ## Scripts -/

/-- One line of a proof script: an axiom instance, or modus ponens on two
earlier lines (given by their 0-based line numbers). -/
inductive Step where
  /-- The instance `a ⇒ (b ⇒ a)` of K. -/
  | axK (a b : Form)
  /-- The instance of S at `a`, `b`, `c`. -/
  | axS (a b c : Form)
  /-- The instance `((a ⇒ ⊥) ⇒ ⊥) ⇒ a` of double negation elimination. -/
  | axDne (a : Form)
  /-- Modus ponens: line `i` must be `a ⇒ b` and line `j` must be `a`. -/
  | mp (i j : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- A proof script. -/
abbrev Script := List Step

/-- The formula a step adds to the proof, given the lines proved so far.  This
is the whole of the engine's trusted computation. -/
def stepCheck (ctx : List Form) : Step → Option Form
  | .axK a b => some (.imp a (.imp b a))
  | .axS a b c => some (.imp (.imp a (.imp b c)) (.imp (.imp a b) (.imp a c)))
  | .axDne a => some (.imp (.imp (.imp a .fls) .fls) a)
  | .mp i j =>
      match ctx[i]?, ctx[j]? with
      | some (.imp a b), some g => if a = g then some b else none
      | _, _ => none

/-- Check a script against the lines already established, returning all the
lines of the completed proof. -/
def checkAux (ctx : List Form) : Script → Option (List Form)
  | [] => some ctx
  | s :: rest =>
      match stepCheck ctx s with
      | none => none
      | some f => checkAux (ctx ++ [f]) rest

/-- Check a script and return what it proves: the formula on its last line. -/
def check (script : Script) : Option Form := (checkAux [] script).bind fun l => l.getLast?

/-- Does this script prove this goal?  The Boolean the external engine reports. -/
def proves (script : Script) (goal : Form) : Bool := check script == some goal

/-! ## Soundness -/

theorem stepCheck_provable {ctx : List Form} (hctx : ∀ g ∈ ctx, Provable g) {s : Step}
    {f : Form} (h : stepCheck ctx s = some f) : Provable f := by
  cases s with
  | axK a b => cases h; exact .axK a b
  | axS a b c => cases h; exact .axS a b c
  | axDne a => cases h; exact .axDne a
  | mp i j =>
      simp only [stepCheck] at h
      split at h
      · rename_i a b g hi hj
        split at h
        · rename_i hab
          cases h
          subst hab
          exact Provable.mp (hctx _ (List.mem_of_getElem? hi)) (hctx _ (List.mem_of_getElem? hj))
        · exact absurd h (by simp)
      · exact absurd h (by simp)

theorem checkAux_provable : ∀ (script : Script) (ctx ctx' : List Form),
    (∀ g ∈ ctx, Provable g) → checkAux ctx script = some ctx' → ∀ g ∈ ctx', Provable g := by
  intro script
  induction script with
  | nil => intro ctx ctx' hctx h; cases h; exact hctx
  | cons s rest ih =>
      intro ctx ctx' hctx h
      simp only [checkAux] at h
      split at h
      · exact absurd h (by simp)
      · rename_i f hf
        refine ih _ _ ?_ h
        intro g hg
        rcases List.mem_append.1 hg with hg | hg
        · exact hctx g hg
        · simp only [List.mem_singleton] at hg
          subst hg
          exact stepCheck_provable hctx hf

/-- **What the checker guarantees, in the calculus.** -/
theorem check_provable {script : Script} {f : Form} (h : check script = some f) :
    Provable f := by
  simp only [check, Option.bind_eq_some_iff] at h
  obtain ⟨l, hl, hf⟩ := h
  exact checkAux_provable script [] l (by simp) hl f (List.mem_of_getLast? hf)

/-- **What the checker guarantees, in the semantics.**  Every script the engine
accepts proves a formula true under every valuation — however the script was
obtained. -/
theorem check_tautology {script : Script} {f : Form} (h : check script = some f) :
    Tautology f := (check_provable h).tautology

/-- The engine never accepts a proof of falsity. -/
theorem not_proves_fls (script : Script) : proves script .fls = false := by
  simp only [proves, beq_eq_false_iff_ne, ne_eq]
  intro h
  exact not_provable_fls (check_provable h)

/-! ## Mutation by substitution -/

/-- Substitute a formula for every variable. -/
def Form.subst (σ : Nat → Form) : Form → Form
  | .var n => σ n
  | .fls => .fls
  | .imp a b => .imp (a.subst σ) (b.subst σ)

/-- Substitution acting on a line of a script.  Line numbers are untouched, so
the shape of the proof is preserved exactly. -/
def Step.subst (σ : Nat → Form) : Step → Step
  | .axK a b => .axK (a.subst σ) (b.subst σ)
  | .axS a b c => .axS (a.subst σ) (b.subst σ) (c.subst σ)
  | .axDne a => .axDne (a.subst σ)
  | .mp i j => .mp i j

/-- The mutator: substitute throughout a script. -/
def mutate (σ : Nat → Form) (script : Script) : Script := script.map (Step.subst σ)

/-- A step the checker accepts is still accepted after substitution, with the
substituted conclusion.  (Only this direction holds: substitution can identify
two different formulas, so a *rejected* step can become accepted.) -/
theorem stepCheck_subst {ctx : List Form} {s : Step} {f : Form} (σ : Nat → Form)
    (h : stepCheck ctx s = some f) :
    stepCheck (ctx.map (Form.subst σ)) (s.subst σ) = some (f.subst σ) := by
  cases s with
  | axK a b => cases h; simp [stepCheck, Step.subst, Form.subst]
  | axS a b c => cases h; simp [stepCheck, Step.subst, Form.subst]
  | axDne a => cases h; simp [stepCheck, Step.subst, Form.subst]
  | mp i j =>
      simp only [stepCheck] at h
      split at h
      · rename_i a b g hi hj
        split at h
        · rename_i hab
          cases h
          subst hab
          simp [Step.subst, stepCheck, List.getElem?_map, hi, hj, Form.subst]
        · exact absurd h (by simp)
      · exact absurd h (by simp)

theorem checkAux_subst (σ : Nat → Form) : ∀ (script : Script) (ctx ctx' : List Form),
    checkAux ctx script = some ctx' →
      checkAux (ctx.map (Form.subst σ)) (mutate σ script) = some (ctx'.map (Form.subst σ)) := by
  intro script
  induction script with
  | nil => intro ctx ctx' h; cases h; rfl
  | cons s rest ih =>
      intro ctx ctx' h
      simp only [checkAux] at h
      split at h
      · exact absurd h (by simp)
      · rename_i f hf
        simp only [mutate, List.map_cons, checkAux, stepCheck_subst σ hf]
        have := ih (ctx ++ [f]) ctx' h
        simpa [mutate, List.map_append] using this

/-- **Mutation by substitution never breaks a proof.**  If the engine accepts
`script` as a proof of `f`, it accepts the substituted script as a proof of the
substituted formula.  This is the edit a mutating search in the browser can
always make. -/
theorem check_subst {script : Script} {f : Form} (σ : Nat → Form)
    (h : check script = some f) : check (mutate σ script) = some (f.subst σ) := by
  simp only [check, Option.bind_eq_some_iff] at h ⊢
  obtain ⟨l, hl, hf⟩ := h
  refine ⟨l.map (Form.subst σ), ?_, ?_⟩
  · simpa using checkAux_subst σ script [] l hl
  · rw [List.getLast?_map, hf, Option.map_some]

/-- Substituting variables for variables leaves a script unchanged. -/
theorem mutate_var (script : Script) : mutate Form.var script = script := by
  have hf : ∀ f : Form, f.subst Form.var = f := by
    intro f; induction f with
    | var n => rfl
    | fls => rfl
    | imp a b iha ihb => simp [Form.subst, iha, ihb]
  have hs : ∀ s : Step, s.subst Form.var = s := by
    intro s; cases s <;> simp [Step.subst, hf]
  simp only [mutate]
  induction script with
  | nil => rfl
  | cons s rest ih => simp [hs s, ih]

/-- **The mutator is safe.**  Whatever a mutation does to a script, if the
result is accepted then what it proves is true.  A corollary of
`check_tautology`, and the reason an untrusted mutator needs no verification of
its own. -/
theorem mutate_tautology {script : Script} {f : Form} (σ : Nat → Form)
    (h : check (mutate σ script) = some f) : Tautology f := check_tautology h

end RequestProject.Kernel
