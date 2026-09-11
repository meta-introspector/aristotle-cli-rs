/-
  Feed.lean — holders collect the data, and the data carries a proof.

  The senators already run software and already hold keys a badge can prove
  (`RequestProject/Badges/Claim.lean`).  This file lets them *contribute
  observations* — a market quote, a price, a reading of anything measurable —
  and turns a round of contributions into one number the rest of the system can
  use as an input to a proof.

      Observation   who measured it, what, when, the value, and a signature
      Round         a subject and a time window
      admitted      the round's reading of the submissions
      feedValue     the median of what was admitted

  `admitted` walks the *roster*, not the submissions, exactly as the chamber's
  `cast` walks the seats: for each holder on the roster, the first eligible
  submission in that holder's name.  So, by construction:

    * a submission from somebody not on the roster is never read
      (`outsider_submission_ignored`);
    * a holder who submits twice is counted once, and a feed stuffed with a
      copy of itself reads exactly the same (`duplicate_submission_ignored`,
      `stuffing_changes_nothing`);
    * at most one value per holder is ever counted — the admitted sources are a
      sublist of the roster, so on a roster without repeats they are distinct
      (`admitted_sources_sublist`, `admitted_sources_nodup`);
    * a submission for another subject, outside the window, or with a signature
      that does not verify is not admitted (`admitted_are_eligible`), and under
      the unforgeability assumption every admitted value was signed by the
      holder of that address (`admitted_authentic`).

  And on the aggregate:

    * `median_mem` — the reading is one of the submitted values, never an
      invention;
    * `median_between` — it lies between the smallest and largest submitted;
    * **`median_robust`** — if more than half the admitted values lie in a band,
      the reading lies in that band.  That is what makes the feed usable in a
      proof: a minority of holders, however they lie, cannot move the reading
      outside the range the honest majority reported.
-/

import Mathlib
import RequestProject.Solfunmeme.Badges.Claim

namespace Quotes

open Badges.Claim

/-! ### Submissions -/

/-- The domain separation tag for feed submissions.  A badge signature cannot
be recycled as a quote, or the other way round. -/
def domainTag : String := "SOLFUNMEME-FEED-OBSERVATION-v1"

/-- One holder's measurement. -/
structure Observation where
  /-- The address that measured it. -/
  source : String
  /-- What was measured, e.g. a market pair. -/
  subject : String
  /-- When, in unix seconds. -/
  time : Nat
  /-- The value, in whatever smallest unit the subject is quoted in. -/
  value : Nat
  /-- A fresh nonce. -/
  nonce : String
  /-- The signature over `message`. -/
  sig : String
deriving DecidableEq, Repr, Inhabited

/-- What the holder signs. -/
def message (o : Observation) : String :=
  domainTag ++ "|" ++ o.source ++ "|" ++ o.subject ++ "|" ++ toString o.time ++ "|"
    ++ toString o.value ++ "|" ++ o.nonce

/-- A round of collection: one subject, one window. -/
structure Round where
  /-- What is being collected. -/
  subject : String
  /-- The window opens. -/
  opens : Nat
  /-- The window closes. -/
  closes : Nat
deriving DecidableEq, Repr, Inhabited

/-- Is this submission admissible at all: from a holder on the roster, for this
subject, inside the window, and signed? -/
def eligible (roster : List String) (rd : Round) (V : Verifier) (o : Observation) : Bool :=
  roster.contains o.source && (o.subject == rd.subject)
    && decide (rd.opens ≤ o.time) && decide (o.time ≤ rd.closes)
    && V o.source (message o) o.sig

/-- The reading, for an arbitrary admissibility test: for each holder on the
roster, in roster order, the first admissible submission in that holder's
name. -/
def admittedWith (roster : List String) (ok : Observation → Bool)
    (obs : List Observation) : List Observation :=
  roster.filterMap fun a => obs.find? (fun o => (o.source == a) && ok o)

/-- **The round's reading of the submissions.** -/
def admitted (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) : List Observation :=
  admittedWith roster (eligible roster rd V) obs

/-- The values admitted, in roster order. -/
def values (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) : List Nat :=
  (admitted roster rd V obs).map (fun o => o.value)

/-! ### What admission guarantees -/

private theorem filterMap_congr' {α β : Type} {f g : α → Option β} (l : List α)
    (h : ∀ a ∈ l, f a = g a) : l.filterMap f = l.filterMap g := by
  induction l with
  | nil => rfl
  | cons a t ih =>
      simp [List.filterMap_cons, h a (by simp), ih (fun x hx => h x (by simp [hx]))]

