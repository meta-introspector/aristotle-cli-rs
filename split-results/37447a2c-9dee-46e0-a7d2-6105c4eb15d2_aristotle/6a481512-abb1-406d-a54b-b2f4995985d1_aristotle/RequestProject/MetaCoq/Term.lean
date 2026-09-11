/-
  MetaCoq Kernel Term Language - Term and related types

  The main `Term` inductive and supporting structures for the
  MetaCoq kernel, including global environments and declarations.
-/
import RequestProject.MetaCoq.Basic

set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MetaCoq

/-! ## Cast and recursivity kinds -/

/-- Cast kinds in the Coq kernel. `Cast_kind = CastKind`. -/
inductive CastKind where
  | VmCast : CastKind
  | NativeCast : CastKind
  | DEFAULTcast : CastKind
  deriving Inhabited, DecidableEq, Repr

/-- `Cast_kind = CastKind`. -/
abbrev Cast_kind := CastKind

/-- Recursivity kind: finite (inductive) or co-finite (coinductive).
    `Recursivity_kind = RecursivityKind`. -/
inductive RecursivityKind where
  | finite : RecursivityKind
  | coFinite : RecursivityKind
  deriving Inhabited, DecidableEq, Repr

/-- `Recursivity_kind = RecursivityKind`. -/
abbrev Recursivity_kind := RecursivityKind

/-! ## Inductive references -/

/-- Reference to an inductive type: kernel name + index in mutual block. -/
structure Inductive where
  ind_mind : Kername
  ind_ind : Nat
  deriving Repr

/-- Reference to a projection. -/
structure Projection where
  proj_ind : Inductive
  proj_npars : Nat
  proj_arg : Nat
  deriving Repr

/-! ## Universe declarations -/

/-- Universe declarations. `Universes_decl = UniversesDecl`. -/
inductive UniversesDecl where
  | monomorphic : UniversesDecl
  | polymorphic : T35 → UniversesDecl
  deriving Repr

/-- `Universes_decl = UniversesDecl`. -/
abbrev Universes_decl := UniversesDecl

/-- Universe instance: a list of levels. -/
abbrev Instance_t := ListT3

/-! ## The Term type and mutually-dependent structures -/

/-- Case analysis info. `Case_info = CaseInfo`. -/
structure CaseInfo where
  ci_ind : Inductive
  ci_npar : Nat
  ci_relevance : Relevance
  deriving Repr

/-- `Case_info = CaseInfo`. -/
abbrev Case_info := CaseInfo

/-- Context declaration, parameterized by the term type.
    Represents a hypothesis in a local context.
    `Context_declTerm = Context_decl Term`. -/
structure Context_decl (α : Type) where
  decl_name : Aname
  decl_body : Option α
  decl_type : α
  deriving Repr

/-- Predicate in a `case` expression. `PredicateTerm = Predicate Term`. -/
structure Predicate (α : Type) where
  puinst : Instance_t
  pparams : List α
  pcontext : List Aname
  preturn : α
  deriving Repr

/-- Branch of a `case` expression. `BranchTerm = Branch Term`. -/
structure Branch (α : Type) where
  bcontext : List Aname
  bbody : α
  deriving Repr

/-- Recursive/corecursive definition body. `DefTerm = Def Term`. -/
structure Def (α : Type) where
  dname : Aname
  dtype : α
  dbody : α
  rarg : Nat
  deriving Repr

/-- `T36`: Retroknowledge entry type. Used in `ListT36` and `OptionListT36`. -/
inductive T36 where
  | retro_nat : T36
  | retro_bool : T36
  | retro_carry : T36
  | retro_pair : T36
  | retro_cmp : T36
  | retro_f_cmp : T36
  | retro_f_class : T36
  deriving Inhabited, DecidableEq, Repr

/-- `ListT36 = List T36`. -/
abbrev ListT36 := List T36

/-- `OptionListT36 = Option ListT36`. -/
abbrev OptionListT36 := Option ListT36

/-- The main term type of the MetaCoq kernel.
    Corresponds to `Ast.term` / `PCUICAst.term`. -/
inductive Term where
  | tRel : Nat → Term
  | tVar : Ident → Term
  | tEvar : Nat → List Term → Term
  | tSort : T22 → Term
  | tCast : Term → CastKind → Term → Term
  | tProd : Aname → Term → Term → Term
  | tLambda : Aname → Term → Term → Term
  | tLetIn : Aname → Term → Term → Term → Term
  | tApp : Term → Term → Term
  | tConst : Kername → Instance_t → Term
  | tInd : Inductive → Instance_t → Term
  | tConstruct : Inductive → Nat → Instance_t → Term
  | tCase : CaseInfo → Predicate Term → Term → List (Branch Term) → Term
  | tProj : Projection → Term → Term
  | tFix : List (Def Term) → Nat → Term
  | tCoFix : List (Def Term) → Nat → Term
  | tInt : Nat → Term
  | tFloat : Nat → Term
  | tArray : Level_t → List Term → Term → Term → Term
  deriving Inhabited, Repr

