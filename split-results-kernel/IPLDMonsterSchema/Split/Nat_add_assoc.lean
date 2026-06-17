import Split.congrArg
import Split.Nat_brecOn
import Split.instOfNatNat
import Split.Nat_below
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_add
import Split.rfl

-- Nat.add_assoc from environment
-- theorem Nat.add_assoc : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k))

-- Stub: this file represents the declaration `Nat.add_assoc`.
-- In a full split, the body would be extracted from the environment.
