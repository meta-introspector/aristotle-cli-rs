/-
# General theory of self-copying decks

Two things live here, both independent of any particular deck:

* a **sufficient criterion** — if some card `p` of the deck, read as a program
  against some card `d` of the same deck, punches exactly the deck, then the
  deck is self-copying (and the witnessing run is a two-step, tier-monotone
  bootstrap sequence);
* a **provenance lemma** — every card any legal run punches came out of
  `exec p d` for two cards `p`, `d` *of the deck itself*.  This is what makes
  the fixed point a real constraint rather than a definition: it gives
  negative results, and a lower bound on how small a self-copying deck can be.
-/
import RequestProject.Nix.Tech.Bootstrap

namespace Bootstrap

/-! ## The canonical two-step run -/

/-- Step one: mount the deck. -/
def spindleStep (cs : CardSet) : Step :=
  { node := spindle cs, used := [], made := cs.map Res.pattern }

/-- Step two: run the loom on the program card `p` with the data card `d`. -/
def loomStep (p d : Card) : Step :=
  { node := loom, used := [Res.shim, Res.pattern p, Res.pattern d],
    made := (exec p d).map Res.card }

/-- A run of the loom, once per pair of (program card, data card). -/
def loomSteps (ps : List (Card × Card)) : BootstrapSeq := ps.map (fun x => loomStep x.1 x.2)

/-- Mount the deck, then punch, once per pair: the whole bootstrap. -/
def copyRun (cs : CardSet) (ps : List (Card × Card)) : BootstrapSeq :=
  spindleStep cs :: loomSteps ps

@[simp] theorem emit_loomSteps (ps : List (Card × Card)) :
    emit (loomSteps ps) = ps.flatMap (fun x => exec x.1 x.2) := by
  induction ps with
  | nil => rfl
  | cons x t ih =>
    simp [emit, loomSteps, loomStep, loom, Res.asCard, List.filterMap_map, Function.comp_def] at ih ⊢
    rw [ih]

@[simp] theorem emit_copyRun (cs : CardSet) (ps : List (Card × Card)) :
    emit (copyRun cs ps) = ps.flatMap (fun x => exec x.1 x.2) := by
  have h : emit (copyRun cs ps) = emit (loomSteps ps) := by
    simp [emit, copyRun, spindleStep, spindle, Res.asCard, List.filterMap_map, Function.comp_def]
  rw [h, emit_loomSteps]

/-- The canonical run never skips a tier: the spindle is tier 0, every loom
firing is tier 1. -/
theorem tierMonotone_copyRun (cs : CardSet) (ps : List (Card × Card)) :
    TierMonotone 0 (copyRun cs ps) := by
  refine ⟨Or.inl rfl, ?_⟩
  suffices h : ∀ (qs : List (Card × Card)) (prev : Nat), prev = 0 ∨ prev = 1 →
      TierMonotone prev (loomSteps qs) by
    exact h ps 0 (Or.inl rfl)
  intro qs
  induction qs with
  | nil => intro prev _; trivial
  | cons x t ih =>
    intro prev hprev
    refine ⟨?_, ih 1 (Or.inr rfl)⟩
    rcases hprev with rfl | rfl
    · exact Or.inr rfl
    · exact Or.inl rfl

/-- Every loom firing is legal as long as its two cards are cards of the deck
and the deck is already mounted. -/
theorem valid_loomSteps (cs : CardSet) :
    ∀ (ps : List (Card × Card)) (avail : List (Nat × Res)) (prev : Nat),
      (∀ x ∈ ps, x.1 ∈ cs ∧ x.2 ∈ cs) → (∀ c ∈ cs, (0, Res.pattern c) ∈ avail) →
      (prev = 0 ∨ prev = 1) → Valid (interpret cs) avail prev (loomSteps ps) := by
  intro ps
  induction ps with
  | nil => intro _ _ _ _ _; trivial
  | cons x t ih =>
    intro avail prev hcards hav hprev
    obtain ⟨hp, hd⟩ := hcards x (List.mem_cons_self ..)
    refine ⟨ ?_, ?_⟩
    · refine ⟨?_, ?_, ?_, rfl, ?_⟩
      · exact List.mem_cons_of_mem _ (List.mem_cons_self ..)
      · exact List.Forall₂.cons rfl (List.Forall₂.cons rfl (List.Forall₂.cons rfl List.Forall₂.nil))
      · intro r hr
        simp only [loomStep, List.mem_cons, List.not_mem_nil, or_false] at hr
        rcases hr with rfl | rfl | rfl
        · exact Or.inl (by simp [BootstrapExceptions])
        · exact Or.inr ⟨0, hav _ hp, by norm_num [loomStep, loom]⟩
        · exact Or.inr ⟨0, hav _ hd, by norm_num [loomStep, loom]⟩
      · rcases hprev with rfl | rfl
        · exact Or.inr rfl
        · exact Or.inl rfl
    · refine ih _ _ (fun y hy => hcards y (List.mem_cons_of_mem _ hy)) ?_ (Or.inr rfl)
      intro c hc
      exact List.mem_append_left _ (hav c hc)

