import Split.MicroLean_MicroLeanType_bool
import Split.Lean_Expr_const
import Split.Option_some
import Split.instDecidableEqBool
import Split.MicroLean_MicroLeanType_nat
import Split.Lean_Level
import Split.Bool_true
import Split.Option_none
import Split.List
import Split.BEq_beq
import Split.MicroLean_MicroLeanType
import Split.MicroLean_ofExprPure
import Split.Bool
import Split.Lean_Name
import Split.Eq_refl
import Split.Lean_Name_mkStr1
import Split.Eq
import Split.Lean_Name_instBEq
import Split.Option
import Split.ite

-- MicroLean.ofExprPure.eq_1 from environment
-- theorem MicroLean.ofExprPure.eq_1 : forall (n : Lean.Name) (us : List.{0} Lean.Level), Eq.{1} (Option.{0} MicroLean.MicroLeanType) (MicroLean.ofExprPure (Lean.Expr.const n us)) (ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Nat")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Nat")) Bool.true) (Option.some.{0} MicroLean.MicroLeanType MicroLean.MicroLeanType.nat) (ite.{1} (Option.{0} MicroLean.MicroLeanType) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Bool")) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq n (Lean.Name.mkStr1 "Bool")) Bool.true) (Option.some.{0} MicroLean.MicroLeanType MicroLean.MicroLeanType.bool) (Option.none.{0} MicroLean.MicroLeanType)))

-- Stub: this file represents the declaration `MicroLean.ofExprPure.eq_1`.
-- In a full split, the body would be extracted from the environment.
