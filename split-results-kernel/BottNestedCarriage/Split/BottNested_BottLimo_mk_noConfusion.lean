import Split.id
import Split.BottNested_BottLimo_noConfusion
import Split.BottNested_LimoCarriage
import Split.List
import Split.BottNested_BottLimo
import Split.MonsterTrain_City
import Split.Eq
import Split.BottNested_BottLimo_mk
import Split.MonsterTrain_King

-- BottNested.BottLimo.mk.noConfusion from environment
-- def BottNested.BottLimo.mk.noConfusion : forall {P : Sort.{u}} {king : MonsterTrain.King} {cars : List.{0} BottNested.LimoCarriage} {location : MonsterTrain.City} {king' : MonsterTrain.King} {cars' : List.{0} BottNested.LimoCarriage} {location' : MonsterTrain.City}, (Eq.{1} BottNested.BottLimo (BottNested.BottLimo.mk king cars location) (BottNested.BottLimo.mk king' cars' location')) -> ((Eq.{1} MonsterTrain.King king king') -> (Eq.{1} (List.{0} BottNested.LimoCarriage) cars cars') -> (Eq.{1} MonsterTrain.City location location') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `BottNested.BottLimo.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
