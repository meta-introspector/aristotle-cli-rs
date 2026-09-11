/-
# Cross-Cluster Ontology — Global Semantic Universe

This module defines the global ontology layer that can host multiple
semantic worlds (like Solfunmeme) as first-class categorical objects.

## Structure
1. **ClusterWorld** — a self-contained semantic universe
2. **Thin category infrastructure** — reusable preorder→category bridge
3. **Global registry** — worlds as navigable sub-categories
-/

import Mathlib

set_option maxHeartbeats 400000

namespace CrossClusterOntology

/-! ## §1. ClusterWorld: a self-contained semantic universe -/

/-- A ClusterWorld represents a self-contained semantic universe
    with its own concept graph and reachability structure.
    This is the unit of integration in the global ontology. -/
structure ClusterWorld where
  name : String
  numConcepts : Nat
  numEdges : Nat
  numSubClusters : Nat
  hasReflReachability : Bool   -- reaches x x = true for all x
  hasTransReachability : Bool  -- reachability is transitive
  deriving Repr, DecidableEq

/-! ## §2. Thin Category from a decidable preorder

  A thin category (aka posetal category) has at most one morphism
  between any two objects. We build one from any decidable preorder. -/

/-- A decidable preorder on a finite type gives rise to a thin category.
    Objects are elements of `α`, morphisms from `a` to `b` exist iff `rel a b`. -/
structure ThinCatData (α : Type) where
  rel : α → α → Bool
  rel_refl : ∀ a, rel a a = true
  rel_trans : ∀ a b c, rel a b = true → rel b c = true → rel a c = true

/-- The hom type for a thin category: either empty or a singleton. -/
def ThinHom {α : Type} (data : ThinCatData α) (a b : α) : Type :=
  PLift (data.rel a b = true)

instance {α : Type} (data : ThinCatData α) (a b : α) :
    Subsingleton (ThinHom data a b) :=
  ⟨fun ⟨_⟩ ⟨_⟩ => rfl⟩

/-- Every thin category's hom is decidable: either there's exactly one
    morphism or none. -/
instance {α : Type} (data : ThinCatData α) (a b : α) :
    Decidable (Nonempty (ThinHom data a b)) := by
  simp only [ThinHom]
  exact if h : data.rel a b = true
    then isTrue ⟨⟨h⟩⟩
    else isFalse (fun ⟨⟨p⟩⟩ => h p)

/-! ## §3. World registry -/

/-- A registered world in the global ontology with its verification status. -/
structure RegisteredWorld where
  world : ClusterWorld
  isThinCategory : Bool
  isDecidable : Bool
  deriving Repr

/-- The global registry of semantic worlds. -/
def WorldRegistry := List RegisteredWorld

/-- Check if a world is registered. -/
def WorldRegistry.contains (reg : WorldRegistry) (name : String) : Bool :=
  reg.any (·.world.name == name)

/-- Look up a world by name. -/
def WorldRegistry.lookup (reg : WorldRegistry) (name : String) :
    Option RegisteredWorld :=
  reg.find? (·.world.name == name)

end CrossClusterOntology
