/-
What a bootstrap plan is, and what makes one work.
-/
import Mathlib.Tactic

/-!
# Bootstrapping, in general

A **stage** of a bootstrap does one thing: it *needs* some capabilities to be
in place already, it *gives* some new ones, it *costs* money, and once it is
done it *earns* money every period thereafter.  A **plan** is a list of stages,
run in order, one per period.

Two things can go wrong with such a plan, and this file says exactly what they
are and how to rule each out.

* **It can ask for something that is not there yet.**  `FeasibleFrom held p`
  checks, stage by stage, that everything a stage needs is either held at the
  start or given by a stage strictly earlier in the plan.  The content of that
  check is `needs_supplied`: in a feasible plan every need of every stage is
  met by the opening holdings plus the stages before it.  Feasibility only ever
  gets easier as you hold more (`feasible_mono`), so a plan that runs from
  nothing runs again from its own output (`feasible_from_caps`) — the fixed
  point that makes a bootstrap a bootstrap, since capabilities are only ever
  added (`caps_idem`).

* **It can run out of money.**  Cash and revenue are tracked together: a period
  collects the revenue of everything finished so far and pays for the stage it
  is doing (`Cash.step`).  `Solvent` says the balance is never negative.  The
  main results are that solvency depends on the opening float in the simplest
  possible way — the trace just shifts (`trace_shift`) — so that there is a
  sharp threshold, `requiredFloat`, with the plan affordable exactly at or
  above it (`solvent_iff_requiredFloat_le`); and that once the standing revenue
  covers every remaining stage the balance can never fall again
  (`cash_ge_of_selfFunding`), so a self-funding operation survives every
  horizon (`solvent_replicate_of_selfFunding`).

Nothing in this file mentions this project, any capability of it, or any price.
-/

namespace SFM.Bootstrap

/-! ## Stages and plans -/

/-- One stage of a bootstrap: what it needs, what it leaves behind, what it
costs to do, what it earns each period afterwards, and the command that checks
it was really done. -/
structure Stage where
  /-- A short name for the stage. -/
  name : String
  /-- Capabilities that must already be in place. -/
  needs : List Nat
  /-- Capabilities the stage leaves behind. -/
  gives : List Nat
  /-- What doing the stage costs, in the smallest money unit used. -/
  cost : Int
  /-- What the stage earns in every later period, once it is done. -/
  income : Int
  /-- The command that checks the stage was really done. -/
  check : String
  deriving Repr, DecidableEq

/-- A plan is a list of stages, done in order, one per period. -/
abbrev Plan := List Stage

/-! ## Capabilities -/

/-- The capabilities held after running a plan, starting from `held`. -/
def caps (held : List Nat) (p : Plan) : List Nat := held ++ p.flatMap Stage.gives

@[simp] theorem caps_nil (held : List Nat) : caps held [] = held := by
  simp [caps]

theorem caps_cons (held : List Nat) (s : Stage) (p : Plan) :
    caps held (s :: p) = caps (held ++ s.gives) p := by
  simp [caps, List.append_assoc]

theorem mem_caps_of_mem_held {held : List Nat} {p : Plan} {c : Nat} (h : c ∈ held) :
    c ∈ caps held p := by
  simp [caps, h]

theorem mem_caps_of_mem_gives {held : List Nat} {p : Plan} {s : Stage} (hs : s ∈ p)
    {c : Nat} (hc : c ∈ s.gives) : c ∈ caps held p := by
  simp only [caps, List.mem_append, List.mem_flatMap]
  exact Or.inr ⟨s, hs, hc⟩

theorem caps_append (held : List Nat) (p q : Plan) :
    caps held (p ++ q) = caps (caps held p) q := by
  simp [caps, List.append_assoc]

/-- Every stage's needs are already held, in order. -/
def FeasibleFrom (held : List Nat) : Plan → Bool
  | [] => true
  | s :: p => s.needs.all (fun c => held.contains c) && FeasibleFrom (held ++ s.gives) p

@[simp] theorem feasibleFrom_nil (held : List Nat) : FeasibleFrom held [] = true := rfl

theorem feasibleFrom_cons {held : List Nat} {s : Stage} {p : Plan} :
    FeasibleFrom held (s :: p) = true ↔
      (∀ c ∈ s.needs, c ∈ held) ∧ FeasibleFrom (held ++ s.gives) p = true := by
  simp [FeasibleFrom, List.all_eq_true]

