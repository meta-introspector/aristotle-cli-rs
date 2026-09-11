import Mathlib

/-!
# MetaCoq Data Structures in Lean 4

Translation of the Haskell MetaCoq data structures from
`Server.MetaCoq.TestMeta` / `Server.MetaCoq.TestMeta3` into Lean 4.

These types model the kernel term language of Coq (as represented by MetaCoq).
-/

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MetaCoq

/-! ## Primitive types -/

/-- Natural numbers (Coq's `nat`). We reuse Lean's `Nat`. -/
abbrev Nat' := Nat

/-- Coq's `byte` type, represented as a `UInt8`. -/
abbrev Byte := UInt8

/-- Coq's `string` type. -/
inductive MyString where
  | EmptyString : MyString
  | String : Byte → MyString → MyString
deriving Inhabited

/-- Coq's `Z` (integers). -/
inductive Z where
  | Z0 : Z
  | Zpos : Nat → Z
  | Zneg : Nat → Z
deriving Inhabited

/-! ## Generic containers -/

/-- Coq's `prod`. -/
inductive Prod (a b : Type) where
  | Pair : a → b → Prod a b
deriving Inhabited

/-- Coq's `option`. -/
inductive Option' (a : Type) where
  | None : Option' a
  | Some : a → Option' a
deriving Inhabited

/-- Coq's `list`. -/
inductive List' (a : Type) where
  | Nil : List' a
  | Cons : a → List' a → List' a
deriving Inhabited

/-! ## Basic MetaCoq identifiers and paths -/

abbrev Ident := MyString
abbrev T := MyString
abbrev Dirpath := List' Ident

/-- Module path. -/
inductive Modpath where
  | MPfile : Dirpath → Modpath
  | MPbound : Dirpath → Ident → Nat → Modpath
  | MPdot : Modpath → Ident → Modpath
deriving Inhabited

abbrev Kername := Prod Modpath Ident
abbrev OKername := Option' Kername

/-! ## Relevance and binder annotations -/

inductive Relevance where
  | Relevant : Relevance
  | Irrelevant : Relevance
deriving Inhabited

inductive Name where
  | nAnon : Name
  | nNamed : Ident → Name
deriving Inhabited

/-- Binder annotation (corresponds to `binder_annot` in MetaCoq). -/
inductive BinderAnnot where
  | MkBindAnn : Name → Relevance → BinderAnnot
deriving Inhabited

abbrev Binder_annot := BinderAnnot
abbrev Aname := Binder_annot
abbrev BinderAnnotName := BinderAnnot  -- specialised to Name

/-! ## Universe-related types -/

/-- Internal tree type for level expressions. -/
inductive T_ where
  | Leaf : T_
  | Node : Z → T_ → T_ → T_
deriving Inhabited

abbrev T3 := T_
abbrev Elt0 := T_
abbrev T0 := Z
abbrev T33 := List' T3

/-- T_3 – allowed eliminations. -/
inductive T_3 where
  | IntoSProp : T_3
  | IntoPropSProp : T_3
  | IntoSetPropSProp : T_3
  | IntoAny : T_3
deriving Inhabited

abbrev T24 := T_3

/-- Tree0 – used for universe maps. -/
inductive Tree0 where
  | Leaf0 : Tree0
  | Node0 : Z → Tree0 → Prod (Prod T3 T24) T3 → Tree0 → Tree0
deriving Inhabited

abbrev T26 := Tree0
abbrev T_4 := T26
abbrev T32 := T_4

/-- Tree – another tree variant. -/
inductive Tree where
  | LeafT : Tree
  | NodeT : Z → Tree → Tree → Tree
deriving Inhabited

abbrev T4 := Tree
abbrev T_0 := T4
abbrev T10 := T_0

abbrev T14 := Prod T3 Nat
abbrev Elt1 := T14
abbrev Elt2 := T14
abbrev T18 := List' Elt1
abbrev T_1 := T18
abbrev T21 := T_1
abbrev NonEmptyLevelExprSet := T21
abbrev T22 := NonEmptyLevelExprSet

/-- T_2 – sort family / universe level set. -/
inductive T_2 where
  | SetLevel : T_2
  | PropLevel : T_2
  | TypeLevel : NonEmptyLevelExprSet → T_2
deriving Inhabited

abbrev T23 := T_2

abbrev T25S := Prod T3 T24
abbrev T25 := Prod T25S T3
abbrev T35 := Prod T10 T32

/-- T36 – universe constraint. -/
inductive T36 where
  | MkT36 : T3 → Nat → T3 → T36
deriving Inhabited

abbrev ListT36 := List' T36
abbrev OptionListT36 := Option' ListT36

/-! ## Cast kinds -/

inductive CastKind where
  | VmCast : CastKind
  | NativeCast : CastKind
  | Cast : CastKind
deriving Inhabited

abbrev Cast_kind := CastKind

/-! ## Recursivity -/

inductive RecursivityKind where
  | Finite : RecursivityKind
  | CoFinite : RecursivityKind
  | BiFinite : RecursivityKind
deriving Inhabited

abbrev Recursivity_kind := RecursivityKind

/-! ## Universes declarations -/

inductive UniversesDecl where
  | Monomorphic : UniversesDecl
  | Polymorphic : Nat → UniversesDecl   -- number of universe params
deriving Inhabited

abbrev Universes_decl := UniversesDecl

/-! ## Terms and related structures -/

/-- Case info. -/
inductive CaseInfo where
  | Mk_case_info : Prod Modpath Ident → Nat → Relevance → CaseInfo
deriving Inhabited

abbrev Case_info := CaseInfo

/-- Predicate for case expressions. -/
inductive Predicate (term : Type) where
  | MkPredicate : List' Name → List' term → Prod Modpath Ident → term → Predicate term
deriving Inhabited

/-- Branch of a case expression. -/
inductive Branch (term : Type) where
  | MkBranch : List' Name → term → Branch term
deriving Inhabited

/-- Context declaration. -/
inductive Context_decl (term : Type) where
  | MkContextDecl : Aname → Option' term → term → Context_decl term
deriving Inhabited

/-- Fixpoint definition body. -/
inductive Def (term : Type) where
  | MkDef : Aname → term → term → Nat → Def term
deriving Inhabited

/-- The core term type (Coq's kernel term). -/
inductive Term where
  | tRel : Nat → Term
  | tVar : Ident → Term
  | tEvar : Nat → List' Term → Term
  | tSort : T23 → Term
  | tCast : Term → CastKind → Term → Term
  | tProd : Aname → Term → Term → Term
  | tLambda : Aname → Term → Term → Term
  | tLetIn : Aname → Term → Term → Term → Term
  | tApp : Term → Term → Term
  | tConst : Kername → List' T3 → Term
  | tInd : Prod Modpath Ident → List' T3 → Term
  | tConstruct : Prod Modpath Ident → Nat → List' T3 → Term
  | tCase : CaseInfo → Predicate Term → Term → List' (Branch Term) → Term
  | tProj : Prod Modpath Ident → Term → Term
  | tFix : List' (Def Term) → Nat → Term
  | tCoFix : List' (Def Term) → Nat → Term
  | tInt : Nat → Term
  | tFloat : Nat → Term
  | tArray : List' T3 → Term → Term → Term → Term
deriving Inhabited

abbrev BranchTerm := Branch Term
abbrev Context_declTerm := Context_decl Term
abbrev DefTerm := Def Term
abbrev PredicateTerm := Predicate Term
abbrev OptionTerm := Option' Term
abbrev ListTerm := List' Term
abbrev ListBranchTerm := List' BranchTerm
abbrev ListContext_declTerm := List' Context_declTerm
abbrev ListDefTerm := List' DefTerm
abbrev ListAname := List' Aname
abbrev ListT3 := List' T3
abbrev Context := List' (Context_decl Term)
abbrev Mfixpoint (term : Type) := List' (Def term)

/-! ## Inductive bodies -/

/-- Projection body. -/
inductive Projection_body where
  | MkProjectionBody : Ident → Relevance → Projection_body
deriving Inhabited

abbrev ListProjection_body := List' Projection_body

/-- Constructor body. -/
inductive Constructor_body where
  | Build_constructor_body :
      Ident → Term → Nat → Context → List' (Prod Nat Nat) → Constructor_body
deriving Inhabited

abbrev ListConstructor_body := List' Constructor_body

-- Allowed eliminations: reuse T_3 / T24

/-- One inductive body. -/
inductive One_inductive_body where
  | Build_one_inductive_body :
      Ident →                     -- type name
      Context →                   -- params context
      T23 →                       -- sort
      Term →                      -- type arity
      T24 →                       -- allowed eliminations
      ListConstructor_body →      -- constructors
      ListProjection_body →       -- projections
      Relevance →                 -- relevance
      One_inductive_body
deriving Inhabited

abbrev ListOne_inductive_body := List' One_inductive_body

/-- Mutual inductive body. -/
inductive MutualInductiveBody where
  | Build_mutual_inductive_body :
      Nat →                            -- number of params
      Nat →                            -- number of uniform params
      OptionListT36 →                  -- universe constraints
      ListOne_inductive_body →         -- bodies
      UniversesDecl →                  -- universes
      Relevance →                      -- variance / relevance
      MutualInductiveBody
deriving Inhabited

abbrev Mutual_inductive_body := MutualInductiveBody

/-! ## Global declarations and environment -/

/-- Constant body. -/
inductive Constant_body where
  | Build_constant_body : Term → Option' Term → OptionListT36 → UniversesDecl → Relevance → Constant_body
deriving Inhabited

/-- Global declaration. -/
inductive Global_decl where
  | ConstantDecl : Constant_body → Global_decl
  | InductiveDecl : MutualInductiveBody → Global_decl
deriving Inhabited

abbrev TGlobalDeclaration := Prod Kername Global_decl
abbrev Global_declarations := List' TGlobalDeclaration
abbrev ListElt1 := List' Elt1

/-- Retroknowledge (stub). -/
inductive Retroknowledge where
  | MkRetroknowledge : Retroknowledge
deriving Inhabited

/-- Global environment. -/
inductive Global_env where
  | Mk_global_env :
      Prod T10 T32 →             -- universes graph
      Global_declarations →       -- declarations
      Retroknowledge →            -- retroknowledge
      Global_env
deriving Inhabited

abbrev BigMama := Prod Global_env Term

/-! ## Utility functions (translated from Haskell) -/

/-- Concatenate a `MyString` into a Lean `String`. -/
noncomputable def concatChars : MyString → String
  | MyString.EmptyString => ""
  | MyString.String _b rest => "?" ++ concatChars rest  -- lossy: Byte→Char not modelled

/-- Extract global declarations from a `(Global_env, Term)` pair. -/
def step1 (rec_def_term : Prod Global_env Term) : Global_declarations :=
  match rec_def_term with
  | Prod.Pair (Global_env.Mk_global_env _ a _) _ => a

/-- Extract the first declaration. -/
def step2 (decls : Global_declarations) : TGlobalDeclaration :=
  match decls with
  | List'.Cons a _ => a
  | List'.Nil => default

/-- Extract the `Global_decl` from a `(Kername, Global_decl)` pair. -/
def step3 (d : TGlobalDeclaration) : Global_decl :=
  match d with
  | Prod.Pair _ b => b

/-- Extract the `Kername` from a `(Kername, Global_decl)` pair. -/
def step3a (d : TGlobalDeclaration) : Kername :=
  match d with
  | Prod.Pair a _ => a

/-- Extract the `Dirpath` from a `(MPdot(MPfile d) _, _)` pair. -/
def get_file {b : Type} (x : Prod Modpath b) : Dirpath :=
  match x with
  | Prod.Pair (Modpath.MPdot (Modpath.MPfile a) _) _ => a
  | _ => List'.Nil

/-- Extract the `MutualInductiveBody` from an `InductiveDecl`. -/
def step_inductive (s : Global_decl) : Mutual_inductive_body :=
  match s with
  | Global_decl.InductiveDecl a => a
  | _ => default

/-- Compose step functions to get the inductive body from `rec_def_term`. -/
def step4_inductive (rec_def_term : Prod Global_env Term) : Mutual_inductive_body :=
  step_inductive (step3 (step2 (step1 rec_def_term)))

/-- Extract the list of one-inductive bodies. -/
def step5_inductive4 (rec_def_term : Prod Global_env Term) : ListOne_inductive_body :=
  match step4_inductive rec_def_term with
  | MutualInductiveBody.Build_mutual_inductive_body _ _ _ a _ _ => a

/-- Extract the name of the type from the first one-inductive body. -/
noncomputable def step6_name_of_type (rec_def_term : Prod Global_env Term) : String :=
  match step5_inductive4 rec_def_term with
  | List'.Cons (One_inductive_body.Build_one_inductive_body aIdent _ _ _ _ _ _ _) _ =>
      concatChars aIdent
  | _ => ""

end MetaCoq
