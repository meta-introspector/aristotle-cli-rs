import RequestProject.Gvcs.Bootstrap
import RequestProject.Gvcs.Workshop
import RequestProject.Gvcs.Barter
import Mathlib.Data.ZMod.Basic

/-!
# The barnraising: building the machine with a crowd

`RequestProject/Bootstrap.lean` says what one LifeTrac costs in labour:
370.52 hours of it, from ore to finished tractor.  `Civilization.lean` splits
that work between four *trades*.  This file splits it between an arbitrary
crowd of **volunteers** — a barnraising, or its online form, a hackathon — and
asks the three questions a crowd raises.

## 1. How many people does it take?

`load` is what one volunteer ends up carrying under an assignment of tasks;
`load_sum` says the loads add up to the whole job (nobody's hour is
double-counted and none goes missing), and `exists_load_ge_average` says
somebody always carries at least the average.  Hence
`total_le_crowd_mul_cap`: if nobody does more than `cap`, the crowd must be at
least the job divided by the cap.  Applied to the tractor
(`weekend_needs_two_dozen`): a barnraising in which nobody works more than a
sixteen-hour weekend needs **at least twenty-four people**, and twenty-four
suffice for the arithmetic (`two_dozen_weekends_cover_the_job`).

## 2. What can a crowd *not* do?

Speed up a chain.  `Chain` is a run of tasks each of which cannot start until
the one before it has finished; `chain_finish` says the last of them cannot be
done before the whole chain's hours have elapsed, *no matter how many people
are helping*.  A crowd buys width, never depth.

## 3. Can the crowd really be handed the job?

Yes, and no cleverness is needed in the handover.  `barnraising_rota`: take the
verified production plan for one LifeTrac and cut it into shifts *any way at
all*; working the shifts in turn from a yard holding the raw material and the
tools, every shift is workable when its volunteer arrives, and the last one
ends with a finished tractor.

## 4. How do you help without giving yourself away?

`zkBarnraising`.  Each volunteer commits to the hours they are pledging by
masking them with a secret random pad — `commit m r = m + r` in `ZMod Q` — and
publishes only the masked value.  The crowd jointly opens the *sum* of the
pads.  Then:

* `soundness` — if the published commitments add up to the target plus the
  opened pad-sum, then the pledges really do add up to the target.  Nobody can
  inflate the total.
* `privacy` — for *every* way of splitting the target between the volunteers
  there is exactly one pad vector producing exactly the view the coordinator
  saw.  The view is therefore consistent with every split, and
  `views_independent_of_split` states this as an equality of the sets of
  possible views: the coordinator learns the total and provably nothing else
  about who did how much.
* `hours_sound` — the arithmetic in `ZMod Q` is faithful to the hours it stands
  for, provided the crowd is smaller than a thousand and nobody pledges more
  than forty hours.
* `zk_barnraising` — the three put together, against the tractor's own labour
  bill.

Finally `a_share_in_a_barnraising` prices a share: twenty-four people, thirty
seven jars of honey and one weekend apiece, against a dealer's tractor at more
than eighty-five such shares.
-/

namespace LifeTrac
namespace Barnraising

/-! ## 1. Dividing the work -/

variable {m n : ℕ}

/-- The hours volunteer `i` carries, when task `j` takes `dur j` hours and is
assigned to `assign j`. -/
def load (dur : Fin m → ℚ) (assign : Fin m → Fin n) (i : Fin n) : ℚ :=
  ∑ j ∈ Finset.univ.filter (fun j => assign j = i), dur j

/-- **Nobody's hour is lost or counted twice**: the volunteers' loads add up to
the job. -/
theorem load_sum (dur : Fin m → ℚ) (assign : Fin m → Fin n) :
    ∑ i, load dur assign i = ∑ j, dur j :=
  Finset.sum_fiberwise Finset.univ assign dur

