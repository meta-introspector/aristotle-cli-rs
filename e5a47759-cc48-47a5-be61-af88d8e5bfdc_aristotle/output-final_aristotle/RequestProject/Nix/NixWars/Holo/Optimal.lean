import RequestProject.Nix.NixWars.Holo.Partition
import RequestProject.Nix.NixWars.Holo.Geometries

/-!
# The layout the partitioner produces is optimal for neighbourhood retrieval

`Objective.lean` scores two fixed candidates against each other and shows the
scrambled one loses.  That is a comparison, not a guarantee about the
construction.  This file proves a guarantee: on the archive the partitioner
emits, the depth-`d` neighbourhood of any concept far enough from the ends of
the file comes back in **one** range request — and one is the least any layout
can manage, so the produced layout attains the optimum rather than merely
beating a rival.

* `mem_ball_blockArchive` — on the generated ring, the depth-`d` ball around `c`
  is exactly the concepts `c-d … c+d`.
* `ball_requests_eq_one` — collecting it costs one request.
* `ball_requests_optimal` — no layout of the same cells does better: any archive
  that holds the centre needs at least one request for the same set.
-/

namespace NixWars
namespace Holo
namespace Optimal

open Archive Partition Geometries

/-! ## Keys, neighbours -/

theorem blockDump_keyAt {n i : Nat} (h : i < n) : keyAt (blockDump n) i = i := by
  rw [keyAt_eq (by simpa using h)]
  simp [blockDump]

theorem length_blockArchive (n : Nat) : (blockArchive n).length = n := by
  simp [blockArchive]

theorem getElem_blockArchive {n i : Nat} (h : i < (blockArchive n).length) :
    (blockArchive n)[i] = cellAt (blockDump n) i := by
  simp [blockArchive]

theorem blockArchive_key_index {n i : Nat} (h : i < (blockArchive n).length) :
    ((blockArchive n)[i]).key = i := by
  rw [getElem_blockArchive h]
  exact blockDump_keyAt (by simpa [length_blockArchive] using h)

/-- The neighbours of a concept of the generated ring: its predecessor and its
successor, by position. -/
theorem nbrs_blockArchive {n i : Nat} (h : i < n) :
    (blockArchive n).nbrs i = [prevIdx n i, nextIdx n i] := by
  have hmem : cellAt (blockDump n) i ∈ blockArchive n :=
    mem_partition (by simpa using h)
  have hkey : (cellAt (blockDump n) i).key = i := blockDump_keyAt h
  have hnd : ((blockArchive n).map Cell.key).Nodup := blockArchive_keys_nodup n
  have := nbrs_of_mem hnd hmem
  rw [hkey] at this
  rw [this, cellAt]
  have hp : prevIdx (blockDump n).length i < n := by
    simpa using prevIdx_lt (n := n) (i := i) (by omega)
  have hq : nextIdx (blockDump n).length i < n := by
    simpa using nextIdx_lt (n := n) (i := i) (by omega)
  simp only [length_blockDump] at *
  rw [blockDump_keyAt hp, blockDump_keyAt hq]

/-! ## The ball of the generated ring -/

/-- Away from the ends of the file the ring does not wrap, so a step is `±1`. -/
theorem nbrs_interior {n i : Nat} (h1 : 0 < i) (h2 : i + 1 < n) :
    (blockArchive n).nbrs i = [i - 1, i + 1] := by
  rw [nbrs_blockArchive (by omega), prevIdx_eq (by omega), nextIdx_eq (by omega),
    if_neg (by omega), if_neg (by omega)]

/-- Everything the ball reaches stays inside the interval. -/
theorem mem_ball_blockArchive_le {n c d : Nat} (hd : d ≤ c) (hc : c + d < n) :
    ∀ x ∈ (blockArchive n).ball c d, c - d ≤ x ∧ x ≤ c + d := by
  induction d with
  | zero =>
    intro x hx
    have : x = c := by simpa using hx
    omega
  | succ d ih =>
    intro x hx
    have hih := ih (by omega) (by omega)
    rcases (mem_ball_succ (blockArchive n) c x d).mp hx with h | ⟨y, hy, hxy⟩
    · have := hih x h
      omega
    · have hyb := hih y hy
      have hy0 : 0 < y := by omega
      have hy1 : y + 1 < n := by omega
      rw [nbrs_interior hy0 hy1] at hxy
      simp only [List.mem_cons, List.not_mem_nil, or_false] at hxy
      rcases hxy with rfl | rfl <;> omega

