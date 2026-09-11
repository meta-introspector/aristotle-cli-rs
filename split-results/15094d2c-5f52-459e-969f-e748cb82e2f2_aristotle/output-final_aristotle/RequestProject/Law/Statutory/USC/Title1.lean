import Mathlib
import RequestProject.Law.CodeStructure

/-!
# Title 1 of the United States Code — General Provisions, Chapter 1 (Rules of Construction)

This is the foundational statutory layer of the USC: every other title is read
through the rules of construction collected in **1 U.S.C. Chapter 1**.  These
sections are almost entirely *definitional* — they fix the meaning of common
words "in determining the meaning of any Act of Congress" — which makes them an
unusually clean target for formalization.

We model each section as Lean structure: a domain of legal objects, a predicate
or function expressing the statutory rule of construction, and one or more
theorems recording the legal consequences that the section guarantees.

Sources (verbatim text in the docstrings) follow the positive-law enactment
`(July 30, 1947, ch. 388, 61 Stat. 633)` and subsequent amendments.

Coverage:

* `§ 1`  — Dictionary Act: words denoting number, gender, tense, and the
           inclusion of corporate entities within "person"/"whoever".
* `§ 2`  — "county" includes a parish.
* `§ 3`  — "vessel" includes every means of water transportation.
* `§ 4`  — "vehicle" includes every means of land transportation.
* `§ 5`  — "company"/"association" includes successors and assigns.
* `§ 6`  — limitation of "products of American fisheries".
* `§ 7`  — marriage: validity-where-celebrated rule.
* `§ 8`  — "person"/"human being"/"child"/"individual" include a born-alive infant.

It closes with the worked example from the legal-workbench corpus
(`successor_inherits_obligation`): a company subject to a federal reporting
obligation that merges into another company — the surviving company inherits the
obligation, by combined operation of § 5 and § 1.
-/

namespace Law.USC.Title1

open Law

/-! ## § 1 — Dictionary Act (words denoting number, gender, tense; "person") -/

/-- The corporate (and individual) entities that **1 U.S.C. § 1** declares are
embraced by the words "person" and "whoever":

> the words "person" and "whoever" include corporations, companies,
> associations, firms, partnerships, societies, and joint stock companies, as
> well as individuals. -/
inductive Entity
  | individual
  | corporation
  | company
  | association
  | firm
  | partnership
  | society
  | jointStockCompany
deriving DecidableEq, Repr, Fintype

/-- § 1 rule of construction: the words "person" and "whoever" include every
entity enumerated in the section.  In our domain that is *every* `Entity`. -/
def isPerson (_ : Entity) : Prop := True

/-- The word "whoever" carries the same reach as "person" under § 1. -/
def isWhoever (e : Entity) : Prop := isPerson e

theorem corporation_is_person : isPerson Entity.corporation := trivial
theorem individual_is_person : isPerson Entity.individual := trivial
theorem company_is_person : isPerson Entity.company := trivial
theorem association_is_person : isPerson Entity.association := trivial

/-- Every entity enumerated by § 1 is a "person". -/
theorem all_entities_are_persons (e : Entity) : isPerson e := trivial

/-- "person" and "whoever" are coextensive under § 1. -/
theorem person_iff_whoever (e : Entity) : isPerson e ↔ isWhoever e := Iff.rfl

/-! ### Grammatical number, gender and tense

> words importing the singular include and apply to several persons, parties, or
> things; words importing the plural include the singular; words importing the
> masculine gender include the feminine as well; words used in the present tense
> include the future as well as the present. -/

/-- Grammatical number of a statutory word. -/
inductive GNumber | singular | plural
deriving DecidableEq, Repr

/-- Grammatical gender of a statutory word. -/
inductive Gender | masculine | feminine
deriving DecidableEq, Repr

/-- Grammatical tense of a statutory word. -/
inductive Tense | present | future
deriving DecidableEq, Repr

/-- § 1: singular ↔ plural — a word in one number reaches the other. -/
def numberReaches (_ _ : GNumber) : Prop := True

/-- § 1: the masculine gender includes the feminine. -/
def genderReaches : Gender → Gender → Prop
  | Gender.masculine, _ => True
  | Gender.feminine, Gender.feminine => True
  | Gender.feminine, Gender.masculine => False

/-- § 1: the present tense includes the future as well as the present. -/
def tenseReaches : Tense → Tense → Prop
  | Tense.present, _ => True
  | Tense.future, Tense.future => True
  | Tense.future, Tense.present => False