/-- **Somebody carries at least the average.** -/
theorem exists_load_ge_average (hn : 0 < n) (dur : Fin m → ℚ) (assign : Fin m → Fin n) :
    ∃ i, (∑ j, dur j) / n ≤ load dur assign i := by
  by_contra h
  push_neg at h
  have hne : (Finset.univ : Finset (Fin n)).Nonempty := by
    simpa [Finset.univ_nonempty_iff, ← Fin.pos_iff_nonempty] using hn
  have hlt : ∑ i, load dur assign i < ∑ _i : Fin n, (∑ j, dur j) / n :=
    Finset.sum_lt_sum_of_nonempty hne (fun i _ => h i)
  rw [load_sum] at hlt
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at hlt
  rw [mul_div_cancel₀] at hlt
  · exact lt_irrefl _ hlt
  · exact_mod_cast hn.ne'

/-- **How big the crowd has to be.**  If no volunteer does more than `cap`
hours, then the whole job is at most `n · cap`. -/
theorem total_le_crowd_mul_cap {cap : ℚ} (dur : Fin m → ℚ) (assign : Fin m → Fin n)
    (hcap : ∀ i, load dur assign i ≤ cap) : ∑ j, dur j ≤ n * cap := by
  have := Finset.sum_le_sum (fun i (_ : i ∈ (Finset.univ : Finset (Fin n))) => hcap i)
  rw [load_sum] at this
  simpa [Finset.sum_const, Finset.card_univ, mul_comm] using this

/-- The labour a LifeTrac takes from the ore up, as a literal: the closed form
of `Workflow.plant.laborFor`, so that it can be printed and computed with
without re-running the whole explosion. -/
def bootstrapLabour : ℚ := 463154719/1250000

theorem bootstrapLabour_eq :
    bootstrapLabour = Workflow.plant.laborFor Workflow.Item.lifeTrac 1 :=
  Workflow.lifeTrac_laborFor.symm

/-- 371 hours cover the labour a LifeTrac takes from the ore up. -/
theorem labour_le_371 : Workflow.plant.laborFor Workflow.Item.lifeTrac 1 ≤ 371 := by
  rw [Workflow.lifeTrac_laborFor]; norm_num

/-- 368 hours do not. -/
theorem labour_gt_368 : (368 : ℚ) < Workflow.plant.laborFor Workflow.Item.lifeTrac 1 := by
  rw [Workflow.lifeTrac_laborFor]; norm_num

/-- **A weekend barnraising takes at least two dozen people.**  However the
370.52 hours of a LifeTrac are cut up, if no volunteer is to work more than a
sixteen-hour weekend then there must be twenty-four of them. -/
theorem weekend_needs_two_dozen (dur : Fin m → ℚ) (assign : Fin m → Fin n)
    (htotal : ∑ j, dur j = Workflow.plant.laborFor Workflow.Item.lifeTrac 1)
    (hcap : ∀ i, load dur assign i ≤ 16) : 24 ≤ n := by
  by_contra h
  push_neg at h
  have hn : (n : ℚ) ≤ 23 := by
    have : n ≤ 23 := by omega
    exact_mod_cast this
  have h1 : ∑ j, dur j ≤ (n : ℚ) * 16 := total_le_crowd_mul_cap dur assign hcap
  have h2 : (n : ℚ) * 16 ≤ 23 * 16 := by nlinarith
  rw [htotal] at h1
  have := labour_gt_368
  linarith

/-- And two dozen are enough for the arithmetic: 24 weekends of 16 hours are
384, more than the 370.52 the machine needs. -/
theorem two_dozen_weekends_cover_the_job :
    Workflow.plant.laborFor Workflow.Item.lifeTrac 1 ≤ 24 * 16 := by
  rw [Workflow.lifeTrac_laborFor]; norm_num

/-! ## 2. What a crowd cannot buy: the critical path -/

variable {α : Type*}

/-- The last task of the run `a`, `l`. -/
def lastOf (a : α) : List α → α
  | [] => a
  | b :: t => lastOf b t

/-- `Chain dur start a l` says that `a`, then the tasks of `l` in order, form a
run of work in which each task starts only after the one before it has
finished. -/
def Chain (dur start : α → ℚ) : α → List α → Prop
  | _, [] => True
  | a, b :: t => start a + dur a ≤ start b ∧ Chain dur start b t

