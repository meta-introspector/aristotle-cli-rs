import Split.Int_instAddCommMonoid
import Split.HMul_hMul
import Split.Finset_univ
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Fin_fintype
import Split.Int_instMul
import Split.instOfNat
import Split.Nat
import Split.MonsterRepCategory_CharacterOrthogonality
import Split.instNatCastInt
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.Finset_sum
import Split.instHMul

-- MonsterRepCategory.CharacterOrthogonality.row_orthog from environment
-- theorem MonsterRepCategory.CharacterOrthogonality.row_orthog : forall {χ : (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) -> (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) -> Int} {classSize : (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) -> Nat} {groupOrder : Nat}, (MonsterRepCategory.CharacterOrthogonality χ classSize groupOrder) -> (forall (i : Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) (l : Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))), (Ne.{1} (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) i l) -> (Eq.{1} Int (Finset.sum.{0, 0} (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) Int Int.instAddCommMonoid (Finset.univ.{0} (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) (Fin.fintype (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194)))) (fun (j : Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) => HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Nat.cast.{0} Int instNatCastInt (classSize j)) (χ i j)) (χ l j))) (OfNat.ofNat.{0} Int 0 (instOfNat 0))))

-- Stub: this file represents the declaration `MonsterRepCategory.CharacterOrthogonality.row_orthog`.
-- In a full split, the body would be extracted from the environment.
