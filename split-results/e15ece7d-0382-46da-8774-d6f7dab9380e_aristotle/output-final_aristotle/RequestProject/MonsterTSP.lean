/-
# Monster Moonshine FRACTRAN-Germ TSP: Optimal Coverage Proof

This file proves that the minimum total valuation-cost for a set of Monster
irreducible representations to achieve full coverage of all 15 supersingular
primes is **22**, achieved uniquely by the pair of irreps {2, 32}.

## Correction to the user's conjecture

The user conjectured that the minimum cost is 23, achieved by irreps {11, 13}
or by irrep 116 alone. While irreps 11 and 13 do cover all 15 primes with
cost 11 + 12 = 23, and irrep 116 alone covers all primes with cost 23,
neither is optimal. The true optimum is **22**, achieved by irreps 2 and 32:
- Irrep 2 (dim 21296876 = 2²·31·41·59·71): rowSum 6, covers {2,31,41,59,71}
- Irrep 32 (dim 31569817307122699605 = 3²·5·7·11·13²·17·19·23·29·31·41·47·59·71):
  rowSum 16, covers all primes except {2}
Together: cost 6+16 = 22, full coverage.

## Data source

Character degrees from OEIS A001379 (194 irreps, sorted by degree).
Each degree factors completely into the 15 supersingular primes.
-/

import Mathlib

/-! ## Data -/

private def rsData : Array ℕ := #[
    0, 3, 6, 7, 9, 7, 9, 11, 14, 12, 12, 11, 12, 12, 22, 19, 19, 14, 15, 16,
    17, 14, 15, 18, 15, 27, 27, 20, 20, 19, 19, 16, 16, 18, 16, 21, 22, 18, 19, 19,
    32, 32, 29, 26, 26, 32, 18, 18, 24, 31, 20, 20, 21, 21, 22, 22, 25, 19, 32, 32,
    26, 21, 23, 31, 25, 30, 24, 26, 21, 22, 32, 32, 21, 22, 22, 22, 28, 33, 25, 22,
    43, 43, 25, 25, 25, 25, 21, 23, 23, 23, 25, 26, 23, 23, 25, 28, 37, 28, 28, 28,
    30, 54, 54, 23, 33, 33, 30, 30, 22, 24, 25, 33, 29, 24, 23, 29, 23, 26, 37, 28,
    31, 33, 52, 52, 52, 35, 26, 26, 26, 30, 32, 23, 52, 26, 35, 35, 37, 26, 23, 54,
    32, 33, 30, 25, 41, 36, 23, 47, 26, 26, 30, 33, 31, 29, 30, 28, 35, 37, 44, 32,
    35, 33, 33, 33, 24, 24, 27, 32, 45, 29, 28, 51, 35, 29, 55, 34, 25, 33, 24, 24,
    55, 30, 27, 26, 26, 31, 34, 28, 33, 26, 26, 29, 56, 30]

private def bmData : Array ℕ := #[
    0, 28672, 27649, 13857, 20249, 27424, 31379, 14779, 25834, 24140, 31578, 16242, 31288, 32653, 25657, 220, 220, 32361, 25980, 27551,
    31909, 31656, 24317, 30683, 32572, 882, 882, 32022, 32181, 29558, 32270, 32556, 32766, 32741, 32758, 27373, 31263, 24509, 15737, 15737,
    2809, 2809, 31217, 10219, 10219, 30239, 30649, 30649, 16157, 32415, 32475, 32187, 12214, 12214, 28892, 28892, 24319, 32508, 25845, 25845,
    32699, 32682, 30509, 32375, 30971, 26491, 32095, 28527, 31741, 32629, 25990, 25990, 31726, 20476, 20476, 32493, 32550, 32011, 32567, 32191,
    7899, 7899, 22239, 22239, 27869, 27869, 32732, 32123, 32589, 32589, 16175, 32478, 32719, 28671, 32511, 32431, 29407, 32635, 22522, 22522,
    16050, 5425, 5425, 32574, 2939, 2939, 29554, 29554, 32761, 28670, 31165, 32713, 32443, 31734, 32763, 32755, 32767, 32635, 28045, 32255,
    31549, 23454, 11185, 11185, 11185, 32627, 23518, 14077, 14077, 30655, 30607, 32637, 15641, 32477, 8185, 8185, 27385, 30974, 32701, 26901,
    28575, 32507, 32246, 32445, 32635, 31679, 32765, 31365, 16383, 32767, 28351, 16063, 32434, 32699, 32191, 20415, 31481, 28525, 30693, 23546,
    25662, 32495, 31643, 28531, 32767, 32758, 31743, 31978, 28195, 32669, 32766, 32545, 30191, 24554, 11055, 28250, 16380, 32310, 32762, 32762,
    26953, 32478, 31981, 32381, 27644, 32698, 32299, 32767, 32590, 31613, 32703, 32655, 31059, 32614]

