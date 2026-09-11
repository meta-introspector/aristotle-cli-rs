/-
# A *proved* capacity bound for every program

`RequestProject/VM/Certification.lean` proves that the first component of a
program's trust level — its group-complexity level — is honest: level `0`
programs provably have no group structure at all. This file does the same for
the second component, turning the group budget from a declaration into a
theorem.

The two structural facts, both proved here:

* `VM.monoidCapacity_reset_le` — **a reset layer contributes no group capacity
  whatsoever.** Any permutation of the states realized inside the transition
  monoid of a reset layer must act as the identity on that layer's own state,
  because the only injective elements of the flip-flop monoid are identities.
* `VM.monoidCapacity_group_le` — a group layer over `G` on top of a base with
  state set `Q` multiplies the realizable group capacity by at most
  `Nat.card G ^ Nat.card Q`: the kernel of the projection to the base embeds
  into the functions `Q → G`, and the image is a group of base permutations
  realized inside the base machine's transition monoid.

Together (`VM.Prog.monoidCapacity_le_capBound`) they give, for every program, a
kernel-checked upper bound `VM.Prog.capBound` on the order of *any* group of
state permutations the program can realize — computed from the syntax alone.
For a reset-only program the bound is `1`, recovering the certificate
(`VM.Prog.capBound_eq_one_of_groupDepth_zero`); for the single-group-layer
word-problem program it is `Nat.card G ^ 1 = Nat.card G`, which
`RequestProject/VM/Examples/WordProblem.lean` shows is attained exactly.

The group-layer bound is `Nat.card G ^ Nat.card Q` rather than `Nat.card G`
because that is the truth: a wreath product of copies of `G` really does realize
groups larger than `G`.
-/
import RequestProject.VM.Certification

namespace VM

open KrohnRhodes Function

variable {A : Type}

/-! ## Capacity of a monoid of state maps -/

/-- The orders of the groups of state permutations realized inside `M`. -/
def monoidCapacitySet {Q : Type*} (M : Submonoid (Function.End Q)) : Set ℕ :=
  {n | ∃ H : Subgroup (Equiv.Perm Q), (∀ h ∈ H, permEnd h ∈ M) ∧ Nat.card H = n}

/-- The largest order of a group of state permutations realized inside `M`. -/
noncomputable def monoidCapacity {Q : Type*} (M : Submonoid (Function.End Q)) : ℕ :=
  sSup (monoidCapacitySet M)

section MonoidCapacity

variable {Q : Type*}

lemma one_mem_monoidCapacitySet (M : Submonoid (Function.End Q)) :
    1 ∈ monoidCapacitySet M := by
  refine ⟨⊥, ?_, ?_⟩
  · intro h hh
    rw [Subgroup.mem_bot.1 hh, map_one]
    exact M.one_mem
  · simp

lemma monoidCapacitySet_bddAbove [Finite Q] (M : Submonoid (Function.End Q)) :
    BddAbove (monoidCapacitySet M) := by
  refine ⟨Nat.card (Equiv.Perm Q), ?_⟩
  rintro n ⟨H, -, rfl⟩
  exact Nat.card_le_card_of_injective _ Subtype.val_injective

lemma one_le_monoidCapacity [Finite Q] (M : Submonoid (Function.End Q)) :
    1 ≤ monoidCapacity M :=
  le_csSup (monoidCapacitySet_bddAbove M) (one_mem_monoidCapacitySet M)

lemma le_monoidCapacity [Finite Q] {M : Submonoid (Function.End Q)}
    {H : Subgroup (Equiv.Perm Q)} (hH : ∀ h ∈ H, permEnd h ∈ M) :
    Nat.card H ≤ monoidCapacity M :=
  le_csSup (monoidCapacitySet_bddAbove M) ⟨H, hH, rfl⟩

lemma monoidCapacity_le {M : Submonoid (Function.End Q)} {b : ℕ}
    (hb : ∀ H : Subgroup (Equiv.Perm Q), (∀ h ∈ H, permEnd h ∈ M) → Nat.card H ≤ b) :
    monoidCapacity M ≤ b := by
  refine csSup_le ⟨1, one_mem_monoidCapacitySet M⟩ ?_
  rintro n ⟨H, hH, rfl⟩
  exact hb H hH

end MonoidCapacity

/-- The group capacity of the automaton a program denotes is the capacity of the
program's transition monoid. -/
lemma dfaGroupCapacity_toDFA {Q : Type} (p : Prog A Q) (start : Q) (accept : Set Q) :
    dfaGroupCapacity (p.toDFA start accept) = monoidCapacity p.monoid := rfl

