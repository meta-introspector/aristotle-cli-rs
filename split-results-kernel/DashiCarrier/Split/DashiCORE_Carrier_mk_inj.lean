import Split.DashiCORE_Carrier_mk
import Split.DashiCORE_Carrier_mk_noConfusion
import Split.And
import Split.DashiCORE_Carrier
import Split.And_intro
import Split.Bool
import Split.eq_of_heq
import Split.DashiCORE_Sign
import Split.HEq
import Split.Eq

-- DashiCORE.Carrier.mk.inj from environment
-- theorem DashiCORE.Carrier.mk.inj : forall {Ω : Type.{u_1}} {support : Ω -> Bool} {sign : Ω -> DashiCORE.Sign} {support_1 : Ω -> Bool} {sign_1 : Ω -> DashiCORE.Sign}, (Eq.{succ u_1} (DashiCORE.Carrier.{u_1} Ω) (DashiCORE.Carrier.mk.{u_1} Ω support sign) (DashiCORE.Carrier.mk.{u_1} Ω support_1 sign_1)) -> (And (Eq.{succ u_1} (Ω -> Bool) support support_1) (Eq.{succ u_1} (Ω -> DashiCORE.Sign) sign sign_1))

-- Stub: this file represents the declaration `DashiCORE.Carrier.mk.inj`.
-- In a full split, the body would be extracted from the environment.
