/-
# Challenge, slashing and audit: the schemes the report left open

`SENATE-REPORT-VAICU.md` records a senator's proposal for a verified compute
market, and `RequestProject/Market/Compute.lean` settles the two extremes it
names: settlement *by proof* (which cannot pay for a wrong result) and
settlement *by validator vote* (which can).  The report's scope note says
plainly what that leaves out:

> The vote result is a possibility result.  It does not show every incentive
> scheme fails, and it says nothing about schemes with challenges, slashing or
> sampling — those would need their own models.

This file is that model.  An **optimistic** market takes the operator's claim on
trust and pays out unless somebody refutes it inside a challenge window; the
refuted operator is slashed and the challenger is paid out of the bond.  Nothing
is verified up front, so the market looks like the vote market — and yet:

* with nobody watching, it pays for wrong results exactly as the vote market
  does (`optimistic_pays_for_wrong_result`);
* with a *single* diligent challenger, payment happens if and only if the claim
  meets the specification (`diligent_court_pays_iff_spec`) — the same guarantee
  as the proof market, moved from settlement time to the challenge window.

So challenges do recover the guarantee, but on an assumption the proof market
does not need: that at least one honest party is watching and can afford to act.
The last section makes the cost of dropping that assumption precise for
*sampling*: if the customer audits `k` of `n` jobs uniformly, the cheats that go
undetected are exactly the ones the sample misses, and the number of samples
that miss `m` cheating jobs is `(n - m).choose k` — strictly fewer than all
`n.choose k` samples as soon as one job is cheated and one job is audited.
-/
import Mathlib
import RequestProject.Solfunmeme.Market.Compute

namespace RequestProject.Market

/-! ## An optimistic market with a challenge window -/

/-- A court for an optimistic market: the specification the claim is supposed to
meet, and the on-chain check that decides whether a submitted refutation stands.
`refutes_sound` is the only thing assumed of the check — a refutation that the
court accepts really does exhibit a violated specification, so an honest
operator cannot be slashed. -/
structure Court (Input Output Refutation : Type*) where
  /-- What the customer asked for. -/
  spec : Input → Output → Prop
  /-- The check the court runs on a challenger's refutation. -/
  refutes : Input → Output → Refutation → Bool
  /-- A refutation the court accepts really does refute the claim. -/
  refutes_sound : ∀ x y r, refutes x y r = true → ¬ spec x y

variable {Input Output Refutation : Type*}

/-- A job on the optimistic market: no proof is submitted, only a claim. -/
structure Claim (Input Output : Type*) where
  /-- The input the customer supplied. -/
  input : Input
  /-- The escrowed price and the operator's bond. -/
  trade : Trade
  /-- The operator's claimed result, if it answered at all. -/
  claim : Option Output

/-- A challenger: given the input and the claim, it either stays silent or
produces a refutation for the court. -/
abbrev Challenger (Input Output Refutation : Type*) :=
  Input → Output → Option Refutation

/-- A challenger is **diligent** when it always finds a refutation the court
accepts, for every claim that violates the specification. -/
def Court.Diligent (C : Court Input Output Refutation)
    (ch : Challenger Input Output Refutation) : Prop :=
  ∀ x y, ¬ C.spec x y → ∃ r, ch x y = some r ∧ C.refutes x y r = true

/-- Whether a challenger's response, if any, is accepted by the court. -/
def Court.upheld (C : Court Input Output Refutation)
    (ch : Challenger Input Output Refutation) (x : Input) (y : Output) : Bool :=
  match ch x y with
  | none => false
  | some r => C.refutes x y r

/-- The claim was successfully challenged inside the window: some watcher
produced a refutation the court upholds. -/
def Court.challenged (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output) : Bool :=
  match j.claim with
  | none => false
  | some y => cs.any (fun ch => C.upheld ch j.input y)

/-- Settlement after the challenge window closes, as
`(paid to operator, returned to customer, paid to the challenger)`.

An unanswered job refunds the customer.  An answered job that nobody refutes
pays the operator its price and returns its bond.  A refuted claim slashes the
bond to the challenger and refunds the customer's price. -/
def Court.payout (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output) :
    Nat × Nat × Nat :=
  match j.claim with
  | none => (0, j.trade.price + j.trade.bond, 0)
  | some _ =>
      if C.challenged cs j then (0, j.trade.price, j.trade.bond)
      else (j.trade.price + j.trade.bond, 0, 0)

/-! ### The settlement rule is conservative -/

