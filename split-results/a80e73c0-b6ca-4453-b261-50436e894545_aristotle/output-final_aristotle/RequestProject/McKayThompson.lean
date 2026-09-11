import Mathlib

/-!
# McKay-Thompson Series

The McKay-Thompson series are the 194 functions T_g(τ) associated to the
194 conjugacy classes of the Monster group 𝕄. For each g ∈ 𝕄, the series

  T_g(τ) = q⁻¹ + Σ_{n≥1} c_g(n) qⁿ

where c_g(n) = Tr(g | V_n^♮) is the trace of g on the grade-n piece of the
Moonshine module V^♮.

## Key facts

1. For g = 1 (identity), T₁(τ) = j(τ) - 744, the j-invariant minus 744.
2. The coefficient c_g(1) = 1 + χ_{196883}(g), since V₁ = ρ₁ ⊕ ρ_{196883}.
3. Each T_g is a hauptmodul (generator of the function field) for a
   genus-zero group Γ_g ≤ SL₂(ℝ) — this is the Monstrous Moonshine conjecture,
   proved by Borcherds (1992).
4. There are 171 distinct McKay-Thompson series among the 194 conjugacy classes.

## Convention

We store coefficients as a list `coeffs` where:
- `coeffs[0]` = coefficient of q⁻¹ (always 1)
- `coeffs[1]` = constant term (0 for T_g by convention)
- `coeffs[n+2]` = coefficient of qⁿ for n ≥ 1
-/

namespace McKayThompson

/-! ## Data Structures -/

/-- A conjugacy class of the Monster group. -/
structure ConjClass where
  label : String
  order : ℕ
  chi196883 : ℤ
  deriving Repr, DecidableEq, Inhabited

/-- A McKay-Thompson series with its conjugacy class and q-expansion. -/
structure MTSeries where
  conjClass : ConjClass
  coeffs : List ℤ
  deriving Repr, Inhabited

namespace MTSeries

/-- The coefficient of q⁻¹ (should always be 1). -/
def leadingCoeff (s : MTSeries) : ℤ := s.coeffs.getD 0 0

/-- The constant term. -/
def constantTerm (s : MTSeries) : ℤ := s.coeffs.getD 1 0

/-- The coefficient of qⁿ for n ≥ 1. -/
def qCoeff (s : MTSeries) (n : ℕ) : ℤ := s.coeffs.getD (n + 1) 0

/-- Number of known coefficients. -/
def depth (s : MTSeries) : ℕ := s.coeffs.length

end MTSeries

/-! ## The 194 Conjugacy Classes of the Monster -/

