import Split.Semiring_toNatCast
import Split.IntCast_intCast
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.instNatCastInt
import Split.Ring_toIntCast
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring

-- Ring.intCast_ofNat from environment
-- theorem Ring.intCast_ofNat : forall {R : Type.{u}} [self : Ring.{u} R] (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R (Ring.toIntCast.{u} R self) (Nat.cast.{0} Int instNatCastInt n)) (Nat.cast.{u} R (Semiring.toNatCast.{u} R (Ring.toSemiring.{u} R self)) n)

-- Stub: this file represents the declaration `Ring.intCast_ofNat`.
-- In a full split, the body would be extracted from the environment.
