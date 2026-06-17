import Split.MulOne_toOne
import Split.HMul_hMul
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.One_toOfNat1
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- MulOneClass.mul_one from environment
-- theorem MulOneClass.mul_one : forall {M : Type.{u}} [self : MulOneClass.{u} M] (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (MulOne.toMul.{u} M (MulOneClass.toMulOne.{u} M self))) a (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M (MulOne.toOne.{u} M (MulOneClass.toMulOne.{u} M self))))) a

-- Stub: this file represents the declaration `MulOneClass.mul_one`.
-- In a full split, the body would be extracted from the environment.
