import Mathlib

/-!
# Slide decks

The formal counterpart of `HesperDeck.slideSpans` / `deckDuration` /
`slideAt` / `transitionAlpha` (`web/js/deck.js`), which is what the
`slideshow` and `slide` playbook statements are built from.

A deck is a list of slide durations.  Slide `i` occupies the span from the
sum of the durations before it to that sum plus its own, so the spans tile
`[0, total]`: they are contiguous, they start at `0`, and the last one ends at
the total length of the deck — which is what the studio uses as the clip's
duration.  `slideAt` is the runtime's lookup (the last slide whose start is at
or before `t`, clamped at both ends) and `spans_cover` says it really returns
the slide that is on screen.

`tests/node/test_deck.mjs` checks the shipped JavaScript against the same
statements.
-/

namespace Hesper.Deck

/-- A slide's span on the clip's timeline. -/
structure Span where
  /-- When the slide starts. -/
  t0 : ℝ
  /-- When the next slide starts. -/
  t1 : ℝ

/-- The spans of a list of durations, laid out one after another from `acc`. -/
def spansFrom (acc : ℝ) : List ℝ → List Span
  | [] => []
  | d :: ds => ⟨acc, acc + d⟩ :: spansFrom (acc + d) ds

/-- The spans of a deck: slide `i` starts where slide `i-1` ended. -/
def spans (ds : List ℝ) : List Span := spansFrom 0 ds

/-- Total length of a deck. -/
def deckDuration (ds : List ℝ) : ℝ := ds.sum

