import RequestProject.Motion.Anim.Easing
import RequestProject.Motion.Anim.Keyframe
import RequestProject.Motion.Anim.Frames
import RequestProject.Motion.Anim.Expr
import RequestProject.Motion.Anim.ExprKernel
import RequestProject.Motion.Anim.ExprFlat
import RequestProject.Motion.Anim.ExprBits
import RequestProject.Motion.Anim.WGSL
import RequestProject.Motion.Anim.Gpu
import RequestProject.Motion.Anim.QR
import RequestProject.Motion.Anim.Markup
import RequestProject.Motion.Anim.UserDraw
import RequestProject.Motion.Anim.Deck
import RequestProject.Motion.Anim.Layout
import RequestProject.Motion.Anim.Palette
import RequestProject.Motion.Anim.Cues
import RequestProject.Motion.Anim.Shader
import RequestProject.Motion.Anim.Rotate
import RequestProject.Motion.Anim.Export
import RequestProject.Motion.Anim.Share
import RequestProject.Motion.Anim.Gif
import RequestProject.Motion.Anim.Space3D
import RequestProject.Motion.Anim.Codec
import RequestProject.Motion.Anim.Fractal
import RequestProject.Motion.Anim.Budget
import RequestProject.Motion.Anim.Scratch
import RequestProject.Motion.Anim.Post
import RequestProject.Motion.Anim.Fly
import RequestProject.Motion.Anim.ProofCodec
import RequestProject.Motion.Anim.Stego
import RequestProject.Motion.Anim.Genome
import RequestProject.Motion.Anim.Learn
import RequestProject.Motion.Anim.Arena
import RequestProject.Motion.Anim.Thread
import RequestProject.Motion.Anim.Token
import RequestProject.Motion.Anim.Library
import RequestProject.Motion.Anim.Named

/-!
# `Hesper.Anim` — the specification behind hesper studio

The studio in `web/` is a browser application: a playbook (whose head is the
formula) is parsed, sampled over a timeline, drawn, and encoded to GIF, MPEG-1,
SVG or PNG.  This library is the formal statement of the semantics its runtime
implements:

| Lean | JavaScript |
|---|---|
| `Hesper.Anim.Easing` | the easing table in `web/js/timeline.js` |
| `Hesper.Anim.sample` | `HesperTimeline.sample` |
| `Hesper.Anim.Clip` | the frame loop of `renderClip` in `web/js/studio.js` |
| `Hesper.Anim.Expr` | the parser/evaluator in `web/js/expr.js` |
| `Hesper.Anim.Kernel` | the flattener in `web/js/expr-kernel.js` and the WebAssembly kernel `web/kernel/hesper_expr.c` |
| `Hesper.Anim.compile` | the shader generator in `web/js/wgsl.js` |
| `Hesper.Anim.Dispatch` | the WebGPU compute dispatch in `web/js/webgpu.js` |
| `Hesper.Markup` | the markup whitelist of `web/js/usercode.js` (`svg`/`link` layers) |
| `Hesper.UserDraw` | the drawing-command validator of `web/js/usercode.js` (`script` layers) |
| `Hesper.Deck` | `slideSpans` / `slideAt` / `transitionAlpha` in `web/js/deck.js` (`slideshow`, `slide`) |
| `Hesper.Layout` | `gridCells` / `insetRect` / `placeIn` in `web/js/deck.js` (`columns`, `rows`, `column`, `table`) |
| `Hesper.Palette` | `rampLookup` in `web/js/deck.js` (`palette`) |
| `Hesper.Cues` | `normalizeCues` in `web/js/deck.js` (`tts`, `say`, captions, the WebVTT track) |
| `Hesper.Shader` | the value semantics and fuel guard of `web/js/shader.js` (`shader`) |
| `Hesper.Rotate` | the matrix layer of `web/js/shader.js`: `mat2`/`mat3`/`mat4`, `rotate2D`, `rotate3D` and the row-vector product `v * M` |
| `Hesper.Export` | the share-target ladder search of `web/js/exporter.js` (the export panel) |
| `Hesper.Share` | the base64url payload, the tagged fragment and the `p=` field of `web/js/share.js` (share links and QR codes) |
| `Hesper.Gif` | the bit packing and sub-block framing under LZW in `web/js/gif.js` (the GIF export) |
| `Hesper.Space3D` | the cube normalisation, camera frame, perspective projection and depth sort of `web/js/space3d.js` (`view3d`, `camera3d`, `plot3d`, `parametric3d`, `label3d`) |
| `Hesper.Fractal` | the complex evaluator, escape time, the chaos game and the L-system of `web/js/fractal.js` (`complex on`, `mandelbrot`, `julia`, `ifs`, `lsystem`) |
| `Hesper.Budget` | the gas pricer and the layer/scene ceilings of `web/js/budget.js` (`budget on`, `gas`) |
| `Hesper.Scratch` | the block editor's paths into a formula in `web/js/scratch.js` |
| `Hesper.Post` | the URL whitelist of `web/js/post.js` |
| `Hesper.Fly` | the flight model of `web/js/fly.js` (flying the camera with the stick) |
| `Hesper.Codec` | the prime-basis codec and its cipher maps, drawn by `web/examples/codec.hesper` |
| `Hesper.ProofCodec` | the canonical proof object, its adapters, comparator, ledger and envelope in `web/codec/` |
| `Hesper.Stego` | the container and the raster, palette and SVG carriers of `web/js/stego.js` |
| `Hesper.Genetics` | the genome of a playbook and its operators in `web/js/genome.js` (the **mutate** and **breed** buttons) |
| `Hesper.Learn` | the knowledge base and its generative model in `web/js/kb.js` (the **predict** button) |
| `Hesper.Arena` | the ballots, points, ratings and ranking of `web/js/arena.js` (votes and battles) |
| `Hesper.Thread` | the comments carried in the URL by `web/js/thread.js` (share threads) |
| `Hesper.Token` | the signature chain of `web/js/nft.js` (minting and transferring a rendering) |

