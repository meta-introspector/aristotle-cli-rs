import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.MonsterTrain_Carriage_mk_inj
import Split.And
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.MonsterTrain_Carriage_mk
import Split.Eq
import Split.MonsterTrain_Carriage

-- MonsterTrain.Carriage.mk.injEq from environment
-- theorem MonsterTrain.Carriage.mk.injEq : forall (grade : Nat) (capacity : Nat) (power : Nat) (grade_1 : Nat) (capacity_1 : Nat) (power_1 : Nat), Eq.{1} Prop (Eq.{1} MonsterTrain.Carriage (MonsterTrain.Carriage.mk grade capacity power) (MonsterTrain.Carriage.mk grade_1 capacity_1 power_1)) (And (Eq.{1} Nat grade grade_1) (And (Eq.{1} Nat capacity capacity_1) (Eq.{1} Nat power power_1)))

-- Stub: this file represents the declaration `MonsterTrain.Carriage.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
