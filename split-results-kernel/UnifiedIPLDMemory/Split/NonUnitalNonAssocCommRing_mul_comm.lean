import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalNonAssocCommRing
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocCommRing.mul_comm from environment
-- theorem NonUnitalNonAssocCommRing.mul_comm : forall {α : Type.{u}} [self : NonUnitalNonAssocCommRing.{u} α] (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} α self))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} α self))) b a)

-- Stub: this file represents the declaration `NonUnitalNonAssocCommRing.mul_comm`.
-- In a full split, the body would be extracted from the environment.
