/-
# The lattice of trust, and what a trust certificate actually guarantees

Each VM program carries a *declared* complexity class, read straight off its
syntax: how many group layers it uses (`groupDepth`) and how large those groups
are (`groupCapacity`). Packaged together these form a **trust level**

  `Trust := ℕ × ℕ`   (level, group budget)

ordered componentwise — a lattice, with `Trust.reset = (0, 1)` the least trust
level any program can have, occupied exactly by the reset-only programs.

The point of this file is that the declaration is *honest*, and honest for a
kernel-checked reason rather than by appeal to the Krohn-Rhodes theorem:

* `VM.Prog.isAperiodic_monoid_of_groupDepth_zero` — a program with no group
  layers has an aperiodic transition monoid. This is proved by induction over
  the layers using `KrohnRhodes.isAperiodic_closure_of_cascade` and
  `KrohnRhodes.isAperiodic_flipFlop`, i.e. from the cascade structure itself.
* `VM.Prog.Trusted.subsingleton_of_groupDivides` — hence *no* nontrivial group
  divides it: nothing in such a program can count, cycle or permute. By
  `KrohnRhodes.isAperiodic_iff_no_cyclic_divisor` this is an exact
  characterization, not a one-sided sufficient condition.
* `VM.Prog.Trusted.not_groupDivides_node` — in lattice terms: no catalogued node
  of capacity `≥ 2` occurs in the program's decomposition.
* `VM.Prog.one_le_groupDepth_of_groupDivides` — the contrapositive, which is the
  soundness statement of the trust discipline: any program whose recognizer can
  realize a nontrivial group *must* have declared a group layer.

What is *not* claimed: a `Trust.reset` certificate says the recognizer has no
group-like internal state. It does not say the recognized language is safe, and
the group budget of a program with group layers is a declared budget, not a
proven upper bound on every group realizable by the cascade (a wreath product of
copies of a group `G` realizes groups larger than `|G|`). Lower-bound placements
on the lattice are proved per program; see `RequestProject/VM/Examples.lean`.
-/
import RequestProject.VM.Syntax
import RequestProject.KrohnRhodes.LatticeBridge

namespace VM

open KrohnRhodes ComplexityLattice

/-! ## The trust lattice -/

/-- A **trust level**: the declared Krohn-Rhodes group-complexity level of a
program together with its declared group budget, ordered componentwise. -/
def Trust : Type := ℕ × ℕ

namespace Trust

instance : Lattice Trust := inferInstanceAs (Lattice (ℕ × ℕ))
instance : OrderBot Trust := inferInstanceAs (OrderBot (ℕ × ℕ))
instance : DecidableEq Trust := inferInstanceAs (DecidableEq (ℕ × ℕ))

/-- The group-complexity level of a trust level. -/
def level (t : Trust) : ℕ := t.1

/-- The group budget of a trust level. -/
def capacity (t : Trust) : ℕ := t.2

/-- The trust level of a reset-only program: no group layers, empty group
budget. This is the least trust level attainable by a program
(`Trust.reset_le`), and the one that carries the "no weird machines" certificate.
-/
def reset : Trust := (0, 1)

@[simp] lemma level_mk (m n : ℕ) : level (m, n) = m := rfl
@[simp] lemma capacity_mk (m n : ℕ) : capacity (m, n) = n := rfl
@[simp] lemma level_reset : level reset = 0 := rfl
@[simp] lemma capacity_reset : capacity reset = 1 := rfl

lemma le_iff {s t : Trust} : s ≤ t ↔ s.level ≤ t.level ∧ s.capacity ≤ t.capacity := Iff.rfl

lemma ext' {s t : Trust} (h₁ : s.level = t.level) (h₂ : s.capacity = t.capacity) : s = t :=
  Prod.ext h₁ h₂

end Trust

namespace Prog

variable {A : Type} {Q : Type}

/-- The trust level a program declares. -/
def trust (p : Prog A Q) : Trust := (p.groupDepth, p.groupCapacity)

@[simp] lemma trust_level (p : Prog A Q) : p.trust.level = p.groupDepth := rfl
@[simp] lemma trust_capacity (p : Prog A Q) : p.trust.capacity = p.groupCapacity := rfl

@[simp] lemma trust_nil : (nil : Prog A Unit).trust = Trust.reset := rfl