The properties proved here — keys are hit exactly, values stay inside the range
spanned by the surrounding keys, frame times stay inside the clip, evaluation
depends only on the free variables — are the ones the runtime is tested against
in `tests/node/test_playbook.mjs`.

The GPU half answers the question the studio's second backend raises: *is the
shader equivalent to the program it was generated from?*  `eval_compile` says
the emitted WGSL expression computes the value of the formula,
`agree_studio_wgsl` says the emitted polyfills implement the builtins they stand
in for, `Dispatch.run_perm` says the dispatch is race-free, and `gpu_eq_cpu`
puts these together: the dispatched kernel fills each pixel's buffer slot with
exactly the number the CPU evaluator computes there.  The corresponding
numerical check against a real device is `tests/node/check_webgpu.py`.

The last two files answer the question the *open* layers raise: a playbook
travels inside a share link, so the markup, links and script code it carries are
untrusted.  `Hesper.Markup` states what the whitelist sanitiser guarantees (no
element outside the whitelist survives, no `on…` handler, no `javascript:` URL,
sanitising is idempotent, escaped text cannot close what it sits in), and
`Hesper.UserDraw` states what the studio accepts back from a sandboxed script
(every item satisfies the render-list invariant, the list is bounded, colours
are inert, re-validating changes nothing).  Their runtime twins are checked by
`tests/node/test_usercode.mjs` and `tests/node/check_usercode.py`.

The last five files cover the deck, layout, palette, narration and shader
statements.  A deck's slides tile the clip and `slideAt` names the slide on
screen; a grid's cells lie inside the frame, never overlap and line up in rows
and columns; a colour ramp hits its end stops and never leaves the range its
stops lie in, so a ramp of bytes stays a byte; scheduled narration cues are
sorted, non-overlapping and inside the clip, so at most one subtitle shows at a
time; and the shader dialect's broadcasting, swizzles and colour conversion
behave as the runtime expects, while its fuel guard is both safe (evaluation
always answers, and never hands back more fuel than it was given) and honest (a
larger budget never changes an answer).  Their runtime twins are checked by
`tests/node/test_deck.mjs` and `tests/node/test_shader.mjs`.

`Hesper.Export` covers the share-target export planner: the
studio walks a ladder of settings ordered by non-increasing estimated size and
takes the first rung that fits the host's file-size budget.  What is proved is
that the rung it picks is a rung, is within budget, is missing only when every
rung is over budget, and — on a ladder ordered by non-increasing cost — is a
best rung among those that fit, so no better setting was passed over; and that
a non-empty ladder always yields some plan to offer.  Its runtime twin is
`tests/node/test_exporter.mjs`.

The last file, `Hesper.Share`, covers the link a rendering travels in: the
base64url payload is lossless and URL-safe, the tagged fragment round-trips on
both its branches (plain, and compressed whenever the browser's inflate undoes
its deflate), and reading a whole `#p=…&t=…` link back recovers the playbook's
bytes.  Its runtime twin is `tests/node/test_share.mjs`.

`Hesper.Gif` covers the container layer of the GIF export, underneath LZW: codes
written at varying widths are read back unchanged, packing them into bytes only
appends the padding that fills the last byte, the sub-block framing is exactly
invertible, and together a decoder recovers precisely the codes the compressor
emitted.  The dictionary itself is not modelled; the whole encoder is checked
end to end by decoding its output with Pillow in `tests/node/check_outputs.py`,
and the framing statements are checked on real output in
`tests/node/test_gif.mjs`.