/-- Settlement neither creates nor destroys money: price and bond are always
distributed in full between operator, customer and challenger. -/
theorem optimistic_payout_conserves (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output) :
    (C.payout cs j).1 + (C.payout cs j).2.1 + (C.payout cs j).2.2 =
      j.trade.price + j.trade.bond := by
  unfold Court.payout
  cases j.claim with
  | none => simp
  | some y => by_cases h : C.challenged cs j <;> simp [h]

/-- A job nobody answered pays the operator nothing. -/
theorem optimistic_payout_of_no_claim (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output)
    (h : j.claim = none) :
    C.payout cs j = (0, j.trade.price + j.trade.bond, 0) := by
  simp [Court.payout, h]

/-- **Slashing.** A refuted claim costs the operator its whole bond, which goes
to the challenger, and returns the price to the customer. -/
theorem slashed_iff_challenged (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output)
    (y : Output) (hy : j.claim = some y) :
    (C.payout cs j).2.2 = j.trade.bond ↔
      (C.challenged cs j = true ∨ j.trade.bond = 0) := by
  by_cases h : C.challenged cs j
  · simp [Court.payout, hy, h]
  · simp [Court.payout, hy, h]
    tauto

/-! ### Nobody watching: the optimistic market is as weak as the vote market -/

/-- **With no challenger, the optimistic market pays for a wrong result.**  A
concrete court, claim and trade where the specification fails and the operator
still collects everything: taking a claim on trust is worth exactly as much as
trusting a committee. -/
theorem optimistic_pays_for_wrong_result :
    ∃ (C : Court Unit Bool Unit) (j : Claim Unit Bool) (y : Bool),
      j.claim = some y ∧ ¬ C.spec j.input y ∧ 0 < j.trade.price ∧
      (C.payout [] j).1 = j.trade.price + j.trade.bond := by
  refine ⟨⟨fun _ y => y = true, fun _ _ _ => false, by simp⟩,
    ⟨(), ⟨20, 5⟩, some false⟩, false, rfl, by simp, by norm_num, ?_⟩
  simp [Court.payout, Court.challenged]

/-- More generally: a silent watch is no watch.  If no challenger ever speaks,
every answered job pays out, correct or not. -/
theorem silent_watch_always_pays (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output)
    (y : Output) (hy : j.claim = some y)
    (hsilent : ∀ ch ∈ cs, ch j.input y = none) :
    (C.payout cs j).1 = j.trade.price + j.trade.bond := by
  have hch : C.challenged cs j = false := by
    unfold Court.challenged
    rw [hy]
    refine List.any_eq_false.2 ?_
    intro ch hch
    simp [Court.upheld, hsilent ch hch]
  simp [Court.payout, hy, hch]

/-! ### One diligent challenger restores the proof-market guarantee -/

/-- A claim meeting the specification is never successfully challenged: the
court only upholds sound refutations. -/
theorem unchallenged_of_spec (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output)
    (y : Output) (hy : j.claim = some y) (hspec : C.spec j.input y) :
    C.challenged cs j = false := by
  unfold Court.challenged
  rw [hy]
  refine List.any_eq_false.2 ?_
  intro ch _
  simp only [Court.upheld, Bool.not_eq_true]
  cases h : ch j.input y with
  | none => rfl
  | some r =>
      by_contra hr
      exact C.refutes_sound _ _ _ (by simpa using hr) hspec

/-- **The honest operator is still paid.**  Whoever is watching, a correct claim
collects the price and the bond. -/
theorem honest_claim_paid (C : Court Input Output Refutation)
    (cs : List (Challenger Input Output Refutation)) (j : Claim Input Output)
    (y : Output) (hy : j.claim = some y) (hspec : C.spec j.input y) :
    C.payout cs j = (j.trade.price + j.trade.bond, 0, 0) := by
  simp [Court.payout, hy, unchallenged_of_spec C cs j y hy hspec]

/-- **A wrong claim is refuted whenever one diligent challenger is watching.** -/
theorem challenged_of_not_spec (C : Court Input Output Refutation)
    {cs : List (Challenger Input Output Refutation)}
    {ch : Challenger Input Output Refutation} (hch : ch ∈ cs) (hdil : C.Diligent ch)
    (j : Claim Input Output) (y : Output) (hy : j.claim = some y)
    (hspec : ¬ C.spec j.input y) :
    C.challenged cs j = true := by
  obtain ⟨r, hr, hrefutes⟩ := hdil j.input y hspec
  unfold Court.challenged
  rw [hy]
  exact List.any_eq_true.2 ⟨ch, hch, by simp [Court.upheld, hr, hrefutes]⟩

