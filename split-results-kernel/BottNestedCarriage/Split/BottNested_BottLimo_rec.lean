import Split.BottNested_LimoCarriage
import Split.List
import Split.BottNested_BottLimo
import Split.MonsterTrain_City
import Split.BottNested_BottLimo_mk
import Split.MonsterTrain_King

-- BottNested.BottLimo.rec from environment
-- recursor BottNested.BottLimo.rec : forall {motive : BottNested.BottLimo -> Sort.{u}}, (forall (king : MonsterTrain.King) (cars : List.{0} BottNested.LimoCarriage) (location : MonsterTrain.City), motive (BottNested.BottLimo.mk king cars location)) -> (forall (t : BottNested.BottLimo), motive t)

-- Stub: this file represents the declaration `BottNested.BottLimo.rec`.
-- In a full split, the body would be extracted from the environment.
