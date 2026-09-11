/-
# Simplicity of alternating groups for n ≥ 5

We prove A_n is simple for n ≥ 5. Strategy:
any nontrivial normal subgroup contains a 3-cycle (by case analysis on cycle structure),
hence equals A_n by `alternating_normalClosure`.
-/

import Mathlib

open Equiv Equiv.Perm Subgroup Finset

/-! ## Basic helpers -/

lemma commutator_mem_of_normal {G : Type*} [Group G] {H : Subgroup G}
    (hN : H.Normal) {a : G} (ha : a ∈ H) (b : G) :
    a * b * a⁻¹ * b⁻¹ ∈ H := by
  simpa [mul_assoc] using H.mul_mem ha (hN.conj_mem _ (H.inv_mem ha) b)

/-- Conjugation preserves membership in a normal subgroup:
    if σ ∈ H and H is normal, then g * σ * g⁻¹ * σ⁻¹ ∈ H. -/
lemma conj_commutator_mem {G : Type*} [Group G] {H : Subgroup G}
    (hN : H.Normal) {σ : G} (hσ : σ ∈ H) (g : G) :
    g * σ * g⁻¹ * σ⁻¹ ∈ H :=
  H.mul_mem (hN.conj_mem σ hσ g) (H.inv_mem hσ)

lemma three_cycle_mem_alternating {α : Type*} [DecidableEq α] [Fintype α]
    {a b c : α} (hab : a ≠ b) (hbc : b ≠ c) (hac : a ≠ c) :
    swap a b * swap b c ∈ alternatingGroup α := by
  simp +decide [alternatingGroup, hab, hbc, hac]

/-! ## Commutator computation for long cycles -/

