/-
  Anonymity.lean — choosing *how much* to redact, by search.

  `RequestProject/Badges/Disclosure.lean` lets a holder redact whatever they
  like.  That leaves the hard question: which redaction is enough?  Publishing
  "senator since 2025-01-15, rank #7" redacts the standing and still names one
  person, because the rank is a key.

  This file answers it the way anonymity is normally measured — by the size of
  the crowd the holder hides in:

      profile     what a policy actually reveals about a page, as data
      cohort      the pages of the roster with exactly that profile
      anonymity   how many pages that is
      kAnonymous  every page on the roster has a cohort of at least k
      search      the most informative policy that is still k-anonymous

  What is proved:

    * `bare_is_fully_anonymous` — publishing nothing hides you in the whole
      roster, so the search always has something to return;
    * `profile_le_cohort_subset`, `anonymity_antitone` — disclosing more never
      grows the crowd: anonymity falls monotonically as fields are added, which
      is what makes the search a search over a partial order rather than a
      guess;
    * `search_is_k_anonymous` — what the search returns really is k-anonymous;
    * `search_is_best` — and nothing more informative is: every k-anonymous
      policy discloses at most as much as the one returned;
    * `profile_determines_the_badge` — two pages with the same profile produce
      the same badge, so the cohort really is a crowd of look-alikes and the
      measure is not optimistic.

  A caveat stated plainly: this measures anonymity of the *facts on the badge*.
  The badge in `Disclosure.lean` also carries the holder's address, and a
  signature over it, which identifies the holder outright.  A holder who wants
  the anonymity measured here must present the badge without the address, and
  then the signature no longer proves anything — what does the proving instead
  is the roster-membership statement of the zero-knowledge schema
  (`RequestProject/ZKP/Schema.lean`), which proves the presenter is one of the
  hundred without saying which.
-/

import RequestProject.Solfunmeme.Badges.Disclosure

namespace Badges.Anonymity

open Badges.Claim Badges.Disclose

/-! ### What a policy reveals -/

/-- What a policy reveals about a page, as data rather than as a rendering. -/
structure Profile where
  /-- The seniority date, if disclosed. -/
  since : Option String
  /-- The snapshot index and its unix time, if disclosed. -/
  snapshot : Option (Nat × Nat)
  /-- The rank, if disclosed. -/
  rank : Option Nat
  /-- The token-day bracket, if disclosed. -/
  standing : Option (Nat × Nat)
  /-- The genesis mark, if disclosed. -/
  genesis : Option Bool
deriving DecidableEq, Repr, Inhabited

/-- The profile a policy exposes. -/
def profile (p : ClaimPage) (pol : Policy) : Profile :=
  { since := if pol.since then some p.sinceDate else none
    snapshot := if pol.snapshot then some (p.sinceIndex, p.sinceTime) else none
    rank := if pol.rank then some p.rank else none
    standing := if pol.standing then some (p.tokenDaysLower, p.tokenDaysUpper) else none
    genesis := if pol.genesis then some p.genesis else none }

/-- **The profile determines the badge**: two pages with the same profile
disclose the same fields, so the cohort below is a crowd of look-alikes and the
anonymity measure is not optimistic. -/
theorem profile_determines_the_badge (p q : ClaimPage) (pol : Policy)
    (h : profile p pol = profile q pol) : disclosed p pol = disclosed q pol := by
  obtain ⟨s1, s2, s3, s4, s5⟩ := pol
  simp only [profile, Profile.mk.injEq] at h
  obtain ⟨h1, h2, h3, h4, h5⟩ := h
  cases s1 <;> cases s2 <;> cases s3 <;> cases s4 <;> cases s5 <;>
    simp_all [disclosed, group, standingFields]

/-- How many facts a policy publishes.  The snapshot and the standing are two
figures each. -/
def info (pol : Policy) : Nat :=
  (if pol.since then 1 else 0) + (if pol.snapshot then 2 else 0)
    + (if pol.rank then 1 else 0) + (if pol.standing then 2 else 0)
    + (if pol.genesis then 1 else 0)

/-- One policy discloses everything another does. -/
def Policy.le (a b : Policy) : Prop :=
  (a.since = true → b.since = true) ∧ (a.snapshot = true → b.snapshot = true)
    ∧ (a.rank = true → b.rank = true) ∧ (a.standing = true → b.standing = true)
    ∧ (a.genesis = true → b.genesis = true)

/-! ### The crowd -/

/-- The pages of the roster that look exactly like this one under the policy. -/
def cohort (pages : List ClaimPage) (pol : Policy) (p : ClaimPage) : List ClaimPage :=
  pages.filter (fun q => profile q pol == profile p pol)

/-- How large a crowd the holder hides in. -/
def anonymity (pages : List ClaimPage) (pol : Policy) (p : ClaimPage) : Nat :=
  (cohort pages pol p).length

