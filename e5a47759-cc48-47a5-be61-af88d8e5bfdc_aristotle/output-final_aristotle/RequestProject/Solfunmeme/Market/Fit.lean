/-
# Tolerances: when "connects" means "fits"

`RequestProject/Market/Twin.lean` checks that component A may legally connect to
B, but only structurally: interfaces are opaque identifiers, so "connects" means
"the names match".  The scope note of `SENATE-REPORT-VAICU.md` says so:

> The digital-twin model is structural only.  Interfaces and guarantees are
> opaque identifiers.  Nothing about geometry, tolerances, timing or physics is
> modelled, so "legally connect" here means interface closure, not fit.

This file puts one dimension of physics in: every port carries a **tolerance
interval**, a shaft fits a hole only if the worst case fits, and a machine is
closed only if every requirement is met by a port that actually fits it.  The
same interval arithmetic does duty for **timing**: a chain of stages meets a
deadline exactly when the worst-case delays sum below it.

What is proved:

* `fits_iff_worst_case` — a shaft fits a hole for *every* pair of actual
  manufactured sizes exactly when the largest shaft clears the smallest hole:
  design by worst case is not conservatism, it is the criterion;
* `clearance_bounds` — the clearance of any actual pair lies between the two
  extremes the tolerances allow;
* `fits_of_tighter_shaft`, `fits_of_wider_hole` — tightening a part or loosening
  a seat keeps a fit;
* `sum_mem`, `width_sum` — **tolerance stack-up**: errors add, and the width of
  a chain is the sum of the widths;
* `stack_within_iff` — a chain stays inside a budget exactly when its worst case
  does; `deadline_met_iff` is the same statement read as timing;
* `fitClosed_substitute` — the twin's substitution theorem, now with physics: a
  replacement part whose shafts are no larger and whose seats are no fussier
  keeps the machine assemblable;
* `closed_of_fitClosed` — fit closure implies the structural closure of
  `Twin.lean`, so this is a refinement of the old check and not a different one.
-/
import Mathlib
import RequestProject.Solfunmeme.Market.Twin

namespace RequestProject.Market

/-! ## Tolerance intervals -/

/-- A dimension with its manufacturing tolerance: everything between `lo` and
`hi` may come out of the factory. -/
structure Tol where
  /-- The smallest size the part may have. -/
  lo : ℚ
  /-- The largest size the part may have. -/
  hi : ℚ
  deriving DecidableEq, Repr

namespace Tol

/-- An actual manufactured size the tolerance allows. -/
def Mem (t : Tol) (x : ℚ) : Prop := t.lo ≤ x ∧ x ≤ t.hi

instance : Membership ℚ Tol := ⟨fun t x => t.Mem x⟩

theorem mem_def {t : Tol} {x : ℚ} : x ∈ t ↔ t.lo ≤ x ∧ x ≤ t.hi := Iff.rfl

/-- A tolerance is realisable when it is not empty. -/
def Valid (t : Tol) : Prop := t.lo ≤ t.hi

theorem lo_mem {t : Tol} (h : t.Valid) : t.lo ∈ t := ⟨le_refl _, h⟩

theorem hi_mem {t : Tol} (h : t.Valid) : t.hi ∈ t := ⟨h, le_refl _⟩

/-- How much the size may vary. -/
def width (t : Tol) : ℚ := t.hi - t.lo

/-- One tolerance is contained in another: a tighter part. -/
def Sub (a b : Tol) : Prop := b.lo ≤ a.lo ∧ a.hi ≤ b.hi

theorem mem_of_sub {a b : Tol} (h : Sub a b) {x : ℚ} (hx : x ∈ a) : x ∈ b :=
  ⟨le_trans h.1 hx.1, le_trans hx.2 h.2⟩

/-- Stack two tolerances in series: the errors add. -/
def add (a b : Tol) : Tol := ⟨a.lo + b.lo, a.hi + b.hi⟩

/-- Stack a chain of tolerances. -/
def sum : List Tol → Tol
  | [] => ⟨0, 0⟩
  | t :: rest => t.add (sum rest)

