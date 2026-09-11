/-
# Surjectivity of the Cl(0,7) → M₈(ℝ) × M₈(ℝ) forward map

We prove that the algebra homomorphism cl07_forward is surjective by showing
the 64 gamma monomials are linearly independent via trace-orthogonality,
then using the idempotent decomposition to generate all of M₈(ℝ)².
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 800000

open CliffordAlgebra Submodule Matrix

open scoped symmDiff

noncomputable section

/-! ## §1. Integer gamma matrices and monomials -/

abbrev M8Z_s := Matrix (Fin 8) (Fin 8) ℤ

def gammaZ_s : Fin 6 → M8Z_s
  | 0 => !![  0, -1,  0,  0,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0,  0,  0, -1,  0]
  | 1 => !![  0,  0, -1,  0,  0,  0,  0,  0;
              0,  0,  0,  1,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0, -1;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0]
  | 2 => !![  0,  0,  0, -1,  0,  0,  0,  0;
              0,  0, -1,  0,  0,  0,  0,  0;
              0,  1,  0,  0,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0, -1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0]
  | 3 => !![  0,  0,  0,  0,  1,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0;
              0,  0, -1,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0]
  | 4 => !![  0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0, -1;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  1,  0,  0,  0,  0,  0,  0;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0]
  | 5 => !![  0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0, -1,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0;
              0,  0,  0,  1,  0,  0,  0,  0;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0]

/-- Ordered product of gammaZ matrices for S ⊆ Fin 6. -/
def gammaMonoZ_s (S : Finset (Fin 6)) : M8Z_s :=
  (S.sort (· ≤ ·)).foldr (fun i acc => gammaZ_s i * acc) 1

/-! ## §2. Per-generator properties (small native_decide atoms) -/

theorem gammaZ_s_sq (a : Fin 6) : gammaZ_s a * gammaZ_s a = -1 := by
  fin_cases a <;> native_decide

theorem gammaZ_s_antisymm (i : Fin 6) : (gammaZ_s i).transpose = -(gammaZ_s i) := by
  fin_cases i <;> native_decide

theorem gammaZ_s_orth (i : Fin 6) : (gammaZ_s i).transpose * (gammaZ_s i) = 1 := by
  fin_cases i <;> native_decide

theorem gammaZ_s_anticommute {a b : Fin 6} (hab : a ≠ b) :
    gammaZ_s a * gammaZ_s b + gammaZ_s b * gammaZ_s a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;> native_decide

theorem gammaZ_s_swap {a b : Fin 6} (hab : a ≠ b) :
    gammaZ_s a * gammaZ_s b = -(gammaZ_s b * gammaZ_s a) := by
  have h := gammaZ_s_anticommute hab
  have : gammaZ_s a * gammaZ_s b = -(gammaZ_s b * gammaZ_s a) := by
    rw [eq_neg_iff_add_eq_zero]; exact h
  exact this

theorem trace_M8Z_s_one : Matrix.trace (1 : M8Z_s) = 8 := by native_decide

/-! ## §3. Trace-zero for nonempty gamma monomials -/

theorem trace_gammaMonoZ_s_zero :
    ∀ S ∈ (Finset.univ : Finset (Fin 6)).powerset,
    S.Nonempty → Matrix.trace (gammaMonoZ_s S) = 0 := by native_decide

theorem trace_gammaMonoZ_s_zero' (S : Finset (Fin 6)) (hS : S.Nonempty) :
    Matrix.trace (gammaMonoZ_s S) = 0 := by
  exact trace_gammaMonoZ_s_zero S (Finset.mem_powerset.mpr (Finset.subset_univ S)) hS

/-! ## §4. Orthogonality of gamma monomials -/

theorem orth_mul_M8Z (M N : M8Z_s)
    (hM : M.transpose * M = 1) (hN : N.transpose * N = 1) :
    (M * N).transpose * (M * N) = 1 := by
  rw [Matrix.transpose_mul, Matrix.mul_assoc,
      ← Matrix.mul_assoc M.transpose, hM, Matrix.one_mul, hN]

/-- Decomposition by minimum element. -/
theorem gammaMonoZ_s_min_mul (S : Finset (Fin 6)) (hS : S.Nonempty) :
    gammaMonoZ_s S = gammaZ_s (S.min' hS) * gammaMonoZ_s (S.erase (S.min' hS)) := by
  unfold gammaMonoZ_s
  rw [show S.sort (· ≤ ·) = S.min' hS :: (S.erase (S.min' hS)).sort (· ≤ ·) from ?_]
  · rfl
  · native_decide +revert

