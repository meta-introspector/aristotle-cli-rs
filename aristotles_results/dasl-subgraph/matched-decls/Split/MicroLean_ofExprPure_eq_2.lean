import Split.Option_some
import Split.Lean_Expr
import Split.instDecidableEqBool
import Split.MicroLean_ofExpr_match_1
import Split.MicroLean_exprNoBVars
import Split.Lean_Expr_forallE
import Split.Bool_true
import Split.Option_none
import Split.MicroLean_MicroLeanType
import Split.MicroLean_ofExprPure
import Split.Bool
import Split.Lean_Name
import Split.Eq_refl
import Split.Lean_BinderInfo
import Split.Eq
import Split.Option
import Split.MicroLean_MicroLeanType_function
import Split.ite

-- MicroLean.ofExprPure.eq_2 from environment
-- theorem MicroLean.ofExprPure.eq_2 : forall (binderName : Lean.Name) (d : Lean.Expr) (b : Lean.Expr) (binderInfo : Lean.BinderInfo), Eq.{1} (Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure (Lean.Expr.forallE binderName d b binderInfo)) (ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (MicroLean.exprNoBVars b) Bool.true) (instDecidableEqBool (MicroLean.exprNoBVars b) Bool.true) (MicroLean.ofExpr.match_1.{1} (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.93 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.95 : Option.{0} MicroLean.MicroLeanType) => Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure d) (MicroLean.ofExprPure b) (fun (dd : MicroLean.MicroLeanType) (cc : MicroLean.MicroLeanType) => Option.some.{0} MicroLean.MicroLeanType (MicroLean.MicroLeanType.function dd cc)) (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.119 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.118 : Option.{0} MicroLean.MicroLeanType) => Option.none.{0} MicroLean.MicroLeanType)) (Option.none.{0} MicroLean.MicroLeanType))

-- Stub: this file represents the declaration `MicroLean.ofExprPure.eq_2`.
-- In a full split, the body would be extracted from the environment.
