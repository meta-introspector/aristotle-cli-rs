import Split.Lean_Expr_const
import Split.Lean_Expr
import Split.instDecidableEqBool
import Split.Lean_Level
import Split.Bool_true
import Split.Option_none
import Split.List
import Split.Option_map
import Split.BEq_beq
import Split.MicroLean_MicroLeanType
import Split.MicroLean_ofExprPure
import Split.Bool
import Split.Lean_Name
import Split.Lean_Expr_app
import Split.Eq_refl
import Split.MicroLean_MicroLeanType_array
import Split.Lean_Name_mkStr1
import Split.Eq
import Split.Lean_Name_instBEq
import Split.Option
import Split.ite

-- MicroLean.ofExprPure.eq_4 from environment
-- theorem MicroLean.ofExprPure.eq_4 : forall (n : Lean.Name) (us : List.{0} Lean.Level) (a : Lean.Expr), Eq.{1} (Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure (Lean.Expr.app (Lean.Expr.const n us) a)) (ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Array")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Array")) Bool.true) (Option.map.{0, 0} MicroLean.MicroLeanType MicroLean.MicroLeanType MicroLean.MicroLeanType.array (MicroLean.ofExprPure a)) (Option.none.{0} MicroLean.MicroLeanType))

-- Stub: this file represents the declaration `MicroLean.ofExprPure.eq_4`.
-- In a full split, the body would be extracted from the environment.