end Tol

/-! ## Fit -/

/-- A hole `h` accepts a shaft `s` when the worst case clears: the largest shaft
still passes the smallest hole. -/
def Accepts (h s : Tol) : Prop := s.hi ≤ h.lo

/-- **Worst-case design is exactly right.**  Every manufactured shaft passes
every manufactured hole precisely when the largest shaft clears the smallest
hole — no more conservative than necessary, and no less. -/
theorem fits_iff_worst_case {h s : Tol} (hh : h.Valid) (hs : s.Valid) :
    (∀ x ∈ s, ∀ y ∈ h, x ≤ y) ↔ Accepts h s := by
  constructor
  · intro hall
    exact hall s.hi (Tol.hi_mem hs) h.lo (Tol.lo_mem hh)
  · intro hfit x hx y hy
    exact le_trans hx.2 (le_trans hfit hy.1)

/-- The clearance of any actual pair lies between the two extremes the
tolerances allow. -/
theorem clearance_bounds {h s : Tol} {x y : ℚ} (hx : x ∈ s) (hy : y ∈ h) :
    h.lo - s.hi ≤ y - x ∧ y - x ≤ h.hi - s.lo := by
  obtain ⟨hx1, hx2⟩ := hx
  obtain ⟨hy1, hy2⟩ := hy
  constructor <;> linarith

/-- A tighter shaft still fits. -/
theorem fits_of_tighter_shaft {h s s' : Tol} (hfit : Accepts h s) (hsub : s'.hi ≤ s.hi) :
    Accepts h s' := le_trans hsub hfit

/-- A more generous seat still accepts. -/
theorem fits_of_wider_hole {h h' s : Tol} (hfit : Accepts h s) (hwide : h.lo ≤ h'.lo) :
    Accepts h' s := le_trans hfit hwide

/-- A part inside the tolerance of one that fitted, fits. -/
theorem fits_of_sub {h s s' : Tol} (hfit : Accepts h s) (hsub : Tol.Sub s' s) :
    Accepts h s' := fits_of_tighter_shaft hfit hsub.2

/-! ## Tolerance stack-up, and the same arithmetic for timing -/

/-- Errors add along a chain. -/
theorem add_mem {a b : Tol} {x y : ℚ} (hx : x ∈ a) (hy : y ∈ b) : x + y ∈ a.add b := by
  obtain ⟨hx1, hx2⟩ := hx
  obtain ⟨hy1, hy2⟩ := hy
  exact ⟨by simpa [Tol.add] using add_le_add hx1 hy1, by simpa [Tol.add] using add_le_add hx2 hy2⟩

/-- The width of a stack of two is the sum of the widths. -/
theorem width_add (a b : Tol) : (a.add b).width = a.width + b.width := by
  simp [Tol.add, Tol.width]
  ring

/-- Choosing one actual size per stage of a chain lands in the stacked
tolerance. -/
theorem sum_mem : ∀ {l : List Tol} {xs : List ℚ}, List.Forall₂ (· ∈ ·) xs l →
    xs.sum ∈ Tol.sum l
  | [], [], _ => ⟨le_refl _, le_refl _⟩
  | t :: rest, x :: xsrest, h => by
      obtain ⟨hx, hrest⟩ := List.forall₂_cons.mp h
      exact add_mem hx (sum_mem hrest)

/-- **Tolerance stack-up.**  The width of a chain is the sum of the widths of
its stages: precision is spent, not preserved. -/
theorem width_sum : ∀ l : List Tol, (Tol.sum l).width = (l.map Tol.width).sum
  | [] => by simp [Tol.sum, Tol.width]
  | t :: rest => by
      simp [Tol.sum, width_add, width_sum rest]

/-- A chain stays inside a budget exactly when its worst case does. -/
theorem stack_within_iff (l : List Tol) (budget : Tol) :
    Tol.Sub (Tol.sum l) budget ↔ budget.lo ≤ (Tol.sum l).lo ∧ (Tol.sum l).hi ≤ budget.hi :=
  Iff.rfl

