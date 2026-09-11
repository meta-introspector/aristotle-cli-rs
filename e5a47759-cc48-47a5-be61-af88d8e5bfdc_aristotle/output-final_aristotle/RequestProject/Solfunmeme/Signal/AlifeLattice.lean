/-
  AlifeLattice.lean — an artificial life, self-hosted on the web, living in the
  lattice of sizes.

  The simulation is *self-hosted* in a precise sense: its cells are the strands
  of the recorded continuum, its neighbourhood relation is the web's own
  hyphae, and its state alphabet is the thirteen-element lattice of sizes that
  the web's conformal field produced (`SizeLattice.lean`).  Nothing is imported
  from outside: the organism runs on the very structure it describes.

  A **colony** assigns a size to every strand.  One **generation** lets each
  strand take the join, in the lattice of sizes, of its own size with the sizes
  of every strand feeding it along a hypha:

      step c x  =  c x  ⊔  ⨆ { c (source h) | h ∈ hyphae, target h = x }.

  Proved in general (for any web):

  * the alphabet is closed — a colony of sizes stays a colony of sizes;
  * life never shrinks — `c x` always divides `step c x`, and hence `gen n c x`;
  * a colony is at **equilibrium** exactly when size flows without obstruction
    along every hypha (`stable_iff`);
  * from any colony, the generations stay below every equilibrium above the
    seed (`gen_dvd_of_stable`): the life grows to the least one, no further.

  Proved of the recorded continuum:

  * the conformal solution itself is *not* at equilibrium — one strand,
    `semanticGraphStore` with size 3, receives size 2 from the OWL ontology and
    cannot hold it;
  * one generation repairs exactly that strand (3 ↦ 6) and nothing else, and
    the result is at equilibrium forever (`mature_stable`, `gen_eq_mature`);
  * the mature colony is the *least* equilibrium above the conformal solution
    (`mature_least`) — it is the divisibility-closure of the field;
  * **self-hosting closes the circle**: the mature colony is itself a conformal
    embedding of the web, for the field its own generation defines, and every
    one of that field's ratios is a whole number (`mature_isEmbedding`,
    `mature_ratio_nat`);
  * **light cone**: seed a single spore at one strand and, after six
    generations, exactly the strands reachable from it in the web are alive —
    life spreads along the mycelium, no faster and no further
    (`alive_iff_reachable`), and from the 2002 root it fills the whole web
    (`spore_root_fills`), taking all six generations to do it.
-/
import RequestProject.Solfunmeme.Signal.SizeLattice

set_option maxRecDepth 40000

namespace Mycelium

-- The thirteen strands form a finite type, so statements quantified over all
-- strands are decidable.
deriving instance Fintype for Strand

namespace Alife

/-! ## Colonies and generations -/

/-- A colony: a size living at every strand. -/
abbrev Colony := Strand → ℕ

/-- A colony is legitimate when every cell holds one of the thirteen sizes. -/
def InSizes (c : Colony) : Prop := ∀ x, c x ∈ sizes

instance (c : Colony) : Decidable (InSizes c) := by unfold InSizes; infer_instance

/-- The strands feeding `x`: the sources of the hyphae that conclude at `x`. -/
def inflow (w : Web Strand) (x : Strand) : List Strand :=
  (w.hyphae.filter (fun h => decide (h.target = x))).map Hypha.source

theorem source_mem_inflow {w : Web Strand} {h : Hypha Strand} (hh : h ∈ w.hyphae) :
    h.source ∈ inflow w h.target :=
  List.mem_map.mpr ⟨h, List.mem_filter.mpr ⟨hh, by simp⟩, rfl⟩

/-- One generation: every strand joins its own size with the sizes of all the
    strands feeding it. -/
def step (w : Web Strand) (c : Colony) (x : Strand) : ℕ :=
  (inflow w x).foldr (fun s v => sjoin (c s) v) (c x)

/-- `n` generations. -/
def gen (w : Web Strand) : ℕ → Colony → Colony
  | 0, c => c
  | n + 1, c => step w (gen w n c)