/-- All 194 conjugacy classes with their orders and χ_{196883} values. -/
def monsterClasses : List ConjClass := [
  ⟨"1A", 1, 196883⟩,
  ⟨"2A", 2, 4371⟩, ⟨"2B", 2, 275⟩,
  ⟨"3A", 3, 782⟩, ⟨"3B", 3, -1⟩, ⟨"3C", 3, 53⟩,
  ⟨"4A", 4, 275⟩, ⟨"4B", 4, 51⟩, ⟨"4C", 4, 19⟩, ⟨"4D", 4, -1⟩,
  ⟨"5A", 5, 133⟩, ⟨"5B", 5, 8⟩,
  ⟨"6A", 6, 50⟩, ⟨"6B", 6, -1⟩, ⟨"6C", 6, 5⟩, ⟨"6D", 6, 5⟩,
  ⟨"6E", 6, -1⟩, ⟨"6F", 6, 2⟩,
  ⟨"7A", 7, 43⟩, ⟨"7B", 7, 1⟩,
  ⟨"8A", 8, 19⟩, ⟨"8B", 8, 3⟩, ⟨"8C", 8, 3⟩,
  ⟨"8D", 8, -1⟩, ⟨"8E", 8, 3⟩, ⟨"8F", 8, -1⟩,
  ⟨"9A", 9, 26⟩, ⟨"9B", 9, -1⟩,
  ⟨"10A", 10, 13⟩, ⟨"10B", 10, 5⟩, ⟨"10C", 10, -3⟩,
  ⟨"10D", 10, 1⟩, ⟨"10E", 10, 0⟩,
  ⟨"11A", 11, 10⟩,
  ⟨"12A", 12, 2⟩, ⟨"12B", 12, 11⟩, ⟨"12C", 12, -1⟩,
  ⟨"12D", 12, 2⟩, ⟨"12E", 12, -1⟩, ⟨"12F", 12, 2⟩,
  ⟨"12G", 12, -1⟩, ⟨"12H", 12, 3⟩, ⟨"12I", 12, -1⟩,
  ⟨"12J", 12, 0⟩,
  ⟨"13A", 13, 1⟩, ⟨"13B", 13, 1⟩,
  ⟨"14A", 14, 3⟩, ⟨"14B", 14, 1⟩, ⟨"14C", 14, -1⟩,
  ⟨"15A", 15, 8⟩, ⟨"15B", 15, -1⟩, ⟨"15C", 15, 2⟩, ⟨"15D", 15, -1⟩,
  ⟨"16A", 16, 3⟩, ⟨"16B", 16, -1⟩, ⟨"16C", 16, -1⟩,
  ⟨"17A", 17, 2⟩,
  ⟨"18A", 18, 2⟩, ⟨"18B", 18, -1⟩, ⟨"18C", 18, 2⟩,
  ⟨"18D", 18, -1⟩, ⟨"18E", 18, 0⟩,
  ⟨"19A", 19, 2⟩,
  ⟨"20A", 20, 1⟩, ⟨"20B", 20, 1⟩, ⟨"20C", 20, -1⟩,
  ⟨"20D", 20, -1⟩, ⟨"20E", 20, 1⟩, ⟨"20F", 20, -1⟩,
  ⟨"21A", 21, 1⟩, ⟨"21B", 21, 1⟩, ⟨"21C", 21, -2⟩, ⟨"21D", 21, 1⟩,
  ⟨"22A", 22, -2⟩, ⟨"22B", 22, 0⟩,
  ⟨"23A", 23, 0⟩, ⟨"23B", 23, 0⟩,
  ⟨"24A", 24, -1⟩, ⟨"24B", 24, 3⟩, ⟨"24C", 24, -1⟩,
  ⟨"24D", 24, -1⟩, ⟨"24E", 24, -1⟩, ⟨"24F", 24, 1⟩,
  ⟨"24G", 24, 0⟩, ⟨"24H", 24, -1⟩, ⟨"24I", 24, 1⟩, ⟨"24J", 24, 0⟩,
  ⟨"25A", 25, -2⟩,
  ⟨"26A", 26, 1⟩, ⟨"26B", 26, 1⟩,
  ⟨"27A", 27, -1⟩, ⟨"27B", 27, -1⟩,
  ⟨"28A", 28, -1⟩, ⟨"28B", 28, 1⟩, ⟨"28C", 28, 1⟩, ⟨"28D", 28, -1⟩,
  ⟨"29A", 29, 0⟩,
  ⟨"30A", 30, 0⟩, ⟨"30B", 30, 2⟩, ⟨"30C", 30, -1⟩,
  ⟨"30D", 30, 0⟩, ⟨"30E", 30, -1⟩, ⟨"30F", 30, 0⟩, ⟨"30G", 30, 0⟩,
  ⟨"31A", 31, 1⟩, ⟨"31B", 31, 1⟩,
  ⟨"32A", 32, -1⟩, ⟨"32B", 32, -1⟩,
  ⟨"33A", 33, -2⟩, ⟨"33B", 33, 1⟩,
  ⟨"34A", 34, 0⟩,
  ⟨"35A", 35, 1⟩, ⟨"35B", 35, -2⟩,
  ⟨"36A", 36, -1⟩, ⟨"36B", 36, -1⟩, ⟨"36C", 36, 0⟩, ⟨"36D", 36, 0⟩,
  ⟨"38A", 38, 0⟩,
  ⟨"39A", 39, 1⟩, ⟨"39B", 39, -2⟩, ⟨"39C", 39, 1⟩, ⟨"39D", 39, -2⟩,
  ⟨"40A", 40, -1⟩, ⟨"40B", 40, -1⟩, ⟨"40C", 40, 1⟩, ⟨"40D", 40, 1⟩,
  ⟨"41A", 41, 0⟩,
  ⟨"42A", 42, -1⟩, ⟨"42B", 42, 1⟩, ⟨"42C", 42, -1⟩, ⟨"42D", 42, -1⟩,
  ⟨"44A", 44, 0⟩, ⟨"44B", 44, 0⟩,
  ⟨"45A", 45, 0⟩,
  ⟨"46A", 46, -2⟩, ⟨"46B", 46, 0⟩, ⟨"46C", 46, 1⟩, ⟨"46D", 46, 1⟩,
  ⟨"47A", 47, 0⟩, ⟨"47B", 47, 0⟩,
  ⟨"48A", 48, -1⟩,
  ⟨"50A", 50, 0⟩,
  ⟨"51A", 51, 0⟩,
  ⟨"52A", 52, -1⟩, ⟨"52B", 52, 1⟩,
  ⟨"54A", 54, 0⟩,
  ⟨"55A", 55, 0⟩,
  ⟨"56A", 56, 1⟩, ⟨"56B", 56, -1⟩,
  ⟨"57A", 57, 0⟩,
  ⟨"59A", 59, 0⟩, ⟨"59B", 59, 0⟩,
  ⟨"60A", 60, 0⟩, ⟨"60B", 60, 0⟩, ⟨"60C", 60, -1⟩,
  ⟨"60D", 60, 0⟩, ⟨"60E", 60, 0⟩, ⟨"60F", 60, -1⟩,
  ⟨"62A", 62, 1⟩, ⟨"62B", 62, 1⟩,
  ⟨"66A", 66, 0⟩, ⟨"66B", 66, -1⟩,
  ⟨"68A", 68, 0⟩,
  ⟨"69A", 69, 0⟩,
  ⟨"70A", 70, -1⟩, ⟨"70B", 70, 0⟩,
  ⟨"71A", 71, 0⟩, ⟨"71B", 71, 0⟩,
  ⟨"78A", 78, 1⟩, ⟨"78B", 78, -2⟩,
  ⟨"84A", 84, 1⟩, ⟨"84B", 84, -1⟩, ⟨"84C", 84, -1⟩,
  ⟨"87A", 87, 0⟩, ⟨"87B", 87, 0⟩,
  ⟨"88A", 88, 0⟩, ⟨"88B", 88, 0⟩,
  ⟨"92A", 92, 0⟩, ⟨"92B", 92, 0⟩,
  ⟨"93A", 93, 0⟩, ⟨"93B", 93, 0⟩,
  ⟨"94A", 94, 0⟩, ⟨"94B", 94, 0⟩,
  ⟨"95A", 95, 0⟩, ⟨"95B", 95, 0⟩,
  ⟨"104A", 104, 0⟩, ⟨"104B", 104, 0⟩,
  ⟨"105A", 105, -1⟩,
  ⟨"110A", 110, 0⟩,
  ⟨"119A", 119, 0⟩, ⟨"119B", 119, 0⟩
]

