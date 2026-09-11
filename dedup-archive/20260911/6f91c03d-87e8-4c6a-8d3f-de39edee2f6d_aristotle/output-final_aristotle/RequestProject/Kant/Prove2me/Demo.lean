/-
# Prove2me — the first milestone, executed

Worked examples of the whole layer, checked by `#guard` at compile time.
This is §18 of the specification played out: two nodes exchange a theorem
and a submission by address, each verifies locally under the same pinned
environment, both publish signed results, and a third client confirms
that the two results name the same statement, source and environment —
with a relay that drops, reorders, duplicates and forges in the middle,
and no effect on the outcome.

**The signature scheme here is a demonstration stub and provides no
security.**  `demoSig` "verifies" a signature that is a copy of the
signing key, which is enough to run the state machine and nothing else.
Every theorem in the other modules is stated over an arbitrary
`SigScheme`; nothing is proved about this one, and no result in the
project depends on it.

Likewise the addresses below are written out as opaque strings rather
than computed: by `no_addressing_is_witness` this project has no function
that can instantiate `Addressing`, and pretending otherwise in a demo
would be the exact confusion the layer exists to prevent.
-/
import RequestProject.Kant.Prove2me.Bridge

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me.Demo

open Kant Kant.Prove2me Kant.Urania

/-! ## A demonstration signature scheme (no security) -/

/-- A stub scheme in which a signature is a copy of the signing key.
Runnable, and worthless as cryptography. -/
def demoSig (Msg : Type) : SigScheme Key Msg Key where
  verify pk _ s := pk == s
  signedBy pk _ s := pk = s
  noForgery := by
    intro pk m s h
    simpa using h

/-! ## The pinned environment -/

/-- The environment both nodes pin. -/
def env : Env :=
  { leanVersion := "4.28.0".toList
    mathlibRev := "8f9d9cff".toList
    platformRev := "prove2me-2026-09".toList
    image := "prove2me/verifier:1".toList
    flags := ["--tstack=32768".toList]
    allowedImports := ["Mathlib".toList, "Prove2me.Prelude".toList]
    timeLimit := 300
    memoryLimit := 8192 }

/-- Its address, as the deployment would publish it. -/
def envCid : Cid := "cid-env-lean4280".toList

/-! ## The theorem -/

/-- The target: a statement, its imports, its environment — and prose
that does not affect its identity. -/
def target : Thm :=
  { core :=
      { statement := "theorem lagrange (G : Type) : True".toList
        imports := ["Mathlib".toList]
        definitions := []
        environment := envCid }
    name := "finite_subgroup_card_dvd_group_card".toList
    title := "Lagrange".toList
    documentation := "The order of a subgroup divides the order of the group.".toList
    tags := ["group-theory".toList] }

/-- The same theorem, retitled and retagged by another peer. -/
def targetRetitled : Thm :=
  { target with title := "Lagrange's theorem".toList, tags := ["algebra".toList] }

/-- Prose does not change identity: the two records have the same core,
so any addressing gives them the same address. -/
example (A : Addressing) : theoremId A target = theoremId A targetRetitled :=
  theoremId_ignores_prose A rfl

/-- The address the network uses for it. -/
def tid : Cid := "cid-thm-lagrange".toList

/-! ## Submissions -/

/-- An honest proof. -/
def goodProof : Sub :=
  { target := tid
    source := "theorem solution (G : Type) : True := trivial".toList
    declaredImports := ["Mathlib".toList]
    kind := .direct
    environment := envCid
    isSketch := false
    explanation := "one line".toList }

/-- A submission that tries to prove the theorem by importing it. -/
def selfImporting : Sub :=
  { goodProof with declaredImports := ["Mathlib".toList, moduleOf tid] }

/-- A submission with a hole in it, not declared as a sketch. -/
def holed : Sub :=
  { goodProof with source := "theorem solution (G : Type) : True := by sorry".toList }

/-- The same hole, published honestly as a sketch. -/
def sketch : Sub := { holed with isSketch := true }

/-- A submission checked in a different environment. -/
def otherEnv : Sub := { goodProof with environment := "cid-env-other".toList }

#guard admissibleB tid envCid env goodProof = true
#guard admissibleB tid envCid env selfImporting = false
#guard admissibleB tid envCid env holed = false
#guard admissibleB tid envCid env sketch = true
#guard proofCandidateB tid envCid env sketch = false
#guard proofCandidateB tid envCid env goodProof = true
#guard admissibleB tid envCid env otherEnv = false

/-- The submission's address on the network. -/
def sid : Cid := "cid-sub-lagrange-1".toList

/-! ## Two nodes verify independently -/

/-- Node A's key. -/
def keyA : Key := "did:key:A".toList

/-- Node B's key. -/
def keyB : Key := "did:key:B".toList

