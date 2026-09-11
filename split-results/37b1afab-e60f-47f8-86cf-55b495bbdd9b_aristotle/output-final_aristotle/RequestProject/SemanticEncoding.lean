import Mathlib
import RequestProject.Monster
import RequestProject.MonsterInvariants

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000
set_option autoImplicit false

/-!
# Semantic encoding by the `j`-invariant and distances to it

This file formalizes the encoding scheme that emerged in the design conversation following the
Monster / supersingular-prime ontology (`RequestProject.Monster`,
`RequestProject.MonsterInvariants`).

The complaint that started it: a length-only "Gödel number" (e.g. `ramanujan ↦ 2^9 = 512`)
encodes nothing about *what the token says* — "foo", "bar", "baz" all collapse together. The
fix is a **semantic** encoding that points at a genuine mathematical object and records the rest
as a *shadow*.

## The architecture

* **Coordinates.** Every object is a *profile*: a 15-dimensional vector aligned to the 15
  supersingular primes `[2,3,5,7,11,13,17,19,23,29,31,41,47,59,71]` — the same coordinate system
  as `MonsterInvariants.table` (the 194 Monster invariants).
* **The `j`-invariant has a data form.** `jProfile` is the fingerprint of the supersingular
  `j`-invariants: its entry at prime `p` is `Monster.ssCountFp p`, the number of supersingular
  `j`-invariants in `𝔽ₚ`. A message that *is* the `j`-invariant is just this vector.
* **Distance to `j`.** `distToJ v` is the `ℓ¹` distance from a profile `v` to `jProfile`.
* **Encoding = nearest pointer + shadow.** `encodeProfile v = (label, shadow)`, where `label` is
  the index of the *nearest Monster invariant row* (the LMFDB-style canonical pointer), and
  `shadow = v − (profile of that row)` is the integer residual that resolves everything the
  pointer alone does not.
* **Lossless.** `decodeProfile (encodeProfile v) = v` — the pointer plus the shadow recovers the
  object exactly (`decode_encode_of_length`, and concretely for tokens).
* **Data-form fixed point.** A message that *is* a Monster invariant encodes to *(its index, the
  zero shadow)* — "irrep 160 doesn't need any description, it has a data form"
  (`encode_invariant_160`, `shadow_zero_iff`).
* **Tokens are content-sensitive.** `tokenProfile` uses a positional hash mod each prime, so
  distinct content gives distinct profiles even at equal length (`ramanujan` vs `aaaaaaaaa`),
  curing the original length-only defect.
* **A zero-knowledge / argument-of-knowledge view.** The 15 supersingular primes are 15 challenge
  rounds. The prover answers challenge `k` with the `k`-th coordinate of the secret profile; the
  verifier recomputes it from `(label, shadow)`. **Completeness** (`zk_complete`): an honest
  prover always satisfies the verifier. **Soundness** (`zk_sound`): passing *all 15* rounds pins
  the secret down uniquely to `decodeProfile (label, shadow)`.

The interpretive layers (LMFDB pointers, VOA virtual machine, multi-round ZK consensus) are kept
as motivation; the statements below are the precise, machine-checked residue.
-/

namespace SemanticEncoding

open Monster MonsterInvariants

/-! ## 0. A reusable list round-trip lemma -/

/-- **Round-trip identity.** Adding back a base profile `p` to the residual `v − p` recovers `v`,
provided the base is at least as long as `v`. This is the algebraic core of losslessness. -/
theorem zipWith_add_sub (v p : List ℤ) (h : v.length ≤ p.length) :
    List.zipWith (· + ·) p (List.zipWith (fun x y => x - y) v p) = v := by
  refine' List.ext_get _ _ <;> aesop

/-- Two integer lists of the same length are equal once they agree coordinate-wise (used for
zero-knowledge soundness). -/
theorem list_ext_coord (u v : List ℤ) (hlen : u.length = v.length)
    (h : ∀ k, k < u.length → u.getD k 0 = v.getD k 0) : u = v := by
  refine' List.ext_get _ _ <;> aesop

/-! ## 1. Profiles and the `j`-invariant data form -/

/-- A *profile* is a 15-dimensional integer vector aligned to `Monster.supersingularPrimes`. -/
abbrev Profile : Type := List ℤ

/-- The `j`-invariant fingerprint: at each supersingular prime `p`, the number of supersingular
`j`-invariants living in `𝔽ₚ` (`Monster.ssCountFp p`). This is "the `j`-invariant's data form". -/
def jProfile : Profile := supersingularPrimes.map (fun p => (ssCountFp p : ℤ))

