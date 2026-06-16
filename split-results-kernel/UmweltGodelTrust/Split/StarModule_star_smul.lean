import Split.instHSMul
import Split.SMul
import Split.Star
import Split.HSMul_hSMul
import Split.StarModule
import Split.Eq
import Split.Star_star

-- StarModule.star_smul from environment
-- theorem StarModule.star_smul : forall {R : Type.{u}} {A : Type.{v}} {inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.6 : Star.{u} R} {inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 : Star.{v} A} {inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12 : SMul.{u, v} R A} [self : StarModule.{u, v} R A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12] (r : R) (a : A), Eq.{succ v} A (Star.star.{v} A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 (HSMul.hSMul.{u, v, v} R A A (instHSMul.{u, v} R A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12) r a)) (HSMul.hSMul.{u, v, v} R A A (instHSMul.{u, v} R A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12) (Star.star.{u} R inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.6 r) (Star.star.{v} A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 a))

-- Stub: this file represents the declaration `StarModule.star_smul`.
-- In a full split, the body would be extracted from the environment.
