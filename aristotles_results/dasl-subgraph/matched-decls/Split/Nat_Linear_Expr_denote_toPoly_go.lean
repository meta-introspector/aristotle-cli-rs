import Split.cond
import Split.BEq_rfl
import Split.HMul_hMul
import Split.Nat_mul_one
import Split.Nat_Linear_Poly_denote
import Split.congrArg
import Split.Lean_RArray_get
import Split.Nat_Linear_Expr_mulL
import Split.Nat_Linear_Poly
import Split.Nat_Linear_Expr_toPoly_go_induct
import Split.Nat_Linear_Expr
import Split.id
import Split.Nat_beq
import Split.Prod_mk
import Split.Nat_Linear_Expr_toPoly_go
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_comm
import Split.Nat_Linear_Expr_num
import Split.instBEqOfDecidableEq
import Split.Nat_mul_assoc
import Split.List_cons
import Split.Nat_Linear_Expr_denote
import Split.Nat_zero_mul
import Split.Nat_Linear_fixedVar
import Split.Bool_true
import Split.funext
import Split.List
import Split.instHAdd
import Split.Nat_Linear_Var
import Split.BEq_beq
import Split.Nat_Linear_Var_denote
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.Nat_Linear_Context
import Split.eq_self
import Split.Bool_rec
import Split.Nat_add_assoc
import Split.Bool
import Split.of_eq_true
import Split.LawfulBEq_toReflBEq
import Split.instAddNat
import Split.congrFun'
import Split.instDecidableEqNat
import Split.Nat_Linear_Expr_add
import Split.Nat_mul
import Split.LawfulBEq_eq_of_beq
import Split.Nat_left_distrib
import Split.Nat_zero_add
import Split.Nat_instLawfulBEq
import Split.Nat_Linear_Expr_mulR
import Split.Prod
import Split.OfNat_ofNat
import Split.Bool_false
import Split.Eq
import Split.Nat_beq_refl
import Split.Eq_trans
import Split.instHMul
import Split.Nat_Linear_Expr_var
import Split.Nat_add_comm

-- Nat.Linear.Expr.denote_toPoly_go from environment
-- theorem Nat.Linear.Expr.denote_toPoly_go : forall {k : Nat} {p : Nat.Linear.Poly} (ctx : Nat.Linear.Context) (e : Nat.Linear.Expr), Eq.{1} Nat (Nat.Linear.Poly.denote ctx (Nat.Linear.Expr.toPoly.go k e p)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k (Nat.Linear.Expr.denote ctx e)) (Nat.Linear.Poly.denote ctx p))

-- Stub: this file represents the declaration `Nat.Linear.Expr.denote_toPoly_go`.
-- In a full split, the body would be extracted from the environment.