/-- **Nobody is paid for a wrong result once one diligent challenger watches.**
This is the proof market's guarantee, recovered from the challenge window
instead of from settlement-time verification. -/
theorem diligent_paid_implies_spec (C : Court Input Output Refutation)
    {cs : List (Challenger Input Output Refutation)}
    {ch : Challenger Input Output Refutation} (hch : ch ∈ cs) (hdil : C.Diligent ch)
    (j : Claim Input Output) (hpos : 0 < (C.payout cs j).1) :
    ∃ y, j.claim = some y ∧ C.spec j.input y := by
  cases hy : j.claim with
  | none => rw [optimistic_payout_of_no_claim C cs j hy] at hpos; simp at hpos
  | some y =>
      refine ⟨y, rfl, ?_⟩
      by_contra hspec
      rw [Court.payout, hy] at hpos
      simp only [challenged_of_not_spec C hch hdil j y hy hspec, if_true] at hpos
      simp at hpos

/-- **The headline.**  With one diligent challenger and something at stake, the
optimistic market pays the operator exactly when the claim is present and meets
the specification — settlement by challenge is then indistinguishable from
settlement by proof. -/
theorem diligent_court_pays_iff_spec (C : Court Input Output Refutation)
    {cs : List (Challenger Input Output Refutation)}
    {ch : Challenger Input Output Refutation} (hch : ch ∈ cs) (hdil : C.Diligent ch)
    (j : Claim Input Output) (hstake : 0 < j.trade.price + j.trade.bond) :
    0 < (C.payout cs j).1 ↔ ∃ y, j.claim = some y ∧ C.spec j.input y := by
  refine ⟨diligent_paid_implies_spec C hch hdil j, ?_⟩
  rintro ⟨y, hy, hspec⟩
  rw [honest_claim_paid C cs j y hy hspec]
  exact hstake

/-- The same statement as a comparison with the proof market of
`Compute.lean`: for a task whose court accepts exactly the failures of the
task's specification, the two settlement rules agree on who is paid. -/
theorem challenge_agrees_with_proof_market
    {Proof : Type*} (T : Task Input Output Proof) (C : Court Input Output Refutation)
    (hspec : C.spec = T.spec)
    {cs : List (Challenger Input Output Refutation)}
    {ch : Challenger Input Output Refutation} (hch : ch ∈ cs) (hdil : C.Diligent ch)
    (x : Input) (t : Trade) (y : Output) (hstake : 0 < t.price + t.bond) :
    (0 < (C.payout cs ⟨x, t, some y⟩).1) ↔
      (∃ s : Submission Output Proof, s.output = y ∧ 0 < (T.payout ⟨x, t, some s⟩).1) := by
  rw [diligent_court_pays_iff_spec C hch hdil ⟨x, t, some y⟩ hstake]
  constructor
  · rintro ⟨y', hy', hs⟩
    have hyy : y' = y := by simpa using hy'.symm
    subst hyy
    obtain ⟨p, hp⟩ := T.verify_complete x y' (by rw [← hspec]; exact hs)
    exact ⟨⟨y', p⟩, rfl, by simp [Task.payout, Task.accepts, hp]; omega⟩
  · rintro ⟨s, hsy, hpos⟩
    obtain ⟨s', hs', hspec'⟩ := paid_implies_spec T ⟨x, t, some s⟩ hpos
    obtain rfl : s' = s := by simpa using hs'.symm
    exact ⟨y, rfl, by rw [hspec, ← hsy]; exact hspec'⟩

/-! ## Sampling: auditing part of a batch

The other scheme the report's note leaves open.  The customer re-checks a
subset of the jobs; cheating on an unaudited job is free, so what an audit buys
is measured by how many samples a cheat can hide from. -/

variable {n : ℕ}

/-- An audit of a batch of `n` jobs detects cheating exactly when the audited
set meets the cheating set. -/
def AuditDetects (cheats sample : Finset (Fin n)) : Prop := (sample ∩ cheats).Nonempty

/-- Cheating escapes an audit precisely when no cheated job was audited. -/
theorem undetected_iff_disjoint (cheats sample : Finset (Fin n)) :
    ¬ AuditDetects cheats sample ↔ Disjoint sample cheats := by
  rw [AuditDetects, Finset.not_nonempty_iff_eq_empty, Finset.disjoint_iff_inter_eq_empty]