/-- A third party nobody has agreed to trust. -/
def keyMallory : Key := "did:key:M".toList

/-- A node's own result. -/
def resultOf (k : Key) (st : Status) : VResult :=
  { submission := sid, target := tid, environment := envCid, verifier := k,
    status := st, diagnostics := "".toList }

/-- Node A accepts. -/
def resultA : VResult := resultOf keyA .accepted

/-- Node B accepts, independently. -/
def resultB : VResult := resultOf keyB .accepted

/-- Mallory claims an acceptance too. -/
def resultM : VResult := resultOf keyMallory .accepted

/-- Mallory also claims the *opposite* about the same job. -/
def resultMBad : VResult := resultOf keyMallory .rejected

#guard acceptedB tid envCid sid env goodProof resultA = true
#guard acceptedB tid envCid sid env goodProof (resultOf keyA .rejected) = false
#guard acceptedB tid envCid sid env sketch resultA = false

-- Mallory's two results about the same job contradict each other, and that
-- is detectable from the two artifacts alone.
#guard conflicting resultM resultMBad = true
#guard conflicting resultA resultB = false

/-! ## Policies -/

/-- A peer that trusts both nodes and wants one result. -/
def policy1 : Policy := { requiredResults := 1, trustedVerifiers := [keyA, keyB] }

/-- A peer that wants two independent verifiers. -/
def policy2 : Policy := { requiredResults := 2, trustedVerifiers := [keyA, keyB] }

#guard acceptsB policy1 tid envCid sid env goodProof [resultA] = true
#guard acceptsB policy2 tid envCid sid env goodProof [resultA] = false
#guard acceptsB policy2 tid envCid sid env goodProof [resultA, resultB] = true
-- duplication cannot substitute for a second verifier
#guard acceptsB policy2 tid envCid sid env goodProof [resultA, resultA] = false
-- nor can an untrusted key
#guard acceptsB policy2 tid envCid sid env goodProof [resultA, resultM] = false
-- and a policy that requires nothing accepts nothing
#guard acceptsB { requiredResults := 0, trustedVerifiers := [keyA] } tid envCid sid env
  goodProof [resultA] = false

/-! ## The relay in the middle -/

/-- The scheme the demo uses to check result signatures. -/
def sigScheme : SigScheme Key VResult Key := demoSig VResult

/-- A correctly signed result. -/
def signed (r : VResult) : SignedResult Key := ⟨r, r.verifier⟩

/-- A result Mallory signed with somebody else's name on it. -/
def forgedResult : SignedResult Key := ⟨resultOf keyA .accepted, keyMallory⟩

/-- What the two honest nodes actually published. -/
def sent : List (Msg Key) :=
  [.result (signed resultA), .result (signed resultB)]

/-- What the relay delivered: reordered, one message duplicated, and a
forged result injected. -/
def received : List (Msg Key) :=
  [.result (signed resultB), .result forgedResult, .result (signed resultA),
    .result (signed resultB)]

#guard keepResults sigScheme sent = [resultA, resultB]
-- the forgery is dropped on arrival
#guard keepResults sigScheme received = [resultB, resultA, resultB]
-- and the verdict is exactly the honest-channel verdict
#guard acceptsB policy2 tid envCid sid env goodProof (keepResults sigScheme received)
     = acceptsB policy2 tid envCid sid env goodProof (keepResults sigScheme sent)
#guard acceptsB policy2 tid envCid sid env goodProof (keepResults sigScheme received) = true

-- A relay that drops everything cannot make the peer accept.
#guard acceptsB policy2 tid envCid sid env goodProof
  (keepResults sigScheme ([] : List (Msg Key))) = false

/-! ## Decomposition -/

/-- A parent theorem, reduced to two children. -/
def parent : Cid := "cid-thm-parent".toList

/-- First child. -/
def child1 : Cid := "cid-thm-child1".toList

/-- Second child. -/
def child2 : Cid := "cid-thm-child2".toList

/-- The reduction submission. -/
def reductionSub : Cid := "cid-sub-reduction".toList

/-- The reduction edge. -/
def edge : Edge :=
  { parent := parent, children := [child1, child2], reduction := reductionSub,
    relation := .proofByImportedChildren }

/-- The same split, published only as a suggestion. -/
def suggestion : Edge := { edge with relation := .suggestedReduction }

/-- Which theorems have a direct accepted proof. -/
def accThm (c : Cid) : Bool := (c == child1) || (c == child2)

/-- Which submissions the peer accepts. -/
def accSub (c : Cid) : Bool := c == reductionSub

-- the parent resolves through the reduction and its two children
#guard resolvedFuel accThm accSub [edge] 1 parent = true
-- but not from a mere suggestion
#guard resolvedFuel accThm accSub [suggestion] 1 parent = false
-- nor if the reduction itself is unaccepted
#guard resolvedFuel accThm (fun _ => false) [edge] 1 parent = false
-- nor if a child is still open
#guard resolvedFuel (fun c => c == child1) accSub [edge] 5 parent = false

