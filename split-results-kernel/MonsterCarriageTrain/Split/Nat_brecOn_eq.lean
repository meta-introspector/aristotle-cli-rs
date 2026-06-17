import Split.Nat_brecOn_go
import Split.Nat_brecOn
import Split.Nat_below
import Split.Nat
import Split.Nat_zero
import Split.Eq_refl
import Split.Nat_succ
import Split.Eq
import Split.Nat_casesOn

-- Nat.brecOn.eq from environment
-- theorem Nat.brecOn.eq : forall {motive : Nat -> Sort.{u}} (t : Nat) (F_1 : forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)), Eq.{u} (motive t) (Nat.brecOn.{u} motive t F_1) (F_1 t ((Nat.brecOn.go.{u} motive t F_1).2))

-- Stub: this file represents the declaration `Nat.brecOn.eq`.
-- In a full split, the body would be extracted from the environment.
