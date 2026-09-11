/-
  Translation of Server.MetaCoq.TestMeta5 (Haskell) to Lean 4.

  Original replacement rules:
    Language.Haskell.TH.Syntax.    → language_Haskell_TH_Syntax_
    Language.Haskell.TH.Desugar.AST. → language_Haskell_TH_Desugar_AST_
-/

-- ============================================================
-- 1. Desugared Template Haskell AST  (`Term`)
-- ============================================================

/-- Desugared TH AST node.  Mirrors the Haskell `data Term` plus an
    `Str` constructor for uninterpreted qualified names / atoms. -/
inductive Term where
  | Skip         : Term
  | DAppT        : Term → Term → Term
  | DArrowT      : Term
  | DConT        : Term → Term
  | DConstrainedT : List Term → Term → Term
  | DForallInvis : List Term → Term
  | DForallT     : Term → Term → Term
  | DKindedTV    : Term → Term → Term → Term
  | DTyConI      : Term → Option (List Term) → Term
  | DVarI        : Term → Term → Option Term → Term
  | DVarT        : Term → Term
  | DTySynD      : Term → List Term → Term → Term
  | InferredSpec : Term
  | SpecifiedSpec : Term
  | Str          : String → Term   -- atom / name
  -- Desugared constructors used in reification output
  | DCon         : List Term → List Term → Term → Term → Term → Term
  | DNormalC     : Bool → List (Term × Term) → Term
  | DDataD       : Term → List Term → Term → List Term → Option Term
                    → List Term → List Term → Term
  | DClassD      : List Term → Term → List Term → List Term
                    → List Term → Term
  | DInstanceD   : Option Term → Option (List Term) → List Term
                    → Term → List Term → Term
  | DLetDec      : Term → Term
  | DSigD        : Term → Term → Term
  -- Bang / strictness  (flattened into Term for simplicity)
  | Bang         : Term → Term → Term
  | NoSourceUnpackedness : Term
  | NoSourceStrictness   : Term
  | SourceStrict         : Term
  -- TH-level type constructors used in `substract`
  | ConT         : Term → Term
  | AppT         : Term → Term → Term
  | ListT        : Term
  -- TH-level declarations used in `substract`
  | TyConI       : Term → Term
  | DataD        : List Term → Term → List Term → Option Term
                    → List Term → List Term → Term
  | NormalC      : Term → List (Term × Term) → Term
  | Data         : Term      -- DataFlavor
  deriving Repr, BEq, Inhabited

-- ============================================================
-- 2.  Atom names  (uninterpreted qualified identifiers)
-- ============================================================

open Term

def language_Haskell_TH_Syntax_Name       := Str "Language.Haskell.TH.Syntax.Name"
def language_Haskell_TH_Syntax_OccName    := Str "Language.Haskell.TH.Syntax.OccName"
def language_Haskell_TH_Syntax_NameFlavour := Str "Language.Haskell.TH.Syntax.NameFlavour"
def language_Haskell_TH_Syntax_ModName    := Str "Language.Haskell.TH.Syntax.ModName"
def language_Haskell_TH_Syntax_Uniq       := Str "Language.Haskell.TH.Syntax.Uniq"
def language_Haskell_TH_Syntax_NameSpace  := Str "Language.Haskell.TH.Syntax.NameSpace"
def language_Haskell_TH_Syntax_PkgName    := Str "Language.Haskell.TH.Syntax.PkgName"
def language_Haskell_TH_Syntax_NameS      := Str "Language.Haskell.TH.Syntax.NameS"
def language_Haskell_TH_Syntax_NameQ      := Str "Language.Haskell.TH.Syntax.NameQ"
def language_Haskell_TH_Syntax_NameU      := Str "Language.Haskell.TH.Syntax.NameU"
def language_Haskell_TH_Syntax_NameL      := Str "Language.Haskell.TH.Syntax.NameL"
def language_Haskell_TH_Syntax_NameG      := Str "Language.Haskell.TH.Syntax.NameG"
def language_Haskell_TH_Syntax_Cxt        := Str "Language.Haskell.TH.Syntax.Cxt"
def language_Haskell_TH_Syntax_Pred       := Str "Language.Haskell.TH.Syntax.Pred"
def language_Haskell_TH_Syntax_Kind       := Str "Language.Haskell.TH.Syntax.Kind"
def language_Haskell_TH_Syntax_Con        := Str "Language.Haskell.TH.Syntax.Con"
def language_Haskell_TH_Syntax_DerivClause := Str "Language.Haskell.TH.Syntax.DerivClause"
def language_Haskell_TH_Syntax_Dec        := Str "Language.Haskell.TH.Syntax.Dec"
def language_Haskell_TH_Syntax_TyVarBndr  := Str "Language.Haskell.TH.Syntax.TyVarBndr"
def language_Haskell_TH_Syntax_Specificity := Str "Language.Haskell.TH.Syntax.Specificity"
def language_Haskell_TH_Syntax_Type       := Str "Language.Haskell.TH.Syntax.Type"
def language_Haskell_TH_Syntax_Overlap    := Str "Language.Haskell.TH.Syntax.Overlap"
def language_Haskell_TH_Syntax_FunDep     := Str "Language.Haskell.TH.Syntax.FunDep"
def language_Haskell_TH_Syntax_Role       := Str "Language.Haskell.TH.Syntax.Role"
def language_Haskell_TH_Syntax_PatSynArgs := Str "Language.Haskell.TH.Syntax.PatSynArgs"
def language_Haskell_TH_Syntax_SumArity   := Str "Language.Haskell.TH.Syntax.SumArity"
def language_Haskell_TH_Syntax_TyLit      := Str "Language.Haskell.TH.Syntax.TyLit"
def language_Haskell_TH_Syntax_DataD      := Str "Language.Haskell.TH.Syntax.DataD"
def language_Haskell_TH_Syntax_Quasi      := Str "Language.Haskell.TH.Syntax.Quasi"
def language_Haskell_TH_Syntax_Q          := Str "Language.Haskell.TH.Syntax.Q"