/-- The hours along a chain. -/
def pathLen (dur : α → ℚ) (a : α) (l : List α) : ℚ := dur a + (l.map dur).sum

/-- **A crowd buys width, not depth.**  Whatever the schedule and however many
volunteers are working, the last task of a dependency chain is not finished
before the whole chain's hours have elapsed. -/
theorem chain_finish (dur start : α → ℚ) :
    ∀ (a : α) (l : List α), Chain dur start a l →
      start a + pathLen dur a l ≤ start (lastOf a l) + dur (lastOf a l) := by
  intro a l
  induction l generalizing a with
  | nil => intro _; simp [pathLen, lastOf]
  | cons b t ih =>
      intro h
      obtain ⟨hab, hrest⟩ := h
      have hIH := ih b hrest
      have hp : pathLen dur a (b :: t) = dur a + pathLen dur b t := by
        simp only [pathLen, List.map_cons, List.sum_cons]
      rw [show lastOf a (b :: t) = lastOf b t from rfl, hp]
      calc start a + (dur a + pathLen dur b t)
          = (start a + dur a) + pathLen dur b t := by ring
        _ ≤ start b + pathLen dur b t := by linarith
        _ ≤ start (lastOf b t) + dur (lastOf b t) := hIH

/-- If the work starts at time zero, the chain's hours are a lower bound on the
finishing time outright. -/
theorem chain_makespan (dur start : α → ℚ) (a : α) (l : List α)
    (h : Chain dur start a l) (h0 : 0 ≤ start a) :
    pathLen dur a l ≤ start (lastOf a l) + dur (lastOf a l) := by
  have := chain_finish dur start a l h
  linarith

/-! ## 3. Cutting the build into shifts

A barnraising is the verified plan of `RequestProject/Workshop.lean` handed
round: cut into shifts, one per volunteer, worked in turn.  Nothing about the
cut has to be clever — *any* cut works, because the plan is admissible step by
step and the shifts are consecutive stretches of it. -/

open Workflow

variable {Item : Type} [DecidableEq Item]

/-- Working a rota of shifts, each in the stock the one before it left. -/
def runShifts (P : Plant Item) : List (List (Item × ℚ)) → (Item → ℚ) → (Item → ℚ)
  | [], s => s
  | sh :: rest, s => runShifts P rest (P.runPlan sh s)

/-- Every shift of the rota is workable when its turn comes. -/
def ShiftsOK (P : Plant Item) : List (List (Item × ℚ)) → (Item → ℚ) → Prop
  | [], _ => True
  | sh :: rest, s => P.PlanOK sh s ∧ ShiftsOK P rest (P.runPlan sh s)

theorem runShifts_flatten (P : Plant Item) :
    ∀ (shifts : List (List (Item × ℚ))) (s : Item → ℚ),
      runShifts P shifts s = P.runPlan shifts.flatten s := by
  intro shifts
  induction shifts with
  | nil => intro s; rfl
  | cons sh rest ih =>
      intro s
      rw [runShifts, ih, List.flatten_cons, P.runPlan_append]

theorem planOK_split (P : Plant Item) :
    ∀ (l₁ l₂ : List (Item × ℚ)) (s : Item → ℚ), P.PlanOK (l₁ ++ l₂) s →
      P.PlanOK l₁ s ∧ P.PlanOK l₂ (P.runPlan l₁ s) := by
  intro l₁
  induction l₁ with
  | nil => intro l₂ s h; exact ⟨trivial, h⟩
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      intro l₂ s h
      obtain ⟨h1, h2⟩ := h
      obtain ⟨h3, h4⟩ := ih l₂ (P.step i q s) h2
      exact ⟨⟨h1, h3⟩, h4⟩

/-- **However the plan is cut up, every shift is workable in its turn.** -/
theorem shiftsOK_of_planOK (P : Plant Item) :
    ∀ (shifts : List (List (Item × ℚ))) (s : Item → ℚ),
      P.PlanOK shifts.flatten s → ShiftsOK P shifts s := by
  intro shifts
  induction shifts with
  | nil => intro s _; trivial
  | cons sh rest ih =>
      intro s h
      rw [List.flatten_cons] at h
      obtain ⟨h1, h2⟩ := planOK_split P sh rest.flatten s h
      exact ⟨h1, ih _ h2⟩

