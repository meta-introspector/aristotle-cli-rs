import Mathlib
import RequestProject.ShapeAlgebra

/-!
# Shape Finder — similarity, structural isomorphism, and the renaming theorem

This module bridges the **heuristic rolling-hash analyzer** to the **formal
Clifford backbone** (`RequestProject.ShapeAlgebra`).

* `canonCode` is the canonical, label-erased, permutation-invariant fingerprint of
  a shape (the idealized `∞`-gram of the rolling-hash profile).  `canonCodeN n` is
  its depth-`n` truncation — the honest model of an `n`-gram profile (e.g. the
  `71`-gram window).  `similar` / `similarUpTo n` compare these fingerprints.

* `Renamed ρ` / `StructIso` is the formal inductive relation for **structural
  isomorphism under α-renaming + permutation of independent subtrees**:
  `t₁` and `t₂` are structurally isomorphic when there is an *injective* relabelling
  `ρ` of constants/variables and a permutation of each node's children turning one
  tree into the other.

The main results:

* **Conservative-approximation theorem** `structIso_imp_similarUpTo`:
  `StructIso t₁ t₂ → similarUpTo n t₁ t₂` for every window `n` (and the full
  `structIso_imp_similar`).  Genuine structural isomorphism is always detected.

* **Clifford secondary filter** `clifford_filter`:
  `classify t₁ ≠ classify t₂ → ¬ StructIso t₁ t₂`.  Any rolling-hash collision that
  survives a Clifford-trace mismatch is a provable false positive.

* **Leakage of the converse** `converse_leaks`: a concrete pair of trees that are
  `similar` (even `similarUpTo 71`) yet **not** `StructIso`.  The precise leak is
  *label collision*: the fingerprint erases labels, so it identifies trees whose
  required renaming fails to be injective.

* **Restricted true converse** `similar_imp_structIso_of_uniform`: on the class of
  trees whose labels carry no information (uniformly labelled), similarity *does*
  imply a structure-preserving renaming — the precise regime where the heuristic is
  exact.

Everything is `sorry`-free.
-/

namespace ShapeFinder

open ShapeAlgebra

/-! ## Canonical fingerprints (the rolling-hash profile, idealized) -/

/-- Encode a sorted list of child-codes into a single natural number.  `[]` maps to
`0`; a nonempty list maps to `Nat.pair head tail + 1`.  This is injective, so the
encoding loses no information beyond the chosen child order. -/
def encodeCodes : List Nat → Nat
  | [] => 0
  | a :: as => Nat.pair a (encodeCodes as) + 1

/-- The canonical, **label-erased, permutation-invariant** fingerprint of a shape:
recursively encode the *sorted multiset* of children fingerprints.  This is the
idealized (unbounded-window) rolling-hash profile. -/
def canonCode : Shape → Nat
  | .mk _ cs => encodeCodes ((cs.map canonCode).mergeSort (· ≤ ·))

/-- The depth-`n` truncation of `canonCode` — the honest model of an `n`-gram
profile.  Beyond depth `n` the structure is forgotten. -/
def canonCodeN : Nat → Shape → Nat
  | 0, _ => 0
  | (n+1), .mk _ cs => encodeCodes ((cs.map (canonCodeN n)).mergeSort (· ≤ ·))

/-- Two shapes are **similar** when their canonical fingerprints agree. -/
def similar (t1 t2 : Shape) : Prop := canonCode t1 = canonCode t2

/-- Two shapes are **`n`-gram similar** when their depth-`n` fingerprints agree. -/
def similarUpTo (n : Nat) (t1 t2 : Shape) : Prop := canonCodeN n t1 = canonCodeN n t2

/-! ## Structural isomorphism under α-renaming + subtree permutation -/

