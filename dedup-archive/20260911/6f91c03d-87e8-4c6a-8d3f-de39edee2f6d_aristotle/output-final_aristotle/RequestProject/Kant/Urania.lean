/-
# Urania: a relay / P2P / static-archive protocol, machine-checked

This layer is the protocol spec v0.3 formalised on top of the Kant port.
Each module states what it proves and, where the protocol rests on
cryptography this project does not have, carries that assumption in the
statement rather than in a comment.

| Module | Protocol section | Guarantees |
|---|---|---|
| `Kant.Urania.Crypto` | §2.5 | abstract signature and hash interfaces as bundled hypotheses; **the shipped FNV-1a digest is provably not collision-free**, so it can never instantiate them |
| `Kant.Urania.Merkle` | §3.2, §4 | `MerklePath` inclusion proofs, sound and complete; a root determines its tree |
| `Kant.Urania.Chain` | §3.3, §4 | unconditional append (the relay is not a policy engine), client-side validity, transferable fork certificates, first-seen head pinning |
| `Kant.Urania.Manifest` | §3.1, §4 | canonical manifest form, content-addressed `snapshot_id` with mutable slugs, coverage checked by inclusion proof, revision-anchored Tier-1 diffing with licence attribution |
| `Kant.Urania.Trust` | §5 | vouching, taint decay, one-hop contagion, reachability from founders, per-window sybil budget |
| `Kant.Urania.Pledge` | §6 | donation pledges as honest aggregation, no double count, fulfilment ≤ pledge — deliberately *not* a ledger |
| `Kant.Urania.Qos` | §7 | bounded ring cache, coarse buckets, expiry, trimmed median, vouched-only access |
| `Kant.Urania.Export` | §3.1, §8 | the static exporter with the grouping key made a parameter: the counting argument is generic, the filename obligation is explicit |
| `Kant.Urania.Demo` | — | consistency witnesses for the abstract interfaces, and `#guard`-checked examples |

The write-up is `docs/URANIA.md`.
-/
import RequestProject.Kant.Urania.Crypto
import RequestProject.Kant.Urania.Merkle
import RequestProject.Kant.Urania.Chain
import RequestProject.Kant.Urania.Manifest
import RequestProject.Kant.Urania.Trust
import RequestProject.Kant.Urania.Pledge
import RequestProject.Kant.Urania.Qos
import RequestProject.Kant.Urania.Export
import RequestProject.Kant.Urania.Demo