/-! ## The fold, in general -/

theorem foldr_sjoin_mem {c : Colony} (hc : InSizes c) (l : List Strand) {b : ℕ} (hb : b ∈ sizes) :
    l.foldr (fun s v => sjoin (c s) v) b ∈ sizes := by
  induction l with
  | nil => exact hb
  | cons s _ ih => exact sjoin_mem _ (hc s) _ ih

theorem base_dvd_foldr {c : Colony} (hc : InSizes c) (l : List Strand) {b : ℕ} (hb : b ∈ sizes) :
    b ∣ l.foldr (fun s v => sjoin (c s) v) b := by
  induction l with
  | nil => exact dvd_refl _
  | cons s t ih =>
      exact dvd_trans ih (right_dvd_sjoin _ (hc s) _ (foldr_sjoin_mem hc t hb))

theorem mem_dvd_foldr {c : Colony} (hc : InSizes c) (l : List Strand) {b : ℕ} (hb : b ∈ sizes) :
    ∀ s ∈ l, c s ∣ l.foldr (fun s v => sjoin (c s) v) b := by
  induction l with
  | nil => intro s hs; exact absurd hs List.not_mem_nil
  | cons a t ih =>
      intro s hs
      rcases List.mem_cons.mp hs with rfl | hs
      · exact left_dvd_sjoin _ (hc s) _ (foldr_sjoin_mem hc t hb)
      · exact dvd_trans (ih s hs) (right_dvd_sjoin _ (hc a) _ (foldr_sjoin_mem hc t hb))

theorem foldr_sjoin_dvd {c : Colony} (hc : InSizes c) (l : List Strand) {b t : ℕ}
    (hb : b ∈ sizes) (ht : t ∈ sizes) (hbt : b ∣ t) (hl : ∀ s ∈ l, c s ∣ t) :
    l.foldr (fun s v => sjoin (c s) v) b ∣ t := by
  induction l with
  | nil => exact hbt
  | cons s l ih =>
      exact sjoin_dvd _ (hc s) _ (foldr_sjoin_mem hc l hb) _ ht
        (hl s List.mem_cons_self) (ih (fun y hy => hl y (List.mem_cons_of_mem _ hy)))

theorem foldr_sjoin_eq_base {c : Colony} (hc : InSizes c) (l : List Strand) {b : ℕ}
    (hb : b ∈ sizes) (hl : ∀ s ∈ l, c s ∣ b) :
    l.foldr (fun s v => sjoin (c s) v) b = b := by
  induction l with
  | nil => rfl
  | cons s l ih =>
      have hrest : l.foldr (fun s v => sjoin (c s) v) b = b :=
        ih (fun y hy => hl y (List.mem_cons_of_mem _ hy))
      show sjoin (c s) (l.foldr (fun s v => sjoin (c s) v) b) = b
      rw [hrest]
      exact sjoin_of_dvd _ (hc s) _ hb (hl s List.mem_cons_self)

/-! ## The rule, in general -/

variable {w : Web Strand}

/-- The rule is local and pointwise: colonies that agree everywhere have the
    same next generation. -/
theorem step_congr {c d : Colony} (h : ∀ x, c x = d x) (x : Strand) :
    step w c x = step w d x := by
  have : c = d := funext h
  rw [this]

/-- The alphabet is closed: a colony of sizes stays a colony of sizes. -/
theorem step_inSizes {c : Colony} (hc : InSizes c) : InSizes (step w c) := fun x =>
  foldr_sjoin_mem hc _ (hc x)

theorem gen_inSizes {c : Colony} (hc : InSizes c) : ∀ n, InSizes (gen w n c)
  | 0 => hc
  | n + 1 => step_inSizes (gen_inSizes hc n)

/-- Life never shrinks: a cell's size always divides its size in the next
    generation. -/
theorem self_dvd_step {c : Colony} (hc : InSizes c) (x : Strand) : c x ∣ step w c x :=
  base_dvd_foldr hc _ (hc x)