/-! ## Shapes of the elements of a layer's transition monoid -/

/-- Every state map realized by a program with a reset layer on top acts on the
top layer by an element of the flip-flop monoid, and on the layers below by an
element of their transition monoid. -/
lemma reset_shape {Q R : Type} (hR : Fintype R) (p : Prog A Q) (act : A → Q → Option R)
    {f : Function.End (R × Q)} (hf : f ∈ (Prog.reset R hR p act).monoid) :
    ∃ τ : Q → Function.End R, (∀ q, τ q ∈ flipFlop R) ∧ ∃ g ∈ p.monoid,
      ∀ r q, f (r, q) = (τ q r, g q) := by
  refine exists_cascade_shape
    (sR := fun a q => (fun r => (act a q).getD r : Function.End R))
    (sQ := p.letterEnd) (S := (Prog.reset R hR p act).letterEnd) ?_ ?_ f hf
  · intro a r q
    rfl
  · intro a q
    cases hact : act a q with
    | none => exact Or.inl (by funext r; show (act a q).getD r = _; rw [hact]; rfl)
    | some c => exact Or.inr ⟨c, by funext r; show (act a q).getD r = _; rw [hact]; rfl⟩

/-- The monoid of right translations of a group, as a submonoid of all state
maps. -/
def rightTransl (G : Type) [Group G] : Submonoid (Function.End G) where
  carrier := {f | ∃ s : G, f = fun x => x * s}
  one_mem' := ⟨1, by funext x; show x = x * 1; rw [mul_one]⟩
  mul_mem' := by
    rintro f₁ f₂ ⟨s₁, rfl⟩ ⟨s₂, rfl⟩
    exact ⟨s₂ * s₁, by funext x; show (x * s₂) * s₁ = x * (s₂ * s₁); rw [mul_assoc]⟩

/-- Every state map realized by a program with a group layer on top acts on the
top layer by a right translation. -/
lemma group_shape {Q G : Type} (hG : Group G) (hF : Fintype G) (p : Prog A Q) (act : A → Q → G)
    {f : Function.End (G × Q)} (hf : f ∈ (Prog.group G hG hF p act).monoid) :
    ∃ τ : Q → Function.End G, (∀ q, τ q ∈ @rightTransl G hG) ∧ ∃ g ∈ p.monoid,
      ∀ x q, f (x, q) = (τ q x, g q) := by
  refine exists_cascade_shape
    (sR := fun a q => (fun x => (letI := hG; x * act a q) : Function.End G))
    (sQ := p.letterEnd) (S := (Prog.group G hG hF p act).letterEnd) ?_ ?_ f hf
  · intro a x q
    rfl
  · intro a q
    exact ⟨act a q, rfl⟩

/-! ## Reset layers add no capacity -/

