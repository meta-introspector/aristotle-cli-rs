import Split.Nat_le_rec
import Split.Nat_le_step
import Split.Nat_le
import Split.Nat
import Split.Nat_le_refl
import Split.Nat_succ

-- Nat.le.casesOn from environment
-- def Nat.le.casesOn : forall {n : Nat} {motive : forall (a._@._internal._hyg.0 : Nat), (Nat.le n a._@._internal._hyg.0) -> Prop} {a._@._internal._hyg.0 : Nat} (t : Nat.le n a._@._internal._hyg.0), (motive n (Nat.le.refl n)) -> (forall {m : Nat} (a._@._internal._hyg.0 : Nat.le n m), motive (Nat.succ m) (Nat.le.step n m a._@._internal._hyg.0)) -> (motive a._@._internal._hyg.0 t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.le.casesOn`.
-- In a full split, the body would be extracted from the environment.