/-- **The barnraising.**  Take the verified plan for one LifeTrac and cut it
into shifts any way at all — twenty-four of them, or a hundred, long or short.
Working the shifts in turn from a yard holding the raw material and the tools,
every shift is workable when its volunteer arrives, and at the end of the last
one there is a finished tractor. -/
theorem barnraising_rota (shifts : List (List (Workflow.Item × ℚ)))
    (h : shifts.flatten = plant.plan Workflow.Item.lifeTrac 1) :
    ShiftsOK plant shifts startStock ∧
      1 ≤ runShifts plant shifts startStock Workflow.Item.lifeTrac := by
  obtain ⟨hok, hend⟩ := lifeTrac_plan_works
  rw [← h] at hok hend
  exact ⟨shiftsOK_of_planOK plant shifts startStock hok,
    by rw [runShifts_flatten]; exact hend⟩

/-! ## 4. Helping without giving yourself away -/

/-- The modulus of the pledge arithmetic: a prime comfortably larger than any
barnraising. -/
abbrev Q : ℕ := 1000003

/-- A masked pledge. -/
abbrev Pledge := ZMod Q

/-- A volunteer's commitment to a pledge `m` under a secret pad `r`. -/
def commit (m r : Pledge) : Pledge := m + r

/-- **Perfect hiding.**  Every commitment value is produced by exactly one pad,
whatever the pledge behind it — so a commitment on its own says nothing at all
about the pledge. -/
theorem commit_hiding (m c : Pledge) : ∃! r, commit m r = c := by
  refine ⟨c - m, by simp [commit], ?_⟩
  intro r hr
  rw [commit] at hr
  linear_combination hr

/-- Commitments add. -/
theorem commit_hom (m₁ r₁ m₂ r₂ : Pledge) :
    commit m₁ r₁ + commit m₂ r₂ = commit (m₁ + m₂) (r₁ + r₂) := by
  simp only [commit]; ring

/-- The commitments of a whole crowd add to the commitment of the whole
pledge under the sum of the pads. -/
theorem commit_sum (mv rv : Fin n → Pledge) :
    ∑ i, commit (mv i) (rv i) = commit (∑ i, mv i) (∑ i, rv i) := by
  simp only [commit, Finset.sum_add_distrib]

/-- What the coordinator checks: the published commitments, added up, are the
target plus the opened pad-sum. -/
def Accepts (c : Fin n → Pledge) (M R : Pledge) : Prop := ∑ i, c i = M + R

/-- **Soundness: nobody can inflate the total.**  If the commitments were
honestly formed and the check passes, the pledges really do add up to the
target. -/
theorem soundness {c mv rv : Fin n → Pledge} {M R : Pledge}
    (hc : ∀ i, commit (mv i) (rv i) = c i) (hR : R = ∑ i, rv i)
    (h : Accepts c M R) : ∑ i, mv i = M := by
  have hA : ∑ i, c i = M + R := h
  have h1 : ∀ i, c i = mv i + rv i := fun i => (hc i).symm
  have h2 : ∑ i, c i = ∑ i, mv i + ∑ i, rv i := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => h1 i)
  rw [hA, hR] at h2
  linear_combination -h2

/-- **Privacy: the view fits every split of the total.**  For each way `mv` of
splitting the target between the volunteers there is exactly one pad vector
that produces the commitments the coordinator saw and the pad-sum it was
given. -/
theorem privacy {c : Fin n → Pledge} {M R : Pledge} (h : Accepts c M R)
    (mv : Fin n → Pledge) (hm : ∑ i, mv i = M) :
    ∃! rv : Fin n → Pledge, (∀ i, commit (mv i) (rv i) = c i) ∧ ∑ i, rv i = R := by
  refine ⟨fun i => c i - mv i, ⟨fun i => by simp [commit], ?_⟩, ?_⟩
  · have : ∑ i, (c i - mv i) = (∑ i, c i) - ∑ i, mv i := by
      simp [Finset.sum_sub_distrib]
    have hA : ∑ i, c i = M + R := h
    rw [this, hm, hA]
    ring
  · rintro rv ⟨hrv, -⟩
    funext i
    have := hrv i
    rw [commit] at this
    linear_combination this

