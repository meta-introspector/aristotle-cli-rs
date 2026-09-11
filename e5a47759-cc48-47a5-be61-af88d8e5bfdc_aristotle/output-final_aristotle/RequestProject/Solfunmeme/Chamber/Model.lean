/-
  Model.lean — the new chamber.

  This replaces the senate model the project inherited from the dataset
  (`RequestProject/Upstream/FederalGov.lean`, shown dead in
  `RequestProject/Review/`, and repaired only in its arithmetic by
  `RequestProject/Federal/Congress.lean`).  The old model counts *numbers*: a
  tally is three natural numbers and a chamber is two.  Nothing in it records
  who voted, so nothing in it can say that a member voted twice, that somebody
  holding no seat voted at all, or that a proxy overrode its grantor's own
  ballot.  Those are the failures a chamber has to rule out.

  The new chamber is stated over *ballots*, one per named voter, and the tally
  is derived from the roll of seats rather than asserted:

      Roll      the seats: who holds them, in which rotation class, at what stake
      Ballot    a voter's name and their choice
      Proxy     a grantor and the agent who may vote in their place
      cast      the roll's own reading of a ballot box

  `cast` walks the *seats*, not the ballots, and takes for each seat the first
  ballot in the box cast in that seat's name.  Three rules therefore hold by
  construction rather than by decree:

    * a ballot from someone who holds no seat is not counted
      (`outsider_ballot_ignored`);
    * a member who votes twice is counted once, and a box stuffed with a copy
      of itself decides exactly what the original decided
      (`duplicate_ballot_ignored`, `stuffing_changes_nothing`);
    * the ayes, the nays and the abstentions account for every member present
      and for no one else (`tally_total`, `present_le_size`).

  On top of that:

    * `unanimous_carries`, `quorum_attainable` — the chamber can act.  This is
      the point of the replacement: the dataset's rule takes a quorum from a
      nominal chamber that was never filled, so every motion under it dies
      `noQuorum`.  Here a quorum is a majority of the seats that exist, and a
      chamber with at least one seat always has a passing roll.
    * `two_thirds_implies_simple`, `three_quarters_implies_two_thirds` — the
      higher thresholds are strictly harder.
    * the proxy rules: a proxy never overrides its grantor's own ballot
      (`proxy_never_overrides`), a self-proxy adds nothing
      (`self_proxy_adds_nothing`), a proxy held by a member who did not vote
      adds nothing (`silent_agent_adds_nothing`), and proxies can only add
      members to the count, never remove one (`proxy_present_monotone`).
    * the rotation rules: seats sit in classes and one class turns over at a
      time, so the chamber is never re-elected wholesale (`rotate_size`,
      `rotate_retains_other_classes`, `rotate_continuity`).
-/

namespace Chamber

/-! ### List helpers -/

private theorem filterMap_congr' {α β : Type} {f g : α → Option β} (l : List α)
    (h : ∀ a ∈ l, f a = g a) : l.filterMap f = l.filterMap g := by
  induction l with
  | nil => rfl
  | cons a t ih =>
      simp [List.filterMap_cons, h a (by simp), ih (fun x hx => h x (by simp [hx]))]

private theorem filterMap_eq_map_of_forall {α β : Type} (f : α → Option β) (g : α → β)
    (l : List α) (h : ∀ a ∈ l, f a = some (g a)) : l.filterMap f = l.map g := by
  induction l with
  | nil => rfl
  | cons a t ih =>
      simp [h a (by simp), ih (fun x hx => h x (by simp [hx]))]

private theorem length_filterMap_mono {α β γ : Type} (f : α → Option β) (g : α → Option γ)
    (l : List α) (h : ∀ a ∈ l, (f a).isSome = true → (g a).isSome = true) :
    (l.filterMap f).length ≤ (l.filterMap g).length := by
  induction l with
  | nil => simp
  | cons a t ih =>
      have ih' := ih (fun x hx => h x (by simp [hx]))
      cases hf : f a with
      | none =>
          cases hg : g a with
          | none => simpa [List.filterMap_cons, hf, hg] using ih'
          | some _ => simp [hf, hg]; omega
      | some _ =>
          have : (g a).isSome = true := h a (by simp) (by simp [hf])
          cases hg : g a with
          | none => simp [hg] at this
          | some _ => simpa [List.filterMap_cons, hf, hg] using ih'

