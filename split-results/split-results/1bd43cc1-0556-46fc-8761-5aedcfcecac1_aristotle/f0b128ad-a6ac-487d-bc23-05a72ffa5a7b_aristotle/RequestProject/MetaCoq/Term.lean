import RequestProject.MetaCoq.Basic

/-!
# MetaCoq Term Types

Translation of MetaCoq term representation types from the Haskell extraction.
-/

namespace MetaCoq

/-! ## Identifiers and Paths -/

abbrev Ident := MyString
abbrev Dirpath := List Ident

inductive Modpath where
  | mpfile  : Dirpath → Modpath
  | mpbound : Dirpath → Ident → Nat → Modpath
  | mpdot   : Modpath → Ident → Modpath
  deriving Repr, BEq, Inhabited

structure Kername where
  modpath : Modpath
  ident   : Ident
  deriving Repr, BEq, Inhabited

abbrev OKername := Option Kername

/-! ## Names and Annotations -/

inductive Name where
  | nAnon  : Name
  | nNamed : Ident → Name
  deriving Repr, BEq, Inhabited

inductive Relevance where
  | relevant   : Relevance
  | irrelevant : Relevance
  deriving Repr, BEq, Inhabited

structure BinderAnnot (α : Type) where
  name      : α
  relevance : Relevance
  deriving Repr, BEq, Inhabited

abbrev Aname := BinderAnnot Name

/-! ## Cast and Case -/

inductive CastKind where
  | vmCast     : CastKind
  | nativeCast : CastKind
  | cast       : CastKind
  deriving Repr, BEq, Inhabited

structure Inductive where
  mind : Kername
  idx  : Nat
  deriving Repr, BEq, Inhabited

structure CaseInfo where
  ind       : Inductive
  npar      : Nat
  relevance : Relevance
  deriving Repr, BEq, Inhabited

/-! ## Recursivity -/

inductive RecursivityKind where
  | finite   : RecursivityKind
  | coFinite : RecursivityKind
  | biFinite : RecursivityKind
  deriving Repr, BEq, Inhabited

/-! ## Universes declaration -/

inductive UniversesDecl where
  | monomorphicCtx : UniversesDecl
  deriving Repr, BEq, Inhabited

/-! ## Projection -/

structure Projection where
  ind   : Inductive
  npars : Nat
  arg   : Nat
  deriving Repr, BEq, Inhabited

/-! ## Terms (mutual inductive) -/

/-- MetaCoq term, corresponding to `Ast.term` in Coq.
    Uses flattened representations for fixpoints and cases to satisfy
    Lean's positivity checker for inductive types. -/
inductive Term where
  | tRel       : Nat → Term
  | tVar       : Ident → Term
  | tEvar      : Nat → List Term → Term
  | tSort      : UnivSort → Term
  | tCast      : Term → CastKind → Term → Term
  | tProd      : Aname → Term → Term → Term
  | tLambda    : Aname → Term → Term → Term
  | tLetIn     : Aname → Term → Term → Term → Term
  | tApp       : Term → List Term → Term
  | tConst     : Kername → List Level → Term
  | tInd       : Inductive → List Level → Term
  | tConstruct : Inductive → Nat → List Level → Term
  | tCase      : CaseInfo → (List Level) → (List Term) → (List Aname) → Term →
                  Term → List (List Aname × Term) → Term
  | tProj      : Projection → Term → Term
  | tFix       : List (Aname × Term × Term × Nat) → Nat → Term
  | tCoFix     : List (Aname × Term × Term × Nat) → Nat → Term
  | tInt       : Int → Term
  | tFloat     : Float → Term
  deriving Inhabited

/-! ## Predicate (non-recursive, for external use) -/

