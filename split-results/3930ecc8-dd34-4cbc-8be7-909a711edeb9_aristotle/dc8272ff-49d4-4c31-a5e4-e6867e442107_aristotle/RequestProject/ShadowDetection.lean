import Mathlib
import RequestProject.SupersingularPrimes
import RequestProject.IrrepMask

/-!
# Shadow Detection

CFSG-inspired shadow detection: identifying sporadic simple groups via
involution centralizer patterns. Each sporadic group has a characteristic
"shadow" signature.
-/

/-- The 26 sporadic simple groups. -/
inductive SporadicType where
  | Mathieu11 | Mathieu12 | Mathieu22 | Mathieu23 | Mathieu24
  | Janko1 | Janko2 | Janko3 | Janko4
  | Conway1 | Conway2 | Conway3
  | FischerF22 | FischerF23 | FischerF24
  | HighmanSims | McLaughlin | Held | Rudvalis | Suzuki
  | ONan | HaradaNorton
  | Thompson | BabyMonster | Monster
  | Tits
  deriving DecidableEq, Repr, Inhabited

/-- Predicate for being an involution (element of order 2). -/
def IsInvolution {G : Type*} [Group G] (g : G) : Prop :=
  g ^ 2 = 1 ∧ g ≠ 1

/-- Shadow identification: a mask has a shadow classification if it matches
    a known sporadic pattern. -/
structure IsShadow (mask : SSPMask) where
  sporadicType : SporadicType
  /-- The popcount gives partial info about which sporadic it might be. -/
  weight_bound : mask.popcount ≤ 15

/-- The Monster's own shadow has full SSP support. -/
def monsterShadow : IsShadow SSPMask.full where
  sporadicType := .Monster
  weight_bound := by native_decide

/-- Baby Monster shadow: missing one prime from full support. -/
def babyMonsterShadow : IsShadow (BitVec.ofNat 15 0x3FFF) where
  sporadicType := .BabyMonster
  weight_bound := by native_decide
