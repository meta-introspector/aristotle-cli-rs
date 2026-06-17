import Split.MonsterTrain_King_mk
import Split.MonsterTrain_MonsterCarriageTrain_cars
import Split.List_map
import Split.MonsterTrain_King_legitimacy
import Split.MonsterTrain_Carriage_grade
import Split.instOfNatNat
import Split.MonsterTrain_City_next
import Split.MonsterTrain_Carriage_power
import Split.instHAdd
import Split.MonsterTrain_advance
import Split.MonsterTrain_resistance
import Split.HAdd_hAdd
import Split.Nat
import Split.MonsterTrain_King_resolve
import Split.MonsterTrain_Carriage_capacity
import Split.instAddNat
import Split.Eq_refl
import Split.MonsterTrain_Carriage_mk
import Split.OfNat_ofNat
import Split.Eq
import Split.MonsterTrain_MonsterCarriageTrain_king
import Split.MonsterTrain_MonsterCarriageTrain_location
import Split.MonsterTrain_MonsterCarriageTrain
import Split.MonsterTrain_Carriage
import Split.MonsterTrain_MonsterCarriageTrain_mk

-- MonsterTrain.advance.eq_1 from environment
-- theorem MonsterTrain.advance.eq_1 : forall (t : MonsterTrain.MonsterCarriageTrain), Eq.{1} MonsterTrain.MonsterCarriageTrain (MonsterTrain.advance t) (MonsterTrain.MonsterCarriageTrain.mk (MonsterTrain.King.mk (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (MonsterTrain.King.legitimacy (MonsterTrain.MonsterCarriageTrain.king t)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (MonsterTrain.King.resolve (MonsterTrain.MonsterCarriageTrain.king t)) (MonsterTrain.resistance (MonsterTrain.MonsterCarriageTrain.location t)))) (List.map.{0, 0} MonsterTrain.Carriage MonsterTrain.Carriage (fun (c : MonsterTrain.Carriage) => MonsterTrain.Carriage.mk (MonsterTrain.Carriage.grade c) (MonsterTrain.Carriage.capacity c) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (MonsterTrain.Carriage.power c) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (MonsterTrain.MonsterCarriageTrain.cars t)) (MonsterTrain.City.next (MonsterTrain.MonsterCarriageTrain.location t)))

-- Stub: this file represents the declaration `MonsterTrain.advance.eq_1`.
-- In a full split, the body would be extracted from the environment.
