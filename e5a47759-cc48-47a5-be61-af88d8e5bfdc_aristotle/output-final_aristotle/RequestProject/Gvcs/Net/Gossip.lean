import RequestProject.Gvcs.Net.Log

/-!
# Peer-to-peer gossip: no server required

`RequestProject/Net/Log.lean` says what one replica does.  This file says what a
*population* of replicas does when they only ever exchange logs pairwise — a
phone handing its log to another phone over Bluetooth, a browser tab to a WebRTC
peer, a Roblox server to the relay.  There is no privileged node in the model:
the "server" of the rollout plan is just a peer that happens to be always on.

* `Network P n` — the logs held by `n` peers.
* `total` — everything anybody has seen; `mem_total` characterises it.
* `send i j` — the only primitive: peer `i` hands its log to peer `j`, who
  merges it.  Every peer's log only grows (`send_grows`) and the total is
  unchanged (`send_total`): gossip never invents or loses an operation.
* `offlinePlay` — a peer plays alone and appends its own operations; those
  operations are then in the total and, after a sync, in everybody's log.
* `collect`/`broadcast`/`fullSync` — the star-shaped sync round built out of
  nothing but `send`s, with `fullSync_eq_total`: after one round every peer
  holds exactly the union of everything, and hence (`fullSync_replay`) every
  peer computes the same game state.  This is the convergence guarantee the
  rollout plan leans on, and it holds however the peers were partitioned
  beforehand.
-/

namespace LifeTrac
namespace Net

variable {P : Type} [DecidableEq P] {n : ℕ}

/-- The state of a peer-to-peer population: what each of the `n` peers has
seen. -/
abbrev Network (P : Type) [DecidableEq P] (n : ℕ) := Fin n → Log P

/-- Everything that anybody in the population has seen. -/
def total (net : Network P n) : Log P := Finset.univ.sup net

theorem mem_total {net : Network P n} {o : Op P} : o ∈ total net ↔ ∃ i, o ∈ net i := by
  simp [total, Finset.mem_sup]

theorem subset_total (net : Network P n) (i : Fin n) : net i ⊆ total net := by
  intro o ho; exact mem_total.2 ⟨i, ho⟩

/-! ## The one primitive: a pairwise exchange -/

/-- Peer `i` hands its log to peer `j`, who merges it into its own. -/
def send (i j : Fin n) (net : Network P n) : Network P n :=
  Function.update net j (merge (net j) (net i))

@[simp] theorem send_apply_target (i j : Fin n) (net : Network P n) :
    send i j net j = merge (net j) (net i) := by
  simp [send]

theorem send_apply_of_ne {k j : Fin n} (i : Fin n) (net : Network P n) (h : k ≠ j) :
    send i j net k = net k := by
  simp [send, Function.update_of_ne h]

theorem mem_send {i j k : Fin n} {net : Network P n} {o : Op P} :
    o ∈ send i j net k ↔ o ∈ net k ∨ (k = j ∧ o ∈ net i) := by
  by_cases h : k = j
  · subst h; simp
  · simp [send_apply_of_ne i net h, h]

/-- Nobody ever forgets: a gossip exchange only grows logs. -/
theorem send_grows (i j : Fin n) (net : Network P n) (k : Fin n) : net k ⊆ send i j net k := by
  intro o ho; exact mem_send.2 (Or.inl ho)

/-- Gossip neither invents nor loses operations. -/
theorem send_total (i j : Fin n) (net : Network P n) : total (send i j net) = total net := by
  ext o
  simp only [mem_total, mem_send]
  constructor
  · rintro ⟨k, hk | ⟨-, hk⟩⟩
    · exact ⟨k, hk⟩
    · exact ⟨i, hk⟩
  · rintro ⟨k, hk⟩; exact ⟨k, Or.inl hk⟩

/-- A peer syncing with itself does nothing. -/
@[simp] theorem send_self (i : Fin n) (net : Network P n) : send i i net = net := by
  funext k
  by_cases h : k = i
  · subst h; simp [merge_self]
  · simp [send_apply_of_ne i net h]