/-- A case predicate (separated since it can't be nested in Term). -/
structure MCPredicate where
  puinst   : List Level
  pparams  : List Term
  pcontext : List Aname
  preturn  : Term
  deriving Inhabited

/-- A case branch. -/
structure Branch where
  bcontext : List Aname
  bbody    : Term
  deriving Inhabited

/-- A (co)fixpoint definition body. -/
structure Def where
  dname : Aname
  dtype : Term
  dbody : Term
  rarg  : Nat
  deriving Inhabited

abbrev Mfixpoint := List Def

/-! ## Smart constructors matching the original Haskell API -/

/-- Construct tCase from structured predicate and branches. -/
def Term.mkCase (ci : CaseInfo) (pred : MCPredicate) (discr : Term) (branches : List Branch)
    : Term :=
  .tCase ci pred.puinst pred.pparams pred.pcontext pred.preturn discr
    (branches.map fun b => (b.bcontext, b.bbody))

/-- Construct tFix from a list of Def. -/
def Term.mkFix (defs : Mfixpoint) (idx : Nat) : Term :=
  .tFix (defs.map fun d => (d.dname, d.dtype, d.dbody, d.rarg)) idx

/-- Construct tCoFix from a list of Def. -/
def Term.mkCoFix (defs : Mfixpoint) (idx : Nat) : Term :=
  .tCoFix (defs.map fun d => (d.dname, d.dtype, d.dbody, d.rarg)) idx

/-! ## Context -/

structure ContextDecl where
  declName : Aname
  declBody : Option Term
  declType : Term
  deriving Inhabited

abbrev Context := List ContextDecl

/-! ## Global declarations -/

/-- Variance for universe polymorphism (T36 in Haskell). -/
inductive Variance where
  | irrelevant : Variance
  | covariant  : Variance
  | invariant  : Variance
  deriving Repr, BEq, Inhabited

structure ConstantBody where
  cstType  : Term
  cstBody  : Option Term
  cstUnivs : UniversesDecl
  cstRel   : Relevance
  deriving Inhabited

inductive AllowedEliminations where
  | intoSProp        : AllowedEliminations
  | intoPropSProp    : AllowedEliminations
  | intoSetPropSProp : AllowedEliminations
  | intoAny          : AllowedEliminations
  deriving Repr, BEq, Inhabited

structure ProjectionBody where
  projName      : Ident
  projRelevance : Relevance
  projType      : Term
  deriving Inhabited

structure ConstructorBody where
  cstrName    : Ident
  cstrArgs    : Context
  cstrIndices : List Term
  cstrType    : Term
  cstrArity   : Nat
  deriving Inhabited

structure OneInductiveBody where
  indName       : Ident
  indIndices    : Context
  indSort       : UnivSort
  indType       : Term
  indKelim      : AllowedEliminations
  indCtors      : List ConstructorBody
  indProjs      : List ProjectionBody
  indRelevance  : Relevance
  deriving Inhabited

structure MutualInductiveBody where
  indFinite    : RecursivityKind
  indNpars     : Nat
  indParams    : Context
  indBodies    : List OneInductiveBody
  indUnivs     : UniversesDecl
  indVariance  : Option (List Variance)
  deriving Inhabited

inductive GlobalDecl where
  | constantDecl  : ConstantBody → GlobalDecl
  | inductiveDecl : MutualInductiveBody → GlobalDecl
  deriving Inhabited

abbrev GlobalDeclEntry := Kername × GlobalDecl
abbrev GlobalDeclarations := List GlobalDeclEntry

/-! ## Retroknowledge -/

/-- Retroknowledge (T37 in Haskell). -/
structure Retroknowledge where
  retroBool : OKername
  retroNat  : OKername
  deriving Repr, BEq, Inhabited

/-! ## Global environment -/

/-- Universe context set (T35 in Haskell: Prod T10 T32). -/
structure UnivContextSet where
  levels      : LevelTree
  constraints : ConstraintTree
  deriving Repr, BEq, Inhabited

structure GlobalEnv where
  univs : UnivContextSet
  decls : GlobalDeclarations
  retro : Retroknowledge
  deriving Inhabited

/-- A program: global environment + term (BigMama in Haskell). -/
abbrev Program := GlobalEnv × Term

/-! ## JSON serialization for Term types -/

-- Forward declaration helpers for the mutually recursive Term type
private partial def Modpath.toJson : Modpath → Lean.Json
  | .mpfile dp   => Lean.Json.mkObj [("tag", "MPfile"), ("contents", Lean.toJson dp)]
  | .mpbound dp id n =>
      Lean.Json.mkObj [("tag", "MPbound"),
        ("dirpath", Lean.toJson dp),
        ("ident", Lean.toJson id),
        ("nat", Lean.Json.num n)]
  | .mpdot mp id =>
      Lean.Json.mkObj [("tag", "MPdot"),
        ("modpath", mp.toJson),
        ("ident", Lean.toJson id)]

instance : Lean.ToJson Modpath where
  toJson := Modpath.toJson

instance : Lean.ToJson Kername where
  toJson k := Lean.Json.mkObj [
    ("modpath", Lean.toJson k.modpath),
    ("ident", Lean.toJson k.ident)
  ]

instance : Lean.ToJson Name where
  toJson
    | .nAnon    => Lean.Json.mkObj [("tag", "NAnon")]
    | .nNamed i => Lean.Json.mkObj [("tag", "NNamed"), ("contents", Lean.toJson i)]

instance : Lean.ToJson Relevance where
  toJson
    | .relevant   => Lean.Json.str "Relevant"
    | .irrelevant => Lean.Json.str "Irrelevant"

instance [Lean.ToJson α] : Lean.ToJson (BinderAnnot α) where
  toJson ba := Lean.Json.mkObj [
    ("name", Lean.toJson ba.name),
    ("relevance", Lean.toJson ba.relevance)
  ]

instance : Lean.ToJson CastKind where
  toJson
    | .vmCast     => Lean.Json.str "VmCast"
    | .nativeCast => Lean.Json.str "NativeCast"
    | .cast       => Lean.Json.str "Cast"

instance : Lean.ToJson Inductive where
  toJson i := Lean.Json.mkObj [
    ("mind", Lean.toJson i.mind),
    ("idx", Lean.Json.num i.idx)
  ]

instance : Lean.ToJson CaseInfo where
  toJson ci := Lean.Json.mkObj [
    ("ind", Lean.toJson ci.ind),
    ("npar", Lean.Json.num ci.npar),
    ("relevance", Lean.toJson ci.relevance)
  ]

instance : Lean.ToJson Projection where
  toJson p := Lean.Json.mkObj [
    ("ind", Lean.toJson p.ind),
    ("npars", Lean.Json.num p.npars),
    ("arg", Lean.Json.num p.arg)
  ]

instance : Lean.ToJson RecursivityKind where
  toJson
    | .finite   => Lean.Json.str "Finite"
    | .coFinite => Lean.Json.str "CoFinite"
    | .biFinite => Lean.Json.str "BiFinite"

instance : Lean.ToJson UniversesDecl where
  toJson
    | .monomorphicCtx => Lean.Json.str "Monomorphic_ctx"

instance : Lean.ToJson Variance where
  toJson
    | .irrelevant => Lean.Json.str "Irrelevant0"
    | .covariant  => Lean.Json.str "Covariant"
    | .invariant  => Lean.Json.str "Invariant"

instance : Lean.ToJson AllowedEliminations where
  toJson
    | .intoSProp        => Lean.Json.str "IntoSProp"
    | .intoPropSProp    => Lean.Json.str "IntoPropSProp"
    | .intoSetPropSProp => Lean.Json.str "IntoSetPropSProp"
    | .intoAny          => Lean.Json.str "IntoAny"

-- Term and its recursive substructures
mutual
private def Term.toJson : Term → Lean.Json
  | .tRel n =>
      Lean.Json.mkObj [("tag", "TRel"), ("contents", Lean.Json.num n)]
  | .tVar id =>
      Lean.Json.mkObj [("tag", "TVar"), ("contents", Lean.toJson id)]
  | .tEvar n ts =>
      Lean.Json.mkObj [("tag", "TEvar"), ("nat", Lean.Json.num n),
        ("terms", termListToJson ts)]
  | .tSort s =>
      Lean.Json.mkObj [("tag", "TSort"), ("contents", Lean.toJson s)]
  | .tCast t ck t2 =>
      Lean.Json.mkObj [("tag", "TCast"),
        ("term", t.toJson), ("castKind", Lean.toJson ck), ("type", t2.toJson)]
  | .tProd an ty body =>
      Lean.Json.mkObj [("tag", "TProd"),
        ("annot", Lean.toJson an), ("type", ty.toJson), ("body", body.toJson)]
  | .tLambda an ty body =>
      Lean.Json.mkObj [("tag", "TLambda"),
        ("annot", Lean.toJson an), ("type", ty.toJson), ("body", body.toJson)]
  | .tLetIn an val ty body =>
      Lean.Json.mkObj [("tag", "TLetIn"),
        ("annot", Lean.toJson an), ("val", val.toJson),
        ("type", ty.toJson), ("body", body.toJson)]
  | .tApp f args =>
      Lean.Json.mkObj [("tag", "TApp"),
        ("fn", f.toJson), ("args", termListToJson args)]
  | .tConst kn univs =>
      Lean.Json.mkObj [("tag", "TConst"),
        ("kername", Lean.toJson kn), ("univs", Lean.toJson univs)]
  | .tInd ind univs =>
      Lean.Json.mkObj [("tag", "TInd"),
        ("inductive", Lean.toJson ind), ("univs", Lean.toJson univs)]
  | .tConstruct ind n univs =>
      Lean.Json.mkObj [("tag", "TConstruct"),
        ("inductive", Lean.toJson ind), ("nat", Lean.Json.num n),
        ("univs", Lean.toJson univs)]
  | .tCase ci puinst pparams pctx pret discr branches =>
      Lean.Json.mkObj [("tag", "TCase"),
        ("caseInfo", Lean.toJson ci),
        ("puinst", Lean.toJson puinst),
        ("pparams", termListToJson pparams),
        ("pcontext", Lean.toJson pctx),
        ("preturn", pret.toJson),
        ("discriminee", discr.toJson),
        ("branches", branchListToJson branches)]
  | .tProj p t =>
      Lean.Json.mkObj [("tag", "TProj"),
        ("projection", Lean.toJson p), ("term", t.toJson)]
  | .tFix defs n =>
      Lean.Json.mkObj [("tag", "TFix"),
        ("defs", defListToJson defs), ("idx", Lean.Json.num n)]
  | .tCoFix defs n =>
      Lean.Json.mkObj [("tag", "TCoFix"),
        ("defs", defListToJson defs), ("idx", Lean.Json.num n)]
  | .tInt i =>
      Lean.Json.mkObj [("tag", "TInt"), ("contents", Lean.Json.num i)]
  | .tFloat f =>
      Lean.Json.mkObj [("tag", "TFloat"), ("contents", Lean.Json.str (toString f))]

private def termListToJson : List Term → Lean.Json
  | [] => Lean.Json.arr #[]
  | t :: ts => match termListToJson ts with
    | Lean.Json.arr a => Lean.Json.arr (#[t.toJson] ++ a)
    | j => j  -- shouldn't happen

private def branchListToJson : List (List Aname × Term) → Lean.Json
  | [] => Lean.Json.arr #[]
  | (ctx, body) :: bs => match branchListToJson bs with
    | Lean.Json.arr a => Lean.Json.arr (#[Lean.Json.mkObj [
        ("bcontext", Lean.toJson ctx),
        ("bbody", body.toJson)]] ++ a)
    | j => j

