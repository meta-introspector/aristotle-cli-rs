import RequestProject.Kernel.Synth

/-!
# The externalised proof engine, part 5: deciding

The engine now has a sound checker (`check_tautology`), a complete calculus
(`Provable.of_tautology`) and a complete wire format (`check_complete`).  What
is still missing is the *decision*: a computation that says which of the two
cases a given formula is in.

This file supplies it, and keeps it inside the portable fragment — a fold over a
finite list of valuations, no search and no proof objects:

* `isTautology` — evaluate the formula at every assignment of its own variables.
* `isTautology_iff` — the computation agrees with the semantics exactly, so
  `Tautology` becomes a decidable proposition (`Tautology.decidable`), and
  `by decide` proves concrete tautologies through it.
* `engine_dichotomy` — for every formula, either some script proves it or some
  valuation refutes it, and `isTautology` says which.  Nothing sits in between.
-/

namespace RequestProject.Kernel

/-! ## Evaluation depends only on the variables that occur -/

theorem Form.eval_congr {v w : Nat → Bool} : ∀ (f : Form), (∀ n ∈ f.vars, v n = w n) →
    f.eval v = f.eval w := by
  intro f
  induction f with
  | var n => intro h; simpa [Form.eval] using h n (by simp [Form.vars])
  | fls => intro _; rfl
  | imp a b iha ihb =>
      intro h
      have ha := iha fun n hn => h n (by simp [Form.vars, hn])
      have hb := ihb fun n hn => h n (by simp [Form.vars, hn])
      simp [Form.eval, ha, hb]

/-! ## Enumerating the assignments -/

/-- Every assignment of the variables in a list, as total valuations that are
`false` outside the list. -/
def allVals : List Nat → List (Nat → Bool)
  | [] => [fun _ => false]
  | n :: L =>
      (allVals L).map (fun v m => if m = n then true else v m) ++
        (allVals L).map (fun v m => if m = n then false else v m)

/-- The enumeration is exhaustive: any valuation whatsoever agrees with one of
the listed ones on the listed variables. -/
theorem exists_mem_allVals : ∀ (L : List Nat) (v : Nat → Bool),
    ∃ w ∈ allVals L, ∀ n ∈ L, w n = v n := by
  intro L
  induction L with
  | nil => intro v; exact ⟨fun _ => false, by simp [allVals], by simp⟩
  | cons n L ih =>
      intro v
      obtain ⟨w, hw, hagree⟩ := ih v
      cases hvn : v n with
      | true =>
          refine ⟨fun m => if m = n then true else w m, ?_, ?_⟩
          · exact List.mem_append_left _ (List.mem_map_of_mem hw)
          · intro m hm
            by_cases hmn : m = n
            · simp [hmn, hvn]
            · rcases List.mem_cons.1 hm with rfl | hm
              · exact absurd rfl hmn
              · simp [hmn, hagree m hm]
      | false =>
          refine ⟨fun m => if m = n then false else w m, ?_, ?_⟩
          · exact List.mem_append_right _ (List.mem_map_of_mem hw)
          · intro m hm
            by_cases hmn : m = n
            · simp [hmn, hvn]
            · rcases List.mem_cons.1 hm with rfl | hm
              · exact absurd rfl hmn
              · simp [hmn, hagree m hm]

/-! ## The decision procedure -/

/-- **The engine's decision procedure**: check the formula at every assignment
of the variables it mentions.  A fold over a finite list — the whole of it is as
portable as the checker. -/
def isTautology (f : Form) : Bool := (allVals f.vars).all (fun v => f.eval v)

/-- The procedure computes exactly the semantic notion. -/
theorem isTautology_iff {f : Form} : isTautology f = true ↔ Tautology f := by
  constructor
  · intro h v
    obtain ⟨w, hw, hagree⟩ := exists_mem_allVals f.vars v
    have hwv : f.eval w = f.eval v := Form.eval_congr f hagree
    rw [← hwv]
    exact List.all_eq_true.1 h w hw
  · intro h
    exact List.all_eq_true.2 fun w _ => h w

/-- Truth under every valuation is decidable. -/
instance Tautology.decidable (f : Form) : Decidable (Tautology f) :=
  decidable_of_iff (isTautology f = true) isTautology_iff

/-- Derivability is decidable too — the interesting half of that being
completeness. -/
instance Provable.decidable (f : Form) : Decidable (Provable f) :=
  decidable_of_iff (Tautology f) provable_iff_tautology.symm

/-- **The dichotomy the engine settles.**  Every formula either has a proof
script or has a counterexample, and `isTautology` is the computation that says
which.  There is no third case and no unresolved formula. -/
theorem engine_dichotomy (f : Form) :
    (isTautology f = true ∧ ∃ script : Script, proves script f = true) ∨
      (isTautology f = false ∧ ∃ v : Nat → Bool, f.eval v = false) := by
  cases h : isTautology f with
  | true => exact .inl ⟨rfl, proves_iff_tautology.2 (isTautology_iff.1 h)⟩
  | false =>
      refine .inr ⟨rfl, ?_⟩
      refine Classical.byContradiction fun hc => ?_
      have htaut : Tautology f := fun v => by
        cases hv : f.eval v
        · exact absurd ⟨v, hv⟩ hc
        · rfl
      rw [isTautology_iff.2 htaut] at h
      exact Bool.noConfusion h

/-! ## Worked instances

Each of these is `Provable` by completeness, with the tautology check done by
the kernel through `isTautology`; no script is written by hand. -/

/-- Peirce's law, the standard witness that the calculus is classical. -/
def peirce (p q : Form) : Form := .imp (.imp (.imp p q) p) p

theorem provable_peirce : Provable (peirce (.var 0) (.var 1)) :=
  Provable.of_tautology (by decide)

/-- The law of excluded middle, written with the derived connectives. -/
theorem provable_em : Provable (.imp (.imp (.var 0) .fls) (.imp (.var 0) .fls)) :=
  Provable.of_tautology (by decide)

/-- Contraposition. -/
theorem provable_contrapose :
    Provable (.imp (.imp (.var 0) (.var 1))
      (.imp (.imp (.var 1) .fls) (.imp (.var 0) .fls))) :=
  Provable.of_tautology (by decide)

/-- A formula that is *not* a tautology is refuted, not merely unproved. -/
theorem not_provable_var : ¬ Provable (.var 0) := by
  intro h
  have := h.tautology (fun _ => false)
  simp [Form.eval] at this

end RequestProject.Kernel