@[simp] lemma trust_reset {R : Type} (hR : Fintype R) (p : Prog A Q) (act : A → Q → Option R) :
    (Prog.reset R hR p act).trust = p.trust := rfl

lemma trust_group {G : Type} (hG : Group G) (hF : Fintype G) (p : Prog A Q) (act : A → Q → G) :
    (Prog.group G hG hF p act).trust =
      (p.groupDepth + 1, (@Fintype.card G hF) * p.groupCapacity) := rfl

/-- A finite group is nonempty, so its order is positive. -/
lemma fintype_card_group_pos {G : Type} (hG : Group G) (hF : Fintype G) :
    0 < @Fintype.card G hF := by
  haveI := hG
  haveI : Nonempty G := One.instNonempty
  exact @Fintype.card_pos G hF _

/-- A program's group budget is at least `1`. -/
theorem one_le_groupCapacity : {Q : Type} → (p : Prog A Q) → 1 ≤ p.groupCapacity
  | _, nil => le_rfl
  | _, Prog.reset _ _ p _ => one_le_groupCapacity p
  | _, Prog.group G hG hF p act => by
      have h1 : 0 < (@Fintype.card G hF) := fintype_card_group_pos hG hF
      have h2 : 1 ≤ p.groupCapacity := one_le_groupCapacity p
      show 1 ≤ (@Fintype.card G hF) * p.groupCapacity
      calc 1 = 1 * 1 := by norm_num
      _ ≤ (@Fintype.card G hF) * p.groupCapacity := Nat.mul_le_mul h1 h2

/-- `Trust.reset` is the least trust level any program can declare. -/
theorem Trust_reset_le (p : Prog A Q) : Trust.reset ≤ p.trust :=
  ⟨Nat.zero_le _, one_le_groupCapacity p⟩

/-- A program with no group layers has group budget exactly `1`. -/
theorem groupCapacity_eq_one_of_groupDepth_zero :
    {Q : Type} → (p : Prog A Q) → p.groupDepth = 0 → p.groupCapacity = 1
  | _, nil, _ => rfl
  | _, Prog.reset _ _ p _, h => groupCapacity_eq_one_of_groupDepth_zero p h
  | _, Prog.group _ _ _ p _, h => by
      exact absurd h (by simp [groupDepth])

/-- Declaring the reset trust level is the same as using no group layers. -/
theorem trust_eq_reset_iff (p : Prog A Q) : p.trust = Trust.reset ↔ p.groupDepth = 0 := by
  constructor
  · intro h
    exact congrArg Trust.level h
  · intro h
    exact Trust.ext' (by simpa using h) (by simpa using groupCapacity_eq_one_of_groupDepth_zero p h)

/-- A **trusted** program: one that declares (and, by the theorems below,
provably has) Krohn-Rhodes group complexity `0`. -/
def Trusted (p : Prog A Q) : Prop := p.trust = Trust.reset

lemma Trusted.groupDepth_eq_zero {p : Prog A Q} (h : p.Trusted) : p.groupDepth = 0 :=
  (trust_eq_reset_iff p).1 h

/-! ## Adding layers is monotone for trust -/

@[simp] lemma trust_reset_eq {R : Type} (hR : Fintype R) (p : Prog A Q) (act : A → Q → Option R) :
    (Prog.reset R hR p act).trust = p.trust := rfl

lemma trust_le_trust_group {G : Type} (hG : Group G) (hF : Fintype G) (p : Prog A Q)
    (act : A → Q → G) : p.trust ≤ (Prog.group G hG hF p act).trust := by
  refine ⟨by simp [trust, groupDepth], ?_⟩
  have h1 : 0 < (@Fintype.card G hF) := fintype_card_group_pos hG hF
  show p.groupCapacity ≤ (@Fintype.card G hF) * p.groupCapacity
  exact Nat.le_mul_of_pos_left _ h1

/-! ## The certificate: reset-only programs are provably group-free -/

/-- **Main soundness theorem for the trust discipline.** A program with no group
layers has an aperiodic transition monoid.

