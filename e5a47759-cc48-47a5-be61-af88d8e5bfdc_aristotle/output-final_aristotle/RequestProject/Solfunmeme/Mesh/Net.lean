import RequestProject.Solfunmeme.Mesh.Quote

/-!
# The mesh: nodes that gossip boards

A mesh is a list of nodes, each holding a `Board`.  Nodes run wherever the game
runs — a browser tab, a Termux shell on a phone, a Linux daemon, a Cloudflare
worker — and the only thing they ever do to each other is **exchange**: two
peers meet and both come away holding the union of what they had.

What is proved here is what a gossip layer has to guarantee before anything
built on top of it can be trusted:

* `exchange_mono`, `deliver_mono` — knowledge never shrinks; no schedule of
  meetings can make a node forget a reading;
* `deliver_routed` — a reading travels: if the meetings contain a path from
  node `a` to node `b`, everything `a` knew reaches `b`;
* `sync_all_eq` — after a full sync every node holds exactly the union of the
  whole mesh, so the mesh converges;
* `deliver_sound` — **the mesh invents nothing**: every quote a node holds
  afterwards was held by some node before.  Gossip moves data, it does not
  create it.

Authenticity is *not* a property of this layer: gossip is unauthenticated, and
a peer can inject any quote it likes.  What stops that mattering is that
published claims are signed and re-derivable (`Mesh.Post`), so a reader checks
data against a key rather than against the network.
-/

namespace Mesh

/-- A mesh, as a list of node boards indexed by node number. -/
abbrev Net := List Board

/-- What node `i` holds (the empty board if there is no such node). -/
def get (n : Net) (i : Nat) : Board := (n[i]?).getD []

/-- Replace node `i`'s board. -/
def upd (n : Net) (i : Nat) (b : Board) : Net := n.set i b

@[simp] theorem length_upd (n : Net) (i : Nat) (b : Board) : (upd n i b).length = n.length := by
  simp [upd]

theorem get_upd_self {n : Net} {i : Nat} (h : i < n.length) (b : Board) :
    get (upd n i b) i = b := by
  simp [get, upd, h]

theorem get_upd_ne {n : Net} {i k : Nat} (h : k ≠ i) (b : Board) :
    get (upd n i b) k = get n k := by
  simp [get, upd, List.getElem?_set_ne (Ne.symm h)]

theorem get_upd_out {n : Net} {i : Nat} (h : ¬ i < n.length) (b : Board) :
    get (upd n i b) i = get n i := by
  have : n.set i b = n := List.set_eq_of_length_le (by omega)
  simp [get, upd, this]

/-- Two nodes meet: both come away with the union. -/
def exchange (i j : Nat) (n : Net) : Net :=
  let u := merge (get n i) (get n j)
  upd (upd n i u) j u

@[simp] theorem length_exchange (i j : Nat) (n : Net) : (exchange i j n).length = n.length := by
  simp [exchange]

/-- After a meeting, a participant that exists holds the union; anybody else
holds what they held. -/
theorem get_exchange (i j k : Nat) (n : Net) :
    get (exchange i j n) k =
      if (k = i ∧ i < n.length) ∨ (k = j ∧ j < n.length)
      then merge (get n i) (get n j) else get n k := by
  simp only [exchange]
  by_cases hkj : k = j
  · subst hkj
    by_cases hj : k < n.length
    · rw [get_upd_self (by simpa using hj)]
      simp [hj]
    · rw [get_upd_out (by simpa using hj)]
      by_cases hki : k = i
      · subst hki
        rw [get_upd_out hj]
        simp [hj]
      · rw [get_upd_ne hki]
        simp [hki, hj]
  · rw [get_upd_ne hkj]
    by_cases hki : k = i
    · subst hki
      by_cases hi : k < n.length
      · rw [get_upd_self hi]
        simp [hi]
      · rw [get_upd_out hi]
        simp [hi, hkj]
    · rw [get_upd_ne hki]
      simp [hki, hkj]

/-- **Knowledge never shrinks.** -/
theorem exchange_mono (i j k : Nat) (n : Net) :
    (get n k).toFinset ⊆ (get (exchange i j n) k).toFinset := by
  rw [get_exchange]
  split
  · rename_i h
    rcases h with ⟨rfl, -⟩ | ⟨rfl, -⟩
    · exact subset_merge_left _ _
    · exact subset_merge_right _ _
  · exact Finset.Subset.refl _

/-- A meeting hands the initiator's board to a peer that exists. -/
theorem exchange_transfer {n : Net} {i j : Nat} (hj : j < n.length) :
    (get n i).toFinset ⊆ (get (exchange i j n) j).toFinset := by
  rw [get_exchange]
  simp only [and_true, hj, or_true, if_true]
  exact subset_merge_left _ _

/-- Nothing appears out of nowhere in a meeting. -/
theorem exchange_sound {i j k : Nat} {n : Net} {q : Quote} (h : q ∈ get (exchange i j n) k) :
    ∃ m, q ∈ get n m := by
  rw [get_exchange] at h
  split at h
  · rcases mem_merge.mp h with h' | h'
    · exact ⟨i, h'⟩
    · exact ⟨j, h'⟩
  · exact ⟨k, h⟩

/-! ## Schedules -/

/-- Run a schedule of meetings, left to right. -/
def deliver (sched : List (Nat × Nat)) (n : Net) : Net :=
  sched.foldl (fun m p => exchange p.1 p.2 m) n

@[simp] theorem length_deliver (sched : List (Nat × Nat)) (n : Net) :
    (deliver sched n).length = n.length := by
  induction sched generalizing n with
  | nil => simp [deliver]
  | cons p t ih => simpa [deliver] using ih (exchange p.1 p.2 n)

