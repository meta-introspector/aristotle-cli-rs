import Split.MicroLean_MicroLeanType_prod
import Split.Lean_Expr_const
import Split.Option_some
import Split.Lean_Expr
import Split.instDecidableEqBool
import Split.MicroLean_ofExpr_match_1
import Split.Lean_Level
import Split.Bool_true
import Split.Option_none
import Split.List
import Split.BEq_beq
import Split.MicroLean_MicroLeanType
import Split.MicroLean_ofExprPure
import Split.Bool
import Split.Lean_Name
import Split.Lean_Expr_app
import Split.Eq_refl
import Split.Lean_Name_mkStr1
import Split.Eq
import Split.Lean_Name_instBEq
import Split.Option
import Split.ite

-- MicroLean.ofExprPure.eq_3 from environment
-- theorem MicroLean.ofExprPure.eq_3 : forall (n : Lean.Name) (us : List.{0} Lean.Level) (a : Lean.Expr) (b : Lean.Expr), Eq.{1} (Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure (Lean.Expr.app (Lean.Expr.app (Lean.Expr.const n us) a) b)) (ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Prod")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Prod")) Bool.true) (MicroLean.ofExpr.match_1.{1} (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.171 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.173 : Option.{0} MicroLean.MicroLeanType) => Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure a) (MicroLean.ofExprPure b) (fun (aa : MicroLean.MicroLeanType) (bb : MicroLean.MicroLeanType) => Option.some.{0} MicroLean.MicroLeanType (MicroLean.MicroLeanType.prod aa bb)) (fun (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.197 : Option.{0} MicroLean.MicroLeanType) (x._@.RequestProject.MicroLean.1915777129._hygCtx._hyg.196 : Option.{0} MicroLean.MicroLeanType) => Option.none.{0} MicroLean.MicroLeanType)) (Option.none.{0} MicroLean.MicroLeanType))

-- Stub: this file represents the declaration `MicroLean.ofExprPure.eq_3`.
-- In a full split, the body would be extracted from the environment.
