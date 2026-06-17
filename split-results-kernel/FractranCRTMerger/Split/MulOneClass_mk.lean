import Split.MulOne_toOne
import Split.HMul_hMul
import Split.MulOne_toMul
import Split.One_toOfNat1
import Split.MulOne
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- MulOneClass.mk from environment
-- constructor MulOneClass.mk : forall {M : Type.{u}} [toMulOne : MulOne.{u} M], (forall (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (MulOne.toMul.{u} M toMulOne)) (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M (MulOne.toOne.{u} M toMulOne))) a) a) -> (forall (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (MulOne.toMul.{u} M toMulOne)) a (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M (MulOne.toOne.{u} M toMulOne)))) a) -> (MulOneClass.{u} M)

-- Stub: this file represents the declaration `MulOneClass.mk`.
-- In a full split, the body would be extracted from the environment.
