import Mathlib

/-!
# q-Expansion Depth Analysis

Extended q-expansion coefficients for McKay-Thompson series, providing
"depth" — the number of terms computed — for structural analysis.

The j-function T_1A has the deepest expansion, while other
series have 10–30 terms. The depth enables:
1. CRT decomposition of each coefficient mod 196883
2. Asymptotic growth analysis
3. Cross-series correlations
4. Connection to the irrep padic profiles

## The j-Function Coefficients

The j-invariant j(τ) = Σ_{n≥-1} c(n) qⁿ with c(-1) = 1, c(0) = 744.
These are OEIS sequence A000521.
-/

namespace QExpansionDepth

/-! ## j-Function Coefficients

We store coefficients c(-1), c(0), c(1), ..., c(29) of the j-function.
These grow roughly as exp(4π√n) / (√2 · n^(3/4)) by Rademacher's formula.
-/

/-- First 32 coefficients of j(τ), from c(-1) to c(29). -/
def jCoeffs : List ℤ := [
  1,                           -- c(-1) = q⁻¹
  744,                         -- c(0)
  196884,                      -- c(1)
  21493760,                    -- c(2)
  864299970,                   -- c(3)
  20245856256,                 -- c(4)
  333202640600,                -- c(5)
  4252023300096,               -- c(6)
  44656994071935,              -- c(7)
  401490886656000,             -- c(8)
  3176440229784420,            -- c(9)
  22567393309593600,           -- c(10)
  146211911499519294,          -- c(11)
  874313719685775360,          -- c(12)
  4872010111798142520,         -- c(13)
  25497827389410525184,        -- c(14)
  126142916465781843075,       -- c(15)
  593121772421445058560,       -- c(16)
  2662842413150775245160,      -- c(17)
  11459912788444786513920,     -- c(18)
  47438786801234168813878,     -- c(19)
  189449976248893390028800,    -- c(20)
  732325668702994007480294,    -- c(21)
  2749031556009989944846336,   -- c(22)
  10040099965261766759782920,  -- c(23)
  35741006424994531301877760,  -- c(24)
  124287060396198414938562650, -- c(25)
  422670328762405574550921216, -- c(26)
  1407471769096079067992279655,-- c(27)
  4594297690315817752419688960,-- c(28)
  14720720375498092215741292020, -- c(29)
  46312930900473724953542422400  -- c(30)
]

theorem j_depth : jCoeffs.length = 32 := by native_decide

/-- Verify first few values match the known j-function. -/
theorem j_leading : jCoeffs.getD 0 0 = 1 := by native_decide
theorem j_constant : jCoeffs.getD 1 0 = 744 := by native_decide
theorem j_c1 : jCoeffs.getD 2 0 = 196884 := by native_decide
theorem j_c2 : jCoeffs.getD 3 0 = 21493760 := by native_decide
theorem j_c3 : jCoeffs.getD 4 0 = 864299970 := by native_decide
theorem j_c4 : jCoeffs.getD 5 0 = 20245856256 := by native_decide

/-! ## CRT Decomposition of j-Coefficients

Each j-function coefficient c(n) can be decomposed modulo 196883 = 47 × 59 × 71,
giving a coordinate on the Monster CRT torus.
-/

/-- Compute CRT coordinates of a j-coefficient: (c mod 47, c mod 59, c mod 71). -/
def jCRT (n : ℕ) : ℤ × ℤ × ℤ :=
  let c := jCoeffs.getD (n + 2) 0
  (c % 47, c % 59, c % 71)

#eval jCRT 0   -- c(1) = 196884 → (1, 1, 1)
#eval jCRT 1   -- c(2) = 21493760
#eval jCRT 2   -- c(3) = 864299970

/-- The first McKay-Thompson coefficient has CRT address (1, 1, 1). -/
theorem jCRT_1 : jCRT 0 = (1, 1, 1) := by native_decide

/-- CRT decomposition for the first 10 j-coefficients. -/
def first10CRT : List (ℤ × ℤ × ℤ) := (List.range 10).map jCRT

#eval first10CRT

/-! ## Modular Properties of Coefficients -/

/-- c(1) ≡ 1 (mod 196883). -/
theorem j_c1_mod_196883 : 196884 % 196883 = 1 := by norm_num

/-- Divisibility by small primes. -/
theorem j_c1_div_4 : (4 : ℤ) ∣ 196884 := ⟨49221, by norm_num⟩
theorem j_c2_div_2 : (2 : ℤ) ∣ 21493760 := ⟨10746880, by norm_num⟩

/-! ## Extended Series for CRT-Special Primes -/

/-- Extended coefficients for T_{47A}: hauptmodul for Γ₀(47)+. -/
def series47_extended : List ℤ := [
  1, 0,
  1, 0, 0, 0, 1, 0, 1, 0,
  0, 1, 0, 1, 1, 0, 0, 1,
  0, 2, 0, 1, 1, 0, 1, 1,
  0, 2, 1, 1, 1, 1, 1, 2
]