/-- **Holding more can only help.**  Feasibility is monotone in the opening
holdings. -/
theorem feasible_mono {h₁ h₂ : List Nat} (hsub : ∀ c ∈ h₁, c ∈ h₂) {p : Plan}
    (hf : FeasibleFrom h₁ p = true) : FeasibleFrom h₂ p = true := by
  induction p generalizing h₁ h₂ with
  | nil => rfl
  | cons s p ih =>
      rw [feasibleFrom_cons] at hf ⊢
      refine ⟨fun c hc => hsub c (hf.1 c hc), ih ?_ hf.2⟩
      intro c hc
      rcases List.mem_append.1 hc with h | h
      · exact List.mem_append_left _ (hsub c h)
      · exact List.mem_append_right _ h

/-- **Nothing is scheduled before what it needs.**  In a feasible plan, every
need of every stage is met by the opening holdings together with the stages
strictly before it. -/
theorem needs_supplied {held : List Nat} {pre : Plan} {s : Stage} {post : Plan}
    (hf : FeasibleFrom held (pre ++ s :: post) = true) {c : Nat} (hc : c ∈ s.needs) :
    c ∈ caps held pre := by
  induction pre generalizing held with
  | nil =>
      rw [List.nil_append, feasibleFrom_cons] at hf
      simpa [caps] using hf.1 c hc
  | cons t pre ih =>
      rw [List.cons_append, feasibleFrom_cons] at hf
      have := ih hf.2
      simpa [caps_cons] using this

/-- A need that neither the opening holdings nor an earlier stage supplies
makes the plan infeasible. -/
theorem not_feasible_of_need_missing {held : List Nat} {pre : Plan} {s : Stage} {post : Plan}
    {c : Nat} (hc : c ∈ s.needs) (hheld : c ∉ held)
    (hpre : ∀ t ∈ pre, c ∉ t.gives) :
    FeasibleFrom held (pre ++ s :: post) ≠ true := by
  intro hf
  have hmem := needs_supplied hf hc
  simp only [caps, List.mem_append, List.mem_flatMap] at hmem
  rcases hmem with h | ⟨t, ht, hct⟩
  · exact hheld h
  · exact hpre t ht hct

/-- **A plan runs again on its own output.**  This is the bootstrap fixed
point: what the plan produces is enough to start the plan over. -/
theorem feasible_from_caps {held : List Nat} {p : Plan} (hf : FeasibleFrom held p = true) :
    FeasibleFrom (caps held p) p = true :=
  feasible_mono (fun _ hc => mem_caps_of_mem_held hc) hf

/-- **Capabilities only accumulate.**  Running the plan a second time adds
nothing new. -/
theorem caps_idem (held : List Nat) (p : Plan) (c : Nat) :
    c ∈ caps (caps held p) p ↔ c ∈ caps held p := by
  simp only [caps, List.mem_append, List.mem_flatMap]
  constructor
  · rintro ((h | h) | h)
    · exact Or.inl h
    · exact Or.inr h
    · exact Or.inr h
  · rintro (h | h)
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr h)

/-! ## Cash -/

/-- The financial state between stages: money in hand, and revenue per period
from everything finished so far. -/
structure Cash where
  /-- Money in hand. -/
  cash : Int
  /-- Revenue per period from the stages already done. -/
  rate : Int
  deriving Repr, DecidableEq

/-- One period: collect the standing revenue, pay for the stage, and add its
revenue to the standing rate. -/
def Cash.step (st : Cash) (s : Stage) : Cash :=
  ⟨st.cash + st.rate - s.cost, st.rate + s.income⟩

/-- The financial state after running a plan. -/
def run (st : Cash) (p : Plan) : Cash := p.foldl Cash.step st

@[simp] theorem run_nil (st : Cash) : run st [] = st := rfl

@[simp] theorem run_cons (st : Cash) (s : Stage) (p : Plan) :
    run st (s :: p) = run (st.step s) p := rfl

theorem run_append (st : Cash) (p q : Plan) : run st (p ++ q) = run (run st p) q :=
  List.foldl_append

/-- Every financial state the plan passes through, opening state first. -/
def trace (st : Cash) : Plan → List Cash
  | [] => [st]
  | s :: p => st :: trace (st.step s) p

@[simp] theorem trace_nil (st : Cash) : trace st [] = [st] := rfl