def language_Haskell_TH_Desugar_AST_DDec        := Str "Language.Haskell.TH.Desugar.AST.DDec"
def language_Haskell_TH_Desugar_AST_DInstanceDec := Str "Language.Haskell.TH.Desugar.AST.DInstanceDec"
def language_Haskell_TH_Desugar_AST_DType       := Str "Language.Haskell.TH.Desugar.AST.DType"
def language_Haskell_TH_Desugar_AST_DKind       := Str "Language.Haskell.TH.Desugar.AST.DKind"
def language_Haskell_TH_Desugar_AST_DInfo       := Str "Language.Haskell.TH.Desugar.AST.DInfo"
def language_Haskell_TH_Desugar_AST_DPatSynType := Str "Language.Haskell.TH.Desugar.AST.DPatSynType"
def language_Haskell_TH_Desugar_AST_DTyVarBndrUnit := Str "Language.Haskell.TH.Desugar.AST.DTyVarBndrUnit"
def language_Haskell_TH_Desugar_AST_DCon        := Str "Language.Haskell.TH.Desugar.AST.DCon"
def language_Haskell_TH_Desugar_AST_DDerivClause := Str "Language.Haskell.TH.Desugar.AST.DDerivClause"
def language_Haskell_TH_Desugar_AST_DLetDec     := Str "Language.Haskell.TH.Desugar.AST.DLetDec"
def language_Haskell_TH_Desugar_AST_DConFields  := Str "Language.Haskell.TH.Desugar.AST.DConFields"
def language_Haskell_TH_Desugar_AST_DCxt         := Str "Language.Haskell.TH.Desugar.AST.DCxt"
def language_Haskell_TH_Desugar_AST_DBangType   := Str "Language.Haskell.TH.Desugar.AST.DBangType"
def language_Haskell_TH_Desugar_AST_DDeclaredInfix := Str "Language.Haskell.TH.Desugar.AST.DDeclaredInfix"
def language_Haskell_TH_Desugar_AST_DForeign    := Str "Language.Haskell.TH.Desugar.AST.DForeign"
def language_Haskell_TH_Desugar_AST_DTypeFamilyHead := Str "Language.Haskell.TH.Desugar.AST.DTypeFamilyHead"
def language_Haskell_TH_Desugar_AST_DTySynEqn   := Str "Language.Haskell.TH.Desugar.AST.DTySynEqn"
def language_Haskell_TH_Desugar_AST_DDerivStrategy := Str "Language.Haskell.TH.Desugar.AST.DDerivStrategy"
def language_Haskell_TH_Desugar_AST_DPat        := Str "Language.Haskell.TH.Desugar.AST.DPat"
def language_Haskell_TH_Desugar_AST_DPatSynDir  := Str "Language.Haskell.TH.Desugar.AST.DPatSynDir"
def language_Haskell_TH_Desugar_Util_DataFlavor := Str "Language.Haskell.TH.Desugar.Util.DataFlavor"
def language_Haskell_TH_Desugar_Reify_DsMonad   := Str "Language.Haskell.TH.Desugar.Reify.DsMonad"
def language_Haskell_TH_Desugar_Reify_DsM       := Str "Language.Haskell.TH.Desugar.Reify.DsM"
def language_Haskell_TH_Desugar_Reify_localDeclarations := Str "Language.Haskell.TH.Desugar.Reify.localDeclarations"