/-! ### The chamber -/

/-- A choice on a motion. -/
inductive Vote where
  /-- In favour. -/
  | aye
  /-- Against. -/
  | nay
  /-- Present, not voting. -/
  | abstain
deriving DecidableEq, Repr, Inhabited

/-- A seat: who holds it, the rotation class it turns over in, and the stake
standing behind it. -/
structure Seat where
  /-- The address holding the seat. -/
  holder : String
  /-- The rotation class (seats turn over one class at a time). -/
  klass : Nat
  /-- The stake standing behind the seat, in whole tokens. -/
  weight : Nat
deriving DecidableEq, Repr, Inhabited

/-- The roll: the seats of the chamber, in order. -/
structure Roll where
  /-- The seats. -/
  seats : List Seat
deriving DecidableEq, Repr, Inhabited

namespace Roll

/-- How many seats exist. -/
def size (r : Roll) : Nat := r.seats.length

/-- The addresses holding a seat. -/
def holders (r : Roll) : List String := r.seats.map (fun s => s.holder)

/-- Does this address hold a seat? -/
def seated (r : Roll) (a : String) : Bool := r.holders.contains a

theorem seated_iff {r : Roll} {a : String} : r.seated a = true ↔ a ∈ r.holders := by
  simp [seated]

end Roll

/-- A ballot: a name and a choice. -/
structure Ballot where
  /-- The address voting. -/
  voter : String
  /-- The choice. -/
  choice : Vote
deriving DecidableEq, Repr, Inhabited

/-- A proxy: `grantor` authorises `agent` to carry their vote. -/
structure Proxy where
  /-- The member granting the proxy. -/
  grantor : String
  /-- The member who may carry it. -/
  agent : String
deriving DecidableEq, Repr, Inhabited

/-! ### Reading a ballot box -/

/-- **The chamber's own reading of a ballot box.**  For each seat, in seat
order, the first ballot in the box cast in that seat's name.  A seat whose
holder did not vote contributes nothing; a ballot in nobody's name is never
read; a second ballot in the same name is never reached. -/
def cast (r : Roll) (bs : List Ballot) : List (Seat × Vote) :=
  r.seats.filterMap fun s =>
    (bs.find? (fun b => b.voter == s.holder)).map (fun b => (s, b.choice))

/-- Members present, that is, members whose ballot the chamber read. -/
def present (r : Roll) (bs : List Ballot) : Nat := (cast r bs).length

/-- Members present who made a given choice. -/
def count (r : Roll) (bs : List Ballot) (v : Vote) : Nat :=
  ((cast r bs).filter (fun p => p.2 == v)).length

/-- Ayes. -/
def ayes (r : Roll) (bs : List Ballot) : Nat := count r bs Vote.aye

/-- Nays. -/
def nays (r : Roll) (bs : List Ballot) : Nat := count r bs Vote.nay

/-- Abstentions. -/
def abstentions (r : Roll) (bs : List Ballot) : Nat := count r bs Vote.abstain

/-- The stake behind a given choice, in whole tokens. -/
def weightFor (r : Roll) (bs : List Ballot) (v : Vote) : Nat :=
  (((cast r bs).filter (fun p => p.2 == v)).map (fun p => p.1.weight)).foldl (· + ·) 0

/-! ### Thresholds -/

/-- A quorum is a majority of the seats that exist. -/
def quorumOf (r : Roll) : Nat := r.size / 2 + 1

/-- Was a quorum present? -/
def hasQuorum (r : Roll) (bs : List Ballot) : Bool := decide (quorumOf r ≤ present r bs)

/-- What a motion must clear. -/
inductive Threshold where
  /-- More ayes than nays, among those present. -/
  | simple
  /-- Two thirds of all seats voting aye. -/
  | twoThirds
  /-- Three quarters of all seats voting aye: the charter threshold. -/
  | threeQuarters
deriving DecidableEq, Repr, Inhabited