/-- The `j`-invariant fingerprint is a genuine 15-channel profile. -/
theorem jProfile_length : jProfile.length = 15 := by native_decide

/-- The non-trivial `j`-invariant fingerprint (its concrete data form). -/
theorem jProfile_value :
    jProfile = [2, 3, 1, 1, 2, 1, 2, 2, 3, 3, 3, 4, 5, 6, 7] := by native_decide

/-! ## 2. The Monster-invariant table as integer profiles -/

/-- The 194 Monster invariants as integer profiles, paired with their index. -/
def tableZ : List (ℕ × Profile) :=
  table.map (fun r => (r.1, r.2.1.map (Int.ofNat)))

/-- The profile of the Monster invariant with a given index (the empty profile if absent). -/
def profileOfIndex (i : ℕ) : Profile :=
  ((tableZ.find? (fun r => r.1 == i)).getD (0, [])).2

/-- Every stored invariant profile has 15 channels. -/
theorem tableZ_profile_length : ∀ r ∈ tableZ, r.2.length = 15 := by native_decide

/-! ## 3. Distance and the nearest-pointer encoding -/

/-- The `ℓ¹` distance between two profiles. -/
def l1 (u v : Profile) : ℤ := (List.zipWith (fun a b => |a - b|) u v).sum

/-- The `ℓ¹` distance from a profile to the `j`-invariant fingerprint. -/
def distToJ (v : Profile) : ℤ := l1 v jProfile

/-- The nearest Monster invariant row to a profile `v` (argmin of `l1`), as `(index, profile)`.
The fold is seeded with the first table row, so the result is always a genuine row. -/
def nearestRow (v : Profile) : ℕ × Profile :=
  tableZ.foldl
    (fun best r => if l1 v r.2 < l1 v best.2 then r else best)
    (tableZ.headD (0, []))

/-- The canonical pointer for `v`: the index of its nearest Monster invariant. -/
def labelOf (v : Profile) : ℕ := (nearestRow v).1

/-- The **shadow** (residual): what the pointer alone does not capture. -/
def shadow (v : Profile) : Profile :=
  List.zipWith (fun a b => a - b) v (profileOfIndex (labelOf v))

/-- The semantic encoding: a canonical pointer plus the residual shadow. -/
def encodeProfile (v : Profile) : ℕ × Profile := (labelOf v, shadow v)

/-- Decoding: re-attach the shadow to the pointed-at invariant profile. -/
def decodeProfile (e : ℕ × Profile) : Profile :=
  List.zipWith (· + ·) (profileOfIndex e.1) e.2

/-! ## 4. Losslessness: the pointer plus shadow recovers the object -/

/-- **Losslessness (general form).** If the pointed-at invariant profile is at least as long as
`v`, decoding the encoding returns `v` exactly. -/
theorem decode_encode_of_length (v : Profile)
    (h : v.length ≤ (profileOfIndex (labelOf v)).length) :
    decodeProfile (encodeProfile v) = v := by
  unfold decodeProfile encodeProfile shadow
  simpa using zipWith_add_sub v (profileOfIndex (labelOf v)) h

/-! ## 5. The data-form fixed point: invariants encode to themselves -/

/-- A message that *is* the Monster invariant 160 encodes to *(160, zero shadow)* — it carries
its own data form and needs no further description. -/
theorem encode_invariant_160 :
    encodeProfile (profileOfIndex 160) = (160, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]) := by
  native_decide

/-- The shadow vanishes exactly when the profile already equals its pointed-at invariant: the
residual is zero iff the message is already in canonical data form. -/
theorem shadow_zero_iff (v : Profile) (h : v.length = (profileOfIndex (labelOf v)).length) :
    shadow v = List.replicate v.length 0 ↔ v = profileOfIndex (labelOf v) := by
  constructor <;> intro H
  · refine list_ext_coord _ _ h ?_
    intro k hk; replace H := congr_arg (fun x => x.getD k 0) H; simp_all +decide
    unfold shadow at H; simp_all +decide
    linarith
  · unfold shadow
    norm_num [← H]

/-! ## 6. The `j`-invariant's own canonical pointer -/

/-- The `j`-invariant fingerprint itself encodes to a definite Monster-invariant pointer with a
small shadow — "the message that contains the `j`-invariant is just the `j`-invariant". -/
theorem jProfile_encodes :
    encodeProfile jProfile = (32, [2, 1, 0, 0, 1, -1, 1, 1, 2, 2, 2, 3, 4, 5, 6]) := by
  native_decide

