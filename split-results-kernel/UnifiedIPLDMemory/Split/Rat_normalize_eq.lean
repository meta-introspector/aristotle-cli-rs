import Split.Rat_maybeNormalize_eq
import Split.Nat_gcd
import Split.Nat_Coprime
import Split.Int_instDiv
import Split.instHDiv
import Split.congrArg
import Split.Rat
import Split.Int_divExact
import Split.Rat_normalize_den_nz
import Split.id
import Split.HDiv_hDiv
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Rat_normalize_reduced
import Split.Nat
import Split.True
import Split.Int_natAbs
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.instNatCastInt
import Split.Rat_mk'
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl
import Split.Eq_trans

-- Rat.normalize_eq from environment
-- theorem Rat.normalize_eq : forall {num : Int} {den : Nat} (den_nz : Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} Rat (Rat.normalize num den den_nz) (Rat.mk' (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt (Nat.gcd (Int.natAbs num) den))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den (Nat.gcd (Int.natAbs num) den)) (Rat.normalize.den_nz num den (Nat.gcd (Int.natAbs num) den) den_nz (rfl.{1} Nat (Nat.gcd (Int.natAbs num) den))) (Rat.normalize.reduced num den (Nat.gcd (Int.natAbs num) den) den_nz (rfl.{1} Nat (Nat.gcd (Int.natAbs num) den))))

-- Stub: this file represents the declaration `Rat.normalize_eq`.
-- In a full split, the body would be extracted from the environment.
