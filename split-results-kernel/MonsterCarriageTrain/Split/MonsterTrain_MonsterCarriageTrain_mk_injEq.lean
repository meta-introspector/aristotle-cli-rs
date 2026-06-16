import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.List
import Split.And
import Split.MonsterTrain_MonsterCarriageTrain_mk_inj
import Split.Eq_ndrec
import Split.Eq_refl
import Split.MonsterTrain_City
import Split.Eq
import Split.MonsterTrain_King
import Split.MonsterTrain_MonsterCarriageTrain
import Split.MonsterTrain_Carriage
import Split.MonsterTrain_MonsterCarriageTrain_mk

-- MonsterTrain.MonsterCarriageTrain.mk.injEq from environment
-- theorem MonsterTrain.MonsterCarriageTrain.mk.injEq : forall (king : MonsterTrain.King) (cars : List.{0} MonsterTrain.Carriage) (location : MonsterTrain.City) (king_1 : MonsterTrain.King) (cars_1 : List.{0} MonsterTrain.Carriage) (location_1 : MonsterTrain.City), Eq.{1} Prop (Eq.{1} MonsterTrain.MonsterCarriageTrain (MonsterTrain.MonsterCarriageTrain.mk king cars location) (MonsterTrain.MonsterCarriageTrain.mk king_1 cars_1 location_1)) (And (Eq.{1} MonsterTrain.King king king_1) (And (Eq.{1} (List.{0} MonsterTrain.Carriage) cars cars_1) (Eq.{1} MonsterTrain.City location location_1)))

-- Stub: this file represents the declaration `MonsterTrain.MonsterCarriageTrain.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
