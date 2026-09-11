/-
# The rendering kernel

One state machine, many games, many renderers.  A game is a `GameKernel`;
a page is a `GameRenderer` over it; the runtime, the share tokens and the
archive checkpoints are written once, generically, and proved once.

| Module | Spec section | Guarantees |
|---|---|---|
| `Kant.Kernel.Core` | §1–§2, §17 | the `GameKernel` record, replay, **prefix compositionality** of `run`, validity preserved by replay, an injective move codec |
| `Kant.Kernel.Codec` | §9 | the canonical numeral/text codec, with round trips against any suffix |
| `Kant.Kernel.Runtime` | §6–§13 | the `past`/`future` zipper, one `dispatch`, one invariant; a rejected move leaves the state *equal*; undo/redo; rewinding shows the prefix world |
| `Kant.Kernel.Share` | §8–§10, §14 | tokens that round-trip and are canonical, rejection-on-mismatch by construction, and checkpoints with an explicit honesty hypothesis |
| `Kant.Kernel.Render` | §3–§5, §15–§18 | `RenderTree` with an injective serialization and decidable equality, the `GameRenderer` adapter, the click-to-picture theorem |
| `Kant.Kernel.Games.Lights` | adapter one | a total `step`, and strong completeness of its controls |
| `Kant.Kernel.Games.Nim` | adapter two | a partial `step` and data-carrying moves — the interface did not change to admit it |
| `Kant.Kernel.Demo` | — | `#guard`-checked golden vectors, including tampered and truncated tokens, and a checkpoint that is valid and still a lie |

Two things this layer deliberately does **not** claim.  Rendering
determinism across the Lean/JavaScript boundary is a golden-test
obligation (`web/kernel-test.mjs`), not a theorem — `render w = render w`
is free.  And no digest can rule out a forged token: the digest is a
checksum, the trust anchor is replay.  The write-up is
`docs/RENDER-KERNEL.md`.
-/
import RequestProject.Kant.Kernel.Core
import RequestProject.Kant.Kernel.Codec
import RequestProject.Kant.Kernel.Runtime
import RequestProject.Kant.Kernel.Share
import RequestProject.Kant.Kernel.Render
import RequestProject.Kant.Kernel.Games.Lights
import RequestProject.Kant.Kernel.Games.Nim
import RequestProject.Kant.Kernel.Demo
