import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.DashiCORE_Carrier_mk
import Split.And
import Split.DashiCORE_Carrier
import Split.DashiCORE_Carrier_mk_inj
import Split.Bool
import Split.Eq_ndrec
import Split.DashiCORE_Sign
import Split.Eq_refl
import Split.Eq

-- DashiCORE.Carrier.mk.injEq from environment
-- theorem DashiCORE.Carrier.mk.injEq : forall {Ω : Type.{u_1}} (support : Ω -> Bool) (sign : Ω -> DashiCORE.Sign) (support_1 : Ω -> Bool) (sign_1 : Ω -> DashiCORE.Sign), Eq.{1} Prop (Eq.{succ u_1} (DashiCORE.Carrier.{u_1} Ω) (DashiCORE.Carrier.mk.{u_1} Ω support sign) (DashiCORE.Carrier.mk.{u_1} Ω support_1 sign_1)) (And (Eq.{succ u_1} (Ω -> Bool) support support_1) (Eq.{succ u_1} (Ω -> DashiCORE.Sign) sign sign_1))

-- Stub: this file represents the declaration `DashiCORE.Carrier.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
