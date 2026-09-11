/-
# Dimension-Product Optimality for Monster Irreps

## The correct metric

The "cost" of a Monster irrep ρ is simply log₂(dim ρ) — the number of
bits needed to write down its dimension. For a pair of irreps, the cost
of the tensor product is:

    log₂(dim(ρᵢ ⊗ ρⱼ)) = log₂(dim ρᵢ · dim ρⱼ)

The optimization problem is: find the pair (i, j) of *nontrivial* Monster
irreps whose tensor product has the smallest dimension, subject to the
constraint that every supersingular prime divides dim ρᵢ · dim ρⱼ.

## Main result

The optimal pair is **(ρ₇, ρ₉)**, with dimension product:

    dim ρ₇ · dim ρ₉ = 486883087066439621917809450 ≈ 4.87 × 10²⁶

This is the unique minimum among all 5217 covering pairs of nontrivial irreps.

The previous rowSum-optimal pair {2, 32} has a 38% larger dimension product:

    dim ρ₂ · dim ρ₃₂ = 672338484532446050272933980 ≈ 6.72 × 10²⁶

The rowSum analysis found the wrong answer because it treats all prime
exponents as equally costly. In reality, one power of 2 costs 1 bit,
while one power of 71 costs 6.15 bits — the unweighted sum is a proxy
that doesn't correspond to any intrinsic quantity.

## Why not the trivial representation?

If we allow i = 0 (the trivial representation, dim = 1), then the problem
degenerates to "find the single irrep of smallest dimension covering all
15 primes." That's irrep 116 with dim = 3537292796538741415074900.
But ρ₀ ⊗ ρ₁₁₆ ≅ ρ₁₁₆ — tensoring with the trivial rep does nothing.
The nontrivial constraint makes the problem genuinely about pairs.

## Data source

Character degrees from OEIS A001379 (194 irreps, sorted by degree).
Consistency with the bitmask/rowSum data in MonsterTSP.lean is verified.
-/

import Mathlib
import RequestProject.MonsterTSP

namespace MonsterDimProduct

/-! ## Character Degree Data

All 194 irreducible character degrees of the Monster group M,
in nondecreasing order (0-indexed, matching MonsterTSP.lean). -/

