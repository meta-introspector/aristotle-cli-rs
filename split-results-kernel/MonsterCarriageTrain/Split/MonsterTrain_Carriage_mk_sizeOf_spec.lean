import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.MonsterTrain_Carriage_mk
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq
import Split.MonsterTrain_Carriage

-- MonsterTrain.Carriage.mk.sizeOf_spec from environment
-- theorem MonsterTrain.Carriage.mk.sizeOf_spec : forall (grade : Nat) (capacity : Nat) (power : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} MonsterTrain.Carriage MonsterTrain.Carriage._sizeOf_inst (MonsterTrain.Carriage.mk grade capacity power)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat grade)) (SizeOf.sizeOf.{1} Nat instSizeOfNat capacity)) (SizeOf.sizeOf.{1} Nat instSizeOfNat power))

-- Stub: this file represents the declaration `MonsterTrain.Carriage.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
