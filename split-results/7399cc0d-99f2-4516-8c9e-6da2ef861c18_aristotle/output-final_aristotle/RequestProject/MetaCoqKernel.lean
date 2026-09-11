/-
# MetaCoqKernel.lean — MetaCoq-Style Kernel Types in Lean 4

Translation of the BigMama Haskell data types to Lean 4.
Defines raw terms, global environments, declarations, and
the `BigMama` pair `(env, term)`.

## Key Types
- `Term` — the main term type (Rel, Var, App, Lambda, Pi, etc.)
- `GlobalEnv` — global environment with declarations
- `BigMama` — the product of environment and term
-/

import Mathlib

set_option maxHeartbeats 400000

namespace MetaCoqKernel

/-! ## §1. Basic Types -/

/-- Universe levels. -/
inductive Level where
  | lzero
  | lsucc (l : Level)
  | lmax (l r : Level)
  | lvar (n : ℕ)
  deriving Repr, DecidableEq

/-- Relevance annotation. -/
inductive Relevance where
  | relevant
  | irrelevant
  deriving Repr, DecidableEq

/-- Name (anonymous or named). -/
inductive MCName where
  | anon
  | named (id : String)
  deriving Repr, DecidableEq

/-- Annotated binder name. -/
structure Annot where
  name : MCName
  relevance : Relevance
  deriving Repr, DecidableEq

/-! ## §2. Universe & Sort Types -/

inductive UniversesDecl where
  | monomorphic
  | polymorphic (params : List String)
  deriving Repr, DecidableEq

inductive SortFamily where
  | prop
  | sprop
  | typeSort (levels : List Level)
  deriving Repr, DecidableEq

/-! ## §3. Names and Module Paths -/

/-- Module path. -/
inductive Modpath where
  | mpfile (dir : List String)
  | mpbound (dir : List String) (mod : String) (n : ℕ)
  | mpdot (mp : Modpath) (mod : String)
  deriving Repr, DecidableEq

/-- Kernel name = module path × identifier. -/
abbrev Kername := Modpath × String

/-! ## §4. Cast Kind -/

inductive CastKind where
  | vmCast
  | nativeCast
  | defaultCast
  deriving Repr, DecidableEq

/-! ## §5. Inductive References -/

structure InductiveRef where
  kn : Kername
  idx : ℕ
  deriving Repr, DecidableEq

structure CaseInfo where
  ind : InductiveRef
  npars : ℕ
  relevance : Relevance
  deriving Repr, DecidableEq

inductive RecursivityKind where
  | finite
  | cofinite
  | bifinite
  deriving Repr, DecidableEq

/-! ## §6. The Main Term Type -/

structure Projection where
  ind : InductiveRef
  npars : ℕ
  argIdx : ℕ
  deriving Repr, DecidableEq

/-- The main term type — mirrors MetaCoq/Coq kernel terms. -/
inductive Term where
  | tRel (n : ℕ)
  | tVar (id : String)
  | tEvar (n : ℕ) (args : List Term)
  | tSort (s : SortFamily)
  | tCast (t : Term) (kind : CastKind) (ty : Term)
  | tProd (name : Annot) (dom : Term) (cod : Term)
  | tLambda (name : Annot) (dom : Term) (body : Term)
  | tLetIn (name : Annot) (val : Term) (ty : Term) (body : Term)
  | tApp (fn : Term) (args : List Term)
  | tConst (kn : Kername) (univs : List Level)
  | tInd (ind : InductiveRef) (univs : List Level)
  | tConstruct (ind : InductiveRef) (cidx : ℕ) (univs : List Level)
  | tProj (proj : Projection) (t : Term)
  | tFix (names : List Annot) (idx : ℕ)
  | tCoFix (names : List Annot) (idx : ℕ)
  | tInt (n : Int)

/-! ## §7. Context -/

structure ContextDecl where
  name : Annot
  body : Option Term
  type : Term

abbrev Context := List ContextDecl

/-! ## §8. Global Declarations -/

inductive AllowedEliminations where
  | intoSProp
  | intoPropSProp
  | intoSetPropSProp
  | intoAny
  deriving Repr, DecidableEq

inductive Variance where
  | irrelevant
  | covariant
  | invariant
  deriving Repr, DecidableEq

structure ConstantBody where
  type : Term
  body : Option Term
  universes : UniversesDecl
  relevance : Relevance

inductive GlobalDecl where
  | constantDecl (body : ConstantBody)
  | inductiveDecl (npars : ℕ) (kind : RecursivityKind)

/-! ## §9. Global Environment -/

abbrev GlobalDeclarations := List (Kername × GlobalDecl)

structure Retroknowledge where
  intType : Option Kername
  boolType : Option Kername
  deriving Repr, DecidableEq

structure GlobalEnv where
  declarations : GlobalDeclarations
  retroknowledge : Retroknowledge

/-! ## §10. BigMama — The Product of Environment and Term -/

/-- BigMama = the pair of a global environment and a term to check/reduce. -/
structure BigMama where
  env : GlobalEnv
  term : Term

def BigMama.create (env : GlobalEnv) (t : Term) : BigMama := ⟨env, t⟩

/-! ## §11. Basic Operations on Terms -/

def Term.size : Term → ℕ
  | .tRel _ => 1
  | .tVar _ => 1
  | .tEvar _ args => 1 + args.length
  | .tSort _ => 1
  | .tCast t _ ty => 1 + t.size + ty.size
  | .tProd _ dom cod => 1 + dom.size + cod.size
  | .tLambda _ dom body => 1 + dom.size + body.size
  | .tLetIn _ val ty body => 1 + val.size + ty.size + body.size
  | .tApp fn args => 1 + fn.size + args.length
  | .tConst _ _ => 1
  | .tInd _ _ => 1
  | .tConstruct _ _ _ => 1
  | .tProj _ t => 1 + t.size
  | .tFix defs _ => 1 + defs.length
  | .tCoFix defs _ => 1 + defs.length
  | .tInt _ => 1

def Term.isSort : Term → Bool
  | .tSort _ => true
  | _ => false

def Term.isLambda : Term → Bool
  | .tLambda _ _ _ => true
  | _ => false

def Term.isApp : Term → Bool
  | .tApp _ _ => true
  | _ => false

def Term.head : Term → Term
  | .tApp fn _ => fn.head
  | t => t

/-! ## §12. Example Terms -/

def propSort : Term := .tSort .prop

def typeSort : Term := .tSort (.typeSort [.lzero])

def identityTerm : Term :=
  .tLambda ⟨.named "A", .relevant⟩ typeSort
    (.tLambda ⟨.named "x", .relevant⟩ (.tRel 0)
      (.tRel 0))

theorem identity_is_lambda : identityTerm.isLambda = true := rfl

theorem identity_size : identityTerm.size = 5 := rfl

/-! ## §13. Content Addressing -/

def BigMama.termHash (bm : BigMama) : ℕ := bm.term.size

theorem BigMama.hash_deterministic (bm1 bm2 : BigMama)
    (h : bm1.term = bm2.term) :
    bm1.termHash = bm2.termHash := by
  simp [termHash, h]

end MetaCoqKernel