private def defListToJson : List (Aname × Term × Term × Nat) → Lean.Json
  | [] => Lean.Json.arr #[]
  | (an, ty, body, rarg) :: ds => match defListToJson ds with
    | Lean.Json.arr a => Lean.Json.arr (#[Lean.Json.mkObj [
        ("dname", Lean.toJson an),
        ("dtype", ty.toJson),
        ("dbody", body.toJson),
        ("rarg", Lean.Json.num rarg)]] ++ a)
    | j => j
end

instance : Lean.ToJson Term where
  toJson := Term.toJson

-- ContextDecl
instance : Lean.ToJson ContextDecl where
  toJson cd := Lean.Json.mkObj [
    ("declName", Lean.toJson cd.declName),
    ("declBody", match cd.declBody with
      | none => Lean.Json.null
      | some t => Lean.toJson t),
    ("declType", Lean.toJson cd.declType)
  ]

-- ConstantBody
instance : Lean.ToJson ConstantBody where
  toJson cb := Lean.Json.mkObj [
    ("cstType", Lean.toJson cb.cstType),
    ("cstBody", match cb.cstBody with
      | none => Lean.Json.null
      | some t => Lean.toJson t),
    ("cstUnivs", Lean.toJson cb.cstUnivs),
    ("cstRel", Lean.toJson cb.cstRel)
  ]

