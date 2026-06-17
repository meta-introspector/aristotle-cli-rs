import Split.Nat_gcd
import Split.Eq_mpr
import Split.Nat_Coprime
import Split.Int_instDiv
import Split.instHDiv
import Split.congrArg
import Split.Int_natAbs_ediv_of_dvd
import Split.Rat_normalize_dvd_num
import Split.Eq_rec
import Split.id
import Split.HDiv_hDiv
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Nat_coprime_div_gcd_div_gcd
import Split.Nat_pos_of_ne_zero
import Split.Nat_gcd_pos_of_pos_right
import Split.Nat
import Split.Int_natAbs
import Split.Nat_instDiv
import Split.Eq_refl
import Split.instNatCastInt
import Split.Int_natAbs_natCast
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq

-- Rat.normalize.reduced from environment
-- theorem Rat.normalize.reduced : forall {num : Int} {den : Nat} {g : Nat}, (Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Nat g (Nat.gcd (Int.natAbs num) den)) -> (Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g))

-- Stub: this file represents the declaration `Rat.normalize.reduced`.
-- In a full split, the body would be extracted from the environment.
