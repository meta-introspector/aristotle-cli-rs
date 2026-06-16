import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalRing_toNonUnitalNonAssocRing
import Split.NonUnitalCommRing
import Split.NonUnitalRing
import Split.Eq
import Split.instHMul

-- NonUnitalCommRing.mk from environment
-- constructor NonUnitalCommRing.mk : forall {α : Type.{u}} [toNonUnitalRing : NonUnitalRing.{u} α], (forall (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α (NonUnitalRing.toNonUnitalNonAssocRing.{u} α toNonUnitalRing))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α (NonUnitalRing.toNonUnitalNonAssocRing.{u} α toNonUnitalRing))) b a)) -> (NonUnitalCommRing.{u} α)

-- Stub: this file represents the declaration `NonUnitalCommRing.mk`.
-- In a full split, the body would be extracted from the environment.
