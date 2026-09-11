import RequestProject.Nix.NixWars.Holo.Archive

/-!
# The geometry of the archive: neighbours, depth shells, staggered fetches

`Archive.lean` cuts the corpus into cells and gives each one a byte interval.
This file is about where the cells are *put*, and how a client walks them.

* **Neighbours.** `Archive.nbrs` reads a cell's outbound references.  An archive
  has `MutualSupport` when the relation is symmetric: if `B` is one of the cells
  that make `A` interpretable then `A` is one of the cells that make `B`
  interpretable, so a link can be walked in either direction.
* **Depth.** `Archive.ball A k d` is everything within `d` links of the concept
  `k`, `Archive.shell A k d` the cells that first become reachable at depth `d`.
  The shells are disjoint (`shell_disjoint_of_lt`), they exhaust the ball
  (`mem_ball_iff_shell`), and `mem_ball_iff_reach` identifies the ball with the
  concepts reachable by at most `d` hops — so `R₀, R₁, R₂, …` really is a
  staggered batch schedule.  When a shell comes back empty the exploration has
  converged and further requests return nothing new (`ball_stabilises`).
  Under `MutualSupport` the geometry is reversible: `mem_ball_symm`.
* **Batches.** `decodeCells` reads a run of cells out of one response.
  `Archive.run_fetch` proves that a single range request starting at `o_i` and
  covering `o_{i+n} - o_i` bytes returns exactly the `n` consecutive cells, so
  physically adjacent cells cost one request rather than `n`.
* **Semantic distance vs byte distance.**  `LayoutNeighbourly` says consecutive
  cells in the file are linked.  Then a window of the file is a neighbourhood of
  the concept space: `getElem_mem_ball` bounds graph distance by the distance in
  cells, and `window_within_depth` says the whole `2d+1`-cell window fetched by
  one request lies within depth `d` of its centre.  Prefetching by byte
  proximity is therefore semantically sound.
-/

set_option maxRecDepth 10000

namespace NixWars
namespace Holo
namespace Archive

/-! ## Neighbours -/

/-- The cells the given concept points at. -/
def nbrs (A : Archive) (k : Nat) : List Nat :=
  match A.find? (fun c => c.key = k) with
  | some c => c.links
  | none => []

/-- **Two neighbours are mutually supportive**: each names the other, so the
link can be followed in either direction. -/
def MutualSupport (A : Archive) : Prop := ∀ j k : Nat, j ∈ A.nbrs k ↔ k ∈ A.nbrs j

/-- In an archive with distinct concept keys, a cell's neighbours are its own
links. -/
theorem nbrs_of_mem {A : Archive} (hnd : (A.map Cell.key).Nodup) {c : Cell} (hc : c ∈ A) :
    A.nbrs c.key = c.links := by
  induction A with
  | nil => cases hc
  | cons a t ih =>
    simp only [List.map_cons, List.nodup_cons, List.mem_map] at hnd
    obtain ⟨hnot, htail⟩ := hnd
    rcases List.mem_cons.mp hc with rfl | hct
    · simp [nbrs]
    · have hne : a.key ≠ c.key := fun h => hnot ⟨c, hct, h.symm⟩
      simp only [nbrs, List.find?_cons, decide_eq_false hne]
      exact ih htail hct

/-- A concept the archive does not hold has no neighbours. -/
theorem nbrs_eq_nil {A : Archive} {k : Nat} (h : ∀ c ∈ A, c.key ≠ k) : A.nbrs k = [] := by
  induction A with
  | nil => simp [nbrs]
  | cons a t ih =>
    simp only [nbrs, List.find?_cons, decide_eq_false (h a (by simp))]
    exact ih (fun c hc => h c (by simp [hc]))

/-- A checkable criterion for mutual support: the cells of the archive name
each other symmetrically. -/
theorem mutualSupport_of_cells {A : Archive} (hnd : (A.map Cell.key).Nodup)
    (hcl : LinksClosed A) (h : ∀ c ∈ A, ∀ d ∈ A, (d.key ∈ c.links ↔ c.key ∈ d.links)) :
    MutualSupport A := by
  have key : ∀ j k : Nat, j ∈ A.nbrs k → k ∈ A.nbrs j := by
    intro j k hjk
    by_cases hk : ∃ c ∈ A, c.key = k
    · obtain ⟨c, hc, rfl⟩ := hk
      rw [nbrs_of_mem hnd hc] at hjk
      obtain ⟨d, hd, hdk⟩ := hcl c hc j hjk
      subst hdk
      rw [nbrs_of_mem hnd hd]
      exact (h c hc d hd).mp hjk
    · push_neg at hk
      rw [nbrs_eq_nil (fun c hc => hk c hc)] at hjk
      exact absurd hjk (List.not_mem_nil)
  exact fun j k => ⟨key j k, key k j⟩

