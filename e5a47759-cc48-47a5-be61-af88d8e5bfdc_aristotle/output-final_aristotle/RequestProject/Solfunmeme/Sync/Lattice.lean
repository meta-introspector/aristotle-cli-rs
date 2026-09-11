import Mathlib

/-!
# The solfunmeme node's replication model

The node shipped in `node/` keeps its state as a **set of content-addressed
updates**, and merging two states is set union.  Everything the deployment
promises rests on that one choice, and this file proves it:

* `merge` is a semilattice join --- commutative, associative, idempotent, and
  monotone (`Solfunmeme.Sync.merge_comm` and friends).  A node can never go
  backwards, and no record can be un-said.
* The state after a list of deliveries depends only on the **set** of records
  delivered: not on their order (`run_perm_invariant`), not on how often each
  arrived (`run_append_self`), and not on which link carried them
  (`run_retag`, `transports_interchangeable`).  That is exactly the statement
  that a libp2p gossip message, a UUCP job and a USB stick are the same thing
  to a node.
* Under that hypothesis the network converges: any family of nodes that has
  each received everything ends in the same state, namely the union of all the
  records anyone ever had (`convergence`), and they then agree on the head
  (`heads_agree`).
* The head --- the record a website or a phone actually displays --- is the
  greatest element of the state under a total order fixed in advance, so it is
  a function of the set (`head_congr`) and it never regresses as records
  arrive (`headKey_mono`).

The implementation mirrors this file one for one; `node/tests/test_sync.py`
and `node/libp2p/test-protocol.mjs` check the Python and JavaScript sides
against the same properties, including the concrete three-node run with mixed
transports.
-/

namespace Solfunmeme.Sync

/-- A record exchanged between nodes.

`uid` is the content address: the SHA-256 of the canonical encoding of all the
other fields.  Two nodes that observe the same thing therefore produce the
*same* record, which is what keeps the union finite.  Fields that vary by
observer (which node published it, when it was relayed) are deliberately not
part of the identity and so are not modelled here. -/
structure Update where
  /-- What is being reported: `snapshot`, `badge`, `review`, ... -/
  kind : String
  /-- The upstream dataset the observation is about. -/
  dataset : String
  /-- Monotone counter within a kind; orders the head. -/
  seq : Nat
  /-- Observation time, seconds since the epoch. -/
  unix : Nat
  /-- The content address. -/
  uid : String
  deriving DecidableEq, Repr

/-- A node's replicated state: the finite set of records it holds. -/
abbrev State := Finset Update

/-- Merging two states.  This is the *only* way a state ever changes. -/
def merge (a b : State) : State := a ∪ b

/-! ## `merge` is a join -/

@[simp] theorem merge_empty (a : State) : merge a ∅ = a := by
  simp [merge]

@[simp] theorem empty_merge (a : State) : merge ∅ a = a := by
  simp [merge]

theorem merge_comm (a b : State) : merge a b = merge b a := by
  simp [merge, Finset.union_comm]

theorem merge_assoc (a b c : State) : merge (merge a b) c = merge a (merge b c) := by
  simp [merge, Finset.union_assoc]

@[simp] theorem merge_idem (a : State) : merge a a = a := by
  simp [merge]

/-- Receiving the same bundle twice changes nothing. -/
theorem merge_self_right (a b : State) : merge (merge a b) b = merge a b := by
  simp [merge, Finset.union_assoc]

/-- A node never loses a record. -/
theorem subset_merge_left (a b : State) : a ⊆ merge a b :=
  Finset.subset_union_left

theorem subset_merge_right (a b : State) : b ⊆ merge a b :=
  Finset.subset_union_right

/-- Merging is monotone in both arguments. -/
theorem merge_mono {a a' b b' : State} (ha : a ⊆ a') (hb : b ⊆ b') :
    merge a b ⊆ merge a' b' :=
  Finset.union_subset_union ha hb

/-- The state only grows, so its size never decreases. -/
theorem card_le_card_merge (a b : State) : a.card ≤ (merge a b).card :=
  Finset.card_le_card (subset_merge_left a b)

/-! ## Transports and deliveries -/

/-- How a bundle of records reached the node. -/
inductive Transport
  /-- gossipsub or a pairwise sync over libp2p -/
  | libp2p
  /-- a bundle queued through a UUCP spool -/
  | uucp
  /-- a bundle carried by hand on removable media -/
  | media
  deriving DecidableEq, Repr

/-- One arrival: a set of records, and the link it came in on. -/
structure Delivery where
  via : Transport
  payload : State
  deriving DecidableEq

/-- Applying one delivery.  The transport tag is not consulted --- that is the
whole point, and every theorem below is a consequence of it. -/
def step (s : State) (d : Delivery) : State := merge s d.payload

/-- The state after a run of deliveries. -/
def run (s : State) (ds : List Delivery) : State := ds.foldl step s

@[simp] theorem run_nil (s : State) : run s [] = s := rfl

