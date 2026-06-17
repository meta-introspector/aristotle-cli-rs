import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalRing_toNonUnitalNonAssocRing
import Split.NonUnitalNormedRing_toNonUnitalRing
import Split.NonUnitalNormedCommRing_toNonUnitalNormedRing
import Split.NonUnitalNormedCommRing
import Split.Eq
import Split.instHMul

-- NonUnitalNormedCommRing.mul_comm from environment
-- theorem NonUnitalNormedCommRing.mul_comm : forall {α : Type.{u_5}} [self : NonUnitalNormedCommRing.{u_5} α] (a : α) (b : α), Eq.{succ u_5} α (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocRing.toMul.{u_5} α (NonUnitalRing.toNonUnitalNonAssocRing.{u_5} α (NonUnitalNormedRing.toNonUnitalRing.{u_5} α (NonUnitalNormedCommRing.toNonUnitalNormedRing.{u_5} α self))))) a b) (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocRing.toMul.{u_5} α (NonUnitalRing.toNonUnitalNonAssocRing.{u_5} α (NonUnitalNormedRing.toNonUnitalRing.{u_5} α (NonUnitalNormedCommRing.toNonUnitalNormedRing.{u_5} α self))))) b a)

-- Stub: this file represents the declaration `NonUnitalNormedCommRing.mul_comm`.
-- In a full split, the body would be extracted from the environment.
