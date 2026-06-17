import Split.MonsterTrain_Carriage_canonical
import Split.MonsterTrain_MonsterCarriageTrain_cars
import Split.MonsterTrain_stretchLimo
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.Eq_refl
import Split.List_instAppend
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.MonsterTrain_MonsterCarriageTrain_king
import Split.MonsterTrain_MonsterCarriageTrain_location
import Split.MonsterTrain_MonsterCarriageTrain
import Split.MonsterTrain_Carriage
import Split.MonsterTrain_MonsterCarriageTrain_mk
import Split.List_nil

-- MonsterTrain.stretchLimo.eq_1 from environment
-- theorem MonsterTrain.stretchLimo.eq_1 : forall (t : MonsterTrain.MonsterCarriageTrain), Eq.{1} MonsterTrain.MonsterCarriageTrain (MonsterTrain.stretchLimo t) (MonsterTrain.MonsterCarriageTrain.mk (MonsterTrain.MonsterCarriageTrain.king t) (HAppend.hAppend.{0, 0, 0} (List.{0} MonsterTrain.Carriage) (List.{0} MonsterTrain.Carriage) (List.{0} MonsterTrain.Carriage) (instHAppendOfAppend.{0} (List.{0} MonsterTrain.Carriage) (List.instAppend.{0} MonsterTrain.Carriage)) (MonsterTrain.MonsterCarriageTrain.cars t) (List.cons.{0} MonsterTrain.Carriage (MonsterTrain.Carriage.canonical (List.length.{0} MonsterTrain.Carriage (MonsterTrain.MonsterCarriageTrain.cars t))) (List.nil.{0} MonsterTrain.Carriage))) (MonsterTrain.MonsterCarriageTrain.location t))

-- Stub: this file represents the declaration `MonsterTrain.stretchLimo.eq_1`.
-- In a full split, the body would be extracted from the environment.
