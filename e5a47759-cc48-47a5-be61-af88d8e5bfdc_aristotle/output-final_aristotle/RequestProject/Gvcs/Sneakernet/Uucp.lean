import Mathlib.Tactic

/-!
# UUCP bang paths and sneakernet transport

Store-and-forward mail for the multiplayer game.  A `Packet` carries a payload
along a bang path `ihnp4!decvax!home` — a list of the hops that are still to be
made.  A `Wire` is the whole network: the bag of packets still in flight, and
the bag of payloads that have already landed in somebody's inbox.

One `step` is one polling round (or one bicycle ride with a tape in the pannier
— the model does not care which): every packet in flight advances one hop, and
a packet with no hops left is delivered.

The theorems say that store-and-forward loses nothing and that it does not
matter how the mail is batched:

* `payloads_step`, `payloads_steps` — the bag of payloads is invariant;
* `step_add` — carrying two sacks of mail is carrying their union;
* `inbox_le_steps` — the inbox only ever grows;
* `flight_eq_zero`, `delivered_all` — after more rounds than the longest bang
  path, every packet has been delivered.
-/

namespace LifeTrac
namespace Sneakernet

/-- A piece of mail: `route` is the bang path still to be walked, `payload` is
what is being carried, `from_` records the site it is sitting at. -/
structure Packet (α : Type) where
  /-- The site the packet is currently at. -/
  from_ : String
  /-- The remaining hops of the bang path. -/
  route : List String
  /-- The carried payload. -/
  payload : α
  deriving DecidableEq, Repr

namespace Packet

variable {α : Type}

/-- The site the packet is bound for: the last name on the bang path (its
current site if the path is empty, i.e. it is already home). -/
def dest (q : Packet α) : String := q.route.getLast?.getD q.from_

/-- The number of hops still to be made. -/
def hops (q : Packet α) : ℕ := q.route.length

/-- Advance a packet by one hop.  `none` means it has arrived. -/
def hop (q : Packet α) : Option (Packet α) :=
  match q.route with
  | [] => none
  | h :: rest => some { q with from_ := h, route := rest }

@[simp] theorem hop_nil {f : String} {a : α} :
    hop { from_ := f, route := [], payload := a } = none := rfl

@[simp] theorem hop_cons {f h : String} {rest : List String} {a : α} :
    hop { from_ := f, route := h :: rest, payload := a } =
      some { from_ := h, route := rest, payload := a } := rfl

theorem hops_hop {q r : Packet α} (h : q.hop = some r) : r.hops + 1 = q.hops := by
  unfold hop at h
  cases hr : q.route with
  | nil => rw [hr] at h; simp at h
  | cons x xs =>
      rw [hr] at h
      simp only [Option.some.injEq] at h
      subst h
      simp [hops, hr]

theorem payload_hop {q r : Packet α} (h : q.hop = some r) : r.payload = q.payload := by
  unfold hop at h
  cases hr : q.route with
  | nil => rw [hr] at h; simp at h
  | cons x xs =>
      rw [hr] at h
      simp only [Option.some.injEq] at h
      subst h
      rfl

theorem hop_eq_none {q : Packet α} : q.hop = none ↔ q.hops = 0 := by
  unfold hop hops
  cases q.route <;> simp

end Packet

/-- A delivered item: the payload, and the site it landed at. -/
structure Delivery (α : Type) where
  /-- The site where the payload landed. -/
  site : String
  /-- The payload. -/
  payload : α
  deriving DecidableEq, Repr

/-- The state of the whole network: mail in flight, and mail delivered. -/
structure Wire (α : Type) where
  /-- Packets still being carried. -/
  flight : Multiset (Packet α)
  /-- Payloads that have reached their destination. -/
  inbox : Multiset (Delivery α)

namespace Wire

variable {α : Type}

/-- The empty network. -/
def empty : Wire α := ⟨0, 0⟩

/-- Post a batch of packets. -/
def post (w : Wire α) (qs : Multiset (Packet α)) : Wire α :=
  ⟨w.flight + qs, w.inbox⟩

