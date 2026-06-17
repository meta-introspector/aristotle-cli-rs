import Split.AddMonoid_toZero
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.Nat
import Split.Zero_toOfNat0
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.AddMonoidWithOne

-- AddMonoidWithOne.natCast_zero from environment
-- theorem AddMonoidWithOne.natCast_zero : forall {R : Type.{u_2}} [self : AddMonoidWithOne.{u_2} R], Eq.{succ u_2} R (NatCast.natCast.{u_2} R (AddMonoidWithOne.toNatCast.{u_2} R self) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u_2} R 0 (Zero.toOfNat0.{u_2} R (AddMonoid.toZero.{u_2} R (AddMonoidWithOne.toAddMonoid.{u_2} R self))))

-- Stub: this file represents the declaration `AddMonoidWithOne.natCast_zero`.
-- In a full split, the body would be extracted from the environment.
