/-
# CliffordBitBasis — BitVec Monomial Model for Clifford Algebras

This file implements the "BitVec filtration" approach to Clifford algebra Cl(0,n):

## §1. Monomial Indexing
  Monomials in Cl(0,n) are indexed by `BitVec n`, where bit i indicates
  presence of generator eᵢ. The monomial for `b : BitVec n` is
    m_b = ∏_{i : b.getLsbD i = true} eᵢ  (in increasing order)

## §2. Sign Parity Function
  Left multiplication by generator eₖ on monomial m_b gives:
    eₖ · m_b = (-1)^s · m_{b ^^^ (1 <<< k)}
  where s = (number of set bits in b below position k) + (if bit k is set then 1 else 0).

  The "+1 when bit k set" accounts for eₖ² = -1.

## §3. Full Monomial Multiplication
  Monomial multiplication m_a · m_b is computed by folding left-multiplication
  by each generator in a (from highest to lowest index).

## §4. Filtration
  Vₖ = span{m_b | b has support ⊆ {0,…,k-1}} has dim 2ᵏ.
  Key decomposition: V_{k+1} = Vₖ ⊕ eₖ · Vₖ (2 cases per step, not 2ⁿ).

## §5. Connection to Cl(0,n)
  The BitVec-indexed monomials map to concrete Clifford algebra elements
  via the canonical inclusion ι, yielding a basis for Cl(0,n).
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 800000

open Finset BigOperators CliffordAlgebra

/-! ## §0. Fintype instance for BitVec n -/

instance : Fintype (BitVec n) :=
  Fintype.ofEquiv (Fin (2 ^ n))
    ⟨BitVec.ofFin, BitVec.toFin, fun x => by simp, fun x => by simp⟩

theorem card_bitvec (n : ℕ) : Fintype.card (BitVec n) = 2 ^ n := by
  simp [Fintype.ofEquiv_card]

/-! ## §1. BitVec Monomial Index Space -/

/-- The type of monomial indices for Cl(0,n). Each `BitVec n` encodes a subset
    of {0, …, n-1}, representing the ordered product of the corresponding generators. -/
abbrev CliffordIndex (n : ℕ) := BitVec n

/-! ## §2. Sign Parity for Generator Multiplication

The core computation: when generator eₖ left-multiplies monomial m_b,
it must swap past all generators eᵢ (i < k) present in b, then either
adjoin eₖ (if bit k is 0) or annihilate via eₖ² = -1 (if bit k is 1).
-/

/-- Count of set bits in `b` strictly below position `k`. This equals the
    number of anticommutation swaps needed when eₖ passes through m_b from the left. -/
def bitsBelow (b : BitVec n) (k : Fin n) : ℕ :=
  (univ.filter (fun i : Fin n => i.val < k.val ∧ b.getLsbD i.val)).card

/-- The sign exponent for left multiplication eₖ · m_b.
    s = bitsBelow(b, k) + (1 if bit k is set, 0 otherwise)
    The result monomial is always b ^^^ (1 <<< k). -/
def signExp (b : BitVec n) (k : Fin n) : ℕ :=
  bitsBelow b k + if b.getLsbD k.val then 1 else 0

/-- Sign (as ℤ) for left multiplication eₖ · m_b: equals (-1)^signExp. -/
def mulGenSign (b : BitVec n) (k : Fin n) : ℤ :=
  (-1) ^ signExp b k

/-- The single-bit mask for position k. -/
def bitMask (n : ℕ) (k : Fin n) : BitVec n :=
  BitVec.ofNat n (1 <<< k.val)

/-- Result of left-multiplying generator eₖ on monomial m_b:
    eₖ · m_b = mulGenSign(b, k) · m_{b ^^^ bitMask(k)}
    Returns (sign, result_index). -/
def mulGen (b : BitVec n) (k : Fin n) : ℤ × CliffordIndex n :=
  (mulGenSign b k, b ^^^ bitMask n k)

/-! ## §3. Full Monomial Multiplication

To multiply m_a · m_b, we decompose m_a = eᵢ₁ · eᵢ₂ · … · eᵢₖ (increasing order)
and fold left-multiplications from right to left:

  m_a · m_b = eᵢ₁ · (eᵢ₂ · (… · (eᵢₖ · m_b)))

At each step we accumulate the sign and update the monomial index.
-/

/-- The set of bit positions set in `a`, as a sorted list (increasing order). -/
def setBits (a : BitVec n) : List (Fin n) :=
  (List.finRange n).filter (fun i => a.getLsbD i.val)

/-- Fold a single generator multiplication into an accumulated (sign, index) pair.
    Processing generator k: (s, b) ↦ (s * mulGenSign(b, k), b ^^^ bitMask(k)) -/
def foldGenMul (n : ℕ) (k : Fin n) (acc : ℤ × CliffordIndex n) : ℤ × CliffordIndex n :=
  let (s, b) := acc
  let (s', b') := mulGen b k
  (s * s', b')

/-- Full monomial multiplication: m_a · m_b = mulMonomial(a, b).1 · m_{mulMonomial(a, b).2}
    We fold generators of a from highest to lowest (right-to-left in the product). -/
def mulMonomial (a b : BitVec n) : ℤ × CliffordIndex n :=
  (setBits a).foldr (foldGenMul n) (1, b)

/-- The sign of monomial multiplication. -/
def mulSign (a b : BitVec n) : ℤ := (mulMonomial a b).1

/-- The index of the product monomial. Always equals a ^^^ b. -/
def mulIndex (a b : BitVec n) : CliffordIndex n := (mulMonomial a b).2

/-! ### Key Property: Product index is always XOR -/

/-
The product monomial index is the XOR of the two input indices.
    This is because each generator either sets or clears its bit.
