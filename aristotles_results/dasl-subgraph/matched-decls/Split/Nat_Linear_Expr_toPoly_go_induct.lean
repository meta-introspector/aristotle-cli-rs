import Split.Nat_Linear_Expr_below
import Split.Eq_mpr
import Split.HMul_hMul
import Split.Nat_Linear_Expr_mulL
import Split.Nat_Linear_Expr
import Split.id
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_Linear_Expr_num
import Split.instBEqOfDecidableEq
import Split.Nat_Linear_Expr_brecOn
import Split.Bool_true
import Split.Nat_Linear_Var
import Split.BEq_beq
import Split.Nat
import Split.Bool
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.Nat_Linear_Expr_add
import Split.Nat_Linear_Expr_mulR
import Split.OfNat_ofNat
import Split.Bool_false
import Split.Eq
import Split.instHMul
import Split.Nat_Linear_Expr_var
import Split.Bool_dcond

-- Nat.Linear.Expr.toPoly.go.induct from environment
-- theorem Nat.Linear.Expr.toPoly.go.induct : forall (motive : Nat -> Nat.Linear.Expr -> Prop), (forall (coeff : Nat) (k : Nat), (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.true) -> (motive coeff (Nat.Linear.Expr.num k))) -> (forall (coeff : Nat) (k : Nat), (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.false) -> (motive coeff (Nat.Linear.Expr.num k))) -> (forall (coeff : Nat) (i : Nat.Linear.Var), motive coeff (Nat.Linear.Expr.var i)) -> (forall (coeff : Nat) (a : Nat.Linear.Expr) (b : Nat.Linear.Expr), (motive coeff a) -> (motive coeff b) -> (motive coeff (Nat.Linear.Expr.add a b))) -> (forall (coeff : Nat) (k : Nat) (a : Nat.Linear.Expr), (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.true) -> (motive coeff (Nat.Linear.Expr.mulL k a))) -> (forall (coeff : Nat) (k : Nat) (a : Nat.Linear.Expr), (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.false) -> (motive (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) coeff k) a) -> (motive coeff (Nat.Linear.Expr.mulL k a))) -> (forall (coeff : Nat) (a : Nat.Linear.Expr) (k : Nat), (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.true) -> (motive coeff (Nat.Linear.Expr.mulR a k))) -> (forall (coeff : Nat) (a : Nat.Linear.Expr) (k : Nat), (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.false) -> (motive (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) coeff k) a) -> (motive coeff (Nat.Linear.Expr.mulR a k))) -> (forall (coeff : Nat) (a._@._internal._hyg.0 : Nat.Linear.Expr), motive coeff a._@._internal._hyg.0)

-- Stub: this file represents the declaration `Nat.Linear.Expr.toPoly.go.induct`.
-- In a full split, the body would be extracted from the environment.