private theorem rsData_size : rsData.size = 194 := by native_decide
private theorem bmData_size : bmData.size = 194 := by native_decide

def irrepRowSum (i : Fin 194) : ℕ := rsData[i.val]'(by have := rsData_size; omega)
def irrepBitmask (i : Fin 194) : ℕ := bmData[i.val]'(by have := bmData_size; omega)
def fullBitmask : ℕ := 32767

/-! ## Achievability -/

/-- The pair {irrep 2, irrep 32} covers all 15 supersingular primes with cost 22. -/
theorem achievable_22 :
    irrepRowSum ⟨2, by omega⟩ + irrepRowSum ⟨32, by omega⟩ = 22 ∧
    irrepBitmask ⟨2, by omega⟩ ||| irrepBitmask ⟨32, by omega⟩ = fullBitmask := by
  native_decide

/-- The user's pair {11, 13} covers all primes but costs 23. -/
theorem pair_11_13_cost :
    irrepRowSum ⟨11, by omega⟩ + irrepRowSum ⟨13, by omega⟩ = 23 ∧
    irrepBitmask ⟨11, by omega⟩ ||| irrepBitmask ⟨13, by omega⟩ = fullBitmask := by
  native_decide

/-- Irrep 116 alone covers all primes with cost 23. -/
theorem irrep116_cost :
    irrepRowSum ⟨116, by omega⟩ = 23 ∧
    irrepBitmask ⟨116, by omega⟩ = fullBitmask := by
  native_decide

/-! ## Lower bound: no cheaper solution exists -/

/-- No single irrep covers all primes with cost < 22. -/
theorem no_cheaper_single : ∀ i : Fin 194,
    irrepBitmask i = fullBitmask → irrepRowSum i ≥ 22 := by
  native_decide

/-- No pair covers all primes with total cost < 22. -/
theorem no_cheaper_pair : ∀ i j : Fin 194,
    irrepBitmask i ||| irrepBitmask j = fullBitmask →
    irrepRowSum i + irrepRowSum j ≥ 22 := by
  native_decide

/-- No triple covers all primes with total cost < 22. -/
theorem no_cheaper_triple : ∀ i j k : Fin 194,
    irrepBitmask i ||| irrepBitmask j ||| irrepBitmask k = fullBitmask →
    irrepRowSum i + irrepRowSum j + irrepRowSum k ≥ 22 := by
  native_decide

/-- Every nonzero rowSum is ≥ 3. -/
theorem min_nonzero_rowSum_ge_3 : ∀ i : Fin 194,
    irrepRowSum i > 0 → irrepRowSum i ≥ 3 := by
  native_decide

/-- There are exactly 4 irreps with 0 < rowSum ≤ 7 and their total is 23. -/
theorem four_cheapest_nonzero :
    (Finset.univ.filter (fun i : Fin 194 => 0 < irrepRowSum i ∧ irrepRowSum i ≤ 7)).card = 4 ∧
    (Finset.univ.filter (fun i : Fin 194 => 0 < irrepRowSum i ∧ irrepRowSum i ≤ 7)).sum
      irrepRowSum = 23 := by
  native_decide

/-- Every nonzero rowSum that's ≤ 7 is at least 3, and every rowSum > 7 is ≥ 8. -/
theorem rowSum_gap : ∀ i : Fin 194, irrepRowSum i > 0 → irrepRowSum i ≤ 7 ∨ irrepRowSum i ≥ 8 := by
  native_decide

