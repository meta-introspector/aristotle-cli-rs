/-!
# MetaCoq Kernel Types — translated from Haskell (Server.MetaCoq.TestMeta)

These inductive types and abbreviations are a direct translation of the Haskell
data types found in `Server.MetaCoq.TestMeta` / `TestMeta3`, which themselves
mirror the Coq/MetaCoq kernel term language.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

/-! ## Primitive / auxiliary types -/

/-- Coq-style positive binary numbers. -/
inductive Positive : Type where
  | xH : Positive
  | xO : Positive → Positive
  | xI : Positive → Positive
  deriving Repr, BEq, Inhabited

/-- Coq-style integers (Z). Called `T0` in the Haskell code. -/
inductive MCZ : Type where
  | Z0   : MCZ
  | Zpos : Positive → MCZ
  | Zneg : Positive → MCZ
  deriving Repr, BEq, Inhabited

/-- Coq-style byte (8-bit). -/
inductive MCByte : Type where
  | x00 | x01 | x02 | x03 | x04 | x05 | x06 | x07
  | x08 | x09 | x0a | x0b | x0c | x0d | x0e | x0f
  | x10 | x11 | x12 | x13 | x14 | x15 | x16 | x17
  | x18 | x19 | x1a | x1b | x1c | x1d | x1e | x1f
  | x20 | x21 | x22 | x23 | x24 | x25 | x26 | x27
  | x28 | x29 | x2a | x2b | x2c | x2d | x2e | x2f
  | x30 | x31 | x32 | x33 | x34 | x35 | x36 | x37
  | x38 | x39 | x3a | x3b | x3c | x3d | x3e | x3f
  | x40 | x41 | x42 | x43 | x44 | x45 | x46 | x47
  | x48 | x49 | x4a | x4b | x4c | x4d | x4e | x4f
  | x50 | x51 | x52 | x53 | x54 | x55 | x56 | x57
  | x58 | x59 | x5a | x5b | x5c | x5d | x5e | x5f
  | x60 | x61 | x62 | x63 | x64 | x65 | x66 | x67
  | x68 | x69 | x6a | x6b | x6c | x6d | x6e | x6f
  | x70 | x71 | x72 | x73 | x74 | x75 | x76 | x77
  | x78 | x79 | x7a | x7b | x7c | x7d | x7e | x7f
  | x80 | x81 | x82 | x83 | x84 | x85 | x86 | x87
  | x88 | x89 | x8a | x8b | x8c | x8d | x8e | x8f
  | x90 | x91 | x92 | x93 | x94 | x95 | x96 | x97
  | x98 | x99 | x9a | x9b | x9c | x9d | x9e | x9f
  | xa0 | xa1 | xa2 | xa3 | xa4 | xa5 | xa6 | xa7
  | xa8 | xa9 | xaa | xab | xac | xad | xae | xaf
  | xb0 | xb1 | xb2 | xb3 | xb4 | xb5 | xb6 | xb7
  | xb8 | xb9 | xba | xbb | xbc | xbd | xbe | xbf
  | xc0 | xc1 | xc2 | xc3 | xc4 | xc5 | xc6 | xc7
  | xc8 | xc9 | xca | xcb | xcc | xcd | xce | xcf
  | xd0 | xd1 | xd2 | xd3 | xd4 | xd5 | xd6 | xd7
  | xd8 | xd9 | xda | xdb | xdc | xdd | xde | xdf
  | xe0 | xe1 | xe2 | xe3 | xe4 | xe5 | xe6 | xe7
  | xe8 | xe9 | xea | xeb | xec | xed | xee | xef
  | xf0 | xf1 | xf2 | xf3 | xf4 | xf5 | xf6 | xf7
  | xf8 | xf9 | xfa | xfb | xfc | xfd | xfe | xff
  deriving Repr, BEq, Inhabited

/-- Coq-style string (list of bytes). Haskell: `MyString`. -/
inductive MyString : Type where
  | EmptyString : MyString
  | String      : MCByte → MyString → MyString
  deriving Repr, BEq, Inhabited

/-- Generic product. Haskell: `data Prod a b = Pair a b`. -/
inductive MCProd (α β : Type) : Type where
  | Pair : α → β → MCProd α β
  deriving Repr, BEq, Inhabited

/-- Generic list. Haskell: `data List a = Nil | Cons a (List a)`. -/
inductive MCList (α : Type) : Type where
  | Nil  : MCList α
  | Cons : α → MCList α → MCList α
  deriving Repr, BEq, Inhabited

/-- Generic option. Haskell: `data Option a = None | Some a`. -/
inductive MCOption (α : Type) : Type where
  | None : MCOption α
  | Some : α → MCOption α
  deriving Repr, BEq, Inhabited

/-! ## Names and identifiers -/

abbrev Ident := MyString
abbrev Dirpath := MCList Ident

/-- Module path. -/
inductive Modpath : Type where
  | MPfile  : Dirpath → Modpath
  | MPbound : Dirpath → Ident → Nat → Modpath
  | MPdot   : Modpath → Ident → Modpath
  deriving Repr, BEq, Inhabited

