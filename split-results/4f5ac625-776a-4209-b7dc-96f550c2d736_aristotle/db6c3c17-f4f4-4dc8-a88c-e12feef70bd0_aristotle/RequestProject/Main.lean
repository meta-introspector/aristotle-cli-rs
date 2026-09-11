import Mathlib

open scoped BigOperators

set_option maxHeartbeats 8000000

/-!
# Formalization of the q-expansion principle markup

We formalize the concrete mathematical content encoded in two structured markup
sections (Type5 and Type1) relating moonshine, the Monster group, Bott
periodicity, Hecke operators, and the Chinese Remainder Theorem.

We also formalize the Pareto lattice of modular/mock form weights.

## Type5 markup (previous section)
```xml
<div typeof="erdfa:SheafSection dasl:Type5" about="#bafkda5131f2f07fc80e">
  <meta property="erdfa:shard" content="4,4,25" />
  <meta property="erdfa:prime" content="1" />
  <meta property="dasl:eigenspace" content="Earth" />
  <meta property="dasl:bott" content="7 (R(8)⊕R(8))" />
  <meta property="dasl:hecke" content="T_41" />
  <meta property="sheaf:orbifold" content="(4 mod 71, 4 mod 59, 25 mod 47)" />
</div>
```

## Type1 markup (current section)
```xml
<div typeof="erdfa:SheafSection dasl:Type1" about="#bafkda51315140c2ac4f">
  <meta property="erdfa:shard" content="46,17,18" />
  <meta property="erdfa:encoding" content="raw" />
  <meta property="erdfa:prime" content="1" />
  <meta property="dasl:addr" content="0xda51132040c2ac4f" />
  <meta property="dasl:type" content="1" />
  <meta property="dasl:eigenspace" content="Earth" />
  <meta property="dasl:bott" content="4 (H(2))" />
  <meta property="dasl:hecke" content="T_47" />
  <meta property="sheaf:orbifold" content="(46 mod 71, 17 mod 59, 18 mod 47)" />
  <link property="sheaf:subgroupIndex" href="erdfa:H/raw" />
</div>
```

## Mathematical content

Both markups use the same three-prime modular lattice: `71 × 59 × 47 = 196883`,
the dimension of the Monster group's smallest faithful representation.

- **Type5 shard** `(4, 4, 25)` has CRT solution `113107 (mod 196883)`.
- **Type1 shard** `(46, 17, 18)` has CRT solution `102854 (mod 196883)`.

Bott periodicity positions 7 (real, R(8)⊕R(8)) and 4 (quaternionic, H(2))
correspond to `KO_7(pt) ≅ ℤ` and `KO_4(pt) ≅ ℤ` respectively.

The Pareto lattice of modular/mock form weights assigns relevance scores to
half-integer weights `k = 0, 1/2, 1, 3/2, 2, 5/2` and verifies the 80/20 rule:
the top 4 out of 6 weights (≈33%) capture ≥ 79% of total relevance.
-/

section Arithmetic

/-! ### Monster group dimension and moonshine -/

/-- The product of primes 71, 59, 47 equals 196883, the dimension of the
Monster group's smallest faithful representation. -/
theorem monster_rep_dim_factored : 71 * 59 * 47 = 196883 := by norm_num

/-- McKay's observation: the first nontrivial Fourier coefficient of the
j-invariant (196884) equals the Monster representation dimension plus 1. -/
theorem mckay_observation : 196883 + 1 = 196884 := by norm_num

/-- The primes 71, 59, 47 are indeed prime. -/
theorem prime_71 : Nat.Prime 71 := by decide
theorem prime_59 : Nat.Prime 59 := by decide
theorem prime_47 : Nat.Prime 47 := by decide

/-- 41 is the prime indexing the Hecke operator T_41 in the Type5 markup. -/
theorem prime_41 : Nat.Prime 41 := by decide

/-- First j-coefficient decomposition (McKay). -/
theorem j_coeff_1 : 196884 = 1 + 196883 := by norm_num

/-- Second j-coefficient decomposition into Monster irreducible dimensions. -/
theorem j_coeff_2 : 21493760 = 1 + 196883 + 21296876 := by norm_num

end Arithmetic

section CRT_Type5

/-! ### Chinese Remainder Theorem: Type5 orbifold residues

The Type5 markup encodes the triple `(4, 4, 25)` as residues modulo `(71, 59, 47)`.
By CRT the unique solution modulo `196883` is `113107`. -/

