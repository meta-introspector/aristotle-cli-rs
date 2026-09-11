/-
# MonsterBaseExt.lean
## Extensions to the Monster CRT Base

Extends the CRT torus `ZMod 71 × ZMod 59 × ZMod 47` with:

1. **CRT Reconstruction** — injectivity of the three-projection map
2. **SSP Partition completeness** — sspA ∪ sspB = ssp, disjoint, ordered
3. **Digest characterization** — two digests are equal in Base iff
   congruent mod all three primes
4. **Fiber arithmetic** — cardinality, product structure
-/

import Mathlib

set_option maxHeartbeats 800000
namespace MonsterBaseExt

/-! ## §0. The Monster Base -/

/-- The Monster CRT base: 71 × 59 × 47 = 196883 fibers. -/
abbrev MonsterBase := ZMod 71 × ZMod 59 × ZMod 47

theorem monsterBase_card : Fintype.card MonsterBase = 196883 := by
  simp [MonsterBase, Fintype.card_prod, ZMod.card]

theorem coprime_71_59 : Nat.Coprime 71 59 := by decide
theorem coprime_71_47 : Nat.Coprime 71 47 := by decide
theorem coprime_59_47 : Nat.Coprime 59 47 := by decide

theorem moduli_product : (71 : ℕ) * 59 * 47 = 196883 := by norm_num

-- ════════════════════════════════════════════════════════════════
-- §1. CRT RECONSTRUCTION
-- ════════════════════════════════════════════════════════════════

/-- Embed a natural number digest into the CRT base. -/
def digestToBase (d : ℕ) : MonsterBase :=
  ((d : ZMod 71), (d : ZMod 59), (d : ZMod 47))

theorem digestToBase_mod71 (d : ℕ) : (digestToBase d).1    = (d : ZMod 71) := rfl
theorem digestToBase_mod59 (d : ℕ) : (digestToBase d).2.1  = (d : ZMod 59) := rfl
theorem digestToBase_mod47 (d : ℕ) : (digestToBase d).2.2  = (d : ZMod 47) := rfl

/-- **CRT Reconstruction**: An element of `MonsterBase` is uniquely
    recoverable from its three component projections. -/
theorem crt_reconstruction (x y : MonsterBase) :
    x.1 = y.1 → x.2.1 = y.2.1 → x.2.2 = y.2.2 → x = y :=
  fun h1 h2 h3 => Prod.ext h1 (Prod.ext h2 h3)

/-- The three-projection map is injective. -/
theorem crt_projections_injective :
    Function.Injective (fun (x : MonsterBase) => (x.1, x.2.1, x.2.2)) :=
  fun x y h => by cases x; cases y; aesop

/-- Two digests map to the same `MonsterBase` element iff they are
    congruent modulo all three primes simultaneously. -/
theorem digestToBase_eq_iff (a b : ℕ) :
    digestToBase a = digestToBase b ↔
    (a : ZMod 71) = (b : ZMod 71) ∧
    (a : ZMod 59) = (b : ZMod 59) ∧
    (a : ZMod 47) = (b : ZMod 47) := by
  unfold digestToBase; aesop

/-
`digestToBase` is surjective: every element of MonsterBase is hit.
    This follows from the Chinese Remainder Theorem.
-/
theorem digestToBase_surjective : Function.Surjective digestToBase := by
  -- By the Chinese Remainder Theorem, there exists a unique $n$ modulo $71 \times 59 \times 47 = 196883$ such that $n \equiv a \pmod{71}$, $n \equiv b \pmod{59}$, and $n \equiv c \pmod{47}$.
  have h_crt : ∀ (a : ZMod 71) (b : ZMod 59) (c : ZMod 47), ∃ n : ℕ, n < 196883 ∧ (n : ZMod 71) = a ∧ (n : ZMod 59) = b ∧ (n : ZMod 47) = c := by
    intro a b c
    have h_crt : ∃ n : ℕ, n < 196883 ∧ n ≡ a.val [MOD 71] ∧ n ≡ b.val [MOD 59] ∧ n ≡ c.val [MOD 47] := by
      have h_crt : ∃ n : ℕ, n ≡ a.val [MOD 71] ∧ n ≡ b.val [MOD 59] ∧ n ≡ c.val [MOD 47] := by
        have h71 : ∃ x : ℕ, x ≡ a.val [MOD 71] ∧ x ≡ b.val [MOD 59] := by
          have h_crt : Nat.gcd 71 59 = 1 := by
            decide +revert;
          have := Nat.chineseRemainder h_crt a.val b.val; aesop;
        obtain ⟨x, hx⟩ := h71
        have h47 : ∃ y : ℕ, y ≡ x [MOD (71 * 59)] ∧ y ≡ c.val [MOD 47] := by
          have h_coprime : Nat.gcd (71 * 59) 47 = 1 := by
            decide +revert;
          have := Nat.chineseRemainder h_coprime;
          exact ⟨ _, this x c.val |>.2 ⟩
        obtain ⟨y, hy⟩ := h47
        use y
        exact ⟨ hy.1.of_dvd ( by decide ) |> Nat.ModEq.trans <| hx.1, hy.1.of_dvd ( by decide ) |> Nat.ModEq.trans <| hx.2, hy.2 ⟩;
      obtain ⟨ n, hn ⟩ := h_crt; exact ⟨ n % 196883, Nat.mod_lt _ ( by decide ), by simpa [ Nat.ModEq, Nat.mod_mod ] using hn ⟩ ;
    simp_all +decide [ ← ZMod.natCast_eq_natCast_iff ];
  intro x; obtain ⟨ n, hn₁, hn₂, hn₃, hn₄ ⟩ := h_crt x.1 x.2.1 x.2.2; exact ⟨ n, by aesop ⟩ ;

