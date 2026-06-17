import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.BottNested_LimoCarriage
import Split.List
import Split.And
import Split.BottNested_BottLimo_mk_inj
import Split.BottNested_BottLimo
import Split.Eq_ndrec
import Split.Eq_refl
import Split.MonsterTrain_City
import Split.Eq
import Split.BottNested_BottLimo_mk
import Split.MonsterTrain_King

-- BottNested.BottLimo.mk.injEq from environment
-- theorem BottNested.BottLimo.mk.injEq : forall (king : MonsterTrain.King) (cars : List.{0} BottNested.LimoCarriage) (location : MonsterTrain.City) (king_1 : MonsterTrain.King) (cars_1 : List.{0} BottNested.LimoCarriage) (location_1 : MonsterTrain.City), Eq.{1} Prop (Eq.{1} BottNested.BottLimo (BottNested.BottLimo.mk king cars location) (BottNested.BottLimo.mk king_1 cars_1 location_1)) (And (Eq.{1} MonsterTrain.King king king_1) (And (Eq.{1} (List.{0} BottNested.LimoCarriage) cars cars_1) (Eq.{1} MonsterTrain.City location location_1)))

-- Stub: this file represents the declaration `BottNested.BottLimo.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
