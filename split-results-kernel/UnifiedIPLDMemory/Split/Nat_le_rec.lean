import Split.Nat_le_step
import Split.Nat_le
import Split.Nat
import Split.Nat_le_refl
import Split.Nat_succ

-- Nat.le.rec from environment
-- recursor Nat.le.rec : forall {n : Nat} {motive : forall (a._@._internal._hyg.0 : Nat), (Nat.le n a._@._internal._hyg.0) -> Prop}, (motive n (Nat.le.refl n)) -> (forall {m : Nat} (a._@._internal._hyg.0 : Nat.le n m), (motive m a._@._internal._hyg.0) -> (motive (Nat.succ m) (Nat.le.step n m a._@._internal._hyg.0))) -> (forall {a._@._internal._hyg.0 : Nat} (t : Nat.le n a._@._internal._hyg.0), motive a._@._internal._hyg.0 t)

-- Stub: this file represents the declaration `Nat.le.rec`.
-- In a full split, the body would be extracted from the environment.