abbrev Kername := MCProd Modpath Ident

/-- Coq `Name`: anonymous or named. -/
inductive MCName : Type where
  | nAnon  : MCName
  | nNamed : Ident → MCName
  deriving Repr, BEq, Inhabited

/-- Relevance annotation. -/
inductive Relevance : Type where
  | Relevant   : Relevance
  | Irrelevant : Relevance
  deriving Repr, BEq, Inhabited

/-- Binder annotation: a name together with a relevance. -/
inductive BinderAnnot (α : Type) : Type where
  | MkBindAnn : α → Relevance → BinderAnnot α
  deriving Repr, BEq, Inhabited

abbrev Binder_annot := BinderAnnot
abbrev BinderAnnotName := BinderAnnot MCName
abbrev Aname := BinderAnnot MCName

/-! ## Internal tree / map types -/

/-- Internal balanced-tree type. Haskell: `T_` / `T3` / `Elt0`. -/
inductive T_ : Type where
  | Leaf : T_
  | Node : MCZ → T_ → Positive → T_ → T_
  deriving Repr, BEq, Inhabited

abbrev T3 := T_
abbrev Elt0 := T_

/-- Internal tree type. Haskell: `T_3` / `T24`. -/
inductive T_3 : Type where
  | Leaf : T_3
  | Node : T_3 → Nat → T_3 → T_3
  deriving Repr, BEq, Inhabited

abbrev T24 := T_3
abbrev T25S := MCProd T3 T24
abbrev T25 := MCProd T25S T3
abbrev T14 := MCProd T3 Nat
abbrev Elt1 := T14
abbrev Elt2 := T14

/-- Internal tree type. Haskell: `Tree` / `T4` / `T_0` / `T10`. -/
inductive Tree : Type where
  | TreeLeaf : Tree
  | TreeNode : MCZ → Tree → T3 → Tree → Tree
  deriving Repr, BEq, Inhabited

abbrev T4  := Tree
abbrev T_0 := T4
abbrev T10 := T_0

/-- Internal tree type. Haskell: `Tree0` / `T26` / `T_4` / `T32`.
    `Node0 T0 Tree0 (Prod (Prod T3 T24) T3) Tree0` -/
inductive Tree0 : Type where
  | Leaf0 : Tree0
  | Node0 : MCZ → Tree0 → T25 → Tree0 → Tree0
  deriving Repr, BEq, Inhabited

abbrev T26 := Tree0
abbrev T_4 := T26
abbrev T32 := T_4

/-- Internal tree type. Haskell: `T_2` / `T23`. -/
inductive T_2 : Type where
  | Leaf2 : T_2
  | Node2 : T_2 → Nat → T_2 → T_2
  deriving Repr, BEq, Inhabited

abbrev T23 := T_2

/-! ### Remaining T-aliases -/

abbrev T0  := MCZ
abbrev T   := MyString
abbrev T18 := MCList Elt1
abbrev T_1 := T18
abbrev T21 := T_1
abbrev NonEmptyLevelExprSet := T21
abbrev T22 := NonEmptyLevelExprSet
abbrev T33 := MCList T3
abbrev T35 := MCProd T10 T32
abbrev T36 := MCProd T3 T3

/-! ## Cast & recursivity kinds -/

inductive CastKind : Type where
  | VmCast     : CastKind
  | NativeCast : CastKind
  | Cast       : CastKind
  | RevertCast : CastKind
  deriving Repr, BEq, Inhabited

inductive RecursivityKind : Type where
  | Finite   : RecursivityKind
  | CoFinite : RecursivityKind
  | BiFinite : RecursivityKind
  deriving Repr, BEq, Inhabited

abbrev Recursivity_kind := RecursivityKind

/-! ## Universe declarations -/

abbrev UniverseInstance := MCList T3
abbrev Universe := NonEmptyLevelExprSet

inductive Allowed_eliminations : Type where
  | IntoSProp        : Allowed_eliminations
  | IntoPropSProp     : Allowed_eliminations
  | IntoSetPropSProp  : Allowed_eliminations
  | IntoAny          : Allowed_eliminations
  deriving Repr, BEq, Inhabited

inductive UniversesDecl : Type where
  | Monomorphic_ctx : UniversesDecl
  | Polymorphic_ctx : MCList (MCProd Ident (MCOption (MCList T36))) → UniversesDecl
  deriving Repr, BEq, Inhabited

abbrev Universes_decl := UniversesDecl

/-! ## Inductive references and case info -/

inductive MCInductive : Type where
  | MkInd : Kername → Nat → MCInductive
  deriving Repr, BEq, Inhabited

inductive Projection : Type where
  | MkProjection : MCInductive → Nat → Nat → Projection
  deriving Repr, BEq, Inhabited

inductive CaseInfo : Type where
  | Mk_case_info : MCInductive → Nat → Relevance → CaseInfo
  deriving Repr, BEq, Inhabited

