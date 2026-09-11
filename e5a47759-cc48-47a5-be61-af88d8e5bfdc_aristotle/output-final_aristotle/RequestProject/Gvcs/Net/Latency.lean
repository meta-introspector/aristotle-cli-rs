import RequestProject.Gvcs.Net.Log

/-!
# Optimistic play and bounded latency

`GAMEPLAN.md` §9 asks for "a bounded-latency statement for optimistic
application of commuting moves": a player's move should take effect the moment
it arrives, with no rollback, and the whole session should agree again within a
bounded number of delivery rounds after the last move.  This file proves both
halves over the replicated log of `RequestProject/Net/Log.lean`.

* `Optimistic` — the state a replica gets by folding the step function over
  operations *in arrival order*, without waiting and without sorting.
* `optimistic_eq_replay` — for commuting payloads the optimistic state is the
  canonical replayed state, at every instant: applying a move as it lands can
  never have to be undone.
* `Schedule`, `Schedule.Delivers`, `Schedule.Quiescent` — a run of the network:
  which operations are issued at each round, what each peer holds, and the
  assumption that anything issued is delivered everywhere within `d` rounds.
* `Schedule.held_eq_upto` — **bounded latency**: `d` rounds after the last move
  is issued, every peer holds exactly the operations that were issued.
* `Schedule.replay_agree` / `Schedule.optimistic_agree` — hence every peer, and
  every optimistic peer, shows the same state from then on, whatever order the
  post arrived in.
-/

namespace LifeTrac
namespace Net

variable {P : Type} [DecidableEq P] {S : Type}

/-! ## Optimistic application -/

/-- The state a replica computes by applying operations as they arrive, in
arrival order, without sorting and without waiting for stragglers. -/
def Optimistic (step : S → P → S) (init : S) (arr : List (Op P)) : S :=
  arr.foldl (fun s o => step s o.payload) init

omit [DecidableEq P] in
@[simp] theorem optimistic_nil (step : S → P → S) (init : S) :
    Optimistic step init ([] : List (Op P)) = init := rfl

omit [DecidableEq P] in
@[simp] theorem optimistic_append (step : S → P → S) (init : S) (l₁ l₂ : List (Op P)) :
    Optimistic step init (l₁ ++ l₂) = Optimistic step (Optimistic step init l₁) l₂ := by
  simp [Optimistic, List.foldl_append]

/-- **No rollback.**  When the payloads commute, a replica that applies each
operation the instant it arrives is in exactly the state the canonical replay
of everything it has received would give.  Optimistic application of commuting
moves is therefore never wrong and never has to be undone. -/
theorem optimistic_eq_replay (step : S → P → S)
    (hcomm : ∀ (s : S) (a b : P), step (step s a) b = step (step s b) a)
    (init : S) {L : Log P} {arr : List (Op P)} (hnd : arr.Nodup)
    (hmem : ∀ o : Op P, o ∈ arr ↔ o ∈ L) :
    Optimistic step init arr = replay step init L := by
  have hperm : arr.Perm L.toList := by
    refine (List.perm_ext_iff_of_nodup hnd (Finset.nodup_toList L)).2 ?_
    intro o; rw [Finset.mem_toList]; exact hmem o
  rw [replay_eq_foldl_of_comm step hcomm init L]
  exact replay_perm_eq step hcomm init hperm

