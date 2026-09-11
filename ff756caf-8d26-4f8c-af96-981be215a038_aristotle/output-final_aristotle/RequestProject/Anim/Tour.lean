import Mathlib

/-!
# Getting started: the guided demo, and a reader's own pages

The formal counterpart of `web/js/tour.js` and `web/js/wiki.js` — the two
things a first-time reader meets: a demo that walks through the studio, and an
offer to make a rendering out of the Wikipedia articles they have edited.

What is proved here is what those two files promise:

*The demo cannot walk off its own script.*  `clamp_lt`, `clamp_idem`,
`next_le_last`, `prev_next` — a cursor is always a step of the tour, moving on
from the last step stays there, and stepping back after stepping on is where
you were.

*The demo never shows an empty stage.*  `shown_isSome` — a step that brings no
playbook of its own keeps the one before it, so as long as the first step has a
playbook, every step has one.

*Nobody's quiet month is deleted.*  `buckets_length`, `buckets_sum`,
`buckets_get` — the contribution chart has one bucket per calendar month
between the first edit and the last, every edit is counted exactly once, and a
month with no edits is a zero rather than a gap, which is what stops a pause
from looking like activity.

*A polyline means the same thing however it is written.*
`pairUp_flatten`, `flatten_pairUp` — a script may hand over one flat run of
coordinates or a list of pairs, and the two spellings are the same picture.

*Text from a stranger's article cannot escape into the playbook.*
`escape_no_quote`, `escape_no_brace`, `escape_no_newline`, `escape_idem` — a
title carrying `"` would close a string, and one carrying `{…}` would be read
as a live hole and evaluated; after escaping, neither is there, and escaping
again changes nothing.

`tests/node/test_tour.mjs` and `tests/node/test_wiki.mjs` check the shipped
JavaScript against the same statements.
-/

namespace Hesper.Tour

/-! ## The cursor

The demo is a list of `n` steps and a cursor into it.  Every movement goes
through `clamp`, so the cursor is a step of the tour by construction rather
than by the caller remembering to check. -/

/-- The cursor, forced into a tour of `n` steps. -/
def clamp (n i : ℕ) : ℕ := min i (n - 1)

/-- A clamped cursor is a step of the tour. -/
theorem clamp_lt {n : ℕ} (h : 0 < n) (i : ℕ) : clamp n i < n := by
  unfold clamp
  omega

/-- Clamping an already-clamped cursor changes nothing. -/
@[simp] theorem clamp_idem (n i : ℕ) : clamp n (clamp n i) = clamp n i := by
  unfold clamp
  omega

/-- A cursor already inside the tour is left alone. -/
theorem clamp_of_lt {n i : ℕ} (h : i < n) : clamp n i = i := by
  unfold clamp
  omega

/-- On to the next step — never past the end. -/
def next (n i : ℕ) : ℕ := clamp n (clamp n i + 1)

/-- Back to the previous step — never before the start. -/
def prev (n i : ℕ) : ℕ := clamp n i - 1

theorem next_lt {n : ℕ} (h : 0 < n) (i : ℕ) : next n i < n := clamp_lt h _

theorem prev_lt {n : ℕ} (h : 0 < n) (i : ℕ) : prev n i < n := by
  have := clamp_lt h i
  unfold prev
  omega

/-- The tour moves forward, or stays where it is; it never jumps back. -/
theorem le_next (n i : ℕ) : clamp n i ≤ next n i := by
  unfold next clamp
  omega

/-- The last step is a fixed point: pressing *next* there does not fall off. -/
@[simp] theorem next_last (n : ℕ) : next n (n - 1) = n - 1 := by
  unfold next clamp
  omega

/-- Stepping back from the first step stays on the first step. -/
@[simp] theorem prev_first (n : ℕ) : prev n 0 = 0 := by
  unfold prev clamp
  omega

/-- Back after forward is where you were — anywhere but the last step. -/
theorem prev_next {n i : ℕ} (h : i + 1 < n) : prev n (next n i) = i := by
  unfold prev next clamp
  omega

/-! ## What is on the stage

A step of the demo may bring a playbook of its own or not.  `shown` is what the
stage holds at a step: the most recent playbook at or before it. -/

variable {α : Type*}

/-- The playbook on the stage at step `i` of the script `l`. -/
def shown (l : List (Option α)) : ℕ → Option α
  | 0 => (l[0]?).join
  | i + 1 => match (l[i + 1]?).join with
    | some a => some a
    | none => shown l i

/-- A step that brings its own playbook shows that one. -/
theorem shown_of_some {l : List (Option α)} {i : ℕ} {a : α}
    (h : (l[i]?).join = some a) : shown l i = some a := by
  cases i with
  | zero => simpa [shown] using h
  | succ k => simp [shown, h]

