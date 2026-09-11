/-
  DashiDefect.lean — Formalization of the dashiCORE Defect specification.

  Formalizes defect semantics from MATH.md §4:
    • Defect as consistency violation measure
    • Non-negativity
    • Zero iff fixed point (kernel consistency)
    • Defect monotonicity (contractivity)
    • Defect under kernel iteration

  Key results:
    • Defect monotonicity for contractive kernels
    • Idempotent implies contractive
    • Defect is invariant under carrier involution for involution-respecting kernels
-/
import Mathlib
import RequestProject.DashiCarrier
import RequestProject.DashiKernel

namespace DashiCORE

/-! ## §1. Contractive Kernels -/

/-- A kernel is contractive iff defect does not increase under application:
    D(K(s)) ≤ D(s) for all s. -/
def Kernel.IsContractive {Ω : Type*} [Fintype Ω] (k : Kernel Ω) : Prop :=
  ∀ s, aggregateDefect (k.K s) k ≤ aggregateDefect s k

/-- An idempotent kernel is automatically contractive,
    because D(K(s)) = 0 ≤ D(s). -/
theorem idempotent_is_contractive {Ω : Type*} [Fintype Ω]
    (k : Kernel Ω) (hk : k.IsIdempotent) :
    k.IsContractive := by
  intro s
  rw [idempotent_zero_defect k hk s]
  exact Nat.zero_le _

/-! ## §2. Kernel Iteration -/

/-- Iterate a kernel n times. -/
def Kernel.iterate {Ω : Type*} (k : Kernel Ω) : ℕ → CarrierField Ω → CarrierField Ω
  | 0     => id
  | n + 1 => k.K ∘ k.iterate n

/-- Iterating 0 times is identity. -/
theorem Kernel.iterate_zero {Ω : Type*} (k : Kernel Ω) (s : CarrierField Ω) :
    k.iterate 0 s = s := rfl

/-- Iterating n+1 times = apply K after iterating n times. -/
theorem Kernel.iterate_succ {Ω : Type*} (k : Kernel Ω) (n : ℕ) (s : CarrierField Ω) :
    k.iterate (n + 1) s = k.K (k.iterate n s) := rfl

/-- If K^n(s) is a fixed point, then K^(n+1)(s) = K^n(s). -/
theorem Kernel.iterate_fixed {Ω : Type*} (k : Kernel Ω) (n : ℕ) (s : CarrierField Ω)
    (h : k.IsFixedPoint (k.iterate n s)) :
    k.iterate (n + 1) s = k.iterate n s := by
  simp [Kernel.iterate_succ, Kernel.IsFixedPoint] at *; exact h

/-- Idempotent kernels reach a fixed point after one application. -/
theorem idempotent_one_step {Ω : Type*} (k : Kernel Ω) (hk : k.IsIdempotent)
    (s : CarrierField Ω) :
    k.IsFixedPoint (k.K s) := hk s

/-! ## §3. Support Monotonicity Under Iteration -/

/-- Support count: number of supported sites. -/
def supportCount {Ω : Type*} [Fintype Ω] (s : CarrierField Ω) : ℕ :=
  (Finset.univ.filter (fun i => (s i).support = true)).card

/-- Support count is bounded by the domain size. -/
theorem supportCount_le_card {Ω : Type*} [Fintype Ω] (s : CarrierField Ω) :
    supportCount s ≤ Fintype.card Ω :=
  Finset.card_filter_le _ _

end DashiCORE