abbrev Case_info := CaseInfo
abbrev Cast_kind := CastKind

/-! ## Core term language

All mutually-dependent types are defined together in a single `mutual` block
because Lean 4 requires mutually recursive inductive types to be declared
simultaneously. -/

mutual

/-- Context declaration, parameterised by the term type. -/
inductive Context_decl : Type where
  | mkdecl : Aname → MCOption Term → Term → Context_decl

/-- Definition body in a (co)fixpoint. -/
inductive Def : Type where
  | mkdef : Aname → Term → Term → Nat → Def

/-- Branch of a `match` / `case`. -/
inductive Branch : Type where
  | mk_branch : MCList Aname → Term → Branch

/-- Predicate (return-type annotation) of a `match`. -/
inductive Predicate : Type where
  | mk_predicate : UniverseInstance → MCList Aname → Context_decl → Term → Predicate

/-- MetaCoq kernel term. -/
inductive Term : Type where
  | tRel       : Nat → Term
  | tVar       : Ident → Term
  | tEvar      : Nat → MCList Term → Term
  | tSort      : Universe → Term
  | tCast      : Term → CastKind → Term → Term
  | tProd      : Aname → Term → Term → Term
  | tLambda    : Aname → Term → Term → Term
  | tLetIn     : Aname → Term → Term → Term → Term
  | tApp       : Term → Term → Term
  | tConst     : Kername → UniverseInstance → Term
  | tInd       : MCInductive → UniverseInstance → Term
  | tConstruct : MCInductive → Nat → UniverseInstance → Term
  | tCase      : CaseInfo → Predicate → Term → MCList Branch → Term
  | tProj      : Projection → Term → Term
  | tFix       : MCList Def → Nat → Term
  | tCoFix     : MCList Def → Nat → Term
  | tInt       : MCZ → Term
  | tFloat     : Nat → Term

end

/-! ### Abbreviations for specialised types -/

abbrev Context_declTerm := Context_decl
abbrev Context := MCList Context_decl
abbrev DefTerm := Def
abbrev Mfixpoint := MCList Def
abbrev BranchTerm := Branch
abbrev PredicateTerm := Predicate

/-! ## Global declarations and environment -/

/-- Constant body (axiom or definition). -/
inductive Constant_body : Type where
  | Build_constant_body :
      MCOption Term →
      Term →
      UniversesDecl →
      Relevance →
      Constant_body

/-- Projection body. -/
inductive Projection_body : Type where
  | Build_projection_body :
      Ident →
      Relevance →
      Projection_body
  deriving Repr, BEq, Inhabited

/-- Constructor body. -/
inductive Constructor_body : Type where
  | Build_constructor_body :
      Ident →
      Term →
      Nat →
      Constructor_body

/-- One inductive body inside a mutual block. -/
inductive One_inductive_body : Type where
  | Build_one_inductive_body :
      Ident →
      MCList Context_decl →
      T23 →
      Term →
      Allowed_eliminations →
      MCList Constructor_body →
      MCList Projection_body →
      Relevance →
      One_inductive_body

/-- Mutual inductive body.
    Haskell constructor: `Build_mutual_inductive_body`. -/
inductive MutualInductiveBody : Type where
  | Build_mutual_inductive_body :
      Nat →
      Nat →
      MCList Context_decl →
      MCList One_inductive_body →
      UniversesDecl →
      Nat →
      MutualInductiveBody

abbrev Mutual_inductive_body := MutualInductiveBody

/-- A global declaration is either a constant or an inductive. -/
inductive Global_decl : Type where
  | ConstantDecl  : Constant_body → Global_decl
  | InductiveDecl : MutualInductiveBody → Global_decl

abbrev TGlobalDeclaration := MCProd Kername Global_decl
abbrev Global_declarations := MCList TGlobalDeclaration

/-- Retroknowledge placeholder. -/
inductive Retroknowledge : Type where
  | mk_retroknowledge : Retroknowledge
  deriving Repr, BEq, Inhabited

/-- Global environment. Haskell constructor: `Mk_global_env`. -/
inductive Global_env : Type where
  | Mk_global_env :
      Retroknowledge →
      Global_declarations →
      T35 →
      Global_env

/-- The "big mama" type: a product of a global environment and a term. -/
abbrev BigMama := MCProd Global_env Term

/-! ## Remaining list / option aliases -/

abbrev ListAname              := MCList Aname
abbrev ListBranchTerm         := MCList BranchTerm
abbrev ListConstructor_body   := MCList Constructor_body
abbrev ListContext_declTerm   := MCList Context_declTerm
abbrev ListDefTerm            := MCList DefTerm
abbrev ListElt1               := MCList Elt1
abbrev ListOne_inductive_body := MCList One_inductive_body
abbrev ListProjection_body    := MCList Projection_body
abbrev ListT3                 := MCList T3
abbrev ListT36                := MCList T36
abbrev ListTerm               := MCList Term
abbrev OKername               := MCOption Kername
abbrev OptionListT36          := MCOption ListT36
abbrev OptionTerm             := MCOption Term
