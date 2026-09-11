/-!
# MetaCoq Kernel Term AST in Lean 4

This file defines a Lean 4 port of MetaCoq's internal Coq kernel term language.
These types model the kernel term language of Coq (as represented by MetaCoq),
translated from the Haskell MetaCoq data structures into Lean 4.

This is part of a cross-kernel reflection pipeline:
```
Lean4 Expr → ReflectiveTermₗ₄ → MetaCoqTermₗ₄ → Coq (MetaCoq) → Haskell → Lean4 → LOOP
```
-/

namespace MetaCoq

/-! ## Primitive types -/

/-- Coq-style byte-list string. -/
inductive MyString where
  | empty : MyString
  | cons : UInt8 → MyString → MyString
  deriving Repr, Inhabited

/-- Coq integers (Z). -/
inductive MCZ where
  | zero : MCZ
  | pos : List Bool → MCZ   -- positive, represented as bits
  | neg : List Bool → MCZ   -- negative, represented as bits
  deriving Repr, Inhabited

/-! ## Identifiers and names -/

/-- An identifier (string-based). -/
abbrev Ident := String

/-- A directory path (list of identifiers, outermost first in MetaCoq). -/
abbrev Dirpath := List Ident

/-- Module path. -/
inductive Modpath where
  | mpFile : Dirpath → Modpath
  | mpBound : Dirpath → Ident → Nat → Modpath
  | mpDot : Modpath → Ident → Modpath
  deriving Repr, BEq, Inhabited

/-- A kernel name: module path × identifier. -/
structure Kername where
  modpath : Modpath
  ident : Ident
  deriving Repr, BEq, Inhabited

/-- An inductive name (kernel name + index into mutual block). -/
structure Inductive where
  kername : Kername
  index : Nat
  deriving Repr, BEq, Inhabited

/-! ## Universe levels -/

/-- Universe level expressions, matching MetaCoq's `Level.t`. -/
inductive MCLevel where
  | prop : MCLevel           -- Prop
  | set : MCLevel            -- Set (= Type 0)
  | levelVar : Nat → MCLevel -- universe variable
  | succ : MCLevel → MCLevel   -- successor universe
  | max : MCLevel → MCLevel → MCLevel
  | imax : MCLevel → MCLevel → MCLevel
  deriving Repr, BEq, Inhabited

/-- A universe instance (list of levels). -/
abbrev MCInstance := List MCLevel

/-! ## Sorts -/

/-- Sort families, matching MetaCoq's sort representation. -/
inductive SortFamily where
  | sProp : SortFamily     -- SProp (strict propositions)
  | prop : SortFamily      -- Prop
  | set : SortFamily       -- Set
  | type : MCLevel → SortFamily  -- Type u
  deriving Repr, BEq, Inhabited

/-- Sort (universe of a type). -/
structure MCSort where
  family : SortFamily
  deriving Repr, BEq, Inhabited

/-! ## Casts and relevance -/