/-- And it reaches all of it. -/
theorem mem_ball_blockArchive_ge {n c d : Nat} (hd : d ≤ c) (hc : c + d < n) :
    ∀ x, c - d ≤ x → x ≤ c + d → x ∈ (blockArchive n).ball c d := by
  have key : ∀ k, k ≤ d → (c + k) ∈ (blockArchive n).ball c k ∧
      (c - k) ∈ (blockArchive n).ball c k := by
    intro k
    induction k with
    | zero => intro _; simp
    | succ k ih =>
      intro hk
      obtain ⟨hup, hdown⟩ := ih (by omega)
      have hup1 : 0 < c + k := by omega
      have hup2 : c + k + 1 < n := by omega
      have hdown1 : 0 < c - k := by omega
      have hdown2 : (c - k) + 1 < n := by omega
      constructor
      · refine (mem_ball_succ (blockArchive n) c (c + (k + 1)) k).mpr (Or.inr ⟨c + k, hup, ?_⟩)
        rw [nbrs_interior hup1 hup2]
        simp only [List.mem_cons]
        right; left
        omega
      · refine (mem_ball_succ (blockArchive n) c (c - (k + 1)) k).mpr (Or.inr ⟨c - k, hdown, ?_⟩)
        rw [nbrs_interior hdown1 hdown2]
        simp only [List.mem_cons]
        left
        omega
  intro x hx1 hx2
  rcases Nat.le_total c x with hcx | hcx
  · have hk : x - c ≤ d := by omega
    have hx : x = c + (x - c) := by omega
    rw [hx]
    exact ball_mono (blockArchive n) c hk (key (x - c) hk).1
  · have hk : c - x ≤ d := by omega
    have hx : x = c - (c - x) := by omega
    rw [hx]
    exact ball_mono (blockArchive n) c hk (key (c - x) hk).2

/-- **The ball of the generated ring is an interval of the file.** -/
theorem mem_ball_blockArchive {n c d : Nat} (hd : d ≤ c) (hc : c + d < n) (x : Nat) :
    x ∈ (blockArchive n).ball c d ↔ (c - d ≤ x ∧ x ≤ c + d) :=
  ⟨fun h => mem_ball_blockArchive_le hd hc x h,
    fun h => mem_ball_blockArchive_ge hd hc x h.1 h.2⟩

/-! ## One request, and one is the best there is -/

theorem requests_of_key_index {A : Archive}
    (hkey : ∀ i, ∀ h : i < A.length, (A[i]'h).key = i) (ks : List Nat) :
    requests A ks = runsOf ((List.range A.length).filter fun i => decide (i ∈ ks)) := by
  unfold requests indicesOf
  congr 1
  apply List.filter_congr
  intro i hi
  have h : i < A.length := List.mem_range.mp hi
  rw [List.getD_eq_getElem _ _ h, hkey i h]

/-- **The neighbourhood is one range request.**  On the archive the partitioner
emits, the depth-`d` ball around any concept at least `d` from either end of the
file is a contiguous window, so a single request delivers it. -/
theorem ball_requests_eq_one {n c d : Nat} (hd : d ≤ c) (hc : c + d < n) :
    requests (blockArchive n) ((blockArchive n).ball c d) = 1 := by
  rw [requests_of_key_index (fun i h => blockArchive_key_index h)]
  have hfilter : ((List.range (blockArchive n).length).filter
        fun i => decide (i ∈ (blockArchive n).ball c d)) =
      ((List.range n).filter fun i => decide (i ∈ List.range' (c - d) (2 * d + 1))) := by
    rw [length_blockArchive]
    apply List.filter_congr
    intro i _
    have hb := mem_ball_blockArchive (n := n) (c := c) (d := d) hd hc i
    have hr : i ∈ List.range' (c - d) (2 * d + 1) ↔ (c - d ≤ i ∧ i ≤ c + d) := by
      rw [List.mem_range']
      constructor
      · rintro ⟨j, hj, rfl⟩
        omega
      · intro h
        exact ⟨i - (c - d), by omega, by omega⟩
    simp [hb, hr]
  rw [hfilter, filter_range_eq_of_pairwise (N := n) (List.pairwise_lt_range' 1 (by omega)) ?_,
    runsOf_range']
  intro k hk
  obtain ⟨j, hj, rfl⟩ := List.mem_range'.mp hk
  omega

/-- **And no layout does better.**  Any archive that holds the centre of the
ball needs at least one request for the same set of concepts, so the layout the
partitioner produces attains the optimum. -/
theorem ball_requests_optimal {n c d : Nat} (hd : d ≤ c) (hc : c + d < n)
    (B : Archive) (hB : ∃ i, ∃ h : i < B.length, (B[i]'h).key = c) :
    requests (blockArchive n) ((blockArchive n).ball c d) ≤
      requests B ((blockArchive n).ball c d) := by
  rw [ball_requests_eq_one hd hc]
  refine requests_pos ?_
  obtain ⟨i, hi, hkey⟩ := hB
  have hmem : i ∈ indicesOf B ((blockArchive n).ball c d) := by
    refine List.mem_filter.mpr ⟨List.mem_range.mpr hi, ?_⟩
    have hc0 : c ∈ (blockArchive n).ball c d :=
      (mem_ball_blockArchive hd hc c).mpr ⟨by omega, by omega⟩
    rw [List.getD_eq_getElem _ _ hi, hkey]
    simpa using hc0
  exact fun hnil => by simp [hnil] at hmem

end Optimal
end Holo
end NixWars
