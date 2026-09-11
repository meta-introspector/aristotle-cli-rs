/-
# The `A₅` word-problem recognizer, and its placement on the complexity lattice

The recognizer: alphabet = elements of `A₅`, states = elements of `A₅`, reading a
letter multiplies the current state on the right, and a word is accepted exactly
when the product of its letters is the identity (`a5DFA_accepts`). This is the
canonical "state tracking" language, and it is the standard example of a
recognizer whose Krohn-Rhodes decomposition is *forced* to contain a specific
nonabelian simple group.

What is proved here:

* `a5_permSubgroup_in` — the right regular representation of `A₅` sits inside the
  recognizer's transition monoid;
* `a5_node_placement` — hence its group capacity is at least `60`, the capacity of
  the catalogued lattice node `gpA5`;
* `a5_dfaGroupCapacity_eq_sixty` — and in fact exactly `60`: the recognizer sits
  precisely at the `gpA5` node, sandwiched from both sides;
* `a5_not_groupComplexityZero` and `a5_gpA5_divides` — so the recognizer's group
  complexity is at least `1`, and the simple group forced into its decomposition
  is `A₅` itself, an already-catalogued node.

No new lattice machinery is used: only `isAt_gpA5` and the capacity monotonicity
lemma, exactly as advertised.
-/
import RequestProject.KrohnRhodes.LatticeBridge

namespace Recognizers

open KrohnRhodes ComplexityLattice Function

/-- The alternating group `A₅`, used both as alphabet and as state set. -/
abbrev A5 : Type := ComplexityLattice.gpA5

/-- The `A₅` word-problem recognizer: states are group elements, each letter acts
by right multiplication, and the accepted words are those whose product is the
identity. -/
def a5DFA : DFA A5 A5 where
  step q a := q * a
  start := 1
  accept := {1}

lemma a5DFA_letterMap (a : A5) : letterMap a5DFA a = (fun q : A5 => q * a) := rfl

lemma a5_evalFrom (w : List A5) (q : A5) : a5DFA.evalFrom q w = q * w.prod := by
  induction w generalizing q with
  | nil => simp [DFA.evalFrom]
  | cons a w ih =>
      have hstep : a5DFA.evalFrom q (a :: w) = a5DFA.evalFrom (q * a) w := rfl
      rw [hstep, ih, List.prod_cons, mul_assoc]

/-- The recognizer accepts exactly the words whose product is the identity: it
recognizes the word problem of `A₅`. -/
theorem a5DFA_accepts (w : List A5) : w ∈ a5DFA.accepts ↔ w.prod = 1 := by
  have h : a5DFA.eval w = 1 * w.prod := a5_evalFrom w 1
  constructor
  · intro hw
    have hw1 : a5DFA.eval w = 1 := hw
    rw [h, one_mul] at hw1
    exact hw1
  · intro hw
    show a5DFA.eval w ∈ a5DFA.accept
    rw [h, one_mul, hw]
    rfl

/-! ## `A₅` sits inside the transition monoid -/

/-- The right regular representation of `A₅` as permutations of the state set
(inverted so that it is a homomorphism rather than an anti-homomorphism). -/
def rightReg : A5 →* Equiv.Perm A5 where
  toFun g := Equiv.mulRight g⁻¹
  map_one' := by ext x; simp
  map_mul' g h := by ext x; simp [mul_assoc]

@[simp] lemma rightReg_apply (g x : A5) : rightReg g x = x * g⁻¹ := rfl

lemma rightReg_injective : Injective rightReg := by
  intro g h hgh
  have hx : rightReg g 1 = rightReg h 1 := by rw [hgh]
  simp only [rightReg_apply, one_mul] at hx
  exact inv_injective hx

lemma permEnd_rightReg_mem (g : A5) : permEnd (rightReg g) ∈ transitionMonoid a5DFA := by
  have h : permEnd (rightReg g) = letterMap a5DFA g⁻¹ := by
    funext x
    rfl
  rw [h]
  exact letterMap_mem a5DFA g⁻¹

/-- The right regular representation of `A₅` is a group of state permutations
realized by words of the recognizer. -/
theorem a5_permSubgroup_in : PermSubgroupIn a5DFA rightReg.range := by
  rintro h ⟨g, rfl⟩
  exact permEnd_rightReg_mem g