/-- The worst case of a chain is the sum of the worst cases. -/
theorem sum_hi : ∀ l : List Tol, (Tol.sum l).hi = (l.map Tol.hi).sum
  | [] => by simp [Tol.sum]
  | t :: rest => by simp [Tol.sum, Tol.add, sum_hi rest]

/-- **Timing is the same arithmetic.**  Reading each `Tol` as the range of a
stage's delay, a pipeline of realisable stages meets its deadline on every
actual run exactly when the worst-case delays sum below the deadline. -/
theorem deadline_met_iff (l : List Tol) (hv : ∀ t ∈ l, t.Valid) (deadline : ℚ) :
    (∀ xs : List ℚ, List.Forall₂ (· ∈ ·) xs l → xs.sum ≤ deadline) ↔
      (Tol.sum l).hi ≤ deadline := by
  constructor
  · intro hall
    have hforall : List.Forall₂ (· ∈ ·) (l.map Tol.hi) l := by
      clear hall
      induction l with
      | nil => exact List.Forall₂.nil
      | cons t rest ih =>
          exact List.Forall₂.cons (Tol.hi_mem (hv t (List.mem_cons_self ..)))
            (ih fun s hs => hv s (List.mem_cons_of_mem _ hs))
    have := hall (l.map Tol.hi) hforall
    rwa [sum_hi l]
  · intro hw xs hxs
    exact le_trans (sum_mem hxs).2 hw

/-! ## Machines whose parts have to fit

A port is an interface with a size.  A part publishes the ports it offers and
the seats it needs; the machine is *fit-closed* when every seat is filled by a
port that actually fits it. -/

/-- An interface with a dimension. -/
structure Port where
  /-- Which interface this port belongs to. -/
  iface : Nat
  /-- The dimension, with its tolerance. -/
  tol : Tol
  deriving DecidableEq, Repr

/-- A part with physical ports: the shafts it offers and the seats it needs. -/
structure FitPart where
  /-- Identifier of the part. -/
  id : Nat
  /-- The ports it offers, as shafts. -/
  ports : List Port
  /-- The seats it needs filled, as holes. -/
  needs : List Port
  deriving DecidableEq, Repr

/-- A machine whose parts have sizes. -/
structure FitMachine where
  /-- The parts, with multiplicity. -/
  parts : List FitPart

namespace FitMachine

/-- Every seat of every part is filled by a port of the machine that matches the
interface *and* fits it. -/
def FitClosed (m : FitMachine) : Prop :=
  ∀ c ∈ m.parts, ∀ p ∈ c.needs, ∃ c' ∈ m.parts, ∃ q ∈ c'.ports,
    q.iface = p.iface ∧ Accepts p.tol q.tol

/-- Replace every occurrence of one part by another. -/
def substitute (m : FitMachine) (old new : FitPart) : FitMachine :=
  ⟨m.parts.map fun c => if c = old then new else c⟩

/-- Forget the sizes: the structural bill of materials of `Twin.lean`. -/
def toAssembly (m : FitMachine) : Assembly :=
  ⟨m.parts.map fun c =>
    ⟨c.id, (c.ports.map Port.iface).toFinset, (c.needs.map Port.iface).toFinset, ∅⟩⟩

