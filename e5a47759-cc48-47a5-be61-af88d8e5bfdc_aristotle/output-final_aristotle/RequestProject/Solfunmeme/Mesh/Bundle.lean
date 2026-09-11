import RequestProject.Solfunmeme.Mesh.Codec

/-!
# The FHME runtime bundle: the site and its data, woven together

The runtime that checks a market card is the same FHME engine the game already
uses: a pure fold with a rolling hash, small enough to ship inside the page.
What this file adds is how it is *served*, and it is the answer to "make it so
people cannot steal our site":

* the runtime bytes and the market payload are **woven** into one byte string,
  `weave`, which alternates them after a two-number header.  There is no
  boundary to cut at: `unweave_weave` recovers both halves only if you know the
  format, and `weave_injective` says the woven bytes determine both halves
  exactly;
* what is signed is not the payload and not the runtime but the **digest of the
  woven bytes together with the origin they are served from**
  (`siteMessage`).  So a copy of the site on another domain is not a valid
  service of it (`rehost_rejected`), and any edit to either half — swapping the
  market data, stripping the checker, injecting a script — changes the digest
  and invalidates the signature (`tamper_changes_digest`, `strip_detected`);
* the runtime only runs what it has verified: `run` returns a bundle exactly
  when the served bytes carry a good signature for this origin
  (`run_isSome_iff`), and what it then executes is exactly the bytes that were
  signed (`run_eq_some_iff`).

Two honest caveats.  The digest is abstract here: the statements assume it is
injective (a collision-free hash), which is how one analyses a commitment
scheme, not a proof about any particular hash.  And nothing can stop somebody
copying bytes: what is proved is that the copy cannot be *served as this site*
without the site key, and that a reader who checks the signature can tell.
-/

namespace Mesh.Runtime

open Meme.Share (natToLE8)
open Senate.Wire

/-! ## Weaving -/

/-- Alternate two byte strings, starting with the first. -/
def weaveBytes : List UInt8 → List UInt8 → List UInt8
  | [], ys => ys
  | x :: xs, ys => x :: weaveBytes ys xs
  termination_by xs ys => xs.length + ys.length

/-- Undo `weaveBytes`, given the two lengths. -/
def unweaveBytes : Nat → Nat → List UInt8 → List UInt8 × List UInt8
  | 0, _, l => ([], l)
  | _ + 1, _, [] => ([], [])
  | n + 1, m, x :: l => let (p, q) := unweaveBytes m n l; (x :: q, p)
  termination_by n m _ => n + m

theorem unweaveBytes_weaveBytes (xs ys : List UInt8) :
    unweaveBytes xs.length ys.length (weaveBytes xs ys) = (xs, ys) := by
  induction xs, ys using weaveBytes.induct with
  | case1 ys => simp [weaveBytes, unweaveBytes]
  | case2 x xs ys ih =>
    simp only [weaveBytes, List.length_cons, unweaveBytes, ih]

/-- Everything a page is: the checking runtime, and the market data it is
about. -/
structure Bundle where
  /-- The FHME runtime bytes — the engine that re-derives the view. -/
  runtime : List UInt8
  /-- The market card bytes. -/
  payload : List UInt8
  deriving DecidableEq, Repr, Inhabited

/-- A bundle fits the wire when both halves have a 64-bit length. -/
def Bundle.wf (b : Bundle) : Prop :=
  b.runtime.length < Meme.Share.bound ∧ b.payload.length < Meme.Share.bound

/-- The served byte string: two lengths, then the two halves alternating. -/
def weave (b : Bundle) : List UInt8 :=
  natToLE8 b.runtime.length ++ natToLE8 b.payload.length ++ weaveBytes b.runtime b.payload

/-- Take a served byte string apart. -/
def unweave (bs : List UInt8) : Option Bundle := do
  let (n, r1) ← Codec.readNat bs
  let (m, r2) ← Codec.readNat r1
  let (rt, pl) := unweaveBytes n m r2
  pure { runtime := rt, payload := pl }

/-- **The weave round trips**: an honest client recovers the runtime and the
data. -/
theorem unweave_weave {b : Bundle} (h : b.wf) : unweave (weave b) = some b := by
  simp only [unweave, weave, List.append_assoc]
  rw [Codec.readNat_append h.1]
  simp only [Option.bind_eq_bind, Option.bind_some]
  rw [Codec.readNat_append h.2]
  simp only [Option.bind_some, unweaveBytes_weaveBytes]
  cases b; rfl