theorem self_dvd_gen {c : Colony} (hc : InSizes c) : ∀ (n : ℕ) (x : Strand), c x ∣ gen w n c x
  | 0, _ => dvd_refl _
  | n + 1, x => dvd_trans (self_dvd_gen hc n x) (self_dvd_step (gen_inSizes hc n) x)

/-- Size flows along hyphae: after one generation, every strand carries the
    sizes of everything attached to it. -/
theorem source_dvd_step {c : Colony} (hc : InSizes c) {h : Hypha Strand} (hh : h ∈ w.hyphae) :
    c h.source ∣ step w c h.target :=
  mem_dvd_foldr hc _ (hc h.target) _ (source_mem_inflow hh)

/-- A colony is at **equilibrium** when size already flows without obstruction
    along every hypha of the web. -/
def Stable (w : Web Strand) (c : Colony) : Prop := ∀ h ∈ w.hyphae, c h.source ∣ c h.target

instance (w : Web Strand) (c : Colony) : Decidable (Stable w c) := by
  unfold Stable; infer_instance

/-- Equilibrium is exactly stationarity: nothing changes from one generation to
    the next precisely when every hypha already carries its source's size. -/
theorem stable_iff {c : Colony} (hc : InSizes c) :
    Stable w c ↔ ∀ x, step w c x = c x := by
  constructor
  · intro hs x
    refine foldr_sjoin_eq_base hc _ (hc x) ?_
    intro s hsx
    obtain ⟨h, hh, rfl⟩ := List.mem_map.mp hsx
    obtain ⟨hmem, htgt⟩ := List.mem_filter.mp hh
    have hx : h.target = x := of_decide_eq_true htgt
    exact hx ▸ hs h hmem
  · intro hfix h hh
    have := source_dvd_step hc hh
    rwa [hfix h.target] at this

/-- An equilibrium colony is a fixed point of the life for all time. -/
theorem gen_of_stable {c : Colony} (hc : InSizes c) (hs : Stable w c) :
    ∀ (n : ℕ) (x : Strand), gen w n c x = c x := by
  intro n
  induction n with
  | zero => intro _; rfl
  | succ n ih =>
      intro x
      show step w (gen w n c) x = c x
      rw [step_congr ih x]
      exact (stable_iff hc).mp hs x

/-- The generations stay below every equilibrium above the seed: the life grows
    to the *least* equilibrium containing it, and no further. -/
theorem step_dvd_of_stable {c d : Colony} (hc : InSizes c) (hd : InSizes d)
    (hs : Stable w d) (hcd : ∀ x, c x ∣ d x) (x : Strand) : step w c x ∣ d x := by
  refine foldr_sjoin_dvd hc _ (hc x) (hd x) (hcd x) ?_
  intro s hsx
  obtain ⟨h, hh, rfl⟩ := List.mem_map.mp hsx
  obtain ⟨hmem, htgt⟩ := List.mem_filter.mp hh
  have hx : h.target = x := of_decide_eq_true htgt
  exact dvd_trans (hcd h.source) (hx ▸ hs h hmem)

theorem gen_dvd_of_stable {c d : Colony} (hc : InSizes c) (hd : InSizes d)
    (hs : Stable w d) (hcd : ∀ x, c x ∣ d x) : ∀ (n : ℕ) (x : Strand), gen w n c x ∣ d x
  | 0, x => hcd x
  | n + 1, x => step_dvd_of_stable (gen_inSizes hc n) hd hs (gen_dvd_of_stable hc hd hs hcd n) x

/-! ## Superposition: mixing two colonies

Colonies are joined cell by cell in the lattice of sizes.  The rule is a join
homomorphism, so running the life on a mixture is the same as mixing the two
lives: colonies superpose. -/

/-- The mixture of two colonies: the join of their sizes, cell by cell. -/
def mix (c d : Colony) : Colony := fun x => sjoin (c x) (d x)

theorem mix_inSizes {c d : Colony} (hc : InSizes c) (hd : InSizes d) : InSizes (mix c d) :=
  fun x => sjoin_mem _ (hc x) _ (hd x)

