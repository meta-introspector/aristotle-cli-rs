import Split.CauSeq_instLTAbs
import Split.Real
import Split.abs
import Split.Rat
import Split.Real_lt_cauchy
import Split.Rat_linearOrder
import Split.Real_instLT
import Split.Rat_instLattice
import Split.Rat_instDivisionRing
import Split.DivisionRing_toRing
import Split.Iff
import Split.Rat_instField
import Split.LT_lt
import Split.CauSeq
import Split.Rat_instIsStrictOrderedRing
import Split.Rat_addGroup
import Split.Real_mk

-- Real.mk_lt from environment
-- theorem Real.mk_lt : forall {f : CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)} {g : CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)}, Iff (LT.lt.{0} Real Real.instLT (Real.mk f) (Real.mk g)) (LT.lt.{0} (CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)) (CauSeq.instLTAbs.{0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing) f g)

-- Stub: this file represents the declaration `Real.mk_lt`.
-- In a full split, the body would be extracted from the environment.