theorem deliver_mono (sched : List (Nat × Nat)) (n : Net) (k : Nat) :
    (get n k).toFinset ⊆ (get (deliver sched n) k).toFinset := by
  induction sched generalizing n with
  | nil => simp [deliver]
  | cons p t ih =>
    refine subset_trans (exchange_mono p.1 p.2 k n) ?_
    simpa [deliver] using ih (exchange p.1 p.2 n)

/-- **The mesh invents nothing.** -/
theorem deliver_sound {sched : List (Nat × Nat)} {n : Net} {k : Nat} {q : Quote}
    (h : q ∈ get (deliver sched n) k) : ∃ m, q ∈ get n m := by
  induction sched generalizing n k with
  | nil => exact ⟨k, by simpa [deliver] using h⟩
  | cons p t ih =>
    obtain ⟨m, hm⟩ := ih (n := exchange p.1 p.2 n) (k := k) (by simpa [deliver] using h)
    exact exchange_sound hm

/-! ## Routing -/

/-- `Routed a sched b` : running `sched`, a packet held by node `a` reaches
node `b` — either it never moves, or the next meeting carries it one hop. -/
inductive Routed : Nat → List (Nat × Nat) → Nat → Prop
  /-- It is already there. -/
  | refl (a : Nat) : Routed a [] a
  /-- The next meeting does not move it. -/
  | stay {a b : Nat} {p : Nat × Nat} {s : List (Nat × Nat)} : Routed a s b → Routed a (p :: s) b
  /-- The next meeting is `a` handing to `j`, and it goes on from `j`. -/
  | hop {a j b : Nat} {s : List (Nat × Nat)} : Routed j s b → Routed a ((a, j) :: s) b

/-- **Data travels along the mesh.**  If the schedule routes `a` to `b`, then
everything `a` knew at the start is known to `b` at the end. -/
theorem deliver_routed {sched : List (Nat × Nat)} {a b : Nat} (hr : Routed a sched b)
    (n : Net) (hidx : ∀ p ∈ sched, p.2 < n.length) :
    (get n a).toFinset ⊆ (get (deliver sched n) b).toFinset := by
  induction hr generalizing n with
  | refl a => simp [deliver]
  | @stay a b p s _ ih =>
    refine subset_trans (exchange_mono p.1 p.2 a n) ?_
    have hidx' : ∀ r ∈ s, r.2 < (exchange p.1 p.2 n).length := by
      intro r hr'
      simpa using hidx r (List.mem_cons_of_mem _ hr')
    simpa [deliver] using ih (exchange p.1 p.2 n) hidx'
  | @hop a j b s _ ih =>
    have hj : j < n.length := hidx (a, j) (by simp)
    refine subset_trans (exchange_transfer hj) ?_
    have hidx' : ∀ r ∈ s, r.2 < (exchange a j n).length := by
      intro r hr'
      simpa using hidx r (List.mem_cons_of_mem _ hr')
    simpa [deliver] using ih (exchange a j n) hidx'

/-! ## Full synchronisation -/

/-- Everything the mesh knows. -/
def unionAll (n : Net) : Board := n.foldl merge []

theorem mem_unionAll_aux (n : Net) (acc : Board) {q : Quote} :
    q ∈ n.foldl merge acc ↔ q ∈ acc ∨ ∃ b ∈ n, q ∈ b := by
  induction n generalizing acc with
  | nil => simp
  | cons b t ih =>
    rw [List.foldl_cons, ih (merge acc b)]
    constructor
    · rintro (h | ⟨c, hc, hq⟩)
      · rcases mem_merge.mp h with h' | h'
        · exact Or.inl h'
        · exact Or.inr ⟨b, by simp, h'⟩
      · exact Or.inr ⟨c, by simp [hc], hq⟩
    · rintro (h | ⟨c, hc, hq⟩)
      · exact Or.inl (mem_merge.mpr (Or.inl h))
      · rcases List.mem_cons.mp hc with rfl | hc'
        · exact Or.inl (mem_merge.mpr (Or.inr hq))
        · exact Or.inr ⟨c, hc', hq⟩

@[simp] theorem mem_unionAll {n : Net} {q : Quote} : q ∈ unionAll n ↔ ∃ b ∈ n, q ∈ b := by
  simpa [unionAll] using mem_unionAll_aux n []

/-- A full sync: every node takes the union of the whole mesh. -/
def sync (n : Net) : Net := n.map (fun _ => unionAll n)

@[simp] theorem length_sync (n : Net) : (sync n).length = n.length := by simp [sync]

/-- **Convergence.**  After a full sync every node holds the same board, namely
everything the mesh knew. -/
theorem sync_all_eq {n : Net} {k : Nat} (hk : k < n.length) : get (sync n) k = unionAll n := by
  have h : (sync n)[k]? = some (unionAll n) := by
    rw [sync, List.getElem?_map, List.getElem?_eq_getElem hk]
    rfl
  simp [get, h]

/-- A full sync is a fixed point on sets: syncing twice adds nothing. -/
theorem sync_idem_toFinset {n : Net} {k : Nat} (hk : k < n.length) :
    (get (sync (sync n)) k).toFinset = (get (sync n) k).toFinset := by
  rw [sync_all_eq (by simpa using hk), sync_all_eq hk]
  ext q
  simp only [List.mem_toFinset, mem_unionAll, sync, List.mem_map]
  constructor
  · rintro ⟨b, ⟨c, hc, rfl⟩, hq⟩
    exact mem_unionAll.mp hq
  · intro hq
    obtain ⟨b, hb, hqb⟩ := hq
    exact ⟨unionAll n, ⟨b, hb, rfl⟩, mem_unionAll.mpr ⟨b, hb, hqb⟩⟩

end Mesh