/-! ## The k ≥ 4 bound

For any Finset S of distinct irrep indices with |S| ≥ 4 and ∀ i ∈ S, irrepRowSum i > 0,
we have S.sum irrepRowSum ≥ 22.

**Proof sketch** (by cases on |S ∩ T| where T = {i | 0 < rowSum i ≤ 7}, |T| = 4):
- |S ∩ T| = 0: all ≥ 8, sum ≥ 4·8 = 32 ≥ 22 ✓
- |S ∩ T| = 1: 1 elem ≥ 3, ≥ 3 elems ≥ 8, sum ≥ 3 + 24 = 27 ✓
- |S ∩ T| = 2: 2 elems ≥ 3+6=9, ≥ 2 elems ≥ 8, sum ≥ 9 + 16 = 25 ✓
- |S ∩ T| = 3: 3 elems ≥ 3+6+7=16, ≥ 1 elem ≥ 8, sum ≥ 16 + 8 = 24 ✓
- |S ∩ T| = 4: S ⊇ T, T.sum = 23, sum ≥ 23 ✓ -/

/-- The cheapest 2 of the 4 low-cost irreps sum to ≥ 9.
    (They are irreps 1 and 2 with rowSums 3 and 6.) -/
theorem cheapest_two_sum :
    (Finset.univ.filter (fun i : Fin 194 => 0 < irrepRowSum i ∧ irrepRowSum i ≤ 6)).card ≤ 2 ∧
    ∀ (a b : Fin 194), irrepRowSum a > 0 → irrepRowSum b > 0 →
      irrepRowSum a ≤ 7 → irrepRowSum b ≤ 7 → a ≠ b →
      irrepRowSum a + irrepRowSum b ≥ 9 := by
  native_decide

/-- The cheapest 3 of the low-cost irreps sum to ≥ 16. -/
theorem cheapest_three_sum :
    ∀ (a b c : Fin 194),
      irrepRowSum a > 0 → irrepRowSum b > 0 → irrepRowSum c > 0 →
      irrepRowSum a ≤ 7 → irrepRowSum b ≤ 7 → irrepRowSum c ≤ 7 →
      a ≠ b → a ≠ c → b ≠ c →
      irrepRowSum a + irrepRowSum b + irrepRowSum c ≥ 16 := by
  native_decide

/-- The 4 irreps with rowSum ≤ 7 are exactly {1,2,3,5} and their specific values. -/
theorem low_cost_irreps_are :
    ∀ i : Fin 194, 0 < irrepRowSum i → irrepRowSum i ≤ 7 →
    (i = ⟨1, by omega⟩ ∧ irrepRowSum i = 3) ∨
    (i = ⟨2, by omega⟩ ∧ irrepRowSum i = 6) ∨
    (i = ⟨3, by omega⟩ ∧ irrepRowSum i = 7) ∨
    (i = ⟨5, by omega⟩ ∧ irrepRowSum i = 7) := by
  native_decide

/-
Any Finset of 4+ distinct nonzero-cost irreps has total cost ≥ 22.
    This uses the case analysis on how many elements have rowSum ≤ 7.