/-
All gamma monomials are orthogonal matrices: M^T M = I.
-/
theorem gammaMonoZ_s_orth (S : Finset (Fin 6)) :
    (gammaMonoZ_s S).transpose * (gammaMonoZ_s S) = 1 := by
  -- We proceed by induction on the cardinality of S.
  induction' S using Finset.strongInduction with S ih;
  by_cases hS : S.Nonempty;
  · rw [ gammaMonoZ_s_min_mul S hS ];
    rw [ ← Matrix.mul_assoc ];
    simp +decide [ Matrix.mul_assoc, gammaZ_s_orth, ih _ ( Finset.erase_ssubset ( Finset.min'_mem _ hS ) ) ];
  · unfold gammaMonoZ_s; aesop;

/-! ## §5. Generator × monomial signed formula -/

/-- Insert at the front when i ≤ all elements. -/
theorem gammaMonoZ_s_insert_le (i : Fin 6) (S : Finset (Fin 6))
    (hle : ∀ s ∈ S, i ≤ s) (hi : i ∉ S) :
    gammaMonoZ_s (insert i S) = gammaZ_s i * gammaMonoZ_s S := by
  unfold gammaMonoZ_s
  have h_sort : (insert i S).sort (· ≤ ·) = i :: S.sort (· ≤ ·) := by
    native_decide +revert
  rw [h_sort]; rfl

/-
Multiplying gammaZ_s i by gammaMonoZ_s S gives ε • gammaMonoZ_s (symmDiff S {i})
    for some sign ε.
-/
theorem gen_mul_gammaMonoZ_s (i : Fin 6) (S : Finset (Fin 6)) :
    ∃ (ε : ℤ) (T : Finset (Fin 6)),
      gammaZ_s i * gammaMonoZ_s S = ε • gammaMonoZ_s T ∧ T ⊆ S ∪ {i} := by
  by_cases hS : S.Nonempty;
  · induction' n : Finset.card ( S.filter ( · < i ) ) using Nat.strong_induction_on with n ih generalizing S i;
    by_cases h_cases : ∀ s ∈ S, i ≤ s;
    · by_cases hi : i ∈ S;
      · rw [ gammaMonoZ_s_min_mul S hS ];
        rw [ show S.min' hS = i from le_antisymm ( Finset.min'_le _ _ hi ) ( h_cases _ ( Finset.min'_mem _ hS ) ) ];
        rw [ ← mul_assoc, gammaZ_s_sq ];
        exact ⟨ -1, S.erase i, by norm_num, by aesop_cat ⟩;
      · use 1, insert i S;
        rw [ gammaMonoZ_s_insert_le ] <;> aesop;
    · obtain ⟨m, hm⟩ : ∃ m ∈ S, m < i ∧ ∀ s ∈ S, s < i → m ≤ s := by
        grind;
      -- By the induction hypothesis, we have gammaZ_s i * gammaMonoZ_s (S.erase m) = ε' • gammaMonoZ_s T' with T' ⊆ (S.erase m) ∪ {i}.
      obtain ⟨ε', T', hT'⟩ : ∃ ε' : ℤ, ∃ T' : Finset (Fin 6), gammaZ_s i * gammaMonoZ_s (S.erase m) = ε' • gammaMonoZ_s T' ∧ T' ⊆ (S.erase m) ∪ {i} := by
        by_cases hS_erase : (S.erase m).Nonempty;
        · apply ih (Finset.card (Finset.filter (fun x => x < i) (S.erase m)));
          · rw [ ← n ];
            refine' Finset.card_lt_card _;
            simp_all +decide [ Finset.ssubset_def, Finset.subset_iff ];
          · assumption;
          · rfl;
        · simp_all +decide [ Finset.nonempty_iff_ne_empty ];
          exact ⟨ 1, { i }, by simp +decide [ gammaMonoZ_s ] ⟩;
      -- Since m ≤ all elements of T' (m was the min of S, and T' ⊆ (S.erase m) ∪ {i}, and m < i and m ≤ all of S.erase m), and m ∉ T', we have gammaZ_s m * gammaMonoZ_s T' = gammaMonoZ_s (insert m T') [by gammaMonoZ_s_insert_le]
      have h_insert : gammaZ_s m * gammaMonoZ_s T' = gammaMonoZ_s (insert m T') := by
        apply Eq.symm; exact (by
          have h_insert : ∀ s ∈ T', m ≤ s := by
            grind
          apply gammaMonoZ_s_insert_le m T' h_insert (by
          grind));
      -- So the product = -(gammaZ_s m * (ε' • gammaMonoZ_s T')) = -ε' • (gammaZ_s m * gammaMonoZ_s T')
      have h_prod : gammaZ_s i * gammaMonoZ_s S = -ε' • (gammaZ_s m * gammaMonoZ_s T') := by
        have h_prod : gammaZ_s i * gammaMonoZ_s S = -(gammaZ_s m * (gammaZ_s i * gammaMonoZ_s (S.erase m))) := by
          have h_prod : gammaZ_s i * gammaMonoZ_s S = gammaZ_s i * (gammaZ_s m * gammaMonoZ_s (S.erase m)) := by
            rw [ gammaMonoZ_s_min_mul S hS ];
            rw [ show S.min' hS = m from le_antisymm ( Finset.min'_le _ _ hm.1 ) ( hm.2.2 _ ( Finset.min'_mem _ hS ) ( lt_of_le_of_lt ( Finset.min'_le _ _ hm.1 ) hm.2.1 ) ) ];
          rw [ h_prod, ← Matrix.mul_assoc ];
          rw [ ← Matrix.mul_assoc, gammaZ_s_swap ];
          · rw [ neg_mul ];
          · exact ne_of_gt hm.2.1;
        simp_all +decide [ mul_assoc, smul_smul ];
        rw [ ← h_insert, ← mul_assoc ];
        simp +decide [ mul_assoc, mul_left_comm, Int.cast_comm ];
      use -ε', insert m T';
      grind;
  · use 1, { i };
    native_decide +revert