/-- `Renamed ρ t₁ t₂`: `t₂` is obtained from `t₁` by applying the relabelling `ρ`
to every node label and permuting the children at each node.  This is the
"structure-preserving renaming + permutation of independent subtrees" relation. -/
inductive Renamed (ρ : Nat → Nat) : Shape → Shape → Prop where
  | node {l : Nat} {cs ds ds' : List Shape} :
      List.Forall₂ (Renamed ρ) cs ds → ds.Perm ds' →
      Renamed ρ (Shape.mk l cs) (Shape.mk (ρ l) ds')

/-- **Structural isomorphism**: there is an injective relabelling `ρ` and a
permutation of independent subtrees identifying the two shapes. -/
def StructIso (t1 t2 : Shape) : Prop :=
  ∃ ρ : Nat → Nat, Function.Injective ρ ∧ Renamed ρ t1 t2

/-- `Renamed id` is reflexive. -/
theorem Renamed.refl (t : Shape) : Renamed id t t := by
  have h_reflexive : ∀ (cs : List Shape), List.Forall₂ (fun t1 t2 => Renamed id t1 t2) cs cs := by
    intro cs; induction cs <;> simp_all +decide ;
    induction' ‹Shape› using Shape.rec with l cs ih;
    exact Renamed.node ih ( List.Perm.refl _ );
    · constructor;
    · exact List.Forall₂.cons ‹_› ‹_›;
  cases t ; exact Renamed.node ( h_reflexive _ ) ( List.Perm.refl _ )

/-- Structural isomorphism is reflexive (take `ρ = id`). -/
theorem StructIso.refl (t : Shape) : StructIso t t :=
  ⟨id, Function.injective_id, Renamed.refl t⟩

/-! ## A sorting helper -/

/-- Permuted `Nat` lists have equal `mergeSort`s. -/
theorem mergeSort_eq_of_perm {l1 l2 : List Nat} (h : l1.Perm l2) :
    l1.mergeSort (· ≤ ·) = l2.mergeSort (· ≤ ·) := by
  apply List.Perm.eq_of_pairwise;
  case le => exact fun x y => x ≤ y;
  · exact fun a b ha hb hab hba => le_antisymm hab hba;
  · exact List.pairwise_mergeSort' (fun x y => x ≤ y) l1;
  · exact List.pairwise_mergeSort' (fun x y => x ≤ y) l2;
  · exact List.Perm.trans ( List.mergeSort_perm _ _ ) ( h.trans ( List.mergeSort_perm _ _ |> List.Perm.symm ) )

/-! ## Conservative-approximation theorem (soundness of the heuristic) -/

/-
A `Renamed` pair has equal canonical fingerprints: relabelling is erased and
the child permutation is absorbed by sorting.
-/
theorem Renamed.canonCode_eq {ρ : Nat → Nat} {t1 t2 : Shape}
    (h : Renamed ρ t1 t2) : canonCode t1 = canonCode t2 := by
  revert t1 t2 h;
  -- We'll use induction on the structure of the shapes to prove that the canonical codes are equal.
  have h_ind : ∀ t1 t2 : Shape, Renamed ρ t1 t2 → ∀ n, canonCodeN n t1 = canonCodeN n t2 := by
    intros t1 t2 h_renamed n
    induction' n with n ih generalizing t1 t2;
    · cases t1 ; cases t2 ; aesop;
    · rcases t1 with ⟨ l1, cs1 ⟩ ; rcases t2 with ⟨ l2, cs2 ⟩ ; simp_all +decide [ canonCodeN ];
      obtain ⟨ hcd, hp ⟩ := h_renamed;
      have h_map : List.map (canonCodeN n) cs1 = List.map (canonCodeN n) ‹_› := by
        have h_map : ∀ {l1 l2 : List Shape}, List.Forall₂ (Renamed ρ) l1 l2 → List.map (canonCodeN n) l1 = List.map (canonCodeN n) l2 := by
          intros l1 l2 h; induction h <;> aesop;
        exact h_map hcd;
      rw [ h_map, mergeSort_eq_of_perm ];
      exact hp.map _;
  intro t1 t2 h;
  have h_size : ∀ t : Shape, ∀ n ≥ t.size, canonCodeN n t = canonCode t := by
    intros t n hn
    induction' n with n ih generalizing t;
    · cases t ; simp_all +decide [ Shape.size ];
    · rcases t with ⟨ l, cs ⟩;
      simp +decide [ Shape.size ] at hn ⊢;
      simp +decide [ canonCodeN, canonCode ];
      rw [ List.map_congr_left ];
      intro a ha; exact ih a (by
      have := List.le_sum_of_mem ( show a.size ∈ List.map Shape.size cs from List.mem_map.mpr ⟨ a, ha, rfl ⟩ ) ; linarith);
  rw [ ← h_size t1 ( Max.max t1.size t2.size ) ( le_max_left _ _ ), ← h_size t2 ( Max.max t1.size t2.size ) ( le_max_right _ _ ), h_ind t1 t2 h ]

/-
A `Renamed` pair has equal depth-`n` fingerprints, for every `n`.
-/
theorem Renamed.canonCodeN_eq {ρ : Nat → Nat} {t1 t2 : Shape}
    (h : Renamed ρ t1 t2) (n : Nat) : canonCodeN n t1 = canonCodeN n t2 := by
  -- We proceed by induction on $n$.
  induction' n with n ih generalizing t1 t2;
  · rfl;
  · obtain ⟨l, cs, hcs⟩ : ∃ l cs, t1 = Shape.mk l cs := by
      cases t1 ; tauto
    obtain ⟨l', cs', hcs'⟩ : ∃ l' cs', t2 = Shape.mk l' cs' := by
      cases t2 ; tauto
    simp [hcs, hcs', canonCodeN] at *;
    rcases h with ⟨ h₁, h₂ ⟩;
    have h_map : List.map (canonCodeN n) cs = List.map (canonCodeN n) ‹List Shape› := by
      have h_map : ∀ {l1 l2 : List Shape}, List.Forall₂ (Renamed ρ) l1 l2 → List.map (canonCodeN n) l1 = List.map (canonCodeN n) l2 := by
        intros l1 l2 h; induction h <;> aesop;
      grind;
    rw [ h_map, mergeSort_eq_of_perm ];
    exact h₂.map _

/-- **Conservative approximation.**  Structural isomorphism implies similarity:
the rolling-hash analyzer never misses a genuine structural isomorphism. -/
theorem structIso_imp_similar {t1 t2 : Shape} (h : StructIso t1 t2) :
    similar t1 t2 := by
  obtain ⟨ρ, _, hr⟩ := h
  exact hr.canonCode_eq

/-- **Conservative approximation for `n`-grams.**  Structural isomorphism implies
`n`-gram similarity for every window `n` (in particular for the `71`-gram
profile). -/
theorem structIso_imp_similarUpTo {t1 t2 : Shape} (n : Nat) (h : StructIso t1 t2) :
    similarUpTo n t1 t2 := by
  obtain ⟨ρ, _, hr⟩ := h
  exact hr.canonCodeN_eq n

/-- Specialization to the `71`-gram window used by the analyzer. -/
theorem structIso_imp_similar71 {t1 t2 : Shape} (h : StructIso t1 t2) :
    similarUpTo 71 t1 t2 :=
  structIso_imp_similarUpTo 71 h

/-! ## The Clifford secondary filter -/

/-
A `Renamed` pair has equal Clifford traces (the per-node norm depends only on
arity, which is preserved by relabelling and child permutation).
-/
theorem Renamed.cliffordTrace_eq {ρ : Nat → Nat} {t1 t2 : Shape}
    (h : Renamed ρ t1 t2) : cliffordTrace t1 = cliffordTrace t2 := by
  revert h;
  have h_ind : ∀ (t1 t2 : Shape), Renamed ρ t1 t2 → ∀ (n : ℕ), t1.size ≤ n → t2.size ≤ n → cliffordTrace t1 = cliffordTrace t2 := by
    intros t1 t2 h_renamed n ht1 ht2
    induction' n with n ih generalizing t1 t2;
    · cases t1 ; cases t2 ; simp_all +decide [ Shape.size ];
    · rcases t1 with ⟨ l1, cs1 ⟩ ; rcases t2 with ⟨ l2, cs2 ⟩ ; simp_all +decide [ Shape.size ];
      rcases h_renamed with ⟨ hcd, hp ⟩;
      have h_sum_eq : List.map cliffordTrace cs1 = List.map cliffordTrace ‹_› := by
        have h_sum_eq : ∀ (cs1 cs2 : List Shape), List.Forall₂ (Renamed ρ) cs1 cs2 → (∀ t ∈ cs1, t.size ≤ n) → (∀ t ∈ cs2, t.size ≤ n) → List.map cliffordTrace cs1 = List.map cliffordTrace cs2 := by
          intros cs1 cs2 hcd hcs1 hcs2; induction' hcd with cs1 cs2 hcd ih <;> simp_all +decide [ List.map ] ;
          grind;
        apply h_sum_eq cs1 _ hcd;
        · intro t ht; have := List.le_sum_of_mem ( show t.size ∈ List.map Shape.size cs1 from List.mem_map.mpr ⟨ t, ht, rfl ⟩ ) ; linarith;
        · intro t ht; have := hp.subset ht; simp_all +decide [ add_comm ] ;
          exact le_trans ( List.le_sum_of_mem ( by aesop ) ) ht2;
      have := hp.length_eq; simp_all +decide ;
      have h_len_eq : cs1.length = cs2.length := by
        have := List.Forall₂.length_eq hcd; aesop;
      rw [ ← h_sum_eq, ← hp.map _ |> List.Perm.sum_eq ] ; aesop;
  exact fun h => h_ind t1 t2 h ( Max.max t1.size t2.size ) ( le_max_left _ _ ) ( le_max_right _ _ )

/-- Structural isomorphism preserves the structural complexity class. -/
theorem structIso_imp_classifyEq {t1 t2 : Shape} (h : StructIso t1 t2) :
    classify t1 = classify t2 := by
  obtain ⟨ρ, _, hr⟩ := h
  exact hr.cliffordTrace_eq

/-- **Verified secondary filter.**  If two shapes have different Clifford traces
they cannot be structurally isomorphic, so any rolling-hash collision claiming
they are similar is a provable false positive. -/
theorem clifford_filter {t1 t2 : Shape} (h : classify t1 ≠ classify t2) :
    ¬ StructIso t1 t2 :=
  fun hiso => h (structIso_imp_classifyEq hiso)

/-! ## Leakage of the converse -/

/-- Witness `t₁`: a root with two leaves carrying **distinct** labels. -/
def leakL : Shape := .mk 0 [.mk 0 [], .mk 1 []]

/-- Witness `t₂`: a root with two leaves carrying the **same** label. -/
def leakR : Shape := .mk 0 [.mk 0 [], .mk 0 []]

/-- The two witnesses are similar: their fingerprints erase the labels. -/
theorem leak_similar : similar leakL leakR := by
  unfold similar; native_decide

/-- The two witnesses are even `71`-gram similar. -/
theorem leak_similar71 : similarUpTo 71 leakL leakR := by
  unfold similarUpTo; native_decide

/-
The two witnesses are **not** structurally isomorphic: any renaming would have
to send the distinct labels `0,1` to the single label `0`, violating
injectivity.  This pinpoints the precise leak of the converse — *label
collision*.
-/
theorem leak_not_structIso : ¬ StructIso leakL leakR := by
  unfold leakL leakR;
  rintro ⟨ ρ, hρ, h ⟩;
  -- From the Renamed hypothesis, we know that there exist `ds` and `ds'` such that `List.Forall₂ (Renamed ρ) [mk 0 [], mk 1 []] ds` and `ds.Perm ds'`, and `ds' = [mk 0 [], mk 0 []]`.
  obtain ⟨ds, ds', hds, hds', hds'_eq⟩ : ∃ ds ds' : List Shape, List.Forall₂ (Renamed ρ) [Shape.mk 0 [], Shape.mk 1 []] ds ∧ ds.Perm ds' ∧ ds' = [Shape.mk 0 [], Shape.mk 0 []] := by
    grind +splitIndPred;
  rcases ds with ( _ | ⟨ a, _ | ⟨ b, _ | ds ⟩ ⟩ ) <;> simp_all +decide;
  rcases hds with ⟨ ⟨ ⟩, ⟨ ⟩ ⟩;
  have := hds'.subset; simp_all +decide ;
  cases hρ ( by linarith : ρ 0 = ρ 1 )

/-- **Leakage characterization.**  The converse of the conservative-approximation
theorem fails: there exist shapes that are similar (indeed `71`-gram similar) yet
not structurally isomorphic.  The obstruction is exactly label collision. -/
theorem converse_leaks :
    ∃ t1 t2 : Shape, similarUpTo 71 t1 t2 ∧ ¬ StructIso t1 t2 :=
  ⟨leakL, leakR, leak_similar71, leak_not_structIso⟩

/-! ## Restricted true converse: the regime where the heuristic is exact -/

/-- A shape is **uniformly labelled** by `c` when every node carries the label `c`.
On such shapes the label carries no information, so the fingerprint loses nothing. -/
inductive Uniform (c : Nat) : Shape → Prop where
  | mk {cs : List Shape} : (∀ t ∈ cs, Uniform c t) → Uniform c (Shape.mk c cs)

/-
**Similarity implies a structure-preserving renaming — on the exact regime.**
If two uniformly labelled trees are similar, then they are structurally
isomorphic (witnessed by the identity renaming).  This is the precise converse to
the conservative-approximation theorem: it holds exactly when labels carry no
discriminating information.
-/
theorem similar_imp_structIso_of_uniform {c : Nat} {t1 t2 : Shape}
    (h1 : Uniform c t1) (h2 : Uniform c t2) (hsim : similar t1 t2) :
    StructIso t1 t2 := by
  refine' ⟨ id, Function.injective_id, _ ⟩;
  induction' n : t1.size + t2.size using Nat.strong_induction_on with n ih generalizing t1 t2;
  rcases t1 with ⟨ l1, cs1 ⟩ ; rcases t2 with ⟨ l2, cs2 ⟩ ; simp_all +decide [ similar ] ;
  -- Since the canonCodes are equal, the lists of child codes must be permutations of each other.
  have h_perm : List.Perm (cs1.map canonCode) (cs2.map canonCode) := by
    have h_perm : List.mergeSort (cs1.map canonCode) (· ≤ ·) = List.mergeSort (cs2.map canonCode) (· ≤ ·) := by
      convert hsim using 1;
      simp +decide [ canonCode ];
      have h_encodeCodes_inj : ∀ (l1 l2 : List Nat), encodeCodes l1 = encodeCodes l2 → l1 = l2 := by
        intros l1 l2 h_eq
        induction' l1 with a l1 ih generalizing l2 <;> induction' l2 with b l2 ih' <;> simp_all +decide [ encodeCodes ];
        exact ih _ rfl
      generalize_proofs at *; (
      exact ⟨ fun h => by rw [ h ], fun h => h_encodeCodes_inj _ _ h ⟩)
    generalize_proofs at *; (
    have h_perm : List.Perm (List.mergeSort (cs1.map canonCode) (· ≤ ·)) (List.map canonCode cs1) ∧ List.Perm (List.mergeSort (cs2.map canonCode) (· ≤ ·)) (List.map canonCode cs2) := by
      exact ⟨ List.mergeSort_perm _ _, List.mergeSort_perm _ _ ⟩
    generalize_proofs at *; (
    exact h_perm.1.symm.trans ( by aesop ) |> List.Perm.trans <| h_perm.2))
  generalize_proofs at *; (
  -- Since the lists of child codes are permutations of each other, we can find a permutation of `cs2` that matches `cs1`.
  obtain ⟨cs2', hcs2'⟩ : ∃ cs2' : List Shape, cs2'.Perm cs2 ∧ cs1.map canonCode = cs2'.map canonCode := by
    have h_perm : ∀ {l1 l2 : List Nat} {l3 : List Shape}, List.Perm l1 l2 → l2 = l3.map canonCode → ∃ l4 : List Shape, l4.Perm l3 ∧ l1 = l4.map canonCode := by
      intros l1 l2 l3 h_perm h_eq; induction' h_perm with l1 l2 h_perm ih generalizing l3; simp_all +decide ;
      · rcases l3 with ( _ | ⟨ x, l3 ⟩ ) <;> simp_all +decide [ List.map ];
        obtain ⟨ l4, hl4 ⟩ := ‹∀ { l3_1 : List Shape }, List.map canonCode l3 = List.map canonCode l3_1 → ∃ l4, l4.Perm l3_1 ∧ l2 = List.map canonCode l4› rfl; use x :: l4; aesop;
      · rcases l3 with ( _ | ⟨ a, _ | ⟨ b, l3 ⟩ ⟩ ) <;> simp_all +decide [ List.map ];
        exact ⟨ b :: a :: l3, List.Perm.swap .., by simp +decide [ List.map ] ⟩;
      · grind +suggestions
    generalize_proofs at *; (
    exact h_perm ‹_› rfl |> fun ⟨ l4, hl4₁, hl4₂ ⟩ => ⟨ l4, hl4₁, hl4₂ ⟩)
  generalize_proofs at *; (
  -- Since `cs1` and `cs2'` are permutations of each other, we can apply the induction hypothesis to each pair of corresponding children.
  have h_ind : List.Forall₂ (fun t1 t2 => Renamed id t1 t2) cs1 cs2' := by
    have h_ind : ∀ t1 ∈ cs1, ∀ t2 ∈ cs2', canonCode t1 = canonCode t2 → Renamed id t1 t2 := by
      intros t1 ht1 t2 ht2 hsim
      apply ih (t1.size + t2.size) (by
      have h_size : t1.size ≤ (Shape.mk l1 cs1).size - 1 ∧ t2.size ≤ (Shape.mk l2 cs2).size - 1 := by
        have h_size : ∀ {l : List Shape}, ∀ t ∈ l, t.size ≤ (1 + (l.map Shape.size).sum) - 1 := by
          intros l t ht; induction l <;> simp_all +decide [ List.sum_cons ] ;
          grind
        generalize_proofs at *; (
        have := h_size t1 ht1; have := h_size t2 ( hcs2'.1.subset ht2 ) ; simp_all +decide [ Shape.size ] ;)
      generalize_proofs at *; (
      linarith [ Nat.sub_add_cancel ( show 1 ≤ ( Shape.mk l1 cs1 ).size from Nat.succ_le_of_lt ( by
                                        exact Nat.pos_of_ne_zero ( by unfold Shape.size; aesop ) ) ), Nat.sub_add_cancel ( show 1 ≤ ( Shape.mk l2 cs2 ).size from Nat.succ_le_of_lt ( by
                                                                                                                                      exact Nat.pos_of_ne_zero ( by cases cs2 <;> simp +decide [ Shape.size ] ) ) ) ])) (by
      cases h1 ; aesop) (by
      have h_uniform : ∀ t ∈ cs2, Uniform c t := by
        cases h2 ; aesop ( simp_config := { singlePass := true } ) ;
      generalize_proofs at *; (
      exact h_uniform t2 ( hcs2'.1.subset ht2 ))) hsim rfl
    generalize_proofs at *; (
    have h_ind : ∀ {l1 l2 : List Shape}, List.map canonCode l1 = List.map canonCode l2 → (∀ t1 ∈ l1, ∀ t2 ∈ l2, canonCode t1 = canonCode t2 → Renamed id t1 t2) → List.Forall₂ (fun t1 t2 => Renamed id t1 t2) l1 l2 := by
      intros l1 l2 hmap h_ind; induction' l1 with t1 l1 ih generalizing l2 <;> induction' l2 with t2 l2 ih' <;> simp_all +decide [ List.map ] ;
    generalize_proofs at *; (
    exact h_ind hcs2'.2 ‹_›))
  generalize_proofs at *; (
  convert Renamed.node h_ind hcs2'.1 using 1;
  cases h1 ; cases h2 ; aesop ( simp_config := { singlePass := true } ) ;)))

/-! ## Operationalizing the discovered structural families -/

/-- Two shapes are in the **same structural class** when their Clifford traces
agree. -/
def sameClass (t1 t2 : Shape) : Prop := classify t1 = classify t2

/-- An **alignment candidate**: two shapes the analyzer flags as parallel — they
are similar *and* share a structural complexity class.  This is the verified
trigger for suggesting parallel lemma extensions (e.g. lifting a `Nat` `gcd`/`dvd`
pattern to `Int`). -/
def alignable (t1 t2 : Shape) : Prop := similar t1 t2 ∧ sameClass t1 t2

/-- **Soundness of alignment.**  Genuinely structurally isomorphic shapes are
always flagged as alignment candidates. -/
theorem structIso_imp_alignable {t1 t2 : Shape} (h : StructIso t1 t2) :
    alignable t1 t2 :=
  ⟨structIso_imp_similar h, structIso_imp_classifyEq h⟩

end ShapeFinder