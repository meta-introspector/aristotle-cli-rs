import RequestProject.Gvcs.Rig.Wasm

/-!
# What the little pieces of code compute

`RequestProject/Rig/Wasm.lean` builds the module out of a dozen combinators —
`addE`, `divE`, `ifE`, `clampCE` and the rest.  This file says what each one
computes, once and for all, in terms of the `Computes` predicate of
`RequestProject/Wasm/Ir.lean`.  Every later proof about the module is then a
matter of putting these together, never of unfolding instructions.

Each lemma is stated over an arbitrary memory `mem` and arbitrary locals `L`,
so the same lemma serves inside every one of the six entry points.
-/

namespace LifeTrac
namespace Rig

open Wasm

namespace Code

variable {L : List Int} {mem : Int → Int}

/-! ## The leaves -/

theorem cst (n : Int) : Computes L mem (Rig.cst n) n := Computes.const n

theorem loc (i : Nat) : Computes L mem [Instr.localGet i] (L.getD i 0) := Computes.localGet i

theorem ld (a : Int) : Computes L mem (Rig.ld a) (mem a) := Computes.load (Computes.const a)

theorem ldE {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (Rig.ldE e) (mem a) := Computes.load h

/-! ## Arithmetic -/

theorem addE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (Rig.addE e₁ e₂) (a + b) :=
  Computes.add h₁ h₂

theorem subE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (Rig.subE e₁ e₂) (a - b) :=
  Computes.sub h₁ h₂

theorem mulE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (Rig.mulE e₁ e₂) (a * b) :=
  Computes.mul h₁ h₂

theorem divE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (Rig.divE e₁ e₂) (a.tdiv b) :=
  Computes.divs h₁ h₂

theorem negE {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (Rig.negE e) (-a) := by
  have := Computes.sub (Computes.const (0 : Int)) h
  simpa [Rig.negE, Rig.subE, Rig.cst] using this

/-! ## Comparisons -/

theorem ltE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) :
    Computes L mem (Rig.ltE e₁ e₂) (ofBool (decide (a < b))) :=
  Computes.bin h₁ h₂ _ (fun _ => rfl)

theorem leE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) :
    Computes L mem (Rig.leE e₁ e₂) (ofBool (decide (a ≤ b))) :=
  Computes.le h₁ h₂

theorem andE {e₁ e₂ : List Instr} {p q : Bool} (h₁ : Computes L mem e₁ (ofBool p))
    (h₂ : Computes L mem e₂ (ofBool q)) :
    Computes L mem (Rig.andE e₁ e₂) (ofBool (p && q)) :=
  Computes.and' h₁ h₂

/-! ## Conditionals -/

theorem ifE {c t e : List Instr} {p : Bool} {v : Int} (hc : Computes L mem c (ofBool p))
    (ht : p = true → Computes L mem t v) (he : p = false → Computes L mem e v) :
    Computes L mem (Rig.ifE c t e) v :=
  Computes.ifte hc ht he

/-- A conditional on a value that is not written as a `Bool`: the `then` arm is
taken exactly when it is not zero, which is WebAssembly's own rule. -/
theorem ifE' {c t e : List Instr} {b v : Int} (hc : Computes L mem c b)
    (ht : b ≠ 0 → Computes L mem t v) (he : b = 0 → Computes L mem e v) :
    Computes L mem (Rig.ifE c t e) v := by
  intro s
  rw [Rig.ifE, execs_append, hc]
  simp only [execs_cons, execs_nil, exec]
  by_cases h : b = 0
  · rw [if_neg (by simp [h])]; exact he h s
  · rw [if_pos h]; exact ht h s

/-! ## The derived operations -/

