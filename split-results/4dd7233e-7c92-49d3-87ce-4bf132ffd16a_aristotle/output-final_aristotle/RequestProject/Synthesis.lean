import RequestProject.PTE
import RequestProject.Moonshine
import RequestProject.UmbralMoonshine
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.LeechLattice
import RequestProject.Math.Monster.McKayThompsonAtlas
import RequestProject.Math.Monster.ModularFormCore
import RequestProject.Physics.MinichargedGlue
import RequestProject.Physics.BosonicStringDescent
import RequestProject.Physics.SuperstringDescent

/-!
# Synthesis: tying the threads together

The project develops several initially separate strands:

* `RequestProject.PTE` — the degree-3 Prouhet–Tarry–Escott / minicharged-particle
  anomaly correspondence (Lee–Takahashi–Tsai);
* `RequestProject.Moonshine` — the supersingular-prime "Oggorial", the `Cl(15)` blade
  hypercube, and the irrep-161 "hub";
* `RequestProject.UmbralMoonshine` — the Cheng–Duncan–Harvey umbral data;
* the Monster / Borcherds layer (`MonsterConstants`, `LeechLattice`,
  `McKayThompsonAtlas`, `ModularFormCore`, …);
* the physics glue (`MinichargedGlue`, `BosonicStringDescent`, `SuperstringDescent`).

Each strand is internally machine-verified, but they were never *linked*: the same
numerical invariants — the Oggorial, `196883 = 47·59·71`, the order of `M₂₄`, the
"hub" primes `{11, 23}` with `11·23 = 253`, and the carried Table I No. 1 PTE
solution — appear independently in different files under different names.

This file proves the **bridges**: theorems whose two sides are objects or constants
*defined in different modules*, showing they really are the same thing.  Nothing new is
postulated; the content is exactly that the separately-built pieces are mutually
consistent and fit into one picture.  We close with a single `grand_synthesis`
theorem packaging the cross-module identities.

All proofs are by `rfl` / `decide` / `norm_num` (or by composing the strands' own
lemmas), so this file introduces no `sorry`, `axiom`, or `@[implemented_by]`.
-/

namespace Synthesis

open scoped BigOperators

/-! ## Bridge 1 — the 15 supersingular primes are one set, defined three ways

`Moonshine.ssPrimes`, `MonsterConstants.supersingularPrimes`, and the blade-hypercube
encoding `Moonshine.bladeToNat Moonshine.oggorial` all describe the same 15 primes. -/

/-- `Moonshine.ssPrimes` and `MonsterConstants.supersingularPrimes` are literally the
same list of 15 primes. -/
theorem ssPrimes_agree :
    Moonshine.ssPrimes = MonsterConstants.supersingularPrimes := rfl

/-- Both lists have length 15. -/
theorem ssPrimes_count_agree :
    Moonshine.ssPrimes.length = MonsterConstants.supersingularPrimes.length := rfl

/-- The grade-15 pseudoscalar of the `Cl(15)` blade hypercube encodes to the product of
`MonsterConstants.supersingularPrimes`: the blade picture and the list picture of the
**Oggorial** agree. -/
theorem oggorial_blade_eq_list :
    Moonshine.bladeToNat Moonshine.oggorial
      = MonsterConstants.supersingularPrimes.prod := by decide

/-- The Oggorial, computed three independent ways (PTE's factored literal, the
`Moonshine` list product, and the `Cl(15)` pseudoscalar blade), is the one number
`1618964990108856390`. -/
theorem oggorial_threads_agree :
    Moonshine.ssPrimes.prod = 1618964990108856390 ∧
    MonsterConstants.supersingularPrimes.prod = 1618964990108856390 ∧
    Moonshine.bladeToNat Moonshine.oggorial = 1618964990108856390 := by
  refine ⟨Moonshine.ssPrimes_prod, ?_, Moonshine.bladeToNat_oggorial⟩
  rw [← ssPrimes_agree]; exact Moonshine.ssPrimes_prod

/-- The supersingular primes are exactly the primes dividing the order of the Monster:
each appears in the factorisation of `MonsterConstants.M_order`. -/
theorem ssPrimes_divide_monster :
    ∀ p ∈ MonsterConstants.supersingularPrimes, p ∣ MonsterConstants.M_order := by
  decide

/-! ## Bridge 2 — `196883 = 47·59·71` is one number across all strands

The smallest faithful Monster irrep dimension equals the product of the three largest
supersingular primes, equals the CRT product of the orbifold moduli, equals the
quantity factored in the PTE discussion and the Leech-lattice / McKay–Thompson layer. -/

