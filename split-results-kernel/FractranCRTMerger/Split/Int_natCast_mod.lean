import Split.Nat_instMod
import Split.instHMod
import Split.Int
import Split.Nat_cast
import Split.HMod_hMod
import Split.Nat
import Split.Int_instMod
import Split.instNatCastInt
import Split.Eq
import Split.rfl

-- Int.natCast_mod from environment
-- theorem Int.natCast_mod : forall (m : Nat) (n : Nat), Eq.{1} Int (Nat.cast.{0} Int instNatCastInt (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) m n)) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (Nat.cast.{0} Int instNatCastInt m) (Nat.cast.{0} Int instNatCastInt n))

-- Stub: this file represents the declaration `Int.natCast_mod`.
-- In a full split, the body would be extracted from the environment.
