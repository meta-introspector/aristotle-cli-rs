/-
# A certified program family at every group node of the lattice

`VM.wordProblem G` is the one-line VM program consisting of a single group layer
over the finite group `G`: its state is an element of `G`, each input letter is
an element of `G`, and reading a letter multiplies the state on the right. With
start state `1` and accepting set `{1}` it recognizes the word problem of `G`
(`VM.wordProblem_accepts`).

What is proved about it:

* its declared trust level is `(1, |G|)` — one group layer, group budget `|G|`
  (`VM.wordProblem_trust`);
* the declaration is *exact*: the group capacity of the machine it denotes is
  exactly `|G|` (`VM.wordProblem_dfaGroupCapacity`), proved by sandwiching — the
  right regular representation of `G` sits inside the transition monoid, and
  every element of that monoid is a right translation;
* consequently the program is not trusted (`VM.wordProblem_not_trusted`), which
  is the sharpness counterpart of the reset-only certificate;
* the syntactic upper bound `VM.Prog.capBound` of
  `RequestProject/VM/Capacity.lean` is attained here exactly
  (`VM.wordProblem_capBound_attained`).

Instantiating at the catalogued lattice nodes gives certified programs sitting
exactly at capacity `2` (`gpZ2`), `24` (`gpSL23`), `60` (`gpA5`) and `336`
(`gpSL27`).
-/
import RequestProject.VM.Capacity

namespace VM

open KrohnRhodes ComplexityLattice Function

variable (G : Type) [hG : Group G] [hF : Fintype G]

/-- The **word-problem program**: a single group layer over `G`, whose state is
multiplied on the right by each input letter. -/
def wordProblem : Prog G (G × Unit) := Prog.group G hG hF Prog.nil (fun a _ => a)

@[simp] lemma wordProblem_step (a : G) (x : G × Unit) :
    (wordProblem G).step a x = (x.1 * a, x.2) := rfl

@[simp] lemma wordProblem_letterEnd (a : G) :
    (wordProblem G).letterEnd a = (fun x : G × Unit => (x.1 * a, x.2)) := rfl

/-! ## Semantics: it recognizes the word problem of `G` -/

/-- The automaton denoted by the word-problem program. -/
def wordProblemDFA : DFA G (G × Unit) := (wordProblem G).toDFA (1, ()) {(1, ())}

lemma wordProblem_evalFrom (w : List G) (x : G × Unit) :
    (wordProblemDFA G).evalFrom x w = (x.1 * w.prod, x.2) := by
  induction w generalizing x with
  | nil => simp [DFA.evalFrom]
  | cons a w ih =>
      have hstep : (wordProblemDFA G).evalFrom x (a :: w)
          = (wordProblemDFA G).evalFrom (x.1 * a, x.2) w := rfl
      rw [hstep, ih, List.prod_cons, mul_assoc]

/-- The program accepts exactly the words whose product is `1`. -/
theorem wordProblem_accepts (w : List G) :
    w ∈ (wordProblem G).accepts (1, ()) {(1, ())} ↔ w.prod = 1 := by
  have h : (wordProblemDFA G).eval w = (1 * w.prod, ()) := wordProblem_evalFrom G w (1, ())
  constructor
  · intro hw
    have hw1 : (wordProblemDFA G).eval w = (1, ()) := hw
    rw [h, one_mul] at hw1
    exact congrArg Prod.fst hw1
  · intro hw
    show (wordProblemDFA G).eval w ∈ ({((1 : G), ())} : Set (G × Unit))
    rw [h, one_mul, hw]
    rfl

/-! ## The declared trust level -/

@[simp] lemma wordProblem_groupDepth : (wordProblem G).groupDepth = 1 := rfl

@[simp] lemma wordProblem_groupCapacity : (wordProblem G).groupCapacity = Fintype.card G := by
  show Fintype.card G * 1 = Fintype.card G
  omega

lemma wordProblem_trust : (wordProblem G).trust = (1, Fintype.card G) := by
  refine Prod.ext rfl ?_
  show (wordProblem G).groupCapacity = Fintype.card G
  simp

/-- A group layer really is a group layer: the program does not carry the
reset-only certificate. -/
theorem wordProblem_not_trusted : ¬ (wordProblem G).Trusted := by
  intro h
  have hz := h.groupDepth_eq_zero
  simp at hz

/-! ## Every element of the transition monoid is a right translation -/

lemma wordProblem_monoid_eq_translation {f : Function.End (G × Unit)}
    (hf : f ∈ (wordProblem G).monoid) : ∃ s : G, ∀ x : G × Unit, f x = (x.1 * s, x.2) := by
  induction hf using Submonoid.closure_induction with
  | mem f hf =>
      obtain ⟨a, rfl⟩ := hf
      exact ⟨a, fun x => rfl⟩
  | one => exact ⟨1, fun x => by
      show x = (x.1 * 1, x.2)
      simp⟩
  | mul f₁ f₂ _ _ ih₁ ih₂ =>
      obtain ⟨s₁, h₁⟩ := ih₁
      obtain ⟨s₂, h₂⟩ := ih₂
      refine ⟨s₂ * s₁, fun x => ?_⟩
      show f₁ (f₂ x) = _
      rw [h₂ x, h₁ (x.1 * s₂, x.2), mul_assoc]

/-! ## The right regular representation sits inside the transition monoid -/

/-- The right regular representation of `G` on the states `G × Unit`, made into a
monoid homomorphism by inverting (right translation is an anti-homomorphism). -/
def rightRegular : G →* Equiv.Perm (G × Unit) where
  toFun g := (Equiv.mulRight g⁻¹).prodCongr (Equiv.refl Unit)
  map_one' := by
    ext x
    simp
  map_mul' g₁ g₂ := by
    ext x
    show x.1 * (g₁ * g₂)⁻¹ = (x.1 * g₂⁻¹) * g₁⁻¹
    rw [mul_inv_rev, mul_assoc]