/-- Every page on the roster hides in a crowd of at least `k`. -/
def kAnonymous (pages : List ClaimPage) (pol : Policy) (k : Nat) : Bool :=
  pages.all (fun p => decide (k ≤ anonymity pages pol p))

/-- **Publishing nothing hides you in the whole roster.** -/
theorem bare_is_fully_anonymous (pages : List ClaimPage) (p : ClaimPage) :
    anonymity pages Policy.bare p = pages.length := by
  simp [anonymity, cohort, profile, Policy.bare]

theorem bare_is_k_anonymous (pages : List ClaimPage) (k : Nat) (h : k ≤ pages.length) :
    kAnonymous pages Policy.bare k = true := by
  simp only [kAnonymous, List.all_eq_true, decide_eq_true_eq]
  intro p _
  rw [bare_is_fully_anonymous pages p]
  exact h

/-- A policy that discloses less cannot tell apart pages that a policy
disclosing more cannot tell apart. -/
theorem profile_eq_of_le {a b : Policy} (hab : Policy.le a b) {p q : ClaimPage}
    (h : profile q b = profile p b) : profile q a = profile p a := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := hab
  simp only [profile, Profile.mk.injEq] at h ⊢
  obtain ⟨e1, e2, e3, e4, e5⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · cases ha : a.since
    · simp
    · simp only [h1 ha] at e1; simpa using e1
  · cases ha : a.snapshot
    · simp
    · simp only [h2 ha] at e2; simpa using e2
  · cases ha : a.rank
    · simp
    · simp only [h3 ha] at e3; simpa using e3
  · cases ha : a.standing
    · simp
    · simp only [h4 ha] at e4; simpa using e4
  · cases ha : a.genesis
    · simp
    · simp only [h5 ha] at e5; simpa using e5

/-- **Disclosing more never grows the crowd.** -/
theorem profile_le_cohort_subset {pages : List ClaimPage} {a b : Policy} (hab : Policy.le a b)
    (p : ClaimPage) : ∀ q ∈ cohort pages b p, q ∈ cohort pages a p := by
  intro q hq
  simp only [cohort, List.mem_filter, beq_iff_eq] at hq ⊢
  exact ⟨hq.1, profile_eq_of_le hab hq.2⟩

private theorem length_filter_mono {α : Type} (l : List α) (p q : α → Bool)
    (h : ∀ x ∈ l, p x = true → q x = true) : (l.filter p).length ≤ (l.filter q).length := by
  induction l with
  | nil => simp
  | cons x t ih =>
      have ih' := ih (fun y hy => h y (by simp [hy]))
      by_cases hp : p x = true
      · rw [List.filter_cons_of_pos hp, List.filter_cons_of_pos (h x (by simp) hp)]
        simp only [List.length_cons]
        omega
      · rw [List.filter_cons_of_neg (by simpa using hp)]
        by_cases hq : q x = true
        · rw [List.filter_cons_of_pos hq]
          simp only [List.length_cons]
          omega
        · rw [List.filter_cons_of_neg (by simpa using hq)]
          exact ih'

/-- **Anonymity falls as fields are added.** -/
theorem anonymity_antitone {pages : List ClaimPage} {a b : Policy} (hab : Policy.le a b)
    (p : ClaimPage) : anonymity pages b p ≤ anonymity pages a p := by
  refine length_filter_mono pages _ _ ?_
  intro x _ hx
  simp only [beq_iff_eq] at hx ⊢
  exact profile_eq_of_le hab hx

/-- The holder is always in their own crowd. -/
theorem one_le_anonymity {pages : List ClaimPage} (pol : Policy) {p : ClaimPage}
    (hp : p ∈ pages) : 1 ≤ anonymity pages pol p := by
  have hmem : p ∈ cohort pages pol p := by
    simp only [cohort, List.mem_filter, beq_self_eq_true, and_true]
    exact hp
  simpa [anonymity] using List.length_pos_of_mem hmem

/-- One page in too small a crowd is enough to fail the test. -/
theorem kAnonymous_false_of_witness {pages : List ClaimPage} {pol : Policy} {k : Nat}
    {p : ClaimPage} (hp : p ∈ pages) (h : anonymity pages pol p < k) :
    kAnonymous pages pol k = false := by
  cases hk : kAnonymous pages pol k with
  | false => rfl
  | true =>
      simp only [kAnonymous, List.all_eq_true, decide_eq_true_eq] at hk
      exact absurd (hk p hp) (by omega)

/-! ### Single-field policies -/

/-- Publish the seniority date and nothing else. -/
def onlySince : Policy := ⟨true, false, false, false, false⟩

/-- Publish the snapshot and nothing else. -/
def onlySnapshot : Policy := ⟨false, true, false, false, false⟩

/-- Publish the rank and nothing else. -/
def onlyRank : Policy := ⟨false, false, true, false, false⟩

/-- Publish the token-day standing and nothing else. -/
def onlyStanding : Policy := ⟨false, false, false, true, false⟩

