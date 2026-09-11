/-
  Commit.lean — the commitments and sigma protocols behind a private claim.

  A player wants to publish "I minted 7 memes and my balance is still above
  zero" without publishing the balance.  The scheme `node/game/pedersen.mjs`
  implements, and this file models, is the standard one:

    * a **Pedersen commitment** `C = v·g + r·h` in a prime-order group (there,
      edwards25519; here, any module over `ZMod q` with `q` prime, which is
      what a prime-order group is);
    * a **Schnorr** proof of knowledge of a discrete logarithm;
    * a **Chaum–Pedersen** proof that two commitments hide the *same* value;
    * a **bit proof**, `v ∈ {0,1}`, from which a range proof — and hence
      "the balance is positive" — is assembled bit by bit.

  All of these are made non-interactive by hashing the transcript for the
  challenge (Fiat–Shamir).  The hash is not modelled here; what is modelled is
  the algebra underneath it, which is where the security argument actually
  lives: completeness (an honest prover always convinces) and *special
  soundness* (two accepting transcripts that share a commitment but differ in
  the challenge yield the witness, so a prover who could answer two challenges
  must have known it).

  **An honest caveat, repeated from the documentation.**  This is additively
  homomorphic commitment plus sigma protocols.  It is *not* fully homomorphic
  encryption: anyone can add commitments and check linear relations between
  them, and nothing else.  The project's "verifiable runtime others can check"
  is exactly that — sums of hidden balances and proofs about those sums — and
  the files never claim more.
-/

import Mathlib

namespace Solfunmeme.Game.Commit

variable {G : Type*} [AddCommGroup G] {q : ℕ} [Fact (Nat.Prime q)] [Module (ZMod q) G]

/-! ## Pedersen commitments -/

/-- `commit g h v r = v·g + r·h`: a commitment to `v` blinded by `r`. -/
def commit (g h : G) (v r : ZMod q) : G := v • g + r • h

/-- **The homomorphism.**  Committing to two balances and adding the
    commitments is the same as committing to the sum.  This is what lets a
    verifier total up hidden stakes without learning any of them. -/
theorem commit_add (g h : G) (v₁ r₁ v₂ r₂ : ZMod q) :
    commit g h v₁ r₁ + commit g h v₂ r₂ = commit g h (v₁ + v₂) (r₁ + r₂) := by
  simp only [commit, add_smul]
  abel

@[simp] theorem commit_zero (g h : G) : commit g h (0 : ZMod q) 0 = 0 := by
  simp [commit]

/-- Adding one to the committed value adds the base point: this is how a
    balance commitment is turned into a commitment to `balance - 1`, the number
    the range proof is about. -/
theorem commit_succ (g h : G) (v r : ZMod q) :
    commit g h (v + 1) r = commit g h v r + g := by
  simp only [commit, add_smul, one_smul]
  abel

/-- **Aggregation.**  A whole list of commitments adds up to a commitment to
    the sum of the values, blinded by the sum of the blinders — so a node can
    publish one number for a room full of players. -/
theorem commit_sum (g h : G) (l : List (ZMod q × ZMod q)) :
    (l.map fun p => commit g h p.1 p.2).sum
      = commit g h (l.map Prod.fst).sum (l.map Prod.snd).sum := by
  induction l with
  | nil => simp
  | cons p t ih => simp [ih, commit_add]

/-- **Binding.**  Two different openings of the same commitment reveal the
    discrete logarithm relating the two bases.  Since nobody knows that
    relation for a properly generated `h`, nobody can produce two openings:
    a committed balance cannot be reinterpreted later. -/