/-! ## Depth: balls, shells and the fetch schedule -/

/-- Everything within `d` links of the concept `k`. -/
def ball (A : Archive) (k : Nat) : Nat → List Nat
  | 0 => [k]
  | d + 1 => (A.ball k d ++ (A.ball k d).flatMap A.nbrs).dedup

/-- The cells that first become reachable at depth `d`: the batch `R_d`. -/
def shell (A : Archive) (k : Nat) : Nat → List Nat
  | 0 => [k]
  | d + 1 => (A.ball k (d + 1)).filter (fun x => x ∉ A.ball k d)

@[simp] theorem mem_ball_zero (A : Archive) (k x : Nat) : x ∈ A.ball k 0 ↔ x = k := by
  simp [ball]

theorem mem_ball_succ (A : Archive) (k x : Nat) (d : Nat) :
    x ∈ A.ball k (d + 1) ↔ x ∈ A.ball k d ∨ ∃ y ∈ A.ball k d, x ∈ A.nbrs y := by
  simp [ball, List.mem_dedup, List.mem_flatMap]

theorem ball_subset_succ (A : Archive) (k d : Nat) : A.ball k d ⊆ A.ball k (d + 1) := by
  intro x hx
  exact (mem_ball_succ A k x d).mpr (Or.inl hx)

theorem ball_mono (A : Archive) (k : Nat) {d e : Nat} (h : d ≤ e) : A.ball k d ⊆ A.ball k e := by
  induction e with
  | zero => simp [Nat.le_zero.mp h]
  | succ e ih =>
    rcases Nat.lt_or_ge d (e + 1) with hlt | hge
    · exact fun x hx => ball_subset_succ A k e (ih (Nat.lt_succ_iff.mp hlt) hx)
    · have : d = e + 1 := Nat.le_antisymm h hge
      subst this
      exact fun x hx => hx

/-- Reaching a concept from `k` in at most `d` hops. -/
inductive Reach (A : Archive) (k : Nat) : Nat → Nat → Prop
  /-- You start where you start. -/
  | zero : Reach A k 0 k
  /-- You may stop early. -/
  | stay {d x : Nat} : Reach A k d x → Reach A k (d + 1) x
  /-- You may follow a link. -/
  | hop {d x y : Nat} : Reach A k d x → y ∈ A.nbrs x → Reach A k (d + 1) y

/-- Anything reachable in at most `d` hops is in the ball of radius `d`. -/
theorem reach_mem_ball {A : Archive} {k d x : Nat} (h : Reach A k d x) : x ∈ A.ball k d := by
  induction h with
  | zero => simp
  | stay _ ih => exact (mem_ball_succ _ _ _ _).mpr (Or.inl ih)
  | hop _ hxy ih => exact (mem_ball_succ _ _ _ _).mpr (Or.inr ⟨_, ih, hxy⟩)

/-- **The ball is exactly what the client can reach**, so `ball k 0`,
`ball k 1`, … is the schedule of progressively wider batches. -/
theorem mem_ball_iff_reach (A : Archive) (k x d : Nat) : x ∈ A.ball k d ↔ Reach A k d x := by
  constructor
  · induction d generalizing x with
    | zero => intro h; rw [mem_ball_zero] at h; subst h; exact Reach.zero
    | succ d ih =>
      intro h
      rcases (mem_ball_succ A k x d).mp h with h | ⟨y, hy, hxy⟩
      · exact Reach.stay (ih x h)
      · exact Reach.hop (ih y hy) hxy
  · exact reach_mem_ball

/-- A hop taken at the *start* of a walk. -/
theorem reach_cons {A : Archive} {y d x : Nat} (h : Reach A y d x) {k : Nat}
    (hk : y ∈ A.nbrs k) : Reach A k (d + 1) x := by
  induction h with
  | zero => exact Reach.hop Reach.zero hk
  | stay _ ih => exact Reach.stay ih
  | hop _ hxy ih => exact Reach.hop ih hxy

/-- **The geometry is reversible when neighbours support each other**: if `x` is
within depth `d` of `k` then `k` is within depth `d` of `x`. -/
theorem mem_ball_symm {A : Archive} (hM : MutualSupport A) {k x d : Nat}
    (h : x ∈ A.ball k d) : k ∈ A.ball x d := by
  rw [mem_ball_iff_reach] at h ⊢
  induction h with
  | zero => exact Reach.zero
  | stay _ ih => exact Reach.stay ih
  | hop _ hxy ih => exact reach_cons ih ((hM _ _).mp hxy)

theorem shell_subset_ball (A : Archive) (k d : Nat) : A.shell k d ⊆ A.ball k d := by
  cases d with
  | zero => intro x hx; exact hx
  | succ d => intro x hx; exact (List.mem_filter.mp hx).1