theorem foldr_sjoin_mix {c d : Colony} (hc : InSizes c) (hd : InSizes d) (l : List Strand)
    {b b' : ℕ} (hb : b ∈ sizes) (hb' : b' ∈ sizes) :
    l.foldr (fun s v => sjoin (mix c d s) v) (sjoin b b')
      = sjoin (l.foldr (fun s v => sjoin (c s) v) b) (l.foldr (fun s v => sjoin (d s) v) b') := by
  induction l with
  | nil => rfl
  | cons s t ih =>
      show sjoin (sjoin (c s) (d s)) (t.foldr (fun s v => sjoin (mix c d s) v) (sjoin b b')) = _
      rw [ih]
      exact sjoin_medial (hc s) (hd s) (foldr_sjoin_mem hc t hb) (foldr_sjoin_mem hd t hb')

/-- **Superposition.**  One generation of a mixture is the mixture of the two
    generations. -/
theorem step_mix {c d : Colony} (hc : InSizes c) (hd : InSizes d) (x : Strand) :
    step w (mix c d) x = sjoin (step w c x) (step w d x) :=
  foldr_sjoin_mix hc hd _ (hc x) (hd x)

/-- …and so is any number of generations: colonies never interfere, they only
    join. -/
theorem gen_mix {c d : Colony} (hc : InSizes c) (hd : InSizes d) :
    ∀ (n : ℕ) (x : Strand), gen w n (mix c d) x = sjoin (gen w n c x) (gen w n d x) := by
  intro n
  induction n with
  | zero => intro _; rfl
  | succ n ih =>
      intro x
      show step w (gen w n (mix c d)) x = _
      rw [step_congr (c := gen w n (mix c d)) (d := mix (gen w n c) (gen w n d)) ih x]
      exact step_mix (gen_inSizes hc n) (gen_inSizes hd n) x

/-! ## Every life converges

The alphabet is a lattice of height at most thirteen and there are thirteen
cells, so a colony that is not yet at equilibrium must strictly climb.  That
bounds the number of generations any colony, on any web, can take to settle. -/

/-- The height of a size: how many of the thirteen sizes divide it.  It
    increases strictly along proper divisibility. -/
def ht (n : ℕ) : ℕ := (sizes.filter (fun s => decide (s ∣ n))).length

theorem ht_lt : ∀ a ∈ sizes, ∀ b ∈ sizes, a ∣ b → a ≠ b → ht a < ht b := by decide

theorem ht_le : ∀ a ∈ sizes, ht a ≤ 13 := by decide

/-- The total height of a colony: its potential. -/
def Phi (c : Colony) : ℕ := ∑ x : Strand, ht (c x)

theorem card_strand : Fintype.card Strand = 13 := by decide

theorem Phi_le {c : Colony} (hc : InSizes c) : Phi c ≤ 169 := by
  have h := Finset.sum_le_card_nsmul (Finset.univ : Finset Strand) (fun x => ht (c x)) 13
    (fun x _ => ht_le _ (hc x))
  simpa [Phi, card_strand] using h

/-- A colony that is not yet at equilibrium strictly increases its potential in
    the next generation. -/
theorem Phi_lt {c : Colony} (hc : InSizes c) (hns : ¬ ∀ x, step w c x = c x) :
    Phi c < Phi (step w c) := by
  push_neg at hns
  obtain ⟨x, hx⟩ := hns
  refine Finset.sum_lt_sum (fun i _ => ?_) ⟨x, Finset.mem_univ x, ?_⟩
  · rcases eq_or_ne (c i) (step w c i) with h | h
    · exact le_of_eq (by rw [h])
    · exact le_of_lt (ht_lt _ (hc i) _ (step_inSizes hc i) (self_dvd_step hc i) h)
  · exact ht_lt _ (hc x) _ (step_inSizes hc x) (self_dvd_step hc x) (Ne.symm hx)

/-- Equilibrium only depends on the sizes, not on how they were reached. -/
theorem stable_congr {c d : Colony} (h : ∀ x, c x = d x) (hs : Stable w c) : Stable w d :=
  fun g hg => by rw [← h, ← h]; exact hs g hg

/-- Running the life one generation and then `n` more is the same as running it
    `n` generations from the next generation. -/
theorem gen_succ_comm (c : Colony) : ∀ (n : ℕ) (x : Strand),
    gen w (n + 1) c x = gen w n (step w c) x := by
  intro n
  induction n with
  | zero => intro _; rfl
  | succ n ih =>
      intro x
      show step w (gen w (n + 1) c) x = step w (gen w n (step w c)) x
      exact step_congr ih x

/-- **Convergence.**  On any web, from any colony of sizes, the life reaches
    equilibrium: after enough generations nothing changes again.  The potential
    is bounded by 169, so 170 generations always suffice. -/
theorem stabilises : ∀ (n : ℕ) (c : Colony), InSizes c → 170 ≤ Phi c + n → Stable w (gen w n c) := by
  intro n
  induction n with
  | zero =>
      intro c hc hn
      exact absurd (Phi_le hc) (by omega)
  | succ n ih =>
      intro c hc hn
      by_cases hs : Stable w c
      · exact stable_congr (fun x => (gen_of_stable hc hs (n + 1) x).symm) hs
      · have hns : ¬ ∀ x, step w c x = c x := fun h => hs ((stable_iff hc).mpr h)
        have hlt := Phi_lt (w := w) hc hns
        exact stable_congr (fun x => (gen_succ_comm c n x).symm)
          (ih (step w c) (step_inSizes hc) (by omega))

/-- Any colony of sizes is at equilibrium after 170 generations. -/
theorem stabilises_170 (c : Colony) (hc : InSizes c) : Stable w (gen w 170 c) :=
  stabilises 170 c hc (by omega)

/-! ## The colony of the recorded continuum

The seed is the conformal solution itself: each strand starts at the size the
conformal field gave it. -/

/-- The seed: the conformal solution, one size per strand. -/
def seed : Colony := strandSize

theorem seed_inSizes : InSizes seed := strandSize_mem

/-- The conformal solution is **not** at equilibrium.  Its scales were fixed by
    multiplication, not by divisibility, and one crossing is obstructed: the
    OWL tree ontology (size 2) feeds the semantic graph store (size 3), and 2
    does not divide 3. -/
theorem seed_not_stable : ¬ Stable continuum seed := by decide

/-- The mature colony: what one generation makes of the seed. -/
def mature : Colony := step continuum seed

theorem mature_inSizes : InSizes mature := step_inSizes seed_inSizes

/-- One generation repairs exactly one strand: the semantic graph store grows
    from 3 to 6, the join of its own size with the ontology's. -/
theorem mature_semanticGraphStore :
    mature .semanticGraphStore = 6 ∧ seed .semanticGraphStore = 3 := by decide

/-- …and changes nothing else. -/
theorem mature_eq_seed_elsewhere : ∀ x : Strand, x ≠ .semanticGraphStore → mature x = seed x := by
  decide

/-- The mature colony is at equilibrium: size now flows along all eighteen
    hyphae. -/
theorem mature_stable : Stable continuum mature := by decide

/-- Hence the life is stationary from the first generation on: one generation
    of growth, then an unchanging organism. -/
theorem gen_eq_mature : ∀ (n : ℕ) (x : Strand), gen continuum (n + 1) seed x = mature x := by
  intro n
  induction n with
  | zero => intro _; rfl
  | succ n ih =>
      intro x
      show step continuum (gen continuum (n + 1) seed) x = mature x
      rw [step_congr ih x]
      exact (stable_iff mature_inSizes).mp mature_stable x

/-- **The mature colony is the divisibility-closure of the conformal field**:
    it is the least equilibrium colony above the seed.  Any legitimate colony
    at equilibrium whose sizes dominate the conformal solution already
    dominates the mature colony. -/
theorem mature_least {d : Colony} (hd : InSizes d) (hs : Stable continuum d)
    (hsd : ∀ x, seed x ∣ d x) (x : Strand) : mature x ∣ d x :=
  step_dvd_of_stable seed_inSizes hd hs hsd x

/-! ### Self-hosting: the equilibrium is a conformal solution of its own field

At equilibrium every hypha multiplies the size of its source by a whole number.
Taking those numbers as a conformal field, the mature colony solves it — the
life reproduces, in the sense of `ConformalEmbedding.lean`, the structure that
produced its alphabet. -/

theorem mature_ne_zero (x : Strand) : mature x ≠ 0 := by revert x; decide

/-- The field the mature colony generates: the factor by which each hypha
    multiplies size. -/
def matureRatio (h : Hypha Strand) : ℚ :=
  (mature h.target : ℚ) / (mature h.source : ℚ)

/-- Every ratio of the generated field is a whole number: at equilibrium a
    hypha never has to divide. -/
theorem mature_ratio_nat :
    ∀ h ∈ continuum.hyphae, ∃ k : ℕ, mature h.target = k * mature h.source := by
  intro h hh
  obtain ⟨k, hk⟩ := mature_stable h hh
  exact ⟨k, by rw [hk, Nat.mul_comm]⟩

/-- **Self-hosting.**  The mature colony is a conformal embedding of the web in
    the field it generates itself: the artificial life is a solution of the
    same equations that gave it its sizes. -/
theorem mature_isEmbedding :
    IsEmbedding continuum matureRatio (fun x => (mature x : ℚ)) := by
  intro h _
  have hne : ((mature h.source : ℚ)) ≠ 0 := Nat.cast_ne_zero.mpr (mature_ne_zero h.source)
  rw [matureRatio, div_mul_cancel₀ _ hne]

/-! ## Spores and the light cone

A spore is a single live cell — one strand at size 2, everything else at the
bottom size 1.  A strand is *alive* when it is above the bottom. -/

/-- A single live strand. -/
def spore (s : Strand) : Colony := fun y => if y = s then 2 else 1

theorem spore_inSizes (s : Strand) : InSizes (spore s) := by
  intro x
  by_cases h : x = s
  · simp only [spore, if_pos h]; decide
  · simp only [spore, if_neg h]; decide

/-- A cell is alive when it holds more than the bottom size. -/
def Alive (c : Colony) (x : Strand) : Prop := c x ≠ 1

instance (c : Colony) (x : Strand) : Decidable (Alive c x) := by unfold Alive; infer_instance

/-- Life, once lit, never goes out. -/
theorem alive_gen {c : Colony} (hc : InSizes c) {x : Strand} (hx : Alive c x) (n : ℕ) :
    Alive (gen w n c) x := by
  intro h
  exact hx (Nat.eq_one_of_dvd_one (h ▸ self_dvd_gen hc n x))

/-- **The light cone.**  Six generations after a single spore, the living
    strands are exactly those the web reaches from it: the life spreads along
    the mycelium, no faster and no further. -/
theorem alive_iff_reachable : ∀ s x : Strand,
    Alive (gen continuum 6 (spore s)) x ↔ continuum.reachIn 6 s x = true := by
  decide

/-- A spore at the 2002 root colonises the entire web. -/
theorem spore_root_fills : ∀ x : Strand, gen continuum 6 (spore .gccIntrospector) x = 2 := by
  decide

/-- …and it takes all six generations: after five, the upper-ontology merge is
    still unreached. -/
theorem spore_root_slow :
    gen continuum 5 (spore .gccIntrospector) .upperOntologyMerge = 1 := by decide

/-! ## Axiom audit -/

#print axioms step_inSizes
#print axioms self_dvd_gen
#print axioms stable_iff
#print axioms gen_dvd_of_stable
#print axioms gen_mix
#print axioms stabilises
#print axioms seed_not_stable
#print axioms mature_stable
#print axioms gen_eq_mature
#print axioms mature_least
#print axioms mature_isEmbedding
#print axioms alive_iff_reachable
#print axioms spore_root_fills

end Alife

end Mycelium
