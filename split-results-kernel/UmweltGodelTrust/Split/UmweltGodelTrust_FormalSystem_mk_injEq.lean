import Split.Eq_propIntro
import Split.UmweltGodelTrust_FormalSystem
import Split.String
import Split.Lean_injEq_helper
import Split.And
import Split.UmweltGodelTrust_FormalSystem_mk
import Split.Bool
import Split.Eq_ndrec
import Split.Eq_refl
import Split.UmweltGodelTrust_FormalSystem_mk_inj
import Split.Eq

-- UmweltGodelTrust.FormalSystem.mk.injEq from environment
-- theorem UmweltGodelTrust.FormalSystem.mk.injEq : forall (name : String) (expresses_arithmetic : Bool) (consistent : Bool) (name_1 : String) (expresses_arithmetic_1 : Bool) (consistent_1 : Bool), Eq.{1} Prop (Eq.{1} UmweltGodelTrust.FormalSystem (UmweltGodelTrust.FormalSystem.mk name expresses_arithmetic consistent) (UmweltGodelTrust.FormalSystem.mk name_1 expresses_arithmetic_1 consistent_1)) (And (Eq.{1} String name name_1) (And (Eq.{1} Bool expresses_arithmetic expresses_arithmetic_1) (Eq.{1} Bool consistent consistent_1)))

-- Stub: this file represents the declaration `UmweltGodelTrust.FormalSystem.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
