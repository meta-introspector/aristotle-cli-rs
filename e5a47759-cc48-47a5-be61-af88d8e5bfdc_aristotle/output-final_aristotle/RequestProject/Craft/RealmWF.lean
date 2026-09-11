import RequestProject.Craft.Realm

/-!
# The rules keep the board sane

Everything here is about `Realm.step`: what a legal move can and cannot do.

* `step_wf` — a legal move takes a well-formed position to a well-formed position:
  nobody leaves the board, nobody stands in the water, and no two live pieces (or
  two live cities) ever share a tile.
* `step_hp_le` / `step_city_hp_le` — health never goes up, so the dead stay dead.
* `step_pieces_length_le` — the piece list only ever grows, and at the end, so a
  move index means the same thing in every replay.  This is what makes a game a
  list of moves.
* `step_bank_le` — only `gather` and `endTurn` can add to a bank: resources cannot
  be conjured.
* `gather_bank`, `train_cost`, `found_city`, `endTurn_alternates` — the individual
  rules.
* `winner_unique`, `over_terminal` — the game ends once and then stops.

§1–§3 are the machinery: how a legal move is taken apart, and four ways of
rebuilding a well-formed position (change one piece in place, move one piece,
add a piece, add a city).
-/

namespace Realm

/-! ## §1  Small facts about the pieces of the definition -/

theorem stepDir_bounds {d : Dir} {x y x' y' : Nat} (hx : x < W) (hy : y < H)
    (h : stepDir d x y = some (x', y')) : x' < W ∧ y' < H := by
  cases d <;> simp [stepDir] at h <;> omega

theorem occupied_false {st : State} {x y : Nat} (h : occupied st x y = false)
    (u : Piece) (hu : u ∈ st.pieces) (hhp : 0 < u.hp) : ¬(u.x = x ∧ u.y = y) := by
  simp [occupied, List.any_eq_false] at h
  intro hc
  exact absurd (h u hu hhp hc.1) (by simp [hc.2])

theorem cityAt_false {st : State} {x y : Nat} (h : cityAt st x y = false)
    (c : City) (hc : c ∈ st.cities) (hhp : 0 < c.hp) : ¬(c.x = x ∧ c.y = y) := by
  simp [cityAt, List.any_eq_false] at h
  intro hcc
  exact absurd (h c hc hhp hcc.1) (by simp [hcc.2])

theorem passable_of_plains {x y : Nat} (h : terrainAt x y = Terrain.plains) :
    passable x y = true := by
  simp [passable, h]

theorem setBank_pieces (st : State) (p : Nat) (r : Res) : (st.setBank p r).pieces = st.pieces := by
  unfold State.setBank; split <;> rfl

theorem setBank_cities (st : State) (p : Nat) (r : Res) : (st.setBank p r).cities = st.cities := by
  unfold State.setBank; split <;> rfl

theorem setBank_active (st : State) (p : Nat) (r : Res) : (st.setBank p r).active = st.active := by
  unfold State.setBank; split <;> rfl

theorem setBank_turn (st : State) (p : Nat) (r : Res) : (st.setBank p r).turn = st.turn := by
  unfold State.setBank; split <;> rfl

theorem setBank_get (st : State) (p : Nat) (r : Res) : (st.setBank p r).bank p = r := by
  unfold State.setBank State.bank
  split <;> simp_all

theorem setBank_get_other (st : State) (p q : Nat) (r : Res) (hq : q ≠ p) (hp : p < 2) (hq2 : q < 2) :
    (st.setBank p r).bank q = st.bank q := by
  unfold State.setBank State.bank
  by_cases h0 : p = 0
  · subst h0; simp [hq]
  · have hp1 : p = 1 := by omega
    subst hp1
    have hq0 : q = 0 := by omega
    subst hq0; simp

theorem setPiece_bank (st : State) (i : Nat) (u : Piece) (p : Nat) :
    (setPiece st i u).bank p = st.bank p := by
  unfold setPiece State.bank; simp

theorem setCity_bank (st : State) (i : Nat) (c : City) (p : Nat) :
    (setCity st i c).bank p = st.bank p := by
  unfold setCity State.bank; simp

theorem setBank_sub_le (st : State) (a p : Nat) (c : Res) :
    ((st.setBank a ((st.bank a).sub c)).bank p).food ≤ (st.bank p).food ∧
    ((st.setBank a ((st.bank a).sub c)).bank p).wood ≤ (st.bank p).wood ∧
    ((st.setBank a ((st.bank a).sub c)).bank p).gold ≤ (st.bank p).gold := by
  unfold State.setBank State.bank Res.sub
  split_ifs <;> simp

/-! ## §2  Taking a legal move apart -/