-- ════════════════════════════════════════════════════════════════
-- §2. SSP PARTITION IS EXHAUSTIVE AND ORDERED
-- ════════════════════════════════════════════════════════════════

def ssp  : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
def sspA : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19]
def sspB : List ℕ := [23, 29, 31, 41, 47, 59, 71]

theorem sspA_card : sspA.length = 8  := by native_decide
theorem sspB_card : sspB.length = 7  := by native_decide
theorem ssp_card  : ssp.length  = 15 := by native_decide

theorem ssp_partition : sspA ++ sspB = ssp := by native_decide

theorem sspA_sspB_disjoint : sspA.Disjoint sspB := by
  simp +decide [List.disjoint_left]

/-- Membership in ssp ↔ membership in sspA or sspB. -/
theorem sspA_union_sspB_eq_ssp :
    ∀ p, p ∈ ssp ↔ (p ∈ sspA ∨ p ∈ sspB) := by
  intro p
  rw [show ssp = sspA ++ sspB from (ssp_partition ▸ rfl)]
  exact List.mem_append

theorem sspA_lt_sspB : ∀ a ∈ sspA, ∀ b ∈ sspB, a < b := by decide

theorem sspA_max_lt_sspB_min : (19 : ℕ) < 23 := by norm_num

theorem sspA_all_prime : ∀ p ∈ sspA, Nat.Prime p := by decide
theorem sspB_all_prime : ∀ p ∈ sspB, Nat.Prime p := by decide
theorem ssp_all_prime  : ∀ p ∈ ssp,  Nat.Prime p := by decide

-- ════════════════════════════════════════════════════════════════
-- §3. THE CRT MODULI ARE IN sspB
-- ════════════════════════════════════════════════════════════════

theorem mod47_in_sspB : (47 : ℕ) ∈ sspB := by decide
theorem mod59_in_sspB : (59 : ℕ) ∈ sspB := by decide
theorem mod71_in_sspB : (71 : ℕ) ∈ sspB := by decide

theorem crt_moduli_in_sspB :
    (47 : ℕ) ∈ sspB ∧ (59 : ℕ) ∈ sspB ∧ (71 : ℕ) ∈ sspB :=
  ⟨mod47_in_sspB, mod59_in_sspB, mod71_in_sspB⟩

theorem crt_moduli_not_in_sspA :
    (47 : ℕ) ∉ sspA ∧ (59 : ℕ) ∉ sspA ∧ (71 : ℕ) ∉ sspA := by decide

theorem crt_moduli_product_is_monster : 47 * 59 * 71 = 196883 := by norm_num

-- ════════════════════════════════════════════════════════════════
-- §4. FIBER ARITHMETIC
-- ════════════════════════════════════════════════════════════════

theorem every_nat_has_fiber (n : ℕ) : ∃ f : MonsterBase, digestToBase n = f :=
  ⟨digestToBase n, rfl⟩

theorem zero_fiber : digestToBase 0 = ((0 : ZMod 71), (0 : ZMod 59), (0 : ZMod 47)) := by
  simp [digestToBase]

theorem monster_dim_fiber :
    digestToBase 196883 = ((0 : ZMod 71), (0 : ZMod 59), (0 : ZMod 47)) := by
  simp [digestToBase, show (196883 : ZMod 71) = 0 by decide,
                       show (196883 : ZMod 59) = 0 by decide,
                       show (196883 : ZMod 47) = 0 by decide]

theorem fiber_periodic (n : ℕ) : digestToBase (n + 196883) = digestToBase n := by
  simp [digestToBase, show (196883 : ZMod 71) = 0 by decide,
                       show (196883 : ZMod 59) = 0 by decide,
                       show (196883 : ZMod 47) = 0 by decide]

-- ════════════════════════════════════════════════════════════════
-- §5. CONGRUENCE IS THE GATE
-- ════════════════════════════════════════════════════════════════

structure CID where
  codec  : ℕ
  mhCode : ℕ
  digest : ℕ
  deriving DecidableEq

