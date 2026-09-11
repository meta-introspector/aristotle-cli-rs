import RequestProject.Kernel.Check
import RequestProject.Kernel.Complete

/-!
# The externalised proof engine, part 4: the checker is complete

`RequestProject.Kernel.Check` proves the portable checker *sound*: any script it
accepts proves a tautology.  `RequestProject.Kernel.Complete` proves the
calculus complete.  This file joins them, at the level of the flat scripts the
engine actually exchanges:

* `Script.of_provable` — every derivation can be laid out as a straight-line
  script the checker accepts.  Concatenation with index shifting is the whole
  construction (`Script.shift`), and it is proved to preserve acceptance.
* `check_complete` — **every tautology has a script.**  So the engine's
  incompleteness, if any, is in the *search*, never in the format: nothing true
  is inexpressible as a checkable script, and a mutating search in a browser is
  looking for something that exists.
* `proves_iff_tautology` — the two directions in one statement.
-/

namespace RequestProject.Kernel

/-! ## Relocating a script -/

/-- Shift the line references of a step by `k`, so the script can be appended
after `k` lines that are already established. -/
def Step.shift (k : Nat) : Step → Step
  | .mp i j => .mp (k + i) (k + j)
  | s => s

/-- Shift every line reference of a script. -/
def Script.shift (k : Nat) (script : Script) : Script := script.map (Step.shift k)

theorem stepCheck_shift (pre ctx : List Form) (s : Step) :
    stepCheck (pre ++ ctx) (s.shift pre.length) = stepCheck ctx s := by
  cases s with
  | axK a b => rfl
  | axS a b c => rfl
  | axDne a => rfl
  | mp i j =>
      have h : ∀ k : Nat, (pre ++ ctx)[pre.length + k]? = ctx[k]? := by
        intro k
        rw [List.getElem?_append_right (by omega)]
        congr 1
        omega
      simp [Step.shift, stepCheck, h]