theorem crt_type5_mod_71 : 113107 % 71 = 4 := by norm_num
theorem crt_type5_mod_59 : 113107 % 59 = 4 := by norm_num
theorem crt_type5_mod_47 : 113107 % 47 = 25 := by norm_num
theorem crt_type5_bound : 113107 < 71 * 59 * 47 := by norm_num

theorem crt_type5_exists :
    (113107 : ℤ) ≡ 4 [ZMOD 71] ∧
    (113107 : ℤ) ≡ 4 [ZMOD 59] ∧
    (113107 : ℤ) ≡ 25 [ZMOD 47] := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

theorem crt_type5_unique (x y : ℤ)
    (hx71 : x ≡ 4 [ZMOD 71]) (hx59 : x ≡ 4 [ZMOD 59]) (hx47 : x ≡ 25 [ZMOD 47])
    (hy71 : y ≡ 4 [ZMOD 71]) (hy59 : y ≡ 4 [ZMOD 59]) (hy47 : y ≡ 25 [ZMOD 47]) :
    x ≡ y [ZMOD (71 * 59 * 47)] := by
  rw [Int.ModEq] at *; omega

end CRT_Type5

section CRT_Type1

/-! ### Chinese Remainder Theorem: Type1 orbifold residues

The Type1 markup encodes the triple `(46, 17, 18)` as residues modulo `(71, 59, 47)`.
By CRT the unique solution modulo `196883` is `102854`. -/

/-- The three moduli are pairwise coprime. -/
theorem coprime_71_59 : Nat.Coprime 71 59 := by decide
theorem coprime_71_47 : Nat.Coprime 71 47 := by decide
theorem coprime_59_47 : Nat.Coprime 59 47 := by decide

theorem crt_type1_mod_71 : 102854 % 71 = 46 := by norm_num
theorem crt_type1_mod_59 : 102854 % 59 = 17 := by norm_num
theorem crt_type1_mod_47 : 102854 % 47 = 18 := by norm_num
theorem crt_type1_bound : 102854 < 71 * 59 * 47 := by norm_num

theorem crt_type1_exists :
    (102854 : ℤ) ≡ 46 [ZMOD 71] ∧
    (102854 : ℤ) ≡ 17 [ZMOD 59] ∧
    (102854 : ℤ) ≡ 18 [ZMOD 47] := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

theorem crt_type1_unique (x y : ℤ)
    (hx71 : x ≡ 46 [ZMOD 71]) (hx59 : x ≡ 17 [ZMOD 59]) (hx47 : x ≡ 18 [ZMOD 47])
    (hy71 : y ≡ 46 [ZMOD 71]) (hy59 : y ≡ 17 [ZMOD 59]) (hy47 : y ≡ 18 [ZMOD 47]) :
    x ≡ y [ZMOD (71 * 59 * 47)] := by
  rw [Int.ModEq] at *; omega

end CRT_Type1

section ShardDifference

/-! ### Relationship between the two sheaf sections

The difference of the two CRT solutions modulo 196883 measures the
"shift" between the Type5 and Type1 sheaf sections over the Monster lattice. -/

/-- The difference between the two CRT solutions. -/
theorem shard_difference : 113107 - 102854 = 10253 := by norm_num

/-- Both solutions lie in the same Monster-dimension modular lattice. -/
theorem both_shards_in_lattice :
    113107 < 196883 ∧ 102854 < 196883 := by omega

end ShardDifference

section BottPeriodicity

/-! ### Bott periodicity (mod 8 structure)

Type5 references position 7: `KO_7(pt) ≅ ℤ`, denoted `R(8)⊕R(8)` (real).
Type1 references position 4: `KO_4(pt) ≅ ℤ`, denoted `H(2)` (quaternionic).
We formalize the period-8 structure arithmetically. -/

/-- Position 7 in the Bott period-8 cycle (Type5). -/
theorem bott_position_type5 : 7 % 8 = 7 := by norm_num

/-- Position 4 in the Bott period-8 cycle (Type1). -/
theorem bott_position_type1 : 4 % 8 = 4 := by norm_num

/-- The Bott period is 8. -/
theorem bott_periodicity_period : 8 > 0 ∧ ∀ n : ℤ, n % 8 = (n + 8) % 8 := by
  constructor
  · norm_num
  · intro n; omega

/-- The two Bott positions differ by 3 (mod 8), reflecting the
real → quaternionic transition in the KO-theory cycle. -/
theorem bott_position_difference : (7 - 4) % 8 = 3 := by norm_num

end BottPeriodicity

section HeckeOperator

/-! ### Hecke operators

