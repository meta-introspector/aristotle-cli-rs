import Split.Nontrivial
import Split.Semiring_toNatCast
import Split.Int_cast
import Split.CommRing
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
import Split.AddCommMonoid_toAddMonoid
import Split.instNatCastInt
import Split.Int_negSucc
import Split.CommRing_toRing
import Split.Ring_toIntCast
import Split.OfNat_ofNat
import Split.NNRat_cast
import Split.Ring_toSemiring
import Split.Nat_succ
import Split.Eq
import Split.Field
import Split.instHMul

-- Field.mk from environment
-- constructor Field.mk : forall {K : Type.{u}} [toCommRing : CommRing.{u} K] [toInv : Inv.{u} K] [toDiv : Div.{u} K], (autoParam.{0} (forall (a : K) (b : K), Eq.{succ u} K (HDiv.hDiv.{u, u, u} K K K (instHDiv.{u} K toDiv) a b) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))) a (Inv.inv.{u} K toInv b))) DivInvMonoid.div_eq_mul_inv._autoParam) -> (forall (zpow : Int -> K -> K), (autoParam.{0} (forall (a : K), Eq.{succ u} K (zpow (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} K 1 (One.toOfNat1.{u} K (Semiring.toOne.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))) DivInvMonoid.zpow_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : K), Eq.{succ u} K (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))) (zpow (Nat.cast.{0} Int instNatCastInt n) a) a)) DivInvMonoid.zpow_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : K), Eq.{succ u} K (zpow (Int.negSucc n) a) (Inv.inv.{u} K toInv (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) DivInvMonoid.zpow_neg'._autoParam) -> (forall [toNontrivial : Nontrivial.{u} K] [toNNRatCast : NNRatCast.{u} K] [toRatCast : RatCast.{u} K], (forall (a : K), (Ne.{succ u} K a (OfNat.ofNat.{u} K 0 (Zero.toOfNat0.{u} K (AddMonoid.toZero.{u} K (AddCommMonoid.toAddMonoid.{u} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))))))) -> (Eq.{succ u} K (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))) a (Inv.inv.{u} K toInv a)) (OfNat.ofNat.{u} K 1 (One.toOfNat1.{u} K (Semiring.toOne.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing))))))) -> (Eq.{succ u} K (Inv.inv.{u} K toInv (OfNat.ofNat.{u} K 0 (Zero.toOfNat0.{u} K (AddMonoid.toZero.{u} K (AddCommMonoid.toAddMonoid.{u} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))))))) (OfNat.ofNat.{u} K 0 (Zero.toOfNat0.{u} K (AddMonoid.toZero.{u} K (AddCommMonoid.toAddMonoid.{u} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))))))) -> (autoParam.{0} (forall (q : NNRat), Eq.{succ u} K (NNRat.cast.{u} K toNNRatCast q) (HDiv.hDiv.{u, u, u} K K K (instHDiv.{u} K toDiv) (Nat.cast.{u} K (Semiring.toNatCast.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing))) (NNRat.num q)) (Nat.cast.{u} K (Semiring.toNatCast.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing))) (NNRat.den q)))) DivisionRing.nnratCast_def._autoParam) -> (forall (nnqsmul : NNRat -> K -> K), (autoParam.{0} (forall (q : NNRat) (a : K), Eq.{succ u} K (nnqsmul q a) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))) (NNRat.cast.{u} K toNNRatCast q) a)) DivisionRing.nnqsmul_def._autoParam) -> (autoParam.{0} (forall (q : Rat), Eq.{succ u} K (Rat.cast.{u} K toRatCast q) (HDiv.hDiv.{u, u, u} K K K (instHDiv.{u} K toDiv) (Int.cast.{u} K (Ring.toIntCast.{u} K (CommRing.toRing.{u} K toCommRing)) (Rat.num q)) (Nat.cast.{u} K (Semiring.toNatCast.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing))) (Rat.den q)))) DivisionRing.ratCast_def._autoParam) -> (forall (qsmul : Rat -> K -> K), (autoParam.{0} (forall (a : Rat) (x : K), Eq.{succ u} K (qsmul a x) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K toCommRing)))))) (Rat.cast.{u} K toRatCast a) x)) DivisionRing.qsmul_def._autoParam) -> (Field.{u} K)))))

-- Stub: this file represents the declaration `Field.mk`.
-- In a full split, the body would be extracted from the environment.
