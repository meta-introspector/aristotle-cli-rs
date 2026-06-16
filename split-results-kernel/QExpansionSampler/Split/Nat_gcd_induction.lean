import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.Nat_mod_lt
import Split.instHAdd
import Split.HMod_hMod
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_succ_pos
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_strongRecOn

-- Nat.gcd.induction from environment
-- theorem Nat.gcd.induction : forall {P : Nat -> Nat -> Prop} (m : Nat) (n : Nat), (forall (n : Nat), P (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) -> (forall (m : Nat) (n : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) m) -> (P (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n m) m) -> (P m n)) -> (P m n)

-- Stub: this file represents the declaration `Nat.gcd.induction`.
-- In a full split, the body would be extracted from the environment.