@[simp] theorem run_cons (s : State) (d : Delivery) (ds : List Delivery) :
    run s (d :: ds) = run (merge s d.payload) ds := rfl

/-- Everything a run delivered, as one set. -/
def delivered (ds : List Delivery) : State :=
  (ds.map Delivery.payload).foldr (· ∪ ·) ∅

@[simp] theorem delivered_nil : delivered [] = ∅ := rfl

@[simp] theorem delivered_cons (d : Delivery) (ds : List Delivery) :
    delivered (d :: ds) = d.payload ∪ delivered ds := rfl

/-- **The normal form of a run**: whatever happened, the node holds what it
started with together with everything that was delivered. -/
theorem run_eq_merge_delivered (s : State) (ds : List Delivery) :
    run s ds = merge s (delivered ds) := by
  induction ds generalizing s with
  | nil => simp [merge]
  | cons d ds ih =>
      simp only [run_cons, delivered_cons, ih, merge]
      rw [Finset.union_assoc]

theorem run_append (s : State) (ds es : List Delivery) :
    run s (ds ++ es) = run (run s ds) es := by
  simp [run, List.foldl_append]

@[simp] theorem delivered_append (ds es : List Delivery) :
    delivered (ds ++ es) = delivered ds ∪ delivered es := by
  induction ds with
  | nil => simp
  | cons d ds ih => simp [ih, Finset.union_assoc]

/-! ## Order, duplication and transport do not matter -/

/-- Deliveries commute. -/
theorem run_pair_comm (s : State) (d e : Delivery) :
    run s [d, e] = run s [e, d] := by
  simp [run_eq_merge_delivered, merge, Finset.union_comm]

/-- **Arrival order is irrelevant.**  Gossip reorders messages and couriers
overtake each other; neither can change a node's state. -/
theorem run_perm_invariant (s : State) {ds es : List Delivery} (h : ds.Perm es) :
    run s ds = run s es := by
  have : delivered ds = delivered es :=
    List.Perm.foldr_eq (h.map Delivery.payload) ∅
  simp [run_eq_merge_delivered, this]

/-- **Duplicates are free.**  Replaying an entire run is a no-op, so a peer may
re-send anything, a stick may be plugged in twice, and gossip may flood. -/
@[simp] theorem run_append_self (s : State) (ds : List Delivery) :
    run s (ds ++ ds) = run s ds := by
  simp [run_eq_merge_delivered, merge]

/-- Redelivering a single arrival is a no-op. -/
theorem run_cons_dup (s : State) (d : Delivery) :
    run s [d, d] = run s [d] := by
  simp [run_eq_merge_delivered, merge]

/-- Retagging every delivery with a different transport --- pretending the
courier's bundle arrived by gossip, or the reverse --- leaves the state alone. -/
theorem run_retag (s : State) (ds : List Delivery) (t : Transport → Transport) :
    run s (ds.map fun d => ⟨t d.via, d.payload⟩) = run s ds := by
  have : delivered (ds.map fun d => ⟨t d.via, d.payload⟩) = delivered ds := by
    induction ds with
    | nil => simp
    | cons d ds ih => simp [ih]
  simp [run_eq_merge_delivered, this]

/-- **libp2p and sneakernet are interchangeable.**  Two runs that carry the
same payloads leave the node in the same state even if every single record
travelled by a different route in the two runs, arrived in a different order,
and was duplicated in one of them. -/
theorem transports_interchangeable (s : State) (ds es : List Delivery)
    (h : (ds.map Delivery.payload).Perm (es.map Delivery.payload)) :
    run s ds = run s es := by
  have : delivered ds = delivered es := List.Perm.foldr_eq h ∅
  simp [run_eq_merge_delivered, this]

/-- Splitting a node's links into an online half and an offline half: it does
not matter whether the node is on the network first and reads its post later,
or the other way round. -/
theorem online_offline_commute (s : State) (online offline : List Delivery) :
    run s (online ++ offline) = run s (offline ++ online) :=
  transports_interchangeable s _ _ (by
    simpa [List.map_append] using (List.perm_append_comm
      (l₁ := online.map Delivery.payload) (l₂ := offline.map Delivery.payload)))

/-- A run is monotone: no delivery can remove a record. -/
theorem subset_run (s : State) (ds : List Delivery) : s ⊆ run s ds := by
  simp [run_eq_merge_delivered, merge]

/-- Delivering more can only give you more. -/
theorem run_mono_state {s t : State} (ds : List Delivery) (h : s ⊆ t) :
    run s ds ⊆ run t ds := by
  simp only [run_eq_merge_delivered, merge]
  exact Finset.union_subset_union h (Finset.Subset.refl _)

/-! ## Convergence

The delivery model above says a node's state is determined by what it received.
Convergence is then the statement that "everyone received everything" forces
agreement --- and, crucially, agreement *on the union*, so no node's private
knowledge is lost. -/

/-- A node: what it held to begin with, and what was delivered to it. -/
structure Node where
  initial : State
  inbox : List Delivery

/-- Its final state. -/
def Node.final (n : Node) : State := run n.initial n.inbox

