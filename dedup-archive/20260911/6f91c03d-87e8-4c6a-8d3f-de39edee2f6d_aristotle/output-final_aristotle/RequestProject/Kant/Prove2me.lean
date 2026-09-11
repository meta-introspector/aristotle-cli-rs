/-
# `prove2.me`, as a peer-to-peer protocol

A Lean 4 specification of the Prove2me P2P layer: content-addressed
theorem, submission, verification, decomposition, mission and name
artifacts, exchanged over an untrusted relay, with acceptance decided
locally by each peer.

The write-up is `docs/PROVE2ME-P2P.md`.  The layers, bottom up:

| Module | Covers | Guarantees |
|---|---|---|
| `Kant.Prove2me.Artifact` | §3–§4 objects and identity | canonical form round-trips and is injective; identity is content, not author, clock or title; the shipped digest provably cannot instantiate the addressing interface |
| `Kant.Prove2me.Statement` | §5 theorem artifacts | identity commits to statement, imports, definitions and environment — and to nothing else; each of the four really is committed to |
| `Kant.Prove2me.Submission` | §6 submissions | the two structural refusals as decidable checks; a proof has no holes; a sketch is not a proof |
| `Kant.Prove2me.Verification` | §7 results | reproducibility as an explicit hypothesis; conflicts are fork certificates; acceptance does not transfer between environments; the §17 invariant |
| `Kant.Prove2me.Policy` | §8 trust | distinct trusted verifiers are counted, so duplication is inert; more results and more trusted verifiers never retract an acceptance |
| `Kant.Prove2me.Graph` | §9 decompositions and missions | only importing reductions resolve; no circular self-justification; competing curations coexist |
| `Kant.Prove2me.Replication` | §10 replication | a relay that drops, reorders, duplicates and forges cannot change the accepted set |
| `Kant.Prove2me.Names` | §11–§12 names and conflicts | stale records never win, names cannot be hijacked, history is retained, renaming touches no bytes |
| `Kant.Prove2me.Bridge` | §13 the HTTP gateway | prose edits do not fork a theorem; the recorded address resolves back; importing accepts nothing |
| `Kant.Prove2me.Demo` | §18 the first milestone | the whole scenario, `#guard`-checked, relay adversary included |
-/
import RequestProject.Kant.Prove2me.Artifact
import RequestProject.Kant.Prove2me.Statement
import RequestProject.Kant.Prove2me.Submission
import RequestProject.Kant.Prove2me.Verification
import RequestProject.Kant.Prove2me.Policy
import RequestProject.Kant.Prove2me.Graph
import RequestProject.Kant.Prove2me.Replication
import RequestProject.Kant.Prove2me.Names
import RequestProject.Kant.Prove2me.Bridge
import RequestProject.Kant.Prove2me.Demo
