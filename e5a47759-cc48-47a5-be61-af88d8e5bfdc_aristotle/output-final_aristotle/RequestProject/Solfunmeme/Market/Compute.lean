/-
# A verified compute market

This file formalises the settlement rule that senator Vaicu's report puts at the
centre of the "verified AI compute market":

    job → formal specification → execution → proof → verification → payment

The point of the exercise is to separate two ways a decentralised compute network
can decide who gets paid:

* **by verification** — the escrow pays out exactly when a submitted proof checks
  against the job's specification;
* **by vote** — the escrow pays out when enough validators say so.

Everything below is stated for an arbitrary task, so the theorems hold whatever
the computation is; they say nothing about whether a proof system for a
particular computation (say, LLM inference) exists.  What they do say is that
*if* one exists, the market built on it cannot pay for a wrong result, while the
vote market can.
-/
import Mathlib

namespace RequestProject.Market

/-- A task the market can price: a specification relating inputs to outputs, and
a decidable verifier for it.  `verify_sound` says a checking proof forces the
specification to hold (nobody can be paid for a wrong answer); `verify_complete`
says a correct answer always has a checking proof (an honest operator can always
get paid). -/
structure Task (Input Output Proof : Type*) where
  /-- What the customer asked for, as a relation between input and output. -/
  spec : Input → Output → Prop
  /-- The public checker run at settlement time. -/
  verify : Input → Output → Proof → Bool
  /-- A proof that checks witnesses the specification. -/
  verify_sound : ∀ x y p, verify x y p = true → spec x y
  /-- A correct output always admits a checking proof. -/
  verify_complete : ∀ x y, spec x y → ∃ p, verify x y p = true

variable {Input Output Proof : Type*}

/-- What an operator hands back: a claimed result together with its proof. -/
structure Submission (Output Proof : Type*) where
  /-- The claimed result of the computation. -/
  output : Output
  /-- The proof that the result meets the specification. -/
  proof : Proof

/-- The money locked for one job: the customer's price and the operator's bond. -/
structure Trade where
  /-- What the customer escrows for the result. -/
  price : Nat
  /-- What the operator stakes as a bond, forfeited on a failed submission. -/
  bond : Nat

/-- One job on the market: its input, the money at stake, and what (if anything)
the operator submitted before the deadline. -/
structure Job (Input Output Proof : Type*) where
  /-- The input the customer supplied. -/
  input : Input
  /-- The escrowed price and bond. -/
  trade : Trade
  /-- The operator's submission, if any. -/
  submission : Option (Submission Output Proof)

/-- The settlement predicate: a job is accepted exactly when a submission is
present and its proof checks. -/
def Task.accepts (T : Task Input Output Proof) (j : Job Input Output Proof) : Bool :=
  match j.submission with
  | none => false
  | some s => T.verify j.input s.output s.proof

/-- Settlement: `(paid to operator, returned to customer)`. -/
def Task.payout (T : Task Input Output Proof) (j : Job Input Output Proof) : Nat × Nat :=
  if T.accepts j then (j.trade.price + j.trade.bond, 0)
  else (0, j.trade.price + j.trade.bond)

/-! ## The settlement rule is conservative and sound -/

/-- Settlement never creates or destroys money: the escrowed price and bond are
always fully distributed. -/
theorem payout_conserves (T : Task Input Output Proof) (j : Job Input Output Proof) :
    (T.payout j).1 + (T.payout j).2 = j.trade.price + j.trade.bond := by
  unfold Task.payout
  split <;> simp

/-- **Nobody is paid for an unverified claim.**  If the operator receives
anything at all, the job carried a submission whose output really does satisfy
the specification. -/
theorem paid_implies_spec (T : Task Input Output Proof) (j : Job Input Output Proof)
    (h : 0 < (T.payout j).1) :
    ∃ s, j.submission = some s ∧ T.spec j.input s.output := by
  unfold Task.payout at h
  by_cases hacc : T.accepts j
  · revert hacc
    unfold Task.accepts
    cases hsub : j.submission with
    | none => simp
    | some s =>
        intro hv
        exact ⟨s, rfl, T.verify_sound _ _ _ hv⟩
  · simp [hacc] at h

/-- A job with no submission pays the operator nothing and refunds the customer
in full. -/
theorem payout_of_no_submission (T : Task Input Output Proof)
    (j : Job Input Output Proof) (h : j.submission = none) :
    T.payout j = (0, j.trade.price + j.trade.bond) := by
  simp [Task.payout, Task.accepts, h]

