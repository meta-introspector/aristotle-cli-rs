import Mathlib.Tactic

/-
  Behaviour.lean — a generic model of *recorded on-chain behaviour*.

  The dataset `introspector/solfunmeme` ships, under `tx/XX/`, cached JSON-RPC
  `getTransaction` responses for signatures that reference the SOLFUNMEME mint
  `BwUTq7fS6sfUmHDwAiCQZ3asSiPEapW5zDrsbwtapump`.  From each such response one can
  read off, for the transaction's fee payer, everything this file talks about:
  whether the transaction settled, what it cost in lamports, whether the governed
  token moved at all, and what the payer's own holding of it was before and after.

  This module is the *generic* layer.  It fixes the shape of such a record, defines
  the behavioural statistics, the four norms against which behaviour is judged, and
  the notion of a *theory of a wallet*; and it proves the facts that hold of every
  record whatsoever.  The transactions extracted from the dataset live in
  `Ledger.Data.*`, the wallet-by-wallet verdicts in `Ledger.Verdicts`, and the
  sample-wide totals in `Ledger.SampleFacts`.

  Nothing here is a moral primitive: `Norm`, `Verdict.bad` and the rest are
  *definitions this analysis states*, and the theorems only say who satisfies them.
-/

namespace Ledger

/-! ## The record -/

/-- One recorded transaction, from the point of view of its fee payer.

* `slot` — the Solana slot it landed in (its identifier inside this analysis;
  `data/analysed_wallets.csv` maps it back to the transaction signature);
* `fee`  — lamports paid, charged whether or not the transaction settled;
* `ok`   — `true` iff `meta.err = null`, i.e. the transaction settled;
* `slip` — `true` iff it failed with the AMM slippage error (`Custom 6001`);
* `pre`  — the payer's SOLFUNMEME balance before, in base units (`0` if it held
  no such account in this transaction);
* `post` — the payer's SOLFUNMEME balance after, in base units;
* `live` — `true` iff *somebody's* SOLFUNMEME balance changed in this transaction. -/
structure Tx where
  slot : Nat
  fee  : Nat
  ok   : Bool
  slip : Bool
  pre  : Nat
  post : Nat
  live : Bool
deriving DecidableEq, Repr

namespace Tx

/-- The change in the payer's holding of the governed token. -/
def delta (t : Tx) : Int := (t.post : Int) - (t.pre : Int)

/-- The transaction changed the payer's holding of the governed token. -/
def moves (t : Tx) : Bool := t.pre != t.post

/-- The payer acquired the governed token. -/
def buys (t : Tx) : Bool := t.pre < t.post

/-- The payer parted with the governed token. -/
def sells (t : Tx) : Bool := t.post < t.pre

/-- The payer's holding went from something positive to nothing: an exit. -/
def exits (t : Tx) : Bool := 0 < t.pre && t.post == 0

theorem delta_pos_iff (t : Tx) : 0 < t.delta ↔ t.buys = true := by
  simp only [delta, buys, sub_pos, Int.ofNat_lt, decide_eq_true_eq]

theorem delta_neg_iff (t : Tx) : t.delta < 0 ↔ t.sells = true := by
  simp only [delta, sells, sub_neg, Int.ofNat_lt, decide_eq_true_eq]

theorem delta_zero_iff (t : Tx) : t.delta = 0 ↔ t.moves = false := by
  simp only [delta, moves, sub_eq_zero, Nat.cast_inj, bne_eq_false_iff_eq]
  exact ⟨fun h => h.symm, fun h => h.symm⟩