structure Block where
  contentHash : ℕ
  codec       : ℕ
  deriving DecidableEq

def cidToBase   (c : CID)   : MonsterBase := digestToBase c.digest
def blockToBase (b : Block) : MonsterBase := digestToBase b.contentHash

/-- The governance gate: block is admitted iff CRT projections agree. -/
def CRTCongruent (c : CID) (b : Block) : Prop := cidToBase c = blockToBase b

instance (c : CID) (b : Block) : Decidable (CRTCongruent c b) := by
  unfold CRTCongruent cidToBase blockToBase digestToBase; infer_instance

theorem crtCongruent_iff (c : CID) (b : Block) :
    CRTCongruent c b ↔
      (c.digest : ZMod 71) = (b.contentHash : ZMod 71) ∧
      (c.digest : ZMod 59) = (b.contentHash : ZMod 59) ∧
      (c.digest : ZMod 47) = (b.contentHash : ZMod 47) := by
  simp [CRTCongruent, cidToBase, blockToBase, digestToBase, Prod.ext_iff]

theorem every_block_has_congruent_cid (b : Block) :
    ∃ c : CID, CRTCongruent c b :=
  ⟨⟨0, 0, b.contentHash⟩, by simp [CRTCongruent, cidToBase, blockToBase, digestToBase]⟩

-- ════════════════════════════════════════════════════════════════
-- §6. THE SENATE THRESHOLD ↔ SSP PARTITION BRIDGE
-- ════════════════════════════════════════════════════════════════

def clotureThreshold : ℕ := 60
def superThreshold   : ℕ := 67

theorem threshold_gap_equals_sspB_card :
    superThreshold - clotureThreshold = sspB.length := by
  simp [superThreshold, clotureThreshold]; native_decide

theorem crt_moduli_are_top_of_sspB :
    ∀ p ∈ [47, 59, 71], ∀ q ∈ sspB, q ≤ 71 := by decide

theorem ssp_count_times_four : ssp.length * 4 = clotureThreshold := by
  simp [clotureThreshold]; native_decide

def clDim8 : ℕ := 256
def clDim7 : ℕ := 128

theorem clDim_ratio : clDim8 / clDim7 = 2 := by simp [clDim8, clDim7]
theorem clDim8_is_pow : clDim8 = 2 ^ sspA.length := by simp [clDim8]; native_decide
theorem clDim7_is_pow : clDim7 = 2 ^ sspB.length := by simp [clDim7]; native_decide

/-
════════════════════════════════════════════════════════════════
§7. FIBER CARDINALITY
════════════════════════════════════════════════════════════════

The fiber over a fixed ZMod 71 value has cardinality 59 × 47 = 2773.
-/
theorem fiber_over_71_card (z : ZMod 71) :
    Fintype.card {x : MonsterBase // x.1 = z} = 59 * 47 := by
  native_decide +revert

/-
The fiber over a fixed ZMod 59 value has cardinality 71 × 47 = 3337.
-/
theorem fiber_over_59_card (z : ZMod 59) :
    Fintype.card {x : MonsterBase // x.2.1 = z} = 71 * 47 := by
  rw [ Fintype.card_subtype ] ; exact by { revert z; native_decide } ;

/-
The fiber over a fixed ZMod 47 value has cardinality 71 × 59 = 4189.
-/
theorem fiber_over_47_card (z : ZMod 47) :
    Fintype.card {x : MonsterBase // x.2.2 = z} = 71 * 59 := by
  native_decide +revert

/-
The fibers of the mod-71 projection all have the same size (constant fiber).
-/
theorem fiber_71_constant (z₁ z₂ : ZMod 71) :
    Fintype.card {x : MonsterBase // x.1 = z₁} =
    Fintype.card {x : MonsterBase // x.1 = z₂} := by
  rw [ fiber_over_71_card, fiber_over_71_card ]

/-
Total = fibers × base, verifying the fiber decomposition.
-/
theorem fiber_decomposition_71 :
    Fintype.card MonsterBase = Fintype.card (ZMod 71) * (59 * 47) := by
  native_decide

-- ════════════════════════════════════════════════════════════════
-- §8. SUMMARY THEOREM
-- ════════════════════════════════════════════════════════════════

theorem monsterBase_summary :
    Fintype.card MonsterBase = 196883 ∧
    sspA.length + sspB.length = ssp.length ∧
    ((47 : ℕ) ∈ sspB ∧ (59 : ℕ) ∈ sspB ∧ (71 : ℕ) ∈ sspB) ∧
    superThreshold - clotureThreshold = sspB.length ∧
    clDim8 = 2 ^ sspA.length ∧ clDim7 = 2 ^ sspB.length := by
  exact ⟨monsterBase_card, by native_decide, crt_moduli_in_sspB,
          threshold_gap_equals_sspB_card, clDim8_is_pow, clDim7_is_pow⟩end MonsterBaseExt