theorem commit_binding {g h : G} {v₁ r₁ v₂ r₂ : ZMod q}
    (heq : commit g h v₁ r₁ = commit g h v₂ r₂) (hv : v₁ ≠ v₂) :
    g = ((r₂ - r₁) / (v₁ - v₂)) • h := by
  have hd : v₁ - v₂ ≠ 0 := sub_ne_zero.mpr hv
  have h1 : (v₁ - v₂) • g = (r₂ - r₁) • h := by
    have := sub_eq_zero.mpr heq
    simp only [commit] at this
    have h2 : (v₁ - v₂) • g - (r₂ - r₁) • h = 0 := by
      simp only [sub_smul]
      rw [← this]; abel
    exact sub_eq_zero.mp h2
  calc g = (v₁ - v₂)⁻¹ • ((v₁ - v₂) • g) := by rw [inv_smul_smul₀ hd]
    _ = (v₁ - v₂)⁻¹ • ((r₂ - r₁) • h) := by rw [h1]
    _ = ((r₂ - r₁) / (v₁ - v₂)) • h := by
        rw [smul_smul, div_eq_mul_inv, mul_comm]

/-! ## Schnorr: knowledge of a discrete logarithm

    The prover knows `x` with `P = x·g` and convinces a verifier of it without
    revealing `x`. -/

/-- A Schnorr transcript: commitment, challenge, response. -/
structure Schnorr (G : Type*) (q : ℕ) where
  A : G
  c : ZMod q
  z : ZMod q

/-- The verifier's equation. -/
def Schnorr.ok (g P : G) (t : Schnorr G q) : Prop := t.z • g = t.A + t.c • P

/-- **Completeness.**  An honest prover, who really knows `x`, always passes —
    whatever challenge is thrown at them. -/
theorem schnorr_complete (g : G) (x k c : ZMod q) :
    Schnorr.ok g (x • g) (⟨k • g, c, k + c * x⟩ : Schnorr G q) := by
  simp only [Schnorr.ok, add_smul, mul_smul]

/-- **Special soundness.**  Two accepting transcripts with the same commitment
    and different challenges hand over the witness.  A prover who can answer
    two challenges therefore knows the discrete logarithm; a prover who does
    not know it can answer at most one, and Fiat–Shamir gives them only one. -/
theorem schnorr_extract (g P : G) {A : G} {c₁ c₂ z₁ z₂ : ZMod q} (hc : c₁ ≠ c₂)
    (h₁ : Schnorr.ok g P (⟨A, c₁, z₁⟩ : Schnorr G q))
    (h₂ : Schnorr.ok g P (⟨A, c₂, z₂⟩ : Schnorr G q)) :
    P = ((z₁ - z₂) / (c₁ - c₂)) • g := by
  have hd : c₁ - c₂ ≠ 0 := sub_ne_zero.mpr hc
  simp only [Schnorr.ok] at h₁ h₂
  have key : (z₁ - z₂) • g = (c₁ - c₂) • P := by
    simp only [sub_smul]
    rw [h₁, h₂]; abel
  calc P = (c₁ - c₂)⁻¹ • ((c₁ - c₂) • P) := by rw [inv_smul_smul₀ hd]
    _ = (c₁ - c₂)⁻¹ • ((z₁ - z₂) • g) := by rw [key]
    _ = ((z₁ - z₂) / (c₁ - c₂)) • g := by rw [smul_smul, div_eq_mul_inv, mul_comm]

/-! ## Chaum–Pedersen: the same value under two bases

    Used when a balance is re-committed — the player proves the new commitment
    hides the same number as the old one, without saying what it is. -/

structure ChaumPedersen (G : Type*) (q : ℕ) where
  A : G
  B : G
  c : ZMod q
  z : ZMod q

def ChaumPedersen.ok (g h P Q : G) (t : ChaumPedersen G q) : Prop :=
  t.z • g = t.A + t.c • P ∧ t.z • h = t.B + t.c • Q

theorem chaumPedersen_complete (g h : G) (x k c : ZMod q) :
    ChaumPedersen.ok g h (x • g) (x • h)
      (⟨k • g, k • h, c, k + c * x⟩ : ChaumPedersen G q) := by
  constructor <;> simp only [add_smul, mul_smul]

/-- **Special soundness for Chaum–Pedersen.**  The extracted witness works for
    *both* bases at once, which is precisely the claim "the same value". -/
