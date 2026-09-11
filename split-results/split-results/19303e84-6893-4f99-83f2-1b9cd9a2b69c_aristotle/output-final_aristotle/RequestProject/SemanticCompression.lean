import RequestProject.Main

open scoped BigOperators
open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# Semantic compression: syntax can be exponentially smaller than semantics

The informal "Theory 1" claim, *that the syntactic size of an expression is always
strictly smaller than the extent of the value it denotes*, is **false as a universal
statement**: an atom such as `SimpleExpr.bvar 0` has small size yet no larger semantic
value, and the claim is sensitive to whichever ad-hoc "extent" measure is chosen.

What *is* genuinely true — and is the real content of the slogan "syntax compresses
semantics" — is an **existence** result: there is a family of expressions whose
syntactic size grows only *linearly* while a perfectly reasonable numeric semantics
grows *exponentially*.  We make this precise and prove it.

* `SimpleExpr.size`   — the AST node count (linear structural cost).
* `SimpleExpr.denote` — a toy numeric semantics in which a `const `double` []` head
  doubles its argument and `const `one` []` denotes `1`.
* `SimpleExpr.tower n` — a left spine of `n` `double`s applied to `one`.

`compression` then states that `tower n` has size `2 * n + 1` (linear) yet denotes
`2 ^ n` (exponential): a verified instance of semantic compression.
-/

namespace SimpleExpr

/-- **Syntactic size**: number of AST nodes (each constructor costs `1`, plus its
children). -/
def size : SimpleExpr → Nat
  | .bvar _        => 1
  | .sort _        => 1
  | .const _ _     => 1
  | .app f a       => 1 + f.size + a.size
  | .lam _ t b _   => 1 + t.size + b.size
  | .forallE _ t b _ => 1 + t.size + b.size

/-- **A toy numeric semantics.**  `const `one` []` denotes `1`; applying the head
`const `double` []` doubles the denotation of its argument; everything else denotes `0`. -/
def denote : SimpleExpr → Nat
  | .const n _ => if n = `one then 1 else 0
  | .app (.const n _) a => if n = `double then 2 * denote a else 0
  | _ => 0

/-- The compressing family: a left spine of `n` `double`s applied to `one`. -/
def tower : Nat → SimpleExpr
  | 0     => .const `one []
  | n + 1 => .app (.const `double []) (tower n)

/-- The size of `tower n` is linear in `n`. -/
theorem size_tower (n : Nat) : (tower n).size = 2 * n + 1 := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [tower, size]; omega

/-- The denotation of `tower n` is `2 ^ n` — exponential in `n`. -/
theorem denote_tower (n : Nat) : (tower n).denote = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [tower, pow_succ']; simp [denote, ih]

/-- **Semantic compression (verified).**  Along the family `tower`, syntactic size is
linear in `n` while the denoted value is exponential in `n`. -/
theorem compression (n : Nat) :
    (tower n).size = 2 * n + 1 ∧ (tower n).denote = 2 ^ n :=
  ⟨size_tower n, denote_tower n⟩

end SimpleExpr