/-- **A reset layer contributes no group capacity.** -/
theorem monoidCapacity_reset_le {Q R : Type} (hR : Fintype R) (p : Prog A Q)
    (act : A → Q → Option R) :
    monoidCapacity (Prog.reset R hR p act).monoid ≤ monoidCapacity p.monoid := by
  letI := hR
  haveI : Finite Q := p.finite_state
  refine monoidCapacity_le ?_
  intro H hH
  rcases isEmpty_or_nonempty R with hemp | ⟨⟨r₀⟩⟩
  · -- with no fibre states there are no states at all
    haveI : IsEmpty (R × Q) := by
      constructor
      rintro ⟨r, -⟩
      exact hemp.elim r
    haveI : Subsingleton (Equiv.Perm (R × Q)) :=
      ⟨fun a b => Equiv.ext fun x => isEmptyElim x⟩
    have hcard : Nat.card H = 1 := Nat.card_eq_one_iff_unique.2 ⟨inferInstance, ⟨1⟩⟩
    rw [hcard]
    exact one_le_monoidCapacity _
  · -- a permutation must act as the identity on the reset layer's own state
    have hbase : ∀ h : Equiv.Perm (R × Q), h ∈ H → ∀ r q, h (r, q) = (r, (h (r₀, q)).2) := by
      intro h hh r q
      obtain ⟨τ, hτ, g, -, hshape⟩ := reset_shape hR p act (hH h hh)
      have hperm : ∀ r q, h (r, q) = (τ q r, g q) := fun r q => hshape r q
      have hτ1 : ∀ q, τ q = 1 := by
        intro q
        rcases hτ q with h1 | ⟨c, hc⟩
        · exact h1
        · have hsub : ∀ r : R, r = r₀ := by
            intro r
            have e1 : h (r, q) = (c, g q) := by rw [hperm r q, hc]
            have e2 : h (r₀, q) = (c, g q) := by rw [hperm r₀ q, hc]
            exact congrArg Prod.fst (h.injective (e1.trans e2.symm))
          funext r
          rw [hc]
          show c = r
          rw [hsub c, hsub r]
      rw [hperm r q, hτ1 q, hperm r₀ q, hτ1 q]
      rfl
    -- the induced action on the base states is a permutation
    have hbij : ∀ h : H, Function.Bijective (fun q => ((h : Equiv.Perm (R × Q)) (r₀, q)).2) := by
      intro h
      have hinj : Function.Injective (fun q => ((h : Equiv.Perm (R × Q)) (r₀, q)).2) := by
        intro q₁ q₂ hq
        have h1 := hbase h h.2 r₀ q₁
        have h2 := hbase h h.2 r₀ q₂
        have heq : (h : Equiv.Perm (R × Q)) (r₀, q₁) = (h : Equiv.Perm (R × Q)) (r₀, q₂) := by
          rw [h1, h2]
          exact congrArg (fun y => (r₀, y)) hq
        exact congrArg Prod.snd ((h : Equiv.Perm (R × Q)).injective heq)
      exact ⟨hinj, Finite.injective_iff_surjective.1 hinj⟩
    let F : H →* Equiv.Perm Q :=
      MonoidHom.mk' (fun h => Equiv.ofBijective _ (hbij h)) (by
        intro h₁ h₂
        refine Equiv.ext fun q => ?_
        show (((h₁ * h₂ : H) : Equiv.Perm (R × Q)) (r₀, q)).2
          = ((h₁ : Equiv.Perm (R × Q)) (r₀, ((h₂ : Equiv.Perm (R × Q)) (r₀, q)).2)).2
        have h2q := hbase h₂ h₂.2 r₀ q
        show ((h₁ : Equiv.Perm (R × Q)) ((h₂ : Equiv.Perm (R × Q)) (r₀, q))).2 = _
        rw [h2q])
    have hFinj : Function.Injective F := by
      intro h₁ h₂ hh
      have hq : ∀ q, ((h₁ : Equiv.Perm (R × Q)) (r₀, q)).2
          = ((h₂ : Equiv.Perm (R × Q)) (r₀, q)).2 :=
        fun q => congrArg (fun e : Equiv.Perm Q => e q) hh
      refine Subtype.ext (Equiv.ext fun x => ?_)
      obtain ⟨r, q⟩ := x
      rw [hbase h₁ h₁.2 r q, hbase h₂ h₂.2 r q, hq q]
    have hmemF : ∀ k ∈ F.range, permEnd k ∈ p.monoid := by
      rintro k ⟨h, rfl⟩
      obtain ⟨τ, -, g, hg, hshape⟩ := reset_shape hR p act (hH h h.2)
      have hperm : ∀ r q, (h : Equiv.Perm (R × Q)) (r, q) = (τ q r, g q) := fun r q => hshape r q
      have hk : permEnd (F h) = g := by
        funext q
        show ((h : Equiv.Perm (R × Q)) (r₀, q)).2 = g q
        rw [hperm r₀ q]
      rw [hk]
      exact hg
    calc Nat.card H ≤ Nat.card F.range :=
          Nat.card_le_card_of_injective (fun h => ⟨F h, ⟨h, rfl⟩⟩)
            (fun a b hab => hFinj (congrArg Subtype.val hab))
    _ ≤ monoidCapacity p.monoid := le_monoidCapacity hmemF

/-! ## Group layers multiply capacity by at most `card G ^ card Q` -/

