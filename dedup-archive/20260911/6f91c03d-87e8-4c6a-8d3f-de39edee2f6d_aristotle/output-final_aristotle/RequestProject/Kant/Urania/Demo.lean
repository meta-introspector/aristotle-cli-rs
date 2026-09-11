/-
# Urania — worked examples, and witnesses that the hypotheses are consistent

Two jobs:

**1. The abstract interfaces are inhabited.**  Every theorem in this
development is stated relative to a `SigScheme`, a `HashFn` or a
`MerkleHash`.  If no value of those types existed, the theorems would be
vacuous.  They are not: `demoSigScheme`, `idHashFn` and `freeMerkleHash`
are constructed here.

These witnesses are **not implementations**, and nothing should be built
on them:

* `demoSigScheme`'s "signature" is the pair `(key, message)` — anybody
  can produce one, so it satisfies the symbolic no-forgery property only
  because that property is about the modelling relation `signedBy`, not
  about secrecy;
* `idHashFn` is the identity — injective, and no compression at all;
* `freeMerkleHash` hashes into the free term algebra — injective by
  construction, and unbounded in size.

Their point is to show the assumptions are consistent, and to make the
gap visible: a *real* hash must be injective *and* fixed-width, and
`digest_not_injective` says nothing fixed-width can be injective.  The
real thing is a computational assumption, not a Lean construction.

**2. Worked examples.**  `#guard`-checked at build time, as elsewhere in
this project.
-/
import Mathlib
import RequestProject.Kant.Urania.Manifest
import RequestProject.Kant.Urania.Trust
import RequestProject.Kant.Urania.Pledge
import RequestProject.Kant.Urania.Qos
import RequestProject.Kant.Urania.Export

set_option maxRecDepth 4000
set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania.Demo

open Kant.Urania

/-! ## Consistency witnesses -/

/-- A signature is the pair it certifies.  Unforgeable in the symbolic
model, and useless in practice — see the module docstring. -/
def demoSigScheme (PubKey Msg : Type) [DecidableEq PubKey] [DecidableEq Msg] :
    SigScheme PubKey Msg (PubKey × Msg) where
  verify pk m s := (s.1 = pk : Bool) && (s.2 = m : Bool)
  signedBy pk m s := s = (pk, m)
  noForgery := by
    intro pk m s h
    simp only [Bool.and_eq_true, decide_eq_true_eq] at h
    exact Prod.ext h.1 h.2

/-- The identity is injective, so it is a `HashFn`; it is also not a hash
(no compression whatsoever). -/
def idHashFn (α : Type) : HashFn α α where
  hash := id
  injective := fun _ _ h => h

/-- Hashing into the free term algebra: injective by construction, with
domain separation by construction, and no fixed width. -/
inductive FreeHash (Leaf : Type) where
  /-- A hashed leaf. -/
  | leaf (x : Leaf)
  /-- A hashed pair of children. -/
  | node (a b : FreeHash Leaf)
deriving DecidableEq, Repr

/-- The corresponding `MerkleHash`. -/
def freeMerkleHash (Leaf : Type) : MerkleHash Leaf (FreeHash Leaf) where
  hleaf := FreeHash.leaf
  hnode := FreeHash.node
  hleaf_inj := by intro a b h; cases h; rfl
  hnode_inj := by intro a b c d h; cases h; exact ⟨rfl, rfl⟩
  node_ne_leaf := by intro a b x h; cases h

/-! ## Worked examples -/

/-- Founding key of the toy community. -/
def alice : Key := "alice".toList
/-- Admitted by Alice. -/
def bob : Key := "bob".toList
/-- Admitted by Bob. -/
def carol : Key := "carol".toList

/-- Nobody vouched for this one. -/
def mallory : Key := "mallory".toList

/-- Cooldowns of 100 and 30 ticks, three vouches per 50-tick window. -/
def params : TrustParams :=
  { selfWindow := 100, voucherWindow := 30, budget := 3, budgetWindow := 50 }

/-- Newest first: Bob vouched for Carol at t=20, Alice for Bob at t=10. -/
def log0 : TrustLog :=
  [.vouch bob carol 20, .vouch alice bob 10]

/-- Carol is a member; Mallory is outside. -/
example : tier params [alice] log0 carol 30 = Tier.full := by decide
example : tier params [alice] log0 mallory 30 = Tier.outside := by decide

/-- Carol is tainted at t=40: she is on probation, and Bob — her direct
voucher — drops to `reduced`.  Alice, two hops away, is untouched. -/
def log1 : TrustLog := .taint carol 40 :: log0

example : tier params [alice] log1 carol 50 = Tier.probation := by decide
example : tier params [alice] log1 bob 50 = Tier.reduced := by decide
example : tier params [alice] log1 alice 50 = Tier.full := by decide

/-- Contagion has expired for Bob by t=80 (30-tick window), and for Carol
by t=140 (100-tick window): recovery needs no appeal. -/
example : tier params [alice] log1 bob 80 = Tier.full := by decide
example : tier params [alice] log1 carol 141 = Tier.full := by decide

/-- The log above is well formed: every vouch came from a member. -/
example : WellFormed [alice] log0 := by
  refine ⟨?_, ?_, trivial⟩ <;> decide

/-- Pledges: two topics, and a re-post of the same pledge changes
nothing. -/
def pledgeA : Pledge :=
  { topic := "math".toList, resource := .bandwidth, amount := 500, author := alice,
    id := "aa".toList }
/-- A second, distinct pledge on the same topic. -/
def pledgeB : Pledge :=
  { topic := "math".toList, resource := .storage, amount := 250, author := bob,
    id := "bb".toList }

example : totalFor [pledgeA, pledgeB] "math".toList = 750 := by decide
example : totalFor [pledgeA, pledgeA, pledgeB] "math".toList = 750 := by decide
example : totalFor [pledgeA, pledgeB] "physics".toList = 0 := by decide

/-- QoS: buckets are coarse, and a single liar cannot move the median. -/
example : latencyBucket 10 = 0 := by decide
example : latencyBucket 1600 = 4 := by decide
/-- Two honest reports of `1`, and one reporter claiming `99`: the
published score still lies in the honest range. -/
example : 1 ≤ trimmedMedian [99, 1, 1] ∧ trimmedMedian [99, 1, 1] ≤ 1 :=
  trimmedMedian_within_honest_range (hs := [1, 1]) (by decide) (by decide) (by decide)

/-- Coverage: a manifest claiming indices 4 to 6 has three indices to
prove. -/
def body0 : Body :=
  { createdAt := 1, operator := alice, tier1Root := "aa".toList, tier2Root := "bb".toList,
    chainFrom := 4, chainTo := 6, supersedes := [], revisionCutoff := 900 }

example : claimedRange body0 = [4, 5, 6] := by decide

-- The canonical form of a manifest reads back.
#guard (parseCanon (canon body0) == some body0)

/-- Tier-1 diffing is quiet about revisions after the cutoff. -/
def wanted : List Tier1Item := [⟨"Group".toList, 10⟩, ⟨"Ring".toList, 20⟩]
/-- What one snapshot actually covered. -/
def covered : List Tier1Item := [⟨"Group".toList, 10⟩]

example : tier1Missing 900 wanted covered = [⟨"Ring".toList, 20⟩] := by decide
example : tier1Missing 900 (⟨"Field".toList, 1000⟩ :: wanted) covered
    = [⟨"Ring".toList, 20⟩] := by decide

end Kant.Urania.Demo