@[simp] theorem trace_cons (st : Cash) (s : Stage) (p : Plan) :
    trace st (s :: p) = st :: trace (st.step s) p := rfl

theorem run_mem_trace (st : Cash) (p : Plan) : run st p ∈ trace st p := by
  induction p generalizing st with
  | nil => simp
  | cons s p ih => simpa using Or.inr (ih (st.step s))

/-- The balance is never negative. -/
def Solvent (st : Cash) (p : Plan) : Bool := (trace st p).all (fun c => decide (0 ≤ c.cash))

theorem solvent_iff {st : Cash} {p : Plan} :
    Solvent st p = true ↔ ∀ c ∈ trace st p, 0 ≤ c.cash := by
  simp [Solvent, List.all_eq_true]

/-- The standing revenue after a plan is the opening rate plus every stage's
income. -/
theorem rate_run (st : Cash) (p : Plan) :
    (run st p).rate = st.rate + (p.map Stage.income).sum := by
  induction p generalizing st with
  | nil => simp
  | cons s p ih => simp [ih, Cash.step, add_assoc]

/-- **Extra opening float shifts the whole trace and changes nothing else.** -/
theorem trace_shift (c r d : Int) (p : Plan) :
    trace ⟨c + d, r⟩ p = (trace ⟨c, r⟩ p).map (fun x => ⟨x.cash + d, x.rate⟩) := by
  induction p generalizing c r with
  | nil => simp
  | cons s p ih =>
      have hstep : (Cash.step ⟨c + d, r⟩ s)
          = ⟨(Cash.step ⟨c, r⟩ s).cash + d, (Cash.step ⟨c, r⟩ s).rate⟩ := by
        simp only [Cash.step, Cash.mk.injEq]
        exact ⟨by ring, trivial⟩
      rw [trace_cons, trace_cons, hstep, ih]
      simp

/-- The float a plan needs: the deepest hole it digs, or nothing if it never
digs one. -/
def requiredFloat (r : Int) (p : Plan) : Int :=
  ((trace ⟨0, r⟩ p).map (fun c => -c.cash)).foldr max 0

theorem foldr_max_le {l : List Int} {f : Int} :
    l.foldr max 0 ≤ f ↔ 0 ≤ f ∧ ∀ x ∈ l, x ≤ f := by
  induction l with
  | nil => simp
  | cons a l ih =>
      simp only [List.foldr_cons, max_le_iff, ih, List.mem_cons]
      constructor
      · rintro ⟨ha, h0, hl⟩
        exact ⟨h0, by rintro x (rfl | hx); exacts [ha, hl x hx]⟩
      · rintro ⟨h0, h⟩
        exact ⟨h a (Or.inl rfl), h0, fun x hx => h x (Or.inr hx)⟩

theorem foldr_max_nonneg (l : List Int) : 0 ≤ l.foldr max 0 := by
  induction l with
  | nil => simp
  | cons a l ih => exact le_trans ih (le_max_right _ _)

/-- **The float needed is never negative.** -/
theorem requiredFloat_nonneg (r : Int) (p : Plan) : 0 ≤ requiredFloat r p :=
  foldr_max_nonneg _

/-- **A sharp threshold: the plan is affordable exactly at or above the float
it requires.** -/
theorem solvent_iff_requiredFloat_le {f r : Int} {p : Plan} :
    Solvent ⟨f, r⟩ p = true ↔ requiredFloat r p ≤ f := by
  have hshift : trace ⟨(0 : Int) + f, r⟩ p
      = (trace ⟨0, r⟩ p).map (fun x => ⟨x.cash + f, x.rate⟩) := trace_shift 0 r f p
  rw [zero_add] at hshift
  rw [solvent_iff, hshift, requiredFloat, foldr_max_le]
  constructor
  · intro h
    refine ⟨?_, ?_⟩
    · have hmem : (⟨0 + f, r⟩ : Cash) ∈ (trace ⟨(0 : Int), r⟩ p).map
          (fun x => ⟨x.cash + f, x.rate⟩) := by
        simp only [List.mem_map]
        exact ⟨⟨0, r⟩, by cases p <;> simp, rfl⟩
      have := h _ hmem
      simpa using this
    · rintro x hx
      simp only [List.mem_map] at hx
      obtain ⟨y, hy, rfl⟩ := hx
      have := h ⟨y.cash + f, y.rate⟩ (by
        simp only [List.mem_map]
        exact ⟨y, hy, rfl⟩)
      simp only at this
      linarith
  · rintro ⟨h0, h⟩ x hx
    simp only [List.mem_map] at hx
    obtain ⟨y, hy, rfl⟩ := hx
    have := h (-y.cash) (by
      simp only [List.mem_map]
      exact ⟨y, hy, rfl⟩)
    simp only
    linarith