/-- **An honest operator is always paid.**  If the operator computes an output
meeting the specification, there is a submission that settles in full. -/
theorem honest_operator_paid (T : Task Input Output Proof) (x : Input) (t : Trade)
    (y : Output) (hy : T.spec x y) :
    ∃ s : Submission Output Proof,
      s.output = y ∧
      T.payout ⟨x, t, some s⟩ = (t.price + t.bond, 0) := by
  obtain ⟨p, hp⟩ := T.verify_complete x y hy
  refine ⟨⟨y, p⟩, rfl, ?_⟩
  simp [Task.payout, Task.accepts, hp]

/-- The operator's bond and fee are paid out exactly when the submission
verifies, and forfeited otherwise (assuming there is money at stake at all). -/
theorem bond_forfeited_iff (T : Task Input Output Proof) (j : Job Input Output Proof)
    (hpos : 0 < j.trade.price + j.trade.bond) :
    (T.payout j).1 = 0 ↔ T.accepts j = false := by
  by_cases hacc : T.accepts j
  · simp [Task.payout, hacc]
    omega
  · simp [Task.payout, hacc]

/-! ## Revenue over many jobs measures verified work, and nothing else -/

/-- Total revenue of an operator over a batch of jobs. -/
def Task.revenue (T : Task Input Output Proof) (js : List (Job Input Output Proof)) : Nat :=
  (js.map fun j => (T.payout j).1).sum

/-- Every job that contributed to the revenue carries a result that meets its
specification. -/
theorem revenue_only_from_verified (T : Task Input Output Proof)
    (js : List (Job Input Output Proof)) (j : Job Input Output Proof) (_hj : j ∈ js)
    (h : 0 < (T.payout j).1) :
    ∃ s, j.submission = some s ∧ T.spec j.input s.output :=
  paid_implies_spec T j h

/-- An operator none of whose submissions verify earns nothing, no matter how
many jobs it takes on. -/
theorem revenue_zero_of_none_accepted (T : Task Input Output Proof)
    (js : List (Job Input Output Proof)) (h : ∀ j ∈ js, T.accepts j = false) :
    T.revenue js = 0 := by
  unfold Task.revenue
  induction js with
  | nil => simp
  | cons a l ih =>
      have ha : T.accepts a = false := h a (List.mem_cons_self ..)
      have hl : ∀ j ∈ l, T.accepts j = false := fun j hj => h j (List.mem_cons_of_mem _ hj)
      have hz : (T.payout a).1 = 0 := by simp [Task.payout, ha]
      simp [hz, ih hl]

/-- Doing more verified work never lowers revenue. -/
theorem revenue_mono (T : Task Input Output Proof)
    (js ks : List (Job Input Output Proof)) :
    T.revenue js ≤ T.revenue (js ++ ks) := by
  unfold Task.revenue
  simp [List.map_append, List.sum_append]

/-! ## Contrast: a market that pays on validator votes -/

/-- A validator committee scoring outputs, as in a reward-by-evaluation network. -/
structure VoteMarket (Input Output : Type*) where
  /-- Each validator's verdict on a claimed result. -/
  validators : List (Input → Output → Bool)

/-- Vote settlement: the operator is paid when a strict majority of validators
approve. -/
def VoteMarket.payout (m : VoteMarket Input Output) (x : Input) (y : Output) (t : Trade) :
    Nat :=
  if 2 * (m.validators.countP fun v => v x y) > m.validators.length then t.price else 0

/-- **The vote market can be gamed.**  There is a task, a committee, and an
output violating the specification for which the committee's verdict pays the
operator in full: the committee simply agrees on a false result. -/
theorem vote_market_pays_for_wrong_result :
    ∃ (spec : Unit → Bool → Prop) (m : VoteMarket Unit Bool) (y : Bool) (t : Trade),
      ¬ spec () y ∧ 0 < t.price ∧ m.payout () y t = t.price := by
  refine ⟨fun _ y => y = true, ⟨[fun _ _ => true, fun _ _ => true, fun _ _ => true]⟩,
    false, ⟨20, 0⟩, by simp, by norm_num, ?_⟩
  simp [VoteMarket.payout]

/-- **The proof market cannot be gamed, by anyone.**  Whatever strategy an
adversary uses to produce a submission — including one chosen with full
knowledge of, or in collusion with, any committee — payment implies the
specification holds. -/
theorem proof_market_immune_to_collusion (T : Task Input Output Proof)
    {Committee : Type*} (adv : Committee → Submission Output Proof)
    (x : Input) (t : Trade) (c : Committee)
    (h : 0 < (T.payout ⟨x, t, some (adv c)⟩).1) :
    T.spec x (adv c).output := by
  obtain ⟨s, hs, hspec⟩ := paid_implies_spec T ⟨x, t, some (adv c)⟩ h
  simpa [Option.some_inj.mp hs] using hspec

end RequestProject.Market
