import Split.BottNested_LimoCarriage_noConfusion
import Split.id
import Split.BottNested_LimoCarriage
import Split.Nat
import Split.BottNested_LimoCarriage_mk
import Split.Eq
import Split.BottNested_NestedCarriage

-- BottNested.LimoCarriage.mk.noConfusion from environment
-- def BottNested.LimoCarriage.mk.noConfusion : forall {P : Sort.{u}} {grade : Nat} {nested : BottNested.NestedCarriage} {capacity : Nat} {grade' : Nat} {nested' : BottNested.NestedCarriage} {capacity' : Nat}, (Eq.{1} BottNested.LimoCarriage (BottNested.LimoCarriage.mk grade nested capacity) (BottNested.LimoCarriage.mk grade' nested' capacity')) -> ((Eq.{1} Nat grade grade') -> (Eq.{1} BottNested.NestedCarriage nested nested') -> (Eq.{1} Nat capacity capacity') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `BottNested.LimoCarriage.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