lemma commutator_long_cycle_small_support {α : Type*} [DecidableEq α] [Fintype α]
    {σ : Perm α} {a b c d : α}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d)
    (hσa : σ a = b) (hσb : σ b = c) (hσc : σ c = d) :
    (σ * (swap a b * swap b c) * σ⁻¹ * (swap b c * swap a b)).support.card = 3 := by
  have h_eq : σ * (swap a b * swap b c) * σ⁻¹ * (swap b c * swap a b) = swap a d * swap d b := by
    ext x
    by_cases hx : x = a <;> by_cases hx' : x = b <;> by_cases hx'' : x = c <;>
      by_cases hx''' : x = d <;> simp_all +decide [Equiv.swap_apply_def]
    · have := σ.injective (by aesop : σ (σ.symm c) = σ b); aesop
    · grind +splitImp
    · rw [show (Equiv.symm σ) b = a by rw [← hσa, Equiv.symm_apply_apply]]; aesop
    · rw [← hσc, Equiv.symm_apply_apply]; aesop
    · grind +extAll
  rw [h_eq, show (swap a d * swap d b : Equiv.Perm α).support = {a, d, b} from ?_]
  · rw [Finset.card_insert_of_notMem, Finset.card_insert_of_notMem] <;> aesop
  · simp +decide [Finset.ext_iff, Equiv.swap_apply_def, *]; grind

/-! ## Long cycle case gives a 3-cycle in H -/

lemma three_cycle_from_long_cycle {n : ℕ}
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H)
    {a b c d : Fin n}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d)
    (hσa : (σ₀ : Perm (Fin n)) a = b)
    (hσb : (σ₀ : Perm (Fin n)) b = c)
    (hσc : (σ₀ : Perm (Fin n)) c = d) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  set τ₀ : alternatingGroup (Fin n) :=
    ⟨swap a b * swap b c, three_cycle_mem_alternating hab hbc hac⟩
  have h_comm_cycle :
      (σ₀ * τ₀ * σ₀⁻¹ * τ₀⁻¹ : alternatingGroup (Fin n)).val.support.card = 3 := by
    convert commutator_long_cycle_small_support hab hac had hbc hbd hcd hσa hσb hσc using 1
  grind +suggestions

/-! ## Center of A_n is trivial -/

lemma eq_one_of_commutes_with_all {n : ℕ} (hn : 4 ≤ n)
    (σ : alternatingGroup (Fin n))
    (hcomm : ∀ τ : alternatingGroup (Fin n), σ * τ = τ * σ) :
    σ = 1 := by
  have h_center : Subgroup.center (alternatingGroup (Fin n)) = ⊥ := by
    convert alternatingGroup.center_eq_bot;
    rotate_left;
    exact Fin n;
    exacts [ inferInstance, inferInstance, by simp +decide [ hn ] ]
  have h_sigma_one : σ ∈ Subgroup.center (alternatingGroup (Fin n)) := by
    rw [ Subgroup.mem_center_iff ] ; aesop;
  rw [h_center] at h_sigma_one
  exact h_sigma_one

lemma commutator_ne_one_of_not_comm {G : Type*} [Group G]
    {σ τ : G} (h : σ * τ ≠ τ * σ) :
    σ⁻¹ * (τ * σ * τ⁻¹) ≠ 1 := by
  simp_all +decide [ mul_assoc, inv_mul_eq_iff_eq_mul ];
  exact fun h' => h ( by simpa [ mul_assoc ] using congr_arg ( · * τ ) h'.symm )

lemma support_commutator_subset {α : Type*} [DecidableEq α] [Fintype α]
    (σ τ : Perm α) :
    (σ⁻¹ * (τ * σ * τ⁻¹)).support ⊆ σ.support ∪ τ.support := by
  intro x hx;
  simp_all +decide [ Equiv.Perm.mem_support, mul_assoc ];
  grind

/-! ## Pigeonhole: finding fresh points in Fin n -/

/-
Given 4 elements in Fin n with n ≥ 5, there exists a 5th distinct element.
-/
lemma exists_fifth_point {n : ℕ} (hn : 5 ≤ n) (a b c d : Fin n) :
    ∃ e : Fin n, e ≠ a ∧ e ≠ b ∧ e ≠ c ∧ e ≠ d := by
  by_contra h;
  -- Since Fin n has n elements and {a,b,c,d} has at most 4 elements, by pigeonhole, there exists e ∈ Fin n \ {a,b,c,d}.
  have h_card : Finset.card (Finset.univ \ {a, b, c, d}) > 0 := by
    simp +decide [ Finset.card_sdiff, * ];
    grind +qlia;
  exact h_card.ne' ( Finset.card_eq_zero.mpr <| Finset.eq_empty_of_forall_notMem fun x hx => h ⟨ x, by aesop ⟩ )

/-! ## Even permutations with a transposition must have extra support -/

/-
An even permutation that swaps a ≠ b and is not the identity must move some point outside {a, b}.
-/
lemma even_perm_extra_support {n : ℕ} {σ : Perm (Fin n)}
    (hσ_even : σ ∈ alternatingGroup (Fin n))
    {a b : Fin n} (hab : a ≠ b)
    (hσa : σ a = b) (hσb : σ b = a) :
    ∃ p : Fin n, p ≠ a ∧ p ≠ b ∧ σ p ≠ p := by
  by_contra h_contra;
  have h_contradiction : σ = Equiv.swap a b := by
    grind;
  simp_all +decide [ Equiv.Perm.mem_alternatingGroup ]

/-! ## Key case: 3-cycle plus additional structure gives a 3-cycle in H

If σ ∈ H has a 3-cycle (a→b→c→a) and also moves d to e (with all five distinct),
then H contains a 3-cycle.

Proof: conjugate by γ = (b c d). The commutator γσγ⁻¹σ⁻¹ maps c→e→a→d
(a chain of 4 distinct points), so three_cycle_from_long_cycle applies.
-/

lemma three_cycle_from_three_cycle_and_more {n : ℕ}
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H)
    {a b c d e : Fin n}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d) (hae : a ≠ e)
    (hbc : b ≠ c) (hbd : b ≠ d) (hbe : b ≠ e)
    (hcd : c ≠ d) (hce : c ≠ e) (hde : d ≠ e)
    (hσa : (σ₀ : Perm (Fin n)) a = b) (hσb : (σ₀ : Perm (Fin n)) b = c)
    (hσc : (σ₀ : Perm (Fin n)) c = a) (hσd : (σ₀ : Perm (Fin n)) d = e) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  -- Let γ = swap b c * swap c � d�.
  set γ : alternatingGroup (Fin n) := ⟨swap b c * swap c d, by
    simp +decide [ *, Equiv.Perm.mem_alternatingGroup ]⟩
  generalize_proofs at *;
  -- Let � ρ� = (γ * σ₀ * γ⁻¹) * σ₀⁻¹. Then � ρ� ∈ H because γ * σ₀ * γ⁻¹ ∈ H (normality) and σ₀⁻¹ ∈ H.
  set ρ : alternatingGroup (Fin n) := (γ * σ₀ * γ⁻¹) * σ₀⁻¹
  have hρH : ρ ∈ H := by
    exact H.mul_mem ( hN.conj_mem _ hσH γ ) ( H.inv_mem hσH );
  -- Now compute.val = (swap b c * swap c d) * σ₀.val * (swap b c * swap c d)⁻¹ * σ₀.val⁻¹.
  have hρ_val : (ρ : Perm (Fin n)) c = e ∧ (ρ : Perm (Fin n)) e = a ∧ (ρ : Perm (Fin n)) a = d := by
    simp +zetaDelta at *;
    grind;
  convert three_cycle_from_long_cycle H hρH ( show c ≠ e by tauto ) ( show c ≠ a by tauto ) ( show c ≠ d by tauto ) ( show e ≠ a by tauto ) ( show e ≠ d by tauto ) ( show a ≠ d by tauto ) hρ_val.1 hρ_val.2.1 hρ_val.2.2 using 1

/-! ## Key case: double transposition with fixed point gives a 3-cycle in H

If σ ∈ H swaps a↔b and c↔d and fixes e (all five distinct),
then H contains a 3-cycle.

Proof: Let τ = (a c e). The commutator σ·τ·σ⁻¹·τ⁻¹ maps a→b→d→e
(a chain of 4 distinct points), so three_cycle_from_long_cycle applies.
-/

lemma three_cycle_from_double_transposition_fixed {n : ℕ}
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H)
    {a b c d e : Fin n}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d) (hae : a ≠ e)
    (hbc : b ≠ c) (hbd : b ≠ d) (hbe : b ≠ e)
    (hcd : c ≠ d) (hce : c ≠ e) (hde : d ≠ e)
    (hσa : (σ₀ : Perm (Fin n)) a = b) (hσb : (σ₀ : Perm (Fin n)) b = a)
    (hσc : (σ₀ : Perm (Fin n)) c = d) (hσd : (σ₀ : Perm (Fin n)) d = c)
    (hσe : (σ₀ : Perm (Fin n)) e = e) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  have h_comm : (σ₀ * ⟨swap a c * swap c e, by
    simp +decide [ *, Equiv.Perm.mem_alternatingGroup ]⟩ * σ₀⁻¹ * (⟨swap a c * swap c e, by
    simp +decide [ *, Equiv.Perm.mem_alternatingGroup ]⟩⁻¹) : alternatingGroup (Fin n)) ∈ H := by
    convert commutator_mem_of_normal hN hσH _ using 1
  generalize_proofs at *;
  apply three_cycle_from_long_cycle H h_comm;
  exact hab;
  exact had;
  all_goals norm_num [ mul_assoc, hσa, hσb, hσc, hσd, hσe ];
  any_goals assumption;
  · rw [ show ( Equiv.symm σ₀.val ) e = e from by rw [ Equiv.symm_apply_eq, hσe ] ] ; simp +decide [ *, swap_apply_def ];
  · grind;
  · grind

/-! ## Key case: triple transposition gives a 3-cycle in H

If σ ∈ H swaps a↔b, c↔d, and e↔f (all six distinct),
then H contains a 3-cycle.

Proof: Let τ = (a c e). The commutator σ·τ·σ⁻¹·τ⁻¹ = (a e c)(b d f),
which has a 3-cycle (a→e→c→a) and extra structure (b→d).
Apply three_cycle_from_three_cycle_and_more to the commutator.
-/

lemma three_cycle_from_triple_transposition {n : ℕ}
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H)
    {a b c d e f : Fin n}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d) (hae : a ≠ e) (haf : a ≠ f)
    (hbc : b ≠ c) (hbd : b ≠ d) (hbe : b ≠ e) (hbf : b ≠ f)
    (hcd : c ≠ d) (hce : c ≠ e) (hcf : c ≠ f)
    (hde : d ≠ e) (hdf : d ≠ f) (hef : e ≠ f)
    (hσa : (σ₀ : Perm (Fin n)) a = b) (hσb : (σ₀ : Perm (Fin n)) b = a)
    (hσc : (σ₀ : Perm (Fin n)) c = d) (hσd : (σ₀ : Perm (Fin n)) d = c)
    (hσe : (σ₀ : Perm (Fin n)) e = f) (hσf : (σ₀ : Perm (Fin n)) f = e) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  revert σ₀;
  -- Let τ₀ = ⟨swap a c * swap c e, three_cycle_mem_alternating hac hce hae⟩ : alternatingGroup (Fin n). Then₀ = σ₀ * τ₀ * σ₀⁻¹ * τ₀⁻¹ ∈ H.
  intro σ₀ hσH hσa hσb hσc hσd hσe hσf
  set τ₀ : alternatingGroup (Fin n) := ⟨swap a c * swap c e, three_cycle_mem_alternating hac hce hae⟩
  set ρ₀ : alternatingGroup (Fin n) := σ₀ * τ₀ * σ₀⁻¹ * τ₀⁻¹
  have hρ₀ : ρ₀ ∈ H := by
    exact?;
  -- Check � distinct�ness: a,e,c,b,d are pairwise distinct (from the original six being pairwise distinct).
  have h_distinct : a ≠ e ∧ a ≠ c ∧ a ≠ b ∧ a ≠ d ∧ e ≠ c ∧ e ≠ b ∧ e ≠ d ∧ c ≠ b ∧ c ≠ d ∧ b ≠ d := by
    grobner;
  apply three_cycle_from_three_cycle_and_more H hρ₀ h_distinct.1 h_distinct.2.1 h_distinct.2.2.1 h_distinct.2.2.2.1 h_distinct.2.2.2.2.1 h_distinct.2.2.2.2.2.1 h_distinct.2.2.2.2.2.2.1 h_distinct.2.2.2.2.2.2.2.1 h_distinct.2.2.2.2.2.2.2.2.1 h_distinct.2.2.2.2.2.2.2.2.2;
  · simp +zetaDelta at *;
    grind;
  · simp +zetaDelta at *;
    grind;
  · simp +zetaDelta at *;
    grind;
  · simp +zetaDelta at *;
    simp +decide [ *, Equiv.swap_apply_def ];
    split_ifs <;> simp_all +decide [ Equiv.symm_apply_eq ]

/-! ## Sub-case: σ has a 3-cycle (a b c) -/

/-
If σ ∈ H has a 3-cycle factor (a b c) (and possibly more structure), H contains a 3-cycle.
-/
private lemma case_three_cycle_main {n : ℕ}
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H) (hσ_ne : σ₀ ≠ 1)
    {a b c : Fin n} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hσa : (σ₀ : Perm (Fin n)) a = b) (hσb : (σ₀ : Perm (Fin n)) b = c)
    (hσc : (σ₀ : Perm (Fin n)) c = a) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  by_cases h : ∀ x, x ≠ a → x ≠ b → x ≠ c → σ₀.val x = x;
  · -- In this case, σ₀ is a 3-cycle, so we are done.
    use σ₀, hσH;
    have h_three_cycle : σ₀.val = swap a b * swap b c := by
      aesop;
    convert isThreeCycle_swap_mul_swap_same ( show b ≠ a by tauto ) ( show b ≠ c by tauto ) ( show a ≠ c by tauto ) using 1;
    rw [ h_three_cycle, swap_comm ];
  · -- So there exists $d \neq � a�, b, c$ such that $\sigma₀(d) \neq d$.
    obtain ⟨d, hd₁, hd₂⟩ : ∃ d : Fin n, d ≠ a ∧ d ≠ b ∧ d ≠ c ∧ σ₀.val d ≠ d := by
      grind;
    -- Let $e = \sigma₀ �(d�)$. Then $e \neq a$, $e \neq b$, $e \neq c$, and $e \neq d$.
    obtain ⟨e, he⟩ : ∃ e : Fin n, e ≠ a ∧ e ≠ b ∧ e ≠ c ∧ e ≠ d ∧ σ₀.val d = e := by
      aesop;
    apply three_cycle_from_three_cycle_and_more H hσH hab hac (by tauto) (by tauto) (by tauto) (by tauto) (by tauto) (by tauto) (by tauto) (by tauto) hσa hσb hσc he.2.2.2.2

/-! ## Sub-case: σ has two disjoint transpositions (a b)(p q) -/

/-
If σ ∈ H has two disjoint transpositions and n ≥ 5, H contains a 3-cycle.
-/
private lemma case_double_transposition_main {n : ℕ} (hn : 5 ≤ n)
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H)
    {a b p q : Fin n}
    (hab : a ≠ b) (hap : a ≠ p) (haq : a ≠ q)
    (hbp : b ≠ p) (hbq : b ≠ q) (hpq : p ≠ q)
    (hσa : (σ₀ : Perm (Fin n)) a = b) (hσb : (σ₀ : Perm (Fin n)) b = a)
    (hσp : (σ₀ : Perm (Fin n)) p = q) (hσq : (σ₀ : Perm (Fin n)) q = p) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  -- By exists_fifth_point, e {a,b,p,q}.
  obtain ⟨e, he⟩ : ∃ e : Fin n, e ≠ a ∧ e ≠ b ∧ e ≠ p ∧ e ≠ q := by
    exact Exists.imp ( by aesop ) ( exists_fifth_point hn a b p q );
  by_cases he' : σ₀.val e = e <;> simp_all +decide;
  · have := @three_cycle_from_double_transposition_fixed n H hN σ₀ hσH a b p q e hab hap haq ( by tauto ) hbp hbq ( by tauto ) hpq ( by tauto ) ( by tauto ) hσa hσb hσp hσq he';
    aesop;
  · -- Let f = σ₀.val e.
    set f := σ₀.val e with hf_def;
    -- Case 2a: g = e (transposition (e f)).
    by_cases hg : σ₀.val f = e;
    · have := @three_cycle_from_triple_transposition n H hN σ₀ hσH a b p q e f; simp_all +decide ;
      grind;
    · -- Case 2b-i: h = e → 3-cycle (e f g). σ has transposition (a b) and 3 �-cycle� (e f g).
      by_cases hh : σ₀.val (σ₀.val f) = e;
      · have := @three_cycle_from_three_cycle_and_more n H hN σ₀ hσH e f ( σ₀.val f ) a b; simp_all +decide [ Equiv.Perm.IsThreeCycle ] ;
        grind +ring;
      · -- Case 2b-ii: h ≠ e → long cycle e→f→g→h.
        set g := σ₀.val f with hg_def
        set h := σ₀.val g with hh_def;
        have h_distinct : e ≠ f ∧ e ≠ g ∧ e ≠ h ∧ f ≠ g ∧ f ≠ h ∧ g ≠ h := by
          have h_inj : Function.Injective (σ₀.val) := by
            exact σ₀.1.injective
          grind +ring;
        have := three_cycle_from_long_cycle H hσH ( show e ≠ f from h_distinct.1 ) ( show e ≠ g from h_distinct.2.1 ) ( show e ≠ h from h_distinct.2.2.1 ) ( show f ≠ g from h_distinct.2.2.2.1 ) ( show f ≠ h from h_distinct.2.2.2.2.1 ) ( show g ≠ h from h_distinct.2.2.2.2.2 ) ( by aesop ) ( by aesop ) ( by aesop ) ; aesop;

/-! ## Sub-case: σ has a transposition (a b) -/

/-
If σ ∈ H is an even permutation with a transposition (a b) and n ≥ 5, H contains a 3-cycle.
-/
private lemma case_transposition_main {n : ℕ} (hn : 5 ≤ n)
    (H : Subgroup (alternatingGroup (Fin n))) [hN : H.Normal]
    {σ₀ : alternatingGroup (Fin n)} (hσH : σ₀ ∈ H)
    {a b : Fin n} (hab : a ≠ b)
    (hσa : (σ₀ : Perm (Fin n)) a = b) (hσb : (σ₀ : Perm (Fin n)) b = a) :
    ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
  -- By even_perm_extra_support �, p ≠ a, p ≠ b, σ₀.val p ≠ p.
  obtain ⟨p, hp_ne_a, hp_ne_b, hp_ne_p⟩ : ∃ p : Fin n, p ≠ a ∧ p ≠ b ∧ σ₀.val p ≠ p := even_perm_extra_support σ₀.2 hab hσa hσb;
  -- Let q = σ₀.val p
  set q := σ₀.val p with hq_def;
  -- Let r = σ₀.val q
  set r := σ₀.val q with hr_def;
  by_cases hr_ne_p : r ≠ p;
  · -- Let s = σ₀.val r
    set s := σ₀.val r with hs_def;
    by_cases hs_ne_p : s = p;
    -- Since σ has transposition (a b) and 3-cycle (p q r), apply case_three_cycle_main or three_cycle_from_three_cycle_and_more with (p,q,r,a,b).
    have h_three_cycle : ∃ τ : alternatingGroup (Fin n), τ ∈ H ∧ (τ : Perm (Fin n)).IsThreeCycle := by
      have h_distinct : p ≠ q ∧ p ≠ r ∧ q ≠ r ∧ p ≠ a ∧ p ≠ b ∧ q ≠ a ∧ q ≠ b ∧ r ≠ a ∧ r ≠ b := by
        grind
      apply case_three_cycle_main H hσH;
      exact fun h => hp_ne_p <| by simp_all +decide ;
      exact h_distinct.1;
      exact h_distinct.2.1;
      · grind;
      · rfl;
      · grind +splitImp;
      · exact hs_ne_p;
    exact h_three_cycle;
    have h_distinct : p ≠ q ∧ p ≠ r ∧ p ≠ s ∧ q ≠ r ∧ q ≠ s ∧ r ≠ s := by
      simp_all +decide [ Equiv.Perm.ext_iff ];
      grind;
    convert three_cycle_from_long_cycle H hσH ( show p ≠ q by tauto ) ( show p ≠ r by tauto ) ( show p ≠ s by tauto ) ( show q ≠ r by tauto ) ( show q ≠ s by tauto ) ( show r ≠ s by tauto ) _ _ _ using 1 <;> aesop ( simp_config := { singlePass := true } ) ;;
  · -- Since $r = p$, � we� have $\sigma₀(q) = p$, which means $\sigma₀$ swaps $p$ and $q$.
    have h_swap_pq : σ₀.val p = q ∧ σ₀.val q = p := by
      grind;
    apply case_double_transposition_main hn H hσH hab (by
    grind) (by
    grind) (by
    tauto) (by
    grind) (by
    grind) hσa hσb h_swap_pq.left h_swap_pq.right

/-! ## Main theorem -/

/-
Any nontrivial normal subgroup of A_n (n ≥ 5) contains a 3-cycle.
-/
theorem normal_subgroup_contains_three_cycle
    {n : ℕ} (hn : 5 ≤ n)
    (H : Subgroup (alternatingGroup (Fin n)))
    [hN : H.Normal]
    (hH : ∃ σ : alternatingGroup (Fin n), σ ∈ H ∧ σ ≠ 1) :
    ∃ σ : alternatingGroup (Fin n), σ ∈ H ∧ (σ : Perm (Fin n)).IsThreeCycle := by
  obtain ⟨σ₀, hσH, hσ_ne⟩ : ∃ σ₀ ∈ H, (σ₀ : Equiv.Perm (Fin n)) ≠ 1 := by
    aesop;
  -- Set b = σ₀.val a, � c� = σ₀.val b. a ≠ b since σ₀.val a ≠ a.
  obtain ⟨a, ha⟩ : ∃ a : Fin n, σ₀.val a ≠ a := by
    exact not_forall.mp fun h => hσ_ne <| Equiv.Perm.ext h
  set b := σ₀.val a
  have hab : a ≠ b := by
    exact Ne.symm ha
  set c := σ₀.val b
  have hbc : b ≠ c := by
    exact fun h => ha <| σ₀.1.injective <| by aesop;
  by_cases hac : a = c;
  · exact?;
  · -- Set d = σ₀.val c.
    set d := σ₀.val c;
    by_cases had : d = a ∨ d = b ∨ d = c;
    · rcases had with ( had | had | had );
      · convert case_three_cycle_main H hσH _ _ _ _ _ _ _ using 1;
        exact fun h => hσ_ne <| h.symm ▸ rfl;
        exact a;
        exact b;
        exact c;
        all_goals tauto;
      · have := σ₀.1.injective had; aesop;
      · have := σ₀.val.injective ( by aesop : ( σ₀ : Equiv.Perm ( Fin n ) ) c = ( σ₀ : Equiv.Perm ( Fin n ) ) b ) ; aesop;
    · exact three_cycle_from_long_cycle H hσH hab hac ( by tauto ) hbc ( by tauto ) ( by tauto ) rfl rfl rfl

/-- The alternating group Aₙ is simple for n ≥ 5. -/
theorem alternatingGroup_isSimpleGroup' (n : ℕ) (hn : 5 ≤ n) :
    IsSimpleGroup (alternatingGroup (Fin n)) := by
  have : Nontrivial (alternatingGroup (Fin n)) :=
    alternatingGroup.nontrivial_of_three_le_card (by rw [Fintype.card_fin]; omega)
  exact IsSimpleGroup.mk fun H hHnormal => by
    by_cases hbot : H = ⊥
    · exact Or.inl hbot
    · right
      have hH : ∃ σ : alternatingGroup (Fin n), σ ∈ H ∧ σ ≠ 1 := by
        rw [Subgroup.eq_bot_iff_forall] at hbot; push_neg at hbot; exact hbot
      obtain ⟨σ, hσH, hσ3⟩ := normal_subgroup_contains_three_cycle hn H hH
      have := hσ3.alternating_normalClosure (by rw [Fintype.card_fin]; exact hn)
      rw [eq_top_iff]
      calc ⊤ = normalClosure ({σ} : Set (alternatingGroup (Fin n))) := this.symm
        _ ≤ H := normalClosure_le_normal (Set.singleton_subset_iff.mpr hσH)