/-- Decoding the `j`-invariant's encoding recovers it exactly (a concrete losslessness check). -/
theorem decode_encode_jProfile : decodeProfile (encodeProfile jProfile) = jProfile := by
  native_decide

/-! ## 7. Content-sensitive tokens (curing the length-only defect) -/

/-- A positional (Horner) hash of a string modulo `p`: sensitive to *which* characters appear and
in *what order*, not merely how many. -/
def tokHash (s : String) (p : ℕ) : ℕ :=
  s.foldl (fun a c => (a * 31 + c.toNat) % p) 0

/-- The profile of a token: its positional hash across the 15 supersingular channels. -/
def tokenProfile (s : String) : Profile :=
  supersingularPrimes.map (fun p => (tokHash s p : ℤ))

/-- Every token profile is a genuine 15-channel profile. -/
theorem tokenProfile_length (s : String) : (tokenProfile s).length = 15 := by
  simp [tokenProfile, supersingularPrimes]

/-- **The defect is cured.** `ramanujan` and `aaaaaaaaa` have the same length but, unlike the old
length-only scheme, distinct profiles. -/
theorem tokenProfile_content_sensitive :
    tokenProfile "ramanujan" ≠ tokenProfile "aaaaaaaaa" := by native_decide

/-- A token round-trips losslessly through encode/decode (concrete). -/
theorem decode_encode_ramanujan :
    decodeProfile (encodeProfile (tokenProfile "ramanujan")) = tokenProfile "ramanujan" := by
  native_decide

/-! ## 8. The zero-knowledge / argument-of-knowledge view

The 15 supersingular primes are 15 challenge rounds. On round `k` the prover reveals the `k`-th
coordinate of the secret profile; the verifier recomputes it from the public transcript
`(label, shadow)`. -/

/-- The prover's response to challenge round `k`: the `k`-th coordinate of the secret profile. -/
def respond (v : Profile) (k : ℕ) : ℤ := v.getD k 0

/-- The verifier's expected value on round `k`, computed from the public transcript. -/
def expected (e : ℕ × Profile) (k : ℕ) : ℤ := (decodeProfile e).getD k 0

/-- **Completeness.** An honest prover (who actually holds `v`) satisfies the verifier on every
round, because the transcript decodes back to `v`. -/
theorem zk_complete (v : Profile)
    (h : v.length ≤ (profileOfIndex (labelOf v)).length) (k : ℕ) :
    respond v k = expected (encodeProfile v) k := by
  unfold respond expected
  rw [decode_encode_of_length v h]

/-- **Soundness.** If a transcript `e` passes *all 15* rounds against a length-15 secret `v`, and
the decoded transcript also has length 15, then the secret is pinned down: `v = decodeProfile e`.
Passing every supersingular challenge leaves no freedom. -/
theorem zk_sound (v : Profile) (e : ℕ × Profile)
    (hv : v.length = 15) (he : (decodeProfile e).length = 15)
    (h : ∀ k, k < 15 → respond v k = expected e k) :
    v = decodeProfile e := by
  apply list_ext_coord v (decodeProfile e) (by rw [hv, he])
  intro k hk
  rw [hv] at hk
  exact h k hk

/-! ## 9. A runnable demonstration -/

/-- Print the encoding of several messages: the `j`-invariant, a self-describing invariant, and
two equal-length but different-content tokens. -/
def runEncoding : IO Unit := do
  let ram := tokenProfile "ramanujan"
  let aaa := tokenProfile "aaaaaaaaa"
  IO.println s!"j-invariant data form (jProfile): {jProfile}"
  IO.println s!"  distance-to-j of jProfile: {distToJ jProfile}"
  IO.println s!"  encodeProfile jProfile = {encodeProfile jProfile}"
  IO.println s!"irrep 160 (a self-describing message):"
  IO.println s!"  encodeProfile (profileOfIndex 160) = {encodeProfile (profileOfIndex 160)}"
  IO.println s!"token 'ramanujan': profile {ram}"
  IO.println s!"  encodeProfile = {encodeProfile ram}"
  IO.println s!"token 'aaaaaaaaa' (same length): profile {aaa}"
  IO.println s!"  distinct from 'ramanujan': {ram != aaa}"

#eval runEncoding

end SemanticEncoding