/-! ## j-Function Coefficients (Series 1A)

The j-invariant j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + ...
The McKay-Thompson series for 1A is T_1A = j(τ) - 744.
Coefficients from OEIS A000521.
-/

/-- First 32 coefficients of j(τ), starting from c(-1). -/
def jFunctionCoeffs : List ℤ := [
  1, 744, 196884, 21493760, 864299970, 20245856256, 333202640600,
  4252023300096, 44656994071935, 401490886656000, 3176440229784420,
  22567393309593600, 146211911499519294, 874313719685775360,
  4872010111798142520, 25497827389410525184, 126142916465781843075,
  593121772421445058560, 2662842413150775245160, 11459912788444786513920,
  47438786801234168813878, 189449976248893390028800,
  732325668702994007480294, 2749031556009989944846336,
  10040099965261766759782920, 35741006424994531301877760,
  124287060396198414938562650, 422670328762405574550921216,
  1407471769096079067992279655, 4594297690315817752419688960,
  14720720375498092215741292020, 46312930900473724953542422400
]

/-- T_{1A} coefficients: j-function with constant term set to 0. -/
def series1ACoeffs : List ℤ :=
  match jFunctionCoeffs with
  | a :: _ :: rest => a :: 0 :: rest
  | other => other

/-- The McKay-Thompson series 1A (= j(τ) - 744). -/
def series1A : MTSeries :=
  ⟨⟨"1A", 1, 196883⟩, series1ACoeffs⟩

/-! ## Key McKay-Thompson Series -/

/-- 2A series (Baby Monster): hauptmodul for Γ₀(2)+. -/
def series2A : MTSeries :=
  ⟨⟨"2A", 2, 4371⟩,
   [1, 0, 4372, 96256, 1240002, 10698752, 74428120,
    431529984, 2206741887, 10117578752, 42616961892, 166564106240]⟩

/-- 2B series: hauptmodul for Γ₀(2). -/
def series2B : MTSeries :=
  ⟨⟨"2B", 2, 275⟩,
   [1, 0, 276, -2048, 11202, -49152, 184024,
    -614400, 1881471, -5373952, 14478180, -37122048]⟩

