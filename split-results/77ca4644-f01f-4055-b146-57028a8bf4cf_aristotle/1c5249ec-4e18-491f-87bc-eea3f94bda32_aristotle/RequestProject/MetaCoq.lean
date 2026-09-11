/-
  Translation of Coq's MetaCoq kernel term representation from Haskell to Lean 4.

  This file defines the core data types used to represent Coq's internal term
  language, including terms, inductive types, global environments, and related
  structures.
-/

namespace MetaCoq

/-! ## Primitive types -/

/-- Coq's byte type (placeholder). -/
inductive Byte where
  deriving Repr, BEq

/-- Coq's cast kinds. -/
inductive CastKind where
  | VmCast
  | NativeCast
  | Cast
  deriving Repr, BEq, Inhabited

/-- Comparison result. -/
inductive Comparison where
  | Eq
  | Lt
  | Gt
  deriving Repr, BEq, Inhabited

/-! ## Numeric types (Coq-style) -/

/-- Coq's positive binary numbers. -/
inductive Positive where
  | XI : Positive → Positive
  | XO : Positive → Positive
  | XH : Positive
  deriving Repr, BEq, Inhabited

/-- Coq's N (natural numbers as binary). -/
inductive CoqN where
  | N0 : CoqN
  | Npos : Positive → CoqN
  deriving Repr, BEq, Inhabited

/-- Coq's Z (integers as binary). -/
inductive CoqZ where
  | Z0 : CoqZ
  | Zpos : Positive → CoqZ
  | Zneg : Positive → CoqZ
  deriving Repr, BEq, Inhabited

/-! ## String type -/

/-- Coq-style strings (byte lists). -/
inductive MyString where
  | EmptyString : MyString
  | String : Byte → MyString → MyString
  deriving Repr, BEq, Inhabited

/-- Identifier type. -/
abbrev Ident := MyString

/-! ## Names and relevance -/

/-- Relevance annotation for binders. -/
inductive Relevance where
  | Relevant
  | Irrelevant
  deriving Repr, BEq, Inhabited

/-- Coq's name type. -/
inductive Name where
  | NAnon : Name
  | NNamed : Ident → Name
  deriving Repr, BEq, Inhabited

/-- Binder annotation: a name with relevance information. -/
structure BinderAnnot (α : Type) where
  name : α
  relevance : Relevance
  deriving Repr, BEq, Inhabited

/-- Binder annotation specialized to Name. -/
abbrev BinderAnnotName := BinderAnnot Name

/-! ## Paths and kernel names -/

/-- Directory path (list of identifiers). -/
abbrev Dirpath := List Ident

/-- Module path. -/
inductive Modpath where
  | MPfile : Dirpath → Modpath
  | MPbound : Dirpath → Ident → Nat → Modpath
  | MPdot : Modpath → Ident → Modpath
  deriving Repr, BEq, Inhabited

/-- Kernel name: module path paired with an identifier. -/
abbrev Kername := Modpath × Ident

/-! ## Universe levels -/

/-- Universe levels in Coq. -/
inductive UniversalLevel where
  | Lzero : UniversalLevel
  | Level : MyString → UniversalLevel
  | Lvar : Nat → UniversalLevel
  deriving Repr, BEq, Inhabited

/-- Universe level expression: a level paired with an offset. -/
abbrev UniversalLevelExpr := UniversalLevel × Nat

/-- Non-empty set of level expressions (represented as a list). -/
abbrev NonEmptyLevelExprSet := List UniversalLevelExpr

/-- Level properties / sort kinds. -/
inductive LevelProps where
  | LProp : LevelProps
  | LSProp : LevelProps
  | LType : NonEmptyLevelExprSet → LevelProps
  deriving Repr, BEq, Inhabited

/-- Universe levels (list of levels). -/
abbrev UniversalLevels := List UniversalLevel

/-- Numeric relation for level constraints. -/
inductive NumRel where
  | Le : CoqZ → NumRel
  | Eq0 : NumRel
  deriving Repr, BEq, Inhabited

/-! ## Level constraint trees -/

/-- Tree for universe level constraints. -/
inductive LevelTree where
  | Leaf : LevelTree
  | Node : Nat → LevelTree → UniversalLevel → LevelTree
  deriving Repr, BEq

/-- Tree for level constraints with relation annotations. -/
inductive LevelTree0 where
  | Leaf0 : LevelTree0
  | Node0 : Nat → LevelTree0 → (UniversalLevel × NumRel) × UniversalLevel → LevelTree0
  deriving Repr, BEq

/-! ## Universe declarations -/

/-- Variance annotations for universe polymorphism. -/
inductive Variance where
  | Irrelevant : Variance
  | Covariant : Variance
  | Invariant : Variance
  deriving Repr, BEq, Inhabited

/-- Universe declarations. -/
inductive UniversesDecl where
  | Monomorphic_ctx : UniversesDecl
  deriving Repr, BEq, Inhabited

/-! ## Retroknowledge -/

abbrev OKername := Option Kername

/-- Retroknowledge structure. -/
structure Retroknowledge where
  mk ::
  field1 : OKername
  field2 : OKername
  deriving Repr, BEq, Inhabited

/-! ## Core term language -/

