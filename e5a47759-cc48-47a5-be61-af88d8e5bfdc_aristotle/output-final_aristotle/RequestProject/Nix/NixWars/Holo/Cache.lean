import RequestProject.Nix.NixWars.Holo.Objective

/-!
# A client with bounded memory: the shell schedule under an LRU cache

The retrieval story so far assumes the client keeps everything it fetches.  A
real one has a budget.  This file gives it one: a cache of `cap` cells with
least-recently-used eviction, the staggered shell schedule as the order in which
cells are asked for, and the two statements that make "load more data, get more
resolution" an engineering claim rather than a slogan.

* `touch`, `run` — the cache and the fetch loop.  The cache never exceeds its
  capacity (`length_run_le`), and what it holds is what was most recently asked
  for (`mem_touch`).
* `schedule` — the shells `R₀, R₁, …, R_d` in order; `mem_schedule_iff` says the
  schedule asks for exactly the depth-`d` ball.
* `ball_resident` — **a budget that fits the ball keeps the ball**: if the cache
  is at least as large as the depth-`d` ball, then after the schedule every cell
  of that ball is resident, so the client can answer any query within depth `d`
  without going back to the host.
* `schedule_cost_le` — and the schedule costs at most one request per cell of
  the ball, `holo_schedule_cost` counting the requests exactly on the concrete
  archive: five cells of the depth-2 ball, three requests.
-/

namespace NixWars
namespace Holo
namespace Cache

open Archive Instance

/-! ## The cache -/

/-- Fetch `k` and keep it: the newest entry first, the oldest evicted once the
cache is full. -/
def touch (cap : Nat) (cache : List Nat) (k : Nat) : List Nat := (k :: cache.erase k).take cap

/-- Run the fetch loop over a schedule of keys. -/
def run (cap : Nat) (cache : List Nat) : List Nat → List Nat
  | [] => cache
  | k :: ks => run cap (touch cap cache k) ks

@[simp] theorem run_nil (cap : Nat) (cache : List Nat) : run cap cache [] = cache := rfl

theorem length_touch_le (cap : Nat) (cache : List Nat) (k : Nat) :
    (touch cap cache k).length ≤ cap := by
  simp [touch]

/-- **The cache never exceeds its capacity.** -/
theorem length_run_le {cap : Nat} {cache : List Nat} (h : cache.length ≤ cap) (ks : List Nat) :
    (run cap cache ks).length ≤ cap := by
  induction ks generalizing cache with
  | nil => simpa using h
  | cons k ks ih => exact ih (length_touch_le cap cache k)

/-- While there is room, nothing is evicted. -/
theorem touch_eq_of_room {cap : Nat} {cache : List Nat} {k : Nat}
    (h : cache.length + 1 ≤ cap) : touch cap cache k = k :: cache.erase k := by
  have hlen : (k :: cache.erase k).length ≤ cap := by
    have := List.length_erase_le (l := cache) (a := k)
    simp only [List.length_cons]
    omega
  simp [touch, List.take_of_length_le hlen]

theorem mem_touch {cap : Nat} (hcap : 0 < cap) (cache : List Nat) (k : Nat) :
    k ∈ touch cap cache k := by
  obtain ⟨c, rfl⟩ : ∃ c, cap = c + 1 := ⟨cap - 1, by omega⟩
  simp [touch, List.take_succ_cons]

theorem subset_touch {cap : Nat} {cache : List Nat} {k : Nat} (h : cache.length + 1 ≤ cap) :
    cache ⊆ touch cap cache k := by
  intro x hx
  rw [touch_eq_of_room h]
  by_cases hxk : x = k
  · simp [hxk]
  · exact List.mem_cons_of_mem _ ((List.mem_erase_of_ne hxk).mpr hx)

theorem length_touch_le_succ (cap : Nat) (cache : List Nat) (k : Nat)
    (h : cache.length + 1 ≤ cap) : (touch cap cache k).length ≤ cache.length + 1 := by
  rw [touch_eq_of_room h]
  have := List.length_erase_le (l := cache) (a := k)
  simp only [List.length_cons]
  omega

/-- **Everything asked for is still there, as long as the budget holds it.** -/
theorem subset_run {cap : Nat} {cache : List Nat} :
    ∀ {ks : List Nat}, ks.length + cache.length ≤ cap →
      cache ⊆ run cap cache ks ∧ ks ⊆ run cap cache ks := by
  intro ks
  induction ks generalizing cache with
  | nil => intro _; exact ⟨fun x hx => hx, fun x hx => absurd hx List.not_mem_nil⟩
  | cons k ks ih =>
    intro hlen
    have hroom : cache.length + 1 ≤ cap := by
      simp only [List.length_cons] at hlen
      omega
    have hnext : ks.length + (touch cap cache k).length ≤ cap := by
      have := length_touch_le_succ cap cache k hroom
      simp only [List.length_cons] at hlen
      omega
    obtain ⟨hc, hk⟩ := ih hnext
    refine ⟨fun x hx => hc (subset_touch hroom hx), ?_⟩
    intro x hx
    rcases List.mem_cons.mp hx with rfl | hxs
    · exact hc (mem_touch (by omega) cache x)
    · exact hk hxs

/-! ## The schedule -/