/-- The canonical run is a legal bootstrap sequence for the tree the deck
describes, as soon as every card it reads is a card of the deck. -/
theorem valid_copyRun (cs : CardSet) (ps : List (Card × Card))
    (h : ∀ x ∈ ps, x.1 ∈ cs ∧ x.2 ∈ cs) :
    ValidSequence (copyRun cs ps) (interpret cs) := by
  refine ⟨⟨?_, ?_, ?_, rfl, Or.inl rfl⟩, ?_⟩
  · exact List.mem_cons_self ..
  · exact List.Forall₂.nil
  · simp [spindleStep]
  · refine valid_loomSteps cs ps _ _ h ?_ (Or.inl rfl)
    intro c hc
    simpa [spindleStep, spindle] using hc

/-- **The criterion.**  If the loom, fired once per listed pair of cards of the
deck, punches exactly the deck, the deck is self-copying. -/
theorem selfCopying_of_execs {cs : CardSet} {ps : List (Card × Card)}
    (h : ∀ x ∈ ps, x.1 ∈ cs ∧ x.2 ∈ cs) (he : ps.flatMap (fun x => exec x.1 x.2) = cs) :
    SelfCopying cs :=
  ⟨copyRun cs ps, valid_copyRun cs ps h, by rw [emit_copyRun]; exact he⟩

/-- **The criterion, single firing.**  A card of the deck that punches the whole
deck in one pass makes the deck self-copying. -/
theorem selfCopying_of_exec {cs : CardSet} {p d : Card} (hp : p ∈ cs) (hd : d ∈ cs)
    (h : exec p d = cs) : SelfCopying cs := by
  refine selfCopying_of_execs (ps := [(p, d)]) ?_ ?_
  · intro x hx
    simp only [List.mem_singleton] at hx
    subst hx
    exact ⟨hp, hd⟩
  · simpa using h

/-- A decidable test for the criterion: is some card of the deck a program that
punches the deck out of some card of the deck? -/
def selfCopyCheck (cs : CardSet) : Bool :=
  cs.any (fun p => cs.any (fun d => exec p d == cs))

/-- The decidable test is sound: if it says `true`, the deck really is
self-copying. -/
theorem selfCopying_of_check {cs : CardSet} (h : selfCopyCheck cs = true) : SelfCopying cs := by
  simp only [selfCopyCheck, List.any_eq_true, beq_iff_eq] at h
  obtain ⟨p, hp, d, hd, h⟩ := h
  exact selfCopying_of_exec hp hd h

/-! ## Provenance: where punched cards can come from -/

/-- Every pattern available for reading is a card of the deck. -/
def PatternsFrom (cs : CardSet) (avail : List (Nat × Res)) : Prop :=
  ∀ k c, (k, Res.pattern c) ∈ avail → c ∈ cs

theorem patternsFrom_nil (cs : CardSet) : PatternsFrom cs [] := by
  intro k c h; cases h

