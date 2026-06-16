import Split.HMul_hMul
import Split.instMulNat
import Split.Int
import Split.Nat_cast
import Split.Int_instMul
import Split.Nat
import Split.instNatCastInt
import Split.Eq
import Split.rfl
import Split.instHMul

-- Int.natCast_mul from environment
-- theorem Int.natCast_mul : forall (n : Nat) (m : Nat), Eq.{1} Int (Nat.cast.{0} Int instNatCastInt (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m)) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Nat.cast.{0} Int instNatCastInt n) (Nat.cast.{0} Int instNatCastInt m))

-- Stub: this file represents the declaration `Int.natCast_mul`.
-- In a full split, the body would be extracted from the environment.