/-- Auditing everything catches any cheat at all. -/
theorem full_audit_detects (cheats : Finset (Fin n)) (h : cheats.Nonempty) :
    AuditDetects cheats Finset.univ := by
  obtain ⟨i, hi⟩ := h
  exact ⟨i, by simp [hi]⟩

/-- The samples of size `k` that miss every cheat are exactly the `k`-subsets of
the honest jobs. -/
theorem escaping_samples (cheats : Finset (Fin n)) (k : ℕ) :
    ((Finset.univ : Finset (Fin n)).powersetCard k).filter (fun s => Disjoint s cheats) =
      cheatsᶜ.powersetCard k := by
  ext s
  simp only [Finset.mem_filter, Finset.mem_powersetCard, Finset.subset_univ, true_and,
    ← Finset.subset_compl_iff_disjoint_right]
  tauto

/-- **How much a sample buys.**  Out of the `n.choose k` audits of size `k`,
exactly `(n - m).choose k` fail to notice `m` cheated jobs. -/
theorem escaping_samples_card (cheats : Finset (Fin n)) (k : ℕ) :
    (((Finset.univ : Finset (Fin n)).powersetCard k).filter
        (fun s => Disjoint s cheats)).card = (n - cheats.card).choose k := by
  rw [escaping_samples, Finset.card_powersetCard, Finset.card_compl]
  simp

/-- The total number of audits of size `k`. -/
theorem all_samples_card (k : ℕ) :
    ((Finset.univ : Finset (Fin n)).powersetCard k).card = n.choose k := by
  rw [Finset.card_powersetCard]
  simp

/-- Cheating strictly narrows the operator's escape: with at least one cheated
job and at least one audited job (and an audit that is not larger than the
batch), strictly fewer samples miss the cheating than there are samples. -/
theorem escaping_lt_all (cheats : Finset (Fin n)) {k : ℕ}
    (hk : 1 ≤ k) (hkn : k ≤ n) (hm : 1 ≤ cheats.card) :
    (n - cheats.card).choose k < n.choose k := by
  have hmono : (n - cheats.card).choose k ≤ (n - 1).choose k :=
    Nat.choose_le_choose k (by omega)
  have hpascal : (n - 1).choose k < n.choose k := by
    obtain ⟨n', rfl⟩ : ∃ n', n = n' + 1 := ⟨n - 1, by omega⟩
    obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
    have hsucc : (n' + 1).choose (k' + 1) = n'.choose k' + n'.choose (k' + 1) :=
      Nat.choose_succ_succ n' k'
    have hpos : 0 < n'.choose k' := Nat.choose_pos (by omega)
    simp only [Nat.add_sub_cancel]
    omega
  omega

/-! ### The security parameter: how fast cheating stops paying

`escaping_lt_all` says an audit helps.  The bound below says how much: the share
of audits a cheat escapes decays like `((n - k) / n) ^ m` in the number `m` of
cheated jobs, so an operator who wants to profit has to cheat on few jobs, and
one that cheats on many is caught in all but a vanishing share of audits. -/

