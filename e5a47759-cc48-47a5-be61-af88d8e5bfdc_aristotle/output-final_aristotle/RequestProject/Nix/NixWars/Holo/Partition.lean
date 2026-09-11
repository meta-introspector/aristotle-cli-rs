import RequestProject.Nix.NixWars.Holo.Objective

/-!
# The partitioner: a procedure that produces archives with the properties

`Instance.lean` exhibits one hand-written archive of eleven cells and checks its
properties by `decide`.  This file does the general thing: a **partitioner**
that takes a raw dump — any list of records, each a concept key and the material
held for it — and emits cells, offsets and links, together with proofs that the
*generated* archive has the properties, for a dump of any size.

* `partition` — the procedure.  One cell per record, in the order given, each
  cell linked to its predecessor and successor around the ring.
* `partition_keys_nodup`, `partition_links_closed`, `partition_mutual`,
  `partition_layout`, `partition_duplication_eq_zero` — keys distinct, links
  closed and mutual, no fact stored twice, and cells adjacent in the file
  adjacent in the concept graph.  All of them for an arbitrary dump, under
  exactly the hypotheses they need (distinct keys; at least three records; no
  repeated material).
* `partition_window_within_depth` — hence the retrieval theorem of
  `Geometry.lean` applies to every archive the partitioner produces: a window of
  `2d+1` consecutive cells, one range request, all within depth `d` of its
  centre.
* `blockDump` / `blockArchive` — the partitioner run on a synthetic dump of `n`
  records with four items of material each, e.g. one record per can of the
  catalogue, and the same properties for all `n` with no case check.
-/

namespace NixWars
namespace Holo
namespace Partition

open Archive

/-! ## Ring index arithmetic -/

/-- The predecessor of position `i` around a ring of `n` cells. -/
def prevIdx (n i : Nat) : Nat := (i + (n - 1)) % n

/-- The successor of position `i` around a ring of `n` cells. -/
def nextIdx (n i : Nat) : Nat := (i + 1) % n

theorem nextIdx_lt {n i : Nat} (hn : 0 < n) : nextIdx n i < n := Nat.mod_lt _ hn

theorem prevIdx_lt {n i : Nat} (hn : 0 < n) : prevIdx n i < n := Nat.mod_lt _ hn

theorem nextIdx_eq {n i : Nat} (hi : i < n) : nextIdx n i = if i + 1 = n then 0 else i + 1 := by
  unfold nextIdx
  by_cases h : i + 1 = n
  · rw [if_pos h, h, Nat.mod_self]
  · rw [if_neg h, Nat.mod_eq_of_lt (by omega)]

theorem prevIdx_eq {n i : Nat} (hi : i < n) : prevIdx n i = if i = 0 then n - 1 else i - 1 := by
  unfold prevIdx
  by_cases h : i = 0
  · subst h
    rw [if_pos rfl, Nat.zero_add, Nat.mod_eq_of_lt (by omega)]
  · rw [if_neg h, show i + (n - 1) = (i - 1) + n by omega, Nat.add_mod_right,
      Nat.mod_eq_of_lt (by omega)]

/-- **The ring is reversible**: `j` follows `i` exactly when `i` precedes `j`. -/
theorem nextIdx_eq_iff {n i j : Nat} (hi : i < n) (hj : j < n) :
    nextIdx n i = j ↔ prevIdx n j = i := by
  rw [nextIdx_eq hi, prevIdx_eq hj]
  by_cases h1 : i + 1 = n <;> by_cases h2 : j = 0 <;> simp [h1, h2] <;> omega

/-! ## The partitioner -/

/-- A raw dump: a list of records, each a concept key and the material held for
that concept. -/
abbrev Dump := List (Nat × List Nat)

/-- The key of record `i`. -/
def keyAt (D : Dump) (i : Nat) : Nat := (D.getD i (0, [])).1

/-- The material of record `i`. -/
def matAt (D : Dump) (i : Nat) : List Nat := (D.getD i (0, [])).2