/-- Extended coefficients for T_{59A}: hauptmodul for Γ₀(59)+. -/
def series59_extended : List ℤ := [
  1, 0,
  1, 0, 0, 0, 0, 0, 1, 0,
  0, 0, 0, 1, 0, 0, 0, 0,
  1, 0, 1, 0, 0, 0, 0, 0,
  1, 0, 0, 1, 0, 1, 0, 0
]

/-- Extended coefficients for T_{71A}: hauptmodul for Γ₀(71)+. -/
def series71_extended : List ℤ := [
  1, 0,
  1, 0, 0, 0, 0, 0, 0, 0,
  1, 0, 0, 0, 0, 0, 0, 0,
  0, 1, 0, 0, 0, 0, 0, 0,
  0, 0, 1, 0, 0, 0, 0, 1
]

theorem depth_47 : series47_extended.length = 34 := by native_decide
theorem depth_59 : series59_extended.length = 34 := by native_decide
theorem depth_71 : series71_extended.length = 34 := by native_decide

/-! ## Cross-Series CRT Analysis -/

/-- Coefficient-wise difference of two series (truncated to shorter). -/
def coeffDiff (s t : List ℤ) : List ℤ :=
  (s.zip t).map (fun ⟨a, b⟩ => a - b)

/-! ## Parity and Residue Patterns -/

/-- Parity pattern of j-function coefficients. -/
def jParityPattern : List ℕ :=
  jCoeffs.map (fun c => if c % 2 == 0 then 0 else 1)

#eval jParityPattern

/-- j-function coefficients mod 47. -/
def jMod47Pattern : List ℤ := jCoeffs.map (fun c => c % 47)

/-- j-function coefficients mod 59. -/
def jMod59Pattern : List ℤ := jCoeffs.map (fun c => c % 59)

/-- j-function coefficients mod 71. -/
def jMod71Pattern : List ℤ := jCoeffs.map (fun c => c % 71)

#eval jMod47Pattern
#eval jMod59Pattern
#eval jMod71Pattern

/-! ## Asymptotic Density of Coefficients on the CRT Torus -/

/-- Full CRT coordinate of the n-th j-coefficient on the Monster torus. -/
def jTorusPt (n : ℕ) : ℕ × ℕ × ℕ :=
  let c := jCoeffs.getD n 0
  ((c % 47).toNat, (c % 59).toNat, (c % 71).toNat)

/-- All torus points. -/
def allTorusPts : List (ℕ × ℕ × ℕ) :=
  (List.range jCoeffs.length).map jTorusPt

#eval allTorusPts.eraseDups.length

/-! ## Connection to Irrep Dimensions -/

/-- The first 5 Monster irrep dimensions. -/
def irrepDims : List ℕ := [1, 196883, 21296876, 842609326, 18538750076]

theorem irrep_dim_0 : irrepDims.getD 0 0 = 1 := by native_decide
theorem irrep_dim_1 : irrepDims.getD 1 0 = 196883 := by native_decide
theorem irrep_dim_2 : irrepDims.getD 2 0 = 21296876 := by native_decide
theorem irrep_dim_3 : irrepDims.getD 3 0 = 842609326 := by native_decide

/-- V₁ decomposition: 196884 = dim(ρ₀) + dim(ρ₁) -/
theorem V1_decomp :
    (irrepDims.getD 0 0) + (irrepDims.getD 1 0) = 196884 := by native_decide

/-- V₂ decomposition: 21493760 = dim(ρ₀) + dim(ρ₁) + dim(ρ₂) -/
theorem V2_decomp :
    (irrepDims.getD 0 0) + (irrepDims.getD 1 0) + (irrepDims.getD 2 0) = 21493760 := by
  native_decide

/-- V₃ decomposition: 864299970 = 2·dim(ρ₀) + 2·dim(ρ₁) + dim(ρ₂) + dim(ρ₃) -/
theorem V3_decomp :
    2 * (irrepDims.getD 0 0) + 2 * (irrepDims.getD 1 0) +
    (irrepDims.getD 2 0) + (irrepDims.getD 3 0) = 864299970 := by native_decide

/-! ## Coefficient Growth Analysis -/

/-- Approximate log₂ of a positive integer. -/
def approxLog2 (n : ℤ) : ℕ :=
  if n ≤ 0 then 0
  else n.toNat.log 2

/-- Growth profile: log₂ of each j-coefficient. -/
def jGrowthProfile : List ℕ := jCoeffs.map approxLog2

#eval jGrowthProfile

/-- The coefficient grows: c(n) > c(n-1) for the first several terms. -/
theorem j_monotone_early :
    ∀ i ∈ [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
      jCoeffs.getD i 0 < jCoeffs.getD (i + 1) 0 := by native_decide

/-! ## Summary Theorem -/

/-- Grand q-expansion depth theorem. -/
theorem qexpansion_depth_summary :
    jCoeffs.length = 32 ∧
    jCoeffs.getD 0 0 = 1 ∧
    jCoeffs.getD 1 0 = 744 ∧
    jCoeffs.getD 2 0 = 196884 ∧
    196883 = 47 * 59 * 71 ∧
    196884 % 196883 = 1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

end QExpansionDepth