theorem absE {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (Rig.absE e) |a| := by
  refine ifE (ltE h (cst 0)) (fun hp => ?_) (fun hp => ?_)
  · rw [abs_of_neg (by simpa using of_decide_eq_true hp)]
    exact negE h
  · rw [abs_of_nonneg (by simpa using of_decide_eq_false hp)]
    exact h

theorem minE {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (Rig.minE e₁ e₂) (min a b) := by
  refine ifE (ltE h₁ h₂) (fun hp => ?_) (fun hp => ?_)
  · rw [min_eq_left (le_of_lt (by simpa using of_decide_eq_true hp))]; exact h₁
  · rw [min_eq_right (by simpa using of_decide_eq_false hp)]; exact h₂

theorem max0E {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (Rig.max0E e) (max 0 a) := by
  refine ifE (ltE h (cst 0)) (fun hp => ?_) (fun hp => ?_)
  · rw [max_eq_left (le_of_lt (by simpa using of_decide_eq_true hp))]; exact cst 0
  · rw [max_eq_right (by simpa using of_decide_eq_false hp)]; exact h

/-- Clamping to a constant bound is `clampTo`. -/
theorem clampCE {b : Int} (hb : 0 ≤ b) {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (Rig.clampCE b e) (clampTo b a) := by
  rw [clampTo_eq_ite hb]
  refine ifE (ltE h (cst (-b))) (fun hp => ?_) (fun hp => ?_)
  · rw [if_pos (by simpa using of_decide_eq_true hp)]; exact cst _
  · rw [if_neg (by simpa using of_decide_eq_false hp)]
    refine ifE (ltE (cst b) h) (fun hq => ?_) (fun hq => ?_)
    · rw [if_pos (by simpa using of_decide_eq_true hq)]; exact cst _
    · rw [if_neg (by simpa using of_decide_eq_false hq)]; exact h

/-- Clamping to a bound that is itself computed. -/
theorem clampE {eb : List Instr} {b : Int} (hb : 0 ≤ b) (hbe : Computes L mem eb b)
    {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (Rig.clampE eb e) (clampTo b a) := by
  rw [clampTo_eq_ite hb]
  refine ifE (ltE h (negE hbe)) (fun hp => ?_) (fun hp => ?_)
  · rw [if_pos (by simpa using of_decide_eq_true hp)]; exact negE hbe
  · rw [if_neg (by simpa using of_decide_eq_false hp)]
    refine ifE (ltE hbe h) (fun hq => ?_) (fun hq => ?_)
    · rw [if_pos (by simpa using of_decide_eq_true hq)]; exact hbe
    · rw [if_neg (by simpa using of_decide_eq_false hq)]; exact h

/-! ## Statements -/

theorem putE {mem : Int → Int} {a v : Int} {e : List Instr} (h : Computes L mem e v) :
    Effects L mem (store1 mem a v) (Rig.putE a e) := Effects.put h

theorem putAtE {mem : Int → Int} {a v : Int} {ea e : List Instr}
    (ha : Computes L mem ea a) (h : Computes L mem e v) :
    Effects L mem (store1 mem a v) (Rig.putAtE ea e) := Effects.putAt ha h

end Code

/-! ## Bodies that both change the memory and leave a value -/

/-- `e` turns `mem` into `mem'` and leaves `v` on top of the stack: the shape
of `reset` and `tick`, a chain of stores followed by a constant. -/
def Returns (L : List Int) (mem mem' : Int → Int) (e : List Instr) (v : Int) : Prop :=
  ∀ s : List Int, execs ⟨s, L, mem⟩ e = ⟨v :: s, L, mem'⟩

namespace Returns

variable {L : List Int} {mem mem₁ mem₂ : Int → Int}

/-- A pure expression returns its value and changes nothing. -/
theorem ofComputes {e : List Instr} {v : Int} (h : Computes L mem e v) :
    Returns L mem mem e v := h

/-- A store, then the rest. -/
theorem step {e₁ e₂ : List Instr} {v : Int} (h₁ : Effects L mem mem₁ e₁)
    (h₂ : Returns L mem₁ mem₂ e₂ v) : Returns L mem mem₂ (e₁ ++ e₂) v := by
  intro s; rw [execs_append, h₁, h₂]

end Returns

/-- What such a body returns. -/
theorem callFun_of_returns {body : List Instr} {args : List Int} {mem mem' : Int → Int}
    {v : Int} (h : Returns args mem mem' body v) : callFun body args 0 mem = v := by
  simp [callFun, runFun, h []]

/-- And the memory it leaves. -/
theorem memAfter_of_returns {body : List Instr} {args : List Int} {mem mem' : Int → Int}
    {v : Int} (h : Returns args mem mem' body v) : memAfter body args 0 mem = mem' := by
  simp [memAfter, runFun, h []]

/-- Running a body that computes a value on the empty stack. -/
theorem callFun_of_computes {body : List Instr} {args : List Int} {mem : Int → Int}
    {v : Int} (h : Computes args mem body v) : callFun body args 0 mem = v := by
  simp [callFun, runFun, h []]

/-- The memory a body that only has effects leaves behind. -/
theorem memAfter_of_effects {body : List Instr} {args : List Int} {mem mem' : Int → Int}
    (h : Effects args mem mem' body) : memAfter body args 0 mem = mem' := by
  simp [memAfter, runFun, h []]

end Rig
end LifeTrac
