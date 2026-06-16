import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.MonsterRepCategory_TensorRule_mk
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.MonsterRepCategory_TensorRule

-- MonsterRepCategory.TensorRule.mk.sizeOf_spec from environment
-- theorem MonsterRepCategory.TensorRule.mk.sizeOf_spec : forall (left : Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) (right : Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) (multiplicities : (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) -> Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} MonsterRepCategory.TensorRule MonsterRepCategory.TensorRule._sizeOf_inst (MonsterRepCategory.TensorRule.mk left right multiplicities)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) (Fin._sizeOf_inst (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) left)) (SizeOf.sizeOf.{1} (Fin (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) (Fin._sizeOf_inst (OfNat.ofNat.{0} Nat 194 (instOfNatNat 194))) right))

-- Stub: this file represents the declaration `MonsterRepCategory.TensorRule.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