theorem exits_sells {t : Tx} (h : t.exits = true) : t.sells = true := by
  simp only [exits, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  simp only [sells, decide_eq_true_eq]
  omega

end Tx

/-! ## List-level lemmas

    Every statistic below is a fold over a list of transactions; these are the
    facts about those folds, for an arbitrary list. -/

theorem length_ok_add_length_fail (l : List Tx) :
    (l.filter (fun t => t.ok)).length + (l.filter (fun t => !t.ok)).length = l.length := by
  induction l with
  | nil => rfl
  | cons t ts ih => cases h : t.ok <;> simp [h] <;> omega

theorem sum_fee_fail_le (l : List Tx) :
    (((l.filter (fun t => !t.ok)).map (fun t => t.fee)).sum) ≤ ((l.map (fun t => t.fee)).sum) := by
  induction l with
  | nil => simp
  | cons t ts ih => cases h : t.ok <;> simp [h] <;> omega

theorem sum_fee_fail_eq (l : List Tx) (h : ∀ t ∈ l, t.ok = false) :
    (((l.filter (fun t => !t.ok)).map (fun t => t.fee)).sum) = ((l.map (fun t => t.fee)).sum) := by
  induction l with
  | nil => simp
  | cons t ts ih =>
      have ht : t.ok = false := h t (by simp)
      have hts : ∀ s ∈ ts, s.ok = false := fun s hs => h s (by simp [hs])
      simp [ht, ih hts]

theorem length_moves_eq (l : List Tx) :
    (l.filter (fun t => t.moves)).length
      = (l.filter (fun t => t.buys)).length + (l.filter (fun t => t.sells)).length := by
  induction l with
  | nil => rfl
  | cons t ts ih =>
      rcases Nat.lt_trichotomy t.pre t.post with h | h | h
      · have h1 : t.moves = true := by simp only [Tx.moves, bne_iff_ne, ne_eq]; omega
        have h2 : t.buys = true := by simp only [Tx.buys, decide_eq_true_eq]; omega
        have h3 : t.sells = false := by simp only [Tx.sells, decide_eq_false_iff_not]; omega
        simp [h1, h2, h3]; omega
      · have h1 : t.moves = false := by simp only [Tx.moves, bne_eq_false_iff_eq]; omega
        have h2 : t.buys = false := by simp only [Tx.buys, decide_eq_false_iff_not]; omega
        have h3 : t.sells = false := by simp only [Tx.sells, decide_eq_false_iff_not]; omega
        simp [h1, h2, h3]; omega
      · have h1 : t.moves = true := by simp only [Tx.moves, bne_iff_ne, ne_eq]; omega
        have h2 : t.buys = false := by simp only [Tx.buys, decide_eq_false_iff_not]; omega
        have h3 : t.sells = true := by simp only [Tx.sells, decide_eq_true_eq]; omega
        simp [h1, h2, h3]; omega

theorem length_exits_le (l : List Tx) :
    (l.filter (fun t => t.exits)).length ≤ (l.filter (fun t => t.sells)).length := by
  induction l with
  | nil => simp
  | cons t ts ih =>
      by_cases he : t.exits = true
      · have hs := Tx.exits_sells he
        simp [he, hs]; omega
      · simp only [Bool.not_eq_true] at he
        by_cases hs : t.sells = true <;> (simp [he, hs]; omega)

theorem sum_delta_eq_zero (l : List Tx) (h : ∀ t ∈ l, t.delta = 0) :
    ((l.map (fun t => t.delta)).sum) = 0 := by
  induction l with
  | nil => simp
  | cons t ts ih =>
      have ht := h t (by simp)
      have hts : ∀ s ∈ ts, s.delta = 0 := fun s hs => h s (by simp [hs])
      simp [ht, ih hts]

theorem sum_delta_nonneg (l : List Tx) (h : ∀ t ∈ l, 0 ≤ t.delta) :
    0 ≤ ((l.map (fun t => t.delta)).sum) := by
  induction l with
  | nil => simp
  | cons t ts ih =>
      have ht := h t (by simp)
      have hts : ∀ s ∈ ts, 0 ≤ s.delta := fun s hs => h s (by simp [hs])
      have := ih hts
      simp only [List.map_cons, List.sum_cons]
      omega

theorem sum_delta_nonpos (l : List Tx) (h : ∀ t ∈ l, t.delta ≤ 0) :
    ((l.map (fun t => t.delta)).sum) ≤ 0 := by
  induction l with
  | nil => simp
  | cons t ts ih =>
      have ht := h t (by simp)
      have hts : ∀ s ∈ ts, s.delta ≤ 0 := fun s hs => h s (by simp [hs])
      have := ih hts
      simp only [List.map_cons, List.sum_cons]
      omega

/-! ## The statistics of a record

    A *record* is the list of transactions recorded for one wallet (or, in
    `Ledger.SampleFacts`, a chunk of the whole sample). -/

/-- Number of recorded transactions. -/
def nTx (l : List Tx) : Nat := l.length
/-- Number that settled. -/
def nOk (l : List Tx) : Nat := (l.filter (fun t => t.ok)).length
/-- Number that failed. -/
def nFail (l : List Tx) : Nat := (l.filter (fun t => !t.ok)).length
/-- Number that failed with the AMM slippage error. -/
def nSlip (l : List Tx) : Nat := (l.filter (fun t => t.slip)).length
/-- Number in which the token moved for somebody. -/
def nLive (l : List Tx) : Nat := (l.filter (fun t => t.live)).length
/-- Number that changed the payer's own holding. -/
def nMoves (l : List Tx) : Nat := (l.filter (fun t => t.moves)).length
/-- Number of acquisitions. -/
def nBuys (l : List Tx) : Nat := (l.filter (fun t => t.buys)).length
/-- Number of disposals. -/
def nSells (l : List Tx) : Nat := (l.filter (fun t => t.sells)).length
/-- Number of full exits. -/
def nExits (l : List Tx) : Nat := (l.filter (fun t => t.exits)).length
/-- Total lamports paid. -/
def fees (l : List Tx) : Nat := (l.map (fun t => t.fee)).sum
/-- Lamports paid on transactions that did not settle: pure deadweight. -/
def burnt (l : List Tx) : Nat := ((l.filter (fun t => !t.ok)).map (fun t => t.fee)).sum
/-- Net change in the wallet's holding of the governed token across the record. -/
def net (l : List Tx) : Int := (l.map (fun t => t.delta)).sum

/-! ### Arithmetic of the statistics -/

theorem nOk_add_nFail (l : List Tx) : nOk l + nFail l = nTx l := length_ok_add_length_fail l

theorem nFail_le_nTx (l : List Tx) : nFail l ≤ nTx l := by have := nOk_add_nFail l; omega
theorem nOk_le_nTx (l : List Tx) : nOk l ≤ nTx l := by have := nOk_add_nFail l; omega
theorem burnt_le_fees (l : List Tx) : burnt l ≤ fees l := sum_fee_fail_le l
theorem nMoves_eq (l : List Tx) : nMoves l = nBuys l + nSells l := length_moves_eq l
theorem nExits_le_nSells (l : List Tx) : nExits l ≤ nSells l := length_exits_le l

/-! ### Additivity: a record can be analysed in pieces -/

@[simp] theorem nTx_append (a b : List Tx) : nTx (a ++ b) = nTx a + nTx b := by
  simp [nTx]
@[simp] theorem nOk_append (a b : List Tx) : nOk (a ++ b) = nOk a + nOk b := by
  simp [nOk, List.filter_append]
@[simp] theorem nFail_append (a b : List Tx) : nFail (a ++ b) = nFail a + nFail b := by
  simp [nFail, List.filter_append]
@[simp] theorem nSlip_append (a b : List Tx) : nSlip (a ++ b) = nSlip a + nSlip b := by
  simp [nSlip, List.filter_append]
@[simp] theorem nLive_append (a b : List Tx) : nLive (a ++ b) = nLive a + nLive b := by
  simp [nLive, List.filter_append]
@[simp] theorem nMoves_append (a b : List Tx) : nMoves (a ++ b) = nMoves a + nMoves b := by
  simp [nMoves, List.filter_append]
@[simp] theorem nBuys_append (a b : List Tx) : nBuys (a ++ b) = nBuys a + nBuys b := by
  simp [nBuys, List.filter_append]
@[simp] theorem nSells_append (a b : List Tx) : nSells (a ++ b) = nSells a + nSells b := by
  simp [nSells, List.filter_append]
@[simp] theorem nExits_append (a b : List Tx) : nExits (a ++ b) = nExits a + nExits b := by
  simp [nExits, List.filter_append]
@[simp] theorem fees_append (a b : List Tx) : fees (a ++ b) = fees a + fees b := by
  simp [fees]
@[simp] theorem burnt_append (a b : List Tx) : burnt (a ++ b) = burnt a + burnt b := by
  simp [burnt, List.filter_append]
@[simp] theorem net_append (a b : List Tx) : net (a ++ b) = net a + net b := by
  simp [net]

/-! ## Behavioural predicates -/

/-- Nothing the wallet submitted ever settled. -/
def NeverSettles (l : List Tx) : Prop := ∀ t ∈ l, t.ok = false
/-- Everything the wallet submitted settled. -/
def AlwaysSettles (l : List Tx) : Prop := ∀ t ∈ l, t.ok = true
/-- The wallet's holding of the governed token never changes. -/
def Inert (l : List Tx) : Prop := ∀ t ∈ l, t.moves = false
/-- The token never moves for anybody in anything the wallet submits: the wallet is
    indexed under a token it has no dealings with. -/
def Bystander (l : List Tx) : Prop := ∀ t ∈ l, t.live = false
/-- The wallet only ever acquires. -/
def OnlyAcquires (l : List Tx) : Prop := ∀ t ∈ l, t.sells = false
/-- The wallet only ever disposes. -/
def OnlyDisposes (l : List Tx) : Prop := ∀ t ∈ l, t.buys = false
/-- The wallet trades in both directions. -/
def TwoWay (l : List Tx) : Prop := (∃ t ∈ l, t.buys = true) ∧ (∃ t ∈ l, t.sells = true)
/-- The wallet took its holding to zero at least once. -/
def Exits (l : List Tx) : Prop := ∃ t ∈ l, t.exits = true

instance (l : List Tx) : Decidable (NeverSettles l) := by unfold NeverSettles; infer_instance
instance (l : List Tx) : Decidable (AlwaysSettles l) := by unfold AlwaysSettles; infer_instance
instance (l : List Tx) : Decidable (Inert l) := by unfold Inert; infer_instance
instance (l : List Tx) : Decidable (Bystander l) := by unfold Bystander; infer_instance
instance (l : List Tx) : Decidable (OnlyAcquires l) := by unfold OnlyAcquires; infer_instance
instance (l : List Tx) : Decidable (OnlyDisposes l) := by unfold OnlyDisposes; infer_instance
instance (l : List Tx) : Decidable (TwoWay l) := by unfold TwoWay; infer_instance
instance (l : List Tx) : Decidable (Exits l) := by unfold Exits; infer_instance

theorem neverSettles_iff (l : List Tx) : NeverSettles l ↔ nOk l = 0 := by
  unfold NeverSettles nOk
  constructor
  · intro h
    have hnil : l.filter (fun t => t.ok) = [] := by
      apply List.filter_eq_nil_iff.2; intro t ht; simp [h t ht]
    simp [hnil]
  · intro h t ht
    by_contra hc
    have htrue : t.ok = true := by
      cases hb : t.ok
      · exact absurd hb hc
      · rfl
    have hmem : t ∈ l.filter (fun t => t.ok) := by
      simp only [List.mem_filter]; exact ⟨ht, by simp [htrue]⟩
    have := List.length_pos_of_mem hmem
    omega

theorem alwaysSettles_iff (l : List Tx) : AlwaysSettles l ↔ nFail l = 0 := by
  unfold AlwaysSettles nFail
  constructor
  · intro h
    have hnil : l.filter (fun t => !t.ok) = [] := by
      apply List.filter_eq_nil_iff.2; intro t ht; simp [h t ht]
    simp [hnil]
  · intro h t ht
    by_contra hc
    have hmem : t ∈ l.filter (fun t => !t.ok) := by
      simp only [List.mem_filter]; exact ⟨ht, by simpa using hc⟩
    have := List.length_pos_of_mem hmem
    omega

theorem inert_iff (l : List Tx) : Inert l ↔ nMoves l = 0 := by
  unfold Inert nMoves
  constructor
  · intro h
    have hnil : l.filter (fun t => t.moves) = [] := by
      apply List.filter_eq_nil_iff.2; intro t ht; simp [h t ht]
    simp [hnil]
  · intro h t ht
    by_contra hc
    have htrue : t.moves = true := by
      cases hb : t.moves
      · exact absurd hb hc
      · rfl
    have hmem : t ∈ l.filter (fun t => t.moves) := by
      simp only [List.mem_filter]; exact ⟨ht, by simp [htrue]⟩
    have := List.length_pos_of_mem hmem
    omega

/-- A wallet that never settles burns every lamport it spends for nothing. -/
theorem burnt_eq_fees_of_neverSettles {l : List Tx} (h : NeverSettles l) : burnt l = fees l :=
  sum_fee_fail_eq l h

/-- A failing transaction cannot move tokens: the chain rolls it back.  This is a
    well-formedness condition on a record, checked for the concrete data. -/
def FailuresAreInert (l : List Tx) : Prop := ∀ t ∈ l, t.ok = false → (t.moves = false ∧ t.live = false)

/-- A wallet that never settles ends where it began. -/
theorem net_eq_zero_of_neverSettles {l : List Tx}
    (hL : FailuresAreInert l) (h : NeverSettles l) : net l = 0 :=
  sum_delta_eq_zero l (fun t ht => (Tx.delta_zero_iff t).2 (hL t ht (h t ht)).1)

/-- …and never touches the token at all. -/
theorem bystander_of_neverSettles {l : List Tx}
    (hL : FailuresAreInert l) (h : NeverSettles l) : Bystander l :=
  fun t ht => (hL t ht (h t ht)).2

theorem inert_of_neverSettles {l : List Tx}
    (hL : FailuresAreInert l) (h : NeverSettles l) : Inert l :=
  fun t ht => (hL t ht (h t ht)).1

/-- An inert wallet's position never changes. -/
theorem net_eq_zero_of_inert {l : List Tx} (h : Inert l) : net l = 0 :=
  sum_delta_eq_zero l (fun t ht => (Tx.delta_zero_iff t).2 (h t ht))

/-- A wallet that only acquires cannot end below where it began. -/
theorem net_nonneg_of_onlyAcquires {l : List Tx} (h : OnlyAcquires l) : 0 ≤ net l := by
  refine sum_delta_nonneg l (fun t ht => ?_)
  have h1 : ¬ (t.post < t.pre) := by have := h t ht; simpa [Tx.sells] using this
  simp only [Tx.delta, sub_nonneg, Int.ofNat_le]
  omega

/-- A wallet that only disposes cannot end above where it began. -/
theorem net_nonpos_of_onlyDisposes {l : List Tx} (h : OnlyDisposes l) : net l ≤ 0 := by
  refine sum_delta_nonpos l (fun t ht => ?_)
  have h1 : ¬ (t.pre < t.post) := by have := h t ht; simpa [Tx.buys] using this
  simp only [Tx.delta, sub_nonpos, Int.ofNat_le]
  omega

/-! ## The four norms

    These are the standards *this analysis* adopts.  They are motivated by what the
    dataset says it is for: it ranks wallets by their holding of one token, it counts
    "unique actors" and "active wallets" from the signatures that reference that
    token's mint, and its governance credentials are minted from a balance snapshot.

    * `settlement`   — at least half of what the wallet submits settles.  A failed
      transaction still consumes block space and still pays a fee, so a wallet that
      mostly fails is externalising cost.
    * `relevance`    — the wallet's own holding of the governed token changes at
      least once.  A wallet whose holding never changes is nevertheless counted as
      an "actor" of that token.
    * `custody`      — the wallet never takes its holding to zero.  Governance rank
      is read off a balance snapshot, so an exited wallet can still carry rank.
    * `reciprocity`  — if the wallet ever disposed of the token, it also acquired it
      at some recorded point: it is a participant rather than a one-way sink. -/

inductive Norm
  | settlement | relevance | custody | reciprocity
deriving DecidableEq, Repr

/-- Does the record meet the given norm? -/
def meets (n : Norm) (l : List Tx) : Prop :=
  match n with
  | .settlement  => nFail l * 2 ≤ nTx l
  | .relevance   => 0 < nMoves l
  | .custody     => nExits l = 0
  | .reciprocity => 0 < nSells l → 0 < nBuys l

instance (n : Norm) (l : List Tx) : Decidable (meets n l) := by
  cases n <;> (unfold meets; infer_instance)

/-- A verdict: `good` meets every norm; `bad` fails one of the two norms whose
    violation imposes a cost on everybody else (settlement, relevance); `mixed` is a
    participant that nonetheless breaks one of the other two. -/
inductive Verdict
  | good | mixed | bad
deriving DecidableEq, Repr

def verdict (l : List Tx) : Verdict :=
  if ¬ meets .settlement l ∨ ¬ meets .relevance l then .bad
  else if meets .custody l ∧ meets .reciprocity l then .good
  else .mixed

theorem verdict_good_iff (l : List Tx) : verdict l = .good ↔ (∀ n, meets n l) := by
  unfold verdict
  constructor
  · intro h n
    by_cases h1 : ¬ meets .settlement l ∨ ¬ meets .relevance l
    · rw [if_pos h1] at h; exact absurd h (by simp)
    · rw [if_neg h1] at h
      by_cases h2 : meets .custody l ∧ meets .reciprocity l
      · push_neg at h1
        cases n
        · exact h1.1
        · exact h1.2
        · exact h2.1
        · exact h2.2
      · rw [if_neg h2] at h; exact absurd h (by simp)
  · intro h
    rw [if_neg (by push_neg; exact ⟨h .settlement, h .relevance⟩),
       if_pos ⟨h .custody, h .reciprocity⟩]

theorem verdict_bad_iff (l : List Tx) :
    verdict l = .bad ↔ (¬ meets .settlement l ∨ ¬ meets .relevance l) := by
  unfold verdict
  constructor
  · intro h
    by_contra hc
    rw [if_neg hc] at h
    split at h <;> exact absurd h (by simp)
  · intro h; rw [if_pos h]

/-- A wallet that never settles anything, and did submit something, is bad. -/
theorem verdict_bad_of_neverSettles {l : List Tx} (hpos : 0 < nTx l) (h : NeverSettles l) :
    verdict l = .bad := by
  refine (verdict_bad_iff l).2 (Or.inl ?_)
  have h0 : nOk l = 0 := (neverSettles_iff l).1 h
  have hsum := nOk_add_nFail l
  simp only [meets]
  omega

/-- A wallet whose holding never changes is bad, however well behaved otherwise. -/
theorem verdict_bad_of_inert {l : List Tx} (h : Inert l) : verdict l = .bad := by
  refine (verdict_bad_iff l).2 (Or.inr ?_)
  have := (inert_iff l).1 h
  simp only [meets]
  omega

/-- Being a bystander to the token is worse than being merely inert: it is inert. -/
theorem inert_of_bystander {l : List Tx} (hwf : ∀ t ∈ l, t.live = false → t.moves = false)
    (h : Bystander l) : Inert l := fun t ht => hwf t ht (h t ht)

/-! ## Theories

    A *theory of a wallet* is a decidable predicate on single transactions that the
    analysis proposes as that wallet's signature.  It is **sound** if every recorded
    transaction of the wallet satisfies it, **corroborated** to depth `k` if it does
    so on at least `k` of them, and **discriminating** against another wallet if
    that wallet has a recorded transaction violating it. -/

/-- The theory holds of everything in the record. -/
def Sound (P : Tx → Bool) (l : List Tx) : Prop := ∀ t ∈ l, P t = true

/-- …on at least `k` recorded transactions. -/
def Corroborated (P : Tx → Bool) (l : List Tx) (k : Nat) : Prop := k ≤ (l.filter P).length

/-- …and it is false of something in the other record. -/
def Discriminates (P : Tx → Bool) (l : List Tx) : Prop := ∃ t ∈ l, P t = false

instance (P : Tx → Bool) (l : List Tx) : Decidable (Sound P l) := by
  unfold Sound; infer_instance
instance (P : Tx → Bool) (l : List Tx) (k : Nat) : Decidable (Corroborated P l k) := by
  unfold Corroborated; infer_instance
instance (P : Tx → Bool) (l : List Tx) : Decidable (Discriminates P l) := by
  unfold Discriminates; infer_instance

/-- A sound theory is corroborated by every transaction of the record. -/
theorem corroborated_of_sound {P : Tx → Bool} {l : List Tx} (h : Sound P l) :
    Corroborated P l (nTx l) := by
  unfold Corroborated nTx
  have hfil : l.filter P = l := List.filter_eq_self.2 (fun t ht => h t ht)
  simp [hfil]

/-- Sound here, discriminating there: the two records are different lists, and in
    particular the theory is not a triviality that everything satisfies. -/
theorem ne_of_discriminates {P : Tx → Bool} {l m : List Tx}
    (hs : Sound P l) (hd : Discriminates P m) : l ≠ m := by
  rintro rfl
  obtain ⟨t, ht, hPt⟩ := hd
  have := hs t ht
  simp [this] at hPt

/-- A discriminating theory is refuted by the other record, which therefore is not
    empty. -/
theorem nTx_pos_of_discriminates {P : Tx → Bool} {m : List Tx} (hd : Discriminates P m) :
    0 < nTx m := by
  obtain ⟨t, ht, _⟩ := hd
  exact List.length_pos_of_mem ht

/-- Soundness is inherited by any sub-record. -/
theorem sound_mono {P : Tx → Bool} {l l' : List Tx} (hsub : ∀ t ∈ l', t ∈ l) (h : Sound P l) :
    Sound P l' := fun t ht => h t (hsub t ht)

@[simp] theorem sound_append {P : Tx → Bool} {a b : List Tx} :
    Sound P (a ++ b) ↔ Sound P a ∧ Sound P b := by
  unfold Sound
  constructor
  · intro h; exact ⟨fun t ht => h t (by simp [ht]), fun t ht => h t (by simp [ht])⟩
  · rintro ⟨h1, h2⟩ t ht
    rcases List.mem_append.1 ht with h | h
    · exact h1 t h
    · exact h2 t h

/-! ## Summaries

    The analysis of a single wallet uses its whole transaction record.  To speak
    about *every* fee payer at once — there are 1 154 of them in the sample — it is
    enough to keep, for each of them, the six counts that the norms depend on.  A
    `Summary` is that record, `summaryOf` computes it, and `verdictS` re-runs the
    verdict on it; `verdictS_summaryOf` says that nothing is lost by doing so. -/

/-- The six counts a verdict depends on. -/
structure Summary where
  nTx : Nat
  nOk : Nat
  nMoves : Nat
  nBuys : Nat
  nSells : Nat
  nExits : Nat
deriving DecidableEq, Repr

/-- The summary of a transaction record. -/
def summaryOf (l : List Tx) : Summary := ⟨nTx l, nOk l, nMoves l, nBuys l, nSells l, nExits l⟩

/-- The norms, read off a summary. -/
def meetsS (n : Norm) (s : Summary) : Prop :=
  match n with
  | .settlement  => (s.nTx - s.nOk) * 2 ≤ s.nTx
  | .relevance   => 0 < s.nMoves
  | .custody     => s.nExits = 0
  | .reciprocity => 0 < s.nSells → 0 < s.nBuys

instance (n : Norm) (s : Summary) : Decidable (meetsS n s) := by
  cases n <;> (unfold meetsS; infer_instance)

/-- The verdict, read off a summary. -/
def verdictS (s : Summary) : Verdict :=
  if ¬ meetsS .settlement s ∨ ¬ meetsS .relevance s then .bad
  else if meetsS .custody s ∧ meetsS .reciprocity s then .good
  else .mixed

theorem meetsS_summaryOf (n : Norm) (l : List Tx) : meetsS n (summaryOf l) ↔ meets n l := by
  cases n
  · have h := nOk_add_nFail l
    simp only [meetsS, meets, summaryOf]
    omega
  · simp [meetsS, meets, summaryOf]
  · simp [meetsS, meets, summaryOf]
  · simp [meetsS, meets, summaryOf]

/-- Judging a wallet by its six counts gives the same verdict as judging it by its
    whole transaction record. -/
theorem verdictS_summaryOf (l : List Tx) : verdictS (summaryOf l) = verdict l := by
  unfold verdictS verdict
  simp only [meetsS_summaryOf]

/-- How many of the summarised wallets get the verdict `v`. -/
def countVerdict (v : Verdict) (l : List Summary) : Nat :=
  (l.filter (fun s => decide (verdictS s = v))).length

theorem countVerdict_total (l : List Summary) :
    countVerdict .good l + countVerdict .mixed l + countVerdict .bad l = l.length := by
  induction l with
  | nil => rfl
  | cons s ss ih =>
      unfold countVerdict at *
      cases h : verdictS s <;> simp [h] <;> omega

end Ledger