/-- **The same statement as an equality of views.**  The set of transcripts the
coordinator can see is exactly the same for two splits of the same total: the
transcript carries the total and nothing else. -/
theorem views_independent_of_split (mv mv' : Fin n → Pledge) (R : Pledge)
    (hmm : ∑ i, mv i = ∑ i, mv' i) :
    {c : Fin n → Pledge | ∃ rv : Fin n → Pledge,
        (∀ i, commit (mv i) (rv i) = c i) ∧ ∑ i, rv i = R} =
    {c : Fin n → Pledge | ∃ rv : Fin n → Pledge,
        (∀ i, commit (mv' i) (rv i) = c i) ∧ ∑ i, rv i = R} := by
  have key : ∀ (u v : Fin n → Pledge), ∑ i, u i = ∑ i, v i →
      ∀ c : Fin n → Pledge,
        (∃ rv : Fin n → Pledge, (∀ i, commit (u i) (rv i) = c i) ∧ ∑ i, rv i = R) →
        (∃ rv : Fin n → Pledge, (∀ i, commit (v i) (rv i) = c i) ∧ ∑ i, rv i = R) := by
    intro u v huv c ⟨rv, hrv, hsum⟩
    refine ⟨fun i => c i - v i, fun i => by simp [commit], ?_⟩
    have hc : ∀ i, c i = u i + rv i := fun i => (hrv i).symm
    have h1 : ∑ i, (c i - v i) = (∑ i, c i) - ∑ i, v i := by
      simp [Finset.sum_sub_distrib]
    have h2 : ∑ i, c i = ∑ i, u i + ∑ i, rv i := by
      rw [← Finset.sum_add_distrib]
      exact Finset.sum_congr rfl (fun i _ => hc i)
    rw [h1, h2, hsum, ← huv]
    ring
  ext c
  exact ⟨key mv mv' hmm c, key mv' mv hmm.symm c⟩

/-! ### Faithfulness: the modular arithmetic really counts hours -/

/-- Two hour-counts smaller than the modulus are equal as pledges only if they
are equal. -/
theorem nat_cast_inj_of_lt {a b : ℕ} (ha : a < Q) (hb : b < Q)
    (h : (a : Pledge) = b) : a = b := by
  have h1 : ((a : Pledge)).val = a := ZMod.val_natCast_of_lt ha
  have h2 : ((b : Pledge)).val = b := ZMod.val_natCast_of_lt hb
  rw [← h1, ← h2, h]

/-- **The hours behind the pledges.**  If there are fewer than a thousand
volunteers, nobody pledges more than forty hours, and the target is a
realistic number of hours, then a check that passes means the crowd really
pledged the target — in hours, not merely modulo `Q`. -/
theorem hours_sound {hrs : Fin n → ℕ} {target : ℕ} (hn : n ≤ 1000)
    (hcap : ∀ i, hrs i ≤ 40) (htarget : target < Q)
    (h : ((∑ i, hrs i : ℕ) : Pledge) = (target : ℕ)) : ∑ i, hrs i = target := by
  have hbound : ∑ i, hrs i ≤ n * 40 := by
    calc ∑ i, hrs i ≤ ∑ _i : Fin n, 40 :=
          Finset.sum_le_sum (fun i _ => hcap i)
      _ = n * 40 := by simp [Finset.sum_const, Finset.card_univ]
  have : ∑ i, hrs i < Q := by
    have : n * 40 ≤ 1000 * 40 := Nat.mul_le_mul_right _ hn
    simp only [Q]
    omega
  exact nat_cast_inj_of_lt this htarget h

/-! ### The barnraising -/

/-- **The zero-knowledge barnraising.**  Twenty-four volunteers each pledge at
most a weekend's work and publish nothing but a masked pledge.  If the
coordinator's check passes then

1. the hours pledged really do add up to the 371 that a LifeTrac takes from the
   ore up (in hours, not merely modulo `Q`) — nobody inflated their share; and
2. every other way of splitting those 371 hours between the twenty-four would
   have produced exactly the transcript the coordinator saw — so it learns the
   total and nothing else.

The second part is stated with `mv'` an arbitrary alternative split. -/
theorem zk_barnraising {hrs : Fin 24 → ℕ} {rv : Fin 24 → Pledge} {c : Fin 24 → Pledge}
    (hcap : ∀ i, hrs i ≤ 16)
    (hc : ∀ i, commit ((hrs i : ℕ) : Pledge) (rv i) = c i)
    (h : Accepts c ((371 : ℕ) : Pledge) (∑ i, rv i)) :
    (∑ i, hrs i = 371) ∧
    ∀ mv' : Fin 24 → Pledge, ∑ i, mv' i = ((371 : ℕ) : Pledge) →
      ∃! rv' : Fin 24 → Pledge,
        (∀ i, commit (mv' i) (rv' i) = c i) ∧ ∑ i, rv' i = ∑ i, rv i := by
  have hsound : ∑ i, ((hrs i : ℕ) : Pledge) = ((371 : ℕ) : Pledge) :=
    soundness hc rfl h
  have hcast : ((∑ i, hrs i : ℕ) : Pledge) = ((371 : ℕ) : Pledge) := by
    rw [Nat.cast_sum]; exact hsound
  refine ⟨hours_sound (by norm_num) (fun i => le_trans (hcap i) (by norm_num))
      (by norm_num [Q]) hcast, ?_⟩
  intro mv' hmv'
  exact privacy h mv' hmv'

/-! ### A worked round, the one printed in the handbook -/

/-- The hours the twenty-four volunteers pledge in the worked example: 371 in
all, nobody over a sixteen-hour weekend. -/
def exampleHours : List ℕ := List.replicate 23 16 ++ [3]

/-- Their secret pads, taken from a fixed arithmetic sequence so that the
example can be checked by hand. -/
def examplePads : List ℕ := (List.range 24).map (fun i => (i * 314159 + 271828) % Q)

/-- What each volunteer publishes. -/
def exampleCommits : List ℕ :=
  (exampleHours.zip examplePads).map (fun (h, r) => (h + r) % Q)

/-- Adding a column of the sheet up, modulo `Q`. -/
def sumMod (l : List ℕ) : ℕ := l.foldl (fun a b => (a + b) % Q) 0

/-- The worked round is a legitimate one: 371 hours, nobody over a weekend. -/
theorem example_round_pledges :
    exampleHours.sum = 371 ∧ exampleHours.length = 24 ∧ ∀ h ∈ exampleHours, h ≤ 16 := by
  refine ⟨by decide, by decide, by decide⟩

/-- **And it passes the check.**  The published column adds up to the target
plus the pad column, modulo `Q`. -/
theorem example_round_checks :
    sumMod exampleCommits = (371 + sumMod examplePads) % Q := by
  decide

/-- **What a share in a barnraising costs.**  Twenty-four people, thirty-seven
jars of honey and one sixteen-hour weekend apiece: that covers the material of
a machine built from the ground up and the labour to build it.  The same
tractor from a dealer is more than eighty-five such shares
(`Barter.the_price_in_honey`: 3167 jars against 37). -/
theorem a_share_in_a_barnraising :
    Barter.jars Ownership.groundPrice ≤ 24 * 37 ∧
    bootstrapLabour ≤ 24 * 16 ∧
    85 * 37 < Barter.jars Ownership.dealerPrice := by
  refine ⟨?_, ?_, ?_⟩
  · rw [Barter.the_price_in_honey.2.2.2]; norm_num
  · rw [bootstrapLabour]; norm_num
  · rw [Barter.the_price_in_honey.1]; norm_num

/-- The hours the crowd verified are enough: 371 hours cover the machine, and
twenty-four weekends are 384. -/
theorem the_crowd_is_enough :
    Workflow.plant.laborFor Workflow.Item.lifeTrac 1 ≤ (371 : ℚ) ∧
    (371 : ℚ) ≤ 24 * 16 :=
  ⟨labour_le_371, by norm_num⟩

end Barnraising
end LifeTrac