/-! ## Offline play -/

/-- Peer `i` plays offline: it appends the operations it produced on its own. -/
def offlinePlay (i : Fin n) (ops : Log P) (net : Network P n) : Network P n :=
  Function.update net i (merge (net i) ops)

@[simp] theorem offlinePlay_apply_self (i : Fin n) (ops : Log P) (net : Network P n) :
    offlinePlay i ops net i = merge (net i) ops := by
  simp [offlinePlay]

theorem offlinePlay_apply_of_ne {k i : Fin n} (ops : Log P) (net : Network P n) (h : k ≠ i) :
    offlinePlay i ops net k = net k := by
  simp [offlinePlay, Function.update_of_ne h]

/-- What was played offline is part of the population's knowledge as soon as the
player rejoins — no operation produced offline is second class. -/
theorem offlinePlay_subset_total (i : Fin n) (ops : Log P) (net : Network P n) :
    ops ⊆ total (offlinePlay i ops net) := by
  intro o ho
  exact mem_total.2 ⟨i, by simp [subset_merge_right _ _ ho]⟩

/-! ## A sync round, built only out of pairwise exchanges -/

/-- Every peer of the list hands its log to `hub`. -/
def collect (hub : Fin n) : List (Fin n) → Network P n → Network P n
  | [], net => net
  | i :: l, net => collect hub l (send i hub net)

/-- `hub` hands its log to every peer of the list. -/
def broadcast (hub : Fin n) : List (Fin n) → Network P n → Network P n
  | [], net => net
  | j :: l, net => broadcast hub l (send hub j net)

theorem collect_apply_of_ne (hub : Fin n) (l : List (Fin n)) (net : Network P n)
    {k : Fin n} (h : k ≠ hub) : collect hub l net k = net k := by
  induction l generalizing net with
  | nil => rfl
  | cons i l ih => rw [collect, ih, send_apply_of_ne i net h]

theorem mem_collect_hub {hub : Fin n} {l : List (Fin n)} {net : Network P n} {o : Op P} :
    o ∈ collect hub l net hub ↔ o ∈ net hub ∨ ∃ i ∈ l, o ∈ net i := by
  induction l generalizing net with
  | nil => simp [collect]
  | cons i l ih =>
      rw [collect, ih]
      constructor
      · rintro (h | ⟨j, hj, h⟩)
        · rcases mem_send.1 h with h' | ⟨-, h'⟩
          · exact Or.inl h'
          · exact Or.inr ⟨i, List.mem_cons_self, h'⟩
        · rcases mem_send.1 h with h' | ⟨-, h'⟩
          · exact Or.inr ⟨j, List.mem_cons_of_mem _ hj, h'⟩
          · exact Or.inr ⟨i, List.mem_cons_self, h'⟩
      · rintro (h | ⟨j, hj, h⟩)
        · exact Or.inl (mem_send.2 (Or.inl h))
        · rcases List.mem_cons.1 hj with rfl | hj
          · exact Or.inl (mem_send.2 (Or.inr ⟨rfl, h⟩))
          · exact Or.inr ⟨j, hj, mem_send.2 (Or.inl h)⟩

theorem broadcast_apply_hub (hub : Fin n) (l : List (Fin n)) (net : Network P n) :
    broadcast hub l net hub = net hub := by
  induction l generalizing net with
  | nil => rfl
  | cons j l ih =>
      rw [broadcast, ih]
      by_cases h : hub = j
      · subst h; simp [merge_self]
      · exact send_apply_of_ne hub net h

