import Split.NonUnitalNonAssocRing
import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalNonAssocCommRing
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocCommRing.mk from environment
-- constructor NonUnitalNonAssocCommRing.mk : forall {α : Type.{u}} [toNonUnitalNonAssocRing : NonUnitalNonAssocRing.{u} α], (forall (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α toNonUnitalNonAssocRing)) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α toNonUnitalNonAssocRing)) b a)) -> (NonUnitalNonAssocCommRing.{u} α)

-- Stub: this file represents the declaration `NonUnitalNonAssocCommRing.mk`.
-- In a full split, the body would be extracted from the environment.
