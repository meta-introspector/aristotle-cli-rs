import RequestProject.ProofTheory.SequentCalculus

/-!
# Completeness of Cut-Free LK (the semantic route to cut elimination)

This file proves **completeness of the cut-free sequent calculus**:

  `LKCutFree.complete : s.IsValid → LKCutFree s`

Together with soundness (`LKCutFree.sound`, `LK.sound`) and the semantic cut
lemma, this provides the *semantic route* to Gentzen's Hauptsatz: every cut is
admissible because its conclusion is valid, hence cut-free provable.

The development proceeds:
1. Structural "move" lemmas (`extractR/insertR/extractL/insertL`): bring a chosen
   formula to the head of the antecedent/succedent, and the inverse.
2. Identity-with-context (`idAx`) and the membership axioms (`memBoth`, `falsumMem`).
3. Contraction of duplicated context (`contractL_dup`, `contractR_dup`).
4. Invertible / context-sharing logical rules derived from the multiplicative and
   additive primitives (`conjL_mult`, `disjR_mult`, `impL_share`, `conjR_share`,
   `disjL_share`).
5. The base case for atomic sequents (`atomic_valid_axiom`).
6. The main completeness theorem by strong induction on a size measure.
-/

set_option maxHeartbeats 1600000

namespace PropForm

variable {V : Type*}

/-! ## Size measure -/

/-- Size of a formula (atoms have size 1). -/
def cfSize : PropForm V → ℕ
  | var _ => 1
  | falsum => 1
  | imp A B => 1 + cfSize A + cfSize B
  | conj A B => 1 + cfSize A + cfSize B
  | disj A B => 1 + cfSize A + cfSize B

/-- Total size of a list of formulas. -/
def cfLSize : List (PropForm V) → ℕ
  | [] => 0
  | A :: rest => cfSize A + cfLSize rest

/-- The measure of a sequent: total size of both sides. -/
def cfMeasure (s : Sequent V) : ℕ := cfLSize s.ant + cfLSize s.suc

theorem cfLSize_append (l₁ l₂ : List (PropForm V)) :
    cfLSize (l₁ ++ l₂) = cfLSize l₁ + cfLSize l₂ := by
  induction l₁ with
  | nil => simp [cfLSize]
  | cons A l ih => simp [cfLSize, ih]; ring

/-! ## Structural move lemmas -/

/-
Move a formula located after a prefix `Δ₁` (in the succedent) to the head.
-/
theorem LKCutFree.extractR (Γ Δ₂ : List (PropForm V)) (A : PropForm V) :
    ∀ Δ₁, @LKCutFree V ⟨Γ, Δ₁ ++ A :: Δ₂⟩ → @LKCutFree V ⟨Γ, A :: (Δ₁ ++ Δ₂)⟩ := by
  intro Δ₁ h;
  -- Apply the induction hypothesis to the prefix `Pre ++ [C]`.
  have ih : ∀ (Pre : List (PropForm V)) (Δ₁ : List (PropForm V)), LKCutFree ⟨Γ, Pre ++ Δ₁ ++ A :: Δ₂⟩ → LKCutFree ⟨Γ, Pre ++ A :: (Δ₁ ++ Δ₂)⟩ := by
    intro Pre Δ₁ h;
    induction' Δ₁ with C Δ₁ ih generalizing Pre;
    · simpa using h;
    · convert LKCutFree.exchR C A _ using 1;
      convert ih ( Pre ++ [ C ] ) _ using 1;
      · simp +decide [ List.append_assoc ];
      · simpa using h;
  simpa using ih [ ] Δ₁ h

