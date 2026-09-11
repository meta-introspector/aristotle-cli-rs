/-
  DashiKernel.lean — Formalization of the dashiCORE Kernel specification.

  Formalizes kernel operators from MATH.md §3:
    • Kernel as local consistency operator K : T^Ω → T^Ω
    • Shape preservation
    • Support non-creation rule
    • Idempotent vs contractive kernels
    • Defect non-increasing property

  Key results:
    • Idempotent kernels have zero defect at fixed points
    • Support rule: kernel cannot create new support
    • Mock kernels (Identity, Zero, Clamp) satisfy all required properties
-/
import Mathlib
import RequestProject.DashiCarrier

namespace DashiCORE

/-! ## §1. Kernel Definition -/

/-- A kernel is a local consistency operator on carrier fields.
    It must be shape-preserving (same domain), deterministic, and
    satisfy the support non-creation rule. -/
structure Kernel (Ω : Type*) where
  /-- The kernel operator. -/
  K : CarrierField Ω → CarrierField Ω
  /-- Support non-creation: kernel cannot make unsupported sites supported. -/
  support_rule : ∀ (s : CarrierField Ω) (i : Ω),
    (s i).support = false → (K s i).support = false

/-! ## §2. Idempotent Kernels -/

/-- A kernel is idempotent iff K(K(s)) = K(s) for all s. -/
def Kernel.IsIdempotent {Ω : Type*} (k : Kernel Ω) : Prop :=
  ∀ s, k.K (k.K s) = k.K s

/-- Fixed points: s is a fixed point of K iff K(s) = s. -/
def Kernel.IsFixedPoint {Ω : Type*} (k : Kernel Ω) (s : CarrierField Ω) : Prop :=
  k.K s = s

/-- The image of an idempotent kernel consists of fixed points. -/
theorem Kernel.idempotent_image_fixed {Ω : Type*} (k : Kernel Ω)
    (hk : k.IsIdempotent) (s : CarrierField Ω) :
    k.IsFixedPoint (k.K s) :=
  hk s

/-! ## §3. Local Defect -/

/-- Local defect at a site: 0 if consistent, 1 if changed by kernel. -/
def localDefect {Ω : Type*} (s : CarrierField Ω) (k : Kernel Ω) (i : Ω) : ℕ :=
  if s i = k.K s i then 0 else 1

/-- Aggregate defect: count of inconsistent sites. -/
def aggregateDefect {Ω : Type*} [Fintype Ω]
    (s : CarrierField Ω) (k : Kernel Ω) : ℕ :=
  Finset.univ.sum (fun i => localDefect s k i)

/-- Local defect is zero iff the site is locally consistent. -/
theorem localDefect_zero_iff {Ω : Type*}
    (s : CarrierField Ω) (k : Kernel Ω) (i : Ω) :
    localDefect s k i = 0 ↔ s i = k.K s i := by
  unfold localDefect; split <;> simp_all

/-
Aggregate defect is zero iff s is a fixed point of K.
-/
theorem aggregateDefect_zero_iff {Ω : Type*} [Fintype Ω]
    (s : CarrierField Ω) (k : Kernel Ω) :
    aggregateDefect s k = 0 ↔ k.IsFixedPoint s := by
      constructor <;> intro h <;> simp_all +decide [aggregateDefect, localDefect];
      · exact funext fun i => Eq.symm ( h i );
      · exact fun i => congr_fun h.symm i

/-- An idempotent kernel has zero defect on its own output. -/
theorem idempotent_zero_defect {Ω : Type*} [Fintype Ω]
    (k : Kernel Ω) (hk : k.IsIdempotent) (s : CarrierField Ω) :
    aggregateDefect (k.K s) k = 0 := by
  rw [aggregateDefect_zero_iff]
  exact hk s

/-! ## §4. Mock Kernels -/

/-- Identity kernel: K(s) = s. Always a fixed point. -/
def identityKernel (Ω : Type*) : Kernel Ω where
  K := id
  support_rule := fun _ _ h => h

/-- The identity kernel is idempotent. -/
theorem identityKernel_idempotent (Ω : Type*) :
    (identityKernel Ω).IsIdempotent :=
  fun _ => rfl

/-- Every state is a fixed point of the identity kernel. -/
theorem identityKernel_fixed (Ω : Type*) (s : CarrierField Ω) :
    (identityKernel Ω).IsFixedPoint s := rfl

/-- Zero kernel: K(s) = 0 (all sites become zero/unsupported). -/
def zeroKernel (Ω : Type*) : Kernel Ω where
  K := fun _ _ => Ternary.zero
  support_rule := fun _ _ _ => rfl

/-- The zero kernel is idempotent. -/
theorem zeroKernel_idempotent (Ω : Type*) :
    (zeroKernel Ω).IsIdempotent :=
  fun _ => rfl

/-- Clamp kernel: negative ↦ zero, zero ↦ zero, positive ↦ positive. -/
def clampKernel (Ω : Type*) : Kernel Ω where
  K := fun s i => match s i with
    | .neg  => .zero
    | .zero => .zero
    | .pos  => .pos
  support_rule := fun s i h => by
    cases hs : s i <;> simp_all [Ternary.support]

/-- The clamp kernel is idempotent. -/
theorem clampKernel_idempotent (Ω : Type*) :
    (clampKernel Ω).IsIdempotent := by
  intro s; funext i; simp [clampKernel]; cases s i <;> rfl

/-
Support non-creation: after applying any kernel, support can only decrease.
-/
theorem support_monotone {Ω : Type*} (k : Kernel Ω) (s : CarrierField Ω) (i : Ω) :
    (k.K s i).support = true → (s i).support = true := by
      exact fun h => by have := k.support_rule s i; aesop;

/-! ## §5. Kernel Composition -/

/-- Compose two kernels (K₂ ∘ K₁). -/
def Kernel.comp {Ω : Type*} (k₂ k₁ : Kernel Ω) : Kernel Ω where
  K := k₂.K ∘ k₁.K
  support_rule := fun s i h => by
    have h₁ := k₁.support_rule s i h
    exact k₂.support_rule (k₁.K s) i h₁

/-- Composing a kernel with itself is the same as iterating twice. -/
theorem Kernel.comp_self_eq {Ω : Type*} (k : Kernel Ω) (s : CarrierField Ω) :
    (k.comp k).K s = k.K (k.K s) := rfl

end DashiCORE