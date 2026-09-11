import Mathlib

/-!
# The formula language

The formal counterpart of `web/js/expr.js`: the abstract syntax of the
expressions a playbook is written in, together with their evaluation.

Builtin functions are left abstract (an `Interp` supplies them), because the
studio's builtins are just the ambient real functions — what matters formally is
the shape of evaluation, not the particular table.  Arities are capped at three,
which covers every builtin the studio offers (`clamp`, `smoothstep`, `lerp` are
the ternary ones).

The main result is `eval_congr`: evaluation only depends on the environment
through the free variables of the expression, so a formula that does not mention
`t` really is a still image, and rebinding an unused parameter cannot change a
frame.
-/

namespace Hesper.Anim

/-- Binary operators of the formula language. -/
inductive BinOp
  | add | sub | mul | div | mod | pow
  | lt | le | gt | ge | eq | ne | and | or
  deriving DecidableEq, Repr

namespace BinOp

/-- Truth values are reals, exactly as in the JavaScript evaluator. -/
noncomputable def ofBool (b : Prop) [Decidable b] : ℝ := if b then 1 else 0

/-- Meaning of a binary operator. -/
noncomputable def apply : BinOp → ℝ → ℝ → ℝ
  | add, a, b => a + b
  | sub, a, b => a - b
  | mul, a, b => a * b
  | div, a, b => a / b
  | mod, a, b => a - b * ⌊a / b⌋
  | pow, a, b => a ^ b
  | lt, a, b => ofBool (a < b)
  | le, a, b => ofBool (a ≤ b)
  | gt, a, b => ofBool (b < a)
  | ge, a, b => ofBool (b ≤ a)
  | eq, a, b => ofBool (a = b)
  | ne, a, b => ofBool (a ≠ b)
  | and, a, b => ofBool (a ≠ 0 ∧ b ≠ 0)
  | or, a, b => ofBool (a ≠ 0 ∨ b ≠ 0)

end BinOp

/-- Expressions of the formula language. -/
inductive Expr
  /-- A numeric literal. -/
  | num : ℝ → Expr
  /-- A variable: `x`, `y`, `t`, or an animated parameter. -/
  | var : String → Expr
  /-- Unary minus. -/
  | neg : Expr → Expr
  /-- A binary operation. -/
  | bin : BinOp → Expr → Expr → Expr
  /-- `if(c, a, b)`. -/
  | cond : Expr → Expr → Expr → Expr
  /-- A unary builtin, e.g. `sin`. -/
  | call₁ : String → Expr → Expr
  /-- A binary builtin, e.g. `atan2`. -/
  | call₂ : String → Expr → Expr → Expr
  /-- A ternary builtin, e.g. `clamp`. -/
  | call₃ : String → Expr → Expr → Expr → Expr

/-- Interpretation of the builtin function names. -/
structure Interp where
  /-- Unary builtins. -/
  un : String → ℝ → ℝ
  /-- Binary builtins. -/
  bin : String → ℝ → ℝ → ℝ
  /-- Ternary builtins. -/
  tern : String → ℝ → ℝ → ℝ → ℝ

namespace Expr

/-- Evaluate an expression in an environment. -/
noncomputable def eval (I : Interp) (env : String → ℝ) : Expr → ℝ
  | .num v => v
  | .var s => env s
  | .neg a => -(eval I env a)
  | .bin op a b => op.apply (eval I env a) (eval I env b)
  | .cond c a b => if eval I env c ≠ 0 then eval I env a else eval I env b
  | .call₁ f a => I.un f (eval I env a)
  | .call₂ f a b => I.bin f (eval I env a) (eval I env b)
  | .call₃ f a b c => I.tern f (eval I env a) (eval I env b) (eval I env c)

/-- The variables an expression can read. -/
def freeVars : Expr → Finset String
  | .num _ => ∅
  | .var s => {s}
  | .neg a => a.freeVars
  | .bin _ a b => a.freeVars ∪ b.freeVars
  | .cond c a b => c.freeVars ∪ a.freeVars ∪ b.freeVars
  | .call₁ _ a => a.freeVars
  | .call₂ _ a b => a.freeVars ∪ b.freeVars
  | .call₃ _ a b c => a.freeVars ∪ b.freeVars ∪ c.freeVars

@[simp] theorem eval_num (I : Interp) (env : String → ℝ) (v : ℝ) :
    eval I env (.num v) = v := rfl

@[simp] theorem eval_var (I : Interp) (env : String → ℝ) (s : String) :
    eval I env (.var s) = env s := rfl

/-- Evaluation only depends on the environment through the free variables. -/
theorem eval_congr (I : Interp) (e : Expr) {env₁ env₂ : String → ℝ}
    (h : ∀ s ∈ e.freeVars, env₁ s = env₂ s) : eval I env₁ e = eval I env₂ e := by
  induction e with
  | num v => rfl
  | var s => exact h s (by simp [freeVars])
  | neg a ih => simp [eval, ih (fun s hs => h s (by simpa [freeVars] using hs))]
  | bin op a b iha ihb =>
    simp only [eval]
    rw [iha (fun s hs => h s (by simp [freeVars, hs])),
        ihb (fun s hs => h s (by simp [freeVars, hs]))]
  | cond c a b ihc iha ihb =>
    simp only [eval]
    rw [ihc (fun s hs => h s (by simp [freeVars, hs])),
        iha (fun s hs => h s (by simp [freeVars, hs])),
        ihb (fun s hs => h s (by simp [freeVars, hs]))]
  | call₁ f a ih => simp [eval, ih (fun s hs => h s (by simpa [freeVars] using hs))]
  | call₂ f a b iha ihb =>
    simp only [eval]
    rw [iha (fun s hs => h s (by simp [freeVars, hs])),
        ihb (fun s hs => h s (by simp [freeVars, hs]))]
  | call₃ f a b c iha ihb ihc =>
    simp only [eval]
    rw [iha (fun s hs => h s (by simp [freeVars, hs])),
        ihb (fun s hs => h s (by simp [freeVars, hs])),
        ihc (fun s hs => h s (by simp [freeVars, hs]))]

/-- A formula that never mentions the clock is a still image. -/
theorem eval_time_independent (I : Interp) (e : Expr) (env : String → ℝ)
    (h : "t" ∉ e.freeVars) (t₁ t₂ : ℝ) :
    eval I (Function.update env "t" t₁) e = eval I (Function.update env "t" t₂) e := by
  refine eval_congr I e (fun s hs => ?_)
  have hne : s ≠ "t" := by rintro rfl; exact h hs
  simp [Function.update_of_ne hne]

/-- A closed expression evaluates to the same value in every environment. -/
theorem eval_closed (I : Interp) (e : Expr) (h : e.freeVars = ∅) (env₁ env₂ : String → ℝ) :
    eval I env₁ e = eval I env₂ e :=
  eval_congr I e (fun s hs => by simp [h] at hs)

end Expr

end Hesper.Anim