-/
theorem mulIndex_eq_xor (a b : BitVec n) : mulIndex a b = a ^^^ b := by
  -- By definition of `setBits`, we know that `a = ^^^ (setBits a)`.
  have h_setBits : a = List.foldr (fun k acc => acc ^^^ (bitMask n k)) 0 (setBits a) := by
    -- By definition of `setBits`, the list `setBits a` contains exactly the indices where `a.getLsbD i.val` is true.
    have h_setBits : ∀ (i : Fin n), a.getLsbD i.val = true ↔ i ∈ setBits a := by
      unfold setBits; aesop;
    refine' BitVec.eq_of_getLsbD_eq _;
    intro i hi
    have h_foldr : ∀ (l : List (Fin n)), (List.foldr (fun k acc => acc ^^^ bitMask n k) 0 l).getLsbD i = if (List.countP (fun k => k.val = i) l) % 2 = 1 then true else false := by
      intro l;
      induction l <;> simp_all +decide [ BitVec.getLsbD ];
      simp +decide [ List.countP_cons, bitMask ];
      split_ifs <;> simp_all +decide [ Nat.testBit ];
      · grind;
      · cases lt_or_gt_of_ne ‹_› <;> simp_all +decide [ Nat.shiftRight_eq_div_pow ];
        · norm_num [ Nat.div_eq_of_lt ( show 1 < 2 ^ ( i - ↑‹Fin n› ) from one_lt_pow₀ one_lt_two ( Nat.sub_ne_zero_of_lt ‹_› ) ) ];
          grind;
        · grind +revert;
    have h_count : List.countP (fun k => k.val = i) (setBits a) = if a.getLsbD i then 1 else 0 := by
      have h_count : List.countP (fun k => k.val = i) (setBits a) = Finset.card (Finset.filter (fun k => k.val = i) (List.toFinset (setBits a))) := by
        rw [ List.countP_eq_length_filter ];
        rw [ ← Multiset.coe_card ];
        rw [ ← Multiset.toFinset_card_of_nodup ];
        · congr with x ; aesop;
        · refine' List.Nodup.filter _ _;
          exact List.Nodup.filter _ ( List.nodup_finRange _ );
      split_ifs <;> simp_all +decide [ Finset.card_eq_one ];
      · use ⟨i, hi⟩; ext; simp [h_setBits];
        exact ⟨ fun h => Fin.ext h.2, fun h => h.symm ▸ ⟨ by simpa [ Fin.ext_iff ] using h_setBits ⟨ i, hi ⟩ |>.1 ‹_›, rfl ⟩ ⟩;
      · grind +locals;
    grind;
  -- By definition of `mulIndex`, we know that `mulIndex a b = List.foldr (fun k acc => acc ^^^ (bitMask n k)) b (setBits a)`.
  have h_mulIndex : mulIndex a b = List.foldr (fun k acc => acc ^^^ (bitMask n k)) b (setBits a) := by
    unfold mulIndex mulMonomial;
    induction' ( setBits a ) with k a ih <;> simp +decide [ foldGenMul ] at *;
    exact ih.symm ▸ rfl;
  convert congr_arg ( · ^^^ b ) h_setBits.symm using 1;
  convert h_mulIndex using 1;
  induction' ( setBits a ) with k hk ih <;> simp +decide [ ← BitVec.xor_assoc ];
  grind +splitImp

/-! ## §4. Algebraic Properties of the Sign Function -/

/-- mulSign is multiplicative: sign(a·b) · sign(a⊕b, c) = sign(a, b⊕c) · sign(b, c)
    (associativity of the Clifford product). Proved later via the Clifford algebra. -/
-- mulSign_assoc is proved below (after cl0Monomial_ne_zero), using the Clifford algebra.

/-
The empty monomial is the multiplicative identity.
-/
theorem mulSign_zero_left (b : BitVec n) : mulSign 0 b = 1 := by
  convert congr_arg Prod.fst ( show ( List.foldr ( foldGenMul n ) ( 1, b ) ( List.finRange n |> List.filter fun i => ( 0 : BitVec n ).getLsbD i.val ) ) = ( 1, b ) from ?_ ) using 1;
  convert List.foldr_nil using 2 ; aesop