-/
theorem four_plus_ge_22 (S : Finset (Fin 194)) (hcard : S.card ≥ 4)
    (hpos : ∀ i ∈ S, irrepRowSum i > 0) :
    S.sum irrepRowSum ≥ 22 := by
  -- Let's denote the set of irreps in S with rowSum ≤ 7 by T.
  set T := S.filter (fun i => irrepRowSum i ≤ 7)
  set U := S.filter (fun i => irrepRowSum i > 7);
  -- By definition of $T$ and $U$, we have $S = T ∪ U$ and $T ∩ U = ∅$.
  have h_union : S = T ∪ U := by
    grind +qlia
  have h_disjoint : Disjoint T U := by
    exact Finset.disjoint_filter.mpr fun _ _ _ _ => by linarith;
  -- By definition of $T$ and $U$, we have $|T| ≤ 4$ and $|U| ≥ 4 - |T|$.
  have h_card_T : T.card ≤ 4 := by
    have hT_card : T.card ≤ (Finset.univ.filter (fun i : Fin 194 => 0 < irrepRowSum i ∧ irrepRowSum i ≤ 7)).card := by
      exact Finset.card_le_card fun x hx => by simpa using ⟨ hpos x ( Finset.mem_filter.mp hx |>.1 ), Finset.mem_filter.mp hx |>.2 ⟩ ;
    exact hT_card.trans ( by native_decide )
  have h_card_U : U.card ≥ 4 - T.card := by
    grind;
  -- By definition of $T$ and $U$, we have $T.sum irrepRowSum ≥ 3 * T.card$ and $U.sum irrepRowSum ≥ 8 * U.card$.
  have h_sum_T : T.sum irrepRowSum ≥ 3 * T.card := by
    exact le_trans ( by norm_num; linarith ) ( Finset.sum_le_sum fun i hi => show irrepRowSum i ≥ 3 from min_nonzero_rowSum_ge_3 i <| hpos i <| Finset.mem_filter.mp hi |>.1 )
  have h_sum_U : U.sum irrepRowSum ≥ 8 * U.card := by
    exact le_trans ( by norm_num; linarith ) ( Finset.sum_le_sum fun i hi => show irrepRowSum i ≥ 8 from by linarith [ Finset.mem_filter.mp hi ] );
  rw [ h_union, Finset.sum_union h_disjoint ];
  interval_cases _ : Finset.card T <;> norm_num at *;
  · grind;
  · grind +splitImp;
  · linarith;
  · have := Finset.card_eq_three.mp ‹_›;
    rcases this with ⟨ x, y, z, hxy, hxz, hyz, hT ⟩ ; simp +decide [ hT ] at *;
    grind +suggestions;
  · -- Since $|T| = 4$, we know that $T$ contains exactly the four irreps with rowSum ≤ 7.
    have hT_eq : T = Finset.univ.filter (fun i => 0 < irrepRowSum i ∧ irrepRowSum i ≤ 7) := by
      refine' Finset.eq_of_subset_of_card_le ( fun i hi => _ ) _ <;> norm_num at *;
      · exact ⟨ hpos i ( Finset.mem_filter.mp hi |>.1 ), Finset.mem_filter.mp hi |>.2 ⟩;
      · exact le_trans ( by native_decide ) ( ‹T.card = 4›.ge );
    exact le_trans ( by native_decide ) ( add_le_add ( hT_eq.symm ▸ four_cheapest_nonzero.2.ge ) ( Nat.zero_le _ ) )

/-! ## Main theorem -/

/-- The minimum total cost for full supersingular prime coverage is exactly 22,
    achieved uniquely by the pair {irrep 2, irrep 32}. -/
theorem optimal_cost_eq_22 :
    (∃ i j : Fin 194, irrepRowSum i + irrepRowSum j = 22 ∧
      irrepBitmask i ||| irrepBitmask j = fullBitmask) ∧
    (∀ i j : Fin 194, irrepBitmask i ||| irrepBitmask j = fullBitmask →
      irrepRowSum i + irrepRowSum j ≥ 22) := by
  exact ⟨⟨⟨2, by omega⟩, ⟨32, by omega⟩, achievable_22⟩, no_cheaper_pair⟩

/-- The pair {2, 32} is the unique optimal pair. -/
theorem unique_optimal_pair : ∀ i j : Fin 194,
    irrepBitmask i ||| irrepBitmask j = fullBitmask →
    irrepRowSum i + irrepRowSum j = 22 →
    (i = ⟨2, by omega⟩ ∧ j = ⟨32, by omega⟩) ∨
    (i = ⟨32, by omega⟩ ∧ j = ⟨2, by omega⟩) := by
  native_decide

/-- Only 4 irreps individually cover all 15 primes: 116, 149, 164, 187. -/
theorem single_full_coverage : ∀ i : Fin 194,
    irrepBitmask i = fullBitmask →
    i = ⟨116, by omega⟩ ∨ i = ⟨149, by omega⟩ ∨ i = ⟨164, by omega⟩ ∨ i = ⟨187, by omega⟩ := by
  native_decide