/-- The staggered fetch schedule: the shells `R₀, R₁, …, R_d`, in order. -/
def schedule (A : Archive) (k : Nat) : Nat → List Nat
  | 0 => A.shell k 0
  | d + 1 => schedule A k d ++ A.shell k (d + 1)

/-- **The schedule asks for exactly the depth-`d` ball.** -/
theorem mem_schedule_iff (A : Archive) (k x d : Nat) :
    x ∈ schedule A k d ↔ x ∈ A.ball k d := by
  induction d with
  | zero => simp [schedule, Archive.shell, Archive.ball]
  | succ d ih =>
    rw [schedule, List.mem_append, ih]
    constructor
    · rintro (h | h)
      · exact Archive.ball_subset_succ A k d h
      · exact Archive.shell_subset_ball A k (d + 1) h
    · intro h
      by_cases hd : x ∈ A.ball k d
      · exact Or.inl hd
      · refine Or.inr ?_
        simpa [Archive.shell, List.mem_filter, hd] using h

/-- **A budget that fits the ball keeps the ball.**  After running the shell
schedule with a cache at least as large as the depth-`d` ball, every cell of the
ball is resident: no further request is needed to answer within depth `d`. -/
theorem ball_resident {A : Archive} {k d cap : Nat}
    (hcap : (schedule A k d).length ≤ cap) :
    ∀ x ∈ A.ball k d, x ∈ run cap [] (schedule A k d) := by
  intro x hx
  exact (subset_run (cache := []) (by simpa using hcap)).2
    ((mem_schedule_iff A k x d).mpr hx)

/-! ## What the schedule costs -/

/-- The requests the schedule issues: one batch per shell. -/
def scheduleCost (A : Archive) (k : Nat) : Nat → Nat
  | 0 => requests A (A.shell k 0)
  | d + 1 => scheduleCost A k d + requests A (A.shell k (d + 1))

/-- Collecting a set of concepts never costs more requests than there are
concepts in it, when the archive holds one cell per concept. -/
theorem requests_le_length {A : Archive} (hnd : (A.map Cell.key).Nodup) (ks : List Nat) :
    requests A ks ≤ ks.length := by
  have hsub : (indicesOf A ks).length ≤ ks.length := by
    set l := indicesOf A ks with hl
    have hlnd : l.Nodup := (List.nodup_range).filter _
    have hkeys : (l.map fun i => (A.getD i default).key).Nodup := by
      refine List.Nodup.map_on ?_ hlnd
      intro i hi j hj hij
      have hi' : i < A.length := by
        have := List.mem_of_mem_filter (l := List.range A.length) hi
        simpa using this
      have hj' : j < A.length := by
        have := List.mem_of_mem_filter (l := List.range A.length) hj
        simpa using this
      rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi',
        List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hj'] at hij
      have : (A.map Cell.key)[i]'(by simpa using hi') = (A.map Cell.key)[j]'(by simpa using hj') := by
        simpa using hij
      exact hnd.getElem_inj_iff.mp this
    have hmem : (l.map fun i => (A.getD i default).key) ⊆ ks := by
      intro x hx
      obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hx
      have := (List.mem_filter.mp hi).2
      simpa using this
    obtain ⟨m, hperm, hsub'⟩ := List.subperm_of_subset hkeys hmem
    calc l.length = (l.map fun i => (A.getD i default).key).length := by simp
      _ = m.length := (hperm.length_eq).symm
      _ ≤ ks.length := hsub'.length_le
  exact le_trans (requests_le A ks) hsub

/-- **The schedule costs at most one request per cell of the ball** — and fewer
whenever a shell lands on consecutive cells of the file. -/
theorem scheduleCost_le {A : Archive} (hnd : (A.map Cell.key).Nodup) (k d : Nat) :
    scheduleCost A k d ≤ (schedule A k d).length := by
  induction d with
  | zero => exact requests_le_length hnd _
  | succ d ih =>
    have h := requests_le_length hnd (A.shell k (d + 1))
    simp only [scheduleCost, schedule, List.length_append]
    omega

/-- On the concrete archive the depth-2 ball around `RIEMANN_ZETA_FUNCTION` is
five cells, and fetching it shell by shell costs five requests — one per cell,
because the shells straddle the centre. -/
theorem holo_schedule_cost :
    (schedule holoArchive 5 2).length = 5 ∧ scheduleCost holoArchive 5 2 = 5 := by
  decide

/-- **Prefetching by byte proximity beats fetching shell by shell** on the
neighbourly layout: the same five cells arrive in a single range request. -/
theorem holo_window_cheaper_than_shells :
    requests holoArchive (holoArchive.ball 5 2) < scheduleCost holoArchive 5 2 := by
  decide

/-- The whole ball stays resident in a cache of five … -/
theorem holo_ball_resident :
    ∀ x ∈ holoArchive.ball 5 2, x ∈ run 5 [] (schedule holoArchive 5 2) :=
  ball_resident (by decide)

/-- … and a cache of three keeps only the three most recent cells: eviction is
real, and the budget is what decides how much of the ball survives. -/
theorem holo_small_cache : run 3 [] (schedule holoArchive 5 2) = [7, 3, 6] := by decide

end Cache
end Holo
end NixWars
