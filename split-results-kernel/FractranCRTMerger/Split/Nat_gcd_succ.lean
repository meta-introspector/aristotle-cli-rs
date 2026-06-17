import Split.Nat_gcd
import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.HMod_hMod
import Split.Nat
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.ite

-- Nat.gcd_succ from environment
-- theorem Nat.gcd_succ : forall (x : Nat) (y : Nat), Eq.{1} Nat (Nat.gcd (Nat.succ x) y) (Nat.gcd (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) y (Nat.succ x)) (Nat.succ x))

-- Stub: this file represents the declaration `Nat.gcd_succ`.
-- In a full split, the body would be extracted from the environment.