private def dimData : Array ℕ := #[
    1, 196883, 21296876, 842609326, 18538750076,
    19360062527, 293553734298, 3879214937598, 36173193327999, 125510727015275,
    190292345709543, 222879856734249, 1044868466775133, 1109944460516150, 2374124840062976,
    8980616927734375, 8980616927734375, 15178147608537368, 39660520552077425, 60359800576579350,
    251098487132187500, 290568421805921077, 336041615485626050, 2500435234254428856, 2986480825407204125,
    3503434660075044981, 3503434660075044981, 3605718753596953125, 8456836343580310400, 8754193822112578125,
    28585990950721640625, 30815545786259524745, 31569817307122699605, 47377503606648784400, 49609712911192813665,
    77316619273928125000, 130415350420342968750, 155943076739182582850, 172399434201593354756, 172399434201593354756,
    286243267692724486144, 286243267692724486144, 379913824694312370176, 640558364167263622626, 640558364167263622626,
    643356925889917747200, 691170144025469730622, 691170144025469730622, 776097192277137500000, 918438233727730974720,
    1201241700908448332364, 1353006807137391674268, 1480279477146615234375, 1480279477146615234375, 1768130802583126953125,
    1768130802583126953125, 2351753641814605348320, 2382987417506242421875, 4567199176912486400000, 4567199176912486400000,
    5578077210155766091776, 6566555764392010419123, 7226910362631220625000, 10145274012943412428800, 12810005542623250817856,
    19795913912408993711352, 21803647757861753437500, 24670833602960142274950, 31714653744947491918600, 41209556844092914062500,
    42940402913709544921875, 42940402913709544921875, 60683762052057587326065, 70660346341309333984375, 70660346341309333984375,
    86551489469233273849000, 91068387388302451493925, 114212876389603002704448, 115192831837135016250000, 146575737439884098045700,
    149614794149226010902528, 149614794149226010902528, 161649111002260792968750, 161649111002260792968750, 191259085113459945312500,
    191259085113459945312500, 218028402153522030021875, 220326476909636307378168, 260799524107083767968750, 260799524107083767968750,
    261575621299360905468750, 277540481294528814140625, 303379038247015811718750, 331150814995116217581480, 351532203382732066094400,
    391009081837477378329600, 392611651975065600000000, 433528694560598978525184, 597787522207315571077947, 597787522207315571077947,
    600020772685064502392907, 626877403613887304040448, 626877403613887304040448, 655159231073705404921875, 689763222744895005949242,
    689763222744895005949242, 689766726179555080994223, 689766726179555080994223, 1037605886984697481755304, 1361549126105752982272875,
    1599110387863558882812500, 1662686180483865572016128, 2181694185821505680397072, 2216343020913351966796875, 2477548750555298068681032,
    3282510540283631442175104, 3537292796538741415074900, 3619209050774375426792424, 4004308274823270400000000, 4239315652979009728125000,
    4926670174323484069683200, 5334046162969208352215625, 5514132424881463208443904, 5514132424881463208443904, 5514132424881463208443904,
    7118465328761788475375616, 7375892500409609408203125, 7567151576542452425781250, 7567151576542452425781250, 7850934959207940600000000,
    8394037047155083487634450, 8874260875527017936065100, 9416031858681585751556096, 9479495745805305653125000, 9592298143650890255171584,
    9592298143650890255171584, 9592584386918582979657728, 10023854998171489083984375, 12650882100466187033706250, 14930164283563048960000000,
    16109407269221032565630370, 22626621365160537099927552, 24546384719289825598186695, 27501917609709102247187500, 29734941419909382162874368,
    33684388830359981044531200, 33722191327002668157047380, 37310715211546624000000000, 38471795739256565080575180, 41738941151243953804687500,
    41762322738385820195625000, 42001454087954515167503490, 42601474860639579669896397, 43527130990147981755651072, 50572542024949598403750000,
    51324350389558097414062500, 56356433273146675005489152, 58437394633227526183321600, 62038057486792249132974080, 63750812845035828079008441,
    64326163427522624205703125, 66550339514356152000000000, 69084859008005036431224066, 74612213529720383654779356, 77423398454853064646282250,
    83974774459050335630859375, 86206621680977834911875000, 88943820620288343261672393, 103354104243912727763091456, 115165062362004433625000000,
    121170799240938738783416925, 124058385593021471188320256, 124982156072747647257292800, 125517264890136048242396811, 129572518017902934396764160,
    130287135266837289237316743, 135226984222789977095703125, 136107644194473772613203125, 136574874874360806036041889, 136574874874360806036041889,
    138988549876584520148320256, 161561864971171113287540625, 163216709667196367710937500, 172248852397651745653437500, 173865305251972140447265625,
    175867626988794162227008203, 177966317773633111417870812, 198203900044423845494482560, 200390867219082687273984375, 203314261261157852274218750,
    207467089840006711558593750, 212490247553365721772656250, 241866941438795926688759808, 258823477531055064045234375]

private theorem dimData_size : dimData.size = 194 := by native_decide

/-- The dimension of the i-th Monster irrep (0-indexed, sorted by degree). -/
def irrepDim (i : Fin 194) : ℕ := dimData[i.val]'(by have := dimData_size; omega)

/-! ## Consistency with MonsterTSP data

We verify that the dimension data is consistent with the bitmask data:
for each irrep i and each supersingular prime index j, the j-th bit of
irrepBitmask i is set iff the j-th supersingular prime divides irrepDim i. -/

/-- The supersingular primes, used for consistency verification. -/
private def spData : Array ℕ := #[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
private theorem spData_size : spData.size = 15 := by native_decide

/-- Bitmask consistency: for every irrep i and prime index j,
    the j-th bit of irrepBitmask i is 1 iff spData[j] divides irrepDim i. -/