/-- A step that brings none keeps the one before it. -/
theorem shown_of_none {l : List (Option α)} {i : ℕ}
    (h : (l[i + 1]?).join = none) : shown l (i + 1) = shown l i := by
  simp [shown, h]

/-- **The stage is never blank.**  If the demo opens with a playbook, then
every step of it has one, whether or not that step brought its own. -/
theorem shown_isSome {l : List (Option α)} {a : α}
    (h : (l[0]?).join = some a) (i : ℕ) : (shown l i).isSome := by
  induction i with
  | zero => simp [shown, h]
  | succ k ih =>
    unfold shown
    cases hk : (l[k + 1]?).join with
    | none => simpa [hk] using ih
    | some b => simp

/-! ## The contribution chart

The reader's own rhythm is the number of edits in each calendar month, counted
from the public contribution list.  A month is an index (`12 * year + month`),
so the chart is a list of counts over a range of indices. -/

/-- How many of these edits fall in month `m`. -/
def bucketCount (ts : List ℕ) (m : ℕ) : ℕ := (ts.filter (fun t => t = m)).length

/-- One bucket per month from `lo` to `hi`, the quiet ones included. -/
def buckets (lo hi : ℕ) (ts : List ℕ) : List ℕ :=
  (List.range (hi + 1 - lo)).map (fun k => bucketCount ts (lo + k))

/-- **No month is dropped**: the chart is exactly as wide as the span it covers. -/
@[simp] theorem buckets_length (lo hi : ℕ) (ts : List ℕ) :
    (buckets lo hi ts).length = hi + 1 - lo := by
  simp [buckets]

/-- Every month of the span has its own bucket, holding its own count. -/
theorem buckets_get {lo hi : ℕ} (ts : List ℕ) {k : ℕ} (hk : k < hi + 1 - lo) :
    (buckets lo hi ts)[k]! = bucketCount ts (lo + k) := by
  have : k < (List.range (hi + 1 - lo)).length := by simpa using hk
  simp [buckets, List.getElem!_eq_getElem?_getD, List.getElem?_map,
    List.getElem?_eq_getElem this]

/-- **Every edit is counted exactly once**, provided the span covers them all. -/
theorem buckets_sum {lo hi : ℕ} {ts : List ℕ}
    (h : ∀ t ∈ ts, lo ≤ t ∧ t ≤ hi) : (buckets lo hi ts).sum = ts.length := by
  induction ts with
  | nil => simp [buckets, bucketCount]
  | cons t rest ih =>
    have ht : lo ≤ t ∧ t ≤ hi := h t (by simp)
    have hrest : ∀ u ∈ rest, lo ≤ u ∧ u ≤ hi := fun u hu => h u (by simp [hu])
    have hsplit : buckets lo hi (t :: rest)
        = (List.range (hi + 1 - lo)).map
            (fun k => (if t = lo + k then 1 else 0) + bucketCount rest (lo + k)) := by
      unfold buckets bucketCount
      refine List.map_congr_left ?_
      intro k _
      by_cases hk : t = lo + k
      · simp [List.filter, hk]
        omega
      · simp [List.filter, hk]
    have hsum : ((List.range (hi + 1 - lo)).map
        (fun k => (if t = lo + k then 1 else 0) + bucketCount rest (lo + k))).sum
        = ((List.range (hi + 1 - lo)).map (fun k => if t = lo + k then 1 else 0)).sum
          + ((List.range (hi + 1 - lo)).map (fun k => bucketCount rest (lo + k))).sum := by
      induction (List.range (hi + 1 - lo)) with
      | nil => simp
      | cons a as iha => simp [iha]; omega
    have hone : ((List.range (hi + 1 - lo)).map (fun k => if t = lo + k then 1 else 0)).sum = 1 := by
      have hrange : ((List.range (hi + 1 - lo)).map (fun k => if t = lo + k then 1 else 0)).sum
          = ∑ k ∈ Finset.range (hi + 1 - lo), (if t = lo + k then 1 else 0) := rfl
      rw [hrange, Finset.sum_eq_single (t - lo)]
      · have hlo : lo + (t - lo) = t := by omega
        simp [hlo]
      · intro b _ hb
        have : t ≠ lo + b := by omega
        simp [this]
      · intro hmem
        exact absurd (by simp only [Finset.mem_range]; omega) hmem
    have hb : buckets lo hi rest
        = (List.range (hi + 1 - lo)).map (fun k => bucketCount rest (lo + k)) := rfl
    rw [hsplit, hsum, hone, ← hb, ih hrest]
    simp only [List.length_cons]
    omega

/-! ## Two ways to write a polyline

A script hands the studio a polyline either as one flat run of numbers, `x`
and `y` alternating, or as a list of `[x, y]` pairs; both spellings appear in
the shipped playbooks, and the reading of a harvested page uses the second.
The two are the same picture: pairing a flattened list up again returns it,
and flattening a paired-up list returns it whenever it had a whole number of
points in it to begin with. -/