/-- Inductive type reference: kernel name + index within mutual block. -/
structure Inductive where
  mk ::
  mind : Kername
  ind : Nat
  deriving Repr, BEq, Inhabited

/-- Projection reference. -/
structure Projection where
  mk ::
  proj_ind : Inductive
  proj_npars : Nat
  proj_arg : Nat
  deriving Repr, BEq, Inhabited

/-- Case analysis info. -/
structure CaseInfo where
  mk ::
  ci_ind : Inductive
  ci_npar : Nat
  ci_relevance : Relevance
  deriving Repr, BEq, Inhabited

/-- Context declaration: a binder with optional body and type. -/
structure ContextDecl (term : Type) where
  mk ::
  decl_name : BinderAnnotName
  decl_body : Option term
  decl_type : term
  deriving Repr, BEq

/-- (Co)fixpoint definition. -/
structure Def (term : Type) where
  mk ::
  dname : BinderAnnotName
  dtype : term
  dbody : term
  rarg : Nat
  deriving Repr, BEq

/-- Predicate for case analysis. -/
structure Predicate (term : Type) where
  mk ::
  puinst : UniversalLevels
  pparams : List term
  pcontext : List BinderAnnotName
  preturn : term
  deriving Repr, BEq

/-- Branch of a case analysis. -/
structure Branch (term : Type) where
  mk ::
  bcontext : List BinderAnnotName
  bbody : term
  deriving Repr, BEq

/-- Coq's core term type (CIC terms). -/
inductive Term where
  | TRel : Nat → Term
  | TVar : Ident → Term
  | TEvar : Nat → List Term → Term
  | TSort : LevelProps → Term
  | TCast : Term → CastKind → Term → Term
  | TProd : BinderAnnotName → Term → Term → Term
  | TLambda : BinderAnnotName → Term → Term → Term
  | TLetIn : BinderAnnotName → Term → Term → Term → Term
  | TApp : Term → List Term → Term
  | TConst : Kername → UniversalLevels → Term
  | TInd : Inductive → UniversalLevels → Term
  | TConstruct : Inductive → Nat → UniversalLevels → Term
  | TCase : CaseInfo → Predicate Term → Term → List (Branch Term) → Term
  | TProj : Projection → Term → Term
  | TFix : List (Def Term) → Nat → Term
  | TCoFix : List (Def Term) → Nat → Term
  | TInt : Int → Term
  | TFloat : Float → Term
  deriving Repr, Inhabited

/-- Context: list of context declarations over Term. -/
abbrev Context := List (ContextDecl Term)

/-! ## Inductive type bodies -/

/-- Allowed elimination sorts. -/
inductive AllowedEliminations where
  | IntoSProp : AllowedEliminations
  | IntoPropSProp : AllowedEliminations
  | IntoSetPropSProp : AllowedEliminations
  | IntoAny : AllowedEliminations
  deriving Repr, BEq, Inhabited

/-- Projection body within an inductive type. -/
structure ProjectionBody where
  mk ::
  proj_name : Ident
  proj_relevance : Relevance
  proj_type : Term
  deriving Repr

/-- Constructor body within an inductive type. -/
structure ConstructorBody where
  mk ::
  cstr_name : Ident
  cstr_args : Context
  cstr_indices : List Term
  cstr_type : Term
  cstr_arity : Nat
  deriving Repr

/-- Recursivity kind for inductive types. -/
inductive RecursivityKind where
  | Finite : RecursivityKind
  | CoFinite : RecursivityKind
  | BiFinite : RecursivityKind
  deriving Repr, BEq, Inhabited

/-- Body of a single inductive type definition. -/
structure OneInductiveBody where
  mk ::
  ind_name : Ident
  ind_indices : Context
  ind_sort : LevelProps
  ind_type : Term
  ind_kelim : AllowedEliminations
  ind_ctors : List ConstructorBody
  ind_projs : List ProjectionBody
  ind_relevance : Relevance
  deriving Repr

/-- Body of a mutual inductive type definition. -/
structure MutualInductiveBody where
  mk ::
  ind_finite : RecursivityKind
  ind_npars : Nat
  ind_params : Context
  ind_bodies : List OneInductiveBody
  ind_universes : UniversesDecl
  ind_variance : Option (List Variance)
  deriving Repr

/-! ## Global environment -/

/-- Constant body (axiom or definition). -/
structure ConstantBody where
  mk ::
  cst_type : Term
  cst_body : Option Term
  cst_universes : UniversesDecl
  cst_relevance : Relevance
  deriving Repr

/-- Global declaration: either a constant or an inductive. -/
inductive GlobalDecl where
  | ConstantDecl : ConstantBody → GlobalDecl
  | InductiveDecl : MutualInductiveBody → GlobalDecl
  deriving Repr

/-- Global declarations: a list of kernel-name/declaration pairs. -/
abbrev GlobalDeclarations := List (Kername × GlobalDecl)

/-- Square product tree (used in global environment). -/
abbrev SquareProdTree := LevelTree × LevelTree

/-- Global environment. -/
structure GlobalEnv where
  mk ::
  universes : SquareProdTree
  declarations : GlobalDeclarations
  retroknowledge : Retroknowledge
  deriving Repr

/-- The "big mama" type: a global environment paired with a term. -/
abbrev BigMama := GlobalEnv × Term

end MetaCoq