/-- **Fit is a refinement of the structural check.**  A machine whose seats are
all filled by ports that fit is in particular closed in the sense of
`Twin.lean`: physics never makes a machine connect that the interface check
rejects. -/
theorem closed_of_fitClosed (m : FitMachine) (h : m.FitClosed) : m.toAssembly.Closed := by
  intro i hi
  -- unfold the union of required interfaces
  have hreq : ∀ (l : List FitPart), i ∈ Assembly.unions
      (l.map fun c => ((c.needs.map Port.iface).toFinset)) →
      ∃ c ∈ l, ∃ p ∈ c.needs, p.iface = i := by
    intro l
    induction l with
    | nil => simp [Assembly.unions]
    | cons c rest ih =>
        intro hmem
        simp only [List.map_cons, Assembly.unions, Finset.mem_union] at hmem
        rcases hmem with hc | hrest
        · simp only [List.mem_toFinset, List.mem_map] at hc
          obtain ⟨p, hp, hpi⟩ := hc
          exact ⟨c, List.mem_cons_self .., p, hp, hpi⟩
        · obtain ⟨c', hc', p, hp, hpi⟩ := ih hrest
          exact ⟨c', List.mem_cons_of_mem _ hc', p, hp, hpi⟩
  have hprov : ∀ (l : List FitPart) (c' : FitPart), c' ∈ l → ∀ q ∈ c'.ports,
      q.iface ∈ Assembly.unions (l.map fun c => ((c.ports.map Port.iface).toFinset)) := by
    intro l
    induction l with
    | nil => simp
    | cons c rest ih =>
        intro c' hc' q hq
        simp only [List.map_cons, Assembly.unions, Finset.mem_union]
        rcases List.mem_cons.1 hc' with rfl | hrest
        · left
          simp only [List.mem_toFinset, List.mem_map]
          exact ⟨q, hq, rfl⟩
        · exact Or.inr (ih c' hrest q hq)
  simp only [toAssembly, Assembly.required, List.map_map, Function.comp_def] at hi
  obtain ⟨c, hc, p, hp, hpi⟩ := hreq m.parts hi
  obtain ⟨c', hc', q, hq, hqi, _⟩ := h c hc p hp
  simp only [toAssembly, Assembly.provided, List.map_map, Function.comp_def]
  have := hprov m.parts c' hc' q hq
  rwa [hqi, hpi] at this

end FitMachine

/-- A legal physical replacement: every port the old part offered is matched by
one of the new part's ports, no larger; and every seat the new part needs was
already needed by the old part, no fussier. -/
structure FitRefines (new old : FitPart) : Prop where
  /-- The new part offers each old port, with a shaft no larger. -/
  ports : ∀ p ∈ old.ports, ∃ q ∈ new.ports, q.iface = p.iface ∧ q.tol.hi ≤ p.tol.hi
  /-- Every seat the new part needs was needed before, and is no fussier. -/
  needs : ∀ p ∈ new.needs, ∃ o ∈ old.needs, o.iface = p.iface ∧ o.tol.lo ≤ p.tol.lo

namespace FitMachine

/-- **Substitution with physics.**  Swapping a part for a legal physical
replacement keeps the machine assemblable: every seat is still filled by a port
that fits it.  This is `Assembly.closed_substitute` of `Twin.lean` with the
tolerances carried along. -/
theorem fitClosed_substitute (m : FitMachine) (old new : FitPart)
    (hclosed : m.FitClosed) (href : FitRefines new old) :
    (m.substitute old new).FitClosed := by
  -- a port of the old machine survives, possibly tightened
  have hsurv : ∀ c' ∈ m.parts, ∀ q ∈ c'.ports,
      ∃ d ∈ (m.substitute old new).parts, ∃ r ∈ d.ports,
        r.iface = q.iface ∧ r.tol.hi ≤ q.tol.hi := by
    intro c' hc' q hq
    by_cases hold : c' = old
    · subst hold
      obtain ⟨r, hr, hri, hrt⟩ := href.ports q hq
      refine ⟨new, ?_, r, hr, hri, hrt⟩
      exact List.mem_map.2 ⟨c', hc', by simp⟩
    · refine ⟨c', ?_, q, hq, rfl, le_refl _⟩
      exact List.mem_map.2 ⟨c', hc', by simp [hold]⟩
  intro c hc p hp
  -- the seat `p` of the new machine comes from a seat of the old one
  obtain ⟨c₀, hc₀, hcc⟩ := List.mem_map.1 hc
  have hseat : ∃ c₁ ∈ m.parts, ∃ p₁ ∈ c₁.needs, p₁.iface = p.iface ∧ p₁.tol.lo ≤ p.tol.lo := by
    by_cases hold : c₀ = old
    · have hcnew : c = new := by rw [← hcc, if_pos hold]
      rw [hcnew] at hp
      obtain ⟨o, ho, hoi, hot⟩ := href.needs p hp
      exact ⟨old, hold ▸ hc₀, o, ho, hoi, hot⟩
    · have hc0 : c = c₀ := by rw [← hcc, if_neg hold]
      rw [hc0] at hp
      exact ⟨c₀, hc₀, p, hp, rfl, le_refl _⟩
  obtain ⟨c₁, hc₁, p₁, hp₁, hpi, hpl⟩ := hseat
  obtain ⟨c', hc', q, hq, hqi, hfit⟩ := hclosed c₁ hc₁ p₁ hp₁
  obtain ⟨d, hd, r, hr, hri, hrt⟩ := hsurv c' hc' q hq
  refine ⟨d, hd, r, hr, by rw [hri, hqi, hpi], ?_⟩
  exact le_trans hrt (le_trans hfit hpl)

end FitMachine

/-! ## Worked examples, so none of this is vacuous -/

/-- A shaft of 9.98–10.00 mm. -/
def shaft : Tol := ⟨998/100, 10⟩

/-- A seat of 10.01–10.05 mm. -/
def seat : Tol := ⟨1001/100, 1005/100⟩

/-- They fit, with 0.01 mm to spare in the worst case. -/
example : Accepts seat shaft := by norm_num [Accepts, shaft, seat]

/-- A shaft made 0.05 mm oversize does not. -/
example : ¬ Accepts seat ⟨1003/100, 1005/100⟩ := by norm_num [Accepts, seat]

/-- Three stages of ±0.02 stack to ±0.06: precision is spent. -/
example : (Tol.sum [⟨-2/100, 2/100⟩, ⟨-2/100, 2/100⟩, ⟨-2/100, 2/100⟩]).width = 12/100 := by
  norm_num [Tol.sum, Tol.add, Tol.width]

/-- A pipeline of three stages taking 1–2, 2–5 and 1–1 units meets a deadline of
8 but not of 7. -/
example : (Tol.sum [⟨1, 2⟩, ⟨2, 5⟩, ⟨1, 1⟩]).hi = 8 := by norm_num [Tol.sum, Tol.add]

/-- A pump with a 10 mm shaft, needing a 20 mm mount. -/
def pumpPart : FitPart := ⟨1, [⟨30, shaft⟩], [⟨20, ⟨1998/100, 2002/100⟩⟩]⟩

/-- The rig that mounts it, offering a 19.90–19.95 mm spigot. -/
def rigPart : FitPart := ⟨2, [⟨20, ⟨1990/100, 1995/100⟩⟩], []⟩

/-- The machine is fit-closed: the rig's spigot really does enter the pump's
mount. -/
example : (FitMachine.mk [pumpPart, rigPart]).FitClosed := by
  intro c hc p hp
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hc
  rcases hc with rfl | rfl
  · simp only [pumpPart, List.mem_cons, List.not_mem_nil, or_false] at hp
    subst hp
    refine ⟨rigPart, by simp, ⟨20, ⟨1990/100, 1995/100⟩⟩, by simp [rigPart], rfl, ?_⟩
    norm_num [Accepts]
  · simp [rigPart] at hp

/-- A second-source pump with a tighter shaft and a wider mount — one that
accepts spigots up to 20.05 mm rather than 19.98 mm — is a legal physical
replacement. -/
def betterPumpPart : FitPart := ⟨3, [⟨30, ⟨9985/1000, 9995/1000⟩⟩], [⟨20, ⟨2005/100, 2010/100⟩⟩]⟩

example : FitRefines betterPumpPart pumpPart := by
  constructor
  · intro p hp
    simp only [pumpPart, List.mem_cons, List.not_mem_nil, or_false] at hp
    subst hp
    exact ⟨⟨30, ⟨9985/1000, 9995/1000⟩⟩, by simp [betterPumpPart], rfl, by norm_num [shaft]⟩
  · intro p hp
    simp only [betterPumpPart, List.mem_cons, List.not_mem_nil, or_false] at hp
    subst hp
    exact ⟨⟨20, ⟨1998/100, 2002/100⟩⟩, by norm_num [pumpPart], rfl, by norm_num⟩

end RequestProject.Market