/-! ## §6. Product formula and Gram matrix -/

/-
Products of gamma monomials are scalar multiples of gamma monomials.
-/
theorem gammaMonoZ_s_mul_scalar (S T : Finset (Fin 6)) :
    ∃ (ε : ℤ) (U : Finset (Fin 6)), gammaMonoZ_s S * gammaMonoZ_s T = ε • gammaMonoZ_s U := by
  induction' S using Finset.strongInduction with S ih generalizing T;
  by_cases hS : S.Nonempty;
  · obtain ⟨ε₁, U₁, h₁⟩ : ∃ ε₁ : ℤ, ∃ U₁ : Finset (Fin 6), gammaMonoZ_s (S.erase (S.min' hS)) * gammaMonoZ_s T = ε₁ • gammaMonoZ_s U₁ := by
      exact ih _ ( Finset.erase_ssubset ( Finset.min'_mem _ hS ) ) _;
    obtain ⟨ε₂, U₂, h₂⟩ : ∃ ε₂ : ℤ, ∃ U₂ : Finset (Fin 6), gammaZ_s (S.min' hS) * gammaMonoZ_s U₁ = ε₂ • gammaMonoZ_s U₂ := by
      exact Exists.elim ( gen_mul_gammaMonoZ_s ( S.min' hS ) U₁ ) fun ε hε => Exists.elim hε fun U hU => ⟨ ε, U, hU.1 ⟩;
    use ε₁ * ε₂, U₂;
    convert congr_arg ( fun x => gammaZ_s ( S.min' hS ) * x ) h₁ using 1;
    · rw [ ← mul_assoc, gammaMonoZ_s_min_mul S hS ];
    · rw [ mul_smul_comm, h₂, smul_smul ];
  · exact ⟨ 1, T, by rw [ show S = ∅ by aesop ] ; simp +decide [ gammaMonoZ_s ] ⟩

/-! ## §6a. Signed permutation encoding for efficient computation -/

/-- Signed permutation: a permutation σ of Fin 8 plus a sign at each position.
    Represents the matrix M where M[i, σ(i)] = ±1, all other entries 0. -/
structure SPerm8 where
  perm : Fin 8 → Fin 8
  sign : Fin 8 → Bool
deriving DecidableEq

instance : Mul SPerm8 where
  mul a b := {
    perm := fun i => b.perm (a.perm i)
    sign := fun i => !(xor (a.sign i) (b.sign (a.perm i)))
  }

instance : One SPerm8 where
  one := { perm := id, sign := fun _ => true }

def invPerm8 (σ : Fin 8 → Fin 8) (j : Fin 8) : Fin 8 :=
  ((List.finRange 8).find? (fun i => σ i = j)).getD 0

def SPerm8.tr (a : SPerm8) : SPerm8 where
  perm := invPerm8 a.perm
  sign := fun j => a.sign (invPerm8 a.perm j)

def SPerm8.traceVal (a : SPerm8) : ℤ :=
  (Finset.univ : Finset (Fin 8)).sum fun i =>
    if a.perm i = i then (if a.sign i then 1 else -1) else 0

def SPerm8.toMatrix (sp : SPerm8) : M8Z_s :=
  Matrix.of fun i j => if sp.perm i = j then (if sp.sign i then 1 else -1) else 0

/-- Signed permutation encodings of the 6 gamma generators. -/
def gamSP : Fin 6 → SPerm8
  | 0 => { perm := ![1,0,3,2,5,4,7,6], sign := ![false,true,false,true,true,false,true,false] }
  | 1 => { perm := ![2,3,0,1,6,7,4,5], sign := ![false,true,true,false,true,false,false,true] }
  | 2 => { perm := ![3,2,1,0,7,6,5,4], sign := ![false,false,true,true,true,true,false,false] }
  | 3 => { perm := ![4,5,6,7,0,1,2,3], sign := ![true,true,true,true,false,false,false,false] }
  | 4 => { perm := ![5,4,7,6,1,0,3,2], sign := ![true,false,false,true,true,false,false,true] }
  | 5 => { perm := ![6,7,4,5,2,3,0,1], sign := ![true,true,false,false,true,true,false,false] }

def gamMonoSP (S : Finset (Fin 6)) : SPerm8 :=
  (S.sort (· ≤ ·)).foldr (fun i acc => gamSP i * acc) 1

/-- The SPerm8 encoding matches the matrix definition for each generator. -/
theorem gamSP_toMatrix (k : Fin 6) : (gamSP k).toMatrix = gammaZ_s k := by
  fin_cases k <;> native_decide

/-- The SPerm8 gram check: all off-diagonal entries are zero. -/
theorem gramCheckSP :
    ∀ S ∈ (Finset.univ : Finset (Fin 6)).powerset,
    ∀ T ∈ (Finset.univ : Finset (Fin 6)).powerset,
    S ≠ T → ((gamMonoSP S).tr * (gamMonoSP T)).traceVal = 0 := by
  native_decide

/-
SPerm8 multiplication matches matrix multiplication.
-/
theorem sperm_mul_toMatrix (a b : SPerm8) :
    (a * b).toMatrix = a.toMatrix * b.toMatrix := by
      ext i j; simp +decide [ SPerm8.toMatrix ] ;
      simp +decide [ Matrix.mul_apply, Finset.sum_ite ];
      split_ifs <;> simp_all +decide [ xor ];
      all_goals erw [ show ( a * b ).perm i = b.perm ( a.perm i ) from rfl ] at *; simp_all +decide ;
      · rename_i h₁ h₂ h₃;
        exact absurd h₁ ( by erw [ show ( a * b ).sign i = !(xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] ; simp +decide [ h₂, h₃ ] );
      · rename_i h₁ h₂ h₃; erw [ show ( a * b ).sign i = ! ( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] at h₁; simp_all +decide ;
      · erw [ show ( a * b ).sign i = !(xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] at * ; simp_all +decide [ xor ] ;
      · erw [ show ( a * b ).sign i = !(xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] at * ; simp_all +decide [ xor ]

/-- For gamMonoSP values (actual permutations), transpose matches. -/
theorem gamMonoSP_tr_toMatrix (S : Finset (Fin 6)) :
    (gamMonoSP S).tr.toMatrix = (gamMonoSP S).toMatrix.transpose := by
  have : ∀ S ∈ (Finset.univ : Finset (Fin 6)).powerset,
      (gamMonoSP S).tr.toMatrix = (gamMonoSP S).toMatrix.transpose := by native_decide
  exact this S (Finset.mem_powerset.mpr (Finset.subset_univ S))

/-
SPerm8 trace matches matrix trace.
-/
theorem sperm_trace_eq (a : SPerm8) :
    a.traceVal = Matrix.trace a.toMatrix := by
      rfl

/-
gamMonoSP matches gammaMonoZ_s.
-/
theorem gamMonoSP_toMatrix (S : Finset (Fin 6)) :
    (gamMonoSP S).toMatrix = gammaMonoZ_s S := by
      unfold gamMonoSP gammaMonoZ_s;
      induction' S.sort ( fun x1 x2 => x1 ≤ x2 ) with i S ih <;> simp +decide [ *, sperm_mul_toMatrix ];
      rw [ gamSP_toMatrix ]

/-- For S ≠ T, trace of M_S^T M_T = 0. -/
theorem gram_offdiag_s (S T : Finset (Fin 6)) (hST : S ≠ T) :
    Matrix.trace ((gammaMonoZ_s S).transpose * (gammaMonoZ_s T)) = 0 := by
  rw [← gamMonoSP_toMatrix S, ← gamMonoSP_toMatrix T,
      ← gamMonoSP_tr_toMatrix, ← sperm_mul_toMatrix, ← sperm_trace_eq]
  exact gramCheckSP S (Finset.mem_powerset.mpr (Finset.subset_univ S))
    T (Finset.mem_powerset.mpr (Finset.subset_univ T)) hST

/-- Gram diagonal: trace(M_S^T M_S) = 8. -/
theorem gram_diag_s (S : Finset (Fin 6)) :
    Matrix.trace ((gammaMonoZ_s S).transpose * (gammaMonoZ_s S)) = 8 := by
  rw [gammaMonoZ_s_orth S, trace_M8Z_s_one]

end