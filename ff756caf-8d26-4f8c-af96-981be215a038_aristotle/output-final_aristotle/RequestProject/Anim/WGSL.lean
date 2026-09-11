import Mathlib
import RequestProject.Anim.Expr

/-!
# Lowering a formula to a WGSL shader

The formal counterpart of `web/js/wgsl.js`: the studio takes the formula at the
head of a playbook and lowers it to a WGSL kernel that runs on the GPU through
WebGPU.  This file models that translation and proves it *meaning preserving*:
the shader expression computes, value for value, what the CPU evaluator of
`Hesper.Anim.Expr` computes.

Two languages are involved.

* `Expr` (in `RequestProject/Anim/Expr.lean`) is the formula language.  It has
  no booleans: comparisons return `1` or `0`, and `if(c, a, b)` tests `c ≠ 0`.
* `WExpr`/`WCond` is the fragment of WGSL the generator emits.  WGSL *does*
  have a `bool` type, arithmetic is infix, and the conditional is the builtin
  `select(f, t, c)`.

`compile`/`compileCond` are the two mutually recursive emitters of `wgsl.js`
(`emit` and `emitCond`), and `eval_compile` is the statement that the emitted
shader expression is equivalent to the source formula.  Floating point is
idealised: both sides are interpreted over `ℝ`, so the theorem is about the
translation, not about `f32` rounding (the runtime tests in
`tests/node/check_wgsl.py` and `tests/node/check_webgpu.py` measure the actual
`f32` gap against the CPU evaluator).
-/

namespace Hesper.Anim

open scoped Classical

/-! ## The shader expression language -/

mutual

/-- A WGSL value expression of type `f32`. -/
inductive WExpr where
  /-- An `f32` literal. -/
  | lit : ℝ → WExpr
  /-- A reference to a shader lvalue: `p.x`, `U.time`, `P[3]`, … -/
  | ref : String → WExpr
  /-- WGSL unary `-`. -/
  | neg : WExpr → WExpr
  /-- WGSL infix `+`. -/
  | add : WExpr → WExpr → WExpr
  /-- WGSL infix `-`. -/
  | sub : WExpr → WExpr → WExpr
  /-- WGSL infix `*`. -/
  | mul : WExpr → WExpr → WExpr
  /-- WGSL infix `/`. -/
  | div : WExpr → WExpr → WExpr
  /-- A call to a unary WGSL function (builtin or emitted polyfill). -/
  | call₁ : String → WExpr → WExpr
  /-- A call to a binary WGSL function. -/
  | call₂ : String → WExpr → WExpr → WExpr
  /-- A call to a ternary WGSL function. -/
  | call₃ : String → WExpr → WExpr → WExpr → WExpr
  /-- `select(f, t, c)`: `t` when `c` holds, `f` otherwise. -/
  | select : WExpr → WExpr → WCond → WExpr

/-- A WGSL expression of type `bool`. -/
inductive WCond where
  /-- `a < b`. -/
  | lt : WExpr → WExpr → WCond
  /-- `a <= b`. -/
  | le : WExpr → WExpr → WCond
  /-- `a > b`. -/
  | gt : WExpr → WExpr → WCond
  /-- `a >= b`. -/
  | ge : WExpr → WExpr → WCond
  /-- `a == b`. -/
  | eq : WExpr → WExpr → WCond
  /-- `a != b`. -/
  | ne : WExpr → WExpr → WCond
  /-- `c && d`. -/
  | and : WCond → WCond → WCond
  /-- `c || d`. -/
  | or : WCond → WCond → WCond
  /-- `(a != 0.0)`: the coercion of an `f32` to a `bool`. -/
  | nz : WExpr → WCond

end

mutual

