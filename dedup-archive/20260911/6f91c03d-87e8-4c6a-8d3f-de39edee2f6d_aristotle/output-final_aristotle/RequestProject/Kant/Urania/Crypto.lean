/-
# Urania §2.5 — the two primitives that did not exist yet

The Urania protocol is stated on top of two cryptographic primitives that
this project never had: an asymmetric **signature scheme** and a
**collision-resistant hash**.  Rather than adding axioms (the project has
none, and is meant to keep it that way), both are modelled as *bundled
hypotheses*: a `SigScheme` value carries its own no-forgery property and
a `HashFn` value carries its own injectivity, so every downstream theorem
that needs them takes one as an argument and therefore states its
assumption visibly in its own statement.

**These are symbolic idealisations, not cryptographic definitions.**
`HashFn.injective` is *perfect* collision freedom, which no finite-output
function has; `SigScheme.noForgery` says a verifying signature was really
produced by the key, which is stronger and cruder than EUF-CMA (no
adversary, no advantage, no queries).  They are the right modelling
choice for a first pass — they let the protocol arguments be checked
without a cryptographic library — but a theorem proved against them is
not the same statement as one proved against a real security bound.

Proved here:

* `digest_not_injective`, `witness_not_injective` — the digest actually
  shipped in `Kant.Bytes` (FNV-1a, four salted rounds, 32 bytes) is
  **provably not** collision free: it maps the infinite set of byte
  strings into a fixed 32-byte width.  This is §2.5's "make the warning a
  checked fact";
* `no_hashFn_is_digest`, `no_hashFn_is_witness` — the payoff: nobody can
  ever instantiate the abstract hash interface with the digest the
  codebase currently computes, because the instance would have to prove a
  property whose negation is right here.
-/
import Mathlib
import RequestProject.Kant.Bytes

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

/-! ## The abstract interfaces -/

/-- A **symbolically idealised collision-resistant hash**: a function
together with a proof that it has no collisions at all.

No function with a fixed-width output can satisfy this (see
`digest_not_injective` below for the concrete instance of that fact), so
a `HashFn` is a *hypothesis* to be carried, not something to be
constructed for a real hash.  Theorems that take one as an argument are
statements of the form "if the hash behaves ideally, then …". -/
structure HashFn (α : Type) (Hash : Type) where
  /-- The hash function itself. -/
  hash : α → Hash
  /-- The idealisation: distinct inputs never collide. -/
  injective : Function.Injective hash

/-- A **symbolically idealised signature scheme**.  `signedBy pk m s`
means "the holder of the private key of `pk` really produced `s` on `m`";
`noForgery` says verification only ever succeeds on such pairs.

This is a symbolic (Dolev–Yao style) idealisation: there is no adversary,
no chosen-message query and no advantage bound, so it is *not* EUF-CMA.
It is exactly enough to reason about who is accountable for a message
that verifies. -/
structure SigScheme (PubKey Msg Sig : Type) where
  /-- The verification algorithm run by every party. -/
  verify : PubKey → Msg → Sig → Bool
  /-- The (unobservable) fact that the key holder produced this signature. -/
  signedBy : PubKey → Msg → Sig → Prop
  /-- The idealisation: what verifies was signed. -/
  noForgery : ∀ pk m s, verify pk m s = true → signedBy pk m s

namespace SigScheme

variable {PubKey Msg Sig : Type} (S : SigScheme PubKey Msg Sig)

/-- A verifying message is attributable to its key: the only content of
the idealisation, restated in the form the protocol uses. -/
theorem attributable {pk : PubKey} {m : Msg} {s : Sig}
    (h : S.verify pk m s = true) : S.signedBy pk m s :=
  S.noForgery pk m s h

end SigScheme

/-! ## The digest actually shipped is not one of these

`Kant.Bytes.digest` is 32 bytes wide for every input (`digest_length`),
and there are infinitely many inputs.  So it collides.  The proof is the
pigeonhole principle, applied through the finite type `Fin 32 → UInt8`. -/

/-- `UInt8` is a finite type.  (Mathlib does not ship this instance.) -/
instance uint8Finite : Finite UInt8 :=
  Finite.of_injective (fun b => (⟨b.toNat, b.toNat_lt_size⟩ : Fin 256))
    (by intro a b h; simp only [Fin.mk.injEq] at h; exact UInt8.toNat_inj.mp h)

/-- `Char` is a finite type.  (Mathlib does not ship this instance.) -/
instance charFinite : Finite Char :=
  Finite.of_injective (fun c => (⟨c.val.toNat, c.val.toNat_lt_size⟩ : Fin (2 ^ 32)))
    (by
      intro a b h
      simp only [Fin.mk.injEq] at h
      exact Char.ext (UInt32.toNat_inj.mp h))

/-- **Pigeonhole:** no fixed-width function on byte strings is injective. -/
theorem fixedWidth_not_injective {n : Nat} (f : List UInt8 → List UInt8)
    (hlen : ∀ bs, (f bs).length = n) : ¬ Function.Injective f := by
  intro hinj
  have hinj' : Function.Injective (fun bs => (fun i : Fin n => (f bs).getD i 0)) := by
    intro a b hab
    apply hinj
    apply List.ext_getElem (by rw [hlen, hlen])
    intro m h1 h2
    have := congrFun hab ⟨m, by rw [hlen] at h1; exact h1⟩
    simpa [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem, h1, h2] using this
  haveI := Finite.of_injective _ hinj'
  exact not_finite (List UInt8)

/-- The same for a fixed-width string of characters. -/
theorem fixedWidth_chars_not_injective {n : Nat} (f : List UInt8 → List Char)
    (hlen : ∀ bs, (f bs).length = n) : ¬ Function.Injective f := by
  intro hinj
  have hinj' : Function.Injective (fun bs => (fun i : Fin n => (f bs).getD i 'a')) := by
    intro a b hab
    apply hinj
    apply List.ext_getElem (by rw [hlen, hlen])
    intro m h1 h2
    have := congrFun hab ⟨m, by rw [hlen] at h1; exact h1⟩
    simpa [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem, h1, h2] using this
  haveI := Finite.of_injective _ hinj'
  exact not_finite (List UInt8)

/-- **The digest this project computes is provably not collision free.**
It is FNV-1a — a checksum — rendered 32 bytes wide, and 32 bytes cannot
separate infinitely many inputs. -/
theorem digest_not_injective : ¬ Function.Injective Kant.Bytes.digest :=
  fixedWidth_not_injective Kant.Bytes.digest Kant.Bytes.digest_length

/-- And neither is the 64-character witness string built from it — the
string that *looks like* a SHA-256 digest wherever it is displayed. -/
theorem witness_not_injective : ¬ Function.Injective Kant.Bytes.witness :=
  fixedWidth_chars_not_injective Kant.Bytes.witness Kant.Bytes.witness_length

/-- **The payoff.** The abstract hash interface can never be instantiated
with the digest the codebase computes today: doing so would require
proving injectivity, and its negation is a theorem of this same
repository.  Any module that needs a `HashFn` therefore needs a real
hash, not this one. -/
theorem no_hashFn_is_digest (H : HashFn (List UInt8) (List UInt8)) :
    H.hash ≠ Kant.Bytes.digest := by
  intro h
  exact digest_not_injective (h ▸ H.injective)

/-- The same, for the hex witness. -/
theorem no_hashFn_is_witness (H : HashFn (List UInt8) (List Char)) :
    H.hash ≠ Kant.Bytes.witness := by
  intro h
  exact witness_not_injective (h ▸ H.injective)

end Kant.Urania
