/-
DaslSplit/Annotate.lean — Deep Structural Annotation Layer

The 18 functions unique to Lean4Introspector.lean — classification, metrics, shapes.
These enrich kernel dependency data with architecture-level metadata.

Dependencies: Lean + DaslSplit.Core. No Mathlib.
-/
import Lean
import DaslSplit.Core
open Lean

namespace DaslSplit

/-! ## Structural annotations on type expressions -/

/-- Type **size**: number of leaf sub-terms of the `Expr` viewed as a tree. -/
partial def exprSize : Expr → Nat
  | .bvar _      => 1
  | .fvar _      => 1
  | .mvar _      => 1
  | .sort _      => 1
  | .const _ _   => 1
  | .lit _       => 1
  | .app f a     => exprSize f + exprSize a
  | .lam _ t b _ => exprSize t + exprSize b
  | .forallE _ t b _ => exprSize t + exprSize b
  | .letE _ t v b _  => exprSize t + exprSize v + exprSize b
  | .mdata _ e   => exprSize e
  | .proj _ _ e  => exprSize e

/-- Tree **depth**: longest root-to-leaf chain. -/
partial def exprDepth : Expr → Nat
  | .bvar _      => 0
  | .fvar _      => 0
  | .mvar _      => 0
  | .sort _      => 0
  | .const _ _   => 0
  | .lit _       => 0
  | .app f a     => 1 + Nat.max (exprDepth f) (exprDepth a)
  | .lam _ t b _ => 1 + Nat.max (exprDepth t) (exprDepth b)
  | .forallE _ t b _ => 1 + Nat.max (exprDepth t) (exprDepth b)
  | .letE _ t v b _  => 1 + Nat.max (exprDepth v) (Nat.max (exprDepth t) (exprDepth b))
  | .mdata _ e   => exprDepth e
  | .proj _ _ e  => 1 + exprDepth e

/-- **Arity**: the length of the leading ∀/→ telescope of a type. -/
partial def piArity : Expr → Nat
  | .forallE _ _ b _ => 1 + piArity b
  | .mdata _ e       => piArity e
  | _                => 0

/-- **Flow length**: the number of top-level *non-dependent* arrows. -/
partial def flowLength : Expr → Nat
  | .forallE _ _ b _ =>
    if b.hasLooseBVars then 0 else 1 + flowLength b
  | .mdata _ e => flowLength e
  | _          => 0

/-- The pre-order list of subtree leaf-sizes (the **size word**), in O(#nodes). -/
partial def sizeWordAux : Expr → Array Nat → Nat × Array Nat
  | .bvar _,    b => (1, b.push 1)
  | .fvar _,    b => (1, b.push 1)
  | .mvar _,    b => (1, b.push 1)
  | .sort _,    b => (1, b.push 1)
  | .const _ _, b => (1, b.push 1)
  | .lit _,     b => (1, b.push 1)
  | .mdata _ e, b => sizeWordAux e b
  | .proj _ _ e, b =>
    let idx := b.size
    let b := b.push 0
    let (s, b) := sizeWordAux e b
    (s, b.set! idx s)
  | .app f a, b =>
    let idx := b.size; let b := b.push 0
    let (sf, b) := sizeWordAux f b
    let (sa, b) := sizeWordAux a b
    (sf + sa, b.set! idx (sf + sa))
  | .lam _ t bd _, b =>
    let idx := b.size; let b := b.push 0
    let (st, b) := sizeWordAux t b
    let (sb, b) := sizeWordAux bd b
    (st + sb, b.set! idx (st + sb))
  | .forallE _ t bd _, b =>
    let idx := b.size; let b := b.push 0
    let (st, b) := sizeWordAux t b
    let (sb, b) := sizeWordAux bd b
    (st + sb, b.set! idx (st + sb))
  | .letE _ t v bd _, b =>
    let idx := b.size; let b := b.push 0
    let (st, b) := sizeWordAux t b
    let (sv, b) := sizeWordAux v b
    let (sb, b) := sizeWordAux bd b
    (st + sv + sb, b.set! idx (st + sv + sb))

/-- The size word of an expression. -/
def exprSizeWord (e : Expr) : Array Nat := (sizeWordAux e #[]).2

/-- The **Clifford blade** of a size word: the sorted set of sizes occurring an odd number of
times (the surviving top-grade blade). -/
def cliffordBlade (w : Array Nat) : Array Nat := Id.run do
  let mut parity : Std.HashMap Nat Bool := {}
  for x in w do
    parity := parity.insert x (!(parity.getD x false))
  let mut odd : Array Nat := #[]
  for (k, v) in parity.toList do
    if v then odd := odd.push k
  return odd.qsort (fun a b => a < b)

/-! ## Tagging -/

/-- The module in which a declaration is defined, if known. -/
def declModule (env : Environment) (n : Name) : Option Name :=
  match env.getModuleIdxFor? n with
  | some idx => env.header.moduleNames[idx.toNat]?
  | none => none

/-- The `kind` tag of a declaration. -/
def kindTag (env : Environment) (n : Name) : String :=
  match env.find? n with
  | some (.defnInfo _)   => "def"
  | some (.thmInfo _)    => "theorem"
  | some (.axiomInfo _)  => "axiom"
  | some (.opaqueInfo _) => "opaque"
  | some (.inductInfo _) => "inductive"
  | some (.ctorInfo _)   => "ctor"
  | some (.recInfo _)    => "recursor"
  | some (.quotInfo _)   => "quot"
  | none                 => "unknown"

/-- Fold a defining module into a coarse pipeline-style `stage` tag. -/
def stageOf (mod : Option Name) : String :=
  match mod with
  | none => "core"
  | some m =>
    let s := m.toString
    if s == "Lean.Elab.Frontend" || s.startsWith "Lean.Elab.Frontend." || s.startsWith "Lean.Frontend" then
      "frontend"
    else if s == "Lean.Parser" || s.startsWith "Lean.Parser." then
      "parse"
    else if s == "Lean.Elab" || s.startsWith "Lean.Elab." then
      "elab"
    else if s == "Lean" || s.startsWith "Lean." then
      "core"
    else
      "other"

/-- The top-level namespace component of a name. -/
def topNamespace (n : Name) : String :=
  (n.toString.splitOn ".").head?.getD "<root>"

/-! ## Serialisation helpers -/

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Render an array of naturals as a JSON array `[a, b, c]`. -/
def renderNatArr (w : Array Nat) : String :=
  "[" ++ String.intercalate ", " (w.toList.map toString) ++ "]"

end DaslSplit