/-- Does the box carry a motion at the given threshold? -/
def carries (r : Roll) (t : Threshold) (bs : List Ballot) : Bool :=
  hasQuorum r bs &&
    match t with
    | .simple => decide (nays r bs < ayes r bs)
    | .twoThirds => decide (2 * r.size ≤ 3 * ayes r bs)
    | .threeQuarters => decide (3 * r.size ≤ 4 * ayes r bs)

/-! ### What the reading guarantees -/

theorem cast_length_le (r : Roll) (bs : List Ballot) : (cast r bs).length ≤ r.size :=
  List.length_filterMap_le _ _

/-- **Nobody is present who does not hold a seat.** -/
theorem present_le_size (r : Roll) (bs : List Ballot) : present r bs ≤ r.size :=
  cast_length_le r bs

private theorem split_by_choice (l : List (Seat × Vote)) :
    (l.filter (fun p => p.2 == Vote.aye)).length
      + (l.filter (fun p => p.2 == Vote.nay)).length
      + (l.filter (fun p => p.2 == Vote.abstain)).length = l.length := by
  induction l with
  | nil => rfl
  | cons a t ih =>
      cases h : a.2 <;> simp [h] <;> omega

/-- **The tally accounts for everybody present and for nobody else.** -/
theorem tally_total (r : Roll) (bs : List Ballot) :
    ayes r bs + nays r bs + abstentions r bs = present r bs :=
  split_by_choice (cast r bs)

theorem ayes_add_nays_le_size (r : Roll) (bs : List Ballot) :
    ayes r bs + nays r bs ≤ r.size := by
  have h := tally_total r bs
  have h2 := present_le_size r bs
  omega

/-- **A ballot in nobody's name is not read.** -/
theorem outsider_ballot_ignored (r : Roll) (b : Ballot) (bs : List Ballot)
    (h : r.seated b.voter = false) : cast r (b :: bs) = cast r bs := by
  have hb : ∀ s ∈ r.seats, ¬ (b.voter == s.holder) = true := by
    intro s hs he
    have hmem : s.holder ∈ r.holders := List.mem_map_of_mem hs
    have : b.voter ∈ r.holders := by
      have : b.voter = s.holder := by simpa using he
      rwa [this]
    simp [Roll.seated, this] at h
  refine filterMap_congr' r.seats ?_
  intro s hs
  simp [hb s hs]

