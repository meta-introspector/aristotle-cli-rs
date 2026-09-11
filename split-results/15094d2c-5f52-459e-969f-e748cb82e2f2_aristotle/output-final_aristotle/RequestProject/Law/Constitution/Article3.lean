import Mathlib
import RequestProject.Law.CodeStructure
import RequestProject.Law.Constitution.Article1

/-!
# Article III of the United States Constitution — The Judicial Power

Article III vests the judicial power, fixes the tenure of federal judges
("good Behaviour", § 1), confines that power to "Cases" and "Controversies"
(§ 2) — the textual root of the modern **standing** doctrine — and gives the
exclusive constitutional definition of **treason** with its two-witness rule
(§ 3).

We model the dispositive facts as records and prove the structural guarantees:

* **Standing** — the irreducible constitutional minimum of injury-in-fact,
  causation, and redressability (Art. III, § 2).
* **Good-behaviour tenure** — an Article III judge is removed only upon
  impeachment *and* conviction, never at will (§ 1).
* **Treason** — conviction requires the testimony of two witnesses to the same
  overt act, or a confession in open court (§ 3).
-/

namespace Law.Constitution.Article3

open Law

/-! ## § 2 — Case or Controversy and the standing doctrine

> The judicial Power shall extend to all Cases ... [and] to Controversies ...

The "irreducible constitutional minimum of standing" (Art. III, § 2) has three
elements: a concrete and particularized **injury in fact**, a **causal**
connection traceable to the defendant's conduct, and a likelihood that the
injury will be **redressed** by a favorable decision. -/

/-- The three constitutional elements of standing, as facts about a plaintiff. -/
structure StandingFacts where
  /-- A concrete, particularized, actual or imminent injury in fact. -/
  injuryInFact : Bool
  /-- The injury is fairly traceable to the defendant's challenged conduct. -/
  causation : Bool
  /-- It is likely the injury will be redressed by a favorable decision. -/
  redressability : Bool
deriving DecidableEq, Repr

/-- Art. III standing: a plaintiff has standing iff all three elements are met. -/
def StandingFacts.hasStanding (s : StandingFacts) : Prop :=
  s.injuryInFact = true ∧ s.causation = true ∧ s.redressability = true

/-- A plaintiff satisfying all three elements has standing. -/
theorem standing_of_all_elements :
    (StandingFacts.mk true true true).hasStanding := ⟨rfl, rfl, rfl⟩

/-- No injury in fact ⇒ no standing (a generalized grievance is not enough). -/
theorem no_standing_without_injury (s : StandingFacts)
    (h : s.injuryInFact = false) : ¬ s.hasStanding := by
  rintro ⟨hi, _, _⟩
  rw [h] at hi
  exact Bool.noConfusion hi

/-- No redressability ⇒ no standing. -/
theorem no_standing_without_redressability (s : StandingFacts)
    (h : s.redressability = false) : ¬ s.hasStanding := by
  rintro ⟨_, _, hr⟩
  rw [h] at hr
  exact Bool.noConfusion hr

/-- No causation ⇒ no standing (a self-inflicted or third-party injury). -/
theorem no_standing_without_causation (s : StandingFacts)
    (h : s.causation = false) : ¬ s.hasStanding := by
  rintro ⟨_, hc, _⟩
  rw [h] at hc
  exact Bool.noConfusion hc

/-- A federal court may exercise the judicial power over a matter only if the
plaintiff has Article III standing; we record justiciability as that minimum. -/
def justiciable (s : StandingFacts) : Prop := s.hasStanding

theorem nonjusticiable_without_injury (s : StandingFacts)
    (h : s.injuryInFact = false) : ¬ justiciable s :=
  no_standing_without_injury s h

/-! ## § 1 — Good-behaviour tenure

> The Judges, both of the supreme and inferior Courts, shall hold their Offices
> during good Behaviour ...

An Article III judge does not serve at the pleasure of any branch: removal
occurs only through the impeachment process — impeachment by the House *and*
conviction by the Senate. -/

/-- The facts bearing on removal of an Article III judge. -/
structure JudicialTenure where
  /-- The House impeached the judge. -/
  impeachedByHouse : Bool
  /-- The Senate convicted the judge on the impeachment. -/
  convictedBySenate : Bool
