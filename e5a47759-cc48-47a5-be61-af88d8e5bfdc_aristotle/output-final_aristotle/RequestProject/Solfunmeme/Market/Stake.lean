/-
# Stake, reward and the cost of lying

The report's token loop is

    stake → submit computation → proof → verified result → reward

This file runs an operator's stake through a sequence of jobs on the market of
`RequestProject.Market.Compute`.  Each job requires the operator to lock a bond
`bond` out of its stake; a verified submission returns the bond and adds the
price, an unverified one forfeits the bond, and an operator whose stake is below
the bond cannot take the job at all.

What is proved: an operator whose submissions all verify never loses stake and
earns exactly the price per job; an operator that never produces a valid proof
earns nothing and can make at most `stake / bond` failed attempts before it is
priced out — so lying to the market has a bounded, paid-for cost, while honest
work is unbounded upside.
-/
import Mathlib
import RequestProject.Solfunmeme.Market.Compute

namespace RequestProject.Market

variable {Input Output Proof : Type*}

/-- The stake schedule of the market: the bond an operator must lock per job and
the price a verified job pays. -/
structure Schedule where
  /-- Locked per job, forfeited if the submission does not verify. -/
  bond : Nat
  /-- Paid on a verified submission. -/
  price : Nat

/-- The operator's running state: stake held, and how many submissions have been
rejected. -/
structure StakeState where
  /-- Stake currently held. -/
  stake : Nat
  /-- Number of failed (bond-forfeiting) submissions so far. -/
  failures : Nat
  deriving DecidableEq

/-- One job's effect on the operator's state. -/
def Schedule.step (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (j : Job Input Output Proof) : StakeState :=
  if st.stake < sch.bond then st
  else if T.accepts j then ⟨st.stake + sch.price, st.failures⟩
  else ⟨st.stake - sch.bond, st.failures + 1⟩

/-- Running a batch of jobs. -/
def Schedule.run (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (js : List (Job Input Output Proof)) : StakeState :=
  js.foldl (sch.step T) st

@[simp] theorem Schedule.run_nil (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) : sch.run T st [] = st := rfl

@[simp] theorem Schedule.run_cons (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (j : Job Input Output Proof) (js : List (Job Input Output Proof)) :
    sch.run T st (j :: js) = sch.run T (sch.step T st j) js := rfl

/-! ## Honest work -/

/-- **Honest operators only gain.**  If every submission verifies and the
operator can afford the first bond, its stake grows by the price of every job and
it never records a failure. -/
theorem run_of_all_accepted (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (js : List (Job Input Output Proof))
    (hafford : sch.bond ≤ st.stake) (hacc : ∀ j ∈ js, T.accepts j = true) :
    sch.run T st js = ⟨st.stake + sch.price * js.length, st.failures⟩ := by
  induction js generalizing st with
  | nil => simp
  | cons j rest ih =>
      have hj : T.accepts j = true := hacc j (List.mem_cons_self ..)
      have hstep : sch.step T st j = ⟨st.stake + sch.price, st.failures⟩ := by
        simp [Schedule.step, Nat.not_lt.mpr hafford, hj]
      have hafford' : sch.bond ≤ st.stake + sch.price := le_trans hafford (Nat.le_add_right _ _)
      rw [Schedule.run_cons, hstep,
        ih ⟨st.stake + sch.price, st.failures⟩ hafford'
          (fun j hj => hacc j (List.mem_cons_of_mem _ hj))]
      simp [List.length_cons, Nat.mul_succ]
      omega

/-! ## The cost of lying -/

/-- The invariant of a run in which nothing ever verifies: every forfeited bond
came out of the initial stake. -/
theorem stake_plus_forfeits (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (js : List (Job Input Output Proof))
    (hrej : ∀ j ∈ js, T.accepts j = false) :
    (sch.run T st js).stake + sch.bond * ((sch.run T st js).failures - st.failures)
      = st.stake ∧ st.failures ≤ (sch.run T st js).failures := by
  induction js generalizing st with
  | nil => simp
  | cons j rest ih =>
      have hj : T.accepts j = false := hrej j (List.mem_cons_self ..)
      have hrest : ∀ k ∈ rest, T.accepts k = false :=
        fun k hk => hrej k (List.mem_cons_of_mem _ hk)
      rw [Schedule.run_cons]
      by_cases hlow : st.stake < sch.bond
      · have hstep : sch.step T st j = st := by simp [Schedule.step, hlow]
        rw [hstep]
        exact ih st hrest
      · have hbond : sch.bond ≤ st.stake := Nat.not_lt.mp hlow
        have hstep : sch.step T st j = ⟨st.stake - sch.bond, st.failures + 1⟩ := by
          simp [Schedule.step, hlow, hj]
        rw [hstep]
        obtain ⟨heq, hle⟩ := ih ⟨st.stake - sch.bond, st.failures + 1⟩ hrest
        dsimp only at heq hle
        refine ⟨?_, by omega⟩
        set r := sch.run T ⟨st.stake - sch.bond, st.failures + 1⟩ rest with hr
        have hmul : sch.bond * (r.failures - st.failures)
            = sch.bond * (r.failures - (st.failures + 1)) + sch.bond := by
          have : r.failures - st.failures = (r.failures - (st.failures + 1)) + 1 := by omega
          rw [this, Nat.mul_succ]
        omega

/-- **Lying is bounded and paid for.**  An operator that never produces a
verifying submission ends with less stake than it started, and the number of
failed attempts it can make is bounded by its stake divided by the bond. -/
theorem failures_bounded (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (js : List (Job Input Output Proof))
    (hrej : ∀ j ∈ js, T.accepts j = false) :
    sch.bond * ((sch.run T st js).failures - st.failures) ≤ st.stake ∧
      (sch.run T st js).stake ≤ st.stake := by
  obtain ⟨heq, _⟩ := stake_plus_forfeits sch T st js hrej
  omega

/-- With a positive bond, at most `stake / bond` lies fit in a run. -/
theorem failure_count_le_stake_div_bond (sch : Schedule) (T : Task Input Output Proof)
    (st : StakeState) (js : List (Job Input Output Proof))
    (hpos : 0 < sch.bond) (hrej : ∀ j ∈ js, T.accepts j = false) :
    (sch.run T st js).failures - st.failures ≤ st.stake / sch.bond := by
  have h := (failures_bounded sch T st js hrej).1
  refine (Nat.le_div_iff_mul_le hpos).mpr ?_
  rw [Nat.mul_comm]
  exact h

/-- An operator that never produces a verifying submission earns nothing: its
market revenue over the batch is zero. -/
theorem liar_earns_nothing (T : Task Input Output Proof)
    (js : List (Job Input Output Proof)) (hrej : ∀ j ∈ js, T.accepts j = false) :
    T.revenue js = 0 :=
  revenue_zero_of_none_accepted T js hrej

end RequestProject.Market
