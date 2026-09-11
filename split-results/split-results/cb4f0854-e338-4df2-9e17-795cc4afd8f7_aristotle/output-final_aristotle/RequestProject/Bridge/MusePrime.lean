/-
  MusePrime.lean
  Salvaged from meta-introspector/meta-meme discussion #23 (Aug 2023).

  The core mathematical idea: 8 "muses" indexed by the first 8 primes.
  Muse i lives in ℝ^(i+1) with eigenvalue p_i.
  Lifted into Clifford algebras Cl(0,7) and Cl(0,8).

  Original thread: https://github.com/orgs/meta-introspector/discussions/23
-/
import Mathlib
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 800000

namespace MuseEigenspace

-- ============================================================
-- §1  The Eight Muses and Their Associated Primes
-- ============================================================

/-- The index type for the 8 muses (0-indexed internally). -/
abbrev MuseIdx := Fin 8

/-- The first 8 primes, one per muse.
    Muse 0 → 2, Muse 1 → 3, … , Muse 7 → 19. -/
def musePrime : MuseIdx → ℕ
  | ⟨0, _⟩ => 2
  | ⟨1, _⟩ => 3
  | ⟨2, _⟩ => 5
  | ⟨3, _⟩ => 7
  | ⟨4, _⟩ => 11
  | ⟨5, _⟩ => 13
  | ⟨6, _⟩ => 17
  | ⟨7, _⟩ => 19

/-- Every entry in `musePrime` is indeed prime. -/
theorem musePrime_prime (i : MuseIdx) : Nat.Prime (musePrime i) := by
  fin_cases i <;> decide

/-- The dimension for Muse i is i + 1.
    Muse 0 lives in ℝ¹, Muse 7 lives in ℝ⁸. -/
def museDim (i : MuseIdx) : ℕ := i.val + 1

theorem museDim_pos (i : MuseIdx) : 0 < museDim i := by unfold museDim; omega

-- ============================================================
-- §2  Eigenvalue and Scalar Eigenspace
-- ============================================================

/-- The eigenvalue for muse i, cast to ℝ. -/
noncomputable def museEigenvalue (i : MuseIdx) : ℝ := (musePrime i : ℝ)

/-- The scalar matrix p_i · I on ℝ^(museDim i). -/
noncomputable def museScalarMatrix (i : MuseIdx) :
    Matrix (Fin (museDim i)) (Fin (museDim i)) ℝ :=
  (museEigenvalue i) • (1 : Matrix (Fin (museDim i)) (Fin (museDim i)) ℝ)

/-- Every vector is an eigenvector of the scalar matrix p_i · I. -/
theorem museScalarMatrix_mulVec (i : MuseIdx) (v : Fin (museDim i) → ℝ) :
    museScalarMatrix i • v = museEigenvalue i • v := by
  simp [museScalarMatrix]

-- ============================================================
-- §3  Lifting Muses into Clifford Algebras
-- ============================================================

/-- Generator of Cl(0,n): the image of the i-th standard basis vector under ι. -/
noncomputable def cl0Gen (n : ℕ) (i : Fin n) : Cl0 n :=
  CliffordAlgebra.ι (negDefForm n) (stdBasis n i)

/-- Each generator squares to -1. -/
theorem cl0Gen_sq (n : ℕ) (i : Fin n) :
    cl0Gen n i * cl0Gen n i = -(1 : Cl0 n) := by
  unfold cl0Gen
  rw [CliffordAlgebra.ι_sq_scalar, negDefForm_basis]
  simp

/-- Muse i (0-indexed, i < 7) maps to generator eᵢ in Cl(0,7).
    Muse 7 maps to the pseudoscalar e₀e₁⋯e₆. -/
noncomputable def museInCl07 (i : MuseIdx) : Cl0 7 :=
  if h : i.val < 7 then
    cl0Gen 7 ⟨i.val, h⟩
  else
    -- Muse 8 (index 7) is the pseudoscalar ω = e₀e₁e₂e₃e₄e₅e₆
    cl0Gen 7 0 * cl0Gen 7 1 * cl0Gen 7 2 * cl0Gen 7 3 *
    cl0Gen 7 4 * cl0Gen 7 5 * cl0Gen 7 6

/-- Each muse (i < 8) maps directly to generator fᵢ in Cl(0,8). -/
noncomputable def museInCl08 (i : MuseIdx) : Cl0 8 :=
  cl0Gen 8 i

-- ============================================================
-- §4  Sanity checks
-- ============================================================

example : musePrime ⟨0, by omega⟩ = 2  := rfl
example : musePrime ⟨7, by omega⟩ = 19 := rfl
example : museDim   ⟨0, by omega⟩ = 1  := rfl
example : museDim   ⟨3, by omega⟩ = 4  := rfl
example : museDim   ⟨7, by omega⟩ = 8  := rfl

-- The primes are strictly increasing
theorem musePrime_strictMono : StrictMono musePrime := by
  intro ⟨a, ha⟩ ⟨b, hb⟩ hab
  simp only [musePrime]
  interval_cases a <;> interval_cases b <;> simp_all

-- 42 is not prime — the original dump mistakenly called it "prime(42)"
theorem forty_two_not_prime : ¬ Nat.Prime 42 := by decide

-- 42 = 2 × 3 × 7
theorem forty_two_factors : 42 = 2 * 3 * 7 := by norm_num

end MuseEigenspace
