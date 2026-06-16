import Split.Nat_Prime
import Split.Preorder_toLT
import Split.Dvd_dvd
import Split.of_decide_eq_true
import Split.Nat_le_add_left
import Split.Eq_rec
import Split.id
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.and_congr_right
import Split.Nat_casesAuxOn
import Split.Bool_true
import Split.instHAdd
import Split.And
import Split.Iff
import Split.Nat_instDvd
import Split.HAdd_hAdd
import Split.Not_elim
import Split.Nat_instPreorder
import Split.Nat
import Split.LT_lt
import Split.Nat_prime_def_lt
import Split.Iff_intro
import Split.Decidable_byContradiction
import Split.forall_congr'
import Split.Iff_trans
import Split.Bool
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Decidable_decide
import Split.Eq
import Split.Not
import Split.not_lt_of_ge

-- Nat.prime_def_lt' from environment
-- theorem Nat.prime_def_lt' : forall {p : Nat}, Iff (Nat.Prime p) (And (LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) p) (forall (m : Nat), (LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) m) -> (LT.lt.{0} Nat instLTNat m p) -> (Not (Dvd.dvd.{0} Nat Nat.instDvd m p))))

-- Stub: this file represents the declaration `Nat.prime_def_lt'`.
-- In a full split, the body would be extracted from the environment.