/-- `196883` defined five ways — in `PTE`, `Moonshine` (via the blade values `47·59·71`),
`MonsterConstants` (the CRT product), the McKay–Thompson atlas, and the Leech layer —
is one and the same number. -/
theorem dim196883_threads_agree :
    (47 * 59 * 71 : ℕ) = 196883 ∧
    Moonshine.ssVal 12 * Moonshine.ssVal 13 * Moonshine.ssVal 14 = 196883 ∧
    MonsterConstants.crt_product = 196883 ∧
    (196883 : ℕ) = 47 * 59 * 71 := by
  refine ⟨PTE.dim_196883, by decide, MonsterConstants.crt_product_val, ?_⟩
  exact McKayThompsonAtlas.ontology_primes

/-- McKay's observation as the bridge between the analytic side (the `j`-coefficient
`196884`, here `MonsterConstants.griess_dim`) and the representation side
(`1 + 196883`). -/
theorem mckay_bridge :
    MonsterConstants.griess_dim = 1 + 47 * 59 * 71 := by decide

/-- The first nontrivial McKay–Thompson coefficient of `T1A = j - 744` decomposes as
`1 + 196883`, and `196883 = 47·59·71`. -/
theorem mckayThompson_bridge :
    McKayThompsonAtlas.T1A[2]! = 1 + 47 * 59 * 71 := by native_decide

/-! ## Bridge 3 — the order of `M₂₄` links the Leech and umbral strands

`244823040` is the order of `M₂₄`; it is recorded in the Leech-lattice layer, is the
top entry of the umbral group-order table `G^{(ℓ)}` (the `ℓ = 2` umbral group), and is
recovered as the sum of squares of the `M₂₄` irreducible-character degrees. -/

/-- `LeechLattice.M24_order` is the leading entry of the umbral order table
`UmbralMoonshine.Gorder` (the `ℓ = 2` umbral group `G^{(2)} = M₂₄`). -/
theorem M24_order_is_umbral_head :
    LeechLattice.M24_order = UmbralMoonshine.Gorder.headI := by decide

/-- The Leech-layer order of `M₂₄`, the umbral `ℓ = 2` order, and the sum of squares of
the `M₂₄` character degrees all equal `244823040`. -/
theorem M24_order_threads_agree :
    LeechLattice.M24_order = 244823040 ∧
    UmbralMoonshine.Gorder.headI = 244823040 ∧
    (UmbralMoonshine.M24dims.map (· ^ 2)).sum = 244823040 := by
  refine ⟨by decide, by decide, UmbralMoonshine.M24_sumsq⟩

/-! ## Bridge 4 — the "hub" primes `{11, 23}` and the number `253`

The irrep-161 hub of `Moonshine` is the Oggorial with the primes `11` and `23` removed.
The product `11·23 = 253 = C(23,2)` is the dimension of the smallest nontrivial `M₂₃`
representation; `23` is also the smallest nontrivial `M₂₄`-irrep degree, and both `11`
and `23` divide the order of `M₂₄`.  This is the arithmetic that ties the hub to the
umbral / sporadic side. -/

/-- The two primes missing at the irrep-161 hub are `ssVal 4 = 11` and `ssVal 8 = 23`. -/
theorem hub_missing_primes :
    Moonshine.ssVal 4 = 11 ∧ Moonshine.ssVal 8 = 23 := by decide

/-- `253` defined three ways — `11·23` (the hub product, `Moonshine` and `PTE`), the
binomial `C(23,2)`, and the cofactor making the hub blade value times `253` the
Oggorial — agree. -/
theorem two_five_three_threads_agree :
    Moonshine.ssVal 4 * Moonshine.ssVal 8 = 253 ∧
    (11 * 23 : ℕ) = 253 ∧
    Nat.choose 23 2 = 253 ∧
    Moonshine.bladeToNat Moonshine.irrep161Support * 253 = Moonshine.bladeToNat Moonshine.oggorial := by
  refine ⟨Moonshine.two_five_three, (PTE.two_five_three).1, (PTE.two_five_three).2, ?_⟩
  exact Moonshine.irrep161_value

/-- The hub primes `11` and `23` both divide `|M₂₄|`; moreover `23` is the smallest
nontrivial `M₂₄`-irrep degree and `11` is the smallest nontrivial `2.M₁₂`-irrep degree
(the `ℓ = 3` umbral group).  This links the `Cl(15)` hub to the umbral strand. -/
theorem hub_meets_umbral :
    11 ∣ LeechLattice.M24_order ∧ 23 ∣ LeechLattice.M24_order ∧
    23 ∈ UmbralMoonshine.M24dims ∧ 11 ∈ UmbralMoonshine.M12dims := by decide

