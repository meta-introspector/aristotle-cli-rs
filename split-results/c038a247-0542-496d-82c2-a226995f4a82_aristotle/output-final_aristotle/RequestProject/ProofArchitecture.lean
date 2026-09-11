import Mathlib

/-!
# A Lean 4 Proof Architecture: the symbolic bedrock, formalized

The accompanying essay is largely a conceptual / metaphorical piece ("Technical
Metamorphosis", the "Kafka Misdirection", the "Bott Periodicity meta-meme", and so on).
Those framing devices are not mathematical statements and cannot be proved or disproved.

What *is* genuinely formalizable is the concrete technical core of §2–§4: the claim that
every Lean term is built from a small fixed set of constructors of an abstract syntax tree
(`Lean.Expr`), that bound variables are managed by **de Bruijn indices** (natural numbers),
and that the **recursor** is a *deterministic, total, rule-bound* engine of transformation
— in explicit contrast to "deconstructive chaos".

This file makes that precise by building a faithful miniature of `Lean.Expr`, called
`SimpleExpr`, with exactly the five constructors highlighted in the essay
(`bvar`, `const`, `app`, `lam`, `forallE`), and proving small structural theorems about it.

The "engine of metamorphosis" is the automatically generated recursor `SimpleExpr.rec`:
every function below (`size`, `liftFrom`, `boundOK`) is defined by structural recursion and
is therefore total and deterministic — the constructive counterpoint to the essay's
"Kafkaesque" decay.
-/

namespace ProofArchitecture

/-- A faithful miniature of `Lean.Expr` — the "foundational atom" / bedrock AST.

The five constructors mirror the ones emphasised in the essay:
* `bvar`    — bound variables, addressed by **de Bruijn indices** (`Nat`);
* `const`   — named constants carrying a `List` of universe levels (here `List Nat`);
* `app`     — function application;
* `lam`     — lambda abstraction (binds one variable);
* `forallE` — dependent function type / universal quantifier (binds one variable). -/
inductive SimpleExpr where
  | bvar    (idx : Nat)
  | const   (name : String) (levels : List Nat)
  | app     (fn arg : SimpleExpr)
  | lam     (body : SimpleExpr)
  | forallE (domain body : SimpleExpr)
deriving Repr, DecidableEq

namespace SimpleExpr

/-- Structural size of an expression (number of constructor nodes). -/
def size : SimpleExpr → Nat
  | bvar _      => 1
  | const _ _   => 1
  | app f a     => 1 + size f + size a
  | lam b       => 1 + size b
  | forallE d b => 1 + size d + size b

/-- The de Bruijn **lift** (shift): increment every *free* variable whose index is at least
the `cutoff`, leaving genuinely bound variables untouched. Passing under a binder raises the
cutoff by one. This is the standard mechanism behind alpha-equivalence-free renaming. -/
def liftFrom (cutoff : Nat) : SimpleExpr → SimpleExpr
  | bvar i      => if i < cutoff then bvar i else bvar (i + 1)
  | const n ls  => const n ls
  | app f a     => app (liftFrom cutoff f) (liftFrom cutoff a)
  | lam b       => lam (liftFrom (cutoff + 1) b)
  | forallE d b => forallE (liftFrom cutoff d) (liftFrom (cutoff + 1) b)

/-- `boundOK n e` holds when every de Bruijn index occurring free in `e` is `< n`,
i.e. `e` has no "dangling" variable beyond the `n` enclosing binders. With `n = 0` this is
the predicate of being a **closed** term. -/
def boundOK (n : Nat) : SimpleExpr → Bool
  | bvar i      => i < n
  | const _ _   => true
  | app f a     => boundOK n f && boundOK n a
  | lam b       => boundOK (n + 1) b
  | forallE d b => boundOK n d && boundOK (n + 1) b

/-- Every expression has at least one constructor node: the transformation engine never
produces "nothing". -/
theorem size_pos (e : SimpleExpr) : 1 ≤ size e := by
  cases e <;> simp [size] <;> omega

/-- Lifting is a pure **renaming**: it never changes the structural size of a term.
A concrete instance of the essay's "constructive, rule-bound metamorphosis". -/
theorem size_liftFrom (c : Nat) (e : SimpleExpr) : size (liftFrom c e) = size e := by
  -- We'll use induction on the structure of the expression to prove that the size is preserved under lifting.
  induction' e with e ih generalizing c;
  · unfold liftFrom; aesop;
  · rfl;
  · rw [ show liftFrom c ( _ |> SimpleExpr.app <| _ ) = SimpleExpr.app ( liftFrom c _ ) ( liftFrom c _ ) by rfl ] ; simp +arith +decide [ *, SimpleExpr.size ];
  · convert congr_arg ( fun x => 1 + x ) ( ‹∀ c, ( liftFrom c _ ).size = _› ( c + 1 ) ) using 1;
  · rename_i domain body hd hb;
    convert congr_arg₂ ( fun x y => 1 + x + y ) ( hd c ) ( hb ( c + 1 ) ) using 1

/-- The bound-checking predicate is monotone in the binder depth. -/
theorem boundOK_mono {n : Nat} {e : SimpleExpr} (h : boundOK n e = true) :
    boundOK (n + 1) e = true := by
      induction e generalizing n <;> simp_all +decide [ boundOK ];
      linarith

/-- If every free index of `e` is below the cutoff `n`, then lifting at `n` is the identity:
closed-enough terms are *stable* under the transformation. -/
theorem liftFrom_eq_self (n : Nat) (e : SimpleExpr) (h : boundOK n e = true) :
    liftFrom n e = e := by
  induction e generalizing n with
  | bvar i => simp only [boundOK, decide_eq_true_eq] at h; simp [liftFrom, h]
  | const => rfl
  | app f a ihf iha =>
      simp only [boundOK, Bool.and_eq_true] at h
      simp [liftFrom, ihf n h.1, iha n h.2]
  | lam b ih =>
      simp only [boundOK] at h
      simp [liftFrom, ih (n + 1) h]
  | forallE d b ihd ihb =>
      simp only [boundOK, Bool.and_eq_true] at h
      simp [liftFrom, ihd n h.1, ihb (n + 1) h.2]

end SimpleExpr

end ProofArchitecture