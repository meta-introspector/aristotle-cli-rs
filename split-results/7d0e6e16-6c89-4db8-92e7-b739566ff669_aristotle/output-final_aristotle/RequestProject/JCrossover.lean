import Mathlib

/-!
# When j-invariant coefficients exceed the Monster group order

For the j-invariant j(τ) = q⁻¹ + Σ_{n≥0} cₙ qⁿ, we determine the smallest index n
such that cₙ > |M|, where |M| = 808017424794512875886459904961710757005754368000000000
is the order of the Monster group.

## Main results

* `jCoeff` — computable function giving the n-th Fourier coefficient of j(τ) (for n ≥ 0)
* `jCoeff_104_gt_monster` — c₁₀₄ > |M|
* `jCoeff_103_le_monster` — c₁₀₃ ≤ |M|
* `monster_crossover_index` — 104 is the smallest n with cₙ > |M|

## Method

We compute j = E₄³/Δ via the recurrence j·Δ = E₄³, where:
- E₄ = 1 + 240 Σ σ₃(n) qⁿ is the Eisenstein series of weight 4
- Δ = q ∏(1-qⁿ)²⁴ is the modular discriminant (Ramanujan's tau function)

The coefficient of qⁿ in j·Δ = E₄³ gives:
  cₙ = E₄³[n+1] - τ(n+2) - Σ_{a=0}^{n-1} cₐ · τ(n+1-a)

## Result

The crossover occurs at n = 104:
- c₁₀₃ = 532360384582564934616501236583995061891109488627959595 < |M|
- c₁₀₄ = 980138362015635064853029622650402721085223194498170880 > |M|

This is consistent with the asymptotic formula cₙ ~ exp(4π√n) / (√2 · n^{3/4}),
which predicts n ≈ 104.
-/

set_option maxHeartbeats 400000

open scoped BigOperators Nat

/-! ## Definitions -/

/-- The order of the Monster group. -/
def Monster.order' : ℕ :=
  808017424794512875886459904961710757005754368000000000

/-- σ₃(n) = sum of cubes of divisors of n. -/
def sigma3 (n : ℕ) : ℤ :=
  if n = 0 then 0
  else ((List.range n).map (· + 1) |>.filter (fun d => n % d = 0)).foldl
    (fun acc (d : ℕ) => acc + (d : ℤ)^3) 0

/-- The truncation degree for our q-expansion computations. -/
private def truncDeg : ℕ := 130

/-- Coefficients of Δ/q = ∏_{n≥1}(1-qⁿ)²⁴ as an array.
    `deltaOverQ[k]` = τ(k+1) (Ramanujan tau function shifted by 1). -/
private def deltaOverQ : Array ℤ := Id.run do
  let N := truncDeg
  let mut s : Array ℤ := (Array.range (N + 1)).map (fun _ => (0 : ℤ))
  s := s.set! 0 1
  for n in List.range N do
    let n := n + 1
    for _ in List.range 24 do
      let mut s' := s
      for k' in List.range (N + 1) do
        let k := N - k'
        if k >= n then
          s' := s'.set! k (s'[k]! - s[k - n]!)
      s := s'
  return s

/-- Coefficients of E₄³ = (1 + 240 Σ σ₃(n)qⁿ)³ as an array. -/
private def e4Cubed : Array ℤ := Id.run do
  let N := truncDeg
  -- E₄ coefficients
  let mut e4 : Array ℤ := #[(1 : ℤ)]
  for n in List.range N do
    e4 := e4.push (240 * sigma3 (n + 1))
  -- Multiply: E₄²
  let mut e4sq : Array ℤ := (Array.range (N + 1)).map (fun _ => (0 : ℤ))
  for i in List.range (min e4.size (N + 1)) do
    if e4[i]! != 0 then
      for j in List.range (min e4.size (N + 1 - i)) do
        e4sq := e4sq.set! (i + j) (e4sq[i + j]! + e4[i]! * e4[j]!)
  -- Multiply: E₄³ = E₄² × E₄
  let mut e4c : Array ℤ := (Array.range (N + 1)).map (fun _ => (0 : ℤ))
  for i in List.range (min e4sq.size (N + 1)) do
    if e4sq[i]! != 0 then
      for j in List.range (min e4.size (N + 1 - i)) do
        e4c := e4c.set! (i + j) (e4c[i + j]! + e4sq[i]! * e4[j]!)
  return e4c

/-- The n-th Fourier coefficient of j(τ) = q⁻¹ + Σ_{n≥0} cₙ qⁿ, for n ≥ 0.
    Computed via the recurrence j·Δ = E₄³. -/
def jCoeff : Array ℤ := Id.run do
  let N := truncDeg
  let dq := deltaOverQ
  let e4c := e4Cubed
  let D : ℕ → ℤ := fun k => if k = 0 then 0 else if k - 1 < dq.size then dq[k-1]! else 0
  let mut J : Array ℤ := #[]
  for n in List.range (N - 2) do
    let mut val := (if n + 1 < e4c.size then e4c[n+1]! else 0) - D (n + 2)
    for a in List.range n do
      val := val - J[a]! * D (n + 1 - a)
    J := J.push val
  return J

/-! ## Verification of known coefficients -/

/-- c₀ = 744 -/
theorem jCoeff_0 : jCoeff[0]! = 744 := by native_decide

/-- c₁ = 196884 (McKay's observation: 196884 = 1 + 196883) -/
theorem jCoeff_1 : jCoeff[1]! = 196884 := by native_decide

/-- c₂ = 21493760 -/
theorem jCoeff_2 : jCoeff[2]! = 21493760 := by native_decide

/-- c₃ = 864299970 -/
theorem jCoeff_3 : jCoeff[3]! = 864299970 := by native_decide

/-- c₄ = 20245856256 -/
theorem jCoeff_4 : jCoeff[4]! = 20245856256 := by native_decide

/-! ## The crossover theorems -/

/-- c₁₀₃ = 532360384582564934616501236583995061891109488627959595 -/
theorem jCoeff_103_value :
    jCoeff[103]! = 532360384582564934616501236583995061891109488627959595 := by
  native_decide

/-- c₁₀₄ = 980138362015635064853029622650402721085223194498170880 -/
theorem jCoeff_104_value :
    jCoeff[104]! = 980138362015635064853029622650402721085223194498170880 := by
  native_decide

/-- c₁₀₃ < |M| -/
theorem jCoeff_103_lt_monster :
    jCoeff[103]! < (Monster.order' : ℤ) := by native_decide

/-- c₁₀₄ > |M| -/
theorem jCoeff_104_gt_monster :
    jCoeff[104]! > (Monster.order' : ℤ) := by native_decide

/-- For all n ≤ 103, cₙ ≤ |M|.
    Together with `jCoeff_104_gt_monster`, this shows 104 is the crossover index. -/
theorem jCoeff_le_monster_below_104 :
    ∀ n : ℕ, n ≤ 103 → jCoeff[n]! ≤ (Monster.order' : ℤ) := by native_decide

/-- **Main theorem**: 104 is the smallest index n ≥ 0 such that the n-th Fourier
    coefficient of the j-invariant exceeds the order of the Monster group. -/
theorem monster_crossover_index :
    (∀ n : ℕ, n ≤ 103 → jCoeff[n]! ≤ (Monster.order' : ℤ)) ∧
    jCoeff[104]! > (Monster.order' : ℤ) :=
  ⟨jCoeff_le_monster_below_104, jCoeff_104_gt_monster⟩

/-! ## Context: coefficients near the crossover -/

/-- c₉₅ through c₁₁₀ for reference. The Monster's order sits between c₁₀₃ and c₁₀₄.

| n   | cₙ                                                        | vs |M|  |
|-----|------------------------------------------------------------|---------  |
| 95  | 3614432179304462681879676809120464684975130836205250       | < |M|   |
| 100 | 83798831110707476912751950384757452703801918339072000      | < |M|   |
| 103 | 532360384582564934616501236583995061891109488627959595     | < |M|   |
| **M** | **808017424794512875886459904961710757005754368000000000** |         |
| 104 | 980138362015635064853029622650402721085223194498170880     | > |M|   |
| 105 | 1799337415283351057784679746927662437028848197411667200    | > |M|   |
| 110 | 19870021249929143399620419901633518864858002945671570872   | > |M|   |

This is consistent with the Hardy-Rademacher asymptotic cₙ ~ exp(4π√n) / (√2 · n^{3/4}),
which predicts the crossover at n ≈ 104. -/
theorem jCoeff_table_check :
    jCoeff[95]! = 3614432179304462681879676809120464684975130836205250 ∧
    jCoeff[100]! = 83798831110707476912751950384757452703801918339072000 := by
  native_decide