theorem dim_bitmask_consistent : ∀ i : Fin 194, ∀ j : Fin 15,
    ((irrepBitmask i).testBit j.val = true) ↔
    (irrepDim i % (spData[j.val]'(by have := spData_size; omega)) = 0) := by
  native_decide

/-! ## The Optimal Pair: {7, 9}

Irrep 7 has dimension 3879214937598 = 2·3·7·11·13²·19·23·41·47·59
Irrep 9 has dimension 125510727015275 = 5²·7⁴·17·29·31·41·47·71
Their tensor product covers all 15 supersingular primes with dimension
486883087066439621917809450. -/

/-- The dimension of irrep 7. -/
theorem dim7 : irrepDim ⟨7, by omega⟩ = 3879214937598 := by native_decide

/-- The dimension of irrep 9. -/
theorem dim9 : irrepDim ⟨9, by omega⟩ = 125510727015275 := by native_decide

/-- The pair {7, 9} covers all 15 supersingular primes. -/
theorem pair_7_9_covers :
    irrepBitmask ⟨7, by omega⟩ ||| irrepBitmask ⟨9, by omega⟩ = fullBitmask := by
  native_decide

/-- The dimension product of irreps 7 and 9. -/
theorem dim_product_7_9 :
    irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ = 486883087066439621917809450 := by
  native_decide

/-! ## Optimality: no nontrivial pair is cheaper

Among all pairs (i, j) with i ≥ 1 and j ≥ 1 such that every supersingular
prime divides dim(ρᵢ) · dim(ρⱼ), the pair (7, 9) achieves the minimum
dimension product. The constraint i, j ≥ 1 excludes the trivial
representation (dim = 1), which would make the problem degenerate. -/

/-- **Main theorem**: No pair of nontrivial Monster irreps covering all
    supersingular primes has a smaller dimension product than {7, 9}. -/
theorem no_cheaper_nontrivial_pair : ∀ i j : Fin 194,
    i.val ≥ 1 → j.val ≥ 1 →
    irrepBitmask i ||| irrepBitmask j = fullBitmask →
    irrepDim i * irrepDim j ≥ irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ := by
  native_decide

/-- The pair {7, 9} is the *unique* optimal nontrivial covering pair. -/
theorem unique_optimal_nontrivial_pair : ∀ i j : Fin 194,
    i.val ≥ 1 → j.val ≥ 1 →
    irrepBitmask i ||| irrepBitmask j = fullBitmask →
    irrepDim i * irrepDim j = irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ →
    (i = ⟨7, by omega⟩ ∧ j = ⟨9, by omega⟩) ∨
    (i = ⟨9, by omega⟩ ∧ j = ⟨7, by omega⟩) := by
  native_decide

/-! ## Comparison with the rowSum-optimal pair {2, 32}

The pair {2, 32} minimizes the rowSum (unweighted exponent count) but
not the dimension product. The dimension product of {2, 32} is about
38% larger than {7, 9}'s. -/

/-- The dimension product of the rowSum-optimal pair {2, 32}. -/
theorem dim_product_2_32 :
    irrepDim ⟨2, by omega⟩ * irrepDim ⟨32, by omega⟩ = 672338484532446050272933980 := by
  native_decide

/-- The dimension product of {7, 9} is strictly less than that of {2, 32}. -/
theorem dim_7_9_lt_dim_2_32 :
    irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ <
    irrepDim ⟨2, by omega⟩ * irrepDim ⟨32, by omega⟩ := by
  native_decide

/-- The dimension product of {2, 32} is about 38% larger than {7, 9}'s.
    Specifically: 672338484532446050272933980 / 486883087066439621917809450 ≈ 1.381.
    We verify the exact ratio bounds: 1000 * prod(2,32) / prod(7,9) is between 1380 and 1382. -/
theorem dim_ratio_bound :
    1380 * (irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩) ≤
      1000 * (irrepDim ⟨2, by omega⟩ * irrepDim ⟨32, by omega⟩) ∧
    1000 * (irrepDim ⟨2, by omega⟩ * irrepDim ⟨32, by omega⟩) ≤
      1382 * (irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩) := by
  native_decide

/-! ## The trivial pairing degeneracy

If we allow the trivial representation (irrep 0, dim = 1), the problem
degenerates: the optimal "pair" is (0, 116), giving product = dim(ρ₁₁₆).
This corresponds to ρ₀ ⊗ ρ₁₁₆ ≅ ρ₁₁₆ — the trivial tensor contributes
nothing. The nontrivial constraint is essential for a meaningful problem. -/

/-- Irrep 116 alone covers all supersingular primes with the smallest
    dimension among full-coverage irreps. -/
theorem dim_116 :
    irrepDim ⟨116, by omega⟩ = 3537292796538741415074900 ∧
    irrepBitmask ⟨116, by omega⟩ = fullBitmask := by
  constructor <;> native_decide

/-- The trivial pairing (0, 116) beats the nontrivial optimum {7, 9}
    by a factor of ~137. -/
theorem trivial_pair_much_cheaper :
    irrepDim ⟨0, by omega⟩ * irrepDim ⟨116, by omega⟩ <
    irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ := by
  native_decide

/-! ## Metrics diverge: rowSum vs dimension product

The rowSum and dimension-product metrics give *different* optimal pairs:
- rowSum optimal: {2, 32} (cost 22)
- Dimension-product optimal: {7, 9} (dim ≈ 4.87 × 10²⁶)

This divergence occurs because rowSum weights all prime exponents equally
(1 unit per exponent), while the dimension product weights them by log₂(p).
One exponent of 71 costs 6.15× more than one exponent of 2 in the dimension
product, but costs the same in rowSum.

The pair {2, 32} wins in rowSum because irrep 2's exponents concentrate on
the cheapest prime (2²), gaining large rowSum savings. But in information-
theoretic terms, those 2-exponents are nearly free — the pair {7, 9}
distributes its exponents more efficiently across the prime spectrum. -/

/-- The metrics give different optimal pairs. -/
theorem metrics_diverge :
    -- {2, 32} wins in rowSum
    irrepRowSum ⟨2, by omega⟩ + irrepRowSum ⟨32, by omega⟩ <
    irrepRowSum ⟨7, by omega⟩ + irrepRowSum ⟨9, by omega⟩ ∧
    -- {7, 9} wins in dimension product
    irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ <
    irrepDim ⟨2, by omega⟩ * irrepDim ⟨32, by omega⟩ := by
  constructor <;> native_decide

/-- The rowSum costs: {7,9} costs 23 in rowSum, {2,32} costs 22. -/
theorem rowSum_costs :
    irrepRowSum ⟨7, by omega⟩ + irrepRowSum ⟨9, by omega⟩ = 23 ∧
    irrepRowSum ⟨2, by omega⟩ + irrepRowSum ⟨32, by omega⟩ = 22 := by
  constructor <;> native_decide

/-! ## Combined optimality statement -/

/-- **The full theorem**: Among all pairs (i, j) of nontrivial Monster
    irreps (i ≥ 1, j ≥ 1) such that every supersingular prime divides
    dim(ρᵢ) · dim(ρⱼ), the pair (ρ₇, ρ₉) uniquely minimizes the
    dimension product dim(ρᵢ) · dim(ρⱼ).

    The minimum dimension product is exactly 486883087066439621917809450,
    corresponding to a tensor product of dimension ≈ 4.87 × 10²⁶. -/
theorem optimal_dim_product :
    -- Achievability: {7, 9} covers all primes
    (irrepBitmask ⟨7, by omega⟩ ||| irrepBitmask ⟨9, by omega⟩ = fullBitmask) ∧
    -- Exact value
    (irrepDim ⟨7, by omega⟩ * irrepDim ⟨9, by omega⟩ = 486883087066439621917809450) ∧
    -- Optimality: no nontrivial pair is cheaper
    (∀ i j : Fin 194, i.val ≥ 1 → j.val ≥ 1 →
      irrepBitmask i ||| irrepBitmask j = fullBitmask →
      irrepDim i * irrepDim j ≥ 486883087066439621917809450) ∧
    -- Uniqueness
    (∀ i j : Fin 194, i.val ≥ 1 → j.val ≥ 1 →
      irrepBitmask i ||| irrepBitmask j = fullBitmask →
      irrepDim i * irrepDim j = 486883087066439621917809450 →
      (i = ⟨7, by omega⟩ ∧ j = ⟨9, by omega⟩) ∨
      (i = ⟨9, by omega⟩ ∧ j = ⟨7, by omega⟩)) := by
  exact ⟨pair_7_9_covers, dim_product_7_9, no_cheaper_nontrivial_pair,
         unique_optimal_nontrivial_pair⟩

end MonsterDimProduct