/-- Publish the genesis mark and nothing else. -/
def onlyGenesis : Policy := ⟨false, false, false, false, true⟩

theorem le_onlySince {pol : Policy} (h : pol.since = true) : Policy.le onlySince pol := by
  refine ⟨fun _ => h, ?_, ?_, ?_, ?_⟩ <;> simp [onlySince]

theorem le_onlySnapshot {pol : Policy} (h : pol.snapshot = true) : Policy.le onlySnapshot pol := by
  refine ⟨?_, fun _ => h, ?_, ?_, ?_⟩ <;> simp [onlySnapshot]

theorem le_onlyRank {pol : Policy} (h : pol.rank = true) : Policy.le onlyRank pol := by
  refine ⟨?_, ?_, fun _ => h, ?_, ?_⟩ <;> simp [onlyRank]

theorem le_onlyStanding {pol : Policy} (h : pol.standing = true) : Policy.le onlyStanding pol := by
  refine ⟨?_, ?_, ?_, fun _ => h, ?_⟩ <;> simp [onlyStanding]

/-- **One identifying field is enough to identify.**  If a single field already
singles somebody out, so does every policy that publishes it. -/
theorem identified_by_more {pages : List ClaimPage} {a pol : Policy} (hle : Policy.le a pol)
    {p : ClaimPage} (hp : p ∈ pages) (h : anonymity pages a p = 1) :
    anonymity pages pol p = 1 := by
  have h1 := one_le_anonymity (pages := pages) pol hp
  have h2 := anonymity_antitone (pages := pages) hle p
  omega

/-! ### The search -/

/-- Every policy there is: five independent flags. -/
def allPolicies : List Policy :=
  (([false, true] : List Bool)).flatMap fun a =>
    ([false, true] : List Bool).flatMap fun b =>
      ([false, true] : List Bool).flatMap fun c =>
        ([false, true] : List Bool).flatMap fun d =>
          ([false, true] : List Bool).map fun e => ⟨a, b, c, d, e⟩

theorem allPolicies_complete (pol : Policy) : pol ∈ allPolicies := by
  obtain ⟨a, b, c, d, e⟩ := pol
  cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> decide

/-- Keep the more informative of two policies, preferring the first on a tie. -/
def better (x y : Policy) : Policy := if info x < info y then y else x

/-- **The search**: the most informative policy that keeps every page on the
roster in a crowd of at least `k`. -/
def search (pages : List ClaimPage) (k : Nat) : Policy :=
  (allPolicies.filter (fun pol => kAnonymous pages pol k)).foldl better Policy.bare

private theorem foldl_better_mem (l : List Policy) (init : Policy) :
    l.foldl better init = init ∨ (l.foldl better init) ∈ l := by
  induction l generalizing init with
  | nil => exact Or.inl rfl
  | cons x t ih =>
      rcases ih (better init x) with h | h
      · rw [List.foldl_cons, h]
        unfold better
        split
        · exact Or.inr (by simp)
        · exact Or.inl rfl
      · exact Or.inr (by simp [List.foldl_cons, h])

private theorem foldl_better_ge (l : List Policy) (init : Policy) :
    info init ≤ info (l.foldl better init) := by
  induction l generalizing init with
  | nil => exact Nat.le_refl _
  | cons x t ih =>
      refine Nat.le_trans ?_ (ih (better init x))
      unfold better
      split
      · omega
      · exact Nat.le_refl _

private theorem foldl_better_max (l : List Policy) (init : Policy) :
    ∀ x ∈ l, info x ≤ info (l.foldl better init) := by
  induction l generalizing init with
  | nil => intro x hx; simp at hx
  | cons y t ih =>
      intro x hx
      rcases List.mem_cons.mp hx with rfl | hx'
      · refine Nat.le_trans ?_ (foldl_better_ge t (better init x))
        unfold better
        split
        · exact Nat.le_refl _
        · omega
      · exact ih (better init y) x hx'

/-- **What the search returns is k-anonymous.** -/
theorem search_is_k_anonymous (pages : List ClaimPage) (k : Nat) (h : k ≤ pages.length) :
    kAnonymous pages (search pages k) k = true := by
  unfold search
  rcases foldl_better_mem (allPolicies.filter (fun pol => kAnonymous pages pol k))
      Policy.bare with hb | hm
  · rw [hb]; exact bare_is_k_anonymous pages k h
  · exact (List.mem_filter.mp hm).2

/-- **And nothing more informative is.**  Every k-anonymous policy discloses at
most as much as the one the search returns, so the holder is publishing as much
as they safely can. -/
theorem search_is_best (pages : List ClaimPage) (k : Nat) (pol : Policy)
    (hpol : kAnonymous pages pol k = true) : info pol ≤ info (search pages k) :=
  foldl_better_max _ _ pol (List.mem_filter.mpr ⟨allPolicies_complete pol, hpol⟩)

end Badges.Anonymity