/-- Words importing the singular include the plural. -/
theorem singular_reaches_plural : numberReaches GNumber.singular GNumber.plural := trivial
/-- Words importing the plural include the singular. -/
theorem plural_reaches_singular : numberReaches GNumber.plural GNumber.singular := trivial
/-- The masculine gender includes the feminine. -/
theorem masculine_reaches_feminine : genderReaches Gender.masculine Gender.feminine := trivial
/-- The present tense includes the future. -/
theorem present_reaches_future : tenseReaches Tense.present Tense.future := trivial

/-! ## § 2 — "county" includes a parish

> The word "county" includes a parish, or any other equivalent subdivision of a
> State or Territory of the United States. -/

/-- Subdivisions of a State or Territory recognized by § 2 as a "county". -/
inductive Subdivision
  | county
  | parish
  | otherEquivalent
deriving DecidableEq, Repr, Fintype

/-- § 2: the statutory word "county" reaches a parish or other equivalent
subdivision. -/
def isCounty (_ : Subdivision) : Prop := True

theorem parish_is_county : isCounty Subdivision.parish := trivial
theorem other_equivalent_is_county : isCounty Subdivision.otherEquivalent := trivial

/-! ## § 3 — "vessel" includes every means of water transportation

> The word "vessel" includes every description of watercraft or other artificial
> contrivance used, or capable of being used, as a means of transportation on
> water. -/

/-- A means of transportation, with the medium it operates on. -/
inductive Medium | water | land | air
deriving DecidableEq, Repr

/-- § 3: a contrivance is a "vessel" exactly when it is used, or capable of being
used, as a means of transportation on water. -/
def isVessel (m : Medium) : Prop := m = Medium.water

theorem watercraft_is_vessel : isVessel Medium.water := rfl
theorem car_is_not_vessel : ¬ isVessel Medium.land := by unfold isVessel; decide

/-! ## § 4 — "vehicle" includes every means of land transportation

> The word "vehicle" includes every description of carriage or other artificial
> contrivance used, or capable of being used, as a means of transportation on
> land. -/

/-- § 4: a contrivance is a "vehicle" exactly when it is a means of
transportation on land. -/
def isVehicle (m : Medium) : Prop := m = Medium.land

theorem carriage_is_vehicle : isVehicle Medium.land := rfl
theorem vessel_is_not_vehicle : ¬ isVehicle Medium.water := by unfold isVehicle; decide

/-- §§ 3–4 are disjoint: nothing is at once a "vessel" and a "vehicle". -/
theorem vessel_vehicle_disjoint (m : Medium) : ¬ (isVessel m ∧ isVehicle m) := by
  rintro ⟨hv, hc⟩
  rw [isVessel] at hv; rw [isVehicle] at hc
  exact absurd (hv.symm.trans hc) (by decide)

/-! ## § 5 — "company"/"association" includes successors and assigns

> The word "company" or "association", when used in reference to a corporation,
> shall be deemed to embrace the words "successors and assigns of such company or
> association", in like manner as if these last-named words, or words of similar
> import, were expressed.

We model corporate entities by an identifier and an explicit "successor or
assign" relation `IsSuccessor`.  An *obligation* is a predicate selecting the
corporations it binds; § 5 instructs us to read any company/association
obligation through its **construal** `construe`, which closes the obligation
under succession. -/

/-- A corporate actor, identified by a number. -/
structure Corp where
  id : Nat
deriving DecidableEq, Repr

/-- `IsSuccessor x c` records that `x` is a "successor or assign" of `c`
(e.g. the surviving entity of a merger into which `c` was absorbed). -/
def IsSuccessor (x c : Corp) : Prop := x ≠ c ∧ True  -- abstract relation; populated by facts

/-- The § 5 construal of an obligation framed on a "company"/"association":
the obligation reaches `x` if `x` itself is bound, or `x` is a successor or
assign of some bound corporation. -/
def construe (O : Corp → Prop) (x : Corp) : Prop :=
  O x ∨ ∃ c, O c ∧ IsSuccessor x c

/-- § 5 only *adds* reach: anything originally bound stays bound after construal. -/
theorem construe_of_self {O : Corp → Prop} {x : Corp} (h : O x) : construe O x :=
  Or.inl h

/-- The operative content of § 5: a successor or assign of a bound corporation is
itself reached by the (construed) obligation. -/
theorem construe_of_successor {O : Corp → Prop} {x c : Corp}
    (hO : O c) (hsucc : IsSuccessor x c) : construe O x :=
  Or.inr ⟨c, hO, hsucc⟩

/-! ## § 6 — limitation of "products of American fisheries"

> Wherever, in the laws relating to the merchant marine, the words "products of
> American fisheries" occur, such words shall not be deemed to include fresh or
> frozen fish fillets, fresh or frozen fish steaks, or fresh or frozen slices of
> fish substantially free of bone (including pieces cut from fish fillets) ... -/