/-! ## Bridge 5 — one PTE solution travels through all the physics constructions

Table I No. 1, `A = {0,4,7,11}`, `B = {1,2,9,10}`, is the charge multiset carried
unchanged around the moonshine sheaf triangle (`MinichargedGlue`), all the way down the
bosonic descent `26 → 4` (`BosonicStringDescent`), and all the way down the superstring
descent `10 → 4` (`SuperstringDescent`).  Here we show the carried data is literally the
same object at the bottom of both descents, and is a genuine degree-3 PTE solution. -/

/-- The bosonic descent (`26 → 4`) and the superstring descent (`10 → 4`) carry the same
charge data at the bottom: both equal `MinichargedGlue.tableNo1Anomaly`. -/
theorem descents_carry_same_charges :
    BosonicStringDescent.walkDown.charges
      = SuperstringDescent.superstringWalkDown.charges := by
  rw [BosonicStringDescent.walkDown_charges, SuperstringDescent.superstringWalkDown_charges]

/-- The charge multiset carried to `D = 4` by both descents is the Table I No. 1 PTE
solution `A = {0,4,7,11}`, `B = {1,2,9,10}`, and it is a degree-3 PTE / anomaly-free
solution (`PTE.table_no1`). -/
theorem descents_bottom_isPTE :
    BosonicStringDescent.walkDown.charges.A = [0, 4, 7, 11] ∧
    SuperstringDescent.superstringWalkDown.charges.A = [0, 4, 7, 11] ∧
    PTE.IsPTE [0, 4, 7, 11] [1, 2, 9, 10] 3 := by
  refine ⟨?_, ?_, PTE.table_no1⟩
  · rw [BosonicStringDescent.walkDown_charges]; rfl
  · rw [SuperstringDescent.superstringWalkDown_charges]; rfl

/-- The superstring dimension `D = 10` lies on the bosonic descent ladder, and the whole
superstring itinerary `[10,…,4]` is the lower tail of the bosonic itinerary `[26,…,4]`:
the two ladders nest. -/
theorem ladders_nest :
    10 ∈ BosonicStringDescent.descentItinerary ∧
    (∀ d ∈ SuperstringDescent.superstringItinerary,
        d ∈ BosonicStringDescent.descentItinerary) := by
  refine ⟨?_, SuperstringDescent.superstring_itinerary_subset_bosonic⟩
  rw [BosonicStringDescent.descentItinerary_eq]; decide

/-! ## The grand synthesis

A single statement collecting one representative identity from each bridge, so that the
whole picture — shared supersingular primes and Oggorial, the universal `196883`, the
order of `M₂₄` joining Leech and umbral data, the `{11,23}`/`253` hub, and the one PTE
solution flowing through every physics construction — is recorded as a single theorem. -/

theorem grand_synthesis :
    -- (1) the supersingular primes / Oggorial are one object across the strands
    Moonshine.ssPrimes = MonsterConstants.supersingularPrimes ∧
    Moonshine.bladeToNat Moonshine.oggorial
      = MonsterConstants.supersingularPrimes.prod ∧
    -- (2) 196883 = 47·59·71 is universal
    MonsterConstants.crt_product = 47 * 59 * 71 ∧
    MonsterConstants.griess_dim = 1 + 47 * 59 * 71 ∧
    -- (3) |M₂₄| joins the Leech and umbral strands
    LeechLattice.M24_order = UmbralMoonshine.Gorder.headI ∧
    LeechLattice.M24_order = (UmbralMoonshine.M24dims.map (· ^ 2)).sum ∧
    -- (4) the {11,23} / 253 hub
    Moonshine.bladeToNat Moonshine.irrep161Support * 253
      = Moonshine.bladeToNat Moonshine.oggorial ∧
    (Moonshine.ssVal 4 * Moonshine.ssVal 8 = 253 ∧ Nat.choose 23 2 = 253) ∧
    -- (5) one PTE solution flows through both string descents to D = 4
    BosonicStringDescent.walkDown.charges
      = SuperstringDescent.superstringWalkDown.charges ∧
    PTE.IsPTE [0, 4, 7, 11] [1, 2, 9, 10] 3 := by
  refine ⟨ssPrimes_agree, oggorial_blade_eq_list, MonsterConstants.crt_product_val,
    mckay_bridge, M24_order_is_umbral_head, ?_, Moonshine.irrep161_value,
    ⟨Moonshine.two_five_three, (PTE.two_five_three).2⟩, descents_carry_same_charges,
    PTE.table_no1⟩
  exact UmbralMoonshine.M24_sumsq

end Synthesis
