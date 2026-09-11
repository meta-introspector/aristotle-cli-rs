import Mathlib

/-!
# Spoken cues

The formal counterpart of `HesperDeck.normalizeCues` (`web/js/deck.js`), the
scheduler behind the `tts` / `say` / `caption … say` playbook statements and
behind the exported WebVTT subtitle track.

Cues arrive with a requested start and a length (how long the line takes to
speak).  They are laid out in order: a cue starts when it asked to, or when
the previous one finishes if that is later, and it is cut off at the end of
the clip.  A cue with no room left is dropped rather than made to overlap its
neighbour.

What is proved: every cue that survives is non-empty and lies inside
`[0, D]`, the result is sorted, and no two cues overlap — so the studio can
speak them one after another and a subtitle track never shows two lines at
once.

`tests/node/test_deck.mjs` checks the shipped JavaScript against the same
statements.
-/

namespace Hesper.Cues

/-- A scheduled cue. -/
structure Cue where
  /-- When the line starts being spoken. -/
  t0 : ℝ
  /-- When it finishes. -/
  t1 : ℝ

/-- A request: when the author asked the line to start, and how long it takes
to speak.  The runtime clamps the requested start into the clip first, which
is the hypothesis `Ok` below. -/
abbrev Req := ℝ × ℝ

/-- A request the runtime can schedule: it starts inside the clip and has a
non-negative length. -/
def Ok (D : ℝ) (r : Req) : Prop := 0 ≤ r.1 ∧ r.1 ≤ D ∧ 0 ≤ r.2

/-- Lay out the requests one after another inside `[0, D]`, starting no
earlier than `free`.  A request with no room left is dropped, but it still
advances the clock, exactly as the runtime does. -/
noncomputable def place (D : ℝ) : ℝ → List Req → List Cue
  | _, [] => []
  | free, (t0, len) :: rest =>
    if max t0 free < min (max t0 free + len) D then
      ⟨max t0 free, min (max t0 free + len) D⟩ :: place D (min (max t0 free + len) D) rest
    else
      place D (min (max t0 free + len) D) rest

@[simp] theorem place_nil (D free : ℝ) : place D free [] = [] := rfl

theorem place_cons (D free t0 len : ℝ) (rest : List Req) :
    place D free ((t0, len) :: rest) =
      if max t0 free < min (max t0 free + len) D then
        ⟨max t0 free, min (max t0 free + len) D⟩ :: place D (min (max t0 free + len) D) rest
      else
        place D (min (max t0 free + len) D) rest := rfl

/-- Schedule a list of requests over a clip of length `D`. -/
noncomputable def normalize (D : ℝ) (l : List Req) : List Cue := place D 0 l

section
variable {D : ℝ}

/-- The clock the scheduler keeps stays inside the clip and moves forwards. -/
private theorem clock_bounds {free t0 len : ℝ} (hD : free ≤ D)
    (ht0 : 0 ≤ t0) (ht0D : t0 ≤ D) (hlen : 0 ≤ len) :
    max t0 free ≤ min (max t0 free + len) D ∧
      0 ≤ min (max t0 free + len) D ∧ min (max t0 free + len) D ≤ D := by
  have ha : max t0 free ≤ D := max_le ht0D hD
  have ha0 : 0 ≤ max t0 free := le_trans ht0 (le_max_left _ _)
  exact ⟨le_min (by linarith) ha, le_min (by linarith) (le_trans ha0 ha), min_le_right _ _⟩

/-- Every scheduled cue is non-empty, starts no earlier than the clock and
ends inside the clip. -/
theorem place_bounds : ∀ (l : List Req) {free : ℝ}, 0 ≤ free → free ≤ D →
    (∀ r ∈ l, Ok D r) → ∀ c ∈ place D free l, free ≤ c.t0 ∧ c.t0 < c.t1 ∧ c.t1 ≤ D
  | [], _, _, _, _, c, hc => by simp at hc
  | (t0, len) :: rest, free, hfree, hD, hok, c, hc => by
    obtain ⟨ht0, ht0D, hlen⟩ := hok (t0, len) (by simp)
    obtain ⟨hab, hb0, hbD⟩ := clock_bounds hD ht0 ht0D hlen
    have hrest : ∀ r ∈ rest, Ok D r := fun r hr => hok r (by simp [hr])
    have hfb : free ≤ min (max t0 free + len) D := le_trans (le_max_right _ _) hab
    rw [place_cons] at hc
    split at hc
    · rcases List.mem_cons.mp hc with rfl | hc'
      · exact ⟨le_max_right _ _, by assumption, min_le_right _ _⟩
      · obtain ⟨h1, h2, h3⟩ := place_bounds rest hb0 hbD hrest c hc'
        exact ⟨le_trans hfb h1, h2, h3⟩
    · obtain ⟨h1, h2, h3⟩ := place_bounds rest hb0 hbD hrest c hc
      exact ⟨le_trans hfb h1, h2, h3⟩