/-- Cast kind (matching Coq's cast kinds). -/
inductive CastKind where
  | vmCast : CastKind
  | defaultCast : CastKind
  | revertCast : CastKind
  | nativeCast : CastKind
  deriving Repr, BEq, Inhabited

/-- Relevance annotation. -/
inductive Relevance where
  | relevant : Relevance
  | irrelevant : Relevance
  deriving Repr, BEq, Inhabited

/-- Binder annotation (name + relevance). -/
structure BinderAnnot where
  name : Ident
  relevance : Relevance := .relevant
  deriving Repr, BEq, Inhabited

/-! ## The core Term AST -/

/--
The core term type (Coq's kernel term).
This is a faithful Lean 4 encoding of MetaCoq's kernel term language.

Fixpoint definitions, predicates, and branches are inlined as nested
structures within the inductive to avoid mutual recursion issues.
-/
inductive Term where
  | tRel : Nat → Term
  | tVar : Ident → Term
  | tEvar : Nat → List Term → Term
  | tSort : MCSort → Term
  | tCast : Term → CastKind → Term → Term
  | tProd : BinderAnnot → Term → Term → Term
  | tLambda : BinderAnnot → Term → Term → Term
  | tLetIn : BinderAnnot → Term → Term → Term → Term
  | tApp : Term → List Term → Term
  | tConst : Kername → MCInstance → Term
  | tInd : Inductive → MCInstance → Term
  | tConstruct : Inductive → Nat → MCInstance → Term
  | tCase : Inductive → Nat → Term → Term → List Term → Term
  | tProj : Kername → Nat → Term → Term
  | tFix : List (BinderAnnot × Term × Term × Nat) → Nat → Term
  | tCoFix : List (BinderAnnot × Term × Term × Nat) → Nat → Term
  | tInt : Int → Term
  | tFloat : Float → Term
  | tArray : MCInstance → List Term → Term → Term → Term
  deriving Repr, Inhabited

/-! ## Inductive bodies -/

/-- A constructor body. -/
structure ConstructorBody where
  name : Ident
  ty : Term
  arity : Nat
  deriving Repr, Inhabited

/-- A projection body. -/
structure ProjectionBody where
  name : Ident
  relevance : Relevance
  deriving Repr, BEq, Inhabited

/-- Finiteness flag for inductive types. -/
inductive Finiteness where
  | finite : Finiteness       -- Inductive
  | cofinite : Finiteness     -- CoInductive
  | bifinite : Finiteness     -- Record / non-recursive
  deriving Repr, BEq, Inhabited

/-- A single inductive body within a mutual block. -/
structure OneInductiveBody where
  name : Ident
  relevance : Relevance
  ty : Term
  sort : SortFamily
  ctors : List ConstructorBody
  projs : List ProjectionBody
  deriving Repr, Inhabited

/-- A mutual inductive body. -/
structure MutualInductiveBody where
  finiteness : Finiteness
  params : Nat
  bodies : List OneInductiveBody
  univParams : List Ident
  variance : Option (List (Option Bool))
  deriving Repr, Inhabited

/-! ## Global declarations and environment -/

/-- A constant body (definition or axiom). -/
structure ConstantBody where
  name : Kername
  ty : Term
  body : Option Term
  univParams : List Ident
  relevance : Relevance
  deriving Repr, Inhabited

/-- A global declaration. -/
inductive GlobalDecl where
  | constantDecl : ConstantBody → GlobalDecl
  | inductiveDecl : MutualInductiveBody → GlobalDecl
  deriving Repr, Inhabited

/-- Global declarations are a list of (name, decl) pairs. -/
abbrev GlobalDeclarations := List (Kername × GlobalDecl)

/-- Retroknowledge (primitive type registrations). -/
structure Retroknowledge where
  retBool : Option Kername
  retNat : Option Kername
  retInt : Option Kername
  deriving Repr, BEq, Inhabited

/-- The global environment. -/
structure GlobalEnv where
  univGraph : Unit
  declarations : GlobalDeclarations
  retroknowledge : Retroknowledge
  deriving Repr, Inhabited

/-! ## Utility functions -/

/-- Extract declarations from a global environment. -/
def GlobalEnv.getDeclarations (env : GlobalEnv) : GlobalDeclarations :=
  env.declarations

/-- Look up a declaration by kernel name. -/
def GlobalEnv.lookup (env : GlobalEnv) (kn : Kername) : Option GlobalDecl :=
  (env.declarations.find? (fun (k, _) => k == kn)).map Prod.snd

/-- Extract the directory path from a module path. -/
def Modpath.getFile : Modpath → Option Dirpath
  | .mpFile dp => some dp
  | .mpBound dp _ _ => some dp
  | .mpDot mp _ => mp.getFile

/-- Extract a mutual inductive body from a global declaration. -/
def GlobalDecl.getInductive? : GlobalDecl → Option MutualInductiveBody
  | .inductiveDecl mib => some mib
  | _ => none

/-- Extract a constant body from a global declaration. -/
def GlobalDecl.getConstant? : GlobalDecl → Option ConstantBody
  | .constantDecl cb => some cb
  | _ => none

/-- Get the list of one-inductive bodies from a mutual inductive. -/
def MutualInductiveBody.getOneInductives (mib : MutualInductiveBody) :
    List OneInductiveBody :=
  mib.bodies

end MetaCoq