/-
Inverse of `extractR`: move the head of the succedent to a deeper position.
-/
theorem LKCutFree.insertR (Γ Δ₂ : List (PropForm V)) (A : PropForm V) :
    ∀ Δ₁, @LKCutFree V ⟨Γ, A :: (Δ₁ ++ Δ₂)⟩ → @LKCutFree V ⟨Γ, Δ₁ ++ A :: Δ₂⟩ := by
  intro Δ₁ h;
  have h_ind : ∀ (Pre Δ₁ : List (PropForm V)), @LKCutFree V ⟨Γ, Pre ++ A :: (Δ₁ ++ Δ₂)⟩ → @LKCutFree V ⟨Γ, Pre ++ Δ₁ ++ A :: Δ₂⟩ := by
    intro Pre Δ₁ h
    induction' Δ₁ with C Δ₁ ih generalizing Pre;
    · simpa using h;
    · -- Apply the exchange rule to swap A and C.
      have h_exch : LKCutFree ⟨Γ, Pre ++ C :: A :: (Δ₁ ++ Δ₂)⟩ := by
        convert LKCutFree.exchR _ _ _ using 1;
        simpa using h;
      grind +suggestions;
  simpa using h_ind [] Δ₁ h

/-
Move a formula located after a prefix `Γ₁` (in the antecedent) to the head.
-/
theorem LKCutFree.extractL (Δ Γ₂ : List (PropForm V)) (A : PropForm V) :
    ∀ Γ₁, @LKCutFree V ⟨Γ₁ ++ A :: Γ₂, Δ⟩ → @LKCutFree V ⟨A :: (Γ₁ ++ Γ₂), Δ⟩ := by
  intro Γ₁ h;
  have h_ind : ∀ (Pre Γ' : List (PropForm V)), LKCutFree ⟨Pre ++ Γ' ++ A :: Γ₂, Δ⟩ → LKCutFree ⟨Pre ++ A :: (Γ' ++ Γ₂), Δ⟩ := by
    intro Pre Γ' h_ind
    induction' Γ' with C Γ' ih generalizing Pre;
    · grind +qlia;
    · have h_ind_step : LKCutFree ⟨Pre ++ C :: A :: (Γ' ++ Γ₂), Δ⟩ := by
        convert ih ( Pre ++ [ C ] ) _ using 1;
        · simp +decide [ List.append_assoc ];
        · simpa using h_ind;
      convert LKCutFree.exchL C A _ using 1;
      exact h_ind_step;
  simpa using h_ind [] Γ₁ h

/-
Inverse of `extractL`.
-/
theorem LKCutFree.insertL (Δ Γ₂ : List (PropForm V)) (A : PropForm V) :
    ∀ Γ₁, @LKCutFree V ⟨A :: (Γ₁ ++ Γ₂), Δ⟩ → @LKCutFree V ⟨Γ₁ ++ A :: Γ₂, Δ⟩ := by
  intro Γ₁ h;
  have h_aux : ∀ (Pre Γ₁ : List (PropForm V)), LKCutFree ⟨Pre ++ A :: (Γ₁ ++ Γ₂), Δ⟩ → LKCutFree ⟨Pre ++ Γ₁ ++ A :: Γ₂, Δ⟩ := by
    intro Pre Γ₁ h
    induction' Γ₁ with C Γ₁ ih generalizing Pre;
    · grind;
    · convert ih ( Pre ++ [ C ] ) _ using 1;
      · simp +decide [ List.append_assoc ];
      · convert LKCutFree.exchL A C _ using 1;
        rotate_left;
        exacts [ Pre, Γ₁ ++ Γ₂, Δ, by simpa [ List.append_assoc ] using h, by simp +decide [ List.append_assoc ] ];
  simpa using h_aux [] Γ₁ h

/-! ## Identity and membership axioms -/

/-
Identity axiom with arbitrary context: `A, Γ ⊢ A, Δ`.
-/
theorem LKCutFree.idAx (A : PropForm V) (Γ Δ : List (PropForm V)) :
    @LKCutFree V ⟨A :: Γ, A :: Δ⟩ := by
  induction' Γ with B Γ ih generalizing Δ;
  · induction' Δ with B Δ ih generalizing A;
    · exact LKCutFree.ax A;
    · -- Apply the weakR rule to get LKCutFree ⟨[A], B :: A :: Δ⟩.
      have h_weakR : LKCutFree ⟨[A], B :: A :: Δ⟩ := by
        exact LKCutFree.weakR B ( ih A );
      convert LKCutFree.exchR B A _ using 1;
      rotate_left;
      exacts [ [ A ], [ ], Δ, h_weakR, rfl ];
  · -- Apply the exchange rule to swap B and A in the antecedent.
    have h_exchL : LKCutFree ⟨B :: A :: Γ, A :: Δ⟩ := by
      exact LKCutFree.weakL B ( ih Δ );
    convert LKCutFree.exchL B A _ using 1;
    rotate_left;
    exacts [ [ ], Γ, A :: Δ, by simpa using h_exchL, by simp +decide ]

/-
If a formula occurs in both antecedent and succedent, the sequent is provable.
-/
theorem LKCutFree.memBoth {Γ Δ : List (PropForm V)} {A : PropForm V}
    (hΓ : A ∈ Γ) (hΔ : A ∈ Δ) : @LKCutFree V ⟨Γ, Δ⟩ := by
  obtain ⟨Γ₁, Γ₂, hΓ⟩ : ∃ Γ₁ Γ₂, Γ = Γ₁ ++ A :: Γ₂ := by
    exact?
  obtain ⟨Δ₁, Δ₂, hΔ⟩ : ∃ Δ₁ Δ₂, Δ = Δ₁ ++ A :: Δ₂ := by
    exact?;
  grind +suggestions

/-
If falsum occurs in the antecedent, the sequent is provable.
-/
theorem LKCutFree.falsumMem {Γ Δ : List (PropForm V)} (h : PropForm.falsum ∈ Γ) :
    @LKCutFree V ⟨Γ, Δ⟩ := by
  obtain ⟨Γ₁, Γ₂, hΓ⟩ : ∃ Γ₁ Γ₂, Γ = Γ₁ ++ [falsum] ++ Γ₂ := by
    rcases List.mem_iff_get.1 h with ⟨ i, hi ⟩ ; use List.take i Γ, List.drop ( i + 1 ) Γ ; simp +decide [ hi ];
    simp +decide [ ← hi, List.take_append_drop ];
  simp_all +decide [ LKCutFree.falsumL ];
  convert LKCutFree.insertL Δ Γ₂ ( falsum ) Γ₁ ( LKCutFree.falsumL ( Γ₁ ++ Γ₂ ) Δ ) using 1

/-! ## Contraction of duplicated context -/

/-
Remove a duplicated single occurrence in the antecedent (head copy kept),
with an untouched prefix `Pre`.
-/
theorem LKCutFree.contrL_dedup (Δ Γ₁ Γ₂ : List (PropForm V)) (A : PropForm V) :
    ∀ Pre, @LKCutFree V ⟨Pre ++ A :: Γ₁ ++ A :: Γ₂, Δ⟩ →
      @LKCutFree V ⟨Pre ++ A :: Γ₁ ++ Γ₂, Δ⟩ := by
  intro Pre h;
  -- Apply `LKCutFree.extractL Δ Γ₂ A (Pre ++ A :: Γ₁)` to the hypothesis to bring the SECOND `A` to the absolute head.
  have h1 : @LKCutFree V ⟨A :: (Pre ++ A :: (Γ₁ ++ Γ₂)), Δ⟩ := by
    grind +suggestions;
  -- Apply `LKCutFree.extractL Δ (Γ₁ ++ Γ₂) A (A :: Pre)` to get `LKCutFree ⟨A :: (A :: Pre ++ (Γ₁ ++ Γ₂)), Δ⟩`.
  have h2 : @LKCutFree V ⟨A :: (A :: (Pre ++ (Γ₁ ++ Γ₂))), Δ⟩ := by
    convert LKCutFree.extractL Δ ( Γ₁ ++ Γ₂ ) A ( A :: Pre ) _ using 1;
    convert h1 using 1;
  convert LKCutFree.insertL Δ ( Γ₁ ++ Γ₂ ) A Pre ( LKCutFree.contrL A h2 ) using 1;
  simp +decide [ List.append_assoc ]

/-
Remove a duplicated single occurrence in the succedent (head copy kept),
with an untouched prefix `Pre`.
-/
theorem LKCutFree.contrR_dedup (Γ Δ₁ Δ₂ : List (PropForm V)) (A : PropForm V) :
    ∀ Pre, @LKCutFree V ⟨Γ, Pre ++ A :: Δ₁ ++ A :: Δ₂⟩ →
      @LKCutFree V ⟨Γ, Pre ++ A :: Δ₁ ++ Δ₂⟩ := by
  intro Pre h;
  -- Apply `extractR` to bring the second `A` to the head of the succedent.
  have h1 : LKCutFree ⟨Γ, A :: (Pre ++ A :: Δ₁ ++ Δ₂)⟩ := by
    convert LKCutFree.extractR Γ Δ₂ A ( Pre ++ A :: Δ₁ ) h using 1;
  have h2 : LKCutFree ⟨Γ, A :: A :: (Pre ++ Δ₁ ++ Δ₂)⟩ := by
    convert LKCutFree.extractR Γ ( Δ₁ ++ Δ₂ ) A ( A :: Pre ) _ using 1;
    · simp +decide [ List.append_assoc ];
    · simpa [ List.append_assoc ] using h1;
  convert LKCutFree.insertR Γ ( Δ₁ ++ Δ₂ ) A Pre _ using 1;
  · simp +decide [ List.append_assoc ];
  · convert LKCutFree.contrR A h2 using 1;
    simp +decide [ List.append_assoc ]

/-
Contract a duplicated block in the antecedent (with an untouched prefix).
-/
theorem LKCutFree.contractL_dup (Δ : List (PropForm V)) :
    ∀ (Pre Γ : List (PropForm V)), @LKCutFree V ⟨Pre ++ (Γ ++ Γ), Δ⟩ →
      @LKCutFree V ⟨Pre ++ Γ, Δ⟩ := by
  intro Pre Γ h;
  -- We proceed by induction on the length of `Γ`.
  induction' Γ with A Γ' ih generalizing Pre;
  · aesop;
  · grind +suggestions

/-
Contract a duplicated block in the succedent (with an untouched prefix).
-/
theorem LKCutFree.contractR_dup (Γ : List (PropForm V)) :
    ∀ (Pre Δ : List (PropForm V)), @LKCutFree V ⟨Γ, Pre ++ (Δ ++ Δ)⟩ →
      @LKCutFree V ⟨Γ, Pre ++ Δ⟩ := by
  intro Pre Δ h;
  induction' Δ with A Δ ih generalizing Pre;
  · aesop;
  · convert ih ( Pre ++ [ A ] ) _ using 1;
    · simp +decide [ List.append_assoc ];
    · convert LKCutFree.contrR_dedup Γ Δ Δ A Pre _ using 1;
      · simp +decide [ List.append_assoc ];
      · simpa only [ List.append_assoc ] using h

/-! ## Derived invertible / context-sharing logical rules -/

/-
Multiplicative conjunction-left: from `A, B, Γ ⊢ Δ` derive `A ∧ B, Γ ⊢ Δ`.
-/
theorem LKCutFree.conjL_mult {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : @LKCutFree V ⟨A :: B :: Γ, Δ⟩) : @LKCutFree V ⟨conj A B :: Γ, Δ⟩ := by
  have h1 : LKCutFree ⟨conj A B :: B :: Γ, Δ⟩ := by
    apply LKCutFree.conjL1 h
  have h2 : LKCutFree ⟨B :: conj A B :: Γ, Δ⟩ := by
    convert LKCutFree.exchL ( A.conj B ) B _ using 1;
    rotate_left;
    exacts [ [ ], Γ, Δ, h1, rfl ]
  have h3 : LKCutFree ⟨conj A B :: conj A B :: Γ, Δ⟩ := by
    apply LKCutFree.conjL2 h2
  have h4 : LKCutFree ⟨conj A B :: Γ, Δ⟩ := by
    exact?
  exact h4

/-
Multiplicative disjunction-right: from `Γ ⊢ A, B, Δ` derive `Γ ⊢ A ∨ B, Δ`.
-/
theorem LKCutFree.disjR_mult {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : @LKCutFree V ⟨Γ, A :: B :: Δ⟩) : @LKCutFree V ⟨Γ, disj A B :: Δ⟩ := by
  contrapose! h;
  intro H;
  apply h;
  convert LKCutFree.contrR ( A.disj B ) _ using 1;
  convert LKCutFree.disjR2 _ using 1;
  convert LKCutFree.exchR ( Δ := [] ) ( A.disj B ) B _ using 1;
  convert LKCutFree.disjR1 _ using 1;
  exact H

/-
Context-sharing implication-left.
-/
theorem LKCutFree.impL_share {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h1 : @LKCutFree V ⟨Γ, A :: Δ⟩) (h2 : @LKCutFree V ⟨B :: Γ, Δ⟩) :
    @LKCutFree V ⟨imp A B :: Γ, Δ⟩ := by
  convert @LKCutFree.contractR_dup V ( A.imp B :: Γ ) [ ] Δ _ using 1;
  convert @LKCutFree.contractL_dup V ( Δ ++ Δ ) [ A.imp B ] Γ _ using 1;
  convert LKCutFree.impL h1 h2 using 1

/-
Context-sharing conjunction-right.
-/
theorem LKCutFree.conjR_share {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h1 : @LKCutFree V ⟨Γ, A :: Δ⟩) (h2 : @LKCutFree V ⟨Γ, B :: Δ⟩) :
    @LKCutFree V ⟨Γ, conj A B :: Δ⟩ := by
  contrapose! h1;
  intro h;
  -- Apply the conjunction right rule to h and h2.
  have h_conj : LKCutFree ⟨Γ ++ Γ, conj A B :: Δ ++ Δ⟩ := by
    apply LKCutFree.conjR h h2;
  -- Apply the contraction rule to the antecedent.
  have h_contra_ant : LKCutFree ⟨Γ, conj A B :: Δ ++ Δ⟩ := by
    convert LKCutFree.contractL_dup ( A.conj B :: Δ ++ Δ ) [] Γ h_conj using 1;
  exact h1 ( LKCutFree.contractR_dup Γ [ A.conj B ] Δ h_contra_ant )

/-
Context-sharing disjunction-left.
-/
theorem LKCutFree.disjL_share {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h1 : @LKCutFree V ⟨A :: Γ, Δ⟩) (h2 : @LKCutFree V ⟨B :: Γ, Δ⟩) :
    @LKCutFree V ⟨disj A B :: Γ, Δ⟩ := by
  have h3 : @LKCutFree V ⟨disj A B :: Γ ++ Γ, Δ ++ Δ⟩ := by
    exact LKCutFree.disjL h1 h2;
  have h4 : @LKCutFree V ⟨disj A B :: Γ, Δ ++ Δ⟩ := by
    convert LKCutFree.contractL_dup ( Δ ++ Δ ) [ A.disj B ] Γ h3 using 1;
  convert LKCutFree.contractR_dup ( A.disj B :: Γ ) [] Δ h4 using 1

/-! ## Base case: atomic valid sequents are axioms -/

/-- An atom is a variable or falsum. -/
def IsAtom : PropForm V → Prop
  | var _ => True
  | falsum => True
  | _ => False

/-
A valid sequent whose formulas are all atomic must have falsum in the
antecedent, or a formula common to both sides.
-/
theorem atomic_valid_axiom (s : Sequent V)
    (hant : ∀ A ∈ s.ant, IsAtom A) (hsuc : ∀ A ∈ s.suc, IsAtom A)
    (hv : s.IsValid) :
    PropForm.falsum ∈ s.ant ∨ ∃ A, A ∈ s.ant ∧ A ∈ s.suc := by
  by_contra! h_contra;
  convert hv ( fun p => decide ( PropForm.var p ∈ s.ant ) ) _ using 1;
  all_goals norm_num [ PropForm.eval ];
  any_goals intros; exact Classical.dec _;
  · intro A hA; specialize hsuc A hA; rcases A with ( _ | _ | A ) <;> simp_all +decide [ PropForm.eval ] ;
    · exact fun h => h_contra.2 _ h hA;
    · cases hsuc;
    · cases hsuc;
    · cases hsuc;
  · intro A hA;
    cases h : A <;> simp_all +decide [ PropForm.IsAtom ];
    · exact if_pos ( by simpa using hA );
    · exact absurd ( hant _ hA ) ( by tauto );
    · exact absurd ( hant _ hA ) ( by tauto );
    · exact absurd ( hant _ hA ) ( by tauto )

/-! ## Semantic invertibility of the logical rules

Validity is preserved when passing from a sequent to the premises of the
corresponding (invertible / context-sharing) logical rule. All proofs are direct
computations on `eval`. -/

/-
Validity only depends on membership: reorder the succedent.
-/
theorem valid_permR {Γ : List (PropForm V)} (Δ₁ Δ₂ : List (PropForm V)) (C : PropForm V)
    (h : Sequent.IsValid ⟨Γ, Δ₁ ++ C :: Δ₂⟩) :
    Sequent.IsValid ⟨Γ, C :: (Δ₁ ++ Δ₂)⟩ := by
  intro v hv; specialize h v hv; aesop;

/-
Validity only depends on membership: reorder the antecedent.
-/
theorem valid_permL {Δ : List (PropForm V)} (Γ₁ Γ₂ : List (PropForm V)) (C : PropForm V)
    (h : Sequent.IsValid ⟨Γ₁ ++ C :: Γ₂, Δ⟩) :
    Sequent.IsValid ⟨C :: (Γ₁ ++ Γ₂), Δ⟩ := by
  intro v hv; simp_all +decide [ List.mem_append, List.mem_cons ] ;
  exact h v ( by aesop )

theorem valid_impR_inv {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨Γ, imp A B :: Δ⟩) : Sequent.IsValid ⟨A :: Γ, B :: Δ⟩ := by
  intro v hv;
  specialize h v;
  simp_all +decide [ PropForm.eval ]

theorem valid_conjR_inv1 {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨Γ, conj A B :: Δ⟩) : Sequent.IsValid ⟨Γ, A :: Δ⟩ := by
  intro v hv
  have h_conj : eval v (conj A B) = (eval v A && eval v B) := by
    rfl;
  specialize h v hv; aesop;

theorem valid_conjR_inv2 {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨Γ, conj A B :: Δ⟩) : Sequent.IsValid ⟨Γ, B :: Δ⟩ := by
  intro v hv; specialize h v; simp_all +decide [ PropForm.Sequent.IsValid ] ;
  cases h <;> simp_all +decide [ PropForm.eval ]

theorem valid_disjR_inv {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨Γ, disj A B :: Δ⟩) : Sequent.IsValid ⟨Γ, A :: B :: Δ⟩ := by
  intro v hv; specialize h v hv; simp_all +decide [ PropForm.eval ] ;
  grind

theorem valid_impL_inv1 {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨imp A B :: Γ, Δ⟩) : Sequent.IsValid ⟨Γ, A :: Δ⟩ := by
  intro v hv;
  by_cases hA : eval v A = true;
  · exact ⟨ A, by simp +decide, hA ⟩;
  · specialize h v ; simp_all +decide [ PropForm.eval ]

theorem valid_impL_inv2 {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨imp A B :: Γ, Δ⟩) : Sequent.IsValid ⟨B :: Γ, Δ⟩ := by
  intro v hv; specialize h v; simp_all +decide [ PropForm.eval ] ;

theorem valid_conjL_inv {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨conj A B :: Γ, Δ⟩) : Sequent.IsValid ⟨A :: B :: Γ, Δ⟩ := by
  intro v hv; specialize h v; simp_all +decide [ PropForm.Sequent.IsValid ] ;
  exact h ( by rw [ show eval v ( A.conj B ) = ( eval v A && eval v B ) by rfl ] ; simp +decide [ hv ] )

theorem valid_disjL_inv1 {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨disj A B :: Γ, Δ⟩) : Sequent.IsValid ⟨A :: Γ, Δ⟩ := by
  intro v hv;
  specialize h v;
  simp_all +decide [ PropForm.eval ]

theorem valid_disjL_inv2 {A B : PropForm V} {Γ Δ : List (PropForm V)}
    (h : Sequent.IsValid ⟨disj A B :: Γ, Δ⟩) : Sequent.IsValid ⟨B :: Γ, Δ⟩ := by
  intro v hv;
  convert h v _;
  simp_all +decide [ PropForm.eval ]

/-! ## Completeness -/

/-
One inductive step: a valid sequent whose succedent head `C` is a compound
formula is cut-free provable, given the strong induction hypothesis `ih`.
-/
theorem LKCutFree.complete_suc_step (n : ℕ)
    (ih : ∀ m, m < n → ∀ t : Sequent V, cfMeasure t = m → t.IsValid → @LKCutFree V t)
    {Γ R : List (PropForm V)} {C : PropForm V}
    (hcomp : ¬ IsAtom C)
    (hmeas : cfMeasure ⟨Γ, C :: R⟩ = n)
    (hv : Sequent.IsValid ⟨Γ, C :: R⟩) :
    @LKCutFree V ⟨Γ, C :: R⟩ := by
  rcases C with ( _ | _ | A | A | A ) <;> simp +decide [ IsAtom ] at hcomp ⊢;
  · apply LKCutFree.impR;
    apply ih (cfLSize (A :: Γ) + cfLSize (‹_› :: R));
    · simp +decide [ ← hmeas, cfMeasure, cfLSize, cfSize ];
      linarith;
    · rfl;
    · convert valid_impR_inv hv using 1;
  · apply LKCutFree.conjR_share;
    · apply ih (cfMeasure ⟨Γ, A :: R⟩) (by
      simp +decide [ ← hmeas, cfMeasure, cfLSize, cfSize ];
      linarith) ⟨Γ, A :: R⟩ rfl (valid_conjR_inv1 hv);
    · apply ih (cfMeasure ⟨Γ, ‹_› :: R⟩);
      · simp +decide [ ← hmeas, cfMeasure, cfLSize, cfSize ];
      · rfl;
      · apply valid_conjR_inv2 hv;
  · apply LKCutFree.disjR_mult;
    convert ih _ _ _ rfl ( valid_disjR_inv hv ) using 1;
    simp +decide [ ← hmeas, cfMeasure, cfLSize ];
    simp +decide [ cfSize ] ; omega

/-
One inductive step: a valid sequent whose antecedent head `C` is a compound
formula is cut-free provable, given the strong induction hypothesis `ih`.
-/
theorem LKCutFree.complete_ant_step (n : ℕ)
    (ih : ∀ m, m < n → ∀ t : Sequent V, cfMeasure t = m → t.IsValid → @LKCutFree V t)
    {L Δ : List (PropForm V)} {C : PropForm V}
    (hcomp : ¬ IsAtom C)
    (hmeas : cfMeasure ⟨C :: L, Δ⟩ = n)
    (hv : Sequent.IsValid ⟨C :: L, Δ⟩) :
    @LKCutFree V ⟨C :: L, Δ⟩ := by
  obtain ⟨A, B, hC⟩ : ∃ A B, C = imp A B ∨ C = conj A B ∨ C = disj A B := by
    cases C <;> simp_all +decide [ IsAtom ];
  rcases hC with ( rfl | rfl | rfl ) <;> simp_all +decide [ cfMeasure, cfLSize ];
  · apply LKCutFree.impL_share;
    · apply ih (cfLSize L + cfLSize Δ + cfSize A);
      · simp +arith +decide [ ← hmeas, PropForm.cfSize ];
      · simp +decide [ add_comm, add_left_comm, add_assoc, cfLSize ];
      · convert valid_impL_inv1 hv using 1;
    · apply ih (cfLSize L + cfLSize Δ + B.cfSize) (by
      simp +arith +decide [ ← hmeas, PropForm.cfSize ]) ⟨B :: L, Δ⟩ (by
      simp +decide [ cfLSize, add_comm, add_left_comm, add_assoc ]) (valid_impL_inv2 hv);
  · apply LKCutFree.conjL_mult;
    apply ih (cfLSize (A :: B :: L) + cfLSize Δ);
    · simp +arith +decide [ ← hmeas, cfSize ];
      simp +arith +decide [ cfLSize ];
    · rfl;
    · convert valid_conjL_inv hv using 1;
  · apply LKCutFree.disjL_share;
    · apply ih (cfLSize (A :: L) + cfLSize Δ);
      · simp_all +decide [ cfSize, cfLSize ];
        linarith;
      · rfl;
      · convert valid_disjL_inv1 hv using 1;
    · apply ih (cfLSize (B :: L) + cfLSize Δ);
      · simp +arith +decide [ ← hmeas, cfSize ];
        simp +arith +decide [ cfLSize ];
      · rfl;
      · convert valid_disjL_inv2 hv using 1

/-
**Completeness of cut-free LK** (numeric version): every valid sequent whose
measure is `n` is cut-free provable.
-/
theorem LKCutFree.complete_aux :
    ∀ (n : ℕ) (s : Sequent V), cfMeasure s = n → s.IsValid → @LKCutFree V s := by
  intro n s hs hv;
  induction' n using Nat.strong_induction_on with n ih generalizing s;
  obtain ⟨Γ, Δ⟩ := s;
  by_cases hsucC : ∃ C ∈ Δ, ¬ IsAtom C;
  · obtain ⟨ C, hC₁, hC₂ ⟩ := hsucC;
    obtain ⟨ Δ₁, Δ₂, rfl ⟩ := List.append_of_mem hC₁;
    convert LKCutFree.insertR Γ Δ₂ C Δ₁ _ using 1;
    apply LKCutFree.complete_suc_step n ih hC₂;
    · simp_all +decide [ cfMeasure, cfLSize_append ];
      convert hs using 1;
      simp +decide [ cfLSize, cfLSize_append ];
      ring;
    · exact valid_permR Δ₁ Δ₂ C hv;
  · by_cases hantC : ∃ C ∈ Γ, ¬ IsAtom C;
    · obtain ⟨ C, hC₁, hC₂ ⟩ := hantC;
      obtain ⟨ Γ₁, Γ₂, rfl ⟩ := List.append_of_mem hC₁;
      convert LKCutFree.insertL Δ Γ₂ C Γ₁ _ using 1;
      apply LKCutFree.complete_ant_step n ih hC₂;
      · simp_all +decide [ cfMeasure, cfLSize_append ];
        simp_all +decide [ cfLSize ];
        rw [ ← hs, cfLSize_append ] ; ring;
      · convert valid_permL Γ₁ Γ₂ C hv using 1;
    · have := atomic_valid_axiom ⟨Γ, Δ⟩ (by push_neg at hantC; exact hantC) (by push_neg at hsucC; exact hsucC) hv;
      exact this.elim ( fun h => LKCutFree.falsumMem h ) fun ⟨ A, hA₁, hA₂ ⟩ => LKCutFree.memBoth hA₁ hA₂

/-- **Completeness of cut-free LK**: every valid sequent is cut-free provable. -/
theorem LKCutFree.complete (s : Sequent V) (hv : s.IsValid) : @LKCutFree V s :=
  LKCutFree.complete_aux (cfMeasure s) s rfl hv

end PropForm