The proof is by induction over the program's layers: the empty program has a
one-element state space, and a reset layer is a cascade step whose fibre actions
all lie in the flip-flop monoid `U₂`, which is aperiodic. No appeal to the
Krohn-Rhodes theorem is made — the cascade structure is present syntactically,
and the aperiodicity of a cascade of aperiodic layers is proved in
`RequestProject/KrohnRhodes/Cascade.lean`. -/
theorem isAperiodic_monoid_of_groupDepth_zero :
    {Q : Type} → (p : Prog A Q) → p.groupDepth = 0 → IsAperiodic p.monoid
  | _, nil, _ => by
      intro f _
      exact ⟨0, by funext u; exact Subsingleton.elim _ _⟩
  | _, Prog.reset R hR p act, h => by
      haveI := hR
      haveI := p.finite_state
      have hbase : IsAperiodic p.monoid := isAperiodic_monoid_of_groupDepth_zero p h
      refine isAperiodic_closure_of_cascade
        (sR := fun a q => (fun r => (act a q).getD r : Function.End R))
        (sQ := p.letterEnd) (S := (Prog.reset R hR p act).letterEnd) ?_ ?_
        isAperiodic_flipFlop hbase
      · intro a r q
        rfl
      · intro a q
        cases hact : act a q with
        | none => exact Or.inl (by funext r; show (act a q).getD r = _; rw [hact]; rfl)
        | some c => exact Or.inr ⟨c, by funext r; show (act a q).getD r = _; rw [hact]; rfl⟩
  | _, Prog.group _ _ _ p _, h => by
      exact absurd h (by simp [groupDepth])

/-- A trusted program has an aperiodic transition monoid. -/
theorem Trusted.isAperiodic {p : Prog A Q} (h : p.Trusted) : IsAperiodic p.monoid :=
  isAperiodic_monoid_of_groupDepth_zero p h.groupDepth_eq_zero

/-- **The certificate.** No nontrivial group divides the transition monoid of a
trusted program: it cannot count, cycle or permute. -/
theorem Trusted.subsingleton_of_groupDivides {p : Prog A Q} (h : p.Trusted) {G : Type*} [Group G]
    (hG : GroupDivides p.monoid G) : Subsingleton G :=
  subsingleton_of_isAperiodic_of_groupDivides h.isAperiodic hG

/-- Lattice form of the certificate: a trusted program admits no catalogued
lattice node of capacity `≥ 2` as a component of its decomposition. -/
theorem Trusted.not_groupDivides_node {p : Prog A Q} (h : p.Trusted) {G : Type*} [Group G]
    {n : ℕ} (hnode : isAt G n) (hn : 2 ≤ n) : ¬ GroupDivides p.monoid G := by
  intro hdiv
  have h1 := card_eq_one_of_isAperiodic_of_groupDivides h.isAperiodic hdiv
  rw [isAt, capacity, h1] at hnode
  omega

/-- The group capacity of a trusted program's automaton is exactly `1`. -/
theorem Trusted.dfaGroupCapacity_eq_one {p : Prog A Q} (h : p.Trusted) (start : Q)
    (accept : Set Q) : dfaGroupCapacity (p.toDFA start accept) = 1 := by
  haveI := p.finite_state
  haveI := Classical.decEq Q
  refine dfaGroupCapacity_eq_one_of_groupComplexityZero ?_
  have := h.isAperiodic
  rwa [p.monoid_eq_transitionMonoid start accept] at this

/-- **Soundness of the trust discipline, contrapositive form.** If a program's
recognizer realizes a nontrivial group, then the program must have declared at
least one group layer. -/
theorem one_le_groupDepth_of_groupDivides {p : Prog A Q} {G : Type*} [Group G]
    (hG : GroupDivides p.monoid G) (hcard : 2 ≤ Nat.card G) : 1 ≤ p.groupDepth := by
  by_contra hcon
  have h0 : p.groupDepth = 0 := by omega
  have := card_eq_one_of_isAperiodic_of_groupDivides
    (isAperiodic_monoid_of_groupDepth_zero p h0) hG
  omega

/-- **Exactness.** For a trusted program the certificate is not merely sufficient:
by `KrohnRhodes.isAperiodic_iff_no_cyclic_divisor`, aperiodicity of the
transition monoid is *equivalent* to the absence of nontrivial cyclic divisors,
so a program that fails the certificate really does contain a nontrivial cyclic
group in its transition monoid. -/
theorem exists_cyclic_divisor_of_not_isAperiodic_monoid (p : Prog A Q)
    (h : ¬ IsAperiodic p.monoid) :
    ∃ n : ℕ, 2 ≤ n ∧ GroupDivides p.monoid (Multiplicative (ZMod n)) := by
  haveI := p.finite_state
  exact KrohnRhodes.exists_cyclic_divisor_of_not_isAperiodic h

end Prog

end VM