/-- **A group layer over `G` multiplies the realizable capacity by at most
`Nat.card G ^ Nat.card Q`.** -/
theorem monoidCapacity_group_le {Q G : Type} (hG : Group G) (hF : Fintype G) (p : Prog A Q)
    (act : A → Q → G) :
    monoidCapacity (Prog.group G hG hF p act).monoid
      ≤ Nat.card G ^ Nat.card Q * monoidCapacity p.monoid := by
  letI := hG
  letI := hF
  haveI : Finite Q := p.finite_state
  refine monoidCapacity_le ?_
  intro H hH
  -- every permutation in `H` translates the fibre and permutes the base
  have hshapeH : ∀ h : Equiv.Perm (G × Q), h ∈ H → ∀ x q,
      h (x, q) = (x * ((h ((1 : G), q)).1), (h ((1 : G), q)).2) := by
    intro h hh x q
    obtain ⟨τ, hτ, g, -, hshape⟩ := group_shape hG hF p act (hH h hh)
    have hperm : ∀ x q, h (x, q) = (τ q x, g q) := fun x q => hshape x q
    obtain ⟨s, hs⟩ := hτ q
    have h1 : h ((1 : G), q) = (s, g q) := by
      rw [hperm 1 q, hs]
      exact congrArg (fun y => (y, g q)) (one_mul s)
    rw [hperm x q, hs, h1]
  -- the induced action on the base states is a permutation
  have hbij : ∀ h : H, Function.Bijective (fun q => ((h : Equiv.Perm (G × Q)) ((1 : G), q)).2) := by
    intro h
    have hinj : Function.Injective (fun q => ((h : Equiv.Perm (G × Q)) ((1 : G), q)).2) := by
      intro q₁ q₂ hq
      set u₁ := ((h : Equiv.Perm (G × Q)) ((1 : G), q₁)).1 with hu₁
      set v₁ := ((h : Equiv.Perm (G × Q)) ((1 : G), q₁)).2 with hv₁
      set u₂ := ((h : Equiv.Perm (G × Q)) ((1 : G), q₂)).1 with hu₂
      set v₂ := ((h : Equiv.Perm (G × Q)) ((1 : G), q₂)).2 with hv₂
      have hq' : v₁ = v₂ := hq
      have e1 : (h : Equiv.Perm (G × Q)) ((1 : G), q₁) = ((1 : G) * u₁, v₁) := hshapeH h h.2 1 q₁
      have e2 : (h : Equiv.Perm (G × Q)) (u₁ * u₂⁻¹, q₂) = (u₁ * u₂⁻¹ * u₂, v₂) :=
        hshapeH h h.2 (u₁ * u₂⁻¹) q₂
      have heq : (h : Equiv.Perm (G × Q)) ((1 : G), q₁)
          = (h : Equiv.Perm (G × Q)) (u₁ * u₂⁻¹, q₂) := by
        rw [e1, e2, hq', one_mul, mul_assoc, inv_mul_cancel, mul_one]
      exact congrArg Prod.snd ((h : Equiv.Perm (G × Q)).injective heq)
    exact ⟨hinj, Finite.injective_iff_surjective.1 hinj⟩
  -- the projection onto the base machine is multiplicative
  have hmulbas : ∀ h₁ h₂ : H, ∀ q,
      (((h₁ * h₂ : H) : Equiv.Perm (G × Q)) ((1 : G), q)).2
        = ((h₁ : Equiv.Perm (G × Q)) ((1 : G), ((h₂ : Equiv.Perm (G × Q)) ((1 : G), q)).2)).2 := by
    intro h₁ h₂ q
    have key := hshapeH h₁ h₁.2 (((h₂ : Equiv.Perm (G × Q)) ((1 : G), q)).1)
      (((h₂ : Equiv.Perm (G × Q)) ((1 : G), q)).2)
    calc (((h₁ * h₂ : H) : Equiv.Perm (G × Q)) ((1 : G), q)).2
        = ((h₁ : Equiv.Perm (G × Q))
            ((((h₂ : Equiv.Perm (G × Q)) ((1 : G), q)).1),
              (((h₂ : Equiv.Perm (G × Q)) ((1 : G), q)).2))).2 := rfl
    _ = ((h₁ : Equiv.Perm (G × Q))
            ((1 : G), ((h₂ : Equiv.Perm (G × Q)) ((1 : G), q)).2)).2 := by rw [key]
  let F : H →* Equiv.Perm Q :=
    MonoidHom.mk' (fun h => Equiv.ofBijective _ (hbij h)) (by
      intro h₁ h₂
      exact Equiv.ext fun q => hmulbas h₁ h₂ q)
  -- the image is a group of base permutations realized in the base monoid
  have hmemF : ∀ k ∈ F.range, permEnd k ∈ p.monoid := by
    rintro k ⟨h, rfl⟩
    obtain ⟨τ, -, g, hg, hshape⟩ := group_shape hG hF p act (hH h h.2)
    have hperm : ∀ x q, (h : Equiv.Perm (G × Q)) (x, q) = (τ q x, g q) := fun x q => hshape x q
    have hk : permEnd (F h) = g := by
      funext q
      show ((h : Equiv.Perm (G × Q)) ((1 : G), q)).2 = g q
      rw [hperm 1 q]
    rw [hk]
    exact hg
  have hrange : Nat.card F.range ≤ monoidCapacity p.monoid := le_monoidCapacity hmemF
  -- the kernel embeds into the functions from base states to group elements
  have hker : Nat.card F.ker ≤ Nat.card G ^ Nat.card Q := by
    have hinj : Function.Injective
        (fun h : F.ker => (fun q => (((h : H) : Equiv.Perm (G × Q)) ((1 : G), q)).1)) := by
      intro h₁ h₂ hfun
      have hfix : ∀ (h : F.ker) (q : Q),
          (((h : H) : Equiv.Perm (G × Q)) ((1 : G), q)).2 = q := by
        intro h q
        have hk : F (h : H) = 1 := h.2
        exact congrArg (fun e : Equiv.Perm Q => e q) hk
      have hval : ∀ q, ((((h₁ : F.ker) : H) : Equiv.Perm (G × Q)) ((1 : G), q)).1
          = ((((h₂ : F.ker) : H) : Equiv.Perm (G × Q)) ((1 : G), q)).1 :=
        fun q => congrFun hfun q
      refine Subtype.ext (Subtype.ext (Equiv.ext fun x => ?_))
      obtain ⟨g₀, q⟩ := x
      rw [hshapeH _ ((h₁ : F.ker) : H).2 g₀ q, hshapeH _ ((h₂ : F.ker) : H).2 g₀ q, hval q,
        hfix h₁ q, hfix h₂ q]
    calc Nat.card F.ker ≤ Nat.card (Q → G) := Nat.card_le_card_of_injective _ hinj
    _ = Nat.card G ^ Nat.card Q := Nat.card_fun
  -- kernel and image multiply back to `H`
  have hcard : Nat.card F.ker * Nat.card F.range = Nat.card H := by
    have h1 := Subgroup.card_mul_index (F.ker)
    have h2 : Nat.card (H ⧸ F.ker) = Nat.card F.range :=
      Nat.card_congr (QuotientGroup.quotientKerEquivRange F).toEquiv
    rw [← Subgroup.index_eq_card F.ker] at h2
    rw [← h2]
    exact h1
  calc Nat.card H = Nat.card F.ker * Nat.card F.range := hcard.symm
  _ ≤ Nat.card G ^ Nat.card Q * monoidCapacity p.monoid := Nat.mul_le_mul hker hrange