-- Constructor atoms for data types
def language_Haskell_TH_Desugar_AST_DTyConI     := Str "Language.Haskell.TH.Desugar.AST.DTyConI"
def language_Haskell_TH_Desugar_AST_DVarI       := Str "Language.Haskell.TH.Desugar.AST.DVarI"
def language_Haskell_TH_Desugar_AST_DTyVarI     := Str "Language.Haskell.TH.Desugar.AST.DTyVarI"
def language_Haskell_TH_Desugar_AST_DPrimTyConI := Str "Language.Haskell.TH.Desugar.AST.DPrimTyConI"
def language_Haskell_TH_Desugar_AST_DPatSynI    := Str "Language.Haskell.TH.Desugar.AST.DPatSynI"
def language_Haskell_TH_Desugar_AST_DTySynD     := Str "Language.Haskell.TH.Desugar.AST.DTySynD"
def language_Haskell_TH_Desugar_AST_DDataD      := Str "Language.Haskell.TH.Desugar.AST.DDataD"
def language_Haskell_TH_Desugar_AST_DClassD     := Str "Language.Haskell.TH.Desugar.AST.DClassD"
def language_Haskell_TH_Desugar_AST_DInstanceD  := Str "Language.Haskell.TH.Desugar.AST.DInstanceD"
def language_Haskell_TH_Desugar_AST_DForeignD   := Str "Language.Haskell.TH.Desugar.AST.DForeignD"
def language_Haskell_TH_Desugar_AST_DOpenTypeFamilyD := Str "Language.Haskell.TH.Desugar.AST.DOpenTypeFamilyD"
def language_Haskell_TH_Desugar_AST_DClosedTypeFamilyD := Str "Language.Haskell.TH.Desugar.AST.DClosedTypeFamilyD"
def language_Haskell_TH_Desugar_AST_DDataFamilyD := Str "Language.Haskell.TH.Desugar.AST.DDataFamilyD"
def language_Haskell_TH_Desugar_AST_DDataInstD  := Str "Language.Haskell.TH.Desugar.AST.DDataInstD"
def language_Haskell_TH_Desugar_AST_DTySynInstD := Str "Language.Haskell.TH.Desugar.AST.DTySynInstD"
def language_Haskell_TH_Desugar_AST_DRoleAnnotD := Str "Language.Haskell.TH.Desugar.AST.DRoleAnnotD"
def language_Haskell_TH_Desugar_AST_DStandaloneDerivD := Str "Language.Haskell.TH.Desugar.AST.DStandaloneDerivD"
def language_Haskell_TH_Desugar_AST_DDefaultSigD := Str "Language.Haskell.TH.Desugar.AST.DDefaultSigD"
def language_Haskell_TH_Desugar_AST_DPatSynD    := Str "Language.Haskell.TH.Desugar.AST.DPatSynD"
def language_Haskell_TH_Desugar_AST_DPatSynSigD := Str "Language.Haskell.TH.Desugar.AST.DPatSynSigD"
def language_Haskell_TH_Desugar_AST_DKiSigD     := Str "Language.Haskell.TH.Desugar.AST.DKiSigD"
def language_Haskell_TH_Desugar_AST_DDefaultD   := Str "Language.Haskell.TH.Desugar.AST.DDefaultD"
def language_Haskell_TH_Desugar_AST_DNormalC    := Str "Language.Haskell.TH.Desugar.AST.DNormalC"