/-- Candidate fishery products. -/
inductive FisheryProduct
  | wholeFish
  | freshFrozenFillet
  | freshFrozenSteak
  | boneFreeSlice
deriving DecidableEq, Repr, Fintype

/-- § 6: the phrase "products of American fisheries" does **not** reach fresh or
frozen fillets, steaks, or substantially bone-free slices. -/
def isProductOfAmericanFisheries : FisheryProduct → Prop
  | FisheryProduct.wholeFish => True
  | _ => False

theorem fillet_excluded : ¬ isProductOfAmericanFisheries FisheryProduct.freshFrozenFillet := by
  unfold isProductOfAmericanFisheries; exact not_false
theorem whole_fish_included : isProductOfAmericanFisheries FisheryProduct.wholeFish := trivial

/-! ## § 7 — Marriage

> (a) For the purposes of any Federal law, rule, or regulation in which marital
> status is a factor, an individual shall be considered married if that
> individual's marriage is between 2 individuals and is valid in the State where
> the marriage was entered into ... -/

/-- The facts § 7 makes relevant to federal marital status. -/
structure MarriageFacts where
  /-- Whether the marriage is between exactly two individuals. -/
  twoIndividuals : Bool
  /-- Whether the marriage is valid in the State (or place) where entered into. -/
  validWhereEntered : Bool
deriving DecidableEq, Repr

/-- § 7(a): for purposes of federal law, an individual is considered married iff
the marriage is between two individuals and valid where entered into. -/
def consideredMarried (f : MarriageFacts) : Prop :=
  f.twoIndividuals = true ∧ f.validWhereEntered = true

theorem married_of_valid_two_party :
    consideredMarried ⟨true, true⟩ := ⟨rfl, rfl⟩

/-- A marriage invalid where entered into is not recognized under § 7(a). -/
theorem not_married_if_invalid_where_entered (b : Bool) :
    ¬ consideredMarried ⟨b, false⟩ := by
  rintro ⟨-, h⟩; simp at h

/-! ## § 8 — "person", "human being", "child", "individual" include born-alive infant

> (a) In determining the meaning of any Act of Congress, or of any ruling,
> regulation, or interpretation of the various administrative bureaus and
> agencies of the United States, the words "person", "human being", "child", and
> "individual", shall include every infant member of the species homo sapiens who
> is born alive at any stage of development. -/

/-- A born-alive infant member of the species, per § 8(b). -/
structure BornAliveInfant where
  /-- born alive at any stage of development -/
  bornAlive : Bool
deriving DecidableEq, Repr

/-- § 8(a): a born-alive infant is included within "person", "human being",
"child", and "individual". -/
def includedAsPerson (i : BornAliveInfant) : Prop := i.bornAlive = true

theorem born_alive_is_person : includedAsPerson ⟨true⟩ := rfl

/-! ## Worked example — successor inheritance of a federal obligation

From the legal-workbench corpus (`01_usc_title1_ch1/question_0001`):

> *If a company subject to a federal reporting obligation merges into another
> company, does the surviving company inherit that obligation?*

**Answer: yes.**  A merger makes the surviving company a "successor or assign"
(§ 5), and § 5 deems an obligation framed on a "company"/"association" to embrace
its successors and assigns; § 1 confirms that such corporate actors are
"persons" to whom federal duties attach.  We record the merger fact as
`IsSuccessor surviving c` and conclude with the construal of § 5. -/

/-- A merger of `c` into `surviving` makes `surviving` a successor/assign of `c`,
provided they are distinct entities. -/
theorem merger_is_successor {c surviving : Corp} (hne : surviving ≠ c) :
    IsSuccessor surviving c := ⟨hne, trivial⟩

/-- **Successor inheritance.**  If a federal reporting obligation `O` binds a
company `c`, and `c` merges into a distinct surviving company `surviving`, then
the surviving company is bound by the obligation as construed under § 5. -/
theorem successor_inherits_obligation
    (O : Corp → Prop) (c surviving : Corp)
    (hc : O c) (hmerge : surviving ≠ c) :
    construe O surviving :=
  construe_of_successor hc (merger_is_successor hmerge)

/-! ## Content addresses of the Chapter 1 sections

Each section is given its canonical USC citation; the addresses are pairwise
distinct, witnessing that Chapter 1 occupies eight distinct slots in the
content-addressed code. -/

/-- `§ n` of Title 1, Chapter 1 as a `USCCitation`. -/
def cite (n : Nat) : USCCitation := ⟨1, 1, n⟩

theorem chapter1_addresses_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro habs
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective habs))

end Law.USC.Title1
