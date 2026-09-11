/-
# "GitHub for machines": BOMs, legal connections and safe substitution

Senator Vaicu's report describes a package

    M = (geometry, BOM, assembly, controller, constraints, proofs)

and asks the system to check that component A may legally connect to B, and that
*a substitution preserves the required properties*.  This file formalises the
part of that which is purely structural, and therefore checkable without any
physics: interfaces provided and required, guaranteed properties, and what
happens when one part is swapped for another.

A component publishes the interfaces it *provides*, the interfaces it *requires*
and the properties it *guarantees*.  An assembly is a bill of materials — a list
of components.  It is *closed* when every requirement of every part is provided
by the assembly, which is exactly the "A can legally connect to B" check applied
to the whole machine.

A component `b` *refines* `a` (`b` is a legal replacement part) when it provides
at least what `a` provided, requires no more than `a` required, and guarantees at
least what `a` guaranteed.

What is proved: refinement is a preorder; a closed assembly stays closed under
substitution by a refinement, and its guarantees can only grow; substituting
several parts at once is likewise safe; and a certified property of the assembly
survives the substitution.
-/
import Mathlib

namespace RequestProject.Market

/-- A part in the bill of materials, described by its interfaces and the
properties it is certified to guarantee.  Interfaces and properties are named by
numeric identifiers. -/
structure Component where
  /-- Identifier of the part. -/
  id : Nat
  /-- Interfaces the part exposes. -/
  provides : Finset Nat
  /-- Interfaces the part needs from the rest of the machine. -/
  requires : Finset Nat
  /-- Properties the part is certified to guarantee. -/
  guarantees : Finset Nat
  deriving DecidableEq

/-- A machine, as a bill of materials. -/
structure Assembly where
  /-- The parts, with multiplicity. -/
  parts : List Component

namespace Assembly

/-- Union of a list of interface sets. -/
def unions : List (Finset Nat) → Finset Nat
  | [] => ∅
  | s :: rest => s ∪ unions rest

theorem unions_mono : ∀ {l l' : List (Finset Nat)}, List.Forall₂ (· ⊆ ·) l l' →
    unions l ⊆ unions l'
  | [], [], _ => by simp [unions]
  | s :: rest, s' :: rest', h => by
      obtain ⟨hs, hrest⟩ := List.forall₂_cons.mp h
      exact Finset.union_subset_union hs (unions_mono hrest)

/-- Everything the assembly provides. -/
def provided (a : Assembly) : Finset Nat := unions (a.parts.map Component.provides)

/-- Everything the assembly needs. -/
def required (a : Assembly) : Finset Nat := unions (a.parts.map Component.requires)

/-- Everything the assembly is certified to guarantee. -/
def guaranteed (a : Assembly) : Finset Nat := unions (a.parts.map Component.guarantees)

/-- The assembly is closed: every interface some part needs is provided by the
machine itself.  This is the "A may legally connect to B" check, taken over the
whole bill of materials. -/
def Closed (a : Assembly) : Prop := a.required ⊆ a.provided

instance (a : Assembly) : Decidable a.Closed := by
  unfold Closed
  infer_instance

/-- Replace every occurrence of one part by another. -/
def substitute (a : Assembly) (old new : Component) : Assembly :=
  ⟨a.parts.map fun c => if c = old then new else c⟩

end Assembly

/-- `b` is a legal replacement for `a`: it provides at least as much, demands at
most as much, and guarantees at least as much. -/
structure Refines (b a : Component) : Prop where
  /-- The replacement exposes every interface the original exposed. -/
  provides : a.provides ⊆ b.provides
  /-- The replacement needs nothing the original did not need. -/
  requires : b.requires ⊆ a.requires
  /-- The replacement keeps every certified property of the original. -/
  guarantees : a.guarantees ⊆ b.guarantees

namespace Refines

/-- Every part is a legal replacement for itself. -/
theorem refl (a : Component) : Refines a a :=
  ⟨Finset.Subset.refl _, Finset.Subset.refl _, Finset.Subset.refl _⟩

/-- Legal replacement composes. -/
theorem trans {c b a : Component} (hcb : Refines c b) (hba : Refines b a) : Refines c a :=
  ⟨hba.provides.trans hcb.provides, hcb.requires.trans hba.requires,
    hba.guarantees.trans hcb.guarantees⟩

end Refines

namespace Assembly

variable {a : Assembly} {old new : Component}

private theorem forall₂_substitute (a : Assembly) (old new : Component)
    (f : Component → Finset Nat) (hf : f old ⊆ f new) :
    List.Forall₂ (· ⊆ ·) (a.parts.map f)
      (((a.substitute old new).parts).map f) := by
  unfold substitute
  simp only [List.map_map]
  induction a.parts with
  | nil => simp
  | cons c rest ih =>
      refine List.Forall₂.cons ?_ ih
      by_cases hc : c = old
      · subst hc; simpa using hf
      · simp [hc]

private theorem forall₂_substitute' (a : Assembly) (old new : Component)
    (f : Component → Finset Nat) (hf : f new ⊆ f old) :
    List.Forall₂ (· ⊆ ·) (((a.substitute old new).parts).map f) (a.parts.map f) := by
  unfold substitute
  simp only [List.map_map]
  induction a.parts with
  | nil => simp
  | cons c rest ih =>
      refine List.Forall₂.cons ?_ ih
      by_cases hc : c = old
      · subst hc; simpa using hf
      · simp [hc]

/-- Substituting a refinement can only add provided interfaces. -/
theorem provided_subset_substitute (a : Assembly) (h : Refines new old) :
    a.provided ⊆ (a.substitute old new).provided :=
  unions_mono (forall₂_substitute a old new Component.provides h.provides)

/-- Substituting a refinement can only remove requirements. -/
theorem required_substitute_subset (a : Assembly) (h : Refines new old) :
    (a.substitute old new).required ⊆ a.required :=
  unions_mono (forall₂_substitute' a old new Component.requires h.requires)

/-- Substituting a refinement can only add guarantees. -/
theorem guaranteed_subset_substitute (a : Assembly) (h : Refines new old) :
    a.guaranteed ⊆ (a.substitute old new).guaranteed :=
  unions_mono (forall₂_substitute a old new Component.guarantees h.guarantees)

/-- **A substitution preserves the required properties.**  Swapping a part for a
legal replacement keeps the machine buildable: every requirement is still met. -/
theorem closed_substitute (a : Assembly) (hclosed : a.Closed) (h : Refines new old) :
    (a.substitute old new).Closed :=
  ((required_substitute_subset a h).trans hclosed).trans (provided_subset_substitute a h)

/-- Every property the certified machine guaranteed is still guaranteed after the
substitution. -/
theorem guarantee_preserved (a : Assembly) (h : Refines new old) {p : Nat}
    (hp : p ∈ a.guaranteed) : p ∈ (a.substitute old new).guaranteed :=
  guaranteed_subset_substitute a h hp

/-- Several substitutions in a row are still safe. -/
theorem closed_substitute_list (a : Assembly) (hclosed : a.Closed)
    (subs : List (Component × Component))
    (h : ∀ p ∈ subs, Refines p.2 p.1) :
    (subs.foldl (fun m p => m.substitute p.1 p.2) a).Closed := by
  induction subs generalizing a with
  | nil => simpa using hclosed
  | cons p rest ih =>
      refine ih _ (closed_substitute a hclosed (h p (List.mem_cons_self ..))) ?_
      intro q hq
      exact h q (List.mem_cons_of_mem _ hq)

end Assembly

end RequestProject.Market