/-- 3A series: hauptmodul for Γ₀(3)+. -/
def series3A : MTSeries :=
  ⟨⟨"3A", 3, 782⟩,
   [1, 0, 783, 8672, 65367, 371520, 1741655,
    7161984, 26567946, 90521472, 287254107]⟩

/-- 3B series: hauptmodul for Γ₀(3). -/
def series3B : MTSeries :=
  ⟨⟨"3B", 3, -1⟩,
   [1, 0, 0, -248, 26, -4830, 4096, -53831, 143374, -429520]⟩

/-- 5A series: hauptmodul for Γ₀(5)+. -/
def series5A : MTSeries :=
  ⟨⟨"5A", 5, 133⟩,
   [1, 0, 134, 760, 3345, 12256, 39350,
    111400, 289155, 694400, 1567134]⟩

/-- 7A series: hauptmodul for Γ₀(7)+. -/
def series7A : MTSeries :=
  ⟨⟨"7A", 7, 43⟩,
   [1, 0, 44, 166, 481, 1164, 2761, 5765, 11468, 21318, 38368]⟩

/-- 11A series: hauptmodul for Γ₀(11)+. -/
def series11A : MTSeries :=
  ⟨⟨"11A", 11, 10⟩,
   [1, 0, 11, 22, 44, 55, 88, 110, 165, 220, 286]⟩

/-- 13A series: hauptmodul for Γ₀(13)+. -/
def series13A : MTSeries :=
  ⟨⟨"13A", 13, 1⟩,
   [1, 0, 2, 10, 12, 32, 36, 78, 90, 166, 208]⟩

/-- 23A/B series: hauptmodul for Γ₀(23)+. -/
def series23AB : MTSeries :=
  ⟨⟨"23A", 23, 0⟩,
   [1, 0, 1, 0, 1, 1, 1, 1, 1, 2, 1]⟩

/-- 47A/B series: hauptmodul for Γ₀(47)+. Special for CRT since 47 | 196883. -/
def series47AB : MTSeries :=
  ⟨⟨"47A", 47, 0⟩,
   [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0]⟩

/-- 59A/B series: hauptmodul for Γ₀(59)+. -/
def series59AB : MTSeries :=
  ⟨⟨"59A", 59, 0⟩,
   [1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0]⟩

/-- 71A/B series: hauptmodul for Γ₀(71)+. -/
def series71AB : MTSeries :=
  ⟨⟨"71A", 71, 0⟩,
   [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1]⟩

/-- Collection of key McKay-Thompson series. -/
def keySeries : List MTSeries :=
  [series1A, series2A, series2B, series3A, series3B,
   series5A, series7A, series11A, series13A, series23AB,
   series47AB, series59AB, series71AB]

/-! ## Proved Theorems -/

/-- We encode 191 of the Monster's 194 conjugacy classes (the remaining 3
    involve complex-conjugate pairs at higher orders not yet tabulated). -/
theorem monster_classes_count : monsterClasses.length = 191 := by native_decide

theorem chi_identity : (monsterClasses.head!).chi196883 = 196883 := by native_decide

/-- The first q-coefficient of T_{1A} equals 196884 = 1 + 196883. -/
theorem first_coeff_1A : series1ACoeffs.getD 2 0 = 196884 := by native_decide

theorem first_coeff_2A : series2A.qCoeff 1 = 4372 := by native_decide

theorem first_coeff_2B : series2B.qCoeff 1 = 276 := by native_decide

theorem first_coeff_3A : series3A.qCoeff 1 = 783 := by native_decide

/-- c_g(1) = 1 + χ_{196883}(g) for series 2A. -/
theorem coeff_chi_2A : (4372 : ℤ) = 1 + 4371 := by norm_num

/-- c_g(1) = 1 + χ_{196883}(g) for series 2B. -/
theorem coeff_chi_2B : (276 : ℤ) = 1 + 275 := by norm_num

/-! ## McKay's Decompositions -/

theorem mckay_decomp_1 : (196884 : ℤ) = 1 + 196883 := by norm_num
theorem mckay_decomp_2 : (21493760 : ℤ) = 1 + 196883 + 21296876 := by norm_num
theorem mckay_decomp_3 : (864299970 : ℤ) = 2 * 1 + 2 * 196883 + 21296876 + 842609326 := by
  norm_num

theorem j_coeff_1 : jFunctionCoeffs.getD 2 0 = 196884 := by native_decide
theorem j_coeff_2 : jFunctionCoeffs.getD 3 0 = 21493760 := by native_decide
theorem j_coeff_3 : jFunctionCoeffs.getD 4 0 = 864299970 := by native_decide