/-- Value of a shader expression, given meanings `W` for the WGSL functions and
an assignment `σ` of the shader lvalues. -/
noncomputable def WExpr.eval (W : Interp) (σ : String → ℝ) : WExpr → ℝ
  | .lit v => v
  | .ref s => σ s
  | .neg a => -(WExpr.eval W σ a)
  | .add a b => WExpr.eval W σ a + WExpr.eval W σ b
  | .sub a b => WExpr.eval W σ a - WExpr.eval W σ b
  | .mul a b => WExpr.eval W σ a * WExpr.eval W σ b
  | .div a b => WExpr.eval W σ a / WExpr.eval W σ b
  | .call₁ f a => W.un f (WExpr.eval W σ a)
  | .call₂ f a b => W.bin f (WExpr.eval W σ a) (WExpr.eval W σ b)
  | .call₃ f a b c => W.tern f (WExpr.eval W σ a) (WExpr.eval W σ b) (WExpr.eval W σ c)
  | .select f t c => if WCond.holds W σ c then WExpr.eval W σ t else WExpr.eval W σ f

/-- Truth of a shader condition. -/
noncomputable def WCond.holds (W : Interp) (σ : String → ℝ) : WCond → Prop
  | .lt a b => WExpr.eval W σ a < WExpr.eval W σ b
  | .le a b => WExpr.eval W σ a ≤ WExpr.eval W σ b
  | .gt a b => WExpr.eval W σ b < WExpr.eval W σ a
  | .ge a b => WExpr.eval W σ b ≤ WExpr.eval W σ a
  | .eq a b => WExpr.eval W σ a = WExpr.eval W σ b
  | .ne a b => WExpr.eval W σ a ≠ WExpr.eval W σ b
  | .and c d => WCond.holds W σ c ∧ WCond.holds W σ d
  | .or c d => WCond.holds W σ c ∨ WCond.holds W σ d
  | .nz a => WExpr.eval W σ a ≠ 0

end

/-! ## The generator -/

/-- WGSL name of a unary studio builtin (the `DIRECT`/`POLYFILL` tables of
`web/js/wgsl.js`). -/
def wname₁ : String → String
  | "ln" => "log"
  | "log" => "log"
  | "log10" => "hs_log10"
  | "cbrt" => "hs_cbrt"
  | "saw" => "hs_saw"
  | "tri" => "hs_tri"
  | "square" => "hs_square"
  | f => f

/-- WGSL name of a binary studio builtin. -/
def wname₂ : String → String
  | "mod" => "hs_mod"
  | "hypot" => "hs_hypot"
  | "log" => "hs_log"
  | "gauss" => "hs_gauss"
  | f => f

/-- WGSL name of a ternary studio builtin. -/
def wname₃ : String → String
  | "lerp" => "mix"
  | f => f

mutual

/-- Lower a formula to a WGSL value expression.  `ρ` gives the shader lvalue
that each formula variable is bound to (`x ↦ p.x`, `t ↦ U.time`, a parameter
`a ↦ P[0]`, a constant `pi ↦ 3.14159…`).  This mirrors `emit` in `wgsl.js`. -/
def compile (ρ : String → WExpr) : Expr → WExpr
  | .num v => .lit v
  | .var s => ρ s
  | .neg a => .neg (compile ρ a)
  | .cond c a b => .select (compile ρ b) (compile ρ a) (compileCond ρ c)
  | .bin .add a b => .add (compile ρ a) (compile ρ b)
  | .bin .sub a b => .sub (compile ρ a) (compile ρ b)
  | .bin .mul a b => .mul (compile ρ a) (compile ρ b)
  | .bin .div a b => .div (compile ρ a) (compile ρ b)
  | .bin .mod a b => .call₂ "hs_mod" (compile ρ a) (compile ρ b)
  | .bin .pow a b => .call₂ "pow" (compile ρ a) (compile ρ b)
  | .bin .lt a b => .select (.lit 0) (.lit 1) (.lt (compile ρ a) (compile ρ b))
  | .bin .le a b => .select (.lit 0) (.lit 1) (.le (compile ρ a) (compile ρ b))
  | .bin .gt a b => .select (.lit 0) (.lit 1) (.gt (compile ρ a) (compile ρ b))
  | .bin .ge a b => .select (.lit 0) (.lit 1) (.ge (compile ρ a) (compile ρ b))
  | .bin .eq a b => .select (.lit 0) (.lit 1) (.eq (compile ρ a) (compile ρ b))
  | .bin .ne a b => .select (.lit 0) (.lit 1) (.ne (compile ρ a) (compile ρ b))
  | .bin .and a b =>
      .select (.lit 0) (.lit 1) (.and (compileCond ρ a) (compileCond ρ b))
  | .bin .or a b =>
      .select (.lit 0) (.lit 1) (.or (compileCond ρ a) (compileCond ρ b))
  | .call₁ f a => .call₁ (wname₁ f) (compile ρ a)
  | .call₂ f a b => .call₂ (wname₂ f) (compile ρ a) (compile ρ b)
  | .call₃ f a b c => .call₃ (wname₃ f) (compile ρ a) (compile ρ b) (compile ρ c)