/-- Which slide is on screen at time `t`: the last one whose start is at or
before `t`, so the first slide is used before the deck starts and the last one
is held after it ends. -/
noncomputable def slideAt : List Span → ℝ → ℕ
  | [], _ => 0
  | [_], _ => 0
  | _ :: s' :: rest, t => if s'.t0 ≤ t then 1 + slideAt (s' :: rest) t else 0

/-- Cross-fade weight of a slide's entrance: `0` before it starts, ramping to
`1` over `fade` seconds. -/
noncomputable def transitionAlpha (s : Span) (t fade : ℝ) : ℝ :=
  if fade ≤ 0 then 1 else max 0 (min 1 ((t - s.t0) / fade))

@[simp] theorem spansFrom_length (acc : ℝ) (ds : List ℝ) :
    (spansFrom acc ds).length = ds.length := by
  induction ds generalizing acc with
  | nil => simp [spansFrom]
  | cons d ds ih => simp [spansFrom, ih]

@[simp] theorem spans_length (ds : List ℝ) : (spans ds).length = ds.length := by
  simp [spans]

/-- The first slide starts where the deck does. -/
theorem spansFrom_head (acc : ℝ) {ds : List ℝ} (h : ds ≠ []) :
    ∃ s, (spansFrom acc ds).head? = some s ∧ s.t0 = acc := by
  cases ds with
  | nil => exact absurd rfl h
  | cons d ds => exact ⟨⟨acc, acc + d⟩, rfl, rfl⟩

/-- Each span has the length of its slide, and they follow one another. -/
theorem spansFrom_chain (acc : ℝ) (ds : List ℝ) :
    List.IsChain (fun a b : Span => a.t1 = b.t0) (spansFrom acc ds) := by
  induction ds generalizing acc with
  | nil => simp [spansFrom]
  | cons d ds ih =>
    cases ds with
    | nil => simp [spansFrom]
    | cons e es =>
      exact List.IsChain.cons_cons rfl (ih (acc + d))

/-- The deck ends exactly at the sum of its slide durations. -/
theorem spansFrom_last (acc : ℝ) {ds : List ℝ} (h : ds ≠ []) :
    ∃ s, (spansFrom acc ds).getLast? = some s ∧ s.t1 = acc + ds.sum := by
  induction ds generalizing acc with
  | nil => exact absurd rfl h
  | cons d ds ih =>
    cases ds with
    | nil => exact ⟨⟨acc, acc + d⟩, rfl, by simp⟩
    | cons e es =>
      obtain ⟨s, hs, hval⟩ := ih (acc := acc + d) (by simp)
      have hcons : spansFrom (acc + d) (e :: es)
          = ⟨acc + d, acc + d + e⟩ :: spansFrom (acc + d + e) es := rfl
      refine ⟨s, ?_, by rw [hval]; simp [List.sum_cons]; ring⟩
      show (⟨acc, acc + d⟩ :: spansFrom (acc + d) (e :: es)).getLast? = some s
      rw [hcons] at hs ⊢
      rw [List.getLast?_cons_cons]
      exact hs

/-- The deck ends at `deckDuration`. -/
theorem spans_last {ds : List ℝ} (h : ds ≠ []) :
    ∃ s, (spans ds).getLast? = some s ∧ s.t1 = deckDuration ds := by
  simpa [spans, deckDuration] using spansFrom_last 0 h

/-- Every slide of a deck of positive durations is a non-empty span inside
`[acc, acc + total]`. -/
theorem spansFrom_mem_bounds {acc : ℝ} {ds : List ℝ} (hpos : ∀ d ∈ ds, 0 < d)
    {s : Span} (hs : s ∈ spansFrom acc ds) :
    acc ≤ s.t0 ∧ s.t0 < s.t1 ∧ s.t1 ≤ acc + ds.sum := by
  induction ds generalizing acc with
  | nil => simp [spansFrom] at hs
  | cons d ds ih =>
    have hd : 0 < d := hpos d (by simp)
    have hrest : ∀ x ∈ ds, 0 < x := fun x hx => hpos x (by simp [hx])
    have hsum : 0 ≤ ds.sum := List.sum_nonneg fun x hx => (hrest x hx).le
    rw [show spansFrom acc (d :: ds) = ⟨acc, acc + d⟩ :: spansFrom (acc + d) ds from rfl] at hs
    rcases List.mem_cons.mp hs with rfl | hs'
    · exact ⟨le_rfl, by simpa using hd, by simp [List.sum_cons]; linarith⟩
    · obtain ⟨h1, h2, h3⟩ := ih hrest hs'
      exact ⟨by linarith, h2, by simp [List.sum_cons] at h3 ⊢; linarith⟩

/-- The lookup never leaves the deck. -/
theorem slideAt_lt_length : ∀ (l : List Span) (t : ℝ), l ≠ [] → slideAt l t < l.length
  | [], _, h => absurd rfl h
  | [_], _, _ => by simp [slideAt]
  | s :: s' :: rest, t, _ => by
    rw [show slideAt (s :: s' :: rest) t
        = if s'.t0 ≤ t then 1 + slideAt (s' :: rest) t else 0 from rfl]
    split
    · have := slideAt_lt_length (s' :: rest) t (by simp)
      simp only [List.length_cons] at *
      omega
    · simp

/-- `slideAt` really finds the slide that is on screen: for a deck of positive
durations, any time inside the deck lands in the span it names. -/
theorem spansFrom_cover {acc : ℝ} : ∀ {ds : List ℝ}, (∀ d ∈ ds, 0 < d) → ds ≠ [] →
    ∀ {t : ℝ}, acc ≤ t → t < acc + ds.sum →
    ∃ s, (spansFrom acc ds)[slideAt (spansFrom acc ds) t]? = some s ∧ s.t0 ≤ t ∧ t < s.t1
  | [], _, h, _, _, _ => absurd rfl h
  | [d], _, _, t, h0, h1 => by
    refine ⟨⟨acc, acc + d⟩, ?_, h0, by simpa using h1⟩
    simp [spansFrom, slideAt]
  | d :: e :: es, hpos, _, t, h0, h1 => by
    have hrest : ∀ x ∈ e :: es, 0 < x := fun x hx => hpos x (by simp [hx])
    rw [show spansFrom acc (d :: e :: es)
        = ⟨acc, acc + d⟩ :: spansFrom (acc + d) (e :: es) from rfl]
    have hhead : (spansFrom (acc + d) (e :: es)).head? = some ⟨acc + d, acc + d + e⟩ := rfl
    rw [show slideAt (⟨acc, acc + d⟩ :: spansFrom (acc + d) (e :: es)) t
        = if (acc + d) ≤ t then 1 + slideAt (spansFrom (acc + d) (e :: es)) t else 0 from by
          rw [show spansFrom (acc + d) (e :: es)
              = ⟨acc + d, acc + d + e⟩ :: spansFrom (acc + d + e) es from rfl]
          rfl]
    split
    · rename_i hle
      have h1' : t < (acc + d) + (e :: es).sum := by
        simp [List.sum_cons] at h1 ⊢; linarith
      obtain ⟨s, hs, hs0, hs1⟩ := spansFrom_cover (acc := acc + d) hrest (by simp) hle h1'
      refine ⟨s, ?_, hs0, hs1⟩
      rw [Nat.add_comm]
      simpa using hs
    · rename_i hgt
      exact ⟨⟨acc, acc + d⟩, by simp, h0, by push_neg at hgt; exact hgt⟩

/-- The same, for a deck laid out from `0`. -/
theorem spans_cover {ds : List ℝ} (hpos : ∀ d ∈ ds, 0 < d) (hne : ds ≠ [])
    {t : ℝ} (h0 : 0 ≤ t) (h1 : t < deckDuration ds) :
    ∃ s, (spans ds)[slideAt (spans ds) t]? = some s ∧ s.t0 ≤ t ∧ t < s.t1 := by
  simpa [spans] using spansFrom_cover (acc := 0) hpos hne h0 (by simpa [deckDuration] using h1)

/-- A transition weight is a weight: it lies in `[0, 1]`. -/
theorem transitionAlpha_mem (s : Span) (t fade : ℝ) :
    0 ≤ transitionAlpha s t fade ∧ transitionAlpha s t fade ≤ 1 := by
  unfold transitionAlpha
  split
  · exact ⟨zero_le_one, le_rfl⟩
  · exact ⟨le_max_left _ _, max_le zero_le_one (min_le_left _ _)⟩

/-- A slide enters closed. -/
@[simp] theorem transitionAlpha_start (s : Span) {fade : ℝ} (h : 0 < fade) :
    transitionAlpha s s.t0 fade = 0 := by
  rw [transitionAlpha, if_neg (not_le.mpr h)]
  simp

/-- It is fully open once the fade has run. -/
theorem transitionAlpha_after (s : Span) {t fade : ℝ} (h : 0 < fade) (ht : s.t0 + fade ≤ t) :
    transitionAlpha s t fade = 1 := by
  have h1 : 1 ≤ (t - s.t0) / fade := (one_le_div h).mpr (by linarith)
  rw [transitionAlpha, if_neg (not_le.mpr h), min_eq_left h1, max_eq_right zero_le_one]

/-- A cut is instant. -/
@[simp] theorem transitionAlpha_cut (s : Span) (t : ℝ) : transitionAlpha s t 0 = 1 := by
  simp [transitionAlpha]

/-- The fade never runs backwards. -/
theorem transitionAlpha_mono (s : Span) {t t' fade : ℝ} (h : t ≤ t') :
    transitionAlpha s t fade ≤ transitionAlpha s t' fade := by
  unfold transitionAlpha
  split
  · exact le_rfl
  · rename_i hf
    push_neg at hf
    have : (t - s.t0) / fade ≤ (t' - s.t0) / fade := by gcongr
    exact max_le_max le_rfl (min_le_min le_rfl this)

end Hesper.Deck
