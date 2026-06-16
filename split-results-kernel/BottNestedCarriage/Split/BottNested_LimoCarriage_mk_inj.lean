import Split.BottNested_LimoCarriage_mk_noConfusion
import Split.BottNested_LimoCarriage
import Split.And
import Split.Nat
import Split.And_intro
import Split.BottNested_LimoCarriage_mk
import Split.Eq
import Split.BottNested_NestedCarriage

-- BottNested.LimoCarriage.mk.inj from environment
-- theorem BottNested.LimoCarriage.mk.inj : forall {grade : Nat} {nested : BottNested.NestedCarriage} {capacity : Nat} {grade_1 : Nat} {nested_1 : BottNested.NestedCarriage} {capacity_1 : Nat}, (Eq.{1} BottNested.LimoCarriage (BottNested.LimoCarriage.mk grade nested capacity) (BottNested.LimoCarriage.mk grade_1 nested_1 capacity_1)) -> (And (Eq.{1} Nat grade grade_1) (And (Eq.{1} BottNested.NestedCarriage nested nested_1) (Eq.{1} Nat capacity capacity_1)))

-- Stub: this file represents the declaration `BottNested.LimoCarriage.mk.inj`.
-- In a full split, the body would be extracted from the environment.