/-- A list of points, written out as one run of coordinates. -/
def flatten : List (α × α) → List α
  | [] => []
  | (x, y) :: rest => x :: y :: flatten rest

/-- A run of coordinates, read back as points; a trailing odd one is dropped. -/
def pairUp : List α → List (α × α)
  | x :: y :: rest => (x, y) :: pairUp rest
  | _ => []

/-- Reading back what was written out gives the same points. -/
@[simp] theorem pairUp_flatten (ps : List (α × α)) : pairUp (flatten ps) = ps := by
  induction ps with
  | nil => rfl
  | cons p rest ih =>
    obtain ⟨x, y⟩ := p
    simp [flatten, pairUp, ih]

/-- And writing out what was read back gives the same run, provided the run
held a whole number of points. -/
theorem flatten_pairUp (l : List α) (h : l.length % 2 = 0) : flatten (pairUp l) = l := by
  induction l using pairUp.induct with
  | case1 x y rest ih =>
    have hrest : rest.length % 2 = 0 := by
      simp only [List.length_cons] at h
      omega
    simp [pairUp, flatten, ih hrest]
  | case2 l hl =>
    match l, hl with
    | [], _ => rfl
    | [x], _ => simp at h
    | x :: y :: rest, hl => exact absurd rfl (hl x y rest)

/-! ## Escaping a stranger's words

An article title, a table caption or a column header goes into the playbook the
studio writes.  Inside a `"…"` a quote would end the string, a newline would end
the statement, and `{…}` is a *hole*: the playbook language evaluates what is
inside it every frame.  None of the three may survive. -/

/-- A quote becomes a typographic quote; a line break becomes a space. -/
def substChar (c : Char) : Char :=
  if c = '"' then '”' else if c = '\n' ∨ c = '\r' then ' ' else c

/-- A brace is dropped: a hole is not something a stranger gets to open. -/
def keepChar (c : Char) : Bool := ! (c = '{' || c = '}')

/-- Text from elsewhere, made safe to write inside a playbook string. -/
def escape (s : List Char) : List Char := (s.map substChar).filter keepChar

@[simp] theorem substChar_ne_quote (c : Char) : substChar c ≠ '"' := by
  unfold substChar
  split
  · decide
  · split
    · decide
    · assumption

@[simp] theorem substChar_ne_newline (c : Char) : substChar c ≠ '\n' := by
  unfold substChar
  split
  · decide
  · split
    · decide
    · tauto

/-- Substituting twice is substituting once: `”` and a space are fixed. -/
theorem substChar_idem (c : Char) : substChar (substChar c) = substChar c := by
  by_cases h1 : c = '"'
  · subst h1
    show substChar '”' = '”'
    decide
  · by_cases h2 : c = '\n' ∨ c = '\r'
    · have hs : substChar c = ' ' := by unfold substChar; simp [h1, h2]
      rw [hs]
      decide
    · have hs : substChar c = c := by
        unfold substChar
        simp only [if_neg h1]
        rw [if_neg h2]
      rw [hs]
      exact hs

/-- The escaped text carries no quote, so it cannot end the string it is in. -/
theorem escape_no_quote (s : List Char) : '"' ∉ escape s := by
  intro h
  unfold escape at h
  obtain ⟨c, _, hc⟩ := List.mem_map.mp (List.mem_of_mem_filter h)
  exact substChar_ne_quote c hc

/-- Nor a line break, so it cannot end the statement it is in. -/
theorem escape_no_newline (s : List Char) : '\n' ∉ escape s := by
  intro h
  unfold escape at h
  obtain ⟨c, _, hc⟩ := List.mem_map.mp (List.mem_of_mem_filter h)
  exact substChar_ne_newline c hc

/-- Nor a brace, so it cannot open a hole that would then be evaluated. -/
theorem escape_no_brace (s : List Char) : '{' ∉ escape s ∧ '}' ∉ escape s := by
  constructor <;>
  · intro h
    unfold escape at h
    have := List.of_mem_filter h
    simp [keepChar] at this

/-- Escaping already-escaped text changes nothing. -/
theorem escape_idem (s : List Char) : escape (escape s) = escape s := by
  have hfix : ∀ c ∈ escape s, substChar c = c := by
    intro c hc
    unfold escape at hc
    obtain ⟨d, _, hd⟩ := List.mem_map.mp (List.mem_of_mem_filter hc)
    rw [← hd]
    exact substChar_idem d
  have hmap : (escape s).map substChar = escape s := by
    calc (escape s).map substChar
        = (escape s).map id := List.map_congr_left (fun c hc => by simpa using hfix c hc)
      _ = escape s := List.map_id _
  calc escape (escape s) = ((escape s).map substChar).filter keepChar := rfl
    _ = (escape s).filter keepChar := by rw [hmap]
    _ = escape s := by unfold escape; simp [List.filter_filter]

end Hesper.Tour