/-- `T` from extraction = `MyString`. -/
abbrev T := MyString

/-- `T0` from extraction = `Z` (Coq's integers). -/
abbrev T0 := Z

/-! ## Type aliases for Term-parameterized types -/

/-- `Context_declTerm = Context_decl Term`. -/
abbrev Context_declTerm := Context_decl Term

/-- `Context = List (Context_decl Term)`. The local context. -/
abbrev Context := List (Context_decl Term)

/-- `DefTerm = Def Term`. -/
abbrev DefTerm := Def Term

/-- `BranchTerm = Branch Term`. -/
abbrev BranchTerm := Branch Term

/-- `PredicateTerm = Predicate Term`. -/
abbrev PredicateTerm := Predicate Term

/-- `OptionTerm = Option Term`. -/
abbrev OptionTerm := Option Term

/-- `ListTerm = List Term`. -/
abbrev ListTerm := List Term

/-- `ListDefTerm = List (Def Term)`. -/
abbrev ListDefTerm := List DefTerm

/-- `Mfixpoint α = List (Def α)`. The type of mutual (co)fixpoint bodies.
    Commented out in the original Haskell extraction due to type variable handling,
    but included here for completeness. -/
def Mfixpoint (α : Type) := List (Def α)

/-- `ListBranchTerm = List (Branch Term)`. -/
abbrev ListBranchTerm := List BranchTerm

/-- `ListContext_declTerm = List (Context_decl Term)`. -/
abbrev ListContext_declTerm := List Context_declTerm

/-! ## Inductive body types -/

/-- Body of a single constructor in an inductive type. -/
structure Constructor_body where
  cstr_name : Ident
  cstr_args : Context
  cstr_indices : List Term
  cstr_type : Term
  cstr_arity : Nat
  deriving Repr

/-- `ListConstructor_body = List Constructor_body`. -/
abbrev ListConstructor_body := List Constructor_body

/-- Body of a projection from a record/structure. -/
structure Projection_body where
  proj_name : Ident
  proj_relevance : Relevance
  proj_type : Term
  deriving Repr

/-- `ListProjection_body = List Projection_body`. -/
abbrev ListProjection_body := List Projection_body

/-- Body of a single inductive type within a mutual block. -/
structure One_inductive_body where
  ind_name : Ident
  ind_indices : Context
  ind_sort : T22
  ind_type : Term
  ind_kelim : List (Bool × Bool)   -- allowed elimination sorts
  ind_ctors : List Constructor_body
  ind_projs : List Projection_body
  ind_relevance : Relevance
  deriving Repr

/-- `ListOne_inductive_body = List One_inductive_body`. -/
abbrev ListOne_inductive_body := List One_inductive_body

/-- Body of a mutual inductive definition.
    `Mutual_inductive_body = MutualInductiveBody`. -/
structure MutualInductiveBody where
  ind_finite : RecursivityKind
  ind_npars : Nat
  ind_params : Context
  ind_bodies : List One_inductive_body
  ind_universes : UniversesDecl
  ind_variance : Option (List T36)
  deriving Repr

/-- `Mutual_inductive_body = MutualInductiveBody`. -/
abbrev Mutual_inductive_body := MutualInductiveBody

/-! ## Global declarations and environment -/

/-- A constant (definition or axiom) body. -/
structure Constant_body where
  cst_type : Term
  cst_body : Option Term
  cst_universes : UniversesDecl
  cst_relevance : Relevance
  deriving Repr

/-- A global declaration is either a constant or an inductive. -/
inductive Global_decl where
  | ConstantDecl : Constant_body → Global_decl
  | InductiveDecl : MutualInductiveBody → Global_decl
  deriving Repr

/-- `TGlobalDeclaration = Prod Kername Global_decl`.
    A named global declaration. -/
abbrev TGlobalDeclaration := Kername × Global_decl

/-- `Global_declarations = List TGlobalDeclaration`.
    The list of all global declarations. -/
abbrev Global_declarations := List TGlobalDeclaration

/-- The global environment. -/
structure Global_env where
  universes : T35      -- (level set, constraint set)
  declarations : Global_declarations
  retroknowledge : List T36
  deriving Repr

/-- `BigMama = Prod Global_env Term`.
    A global environment paired with a term (typically the main term to check). -/
abbrev BigMama := Global_env × Term

/-! ## The `getStringFromName` analogue -/

/-- Analogue of the Haskell `getStringFromName` function.
    Given a `Name`, returns a string representation.
    In the original Haskell code, this attempted to use TH reification
    to get type info; here we simply extract the name string. -/
def getStringFromName : Name → String
  | Name.nAnon => "nAnon"
  | Name.nNamed id => id

end MetaCoq