/-- A mission tracking the parent and its children. -/
def mission : Mission :=
  { title := "Lagrange and friends".toList
    description := "".toList
    roots := [parent]
    milestones := [parent, child1, child2]
    curator := keyA }

#guard openLeaves (fun c => resolvedFuel accThm accSub [edge] 3 c) mission = []
#guard openLeaves (fun c => resolvedFuel (fun _ => false) accSub [edge] 3 c) mission
     = [parent, child1, child2]

/-! ## Names -/

/-- The scheme the demo uses to check name records. -/
def nameSig : SigScheme Key NameRecord Key := demoSig NameRecord

/-- Node A claims a name for the theorem. -/
def nameV1 : SignedName Key :=
  ⟨{ name := "lagrange".toList, pointsTo := tid, sequence := 1, owner := keyA }, keyA⟩

/-- Node A repoints it. -/
def nameV2 : SignedName Key :=
  ⟨{ name := "lagrange".toList, pointsTo := parent, sequence := 2, owner := keyA }, keyA⟩

/-- Mallory tries to take the name over. -/
def nameHijack : SignedName Key :=
  ⟨{ name := "lagrange".toList, pointsTo := child1, sequence := 99, owner := keyMallory },
    keyMallory⟩

/-- The registry after A's two updates. -/
def registry : Registry := update nameSig (update nameSig [] nameV1) nameV2

#guard (resolve registry "lagrange".toList).map NameRecord.pointsTo = some parent
-- replaying the old record does not roll the name back
#guard (resolve (update nameSig registry nameV1) "lagrange".toList).map NameRecord.pointsTo
     = some parent
-- and Mallory cannot take the name, however large the sequence number
#guard (resolve (update nameSig registry nameHijack) "lagrange".toList).map NameRecord.pointsTo
     = some parent
-- the history is still there
#guard registry.length = 2

/-! ## The gateway -/

/-- A row as the existing HTTP API would return it. -/
def apiRow : ApiTheorem :=
  { id := 123
    name := "finite_subgroup_card_dvd_group_card".toList
    statement := "theorem lagrange (G : Type) : True".toList
    imports := ["Mathlib".toList]
    definitions := []
    environment := envCid
    title := "Lagrange".toList
    description := "".toList
    tags := ["group-theory".toList] }

/-- The same row after somebody edited its display text. -/
def apiRowRetitled : ApiTheorem :=
  { apiRow with title := "Lagrange's theorem".toList, tags := [] }

#guard (toThm apiRow).core = target.core
#guard (toThm apiRowRetitled).core = target.core
#guard apiUrl "https://prove2.me".toList 123
     = "https://prove2.me/api/v1/theorems/7b".toList

/-- Editing the API display text leaves the artifact address alone. -/
example (A : Addressing) : theoremId A (toThm apiRow) = theoremId A (toThm apiRowRetitled) :=
  bridge_ignores_prose A rfl rfl rfl rfl


/-! ## Golden vectors

The strings the JavaScript twin (`web/kant-prove2me.mjs`) is asserted
against in `web/prove2me-test.mjs`.  They are computed by the definitions
above and checked here, so the two sides cannot drift. -/

#guard canon target.core.content =
  ("70326d617274:02:7468656f72656d206c616772616e6765202847203a205479706529203a2054727565" ++
   ":37303332366436633639373337343a3464363137343638366336393632" ++
   ":3730333236643663363937333734:6369642d656e762d6c65616e34323830").toList

#guard canon goodProof.content =
  ("70326d617274:03:6369642d74686d2d6c616772616e6765" ++
   ":7468656f72656d20736f6c7574696f6e202847203a205479706529203a2054727565203a3d207472697669616c" ++
   ":37303332366436633639373337343a3464363137343638366336393632" ++
   ":3031:6369642d656e762d6c65616e34323830:30").toList

#guard canon env.content =
  ("70326d617274:08:342e32382e30:3866396439636666:70726f7665326d652d323032362d3039" ++
   ":70726f7665326d652f76657269666965723a31" ++
   ":37303332366436633639373337343a32643264373437333734363136333662336433333332333733363338" ++
   ":37303332366436633639373337343a34643631373436383663363936323a" ++
   "3530373236663736363533323664363532653530373236353663373536343635" ++
   ":30313263:32303030").toList

#guard packText ["Mathlib".toList] = "70326d6c697374:4d6174686c6962".toList
#guard natField 2 = "02".toList
#guard natField 300 = "012c".toList
#guard natField 0 = "".toList
#guard boolField false = "0".toList
#guard boolField true = "1".toList

end Kant.Prove2me.Demo
