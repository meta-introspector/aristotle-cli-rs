/-
# One time axis

`(startYear, endYear)` cannot express a month, and — more importantly — it
cannot stop an aggregation from counting the same day twice.  A period here is
a half-open interval `[start, stop)` on a single axis of days since an epoch,
so months, quarters, marketing years and arbitrary windows are all periods, and
aggregation carries a pairwise-disjointness side condition.
-/
import RequestProject.Economy.Quantities

namespace RequestProject.Economy

/-- A half-open interval of days since the epoch: `[start, stop)`. -/
structure Period where
  start : Int
  stop : Int
  nonempty : start < stop
deriving Repr

namespace Period

@[ext] theorem ext {p q : Period} (h1 : p.start = q.start) (h2 : p.stop = q.stop) : p = q := by
  cases p; cases q; simp_all

instance : DecidableEq Period := fun p q =>
  decidable_of_iff (p.start = q.start ∧ p.stop = q.stop)
    ⟨fun h => Period.ext h.1 h.2, fun h => by subst h; exact ⟨rfl, rfl⟩⟩

/-- The days covered by a period. -/
def Contains (p : Period) (d : Int) : Prop := p.start ≤ d ∧ d < p.stop

instance : Membership Int Period := ⟨fun p d => p.Contains d⟩

@[simp] theorem mem_iff {p : Period} {d : Int} : d ∈ p ↔ p.start ≤ d ∧ d < p.stop := Iff.rfl

/-- The length of a period, in days. -/
def days (p : Period) : Int := p.stop - p.start

theorem days_pos (p : Period) : 0 < p.days := by
  have := p.nonempty
  simp only [days]
  omega

/-- Two periods are disjoint when neither contains a day of the other. -/
def Disjoint (p q : Period) : Prop := p.stop ≤ q.start ∨ q.stop ≤ p.start

theorem not_mem_both {p q : Period} (h : Disjoint p q) {d : Int} (hp : d ∈ p) : d ∉ q := by
  rcases h with h | h <;> rintro ⟨h1, h2⟩ <;> obtain ⟨h3, h4⟩ := hp <;> omega

theorem disjoint_comm {p q : Period} (h : Disjoint p q) : Disjoint q p := by
  rcases h with h | h
  · exact Or.inr h
  · exact Or.inl h

/-! ### Chains and aggregation

A *chain* is a consecutive decomposition: each period stops where the next
begins.  Chains are exactly the decompositions along which aggregation is
sound: their members are pairwise disjoint, so no day is counted twice, and the
day counts add up to the span.
-/

/-- The right endpoint of a nonempty chain, written as head-plus-tail so no
`getLast` proof obligation is needed. -/
def lastStop : Period → List Period → Int
  | a, [] => a.stop
  | _, b :: t => lastStop b t

/-- `Chain a ps` says `a :: ps` is a consecutive decomposition: each period
stops exactly where the next one begins. -/
def Chain : Period → List Period → Prop
  | _, [] => True
  | a, b :: t => a.stop = b.start ∧ Chain b t

/-- Along a chain, every later period starts at or after the head's stop. -/
theorem chain_start_ge {a : Period} {ps : List Period} (h : Chain a ps) :
    ∀ b ∈ ps, a.stop ≤ b.start := by
  induction ps generalizing a with
  | nil => intro b hb; cases hb
  | cons c t ih =>
      obtain ⟨hac, hchain⟩ := h
      intro b hb
      rcases List.mem_cons.mp hb with rfl | hb
      · omega
      · have := ih hchain b hb
        have := c.nonempty
        omega

/-- **No double counting.** The members of a chain are pairwise disjoint. -/
theorem chain_pairwise_disjoint {a : Period} {ps : List Period} (h : Chain a ps) :
    List.Pairwise Disjoint (a :: ps) := by
  induction ps generalizing a with
  | nil => simp
  | cons c t ih =>
      obtain ⟨hac, hchain⟩ := h
      have hpair := ih hchain
      refine List.pairwise_cons.mpr ⟨?_, hpair⟩
      intro b hb
      rcases List.mem_cons.mp hb with rfl | hb
      · exact Or.inl (le_of_eq hac)
      · have := chain_start_ge hchain b hb
        have := c.nonempty
        exact Or.inl (by omega)

/-- **Aggregation is exact.** The day counts of a chain sum to its span. -/
theorem chain_days_sum {a : Period} {ps : List Period} (h : Chain a ps) :
    a.days + (ps.map days).sum = lastStop a ps - a.start := by
  induction ps generalizing a with
  | nil => simp [days, lastStop]
  | cons c t ih =>
      obtain ⟨hac, hchain⟩ := h
      have := ih hchain
      simp only [List.map_cons, List.sum_cons, lastStop, days] at *
      omega

/-- A day inside the span of a chain lies in exactly one of its members. -/
theorem chain_mem_unique {a : Period} {ps : List Period} (h : Chain a ps)
    {d : Int} {p q : Period} (hp : p ∈ a :: ps) (hq : q ∈ a :: ps)
    (hdp : d ∈ p) (hdq : d ∈ q) : p = q := by
  by_contra hne
  have hpair := chain_pairwise_disjoint h
  have hd := hpair.forall (fun _ _ hxy => disjoint_comm hxy) hp hq hne
  exact not_mem_both hd hdp hdq

end Period

end RequestProject.Economy