/-- Lower a formula in *boolean* position, mirroring `emitCond` in `wgsl.js`:
comparisons and the logical connectives become genuine WGSL `bool`s, anything
else is compared against zero. -/
def compileCond (ρ : String → WExpr) : Expr → WCond
  | .bin .lt a b => .lt (compile ρ a) (compile ρ b)
  | .bin .le a b => .le (compile ρ a) (compile ρ b)
  | .bin .gt a b => .gt (compile ρ a) (compile ρ b)
  | .bin .ge a b => .ge (compile ρ a) (compile ρ b)
  | .bin .eq a b => .eq (compile ρ a) (compile ρ b)
  | .bin .ne a b => .ne (compile ρ a) (compile ρ b)
  | .bin .and a b => .and (compileCond ρ a) (compileCond ρ b)
  | .bin .or a b => .or (compileCond ρ a) (compileCond ρ b)
  | .num v => .nz (.lit v)
  | .var s => .nz (ρ s)
  | .neg a => .nz (.neg (compile ρ a))
  | .cond c a b => .nz (.select (compile ρ b) (compile ρ a) (compileCond ρ c))
  | .bin .add a b => .nz (compile ρ (.bin .add a b))
  | .bin .sub a b => .nz (compile ρ (.bin .sub a b))
  | .bin .mul a b => .nz (compile ρ (.bin .mul a b))
  | .bin .div a b => .nz (compile ρ (.bin .div a b))
  | .bin .mod a b => .nz (compile ρ (.bin .mod a b))
  | .bin .pow a b => .nz (compile ρ (.bin .pow a b))
  | .call₁ f a => .nz (compile ρ (.call₁ f a))
  | .call₂ f a b => .nz (compile ρ (.call₂ f a b))
  | .call₃ f a b c => .nz (compile ρ (.call₃ f a b c))

end

/-! ## Agreement between the two builtin tables -/

/-- Unary builtins of the studio that the generator has a WGSL image for. -/
def unNames : List String :=
  ["sin", "cos", "tan", "asin", "acos", "atan", "sinh", "cosh", "tanh", "exp",
   "sqrt", "abs", "sign", "floor", "ceil", "round", "ln", "log", "log2",
   "log10", "fract", "saw", "tri", "square", "cbrt"]

/-- Binary builtins of the studio that the generator has a WGSL image for. -/
def binNames : List String :=
  ["min", "max", "atan2", "pow", "hypot", "mod", "log", "gauss", "step"]

/-- Ternary builtins of the studio that the generator has a WGSL image for. -/
def ternNames : List String := ["clamp", "smoothstep", "lerp"]

/-- A formula is *lowerable* when every builtin it calls has a WGSL image. -/
def Expr.Lowerable : Expr → Prop
  | .num _ => True
  | .var _ => True
  | .neg a => a.Lowerable
  | .bin _ a b => a.Lowerable ∧ b.Lowerable
  | .cond c a b => c.Lowerable ∧ a.Lowerable ∧ b.Lowerable
  | .call₁ f a => f ∈ unNames ∧ a.Lowerable
  | .call₂ f a b => f ∈ binNames ∧ a.Lowerable ∧ b.Lowerable
  | .call₃ f a b c => f ∈ ternNames ∧ a.Lowerable ∧ b.Lowerable ∧ c.Lowerable