/-- What one hop does to a single packet: either it moves on, or it lands. -/
def one (q : Packet α) : Wire α :=
  match q.hop with
  | some r => ⟨{r}, 0⟩
  | none => ⟨0, {⟨q.from_, q.payload⟩}⟩

/-- One polling round / one courier run: every packet in flight advances a hop. -/
def step (w : Wire α) : Wire α :=
  ⟨(w.flight.bind fun q => (one q).flight),
   w.inbox + w.flight.bind fun q => (one q).inbox⟩

/-- `n` rounds. -/
def steps (w : Wire α) : ℕ → Wire α
  | 0 => w
  | n + 1 => step (steps w n)

@[simp] theorem steps_zero (w : Wire α) : steps w 0 = w := rfl

@[simp] theorem steps_succ (w : Wire α) (n : ℕ) :
    steps w (n + 1) = step (steps w n) := rfl

theorem steps_add (w : Wire α) (m n : ℕ) :
    steps w (m + n) = steps (steps w m) n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [steps, ← ih]

theorem steps_succ' (w : Wire α) (n : ℕ) : steps w (n + 1) = steps (step w) n := by
  rw [add_comm, steps_add]; rfl

/-! ### Conservation of mail -/

/-- All payloads in the network, in flight or delivered. -/
def payloads (w : Wire α) : Multiset α :=
  w.flight.map Packet.payload + w.inbox.map Delivery.payload

theorem payloads_one (q : Packet α) : payloads (one q) = {q.payload} := by
  unfold one payloads
  cases h : q.hop with
  | none => simp
  | some r => simp [Packet.payload_hop h]

theorem payloads_step_zero (f : Multiset (Packet α)) :
    payloads (step (⟨f, 0⟩ : Wire α)) = f.map Packet.payload := by
  induction f using Multiset.induction_on with
  | empty => simp [step, payloads]
  | cons q f ih =>
      have h1 := payloads_one q
      unfold payloads step at *
      simp only [Multiset.cons_bind, Multiset.map_add, zero_add, Multiset.map_cons] at *
      rw [show (one q).flight.map Packet.payload
            + (f.bind fun x => (one x).flight).map Packet.payload
            + ((one q).inbox.map Delivery.payload
              + (f.bind fun x => (one x).inbox).map Delivery.payload)
          = ((one q).flight.map Packet.payload + (one q).inbox.map Delivery.payload)
            + ((f.bind fun x => (one x).flight).map Packet.payload
              + (f.bind fun x => (one x).inbox).map Delivery.payload) from by abel]
      rw [h1, ih, Multiset.singleton_add]

/-- **Store-and-forward loses nothing**: one round moves mail, it does not
create or destroy it. -/
theorem payloads_step (w : Wire α) : payloads (step w) = payloads w := by
  obtain ⟨f, i⟩ := w
  have h := payloads_step_zero f
  unfold payloads step at *
  simp only [Multiset.map_add, zero_add] at h ⊢
  rw [show (f.bind fun x => (one x).flight).map Packet.payload
        + (i.map Delivery.payload + (f.bind fun x => (one x).inbox).map Delivery.payload)
      = ((f.bind fun x => (one x).flight).map Packet.payload
        + (f.bind fun x => (one x).inbox).map Delivery.payload)
        + i.map Delivery.payload from by abel]
  rw [h]

theorem payloads_steps (w : Wire α) (n : ℕ) : payloads (steps w n) = payloads w := by
  induction n with
  | zero => rfl
  | succ n ih => rw [steps_succ, payloads_step, ih]

/-! ### Batching is irrelevant -/

/-- **Batching mail onto media does not matter**: hopping the union of two
sacks is the union of hopping each. -/
theorem step_add (f g : Multiset (Packet α)) (i j : Multiset (Delivery α)) :
    step (⟨f + g, i + j⟩ : Wire α) =
      ⟨(step (⟨f, i⟩ : Wire α)).flight + (step (⟨g, j⟩ : Wire α)).flight,
       (step (⟨f, i⟩ : Wire α)).inbox + (step (⟨g, j⟩ : Wire α)).inbox⟩ := by
  simp only [step, Multiset.add_bind, Wire.mk.injEq, true_and]
  abel