/-- Two players whose devices received the same commuting moves in different
orders, and applied each one as it landed, are looking at the same world. -/
theorem optimistic_agree_of_same_ops (step : S → P → S)
    (hcomm : ∀ (s : S) (a b : P), step (step s a) b = step (step s b) a)
    (init : S) {arr arr' : List (Op P)} (hnd : arr.Nodup) (hnd' : arr'.Nodup)
    (h : ∀ o : Op P, o ∈ arr ↔ o ∈ arr') :
    Optimistic step init arr = Optimistic step init arr' := by
  classical
  set L : Log P := arr.toFinset with hL
  have hmem : ∀ o : Op P, o ∈ arr ↔ o ∈ L := by intro o; simp [hL]
  have hmem' : ∀ o : Op P, o ∈ arr' ↔ o ∈ L := by intro o; rw [← h o]; exact hmem o
  rw [optimistic_eq_replay step hcomm init hnd hmem,
    optimistic_eq_replay step hcomm init hnd' hmem']

/-! ## A run of the network -/

/-- A run of the session: at each round some operations are issued, and each
peer holds a growing log of what has reached it.  A peer never holds an
operation that was not issued at some round up to now. -/
structure Schedule (P : Type) [DecidableEq P] (ι : Type) where
  /-- The operations issued at a round. -/
  issued : ℕ → Log P
  /-- What peer `i` holds after round `t`. -/
  held : ι → ℕ → Log P
  /-- Peers never forget. -/
  held_mono : ∀ i t t', t ≤ t' → held i t ⊆ held i t'
  /-- Peers never invent: everything held was issued, at this round or before. -/
  held_sound : ∀ i t, held i t ⊆ (Finset.range (t + 1)).biUnion issued

namespace Schedule

variable {ι : Type} (sch : Schedule P ι)

/-- Everything issued up to and including round `T`. -/
def upto (sch : Schedule P ι) (T : ℕ) : Log P := (Finset.range (T + 1)).biUnion sch.issued

theorem mem_upto {T : ℕ} {o : Op P} :
    o ∈ sch.upto T ↔ ∃ s ≤ T, o ∈ sch.issued s := by
  simp only [upto, Finset.mem_biUnion, Finset.mem_range]
  constructor
  · rintro ⟨s, hs, ho⟩; exact ⟨s, Nat.lt_succ_iff.1 hs, ho⟩
  · rintro ⟨s, hs, ho⟩; exact ⟨s, Nat.lt_succ_of_le hs, ho⟩

/-- The transport delivers within `d` rounds: whatever is issued at round `s`
has reached every peer by round `s + d`. -/
def Delivers (sch : Schedule P ι) (d : ℕ) : Prop :=
  ∀ i s t, s + d ≤ t → sch.issued s ⊆ sch.held i t

/-- Nothing is issued after round `T`: the last move of the session. -/
def Quiescent (sch : Schedule P ι) (T : ℕ) : Prop := ∀ s, T < s → sch.issued s = ∅

/-- **Bounded latency.**  Once `d` rounds have passed since the last move was
issued, every peer holds exactly the operations of the session — no more
waiting, no straggler. -/
theorem held_eq_upto {d T t : ℕ} (hd : sch.Delivers d) (hq : sch.Quiescent T)
    (ht : T + d ≤ t) (i : ι) : sch.held i t = sch.upto T := by
  apply Finset.Subset.antisymm
  · intro o ho
    obtain ⟨s, hs, hos⟩ := Finset.mem_biUnion.1 (sch.held_sound i t ho)
    rcases le_or_gt s T with hsT | hsT
    · exact sch.mem_upto.2 ⟨s, hsT, hos⟩
    · rw [hq s hsT] at hos
      exact absurd hos (Finset.notMem_empty o)
  · intro o ho
    obtain ⟨s, hsT, hos⟩ := sch.mem_upto.1 ho
    exact hd i s t (le_trans (Nat.add_le_add_right hsT d) ht) hos

/-- Every peer shows the same state from `d` rounds after the last move — and
it is the state of the whole session. -/
theorem replay_agree (step : S → P → S) (init : S) {d T t t' : ℕ}
    (hd : sch.Delivers d) (hq : sch.Quiescent T) (ht : T + d ≤ t) (ht' : T + d ≤ t')
    (i j : ι) :
    replay step init (sch.held i t) = replay step init (sch.held j t') := by
  rw [sch.held_eq_upto hd hq ht i, sch.held_eq_upto hd hq ht' j]

/-- The state everyone converges to is the replay of every move that was
played. -/
theorem replay_eq_upto (step : S → P → S) (init : S) {d T t : ℕ}
    (hd : sch.Delivers d) (hq : sch.Quiescent T) (ht : T + d ≤ t) (i : ι) :
    replay step init (sch.held i t) = replay step init (sch.upto T) := by
  rw [sch.held_eq_upto hd hq ht i]

/-- **Optimistic play converges within the latency bound.**  Peers that applied
each commuting move the instant it arrived, in whatever order it arrived,
are all showing the state of the whole session `d` rounds after the last move —
without ever having rolled anything back. -/
theorem optimistic_agree (step : S → P → S)
    (hcomm : ∀ (s : S) (a b : P), step (step s a) b = step (step s b) a)
    (init : S) {d T t t' : ℕ} (hd : sch.Delivers d) (hq : sch.Quiescent T)
    (ht : T + d ≤ t) (ht' : T + d ≤ t') {i j : ι} {arr arr' : List (Op P)}
    (hnd : arr.Nodup) (hmem : ∀ o : Op P, o ∈ arr ↔ o ∈ sch.held i t)
    (hnd' : arr'.Nodup) (hmem' : ∀ o : Op P, o ∈ arr' ↔ o ∈ sch.held j t') :
    Optimistic step init arr = Optimistic step init arr' := by
  rw [optimistic_eq_replay step hcomm init hnd hmem,
    optimistic_eq_replay step hcomm init hnd' hmem',
    sch.replay_agree step init hd hq ht ht' i j]

/-- Past the latency bound, a peer holds every operation that was ever
issued. -/
theorem upto_subset_held {d T t : ℕ} (hd : sch.Delivers d) (ht : T + d ≤ t) (i : ι) :
    sch.upto T ⊆ sch.held i t := by
  intro o ho
  obtain ⟨s, hsT, hos⟩ := sch.mem_upto.1 ho
  exact hd i s t (le_trans (Nat.add_le_add_right hsT d) ht) hos

end Schedule

end Net
end LifeTrac
