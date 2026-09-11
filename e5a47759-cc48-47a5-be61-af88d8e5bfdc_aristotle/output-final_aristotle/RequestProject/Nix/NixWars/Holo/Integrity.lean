import RequestProject.Nix.NixWars.Holo.Archive
import RequestProject.Nix.NixWars.Sha256

/-!
# Integrity: a checksum per cell, and what a tampered range does to it

The retrieval model says which bytes to ask a dumb host for.  It says nothing
about whether the host told the truth.  A block sketch of the archive lists an
integrity hash per cell; this file adds one and proves the two halves of what a
manifest is for.

* `checksum`, `manifest` — a modular checksum of each cell's wire form, and the
  table of them, alongside `digest`, the SHA-256 of the cell computed by the
  project's own implementation.
* `verify_fetch`, `digest_fetch` — **an honest fetch verifies**: the checksum
  (and the digest) recomputed from the bytes of the range for cell `i` is the
  manifest entry for cell `i`, so a client that checks what it got accepts it.
* `checksum_ne_of_single_byte_change` — **a tampered range does not**: altering
  a single byte of a fetched range always changes the checksum, so the client
  rejects it.  `verify_rejects_tamper` states that against a live fetch.

The checksum is a sum modulo 65521, so what is proved is exactly what such a
checksum gives: every single-byte alteration is caught.  Collision resistance
against an adversary who may change many bytes is the job of the SHA-256
digest, and is not a theorem — it is a cryptographic assumption.
-/

namespace NixWars
namespace Holo
namespace Integrity

open Archive

/-- The modulus: the largest prime below `2^16`, as in Adler-32. -/
def modulus : Nat := 65521

/-- The checksum of a byte range. -/
def checksum (bs : List Nat) : Nat := bs.sum % modulus

/-- The SHA-256 digest of a byte range, by the project's own implementation. -/
def digest (bs : List Nat) : Array UInt8 :=
  Sha256.hashBytes (bs.map (fun n => (UInt8.ofNat n))).toArray

/-- The manifest: one checksum per cell, in the order of the file, beside the
offset table. -/
def manifest (A : Archive) : List Nat := A.map (fun c => checksum c.encode)

/-- The digest manifest: one SHA-256 per cell. -/
def digestManifest (A : Archive) : List (Array UInt8) := A.map (fun c => digest c.encode)

@[simp] theorem length_manifest (A : Archive) : (manifest A).length = A.length := by
  simp [manifest]

/-- **An honest fetch verifies.**  The checksum recomputed from the bytes the
host returned for cell `i` is the manifest entry for cell `i`. -/
theorem verify_fetch (A : Archive) (i : Nat) (h : i < A.length) :
    checksum ((A.bytes.drop (A.offset i)).take (A[i]'h).size) =
      (manifest A)[i]'(by simpa using h) := by
  rw [range_fetch A i h]
  simp [manifest]

/-- The same for the digest: the SHA-256 of the fetched range is the digest the
manifest records for that cell. -/
theorem digest_fetch (A : Archive) (i : Nat) (h : i < A.length) :
    digest ((A.bytes.drop (A.offset i)).take (A[i]'h).size) =
      (digestManifest A)[i]'(by simpa [digestManifest] using h) := by
  rw [range_fetch A i h]
  simp [digestManifest]

/-! ## A tampered range -/

private theorem sum_set (l : List Nat) (b : Nat) :
    ∀ (i : Nat) (h : i < l.length), (l.set i b).sum + l[i] = l.sum + b := by
  induction l with
  | nil => intro i h; simp at h
  | cons x xs ih =>
    intro i h
    cases i with
    | zero => simp; omega
    | succ j =>
      have hj : j < xs.length := by simpa using h
      simp only [List.set_cons_succ, List.sum_cons, List.getElem_cons_succ]
      have := ih j hj
      omega

/-- **Changing one byte always changes the checksum.**  A host that alters a
single byte of the range it serves is caught. -/
theorem checksum_ne_of_single_byte_change {bs : List Nat} {i b : Nat} (h : i < bs.length)
    (hb : b < modulus) (hold : bs[i] < modulus) (hne : b ≠ bs[i]) :
    checksum (bs.set i b) ≠ checksum bs := by
  intro heq
  have hsum := sum_set bs b i h
  have hmod : (bs.set i b).sum % modulus = bs.sum % modulus := heq
  have h1 : ((bs.set i b).sum + bs[i]) % modulus = (bs.sum + bs[i]) % modulus :=
    Nat.ModEq.add_right _ hmod
  have h2 : (bs.sum + b) % modulus = (bs.sum + bs[i]) % modulus := by
    rw [← hsum]; exact h1
  have h3 : b % modulus = bs[i] % modulus := Nat.ModEq.add_left_cancel' bs.sum h2
  rw [Nat.mod_eq_of_lt hb, Nat.mod_eq_of_lt hold] at h3
  exact hne h3

/-- **A tampered range is rejected.**  If the host flips one byte of the range
it serves for cell `i`, the checksum the client computes does not match the
manifest. -/
theorem verify_rejects_tamper (A : Archive) (i : Nat) (h : i < A.length)
    (hbytes : ∀ x ∈ (A[i]'h).encode, x < modulus)
    (j b : Nat) (hj : j < (A[i]'h).size) (hb : b < modulus)
    (hne : b ≠ ((A.bytes.drop (A.offset i)).take (A[i]'h).size)[j]'(by
      rw [range_fetch A i h]; simpa [Cell.size] using hj)) :
    checksum ((((A.bytes.drop (A.offset i)).take (A[i]'h).size)).set j b) ≠
      (manifest A)[i]'(by simpa using h) := by
  rw [← verify_fetch A i h]
  refine checksum_ne_of_single_byte_change ?_ hb ?_ hne
  · rw [range_fetch A i h]; simpa [Cell.size] using hj
  · have hsub : ((A.bytes.drop (A.offset i)).take (A[i]'h).size) ⊆ (A[i]'h).encode := by
      rw [range_fetch A i h]
      exact fun x hx => hx
    exact hbytes _ (hsub (List.getElem_mem _))

end Integrity
end Holo
end NixWars