/-- No two scheduled cues overlap: each one ends before the next begins.  The
list is therefore also sorted by start time. -/
theorem place_pairwise : ∀ (l : List Req) {free : ℝ}, 0 ≤ free → free ≤ D →
    (∀ r ∈ l, Ok D r) → List.Pairwise (fun a b : Cue => a.t1 ≤ b.t0) (place D free l)
  | [], _, _, _, _ => by simp
  | (t0, len) :: rest, free, hfree, hD, hok => by
    obtain ⟨ht0, ht0D, hlen⟩ := hok (t0, len) (by simp)
    obtain ⟨hab, hb0, hbD⟩ := clock_bounds hD ht0 ht0D hlen
    have hrest : ∀ r ∈ rest, Ok D r := fun r hr => hok r (by simp [hr])
    rw [place_cons]
    split
    · refine List.Pairwise.cons ?_ (place_pairwise rest hb0 hbD hrest)
      intro c hc
      exact (place_bounds rest hb0 hbD hrest c hc).1
    · exact place_pairwise rest hb0 hbD hrest

/-- Every cue of a schedule is a non-empty interval inside the clip. -/
theorem normalize_bounds {l : List Req} (hD : 0 ≤ D) (hok : ∀ r ∈ l, Ok D r)
    {c : Cue} (hc : c ∈ normalize D l) : 0 ≤ c.t0 ∧ c.t0 < c.t1 ∧ c.t1 ≤ D :=
  place_bounds l le_rfl hD hok c hc

/-- A schedule is sorted and free of overlaps. -/
theorem normalize_pairwise {l : List Req} (hD : 0 ≤ D) (hok : ∀ r ∈ l, Ok D r) :
    List.Pairwise (fun a b : Cue => a.t1 ≤ b.t0) (normalize D l) :=
  place_pairwise l le_rfl hD hok

/-- Sorted by start time, as a corollary. -/
theorem normalize_sorted {l : List Req} (hD : 0 ≤ D) (hok : ∀ r ∈ l, Ok D r) :
    List.Pairwise (fun a b : Cue => a.t0 ≤ b.t0) (normalize D l) := by
  refine (normalize_pairwise hD hok).imp_of_mem ?_
  intro a b ha _ hab
  exact le_trans (normalize_bounds hD hok ha).2.1.le hab

/-- Two cues of a schedule never overlap, in whichever order they appear. -/
theorem normalize_disjoint {l : List Req} (hD : 0 ≤ D) (hok : ∀ r ∈ l, Ok D r)
    {a b : Cue} (ha : a ∈ normalize D l) (hb : b ∈ normalize D l) (hne : a ≠ b) :
    a.t1 ≤ b.t0 ∨ b.t1 ≤ a.t0 := by
  have hsym : Symmetric (fun a b : Cue => a.t1 ≤ b.t0 ∨ b.t1 ≤ a.t0) := by
    intro x y h; exact h.symm
  have hp : List.Pairwise (fun a b : Cue => a.t1 ≤ b.t0 ∨ b.t1 ≤ a.t0) (normalize D l) :=
    (normalize_pairwise hD hok).imp Or.inl
  exact hp.forall hsym ha hb hne

/-- At most one cue is being spoken at any time. -/
theorem normalize_unique_at {l : List Req} (hD : 0 ≤ D) (hok : ∀ r ∈ l, Ok D r)
    {t : ℝ} {a b : Cue} (ha : a ∈ normalize D l) (hb : b ∈ normalize D l)
    (hat : a.t0 ≤ t ∧ t < a.t1) (hbt : b.t0 ≤ t ∧ t < b.t1) : a = b := by
  by_contra hne
  rcases normalize_disjoint hD hok ha hb hne with h | h <;> linarith [hat.1, hat.2, hbt.1, hbt.2]

end

end Hesper.Cues