-- ProjectionBody
instance : Lean.ToJson ProjectionBody where
  toJson pb := Lean.Json.mkObj [
    ("projName", Lean.toJson pb.projName),
    ("projRelevance", Lean.toJson pb.projRelevance),
    ("projType", Lean.toJson pb.projType)
  ]

-- ConstructorBody
instance : Lean.ToJson ConstructorBody where
  toJson cb := Lean.Json.mkObj [
    ("cstrName", Lean.toJson cb.cstrName),
    ("cstrArgs", Lean.toJson cb.cstrArgs),
    ("cstrIndices", Lean.toJson cb.cstrIndices),
    ("cstrType", Lean.toJson cb.cstrType),
    ("cstrArity", Lean.Json.num cb.cstrArity)
  ]

-- OneInductiveBody
instance : Lean.ToJson OneInductiveBody where
  toJson oib := Lean.Json.mkObj [
    ("indName", Lean.toJson oib.indName),
    ("indIndices", Lean.toJson oib.indIndices),
    ("indSort", Lean.toJson oib.indSort),
    ("indType", Lean.toJson oib.indType),
    ("indKelim", Lean.toJson oib.indKelim),
    ("indCtors", Lean.toJson oib.indCtors),
    ("indProjs", Lean.toJson oib.indProjs),
    ("indRelevance", Lean.toJson oib.indRelevance)
  ]