/-- **Lattice placement (lower bound).** The recognizer's group capacity is at
least the capacity `60` of the catalogued node `gpA5`. -/
theorem a5_node_placement : 60 ≤ dfaGroupCapacity a5DFA :=
  node_le_dfaGroupCapacity isAt_gpA5 rightReg rightReg_injective permEnd_rightReg_mem

/-- `A₅` divides the transition monoid of the recognizer: it is a genuine
Krohn-Rhodes group component. -/
theorem a5_gpA5_divides : GroupDivides (transitionMonoid a5DFA) gpA5 := by
  refine ⟨(permEnd.comp rightReg).toMulHom, ?_, ?_⟩
  · intro g h hgh
    exact rightReg_injective (permEnd_injective hgh)
  · intro g
    exact permEnd_rightReg_mem g

/-- The recognizer does **not** have group complexity `0`. -/
theorem a5_not_groupComplexityZero : ¬ GroupComplexityZero a5DFA := by
  intro hD
  exact not_groupDivides_of_groupComplexityZero hD isAt_gpA5 (by norm_num) a5_gpA5_divides

/-! ## The exact capacity: the transition monoid is exactly the regular
representation of `A₅` -/

/-- The submonoid of all right multiplications by elements of `A₅`. -/
def rightMulSubmonoid : Submonoid (Function.End A5) where
  carrier := {f | ∃ g : A5, f = fun x => x * g}
  mul_mem' := by
    rintro f f' ⟨g, rfl⟩ ⟨g', rfl⟩
    exact ⟨g' * g, by funext x; show x * g' * g = x * (g' * g); rw [mul_assoc]⟩
  one_mem' := ⟨1, by funext x; show x = x * 1; rw [mul_one]⟩

lemma transitionMonoid_a5_le : transitionMonoid a5DFA ≤ rightMulSubmonoid := by
  refine Submonoid.closure_le.2 ?_
  rintro f ⟨a, rfl⟩
  exact ⟨a, rfl⟩

/-- Any group of state permutations realized by the recognizer injects into `A₅`,
so has order at most `60`. -/
lemma card_le_of_permSubgroupIn {H : Subgroup (Equiv.Perm A5)} (hH : PermSubgroupIn a5DFA H) :
    Nat.card H ≤ 60 := by
  have hinj : Injective (fun h : H => (h : Equiv.Perm A5) 1) := by
    rintro ⟨h₁, hh₁⟩ ⟨h₂, hh₂⟩ heq
    obtain ⟨g₁, hg₁⟩ := transitionMonoid_a5_le (hH h₁ hh₁)
    obtain ⟨g₂, hg₂⟩ := transitionMonoid_a5_le (hH h₂ hh₂)
    have e₁ : ∀ x, h₁ x = x * g₁ := fun x => congrFun hg₁ x
    have e₂ : ∀ x, h₂ x = x * g₂ := fun x => congrFun hg₂ x
    simp only at heq
    have hg : g₁ = g₂ := by
      have := heq
      rw [e₁ 1, e₂ 1, one_mul, one_mul] at this
      exact this
    refine Subtype.ext (Equiv.ext ?_)
    intro x
    rw [e₁ x, e₂ x, hg]
  calc Nat.card H ≤ Nat.card A5 := Nat.card_le_card_of_injective _ hinj
  _ = 60 := isAt_gpA5

/-- **Exact placement.** The `A₅` word-problem recognizer sits exactly at the
lattice node `gpA5`: its group capacity is `60 = capacity gpA5`. -/
theorem a5_dfaGroupCapacity_eq_sixty : dfaGroupCapacity a5DFA = 60 := by
  refine le_antisymm (dfaGroupCapacity_le ?_) a5_node_placement
  rintro n ⟨H, hH, rfl⟩
  exact card_le_of_permSubgroupIn hH

theorem a5_dfaGroupCapacity_eq_capacity_gpA5 :
    dfaGroupCapacity a5DFA = capacity gpA5 := by
  rw [a5_dfaGroupCapacity_eq_sixty, isAt_gpA5]

end Recognizers
