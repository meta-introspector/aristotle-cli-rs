import Mathlib
import RequestProject.Law.CodeStructure

/-!
# The Standing Rules of the U.S. House of Representatives as a content-addressed hierarchy

The constitutional layer (`Law/CodeStructure.lean`) addresses *positive law* — the
United States Code — by `(title, chapter, section)`.  The internal operating law of
each chamber, by contrast, is its own body of **standing rules**, adopted by the
House at the opening of each Congress under its Art. I, § 5, cl. 2 power to
"determine the Rules of its Proceedings".

The House Rules are organized as

```
Rule (Roman numeral)  →  Clause  ( → subclause → ... )
```

This file provides the *spine* on which the individual House-procedure modules
hang.  We model a citation into the Rules as the pair `(rule, clause)`, and give
each citation a canonical numeric **content address** via an injective pairing,
exactly mirroring the USC spine.  Because the chamber-rule address space is
logically distinct from the positive-law one, downstream modules keep the two
families separate; the only property relied upon is injectivity, proved here as
`HouseRuleCitation.address_injective`.
-/

namespace Law.Legislative

open Law

/-- A citation into the Standing Rules of the House of Representatives, at clause
granularity.  `rule` is the Roman-numeral rule number recorded as a natural
number (Rule X ↦ 10, Rule XII ↦ 12, Rule XIII ↦ 13, Rule XX ↦ 20). -/
structure HouseRuleCitation where
  /-- The House Rule number (recorded as a natural number). -/
  rule : Nat
  /-- The clause within the rule. -/
  clause : Nat
deriving DecidableEq, Repr

namespace HouseRuleCitation

/-- The canonical numeric content address of a House-rule citation, obtained by
`Nat.pair` over the two coordinates. -/
def address (c : HouseRuleCitation) : Nat :=
  Nat.pair c.rule c.clause

/-- Distinct House-rule citations receive distinct content addresses. -/
theorem address_injective : Function.Injective address := by
  rintro ⟨r₁, l₁⟩ ⟨r₂, l₂⟩ h
  simp only [address, Nat.pair_eq_pair] at h
  obtain ⟨hr, hl⟩ := h
  subst hr; subst hl; rfl

/-- Two House-rule citations are equal iff their content addresses agree. -/
theorem address_inj {a b : HouseRuleCitation} : a.address = b.address ↔ a = b :=
  ⟨fun h => address_injective h, fun h => by rw [h]⟩

end HouseRuleCitation

end Law.Legislative