theorem mulSign_zero_right (a : BitVec n) : mulSign a 0 = 1 := by
  have h_foldr : ∀ (L : List (Fin n)), List.Pairwise (fun x y => x < y) L → (List.foldr (fun k acc => (acc.1 * mulGenSign acc.2 k, acc.2 ^^^ bitMask n k)) (1, 0) L).1 = 1 := by
    intro L hL
    induction' L with k L ih;
    · rfl;
    · simp_all +decide [ mulGenSign ];
      -- Since the list L is sorted and all elements are greater than k, the bits below k in the result of folding L are zero.
      have h_bits_below : ∀ (L : List (Fin n)), List.Pairwise (fun x y => x < y) L → (∀ a' ∈ L, k < a') → bitsBelow (List.foldr (fun k acc => acc ^^^ bitMask n k) (0#n) L) k = 0 := by
        intros L hL hL'; induction' L with a L ih <;> simp_all +decide [ bitsBelow ] ;
        unfold bitMask; simp +decide [ Fin.ext_iff, Nat.shiftLeft_eq ] ;
        intro x hx; rw [ BitVec.getElem_eq_getElem? ] ; simp +decide [ hx.ne, hx.ne.symm, Nat.shiftLeft_eq ] ;
        have h_bit_false : (2#n ^ (a : ℕ)).toNat.testBit x = false := by
          rw [ BitVec.toNat_pow ];
          rw [ Nat.mod_eq_of_lt ] <;> norm_num [ Nat.testBit_two_pow ];
          · rw [ Nat.mod_eq_of_lt ];
            · grind;
            · exact lt_self_pow₀ ( by decide ) ( by linarith [ Fin.is_lt k, Fin.is_lt a, show ( k : ℕ ) < a from hL'.1 ] );
          · exact lt_of_le_of_lt ( Nat.pow_le_pow_left ( Nat.mod_le _ _ ) _ ) ( pow_lt_pow_right₀ ( by decide ) ( Fin.is_lt _ ) );
        grind;
      -- Since the bits below k in the result of folding L are zero, the sign exponent is zero.
      have h_sign_exp_zero : signExp (List.foldr (fun k acc => acc ^^^ bitMask n k) (0#n) L) k = 0 := by
        have h_bit_zero : ∀ (L : List (Fin n)), List.Pairwise (fun x y => x < y) L → (∀ a' ∈ L, k < a') → (List.foldr (fun k acc => acc ^^^ bitMask n k) (0#n) L).getLsbD k.val = false := by
          intros L hL hL'; induction' L with a L ih <;> simp_all +decide [ BitVec.getLsbD ] ;
          grind +locals;
        unfold signExp; aesop;
      convert congr_arg ( fun x : ℕ => ( -1 : ℤ ) ^ x ) h_sign_exp_zero using 1;
      congr! 2;
      clear hL h_bits_below h_sign_exp_zero;
      induction L <;> aesop;
  apply h_foldr;
  exact List.Pairwise.filter _ ( List.pairwise_lt_finRange _ )

/-
Generator self-multiplication gives -1 (from eₖ² = -1).
-/
theorem mulSign_self_gen (k : Fin n) :
    mulSign (bitMask n k) (bitMask n k) = -1 := by
  -- By definition of `mulSign`, we know that `mulSign (bitMask n k) (bitMask n k) = mulGenSign (bitMask n k) k`.
  have h_mulSign_def : mulSign (bitMask n k) (bitMask n k) = mulGenSign (bitMask n k) k := by
    unfold mulSign mulMonomial setBits foldGenMul;
    -- By definition of `bitMask`, we know that `bitMask n k` has exactly one bit set, which is at position `k`.
    have h_bitMask : ∀ i : Fin n, (bitMask n k).getLsbD i.val = (i = k) := by
      unfold bitMask; simp +decide [ BitVec.getLsbD ] ;
      intro i; constructor <;> intro hi <;> simp_all +decide [ Nat.testBit ] ;
      rcases h : ( i : ℕ ) - k with ( _ | _ | h ) <;> simp_all +decide [ Nat.shiftRight_eq_div_pow ];
      · exact Fin.ext ( by linarith [ Nat.sub_add_cancel ( show ( k : ℕ ) ≤ i from hi ) ] );
      · norm_num [ Nat.div_eq_of_lt ] at hi;
    rw [ show List.filter ( fun i : Fin n => ( bitMask n k ).getLsbD i.val ) ( List.finRange n ) = [ k ] from ?_ ] ; simp +decide [ mulGen ];
    rw [ List.filter_congr ];
    rotate_right;
    exact fun i => i = k;
    · simp +decide [ List.filter_eq ];
    · grind;
  convert h_mulSign_def using 1;
  unfold mulGenSign;
  unfold signExp bitsBelow;
  unfold bitMask; simp +decide [ BitVec.getLsbD ] ;
  rw [ Finset.card_eq_zero.mpr ] <;> aesop

/-! ## §5. Filtration by Bit Depth

The key structural tool: define subspaces Vₖ of monomials using only
the first k generators (bits 0, …, k-1).

  Vₖ = span{m_b | ∀ i ≥ k, ¬b.getLsbD i} = span{m_b | b < 2ᵏ}

This gives a filtration V₀ ⊆ V₁ ⊆ … ⊆ Vₙ = full space.
-/

/-- Predicate: monomial index b has support contained in {0, …, k-1}. -/
def supportBelow (b : BitVec n) (k : ℕ) : Prop :=
  ∀ i : Fin n, k ≤ i.val → b.getLsbD i.val = false

instance (b : BitVec n) (k : ℕ) : Decidable (supportBelow b k) :=
  Fintype.decidableForallFintype

/-- The set of monomial indices with support below k. -/
def indicesBelow (n k : ℕ) : Finset (BitVec n) :=
  univ.filter (fun b => supportBelow b k)

/-
The number of monomials with support below k is 2ᵏ (when k ≤ n).
-/
theorem card_indicesBelow (hk : k ≤ n) : (indicesBelow n k).card = 2 ^ k := by
  -- The number of such bit vectors is exactly $2^k$ because each of the $k$ positions can be either 0 or 1.
  have h_card_support : (Finset.filter (fun b : BitVec n => ∀ i : Fin n, k ≤ i.val → b.getLsbD i.val = false) Finset.univ).card = 2 ^ k := by
    have h_card_support : (Finset.filter (fun b : BitVec n => ∀ i : Fin n, k ≤ i.val → b.getLsbD i.val = false) Finset.univ).card = (Finset.filter (fun b : Fin n → Bool => ∀ i : Fin n, k ≤ i.val → b i = false) Finset.univ).card := by
      refine' Finset.card_bij ( fun b hb => fun i => b.getLsbD i.val ) _ _ _ <;> simp +decide [ BitVec.getLsbD ];
      · intro a₁ ha₁ a₂ ha₂ h; ext i; simp_all +decide [ funext_iff ] ;
        convert h ⟨ i, by linarith ⟩ using 1;
      · intro b hb; use ⟨ Nat.ofBits ( fun i => b i ), by
          exact Nat.ofBits_lt_two_pow _ ⟩ ; simp +decide [ hb ] ;
        exact hb;
    -- The set of functions from Fin n to Bool where the last n-k elements are false is equivalent to the set of functions from Fin k to Bool.
    have h_equiv : {b : Fin n → Bool | ∀ i : Fin n, k ≤ i.val → b i = false} ≃ (Fin k → Bool) := by
      refine' Equiv.ofBijective ( fun b => fun i => b.val ⟨ i, by linarith [ Fin.is_lt i ] ⟩ ) ⟨ fun a b h => _, fun a => _ ⟩;
      · ext i; by_cases hi : k ≤ i.val <;> simp_all +decide [ funext_iff ] ;
        · grind +qlia;
        · convert h ⟨ i, hi ⟩;
      · refine' ⟨ ⟨ fun i => if hi : i.val < k then a ⟨ i.val, hi ⟩ else false, _ ⟩, _ ⟩ <;> aesop;
    have := Fintype.card_congr h_equiv; simp_all +decide [ Fintype.card_pi ] ;
    rw [ ← this, Fintype.card_subtype ];
  grind +locals

/-! ### The Key Decomposition: indices at level k+1 split into two halves

Every monomial m_b with support ⊆ {0,…,k} either has bit k = 0 (lives in level k)
or bit k = 1 (equals ± eₖ · m_{b ⊕ bitMask(k)} where the latter is at level k).
-/

/-
Left multiplication by eₖ maps a level-k monomial to a level-(k+1) monomial.
-/
theorem mulGen_preserves_filtration (k : Fin n) (b : BitVec n) (hb : supportBelow b k.val) :
    supportBelow (b ^^^ bitMask n k) (k.val + 1) := by
  intro i hi;
  rw [ BitVec.getLsbD_xor ];
  rw [ show ( bitMask n k ).getLsbD i = false from ?_ ];
  · simpa using hb i ( Nat.le_of_succ_le hi );
  · unfold bitMask;
    simp +decide [ BitVec.getLsbD, Nat.shiftLeft_eq ];
    rw [ Nat.mod_eq_of_lt ];
    · grind +qlia;
    · exact lt_self_pow₀ ( by decide ) ( by linarith [ Fin.is_lt k, Fin.is_lt i ] )

/-
Monomials at level k+1 split into those with bit k = 0 (in level k)
    and those with bit k = 1 (XOR-image of level k).
-/
theorem indicesBelow_succ (hk : k < n) :
    indicesBelow n (k + 1) =
      (indicesBelow n k) ∪
      ((indicesBelow n k).image (· ^^^ bitMask n ⟨k, hk⟩)) := by
  ext b;
  constructor;
  · by_cases h : b.getLsbD k <;> simp_all +decide [ indicesBelow ];
    · intro hb
      use Or.inr ⟨b ^^^ bitMask n ⟨k, hk⟩, by
        intro i hi; specialize hb i; simp_all +decide [ BitVec.getLsbD ] ;
        by_cases hi' : k < i.val <;> simp_all +decide [ bitMask ];
        · grind +suggestions;
        · grind, by
        simp +decide [ BitVec.xor_assoc ]⟩;
    · intro hb;
      refine Or.inl ?_;
      intro i hi; specialize hb i; cases lt_or_eq_of_le hi <;> aesop;
  · simp +decide [ indicesBelow ];
    rintro ( h | ⟨ a, ha, rfl ⟩ );
    · exact fun i hi => h i ( Nat.le_of_succ_le hi );
    · convert mulGen_preserves_filtration ⟨ k, hk ⟩ a ha using 1

/-
The two halves are disjoint (bit k is 0 in one set, 1 in the other).
-/
theorem indicesBelow_disjoint (hk : k < n) :
    Disjoint
      (indicesBelow n k)
      ((indicesBelow n k).image (· ^^^ bitMask n ⟨k, hk⟩)) := by
  refine' Finset.disjoint_iff_ne.mpr _;
  simp +contextual [ indicesBelow ];
  intro a ha b hb; intro H; have := ha ⟨ k, hk ⟩ ; have := hb ⟨ k, hk ⟩ ; simp_all +decide [ BitVec.getLsbD ] ;
  unfold bitMask at this; simp_all +decide [ Nat.testBit_shiftLeft ] ;

/-
**Filtration cardinality doubling**: |indices_{k+1}| = 2 · |indices_k|.
    Direct consequence of the disjoint union decomposition.
-/
theorem card_indicesBelow_succ (hk : k < n) :
    (indicesBelow n (k + 1)).card = 2 * (indicesBelow n k).card := by
  rw [ indicesBelow_succ hk, Finset.card_union_of_disjoint ];
  · rw [ two_mul, Finset.card_image_of_injective ] ; intro a b ; aesop;
  · exact indicesBelow_disjoint hk

/-! ## §6. Connection to the Abstract Clifford Algebra Cl(0,n)

We construct the BitVec-indexed monomials as elements of Cl(0,n) and
prove they satisfy the sign-XOR multiplication rule.
-/

/-- The monomial in Cl(0,n) corresponding to BitVec index b:
    product of ι(eᵢ) for each bit i set in b, in increasing order. -/
noncomputable def cl0Monomial (n : ℕ) (b : BitVec n) : Cl0 n :=
  (setBits b).foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1

/-- The zero monomial maps to the identity. -/
theorem cl0Monomial_zero : cl0Monomial n 0 = 1 := by
  simp [cl0Monomial, setBits, List.finRange]

/-
A single-generator monomial maps to the generator.
-/
theorem cl0Monomial_gen (k : Fin n) :
    cl0Monomial n (bitMask n k) = ι (negDefForm n) (stdBasis n k) := by
  have h_setBits_bitMask : setBits (bitMask n k) = List.filter (fun i : Fin n => i.val = k.val) (List.finRange n) := by
    unfold setBits bitMask;
    refine' List.filter_congr fun i hi => _;
    simp +decide [ BitVec.getLsbD, Nat.shiftLeft_eq ];
    rcases n with ( _ | _ | n ) <;> simp_all +decide [ Nat.mod_eq_of_lt, Nat.pow_succ' ];
    rw [ Nat.mod_eq_of_lt ( by linarith [ Nat.one_le_pow n 2 zero_lt_two ] ) ];
    grind;
  rw [ show List.filter ( fun i : Fin n => decide ( i.val = k.val ) ) ( List.finRange n ) = [ k ] from ?_ ] at h_setBits_bitMask;
  · unfold cl0Monomial; aesop;
  · have h_filter : List.filter (fun i : Fin n => i.val = k.val) (List.finRange n) = List.filter (fun i : Fin n => i = k) (List.finRange n) := by
      simp +decide [ Fin.ext_iff ];
    rw [ h_filter, List.filter_eq ] ; aesop

/-! ### Helper lemmas for generator multiplication -/

/-
Generators anticommute: eᵢ * eⱼ = -eⱼ * eᵢ for i ≠ j.
-/
theorem cl0_gen_anticommute_ne {i j : Fin n} (hij : i ≠ j) :
    ι (negDefForm n) (stdBasis n i) * ι (negDefForm n) (stdBasis n j) =
    -(ι (negDefForm n) (stdBasis n j) * ι (negDefForm n) (stdBasis n i)) := by
  have h_comm : (ι (negDefForm n)) (stdBasis n i) * (ι (negDefForm n)) (stdBasis n j) + (ι (negDefForm n)) (stdBasis n j) * (ι (negDefForm n)) (stdBasis n i) = 0 := by
    rw [ CliffordAlgebra.ι_mul_ι_add_swap ];
    simp +decide [ QuadraticMap.polar, negDefForm ];
    simp +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, stdBasis ];
    simp +decide [ Finset.sum_apply, Pi.single_apply, hij.symm ];
    exact hij;
  exact eq_neg_of_add_eq_zero_left h_comm

/-
Generator squares to -1: eₖ² = -(1 : Cl0 n).
-/
theorem cl0_gen_sq_neg (k : Fin n) :
    ι (negDefForm n) (stdBasis n k) * ι (negDefForm n) (stdBasis n k) = -(1 : Cl0 n) := by
  convert cl0_generator_sq n k using 1;
  norm_num [ Algebra.algebraMap_eq_smul_one ]

/-
eₖ passes through a product of distinct generators, picking up (-1) per swap:
    eₖ * (eⱼ₁ * (... * (eⱼₘ * x))) = (-1)^m * (eⱼ₁ * (... * (eⱼₘ * (eₖ * x))))
    when all jₗ ≠ k.
-/
theorem cl0_gen_pass_through (k : Fin n) (L : List (Fin n)) (hk : k ∉ L) (x : Cl0 n) :
    ι (negDefForm n) (stdBasis n k) *
      L.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) x =
    (-1 : ℝ) ^ L.length •
      L.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc)
        (ι (negDefForm n) (stdBasis n k) * x) := by
  induction' L with j L ih generalizing x;
  · norm_num;
  · -- By the properties of the Clifford algebra, we can move the generator $e_k$ past $e_j$ at the cost of a sign.
    have h_comm : ι (negDefForm n) (stdBasis n k) * ι (negDefForm n) (stdBasis n j) = -(ι (negDefForm n) (stdBasis n j) * ι (negDefForm n) (stdBasis n k)) := by
      apply cl0_gen_anticommute_ne; aesop;
    simp_all +decide [ mul_assoc, pow_succ' ];
    simp +decide only [← mul_assoc, h_comm, neg_mul];
    simp +decide [ mul_assoc, ih ]

/-
setBits is always sorted in increasing order.
-/
theorem setBits_sorted (b : BitVec n) : (setBits b).Sorted (· < ·) := by
  convert List.Pairwise.filter _ ( List.pairwise_lt_finRange n ) using 1

/-
setBits has no duplicates.
-/
theorem setBits_nodup (b : BitVec n) : (setBits b).Nodup := by
  exact List.Nodup.filter _ ( List.nodup_finRange _ )

/-
Membership in setBits iff bit is set.
-/
theorem mem_setBits_iff (b : BitVec n) (i : Fin n) :
    i ∈ setBits b ↔ b.getLsbD i.val := by
  unfold setBits; aesop;

/-
bitMask bit: (bitMask n k).getLsbD k = true
-/
theorem bitMask_getLsbD_self (k : Fin n) : (bitMask n k).getLsbD k.val = true := by
  unfold bitMask;
  simp +decide [ BitVec.getLsbD ]

/-
bitMask off-bit: (bitMask n k).getLsbD i = false when i ≠ k
-/
theorem bitMask_getLsbD_ne {i k : Fin n} (h : i ≠ k) : (bitMask n k).getLsbD i.val = false := by
  convert BitVec.getLsbD_ofNat _ _ _;
  simp +decide [ Nat.shiftLeft_eq, h.symm ];
  grind

/-
When k ∉ setBits b (bit k not set), setBits(b ^^^ bitMask k) equals
    setBits b with k inserted in sorted position:
    filter (· < k) ++ [k] ++ filter (k < ·)
-/
theorem setBits_xor_insert (b : BitVec n) (k : Fin n) (hk : ¬b.getLsbD k.val) :
    setBits (b ^^^ bitMask n k) =
    (setBits b).filter (· < k) ++ [k] ++ (setBits b).filter (k < ·) := by
  have h_setBits_eq : (setBits (b ^^^ bitMask n k)).Sorted (· < ·) ∧ (setBits b).Sorted (· < ·) ∧ (setBits (b ^^^ bitMask n k)).Nodup ∧ (setBits b).Nodup := by
    exact ⟨ setBits_sorted _, setBits_sorted _, setBits_nodup _, setBits_nodup _ ⟩;
  refine' List.Perm.eq_of_pairwise _ _ _ _;
  use fun x y => x < y;
  · exact fun a b ha hb hab hba => False.elim <| lt_asymm hab hba;
  · exact h_setBits_eq.1;
  · simp_all +decide [ List.pairwise_append, List.pairwise_filter ];
    exact ⟨ h_setBits_eq.2.1.imp fun x => by aesop, h_setBits_eq.2.1.imp fun x => by aesop, fun x hx hx' y hy hy' => lt_trans hx' hy' ⟩;
  · rw [ List.perm_iff_count ];
    intro a; by_cases ha : a = k <;> simp_all +decide [ List.count_cons ] ;
    · simp_all +decide [ List.Nodup.count, setBits ];
      rw [ List.count_eq_zero_of_not_mem, List.count_eq_zero_of_not_mem ] <;> simp_all +decide [ List.mem_filter, List.mem_finRange ];
      convert bitMask_getLsbD_self k;
    · grind +suggestions

/-
When k ∈ setBits b (bit k set), setBits(b ^^^ bitMask k) equals
    setBits b with k removed:
    filter (· < k) ++ filter (k < ·)
-/
theorem setBits_xor_remove (b : BitVec n) (k : Fin n) (hk : b.getLsbD k.val) :
    setBits (b ^^^ bitMask n k) =
    (setBits b).filter (· < k) ++ (setBits b).filter (k < ·) := by
  -- By definition of `setBits`, we know that `setBits (b ^^^ bitMask n k)` is the list of elements in `setBits b` that are less than `k`, followed by the elements in `setBits b` that are greater than `k`.
  have h_setBits_xor : ∀ i : Fin n, i ∈ setBits (b ^^^ bitMask n k) ↔ i ∈ setBits b ∧ i ≠ k := by
    intro i
    simp [setBits, hk];
    by_cases hi : i = k <;> simp_all +decide [ BitVec.getLsbD ];
    · convert hk using 1;
      convert bitMask_getLsbD_self k;
    · simp_all +decide [ BitVec.getElem?_eq_some_iff, bitMask ];
      grind +suggestions;
  refine' List.Perm.eq_of_pairwise _ _ _ _;
  use fun i j => i < j;
  · exact fun a b ha hb hab hba => False.elim <| lt_asymm hab hba;
  · exact setBits_sorted _;
  · simp +decide [ List.pairwise_append, List.pairwise_filter ];
    exact ⟨ List.Pairwise.imp_of_mem ( by aesop ) ( setBits_sorted b ), List.Pairwise.imp_of_mem ( by aesop ) ( setBits_sorted b ), fun a ha ha' b hb hb' => lt_trans ha' hb' ⟩;
  · rw [ List.perm_iff_count ];
    intro i; by_cases hi : i = k <;> simp_all +decide [ List.Nodup.count, List.nodup_append ] ;
    · rw [ List.count_eq_zero_of_not_mem, List.count_eq_zero_of_not_mem, List.count_eq_zero_of_not_mem ] <;> aesop;
    · rw [ List.Nodup.count, List.Nodup.count, List.Nodup.count ];
      · grind;
      · exact List.Nodup.filter _ ( setBits_nodup _ );
      · exact List.Nodup.filter _ ( setBits_nodup b );
      · exact setBits_nodup _

/-
bitsBelow equals the length of the filter of setBits below k.
-/
theorem bitsBelow_eq_filter_length (b : BitVec n) (k : Fin n) :
    bitsBelow b k = ((setBits b).filter (· < k)).length := by
  rw [ ← Multiset.coe_card ];
  rw [ ← Multiset.toFinset_card_of_nodup ];
  · refine' congr_arg Finset.card _;
    ext; simp [setBits];
  · exact List.Nodup.filter _ ( setBits_nodup _ )

/-
For sorted L with k ∉ L: setBits b = L implies
    setBits b = filter (< k) ++ filter (> k) (no k in middle)
-/
theorem sorted_filter_split (L : List (Fin n)) (hL : L.Sorted (· < ·)) (k : Fin n) (hk : k ∉ L) :
    L = L.filter (· < k) ++ L.filter (k < ·) := by
  have h_filter : ∀ {L : List (Fin n)}, List.Sorted (· < ·) L → ∀ k, k ∉ L → L = List.filter (· < k) L ++ List.filter (k < ·) L := by
    intros L hL k hk;
    induction' L with x L ih;
    · rfl;
    · by_cases h : x < k <;> simp +decide [ h ] at hk ⊢;
      · convert ih ( List.pairwise_cons.mp hL |>.2 ) hk.2 using 1;
        grind;
      · rw [ List.filter_cons ] ; simp +decide [ h, hk ];
        rw [ if_pos ( lt_of_le_of_ne ( le_of_not_gt h ) hk.1 ) ];
        rw [ ih ( List.pairwise_cons.mp hL |>.2 ) hk.2 ];
        rw [ List.filter_eq_nil_iff.mpr ] <;> norm_num;
        · exact fun a ha ha' => le_of_lt ha';
        · intro a ha; exact le_of_not_gt fun h' => hk.2 <| by have := List.pairwise_cons.mp hL; exact (by
          exact absurd ( this.1 a ha ) ( not_lt_of_ge ( le_trans h'.le ( le_of_not_gt h ) ) ));
  exact h_filter hL k hk

/-
The key multiplication rule in Cl(0,n):
    ι(eₖ) · cl0Monomial(b) = mulGenSign(b,k) · cl0Monomial(b ^^^ bitMask(k))
    This connects the abstract algebra to the concrete sign-XOR model.
-/
theorem cl0_mulGen_monomial (k : Fin n) (b : BitVec n) :
    ι (negDefForm n) (stdBasis n k) * cl0Monomial n b =
    (mulGenSign b k : ℝ) • cl0Monomial n (b ^^^ bitMask n k) := by
  by_cases hk : b.getLsbD k.val;
  · have h_split : cl0Monomial n b = List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (· < k)) * ι (negDefForm n) (stdBasis n k) * List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (k < ·)) := by
      have h_split : List.Sorted (· < ·) (setBits b) := by
        grind +suggestions;
      have h_split : List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 (setBits b) = List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (· < k) ++ [k] ++ (setBits b).filter (k < ·)) := by
        have h_split : setBits b = (setBits b).filter (· < k) ++ [k] ++ (setBits b).filter (k < ·) := by
          have h_split : k ∈ setBits b := by
            grind +locals;
          have h_split : ∀ {L : List (Fin n)}, List.Sorted (· < ·) L → ∀ k ∈ L, L = List.filter (· < k) L ++ [k] ++ List.filter (k < ·) L := by
            intros L hL k hk; induction' L with hd tl ih generalizing k <;> simp +decide [ List.filter_cons ] at *;
            rcases hk with ( rfl | hk ) <;> simp +decide [ List.Sorted ] at *;
            · rw [ List.filter_eq_nil_iff.mpr ] <;> simp +decide [ hL ];
              · rw [ List.filter_eq_self.mpr ] ; aesop;
              · exact fun x hx => le_of_lt ( hL.1 x hx );
            · grind;
          exact h_split ‹_› k ‹_›;
        congr;
      convert h_split using 1;
      induction ( List.filter ( fun x => decide ( x < k ) ) ( setBits b ) ) <;> simp +decide [ * ];
      simp_all +decide [ mul_assoc ];
    have h_pass : ι (negDefForm n) (stdBasis n k) * List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (· < k)) = (-1 : ℝ) ^ ((setBits b).filter (· < k)).length • List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (· < k)) * ι (negDefForm n) (stdBasis n k) := by
      convert cl0_gen_pass_through k ( List.filter ( fun x => decide ( x < k ) ) ( setBits b ) ) _ 1 using 1;
      · induction ( List.filter ( fun x => decide ( x < k ) ) ( setBits b ) ) <;> simp +decide [ *, pow_succ, mul_assoc ];
        rename_i i l ih; specialize ih; simp_all +decide [ ← mul_assoc, ← Algebra.smul_def ] ;
      · simp +decide [ hk ];
    have h_sq : ι (negDefForm n) (stdBasis n k) * ι (negDefForm n) (stdBasis n k) = -(1 : Cl0 n) := by
      convert cl0_gen_sq_neg k using 1;
    have h_final : cl0Monomial n (b ^^^ bitMask n k) = List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (· < k)) * List.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1 ((setBits b).filter (k < ·)) := by
      convert congr_arg ( fun l => List.foldr ( fun i acc => ι ( negDefForm n ) ( stdBasis n i ) * acc ) 1 l ) ( setBits_xor_remove b k hk ) using 1;
      induction ( List.filter ( fun x => decide ( x < k ) ) ( setBits b ) ) <;> simp +decide [ * ];
      simp_all +decide [ mul_assoc ];
    simp_all +decide [ ← mul_assoc, mulGenSign ];
    simp_all +decide [ mul_assoc, signExp ];
    simp_all +decide [ bitsBelow_eq_filter_length, pow_add ];
  · convert cl0_gen_pass_through k ( List.filter ( · < k ) ( setBits b ) ) _ ( List.foldr ( fun i acc => ι ( negDefForm n ) ( stdBasis n i ) * acc ) 1 ( List.filter ( k < · ) ( setBits b ) ) ) using 1;
    · rw [ show cl0Monomial n b = List.foldr ( fun i acc => ι ( negDefForm n ) ( stdBasis n i ) * acc ) 1 ( setBits b ) from rfl ];
      grind +suggestions;
    · unfold mulGenSign; simp +decide [ hk, bitsBelow_eq_filter_length ] ;
      unfold cl0Monomial; simp +decide [ setBits_xor_insert b k hk, bitsBelow_eq_filter_length ] ;
      rw [ signExp ];
      rw [ bitsBelow_eq_filter_length ] ; aesop;
    · simp +decide [ hk ]

/-! ### Monomial multiplication and associativity (proved via the Clifford algebra) -/

/-
Monomial multiplication in Cl(0,n): cl0Monomial a * cl0Monomial b = mulSign(a,b) • cl0Monomial(a ⊕ b).
    Proof by induction on setBits a, using cl0_mulGen_monomial at each step.
-/
theorem cl0Monomial_mul (a b : BitVec n) :
    cl0Monomial n a * cl0Monomial n b =
    (mulSign a b : ℝ) • cl0Monomial n (a ^^^ b) := by
  revert a b;
  -- We'll use induction on the set of bits in `a`.
  have h_ind : ∀ (L : List (Fin n)), (∀ k ∈ L, ∀ l ∈ L, k ≠ l → True) → ∀ b : BitVec n, (L.foldr (fun i acc => ι (negDefForm n) (stdBasis n i) * acc) 1) * cl0Monomial n b = ((L.foldr (fun k acc => foldGenMul n k acc) (1, b)).1 : ℝ) • cl0Monomial n (L.foldr (fun k acc => foldGenMul n k acc) (1, b)).2 := by
    intro L hL b; induction' L with k L ih generalizing b <;> simp_all +decide [ mul_assoc ] ;
    rw [ cl0_mulGen_monomial ];
    simp +decide [ foldGenMul, mulGenSign ];
    rw [ mul_smul ] ; norm_cast;
  intro a b; specialize h_ind ( setBits a ) ; simp_all +decide [ mulSign, mulIndex ] ;
  convert h_ind b using 1;
  rw [ ← mulIndex_eq_xor ] ; rfl;

/-
Every monomial is nonzero in Cl(0,n).
    Proof: cl0Monomial(b)² = mulSign(b,b) • cl0Monomial(0) = ±1 ≠ 0,
    so cl0Monomial(b) cannot be zero.
-/
theorem cl0Monomial_ne_zero (b : BitVec n) : cl0Monomial n b ≠ 0 := by
  have := cl0Monomial_mul b b;
  intro h; simp_all +decide ;
  rw [ eq_comm, smul_eq_zero ] at this;
  have h_contra : (mulSign b b : ℝ) = 0 := by
    exact this.resolve_right ( by rw [ show cl0Monomial n 0#n = 1 from cl0Monomial_zero ] ; norm_num );
  norm_cast at h_contra; simp_all +decide [ mulSign ] ;
  have h_contra : ∀ (l : List (Fin n)), (List.foldr (fun x1 x2 => foldGenMul n x1 x2) (1, b) l).1 ≠ 0 := by
    intro l; induction l <;> simp_all +decide [ foldGenMul ] ;
    unfold mulGen; simp +decide [ mulGenSign ] ;
  exact h_contra _ ‹_›

/-
Proof of mulSign_assoc using Clifford algebra associativity.
    The associativity (m_a * m_b) * m_c = m_a * (m_b * m_c) in Cl(0,n),
    combined with cl0Monomial_mul and cl0Monomial_ne_zero, forces
    mulSign(a,b) * mulSign(a⊕b,c) = mulSign(a,b⊕c) * mulSign(b,c).
-/
theorem mulSign_assoc (a b c : BitVec n) :
    mulSign a b * mulSign (a ^^^ b) c = mulSign a (b ^^^ c) * mulSign b c := by
  -- From associativity of multiplication in Cl(0,n):
  have h_assoc : (cl0Monomial n a * cl0Monomial n b) * cl0Monomial n c = cl0Monomial n a * (cl0Monomial n b * cl0Monomial n c) := by
    rw [ mul_assoc ];
  rw [ cl0Monomial_mul, cl0Monomial_mul ] at h_assoc;
  rw [ smul_mul_assoc, cl0Monomial_mul, mul_smul_comm, cl0Monomial_mul ] at h_assoc;
  simp_all +decide [ mul_comm, ← smul_smul ];
  simp_all +decide [ ← smul_assoc, ← BitVec.xor_assoc ];
  exact_mod_cast smul_left_injective _ ( cl0Monomial_ne_zero _ ) h_assoc

/-
The set of all 2ⁿ monomials spans Cl(0,n).
-/
theorem cl0Monomial_span :
    Submodule.span ℝ (Set.range (cl0Monomial n)) = ⊤ := by
  -- The set of all 2ⁿ monomials spans Cl(0,n) because every element in the algebra can be written as a linear combination of these monomials.
  apply le_antisymm;
  · exact le_top;
  · intro x;
    induction' x using CliffordAlgebra.left_induction with r x y hx hy;
    · simp +zetaDelta at *;
      rw [ show ( algebraMap ℝ ( CliffordAlgebra ( negDefForm n ) ) ) r = r • 1 by simp +decide [ Algebra.smul_def ] ];
      exact Submodule.smul_mem _ _ ( Submodule.subset_span ⟨ 0, cl0Monomial_zero ⟩ );
    · exact fun _ => Submodule.add_mem _ ( hx trivial ) ( hy trivial );
    · rename_i x hx;
      -- By definition of $cl0Monomial$, we know that $ι (negDefForm n) x$ can be written as a linear combination of the generators.
      have h_gen : ι (negDefForm n) x = ∑ i : Fin n, x i • ι (negDefForm n) (stdBasis n i) := by
        rw [ show x = ∑ i, x i • stdBasis n i from ?_ ];
        · simp +decide [ stdBasis, Pi.single_apply ];
        · ext i; simp +decide [ stdBasis ] ;
          simp +decide [ Pi.single_apply ];
      simp_all +decide [ Finset.sum_mul _ _ _ ];
      refine' Submodule.sum_mem _ fun i _ => Submodule.smul_mem _ _ _;
      refine' Submodule.span_induction _ _ _ _ hx;
      · rintro _ ⟨ b, rfl ⟩;
        rw [ cl0_mulGen_monomial ];
        exact Submodule.smul_mem _ _ ( Submodule.subset_span ⟨ _, rfl ⟩ );
      · simp +decide [ Submodule.zero_mem ];
      · exact fun x y hx hy hx' hy' => by simpa only [ mul_add ] using Submodule.add_mem _ hx' hy';
      · exact fun a x hx hx' => by simpa [ mul_smul_comm ] using Submodule.smul_mem _ a hx';

/-! ## §7. Worked Example: n = 2

For Cl(0,2), we have 4 monomials indexed by BitVec 2:
  00 → 1, 01 → e₀, 10 → e₁, 11 → e₀e₁

Generator multiplication signs:
  e₀ · m_00 = +m_01  (no bits below 0, bit 0 clear → s=0)
  e₀ · m_01 = -m_00  (no bits below 0, bit 0 set → s=1)
  e₀ · m_10 = +m_11  (no bits below 0, bit 0 clear → s=0)
  e₀ · m_11 = -m_10  (no bits below 0, bit 0 set → s=1)
  e₁ · m_00 = +m_10  (0 bits below 1, bit 1 clear → s=0)
  e₁ · m_01 = -m_11  (1 bit below 1, bit 1 clear → s=1)
  e₁ · m_10 = -m_00  (0 bits below 1, bit 1 set → s=1)
  e₁ · m_11 = +m_01  (1 bit below 1, bit 1 set → s=2, even → +)

These match: e₀² = -1, e₁² = -1, e₀e₁ = -e₁e₀. ✓
-/

/-- Verify: e₀ · m_01 has sign -1 (e₀² = -1). -/
example : mulGenSign (n := 2) 0b01 ⟨0, by omega⟩ = -1 := by native_decide

/-- Verify: e₁ · m_01 has sign -1 (e₁ must swap past e₀). -/
example : mulGenSign (n := 2) 0b01 ⟨1, by omega⟩ = -1 := by native_decide

/-- Verify: e₁ · m_11 has sign +1 (1 swap + 1 collision = even). -/
example : mulGenSign (n := 2) 0b11 ⟨1, by omega⟩ = 1 := by native_decide

/-- Verify: m_10 · m_01 sign = -1 (e₁ · e₀ = -(e₀e₁)). -/
example : mulSign (n := 2) 0b10 0b01 = -1 := by native_decide

/-- Verify: m_01 · m_01 sign = -1 (e₀² = -1). -/
example : mulSign (n := 2) 0b01 0b01 = -1 := by native_decide

/-- Verify: m_11 · m_11 sign = -1 (e₀e₁ · e₀e₁ = -1). -/
example : mulSign (n := 2) 0b11 0b11 = -1 := by native_decide

/-! ## §8. Computational Verification for n = 6 -/

-- Verify generator self-products give sign -1
example : mulSign (n := 6) (bitMask 6 ⟨0, by omega⟩) (bitMask 6 ⟨0, by omega⟩) = -1 := by
  native_decide
example : mulSign (n := 6) (bitMask 6 ⟨3, by omega⟩) (bitMask 6 ⟨3, by omega⟩) = -1 := by
  native_decide

-- Verify anticommutativity: sign(e₀·e₁) = -sign(e₁·e₀)
example : mulSign (n := 6) 0b000001 0b000010 = 1 := by native_decide
example : mulSign (n := 6) 0b000010 0b000001 = -1 := by native_decide

-- Verify the pseudoscalar e₀e₁e₂e₃e₄e₅ squares to -1
example : mulSign (n := 6) 0b111111 0b111111 = -1 := by native_decide

-- Filtration cardinalities
example : (indicesBelow 6 0).card = 1 := by native_decide
example : (indicesBelow 6 1).card = 2 := by native_decide
example : (indicesBelow 6 2).card = 4 := by native_decide
example : (indicesBelow 6 3).card = 8 := by native_decide
example : (indicesBelow 6 4).card = 16 := by native_decide
example : (indicesBelow 6 5).card = 32 := by native_decide
example : (indicesBelow 6 6).card = 64 := by native_decide