theorem not_mem_ball_of_mem_shell {A : Archive} {k x d : Nat} (h : x ∈ A.shell k (d + 1)) :
    x ∉ A.ball k d := by
  have := (List.mem_filter.mp h).2
  simpa using this

/-- **The batches do not repeat work**: distinct shells are disjoint. -/
theorem shell_disjoint_of_lt {A : Archive} {k x e d : Nat} (hed : e < d)
    (he : x ∈ A.shell k e) (hd : x ∈ A.shell k d) : False := by
  obtain ⟨d', rfl⟩ : ∃ d', d = d' + 1 := ⟨d - 1, by omega⟩
  exact not_mem_ball_of_mem_shell hd
    (ball_mono A k (by omega) (shell_subset_ball A k e he))

/-- **The shells exhaust the ball**: fetching `R_0, R_1, …, R_d` in turn loads
everything within depth `d`, and nothing else. -/
theorem mem_ball_iff_shell (A : Archive) (k x d : Nat) :
    x ∈ A.ball k d ↔ ∃ e ≤ d, x ∈ A.shell k e := by
  induction d with
  | zero =>
    constructor
    · intro h; exact ⟨0, le_refl _, by simpa [shell] using h⟩
    · rintro ⟨e, he, hx⟩
      interval_cases e
      simpa [shell] using hx
  | succ d ih =>
    constructor
    · intro h
      by_cases hprev : x ∈ A.ball k d
      · obtain ⟨e, he, hx⟩ := ih.mp hprev
        exact ⟨e, by omega, hx⟩
      · exact ⟨d + 1, le_refl _, List.mem_filter.mpr ⟨h, by simpa using hprev⟩⟩
    · rintro ⟨e, he, hx⟩
      exact ball_mono A k he (shell_subset_ball A k e hx)

/-- **When a shell comes back empty, exploration has converged**: no further
request returns anything new. -/
theorem ball_stabilises {A : Archive} {k d : Nat} (h : A.ball k (d + 1) ⊆ A.ball k d) :
    ∀ n, A.ball k (d + n) ⊆ A.ball k d := by
  intro n
  induction n with
  | zero => exact fun x hx => hx
  | succ n ih =>
    intro x hx
    rw [show d + (n + 1) = (d + n) + 1 by omega] at hx
    rcases (mem_ball_succ A k x (d + n)).mp hx with hx' | ⟨y, hy, hxy⟩
    · exact ih hx'
    · exact h ((mem_ball_succ A k x d).mpr (Or.inr ⟨y, ih hy, hxy⟩))

/-! ## One request, many cells -/

/-- Read `n` cells out of one response. -/
def decodeCells : Nat → List Nat → Option (List Cell × List Nat)
  | 0, bs => some ([], bs)
  | n + 1, bs =>
    (decodeCell bs).bind fun p => (decodeCells n p.2).map fun q => (p.1 :: q.1, q.2)

theorem decodeCells_encode (cs : List Cell) (rest : List Nat) :
    decodeCells cs.length ((cs.map Cell.encode).flatten ++ rest) = some (cs, rest) := by
  induction cs generalizing rest with
  | nil => simp [decodeCells]
  | cons c t ih =>
    simp only [List.length_cons, decodeCells, List.map_cons, List.flatten_cons,
      List.append_assoc, decodeCell_encode, Option.bind_some, ih]
    simp

theorem decodeCells_take (l : List Cell) (n : Nat) :
    decodeCells (l.take n).length ((l.map Cell.encode).flatten) =
      some (l.take n, ((l.drop n).map Cell.encode).flatten) := by
  have h := decodeCells_encode (l.take n) (((l.drop n).map Cell.encode).flatten)
  have e : ((l.take n).map Cell.encode).flatten ++ ((l.drop n).map Cell.encode).flatten =
      (l.map Cell.encode).flatten := by
    rw [← List.flatten_append, ← List.map_append, List.take_append_drop]
  rwa [e] at h

/-- **A staggered batch is one request.**  Seeking to `o_i` and reading up to
`o_{i+n}` returns exactly the `n` consecutive cells `i, …, i+n-1`. -/
theorem run_fetch (A : Archive) (i n : Nat) :
    decodeCells ((A.drop i).take n).length (A.bytes.drop (A.offset i)) =
      some (((A.drop i).take n), ((A.drop (i + n)).map Cell.encode).flatten) := by
  have hd : A.drop (i + n) = (A.drop i).drop n := by rw [List.drop_drop, Nat.add_comm]
  rw [bytes_drop A i, hd, decodeCells_take]

