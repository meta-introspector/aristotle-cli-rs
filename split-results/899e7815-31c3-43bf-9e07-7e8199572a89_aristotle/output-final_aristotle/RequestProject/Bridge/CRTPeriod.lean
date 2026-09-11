/-
  CRTPeriod.lean — Port of CRTPeriod.agda: digit function periodicity.
-/
import Mathlib

def digitFn (N : ℕ) : ℕ := ((N % 71) + (N % 59) + (N % 47)) % 10

def period : ℕ := 71 * 59 * 47

theorem period_eq : period = 196883 := by norm_num [period]

/-- d(N + k * period) = d(N): the digit function is periodic. -/
theorem period_thm (N k : ℕ) : digitFn (N + k * period) = digitFn N := by
  simp only [digitFn, period]
  have h71 : (N + k * (71 * 59 * 47)) % 71 = N % 71 := by omega
  have h59 : (N + k * (71 * 59 * 47)) % 59 = N % 59 := by omega
  have h47 : (N + k * (71 * 59 * 47)) % 47 = N % 47 := by omega
  rw [h71, h59, h47]

theorem crt_coprime_71_59 : Nat.Coprime 71 59 := by decide
theorem crt_coprime_71_47 : Nat.Coprime 71 47 := by decide
theorem crt_coprime_59_47 : Nat.Coprime 59 47 := by decide

theorem stage1_product : 71 * 59 * 47 = 196883 := by norm_num
theorem stage2_product : 4 * 41 * 31 = 5084 := by norm_num
theorem stage3_is_square : 169 = 13 ^ 2 := by norm_num

theorem digitFn_0 : digitFn 0 = 0 := by native_decide
theorem digitFn_1 : digitFn 1 = 3 := by native_decide
theorem digitFn_196883 : digitFn 196883 = 0 := by native_decide
