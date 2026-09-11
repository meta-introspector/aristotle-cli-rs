import Lean

/-!
# Reflective Lean 4 AST

This file defines a Lean-native reflective AST (`RExpr`) that mirrors the structure
of Lean 4's internal `Expr` type, but as a fully inspectable inductive type.

This is the bridge between Lean's kernel and the MetaCoq term representation:
```
Lean4 Expr → RExpr → MetaCoqTerm → Coq → Haskell → Lean4 → LOOP
```
-/

namespace Reflective

open Lean in

/-! ## Universe levels -/

/-- Reflective universe level, mirroring Lean's `Level`. -/
inductive RLevel where
  | zero : RLevel
  | succ : RLevel → RLevel
  | max : RLevel → RLevel → RLevel
  | imax : RLevel → RLevel → RLevel
  | param : Lean.Name → RLevel
  | mvar : Lean.Name → RLevel
  deriving Inhabited

/-! ## Binder info -/

/-- Binder info, matching Lean's `BinderInfo`. -/
inductive RBinderInfo where
  | default : RBinderInfo
  | implicit : RBinderInfo
  | strictImplicit : RBinderInfo
  | instImplicit : RBinderInfo
  deriving Repr, BEq, Inhabited

/-! ## Literal values -/

/-- Literal values in Lean expressions. -/
inductive RLiteral where
  | natVal : Nat → RLiteral
  | strVal : String → RLiteral
  deriving Repr, BEq, Inhabited

/-! ## The reflective expression type -/

/--
The reflective expression type, mirroring Lean 4's `Expr`.

Key differences from MetaCoq's `Term`:
- Uses `Lean.Name` instead of de Bruijn index strings
- Has `proj` with structured projection info
- Has `mdata` for metadata
- No `tEvar`, `tCast` (Lean doesn't have these in the same way)
- Binder info is explicit (Lean is more granular than Coq here)
-/
inductive RExpr where
  | bvar : Nat → RExpr
  | fvar : Lean.Name → RExpr
  | mvar : Lean.Name → RExpr
  | sort : RLevel → RExpr
  | const : Lean.Name → List RLevel → RExpr
  | app : RExpr → RExpr → RExpr
  | lam : Lean.Name → RBinderInfo → RExpr → RExpr → RExpr
  | forallE : Lean.Name → RBinderInfo → RExpr → RExpr → RExpr
  | letE : Lean.Name → RExpr → RExpr → RExpr → RExpr
  | lit : RLiteral → RExpr
  | mdata : RExpr → RExpr
  | proj : Lean.Name → Nat → RExpr → RExpr
  deriving Inhabited

/-! ## Reification from Lean's `Expr` -/

/-- Convert a Lean `Level` to an `RLevel`. -/
partial def reifyLevel : Lean.Level → RLevel
  | .zero => .zero
  | .succ l => .succ (reifyLevel l)
  | .max l₁ l₂ => .max (reifyLevel l₁) (reifyLevel l₂)
  | .imax l₁ l₂ => .imax (reifyLevel l₁) (reifyLevel l₂)
  | .param n => .param n
  | .mvar n => .mvar n.name

/-- Convert a Lean `BinderInfo` to an `RBinderInfo`. -/
def reifyBinderInfo : Lean.BinderInfo → RBinderInfo
  | .default => .default
  | .implicit => .implicit
  | .strictImplicit => .strictImplicit
  | .instImplicit => .instImplicit

/-- Convert a Lean `Literal` to an `RLiteral`. -/
def reifyLiteral : Lean.Literal → RLiteral
  | .natVal n => .natVal n
  | .strVal s => .strVal s

/--
Reify a Lean `Expr` into an `RExpr`.
This is the first stage of the reflection pipeline.
-/
partial def reifyExpr : Lean.Expr → RExpr
  | .bvar n => .bvar n
  | .fvar fid => .fvar fid.name
  | .mvar mid => .mvar mid.name
  | .sort l => .sort (reifyLevel l)
  | .const n ls => .const n (ls.map reifyLevel)
  | .app f a => .app (reifyExpr f) (reifyExpr a)
  | .lam n ty b bi => .lam n (reifyBinderInfo bi) (reifyExpr ty) (reifyExpr b)
  | .forallE n ty b bi => .forallE n (reifyBinderInfo bi) (reifyExpr ty) (reifyExpr b)
  | .letE n ty v b _ => .letE n (reifyExpr ty) (reifyExpr v) (reifyExpr b)
  | .lit l => .lit (reifyLiteral l)
  | .mdata _ e => .mdata (reifyExpr e)
  | .proj typeName idx struct => .proj typeName idx (reifyExpr struct)

/-! ## Quotation back to Lean's `Expr` -/

/-- Convert an `RLevel` back to a Lean `Level`. -/
partial def quoteLevel : RLevel → Lean.Level
  | .zero => .zero
  | .succ l => .succ (quoteLevel l)
  | .max l₁ l₂ => .max (quoteLevel l₁) (quoteLevel l₂)
  | .imax l₁ l₂ => .imax (quoteLevel l₁) (quoteLevel l₂)
  | .param n => .param n
  | .mvar n => .mvar ⟨n⟩

/-- Convert an `RBinderInfo` back to a Lean `BinderInfo`. -/
def quoteBinderInfo : RBinderInfo → Lean.BinderInfo
  | .default => .default
  | .implicit => .implicit
  | .strictImplicit => .strictImplicit
  | .instImplicit => .instImplicit

/-- Convert an `RLiteral` back to a Lean `Literal`. -/
def quoteLiteral : RLiteral → Lean.Literal
  | .natVal n => .natVal n
  | .strVal s => .strVal s

/--
Quote an `RExpr` back to a Lean `Expr`.
This is the inverse of `reifyExpr`, up to homotopy.
-/
partial def quoteExpr : RExpr → Lean.Expr
  | .bvar n => .bvar n
  | .fvar n => .fvar ⟨n⟩
  | .mvar n => .mvar ⟨n⟩
  | .sort l => .sort (quoteLevel l)
  | .const n ls => .const n (ls.map quoteLevel)
  | .app f a => .app (quoteExpr f) (quoteExpr a)
  | .lam n bi ty b => .lam n (quoteExpr ty) (quoteExpr b) (quoteBinderInfo bi)
  | .forallE n bi ty b => .forallE n (quoteExpr ty) (quoteExpr b) (quoteBinderInfo bi)
  | .letE n ty v b => .letE n (quoteExpr ty) (quoteExpr v) (quoteExpr b) false
  | .lit l => .lit (quoteLiteral l)
  | .mdata e => .mdata {} (quoteExpr e)
  | .proj n i s => .proj n i (quoteExpr s)

end Reflective