/-- **The served bytes determine both halves.**  There is no way to read the
same bytes as a different runtime or a different market payload. -/
theorem weave_injective {b b' : Bundle} (h : b.wf) (h' : b'.wf) (hw : weave b = weave b') :
    b = b' := by
  have hb := unweave_weave h
  rw [hw, unweave_weave h'] at hb
  exact (Option.some.inj hb).symm

/-! ## Serving -/

/-- Domain separation for the site signature. -/
def siteTag : String := "SOLFUNMEME-MESH-SITE-v1"

/-- What the site key signs: this origin, serving these bytes. -/
def siteMessage (origin digest : String) : String := joinFields [siteTag, origin, digest]

/-- A served page: where it is served from, what bytes, and the site's
signature. -/
structure Served where
  /-- The origin the page claims to be served from. -/
  origin : String
  /-- The woven bytes. -/
  bytes : List UInt8
  /-- The site key's signature over `siteMessage origin (H bytes)`. -/
  sig : String
  deriving DecidableEq, Repr, Inhabited

/-- A signature verifier, as in `Mesh.Post`. -/
abbrev Verifier := String → String → String → Bool

/-- The check the runtime performs on itself before doing anything. -/
def accept (V : Verifier) (H : List UInt8 → String) (siteKey : String) (s : Served) : Bool :=
  V siteKey (siteMessage s.origin (H s.bytes)) s.sig

/-- **The execution gate.**  Unpack and run only what verified. -/
def run (V : Verifier) (H : List UInt8 → String) (siteKey : String) (s : Served) : Option Bundle :=
  if accept V H siteKey s then unweave s.bytes else none

theorem run_isSome_iff {V H k s} :
    (run V H k s).isSome = true ↔ accept V H k s = true ∧ (unweave s.bytes).isSome = true := by
  unfold run
  by_cases h : accept V H k s = true <;> simp [h]

/-- What runs is exactly what was signed. -/
theorem run_eq_some_iff {V H k s b} :
    run V H k s = some b ↔ accept V H k s = true ∧ unweave s.bytes = some b := by
  unfold run
  by_cases h : accept V H k s = true <;> simp [h]

/-- **Only the site key can serve the site.**  If the runtime ran, the holder
of the site key signed *these* bytes for *this* origin. -/
theorem run_sound {V : Verifier} {HasKey : String → String → Prop}
    (hV : ∀ k m s, V k m s = true → HasKey k m) {H k s b} (h : run V H k s = some b) :
    HasKey k (siteMessage s.origin (H s.bytes)) :=
  hV _ _ _ (run_eq_some_iff.mp h).1

/-- **Tampering is visible.**  Two different well-formed bundles never have the
same digest, so a thief who edits the market data, or the checker, or drops
either, cannot keep the signature. -/
theorem tamper_changes_digest {H : List UInt8 → String} (hH : Function.Injective H)
    {b b' : Bundle} (h : b.wf) (h' : b'.wf) (hne : b ≠ b') : H (weave b) ≠ H (weave b') :=
  fun heq => hne (weave_injective h h' (hH heq))

/-- Stripping the data out of the page is a case of tampering. -/
theorem strip_detected {H : List UInt8 → String} (hH : Function.Injective H) {b : Bundle}
    (h : b.wf) (hne : b.payload ≠ []) :
    H (weave b) ≠ H (weave { b with payload := [] }) := by
  refine tamper_changes_digest hH h ⟨h.1, by simp [Meme.Share.bound]⟩ ?_
  intro heq
  exact hne (by simpa using congrArg Bundle.payload heq)

/-- Replacing the runtime, keeping the data, is also a case of tampering — the
data cannot be lifted out and re-served under a different checker. -/
theorem runtime_swap_detected {H : List UInt8 → String} (hH : Function.Injective H)
    {b b' : Bundle} (h : b.wf) (h' : b'.wf) (hrt : b.runtime ≠ b'.runtime) :
    H (weave b) ≠ H (weave b') :=
  tamper_changes_digest hH h h' (fun heq => hrt (by rw [heq]))

/-- The signed site text determines the origin and the digest. -/
theorem siteMessage_inj {o d o' d' : String} (ho : SepFree o) (hd : SepFree d)
    (ho' : SepFree o') (hd' : SepFree d') (h : siteMessage o d = siteMessage o' d') :
    o = o' ∧ d = d' := by
  have htag : SepFree siteTag := by decide
  have hfields := joinFields_injective (l := [siteTag, o, d]) (m := [siteTag, o', d'])
    (by
      intro t ht
      simp only [List.mem_cons, List.not_mem_nil, or_false] at ht
      rcases ht with rfl | rfl | rfl
      exacts [htag, ho, hd])
    (by
      intro t ht
      simp only [List.mem_cons, List.not_mem_nil, or_false] at ht
      rcases ht with rfl | rfl | rfl
      exacts [htag, ho', hd'])
    (by simp) (by simp) h
  simp only [List.cons.injEq, and_true] at hfields
  exact ⟨hfields.2.1, hfields.2.2⟩

/-- **Re-hosting is refused.**  If the site key only ever signs its own origin,
then a served copy that verifies is served from that origin: a byte-for-byte
copy of the page on another domain does not check out. -/
theorem rehost_rejected {V : Verifier} {Signed : String → String → Prop}
    (hV : ∀ k m s, V k m s = true → Signed k m) {H : List UInt8 → String} {k origin : String}
    (hOnly : ∀ m, Signed k m → ∃ d, SepFree d ∧ m = siteMessage origin d)
    (horigin : SepFree origin) {s : Served} (hs : SepFree s.origin)
    (hdig : SepFree (H s.bytes)) (hacc : accept V H k s = true) : s.origin = origin := by
  obtain ⟨d, hd, heq⟩ := hOnly _ (hV _ _ _ hacc)
  exact (siteMessage_inj hs hdig horigin hd heq).1

end Mesh.Runtime