Type5 uses `T_41` and Type1 uses `T_47`. Both 41 and 47 are prime.
47 divides the Monster representation dimension. -/

/-- 47 divides the Monster representation dimension. -/
theorem hecke_prime_divides_monster_dim : 47 ∣ 196883 := by norm_num

/-- 196883 = 71 × 59 × 47. -/
theorem monster_dim_prime_factors : 196883 = 71 * 59 * 47 := by norm_num

/-- 41 does not divide 196883 (unlike 47, it is external to the lattice). -/
theorem hecke_41_coprime_monster_dim : Nat.Coprime 41 196883 := by decide

end HeckeOperator

section MonsterOrder

/-! ### Monster group order divisibility

The Monster group order's prime factorization includes 71, 59, and 47.
We verify that 196883 divides a product of prime powers from the Monster order. -/

theorem monster_order_divisibility :
    (71 * 59 * 47 : ℕ) ∣
    (2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 *
     41 * 47 * 59 * 71) := by
  native_decide

end MonsterOrder

section ParetoWeightLattice

/-! ### Pareto lattice of modular/mock form weights

The Pareto principle (80/20 rule) applied to modular and mock modular form
weights prioritizes the rational weights `k = n/m` that appear most frequently
in moonshine/CFT contexts.

We use rational numbers to represent weights and their relevance scores:
- Weight 0 (Hauptmoduln, j-function): relevance 10
- Weight 1/2 (mock theta functions, Ramanujan): relevance 8
- Weight 1 (Eisenstein series): relevance 7
- Weight 3/2 (mock modular forms for pariahs/BPS): relevance 6
- Weight 2 (classical modular forms): relevance 5
- Weight 5/2 (higher weight mocks): relevance 3

Total relevance = 39. The top 4 weights (0, 1/2, 1, 3/2) have cumulative
relevance 31, which is 31/39 ≈ 79.5%, confirming the Pareto principle.
-/

/-- The six Pareto weights as rationals. -/
def paretoWeights : List ℚ := [0, 1/2, 1, 3/2, 2, 5/2]

/-- Relevance scores for each weight (descending order). -/
def paretoRelevances : List ℕ := [10, 8, 7, 6, 5, 3]

/-- Total relevance across all weights. -/
theorem pareto_total_relevance : paretoRelevances.sum = 39 := by native_decide

/-- The top 4 weights have cumulative relevance 31. -/
theorem pareto_top4_relevance : (paretoRelevances.take 4).sum = 31 := by native_decide

/-- The top 4 weights cover ≥ 79% of total relevance (Pareto principle).
    We verify 31 * 100 ≥ 79 * 39. -/
theorem pareto_principle_holds :
    (paretoRelevances.take 4).sum * 100 ≥ 79 * paretoRelevances.sum := by
  native_decide

/-- The weight lattice has 6 elements (half-integer spacing). -/
theorem pareto_weight_count : paretoWeights.length = 6 := by native_decide

/-- The weights form a half-integer lattice: each successive weight increases
    by 1/2. -/
theorem pareto_weights_half_integer_spacing :
    ∀ i : Fin 5, paretoWeights[i.val + 1]! - paretoWeights[i.val]! = 1/2 := by
  intro i; fin_cases i <;> native_decide

/-- Mock modular form duality: weight k pairs with shadow weight 1 - k.
    For the top Pareto weight k = 0, its dual is 1. Both are in the lattice. -/
theorem mock_duality_top_weight :
    (0 : ℚ) ∈ paretoWeights ∧ (1 - 0 : ℚ) ∈ paretoWeights := by
  constructor <;> simp [paretoWeights]

/-- For weight k = 1/2, its dual 1 - 1/2 = 1/2 (self-dual). -/
theorem mock_duality_half :
    (1/2 : ℚ) ∈ paretoWeights ∧ (1 - 1/2 : ℚ) = 1/2 := by
  constructor
  · simp [paretoWeights]
  · norm_num

/-- For weight k = 3/2, its dual 1 - 3/2 = -1/2, which is NOT in the
    non-negative Pareto lattice — the shadow falls outside the lattice,
    reflecting the "holes" in O'Nan moonshine. -/
theorem mock_duality_three_half :
    (3/2 : ℚ) ∈ paretoWeights ∧ (1 - 3/2 : ℚ) = -1/2 ∧ (-1/2 : ℚ) ∉ paretoWeights := by
  refine ⟨?_, by norm_num, ?_⟩
  · simp [paretoWeights]
  · simp [paretoWeights]; norm_num

end ParetoWeightLattice
