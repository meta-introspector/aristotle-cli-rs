import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalRing_toNonUnitalNonAssocRing
import Split.NonUnitalCommRing
import Split.NonUnitalCommRing_toNonUnitalRing
import Split.Eq
import Split.instHMul

-- NonUnitalCommRing.mul_comm from environment
-- theorem NonUnitalCommRing.mul_comm : forall {α : Type.{u}} [self : NonUnitalCommRing.{u} α] (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α (NonUnitalRing.toNonUnitalNonAssocRing.{u} α (NonUnitalCommRing.toNonUnitalRing.{u} α self)))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α (NonUnitalRing.toNonUnitalNonAssocRing.{u} α (NonUnitalCommRing.toNonUnitalRing.{u} α self)))) b a)

-- Stub: this file represents the declaration `NonUnitalCommRing.mul_comm`.
-- In a full split, the body would be extracted from the environment.