theorem mem_broadcast {hub : Fin n} {l : List (Fin n)} {net : Network P n} {k : Fin n}
    {o : Op P} : o ∈ broadcast hub l net k ↔ o ∈ net k ∨ (k ∈ l ∧ o ∈ net hub) := by
  induction l generalizing net with
  | nil => simp [broadcast]
  | cons j l ih =>
      rw [broadcast, ih]
      have hhub : send hub j net hub = net hub := by
        by_cases h : hub = j
        · subst h; simp [merge_self]
        · exact send_apply_of_ne hub net h
      rw [hhub]
      constructor
      · rintro (h | ⟨hk, h⟩)
        · rcases mem_send.1 h with h' | ⟨rfl, h'⟩
          · exact Or.inl h'
          · exact Or.inr ⟨List.mem_cons_self, h'⟩
        · exact Or.inr ⟨List.mem_cons_of_mem _ hk, h⟩
      · rintro (h | ⟨hk, h⟩)
        · exact Or.inl (mem_send.2 (Or.inl h))
        · rcases List.mem_cons.1 hk with rfl | hk
          · exact Or.inl (mem_send.2 (Or.inr ⟨rfl, h⟩))
          · exact Or.inr ⟨hk, h⟩

/-- One sync round: everybody uploads to `hub`, then `hub` sends the merged log
back down.  Nothing but pairwise `send`s. -/
def fullSync (hub : Fin n) (net : Network P n) : Network P n :=
  broadcast hub (List.finRange n) (collect hub (List.finRange n) net)

/-- **Convergence.**  After one sync round every peer holds exactly everything
that anybody knew, whatever the previous pattern of connectivity. -/
theorem fullSync_eq_total (hub : Fin n) (net : Network P n) (k : Fin n) :
    fullSync hub net k = total net := by
  set m := collect hub (List.finRange n) net with hm
  have hmhub : ∀ o : Op P, o ∈ m hub ↔ ∃ i, o ∈ net i := by
    intro o
    rw [hm, mem_collect_hub]
    constructor
    · rintro (h | ⟨i, -, h⟩)
      · exact ⟨hub, h⟩
      · exact ⟨i, h⟩
    · rintro ⟨i, hi⟩
      exact Or.inr ⟨i, List.mem_finRange i, hi⟩
  have hmk : ∀ (k : Fin n) (o : Op P), o ∈ m k → ∃ i, o ∈ net i := by
    intro k o ho
    by_cases h : k = hub
    · subst h; exact (hmhub o).1 ho
    · exact ⟨k, by rwa [hm, collect_apply_of_ne hub _ net h] at ho⟩
  ext o
  rw [fullSync, ← hm, mem_broadcast, mem_total]
  constructor
  · rintro (h | ⟨-, h⟩)
    · exact hmk k o h
    · exact (hmhub o).1 h
  · intro h
    exact Or.inr ⟨List.mem_finRange k, (hmhub o).2 h⟩

/-- After a sync round every peer computes the same game state: the same world,
the same tractor, the same score, on the phone, in the browser and in Roblox. -/
theorem fullSync_replay {S : Type} (step : S → P → S) (init : S) (hub : Fin n)
    (net : Network P n) (k k' : Fin n) :
    replay step init (fullSync hub net k) = replay step init (fullSync hub net k') := by
  rw [fullSync_eq_total, fullSync_eq_total]

/-- A sync round loses nothing. -/
theorem fullSync_grows (hub : Fin n) (net : Network P n) (k : Fin n) :
    net k ⊆ fullSync hub net k := by
  rw [fullSync_eq_total]; exact subset_total net k

/-- Syncing an already-synced population changes nothing. -/
theorem fullSync_idem (hub : Fin n) (net : Network P n) :
    fullSync hub (fullSync hub net) = fullSync hub net := by
  funext k
  rw [fullSync_eq_total, fullSync_eq_total]
  ext o
  rw [mem_total]
  constructor
  · rintro ⟨i, hi⟩; rwa [fullSync_eq_total] at hi
  · intro h; exact ⟨k, by rw [fullSync_eq_total]; exact h⟩

/-- **Offline play is first class.**  A peer that went away, played a whole
session on its own and came back has all of its work adopted by everyone at the
next sync round. -/
theorem offline_then_sync (hub i : Fin n) (ops : Log P) (net : Network P n) (k : Fin n) :
    ops ⊆ fullSync hub (offlinePlay i ops net) k := by
  rw [fullSync_eq_total]
  exact offlinePlay_subset_total i ops net

end Net
end LifeTrac
