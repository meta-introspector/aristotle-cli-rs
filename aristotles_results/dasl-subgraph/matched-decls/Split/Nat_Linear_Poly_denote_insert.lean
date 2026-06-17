import Split.Nat_blt
import Split.cond
import Split.List_brecOn
import Split.Eq_mpr
import Split.Nat_Linear_Poly_insert
import Split.HMul_hMul
import Split.Nat_Linear_Poly_denote
import Split.congrArg
import Split.Nat_right_distrib
import Split.Nat_Linear_Poly
import Split.id
import Split.Nat_beq
import Split.instDecidableEqBool
import Split.Prod_mk
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_add_left_comm
import Split.dite
import Split.List_cons
import Split.Bool_true
import Split.List
import Split.instHAdd
import Split.Nat_Linear_Var
import Split.Unit
import Split.Nat_Linear_Var_denote
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.Nat_Linear_Context
import Split.Bool_of_not_eq_true
import Split.eq_self
import Split.Nat_add_assoc
import Split.Bool
import Split.of_eq_true
import Split.instAddNat
import Split.Nat_eq_of_beq_eq_true
import Split.List_below
import Split.congrFun'
import Split.Nat_mul
import Split.Nat_zero_add
import Split.Prod
import Split.OfNat_ofNat
import Split.Bool_false
import Split.Eq
import Split.Not
import Split.Nat_add
import Split.Eq_trans
import Split.instHMul
import Split.List_nil
import Split.Nat_add_comm

-- Nat.Linear.Poly.denote_insert from environment
-- theorem Nat.Linear.Poly.denote_insert : forall (ctx : Nat.Linear.Context) (k : Nat) (v : Nat.Linear.Var) (p : Nat.Linear.Poly), Eq.{1} Nat (Nat.Linear.Poly.denote ctx (Nat.Linear.Poly.insert k v p)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Nat.Linear.Poly.denote ctx p) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k (Nat.Linear.Var.denote ctx v)))

-- Stub: this file represents the declaration `Nat.Linear.Poly.denote_insert`.
-- In a full split, the body would be extracted from the environment.