/-- The union of everything the whole network ever held. -/
def total (ns : List Node) : State :=
  (ns.map fun n => merge n.initial (delivered n.inbox)).foldr (· ∪ ·) ∅

@[simp] theorem total_nil : total [] = ∅ := rfl

@[simp] theorem total_cons (n : Node) (ns : List Node) :
    total (n :: ns) = merge n.initial (delivered n.inbox) ∪ total ns := rfl

theorem final_subset_total {ns : List Node} {n : Node} (hn : n ∈ ns) :
    n.final ⊆ total ns := by
  induction ns with
  | nil => cases hn
  | cons m ms ih =>
      rcases List.mem_cons.mp hn with rfl | hmem
      · intro x hx
        have hx' : x ∈ merge n.initial (delivered n.inbox) := by
          simpa [Node.final, run_eq_merge_delivered] using hx
        exact Finset.mem_union.mpr (Or.inl hx')
      · intro x hx
        exact Finset.mem_union.mpr (Or.inr (ih hmem hx))

/-- **Convergence.**  If every node has, one way or another, received
everything the network holds, then every node holds exactly the union --- so
all of them agree, whatever mixture of gossip and couriers got them there. -/
theorem convergence (ns : List Node)
    (complete : ∀ n ∈ ns, total ns ⊆ n.final) :
    ∀ n ∈ ns, n.final = total ns := fun n hn =>
  Finset.Subset.antisymm (final_subset_total hn) (complete n hn)

/-- Any two nodes that have received everything agree. -/
theorem converged_pairwise (ns : List Node)
    (complete : ∀ n ∈ ns, total ns ⊆ n.final)
    {a b : Node} (ha : a ∈ ns) (hb : b ∈ ns) : a.final = b.final := by
  rw [convergence ns complete a ha, convergence ns complete b hb]

/-- The completeness hypothesis is exactly "delivery eventually happens", and
it is satisfiable by either transport alone: a node whose inbox contains one
delivery carrying the whole union is converged, whether that delivery was a
gossip flood or a single bundle handed over on a memory card. -/
theorem one_bundle_suffices (ns : List Node) (t : Transport) (n : Node)
    (h : n.inbox = [⟨t, total ns⟩]) : total ns ⊆ n.final := by
  simp [Node.final, h, run_eq_merge_delivered, merge]

/-! ## The head

A website, a phone and a `solfunmeme-node head` all display one record: the
greatest one under a total order fixed in advance.  Because that order does not
depend on the node, converged nodes display the same thing. -/

/-- The ordering key: sequence number first, then observation time, then the
content address as a tie-break.  Lexicographic, hence total. -/
def key (u : Update) : Lex (Nat × Lex (Nat × String)) :=
  toLex (u.seq, toLex (u.unix, u.uid))

/-- The head of a state, restricted to one kind of record: the greatest key
present, or `⊥` if the node holds no record of that kind. -/
noncomputable def headKey (kind : String) (s : State) :
    WithBot (Lex (Nat × Lex (Nat × String))) :=
  ((s.filter fun u => u.kind = kind).image key).max

/-- The head is a function of the state alone: no history, no arrival order, no
transport.  Two nodes holding the same set display the same record. -/
theorem head_congr (kind : String) {s t : State} (h : s = t) :
    headKey kind s = headKey kind t := by
  rw [h]

/-- Converged nodes display the same head. -/
theorem heads_agree (kind : String) (ns : List Node)
    (complete : ∀ n ∈ ns, total ns ⊆ n.final)
    {a b : Node} (ha : a ∈ ns) (hb : b ∈ ns) :
    headKey kind a.final = headKey kind b.final :=
  head_congr kind (converged_pairwise ns complete ha hb)

/-- The head never regresses: merging in more records can only move it up. -/
theorem headKey_mono (kind : String) {s t : State} (h : s ⊆ t) :
    headKey kind s ≤ headKey kind t := by
  refine Finset.max_mono (Finset.image_subset_image ?_)
  exact Finset.filter_subset_filter _ h

/-- In particular a run can only advance the head. -/
theorem headKey_run (kind : String) (s : State) (ds : List Delivery) :
    headKey kind s ≤ headKey kind (run s ds) :=
  headKey_mono kind (subset_run s ds)

/-- A node with no records of a kind has no head of that kind. -/
@[simp] theorem headKey_empty (kind : String) : headKey kind (∅ : State) = ⊥ := by
  simp [headKey]

/-- The head of a nonempty state is one of its records. -/
theorem headKey_mem {kind : String} {s : State} {k : Lex (Nat × Lex (Nat × String))}
    (h : headKey kind s = (k : WithBot _)) :
    ∃ u ∈ s, u.kind = kind ∧ key u = k := by
  have hmem := Finset.mem_of_max h
  rcases Finset.mem_image.mp hmem with ⟨u, hu, hku⟩
  rcases Finset.mem_filter.mp hu with ⟨hus, huk⟩
  exact ⟨u, hus, huk, hku⟩

end Solfunmeme.Sync
