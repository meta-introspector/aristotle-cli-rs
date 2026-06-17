import Split.Eq_mpr
import Split.False
import Split.MicroLean_MicroLeanType_bool
import Split.Lean_Expr_brecOn
import Split.congrArg
import Split.MicroLean_MicroLeanType_prod
import Split.Lean_Expr_const
import Split.Option_some
import Split.Lean_MVarId
import Split.Lean_Expr
import Split.id
import Split.MicroLean_ofExprPure_match_1
import Split.Lean_FVarId
import Split.instDecidableEqBool
import Split.MicroLean_MicroLeanType_nat
import Split.MicroLean_ofExpr_match_1
import Split.Lean_Level
import Split.Lean_Literal
import Split.MicroLean_exprNoBVars
import Split.Lean_Expr_forallE
import Split.Bool_true
import Split.Option_none
import Split.List
import Split.Option_map
import Split.BEq_beq
import Split.Lean_Expr_brecOn_eq
import Split.PProd
import Split.congrFun
import Split.PUnit
import Split.Lean_MData
import Split.Nat
import Split.congr
import Split.MicroLean_MicroLeanType
import Split.MicroLean_ofExprPure
import Split.Bool
import Split.Eq_ndrec
import Split.Lean_Name
import Split.Lean_Expr_app
import Split.Eq_refl
import Split.MicroLean_MicroLeanType_array
import Split.Lean_BinderInfo
import Split.Eq_symm
import Split.Lean_Name_mkStr1
import Split.Eq
import Split.Lean_Expr_below
import Split.Lean_Name_instBEq
import Split.Lean_Expr_rec
import Split.Lean_Expr_brecOn_go
import Split.Option
import Split.MicroLean_MicroLeanType_function
import Split.ite

-- MicroLean.ofExprPure.eq_def from environment
-- theorem MicroLean.ofExprPure.eq_def : forall (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.6 : Lean.Expr), Eq.{1} (Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.6) (MicroLean.ofExprPure.match_1.{1} (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx.6.RequestProject.MicroLean.1915777129._hygCtx._hyg.17 : Lean.Expr) => Option.{0} MicroLean.MicroLeanType) x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.6 (fun (n : Lean.Name) (us._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.28 : List.{0} Lean.Level) => ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Nat")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Nat")) Bool.true) (Option.some.{0} MicroLean.MicroLeanType MicroLean.MicroLeanType.nat) (ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Bool")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Bool")) Bool.true) (Option.some.{0} MicroLean.MicroLeanType MicroLean.MicroLeanType.bool) (Option.none.{0} MicroLean.MicroLeanType))) (fun (binderName._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.69 : Lean.Name) (d : Lean.Expr) (b : Lean.Expr) (binderInfo._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.70 : Lean.BinderInfo) => ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (MicroLean.exprNoBVars b) Bool.true) (instDecidableEqBool (MicroLean.exprNoBVars b) Bool.true) (MicroLean.ofExpr.match_1.{1} (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.93 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.95 : Option.{0} MicroLean.MicroLeanType) => Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure d) (MicroLean.ofExprPure b) (fun (dd : MicroLean.MicroLeanType) (cc : MicroLean.MicroLeanType) => Option.some.{0} MicroLean.MicroLeanType (MicroLean.MicroLeanType.function dd cc)) (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.119 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.118 : Option.{0} MicroLean.MicroLeanType) => Option.none.{0} MicroLean.MicroLeanType)) (Option.none.{0} MicroLean.MicroLeanType)) (fun (n : Lean.Name) (us._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.145 : List.{0} Lean.Level) (a : Lean.Expr) (b : Lean.Expr) => ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Prod")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Prod")) Bool.true) (MicroLean.ofExpr.match_1.{1} (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.171 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.173 : Option.{0} MicroLean.MicroLeanType) => Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure a) (MicroLean.ofExprPure b) (fun (aa : MicroLean.MicroLeanType) (bb : MicroLean.MicroLeanType) => Option.some.{0} MicroLean.MicroLeanType (MicroLean.MicroLeanType.prod aa bb)) (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.197 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.196 : Option.{0} MicroLean.MicroLeanType) => Option.none.{0} MicroLean.MicroLeanType)) (Option.none.{0} MicroLean.MicroLeanType)) (fun (n : Lean.Name) (us._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.219 : List.{0} Lean.Level) (a : Lean.Expr) => ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Array")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Array")) Bool.true) (Option.map.{0, 0} MicroLean.MicroLeanType MicroLean.MicroLeanType MicroLean.MicroLeanType.array (MicroLean.ofExprPure a)) (Option.none.{0} MicroLean.MicroLeanType)) (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.242 : Lean.Expr) => Option.none.{0} MicroLean.MicroLeanType))

-- Stub: this file represents the declaration `MicroLean.ofExprPure.eq_def`.
-- In a full split, the body would be extracted from the environment.
