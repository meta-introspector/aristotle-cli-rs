import Split.HSub_hSub
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.And
import Split.instHSub
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Not

-- Nat.div.inductionOn from environment
-- def Nat.div.inductionOn : forall {motive : Nat -> Nat -> Sort.{u}} (x : Nat) (y : Nat), (forall (x : Nat) (y : Nat), (And (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (LE.le.{0} Nat instLENat y x)) -> (motive (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x y) y) -> (motive x y)) -> (forall (x : Nat) (y : Nat), (Not (And (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (LE.le.{0} Nat instLENat y x))) -> (motive x y)) -> (motive x y)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.div.inductionOn`.
-- In a full split, the body would be extracted from the environment.
