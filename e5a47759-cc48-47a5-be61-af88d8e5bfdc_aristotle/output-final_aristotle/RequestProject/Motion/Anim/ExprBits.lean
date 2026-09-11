import RequestProject.Motion.Anim.ExprKernel

/-!
# What a `Float` denotes, and one evaluation that is exact

`ExprKernel.lean` states the correspondence between the float evaluator and the
real-valued specification relative to an embedding `φ : Float → ℝ` and a
hypothesis (`Refines`, or the per-evaluation `EvalExact`) about how the
primitives behave under it.  That is honest, but on its own it leaves two fair
questions open: *which* embedding, and can the hypothesis ever hold?

This module answers both.

* `Float.toRatOfBits` decodes the IEEE-754 bit pattern of a finite double to the
  exact rational it denotes — no axiom, no oracle, and computable, so a claim
  about it can be *checked*.  `Float.toRealOfBits` is that rational in `ℝ`.
* `evalExact_two_add_three_halves` exhibits an evaluation for which
  `Tree.EvalExact` genuinely holds, and `eval_correspondence_concrete` runs it
  through `eval_correspondence_exact` to get a correspondence with **no
  hypothesis left over at all**.

So the conditional theorems are not vacuous: there is a real embedding and there
are real evaluations satisfying their hypotheses.  What remains true, and is
said plainly in `docs/wasm-kernel.md`, is that the hypothesis has to be
discharged *per evaluation* — the arithmetic facts below are obtained by
computing with the platform's own `Float`, via `native_decide`, because Lean's
`Float` operations are opaque to the kernel and no lemma about them is
derivable.
-/

namespace Hesper.Anim
namespace Kernel

namespace Float

/-- The exact rational a **finite** IEEE-754 double denotes, decoded from its
bits.  Infinities and `NaN` denote no rational and are sent to `0`; they are
excluded wherever this is used, by `Float.isFinite`. -/
def toRatOfBits (x : _root_.Float) : ℚ :=
  let u := x.toBits.toNat
  let s := u >>> 63
  let e := (u >>> 52) % 2048
  let m := u % 4503599627370496
  let sgn : ℚ := if s = 1 then -1 else 1
  if e = 0 then sgn * (m : ℚ) / (2 : ℚ) ^ (1074 : ℕ)
  else if e = 2047 then 0
  else sgn * ((4503599627370496 + m : ℕ) : ℚ) * (2 : ℚ) ^ ((e : ℤ) - 1075)

/-- The real number a finite double denotes. -/
noncomputable def toRealOfBits (x : _root_.Float) : ℝ := (toRatOfBits x : ℚ)

@[simp] theorem toRealOfBits_def (x : _root_.Float) :
    toRealOfBits x = ((toRatOfBits x : ℚ) : ℝ) := rfl

/-- The decoder gets the obvious cases right — checked by decoding the bits the
platform actually produces. -/
example : toRatOfBits 0.0 = 0 := by native_decide
example : toRatOfBits 1.0 = 1 := by native_decide
example : toRatOfBits 2.5 = 5 / 2 := by native_decide
example : toRatOfBits (-0.75) = -3 / 4 := by native_decide
example : toRatOfBits 0.1 = 3602879701896397 / 36028797018963968 := by native_decide

/-- A float addition that happens to be exact, transferred to `ℝ`.  The
hypothesis is a statement about rationals, so it can be *computed*; there is no
lemma in Lean relating `Float.add` to anything, which is exactly why the
transfer has to be set up this way. -/
theorem toRealOfBits_add (a b : _root_.Float)
    (h : toRatOfBits (a + b) = toRatOfBits a + toRatOfBits b) :
    toRealOfBits (a + b) = toRealOfBits a + toRealOfBits b := by
  simp [toRealOfBits, h]

/-- The same for multiplication. -/
theorem toRealOfBits_mul (a b : _root_.Float)
    (h : toRatOfBits (a * b) = toRatOfBits a * toRatOfBits b) :
    toRealOfBits (a * b) = toRealOfBits a * toRealOfBits b := by
  simp [toRealOfBits, h]

/-- The same for subtraction. -/
theorem toRealOfBits_sub (a b : _root_.Float)
    (h : toRatOfBits (a - b) = toRatOfBits a - toRatOfBits b) :
    toRealOfBits (a - b) = toRealOfBits a - toRealOfBits b := by
  simp [toRealOfBits, h]

end Float

/-! ## An evaluation whose exactness hypothesis actually holds -/

/-- `x + 1.5` at `x = 2`: three nodes, one of them an addition of two doubles
that is representable exactly.  This is a witness that `Tree.EvalExact` is not
an empty hypothesis. -/
def sampleTree : Tree Float := .bin .add (.var 0) (.num 1.5)

private theorem sample_add_exact :
    Float.toRatOfBits ((2.0 : Float) + 1.5)
      = Float.toRatOfBits (2.0 : Float) + Float.toRatOfBits (1.5 : Float) := by
  native_decide

/-- The evaluation of `sampleTree` at `x = 2` is exact at every node. -/
theorem evalExact_sampleTree (I : Interp) (fn : Nat → String) :
    Tree.EvalExact floatOps (realOps I fn) Float.toRealOfBits (fun _ => 2.0) sampleTree := by
  refine ⟨trivial, trivial, ?_⟩
  show Float.toRealOfBits (floatBinOp .add _ _) = BinOp.apply .add _ _
  simpa [floatBinOp, BinOp.apply, Tree.eval] using
    Float.toRealOfBits_add 2.0 1.5 sample_add_exact

/-- **A correspondence with nothing assumed.**  For this expression and this
environment, the value the float kernel computes denotes exactly the real number
the studio's specification `Hesper.Anim.Expr.eval` gives.  Every hypothesis of
`eval_correspondence_exact` has been discharged. -/
theorem eval_correspondence_concrete (I : Interp) (vn fn : Nat → String)
    (env' : String → ℝ) (henv : ∀ i, env' (vn i) = Float.toRealOfBits 2.0) :
    Float.toRealOfBits (Tree.eval floatOps (fun _ => 2.0) sampleTree)
      = Expr.eval I env' ((sampleTree.map Float.toRealOfBits).toExpr vn fn) :=
  eval_correspondence_exact I vn fn Float.toRealOfBits (fun _ => 2.0) env' henv
    sampleTree (evalExact_sampleTree I fn)

/-- And the number is the one it should be. -/
example : (Float.toRatOfBits (Tree.eval floatOps (fun _ => 2.0) sampleTree)) = 7 / 2 := by
  native_decide

end Kernel
end Hesper.Anim