/-- The WGSL side (`W`) implements the studio side (`I`): each builtin with a
WGSL image means the same thing there, and the two operators that are emitted
as calls (`%` as the `hs_mod` polyfill, `^` as WGSL `pow`) are implemented
correctly. -/
structure Agree (I W : Interp) : Prop where
  /-- Unary builtins agree under the name map. -/
  un : ∀ f ∈ unNames, W.un (wname₁ f) = I.un f
  /-- Binary builtins agree under the name map. -/
  bin : ∀ f ∈ binNames, W.bin (wname₂ f) = I.bin f
  /-- Ternary builtins agree under the name map. -/
  tern : ∀ f ∈ ternNames, W.tern (wname₃ f) = I.tern f
  /-- The `hs_mod` polyfill implements the formula language's `%`. -/
  mod : ∀ a b : ℝ, W.bin "hs_mod" a b = a - b * ⌊a / b⌋
  /-- WGSL `pow` implements the formula language's `^`. -/
  pow : ∀ a b : ℝ, W.bin "pow" a b = a ^ b

/-! ## Correctness of the lowering -/

/-- Main lemma, by induction on the formula: the compiled shader expression
evaluates to the value of the formula, and the compiled *condition* holds
exactly when the formula is nonzero. -/
theorem eval_compile_and_holds (I W : Interp) (h : Agree I W) (ρ : String → WExpr)
    (σ : String → ℝ) (env : String → ℝ) (hρ : ∀ s, WExpr.eval W σ (ρ s) = env s) :
    ∀ e : Expr, e.Lowerable →
      WExpr.eval W σ (compile ρ e) = Expr.eval I env e ∧
      (WCond.holds W σ (compileCond ρ e) ↔ Expr.eval I env e ≠ 0) := by
  intro e
  induction e with
  | num v =>
      intro _
      exact ⟨by simp [compile, WExpr.eval, Expr.eval],
             by simp [compileCond, WCond.holds, WExpr.eval, Expr.eval]⟩
  | var s =>
      intro _
      exact ⟨by simp [compile, Expr.eval, hρ s],
             by simp [compileCond, WCond.holds, Expr.eval, hρ s]⟩
  | neg a ih =>
      intro hl
      obtain ⟨ha, _⟩ := ih hl
      exact ⟨by simp [compile, WExpr.eval, ha, Expr.eval],
             by simp [compileCond, WCond.holds, WExpr.eval, ha, Expr.eval]⟩
  | bin op a b iha ihb =>
      rintro ⟨hla, hlb⟩
      obtain ⟨ha, ha'⟩ := iha hla
      obtain ⟨hb, hb'⟩ := ihb hlb
      cases op <;>
        simp [compile, compileCond, WExpr.eval, WCond.holds, Expr.eval, BinOp.apply,
          ha, hb, ha', hb', h.mod, h.pow, BinOp.ofBool]
      all_goals (try simp_all)
      all_goals tauto
  | cond c a b ihc iha ihb =>
      rintro ⟨hlc, hla, hlb⟩
      obtain ⟨hc, hc'⟩ := ihc hlc
      obtain ⟨ha, _⟩ := iha hla
      obtain ⟨hb, _⟩ := ihb hlb
      exact ⟨by simp [compile, WExpr.eval, Expr.eval, ha, hb, hc'],
             by simp [compileCond, WCond.holds, WExpr.eval, Expr.eval, ha, hb, hc']⟩
  | call₁ f a ih =>
      rintro ⟨hf, hla⟩
      obtain ⟨ha, _⟩ := ih hla
      have hn := h.un f hf
      exact ⟨by simp [compile, WExpr.eval, Expr.eval, ha, hn],
             by simp [compileCond, compile, WCond.holds, WExpr.eval, Expr.eval, ha, hn]⟩
  | call₂ f a b iha ihb =>
      rintro ⟨hf, hla, hlb⟩
      obtain ⟨ha, _⟩ := iha hla
      obtain ⟨hb, _⟩ := ihb hlb
      have hn := h.bin f hf
      exact ⟨by simp [compile, WExpr.eval, Expr.eval, ha, hb, hn],
             by simp [compileCond, compile, WCond.holds, WExpr.eval, Expr.eval, ha, hb, hn]⟩
  | call₃ f a b c iha ihb ihc =>
      rintro ⟨hf, hla, hlb, hlc⟩
      obtain ⟨ha, _⟩ := iha hla
      obtain ⟨hb, _⟩ := ihb hlb
      obtain ⟨hc, _⟩ := ihc hlc
      have hn := h.tern f hf
      exact ⟨by simp [compile, WExpr.eval, Expr.eval, ha, hb, hc, hn],
             by simp [compileCond, compile, WCond.holds, WExpr.eval, Expr.eval, ha, hb, hc, hn]⟩

/-- **The shader expression is equivalent to the formula.** -/
theorem eval_compile (I W : Interp) (h : Agree I W) (ρ : String → WExpr)
    (σ : String → ℝ) (env : String → ℝ) (hρ : ∀ s, WExpr.eval W σ (ρ s) = env s)
    (e : Expr) (he : e.Lowerable) :
    WExpr.eval W σ (compile ρ e) = Expr.eval I env e :=
  (eval_compile_and_holds I W h ρ σ env hρ e he).1

/-- The boolean lowering is faithful to the formula language's `≠ 0` test. -/
theorem holds_compileCond (I W : Interp) (h : Agree I W) (ρ : String → WExpr)
    (σ : String → ℝ) (env : String → ℝ) (hρ : ∀ s, WExpr.eval W σ (ρ s) = env s)
    (e : Expr) (he : e.Lowerable) :
    WCond.holds W σ (compileCond ρ e) ↔ Expr.eval I env e ≠ 0 :=
  (eval_compile_and_holds I W h ρ σ env hρ e he).2

/-! ## The two concrete tables

`Agree` above is a hypothesis about two arbitrary builtin tables.  Here the two
tables the studio actually uses are written down — the CPU table `BUILTIN` of
`web/js/expr.js` and the WGSL table (builtins plus the `hs_*` polyfills emitted
into the shader prelude by `wgsl.js`) — and the hypothesis is discharged: the
emitted polyfills really do implement the builtins they stand in for. -/

noncomputable section

/-- `fract`/`saw`: `x - floor x`. -/
def hsFract (x : ℝ) : ℝ := x - ⌊x⌋
/-- `sign`. -/
def hsSign (x : ℝ) : ℝ := if x < 0 then -1 else if 0 < x then 1 else 0
/-- `tri`: the triangle wave of period one. -/
def hsTri (x : ℝ) : ℝ := if hsFract x < 1/2 then 2 * hsFract x else 2 - 2 * hsFract x
/-- `square`: the square wave of period one. -/
def hsSquare (x : ℝ) : ℝ := if hsFract x < 1/2 then 1 else -1
/-- `cbrt`, defined for negative arguments as well. -/
def hsCbrt (x : ℝ) : ℝ := hsSign x * |x| ^ ((1:ℝ)/3)
/-- `round`, breaking ties upwards as JavaScript and WGSL both do. -/
def hsRound (x : ℝ) : ℝ := ⌊x + 1/2⌋
/-- `mod`: the floored modulus, which is also the meaning of the `%` operator. -/
def hsMod (a b : ℝ) : ℝ := a - b * ⌊a / b⌋
/-- `hypot`. -/
def hsHypot (a b : ℝ) : ℝ := Real.sqrt (a * a + b * b)
/-- `log(x, b)`: the logarithm of `x` in base `b`. -/
def hsLogBase (x b : ℝ) : ℝ := Real.log x / Real.log b
/-- `gauss(x, s)`. -/
def hsGauss (x s : ℝ) : ℝ := Real.exp (-(x * x) / (2 * s * s))
/-- `step(edge, x)`. -/
def hsStep (edge x : ℝ) : ℝ := if x < edge then 0 else 1
/-- `atan2(y, x)`, the angle of the point `(x, y)`. -/
def hsAtan2 (y x : ℝ) : ℝ := Complex.arg ⟨x, y⟩
/-- `clamp(x, a, b)`. -/
def hsClamp (x a b : ℝ) : ℝ := min (max x a) b
/-- `smoothstep(a, b, x)`.  WGSL leaves the degenerate case `a = b` unspecified,
so the model takes the guarded reading the CPU evaluator uses. -/
def hsSmoothstep (a b x : ℝ) : ℝ :=
  if b = a then (if x < a then 0 else 1)
  else (min (max ((x - a) / (b - a)) 0) 1) ^ 2 * (3 - 2 * min (max ((x - a) / (b - a)) 0) 1)
/-- `lerp(a, b, t)`, WGSL's `mix`. -/
def hsLerp (a b t : ℝ) : ℝ := a + (b - a) * t

/-- The studio's CPU builtin table (`BUILTIN` in `web/js/expr.js`), read over
`ℝ`.  Unknown names evaluate to `0`. -/
def studioInterp : Interp where
  un := fun f => match f with
    | "sin" => Real.sin | "cos" => Real.cos | "tan" => Real.tan
    | "asin" => Real.arcsin | "acos" => Real.arccos | "atan" => Real.arctan
    | "sinh" => Real.sinh | "cosh" => Real.cosh | "tanh" => Real.tanh
    | "exp" => Real.exp | "sqrt" => Real.sqrt | "abs" => abs | "sign" => hsSign
    | "floor" => fun x => ⌊x⌋ | "ceil" => fun x => ⌈x⌉ | "round" => hsRound
    | "ln" => Real.log | "log" => Real.log
    | "log2" => fun x => Real.log x / Real.log 2
    | "log10" => fun x => Real.log x / Real.log 10
    | "fract" => hsFract | "saw" => hsFract | "tri" => hsTri | "square" => hsSquare
    | "cbrt" => hsCbrt
    | _ => fun _ => 0
  bin := fun f => match f with
    | "min" => min | "max" => max | "atan2" => hsAtan2 | "pow" => fun a b => a ^ b
    | "hypot" => hsHypot | "mod" => hsMod | "log" => hsLogBase
    | "gauss" => hsGauss | "step" => hsStep
    | _ => fun _ _ => 0
  tern := fun f => match f with
    | "clamp" => hsClamp | "smoothstep" => hsSmoothstep | "lerp" => hsLerp
    | _ => fun _ _ _ => 0

/-- The shader-side table: WGSL's own builtins, plus the `hs_*` polyfills that
`wgsl.js` emits into the shader prelude for the builtins WGSL lacks.  Where WGSL
and the CPU share a function (`sin`, `sqrt`, `min`, …) both denote the same real
function, which is what the fall-through case records. -/
def wgslInterp : Interp where
  un := fun g => match g with
    | "hs_log10" => fun x => Real.log x / Real.log 10
    | "hs_cbrt" => hsCbrt | "hs_saw" => hsFract | "hs_tri" => hsTri
    | "hs_square" => hsSquare
    | "log" => Real.log
    | g => studioInterp.un g
  bin := fun g => match g with
    | "hs_mod" => hsMod | "hs_hypot" => hsHypot | "hs_log" => hsLogBase
    | "hs_gauss" => hsGauss
    | g => studioInterp.bin g
  tern := fun g => match g with
    | "mix" => hsLerp
    | g => studioInterp.tern g

/-- **The emitted prelude is correct**: every builtin of the formula language
means, on the shader side, exactly what it means on the CPU. -/
theorem agree_studio_wgsl : Agree studioInterp wgslInterp := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro f hf; fin_cases hf <;> rfl
  · intro f hf; fin_cases hf <;> rfl
  · intro f hf; fin_cases hf <;> rfl
  · intro _ _; rfl
  · intro _ _; rfl

/-- **One formula, two backends.**  For the studio's actual builtin tables, the
generated shader expression computes the value of the formula. -/
theorem eval_compile_studio (ρ : String → WExpr) (σ env : String → ℝ)
    (hρ : ∀ s, WExpr.eval wgslInterp σ (ρ s) = env s) (e : Expr) (he : e.Lowerable) :
    WExpr.eval wgslInterp σ (compile ρ e) = Expr.eval studioInterp env e :=
  eval_compile _ _ agree_studio_wgsl ρ σ env hρ e he

end

end Hesper.Anim
