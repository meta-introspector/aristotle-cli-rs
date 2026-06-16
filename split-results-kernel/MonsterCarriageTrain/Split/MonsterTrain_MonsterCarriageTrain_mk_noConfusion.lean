import Split.id
import Split.List
import Split.MonsterTrain_City
import Split.Eq
import Split.MonsterTrain_MonsterCarriageTrain_noConfusion
import Split.MonsterTrain_King
import Split.MonsterTrain_MonsterCarriageTrain
import Split.MonsterTrain_Carriage
import Split.MonsterTrain_MonsterCarriageTrain_mk

-- MonsterTrain.MonsterCarriageTrain.mk.noConfusion from environment
-- def MonsterTrain.MonsterCarriageTrain.mk.noConfusion : forall {P : Sort.{u}} {king : MonsterTrain.King} {cars : List.{0} MonsterTrain.Carriage} {location : MonsterTrain.City} {king' : MonsterTrain.King} {cars' : List.{0} MonsterTrain.Carriage} {location' : MonsterTrain.City}, (Eq.{1} MonsterTrain.MonsterCarriageTrain (MonsterTrain.MonsterCarriageTrain.mk king cars location) (MonsterTrain.MonsterCarriageTrain.mk king' cars' location')) -> ((Eq.{1} MonsterTrain.King king king') -> (Eq.{1} (List.{0} MonsterTrain.Carriage) cars cars') -> (Eq.{1} MonsterTrain.City location location') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `MonsterTrain.MonsterCarriageTrain.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