theorem legal_march_iff {st : State} {i : Nat} {d : Dir} (h : legal st (.march i d) = true) :
    ∃ u x y, st.pieces[i]? = some u ∧ 0 < u.hp ∧ u.owner = st.active ∧ u.acted = false ∧
      stepDir d u.x u.y = some (x, y) ∧ passable x y = true ∧ occupied st x y = false := by
  simp only [legal, Bool.and_eq_true] at h
  obtain ⟨⟨_, _⟩, hm⟩ := h
  split at hm
  · exact absurd hm (by simp)
  · rename_i u hu
    simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, Bool.not_eq_true'] at hm
    obtain ⟨⟨⟨h1, h2⟩, h3⟩, hm4⟩ := hm
    split at hm4
    · exact absurd hm4 (by simp)
    · rename_i x y ht
      simp only [Bool.and_eq_true, Bool.not_eq_true'] at hm4
      exact ⟨u, x, y, hu, h1, h2, h3, ht, hm4.1.1, hm4.1.2⟩

theorem legal_gather_iff {st : State} {i : Nat} (h : legal st (.gather i) = true) :
    ∃ u, st.pieces[i]? = some u ∧ 0 < u.hp ∧ u.owner = st.active ∧ u.acted = false ∧
      u.kind = Kind.worker := by
  simp only [legal, Bool.and_eq_true] at h
  obtain ⟨⟨_, _⟩, hm⟩ := h
  split at hm
  · exact absurd hm (by simp)
  · rename_i u hu
    simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, Bool.not_eq_true'] at hm
    exact ⟨u, hu, hm.1.1.1, hm.1.1.2, hm.1.2, hm.2⟩

theorem legal_found_iff {st : State} {i : Nat} (h : legal st (.found i) = true) :
    ∃ u, st.pieces[i]? = some u ∧ 0 < u.hp ∧ u.owner = st.active ∧ u.acted = false ∧
      u.kind = Kind.worker ∧ terrainAt u.x u.y = Terrain.plains ∧ cityAt st u.x u.y = false ∧
      (st.bank st.active).covers foundCost = true := by
  simp only [legal, Bool.and_eq_true] at h
  obtain ⟨⟨_, _⟩, hm⟩ := h
  split at hm
  · exact absurd hm (by simp)
  · rename_i u hu
    simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, Bool.not_eq_true'] at hm
    obtain ⟨⟨⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩, h6⟩, h7⟩ := hm
    exact ⟨u, hu, h1, h2, h3, h4, h5, h6, h7⟩

theorem legal_train_iff {st : State} {c : Nat} {k : Kind} (h : legal st (.train c k) = true) :
    ∃ ct, st.cities[c]? = some ct ∧ 0 < ct.hp ∧ ct.owner = st.active ∧
      (st.bank st.active).covers (costOf k) = true ∧ occupied st ct.x ct.y = false := by
  simp only [legal, Bool.and_eq_true] at h
  obtain ⟨⟨_, _⟩, hm⟩ := h
  split at hm
  · exact absurd hm (by simp)
  · rename_i ct hc
    simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, Bool.not_eq_true'] at hm
    exact ⟨ct, hc, hm.1.1.1, hm.1.1.2, hm.1.2, hm.2⟩

theorem legal_strike_iff {st : State} {i : Nat} {d : Dir} (h : legal st (.strike i d) = true) :
    ∃ u x y, st.pieces[i]? = some u ∧ 0 < u.hp ∧ u.owner = st.active ∧ u.acted = false ∧
      u.kind = Kind.soldier ∧ stepDir d u.x u.y = some (x, y) ∧
      ((∃ j v, pieceIdxAt st x y = some j ∧ st.pieces[j]? = some v ∧ v.owner ≠ st.active) ∨
        (pieceIdxAt st x y = none ∧ cityOfAt st (other st.active) x y = true)) := by
  simp only [legal, Bool.and_eq_true] at h
  obtain ⟨⟨_, _⟩, hm⟩ := h
  split at hm
  · exact absurd hm (by simp)
  · rename_i u hu
    simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, Bool.not_eq_true'] at hm
    obtain ⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, hm5⟩ := hm
    split at hm5
    · exact absurd hm5 (by simp)
    · rename_i x y ht
      split at hm5
      · rename_i j hj
        cases hv : st.pieces[j]? with
        | none => rw [hv] at hm5; exact absurd hm5 (by simp)
        | some v =>
          rw [hv] at hm5
          simp only [Option.map_some, Option.getD_some, bne_iff_ne, ne_eq] at hm5
          exact ⟨u, x, y, hu, h1, h2, h3, h4, ht, Or.inl ⟨j, v, hj, hv, hm5⟩⟩
      · rename_i hj
        exact ⟨u, x, y, hu, h1, h2, h3, h4, ht, Or.inr ⟨hj, hm5⟩⟩

/-! ## §3  Four ways of keeping a position well formed -/

theorem wf_congr {st st' : State} (h : WF st) (hp : st'.pieces = st.pieces)
    (hc : st'.cities = st.cities) (ha : st'.active = st.active) : WF st' where
  active := by rw [ha]; exact h.active
  piece_ok := by rw [hp]; exact h.piece_ok
  city_ok := by rw [hc]; exact h.city_ok
  piece_uniq := by simp only [hp]; exact h.piece_uniq
  city_uniq := by simp only [hc]; exact h.city_uniq

/-- Rebuild a well-formed position from one whose pieces and cities sit where the
old ones sat, with the same owners and no more health. -/
theorem wf_of_pointwise {st st' : State} (h : WF st)
    (hlen : st'.pieces.length = st.pieces.length)
    (hclen : st'.cities.length = st.cities.length)
    (hp : ∀ j, ∀ hj : j < st.pieces.length,
      (st'.pieces[j]'(by omega)).x = st.pieces[j].x ∧
      (st'.pieces[j]'(by omega)).y = st.pieces[j].y ∧
      (st'.pieces[j]'(by omega)).owner = st.pieces[j].owner ∧
      (st'.pieces[j]'(by omega)).hp ≤ st.pieces[j].hp)
    (hc : ∀ j, ∀ hj : j < st.cities.length,
      (st'.cities[j]'(by omega)).x = st.cities[j].x ∧
      (st'.cities[j]'(by omega)).y = st.cities[j].y ∧
      (st'.cities[j]'(by omega)).owner = st.cities[j].owner ∧
      (st'.cities[j]'(by omega)).hp ≤ st.cities[j].hp)
    (ha : st'.active < 2) : WF st' where
  active := ha
  piece_ok := by
    intro v hv
    obtain ⟨j, hj, rfl⟩ := List.getElem_of_mem hv
    have hj' : j < st.pieces.length := by omega
    obtain ⟨e1, e2, e3, e4⟩ := hp j hj'
    obtain ⟨g1, g2, g3, g4⟩ := h.piece_ok _ (List.getElem_mem hj')
    refine ⟨by rw [e3]; exact g1, by rw [e1]; exact g2, by rw [e2]; exact g3, ?_⟩
    intro hpos
    rw [e1, e2]
    exact g4 (by omega)
  city_ok := by
    intro v hv
    obtain ⟨j, hj, rfl⟩ := List.getElem_of_mem hv
    have hj' : j < st.cities.length := by omega
    obtain ⟨e1, e2, e3, e4⟩ := hc j hj'
    obtain ⟨g1, g2, g3, g4⟩ := h.city_ok _ (List.getElem_mem hj')
    refine ⟨by rw [e3]; exact g1, by rw [e1]; exact g2, by rw [e2]; exact g3, ?_⟩
    intro hpos
    rw [e1, e2]
    exact g4 (by omega)
  piece_uniq := by
    intro a b ha' hb' hab h1 h2
    have la : a < st.pieces.length := by omega
    have lb : b < st.pieces.length := by omega
    obtain ⟨e1, e2, _, e4⟩ := hp a la
    obtain ⟨f1, f2, _, f4⟩ := hp b lb
    rw [e1, e2, f1, f2]
    exact h.piece_uniq a b la lb hab (by omega) (by omega)
  city_uniq := by
    intro a b ha' hb' hab h1 h2
    have la : a < st.cities.length := by omega
    have lb : b < st.cities.length := by omega
    obtain ⟨e1, e2, _, e4⟩ := hc a la
    obtain ⟨f1, f2, _, f4⟩ := hc b lb
    rw [e1, e2, f1, f2]
    exact h.city_uniq a b la lb hab (by omega) (by omega)

/-- Replacing two pieces in place — where each replacement stands where the piece
it replaces stood, with the same owner and no more health — keeps the position well
formed.  This is what an attack does: the attacker is marked as having acted, the
defender loses health. -/
theorem wf_setPiece2 {st : State} {i j : Nat} {a b : Piece} (h : WF st)
    (hA : ∀ hi : i < st.pieces.length, a.x = st.pieces[i].x ∧ a.y = st.pieces[i].y ∧
      a.owner = st.pieces[i].owner ∧ a.hp ≤ st.pieces[i].hp)
    (hB : ∀ hj : j < st.pieces.length, b.x = st.pieces[j].x ∧ b.y = st.pieces[j].y ∧
      b.owner = st.pieces[j].owner ∧ b.hp ≤ st.pieces[j].hp) :
    WF (setPiece (setPiece st i a) j b) := by
  refine wf_of_pointwise h (by simp [setPiece]) (by simp [setPiece]) ?_ (fun k hk => ⟨rfl, rfl, rfl, le_refl _⟩)
    h.active
  intro k hk
  simp only [setPiece, List.getElem_set]
  split_ifs with e1 e2
  · subst e1; exact hB hk
  · subst e2; exact hA hk
  · exact ⟨rfl, rfl, rfl, le_refl _⟩

/-- The same for one piece. -/
theorem wf_setPiece1 {st : State} {i : Nat} {a : Piece} (h : WF st)
    (hA : ∀ hi : i < st.pieces.length, a.x = st.pieces[i].x ∧ a.y = st.pieces[i].y ∧
      a.owner = st.pieces[i].owner ∧ a.hp ≤ st.pieces[i].hp) :
    WF (setPiece st i a) := by
  refine wf_of_pointwise h (by simp [setPiece]) (by simp [setPiece]) ?_
    (fun k hk => ⟨rfl, rfl, rfl, le_refl _⟩) h.active
  intro k hk
  simp only [setPiece, List.getElem_set]
  split_ifs with e1
  · subst e1; exact hA hk
  · exact ⟨rfl, rfl, rfl, le_refl _⟩

/-- The same for one city: a city that is bombarded loses health and nothing else. -/
theorem wf_setCity1 {st : State} {i : Nat} {a : City} (h : WF st)
    (hA : ∀ hi : i < st.cities.length, a.x = st.cities[i].x ∧ a.y = st.cities[i].y ∧
      a.owner = st.cities[i].owner ∧ a.hp ≤ st.cities[i].hp) :
    WF (setCity st i a) := by
  refine wf_of_pointwise h (by simp [setCity]) (by simp [setCity])
    (fun k hk => ⟨rfl, rfl, rfl, le_refl _⟩) ?_ h.active
  intro k hk
  simp only [setCity, List.getElem_set]
  split_ifs with e1
  · subst e1; exact hA hk
  · exact ⟨rfl, rfl, rfl, le_refl _⟩

/-- Moving a piece to a free, passable tile keeps the position well formed. -/
theorem wf_setPiece {st : State} {i : Nat} {u' : Piece} (h : WF st)
    (hown : u'.owner < 2) (hx : u'.x < W) (hy : u'.y < H) (hpass : 0 < u'.hp → passable u'.x u'.y)
    (hfree : ∀ j, ∀ hj : j < st.pieces.length, j ≠ i → 0 < st.pieces[j].hp → 0 < u'.hp →
        ¬(u'.x = st.pieces[j].x ∧ u'.y = st.pieces[j].y)) :
    WF (setPiece st i u') where
  active := h.active
  piece_ok := by
    intro v hv
    rcases List.mem_or_eq_of_mem_set hv with hv' | hv'
    · exact h.piece_ok v hv'
    · subst hv'; exact ⟨hown, hx, hy, hpass⟩
  city_ok := h.city_ok
  piece_uniq := by
    intro a b ha hb hab h1 h2
    simp only [setPiece, List.length_set] at ha hb
    simp only [setPiece, List.getElem_set] at h1 h2 ⊢
    split_ifs at h1 h2 ⊢ with e1 e2
    · exact absurd (e1.symm.trans e2) hab
    · exact hfree b hb (fun hbi => e2 hbi.symm) h2 h1
    · intro hcon
      exact hfree a ha (fun hai => e1 hai.symm) h1 h2 ⟨hcon.1.symm, hcon.2.symm⟩
    · exact h.piece_uniq a b ha hb hab h1 h2
  city_uniq := h.city_uniq

/-- Putting a new piece on a free, passable tile keeps the position well formed. -/
theorem wf_addPiece {st : State} {u' : Piece} (h : WF st)
    (hown : u'.owner < 2) (hx : u'.x < W) (hy : u'.y < H) (hpass : 0 < u'.hp → passable u'.x u'.y)
    (hfree : ∀ j, ∀ hj : j < st.pieces.length, 0 < st.pieces[j].hp → 0 < u'.hp →
        ¬(u'.x = st.pieces[j].x ∧ u'.y = st.pieces[j].y)) :
    WF { st with pieces := st.pieces ++ [u'] } where
  active := h.active
  piece_ok := by
    intro v hv
    rcases List.mem_append.1 hv with hv' | hv'
    · exact h.piece_ok v hv'
    · simp at hv'; subst hv'; exact ⟨hown, hx, hy, hpass⟩
  city_ok := h.city_ok
  piece_uniq := by
    intro a b ha hb hab h1 h2
    simp only [List.length_append, List.length_cons, List.length_nil] at ha hb
    by_cases hA : a < st.pieces.length <;> by_cases hB : b < st.pieces.length
    · simp only [List.getElem_append_left hA, List.getElem_append_left hB] at h1 h2 ⊢
      exact h.piece_uniq a b hA hB hab h1 h2
    · have hb' : b = st.pieces.length := by omega
      subst hb'
      simp only [List.getElem_append_left hA, List.getElem_append_right (le_refl _),
        Nat.sub_self] at h1 h2 ⊢
      intro hcon
      exact hfree a hA h1 (by simpa using h2) ⟨hcon.1.symm, hcon.2.symm⟩
    · have ha' : a = st.pieces.length := by omega
      subst ha'
      simp only [List.getElem_append_left hB, List.getElem_append_right (le_refl _),
        Nat.sub_self] at h1 h2 ⊢
      exact hfree b hB h2 (by simpa using h1)
    · omega
  city_uniq := h.city_uniq

/-- Founding a city on a tile that has none keeps the position well formed. -/
theorem wf_addCity {st : State} {c' : City} (h : WF st)
    (hown : c'.owner < 2) (hx : c'.x < W) (hy : c'.y < H) (hpass : 0 < c'.hp → passable c'.x c'.y)
    (hfree : ∀ j, ∀ hj : j < st.cities.length, 0 < st.cities[j].hp → 0 < c'.hp →
        ¬(c'.x = st.cities[j].x ∧ c'.y = st.cities[j].y)) :
    WF { st with cities := st.cities ++ [c'] } where
  active := h.active
  piece_ok := h.piece_ok
  city_ok := by
    intro v hv
    rcases List.mem_append.1 hv with hv' | hv'
    · exact h.city_ok v hv'
    · simp at hv'; subst hv'; exact ⟨hown, hx, hy, hpass⟩
  piece_uniq := h.piece_uniq
  city_uniq := by
    intro a b ha hb hab h1 h2
    simp only [List.length_append, List.length_cons, List.length_nil] at ha hb
    by_cases hA : a < st.cities.length <;> by_cases hB : b < st.cities.length
    · simp only [List.getElem_append_left hA, List.getElem_append_left hB] at h1 h2 ⊢
      exact h.city_uniq a b hA hB hab h1 h2
    · have hb' : b = st.cities.length := by omega
      subst hb'
      simp only [List.getElem_append_left hA, List.getElem_append_right (le_refl _),
        Nat.sub_self] at h1 h2 ⊢
      intro hcon
      exact hfree a hA h1 (by simpa using h2) ⟨hcon.1.symm, hcon.2.symm⟩
    · have ha' : a = st.cities.length := by omega
      subst ha'
      simp only [List.getElem_append_left hB, List.getElem_append_right (le_refl _),
        Nat.sub_self] at h1 h2 ⊢
      exact hfree b hB h2 (by simpa using h1)
    · omega

/-- A position whose pieces are relabelled without moving them — which is what the
end of a turn does, clearing the `acted` flags — is still well formed. -/
theorem wf_of_map {st st' : State} (h : WF st) (f : Piece → Piece)
    (hf : ∀ u : Piece, (f u).x = u.x ∧ (f u).y = u.y ∧ (f u).hp = u.hp ∧ (f u).owner = u.owner)
    (hp : st'.pieces = st.pieces.map f) (hc : st'.cities = st.cities) (ha : st'.active < 2) :
    WF st' where
  active := ha
  piece_ok := by
    intro v hv
    rw [hp] at hv
    obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hv
    obtain ⟨h1, h2, h3, h4⟩ := hf u
    obtain ⟨g1, g2, g3, g4⟩ := h.piece_ok u hu
    exact ⟨by rw [h4]; exact g1, by rw [h1]; exact g2, by rw [h2]; exact g3,
      by rw [h1, h2, h3]; exact g4⟩
  city_ok := by rw [hc]; exact h.city_ok
  piece_uniq := by
    intro a b ha' hb' hab h1 h2
    have la : a < st.pieces.length := by simpa [hp] using ha'
    have lb : b < st.pieces.length := by simpa [hp] using hb'
    simp only [hp, List.getElem_map] at h1 h2 ⊢
    rw [(hf _).1, (hf _).1, (hf _).2.1, (hf _).2.1]
    rw [(hf _).2.2.1] at h1
    rw [(hf _).2.2.1] at h2
    exact h.piece_uniq a b la lb hab h1 h2
  city_uniq := by simp only [hc]; exact h.city_uniq

/-! ## §4  What each move does -/

theorem apply_march {st : State} {i : Nat} {d : Dir} {u : Piece} {x y : Nat}
    (hu : st.pieces[i]? = some u) (ht : stepDir d u.x u.y = some (x, y)) :
    apply st (.march i d) = setPiece st i { u with x := x, y := y, acted := true } := by
  simp [apply, hu, ht]

theorem apply_gather {st : State} {i : Nat} {u : Piece} (hu : st.pieces[i]? = some u) :
    apply st (.gather i) =
      (setPiece st i { u with acted := true }).setBank st.active
        ((st.bank st.active).add (yieldOf (terrainAt u.x u.y))) := by
  simp [apply, hu]

theorem apply_found {st : State} {i : Nat} {u : Piece} (hu : st.pieces[i]? = some u) :
    apply st (.found i) =
      State.setBank
        { setPiece st i { u with hp := 0 } with
            cities := st.cities ++ [(⟨st.active, u.x, u.y, cityHp⟩ : City)] }
        st.active ((st.bank st.active).sub foundCost) := by
  simp [apply, hu, setPiece]

theorem apply_train {st : State} {c : Nat} {k : Kind} {ct : City} (hc : st.cities[c]? = some ct) :
    apply st (.train c k) =
      State.setBank
        { st with pieces := st.pieces ++ [(⟨st.active, k, ct.x, ct.y, startHp k, true⟩ : Piece)] }
        st.active ((st.bank st.active).sub (costOf k)) := by
  simp [apply, hc]

theorem endTurn_fields (st : State) :
    (apply st .endTurn).pieces =
        st.pieces.map (fun u => if u.owner = other st.active then { u with acted := false } else u)
      ∧ (apply st .endTurn).cities = st.cities
      ∧ (apply st .endTurn).active = other st.active
      ∧ (apply st .endTurn).turn = st.turn + 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [apply, setBank_pieces, setBank_cities]

theorem apply_strike_piece {st : State} {i j : Nat} {d : Dir} {u v : Piece} {x y : Nat}
    (hu : st.pieces[i]? = some u) (ht : stepDir d u.x u.y = some (x, y))
    (hj : pieceIdxAt st x y = some j) (hv : st.pieces[j]? = some v) :
    apply st (.strike i d) =
      setPiece (setPiece st i { u with acted := true }) j
        { v with hp := v.hp - damage u.x u.y x y } := by
  simp [apply, hu, ht, hj, hv]

theorem apply_strike_gone {st : State} {i j : Nat} {d : Dir} {u : Piece} {x y : Nat}
    (hu : st.pieces[i]? = some u) (ht : stepDir d u.x u.y = some (x, y))
    (hj : pieceIdxAt st x y = some j) (hv : st.pieces[j]? = none) :
    apply st (.strike i d) = setPiece st i { u with acted := true } := by
  simp [apply, hu, ht, hj, hv]

theorem apply_strike_city {st : State} {i j : Nat} {d : Dir} {u : Piece} {ct : City} {x y : Nat}
    (hu : st.pieces[i]? = some u) (ht : stepDir d u.x u.y = some (x, y))
    (hj : pieceIdxAt st x y = none) (hc : cityIdxAt st x y = some j)
    (hct : st.cities[j]? = some ct) :
    apply st (.strike i d) =
      setCity (setPiece st i { u with acted := true }) j
        { ct with hp := ct.hp - damage u.x u.y x y } := by
  simp [apply, hu, ht, hj, hc, hct]

theorem apply_strike_nocity {st : State} {i : Nat} {d : Dir} {u : Piece} {x y : Nat}
    (hu : st.pieces[i]? = some u) (ht : stepDir d u.x u.y = some (x, y))
    (hj : pieceIdxAt st x y = none) (hc : cityIdxAt st x y = none) :
    apply st (.strike i d) = setPiece st i { u with acted := true } := by
  simp [apply, hu, ht, hj, hc]

theorem apply_strike_razed {st : State} {i j : Nat} {d : Dir} {u : Piece} {x y : Nat}
    (hu : st.pieces[i]? = some u) (ht : stepDir d u.x u.y = some (x, y))
    (hj : pieceIdxAt st x y = none) (hc : cityIdxAt st x y = some j)
    (hct : st.cities[j]? = none) :
    apply st (.strike i d) = setPiece st i { u with acted := true } := by
  simp [apply, hu, ht, hj, hc, hct]

/-! ## §5  Well-formedness is preserved -/

theorem wf_apply_march {st : State} {i : Nat} {d : Dir} (h : WF st)
    (hleg : legal st (.march i d) = true) : WF (apply st (.march i d)) := by
  obtain ⟨u, x, y, hu, hhp, hown, hact, ht, hpass, hocc⟩ := legal_march_iff hleg
  rw [apply_march hu ht]
  have humem : u ∈ st.pieces := List.mem_of_getElem? hu
  obtain ⟨o1, o2, o3, o4⟩ := h.piece_ok u humem
  obtain ⟨bx, by'⟩ := stepDir_bounds o2 o3 ht
  refine wf_setPiece h ?_ bx by' (fun _ => hpass) ?_
  · show u.owner < 2
    rw [hown]; exact h.active
  · intro j hj _ hjhp _ hcon
    exact occupied_false hocc st.pieces[j] (List.getElem_mem hj) hjhp ⟨hcon.1.symm, hcon.2.symm⟩

theorem wf_apply_gather {st : State} {i : Nat} (h : WF st)
    (hleg : legal st (.gather i) = true) : WF (apply st (.gather i)) := by
  obtain ⟨u, hu, _, _, _, _⟩ := legal_gather_iff hleg
  rw [apply_gather hu]
  refine wf_congr ?_ (setBank_pieces _ _ _) (setBank_cities _ _ _) (setBank_active _ _ _)
  refine wf_setPiece1 h ?_
  intro hi
  have : st.pieces[i] = u := by
    have := List.getElem?_eq_getElem hi
    rw [hu] at this
    exact (Option.some.inj this).symm
  rw [this]
  exact ⟨rfl, rfl, rfl, le_refl _⟩

theorem wf_apply_strike {st : State} {i : Nat} {d : Dir} (h : WF st)
    (hleg : legal st (.strike i d) = true) : WF (apply st (.strike i d)) := by
  obtain ⟨u, x, y, hu, hhp, hown, hact, hkind, ht, hcase⟩ := legal_strike_iff hleg
  have hui : ∀ hi : i < st.pieces.length, st.pieces[i] = u := by
    intro hi
    have := List.getElem?_eq_getElem hi
    rw [hu] at this
    exact (Option.some.inj this).symm
  have hattack : ∀ (b : Bool), ∀ hi : i < st.pieces.length,
      ({ u with acted := b } : Piece).x = st.pieces[i].x ∧
      ({ u with acted := b } : Piece).y = st.pieces[i].y ∧
      ({ u with acted := b } : Piece).owner = st.pieces[i].owner ∧
      ({ u with acted := b } : Piece).hp ≤ st.pieces[i].hp := by
    intro b hi; rw [hui hi]; exact ⟨rfl, rfl, rfl, le_refl _⟩
  simp only [apply, hu, ht]
  rcases hcase with ⟨j, v, hj, hv, _⟩ | ⟨hj, hcity⟩
  · simp only [hj, hv]
    refine wf_setPiece2 h (hattack true) ?_
    intro hjl
    have hvj : st.pieces[j] = v := by
      have := List.getElem?_eq_getElem hjl
      rw [hv] at this
      exact (Option.some.inj this).symm
    rw [hvj]
    exact ⟨rfl, rfl, rfl, Nat.sub_le _ _⟩
  · simp only [hj]
    have hpiece : WF (setPiece st i { u with acted := true }) := wf_setPiece1 h (hattack true)
    cases hc : cityIdxAt st x y with
    | none => simpa only [hc] using hpiece
    | some j =>
      cases hct : st.cities[j]? with
      | none => simpa only [hc, hct] using hpiece
      | some ct =>
        simp only [hct]
        refine wf_setCity1 hpiece ?_
        intro hjl
        have : (setPiece st i { u with acted := true }).cities = st.cities := rfl
        have hjl' : j < st.cities.length := by simpa [setPiece] using hjl
        have hctj : st.cities[j] = ct := by
          have := List.getElem?_eq_getElem hjl'
          rw [hct] at this
          exact (Option.some.inj this).symm
        show _ ∧ _ ∧ _ ∧ _
        simp only [setPiece] at *
        rw [hctj]
        exact ⟨rfl, rfl, rfl, Nat.sub_le _ _⟩

theorem wf_apply_found {st : State} {i : Nat} (h : WF st)
    (hleg : legal st (.found i) = true) : WF (apply st (.found i)) := by
  obtain ⟨u, hu, hhp, hown, hact, hkind, hterr, hcity, hbank⟩ := legal_found_iff hleg
  rw [apply_found hu]
  refine wf_congr ?_ (setBank_pieces _ _ _) (setBank_cities _ _ _) (setBank_active _ _ _)
  have humem : u ∈ st.pieces := List.mem_of_getElem? hu
  obtain ⟨o1, o2, o3, o4⟩ := h.piece_ok u humem
  have hp1 : WF (setPiece st i { u with hp := 0 }) := by
    refine wf_setPiece1 h ?_
    intro hi
    have : st.pieces[i] = u := by
      have := List.getElem?_eq_getElem hi
      rw [hu] at this
      exact (Option.some.inj this).symm
    rw [this]
    exact ⟨rfl, rfl, rfl, Nat.zero_le _⟩
  refine wf_addCity hp1 h.active o2 o3 (fun _ => passable_of_plains hterr) ?_
  intro j hj hjhp _ hcon
  have hj' : j < st.cities.length := by simpa [setPiece] using hj
  exact cityAt_false hcity st.cities[j] (List.getElem_mem hj') hjhp ⟨hcon.1.symm, hcon.2.symm⟩

theorem wf_apply_train {st : State} {c : Nat} {k : Kind} (h : WF st)
    (hleg : legal st (.train c k) = true) : WF (apply st (.train c k)) := by
  obtain ⟨ct, hc, hhp, hown, hbank, hocc⟩ := legal_train_iff hleg
  rw [apply_train hc]
  refine wf_congr ?_ (setBank_pieces _ _ _) (setBank_cities _ _ _) (setBank_active _ _ _)
  have hctmem : ct ∈ st.cities := List.mem_of_getElem? hc
  obtain ⟨o1, o2, o3, o4⟩ := h.city_ok ct hctmem
  refine wf_addPiece h h.active o2 o3 (fun _ => o4 hhp) ?_
  intro j hj hjhp _ hcon
  exact occupied_false hocc st.pieces[j] (List.getElem_mem hj) hjhp ⟨hcon.1.symm, hcon.2.symm⟩

theorem wf_endTurn {st : State} (h : WF st) : WF (apply st .endTurn) := by
  have hf := endTurn_fields st
  refine wf_of_map h _ ?_ hf.1 hf.2.1 ?_
  · intro u; by_cases hu : u.owner = other st.active <;> simp [hu]
  · rw [hf.2.2.1]
    have := h.active
    unfold other
    omega

/-- A legal move keeps the position well formed. -/
theorem step_wf {st st' : State} {mv : Move} (h : WF st) (hs : step st mv = some st') :
    WF st' := by
  rw [step] at hs
  split at hs
  · rename_i hleg
    obtain rfl : apply st mv = st' := Option.some.inj hs
    cases mv with
    | march i d => exact wf_apply_march h hleg
    | strike i d => exact wf_apply_strike h hleg
    | gather i => exact wf_apply_gather h hleg
    | found i => exact wf_apply_found h hleg
    | train c k => exact wf_apply_train h hleg
    | endTurn => exact wf_endTurn h
  · exact absurd hs (by simp)

/-- A whole game keeps the position well formed. -/
theorem play_wf {st st' : State} {ms : List Move} (h : WF st) (hs : play st ms = some st') :
    WF st' := by
  induction ms generalizing st with
  | nil => simp only [play, Option.some.injEq] at hs; exact hs ▸ h
  | cons m ms ih =>
    simp only [play, Option.bind_eq_some_iff] at hs
    obtain ⟨st1, h1, h2⟩ := hs
    exact ih (step_wf h h1) h2

/-- The opening position is well formed. -/
theorem wf_initial : WF initial := by
  refine ⟨by decide, by decide, by decide, ?_, ?_⟩
  · intro i j hi hj hij h1 h2
    simp only [initial, List.length_cons, List.length_nil] at hi hj
    interval_cases i <;> interval_cases j <;> simp_all [initial]
  · intro i j hi hj
    simp only [initial, List.length_nil] at hi
    omega

/-! ## §6  Nothing is created out of nothing -/

theorem getElem_of_getElem? {α} {l : List α} {i : Nat} {u : α} (hu : l[i]? = some u)
    (hi : i < l.length) : l[i] = u := by
  have := List.getElem?_eq_getElem hi
  rw [hu] at this
  exact (Option.some.inj this).symm

theorem lt_of_getElem? {α} {l : List α} {i : Nat} {u : α} (hu : l[i]? = some u) :
    i < l.length := by
  by_contra hc
  rw [List.getElem?_eq_none (by omega)] at hu
  simp at hu

/-- `Shape st st'`: nothing has been removed and nothing has been revived. -/
def Shape (st st' : State) : Prop :=
  st.pieces.length ≤ st'.pieces.length ∧ st.cities.length ≤ st'.cities.length ∧
  (∀ i, ∀ hi : i < st.pieces.length, ∀ hi' : i < st'.pieces.length,
      st'.pieces[i].hp ≤ st.pieces[i].hp ∧ st'.pieces[i].owner = st.pieces[i].owner ∧
      st'.pieces[i].kind = st.pieces[i].kind) ∧
  (∀ i, ∀ hi : i < st.cities.length, ∀ hi' : i < st'.cities.length,
      st'.cities[i].hp ≤ st.cities[i].hp ∧ st'.cities[i].owner = st.cities[i].owner)

theorem Shape.rfl' (st : State) : Shape st st :=
  ⟨le_refl _, le_refl _, fun _ _ _ => ⟨le_refl _, rfl, rfl⟩, fun _ _ _ => ⟨le_refl _, rfl⟩⟩

theorem Shape.trans {a b c : State} (h1 : Shape a b) (h2 : Shape b c) : Shape a c := by
  obtain ⟨l1, m1, p1, c1⟩ := h1
  obtain ⟨l2, m2, p2, c2⟩ := h2
  refine ⟨by omega, by omega, ?_, ?_⟩
  · intro i hi hi'
    have hb : i < b.pieces.length := by omega
    obtain ⟨q1, q2, q3⟩ := p1 i hi hb
    obtain ⟨r1, r2, r3⟩ := p2 i hb hi'
    exact ⟨by omega, by rw [r2, q2], by rw [r3, q3]⟩
  · intro i hi hi'
    have hb : i < b.cities.length := by omega
    obtain ⟨q1, q2⟩ := c1 i hi hb
    obtain ⟨r1, r2⟩ := c2 i hb hi'
    exact ⟨by omega, by rw [r2, q2]⟩

theorem shape_congr {st st' : State} (hp : st'.pieces = st.pieces) (hc : st'.cities = st.cities) :
    Shape st st' := by
  refine ⟨by rw [hp], by rw [hc], ?_, ?_⟩
  · intro i hi hi'
    have hg : st'.pieces[i]'hi' = st.pieces[i]'hi := by simp only [hp]
    rw [hg]
    exact ⟨le_refl _, rfl, rfl⟩
  · intro i hi hi'
    have hg : st'.cities[i]'hi' = st.cities[i]'hi := by simp only [hc]
    rw [hg]
    exact ⟨le_refl _, rfl⟩

theorem shape_setPiece' {st : State} {i : Nat} {a : Piece}
    (h : ∀ u, st.pieces[i]? = some u → a.hp ≤ u.hp ∧ a.owner = u.owner ∧ a.kind = u.kind) :
    Shape st (setPiece st i a) := by
  refine ⟨by simp [setPiece], le_refl _, ?_, fun i hi hi' => ⟨le_refl _, rfl⟩⟩
  intro j hj hj'
  simp only [setPiece, List.getElem_set]
  split_ifs with e
  · subst e
    exact h _ (List.getElem?_eq_getElem hj)
  · exact ⟨le_refl _, rfl, rfl⟩

theorem shape_setPiece {st : State} {i : Nat} {u a : Piece} (hu : st.pieces[i]? = some u)
    (hhp : a.hp ≤ u.hp) (ho : a.owner = u.owner) (hk : a.kind = u.kind) :
    Shape st (setPiece st i a) := by
  refine shape_setPiece' ?_
  intro w hw
  rw [hu] at hw
  obtain rfl : u = w := Option.some.inj hw
  exact ⟨hhp, ho, hk⟩

theorem shape_setCity {st : State} {i : Nat} {ct a : City} (hu : st.cities[i]? = some ct)
    (hhp : a.hp ≤ ct.hp) (ho : a.owner = ct.owner) :
    Shape st (setCity st i a) := by
  refine ⟨le_refl _, by simp [setCity], fun i hi hi' => ⟨le_refl _, rfl, rfl⟩, ?_⟩
  intro j hj hj'
  simp only [setCity, List.getElem_set]
  split_ifs with e
  · subst e; rw [getElem_of_getElem? hu hj]; exact ⟨hhp, ho⟩
  · exact ⟨le_refl _, rfl⟩

theorem shape_addPiece (st : State) (a : Piece) :
    Shape st { st with pieces := st.pieces ++ [a] } := by
  refine ⟨by simp, le_refl _, ?_, fun i hi hi' => ⟨le_refl _, rfl⟩⟩
  intro j hj hj'
  rw [List.getElem_append_left hj]
  exact ⟨le_refl _, rfl, rfl⟩

theorem shape_addCity (st : State) (a : City) :
    Shape st { st with cities := st.cities ++ [a] } := by
  refine ⟨le_refl _, by simp, fun i hi hi' => ⟨le_refl _, rfl, rfl⟩, ?_⟩
  intro j hj hj'
  rw [List.getElem_append_left hj]
  exact ⟨le_refl _, rfl⟩

theorem shape_setBank (st : State) (p : Nat) (r : Res) : Shape st (st.setBank p r) :=
  shape_congr (setBank_pieces _ _ _) (setBank_cities _ _ _)

/-- Any move at all — legal or not — only ever adds at the end and never revives. -/
theorem apply_shape (st : State) (mv : Move) : Shape st (apply st mv) := by
  cases mv with
  | march i d =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.march i d) = st by simp [apply, hu]]; exact Shape.rfl' st
    | some u =>
      cases ht : stepDir d u.x u.y with
      | none => rw [show apply st (.march i d) = st by simp [apply, hu, ht]]; exact Shape.rfl' st
      | some p =>
        obtain ⟨x, y⟩ := p
        rw [apply_march hu ht]
        exact shape_setPiece (a := { u with x := x, y := y, acted := true }) hu
          (le_refl _) rfl rfl
  | gather i =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.gather i) = st by simp [apply, hu]]; exact Shape.rfl' st
    | some u =>
      rw [apply_gather hu]
      exact (shape_setPiece (a := { u with acted := true }) hu (le_refl _) rfl rfl).trans
        (shape_setBank _ _ _)
  | found i =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.found i) = st by simp [apply, hu]]; exact Shape.rfl' st
    | some u =>
      rw [apply_found hu]
      exact ((shape_setPiece (a := { u with hp := 0 }) hu (Nat.zero_le _) rfl rfl).trans
        (shape_addCity _ _)).trans (shape_setBank _ _ _)
  | train c k =>
    cases hc : st.cities[c]? with
    | none => rw [show apply st (.train c k) = st by simp [apply, hc]]; exact Shape.rfl' st
    | some ct =>
      rw [apply_train hc]
      exact (shape_addPiece _ _).trans (shape_setBank _ _ _)
  | endTurn =>
    obtain ⟨hp, hc, _, _⟩ := endTurn_fields st
    refine ⟨by rw [hp]; simp, by rw [hc], ?_, ?_⟩
    · intro j hj hj'
      have hg : (apply st .endTurn).pieces[j]'hj' =
          (if st.pieces[j].owner = other st.active then { st.pieces[j] with acted := false }
            else st.pieces[j]) := by
        simp only [hp, List.getElem_map]
      rw [hg]
      split_ifs <;> exact ⟨le_refl _, rfl, rfl⟩
    · intro j hj hj'
      have hg : (apply st .endTurn).cities[j]'hj' = st.cities[j] := by simp only [hc]
      rw [hg]
      exact ⟨le_refl _, rfl⟩
  | strike i d =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.strike i d) = st by simp [apply, hu]]; exact Shape.rfl' st
    | some u =>
      cases ht : stepDir d u.x u.y with
      | none => rw [show apply st (.strike i d) = st by simp [apply, hu, ht]]; exact Shape.rfl' st
      | some p =>
        obtain ⟨x, y⟩ := p
        cases hj : pieceIdxAt st x y with
        | some j =>
          cases hv : st.pieces[j]? with
          | none =>
            rw [apply_strike_gone hu ht hj hv]
            exact shape_setPiece (a := { u with acted := true }) hu (le_refl _) rfl rfl
          | some v =>
            rw [apply_strike_piece hu ht hj hv]
            refine (shape_setPiece (a := { u with acted := true }) hu
              (le_refl _) rfl rfl).trans (shape_setPiece' ?_)
            intro w hw
            by_cases hji : j = i
            · subst hji
              have hlt : j < st.pieces.length := lt_of_getElem? hu
              have : (setPiece st j { u with acted := true }).pieces[j]? =
                  some { u with acted := true } := by
                simp [setPiece, hlt]
              rw [this] at hw
              obtain rfl : ({ u with acted := true } : Piece) = w := Option.some.inj hw
              have huv : u = v := by rw [hu] at hv; exact Option.some.inj hv
              subst huv
              exact ⟨Nat.sub_le _ _, rfl, rfl⟩
            · have : (setPiece st i { u with acted := true }).pieces[j]? = st.pieces[j]? := by
                simp [setPiece, Ne.symm hji]
              rw [this, hv] at hw
              obtain rfl : v = w := Option.some.inj hw
              exact ⟨Nat.sub_le _ _, rfl, rfl⟩
        | none =>
          cases hc : cityIdxAt st x y with
          | none =>
            rw [apply_strike_nocity hu ht hj hc]
            exact shape_setPiece (a := { u with acted := true }) hu (le_refl _) rfl rfl
          | some j =>
            cases hct : st.cities[j]? with
            | none =>
              rw [apply_strike_razed hu ht hj hc hct]
              exact shape_setPiece (a := { u with acted := true }) hu (le_refl _) rfl rfl
            | some ct =>
              rw [apply_strike_city hu ht hj hc hct]
              exact (shape_setPiece (a := { u with acted := true }) hu (le_refl _) rfl rfl).trans
                (shape_setCity (ct := ct) (by exact hct) (Nat.sub_le _ _) rfl)

/-- A legal move is applied. -/
theorem apply_of_step {st st' : State} {mv : Move} (hs : step st mv = some st') :
    apply st mv = st' := by
  unfold step at hs
  split at hs
  · exact Option.some.inj hs
  · exact absurd hs (by simp)

/-- A legal move is legal. -/
theorem legal_of_step {st st' : State} {mv : Move} (hs : step st mv = some st') :
    legal st mv = true := by
  unfold step at hs
  split at hs
  · assumption
  · exact absurd hs (by simp)


/-- A move never removes a piece from the list, and only ever appends. -/
theorem step_pieces_length_le {st st' : State} {mv : Move} (hs : step st mv = some st') :
    st.pieces.length ≤ st'.pieces.length := by
  rw [← apply_of_step hs]; exact (apply_shape st mv).1

/-- Health never increases: the dead stay dead. -/
theorem step_hp_le {st st' : State} {mv : Move} (hs : step st mv = some st')
    (i : Nat) (hi : i < st.pieces.length) (hi' : i < st'.pieces.length) :
    st'.pieces[i].hp ≤ st.pieces[i].hp := by
  have he := apply_of_step hs
  subst he
  exact ((apply_shape st mv).2.2.1 i hi hi').1

/-- A piece keeps its owner and its kind for ever. -/
theorem step_owner_kind {st st' : State} {mv : Move} (hs : step st mv = some st')
    (i : Nat) (hi : i < st.pieces.length) (hi' : i < st'.pieces.length) :
    st'.pieces[i].owner = st.pieces[i].owner ∧ st'.pieces[i].kind = st.pieces[i].kind := by
  have he := apply_of_step hs
  subst he
  exact ((apply_shape st mv).2.2.1 i hi hi').2

/-- Cities are never removed either, and a razed city stays razed. -/
theorem step_city_hp_le {st st' : State} {mv : Move} (hs : step st mv = some st')
    (i : Nat) (hi : i < st.cities.length) (hi' : i < st'.cities.length) :
    st'.cities[i].hp ≤ st.cities[i].hp := by
  have he := apply_of_step hs
  subst he
  exact ((apply_shape st mv).2.2.2 i hi hi').1

/-- Only `gather` and `endTurn` bring resources in; every other move can only spend. -/
theorem step_bank_le {st st' : State} {mv : Move} (hs : step st mv = some st')
    (hmv : (∀ i, mv ≠ Move.gather i) ∧ mv ≠ Move.endTurn) (p : Nat) :
    (st'.bank p).food ≤ (st.bank p).food ∧ (st'.bank p).wood ≤ (st.bank p).wood ∧
      (st'.bank p).gold ≤ (st.bank p).gold := by
  have he := apply_of_step hs
  subst he
  cases mv with
  | gather i => exact absurd rfl (hmv.1 i)
  | endTurn => exact absurd rfl hmv.2
  | march i d =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.march i d) = st by simp [apply, hu]]; exact ⟨le_refl _, le_refl _, le_refl _⟩
    | some u =>
      cases ht : stepDir d u.x u.y with
      | none =>
        rw [show apply st (.march i d) = st by simp [apply, hu, ht]]
        exact ⟨le_refl _, le_refl _, le_refl _⟩
      | some q =>
        obtain ⟨x, y⟩ := q
        rw [apply_march hu ht, setPiece_bank]
        exact ⟨le_refl _, le_refl _, le_refl _⟩
  | found i =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.found i) = st by simp [apply, hu]]; exact ⟨le_refl _, le_refl _, le_refl _⟩
    | some u =>
      rw [apply_found hu]
      have hb : ∀ q, ({ setPiece st i { u with hp := 0 } with
          cities := st.cities ++ [(⟨st.active, u.x, u.y, cityHp⟩ : City)] } : State).bank q
          = st.bank q := by
        intro q; unfold State.bank setPiece; simp
      rw [show ((st.bank st.active).sub foundCost) =
        ((({ setPiece st i { u with hp := 0 } with
          cities := st.cities ++ [(⟨st.active, u.x, u.y, cityHp⟩ : City)] } : State)).bank st.active).sub
            foundCost by rw [hb]]
      have := setBank_sub_le ({ setPiece st i { u with hp := 0 } with
          cities := st.cities ++ [(⟨st.active, u.x, u.y, cityHp⟩ : City)] } : State) st.active p foundCost
      rw [hb] at this
      exact this
  | train c k =>
    cases hc : st.cities[c]? with
    | none => rw [show apply st (.train c k) = st by simp [apply, hc]]; exact ⟨le_refl _, le_refl _, le_refl _⟩
    | some ct =>
      rw [apply_train hc]
      have hb : ∀ q, ({ st with
          pieces := st.pieces ++ [(⟨st.active, k, ct.x, ct.y, startHp k, true⟩ : Piece)] } : State).bank q
          = st.bank q := by
        intro q; unfold State.bank; simp
      have := setBank_sub_le ({ st with
          pieces := st.pieces ++ [(⟨st.active, k, ct.x, ct.y, startHp k, true⟩ : Piece)] } : State)
          st.active p (costOf k)
      rw [hb, hb] at this
      exact this
  | strike i d =>
    cases hu : st.pieces[i]? with
    | none => rw [show apply st (.strike i d) = st by simp [apply, hu]]; exact ⟨le_refl _, le_refl _, le_refl _⟩
    | some u =>
      cases ht : stepDir d u.x u.y with
      | none =>
        rw [show apply st (.strike i d) = st by simp [apply, hu, ht]]
        exact ⟨le_refl _, le_refl _, le_refl _⟩
      | some q =>
        obtain ⟨x, y⟩ := q
        cases hj : pieceIdxAt st x y with
        | some j =>
          cases hv : st.pieces[j]? with
          | none =>
            rw [apply_strike_gone hu ht hj hv, setPiece_bank]
            exact ⟨le_refl _, le_refl _, le_refl _⟩
          | some v =>
            rw [apply_strike_piece hu ht hj hv, setPiece_bank, setPiece_bank]
            exact ⟨le_refl _, le_refl _, le_refl _⟩
        | none =>
          cases hc : cityIdxAt st x y with
          | none =>
            rw [apply_strike_nocity hu ht hj hc, setPiece_bank]
            exact ⟨le_refl _, le_refl _, le_refl _⟩
          | some j =>
            cases hct : st.cities[j]? with
            | none =>
              rw [apply_strike_razed hu ht hj hc hct, setPiece_bank]
              exact ⟨le_refl _, le_refl _, le_refl _⟩
            | some ct =>
              rw [apply_strike_city hu ht hj hc hct, setCity_bank, setPiece_bank]
              exact ⟨le_refl _, le_refl _, le_refl _⟩

/-! ## §7  The individual rules -/

/-- `gather` adds exactly the harvest of the tile the worker stands on. -/
theorem gather_bank {st st' : State} {i : Nat} (hs : step st (.gather i) = some st')
    (u : Piece) (hu : st.pieces[i]? = some u) :
    st'.bank st.active = (st.bank st.active).add (yieldOf (terrainAt u.x u.y)) := by
  have he := apply_of_step hs
  subst he
  rw [apply_gather hu, setBank_get _ _ _]

/-- `train` pays exactly the price and puts exactly one new piece on the board, at
full health, owned by the player who paid. -/
theorem train_cost {st st' : State} {c : Nat} {k : Kind} (hs : step st (.train c k) = some st')
    (ct : City) (hc : st.cities[c]? = some ct) :
    st'.bank st.active = (st.bank st.active).sub (costOf k) ∧
      st'.pieces = st.pieces ++ [⟨st.active, k, ct.x, ct.y, startHp k, true⟩] := by
  have he := apply_of_step hs
  subst he
  rw [apply_train hc]
  refine ⟨by rw [setBank_get _ _ _], by rw [setBank_pieces]⟩

/-- `found` turns the worker into a city of its own colour on its own tile. -/
theorem found_city {st st' : State} {i : Nat} (hs : step st (.found i) = some st')
    (u : Piece) (hu : st.pieces[i]? = some u) :
    st'.cities = st.cities ++ [⟨st.active, u.x, u.y, cityHp⟩] ∧
      st'.pieces = st.pieces.set i { u with hp := 0 } ∧
      st'.bank st.active = (st.bank st.active).sub foundCost := by
  have he := apply_of_step hs
  subst he
  rw [apply_found hu]
  refine ⟨by rw [setBank_cities], by rw [setBank_pieces]; rfl, by rw [setBank_get _ _ _]⟩

/-- `endTurn` hands over to the other player and advances the clock. -/
theorem endTurn_alternates {st st' : State} (h : st.active < 2) (hs : step st .endTurn = some st') :
    st'.active = other st.active ∧ st'.turn = st.turn + 1 ∧ st'.active ≠ st.active := by
  have he := apply_of_step hs
  subst he
  obtain ⟨_, _, ha, ht⟩ := endTurn_fields st
  refine ⟨ha, ht, ?_⟩
  rw [ha]
  unfold other
  omega

/-- Only the player to move may move: every move but `endTurn` and `train` acts
through a live piece of the active player that has not acted yet. -/
theorem legal_piece_owner {st : State} {mv : Move} {i : Nat} (h : legal st mv = true)
    (hi : mv.pieceIdx = some i) :
    ∃ u, st.pieces[i]? = some u ∧ u.owner = st.active ∧ 0 < u.hp ∧ u.acted = false := by
  cases mv with
  | march j d =>
    obtain rfl : j = i := Option.some.inj hi
    obtain ⟨u, x, y, hu, h1, h2, h3, _⟩ := legal_march_iff h
    exact ⟨u, hu, h2, h1, h3⟩
  | strike j d =>
    obtain rfl : j = i := Option.some.inj hi
    obtain ⟨u, x, y, hu, h1, h2, h3, _⟩ := legal_strike_iff h
    exact ⟨u, hu, h2, h1, h3⟩
  | gather j =>
    obtain rfl : j = i := Option.some.inj hi
    obtain ⟨u, hu, h1, h2, h3, _⟩ := legal_gather_iff h
    exact ⟨u, hu, h2, h1, h3⟩
  | found j =>
    obtain rfl : j = i := Option.some.inj hi
    obtain ⟨u, hu, h1, h2, h3, _⟩ := legal_found_iff h
    exact ⟨u, hu, h2, h1, h3⟩
  | train c k => exact absurd hi (by simp [Move.pieceIdx])
  | endTurn => exact absurd hi (by simp [Move.pieceIdx])

/-- Only the player to move may train, and only in a city of their own. -/
theorem legal_city_owner {st : State} {c : Nat} {k : Kind} (h : legal st (.train c k) = true) :
    ∃ ct, st.cities[c]? = some ct ∧ ct.owner = st.active ∧ 0 < ct.hp := by
  obtain ⟨ct, hc, hhp, hown, _, _⟩ := legal_train_iff h
  exact ⟨ct, hc, hown, hhp⟩

/-! ## §8  The end of the game -/

/-- At most one player can have won. -/
theorem winner_unique {st : State} {p : Nat} (h : winner st = some p) :
    p < 2 ∧ alivePlayer st p = true ∧ alivePlayer st (other p) = false := by
  unfold winner at h
  split_ifs at h with h1 h2
  · obtain rfl : (0 : Nat) = p := Option.some.inj h
    simp only [Bool.and_eq_true, Bool.not_eq_true'] at h1
    exact ⟨by omega, h1.1, by simpa [other] using h1.2⟩
  · obtain rfl : (1 : Nat) = p := Option.some.inj h
    simp only [Bool.and_eq_true, Bool.not_eq_true'] at h2
    exact ⟨by omega, h2.1, by simpa [other] using h2.2⟩

/-- Once the game is over, no move is legal: the final page is final. -/
theorem over_terminal {st : State} {p : Nat} (h : winner st = some p) (mv : Move) :
    step st mv = none := by
  simp [step, legal, h]

end Realm