/-- A script accepted from `ctx` is still accepted after `pre` extra lines, if
its references are shifted past them. -/
theorem checkAux_shift : ∀ (script : Script) (ctx ctx' pre : List Form),
    checkAux ctx script = some ctx' →
      checkAux (pre ++ ctx) (Script.shift pre.length script) = some (pre ++ ctx') := by
  intro script
  induction script with
  | nil => intro ctx ctx' pre h; cases h; rfl
  | cons s rest ih =>
      intro ctx ctx' pre h
      simp only [checkAux] at h
      split at h
      · exact absurd h (by simp)
      · rename_i f hf
        simp only [Script.shift, List.map_cons, checkAux, stepCheck_shift pre ctx s, hf]
        have := ih (ctx ++ [f]) ctx' pre h
        simpa [Script.shift, List.append_assoc] using this

/-- Checking two scripts in a row is checking their concatenation. -/
theorem checkAux_append : ∀ (s₁ s₂ : Script) (ctx ctx₁ : List Form),
    checkAux ctx s₁ = some ctx₁ → checkAux ctx (s₁ ++ s₂) = checkAux ctx₁ s₂ := by
  intro s₁
  induction s₁ with
  | nil => intro s₂ ctx ctx₁ h; cases h; rfl
  | cons s rest ih =>
      intro s₂ ctx ctx₁ h
      simp only [checkAux] at h
      split at h
      · exact absurd h (by simp)
      · rename_i f hf
        simp only [List.cons_append, checkAux, hf]
        exact ih s₂ (ctx ++ [f]) ctx₁ h

/-! ## Laying a derivation out as a script -/

/-- **Every derivation is a script.**  If `f` is derivable, some script is
accepted by the checker with `f` on its last line.  The statement carries the
list of earlier lines explicitly, which is what makes the induction go
through. -/
theorem Script.of_provable {f : Form} (h : Provable f) :
    ∃ (script : Script) (pre : List Form), checkAux [] script = some (pre ++ [f]) := by
  induction h with
  | axK a b => exact ⟨[.axK a b], [], rfl⟩
  | axS a b c => exact ⟨[.axS a b c], [], rfl⟩
  | axDne a => exact ⟨[.axDne a], [], rfl⟩
  | @mp a b _ _ ih₁ ih₂ =>
      obtain ⟨s₁, p₁, h₁⟩ := ih₁
      obtain ⟨s₂, p₂, h₂⟩ := ih₂
      refine ⟨s₁ ++ Script.shift (p₁.length + 1) s₂ ++
        [Step.mp p₁.length (p₁.length + 1 + p₂.length)], (p₁ ++ [.imp a b]) ++ (p₂ ++ [a]), ?_⟩
      have hlen : (p₁ ++ [Form.imp a b]).length = p₁.length + 1 := by simp
      have hstep : checkAux ((p₁ ++ [Form.imp a b]) ++ [])
          (Script.shift (p₁.length + 1) s₂) = some ((p₁ ++ [Form.imp a b]) ++ (p₂ ++ [a])) := by
        have := checkAux_shift s₂ [] (p₂ ++ [a]) (p₁ ++ [Form.imp a b]) h₂
        rwa [hlen] at this
      rw [List.append_nil] at hstep
      rw [List.append_assoc, checkAux_append s₁ _ [] _ h₁,
        checkAux_append (Script.shift (p₁.length + 1) s₂) _ _ _ hstep]
      -- one modus ponens step remains
      have hi : ((p₁ ++ [Form.imp a b]) ++ (p₂ ++ [a]))[p₁.length]? = some (.imp a b) := by
        rw [List.getElem?_append_left (by simp), List.getElem?_append_right (by omega)]
        simp
      have hj : ((p₁ ++ [Form.imp a b]) ++ (p₂ ++ [a]))[p₁.length + 1 + p₂.length]? = some a := by
        rw [List.getElem?_append_right (by simp), hlen, List.getElem?_append_right (by omega)]
        simp
      have hmp : stepCheck ((p₁ ++ [Form.imp a b]) ++ (p₂ ++ [a]))
          (Step.mp p₁.length (p₁.length + 1 + p₂.length)) = some b := by
        simp only [stepCheck, hi, hj, if_true]
      simp only [checkAux, hmp]

/-- Every derivation has a script the checker accepts as a proof of it. -/
theorem check_of_provable {f : Form} (h : Provable f) : ∃ script : Script, check script = some f := by
  obtain ⟨script, pre, hs⟩ := Script.of_provable h
  exact ⟨script, by simp [check, hs]⟩

/-- **Completeness of the portable checker.**  Every formula true under every
valuation is proved by some script — the wire format loses nothing. -/
theorem check_complete {f : Form} (h : Tautology f) : ∃ script : Script, check script = some f :=
  check_of_provable (Provable.of_tautology h)

/-- **Soundness and completeness of the engine, in one statement.**  A formula
is provable by some script exactly when it is true under every valuation. -/
theorem proves_iff_tautology {f : Form} : (∃ script : Script, proves script f = true) ↔ Tautology f := by
  constructor
  · rintro ⟨script, hs⟩
    exact check_tautology (by simpa [proves] using hs)
  · intro h
    obtain ⟨script, hs⟩ := check_complete h
    exact ⟨script, by simp [proves, hs]⟩

/-- A formula the engine can never prove is exactly one with a falsifying
valuation: rejection is informative, not just a failure of search. -/
theorem no_script_iff_falsifiable {f : Form} :
    (∀ script : Script, proves script f = false) ↔ ∃ v : Nat → Bool, f.eval v = false := by
  constructor
  · intro h
    refine Classical.byContradiction fun hc => ?_
    have htaut : Tautology f := fun v => by
      cases hv : f.eval v
      · exact absurd ⟨v, hv⟩ hc
      · rfl
    obtain ⟨script, hs⟩ := proves_iff_tautology.2 htaut
    rw [h script] at hs
    exact Bool.noConfusion hs
  · rintro ⟨v, hv⟩ script
    cases hs : proves script f
    · rfl
    · have h2 := proves_iff_tautology.1 ⟨script, hs⟩ v
      rw [hv] at h2
      exact absurd h2 (by simp)

end RequestProject.Kernel