/-! ## The proved capacity bound of a program -/

namespace Prog

/-- The number of states of a program. -/
noncomputable def stateCard : {Q : Type} → Prog A Q → ℕ := fun {Q} _ => Nat.card Q

/-- The **proved** group budget of a program: reset layers cost nothing, and a
group layer over `G` multiplies the bound by `Nat.card G` raised to the number of
states below it. -/
noncomputable def capBound : {Q : Type} → Prog A Q → ℕ
  | _, Prog.nil => 1
  | _, Prog.reset _ _ p _ => p.capBound
  | _, Prog.group G _ _ p _ => Nat.card G ^ p.stateCard * p.capBound

/-- **The capacity bound is honest.** Every group of state permutations realized
by a program has order at most `p.capBound`, a number read off the syntax. -/
theorem monoidCapacity_le_capBound :
    {Q : Type} → (p : Prog A Q) → monoidCapacity p.monoid ≤ p.capBound
  | _, Prog.nil => by
      refine monoidCapacity_le ?_
      intro H _
      haveI : Subsingleton (Equiv.Perm Unit) := ⟨fun a b => Equiv.ext fun _ => rfl⟩
      calc Nat.card H ≤ Nat.card (Equiv.Perm Unit) :=
            Nat.card_le_card_of_injective _ Subtype.val_injective
      _ = 1 := Nat.card_eq_one_iff_unique.2 ⟨inferInstance, ⟨1⟩⟩
  | _, Prog.reset R hR p act =>
      le_trans (monoidCapacity_reset_le hR p act) (monoidCapacity_le_capBound p)
  | _, Prog.group G hG hF p act => by
      refine le_trans (monoidCapacity_group_le hG hF p act) ?_
      exact Nat.mul_le_mul_left _ (monoidCapacity_le_capBound p)

/-- In terms of the automaton a program denotes. -/
theorem dfaGroupCapacity_le_capBound {Q : Type} (p : Prog A Q) (start : Q) (accept : Set Q) :
    dfaGroupCapacity (p.toDFA start accept) ≤ p.capBound :=
  p.monoidCapacity_le_capBound

/-- For a reset-only program the proved bound is `1` — the certificate again,
this time as a capacity computation. -/
theorem capBound_eq_one_of_groupDepth_zero :
    {Q : Type} → (p : Prog A Q) → p.groupDepth = 0 → p.capBound = 1
  | _, Prog.nil, _ => rfl
  | _, Prog.reset _ _ p _, h => capBound_eq_one_of_groupDepth_zero p h
  | _, Prog.group _ _ _ p _, h => absurd h (by simp [Prog.groupDepth])

end Prog

end VM
