import Split.Nontrivial
import Split.Semiring_toNatCast
import Split.Int_cast
import Split.Rat_num
import Split.instHDiv
import Split.Inv
import Split.Semiring_toOne
import Split.HMul_hMul
import Split.NNRatCast
import Split.Rat
import Split.AddMonoid_toZero
import Split.Rat_den
import Split.NonUnitalNonAssocSemiring_toMul
import Split.HDiv_hDiv
import Split.Div
import Split.Rat_cast
import Split.NNRat
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Ne
import Split.Int
import Split.NNRat_num
import Split.Nat_cast
import Split.autoParam
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.NNRat_den
import Split.Inv_inv
import Split.instOfNat
import Split.RatCast
import Split.Nat
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.DivisionRing
import Split.AddCommMonoid_toAddMonoid
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Ring_toIntCast
import Split.OfNat_ofNat
import Split.NNRat_cast
import Split.Ring_toSemiring
import Split.Nat_succ
import Split.Eq
import Split.Ring
import Split.instHMul

-- DivisionRing.mk from environment
-- constructor DivisionRing.mk : forall {K : Type.{u_2}} [toRing : Ring.{u_2} K] [toInv : Inv.{u_2} K] [toDiv : Div.{u_2} K], (autoParam.{0} (forall (a : K) (b : K), Eq.{succ u_2} K (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K toDiv) a b) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))) a (Inv.inv.{u_2} K toInv b))) DivInvMonoid.div_eq_mul_inv._autoParam) -> (forall (zpow : Int -> K -> K), (autoParam.{0} (forall (a : K), Eq.{succ u_2} K (zpow (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u_2} K 1 (One.toOfNat1.{u_2} K (Semiring.toOne.{u_2} K (Ring.toSemiring.{u_2} K toRing))))) DivInvMonoid.zpow_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : K), Eq.{succ u_2} K (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))) (zpow (Nat.cast.{0} Int instNatCastInt n) a) a)) DivInvMonoid.zpow_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : K), Eq.{succ u_2} K (zpow (Int.negSucc n) a) (Inv.inv.{u_2} K toInv (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) DivInvMonoid.zpow_neg'._autoParam) -> (forall [toNontrivial : Nontrivial.{u_2} K] [toNNRatCast : NNRatCast.{u_2} K] [toRatCast : RatCast.{u_2} K], (forall (a : K), (Ne.{succ u_2} K a (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))))))) -> (Eq.{succ u_2} K (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))) a (Inv.inv.{u_2} K toInv a)) (OfNat.ofNat.{u_2} K 1 (One.toOfNat1.{u_2} K (Semiring.toOne.{u_2} K (Ring.toSemiring.{u_2} K toRing)))))) -> (Eq.{succ u_2} K (Inv.inv.{u_2} K toInv (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))))))) (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))))))) -> (autoParam.{0} (forall (q : NNRat), Eq.{succ u_2} K (NNRat.cast.{u_2} K toNNRatCast q) (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K toDiv) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (Ring.toSemiring.{u_2} K toRing)) (NNRat.num q)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (Ring.toSemiring.{u_2} K toRing)) (NNRat.den q)))) DivisionRing.nnratCast_def._autoParam) -> (forall (nnqsmul : NNRat -> K -> K), (autoParam.{0} (forall (q : NNRat) (a : K), Eq.{succ u_2} K (nnqsmul q a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))) (NNRat.cast.{u_2} K toNNRatCast q) a)) DivisionRing.nnqsmul_def._autoParam) -> (autoParam.{0} (forall (q : Rat), Eq.{succ u_2} K (Rat.cast.{u_2} K toRatCast q) (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K toDiv) (Int.cast.{u_2} K (Ring.toIntCast.{u_2} K toRing) (Rat.num q)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (Ring.toSemiring.{u_2} K toRing)) (Rat.den q)))) DivisionRing.ratCast_def._autoParam) -> (forall (qsmul : Rat -> K -> K), (autoParam.{0} (forall (a : Rat) (x : K), Eq.{succ u_2} K (qsmul a x) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K toRing))))) (Rat.cast.{u_2} K toRatCast a) x)) DivisionRing.qsmul_def._autoParam) -> (DivisionRing.{u_2} K)))))

-- Stub: this file represents the declaration `DivisionRing.mk`.
-- In a full split, the body would be extracted from the environment.
