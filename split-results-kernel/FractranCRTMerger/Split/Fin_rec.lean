import Split.Fin_mk
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.Fin

-- Fin.rec from environment
-- recursor Fin.rec : forall {n : Nat} {motive : (Fin n) -> Sort.{u}}, (forall (val : Nat) (isLt : LT.lt.{0} Nat instLTNat val n), motive (Fin.mk n val isLt)) -> (forall (t : Fin n), motive t)

-- Stub: this file represents the declaration `Fin.rec`.
-- In a full split, the body would be extracted from the environment.
