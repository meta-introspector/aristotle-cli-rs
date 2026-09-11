/-
# Interval gluing, and conflict certificates

The tolerance relation `|x - y| ≤ ε` is reflexive and symmetric but not
transitive, so it cannot glue.  What glues is a *feasible set*: each local
report assigns to a cell the interval of values consistent with it, restriction
is projection onto the cells of an overlap, and compatibility is nonempty
intersection.

In one dimension the Helly property holds — pairwise compatibility implies a
common point — and it is proved here (`helly_of_pairwise`).  Since cells are
independent coordinates, the same argument applies coordinatewise to product
intervals, which is what a supply/disposition account is.  For general convex
constraints in `ℝⁿ` pairwise compatibility is *not* enough (Helly needs
`(n+1)`-wise intersection), and that boundary is recorded here rather than
quietly assumed away.

Failure is informative: `glueAt` returns `inconsistent` only when two of the
local intervals are actually separated, and `inconsistent_witness` produces
that pair.  A third party can recheck the pair without redoing the gluing.
-/
import RequestProject.Economy.Accounting

namespace RequestProject.Economy

/-- The lines of a supply/disposition account, used as coordinates. -/
inductive Line where
  | openingStock | production | imports | otherSupply
  | exports | intermediateUse | finalConsumption | losses | otherDisposition | closingStock
deriving DecidableEq, Repr

/-- A cell is one coordinate of the reconstruction: commodity, region, period,
account line.  Two reports overlap exactly when they constrain a common cell. -/
structure Cell where
  commodity : Commodity
  region : RegionCode
  period : Period
  line : Line
deriving DecidableEq, Repr

/-! ### Gluing a list of intervals -/

namespace Interval

/-- The greatest lower endpoint of a nonempty list of intervals. -/
def maxLo (i : Interval) : List Interval → ℚ
  | [] => i.lo
  | j :: t => max i.lo (maxLo j t)

/-- The least upper endpoint of a nonempty list of intervals. -/
def minHi (i : Interval) : List Interval → ℚ
  | [] => i.hi
  | j :: t => min i.hi (minHi j t)

theorem lo_le_maxLo (i : Interval) (t : List Interval) : ∀ k ∈ i :: t, k.lo ≤ maxLo i t := by
  induction t generalizing i with
  | nil => intro k hk; rcases List.mem_singleton.mp hk with rfl; exact le_refl _
  | cons j s ih =>
      intro k hk
      rcases List.mem_cons.mp hk with rfl | hk
      · exact le_max_left _ _
      · exact le_trans (ih j k hk) (le_max_right _ _)

theorem minHi_le_hi (i : Interval) (t : List Interval) : ∀ k ∈ i :: t, minHi i t ≤ k.hi := by
  induction t generalizing i with
  | nil => intro k hk; rcases List.mem_singleton.mp hk with rfl; exact le_refl _
  | cons j s ih =>
      intro k hk
      rcases List.mem_cons.mp hk with rfl | hk
      · exact min_le_left _ _
      · exact le_trans (min_le_right _ _) (ih j k hk)

theorem maxLo_mem (i : Interval) (t : List Interval) : ∃ k ∈ i :: t, maxLo i t = k.lo := by
  induction t generalizing i with
  | nil => exact ⟨i, by simp, rfl⟩
  | cons j s ih =>
      obtain ⟨k, hk, hkeq⟩ := ih j
      rcases max_cases i.lo (maxLo j s) with ⟨h1, _⟩ | ⟨h1, _⟩
      · exact ⟨i, by simp, by rw [maxLo, h1]⟩
      · exact ⟨k, List.mem_cons_of_mem _ hk, by rw [maxLo, h1, hkeq]⟩

theorem minHi_mem (i : Interval) (t : List Interval) : ∃ k ∈ i :: t, minHi i t = k.hi := by
  induction t generalizing i with
  | nil => exact ⟨i, by simp, rfl⟩
  | cons j s ih =>
      obtain ⟨k, hk, hkeq⟩ := ih j
      rcases min_cases i.hi (minHi j s) with ⟨h1, _⟩ | ⟨h1, _⟩
      · exact ⟨i, by simp, by rw [minHi, h1]⟩
      · exact ⟨k, List.mem_cons_of_mem _ hk, by rw [minHi, h1, hkeq]⟩