/-- **Provenance.**  Whatever a legal run punches, it punched by reading two
cards of the deck.  Nothing else can enter the shop: the bootstrap exceptions
are blank shims only. -/
theorem emit_provenance {cs : CardSet} :
    ∀ (seq : BootstrapSeq) (avail : List (Nat × Res)) (prev : Nat),
      PatternsFrom cs avail → Valid (interpret cs) avail prev seq →
      ∀ c ∈ emit seq, ∃ p ∈ cs, ∃ d ∈ cs, c ∈ exec p d := by
  intro seq
  induction seq with
  | nil => intro avail prev _ _ c hc; simp [emit] at hc
  | cons s rest ih =>
    intro avail prev hpat hvalid c hc
    obtain ⟨⟨hnode, hmatch, havail, hmade, _⟩, hrest⟩ := hvalid
    simp only [interpret, List.mem_cons, List.not_mem_nil, or_false] at hnode
    rcases hnode with hnode | hnode
    · -- the spindle: it punches no cards, and it only makes patterns of the deck
      have hmade' : s.made = cs.map Res.pattern := by rw [hmade, hnode]; rfl
      have hstep : (s.made.filterMap Res.asCard) = [] := by
        rw [hmade']
        simp [List.filterMap_map, Res.asCard, Function.comp_def]
      have hc' : c ∈ emit rest := by
        rw [emit, List.flatMap_cons, hstep, List.nil_append] at hc
        exact hc
      refine ih _ _ ?_ hrest c hc'
      intro k e he
      rcases List.mem_append.mp he with he | he
      · exact hpat k e he
      · rw [hmade'] at he
        simp only [List.map_map, List.mem_map, Function.comp_apply] at he
        obtain ⟨a, ha, hae⟩ := he
        cases hae
        exact ha
    · -- the loom: it reads two mounted patterns, hence two cards of the deck
      have hin : s.node.inputs = [Req.shim, Req.pattern, Req.pattern] := by rw [hnode]; rfl
      rw [hin] at hmatch
      obtain ⟨r1, r2, r3, hused, h1, h2, h3⟩ :
          ∃ r1 r2 r3, s.used = [r1, r2, r3] ∧ Req.accepts Req.shim r1 = true ∧
            Req.accepts Req.pattern r2 = true ∧ Req.accepts Req.pattern r3 = true := by
        rw [List.forall₂_cons_left_iff] at hmatch
        obtain ⟨r1, u1, h1, hm1, hu1⟩ := hmatch
        rw [List.forall₂_cons_left_iff] at hm1
        obtain ⟨r2, u2, h2, hm2, hu2⟩ := hm1
        rw [List.forall₂_cons_left_iff] at hm2
        obtain ⟨r3, u3, h3, hm3, hu3⟩ := hm2
        rw [List.forall₂_nil_left_iff] at hm3
        exact ⟨r1, r2, r3, by rw [hu1, hu2, hu3, hm3], h1, h2, h3⟩
      obtain ⟨p, rfl⟩ : ∃ p, r2 = Res.pattern p := by
        cases r2 <;> simp [Req.accepts] at h2 ⊢
      obtain ⟨d, rfl⟩ : ∃ d, r3 = Res.pattern d := by
        cases r3 <;> simp [Req.accepts] at h3 ⊢
      have hpmem : p ∈ cs := by
        have := havail (Res.pattern p) (by rw [hused]; simp)
        rcases this with h | ⟨k, hk, _⟩
        · simp [BootstrapExceptions] at h
        · exact hpat k p hk
      have hdmem : d ∈ cs := by
        have := havail (Res.pattern d) (by rw [hused]; simp)
        rcases this with h | ⟨k, hk, _⟩
        · simp [BootstrapExceptions] at h
        · exact hpat k d hk
      have hr1 : r1 = Res.shim := by cases r1 <;> simp [Req.accepts] at h1 ⊢
      have hmade' : s.made = (exec p d).map Res.card := by
        rw [hmade, hnode, hused, hr1]; rfl
      rw [emit, List.flatMap_cons] at hc
      rcases List.mem_append.mp hc with hc | hc
      · refine ⟨p, hpmem, d, hdmem, ?_⟩
        rw [hmade'] at hc
        simpa [List.filterMap_map, Res.asCard, Function.comp_def] using hc
      · refine ih _ _ ?_ hrest c hc
        intro k e he
        rcases List.mem_append.mp he with he | he
        · exact hpat k e he
        · rw [hmade'] at he
          simp only [List.map_map, List.mem_map, Function.comp_apply] at he
          obtain ⟨a, _, hae⟩ := he
          cases hae

/-- Provenance, applied to a whole self-copying deck: every card of a
self-copying deck is punched by two cards of that deck. -/
theorem selfCopying_provenance {cs : CardSet} (h : SelfCopying cs) :
    ∀ c ∈ cs, ∃ p ∈ cs, ∃ d ∈ cs, c ∈ exec p d := by
  obtain ⟨seq, hvalid, hemit⟩ := h
  intro c hc
  exact emit_provenance seq [] 0 (patternsFrom_nil cs) hvalid c (hemit ▸ hc)

/-! ## Lower bound

The empty deck is self-copying by the empty run — nothing is asked of a shop
that is never switched on.  That degenerate case aside, a self-copying deck
must carry at least one pin: a deck of blank cards punches nothing at all. -/

/-- The degenerate solution, stated rather than hidden: the empty deck copies
itself by doing nothing. -/
theorem selfCopying_nil : SelfCopying ([] : CardSet) :=
  ⟨[], trivial, rfl⟩

/-- **The lower bound.**  A non-empty self-copying deck has a card with at
least one pin on it. -/
theorem selfCopying_has_pin {cs : CardSet} (h : SelfCopying cs) (hne : cs ≠ []) :
    ∃ c ∈ cs, c ≠ [] := by
  by_contra hcon
  push_neg at hcon
  obtain ⟨c, hc⟩ : ∃ c, c ∈ cs := by
    cases cs with
    | nil => exact absurd rfl hne
    | cons a t => exact ⟨a, List.mem_cons_self ..⟩
  obtain ⟨p, hp, d, _, hmem⟩ := selfCopying_provenance h c hc
  rw [hcon p hp] at hmem
  simp [exec] at hmem

end Bootstrap