/-- **Everything admitted is admissible.** -/
theorem admitted_are_eligible {roster : List String} {rd : Round} {V : Verifier}
    {obs : List Observation} :
    ∀ o ∈ admitted roster rd V obs, eligible roster rd V o = true := by
  intro o ho
  simp only [admitted, admittedWith, List.mem_filterMap] at ho
  obtain ⟨a, _, hfind⟩ := ho
  have hp := List.find?_some hfind
  simpa using (Bool.and_eq_true _ _).mp hp |>.2

/-- **Every admitted value was signed by the holder of its address.** -/
theorem admitted_authentic {V : Verifier} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {roster : List String} {rd : Round}
    {obs : List Observation} :
    ∀ o ∈ admitted roster rd V obs, HasKey o.source := by
  intro o ho
  have he := admitted_are_eligible (roster := roster) (rd := rd) (V := V) (obs := obs) o ho
  simp only [eligible, Bool.and_eq_true] at he
  exact hV _ _ _ he.2

/-- **Everything admitted is on the roster, for this subject, inside the
window.** -/
theorem admitted_on_roster {roster : List String} {rd : Round} {V : Verifier}
    {obs : List Observation} :
    ∀ o ∈ admitted roster rd V obs,
      o.source ∈ roster ∧ o.subject = rd.subject ∧ rd.opens ≤ o.time ∧ o.time ≤ rd.closes := by
  intro o ho
  have he := admitted_are_eligible (roster := roster) (rd := rd) (V := V) (obs := obs) o ho
  simp only [eligible, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at he
  exact ⟨by simpa using he.1.1.1.1, he.1.1.1.2, he.1.1.2, he.1.2⟩

/-- **At most one value per holder.**  The addresses whose values were admitted
are a sublist of the roster. -/
theorem admittedWith_sources_sublist (roster : List String) (ok : Observation → Bool)
    (obs : List Observation) :
    ((admittedWith roster ok obs).map (fun o => o.source)).Sublist roster := by
  unfold admittedWith
  induction roster with
  | nil => simp
  | cons a t ih =>
      simp only [List.filterMap_cons]
      cases hf : obs.find? (fun o => (o.source == a) && ok o) with
      | none => simpa using List.Sublist.cons a ih
      | some o =>
          have hsrc : o.source = a := by
            have := List.find?_some hf
            simpa using (Bool.and_eq_true _ _).mp this |>.1
          simp only [List.map_cons, hsrc]
          exact ih.cons₂ a

theorem admitted_sources_sublist (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) :
    ((admitted roster rd V obs).map (fun o => o.source)).Sublist roster :=
  admittedWith_sources_sublist roster _ obs

/-- **On a roster without repeats, no holder is counted twice.** -/
theorem admitted_sources_nodup (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) (h : roster.Nodup) :
    ((admitted roster rd V obs).map (fun o => o.source)).Nodup :=
  h.sublist (admitted_sources_sublist roster rd V obs)

/-- **A submission from somebody not on the roster is never read.** -/
theorem outsider_submission_ignored (roster : List String) (rd : Round) (V : Verifier)
    (o : Observation) (obs : List Observation) (h : o.source ∉ roster) :
    admitted roster rd V (o :: obs) = admitted roster rd V obs := by
  refine filterMap_congr' roster ?_
  intro a ha
  have hne : ¬ ((o.source == a) && eligible roster rd V o) = true := by
    intro hc
    have heq : o.source = a := by simpa using (Bool.and_eq_true _ _).mp hc |>.1
    exact h (heq ▸ ha)
  simp [hne]

/-- **A holder who submits twice is counted once.** -/
theorem duplicate_submission_ignored (roster : List String) (rd : Round) (V : Verifier)
    (o o' : Observation) (obs : List Observation) (hsrc : o'.source = o.source)
    (hel : eligible roster rd V o = true) :
    admitted roster rd V (o :: o' :: obs) = admitted roster rd V (o :: obs) := by
  refine filterMap_congr' roster ?_
  intro a _
  by_cases hb : ((o.source == a) && eligible roster rd V o) = true
  · simp [hb]
  · have hb' : ¬ ((o'.source == a) && eligible roster rd V o') = true := by
      intro hc
      have h1 : o'.source = a := by simpa using (Bool.and_eq_true _ _).mp hc |>.1
      exact hb (by simp [← hsrc, h1, hel])
    simp [hb, hb']

/-- **A feed stuffed with a copy of itself reads exactly the same.** -/
theorem stuffing_changes_nothing (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) :
    admitted roster rd V (obs ++ obs) = admitted roster rd V obs := by
  refine filterMap_congr' roster ?_
  intro a _
  cases h : obs.find? (fun o => (o.source == a) && eligible roster rd V o) with
  | none => simp [List.find?_append, h]
  | some b => simp [List.find?_append, h]

/-! ### The reading -/

/-- The admitted values, sorted. -/
def sorted (l : List Nat) : List Nat := l.mergeSort (fun a b => decide (a ≤ b))

/-- The median of a list of values: the middle element of the sorted list. -/
def median (l : List Nat) : Nat := (sorted l).getD (l.length / 2) 0

/-- The reading of the round. -/
def feedValue (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) : Nat := median (values roster rd V obs)

theorem sorted_perm (l : List Nat) : (sorted l).Perm l := List.mergeSort_perm l _

theorem sorted_length (l : List Nat) : (sorted l).length = l.length :=
  (sorted_perm l).length_eq

theorem sorted_pairwise (l : List Nat) : (sorted l).Pairwise (fun a b => a ≤ b) := by
  have h := List.pairwise_mergeSort (le := fun a b => decide (a ≤ b))
    (fun a b c hab hbc => by simp only [decide_eq_true_eq] at *; omega)
    (fun a b => by simp only [Bool.or_eq_true, decide_eq_true_eq]; omega) l
  simpa using h

/-- **The reading is one of the submitted values**, never an invention. -/
theorem median_mem (l : List Nat) (h : l ≠ []) : median l ∈ l := by
  have hlen : 0 < l.length := List.length_pos_iff.mpr h
  have hidx : l.length / 2 < (sorted l).length := by
    rw [sorted_length]
    omega
  have hmem : (sorted l).getD (l.length / 2) 0 ∈ sorted l := by
    rw [List.getD_eq_getElem _ _ hidx]
    exact List.getElem_mem hidx
  exact (sorted_perm l).mem_iff.mp hmem

/-- **The reading lies between the smallest and the largest value submitted.** -/
theorem median_between (l : List Nat) (h : l ≠ []) (lo hi : Nat)
    (hlo : ∀ x ∈ l, lo ≤ x) (hhi : ∀ x ∈ l, x ≤ hi) : lo ≤ median l ∧ median l ≤ hi :=
  ⟨hlo _ (median_mem l h), hhi _ (median_mem l h)⟩

/-! ### Robustness: a minority cannot move the reading -/

/-- The band a majority is assumed to agree on. -/
def inBand (lo hi x : Nat) : Bool := decide (lo ≤ x) && decide (x ≤ hi)

theorem inBand_iff {lo hi x : Nat} : inBand lo hi x = true ↔ lo ≤ x ∧ x ≤ hi := by
  simp [inBand]

/-- Outside the band. -/
def outBand (lo hi x : Nat) : Bool := !inBand lo hi x

theorem countP_band_split (l : List Nat) (lo hi : Nat) :
    l.countP (inBand lo hi) + l.countP (outBand lo hi) = l.length := by
  have h := List.length_eq_countP_add_countP (l := l) (p := inBand lo hi)
  have hcong : l.countP (fun a => decide ¬ (inBand lo hi a = true))
      = l.countP (outBand lo hi) := by
    refine List.countP_congr ?_
    intro x _
    by_cases hx : inBand lo hi x = true <;> simp [outBand, hx]
  omega


private theorem countP_ge_of_prefix_all (s : List Nat) (p : Nat → Bool) (k : Nat)
    (hk : k ≤ s.length) (hall : ∀ x ∈ s.take k, p x = true) : k ≤ s.countP p := by
  have hsub : ((s.take k).filter p).Sublist (s.filter p) :=
    List.Sublist.filter p (List.take_sublist k s)
  have heq : (s.take k).filter p = s.take k := List.filter_eq_self.mpr hall
  have hlen : (s.take k).length = k := by
    rw [List.length_take]
    omega
  have hle := hsub.length_le
  rw [heq, hlen, ← List.countP_eq_length_filter] at hle
  exact hle

private theorem le_get_of_mem_take (s : List Nat) (hs : s.Pairwise (fun a b => a ≤ b)) (i : Nat)
    (hi : i < s.length) : ∀ x ∈ s.take (i + 1), x ≤ s[i] := by
  intro x hx
  obtain ⟨j, hj, rfl⟩ := List.getElem_of_mem hx
  rw [List.getElem_take]
  have hjlen : j < i + 1 := by
    rw [List.length_take] at hj
    omega
  rcases Nat.lt_or_ge j i with hlt | hge
  · exact List.pairwise_iff_getElem.mp hs j i (by omega) hi hlt
  · have hji : j = i := by omega
    subst hji
    exact Nat.le_refl _

private theorem get_le_of_mem_drop (s : List Nat) (hs : s.Pairwise (fun a b => a ≤ b)) (i : Nat)
    (hi : i < s.length) : ∀ x ∈ s.drop i, s[i] ≤ x := by
  intro x hx
  obtain ⟨j, hj, rfl⟩ := List.getElem_of_mem hx
  rw [List.getElem_drop]
  rw [List.length_drop] at hj
  rcases Nat.eq_zero_or_pos j with rfl | hpos
  · simp
  · exact List.pairwise_iff_getElem.mp hs i (i + j) hi (by omega) (by omega)

/-- **A minority cannot move the reading out of the honest band.**  If more than
half of the admitted values lie in `[lo, hi]`, so does the median — whatever the
rest of the submissions say. -/
theorem median_robust (l : List Nat) (lo hi : Nat)
    (hmaj : l.length < 2 * (l.countP (inBand lo hi))) :
    lo ≤ median l ∧ median l ≤ hi := by
  have hne : l ≠ [] := by
    intro hnil
    rw [hnil] at hmaj
    simp at hmaj
  have hlen : 0 < l.length := List.length_pos_iff.mpr hne
  have hperm := sorted_perm l
  have hslen : (sorted l).length = l.length := sorted_length l
  have hpw : (sorted l).Pairwise (fun a b => a ≤ b) := sorted_pairwise l
  have hilt : l.length / 2 < (sorted l).length := by rw [hslen]; omega
  have hmed : median l = (sorted l)[l.length / 2] := by
    rw [median, List.getD_eq_getElem _ _ hilt]
  have hcount : l.countP (inBand lo hi) = (sorted l).countP (inBand lo hi) :=
    (hperm.countP_eq _).symm
  have hsum := countP_band_split (sorted l) lo hi
  constructor
  · by_contra hcon
    push_neg at hcon
    rw [hmed] at hcon
    have hall : ∀ x ∈ (sorted l).take (l.length / 2 + 1),
        outBand lo hi x = true := by
      intro x hx
      have hle := le_get_of_mem_take (sorted l) hpw _ hilt x hx
      simp only [outBand, Bool.not_eq_true', inBand, Bool.and_eq_false_iff,
        decide_eq_false_iff_not, not_le]
      exact Or.inl (by omega)
    have hcnt : l.length / 2 + 1
        ≤ (sorted l).countP (outBand lo hi) :=
      countP_ge_of_prefix_all _ _ _ (by omega) hall
    omega
  · by_contra hcon
    push_neg at hcon
    rw [hmed] at hcon
    have hall : ∀ x ∈ (sorted l).drop (l.length / 2),
        outBand lo hi x = true := by
      intro x hx
      have hge := get_le_of_mem_drop (sorted l) hpw _ hilt x hx
      simp only [outBand, Bool.not_eq_true', inBand, Bool.and_eq_false_iff,
        decide_eq_false_iff_not, not_le]
      exact Or.inr (by omega)
    have hcnt : ((sorted l).drop (l.length / 2)).length
        ≤ (sorted l).countP (outBand lo hi) := by
      have hsub : (((sorted l).drop (l.length / 2)).filter
          (outBand lo hi)).Sublist
          ((sorted l).filter (outBand lo hi)) :=
        List.Sublist.filter _ (List.drop_sublist _ _)
      have heq : ((sorted l).drop (l.length / 2)).filter
          (outBand lo hi)
          = (sorted l).drop (l.length / 2) := List.filter_eq_self.mpr hall
      have hle := hsub.length_le
      rw [heq, ← List.countP_eq_length_filter] at hle
      exact hle
    rw [List.length_drop] at hcnt
    omega

/-- The reading of a round: a majority of admitted values inside a band puts the
feed value inside that band. -/
theorem feedValue_robust (roster : List String) (rd : Round) (V : Verifier)
    (obs : List Observation) (lo hi : Nat)
    (hmaj : (values roster rd V obs).length
      < 2 * ((values roster rd V obs).countP (inBand lo hi))) :
    lo ≤ feedValue roster rd V obs ∧ feedValue roster rd V obs ≤ hi :=
  median_robust _ lo hi hmaj

end Quotes