/-- A value lies in every interval of the list exactly when it lies between the
greatest lower and the least upper endpoint. -/
theorem mem_all_iff (i : Interval) (t : List Interval) (x : ℚ) :
    (∀ k ∈ i :: t, x ∈ k) ↔ (maxLo i t ≤ x ∧ x ≤ minHi i t) := by
  constructor
  · intro h
    obtain ⟨k, hk, hkeq⟩ := maxLo_mem i t
    obtain ⟨m, hm, hmeq⟩ := minHi_mem i t
    exact ⟨by rw [hkeq]; exact (h k hk).1, by rw [hmeq]; exact (h m hm).2⟩
  · rintro ⟨h1, h2⟩ k hk
    exact ⟨le_trans (lo_le_maxLo i t k hk) h1, le_trans h2 (minHi_le_hi i t k hk)⟩

/-- **Helly in one dimension.** Pairwise compatible intervals have a common
point. -/
theorem helly_of_pairwise {i : Interval} {t : List Interval}
    (h : ∀ a ∈ i :: t, ∀ b ∈ i :: t, Overlaps a b) : ∃ x, ∀ k ∈ i :: t, x ∈ k := by
  obtain ⟨k, hk, hkeq⟩ := maxLo_mem i t
  obtain ⟨m, hm, hmeq⟩ := minHi_mem i t
  refine ⟨maxLo i t, (mem_all_iff i t _).mpr ⟨le_refl _, ?_⟩⟩
  rw [hkeq, hmeq]
  exact (h k hk m hm).1

/-- The converse direction, which is what makes a conflict certificate
meaningful: no common point means two of the intervals are separated. -/
theorem exists_separated_of_no_common_point {i : Interval} {t : List Interval}
    (h : ¬ ∃ x, ∀ k ∈ i :: t, x ∈ k) :
    ∃ a ∈ i :: t, ∃ b ∈ i :: t, Separated a b := by
  by_contra hc
  push_neg at hc
  refine h (helly_of_pairwise ?_)
  intro a ha b hb
  exact separated_iff_not_overlaps.not_left.mp (hc a ha b hb)

end Interval

/-- The outcome of gluing the local constraints on one cell. -/
inductive GluingResult where
  /-- The local reports agree; this is the interval of values they all allow. -/
  | glued (I : Interval)
  /-- Two of the local reports are separated; there is no consistent value. -/
  | inconsistent
  /-- No local report constrains this cell. -/
  | insufficientCoverage
deriving Repr, DecidableEq

/-- Glue a list of local interval constraints on a single cell. -/
def glueAt : List Interval → GluingResult
  | [] => GluingResult.insufficientCoverage
  | i :: t =>
      if h : Interval.maxLo i t ≤ Interval.minHi i t then
        GluingResult.glued ⟨Interval.maxLo i t, Interval.minHi i t, h⟩
      else
        GluingResult.inconsistent

/-- **The glued interval is exactly the set of consistent values.**  Nothing is
averaged away and nothing is invented: `I` contains a value iff every local
report allows it. -/
theorem glueAt_glued_iff {l : List Interval} {I : Interval} (h : glueAt l = GluingResult.glued I)
    (x : ℚ) : x ∈ I ↔ ∀ k ∈ l, x ∈ k := by
  cases l with
  | nil => simp [glueAt] at h
  | cons i t =>
      simp only [glueAt] at h
      split at h
      · injection h with h
        subst h
        exact (Interval.mem_all_iff i t x).symm
      · exact absurd h (by simp)