/-- The run of `n` cells beginning at `i` is one byte interval of the file. -/
theorem run_range (A : Archive) (i n : Nat) :
    (A.bytes.drop (A.offset i)).take (A.offset (i + n) - A.offset i) =
      (((A.drop i).take n).map Cell.encode).flatten := by
  have hlen : ((((A.drop i).take n)).map Cell.encode).flatten.length =
      A.offset (i + n) - A.offset i := by
    rw [offset_add A i n]
    simp only [List.length_flatten, List.map_map]
    unfold Cell.size
    simp [Function.comp_def]
  have e : ((A.drop i).map Cell.encode).flatten =
      (((A.drop i).take n).map Cell.encode).flatten ++
        (((A.drop i).drop n).map Cell.encode).flatten := by
    rw [← List.flatten_append, ← List.map_append, List.take_append_drop]
  rw [bytes_drop A i, e, ← hlen, List.take_left]

/-! ## Semantic distance and byte distance -/

/-- Consecutive cells of the file are semantically linked: byte adjacency is
concept adjacency. -/
def LayoutNeighbourly (A : Archive) : Prop :=
  ∀ i : Nat, ∀ h : i + 1 < A.length, (A[i + 1]'h).key ∈ A.nbrs (A[i]'(by omega)).key

/-- A checkable form of `LayoutNeighbourly`. -/
def layoutCheck (A : Archive) : Bool :=
  (List.range (A.length - 1)).all fun i =>
    match A[i]?, A[i + 1]? with
    | some c, some d => decide (d.key ∈ A.nbrs c.key)
    | _, _ => false

theorem layoutNeighbourly_of_check {A : Archive} (h : layoutCheck A = true) :
    LayoutNeighbourly A := by
  intro i hi
  have hmem : i ∈ List.range (A.length - 1) := List.mem_range.mpr (by omega)
  have hall := List.all_eq_true.mp h i hmem
  rw [List.getElem?_eq_getElem (show i < A.length by omega), List.getElem?_eq_getElem hi] at hall
  simpa using hall

/-- **Semantic distance is bounded by byte distance**, forwards along the file. -/
theorem getElem_mem_ball_forward {A : Archive} (hL : LayoutNeighbourly A) (i n : Nat)
    (h : i + n < A.length) : (A[i + n]'h).key ∈ A.ball (A[i]'(by omega)).key n := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hn : i + n < A.length := by omega
    have hstep : (A[i + n + 1]'(by omega)).key ∈ A.nbrs (A[i + n]'hn).key := hL (i + n) (by omega)
    refine (mem_ball_succ _ _ _ _).mpr (Or.inr ⟨(A[i + n]'hn).key, ih hn, ?_⟩)
    simpa [show i + (n + 1) = i + n + 1 by omega] using hstep

/-- **Semantic distance is bounded by byte distance**, in both directions, when
neighbours support each other. -/
theorem getElem_mem_ball {A : Archive} (hL : LayoutNeighbourly A) (hM : MutualSupport A)
    {i j d : Nat} (hi : i < A.length) (hj : j < A.length)
    (hd : (if i ≤ j then j - i else i - j) ≤ d) :
    (A[j]'hj).key ∈ A.ball (A[i]'hi).key d := by
  rcases Nat.le_total i j with hij | hij
  · rw [if_pos hij] at hd
    obtain ⟨n, rfl⟩ : ∃ n, j = i + n := ⟨j - i, by omega⟩
    exact ball_mono A _ (by omega) (getElem_mem_ball_forward hL i n hj)
  · rcases Nat.eq_or_lt_of_le hij with rfl | hlt
    · exact ball_mono A _ (Nat.zero_le d) (by simp)
    · rw [if_neg (by omega)] at hd
      obtain ⟨n, rfl⟩ : ∃ n, i = j + n := ⟨i - j, by omega⟩
      exact mem_ball_symm hM (ball_mono A _ (by omega) (getElem_mem_ball_forward hL j n hi))

/-- **Prefetching by byte proximity is semantically sound.**  Every cell in the
window of `2d+1` cells that one range request delivers lies within depth `d` of
the concept at the centre of the window. -/
theorem window_within_depth {A : Archive} (hL : LayoutNeighbourly A) (hM : MutualSupport A)
    (i d : Nat) (h : i + (2 * d + 1) ≤ A.length) (hc : i + d < A.length) :
    ∀ c ∈ ((A.drop i).take (2 * d + 1)), c.key ∈ A.ball (A[i + d]'hc).key d := by
  intro c hcmem
  obtain ⟨t, ht, hct⟩ := List.mem_iff_getElem.mp hcmem
  have htlen : t < 2 * d + 1 := by
    rw [List.length_take, List.length_drop] at ht
    omega
  have hidx : i + t < A.length := by omega
  have hceq : c = A[i + t]'hidx := by
    rw [← hct]
    simp [List.getElem_take, List.getElem_drop]
  subst hceq
  exact getElem_mem_ball hL hM hc hidx (by split <;> omega)

end Archive
end Holo
end NixWars