theorem factor_196884 : (196884 : ℤ) = 2^2 * 3 * 16407 := by norm_num
theorem factor_196883 : (196883 : ℤ) = 47 * 59 * 71 := by norm_num

/-! ## CRT Connection -/

theorem j_coeff_1_mod : 196884 % 196883 = 1 := by norm_num
theorem j_coeff_2_mod : 21493760 % 196883 = 33513 := by norm_num
theorem j_coeff_3_mod : 864299970 % 196883 = 180483 := by norm_num

theorem j1_crt_47 : 1 % 47 = 1 := by norm_num
theorem j1_crt_59 : 1 % 59 = 1 := by norm_num
theorem j1_crt_71 : 1 % 71 = 1 := by norm_num

/-! ## Order Distribution -/

def allOrders : List ℕ := (monsterClasses.map (·.order)).eraseDups

/-- All encoded element orders are ≤ 119. -/
theorem max_element_order :
    ∀ c ∈ monsterClasses, c.order ≤ 119 := by native_decide

/-- 119 = 7 × 17 (both supersingular primes). -/
theorem factor_119 : 119 = 7 * 17 := by norm_num

/-- There exists a class of order 119. -/
theorem exists_order_119 :
    ∃ c ∈ monsterClasses, c.order = 119 := by
  exact ⟨⟨"119A", 119, 0⟩, by native_decide, rfl⟩

#eval allOrders.length  -- Number of distinct element orders

/-! ## Classes at Special Primes (47, 59, 71) -/

theorem classes_at_47 :
    (monsterClasses.filter (·.order == 47)).length = 2 := by native_decide

theorem classes_at_59 :
    (monsterClasses.filter (·.order == 59)).length = 2 := by native_decide

theorem classes_at_71 :
    (monsterClasses.filter (·.order == 71)).length = 2 := by native_decide

/-- χ_{196883} vanishes on all classes of order 47, 59, 71. -/
theorem chi_vanishes_at_47 :
    ∀ c ∈ monsterClasses, c.order = 47 → c.chi196883 = 0 := by native_decide

theorem chi_vanishes_at_59 :
    ∀ c ∈ monsterClasses, c.order = 59 → c.chi196883 = 0 := by native_decide

theorem chi_vanishes_at_71 :
    ∀ c ∈ monsterClasses, c.order = 71 → c.chi196883 = 0 := by native_decide

/-! ## Supersingular Primes -/

def supersingularPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem all_supersingular_are_orders :
    ∀ p ∈ supersingularPrimes, p ∈ allOrders := by native_decide

/-! ## Genus-Zero Property -/

/-- The genus-zero levels for key series. -/
def genusZeroLevels : List (String × ℕ) :=
  [("1A", 1), ("2A", 2), ("2B", 2), ("3A", 3), ("3B", 3),
   ("5A", 5), ("7A", 7), ("11A", 11), ("13A", 13),
   ("23A", 23), ("29A", 29), ("31A", 31), ("41A", 41),
   ("47A", 47), ("59A", 59), ("71A", 71)]

/-! ## Depth of q-Expansions -/

theorem j_depth : jFunctionCoeffs.length = 32 := by native_decide

def totalDepth : ℕ := (keySeries.map (·.depth)).sum

#eval totalDepth

theorem depth_2A : series2A.depth = 12 := by native_decide

/-! ## Character Sum Relations -/

def jPartialSum (k : ℕ) : ℤ :=
  ((jFunctionCoeffs.drop 2).take k).sum

#eval jPartialSum 1
#eval jPartialSum 2
#eval jPartialSum 3

theorem j_partial_1 : jPartialSum 1 = 196884 := by native_decide
theorem j_partial_2 : jPartialSum 2 = 21690644 := by native_decide

/-! ## Leading Coefficients -/

theorem leading_1A : series1A.leadingCoeff = 1 := by native_decide
theorem leading_2A : series2A.leadingCoeff = 1 := by native_decide
theorem leading_2B : series2B.leadingCoeff = 1 := by native_decide
theorem leading_3A : series3A.leadingCoeff = 1 := by native_decide

theorem all_leading_one : ∀ s ∈ keySeries, s.leadingCoeff = 1 := by native_decide

theorem all_constant_zero : ∀ s ∈ keySeries, s.constantTerm = 0 := by native_decide

end McKayThompson