/-- **A conflict result carries a witness.** If gluing fails, two of the local
intervals really are separated — a fact a third party can recheck on its own. -/
theorem glueAt_inconsistent_witness {l : List Interval} (h : glueAt l = GluingResult.inconsistent) :
    ∃ a ∈ l, ∃ b ∈ l, Interval.Separated a b := by
  cases l with
  | nil => simp [glueAt] at h
  | cons i t =>
      apply Interval.exists_separated_of_no_common_point
      rintro ⟨x, hx⟩
      rw [Interval.mem_all_iff] at hx
      have hle : Interval.maxLo i t ≤ Interval.minHi i t := le_trans hx.1 hx.2
      rw [glueAt, dif_pos hle] at h
      exact absurd h (by simp)

/-- Gluing succeeds precisely when the local reports are pairwise compatible. -/
theorem glueAt_glued_of_pairwise {i : Interval} {t : List Interval}
    (h : ∀ a ∈ i :: t, ∀ b ∈ i :: t, Interval.Overlaps a b) :
    ∃ I, glueAt (i :: t) = GluingResult.glued I := by
  obtain ⟨x, hx⟩ := Interval.helly_of_pairwise h
  rw [Interval.mem_all_iff] at hx
  have hle : Interval.maxLo i t ≤ Interval.minHi i t := le_trans hx.1 hx.2
  exact ⟨⟨Interval.maxLo i t, Interval.minHi i t, hle⟩, by rw [glueAt, dif_pos hle]⟩