-- MutualInductiveBody
instance : Lean.ToJson MutualInductiveBody where
  toJson mib := Lean.Json.mkObj [
    ("indFinite", Lean.toJson mib.indFinite),
    ("indNpars", Lean.Json.num mib.indNpars),
    ("indParams", Lean.toJson mib.indParams),
    ("indBodies", Lean.toJson mib.indBodies),
    ("indUnivs", Lean.toJson mib.indUnivs),
    ("indVariance", Lean.toJson mib.indVariance)
  ]

-- GlobalDecl
instance : Lean.ToJson GlobalDecl where
  toJson
    | .constantDecl cb  => Lean.Json.mkObj [("tag", "ConstantDecl"), ("contents", Lean.toJson cb)]
    | .inductiveDecl mb => Lean.Json.mkObj [("tag", "InductiveDecl"), ("contents", Lean.toJson mb)]

-- Retroknowledge
instance : Lean.ToJson Retroknowledge where
  toJson rk := Lean.Json.mkObj [
    ("retroBool", Lean.toJson rk.retroBool),
    ("retroNat", Lean.toJson rk.retroNat)
  ]

-- UnivContextSet
instance : Lean.ToJson UnivContextSet where
  toJson ucs := Lean.Json.mkObj [
    ("levels", Lean.toJson ucs.levels),
    ("constraints", Lean.toJson ucs.constraints)
  ]

-- GlobalEnv
instance : Lean.ToJson GlobalEnv where
  toJson ge := Lean.Json.mkObj [
    ("univs", Lean.toJson ge.univs),
    ("decls", Lean.toJson ge.decls),
    ("retro", Lean.toJson ge.retro)
  ]

end MetaCoq
