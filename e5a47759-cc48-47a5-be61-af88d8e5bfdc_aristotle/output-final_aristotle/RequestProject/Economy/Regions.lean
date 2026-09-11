/-
# Regions and containment

`RegionContains parent child := parent.authority = child.authority` is not
containment: it is reflexive and symmetric, so it identifies a country with
every one of its provinces.  Containment here comes from a *registry*: a
partial `parentOf` map together with a rank that strictly decreases towards the
root, which is the acyclicity witness.  Containment is the reflexive-transitive
closure of `parentOf`, and it is proved to be a partial order.
-/
import RequestProject.Economy.Time

namespace RequestProject.Economy

/-- A region named by an issuing authority and a code within it.  The label is
documentation; identity is `(authority, code)`. -/
structure RegionCode where
  authority : String
  code : String
  label : String
deriving DecidableEq, Repr

/-- A versioned geographic registry: each region has at most one parent, and
`rank` strictly decreases along the parent edge, which forbids cycles. -/
structure RegionRegistry where
  parentOf : RegionCode → Option RegionCode
  rank : RegionCode → Nat
  rank_decreasing : ∀ r p, parentOf r = some p → rank p < rank r

namespace RegionRegistry

variable (reg : RegionRegistry)

/-- One step towards the root. -/
def Step (child parent : RegionCode) : Prop := reg.parentOf child = some parent

/-- `Contains reg parent child` : `child` lies inside `parent`. -/
def Contains (parent child : RegionCode) : Prop :=
  Relation.ReflTransGen reg.Step child parent

theorem contains_refl (r : RegionCode) : reg.Contains r r := Relation.ReflTransGen.refl

theorem contains_trans {a b c : RegionCode} (h₁ : reg.Contains a b) (h₂ : reg.Contains b c) :
    reg.Contains a c := Relation.ReflTransGen.trans h₂ h₁

theorem contains_of_step {child parent : RegionCode} (h : reg.Step child parent) :
    reg.Contains parent child := Relation.ReflTransGen.single h

/-- Rank is monotone along containment. -/
theorem rank_le_of_contains {parent child : RegionCode} (h : reg.Contains parent child) :
    reg.rank parent ≤ reg.rank child := by
  induction h with
  | refl => exact le_refl _
  | tail _hrest hstep ih => exact le_of_lt (lt_of_lt_of_le (reg.rank_decreasing _ _ hstep) ih)

/-- Strict decrease for a proper containment. -/
theorem rank_lt_of_contains_ne {parent child : RegionCode} (h : reg.Contains parent child)
    (hne : parent ≠ child) : reg.rank parent < reg.rank child := by
  rcases Relation.ReflTransGen.cases_head h with rfl | ⟨b, hstep, hrest⟩
  · exact absurd rfl hne
  · exact lt_of_le_of_lt (rank_le_of_contains reg hrest) (reg.rank_decreasing _ _ hstep)

/-- Containment is antisymmetric: the registry cannot make two distinct regions
contain each other. -/
theorem contains_antisymm {a b : RegionCode} (h₁ : reg.Contains a b) (h₂ : reg.Contains b a) :
    a = b := by
  by_contra hne
  have l₁ := rank_lt_of_contains_ne reg h₁ hne
  have l₂ := rank_lt_of_contains_ne reg h₂ (Ne.symm hne)
  omega

/-! ### Deciding containment by walking to the root -/

/-- Walk at most `n` steps from `child` towards the root looking for `parent`. -/
def walk : Nat → RegionCode → RegionCode → Bool
  | 0, c, p => c == p
  | n + 1, c, p =>
      if c == p then true
      else match reg.parentOf c with
        | none => false
        | some q => walk n q p

/-- The walk is sound: whatever it accepts really is a containment. -/
theorem contains_of_walk : ∀ (n : Nat) (c p : RegionCode), reg.walk n c p = true → reg.Contains p c
  | 0, c, p, h => by
      simp only [walk, beq_iff_eq] at h
      subst h; exact contains_refl reg c
  | n + 1, c, p, h => by
      simp only [walk] at h
      by_cases hcp : c = p
      · subst hcp; exact contains_refl reg c
      · simp only [beq_iff_eq, hcp, if_false] at h
        revert h
        cases hq : reg.parentOf c with
        | none => intro h; exact absurd h (by simp)
        | some q =>
            intro h
            exact Relation.ReflTransGen.head hq (contains_of_walk n q p h)

/-- The walk is complete: every containment is found within enough steps. -/
theorem walk_of_contains {c p : RegionCode} (h : reg.Contains p c) :
    ∃ n, reg.walk n c p = true := by
  induction h using Relation.ReflTransGen.head_induction_on with
  | refl => exact ⟨0, by simp [walk]⟩
  | @head a b hstep _ ih =>
      obtain ⟨n, hn⟩ := ih
      refine ⟨n + 1, ?_⟩
      have hs : reg.parentOf a = some b := hstep
      simp only [walk, hs, beq_iff_eq]
      split
      · rfl
      · exact hn

end RegionRegistry

end RequestProject.Economy