-- TH Syntax constructor atoms for Type
def language_Haskell_TH_Syntax_ForallT     := Str "Language.Haskell.TH.Syntax.ForallT"
def language_Haskell_TH_Syntax_ForallVisT  := Str "Language.Haskell.TH.Syntax.ForallVisT"
def language_Haskell_TH_Syntax_AppT        := Str "Language.Haskell.TH.Syntax.AppT"
def language_Haskell_TH_Syntax_AppKindT    := Str "Language.Haskell.TH.Syntax.AppKindT"
def language_Haskell_TH_Syntax_SigT        := Str "Language.Haskell.TH.Syntax.SigT"
def language_Haskell_TH_Syntax_VarT        := Str "Language.Haskell.TH.Syntax.VarT"
def language_Haskell_TH_Syntax_ConT        := Str "Language.Haskell.TH.Syntax.ConT"
def language_Haskell_TH_Syntax_PromotedT   := Str "Language.Haskell.TH.Syntax.PromotedT"
def language_Haskell_TH_Syntax_InfixT      := Str "Language.Haskell.TH.Syntax.InfixT"
def language_Haskell_TH_Syntax_UInfixT     := Str "Language.Haskell.TH.Syntax.UInfixT"
def language_Haskell_TH_Syntax_ParensT     := Str "Language.Haskell.TH.Syntax.ParensT"
def language_Haskell_TH_Syntax_TupleT      := Str "Language.Haskell.TH.Syntax.TupleT"
def language_Haskell_TH_Syntax_UnboxedTupleT := Str "Language.Haskell.TH.Syntax.UnboxedTupleT"
def language_Haskell_TH_Syntax_UnboxedSumT := Str "Language.Haskell.TH.Syntax.UnboxedSumT"
def language_Haskell_TH_Syntax_ArrowT      := Str "Language.Haskell.TH.Syntax.ArrowT"
def language_Haskell_TH_Syntax_MulArrowT   := Str "Language.Haskell.TH.Syntax.MulArrowT"
def language_Haskell_TH_Syntax_EqualityT   := Str "Language.Haskell.TH.Syntax.EqualityT"
def language_Haskell_TH_Syntax_ListT       := Str "Language.Haskell.TH.Syntax.ListT"
def language_Haskell_TH_Syntax_PromotedTupleT := Str "Language.Haskell.TH.Syntax.PromotedTupleT"
def language_Haskell_TH_Syntax_PromotedNilT := Str "Language.Haskell.TH.Syntax.PromotedNilT"
def language_Haskell_TH_Syntax_PromotedConsT := Str "Language.Haskell.TH.Syntax.PromotedConsT"
def language_Haskell_TH_Syntax_StarT       := Str "Language.Haskell.TH.Syntax.StarT"
def language_Haskell_TH_Syntax_ConstraintT := Str "Language.Haskell.TH.Syntax.ConstraintT"
def language_Haskell_TH_Syntax_LitT        := Str "Language.Haskell.TH.Syntax.LitT"
def language_Haskell_TH_Syntax_WildCardT   := Str "Language.Haskell.TH.Syntax.WildCardT"
def language_Haskell_TH_Syntax_ImplicitParamT := Str "Language.Haskell.TH.Syntax.ImplicitParamT"

-- GHC atoms
def ghc_Base_String      := Str "GHC.Base.String"
def ghc_Base_Monoid      := Str "GHC.Base.Monoid"
def GHC_Types_Type       := Str "GHC.Types.Type"
def GHC_Maybe            := Str "GHC.Maybe"
def GHC_Types_empty_array := Str "GHC.Types.[]"
def GHC_Types_Int        := Str "GHC.Types.Int"
def GHC_Types_Bool       := Str "GHC.Types.Bool"
def GHC_Types_False      := Str "GHC.Types.False"
def GHC_Types_True       := Str "GHC.Types.True"
def GHC_Types_IO         := Str "GHC.Types.IO"
def GHC_Tuple_unit       := Str "GHC.Tuple.()"

-- Monad transformer atoms
def Control_Monad_Fail_MonadFail := Str "Control.Monad.Fail.MonadFail"
def Control_Monad_Trans_Writer_Lazy_WriterT := Str "Control.Monad.Trans.Writer.Lazy.WriterT"
def Control_Monad_Trans_State_Lazy_StateT := Str "Control.Monad.Trans.State.Lazy.StateT"
def Control_Monad_Trans_Reader_ReaderT := Str "Control.Monad.Trans.Reader.ReaderT"
def Control_Monad_Trans_RWS_Lazy_RWST := Str "Control.Monad.Trans.RWS.Lazy.RWST"

-- TH Syntax type name atoms
def Language_Haskell_TH_Syntax_Type := Str "Language.Haskell.TH.Syntax.Type"

-- ============================================================
-- 3.  Helper functions
-- ============================================================

def mkName' (a : String) : Term := Str a

def dsReify (_a : String) : Term := DArrowT

-- ============================================================
-- 4.  Reified definitions  (from `$(stringE . show =<< dsReify …)`)
-- ============================================================

-- $(stringE . show =<< dsReify  'Language.Haskell.TH.Syntax.Name )
def reify_Name : Term :=
  DVarI language_Haskell_TH_Syntax_Name
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_OccName))
      (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_NameFlavour))
        (DConT language_Haskell_TH_Syntax_Name)))
    (some language_Haskell_TH_Syntax_Name)

