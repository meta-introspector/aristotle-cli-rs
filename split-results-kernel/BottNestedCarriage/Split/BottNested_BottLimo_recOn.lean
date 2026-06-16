import Split.BottNested_BottLimo_rec
import Split.BottNested_LimoCarriage
import Split.List
import Split.BottNested_BottLimo
import Split.MonsterTrain_City
import Split.BottNested_BottLimo_mk
import Split.MonsterTrain_King

-- BottNested.BottLimo.recOn from environment
-- def BottNested.BottLimo.recOn : forall {motive : BottNested.BottLimo -> Sort.{u}} (t : BottNested.BottLimo), (forall (king : MonsterTrain.King) (cars : List.{0} BottNested.LimoCarriage) (location : MonsterTrain.City), motive (BottNested.BottLimo.mk king cars location)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `BottNested.BottLimo.recOn`.
-- In a full split, the body would be extracted from the environment.
