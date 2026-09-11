/-
# SystemProfile.lean — Shadow Classification as a Consteval Morphism

`isShadow` is NOT a stored data field on a system profile.
It is a **consteval morphism** — a computable classification map
determined entirely by the system's prime support.

## Key Principle

Shadowness is not metadata. Shadowness is a morphism.
A system *is* shadow iff its prime support fails to intersect
the Monster supersingular spectrum.
-/

import Mathlib
import RequestProject.MonsterConstants

set_option maxHeartbeats 400000

namespace SystemProfile

open MonsterConstants

/-! ## §1. The Monster Supersingular Spectrum -/
-- [dedup] supersingularPrimes now imported from MonsterConstants
/-! ## §2. System Profile — No `isShadow` Field -/

structure Profile where
  name : String
  supportPrimes : List ℕ
  deriving DecidableEq, Repr, Inhabited

/-! ## §3. The Consteval Morphisms -/

def monsterCompatible (S : Profile) : Bool :=
  S.supportPrimes.any (· ∈ supersingularPrimes)

def isShadow (S : Profile) : Bool :=
  !monsterCompatible S

/-! ## §4. Examples -/

def moonshineSystem : Profile := ⟨"moonshine_atlas", [47, 59, 71]⟩
def shadowSystem : Profile := ⟨"shadow_43", [43, 37, 53]⟩
def emptySystem : Profile := ⟨"empty", []⟩

theorem moonshine_is_compatible : monsterCompatible moonshineSystem = true := by native_decide
theorem moonshine_not_shadow : isShadow moonshineSystem = false := by native_decide
theorem shadow_is_shadow : isShadow shadowSystem = true := by native_decide
theorem empty_is_shadow : isShadow emptySystem = true := by native_decide

/-! ## §5. Invariance Under Permutation -/

/-- Helper: `List.any` is invariant under permutation. -/
private theorem any_perm {α : Type} {p : α → Bool} {l₁ l₂ : List α}
    (h : l₁.Perm l₂) : l₁.any p = l₂.any p := by
  induction h with
  | nil => rfl
  | cons x _ ih => simp [List.any_cons, ih]
  | swap x y l => simp [List.any_cons, Bool.or_assoc, Bool.or_comm (p x)]
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem shadow_perm_invariant (S T : Profile)
    (h : S.supportPrimes.Perm T.supportPrimes) :
    isShadow S = isShadow T := by
  simp only [isShadow, monsterCompatible]
  congr 1
  exact any_perm h

/-! ## §6. The Handshake Protocol Gate -/

def canHandshake (S : Profile) : Bool := monsterCompatible S

theorem handshake_requires_compatibility (S : Profile) :
    canHandshake S = true → isShadow S = false := by
  intro h; simp [canHandshake] at h; simp [isShadow, h]

theorem shadow_cannot_handshake (S : Profile) :
    isShadow S = true → canHandshake S = false := by
  intro h; simp [isShadow] at h; simp [canHandshake, h]

/-! ## §7. Transport Along Equivalences -/

structure ProfileEquiv (S T : Profile) where
  supportBij : S.supportPrimes.Perm T.supportPrimes

theorem shadow_transport_invariant (S T : Profile) (e : ProfileEquiv S T) :
    isShadow S = isShadow T :=
  shadow_perm_invariant S T e.supportBij

/-! ## §8. The Ontology Triple -/

def ontologyPrimes : List ℕ := [47, 59, 71]

theorem ontology_primes_supersingular :
    ∀ p ∈ ontologyPrimes, p ∈ supersingularPrimes := by decide

/-! ## §9. Summary -/

theorem shadowness_is_consteval :
    (∀ S : Profile, isShadow S = true ∨ isShadow S = false) ∧
    (∀ S T : Profile, S.supportPrimes.Perm T.supportPrimes →
      isShadow S = isShadow T) ∧
    (∀ S : Profile, isShadow S = true → canHandshake S = false) := by
  exact ⟨fun S => by cases isShadow S <;> simp,
         shadow_perm_invariant, shadow_cannot_handshake⟩

end SystemProfile