/-- A binomial identity in the form the induction needs:
`a * C(a-1, k) = C(a, k) * (a - k)`. -/
theorem mul_choose_pred (a k : ℕ) (ha : 1 ≤ a) :
    a * (a - 1).choose k = a.choose k * (a - k) := by
  obtain ⟨a', rfl⟩ : ∃ a', a = a' + 1 := ⟨a - 1, by omega⟩
  simp only [Nat.add_sub_cancel]
  by_cases hka : k ≤ a'
  · have key := Nat.add_one_mul_choose_eq a' (a' - k)
    have h1 : a'.choose k = a'.choose (a' - k) := (Nat.choose_symm hka).symm
    have h2 : (a' + 1).choose k = (a' + 1).choose (a' + 1 - k) :=
      (Nat.choose_symm (by omega)).symm
    rw [h1, h2]
    have e1 : a' - k + 1 = a' + 1 - k := by omega
    rw [← e1]
    exact key
  · rcases Nat.lt_or_ge (a' + 1) k with h | h
    · rw [Nat.choose_eq_zero_of_lt (by omega), Nat.choose_eq_zero_of_lt (by omega)]
      simp
    · have hk' : k = a' + 1 := by omega
      subst hk'
      simp

/-- One more cheated job costs the operator a factor of at least `(n - k) / n`
in the share of audits it escapes. -/
theorem escape_step (a n k : ℕ) (ha : 1 ≤ a) (han : a ≤ n) :
    (a - 1).choose k * n ≤ a.choose k * (n - k) := by
  have hineq : (a - k) * n ≤ (n - k) * a := by
    rcases Nat.lt_or_ge a k with h | h
    · simp [Nat.sub_eq_zero_of_le h.le]
    · rw [Nat.sub_mul, Nat.sub_mul]
      have h1 : k * a ≤ k * n := Nat.mul_le_mul_left k han
      have h2 : a * n = n * a := Nat.mul_comm a n
      omega
  have hmain : a * ((a - 1).choose k * n) ≤ a * (a.choose k * (n - k)) := by
    calc a * ((a - 1).choose k * n) = (a * (a - 1).choose k) * n := by ring
      _ = (a.choose k * (a - k)) * n := by rw [mul_choose_pred a k ha]
      _ = a.choose k * ((a - k) * n) := by ring
      _ ≤ a.choose k * ((n - k) * a) := Nat.mul_le_mul_left _ hineq
      _ = a * (a.choose k * (n - k)) := by ring
  exact Nat.le_of_mul_le_mul_left hmain ha

/-- **Cheating escapes geometrically less often.**  Of the `n.choose k` audits of
size `k`, those that miss all `m` cheated jobs are at most a `((n - k) / n) ^ m`
share — stated without division, `C(n-m, k) * n ^ m ≤ C(n, k) * (n - k) ^ m`. -/
theorem escape_geometric_bound (n k m : ℕ) (hm : m ≤ n) :
    (n - m).choose k * n ^ m ≤ n.choose k * (n - k) ^ m := by
  induction m with
  | zero => simp
  | succ m ih =>
      have hm' : m ≤ n := by omega
      have hstep : (n - (m + 1)).choose k * n ≤ (n - m).choose k * (n - k) := by
        have h := escape_step (n - m) n k (by omega) (by omega)
        have e : n - (m + 1) = (n - m) - 1 := by omega
        rw [e]
        exact h
      calc (n - (m + 1)).choose k * n ^ (m + 1)
          = ((n - (m + 1)).choose k * n) * n ^ m := by ring
        _ ≤ ((n - m).choose k * (n - k)) * n ^ m := Nat.mul_le_mul_right _ hstep
        _ = ((n - m).choose k * n ^ m) * (n - k) := by ring
        _ ≤ (n.choose k * (n - k) ^ m) * (n - k) := Nat.mul_le_mul_right _ (ih hm')
        _ = n.choose k * (n - k) ^ (m + 1) := by ring

/-- **The economic security parameter, as a fraction.**  Auditing `k` of `n`
jobs, an operator that cheats on `m` of them escapes at most a
`((n - k) / n) ^ m` share of the possible audits: the chance of getting away
with it decays geometrically in the amount of cheating, at a rate set by how
much of the batch is audited. -/
theorem escape_ratio_le (n k m : ℕ) (hk : k ≤ n) (hm : m ≤ n) :
    (((n - m).choose k : ℚ)) / (n.choose k : ℚ) ≤ (((n - k : ℕ) : ℚ) / (n : ℚ)) ^ m := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · obtain rfl : k = 0 := Nat.le_zero.1 hk
    obtain rfl : m = 0 := Nat.le_zero.1 hm
    simp
  have hcpos : (0 : ℚ) < (n.choose k : ℚ) := by exact_mod_cast Nat.choose_pos hk
  have hnpos : (0 : ℚ) < (n : ℚ) ^ m := by positivity
  rw [div_pow, div_le_div_iff₀ hcpos hnpos]
  have h : (((n - m).choose k : ℚ)) * ((n : ℚ) ^ m) ≤
      ((n.choose k : ℚ)) * (((n - k : ℕ) : ℚ) ^ m) := by
    exact_mod_cast escape_geometric_bound n k m hm
  calc (((n - m).choose k : ℚ)) * (n : ℚ) ^ m
      ≤ ((n.choose k : ℚ)) * (((n - k : ℕ) : ℚ) ^ m) := h
    _ = ((n - k : ℕ) : ℚ) ^ m * (n.choose k : ℚ) := by ring

/-- The same bound for the audits of a concrete cheating set. -/
theorem escaping_samples_geometric (cheats : Finset (Fin n)) (k : ℕ) :
    ((((Finset.univ : Finset (Fin n)).powersetCard k).filter
        (fun s => Disjoint s cheats)).card) * n ^ cheats.card ≤
      n.choose k * (n - k) ^ cheats.card := by
  rw [escaping_samples_card]
  exact escape_geometric_bound n k cheats.card (by simpa using Finset.card_le_univ cheats)

end RequestProject.Market