theorem chaumPedersen_extract (g h P Q : G) {A B : G} {c₁ c₂ z₁ z₂ : ZMod q} (hc : c₁ ≠ c₂)
    (h₁ : ChaumPedersen.ok g h P Q (⟨A, B, c₁, z₁⟩ : ChaumPedersen G q))
    (h₂ : ChaumPedersen.ok g h P Q (⟨A, B, c₂, z₂⟩ : ChaumPedersen G q)) :
    ∃ x : ZMod q, P = x • g ∧ Q = x • h :=
  ⟨(z₁ - z₂) / (c₁ - c₂),
    schnorr_extract g P hc h₁.1 h₂.1,
    schnorr_extract h Q hc h₁.2 h₂.2⟩

/-! ## Bits, ranges, and "my balance is still above zero" -/

/-- **A bit is a root of `v(v-1)`.**  This is the relation the OR proof in
    `node/game/pedersen.mjs` establishes for each bit of the balance. -/
theorem bit_iff (v : ZMod q) : v * (v - 1) = 0 ↔ v = 0 ∨ v = 1 := by
  rw [mul_eq_zero, sub_eq_zero]

/-- A natural number reassembled from its bits. -/
def fromBits (b : ℕ → ℕ) (k : ℕ) : ℕ := ∑ i ∈ Finset.range k, 2 ^ i * b i

@[simp] theorem fromBits_zero (b : ℕ → ℕ) : fromBits b 0 = 0 := by simp [fromBits]

theorem fromBits_succ (b : ℕ → ℕ) (k : ℕ) :
    fromBits b (k + 1) = fromBits b k + 2 ^ k * b k := by
  simp [fromBits, Finset.sum_range_succ]

/-- **The range proof.**  If every committed digit is a bit, the number they
    encode is below `2^k` — so `k` bit proofs bound the value, which is what
    a range proof is. -/
theorem fromBits_lt (b : ℕ → ℕ) (hb : ∀ i, b i ≤ 1) (k : ℕ) : fromBits b k < 2 ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [fromBits_succ, pow_succ]
    have : 2 ^ k * b k ≤ 2 ^ k := by
      calc 2 ^ k * b k ≤ 2 ^ k * 1 := Nat.mul_le_mul_left _ (hb k)
        _ = 2 ^ k := by ring
    omega

/-- **The balance is still above zero.**  A player does not prove `balance > 0`
    directly — that is not a linear relation.  They commit to `balance - 1`,
    prove each of its `k` bits is a bit, and let the verifier add `g` back
    (`commit_succ`).  The arithmetic below is the whole content of that step:
    anything of the form `(bits) + 1` is positive, and bounded by `2^k`. -/
theorem balance_pos_of_bit_proofs {balance : ℕ} (b : ℕ → ℕ) (hb : ∀ i, b i ≤ 1) (k : ℕ)
    (hbal : balance = fromBits b k + 1) : 0 < balance ∧ balance ≤ 2 ^ k := by
  have := fromBits_lt b hb k
  omega

/-- The same statement at the level of the commitments a verifier actually
    sees: if `C` opens to `n + 1` then `C - g` opens to `n`, and it is `C - g`
    that the bit proofs are about. -/
theorem commit_pred (g h : G) (n r : ZMod q) :
    commit g h (n + 1) r - g = commit g h n r := by
  rw [commit_succ]; abel

/-- **Aggregate positivity.**  Summing the players' commitments and their bit
    bounds: if every one of `m` players proved a balance in `[1, 2^k]`, the
    total is between `m` and `m * 2^k`, and the verifier learns nothing else. -/
theorem total_bounds (bal : List ℕ) (k : ℕ)
    (h : ∀ x ∈ bal, 0 < x ∧ x ≤ 2 ^ k) :
    bal.length ≤ bal.sum ∧ bal.sum ≤ bal.length * 2 ^ k := by
  induction bal with
  | nil => simp
  | cons x t ih =>
    have hx := h x (by simp)
    have ht : ∀ y ∈ t, 0 < y ∧ y ≤ 2 ^ k := fun y hy => h y (by simp [hy])
    have := ih ht
    simp only [List.length_cons, List.sum_cons]
    constructor
    · omega
    · have : (t.length + 1) * 2 ^ k = t.length * 2 ^ k + 2 ^ k := by ring
      omega

end Solfunmeme.Game.Commit