/-- **A second ballot in the same name is never reached**: the box is read
first-come, so the vote a member casts is the vote they cast first. -/
theorem duplicate_ballot_ignored (r : Roll) (b b' : Ballot) (bs : List Ballot)
    (h : b'.voter = b.voter) : cast r (b :: b' :: bs) = cast r (b :: bs) := by
  refine filterMap_congr' r.seats ?_
  intro s _
  by_cases hb : (b.voter == s.holder) = true
  · simp [hb]
  · simp [hb, h]

/-- **Stuffing the box with a copy of itself decides nothing new.** -/
theorem stuffing_changes_nothing (r : Roll) (bs : List Ballot) :
    cast r (bs ++ bs) = cast r bs := by
  refine filterMap_congr' r.seats ?_
  intro s _
  cases h : bs.find? (fun b => b.voter == s.holder) with
  | none => simp [List.find?_append, h]
  | some b => simp [List.find?_append, h]

/-! ### The chamber can act -/

/-- The roll on which every member votes aye. -/
def unanimous (r : Roll) : List Ballot := r.seats.map (fun s => ⟨s.holder, Vote.aye⟩)

private theorem find?_unanimous (l : List Seat) (a : String)
    (ha : a ∈ l.map (fun s => s.holder)) :
    ∃ b, (l.map (fun s => (⟨s.holder, Vote.aye⟩ : Ballot))).find? (fun x => x.voter == a)
        = some b ∧ b.choice = Vote.aye := by
  induction l with
  | nil => simp at ha
  | cons u t ih =>
      by_cases hu : (u.holder == a) = true
      · exact ⟨⟨u.holder, Vote.aye⟩, by simp [hu], rfl⟩
      · have hmem : a ∈ t.map (fun s => s.holder) := by
          simp only [List.map_cons, List.mem_cons] at ha
          rcases ha with h | h
          · exact absurd (by simp [h]) hu
          · exact h
        obtain ⟨b, hb, hb2⟩ := ih hmem
        exact ⟨b, by simp [hu, hb], hb2⟩

theorem cast_unanimous (r : Roll) :
    cast r (unanimous r) = r.seats.map (fun s => (s, Vote.aye)) := by
  refine filterMap_eq_map_of_forall _ _ r.seats ?_
  intro s hs
  obtain ⟨b, hb, hb2⟩ := find?_unanimous r.seats s.holder (List.mem_map_of_mem hs)
  simp [unanimous, hb, hb2]

theorem present_unanimous (r : Roll) : present r (unanimous r) = r.size := by
  simp [present, cast_unanimous, Roll.size]

theorem ayes_unanimous (r : Roll) : ayes r (unanimous r) = r.size := by
  simp only [ayes, count, cast_unanimous, Roll.size]
  induction r.seats with
  | nil => rfl
  | cons s t ih => simpa [List.filter_cons] using ih

theorem nays_unanimous (r : Roll) : nays r (unanimous r) = 0 := by
  simp only [nays, count, cast_unanimous]
  induction r.seats with
  | nil => rfl
  | cons s t ih => simp [ih]

/-- **A quorum is attainable.**  This is exactly what the dataset's rule
denies: there, quorum is a majority of a nominal chamber that was never
filled, and no possible vote reaches it. -/
theorem quorum_attainable (r : Roll) (h : 0 < r.size) : hasQuorum r (unanimous r) = true := by
  simp only [hasQuorum, present_unanimous, quorumOf, decide_eq_true_eq]
  omega

/-- **The chamber can act at every threshold.** -/
theorem unanimous_carries (r : Roll) (t : Threshold) (h : 0 < r.size) :
    carries r t (unanimous r) = true := by
  have hq : hasQuorum r (unanimous r) = true := quorum_attainable r h
  cases t <;>
    simp [carries, hq, ayes_unanimous, nays_unanimous] <;> omega

/-- **The supermajority threshold is strictly harder than the simple one.** -/
theorem two_thirds_implies_simple (r : Roll) (bs : List Ballot) (h : 0 < r.size)
    (ht : carries r Threshold.twoThirds bs = true) : carries r Threshold.simple bs = true := by
  simp only [carries, Bool.and_eq_true, decide_eq_true_eq] at ht ⊢
  obtain ⟨hq, hs⟩ := ht
  have hb := ayes_add_nays_le_size r bs
  exact ⟨hq, by omega⟩

theorem three_quarters_implies_two_thirds (r : Roll) (bs : List Ballot)
    (ht : carries r Threshold.threeQuarters bs = true) :
    carries r Threshold.twoThirds bs = true := by
  simp only [carries, Bool.and_eq_true, decide_eq_true_eq] at ht ⊢
  obtain ⟨hq, hs⟩ := ht
  exact ⟨hq, by omega⟩

/-! ### Proxies -/

/-- The ballots a set of proxies adds: for each proxy whose grantor did not
vote in person, a ballot in the grantor's name carrying the agent's choice. -/
def proxyBallots (ps : List Proxy) (bs : List Ballot) : List Ballot :=
  ps.filterMap fun p =>
    if bs.any (fun b => b.voter == p.grantor) then none
    else (bs.find? (fun b => b.voter == p.agent)).map (fun b => ⟨p.grantor, b.choice⟩)

/-- The box as the chamber reads it once proxies are exercised. -/
def withProxies (ps : List Proxy) (bs : List Ballot) : List Ballot := bs ++ proxyBallots ps bs

/-- **A proxy never overrides its grantor's own ballot.** -/
theorem proxy_never_overrides (ps : List Proxy) (bs : List Ballot) (b : Ballot)
    (hb : b ∈ bs) : ∀ q ∈ proxyBallots ps bs, q.voter ≠ b.voter := by
  intro q hq hqv
  simp only [proxyBallots, List.mem_filterMap] at hq
  obtain ⟨p, _, hp⟩ := hq
  by_cases hany : bs.any (fun x => x.voter == p.grantor) = true
  · simp [hany] at hp
  · simp only [hany, if_false, Bool.false_eq_true] at hp
    cases hf : bs.find? (fun x => x.voter == p.agent) with
    | none => simp [hf] at hp
    | some a =>
        simp only [hf, Option.map_some] at hp
        have hq' := Option.some.inj hp
        have hqg : q.voter = p.grantor := by rw [← hq']
        rw [hqg] at hqv
        exact hany (List.any_eq_true.mpr ⟨b, hb, by simp [hqv]⟩)

/-- **A self-proxy adds nothing.** -/
theorem self_proxy_adds_nothing (p : Proxy) (bs : List Ballot) (h : p.agent = p.grantor) :
    proxyBallots [p] bs = [] := by
  simp only [proxyBallots, List.filterMap_cons, List.filterMap_nil]
  by_cases hany : bs.any (fun x => x.voter == p.grantor) = true
  · simp [hany]
  · have hnone : bs.find? (fun x => x.voter == p.agent) = none := by
      rw [h]
      cases hf : bs.find? (fun x => x.voter == p.grantor) with
      | none => rfl
      | some a =>
          exact absurd (List.any_eq_true.mpr
            ⟨a, List.mem_of_find?_eq_some hf, by simpa using List.find?_some hf⟩) hany
    simp [hany, hnone]

/-- **A proxy held by a member who did not vote adds nothing.** -/
theorem silent_agent_adds_nothing (p : Proxy) (bs : List Ballot)
    (h : bs.find? (fun x => x.voter == p.agent) = none) : proxyBallots [p] bs = [] := by
  simp only [proxyBallots, List.filterMap_cons, List.filterMap_nil]
  by_cases hany : bs.any (fun x => x.voter == p.grantor) = true <;> simp [hany, h]

/-- **Proxies can only add members to the count, never remove one.** -/
theorem proxy_present_monotone (r : Roll) (ps : List Proxy) (bs : List Ballot) :
    present r bs ≤ present r (withProxies ps bs) := by
  simp only [present, cast, withProxies]
  refine length_filterMap_mono _ _ r.seats ?_
  intro s _ hx
  cases hf : bs.find? (fun b => b.voter == s.holder) with
  | none => simp [hf] at hx
  | some b => simp [List.find?_append, hf]

/-! ### Rotation -/

/-- The seats that stay when class `k` turns over. -/
def retained (r : Roll) (k : Nat) : List Seat := r.seats.filter (fun s => s.klass != k)

/-- The seats that turn over. -/
def turningOver (r : Roll) (k : Nat) : List Seat := r.seats.filter (fun s => s.klass == k)

/-- One class turns over; the rest of the chamber is untouched. -/
def rotate (r : Roll) (k : Nat) (fresh : List Seat) : Roll := ⟨retained r k ++ fresh⟩

theorem retained_add_turningOver (r : Roll) (k : Nat) :
    (retained r k).length + (turningOver r k).length = r.size := by
  simp only [retained, turningOver, Roll.size]
  induction r.seats with
  | nil => rfl
  | cons s t ih =>
      by_cases h : s.klass = k
      · simp [h]; omega
      · simp [h]; omega

/-- **A rotation keeps the chamber the same size** when the class that turns
over is replaced seat for seat. -/
theorem rotate_size (r : Roll) (k : Nat) (fresh : List Seat)
    (h : fresh.length = (turningOver r k).length) : (rotate r k fresh).size = r.size := by
  have hr := retained_add_turningOver r k
  show ((retained r k) ++ fresh).length = r.size
  rw [List.length_append, h]
  omega

/-- **Only the class that turns over turns over.** -/
theorem rotate_retains_other_classes (r : Roll) (k : Nat) (fresh : List Seat) (s : Seat)
    (hs : s ∈ r.seats) (hk : s.klass ≠ k) : s ∈ (rotate r k fresh).seats := by
  simp only [rotate, retained, List.mem_append, List.mem_filter]
  exact Or.inl ⟨hs, by simpa using hk⟩

/-- **The chamber is never re-elected wholesale**: whatever is put in the
turning-over class, the seats of every other class are still there. -/
theorem rotate_continuity (r : Roll) (k : Nat) (fresh : List Seat) :
    (retained r k).length ≤ (rotate r k fresh).size := by
  simp [rotate, Roll.size]

end Chamber