theorem keyAt_eq {D : Dump} {i : Nat} (h : i < D.length) : keyAt D i = (D[i]'h).1 := by
  simp [keyAt, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem h]

theorem matAt_eq {D : Dump} {i : Nat} (h : i < D.length) : matAt D i = (D[i]'h).2 := by
  simp [matAt, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem h]

/-- The cell the partitioner emits for record `i`: the record's own material,
and references — not copies — to the neighbouring records. -/
def cellAt (D : Dump) (i : Nat) : Cell :=
  { key := keyAt D i,
    payload := matAt D i,
    links := [keyAt D (prevIdx D.length i), keyAt D (nextIdx D.length i)] }

/-- **The partitioner.**  A dump in, an archive out. -/
def partition (D : Dump) : Archive := (List.range D.length).map (cellAt D)

@[simp] theorem length_partition (D : Dump) : (partition D).length = D.length := by
  simp [partition]

@[simp] theorem getElem_partition (D : Dump) (i : Nat) (h : i < (partition D).length) :
    (partition D)[i] = cellAt D i := by
  simp [partition]

theorem mem_partition {D : Dump} {i : Nat} (h : i < D.length) : cellAt D i ∈ partition D := by
  refine List.mem_map.mpr ⟨i, List.mem_range.mpr h, rfl⟩

theorem exists_index_of_mem {D : Dump} {c : Cell} (hc : c ∈ partition D) :
    ∃ i < D.length, c = cellAt D i := by
  obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hc
  exact ⟨i, List.mem_range.mp hi, rfl⟩

theorem map_key_partition (D : Dump) : (partition D).map Cell.key = D.map Prod.fst := by
  apply List.ext_getElem (by simp)
  intro i h₁ h₂
  simp only [List.getElem_map, getElem_partition, cellAt] at *
  exact keyAt_eq (by simpa using h₁)

/-- **The generated archive has one cell per concept**, whenever the dump does. -/
theorem partition_keys_nodup {D : Dump} (hnd : (D.map Prod.fst).Nodup) :
    ((partition D).map Cell.key).Nodup := by
  rw [map_key_partition]
  exact hnd

/-- Distinct records get distinct keys, so a key determines its position. -/
theorem keyAt_inj {D : Dump} (hnd : (D.map Prod.fst).Nodup) {i j : Nat}
    (hi : i < D.length) (hj : j < D.length) (h : keyAt D i = keyAt D j) : i = j := by
  have hi' : i < (D.map Prod.fst).length := by simpa using hi
  have hj' : j < (D.map Prod.fst).length := by simpa using hj
  have : (D.map Prod.fst)[i]'hi' = (D.map Prod.fst)[j]'hj' := by
    simpa [keyAt_eq hi, keyAt_eq hj] using h
  exact (hnd.getElem_inj_iff).mp this

/-- **Every reference the partitioner emits resolves**: the links are closed. -/
theorem partition_links_closed {D : Dump} (hn : 0 < D.length) : LinksClosed (partition D) := by
  intro c hc k hk
  obtain ⟨i, hi, rfl⟩ := exists_index_of_mem hc
  simp only [cellAt, List.mem_cons, List.not_mem_nil, or_false] at hk
  rcases hk with rfl | rfl
  · exact ⟨cellAt D (prevIdx D.length i), mem_partition (prevIdx_lt hn), rfl⟩
  · exact ⟨cellAt D (nextIdx D.length i), mem_partition (nextIdx_lt hn), rfl⟩

/-- **Neighbours support each other** in every archive the partitioner
produces, so navigation is reversible. -/
theorem partition_mutual {D : Dump} (hn : 0 < D.length) (hnd : (D.map Prod.fst).Nodup) :
    MutualSupport (partition D) := by
  refine mutualSupport_of_cells (partition_keys_nodup hnd) (partition_links_closed hn) ?_
  intro c hc d hd
  obtain ⟨i, hi, rfl⟩ := exists_index_of_mem hc
  obtain ⟨j, hj, rfl⟩ := exists_index_of_mem hd
  have hpi := prevIdx_lt (i := i) hn
  have hni := nextIdx_lt (i := i) hn
  have hpj := prevIdx_lt (i := j) hn
  have hnj := nextIdx_lt (i := j) hn
  simp only [cellAt, List.mem_cons, List.not_mem_nil, or_false]
  constructor
  · rintro (h | h)
    · -- `j` precedes `i`, hence `i` follows `j`
      have hji : prevIdx D.length i = j := keyAt_inj hnd hpi hj h.symm
      exact Or.inr (by rw [(nextIdx_eq_iff hj hi).mpr hji])
    · have hji : nextIdx D.length i = j := keyAt_inj hnd hni hj h.symm
      exact Or.inl (by rw [(nextIdx_eq_iff hi hj).mp hji])
  · rintro (h | h)
    · have hij : prevIdx D.length j = i := keyAt_inj hnd hpj hi h.symm
      exact Or.inr (by rw [(nextIdx_eq_iff hi hj).mpr hij])
    · have hij : nextIdx D.length j = i := keyAt_inj hnd hnj hi h.symm
      exact Or.inl (by rw [(nextIdx_eq_iff hj hi).mp hij])

/-- **Neighbourly layout**: cells adjacent in the emitted file are neighbours in
the concept graph. -/
theorem partition_layout {D : Dump} (hnd : (D.map Prod.fst).Nodup) :
    LayoutNeighbourly (partition D) := by
  intro i hi
  have hi1 : i + 1 < D.length := by simpa using hi
  have hi0 : i < D.length := by omega
  have hmem : cellAt D i ∈ partition D := mem_partition hi0
  rw [getElem_partition, getElem_partition, show (cellAt D i).key = keyAt D i from rfl,
    ← show (cellAt D i).key = keyAt D i from rfl, nbrs_of_mem (partition_keys_nodup hnd) hmem]
  have : nextIdx D.length i = i + 1 := by
    rw [nextIdx_eq hi0, if_neg (by omega)]
  simp [cellAt, this]

/-! ## Duplication -/

theorem facts_partition (D : Dump) : (partition D).facts = D.flatMap Prod.snd := by
  unfold Archive.facts
  rw [List.flatMap_def, List.flatMap_def]
  congr 1
  apply List.ext_getElem (by simp)
  intro i h₁ h₂
  simp only [partition, List.getElem_map, List.getElem_range, cellAt] at *
  exact matAt_eq (by simpa using h₁)

/-- **Zero duplication**: the partitioner never stores a fact twice, as long as
the dump does not. -/
theorem partition_duplication_eq_zero {D : Dump} (h : (D.flatMap Prod.snd).Nodup) :
    (partition D).duplication = 0 :=
  (duplication_eq_zero_iff _).mpr (by rw [facts_partition]; exact h)

/-! ## The retrieval theorem, on the generated archive -/

/-- **One request, a whole neighbourhood** — for every archive the partitioner
produces.  Every cell of a window of `2d+1` consecutive cells lies within depth
`d` of the cell at its centre. -/
theorem partition_window_within_depth {D : Dump} (hn : 0 < D.length)
    (hnd : (D.map Prod.fst).Nodup) (i d : Nat) (h : i + (2 * d) < D.length) :
    ∀ c ∈ ((partition D).drop i).take (2 * d + 1),
      c.key ∈ (partition D).ball ((partition D)[i + d]'(by simp; omega)).key d :=
  window_within_depth (partition_layout hnd) (partition_mutual hn hnd) i d (by simpa using h)
    (by simp; omega)

/-! ## The partitioner on a dump of any size -/

/-- A synthetic dump of `n` records, four items of material each and nothing
shared: one record per can of the catalogue, or per character row, or per
Wikidata entity. -/
def blockDump (n : Nat) : Dump :=
  (List.range n).map fun i => (i, [4 * i, 4 * i + 1, 4 * i + 2, 4 * i + 3])

/-- The archive the partitioner emits for it. -/
def blockArchive (n : Nat) : Archive := partition (blockDump n)

@[simp] theorem length_blockDump (n : Nat) : (blockDump n).length = n := by simp [blockDump]

theorem blockDump_keys (n : Nat) : (blockDump n).map Prod.fst = List.range n := by
  simp [blockDump, List.map_map, Function.comp_def]

theorem blockDump_keys_nodup (n : Nat) : ((blockDump n).map Prod.fst).Nodup := by
  rw [blockDump_keys]
  exact List.nodup_range

theorem blockDump_facts (n : Nat) : (blockDump n).flatMap Prod.snd = List.range (4 * n) := by
  induction n with
  | zero => simp [blockDump]
  | succ n ih =>
    rw [blockDump, List.range_succ, List.map_append, List.flatMap_append, ← blockDump, ih]
    have : 4 * (n + 1) = 4 * n + 1 + 1 + 1 + 1 := by omega
    rw [this, List.range_succ, List.range_succ, List.range_succ, List.range_succ]
    simp [List.append_assoc]

theorem blockDump_facts_nodup (n : Nat) : ((blockDump n).flatMap Prod.snd).Nodup := by
  rw [blockDump_facts]
  exact List.nodup_range

/-- **The generated archive has distinct keys**, for every size. -/
theorem blockArchive_keys_nodup (n : Nat) : ((blockArchive n).map Cell.key).Nodup :=
  partition_keys_nodup (blockDump_keys_nodup n)

/-- **Its links are closed**, for every size. -/
theorem blockArchive_links_closed {n : Nat} (hn : 0 < n) : LinksClosed (blockArchive n) :=
  partition_links_closed (by simpa using hn)

/-- **Its neighbours support each other**, for every size. -/
theorem blockArchive_mutual {n : Nat} (hn : 0 < n) : MutualSupport (blockArchive n) :=
  partition_mutual (by simpa using hn) (blockDump_keys_nodup n)

/-- **Its layout is neighbourly**, for every size. -/
theorem blockArchive_layout (n : Nat) : LayoutNeighbourly (blockArchive n) :=
  partition_layout (blockDump_keys_nodup n)

/-- **It stores nothing twice**, for every size. -/
theorem blockArchive_duplication (n : Nat) : (blockArchive n).duplication = 0 :=
  partition_duplication_eq_zero (blockDump_facts_nodup n)

/-- And the window theorem holds of it: at `n = 3529`, one can per cell, a
single range request covering eleven consecutive cells returns nothing further
than five links from its centre. -/
theorem blockArchive_window_3529 (i d : Nat) (h : i + 2 * d < 3529) :
    ∀ c ∈ ((blockArchive 3529).drop i).take (2 * d + 1),
      c.key ∈ (blockArchive 3529).ball
        ((blockArchive 3529)[i + d]'(by simp [blockArchive]; omega)).key d :=
  partition_window_within_depth (D := blockDump 3529) (by simp) (blockDump_keys_nodup _) i d
    (by simpa using h)

end Partition
end Holo
end NixWars