omit hF in
@[simp] lemma rightRegular_apply (g : G) (x : G × Unit) :
    rightRegular G g x = (x.1 * g⁻¹, x.2) := rfl

omit hF in
lemma rightRegular_injective : Injective (rightRegular G) := by
  intro g₁ g₂ h
  have hval := congrArg (fun e : Equiv.Perm (G × Unit) => (e (1, ())).1) h
  simpa using hval

lemma permEnd_rightRegular_mem (g : G) :
    permEnd (rightRegular G g) ∈ (wordProblem G).monoid := by
  have hEq : permEnd (rightRegular G g) = (wordProblem G).letterEnd g⁻¹ := by
    funext x
    rfl
  rw [hEq]
  exact Submonoid.subset_closure ⟨g⁻¹, rfl⟩

/-! ## Exact placement on the lattice -/

/-- Lower bound: the machine's group capacity is at least `|G|`. -/
theorem wordProblem_card_le_dfaGroupCapacity :
    Nat.card G ≤ dfaGroupCapacity (wordProblemDFA G) := by
  haveI : DecidableEq (G × Unit) := Classical.decEq _
  exact node_le_dfaGroupCapacity (G := G) (n := Nat.card G) rfl (rightRegular G)
    (rightRegular_injective G) (fun g => permEnd_rightRegular_mem G g)

/-- Upper bound: the machine's group capacity is at most `|G|`, because every
state map it realizes is a right translation. -/
theorem wordProblem_dfaGroupCapacity_le : dfaGroupCapacity (wordProblemDFA G) ≤ Nat.card G := by
  refine dfaGroupCapacity_le ?_
  rintro n ⟨H, hH, rfl⟩
  -- send a permutation in `H` to the group element it translates by
  have key : Injective (fun h : H => ((h : Equiv.Perm (G × Unit)) (1, ())).1) := by
    intro h₁ h₂ hval
    obtain ⟨s₁, hs₁⟩ := wordProblem_monoid_eq_translation G (hH h₁ h₁.2)
    obtain ⟨s₂, hs₂⟩ := wordProblem_monoid_eq_translation G (hH h₂ h₂.2)
    have e₁ : ∀ x : G × Unit, (h₁ : Equiv.Perm (G × Unit)) x = (x.1 * s₁, x.2) := hs₁
    have e₂ : ∀ x : G × Unit, (h₂ : Equiv.Perm (G × Unit)) x = (x.1 * s₂, x.2) := hs₂
    have hs : s₁ = s₂ := by
      have h1 := e₁ (1, ())
      have h2 := e₂ (1, ())
      simp only [one_mul] at h1 h2
      have hv := hval
      simp only [h1, h2] at hv
      exact hv
    refine Subtype.ext (Equiv.ext fun x => ?_)
    rw [e₁ x, e₂ x, hs]
  exact Nat.card_le_card_of_injective _ key

/-- **Exact placement.** The word-problem program's machine sits exactly at the
lattice node `G`: its group capacity is `|G|`, matching its declared budget. -/
theorem wordProblem_dfaGroupCapacity : dfaGroupCapacity (wordProblemDFA G) = Nat.card G :=
  le_antisymm (wordProblem_dfaGroupCapacity_le G) (wordProblem_card_le_dfaGroupCapacity G)

/-- The syntactic capacity bound of this program is `Nat.card G` ... -/
theorem wordProblem_capBound : (wordProblem G).capBound = Nat.card G := by
  have h1 : (Prog.nil : Prog G Unit).stateCard = 1 := by
    show Nat.card Unit = 1
    simp
  show Nat.card G ^ (Prog.nil : Prog G Unit).stateCard * (Prog.nil : Prog G Unit).capBound
      = Nat.card G
  rw [h1]
  show Nat.card G ^ 1 * 1 = Nat.card G
  simp

/-- ... and it is attained: for this program the proved upper bound on realizable
group capacity is exactly the capacity actually realized. -/
theorem wordProblem_capBound_attained :
    dfaGroupCapacity (wordProblemDFA G) = (wordProblem G).capBound := by
  rw [wordProblem_dfaGroupCapacity, wordProblem_capBound]

/-! ## Instances at the catalogued nodes -/

/-- A single `ZMod 2` layer: capacity exactly `2` = capacity of the node `gpZ2`. -/
theorem wordProblem_gpZ2 : dfaGroupCapacity (wordProblemDFA gpZ2) = capacity gpZ2 :=
  wordProblem_dfaGroupCapacity gpZ2

/-- A single `SL(2, F₃)` layer: capacity exactly `24` = capacity of `gpSL23`. -/
theorem wordProblem_gpSL23 : dfaGroupCapacity (wordProblemDFA gpSL23) = capacity gpSL23 :=
  wordProblem_dfaGroupCapacity gpSL23

/-- A single `A₅` layer: capacity exactly `60` = capacity of the node `gpA5`. -/
theorem wordProblem_gpA5 : dfaGroupCapacity (wordProblemDFA gpA5) = capacity gpA5 :=
  wordProblem_dfaGroupCapacity gpA5

/-- A single `SL(2, F₇)` layer: capacity exactly `336` = capacity of `gpSL27`. -/
theorem wordProblem_gpSL27 : dfaGroupCapacity (wordProblemDFA gpSL27) = capacity gpSL27 :=
  wordProblem_dfaGroupCapacity gpSL27

end VM