deriving DecidableEq, Repr

/-- An Article III judge is removed iff impeached by the House *and* convicted by
the Senate ("good Behaviour" tenure). -/
def JudicialTenure.removed (j : JudicialTenure) : Prop :=
  j.impeachedByHouse = true ∧ j.convictedBySenate = true

/-- A judge who is not convicted by the Senate is not removed, even if impeached:
tenure is protected absent a Senate conviction. -/
theorem not_removed_without_conviction (j : JudicialTenure)
    (h : j.convictedBySenate = false) : ¬ j.removed := by
  rintro ⟨_, hc⟩
  rw [h] at hc
  exact Bool.noConfusion hc

/-- A judge against whom the House has taken no impeachment cannot be removed. -/
theorem not_removed_without_impeachment (j : JudicialTenure)
    (h : j.impeachedByHouse = false) : ¬ j.removed := by
  rintro ⟨hi, _⟩
  rw [h] at hi
  exact Bool.noConfusion hi

/-- Removal upon impeachment and conviction. -/
theorem removed_on_impeachment_and_conviction (j : JudicialTenure)
    (hi : j.impeachedByHouse = true) (hc : j.convictedBySenate = true) :
    j.removed := ⟨hi, hc⟩

/-! ## § 3 — Treason

> Treason against the United States, shall consist only in levying War against
> them, or in adhering to their Enemies, giving them Aid and Comfort. No Person
> shall be convicted of Treason unless on the Testimony of two Witnesses to the
> same overt Act, or on Confession in open Court. -/

/-- The two constitutionally exclusive forms of the treasonous act (§ 3). -/
inductive TreasonousAct
  /-- Levying war against the United States. -/
  | levyingWar
  /-- Adhering to their enemies, giving them aid and comfort. -/
  | adheringToEnemies
deriving DecidableEq, Repr, Fintype

/-- The record bearing on a treason conviction. -/
structure TreasonCase where
  /-- The number of witnesses to the same overt act. -/
  witnessesToSameOvertAct : Nat
  /-- Whether the defendant confessed in open court. -/
  confessionInOpenCourt : Bool
deriving DecidableEq, Repr

/-- § 3: a treason conviction is constitutionally permissible iff there is the
testimony of two witnesses to the same overt act, or a confession in open
court. -/
def TreasonCase.convictionPermitted (c : TreasonCase) : Prop :=
  c.witnessesToSameOvertAct ≥ 2 ∨ c.confessionInOpenCourt = true

/-- A single witness, absent a confession, cannot support a treason conviction. -/
theorem one_witness_insufficient (c : TreasonCase)
    (hw : c.witnessesToSameOvertAct ≤ 1)
    (hconf : c.confessionInOpenCourt = false) :
    ¬ c.convictionPermitted := by
  rintro (h | h)
  · omega
  · rw [hconf] at h; exact Bool.noConfusion h

/-- Two witnesses to the same overt act suffice. -/
theorem two_witnesses_suffice (c : TreasonCase)
    (hw : c.witnessesToSameOvertAct ≥ 2) : c.convictionPermitted :=
  Or.inl hw

/-- A confession in open court suffices. -/
theorem confession_suffices (c : TreasonCase)
    (hconf : c.confessionInOpenCourt = true) : c.convictionPermitted :=
  Or.inr hconf

/-! ## Content addresses of the cited Article III sections

Article III is placed at the constitutional pseudo-title `0`, chapter `3`. -/

/-- A citation to Article III, § `s`, in the content-addressing spine. -/
def cite (s : Nat) : USCCitation := ⟨0, 3, s⟩

theorem article3_sections_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro habs
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective habs))

/-- The three constitutional articles occupy distinct chapters of the content
address space (Article I = chapter 1, II = 2, III = 3), so e.g. an Article I and
an Article III citation to the same section number are never confused. -/
theorem articles_distinct_chapters (s : Nat) :
    (Article1.cite s).address ≠ (cite s).address := by
  intro habs
  have := USCCitation.address_injective habs
  simp [Article1.cite, cite] at this

end Law.Constitution.Article3