/-- **Monotonicity: evidence never widens the accepted set.** Gluing a longer
list of reports admits no value that the shorter list rejected. -/
theorem glueAt_mono {l l' : List Interval} (hsub : ∀ k ∈ l, k ∈ l') {I I' : Interval}
    (h : glueAt l = GluingResult.glued I) (h' : glueAt l' = GluingResult.glued I') {x : ℚ}
    (hx : x ∈ I') : x ∈ I :=
  (glueAt_glued_iff h x).mpr fun k hk => (glueAt_glued_iff h' x).mp hx k (hsub k hk)

/-! ### Sites, local sections and covers -/

/-- A local section: one reporting context and the interval constraints it
supplies. -/
structure LocalSection where
  site : String
  constraints : List (Cell × Interval)

namespace LocalSection

/-- The constraint this section places on a cell, if any. -/
def value? (s : LocalSection) (c : Cell) : Option Interval :=
  (s.constraints.find? (fun p => p.1 = c)).map Prod.snd

/-- Restriction to a set of cells — projection onto an overlap. -/
def restrict (s : LocalSection) (cells : List Cell) : LocalSection :=
  { site := s.site, constraints := s.constraints.filter (fun p => p.1 ∈ cells) }

@[simp] theorem restrict_site (s : LocalSection) (cells : List Cell) :
    (s.restrict cells).site = s.site := rfl

/-- Restriction keeps exactly the constraints on the cells restricted to. -/
theorem find?_filter_key (l : List (Cell × Interval)) (cells : List Cell) (c : Cell) :
    ((l.filter (fun p => p.1 ∈ cells)).find? (fun p => p.1 = c)).map Prod.snd
      = if c ∈ cells then ((l.find? (fun p => p.1 = c)).map Prod.snd) else none := by
  induction l with
  | nil => by_cases h : c ∈ cells <;> simp [h]
  | cons p t ih =>
      by_cases hmem : p.1 ∈ cells
      · rw [List.filter_cons_of_pos (by simpa using hmem)]
        by_cases hkey : p.1 = c
        · subst hkey
          rw [List.find?_cons_of_pos (by simp), List.find?_cons_of_pos (by simp)]
          simp [hmem]
        · rw [List.find?_cons_of_neg (by simpa using hkey),
            List.find?_cons_of_neg (by simpa using hkey)]
          exact ih
      · rw [List.filter_cons_of_neg (by simpa using hmem)]
        by_cases hkey : p.1 = c
        · subst hkey
          rw [List.find?_cons_of_pos (by simp)]
          simp only [hmem, if_false] at ih ⊢
          exact ih
        · rw [List.find?_cons_of_neg (by simpa using hkey)]
          exact ih

theorem value?_restrict (s : LocalSection) (cells : List Cell) (c : Cell) :
    (s.restrict cells).value? c = if c ∈ cells then s.value? c else none :=
  find?_filter_key s.constraints cells c

/-- Restriction is functorial: restricting twice, to a smaller set of cells
second, is restricting once. -/
theorem value?_restrict_restrict (s : LocalSection) (big small : List Cell)
    (hsub : ∀ c ∈ small, c ∈ big) (c : Cell) :
    ((s.restrict big).restrict small).value? c = (s.restrict small).value? c := by
  rw [value?_restrict, value?_restrict, value?_restrict]
  by_cases h : c ∈ small
  · simp [h, hsub c h]
  · simp [h]

end LocalSection

/-- A cover is a list of local sections. -/
abbrev Cover := List LocalSection

/-- All the constraints the cover places on a cell. -/
def constraintsAt (cover : Cover) (c : Cell) : List Interval :=
  cover.filterMap (fun s => s.value? c)

/-- The cover is compatible at a cell when its constraints there are pairwise
overlapping. -/
def CompatibleAt (cover : Cover) (c : Cell) : Prop :=
  ∀ a ∈ constraintsAt cover c, ∀ b ∈ constraintsAt cover c, Interval.Overlaps a b

instance (cover : Cover) (c : Cell) : Decidable (CompatibleAt cover c) := by
  unfold CompatibleAt; infer_instance

/-- Glue the cover at a cell. -/
def glue (cover : Cover) (c : Cell) : GluingResult := glueAt (constraintsAt cover c)

/-- A global section over a list of cells: a value for each cell that satisfies
every local constraint on it. -/
def IsGlobalSection (cover : Cover) (cells : List Cell) (f : Cell → ℚ) : Prop :=
  ∀ c ∈ cells, ∀ i ∈ constraintsAt cover c, f c ∈ i

/-- **Gluing, coordinatewise.**  If the cover is compatible at every cell of a
list, a global section over those cells exists — and it is constructed, not
merely asserted. -/
theorem exists_globalSection {cover : Cover} {cells : List Cell}
    (h : ∀ c ∈ cells, CompatibleAt cover c) :
    ∃ f : Cell → ℚ, IsGlobalSection cover cells f := by
  classical
  refine ⟨fun c =>
    match hc : constraintsAt cover c with
    | [] => 0
    | i :: t => Interval.maxLo i t, ?_⟩
  intro c hc i hi
  revert hi
  simp only
  split
  · rename_i hnil
    rw [hnil]
    exact fun hi => absurd hi (by simp)
  · rename_i j t hcons
    intro hi
    have hpair : ∀ a ∈ j :: t, ∀ b ∈ j :: t, Interval.Overlaps a b := by
      rw [← hcons]; exact h c hc
    obtain ⟨x, hx⟩ := Interval.helly_of_pairwise hpair
    rw [Interval.mem_all_iff] at hx
    rw [hcons] at hi
    exact (Interval.mem_all_iff j t _).mpr ⟨le_refl _, le_trans hx.1 hx.2⟩ i hi

/-- **A failed gluing is a result, not an apology.**  When the cover fails to
glue at a cell, two of the reports on that cell are separated. -/
theorem glue_conflict_witness {cover : Cover} {c : Cell}
    (h : glue cover c = GluingResult.inconsistent) :
    ∃ a ∈ constraintsAt cover c, ∃ b ∈ constraintsAt cover c, Interval.Separated a b :=
  glueAt_inconsistent_witness h

/-- A published conflict: the two separated reports, with the proof that they
have no common value. -/
structure ConflictWitness where
  cell : Cell
  leftSite : String
  rightSite : String
  left : Interval
  right : Interval
  separated : Interval.Separated left right

/-- The witness is sound: no value satisfies both reports. -/
theorem conflictWitness_sound (w : ConflictWitness) : ¬ ∃ x, x ∈ w.left ∧ x ∈ w.right :=
  Interval.not_exists_mem_of_separated w.separated

end RequestProject.Economy