/-! ### The inbox only grows -/

theorem inbox_le_step (w : Wire α) : w.inbox ≤ (step w).inbox := by
  simp [step]

theorem inbox_le_steps (w : Wire α) (n : ℕ) : w.inbox ≤ (steps w n).inbox := by
  induction n with
  | zero => exact le_refl _
  | succ n ih => exact le_trans ih (inbox_le_step _)

theorem mem_inbox_steps {w : Wire α} {d : Delivery α} (n : ℕ) (h : d ∈ w.inbox) :
    d ∈ (steps w n).inbox :=
  Multiset.mem_of_le (inbox_le_steps w n) h

/-! ### Everything is eventually delivered -/

/-- The longest bang path still in flight. -/
def maxHops (w : Wire α) : ℕ := (w.flight.map Packet.hops).sup

theorem hops_le_maxHops {w : Wire α} {q : Packet α} (h : q ∈ w.flight) :
    q.hops ≤ maxHops w :=
  Multiset.le_sup (Multiset.mem_map_of_mem _ h)

theorem maxHops_le {w : Wire α} {n : ℕ} (h : ∀ q ∈ w.flight, q.hops ≤ n) :
    maxHops w ≤ n := by
  refine Multiset.sup_le.2 ?_
  intro a ha
  obtain ⟨q, hq, rfl⟩ := Multiset.mem_map.1 ha
  exact h q hq

theorem flight_step_hops {w : Wire α} {r : Packet α} (h : r ∈ (step w).flight) :
    ∃ q ∈ w.flight, q.hop = some r := by
  simp only [step, Multiset.mem_bind] at h
  obtain ⟨q, hq, hr⟩ := h
  refine ⟨q, hq, ?_⟩
  unfold one at hr
  cases hh : q.hop with
  | none => rw [hh] at hr; simp at hr
  | some r' =>
      rw [hh] at hr
      simp only [Multiset.mem_singleton] at hr
      rw [hr]

/-- A round shortens the longest bang path in flight. -/
theorem maxHops_step_le {w : Wire α} {n : ℕ} (h : maxHops w ≤ n + 1) :
    maxHops (step w) ≤ n := by
  refine maxHops_le ?_
  intro r hr
  obtain ⟨q, hq, hqr⟩ := flight_step_hops hr
  have h1 := Packet.hops_hop hqr
  have h2 := hops_le_maxHops hq
  omega

/-- When no bang path has a hop left, one round empties the network. -/
theorem flight_step_eq_zero {w : Wire α} (h : maxHops w = 0) : (step w).flight = 0 := by
  rw [Multiset.eq_zero_iff_forall_notMem]
  intro r hr
  obtain ⟨q, hq, hqr⟩ := flight_step_hops hr
  have h1 := Packet.hops_hop hqr
  have h2 := hops_le_maxHops hq
  omega

/-- **The mail always gets through**: after more rounds than the longest bang
path, nothing is in flight. -/
theorem flight_eq_zero (w : Wire α) {n : ℕ} (h : maxHops w < n) :
    (steps w n).flight = 0 := by
  induction n generalizing w with
  | zero => omega
  | succ n ih =>
      rw [steps_succ' w n]
      rcases Nat.eq_zero_or_pos n with hn | hn
      · subst hn
        exact flight_step_eq_zero (by omega)
      · exact ih (step w) (by
          have := maxHops_step_le (w := w) (n := n - 1) (by omega)
          omega)

/-- **Everything is eventually delivered.**  After enough rounds the inbox
holds exactly the payloads that were posted. -/
theorem delivered_all (w : Wire α) {n : ℕ} (h : maxHops w < n) :
    ((steps w n).inbox.map Delivery.payload) = payloads w := by
  have hf := flight_eq_zero w h
  have hp := payloads_steps w n
  unfold payloads at hp
  rw [hf] at hp
  simpa using hp

end Wire

end Sneakernet
end LifeTrac