/-- **Affordability is monotone in the float.** -/
theorem solvent_mono_float {f d r : Int} {p : Plan} (hd : 0 ≤ d)
    (h : Solvent ⟨f, r⟩ p = true) : Solvent ⟨f + d, r⟩ p = true :=
  solvent_iff_requiredFloat_le.2 (le_trans (solvent_iff_requiredFloat_le.1 h) (by linarith))

/-- A plan is *self-funding* at a given standing revenue when that revenue
already covers every stage still to be done, and no stage loses revenue. -/
def SelfFunding (r : Int) (p : Plan) : Prop :=
  (∀ s ∈ p, s.cost ≤ r) ∧ (∀ s ∈ p, 0 ≤ s.income)

/-- **Once the standing revenue covers every remaining stage, the balance never
falls again.** -/
theorem cash_ge_of_selfFunding {st : Cash} {p : Plan} (h : SelfFunding st.rate p) :
    ∀ c ∈ trace st p, st.cash ≤ c.cash := by
  induction p generalizing st with
  | nil => simp
  | cons s p ih =>
      obtain ⟨hcost, hinc⟩ := h
      have hstep : st.cash ≤ (st.step s).cash := by
        have := hcost s (List.mem_cons_self ..)
        simp only [Cash.step]
        linarith
      have hnext : SelfFunding (st.step s).rate p := by
        refine ⟨fun t ht => ?_, fun t ht => hinc t (List.mem_cons_of_mem _ ht)⟩
        have h1 := hcost t (List.mem_cons_of_mem _ ht)
        have h2 := hinc s (List.mem_cons_self ..)
        simp only [Cash.step]
        linarith
      intro c hc
      rcases List.mem_cons.1 (by simpa using hc) with rfl | hc'
      · exact le_refl _
      · exact le_trans hstep (ih hnext c hc')

/-- **A self-funding plan with money in hand stays solvent.** -/
theorem solvent_of_selfFunding {st : Cash} {p : Plan} (hcash : 0 ≤ st.cash)
    (h : SelfFunding st.rate p) : Solvent st p = true :=
  solvent_iff.2 fun c hc => le_trans hcash (cash_ge_of_selfFunding h c hc)

/-- **A recurring bill covered by recurring revenue is covered for ever**: the
maintenance stage repeated any number of times stays solvent. -/
theorem solvent_replicate_of_selfFunding {st : Cash} {m : Stage} (hcash : 0 ≤ st.cash)
    (hcost : m.cost ≤ st.rate) (hinc : 0 ≤ m.income) (n : ℕ) :
    Solvent st (List.replicate n m) = true := by
  refine solvent_of_selfFunding hcash ⟨fun s hs => ?_, fun s hs => ?_⟩ <;>
    · rw [List.eq_of_mem_replicate hs]
      assumption

/-- A plan that spends nothing and earns nothing needs no float. -/
theorem requiredFloat_of_free {r : Int} {p : Plan} (hr : 0 ≤ r)
    (h : ∀ s ∈ p, s.cost = 0 ∧ s.income = 0) : requiredFloat r p = 0 := by
  have hsolv : Solvent (⟨0, r⟩ : Cash) p = true := by
    refine solvent_of_selfFunding (le_refl 0) ⟨fun s hs => ?_, fun s hs => ?_⟩
    · rw [(h s hs).1]; exact hr
    · rw [(h s hs).2]
  exact le_antisymm (solvent_iff_requiredFloat_le.1 hsolv) (requiredFloat_nonneg r p)

/-! ## Reading a plan -/

/-- The total spent by a plan. -/
def totalCost (p : Plan) : Int := (p.map Stage.cost).sum

/-- The standing revenue a plan ends with, from a standing start. -/
def totalIncome (p : Plan) : Int := (p.map Stage.income).sum

theorem totalCost_append (p q : Plan) : totalCost (p ++ q) = totalCost p + totalCost q := by
  simp [totalCost]

theorem totalIncome_append (p q : Plan) :
    totalIncome (p ++ q) = totalIncome p + totalIncome q := by
  simp [totalIncome]

end SFM.Bootstrap