-- $(stringE . show =<< dsReify  'Language.Haskell.TH.Syntax.OccName )
def reify_OccName : Term :=
  DVarI language_Haskell_TH_Syntax_OccName
    (DAppT (DAppT DArrowT (DConT ghc_Base_String))
      (DConT language_Haskell_TH_Syntax_OccName))
    (some language_Haskell_TH_Syntax_OccName)

-- f1 = Skip
def f1 : Term := Skip

-- q variable name
def q_var : Term := mkName' "temp"

-- nexttest2
def nexttest2 : Term :=
  DVarI f1
    (DForallT
      (DForallInvis [
        DKindedTV q_var InferredSpec
          (DAppT (DAppT DArrowT (DConT GHC_Types_Type))
            (DConT GHC_Types_Type))
      ])
      (DConstrainedT
        [DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad) (DVarT q_var)]
        (DAppT (DVarT q_var)
          (DAppT (DConT GHC_Maybe)
            (DConT language_Haskell_TH_Desugar_AST_DInfo)))))
    none

-- language_Haskell_TH_Desugar_AST_DPatSynI  (the reified constructor info)
def reify_DPatSynI : Term :=
  DVarI language_Haskell_TH_Desugar_AST_DPatSynI
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Name))
      (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DPatSynType))
        (DConT language_Haskell_TH_Desugar_AST_DInfo)))
    (some language_Haskell_TH_Desugar_AST_DInfo)

-- next_test  (nested DVarI)
def next_test : Term :=
  DVarI
    (DVarI language_Haskell_TH_Desugar_AST_DPatSynI
      (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Name))
        (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DPatSynType))
          (DConT language_Haskell_TH_Desugar_AST_DInfo)))
      (some language_Haskell_TH_Desugar_AST_DInfo))
    DArrowT  -- placeholder for missing argument in original
    none

-- Helper: toName placeholder
def toName : Term := Str "toName"

-- b  (NormalC constructor)
def b_val : Term :=
  NormalC toName [
    (Bang NoSourceUnpackedness NoSourceStrictness,
     ConT language_Haskell_TH_Syntax_Name),
    (Bang NoSourceUnpackedness NoSourceStrictness,
     ConT language_Haskell_TH_Desugar_AST_DPatSynType)
  ]

-- substract  (reification of DInfo as a TH Dec list)
def substract : List Term := [
  TyConI (
    DataD [] language_Haskell_TH_Desugar_AST_DInfo [] none [
      NormalC language_Haskell_TH_Desugar_AST_DTyConI [
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT language_Haskell_TH_Desugar_AST_DDec),
        (Bang NoSourceUnpackedness NoSourceStrictness,
         AppT (ConT GHC_Maybe)
              (AppT ListT (ConT language_Haskell_TH_Desugar_AST_DInstanceDec)))
      ],
      NormalC language_Haskell_TH_Desugar_AST_DVarI [
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT language_Haskell_TH_Syntax_Name),
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT language_Haskell_TH_Desugar_AST_DType),
        (Bang NoSourceUnpackedness NoSourceStrictness,
         AppT (ConT GHC_Maybe) (ConT language_Haskell_TH_Syntax_Name))
      ],
      NormalC language_Haskell_TH_Desugar_AST_DTyVarI [
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT language_Haskell_TH_Syntax_Name),
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT language_Haskell_TH_Desugar_AST_DKind)
      ],
      NormalC language_Haskell_TH_Desugar_AST_DPrimTyConI [
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT language_Haskell_TH_Syntax_Name),
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT GHC_Types_Int),
        (Bang NoSourceUnpackedness NoSourceStrictness,
         ConT GHC_Types_Bool)
      ],
      b_val
    ] [])
]

-- $(stringE . show =<< dsReify GHC_Types_Type)
def atype : Term :=
  DTyConI (DTySynD GHC_Types_Type [] (DConT GHC_Types_Type)) none

-- $(stringE . show =<< dsReifyType 'DTyConI)
def dtyconi : Term :=
  DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DDec))
    (DAppT (DAppT DArrowT
      (DAppT (DConT GHC_Maybe)
        (DAppT (DConT GHC_Types_empty_array)
          (DConT language_Haskell_TH_Desugar_AST_DInstanceDec))))
      (DConT language_Haskell_TH_Desugar_AST_DInfo))

-- dinfo  (type of DInfo as a function type)
def dinfo : Term :=
  DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DType))
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DType))
      (DConT language_Haskell_TH_Desugar_AST_DType))

-- language_Haskell_TH_Desugar_AST_DInfo_alias (mutual reference in original)
def language_Haskell_TH_Desugar_AST_DInfo_term := dinfo

-- dtype  (DArrowT reified type)
def dtype : Term := DConT language_Haskell_TH_Desugar_AST_DType

-- dcont  (DConT reified type)
def dcont : Term :=
  DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Name))
    (DConT language_Haskell_TH_Desugar_AST_DType)

