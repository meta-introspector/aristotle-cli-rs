import RequestProject.MetaCoqAST
import RequestProject.ReflectiveAST

/-!
# Translation between Reflective AST and MetaCoq AST

This file defines the translation functions between the Lean-native reflective
AST (`RExpr`) and the MetaCoq kernel term AST (`Term`).

This is Stage B of the reflection pipeline:
```
ReflectiveTermₗ₄ → MetaCoqTermₗ₄
MetaCoqTermₗ₄ → ReflectiveTermₗ₄
```
-/

namespace Translate

open MetaCoq Reflective

/-! ## Name translation -/

/-- Convert a Lean `Name` to a MetaCoq `Ident`. -/
def nameToIdent : Lean.Name → MetaCoq.Ident
  | .anonymous => "_"
  | .str _ s => s
  | .num _ n => s!"_{n}"

/-- Convert a MetaCoq `Ident` to a Lean `Name`. -/
def identToName (i : MetaCoq.Ident) : Lean.Name :=
  if i == "_" then .anonymous
  else .str .anonymous i

/-- Convert a Lean `Name` to a full MetaCoq `Kername` (using a default module path). -/
def nameToKername (n : Lean.Name) : MetaCoq.Kername := {
  modpath := .mpFile []
  ident := nameToIdent n
}

/-! ## Universe level translation -/

private def nameToNat : Lean.Name → Nat
  | .num _ n => n
  | _ => 0

/-- Translate a reflective level to a MetaCoq level. -/
def translateLevel : RLevel → MetaCoq.MCLevel
  | .zero => .set
  | .succ l => .succ (translateLevel l)
  | .max l₁ l₂ => .max (translateLevel l₁) (translateLevel l₂)
  | .imax l₁ l₂ => .imax (translateLevel l₁) (translateLevel l₂)
  | .param n => .levelVar (nameToNat n)
  | .mvar _ => .levelVar 0

/-- Translate a MetaCoq level to a reflective level. -/
def translateLevelBack : MetaCoq.MCLevel → RLevel
  | .prop => .zero
  | .set => .zero
  | .levelVar n => .param (.num .anonymous n)
  | .succ l => .succ (translateLevelBack l)
  | .max l₁ l₂ => .max (translateLevelBack l₁) (translateLevelBack l₂)
  | .imax l₁ l₂ => .imax (translateLevelBack l₁) (translateLevelBack l₂)

/-- Translate universe instances. -/
def translateInstance : List RLevel → MetaCoq.MCInstance :=
  List.map translateLevel

def translateInstanceBack : MetaCoq.MCInstance → List RLevel :=
  List.map translateLevelBack

/-! ## Binder translation -/

/-- Translate Lean binder info to MetaCoq binder annotation. -/
def translateBinder (n : Lean.Name) (_bi : RBinderInfo) : MetaCoq.BinderAnnot :=
  { name := nameToIdent n, relevance := .relevant }

/-- Translate MetaCoq binder annotation to Lean binder info. -/
def translateBinderBack (ba : MetaCoq.BinderAnnot) : Lean.Name × RBinderInfo :=
  (identToName ba.name, .default)

/-! ## Sort family translation -/

def levelToSortFamily : RLevel → MetaCoq.SortFamily
  | .zero => .prop
  | .succ .zero => .set
  | l => .type (translateLevel l)

def sortFamilyToLevel : MetaCoq.SortFamily → RLevel
  | .sProp => .zero
  | .prop => .zero
  | .set => .succ .zero
  | .type l => translateLevelBack l

/-! ## Core translation: RExpr → MetaCoq.Term -/

/--
Translate a reflective Lean expression to a MetaCoq kernel term.
Total (non-partial) since `RExpr` has no nested `List RExpr`.
-/
def translateExpr : RExpr → MetaCoq.Term
  | .bvar n => .tRel n
  | .fvar n => .tVar (nameToIdent n)
  | .mvar _ => .tEvar 0 []
  | .sort l => .tSort { family := levelToSortFamily l }
  | .const n ls => .tConst (nameToKername n) (translateInstance ls)
  | .app f a => .tApp (translateExpr f) [translateExpr a]
  | .lam n bi ty b =>
    .tLambda (translateBinder n bi) (translateExpr ty) (translateExpr b)
  | .forallE n bi ty b =>
    .tProd (translateBinder n bi) (translateExpr ty) (translateExpr b)
  | .letE n ty v b =>
    .tLetIn { name := nameToIdent n, relevance := .relevant }
      (translateExpr ty) (translateExpr v) (translateExpr b)
  | .lit (.natVal n) => .tInt n
  | .lit (.strVal _) => .tEvar 0 []
  | .mdata e => translateExpr e
  | .proj n i s => .tProj (nameToKername n) i (translateExpr s)

/-! ## Core translation: MetaCoq.Term → RExpr -/

/-- Reconstruct nested binary applications from an argument list. -/
def applySpine (head : RExpr) : List RExpr → RExpr
  | [] => head
  | a :: rest => applySpine (.app head a) rest

/--
Translate a MetaCoq kernel term back to a reflective Lean expression.
Total (non-partial), using Lean 4's support for nested inductive recursion.
-/
def translateExprBack : MetaCoq.Term → RExpr
  | .tRel n => .bvar n
  | .tVar id => .fvar (identToName id)
  | .tEvar _ _ => .mvar .anonymous
  | .tSort s => .sort (sortFamilyToLevel s.family)
  | .tCast t _ _ => translateExprBack t
  | .tProd ba ty b =>
    let (n, bi) := translateBinderBack ba
    .forallE n bi (translateExprBack ty) (translateExprBack b)
  | .tLambda ba ty b =>
    let (n, bi) := translateBinderBack ba
    .lam n bi (translateExprBack ty) (translateExprBack b)
  | .tLetIn ba ty v b =>
    .letE (identToName ba.name) (translateExprBack ty) (translateExprBack v) (translateExprBack b)
  | .tApp f args => applySpine (translateExprBack f) (args.map translateExprBack)
  | .tConst kn inst => .const (identToName kn.ident) (translateInstanceBack inst)
  | .tInd ind inst => .const (identToName ind.kername.ident) (translateInstanceBack inst)
  | .tConstruct ind n inst =>
    .const (.str (identToName ind.kername.ident) s!"ctor{n}") (translateInstanceBack inst)
  | .tCase _ _ _ discr _ => translateExprBack discr
  | .tProj kn i s => .proj (identToName kn.ident) i (translateExprBack s)
  | .tFix _defs _n => .mvar .anonymous  -- fixpoints simplified
  | .tCoFix _defs _n => .mvar .anonymous  -- cofixpoints simplified
  | .tInt n => .lit (.natVal n.toNat)
  | .tFloat _ => .mvar .anonymous
  | .tArray _ _ _ _ => .mvar .anonymous

/-! ## Full pipeline compositions -/

/--
Full pipeline: Lean `Expr` → MetaCoq `Term`.
Composes reification with translation.
-/
def leanToMetaCoq (e : Lean.Expr) : MetaCoq.Term :=
  translateExpr (reifyExpr e)

/--
Full pipeline: MetaCoq `Term` → Lean `Expr`.
Composes translation with quotation.
-/
def metaCoqToLean (t : MetaCoq.Term) : Lean.Expr :=
  quoteExpr (translateExprBack t)

end Translate