`Hesper.Space3D` is the spatial half of the language: a point of the author's
`view3d` box is normalised into the cube `[-1,1]³`, seen through an orthonormal
camera frame and divided by its depth.  What is proved is that normalisation is
invertible, order-preserving and affine (so a straight segment stays straight
and may be drawn from its endpoints), that the frame really is orthonormal for
every non-degenerate camera, that the projection is a perspective one (a whole
viewing ray lands on one pixel) with the target at the centre of the frame,
that the near-plane clip lands exactly on the near plane, and that the
painter's sort is a permutation ordered far to near.  Its runtime twin is
`tests/node/test_space3d.mjs`.

`Hesper.Codec` is the mathematics the `codec` example draws: exponent pairs over
the basis `{2, 3}`, the cipher maps `Φ_s` lifted from `σ_s : 2 ↦ 2+s, 3 ↦ 3+2s`,
and the structural pyramid under the Ur-meme `Ω = (4,2) ↦ 144`.  What is proved
is morphism preservation, injectivity of the exponent encoding, order
preservation (divisibility is componentwise comparison), that every edge of the
pyramid descends strictly and still descends after any cipher, and that the
height the studio draws — `log₂` of the value — turns the multiplicative action
into a translation.

`Hesper.ProofCodec` is the standard proof codec: the canonical proof object every
adapter decodes into, its deterministic serialisation and content hash, the
comparator that decides whether two systems agree, the extension namespace that
keeps unknown fields, the minimum interchange profile, the transformation ledger
and the exchange envelope.  What is proved is that canonicalisation depends on
content and not on field order (so the content hash is a function of the
content), that the comparator reports no difference exactly when the canonical
objects are equal, that a document that could not be read is `ERROR` and never
`INVALID`, that a codec may claim `LOSSLESS` only when the whole semantic object
survived the round trip, that a ledger's overall level is the worst step in it,
that nothing — known field or not — is discarded, and that a sealed envelope
detects a changed payload.  Its runtime twin is `web/codec/`, exercised by
`tests/node/test_codec.mjs`.

`Hesper.Stego` is the layer that hides data inside the rendering itself: the
`"HSTG"` container with its length and checksum, and the three carriers — the
low bits of a frame's colour samples, the doubled GIF palette whose index has a
spare bit, and the third decimal of an SVG coordinate.  What is proved is that a
packed message reads back, that a tampered one is reported damaged rather than
returned as data, that the bit packing is a bijection, that what was written
into the low bits is what comes back out, and — the point of the whole layer —
that the picture barely moves: a sample changes by at most `2^bits - 1` steps,
alpha is never touched, a paired palette decodes every index to the colour it
stood for, and a nudged decimal digit moves by at most one.  Its runtime twin is
`web/js/stego.js`, exercised by `tests/node/test_stego.mjs`.

The last five modules are the studio's *lab*, where renderings are varied, bred,
predicted, voted on, discussed and owned — all inside links, with no server.
`Hesper.Genetics` proves that every operator keeps the skeleton and the gene
keys of a playbook (so a mutant or a child is a playbook again), that a mutated
number moves by at most the amount asked for, and that every gene of a child
came from a parent.  `Hesper.Learn` proves that the fitness weights are a
distribution, that a predicted number stays inside the range the knowledge base
has shown, and that a weighted draw always lands on something of positive
weight — the model never emits a statement it has not seen.  `Hesper.Arena`
proves that a battle is zero-sum and bounded by `K`, that the points awarded are
exactly `WIN` per ballot, that the league table is a function of the *set* of
ballots however they arrived, and that a Condorcet winner ranks first.
`Hesper.Thread` proves that the wire format is lossless, that an edited comment
is a different comment and orphans its replies, and that a thread is a forest.
`Hesper.Token` proves that a valid chain determines its owner, that every
transfer in it was signed by the owner at the time, and that the token is bound
to the exact playbook.  Their runtime twins are `web/js/{genome,kb,evolve,
arena,thread,nft}.js`, exercised by `tests/node/test_lab.mjs`.
`Hesper.Library` proves that the library of named objects behaves: a record's
seal detects tampering, merging never overwrites a held record and is
idempotent, a certificate names exactly the playbook and record it was made
from, and the wikitext escaper can never emit a markup opener.
`Hesper.Named` proves the arithmetic those checks rely on: the Weierstrass
identity, the point count of a curve over a prime field as a sum of
quadratic-root counts, the Hasse test, and the Catalan and Fibonacci
recurrences.  Their runtime twins are `web/js/{library,verify,objrender,
commons}.js`, exercised by `tests/node/test_library.mjs`.
-/