-- name  (Name reified type)
def name : Term :=
  DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_OccName))
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_NameFlavour))
      (DConT language_Haskell_TH_Syntax_Name))

-- occname
def occname : Term :=
  DAppT (DAppT DArrowT (DConT ghc_Base_String))
    (DConT language_Haskell_TH_Syntax_OccName)

-- $(stringE . show =<< dsReify Language.Haskell.TH.Syntax.NameFlavour)
def name_flavor : Term :=
  DTyConI
    (DDataD Data [] language_Haskell_TH_Syntax_NameFlavour [] none [
      DCon [] [] language_Haskell_TH_Syntax_NameS
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_NameFlavour),
      DCon [] [] language_Haskell_TH_Syntax_NameQ
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_ModName)])
        (DConT language_Haskell_TH_Syntax_NameFlavour),
      DCon [] [] language_Haskell_TH_Syntax_NameU
        (DNormalC false [
          (Bang NoSourceUnpackedness SourceStrict,
           DConT language_Haskell_TH_Syntax_Uniq)])
        (DConT language_Haskell_TH_Syntax_NameFlavour),
      DCon [] [] language_Haskell_TH_Syntax_NameL
        (DNormalC false [
          (Bang NoSourceUnpackedness SourceStrict,
           DConT language_Haskell_TH_Syntax_Uniq)])
        (DConT language_Haskell_TH_Syntax_NameFlavour),
      DCon [] [] language_Haskell_TH_Syntax_NameG
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_NameSpace),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_PkgName),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_ModName)])
        (DConT language_Haskell_TH_Syntax_NameFlavour)
    ] [])
    none

-- ddec  (reification of the DDec data type – all 18 constructors)
def ddec : Term :=
  DTyConI
    (DDataD Data [] language_Haskell_TH_Desugar_AST_DDec [] none [
      DCon [] [] language_Haskell_TH_Desugar_AST_DLetDec
        (DNormalC false [(Bang NoSourceUnpackedness NoSourceStrictness,
                          DConT language_Haskell_TH_Desugar_AST_DLetDec)])
        (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DDataD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_Util_DataFlavor),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DCxt),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Desugar_AST_DKind)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DCon)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DDerivClause))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DTySynD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DType)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DClassD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DCxt),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Syntax_FunDep)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DDec))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DInstanceD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Syntax_Overlap)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe)
                 (DAppT (DConT GHC_Types_empty_array)
                        (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit))),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DCxt),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DType),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DDec))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DForeignD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DForeign)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DOpenTypeFamilyD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DTypeFamilyHead)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DClosedTypeFamilyD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DTypeFamilyHead),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DTySynEqn))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DDataFamilyD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Desugar_AST_DKind))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DDataInstD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_Util_DataFlavor),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DCxt),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe)
                 (DAppT (DConT GHC_Types_empty_array)
                        (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit))),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DType),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Desugar_AST_DKind)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DCon)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DDerivClause))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DTySynInstD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DTySynEqn)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DRoleAnnotD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Syntax_Role))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DStandaloneDerivD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Desugar_AST_DDerivStrategy)),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe)
                 (DAppT (DConT GHC_Types_empty_array)
                        (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit))),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DCxt),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DType)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DDefaultSigD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DType)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DPatSynD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_PatSynArgs),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DPatSynDir),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DPat)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DPatSynSigD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DPatSynType)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DKiSigD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DKind)
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec),
      DCon [] [] language_Haskell_TH_Desugar_AST_DDefaultD
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DConT language_Haskell_TH_Desugar_AST_DType))
        ]) (DConT language_Haskell_TH_Desugar_AST_DDec)
    ] [])
    none

-- dinstanced  (DInstanceDec is a type synonym for DDec)
def dinstanced : Term :=
  DTyConI (DTySynD language_Haskell_TH_Desugar_AST_DInstanceDec []
    (DConT language_Haskell_TH_Desugar_AST_DDec)) none

-- dtysynd
def dtysynd : Term :=
  DVarI language_Haskell_TH_Desugar_AST_DTySynD
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Name))
      (DAppT (DAppT DArrowT
        (DAppT (DConT GHC_Types_empty_array)
          (DConT language_Haskell_TH_Desugar_AST_DTyVarBndrUnit)))
        (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DType))
          (DConT language_Haskell_TH_Desugar_AST_DDec))))
    (some language_Haskell_TH_Desugar_AST_DDec)

-- dvari
def dvari : Term :=
  DVarI language_Haskell_TH_Desugar_AST_DVarI
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Name))
      (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DType))
        (DAppT (DAppT DArrowT
          (DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Syntax_Name)))
          (DConT language_Haskell_TH_Desugar_AST_DInfo))))
    (some language_Haskell_TH_Desugar_AST_DInfo)

