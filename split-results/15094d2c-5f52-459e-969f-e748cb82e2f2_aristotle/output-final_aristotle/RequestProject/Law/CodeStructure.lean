import Mathlib

/-!
# The United States Code as a content-addressed hierarchy

This file provides the *spine* on which individual statutory titles hang.  The
United States Code (USC) is organized as a tree:

```
Title  →  Chapter  →  Section  ( → subsection → paragraph → ... )
```

We model a *citation* into the Code as the triple `(title, chapter, section)`,
which is the granularity at which the positive-law text is enacted, and we give
each citation a canonical numeric **content address** via a simple injective
pairing.  This mirrors the registry/address pattern used elsewhere in the
archive: every statutory unit gets one canonical key, and distinct units get
distinct keys.

The address map is deliberately elementary (a Cantor-style pairing iterated
over the three coordinates).  All that the downstream development relies on is
that it is *injective*, which is proved here as `USCCitation.address_injective`.
-/

namespace Law

/-- A citation into the United States Code at section granularity. -/
structure USCCitation where
  /-- USC title number (1–54). -/
  title : Nat
  /-- Chapter number within the title. -/
  chapter : Nat
  /-- Section number. -/
  «section» : Nat
deriving DecidableEq, Repr

namespace USCCitation

/-- The canonical numeric content address of a citation, obtained by iterating
Mathlib's `Nat.pair` over the three coordinates. -/
def address (c : USCCitation) : Nat :=
  Nat.pair (Nat.pair c.title c.chapter) c.«section»

/-- Distinct citations receive distinct content addresses. -/
theorem address_injective : Function.Injective address := by
  rintro ⟨t₁, c₁, s₁⟩ ⟨t₂, c₂, s₂⟩ h
  simp only [address, Nat.pair_eq_pair] at h
  obtain ⟨⟨ht, hc⟩, hs⟩ := h
  subst ht; subst hc; subst hs; rfl

/-- Two citations are equal iff their content addresses agree. -/
theorem address_inj {a b : USCCitation} : a.address = b.address ↔ a = b :=
  ⟨fun h => address_injective h, fun h => by rw [h]⟩

end USCCitation

end Law
