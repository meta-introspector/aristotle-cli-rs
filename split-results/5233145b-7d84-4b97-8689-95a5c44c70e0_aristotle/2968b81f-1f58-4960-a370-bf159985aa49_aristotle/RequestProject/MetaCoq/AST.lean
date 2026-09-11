import RequestProject.MetaCoq.Basic
import RequestProject.MetaCoq.Arith

/-!
# MetaCoq AST Types

The core MetaCoq term language and global environment types,
translated from `Server.MetaCoq.TestMeta`.
-/

namespace MetaCoq

/-! ## Universe levels -/

inductive T_ where
  | Lzero : T_
  | Level : MyString → T_
  | Lvar : Nat → T_
  deriving Repr, BEq, Inhabited

abbrev T3 := T_

/-! ## Level expression constraint -/

inductive T_3 where
  | Le : Z → T_3
  | Eq0 : T_3
  deriving Repr, BEq, Inhabited

abbrev T24 := T_3

def T_3.lt : T_3 := .Le (.Zpos .XH)
def T_3.le0 : T_3 := .Le .Z0

/-! ## Sort families -/

inductive T13 where
  | LSProp : T13
  | LProp : T13
  deriving Repr, BEq, Inhabited

/-! ## Level expression pairs and sets -/

abbrev T14 := Prod T3 Nat
abbrev Elt1 := T14
abbrev Elt2 := T14
abbrev T18 := List Elt1
abbrev T_1 := T18
abbrev T21 := T_1
abbrev NonEmptyLevelExprSet := T21
abbrev T22 := NonEmptyLevelExprSet

/-! ## Sort -/

inductive T_2 where
  | LProp0 : T_2
  | LSProp0 : T_2
  | LType : T22 → T_2
  deriving Repr, BEq, Inhabited

abbrev T23 := T_2
abbrev Elt0 := T_

/-! ## Names and identifiers -/

abbrev Ident := MyString
abbrev Dirpath := List Ident

inductive Modpath where
  | MPfile : Dirpath → Modpath
  | MPbound : Dirpath → Ident → Nat → Modpath
  | MPdot : Modpath → Ident → Modpath
  deriving Repr, BEq, Inhabited

abbrev Kername := Prod Modpath Ident
abbrev OKername := Option Kername
abbrev T33 := List T3

inductive Name where
  | NAnon : Name
  | NNamed : Ident → Name
  deriving Repr, BEq, Inhabited

inductive Relevance where
  | Relevant : Relevance
  | Irrelevant : Relevance
  deriving Repr, BEq, Inhabited

inductive BinderAnnot (a : Type _) where
  | MkBindAnn : a → Relevance → BinderAnnot a
  deriving Repr, BEq, Inhabited

abbrev Binder_annot := BinderAnnot
abbrev Aname := Binder_annot Name

/-! ## Cast kinds -/

inductive CastKind where
  | VmCast | NativeCast | Cast
  deriving Repr, BEq, Inhabited

abbrev Cast_kind := CastKind

/-! ## Inductives and case info -/

inductive Inductive where
  | MkInd : Kername → Nat → Inductive
  deriving Repr, BEq, Inhabited

inductive CaseInfo where
  | Mk_case_info : Inductive → Nat → Relevance → CaseInfo
  deriving Repr, BEq, Inhabited

abbrev Case_info := CaseInfo

/-! ## Recursivity -/

inductive RecursivityKind where
  | Finite | CoFinite | BiFinite
  deriving Repr, BEq, Inhabited

abbrev Recursivity_kind := RecursivityKind

/-! ## Projections -/

inductive Projection where
  | MkProjection : Inductive → Nat → Nat → Projection
  deriving Repr, BEq, Inhabited

/-! ## Term

Term and its auxiliary types are defined in a single mutual inductive
block so that the Lean 4 kernel can handle the nested occurrences.
-/

mutual
inductive Term where
  | TRel : Nat → Term
  | TVar : Ident → Term
  | TEvar : Nat → TermList → Term
  | TSort : T23 → Term
  | TCast : Term → Cast_kind → Term → Term
  | TProd : Aname → Term → Term → Term
  | TLambda : Aname → Term → Term → Term
  | TLetIn : Aname → Term → Term → Term → Term
  | TApp : Term → TermList → Term
  | TConst : Kername → T33 → Term
  | TInd : Inductive → T33 → Term
  | TConstruct : Inductive → Nat → T33 → Term
  | TCase : Case_info → Predicate → Term → BranchList → Term
  | TProj : Projection → Term → Term
  | TFix : DefList → Nat → Term
  | TCoFix : DefList → Nat → Term
  | TInt : _root_.Int → Term
  | TFloat : Float → Term

inductive TermList where
  | nil : TermList
  | cons : Term → TermList → TermList

inductive Branch where
  | Mk_branch : ANameList → Term → Branch

inductive BranchList where
  | nil : BranchList
  | cons : Branch → BranchList → BranchList

inductive Predicate where
  | Mk_predicate : T33 → TermList → ANameList → Term → Predicate

inductive Def where
  | Mkdef : Aname → Term → Term → Nat → Def

inductive DefList where
  | nil : DefList
  | cons : Def → DefList → DefList

inductive ANameList where
  | nil : ANameList
  | cons : Aname → ANameList → ANameList
end

abbrev Mfixpoint := DefList

/-! ## Context declarations -/

inductive Context_decl where
  | Mkdecl : Aname → Option Term → Term → Context_decl

abbrev Context := List Context_decl

/-! ## Allowed eliminations -/

inductive Allowed_eliminations where
  | IntoSProp | IntoPropSProp | IntoSetPropSProp | IntoAny
  deriving Repr, BEq, Inhabited

/-! ## Inductive body declarations -/

inductive Projection_body where
  | Build_projection_body : Ident → Relevance → Term → Projection_body

inductive Constructor_body where
  | Build_constructor_body : Ident → Context → List Term → Term → Nat →
      Constructor_body

inductive One_inductive_body where
  | Build_one_inductive_body :
      Ident → Context → T23 → Term → Allowed_eliminations →
      List Constructor_body → List Projection_body → Relevance →
      One_inductive_body

/-! ## Variance -/

inductive T36 where
  | Irrelevant0 | Covariant | Invariant
  deriving Repr, BEq, Inhabited

/-! ## Universes declaration -/

inductive UniversesDecl where
  | Monomorphic_ctx
  deriving Repr, BEq, Inhabited

abbrev Universes_decl := UniversesDecl

/-! ## Constant and mutual inductive bodies -/

inductive Constant_body where
  | Build_constant_body : Term → Option Term → Universes_decl → Relevance →
      Constant_body

inductive MutualInductiveBody where
  | Build_mutual_inductive_body :
      Recursivity_kind → Nat → Context →
      List One_inductive_body → Universes_decl →
      Option (List T36) →
      MutualInductiveBody

abbrev Mutual_inductive_body := MutualInductiveBody

/-! ## Global declarations -/

inductive Global_decl where
  | ConstantDecl : Constant_body → Global_decl
  | InductiveDecl : Mutual_inductive_body → Global_decl

abbrev TGlobalDeclaration := Prod Kername Global_decl
abbrev Global_declarations := List TGlobalDeclaration

/-! ## Retroknowledge -/

inductive T37 where
  | Mk_retroknowledge : OKername → OKername → T37
  deriving Repr, BEq, Inhabited

end MetaCoq