-- adinfo  (reification of DInfo data type)
def adinfo : Term :=
  DTyConI
    (DDataD Data [] language_Haskell_TH_Desugar_AST_DInfo [] none [
      DCon [] [] language_Haskell_TH_Desugar_AST_DTyConI
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DDec),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe)
                 (DAppT (DConT GHC_Types_empty_array)
                        (DConT language_Haskell_TH_Desugar_AST_DInstanceDec)))
        ]) (DConT language_Haskell_TH_Desugar_AST_DInfo),
      DCon [] [] language_Haskell_TH_Desugar_AST_DVarI
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DType),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Syntax_Name))
        ]) (DConT language_Haskell_TH_Desugar_AST_DInfo),
      DCon [] [] language_Haskell_TH_Desugar_AST_DTyVarI
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DKind)
        ]) (DConT language_Haskell_TH_Desugar_AST_DInfo),
      DCon [] [] language_Haskell_TH_Desugar_AST_DPrimTyConI
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT GHC_Types_Int),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT GHC_Types_Bool)
        ]) (DConT language_Haskell_TH_Desugar_AST_DInfo),
      DCon [] [] language_Haskell_TH_Desugar_AST_DPatSynI
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Desugar_AST_DPatSynType)
        ]) (DConT language_Haskell_TH_Desugar_AST_DInfo)
    ] [])
    none

-- normalc  (reification of DNormalC constructor)
def normalc : Term :=
  DVarI language_Haskell_TH_Desugar_AST_DNormalC
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Desugar_AST_DDeclaredInfix))
      (DAppT (DAppT DArrowT
        (DAppT (DConT GHC_Types_empty_array)
          (DConT language_Haskell_TH_Desugar_AST_DBangType)))
        (DConT language_Haskell_TH_Desugar_AST_DConFields)))
    (some language_Haskell_TH_Desugar_AST_DConFields)

-- declared_infix  (DDeclaredInfix is a type synonym for Bool)
def declared_infix : Term :=
  DTyConI (DTySynD language_Haskell_TH_Desugar_AST_DDeclaredInfix []
    (DConT GHC_Types_Bool)) none

-- ghc_bool
def ghc_bool : Term :=
  DTyConI
    (DDataD Data [] GHC_Types_Bool [] none [
      DCon [] [] GHC_Types_False (DNormalC false []) (DConT GHC_Types_Bool),
      DCon [] [] GHC_Types_True  (DNormalC false []) (DConT GHC_Types_Bool)
    ] [])
    none

-- datad  (reification of TH DataD constructor)
def datad : Term :=
  DVarI language_Haskell_TH_Syntax_DataD
    (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Cxt))
      (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Name))
        (DAppT (DAppT DArrowT
          (DAppT (DConT GHC_Types_empty_array)
            (DAppT (DConT language_Haskell_TH_Syntax_TyVarBndr)
                   (DConT GHC_Tuple_unit))))
          (DAppT (DAppT DArrowT
            (DAppT (DConT GHC_Maybe) (DConT language_Haskell_TH_Syntax_Kind)))
            (DAppT (DAppT DArrowT
              (DAppT (DConT GHC_Types_empty_array)
                     (DConT language_Haskell_TH_Syntax_Con)))
              (DAppT (DAppT DArrowT
                (DAppT (DConT GHC_Types_empty_array)
                       (DConT language_Haskell_TH_Syntax_DerivClause)))
                (DConT language_Haskell_TH_Syntax_Dec)))))))
    (some language_Haskell_TH_Syntax_Dec)

-- ctx  (Cxt is a type synonym)
def ctx : Term :=
  DTyConI (DTySynD language_Haskell_TH_Syntax_Cxt []
    (DAppT (DConT GHC_Types_empty_array)
           (DConT language_Haskell_TH_Syntax_Pred)))
    none

-- th_pred  (Pred is a type synonym for Type)
def th_pred : Term :=
  DTyConI (DTySynD language_Haskell_TH_Syntax_Pred []
    (DConT language_Haskell_TH_Syntax_Type)) none

-- th_syntax_type  (reification of TH Type – all constructors)
def th_syntax_type : Term :=
  DTyConI
    (DDataD Data [] language_Haskell_TH_Syntax_Type [] none [
      DCon [] [] language_Haskell_TH_Syntax_ForallT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DAppT (DConT language_Haskell_TH_Syntax_TyVarBndr)
                        (DConT language_Haskell_TH_Syntax_Specificity))),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Cxt),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ForallVisT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DAppT (DConT GHC_Types_empty_array)
                 (DAppT (DConT language_Haskell_TH_Syntax_TyVarBndr)
                        (DConT GHC_Tuple_unit))),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_AppT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_AppKindT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Kind)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_SigT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Kind)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_VarT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ConT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_PromotedT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_InfixT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_UInfixT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Name),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ParensT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_TupleT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT GHC_Types_Int)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_UnboxedTupleT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT GHC_Types_Int)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_UnboxedSumT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_SumArity)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ArrowT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_MulArrowT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_EqualityT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ListT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_StarT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ConstraintT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_LitT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_TyLit)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_WildCardT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_ImplicitParamT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT ghc_Base_String),
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT language_Haskell_TH_Syntax_Type)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_PromotedTupleT
        (DNormalC false [
          (Bang NoSourceUnpackedness NoSourceStrictness,
           DConT GHC_Types_Int)
        ]) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_PromotedNilT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type),
      DCon [] [] language_Haskell_TH_Syntax_PromotedConsT
        (DNormalC false []) (DConT language_Haskell_TH_Syntax_Type)
    ] [])
    none

-- th_forall_t
def th_forall_t : Term :=
  DVarI language_Haskell_TH_Syntax_ForallT
    (DAppT (DAppT DArrowT
      (DAppT (DConT GHC_Types_empty_array)
        (DAppT (DConT language_Haskell_TH_Syntax_TyVarBndr)
          (DConT language_Haskell_TH_Syntax_Specificity))))
      (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Cxt))
        (DAppT (DAppT DArrowT (DConT language_Haskell_TH_Syntax_Type))
          (DConT language_Haskell_TH_Syntax_Type))))
    (some Language_Haskell_TH_Syntax_Type)

-- ============================================================
-- 5.  DsMonad class reification  (complex, faithfully translated)
-- ============================================================

-- Variable names used in DsMonad reification
def m_var  := Str "m"
def w_var  := Str "w"
def s_var  := Str "s"
def r_var  := Str "r"
def q_dsm  := Str "q"

def reify_DsMonad : Term :=
  DTyConI
    (DClassD
      [DAppT (DConT language_Haskell_TH_Syntax_Quasi) (DVarT m_var),
       DAppT (DConT Control_Monad_Fail_MonadFail) (DVarT m_var)]
      language_Haskell_TH_Desugar_Reify_DsMonad
      [DKindedTV m_var GHC_Tuple_unit
        (DAppT (DAppT DArrowT (DConT GHC_Types_Type)) (DConT GHC_Types_Type))]
      []
      [DLetDec (DSigD language_Haskell_TH_Desugar_Reify_localDeclarations
        (DAppT (DVarT m_var)
          (DAppT (DConT GHC_Types_empty_array)
            (DConT language_Haskell_TH_Syntax_Dec))))])
    (some [
      -- WriterT instance
      DInstanceD none none
        [DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad) (DVarT m_var),
         DAppT (DConT ghc_Base_Monoid) (DVarT w_var)]
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DAppT (DAppT (DConT Control_Monad_Trans_Writer_Lazy_WriterT)
            (DVarT w_var)) (DVarT m_var)))
        [],
      -- StateT instance
      DInstanceD none none
        [DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad) (DVarT m_var)]
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DAppT (DAppT (DConT Control_Monad_Trans_State_Lazy_StateT)
            (DVarT s_var)) (DVarT m_var)))
        [],
      -- ReaderT instance
      DInstanceD none none
        [DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad) (DVarT m_var)]
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DAppT (DAppT (DConT Control_Monad_Trans_Reader_ReaderT)
            (DVarT r_var)) (DVarT m_var)))
        [],
      -- RWST instance
      DInstanceD none none
        [DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad) (DVarT m_var),
         DAppT (DConT ghc_Base_Monoid) (DVarT w_var)]
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DAppT (DAppT (DAppT (DAppT (DConT Control_Monad_Trans_RWS_Lazy_RWST)
            (DVarT r_var)) (DVarT w_var)) (DVarT s_var)) (DVarT m_var)))
        [],
      -- Q instance
      DInstanceD none none []
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DConT language_Haskell_TH_Syntax_Q))
        [],
      -- IO instance
      DInstanceD none none []
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DConT GHC_Types_IO))
        [],
      -- DsM instance
      DInstanceD none none
        [DAppT (DConT language_Haskell_TH_Syntax_Quasi) (DVarT q_dsm),
         DAppT (DConT Control_Monad_Fail_MonadFail) (DVarT q_dsm)]
        (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsMonad)
          (DAppT (DConT language_Haskell_TH_Desugar_Reify_DsM) (DVarT q_dsm)))
        []
    ])
